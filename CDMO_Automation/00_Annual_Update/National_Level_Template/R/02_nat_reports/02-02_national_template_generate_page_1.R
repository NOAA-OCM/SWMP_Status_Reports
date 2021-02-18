# Initialize template and add first slide -------
doc <- read_pptx('template_files/empty_template/National_Level_Template.pptx')
doc <- add_slide(doc, layout = "Page One", master = "Office Theme")

# Set text formatting ----
format_rpt_ttl <- fp_text(color = 'white', font.size = 24, font.family = "Calibri-Light")
format_nerr_desc_ttl <- fp_text(color = 'white', font.size = 18, font.family = "Calibri-Light")
format_nerr_desc <- fp_text(color = 'white', font.size = 14, font.family = "Garamond")
format_nerr_website <- fp_text(color = 'white', font.size = 14, font.family = "Garamond", bold = T)

# Add elements to template ----
# Background image
doc <- doc %>% ph_with_img_at(src = img_intro
                              , left = 0.21, top = 0.29
                              , width = 8.1, height = 4.12)

# National map
doc <- doc %>% ph_with_img_at(src = img_national_map
                              , left = 4.05, top = 5.98
                              , width = 4.4, height = 2.93)

# Add NERRS report title
doc <- doc %>% ph_empty_at(left = 0.16, top = 0.49, width = 8.2, height = 0.5)
doc <- doc %>% ph_add_par(id_chr = "4") %>% 
  ph_add_text(str = txt_rpt_ttl, type = 'body', id_chr = "4", style = format_rpt_ttl)


# Add NERR description title
doc <- doc %>% ph_empty_at(left = 0.17, top = 2.15, width = 6.5, height = 0.6)
doc <- doc %>% ph_add_par(id_chr = "5") %>% 
  ph_add_text(str = txt_nerr_desc_ttl, type = 'body', id_chr = "5", style = format_nerr_desc_ttl)

# Add NERR description
doc <- doc %>% ph_empty_at(left = 0.21, top = 2.59, width = 7.96, height = 1.36)
doc <- doc %>% ph_add_par(id_chr = "6") %>% 
  ph_add_text(str = txt_nerr_desc, type = 'body', id_chr = "6", style = format_nerr_desc)

# Add NERR description website
doc <- doc %>% ph_empty_at(left = 1.66, top = 3.6, width = 2.77, height = 0.34)
doc <- doc %>% ph_add_par(id_chr = "7") %>% 
  ph_add_text(str = txt_nerr_website, type = 'body', id_chr = "7", style = format_nerr_website)
