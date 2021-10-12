# Check all Shapefiles and bounding boxes in Excel spreadsheets
#
# N.B.: The source paths for non-qaqced files are hard coded, since there is no
# expectation that annual updates will reside within this package during the
# QA/QC process. In fact, I recommend against it.  Instead this process will copy them into the
# ../../00_Annual_Update/Updated_reserve_var_sheets and the appropriate gis  directory when they have
# passed QA/QC.  That should be a cleaner process, IMO.

# Libraries ----
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readxl)
  library(janitor)
  library(sf)
  library(SWMPrExtension)
  library(tmap)
  # library(tidycensus)
})  
# options(tigris_use_cache = TRUE)
tmap_mode("view")

# Path for new data ----
#--  THIS NEEDS DEFINITION!!
#
#gis_init_base <- "C:/Users/davee/Downloads/Nerrs_GIS/GIS_Process/"
gis_init_base <- "D:/SWMP/CDMO_GIS_2021/GIS_Process/"

# Internal functions for workflow -----------

check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

#
# Paths ------
#   Below here are standardized directory paths, assuming this program is
#   launched from an Rproject.
#
test_year <- 2020

gis_final_base <- "../00_Annual_Update/Reserve_level_template/inst/gis/"
report_file <- paste0("check_results/gis_boundary_checks_",test_year,".log")
county_file <- paste0("check_results/reserve-county_intersections_",test_year,".csv")

#
# Get state outlines ------
#

cnty_raw <- get("counties_4269") %>% 
  select(-area) 
cnty_fips <- tidycensus::fips_codes %>% 
  transmute(county, state, state_fips = state_code,
            county_fips = paste0(state_code, county_code))

cnty_boundaries  <- cnty_raw %>% 
  left_join(cnty_fips, by = 'county_fips') %>% 
  select(county, state, county_fips, state_fips)
 
st_crs(cnty_boundaries) <- 4326  # Set the projection information

#Project the state data into our Albers EA projection, epsg = 5072.
# state_5072 <- st_transform(cnty_boundaries, crs = 5072)
# us_4269 <- st_transform(cnty_boundaries, crs = 4269)  # Get county outlines from census data


# Begin testing ------ 
# 

msg <- paste0("Begin check at ", Sys.time())
write(msg, file = report_file, append = FALSE)

reserves <- list.files(gis_init_base)

df <- data.frame(reserve = character(),
                 relationship = character(),
                 county = character(),
                 state = character(),
                 state_fips = character(),
                 county_fips = character())
df_col <- colnames(df)


