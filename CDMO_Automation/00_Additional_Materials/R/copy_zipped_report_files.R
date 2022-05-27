this_dir <- getwd()
logout <- file("01_copy_files_output.log", open = "wt")
logmess <- file("01_copy_files__message.log", open = "wt")
sink(logout, append = FALSE, type = "output", split = FALSE)
sink(logmess, append = FALSE, type = "message", split = FALSE)

# Load libraries ----------
suppressPackageStartupMessages({
  library(SWMPrExtension)
  library(dplyr)
  library(tidyr)
  library(tmap)
  library(readxl)
  library(dplyr)
  library(stringr)
})

# Copy needed files from previous years zip archives
#
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
if(!exists('old_zip_dir')) {old_zip_dir <- "E:/SWMP/Old/2020_runs/new_zips"}
print(paste0("Old_zip_dir is ", old_zip_dir))
# Destination root
if(!exists('dest_dir_root')) {dest_dir_root <- "E:/SWMP/2021_status_input"}

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
    filter(grepl("xlsx", Name, ignore.case = TRUE) | 
             grepl("Page..jpg", Name) |
             grepl("logo", Name, ignore.case = TRUE))
  if(aroot != "elk") {
    needed <- needed %>%
      filter(!grepl("elk", Name, ignore.case = TRUE))
  }
  print(needed$Name)
  unzip(asource,  files = needed$Name, exdir = adest,
        junkpaths = TRUE,
        overwrite = TRUE)
  # Create correct directory structure
  
  fnames <- list.files(adest)
  to_keep <- c()
  for(file in fnames) {
    if(grepl("jpg",tolower(file)) || grepl("logo",tolower(file))){
      to_keep <- c(to_keep, paste0(adest, "/template_files/images/", file))
    } else if (file == "Reserve_Level_Template_Text_Entry.xlsx") {
      to_keep <- c(to_keep, paste0(adest, "/template_files/text/", file))
    } else if (file == "Reserve_Level_Plotting_Variables.xlsx") {
      to_keep <- c(to_keep, paste0(adest, "/figure_files/", file))
    }
  }
  
  for(kept in to_keep) {
    check_make_dir(kept)
    file.copy(paste0(adest, "/", basename(kept)), kept)
  }
  
  for(file in fnames) {
    file.remove(paste0(adest, "/", file))
  }
}

message("End move_old_report_files, closing log files ===================")
# End output and message redirection
sink(NULL, type = "output")
sink(NULL, type = "message")
for(i in seq_len(sink.number())){  # Just in case there are more
  sink(NULL)
}
close(logout)
close(logmess)
