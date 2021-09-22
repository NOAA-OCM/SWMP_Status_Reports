# Add fourth slide ----
doc <- add_slide(doc, layout = "Page Four", master = "Office Theme")

# Set text formatting ----
format_contact_ttl <- fp_text(color = 'white', font.size = 24, font.family = "Calibri-Light", bold = F)
format_contact_highlight <- fp_text(color = 'white', font.size = 14, font.family = "Calibri Light", bold = T)
format_contact <- fp_text(color = '#595959', font.size = 14, font.family = "Garamond", bold = F) #595959 is grayish

# contact text
doc <- ph_with(doc, value = empty_content(),
               location = ph_location(left = 0.28, top = 9.61, 
                                      width = 2.5, height = 0.8))
doc <- doc %>% ph_add_par(id_chr = "2") %>%
  ph_add_text(str = txt_contact_nm, type = 'body', id_chr = "2", style = format_contact) %>%
  ph_add_par(id_chr = "2") %>%
  ph_add_text(str = txt_contact_email, type = 'body', id_chr = "2", style = format_contact) %>%
  ph_add_par(id_chr = "2") %>%
  ph_add_text(str = txt_contact_phone, type = 'body', id_chr = "2", style = format_contact)
