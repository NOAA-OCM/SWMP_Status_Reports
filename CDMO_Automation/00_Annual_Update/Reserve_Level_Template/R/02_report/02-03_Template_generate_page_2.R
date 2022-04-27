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
doc <- ph_with(doc, value = external_img(src = img_map,  
                                         width = 3.3,height = 3.15),
               use_loc_size = FALSE,
               location = ph_location(left = 5, top = 0.29))
# Left-hand plot
doc <- ph_with(doc, value = external_img(src = img_plot_1, 
                                         width = 3.25, height = 2),
               use_loc_size = FALSE,
               location = ph_location(left = 0.25, top = 8.07))
# Right hand plot
doc <- ph_with(doc, value = external_img(src = img_plot_2, 
                                         width = 3.25, height = 2),
               use_loc_size = FALSE,
               location = ph_location(left = 3.56, top = 8.07))

# Add trend title
doc <- ph_with(doc, value = fpar(str = txt_trend_ttl, fp_t = format_trend_ttl),
               location = ph_location(left = 0.15, top = 0.33, 
                                      width = 4.6, height = 0.51))

#Add trend facts
fact1 <- fpar(ftext(txt_trend_1_a, prop = format_trend_a),
              ftext(txt_trend_1_b, prop = format_trend_b))
doc <- ph_with(doc, value = fact1,
               location = ph_location(left = 0.15, top = 0.79,
                                      width = 4.8, height = 0.55))

fact2 <- fpar(ftext(txt_trend_2_a, prop = format_trend_a),
              ftext(txt_trend_2_b, prop = format_trend_b))
doc <- ph_with(doc, value = fact2,
               location = ph_location(left = 0.15, top = 1.34, 
                                      width = 4.8, height = 0.55))

fact3 <- fpar(ftext(txt_trend_3_a, prop = format_trend_a),
              ftext(txt_trend_3_b, prop = format_trend_b))
doc <- ph_with(doc, value = fact3,
               location = ph_location(left = 0.15, top = 1.82, 
                                      width = 4.8, height = 0.55))

fact4 <- fpar(ftext(txt_trend_4_a, prop = format_trend_a),
              ftext(txt_trend_4_b, prop = format_trend_b))
doc <- ph_with(doc, value = fact4,
               location = ph_location(left = 0.15, top = 2.36, 
                                      width = 4.8, height = 0.55))

fact5 <- fpar(ftext(txt_trend_5_a, prop = format_trend_a),
              ftext(txt_trend_5_b, prop = format_trend_b))
doc <- ph_with(doc, value = fact5,
               location = ph_location(left = 0.15, top = 2.84, 
                                      width = 4.8, height = 0.55))


# Add trend table title
doc <- ph_with(doc, value = fpar(str = txt_table_ttl, fp_t = format_table_ttl),
               location = ph_location(left = 0.14, top = 3.46, 
                                      width = 4.8, height = 0.4))

# Add trend table caption (highlights years of data used)
doc <- ph_with(doc, value = fpar(str = txt_table_caption, fp_t = format_table_caption),
               location = ph_location(left = 2.88, top = 6.58,
                                      width = 2.2, height = 0.2))

# Add map title to sampling map
doc <- ph_with(doc, value = fpar(str = txt_map_ttl, fp_t = format_map_ttl),
               location = ph_location(left = 4.95, top = 0.31, 
                                      width = 3.4, height = 0.66))
# Add plot title
doc <- ph_with(doc, value = fpar(str = txt_plot_ttl, fp_t = format_plot_ttl),
               location = ph_location(left = 0.15, top = 7.39, 
                                      width = 7.3, height = 0.4))

# Add plot subtitle
doc <- ph_with(doc, fpar(str = txt_plot_subttl, fp_t = format_plot_subttl),
               location = ph_location(left = 0.16, top = 7.68, 
                                      width = 7.3, height = 0.34))

# Add plot captions
doc <- ph_with(doc, value = fpar(str = txt_plot_caption_1, fp_t = format_plot_caption),
               location = ph_location(left = 0.16, top = 10.08, 
                                      width = 3.1, height = 0.75))

doc <- ph_with(doc, value = fpar(str = txt_plot_caption_2, fp_t = format_plot_caption),
               location = ph_location(left = 3.48, top = 10.08, 
                                      width = 3.1, height = 0.75))

# Add flextables for trends
## met table
doc <- ph_with(doc, value = ls_met_ft[[1]], location = ph_location(left = 0.27, top = 3.86))
doc <- ph_with(doc, value = ls_met_ft[[2]], location = ph_location(left = 1.94, top = 3.86))

## wq table
doc <- ph_with(doc, value = ls_wq_ft[[1]], location = ph_location(left = 0.27, top = 4.38))
doc <- ph_with(doc, value = ls_wq_ft[[2]], location = ph_location(left = 1.94, top = 4.38))

## nut table
doc <- ph_with(doc, value = ls_nut_ft[[1]], location = ph_location(left = 0.27, top = 5.5))
doc <- ph_with(doc, value = ls_nut_ft[[2]], location = ph_location(left = 1.94, top = 5.5))
