# Internal functions for workflow -----------

check_make_dir <- function(fname) {
  if(!dir.exists(dirname(fname))) {
    dir.create(dirname(fname), recursive = TRUE)
    return(TRUE)
  }
}

base_dir <- getwd()
old_zip_dir <- "E:/SWMP/From_CDMO_2020_RPTS"
dest_dir_root <- paste0(old_zip_dir, "/", "unzipped")
new_zip_dir <- paste0(old_zip_dir, "/", "new_zips")
zips <- list.files(path = old_zip_dir, pattern = "^....zip")


# Loop and extract ----

for (archive in zips) {
  aroot <- substr(archive,1,3)
  print(paste0("Working on ", archive))
  adest <- paste0(dest_dir_root, "/", aroot)
  asource <- paste0(old_zip_dir, "/", archive)
  check_make_dir(adest)
  unzip(asource,  exdir = adest)
} 



# fix template dir if needed

wrong_dir <- "./template_files/images/images/images"
right_dir <- "./template_files/images"
for (archive in zips) {
  aroot <- substr(archive,1,3)
  print(paste0("Checking ", aroot))
  adest <- paste0(dest_dir_root, "/", aroot)
  setwd(adest)
  if(dir.exists(wrong_dir)) {
    print(paste0("*** FIXING ", adest))
    pics <- list.files(path = wrong_dir, full.names = FALSE)
    for (pic in pics) {
      file.copy(paste0(wrong_dir, "/",pic), paste0(right_dir, "/",pic),
                overwrite = TRUE)
    }
    unlink("./template_files/images/images", recursive = TRUE)
  }
  setwd(base_dir)
}

for (archive in zips) {
  aroot <- substr(archive,1,3)
  print(paste0("zipping up ", archive))
  adest <- paste0(dest_dir_root, "/", aroot)
  afinal <- paste0(new_zip_dir, "/", archive)
  check_make_dir(afinal)
  zip(afinal,  files = adest)
} 

