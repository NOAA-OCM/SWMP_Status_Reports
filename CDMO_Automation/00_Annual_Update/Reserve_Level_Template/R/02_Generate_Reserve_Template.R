# Load libraries ----
suppressPackageStartupMessages({
  library(SWMPrExtension)
  library(officer)
  library(flextable)
  library(readxl)
  library(dplyr)
})

# Load variables ----
source('R/00_setup/00_load_reserve_template_variables.R')

# GENERATE FLEXTABLES -----
source('R/02_report/02-01_make_flextables.R')

# With parameters loaded, generate the template ----
source('R/02_report/02-02_Template_generate_page_1.R')
source('R/02_report/02-03_Template_generate_page_2.R')
source('R/02_report/02-04_Template_generate_page_3.R')
source('R/02_report/02-05_Template_generate_page_4.R')

print(doc, target = 'template_files/annual_report_raw.pptx')

