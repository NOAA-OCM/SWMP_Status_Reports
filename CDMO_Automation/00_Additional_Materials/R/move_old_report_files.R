# Load libraries ----------
suppressPackageStartupMessages({
  library(SWMPrExtension)
  library(dplyr)
  library(tidyr)
  library(readxl)
})

# This is preliminary step to check_reserve_vars.R  It will copy and
# rename plotting variable files from previous years zip archives

# THIS IS ONLY NEEDED IF THERE IS NO COPY OF THE PREVIOUS YEAR'S
# Reserve_Level_Plotting_Variables.xlsx FILES FOR ALL RESERVES.
# 
# I suggest keeping the past year's files, then just using that directory 
# in the next step: check_reserve_vars.R

# Libraries ----
library(dplyr)

# Internal functions for workflow -----------

check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

# Parameters ----
#
# This is where the XXX.zip files are, out of which *needed* will be copied  
if(!exists('old_zip_dir')) {old_zip_dir <- "D:/SWMP/2019_Version1"}
print(paste0("Old_zip_dir is ", old_zip_dir))
# Destination root: to be used in check_reserve_vars.R
if(!exists('dest_dir_root')) {dest_dir_root <- "C:/SWMP/2019_raw_spreadsheets"}

print(paste0("dest_dir_root is ", dest_dir_root))


check_make_dir(dest_dir_root)

# Read list of zipped files
zips <- list.files(path = old_zip_dir, pattern = "^....zip")


# Loop and extract ----

for (archive in zips) {
  aroot <- substr(archive,1,3)
  print(paste0("Working on ", archive))
  adest <- paste0(dest_dir_root, "/", aroot)
  asource <- paste0(old_zip_dir, "/", archive)
  check_make_dir(adest)
  all_files <- unzip(asource, list = TRUE)
  needed <- all_files %>% 
    filter(grepl("Reserve_Level_Plotting_Variables.xlsx", Name, ignore.case = TRUE) )
  print(needed$Name)
  unzip(asource,  files = needed$Name, exdir = dest_dir_root,
        overwrite = TRUE) 
  new_name <- paste0(sub('\\.xlsx$', '', basename(needed$Name)),
  "_", toupper(aroot), "_2020.xlsx")
  file.rename(paste0(dest_dir_root, "/",needed$Name), 
              paste0(dest_dir_root, "/",new_name))
}
