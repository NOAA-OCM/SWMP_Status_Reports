# QAQC Excel spreadsheets and copy to new location when passed
# 
# Packages ----
suppressPackageStartupMessages({
  library(dplyr)
  library(janitor)
  library(openxlsx)
  library(sf)
  library(stringr)
  library(tidyr)
})

# Paths ----
# 
# N.B.: These paths are hard coded, since there is no expectation 
# that annual updates will reside within this package during the 
# QA/QC process.
# In fact, I recommend against it.  Instead copy them into the 
# ../../00_Annual_Update/Updated_reserve_var_sheets directory 
# when they have passed QA/QC.  That should be a cleaner process.
# 
reserve_updates_path <- "C:/SWMP/2019_raw_spreadsheets"
# reserve_updates_path <- "D:/SWMP/2020_QAQC_reserve_var_sheetsV2"
good_reserve_updates_path <- "D:/SWMP/2020_QAQC_reserve_var_sheetsV3"

# Path for shapefiles after they have gone through 
# the qaqc_gis.R process
gis_final_base <- "../00_Annual_Update/Reserve_level_template/inst/gis"

# Location for data files.  Beginning year will be taken from available data.
#
data_dir <- "d:/SWMP/data2020"

# Functions ----
#
check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

# Fix aspect ratio ----
#  aspect is width/height
fix_aspect <- function(bb, aspect) {
  newbb <- bb
  xdist <- abs(bb[3] - bb[1])
  ydist <- abs(bb[4] - bb[2])
  # Difference in desired aspect ratio in projected units
  dist_diff <- (aspect * xdist) - ydist 
  if(dist_diff < 0) { # Too wide, increase ydist
    # y_cent <- (bb[4] - bb[2])/2
    adj <- ((xdist/aspect) - ydist)/2
    newbb[2] <- bb[2] - adj
    newbb[4] <- bb[4] + adj
  } else {                       # Too narrow, increase x
    adj <- ((ydist*aspect) - xdist)/2
    newbb[1] <- bb[1] - adj
    newbb[3] <- bb[3] + adj
  }
  # new_aspect <- abs(newbb[3] - newbb[1])/abs(newbb[4] - newbb[2])
  return(newbb)
}

# Create polygon from bounding box. ----
bb_to_poly <- function(bb){
  pol = st_sfc(st_polygon(
    list(cbind(c(bb[1],bb[3],bb[3],bb[1],bb[1]),
               c(bb[2],bb[2],bb[4],bb[4],bb[2])))))
  pol_sf = st_sf(r = 5, pol)
  return(pol_sf)
}

# Calculate new bounding box, buffering gis file by percent % per side
#  and then enlarged in one dimension to desired to aspect ratio ----
# 
buff_bb <- function(gis_shape, percent, aspect = 1.0){
  gis_5072 <- st_transform(gis_shape, crs = 5072) 
  bb_5072 <- st_bbox(gis_5072)
  buff_dist <- (max(abs(bb_5072[3] - bb_5072[1]),   # Horizontal distance
                    abs(bb_5072[4] - bb_5072[2])) * # Vertical distance
                  percent)                          # * percentage%
  buff_5072 <- st_buffer(gis_5072, buff_dist)
  bbfixed_5072 <- fix_aspect(st_bbox(buff_5072), aspect)
  # Make bounding box into a polygon, and project that back into 
  #  desired projection.
  fixed_poly <- bb_to_poly(bbfixed_5072)
  st_crs(fixed_poly) <-  5072
  bb_buff_4092 <- st_bbox(st_transform(fixed_poly, crs = 4269))
  return(bb_buff_4092)
}
# 
# Make bbox check ----
# 
bb_check <- function(xlbbx, gis_shape, percent, aspect = 1) { 
  this_bbox <- c(min(xlbbx[1], xlbbx[3]), min(xlbbx[2], xlbbx[4]),
                 max(xlbbx[1], xlbbx[3]), max(xlbbx[2], xlbbx[4]))
  
  res_4269 <- st_transform(gis_shape, 4269) # Reproject to lat/lon NAD83
  gisbbx <- st_bbox(res_4269)
  
  if(! (this_bbox[1] <= gisbbx[1] &  # specified LL-long is correct
        this_bbox[2] <= gisbbx[2] &  # specified LL-lat is correct
        this_bbox[3] >= gisbbx[3] &  # specified LL-long is correct
        this_bbox[4] >= gisbbx[4])   # specified LL-lat is correct
  ) { 
    bb_buff_4092 <- buff_bb(gis_shape, percent, aspect)
    msg <- paste0("   ! -- Bounding_Box ERROR: Specified coordinates of\n",
                  "       ", round(this_bbox[1], 4), ", ", 
                  round(this_bbox[2], 4), " for lower left, and \n", 
                  "       ", round(this_bbox[3], 4), ", ", 
                  round(this_bbox[4], 4), " for upper right.,\n",
                  "     Do not work for gis geographic limits: \n",
                  "       ", round(gisbbx[1], 4), ", ", 
                  round(gisbbx[2], 4), " for lower left, and \n", 
                  "       ", round(gisbbx[3], 4), ", ", 
                  round(gisbbx[4], 4), " for upper right.,\n",
                  "  * --- For a relative ", round(100*percent),
                  "% buffer around shapefile, try: \n",
                  "       ", round(bb_buff_4092[1], 4), ", ", 
                  round(bb_buff_4092[2], 4), " for lower left, and \n", 
                  "       ", round(bb_buff_4092[3], 4), ", ", 
                  round(bb_buff_4092[4], 4), " for upper right." )
    # print(msg)
  } else {
    msg <- paste0("   Bounding box is appropriate." )
  }
  return(msg)
}

