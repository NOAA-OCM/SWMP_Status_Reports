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
good_reserve_updates_path <- "C:/SWMP/2020_QAQC_reserve_var_sheets"

# Path for shapefiles after they have gone through 
# the qaqc_gis.R process
gis_final_base <- "../00_Annual_Update/Reserve_level_template/inst/gis"

#
# Functions ----
#
check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

# Calculate new bounding box, buffering gis file by percent % per side
# 
buff_bb <- function(gis_shape, percent){
  gis_5072 <- st_transform(gis_shape, crs = 5072) 
  bb_5072 <- st_bbox(gis_5072)
  buff_dist <- (max(abs(bb_5072[2] - bb_5072[1]),   # Horizontal distance
                    abs(bb_5072[2] - bb_5072[1])) * # Vertical distance
                  percent)                          # * percentage%
  buff_5072 <- st_buffer(gis_5072, buff_dist)
  bb_buff_4092 <- st_bbox(st_transform(buff_5072, crs = 4269))
  return(bb_buff_4092)
}
# 
# Make bbox check ----
# 
bb_check <- function(xlbbx, gis_shape, percent, bb_buff_4092) { 
  this_bbox <- c(min(xlbbx[1], xlbbx[3]), min(xlbbx[2], xlbbx[4]),
                 max(xlbbx[1], xlbbx[3]), max(xlbbx[2], xlbbx[4]))
  
  res_4269 <- st_transform(gis_shape, 4269) # Reproject to lat/lon NAD83
  gisbbx <- st_bbox(res_4269)
  
  if(! (this_bbox[1] <= gisbbx[1] &  # specified LL-long is correct
        this_bbox[2] <= gisbbx[2] &  # specified LL-lat is correct
        this_bbox[3] >= gisbbx[3] &  # specified LL-long is correct
        this_bbox[4] >= gisbbx[4])   # specified LL-lat is correct
  ) { 
    bb_buff_4092 <- buff_bb(gis_shape, percent)
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
site_files <- (list.files(path = reserve_updates_path, pattern = "xlsx"))

test_year <- 2020
report_file <- paste0("check_results/reserve_var_checks_", test_year,".txt")

sheets <- c('Flags', 'Years_of_Interest', 'Seasons', 'Mapping',
            'Bonus_Settings', 'Basic_Plotting', 'Threshold_Plots',
            'Threshold_Identification')

min_rows <- c(5, 2, 13, 5, 11, 21, 21, 21)
min_cols <- c(1, 2,  7, 6,  2,  6, 14,  5)

# Begin testing
# 

msg <- paste0("Begin check at ", Sys.time())
write.table(msg, report_file, col.names = FALSE,
            row.names = FALSE, quote = FALSE, append = FALSE)

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
      good_sheets <- FALSE
      msg <- paste0("! -- Missing rows on sheet *", sheet,
                    "*, has ", nrow(wks), " needs ", min_rows[i])
      # print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
    }
    if(ncol(wks) < min_cols[i]) {
      good_sheets <- FALSE
      msg <- paste0("! -- Missing columns on sheet *", sheet,
                    "*, has ", ncol(wks), " needs ", min_cols[i])
      # print(msg)
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
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
      msg2 <- bb_check(res_bbox, res_spatial, 0.20, newbb1) 
      
      #### SK Bounding box
      sk_bbox <- wks[[2]] %>% .[complete.cases(.)]
      msg3 <- bb_check(sk_bbox, res_spatial, 0.10) 
      
      
      # If either bbox is incorrect, update it with the buffered one
      if(substr(msg2,4,4) == "!" | substr(msg3,4,4) == "!"){
        newbb1 <- NULL
        newbb2 <- NULL
        if(substr(msg2,4,4) == "!"){
          newbb1 <- buff_bb(res_spatial, 0.20)
        } else
        if(substr(msg3,4,4) == "!"){
          newbb2 <- buff_bb(res_spatial, 0.10)
        }
        # wb <- loadWorkbook(xl_path)
        if(!is.null(newbb1)) {
          wks[ , 1] <- c(round(newbb1, 4), rep(NA, length(wks[ , 1]) - 4))
          msg2 <- paste0(msg2, "\n  New BBOX written to spreadsheet\n")
        }
        if(!is.null(newbb2)) {
          wks[ , 2] <- c(round(newbb2, 4), rep(NA, length(wks[ , 2]) - 4))
          msg3 <- paste0(msg3, "\n  New BBOX written to spreadsheet\n")
        }
        writeData(wb, sheet = "Mapping", wks, rowNames = FALSE)
      }
      
      
      msg <- paste0("   ---Checking res_bounding_box ---\n", msg2,"\n",
                    "   ---Checking SK_bounding_box ---\n", msg3,"\n")
      write.table(msg, report_file, col.names = FALSE,
                  row.names = FALSE, quote = FALSE, append = TRUE)
      
    }
  }
  
  #
  # Write out results ----
  # 
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
