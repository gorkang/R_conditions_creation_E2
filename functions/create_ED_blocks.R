create_ED_blocks <- function() {
  
  # # THIS GOES ON ED BLOCK CREATOR
  # fu_fields_replaces <- 
  #   list(positive_test_result = c( "mammograms", "results"),
  #        medical_condition    = c( "breast cancer", "Trisomy 21"),
  #        medical_screening    = c( "mammogram screening", "prenatal screening"),
  #        medical_test         = c( "mammogram", "amniocentesis"),
  #        doctor_offers        = c( "that consists of a biopsy", "called amniocentesis"),
  #        fluid_test           = c( "a breast cyst", "the amniotic sac"),
  #        test_name            = c( "The biopsy", "Amniocentesis"),
  #        medical_consequence  = c( "partial mastectomy", "miscarriage"),
  #        sg_person            = c( "a woman", "a woman's fetus"),
  #        sg_test_result       = c( "mammogram", "test result")
  #   )
  
  screening_blocks_ED_fill <- list(ca = list(sg_test_result       = "mammogram" ,
                                             sg_person            = "a woman",
                                             medical_condition    = "breast cancer",
                                             positive_test_result = "mammogram",
                                             medical_test         = "mammogram",
                                             doctor_offers        = "that consist of a biopsy",
                                             fluid_test           = "the breast cyst",
                                             test_name            = "The biopsy",
                                             medical_consequence  = "partial mastectomy"),
                                   
                                   pr = list(sg_test_result       = "test result" ,
                                             sg_person            = "a woman's fetus",
                                             medical_condition    = "trisomy 21",
                                             positive_test_result = "test result",
                                             medical_test         = "test result",
                                             doctor_offers        = "called amniocentesis",
                                             fluid_test           = "the amniotic sac",
                                             test_name            = "Amniocentesis",
                                             medical_consequence  = "miscarriage")
  ) 
  
  for (xxx in 1:nrow(conditions)) {
    # xxx <- 1
    message(paste0(xxx, "/", nrow(conditions)))
    
    # ######################################################################################################
    # This function creates the following fields as embedded data variables ------------------------------
    
    embedded_data <- 
      list(advanced_format = qualtrics_codes$advanced_format,
           press_format = NULL,               # Presentation format
           resp_type = NULL,
           ppv_question = NULL,
           prob_context_01 = NULL,            # Problem context item 01
           prob_context_02 = NULL,            # Problem context item 02
           med_cond_01 = NULL,                # Medical condition item 01
           med_cond_02 = NULL,                # Medical condition item 02
           ppv_prob_text_01 = NULL,           # PPV probability as text item 01
           ppv_prob_text_02 = NULL,           # PPV probability as text item 02
           ppv_prob_num_01 = NULL,            # PPV probability as num item 01
           ppv_prob_num_02 = NULL,            # PPV probability as num item 02
           fu_risk_text_01 = NULL,            # Follow-up riks as text item 01
           fu_risk_text_02 = NULL,            # Follow-up riks as text item 02
           fu_risk_num_01 = NULL,             # Follow-up riks as num item 01
           fu_risk_num_02 = NULL,             # Follow-up riks as num item 02
           screening_item_01_intro = NULL,    # Screening item introduction item 01
           prevalence_01 = NULL,              # Screening item prevalence item 01
           screening_item_01 = NULL,          # Screening item 01
           screening_item_02_intro = NULL,    # Screening item introduction item 02
           prevalence_02 = NULL,              # Screening item prevalence item 02  
           screening_item_02 = NULL,          # Screening item 02
           dumb_question = paste(qualtrics_codes$question_only_text, "DELETE THIS", sep = "\n")
      )
    # ######################################################################################################
    
    # iterate through rows. each row is a condition.
    current_condition <- 
      conditions[xxx,]
    
    
    # ######################################################################################################
    # Dinamycally created fields -------------------------------------------------------------------------
    # This fields are used to fill each screening block (screening item + follow-up)
    
    for (a in c(1:2)) {
      # a <- 1
      trial <- a
      curr_context <- current_condition[[paste0("prob_context_0", trial)]]
      filt_list <- screening_blocks_ED_fill[[curr_context]]
      
      for (b in seq(filt_list)) {
        # b <- 1
        embedded_data[[paste0(names(filt_list[b]), "_0", trial)]] <- 
          qualtrics_codes$embedded_data %>% 
          gsub("field", paste0(names(filt_list[b]), "_0", trial), .) %>% 
          gsub("value", filt_list[[b]], .)
        
      }
    }
    # ######################################################################################################
    
    # Follow up risk as text
    fu_risk_text_01 <- tolower(gsub("risk", "", current_condition$followUp_01))
    fu_risk_text_02 <- tolower(gsub("risk", "", current_condition$followUp_02))
    # Follow up risk as num
    fu_risk_num_01 <- followUp_num %>% filter(prob == fu_risk_text_01) %>% select(fu_risk) %>% pull()
    fu_risk_num_02 <- followUp_num %>% filter(prob == fu_risk_text_02) %>% select(fu_risk) %>% pull()
    
    # Positive Predictive Value
    # PPV as number (actual correct response)
    ppv_prob_num_01 <- ppv_num %>% filter(prob == current_condition$ppv_prob_01) %>% select(PPV) %>% pull()
    ppv_prob_num_02 <- ppv_num %>% filter(prob == current_condition$ppv_prob_02) %>% select(PPV) %>% pull()
    
    # Presentation format -----------------------------------------------------
    embedded_data$press_format <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "press_format", .) %>% 
      gsub("value", current_condition$press_format, .)
    
    
    # Response type -----------------------------------------------------------
    embedded_data$resp_type <-
      qualtrics_codes$embedded_data %>% 
      gsub("field", "resp_type", .) %>% 
      gsub("value", current_condition$resp_type, .)
    
    # PPV question -----------------------------------------------------------
    # IF positive framwork and sequential guided, no ppv question.
    if (current_condition$press_format == "pfab" & current_condition$resp_type == "sg") {
      embedded_data$ppv_question <-
        qualtrics_codes$embedded_data %>% 
        gsub("field", "ppv_quest", .) %>% 
        gsub("value", "", .)
      # IF any other than positive framework and sequential guided, normal ppv question
    } else if (!(current_condition$press_format == "pfab" & current_condition$resp_type == "sg")) {
      # Read generic question and repalce linebreaks with html equivalent
      curr_ppv_question <- 
        "materials/Question/Calculation/input/unified_question.txt" %>% 
        readChar(., file.size(.)) %>% 
        remove_placeholders() %>% 
        gsub("(.*)\\n\\b", "\\1", .) %>% 
        gsub("\\n", "<br>", .) %>% 
        gsub("^<br>", "", .)
      # Store as embedded data
      embedded_data$ppv_question <-
        qualtrics_codes$embedded_data %>% 
        gsub("field", "ppv_quest", .) %>% 
        gsub("value", curr_ppv_question, .) 
    }
    
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
    embedded_data$ppv_prob_text_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_text_01", .) %>% 
      gsub("value", current_condition$ppv_prob_01, .)
    # PPV probability 01 text
    embedded_data$ppv_prob_text_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_text_02", .) %>% 
      gsub("value", current_condition$ppv_prob_02, .)
    
    # PPV probability 01 text
    embedded_data$ppv_prob_num_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_num_01", .) %>% 
      gsub("value", ppv_prob_num_01, .)
    
    # PPV probability 02 text
    embedded_data$ppv_prob_num_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "ppv_prob_num_02", .) %>% 
      gsub("value", ppv_prob_num_02, .)
    
    # Follow-up risk ----------------------------------------------------------
    
    # Follow-up risk 01 text
    embedded_data$fu_risk_text_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_text_01", .) %>% 
      gsub("value", fu_risk_text_01, .)
    # Follow-up risk 02 text
    embedded_data$fu_risk_text_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_text_02", .) %>% 
      gsub("value", fu_risk_text_02, .)
    # Follow-up risk 01 num
    embedded_data$fu_risk_num_01 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_num_01", .) %>% 
      gsub("value", fu_risk_num_01, .)
    # Follow-up risk 02 num
    embedded_data$fu_risk_num_02 <- 
      qualtrics_codes$embedded_data %>% 
      gsub("field", "fu_risk_num_02", .) %>% 
      gsub("value", fu_risk_num_02, .)
    
    
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
      gsub("(.*)\\n\\b", "\\1", .) %>%
      gsub("\\n", "<br>", .) %>% 
      gsub("^<br>", "", .)
    
    
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
      gsub("(.*)\\n\\b", "\\1", .) %>%
      gsub("\\n", "<br>", .) %>% 
      gsub("^<br>", "", .)
    
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
      gsub("(.*)\\n\\b", "\\1", .) %>% 
      # change : with asci code
      gsub(":", "&#58;", .) %>% 
      gsub("\\n", "<br>", .) %>% 
      gsub("^<br>", "", .)
    
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
      gsub("(.*)\\n\\b", "\\1", .) %>% 
      # change : with asci code
      gsub(":", "&#58;", .) %>% 
      gsub("\\n", "<br>", .) %>% 
      gsub("^<br>", "", .)
    
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