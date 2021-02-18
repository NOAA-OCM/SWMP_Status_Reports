# National level template variables ----

# Load year range and target year from variable spreadsheet
wb_name <- 'template_files/text/National_Level_Template_Text_Entry.xlsx'
sheets <- c('Years_of_Interest', 'Page_1'
            , 'Page_2_NERRS_in_Trend_Table', 'Page_2_Param_in_Trend_Table'
            , 'Page_3', 'Page_4')
			
if(!exists('year_range')) {year_range <- read_xlsx(path = wb_name, sheet = sheets[1])[[1]]}
if(!exists('target_year')) {target_year <- read_xlsx(path = wb_name, sheet = sheets[1])[[2]][1]}

# Load text variables
pg1 <- readxl::read_xlsx(wb_name, sheet = sheets[2])
pg3 <- readxl::read_xlsx(wb_name, sheet = sheets[5])
pg4 <- readxl::read_xlsx(wb_name, sheet = sheets[6])

# Load reserve names and abbreviations
res <- readxl::read_xlsx(path = wb_name, sheet = sheets[2])

# Load trend table variables
trend_tbl_vars <- readxl::read_xlsx(path = wb_name, sheet = sheets[3])[[1]]

# PAGE ONE VARIABLES -----
txt_rpt_ttl <- pg1 %>% filter(Variable_Name == 'txt_rpt_ttl') %>% .$Text
txt_nerr_desc_ttl <- pg1 %>% filter(Variable_Name == 'txt_nerr_desc_ttl') %>% .$Text
txt_nerr_desc <- pg1 %>% filter(Variable_Name == 'txt_nerr_desc') %>% .$Text %>% paste(., ' For more information go to: ', sep = '')
txt_nerr_website <- pg1 %>% filter(Variable_Name == 'txt_nerr_website') %>% .$Text

img_intro <- pg1 %>% filter(Variable_Name == 'img_intro') %>% .$File_Name %>% paste('template_files/images/', ., sep = '')
img_national_map <- pg1 %>% filter(Variable_Name == 'img_national_map') %>% .$File_Name

# PAGE TWO VARIABLES -----
## Page two only requires a trend table data caption. The caption listed for page three will
## also be used for page two.
txt_table_caption <- pg3 %>% filter(Variable_Name == 'txt_plot_data_caption') %>%
  .$Text %>% 
  paste(., ' ', year_range[1], '-', year_range[2], ', LOC = Sample Location', sep = '')

# PAGE THREE VARIABLES -----
# images
img_trend_plot_1 <- pg3 %>% filter(Variable_Name == 'img_trend_plot_1') %>% .$File_Name
img_trend_plot_2 <- pg3 %>% filter(Variable_Name == 'img_trend_plot_2') %>% .$File_Name

# text
txt_trend_plot_ttl_1 <- pg3 %>% filter(Variable_Name == 'txt_trend_plot_ttl_1') %>% .$Text
txt_trend_plot_ttl_2 <- pg3 %>% filter(Variable_Name == 'txt_trend_plot_ttl_2') %>% .$Text
txt_trend_plot_caption_1 <- pg3 %>% filter(Variable_Name == 'txt_trend_plot_caption_1') %>% .$Text
txt_trend_plot_caption_2 <- pg3 %>% filter(Variable_Name == 'txt_trend_plot_caption_2') %>% .$Text
txt_plot_data_caption <- pg3 %>% filter(Variable_Name == 'txt_plot_data_caption') %>%
  .$Text %>% 
  paste(., ' ', year_range[1], '-', year_range[2], sep = '')

# PAGE FOUR VARIABLES -----
# images
img_header <- pg4 %>% filter(Variable_Name == 'img_header') %>% .$File_Name %>% paste('template_files/images/', ., sep = '')
img_background <- pg4 %>% filter(Variable_Name == 'img_background') %>% .$File_Name %>% paste('template_files/images/', ., sep = '')

# text
txt_contact_ttl <- pg4 %>% filter(Variable_Name == 'txt_contact_nm') %>% .$Text
txt_contact_highlight <- pg4 %>% filter(Variable_Name == 'txt_contact_nm') %>% .$Text
txt_contact_nm <- pg4 %>% filter(Variable_Name == 'txt_contact_nm') %>% .$Text %>% paste('Contact', .)
txt_contact_email <- pg4 %>% filter(Variable_Name == 'txt_contact_email') %>% .$Text
txt_contact_phone <- pg4 %>% filter(Variable_Name == 'txt_contact_phone') %>% .$Text