# Constant declarations ----
rbb_percent <- 0.30
sbb_percent <- 0.15
force_bb_replacement <- TRUE
bb_aspect <- 1.0

site_files <- (list.files(path = reserve_updates_path, pattern = "xlsx"))

test_year <- 2020
report_file <- paste0("check_results/reserve_var_checks_", test_year,".txt")

sheets <- c('Flags', 'Years_of_Interest', 'Seasons', 'Mapping',
            'Bonus_Settings', 'Basic_Plotting', 'Threshold_Plots',
            'Threshold_Identification')

min_rows <- c(5, 2, 13, 5, 11, 21, 21, 21)
min_cols <- c(1, 2,  7, 6,  2,  6, 14,  5)
flags <- c("0","3", "5", "<-4> \\[SBL\\]", "1")
windTF <- c("Convert winds from m/s to mph?", "T")
Free_Y <- c("T","T","F", "T","T","F", "T","T","T", "T","T","F", "F",
            "T","T","T","T","T","T","T","T")   
# Begin testing ----
# 

msg <- paste0("Begin check at ", Sys.time())
write.table(msg, report_file, col.names = FALSE,
            row.names = FALSE, quote = FALSE, append = FALSE)

# Workbook loop ----
for(wb_name in site_files) {
  print(wb_name)
  xl_path <- paste0(reserve_updates_path, "/", wb_name)
  # qaqced_xl_path <- paste0(good_reserve_updates_path, "/", wb_name)
  wb <- loadWorkbook(xl_path)
  
  msg <- paste0("\nProcessing: ",wb_name)
  write.table(msg, report_file, col.names = FALSE,
              row.names = FALSE, quote = FALSE, append = TRUE)
  
  good_sheets <- TRUE
  
  for(i in 1:length(sheets)) {
    sheet <- sheets[i]
    # wks2 <- read_xlsx(path = xl_path, sheet = sheet) 
    wks <- (read.xlsx(xl_path, sheet) )
    wks <- remove_empty(wks, which = "rows")
    if(nrow(wks) < min_rows[i]) {
      if(i == 1) {
        # Needs 1 flag ----
        wks <- rbind(wks, "1")
        writeData(wb, sheet = "Flags", wks, rowNames = FALSE)
        msg <- paste0("  -- Missing rows on sheet *", sheet,
                      "*, has ", nrow(wks)-1, " needs ", min_rows[i], 
                      "\n      * 1 flag added")
      } else {
        if(i == 5) {
          # wIND t/f ROW NEEDED ----
          wks <- rbind(wks, windTF)
          writeData(wb, sheet = "Bonus_Settings", wks, rowNames = FALSE)
          msg <- paste0("  -- Missing rows on sheet *", sheet,
                        "*, has ", nrow(wks)-1, " needs ", min_rows[i], 
                        "\n      * Wind T/F row added")
        } else {
          good_sheets <- FALSE
          msg <- paste0("! -- Missing rows on sheet *", sheet,
                        "*, has ", nrow(wks), " needs ", min_rows[i])
        }
      }
      # print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
    if(ncol(wks) < min_cols[i]) {
      if(i == 6) {
        # Free_Y needed ----
        wks <- cbind(wks, Free_Y)
        writeData(wb, sheet = sheet, wks, rowNames = FALSE)
        msg <- paste0("  -- Missing columns on sheet *", sheet,
                      "*, has ", ncol(wks)-1, " needs ", min_cols[i],
                      "\n      * Free_Y column added")
        
      } else {
        good_sheets <- FALSE
        msg <- paste0("! -- Missing columns on sheet *", sheet,
                      "*, has ", ncol(wks), " needs ", min_cols[i])
      }
      # print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
    
    # Find years ----
    if(i == 2) {
      res_abb <- tolower(substr(wb_name, 34, 36))
      years_avail <- list.files(data_dir, pattern = res_abb) %>% 
        str_sub(-8, -5) %>% 
        range(na.rm = TRUE)
      wks[ ,1] <- c(max(2000, years_avail[1]), test_year)
      wks[1, 2] <- test_year
      writeData(wb, sheet = "Years_of_Interest", wks, rowNames = FALSE)
    }
    
    
    # Compare bounding boxes given vs. shapefile bounding boxes ----
    
    if(sheet == "Mapping") {
      res <- str_extract(string = wb_name, pattern = "_..._") %>% 
        substr(2,4)
      res_gis_loc <- paste0(gis_final_base, "/", toupper(res))
      res_gis_shp <- list.files(path = res_gis_loc, pattern = '.shp$')
      # Load spatial data
      res_spatial <- read_sf(dsn = paste(res_gis_loc, res_gis_shp, sep ='/')) %>% 
        st_zm(drop = TRUE)  # Drop any Z coordinate
      
      #### Reserve bounding box
      res_bbox <- wks[[1]] %>% .[complete.cases(.)]
      msg2 <- bb_check(res_bbox, res_spatial, rbb_percent, bb_aspect) 
      
      #### SK Bounding box
      sk_bbox <- wks[[2]] %>% .[complete.cases(.)]
      msg3 <- bb_check(sk_bbox, res_spatial, sbb_percent, bb_aspect) 
      
      # If either bbox is incorrect, update it with the buffered one
      if(substr(msg2,4,4) == "!" | substr(msg3,4,4) == "!" |
         force_bb_replacement){
        newbb1 <- NULL
        newbb2 <- NULL
        if(substr(msg2,4,4) == "!" | force_bb_replacement){
          newbb1 <- buff_bb(res_spatial, rbb_percent, bb_aspect)
        } 
        if(substr(msg3,4,4) == "!" | force_bb_replacement){
          newbb2 <- buff_bb(res_spatial, sbb_percent, bb_aspect)
        }
        # wb <- loadWorkbook(xl_path)
        if(!is.null(newbb1)) {
          wks[ , 1] <- c(round(newbb1, 4), rep(NA, length(wks[ , 1]) - 4))
          if(force_bb_replacement){
            msg2 <- paste0(msg2, "\n  Forced New BBOX written to spreadsheet")
          }
          else{
            msg2 <- paste0(msg2, "\n  New BBOX written to spreadsheet")
          }
        }
        if(!is.null(newbb2)) {
          wks[ , 2] <- c(round(newbb2, 4), rep(NA, length(wks[ , 2]) - 4))
          if(force_bb_replacement){
            msg3 <- paste0(msg3, "\n  Forced New BBOX written to spreadsheet")
          }
          else{
            msg3 <- paste0(msg3, "\n  New BBOX written to spreadsheet")
          }
        }
      }
      writeData(wb, sheet = "Mapping", wks, rowNames = FALSE)
      msg <- paste0("   ---Checking res_bounding_box ---\n", msg2,
                    "\n   ---Checking SK_bounding_box ---\n", msg3)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
  }
  #
  # Write out results ----
  # Add sheets that were not used to preserve correct structure
  wks <- (read.xlsx(xl_path, "Global_Decisions-->") )
  writeData(wb, sheet = "Global_DecisionsX-->", wks, rowNames = FALSE)
  wks <- (read.xlsx(xl_path, "Analyses-->") )
  writeData(wb, sheet = "AnalysesX-->", wks, rowNames = FALSE)
  
  if(good_sheets) {
    qaqced_xl_path <- paste0(good_reserve_updates_path, "/", wb_name)    
    msg <- paste0("Workbook passed QA/QC, copying to \n",
                  qaqced_xl_path)
  } else {
    qaqced_xl_path <- paste0(good_reserve_updates_path, "/needs_checking/", wb_name)
    msg <- paste0("!!!  Workbook FAILED QA/QC, copying to \n",
                  qaqced_xl_path, "")
    
  }
  
  write.table(msg, report_file, col.names = FALSE,
              row.names = FALSE, quote = FALSE, append = TRUE)
  
  #  Create output directory if needed ----
  # 
  new_dir_result <- check_make_dir(qaqced_xl_path)
  saveWorkbook(wb, file = qaqced_xl_path, overwrite = TRUE)
}
msg <- paste0("\n====== END of Spreadsheet QA/QC processing ======")
write.table(msg, report_file, col.names = FALSE,
            row.names = FALSE, quote = FALSE, append = TRUE)
