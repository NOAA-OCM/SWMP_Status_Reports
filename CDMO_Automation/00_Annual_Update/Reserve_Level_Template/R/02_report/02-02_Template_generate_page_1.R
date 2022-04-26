# Initialize template and add first slide -------
doc <- read_pptx('template_files/empty_template/Reserve_Level_Template.pptx')
doc <- add_slide(doc, layout = "Page One", master = "Office Theme")

# Set text formatting ----
format_ttl <- fp_text(color = "white", font.size = 24, font.family = "Calibri-Light", bold = FALSE)
format_subttl <- fp_text(color = "white", font.size = 16, font.family = "Calibri-Light", bold = FALSE)
format_nerr_nm <- fp_text(color = "white", font.size = 18, font.family = "Calibri-Light", bold = FALSE)
format_nerr_desc <- fp_text(color = "white", font.size = 14, font.family = "Garamond", bold = FALSE)
format_nerr_web <- fp_text(color = "white", font.size = 14, font.family = "Garamond", bold = TRUE)
format_highlight_ttl <- fp_text(color = '#595959', font.size = 24, font.family = "Calibri-Light", bold = FALSE)
format_highlight <- fp_text(color = '#404040', font.size = 14, font.family = "Garamond", bold = FALSE)

# Add elements to template ----
# Add cover image
doc <- ph_with(doc, value = external_img(src = img_intro),
               location = ph_location_label("Picture Placeholder 10"))

# Add  template title
doc <- ph_with(doc, fpar(txt_rpt_ttl, fp_t = format_ttl),
               location = ph_location_label("Title 27"))

# Add template subtitle
doc <- ph_with(doc, fpar(c(txt_sub_ttl_1, txt_sub_ttl_2), fp_t = format_subttl),
               location = ph_location_label("Date Placeholder 28"))

# Add NERR name for description
doc <- ph_with(doc, fpar(str = txt_nerr_name, fp_t = format_nerr_nm), 
          location = ph_location(left = 0.18, top = 5.08, 
                                 width = 4.1, height = 0.62))

# Add NERR description
doc <- ph_with(doc, fpar(str = txt_nerr_desc, fp_t = format_nerr_desc), 
          location = ph_location(left = 0.19, top = 5.73, 
                                 width = 3.8, height = 3.5))

# Add NERR website to description
doc <- ph_with(doc, fpar(str = txt_nerr_website, fp_t = format_nerr_web),
               location = ph_location(left = 0.19, top = 8.69,
                                      width = 3.8, height = 0.31))

# add highlights title
doc <- ph_with(doc, fpar(str = paste(target_year, txt_highlight_ttl), 
                         fp_t = format_highlight_ttl),
               location = ph_location(left = 4.3, top = 5.08, 
                                      width = 3.6, height = 0.9))

# add highlights
# doc <- doc %>% ph_with(value = empty_content())
doc <- ph_with(doc, value = fpar(str = txt_highlight_1, fp_t = format_highlight), 
          location = ph_location(left = 4.32, top = 5.9, 
                                 width = 3.6, height = 0.62))

doc <- ph_with(doc, value = fpar(str = txt_highlight_2, fp_t =format_highlight),
               location = ph_location(left = 4.32, top = 6.94,
                                      width = 3.6, height = 0.62))

doc <- ph_with(doc, value = fpar(str = txt_highlight_3, fp_t =format_highlight),
               location = ph_location(left = 4.32, top = 7.99,
                                      width = 3.6, height = 0.62))

doc <- ph_with(doc, value = fpar(str = txt_highlight_4, fp_t =format_highlight), 
               location = ph_location(left = 4.32, top = 8.98, 
                                      width = 3.6, height = 0.62))
