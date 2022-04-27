# Add fourth slide ----
doc <- add_slide(doc, layout = "Page Four", master = "Office Theme")

# Set text formatting ----
format_contact <- fp_text(color = '#404040', font.size = 13, font.family = "Garamond", bold = F)

# Add elements to template ----
# contact text
contact_info <- block_list(fpar(str = txt_contact_nm, fp_t = format_contact),
                           fpar(str = txt_contact_email, fp_t = format_contact),
                           fpar(str = txt_contact_phone, fp_t = format_contact))

doc <- ph_with(doc, contact_info, 
                       location = ph_location(left = 5.75, top = 8.75, 
                                              width = 2.5, height = 0.5))
# National NERR map
doc <- ph_with(doc, value = external_img(src = img_nerr_map, width = 4.1, height = 2.82),
                       use_loc_size = FALSE,
                       location = ph_location(left = 4.4, top = 4.02))