#
# Reserve loop   ------------------------------------
#
for(res in reserves) {
  msg <- paste0("\n\n--------------------------\n",
                "Checking ", res, " at ", Sys.time())
  write(msg, file = report_file, append = TRUE)
  
  # shapefile section ----
  
  res_gis_loc <- paste0(gis_init_base, toupper(res),"/Boundaries/Reserve_Boundaries")
  res_gis_shp <- list.files(path = res_gis_loc, pattern = '.shp$')
  
  # Load spatial data
  res_spatial <- read_sf(dsn = paste(res_gis_loc, res_gis_shp, sep ='/')) %>% 
    st_zm(drop = TRUE)  # Drop any Z coordinate
  
  
  # check shapefile validity ----
  
  file_is_good <- TRUE  # Starts as good, flagged if can't be repaired
  for(i in 1:nrow(res_spatial)){
    if(!st_is_valid(res_spatial[i,])) {
      msg <- paste0("   Bad shapefile for ", res, ", record ", i)
      msg2 <- st_is_valid(res_spatial[i,], reason = TRUE)
      msg <- c(msg, msg2)
      write(msg, file = report_file,  append = TRUE)
      tmp_sf <- st_make_valid(res_spatial[i,])
      if(st_is_valid(tmp_sf )) {
        res_spatial[i,] <- tmp_sf
        msg <- paste0(   "Record ", i, " repaired for ", res)
        write(msg, file = report_file,  append = TRUE)
      } else {
        msg <- paste0("   Record ", i," could not be repaired for ", res)
        msg2 <- st_is_valid(res_spatial[i,], reason = TRUE)
        msg3 <- paste0("\n**** Reserve ", res, 
                       "needs different gis data ****\n")
        msg <- c(msg, msg2, msg3)
        write(msg, file = report_file,  append = TRUE)
        file_is_good <- FALSE
        next()
      }
    }
  }
  
  msg <- paste0("   Initial ",res, " crs is ", st_crs(res_spatial)$input
                # , " \n With WKS:\n", st_crs(res_spatial)$wkt
  )
  write(msg, file = report_file,  append = TRUE)
  # res_5072 <- st_transform(res_spatial, crs = 5072)
  # res_4269 <- st_transform(res_spatial, crs = 4269)
  # c_inters <- state_5072[as.data.frame(st_intersects(state_5072, res_5072))[, 1], ]
  # c_touch <- state_5072[as.data.frame(st_touches(state_5072, res_5072))[, 1], ]
  
  # Do intersection in CRS of Reserve shapefile
  state_res <- st_transform(cnty_boundaries, st_crs(res_spatial))
  c_inters <- state_res[as.data.frame(st_intersects(state_res, res_spatial))[, 1], ]
  c_touch <- state_res[as.data.frame(st_touches(state_res, res_spatial))[, 1], ]
  
  inters <- cbind(res, "intersects", 
                  unique(st_drop_geometry(c_inters)))
  colnames(inters) <- df_col
  df <- rbind(df, inters)
  
  if(nrow(c_touch > 0)) {
    touc <- cbind(res, "touches", 
                  unique(st_drop_geometry(c_touch)))
    colnames(touc) <- df_col
    df <- rbind(df, touc)
  }
  
  # Write out good shapefile into new location -----
  
  if(file_is_good) {
    fixed_name <- paste0(gis_final_base, res, "/qa_",res_gis_shp) 
    new_dir_result <- check_make_dir(fixed_name)
    msg <- paste0("   Saving good shapefile as \n       ", fixed_name)
    write(msg, file = report_file,  append = TRUE)
    st_write(res_spatial, fixed_name, 
             driver = "Esri Shapefile", append = FALSE)
  } else {
    msg <- paste0("**** No GIS data for Reserve ", res, "\n")
    write(msg, file = report_file,  append = TRUE)
  }
  #  Tmap ----
  
  if(FALSE){  
    map <- tm_shape(res_spatial) +
      tm_borders() +
      tm_fill(col = "green") +
      tm_shape(state_res) +
      tm_borders() +
      tm_shape(c_inters) +
      tm_borders() +
      tm_fill(col = "yellow", alpha = 0.05) 
    # tm_shape(c_overlap) +
    # tm_borders() +
    # tm_fill(col = "red", alpha = 0.5)
    
    if(nrow(c_touch > 0)) {
      map <- map +
        tm_shape(c_touch) +
        tm_borders() +
        tm_fill(col = "blue", alpha = 0.5)
    }
    
    map
  }
  # 
  # # Compare bounding boxes ----
  # 
  # wb_name <- paste0(reserve_updates_path,"Reserve_Level_Plotting_Variables_", res, "_", test_year, ".xlsx") 
  # wb <- read_xlsx(path = wb_name, sheet = "Mapping")
  # #### Reserve bounding box
  # res_bbox <- wb[[1]] %>% .[complete.cases(.)]
  # sk_bbox <- wb[[2]] %>% .[complete.cases(.)]
  # 
  # 
}
msg <- paste0("QA/QC successful.  Writing csv file of county intersections.\n")
write(msg, file = report_file,  append = TRUE)

write.csv(df, file = county_file, row.names = FALSE)

msg <- paste0("Output successfully written.  QA/QC complete.")
write(msg, file = report_file,  append = TRUE)

