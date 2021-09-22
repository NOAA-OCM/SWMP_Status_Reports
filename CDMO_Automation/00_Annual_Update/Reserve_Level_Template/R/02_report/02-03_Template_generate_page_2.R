# Add second slide ----
doc <- add_slide(doc, layout = "Page Two", master = "Office Theme")

# Set text formatting ----
format_trend_ttl <- fp_text(color = '#444E65', font.size = 18, font.family = "Calibri-Light", bold = TRUE)
format_trend_a <- fp_text(color = '#444E65', font.size = 16, font.family = "Garamond", bold = TRUE)
format_trend_b <- fp_text(color = '#404040', font.size = 16, font.family = "Garamond", bold = FALSE)
format_table_ttl <- fp_text(color = 'white', font.size = 18, font.family = "Calibri-Light", bold = FALSE)
format_table_caption <- fp_text(color = 'white', font.size = 10, font.family = "Garamond", italic = TRUE, bold = FALSE)
format_map_ttl <- fp_text(color = '#444E65', font.size = 18, font.family = "Calibri-Light", bold = FALSE)
format_plot_ttl <- fp_text(color = '#444E65', font.size = 18, font.family = "Calibri-Light", bold = FALSE)
format_plot_subttl <- fp_text(color = '#444E65', font.size = 16, font.family = "Calibri-Light", bold = FALSE)
format_plot_caption <- fp_text(color = '#404040', font.size = 12, font.family = "Garamond", bold = FALSE)

# Add elements to template ----
# Sampling map
doc <- doc %>% ph_with(value = external_img(src = img_map, width = 3.3, height = 3.15),
                       use_loc_size = FALSE,
                       location = ph_location(left = 5, top = 0.29))
# Left-hand plot
doc <- doc %>% ph_with(value = external_img(src = img_plot_1, width = 3.25, height = 2),
                       use_loc_size = FALSE,
                       location = ph_location(left = 0.25, top = 8.07))
# Right hand plot
doc <- doc %>% ph_with(value = external_img(src = img_plot_2, width = 3.25, height = 2),
                       use_loc_size = FALSE,
                       location = ph_location(left = 3.56, top = 8.07))
# Add trend title
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 0.33, 
                                              width = 4.6, height = 0.51))
doc <- doc %>% ph_add_par(id_chr = "5") %>% 
  ph_add_text(str = txt_trend_ttl, type = 'body', id_chr = "5", style = format_trend_ttl)

#Add trend facts
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 0.79,
                                              width = 4.8, height = 0.55))
doc <- doc %>% ph_add_par(id_chr = "6") %>%
  ph_add_text(str = txt_trend_1_b, type = 'body', id_chr = "6", style = format_trend_b) %>%
  ph_add_text(str = txt_trend_1_a, type = 'body', id_chr = "6", style = format_trend_a)

# doc <- ph_with(doc, fpar(ftext(txt_trend_1_a,format_trend_a)," ", ftext(txt_trend_1_b,format_trend_b)),
#                # location = ph_location_label("Content Placeholder 17")[[1]])
#                location = foobar)

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 1.32, 
                                              width = 4.8, height = 0.55))
doc <- doc %>% ph_add_par(id_chr = "7") %>% 
  ph_add_text(str = txt_trend_2_b, type = 'body', id_chr = "7", style = format_trend_b) %>% 
  ph_add_text(str = txt_trend_2_a, type = 'body', id_chr = "7", style = format_trend_a)

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 1.85, 
                                              width = 4.8, height = 0.55))
doc <- doc %>% ph_add_par(id_chr = "8") %>% 
  ph_add_text(str = txt_trend_3_b, type = 'body', id_chr = "8", style = format_trend_b) %>% 
  ph_add_text(str = txt_trend_3_a, type = 'body', id_chr = "8", style = format_trend_a)
  
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 2.37, 
                                              width = 4.8, height = 0.55))
doc <- doc %>% ph_add_par(id_chr = "9") %>% 
  ph_add_text(str = txt_trend_4_b, type = 'body', id_chr = "9", style = format_trend_b) %>% 
  ph_add_text(str = txt_trend_4_a, type = 'body', id_chr = "9", style = format_trend_a)

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 2.89, 
                                              width = 4.8, height = 0.55))
doc <- doc %>% ph_add_par(id_chr = "10") %>% 
  ph_add_text(str = txt_trend_5_b, type = 'body', id_chr = "10", style = format_trend_b) %>% 
  ph_add_text(str = txt_trend_5_a, type = 'body', id_chr = "10", style = format_trend_a)

# Add trend table title
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.14, top = 3.46, 
                                              width = 4.8, height = 0.4))
doc <- doc %>% ph_add_par(id_chr = "11") %>% 
  ph_add_text(str = txt_table_ttl, type = 'body', id_chr = "11", style = format_table_ttl)

# Add trend table caption (highlights years of data used)
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 2.88, top = 6.58,
                                              width = 2.2, height = 0.2))
doc <- doc %>% ph_add_par(id_chr = "12") %>% 
  ph_add_text(str = txt_table_caption, type = 'body', id_chr = "12", style = format_table_caption)

# Add map title to sampling map
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 4.95, top = 0.31, 
                                              width = 3.4, height = 0.66))
doc <- doc %>% ph_add_par(id_chr = "13") %>% 
  ph_add_text(str = txt_map_ttl, type = 'body', id_chr = "13", style = format_map_ttl)

# Add plot title
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.15, top = 7.39, 
                                              width = 7.3, height = 0.4))
doc <- doc %>% ph_add_par(id_chr = "14") %>% 
  ph_add_text(str = txt_plot_ttl, type = 'body', id_chr = "14", style = format_plot_ttl) 

# Add plot subtitle
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.16, top = 7.68, 
                                              width = 7.3, height = 0.34))

doc <- doc %>% ph_add_par(id_chr = "15") %>% 
  ph_add_text(str = txt_plot_subttl, type = 'body', id_chr = "15", style = format_plot_subttl) 

# Add plot captions
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 0.16, top = 10.08, 
                                              width = 3.1, height = 0.75))
doc <- doc %>% ph_add_par(id_chr = "16") %>% 
  ph_add_text(str = txt_plot_caption_1, type = 'body', id_chr = "16", style = format_plot_caption) 

doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 3.48, top = 10.08, 
                                              width = 3.1, height = 0.75))
doc <- doc %>% ph_add_par(id_chr = "17") %>% 
  ph_add_text(str = txt_plot_caption_2, type = 'body', id_chr = "17", style = format_plot_caption) 

# Add flextables for trends
## met table
doc <- doc %>% ph_with(value = ls_met_ft[[1]], location = ph_location(left = 0.27, top = 3.86))
doc <- doc %>% ph_with(value = ls_met_ft[[2]], location = ph_location(left = 1.94, top = 3.86))

## wq table
doc <- doc %>% ph_with(value = ls_wq_ft[[1]], location = ph_location(left = 0.27, top = 4.38))
doc <- doc %>% ph_with(value = ls_wq_ft[[2]], location = ph_location(left = 1.94, top = 4.38))

## nut table
doc <- doc %>% ph_with(value = ls_nut_ft[[1]], location = ph_location(left = 0.27, top = 5.5))
doc <- doc %>% ph_with(value = ls_nut_ft[[2]], location = ph_location(left = 1.94, top = 5.5))
