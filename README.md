# SWMP_StatusReport

This repo is for the R scripts, data, and associated files needed to produce status reports for the National Estuarine Research Reserve System (NERRS) reserves on an annual basis based off of their System-Wide Monitoring Program (SWMP, pronounces "swamp") data.

The reports rely heavily on the [SWMPrExtension (https://github.com/NOAA-OCM/SWMPrExtension)](https://github.com/NOAA-OCM/SWMPrExtension) and [SWMPr (https://github.com/fawda123/SWMPr)](https://github.com/fawda123/SWMPr) libraries.

The status report code was developed by LimnoTech, Inc., as a contracted service through the NERRS Science COllaborative (http://www.nerrssciencecollaborative.org/) for the NOAA Office for Coastal Management.  The process was overseen and guided by a broad range of NERRS members representing different roles and geographies.

## Repo Organization and General Instructions
Status reports can be produced at the level of individual reserves or at a National level.  R projects for each type report are found in the appropriately named subdirecty of this repo.  Detailed directions are given for creating each report in a pdf document located in the /doc subdirectory for each type.

Note: Before creating an Annual Report, all reserve-level reports will need to be run.  Running reserve-level reports creates the analyzed input needed for the annual report.

The CDMO_Automation subdirectory contains PowerShell scripts, R scripts, and other files needed for automatically creating all reserve templates in a batch fashion at the NERRS [Centralized Data Management Office ( CDMO, http://cdmo.baruch.sc.edu/).](http://cdmo.baruch.sc.edu/)

## Data Access and Format
The SWMPr library require SWMP data to be downloaded from the CDMO Advanced Query System (http://cdmo.baruch.sc.edu/aqs/zips.cfm) using the Zip Downloads interface (http://cdmo.baruch.sc.edu/aqs/zips.cfm).  Data downloaded in other formats will require additional steps, not documented as part of this package, to work with SWMPr and, therefore, the whole status report generation workflow.

## NOAA Open Source Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ?as is? basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
