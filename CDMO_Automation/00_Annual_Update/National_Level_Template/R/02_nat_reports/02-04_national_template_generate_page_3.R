# Add third slide ----
doc <- add_slide(doc, layout = "Page Three", master = "Office Theme")

# Set text formatting ----
format_trend_plot_ttl <- fp_text(color = '#444E65', font.size = 20, font.family = "Calibri Light", bold = T)
format_plot_caption <- fp_text(color = '#404040', font.size = 14, font.family = "Garamond", italic = F) 
format_plot_data_caption <- fp_text(color = '#7F7F7F', font.size = 10, font.family = "Garamond", italic = T) 

# Add elements to template ----
# trend map 1
doc <- doc %>% ph_with_img_at(src = img_trend_plot_1
                              , left = 0, top = 2.78
                              , width = 5.38, height = 3.58)

# trend map 2
doc <- doc %>% ph_with_img_at(src = img_trend_plot_2
                              , left = 0, top = 6.99
                              , width = 5.38, height = 3.58)

# Add trend map 1 title
doc <- doc %>% ph_empty_at(left = 0.15, top = 2.33, width = 2.67, height = 0.44)
doc <- doc %>% ph_add_par(id_chr = "4") %>% 
  ph_add_text(str = txt_trend_plot_ttl_1, type = 'body', id_chr = "4", style = format_trend_plot_ttl)

# Add trend map 1 caption
doc <- doc %>% ph_empty_at(left = 4.98, top = 2.65, width = 3.4, height = 2.2)
doc <- doc %>% ph_add_par(id_chr = "5") %>% 
  ph_add_text(str = txt_trend_plot_caption_1, type = 'body', id_chr = "5", style = format_plot_caption)

# Add trend map 1 data caption
doc <- doc %>% ph_empty_at(left = 0.15, top = 6.23, width = 2.67, height = 0.44)
doc <- doc %>% ph_add_par(id_chr = "6") %>% 
  ph_add_text(str = txt_plot_data_caption, type = 'body', id_chr = "6", style = format_plot_data_caption)

# Add trend map 2 title
doc <- doc %>% ph_empty_at(left = 0.15, top = 6.54, width = 3.06, height = 0.44)
doc <- doc %>% ph_add_par(id_chr = "7") %>% 
  ph_add_text(str = txt_trend_plot_ttl_2, type = 'body', id_chr = "7", style = format_trend_plot_ttl)

# Add trend map 2 caption
doc <- doc %>% ph_empty_at(left = 4.98, top = 6.68, width = 3.4, height = 2.2)
doc <- doc %>% ph_add_par(id_chr = "8") %>% 
  ph_add_text(str = txt_trend_plot_caption_2, type = 'body', id_chr = "8", style = format_plot_caption)

# Add trend map 2 data caption
doc <- doc %>% ph_empty_at(left = 0.13, top = 10.43, width = 2.25, height = 0.28)
doc <- doc %>% ph_add_par(id_chr = "9") %>% 
  ph_add_text(str = txt_plot_data_caption, type = 'body', id_chr = "9", style = format_plot_data_caption)