# Add second slide ----
doc <- add_slide(doc, layout = "Page Two", master = "Office Theme")

# Set text formatting ----
format_table_caption <- fp_text(color = 'white', font.size = 10, font.family = "Garamond", italic = T, bold = F)
# format_table_caption <- fp_text(color = '#7F7F7F', font.size = 10, font.family = "Garamond", italic = T, bold = F)

# Add elements to template ----
# Add trend table caption (highlights years of data used)
doc <- ph_with(doc, value = empty_content(),
               location = ph_location(left = 4.82, top = 7.56, 
                                      width = 3.62, height = 0.27))
doc <- doc %>% ph_add_par(id_chr = "2") %>% 
  ph_add_text(str = txt_table_caption, type = 'body', id_chr = "2", style = format_table_caption)

# Add flextables for trends
## reserve table
doc <- doc %>% ph_with(value = ls_trend_tbl[[1]], 
                       location = ph_location(left = 0.3, top = 0.71))

## parameter tables
doc <- doc %>% ph_with(value = ls_trend_tbl[[2]], 
                       location = ph_location(left = 2.28, top = 0.71))
doc <- doc %>% ph_with(value = ls_trend_tbl[[3]], 
                       location = ph_location(left = 3.77, top = 0.71))
doc <- doc %>% ph_with(value = ls_trend_tbl[[4]], 
                       location = ph_location(left = 5.27, top = 0.71))
doc <- doc %>% ph_with(value = ls_trend_tbl[[5]], 
                       location = ph_location(left = 6.77, top = 0.71))