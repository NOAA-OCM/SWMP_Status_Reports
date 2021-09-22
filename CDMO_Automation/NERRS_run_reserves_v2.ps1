#-----------------------------------------------------------------------
# Initializing Path and begin logging:
#  DO NOT CHANGE THIS BIT
#-----------------------------------------------------------------------

$root = $PSScriptRoot ## Use of batch processing
# $root = Get-Location # Use for interactive testing
Set-Location $root
$proc_log = "$root\01_process_log.txt"

# Set up a logging session to capture all PowerShell output
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
if (Test-Path -Path $proc_log) {  # If log file already exists, back it up
    Move-Item -Path $proc_log  "$proc_log.Backup" -Force 
}
Start-Transcript -path $proc_log -append

#-----------------------------------------------------------------------
# *****!!!!! USER INPUT REQUIRED !!!!!*****
# Change the below paths for your system.  
#-----------------------------------------------------------------------

# $previous_year_path = "C:\tmp\2018_reserves" # Absolute path for old site directories
# $data_path = "C:\SWMP\CDMO_V2\00_Data"    # Absloute path to data directory, where all
$previous_year_path = "E:\SWMP\2018_reserves" # Absolute path for old site directories
$data_path = "E:\SWMP\data2019\swmp_data_archives"    # Absolute path to data directory, where all
                                          # reserve data are kept

#-----------------------------------------------------------------------
# *****!!!!! End of User Input.  No modification should be needed below here !!!!!*****                                        
#-----------------------------------------------------------------------

# Define input directories
$update_path = "$root\00_Annual_Update"

#    Source files for new site template
$site_template = "$update_path\Reserve_Level_Template"
$natl_template = "$update_path\National_Level_Template"
$reserve_updates_path = "$update_path\Updated_reserve_var_sheets" # Absolute path to where any new 
#       Reserve_Level_Plotting_Variables_XXX_YYYY.xlsx files are found.  XXX is reserve, YYYY is year.

#    List of subdirectories that contain customized content.  These will be copied to updated site dir.
$Site_custom = New-Object System.Collections.ArrayList
[void]$Site_custom.Add("figure_files\Reserve_Level_Plotting_Variables.xlsx")
[void]$Site_custom.Add("template_files\text\Reserve_Level_Template_Text_Entry.xlsx")
[void]$Site_custom.Add("template_files\images")
# Write-Output $Site_custom
# Break

# Define output directories
$nat_folder_local = "01_National_Report"    # local National template folder to move result files to
$nat_folder = "$root\$nat_folder_local"    # full path National template folder to move result files to
$dist_folder = "$root\01_Zipped_distrib_files"
$work_folder = "$root\01_Reserve_working_files"
$hout_folder = "handoff_files"				# Subfolder in reserve folder to retrieve result files from

# Define temporary variables and intialize as needed
$site_lst = @()                             # initialize list
$Rmaster = "temp.R"                         # Temporoary file for running R commands

# Load required system resources
Add-Type -AssemblyName "System.IO"
Add-Type -AssemblyName "System.IO.Compression.FileSystem"

#-----------------------------------------------------------------------
# Create folders to hold reserve unzipped and zipped folders:
#-----------------------------------------------------------------------
if (Test-Path -Path $work_folder) {
    Move-Item -Path $work_folder  "$work_folder.Backup" -Force  #Backup existing working files
}
New-Item -ItemType Directory -Force -Path $work_folder
New-Item -ItemType Directory -Force -Path "$work_folder\all_logs"

if (Test-Path -Path $dist_folder) {
    Move-Item -Path $dist_folder  "$dist_folder.Backup" -Force  #Backup existing distribution files
}
New-Item -ItemType Directory -Force -Path $dist_folder

if (Test-Path -Path $nat_folder) {
    Move-Item -Path $nat_folder  "$nat_folder.Backup" -Force  #Backup existing national files
}
New-Item -ItemType Directory -Force -Path $nat_folder
New-Item -ItemType Directory -Force -Path $nat_folder/$hout_folder

#-----------------------------------------------------------------------
# Read User Inputs from CSV Files:
#-----------------------------------------------------------------------

# Read sites from CSV:
Import-Csv $root\NERRS_sites.csv |
    ForEach-Object {
        $site_lst += $_.SiteID
    }

# Read timeframe info from CSV:
Import-Csv $root\NERRS_years.csv |
    ForEach-Object {
        $targ_year = $_.target_year
        $year_start = $_.start_year
        $year_end = $_.end_year
    }

#-----------------------------------------------------------------------
# Create Content ArrayList for Running Reserve Sequence:
#-----------------------------------------------------------------------
$Rlines = New-Object System.Collections.ArrayList
[void]$Rlines.Add("target_year = c(" + $targ_year + ")")
[void]$Rlines.Add("year_range = c(" + $year_start + "," + $year_end + ")")
#[void]$Rlines.Add("source('R/00_load_global_decisions_variables.R')")
[void]$Rlines.Add("source('R/01_Load_Wrangle_Run.R')")
[void]$Rlines.Add("closeAllConnections()")

