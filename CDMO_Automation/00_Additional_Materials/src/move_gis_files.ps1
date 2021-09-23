# Change gis_relative depending on location this script is run from.
$gis_relative = "..\..\00_Annual_Update\Reserve_Level_Template"
$gis_root_old = "$gis_relative\inst\gis\GIS_Process"
$site_lst = Get-ChildItem -Path $gis_root_old
# echo $site_lst
Foreach ($site in $site_lst) {
    $old_dir = "$gis_root_old\$site\Boundaries\Reserve_Boundaries"
    $new_dir = "$gis_relative\inst\gis\$site\"
    if (Test-Path -Path $new_dir) {
        Move-Item -Path $new_dir  "Backup.$new_dir" -Force  #Backup existing distribution files
    }
    New-Item -ItemType Directory -Force -Path $new_dir
    
    # $shapes = Get-ChildItem -Path $old_dir
    # echo $shapes
    Copy-Item -Path "$old_dir\*" $new_dir -Recurse
}