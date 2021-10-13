# Reserve level template variables ----

# Load year range and target year from variable spreadsheet
wb_name <- 'figure_files/Reserve_Level_Plotting_Variables.xlsx'
sheets <- c('Flags', 'Years_of_Interest', 'Seasons', 'Mapping', 'Bonus_Settings'
            , 'Basic_Plotting', 'Threshold_Plots', 'Threshold_Identification')
			
if(!exists('year_range')) {year_range <- readxl::read_xlsx(path = wb_name, sheet = sheets[2])[[1]]}
if(!exists('target_year')) {target_year <- readxl::read_xlsx(path = wb_name, sheet = sheets[2])[[2]][1]}

# Load reserve name and abbreviation based on data files in the data folder
res <- get_reserve('data/')
res.abb <- get_site_code('data/')

# Load text variables
wb_name <- 'template_files/text/Reserve_Level_Template_Text_Entry.xlsx'

pg1 <- readxl::read_xlsx(wb_name, sheet = 1)
pg2 <- readxl::read_xlsx(wb_name, sheet = 2)
pg3 <- readxl::read_xlsx(wb_name, sheet = 3)
pg4 <- readxl::read_xlsx(wb_name, sheet = 4)

# PAGE ONE VARIABLES -----
# Images
img_intro <- pg1 %>% filter(Variable_Name == 'img_intro') %>% .$File_Name %>% paste('template_files/images/', ., sep = '')

# Text for title
txt_rpt_ttl <- pg1 %>% filter(Variable_Name == 'txt_rpt_ttl') %>%  .$Text
txt_sub_ttl_1 <- pg1 %>% filter(Variable_Name == 'txt_sub_ttl_1') %>%  .$Text
txt_sub_ttl_2 <- pg1 %>% filter(Variable_Name == 'txt_sub_ttl_2') %>%  .$Text

# Text for NERR description
txt_nerr_name <- pg1 %>% filter(Variable_Name == 'txt_nerr_name') %>%  .$Text
txt_nerr_desc <- pg1 %>% filter(Variable_Name == 'txt_nerr_desc') %>%  .$Text %>% paste(., 'For more information go to: ')
txt_nerr_website <- pg1 %>% filter(Variable_Name == 'txt_nerr_website') %>%  .$Text

# Text for target year highlights
txt_highlight_ttl <- pg1 %>% filter(Variable_Name == 'txt_highlight_ttl') %>%  .$Text
txt_highlight_1 <- pg1 %>% filter(Variable_Name == 'txt_highlight_1') %>%  .$Text
txt_highlight_2 <- pg1 %>% filter(Variable_Name == 'txt_highlight_2') %>%  .$Text
txt_highlight_3 <- pg1 %>% filter(Variable_Name == 'txt_highlight_3') %>%  .$Text
txt_highlight_4 <- pg1 %>% filter(Variable_Name == 'txt_highlight_4') %>%  .$Text

# PAGE TWO VARIABLES -----
# Plots
img_map <- pg2 %>% filter(Variable_Name == 'img_map') %>% .$File_Name
img_plot_1 <- pg2 %>% filter(Variable_Name == 'img_plot_1') %>% .$File_Name
img_plot_2 <- pg2 %>% filter(Variable_Name == 'img_plot_2') %>% .$File_Name

# Text for trends
txt_trend_ttl <- pg2 %>% filter(Variable_Name == 'txt_trend_ttl') %>% .$Text
txt_trend_1_a <- pg2 %>% filter(Variable_Name == 'txt_trend_1') %>% .$Parameter %>% paste(., ' ', sep = '')
txt_trend_1_b <- pg2 %>% filter(Variable_Name == 'txt_trend_1') %>% .$Text
txt_trend_2_a <- pg2 %>% filter(Variable_Name == 'txt_trend_2') %>% .$Parameter %>% paste(., ' ', sep = '')
txt_trend_2_b <- pg2 %>% filter(Variable_Name == 'txt_trend_2') %>% .$Text
txt_trend_3_a <- pg2 %>% filter(Variable_Name == 'txt_trend_3') %>% .$Parameter %>% paste(., ' ', sep = '')
txt_trend_3_b <- pg2 %>% filter(Variable_Name == 'txt_trend_3') %>% .$Text
txt_trend_4_a <- pg2 %>% filter(Variable_Name == 'txt_trend_4') %>% .$Parameter %>% paste(., ' ', sep = '')
txt_trend_4_b <- pg2 %>% filter(Variable_Name == 'txt_trend_4') %>% .$Text
txt_trend_5_a <- pg2 %>% filter(Variable_Name == 'txt_trend_5') %>% .$Parameter %>% paste(., ' ', sep = '')
txt_trend_5_b <- pg2 %>% filter(Variable_Name == 'txt_trend_5') %>% .$Text