#-----------------------------------------------------------------------
# Process reserve sites & run reserve analyses:
#-----------------------------------------------------------------------
Foreach ($site in $site_lst) {

    # Write initialization message:
    Write-Output ""
    Write-Output ""
    Write-Output "********************************************************"
	Write-Output "* Processing reserve '$($site)'"
    Write-Output "*"
    Write-Output ""

    # Copy updated version of Reserve_Level_Template to site directory
    Copy-Item -Path $site_template -Destination $work_folder\$site -Force -Recurse

    # Copy reserve-specific files from previous year.  If none available, print warning
    if (Test-Path $previous_year_path\$site) {
        foreach ($item in $Site_custom) {
            if(Test-Path $previous_year_path\$site\$item){
                Copy-Item -Path "$previous_year_path\$site\$item" -Destination "$work_folder\$site\$item" -Force -Recurse
                Copy-Item $previous_year_path\$site\$item $work_folder\$site\$item -Force -Recurse
            } else {
                Write-Output "  *** No content in $site for $item ***"
            }
       }
    } else {
           Write-Output "  *** No $site reserve-specific files from previous year ***"
    }


    # Copy all  data files for this site to "data" subfolder (force overwrite):
    Get-ChildItem -Path $data_path -filter "$site*.csv" | Copy-Item -Destination "$work_folder\$site\data" -Force

    # Copy any annual updates from the Updated_Reserve_Variables folder and subfolders

    #     Copy the reserve plotting spreadsheet if an update exists
    $new_res_vars = "$reserve_updates_path\Reserve_Level_Plotting_Variables_$($site)_$targ_year.xlsx"
    if (Test-Path -Path $new_res_vars) {
        $var_dest_path = "$work_folder\$site\figure_files"
        if( -not (Test-Path $var_dest_path)) {
            New-Item -Path $var_dest_path -ItemType "directory"
        }
        Copy-Item -Path $new_res_vars -Destination $var_dest_path\Reserve_Level_Plotting_Variables_$($site)_$targ_year.xlsx -Force
        # Copy for a backup and rename for use
        Copy-Item -Path $var_dest_path\Reserve_Level_Plotting_Variables_$($site)_$targ_year.xlsx `
        -Destination $var_dest_path\Reserve_Level_Plotting_Variables.xlsx
        Write-Output " *** Using updated spreadsheet: $new_res_vars *** "
    } else {
        Write-Output " *** No updated spreadsheet, using previous version *** "
    }

    # Change directory and remove existing "handoff" and "output" files:
    Set-Location $work_folder\$site
    if( Test-Path "$work_folder\$site\$hout_folder") {
	    Remove-Item $work_folder\$site\$hout_folder\* -Force -Recurse    #delete "handoff" files
    }
    Get-ChildItem -Path $work_folder\$site\output -Recurse -force | Where-Object { -not ($_.psiscontainer) } | Remove-Item -Force    #delete "output" files

    # Create temporary master script ("temp.R") - must be encoded in UTF-8!:
    $tmpfile = "$($work_folder)\$($site)\$($Rmaster)"
    [System.IO.File]::WriteAllLines($tmpfile, $Rlines, [System.Text.UTF8Encoding]($False))

	# Run master R script:
	$Rcommand = "R.exe --vanilla -f $($Rmaster)"
	Try { 
        Invoke-Expression $Rcommand  
        Write-Output "`R call succeeded for $($site)` ------------"
        Write-Output ""    
    }Catch{
        Write-Output "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        Write-Output "X                                                      X"
        Write-Output "X       ERROR in R processing of reserve '$($site)'         X"
        Write-Output "X                                                      X"
        Write-Output "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 
        Write-Output ""       
    } 

	Remove-Item $tmpfile -Force


    # Move reserve handoff files to national handoff folder:
	Set-Location $root			#back to main folder

	Copy-Item $work_folder\$site\$hout_folder\* "$nat_folder\$hout_folder\" -Force
	# Move-Item $root\$site\$hout_folder\* $root\$nat_folder\$hout_folder -Force
	
    # Copy log files to top level all_logs directory
    Copy-Item $work_folder\$site\*.log "$work_folder\all_logs\" -Force
	
    # Zip up all reserve files:
    $zsrc = "$($work_folder)\$($site)\"
    $zdest = "$($dist_folder)\$($site).zip"

    if (Test-Path $zdest) {
	    Remove-Item $zdest -Force
    }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($zsrc, $zdest)

    # Write completion message:
    Write-Output "*"
	Write-Output "* Completed reserve '$($site)'"
    Write-Output "********************************************************"
    Write-Output ""
}

Write-Output ""
Write-Output "  ========== END OF RESERVE LOOP ==========="
Write-Output ""
Write-Output ""
Write-Output "---------------------------------------------------------"
Write-Output "    Check for Reserve-level processing errors"
Write-Output ""
Set-Location $work_folder\all_logs\
Select-String -Pattern "Error" *.log
Set-Location $root
Write-Output ""
Write-Output "    End of Reserve-level processing error check"
Write-Output "---------------------------------------------------------"
Write-Output ""

# break  ####   NOTE: Skipping National Processing for now   DLE on 8/31/2020

#-----------------------------------------------------------------------
# Run national level analyses (based on reserve-specific output):
#-----------------------------------------------------------------------

# Write initialization message:
Write-Output ""
Write-Output "---------------------------------------------------------"
Write-Output "* Processing national level reports"
Write-Output "*"
Write-Output ""

# Copy updated code to National Folder
Copy-Item -Path "$natl_template\*" -Destination $nat_folder -Recurse -Force

# Run script:
Set-Location $nat_folder
$Rcommand = "R.exe --vanilla -f R\01_Generate_National_Summaries.R"
Invoke-Expression $Rcommand

Write-Output "Check for National-level processing errors"
Write-Output ""
Select-String -Pattern "Error" *.log

Set-Location $root     #back to root level

# Zip national level reports:
$zsrc = "$($nat_folder)"
$zdest = "$($dist_folder)\$($nat_folder_local).zip"

if (Test-Path $zdest) {
    Remove-Item $zdest -Force
}
[System.IO.Compression.ZipFile]::CreateFromDirectory($zsrc, $zdest)

# Write completion message:
Write-Output ""
Write-Output "*"
Write-Output "* National level reports have been completed"
Write-Output "---------------------------------------------------------"


# Stop logging script output
Stop-Transcript
