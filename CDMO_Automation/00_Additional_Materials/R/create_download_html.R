# Create a basic HTML page to download zipped reserve files
# 

years <- read.csv("../NERRS_years.csv")

reserves <- read.csv(("../NERRS_sites.csv"))

ofile <- ("./results/index.html")

header <- "<!DOCTYPE html>  <body> 
<h1>SWMP Status Report runs for 2021</h1>"
footer <- " </body></html>"

write(header, file = ofile)


for(res in reserves) {
  txt <- paste0('<a href="./', res, '.zip">', res, '.zip</a><br>')
   write(txt, file = ofile, append = TRUE)

}  

write(footer, file = ofile, append = TRUE)
closeAllConnections()
