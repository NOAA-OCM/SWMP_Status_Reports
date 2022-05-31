# Create a basic HTML page to download zipped reserve files
# 

years <- read.csv("../NERRS_years.csv")

reserves <- read.csv(("../NERRS_sites.csv"))

ofile <- ("./results/index.html")

header <- '<!DOCTYPE html>  <body> 
<h1>SWMP Status Report runs for 2021</h1>

<h2>These reports are run with data downloaded from CDMO on 04/02/2022</h2>

<p>For the most recent data, always download zip-formatted data from
<a href="https://cdmo.baruch.sc.edu/aqs/zips.cfm">CDMO</a></p>

<p>If you are having issues or run into problems downloading these files, 
contact Kirk.Waters@noaa.gov.  If you have R questions, you can still ask
Dave Eslinger at dave.eslinger01@gmail.com.</p>'
footer <- " </body></html>"

write(header, file = ofile)


for(res in reserves) {
  txt <- paste0('<a href="./', res, '.zip">', res, '.zip</a><br>')
   write(txt, file = ofile, append = TRUE)

}  

write(footer, file = ofile, append = TRUE)
closeAllConnections()
