# Add fourth slide ----
doc <- add_slide(doc, layout = "Page Four", master = "Office Theme")

# Set text formatting ----
format_contact <- fp_text(color = '#404040', font.size = 13, font.family = "Garamond", bold = F)

# Add elements to template ----
# contact text
doc <- doc %>% ph_with(value = empty_content(),
                       location = ph_location(left = 5.75, top = 8.75, 
                                              width = 2.5, height = 0.5))
doc <- doc %>% ph_with(value = fpar(id_chr = "2")) %>%
  ph_with(value = fpar(str = txt_contact_nm, type = 'body', id_chr = "2", 
                       style = format_contact)) %>%
  ph_with(value = fpar(id_chr = "2")) %>%
  ph_with(value = fpar(str = txt_contact_email, type = 'body', id_chr = "2", 
                       style = format_contact)) %>%
  ph_with(value = fpar(id_chr = "2")) %>%
  ph_with(value = fpar(str = txt_contact_phone, type = 'body', id_chr = "2", 
                       style = format_contact))

# National NERR map
doc <- doc %>% ph_with(value = external_img(src = img_nerr_map, width = 4.1, height = 2.82),
                       use_loc_size = FALSE,
                       location = ph_location(left = 4.4, top = 4.02))
                              

