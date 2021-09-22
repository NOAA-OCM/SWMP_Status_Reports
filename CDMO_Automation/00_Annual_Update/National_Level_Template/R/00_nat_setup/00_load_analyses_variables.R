# Load libraries ----
library(SWMPrExtension)
library(readxl)
library(dplyr)
library(tidyr)

# Variables for MET trend maps -----------------
# Load year range and target year from variable spreadsheet
wb_name <- 'figure_files/National_Level_Plotting_Variables.xlsx'
sheets <- c('Parameters', 'Reserve_Regions')

# Load parameter names
par <- read_xlsx(path = wb_name, sheet = sheets[1])

# filter for MET parameters (for mapping)
par <- par %>% filter(Parameter_Category == 'met')


# Variables for national trends summary ----------------
# Load reserves and generate a data.frame of unique regions 
# to make sure that all regions are included in summary table
reserve <- read_xlsx(path = wb_name, sheet = sheets[2])

reserve_region <- reserve[, c(1, 3)]

unique_regions <- reserve_region %>%
  group_by(Region) %>% 
  summarise(reserve_ct = n())