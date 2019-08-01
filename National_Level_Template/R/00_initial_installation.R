pkg_data_wrangle <- c('broom', 'dplyr', 'lubridate', 'magrittr', 'tidyr', 'rlang', 'readxl')

pkg_analysis <- c('EnvStats', 'ggplot2', 'ggthemes', 'scales', 'RColorBrewer', 'stringr')

pkg_map <- c('leaflet', 'maptools', 'rgdal', 'rgeos', 'sp', 'mapview', 'webshot')

pkg_reporting <- c('flextable', 'officer')

pkg_swmp <- c('SWMPr', 'SWMPrExtension', 'devtools')

install.packages(c(pkg_data_wrangle, pkg_analysis, pkg_map, pkg_reporting, pkg_swmp), repos = "http://cran.us.r-project.org")

# Load webshot package and install phantomjs
## phantomjs is required to make the grayscale reserve level maps
library(webshot)
install_phantomjs()
 
# Install/load "installr" package:
#if(!require(installr)) { install.packages("installr", repos = "http://cran.us.r-project.org"); require(installr)} #load / install+load installr

# Install pandoc:
#install.pandoc()