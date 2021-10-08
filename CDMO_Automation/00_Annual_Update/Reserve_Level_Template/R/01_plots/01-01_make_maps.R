##################################################################
# This script generates a NERRS national map that highlights    ##
# the reserve of interest and a station map at the reserve      ##
# level                                                         ##
#                                                               ##
# It performs the following actions:                            ##
### res_national_map()                                          ##
### res_local_map()                                             ##
##################################################################

# GENERATE RESERVE MAPS ---------
## National map
message("Making maps")
us_map_ttl <- paste(getwd(),'/output/maps/NERR_system_map_', res_abb, '.png', sep = '')

nerr_states <- c('01', '02', '06', '10', '12', '13', '15'
                 , '23', '24', '25', '28', '33', '34', '36', '37', '39'
                 , '41', '44', '45', '48', '51', '53', '55', '72')

us_map <- res_national_map(highlight_states = nerr_states, highlight_reserves = res_abb)

new_dir_result <- check_make_dir(us_map_ttl)
ggsave(filename = us_map_ttl, plot = us_map, width = 6, height = 4, units = 'in', dpi = 300)

# Reserve level map
res_map_ttl <- paste(getwd(), '/output/maps/', res_abb, '_reserve_map.png', sep = '')

res_map <- res_local_map(nerr_site_id = res_abb
                         , stations = sites_to_map
                         , bbox = res_bbox
                         , shp = res_spatial
                         , station_labs = res_map_station_labels
                         , lab_loc = map_labels
                         # , scale_pos = scale_pos
                         )

new_dir_result <- check_make_dir(res_map_ttl)
tmap_save(res_map, file = res_map_ttl, width = 5, height = 5, units = "in")
message("End of maps")
