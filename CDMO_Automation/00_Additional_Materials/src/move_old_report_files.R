# Copy needed files from previous years zip archives
#

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

# Destination root
if(!exists('dest_dir_root')) {dest_dir_root <- "C:/SWMP/2019_status_input"}

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
    filter(grepl("xlsx", Name, ignore.case = TRUE) | 
             grepl("Page..jpg", Name) |
             grepl("logo", Name, ignore.case = TRUE))
  if(aroot != "elk") {
    needed <- needed %>%
      filter(!grepl("elk", Name, ignore.case = TRUE))
  }
  unzip(asource,  files = needed$Name, exdir = adest,
        overwrite = TRUE) 
}

