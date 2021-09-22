clear

#-----------------------------------------------------------------------
# Initializing Variables:
#-----------------------------------------------------------------------
$root = $PSScriptRoot
Set-Location $root

Add-Type -AssemblyName "System.IO"
Add-Type -AssemblyName "System.IO.Compression.FileSystem"

$site_lst = @()                             # initialize list
$data_path = "$root\00_DATA\"		        #Folder to retrieve reserve data from (relative)

$hout_folder = "handoff_files"				#Subfolder in reserve folder to retrieve result files from
$nat_folder = "National_Level_Template"		#National template folder to move result files to

$Rmaster = "temp.R"
$dist_folder = "00_Reserve_distrib_files"

# Content for temporary R script to support automation w/ env. variables:
#$targ_year = 2016
#$year_start = 2007
#$year_end = 2016

#-----------------------------------------------------------------------
# Create folder to hold reserve zipped folders:
#-----------------------------------------------------------------------
New-Item -ItemType Directory -Force -Path $root\$dist_folder

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


#-----------------------------------------------------------------------
# Process reserve sites & run reserve analyses:
#-----------------------------------------------------------------------
Foreach ($site in $site_lst) {

    # Write initialization message:
    Write-Output ""
    Write-Output ""
    Write-Output "********************************************************"
	Write-Output "* Processing reserve '$($site)'"
    Write-Output "********************************************************"
    Write-Output ""

    # Copy all files for this site to "data" subfolder (force overwrite):
    Get-ChildItem -Path $data_path -filter $site*.csv | Copy-Item -Destination $root\$site\data\ -Force

	# Change directory and remove existing "handoff" and "output" files:
	Set-Location $root\$site
	Remove-Item $root\$site\$hout_folder\* -Force -Recurse    #delete "handoff" files

    Get-ChildItem -Path $root\$site\output -Recurse -force | Where-Object { -not ($_.psiscontainer) } | Remove-Item -Force    #delete "output" files

    # Create temporary master script ("temp.R") - must be encoded in UTF-8!:
    $tmpfile = "$($root)\$($site)\$($Rmaster)"
    [System.IO.File]::WriteAllLines($tmpfile, $Rlines, [System.Text.UTF8Encoding]($False))

	# Run master R script:
	$Rcommand = "R.exe --vanilla -f $($Rmaster)"
	Invoke-Expression $Rcommand

	Remove-Item $tmpfile -Force


    # Move reserve handoff files to national handoff folder:
	Set-Location ..			#back to main folder

	Move-Item $root\$site\$hout_folder\* $root\$nat_folder\$hout_folder -Force
	
    # Zip up all reserve files:
    $zsrc = "$($root)\$($site)\"
    $zdest = "$($root)\$($dist_folder)\$($site).zip"

    if (Test-Path $zdest) {
	    Remove-Item $zdest -Force
    }

    [System.IO.Compression.ZipFile]::CreateFromDirectory($zsrc, $zdest)

    # Write completion message:
    Write-Output ""
    Write-Output ""
    Write-Output "********************************************************"
	Write-Output "* Completed reserve '$($site)'"
    Write-Output "********************************************************"
    Write-Output ""
}

#-----------------------------------------------------------------------
# Run national level analyses (based on reserve-specific output):
#-----------------------------------------------------------------------

# Write initialization message:
Write-Output ""
Write-Output ""
Write-Output "********************************************************"
Write-Output "* Processing national level reports"
Write-Output "********************************************************"
Write-Output ""

# Run script:
Set-Location $root\$nat_folder
$Rcommand = "R.exe --vanilla -f R\01_Generate_National_Summaries.R"
Invoke-Expression $Rcommand

Set-Location $root     #back to root level

# Zip national level reports:
$zsrc = "$($root)\$($nat_folder)"
$zdest = "$($root)\$($dist_folder)\$($nat_folder).zip"

[System.IO.Compression.ZipFile]::CreateFromDirectory($zsrc, $zdest)


# Write completion message:
Write-Output ""
Write-Output "********************************************************"
Write-Output "* National level reports have been completed"
Write-Output "********************************************************"
