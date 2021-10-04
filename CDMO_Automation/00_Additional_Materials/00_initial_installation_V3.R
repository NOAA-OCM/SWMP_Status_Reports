pkg_data_wrangle <- c('broom', 'lubridate', 'openxlsx', 'readxl')

pkg_analysis <- c('EnvStats', 'ggthemes', 'RColorBrewer')

pkg_map <- c('sf', 'tmap', 'tmaptools')

pkg_reporting <- c('flextable', 'officer')

pkg_swmp <- c('SWMPr', 'SWMPrExtension', 'devtools')

install.packages(c(pkg_data_wrangle, pkg_analysis, pkg_map, pkg_reporting, pkg_swmp), repos = "http://cran.us.r-project.org")