# Text for plots
txt_plot_ttl <- pg2 %>% filter(Variable_Name == 'txt_plot_ttl') %>% .$Text
txt_plot_subttl <- pg2 %>% filter(Variable_Name == 'txt_plot_subttl') %>% .$Text
txt_plot_caption_1 <- pg2 %>% filter(Variable_Name == 'txt_plot_caption_1') %>% .$Text
txt_plot_caption_2 <- pg2 %>% filter(Variable_Name == 'txt_plot_caption_2') %>% .$Text

# Text for trend table
txt_table_ttl <- pg2 %>% filter(Variable_Name == 'txt_table_ttl') %>% .$Text
txt_table_caption <- pg2 %>% filter(Variable_Name == 'txt_table_caption') %>% .$Text %>%  paste(., ' ', year_range[1], '-', year_range[2], sep = '')

# Text for map & side bar
txt_map_ttl <- pg2 %>% filter(Variable_Name == 'txt_map_ttl') %>% .$Text %>% paste(res, .)
txt_weather_ttl <- pg2 %>% filter(Variable_Name == 'txt_weather_ttl') %>% .$Text

# PAGE THREE VARIABLES -----
# images
img_cs_map <- pg3 %>% filter(Variable_Name == 'img_cs_map') %>% .$File_Name
img_cs_plot_1 <- pg3 %>% filter(Variable_Name == 'img_cs_plot_1') %>% .$File_Name
img_cs_plot_2 <- pg3 %>% filter(Variable_Name == 'img_cs_plot_2') %>% .$File_Name
img_cs_background <- pg3 %>% filter(Variable_Name == 'img_cs_background') %>% .$File_Name %>% paste('template_files/images/', ., sep = '')

# Text
txt_cs_ttl <- pg3 %>% filter(Variable_Name == 'txt_cs_ttl') %>% .$Text
txt_cs_intro <- pg3 %>% filter(Variable_Name == 'txt_cs_intro') %>% .$Text

txt_cs_plot_ttl_1 <- pg3 %>% filter(Variable_Name == 'txt_cs_plot_ttl_1') %>% .$Text
txt_cs_plot_caption_1 <- pg3 %>% filter(Variable_Name == 'txt_cs_plot_caption_1') %>% .$Text
txt_cs_plot_ttl_2 <- pg3 %>% filter(Variable_Name == 'txt_cs_plot_ttl_2') %>% .$Text
txt_cs_plot_caption_2 <- pg3 %>% filter(Variable_Name == 'txt_cs_plot_caption_2') %>% .$Text

txt_cs_map_ttl <- pg3 %>% filter(Variable_Name == 'txt_cs_map_ttl') %>% .$Text
txt_cs_map_caption <- pg3 %>% filter(Variable_Name == 'txt_cs_map_caption') %>% .$Text

txt_cs_outreach_ttl <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_ttl') %>% .$Text
txt_cs_outreach_point_1 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_1') %>% .$Text
txt_cs_outreach_point_2 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_2') %>% .$Text
txt_cs_outreach_point_3 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_3') %>% .$Text
txt_cs_outreach_point_4 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_4') %>% .$Text
txt_cs_outreach_point_5 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_5') %>% .$Text
txt_cs_outreach_point_6 <- pg3 %>% filter(Variable_Name == 'txt_cs_outreach_point_6') %>% .$Text

# PAGE FOUR VARIABLES -----
# Images
img_nerr_map <- pg4 %>% filter(Variable_Name == 'img_nerr_map') %>% .$File_Name# %>% paste('output/maps/', ., sep = '')

# Text
txt_contact_nm <- pg4 %>% filter(Variable_Name == 'txt_contact_nm') %>% .$Text %>% paste('Contact', .)
txt_contact_email <- pg4 %>% filter(Variable_Name == 'txt_contact_email') %>% .$Text
txt_contact_phone <- pg4 %>% filter(Variable_Name == 'txt_contact_phone') %>% .$Text