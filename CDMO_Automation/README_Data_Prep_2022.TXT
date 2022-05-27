           Instructions for preliminary data preparation prior to  
     running the batch job to process all NERRS SWMP data for Status Reports

                      Version 1; May 24, 2022
                      David Eslinger
                      dave.eslinger@noaa.gov
        (dave.eslinger01@gmail.com if needed after 1 June, 2022)
        

Because there may be new reserves, or reserves may aupdate their boundaries
and/or station locations, there are a few things to check each year before
submitting the batch job to create all of the SWMP Status Report plots.

Steps required:
1) Submit a request through the CDMO GIS interface
(http://cdmo.baruch.sc.edu/get/gis_index.cfm) to get updated copies of the
reserve boundaries.  Submit a request through the About Data/SWMP Stations
pull-down menu (http://cdmo.baruch.sc.edu/data/swmp-stations/) to get a current
list of all monitoring station locations.

2) Upload the new station locations using the update_sampling_stations()
function from {SWMPrExtension}.  For instructions use the R help function on the
function: "?update_sampling_stations"   It is quite easy to do.

*** NOTE: You may need to open the downloaded GIS file and delete the CONTENTS
(only) of the "Lat Lon" column if it looks like it has non-ASCII text in it.
Don't worry about the values, they get thrown out anyway.

3)Use the qaqc_gis.R program to check the downloaded GIS files to make sure they
contain valid geometry and fix if possible.  Also, produce a list of counties
that intersect, or are adjacent, to the reserves. (Doug George wanted this at
one point.) 
*** CHECK the path to the GIS files.  It changes at times. ***

4) The next steps require the  "Reserve_Level_Plotting_Variables.xlsx" from each
reserve.  It is easiest to save the ones used in teh previous year.  If those
are not available, use the  "move_old_report_files.R" program to copy them out
of the old zipped up distributions.  Proceed to step 5 when they are available.

5) Use the "check_reserve_vars.R" program to check the boundaries of each
reserve and the locations of their stations to make sure their
"Reserve_Level_Plotting_Variables.xlsx" mapping settings will include them.
These shouldn't change much, but do when reserves expand, or if they move
stations. This program also checks for some entries that were missing in old
spreadsheeet versions.

*** Before using check_reserve_vars.R file, change line #153 (or near there) to
make sure the nerr_sites variable is read from the correct location 
