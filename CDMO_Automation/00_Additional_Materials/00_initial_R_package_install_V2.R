# This should be all needed to update R 4.0 with new libraries
# When prompted to compile from source, NO is the recommended answer.

install.packages(c("broom", "lubridate", "readxl", "EnvStats", "ggthemes", "RColorBrewer"))
install.packages(c("leaflet", "maptools", "officer"))
install.packages(c("flextable", "rgeos", "rgdal"))
install.packages(c("devtools","webshot"))
install.packages("SWMPr")
install.packages("SWMPrExtension")

tinytex::install_tinytex()

webshot::install_phantomjs()

#devtools::install_github("NOAA-OCM/SWMPrExtension")
