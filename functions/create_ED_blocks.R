create_ED_blocks <- function() {
  
  for (xxx in 1:nrow(conditions)) {
    # xxx <- 1
    print(paste0(xxx, "/", nrow(conditions)))
    
    # ######################################################################################################
    # This function creates the following fields as embedded data variables ------------------------------
    
    embedded_data <- 
      list(press_format = NULL,               # Presentation format
           prob_context_01 = NULL,            # Problem context item 01
           prob_context_02 = NULL,            # Problem context item 02
           med_cond_01 = NULL,                # Medical condition item 01
           med_cond_02 = NULL,                # Medical condition item 02
           ppv_prob_01_text = NULL,           # PPV probability as text item 01
           ppv_prob_02_text = NULL,           # PPV probability as text item 02
           ppv_prob_01_num = NULL,            # PPV probability as num item 01
           ppv_prob_02_num = NULL,            # PPV probability as num item 02
           fu_risk_01_text = NULL,            # Follow-up riks as text item 01
           fu_risk_02_text = NULL,            # Follow-up riks as text item 02
           fu_risk_01_num = NULL,             # Follow-up riks as num item 01
           fu_risk_02_num = NULL,             # Follow-up riks as num item 02
           screening_item_01_intro = NULL,    # Screening item introduction item 01
           prevalence_01 = NULL,              # Screening item prevalence item 01
           screening_item_01 = NULL,          # Screening item 01
           screening_item_02_intro = NULL,    # Screening item introduction item 02
           prevalence_02 = NULL,              # Screening item prevalence item 02  
           screening_item_02 = NULL)          # Screening item 02
    # ######################################################################################################
    
    current_condition <- conditions[xxx,]
    
    # Follow up risk as text
    fu_risk_01_text <- tolower(gsub("risk", "", current_condition$followUp_01))
    fu_risk_02_text <- tolower(gsub("risk", "", current_condition$followUp_02))
    # Follow up risk as num
    fu_risk_01_num <- followUp_num %>% filter(prob == fu_risk_01_text) %>% select(fu_risk) %>% pull()
    fu_risk_02_num <- followUp_num %>% filter(prob == fu_risk_02_text) %>% select(fu_risk) %>% pull()
    
    # Positive Predictive Value
    # PPV as number (actual correct response)
    ppv_prob_01_num <- ppv_num %>% filter(prob == current_condition$ppv_prob_01) %>% select(PPV) %>% pull()
    ppv_prob_02_num <- ppv_num %>% filter(prob == current_condition$ppv_prob_02) %>% select(PPV) %>% pull()
    
    
    # Presentation format -----------------------------------------------------
    embedded_data$press_format <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "press_format", .) %>% 
      gsub("value", current_condition$press_format, .)
    
    # Problem context ---------------------------------------------------------
    
    # Problem context 01
    embedded_data$prob_context_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "prob_context_01", .) %>% 
      gsub("value", current_condition$prob_context_01, .)
    # Problem context 02
    embedded_data$prob_context_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "prob_context_02", .) %>% 
      gsub("value", current_condition$prob_context_02, .)
    
    # Medical condition -------------------------------------------------------
    
    # Medical condition 01
    embedded_data$med_cond_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "med_cond_01", .) %>% 
      gsub("value", current_condition$med_cond_01, .)
    # Medical condition 02
    embedded_data$med_cond_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "med_cond_02", .) %>% 
      gsub("value", current_condition$med_cond_02, .)
    
    # PPV ---------------------------------------------------------------------
    
    # PPV probability 01 text
    embedded_data$ppv_prob_01_text <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_01_text", .) %>% 
      gsub("value", current_condition$ppv_prob_01, .)
    # PPV probability 01 text
    embedded_data$ppv_prob_02_text <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_02_text", .) %>% 
      gsub("value", current_condition$ppv_prob_02, .)
    
    # PPV probability 01 text
    embedded_data$ppv_prob_01_num <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_01_num", .) %>% 
      gsub("value", ppv_prob_01_num, .)
    
    # PPV probability 02 text
    embedded_data$ppv_prob_02_num <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_02_num", .) %>% 
      gsub("value", ppv_prob_02_num, .)
    
    # Follow-up risk ----------------------------------------------------------
    
    # Follow-up risk 01 text
    embedded_data$fu_risk_01_text <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_01_text", .) %>% 
      gsub("value", fu_risk_01_text, .)
    # Follow-up risk 02 text
    embedded_data$fu_risk_02_text <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_02_text", .) %>% 
      gsub("value", fu_risk_02_text, .)
    # Follow-up risk 01 num
    embedded_data$fu_risk_01_num <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_01_num", .) %>% 
      gsub("value", fu_risk_01_num, .)
    # Follow-up risk 02 num
    embedded_data$fu_risk_02_num <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_02_num", .) %>% 
      gsub("value", fu_risk_02_num, .)
    
    
    # READ FROM FILE ----------------------------------------------------------
    
    # Item --------------------------------------------------------------------
    
    items_path <- "materials/qualtrics/output/plain_text/items/"
    
    # Item 01
    item_01 <-
      paste0(items_path, 
             current_condition$item_file_name_01) %>% 
      readChar(., file.size(.)) %>% 
      gsub("\\*\\*.*\\*\\*\\n{1,2}(.*)", "\\1", .) %>% 
      remove_placeholders() %>% 
      gsub("(.*)\\n\\b", "\\1", .)
    
    
    embedded_data$screening_item_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "screening_item_01", .) %>% 
      gsub("value", item_01, .)
    
    # Item 02
    item_02 <-
      paste0(items_path, 
             current_condition$item_file_name_02) %>% 
      readChar(., file.size(.)) %>% 
      gsub("\\*\\*.*\\*\\*\\n{1,2}(.*)", "\\1", .) %>% 
      remove_placeholders() %>% 
      gsub("(.*)\\n\\b", "\\1", .)
    
    embedded_data$screening_item_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "screening_item_02", .) %>% 
      gsub("value", item_02, .)
    
    
    # Prevalence --------------------------------------------------------------
    
    prevalences_path <- "materials/qualtrics/output/plain_text/prevalences/"
    
    # Prevalence 01
    prevalence_01 <- 
      paste0(prevalences_path, 
             current_condition$item_file_name_01) %>% 
      readChar(., file.size(.)) %>% 
      gsub("\\*\\*.*\\*\\*(.*)", "\\1", .)
    
    embedded_data$prevalence_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "prevalence_01", .) %>% 
      gsub("value", prevalence_01, .)
    
    # Prevalence 02
    prevalence_02 <- 
      paste0(prevalences_path, 
             current_condition$item_file_name_02) %>% 
      readChar(., file.size(.)) %>% 
      gsub("\\*\\*.*\\*\\*(.*)", "\\1", .)
    
    embedded_data$prevalence_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "prevalence_02", .) %>% 
      gsub("value", prevalence_02, .)
    
    # Problem intro -----------------------------------------------------------
    
    introductions_path <- "materials/qualtrics/output/plain_text/prob_intro/"
    
    # introduction 01
    introduction_01 <-
      # create path
      paste0(introductions_path, 
             paste0(current_condition$prob_context_01, "_context_ppv", current_condition$ppv_prob_01)) %>% 
      # read file
      readChar(., file.size(.)) %>% 
      # remove name
      gsub("\\*\\*.*\\*\\*(.*)", "\\1", .) %>% 
      remove_placeholders() %>% 
      # remove linebreaks at the end
      gsub("(.*)\\n\\n\\b", "\\1", .) %>% 
      # change : with asci code
      gsub(":", "&#58;", .)
    
    embedded_data$screening_item_01_intro <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "screening_intro_01", .) %>% 
      gsub("value", introduction_01, .)
    
    # introduction 02
    introduction_02 <-
      # create path
      paste0(introductions_path, 
             paste0(current_condition$prob_context_02, "_context_ppv", current_condition$ppv_prob_02)) %>% 
      # read file
      readChar(., file.size(.)) %>% 
      # remove name
      gsub("\\*\\*.*\\*\\*(.*)", "\\1", .) %>% 
      remove_placeholders() %>% 
      # remove linebreaks at the end
      gsub("(.*)\\n\\n\\b", "\\1", .) %>% 
      # change : with asci code
      gsub(":", "&#58;", .)
    
    embedded_data$screening_item_02_intro <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "screening_intro_02", .) %>% 
      gsub("value", introduction_02, .)
    
    # export to txt file ------------------------------------------------------
    
    ED_blocks_path <- "materials/qualtrics/output/plain_text/embedded_data_blocks/"
    
    dir.create(ED_blocks_path, showWarnings = FALSE, recursive = TRUE)
    
    # paste(embedded_data, collapse = "\n") %>% cat
    paste(embedded_data, collapse = "\n") %>% cat(., sep = "", file = paste0(ED_blocks_path, current_condition$complete_name))
  }
  
}