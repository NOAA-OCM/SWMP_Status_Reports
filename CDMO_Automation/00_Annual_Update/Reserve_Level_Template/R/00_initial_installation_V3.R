using <- function(...) {
  libs <- unlist(list(...))
  req <- unlist(lapply(libs,require,character.only=TRUE))
  need <-libs[req==FALSE]
  n <-length(need)
  if(n > 0){
    libsmsg <-if(n > 2) paste(paste(need[1:(n-1)], collapse=", "),",",sep="") else need[1]
    print(libsmsg)
    if(n > 1){
      libsmsg <-paste(libsmsg," and ", need[n],sep="")
    }
    libsmsg <- paste("The following packages could not be found: ",libsmsg,
                     "\n\r\n\rInstall missing packages?", collapse="")
    if(winDialog(type = c("yesno"), libsmsg)=="YES"){       
      install.packages(need, repos = "http://cran.us.r-project.org")
      lapply(need, require, character.only=TRUE)
    }
  }
}

pkg_data_wrangle <- c('broom', 'lubridate', 'openxlsx', 'readxl')

pkg_analysis <- c('EnvStats', 'ggthemes', 'RColorBrewer')

pkg_map <- c('sf', 'tmap', 'tmaptools')

pkg_reporting <- c('flextable', 'officer')

pkg_swmp <- c('SWMPr', 'SWMPrExtension', 'devtools')

using(c(pkg_data_wrangle, pkg_analysis, pkg_map, pkg_reporting, pkg_swmp))