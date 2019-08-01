# Initialize template and add first slide -------
doc <- read_pptx('template_files/empty_template/Reserve_Level_Template.pptx')
doc <- add_slide(doc, layout = "Page One", master = "Office Theme")

# Set text formatting ----
format_ttl <- fp_text(color = "white", font.size = 24, font.family = "Calibri-Light", bold = F)
format_subttl <- fp_text(color = "white", font.size = 16, font.family = "Calibri-Light", bold = F)
format_nerr_nm <- fp_text(color = "white", font.size = 18, font.family = "Calibri-Light", bold = F)
format_nerr_desc <- fp_text(color = "white", font.size = 14, font.family = "Garamond", bold = F)
format_nerr_web <- fp_text(color = "white", font.size = 14, font.family = "Garamond", bold = T)
format_highlight_ttl <- fp_text(color = '#595959', font.size = 24, font.family = "Calibri-Light", bold = F)
format_highlight <- fp_text(color = '#404040', font.size = 14, font.family = "Garamond", bold = F)

# Add elements to template ----
# Add cover image
doc <- doc %>% ph_with_img_at(src = img_intro
                              , width = 8.1, height = 4.75
                              , left = 0.21, top = 0.29)

# Add  template title
doc <- doc %>% ph_empty_at(left = 0.17, top = 0.42, width = 8.3, height = 0.51)
doc <- doc %>% ph_add_par(id_chr = "3") %>% 
  ph_add_text(str = txt_rpt_ttl, type = 'body', id_chr = "3", style = format_ttl)

# Add template subtitle
doc <- doc %>% ph_empty_at(left = 0.18, top = 0.91, width = 4.85, height = 0.71)
doc <- doc %>% ph_add_par(id_chr = "4") %>% 
  ph_add_text(str = txt_sub_ttl_1 , type = 'body', id_chr = "4", style = format_subttl) %>% 
  ph_add_par(id_chr = "3") %>% 
  ph_add_text(str = txt_sub_ttl_2, type = 'body', id_chr = "4", style = format_subttl)

# Add NERR name for description
doc <- doc %>% ph_empty_at(left = 0.18, top = 5.08, width = 4.1, height = 0.62)
text_format <- doc <- doc %>% ph_add_par(id_chr = "5") %>% 
  ph_add_text(str = txt_nerr_name
              , type = 'body', id_chr = "5", style = format_nerr_nm)

# Add NERR description
doc <- doc %>% ph_empty_at(left = 0.19, top = 5.73, width = 3.8, height = 3.5)
doc <- doc %>% ph_add_par(id_chr = "6") %>% 
  ph_add_text(str = txt_nerr_desc, type = 'body', id_chr = "6", style = format_nerr_desc)

# Add NERR website to description
doc <- doc %>% ph_empty_at(left = 0.19, top = 8.69, width = 2.94, height = 0.31)
doc <- doc %>% ph_add_par(id_chr = "7") %>% 
  ph_add_text(str = txt_nerr_website, type = 'body', id_chr = "7", style = format_nerr_web)

# add highlights title
doc <- doc %>% ph_empty_at(left = 4.3, top = 5.08, width = 3.6, height = 0.9)
doc <- doc %>% ph_add_par(id_chr = "8") %>%
  ph_add_text(str = paste(target_year, txt_highlight_ttl), type = 'body', id_chr = "8", style = format_highlight_ttl)

# add highlights
doc <- doc %>% ph_empty_at(left = 4.32, top = 5.9, width = 3.6, height = 0.62)
doc <- doc %>% ph_add_par(id_chr = "9") %>%
  ph_add_text(str = txt_highlight_1, type = 'body', id_chr = "9", style = format_highlight)

doc <- doc %>% ph_empty_at(left = 4.32, top = 6.94, width = 3.6, height = 0.62)
doc <- doc %>% ph_add_par(id_chr = "10") %>%
  ph_add_text(str = txt_highlight_2, type = 'body', id_chr = "10", style = format_highlight)

doc <- doc %>% ph_empty_at(left = 4.32, top = 7.99, width = 3.6, height = 0.62)
doc <- doc %>% ph_add_par(id_chr = "11") %>%
  ph_add_text(str = txt_highlight_3, type = 'body', id_chr = "11", style = format_highlight)

doc <- doc %>% ph_empty_at(left = 4.32, top = 8.98, width = 3.6, height = 0.62)
doc <- doc %>% ph_add_par(id_chr = "12") %>%
  ph_add_text(str = txt_highlight_4, type = 'body', id_chr = "12", style = format_highlight)
