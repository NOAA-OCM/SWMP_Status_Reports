           Instructions for running a batch job 
     to process all NERRS SWMP data for Status Reports

                      Version 3; September, 2021
                      David Eslinger
                      dave.eslinger@noaa.gov

The current batch process is fairly straight forward.  The user needs to modify two lines 
in the NERRS_run_reserves_v2.ps1 script and to copy one directory. The lines to be changed 
are near the top of the code (just after the logging setup) and define the FULL PATH to a) 
the location of all data files, b) the location of last years results (unzipped).  
Updated spreadsheets will be supplied as a separate zip file.  They need to be unzipped and 
copied into the CDMO_Automation\00_Annual_Update\Updated_reserve_var_sheets directory.

Once the above steps are done, the modified script can be saved and run from a Windows Command 
console using the NERRS_run.bat batch file, or it can be run directly from a PowerShell by
calling the NERRS_run_reserves_V2.ps1 file directly from within the Update directory.

Detailed Steps:

1) Unzip the CDMO_Automation.zip archive into a new directory.  
It will default to the name of CDMO_Automation, but you can rename it to anything you like, 
e.g., 2020_Status_Reports.  I suggest naming it after the year of the reports rather than
the year in which the processing occurs.

2) Check contents.  There should be:
    a) Two top-level directories
        1) 00_Additional_Materials, which should be used before submitting package to CDMO for production.
            This directory contains 3 subdirectories and 2 files:
            Subdirectories:
            a) check_results, which contains results of preliminary QA/QC checks.  Should be
                self-explanatory.
            b) R, which contains RMarkdown and R scripts for preprocessing GIS and Excel spreadsheets to
               ensure consistency prior to CDMO submission of Status Report package:
                - 00_initial_installation_for_QAQC.R: loads needed libraries
                - check_reserve_vars.R: an R script to make sure all the reserve-specific variable 
                    spreadsheets have the correct number of columns and rows, and their bounding
                    box definitions cover the GIS boundary area.
                - copy_zipped_report_files.R: USED BY CDMO in NERRS_run_reserve_2021.ps1 script;
                    gets needed files (images and excel spreadsheets) from
                    previous zipped up results.
                - get_new_data.Rmd: Gets all raw data files from a CDMO directory
                - move_old_report_files.R: preliminary version of copy_zipped_report_files.R; 
                    may not be needed anymore.
                - qaqc_gis.R: Performs checks on all GIS files, reprojects into standard projection and 
                    moves good files into new location.  They may need to be manually copied into the correct
                    location in 00_Annual_Update/Reserve_Level_Plotting_Template/inst/gis, depending on how the
                    internal paths are defined.
            c) src, contains a PowerShell script to move GIS files into a flatter directory structure. 
                - move_gis_files.ps1: File used to simplify the directory structure for GIS files.
            Files:
            e) CDMO_Automation_Documentation.pdf WARNING: The pdf document is outdated, follow this 
                text document instead. However, the pdf document has useful information on the 
                processing of the data and creation of plots.
            f) 00_Additional_Materials.Rproj: RStudio project file for preliminary QA/QC.

    NOTE:  Prior to a CDMO run, only the 00_initial_installation_V3.R may be required 
        to run an update. That will only be required if the installed R setup needs 
        updating (which is recommended).  Other needed files will be called from the 
        NERRS_run_reserve_2021.ps1 script.

        2) 00_Annual_Update, which contains three subdirectories:
            a) National_Level_Template (R project for National report)
            b) Reserve_Level_Template (R project for Reserve-level reports)
            c) Updated_reserve_var_sheets (location for updated Excel spreadsheets)
                NOTE: These files should use the naming convention: 
                    Reserve_Level_Plotting_Variables_XXX_YYYY.xlsx, where
                    XXX is the 3 letter reserve abbreviation, in UPPERCASE, and
                    YYYY is the full year for the data report, e.g. 2019 for the 2020 run.
    b) Six files
        1) NERRS_run.bat (batch file to run the whole process.)
        2) NERRS_run_reserves_2021.ps1 (actual script to run everything.)
        3) NERRS_sites.csv (list of 3-letter abbreviations for reserves to be run.)
        4) NERRS_sites_all_backup.csv (complete list of 3-letter abbreviations for reserves)
        5) NERRS_years.csv (csv file defining target year and time range for comparison.)
        6) README_CDMO_Run_2021.TXT (this file)
            
3) If needed, copy all the new Reserve_Level_Plotting_Template files (from separate zip archive) to the 
    00_Annual_Update/Updated_reserve_var_sheets subdirectory.  They should be named
    "Reserve_Level_Plotting_Template_xxx_YYYY.xlsx", where xxx is the reserve abbreviation (in
    lower case) and YYYY is the year.  This naming convention will make it easier for reserves to 
    identify their different analyses.  
** For the 2020 data, I have made spreadsheets for all reserves and already put them in the correct location.

4) Edit the NERRS_run_reserves_2021.ps1 file to set variables:
    a) $old_zip_dir, on line 27, which specifies the absolute path to a folder containing COMPRESSED directories 
    from the previous year's run (or any recent run)
    b) $data_path, on line 28, which specifies where ALL csv-formatted data files are for all reserves.

5) Optional, should be correct in supplied package: Check, and edit if necessary, NERRS_sites.csv.

6) Optional, should be correct in supplied package: 
    Edit NERRS_years.csv to specify the target year, generally the current year, and the time period 
    for the long-term comparison, generally, 2000 to the current year.

7) Check your installed R version and update it if needed.  The current version (9/26/2021) is 4.1.1.
    Probably the easiest way to do this is
    a) install the newest version of R from https://cran.r-project.org/.
    b) Two options: 
        1) Use R Studio:
            i. install the newest version of RStudio from https://www.rstudio.com/.  
            ii. Open it up, load and source "00_initial_R_package_install_V2.R"
        2) Just stick to R command line.  RStudio is not needed for anything else:
            i. Navigate to the 00_Additional_NMaterials directory.
            ii. Start an R session by typing "R" at the command line.
            iii. Set up the neded CRAN mirror by entering the following lines (without the ">" prompt of course):
                > r = getOption("repos")
                > r["CRAN"] = "http://cran.us.r-project.org"
                > options(repos = r)
            iv. Run the install program by entering the following lines (without the ">" prompt of course):
                > source(file = "00_initial_R_package_install_V2.R")
            v. Wait a bit.  This SHOULD load everything needed.  It worked for DLE on 9/20/2021 in a new install.

8) Save all edits from steps 4-6.  Then either
    a) run NERRS_run.bat from the command line in a command.com terminal, or
    b) run NERRS_run_reserves_V2.ps1 directly from within a PowerShell terminal.  You will need
        to set ExecutionPolicy to "bypass" for this option.
    Option a) is probably easiest.

9) If everything works as it should, new results are in directories with "01" prefixes. The most
    important directory is 01_Reserve_distrib_files. This is the directory with the zipped 
    directories for all the reserves.  Specifics of directories are:
    a) 01_National_Report: Contains a copy of all the handoff files from the reserves, and the
        National Report.
    b) 01_Reserve_distrib_files: Contains zipped directories for all reserves.  Use this directory
        for distribution to reserves.
    c) 01_Reserve_working_files: unzipped reserve directories used during the processing.  It is
        suggested to compress this entire directory and save it to unzip and use as the 
        "previous_year_path" directory for the next year's processing.
    Note: There may be additional "Backup" directories with an "01" prefix if the batch process is 
        run more than once.  These can be discarded.
          