           Instructions for running a batch job 
     to process all NERRS SWMP data for Status Reports

                      Version 2; August, 2020
                      David Eslinger
                      dave.eslinger@noaa.gov


The current batch process is fairly straight forward.  The user needs to modify two lines 
in the NERRS_run_reserves_V2.ps1 script.  Those lines are right at the top of the code
and simply define the FULL PATH to a) the location of all data files, and b) the location 
of last years results.  Then the modified script can be saved and run from a Windows Command
console using the NERRS_run.bat batch file, or it can be run directly from a PowerShell by
calling the NERRS_run_reserves_V2.ps1 file directly from within the Update directory.

Steps:

1) If needed, unzip the archive containing this file (named CDMO_V2.zip for 2020)into a new directory.  
It will default to the name of CDMO_V2 (for 2020), but you can rename it to anything you like, e.g., 2019_Status_Reports.

2) Check contents.  There should be:
    a) Two directories
        1) 00_Additional_Materials,which contains 2 files:
            a) 00_initial_R_package_install_V2.R
            b) CDMO_Automation_Documentation.pdf WARNING: The pdf document is outdated, follow this 
                text document instead. However, the pdf document has useful information on the 
                processing of the data and creation of plots.
            N.B. Previous versions of this directory contained the install package for pandoc,
                which is needed for producing final Status Reports.  If pandoc is not installed, 
                and you want to install it (not needed for the basic reserve run),
                check the RStudio pandoc site for links to a current version:
                    https://rmarkdown.rstudio.com/docs/articles/pandoc.html
        2) 00_Annual_Update, which contains three subdirectories:
            a) National_Level_Template (R project for National report)
            b) Reserve_Level_Template (R project for Reserve-level reports)
            c) Update_reserve_var_sheets (Updated Excel spreadsheets for plotting variables)
                NOTE: These files should use the naming convention: 
                    Reserve_Level_Plotting_Variables_XXX_YYYY.xlsx, where
                    XXX is the 3 letter reserve abbreviation, in UPPERCASE, and
                    YYYY is the full year for the data report, e.g. 2019 for the 2020 run.
    b) Seven files
        1) NERRS_run.bat (batch file to run the whole process.)
        2) NERRS_run_reserves.ps1.OLD (Original version from LimnoTech), replaced by
        3) NERRS_run_reserves_V2.ps1 (actual script to run everything.)
        4) NERRS_sites.csv (list of 3-letter abbreviations for reserves to be run.)
        5) NERRS_sites_all_backup.csv (complete list of 3-letter abbreviations for reserves)
        6) NERRS_years.csv (csv file defining target year and time range for comparison.)
        7) README_CDMO_Run_2020.TXT (this file)
            
3) Copy all the new Reserve_Level_Plotting_Template files to the 
    00_Annual_Update/Updated_reserve_var_sheets subdirectory.  They should be named
    "Reserve_Level_Plotting_Template_xxx_YYYY.xlsx", where xxx is the reserve abbreviation (in
    lower case) and YYYY is the year.  This naming convention will make it easier for reserves to 
    identify their different analyses.  If reserves do not supply an updated spreadsheet, the values
    from the previous year will be used.

4) Edit the NERRS_run_reserves_V2.ps1 file to set variables:
    a) $previous_year_path, on line 8, which specifies the absolute path to a folder containing UNCOMPRESSED directories 
    from the previous year's run (or any recent run)
    b) $data_path, on line 9, which specifies where ALL csv-formatted data files are for all reserves.

5) Check, and edit if necessary, NERRS_sites.csv

6) Edit NERRS_years.csv to specify the target year, generally the current year, and the time period 
    for the long-term comparison, generally, 2007 to the current year.

7) Save all edits from steps 4-6.  Then either
    a) run NERRS_run.bat from the command line in a command.com terminal, or
    b) run NERRS_run_reserves_V2.ps1 directly from within a PowerShell terminal.  You will need
        to set ExecutionPolicy to "bypass" for this option.
    Option a) is probably easiest.

8) If everything works as it should, new results are in directories with "01" prefixes. The most
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

Special Note for 2019 results: He'eia is excluded from the automated processing for this year.  NOAA 
    will work directly with them to handle their special case for this year.  Contact Dave Eslinger
    (dave.eslinger@noaa.gov) to discuss.



    