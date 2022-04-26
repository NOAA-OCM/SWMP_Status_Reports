# Add third slide ----
doc <- add_slide(doc, layout = "Page Three", master = "Office Theme")

# Set text formatting ----
format_cs_title <- fp_text(color = '#595959', font.size = 18, font.family = "Calibri-Light", bold = F)
format_cs_intro <- fp_text(color = 'white', font.size = 14, font.family = "Garamond", bold = F)
format_cs_plot_ttl <- fp_text(color = '#444E65', font.size = 18, font.family = "Calibri-Light", bold = F) #444E65 is bluish
format_cs_plot_caption <- fp_text(color = '#404040', font.size = 12, font.family = "Garamond", bold = F) #404040 is grayish
format_cs_map_ttl <- fp_text(color = '#444E65', font.size = 18, font.family = "Calibri-Light", bold = F)
format_cs_map_caption <- fp_text(color = '#404040', font.size = 12, font.family = "Garamond", bold = F) #404040 is grayish
format_cs_outreach_ttl <- fp_text(color = 'white', font.size = 18, font.family = "Calibri-Light", bold = F)
format_cs_outreach_point <- fp_text(color = 'white', font.size = 14, font.family = "Garamond", bold = F)

# Add elements to template ----
# trend map
doc <- doc %>% ph_with(value = external_img(src = img_cs_map, width = 3.2, height = 3.21),
                       use_loc_size = FALSE,
                       location = ph_location(left =  5.08, top = 2.19))
# plot 1
doc <- doc %>% ph_with(value = external_img(src = img_cs_plot_1, width = 3.26, height = 1.9),
                       use_loc_size = FALSE,
                       location = ph_location(left =  0.26, top = 2.5))
# plot 2
doc <- doc %>% ph_with(value = external_img(src = img_cs_plot_2, width = 3.26, height = 1.9),
                       use_loc_size = FALSE,
                       location = ph_location(left =  0.26, top = 6.16))

# background image for outreach section
doc <- doc %>% ph_with(value = external_img(src = img_cs_background, width = 3.2, height = 4.27),
                       use_loc_size = FALSE,
                       location = ph_location(left =  5.08, top = 5.36))

# Add case study title
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.14, top = 0.18, width = 7, height = 0.4))
doc <- doc %>% ph_with(value = fpar(id_chr = "6")) %>% 
  ph_with(value = fpar(str = txt_cs_ttl, type = 'body', id_chr = "6", 
                       style = format_cs_title))

# Add case study intro description
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 0.8, width = 8.1, height = 1.3))
doc <- doc %>% ph_with(value = fpar(id_chr = "7")) %>% 
  ph_with(value = fpar(str = txt_cs_intro, type = 'body', id_chr = "7", 
                       style = format_cs_intro))

# Add plot 1 title and caption
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 2.16, width = 2, height = 0.34))
doc <- doc %>% ph_with(value = fpar(id_chr = "8")) %>% 
  ph_with(value = fpar(str = txt_cs_plot_ttl_1, type = 'body', id_chr = "8", 
                       style = format_cs_plot_ttl))

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.16, top = 4.45, width = 4.6, height = 1.43))
doc <- doc %>% ph_with(value = fpar(id_chr = "9")) %>% 
  ph_with(value = fpar(str = txt_cs_plot_caption_1, type = 'body', id_chr = "9", 
                       style = format_cs_plot_caption))

# Add plot 2 title and caption
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 5.8, width = 2, height = 0.34))
doc <- doc %>% ph_with(value = fpar(id_chr = "10")) %>% 
  ph_with(value = fpar(str = txt_cs_plot_ttl_2, type = 'body', id_chr = "10", 
                       style = format_cs_plot_ttl))

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.16, top = 8.09, width = 4.6, height = 1.43))
doc <- doc %>% ph_with(value = fpar(id_chr = "11")) %>% 
  ph_with(value = fpar(str = txt_cs_plot_caption_2, type = 'body', id_chr = "11", 
                       style = format_cs_plot_caption))

# Add trend map title and caption
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 5.08, top = 2.15, width = 3.2, height = 0.49))
doc <- doc %>% ph_with(value = fpar(id_chr = "12")) %>% 
  ph_with(value = fpar(str = txt_cs_map_ttl, type = 'body', id_chr = "12", 
                       style = format_cs_map_ttl))

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 5.08, top = 2.95, width = 2.11, height = 1.36))
doc <- doc %>% ph_with(value = fpar(id_chr = "13")) %>% 
  ph_with(value = fpar(str = txt_cs_map_caption, type = 'body', id_chr = "13", 
                       style = format_cs_map_caption))

# Add outreach title
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 5.08, top = 5.53, width = 3.25, height = 0.71))
doc <- doc %>% ph_with(value = fpar(id_chr = "14")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_ttl, type = 'body', id_chr = "14", 
                       style = format_cs_outreach_ttl))

# Add outreach points
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 5.14, top = 6.18, 
                                              width = 3.05, height = 3.4))
doc <- doc %>% ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_1, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point)) %>% 
  ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_2, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point)) %>% 
  ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_3, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point)) %>% 
  ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_4, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point)) %>% 
  ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_5, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point)) %>% 
  ph_with(value = fpar(id_chr = "15")) %>% 
  ph_with(value = fpar(str = txt_cs_outreach_point_6, type = 'body', 
                       id_chr = "15", style = format_cs_outreach_point))
