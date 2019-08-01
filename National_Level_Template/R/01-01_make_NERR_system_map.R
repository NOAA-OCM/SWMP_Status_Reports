##################################################################
# This script generates seasonal kendall trend maps             ##
# for later use with the national level template                ##
#                                                               ##
# It performs the following actions:                            ##
### res_national_map()                                          ##
#                                                               ##
##################################################################


nerr_states <- c('01', '02', '06', '10', '12', '13', '15'
                 , '23', '24', '25', '28', '33', '34', '36', '37', '39'
                 , '41', '44', '45', '48', '51', '53', '55', '72')

national_map <- res_national_map(highlight_states = nerr_states)

file_nm <- c('output/maps/nerrs_national_map.png')

ggsave(filename = file_nm, plot = national_map, width = 6, height = 4, units = 'in', dpi = 300, bg = 'transparent')
