items2qualtrics <- function(list_of_items, outputdir, removePlaceholders) {
  
  # item to format to qualtrics
  # item <- item_pairs$item_01[1]
  # responsesdir <- response_types_dir
  item <- 
    list_of_items
  
  item <- readChar(paste0("materials/text_output/", item, ".txt"), file.size(paste0("materials/text_output/", item, ".txt")))
  
  
  item <- 
    gsub("(.*)\\n\\b", "\\1", item)
  
  # 00. get item name (this should be the actual file-name) ####
  item_name_01 <- 
    gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)
  item_01_context <- 
    gsub("([a-z]{2})_[a-z]{4}_ppv[a-z]{3,4}", "\\1", item_name_01)
  item_01_presentation_format <- 
    gsub("[a-z]{2}_([a-z]{4})_ppv[a-z]{3,4}", "\\1", item_name_01)
  item_01_ppv_prob <- 
    gsub("[a-z]{2}_[a-z]{4}_ppv([a-z]{3,4})", "\\1", item_name_01)
  
  # GET 01 CONDITION INFO EMBEDDED DATA ###################################
  
  embedded_presentation_format <- 
    gsub("value", 
         item_01_presentation_format, 
         gsub("field", "pres_format", qualtrics_codes$embedded_data))
  
  embedded_problem_context_01 <- 
    gsub("value", 
         item_01_context, 
         gsub("field", "prob_context_01", qualtrics_codes$embedded_data))
  
  embedded_ppv_probability_01 <- 
    gsub("value", 
         item_01_ppv_prob, 
         gsub("field", "ppv_prob_01", qualtrics_codes$embedded_data))
  
  # FOLLOWUP RISK #################################################
  fu_numbers <- 
    readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 1) %>% 
    filter(format == "fu")
    
  fu_risk <- fu_numbers %>% filter(prob == item_01_ppv_prob) %>% select(fu_risk) %>% pull
  
  embedded_fu_risk_01 <- 
    gsub("value", 
         fu_risk, 
         gsub("field", "fu_risk_01", qualtrics_codes$embedded_data))
  #################################################################
  
  # GET 01 PREVALENCE NAME EMBEDDED DATA ########################
  
  embedded_prevalence_01 <- 
    gsub("value", 
         all_prevalences$prevalence[grep(item_name_01, all_prevalences$name)], 
         gsub("field", "prevalence_01", qualtrics_codes$embedded_data))
  
  # GET 01 ITEM EMBEDDED DATA ###################################
  
  item_nameless <- 
    gsub("\\*\\*.*\\*\\*\n\n(.*)", "\\1", item)
  
  embedded_item_01 <- 
    gsub("value", 
         item_nameless, 
         gsub("field", "item_01", qualtrics_codes$embedded_data)) %>% 
    remove_placeholders(items = ., item_followup = "item") %>% 
    gsub("\\n", "<br>", .)
  
  # Read second file --------------------------------------------------------
  
  item_name_02 <- 
    item_pairs$item_02[grep(item_name_01, item_pairs$item_01)]
  
  # 00. get item name (this should be the actual file-name) ####
  
  item_02_context <- 
    gsub("([a-z]{2})_[a-z]{4}_ppv[a-z]{3,4}", "\\1", item_name_02)
  item_02_presentation_format <- 
    gsub("[a-z]{2}_([a-z]{4})_ppv[a-z]{3,4}", "\\1", item_name_02)
  item_02_ppv_prob <- 
    gsub("[a-z]{2}_[a-z]{4}_ppv([a-z]{3,4})", "\\1", item_name_02)
  
  # GET 02 CONDITION INFO EMBEDDED DATA ###################################
  
  
  embedded_problem_context_02 <- 
    gsub("value", 
         item_02_context, 
         gsub("field", "prob_context_02", qualtrics_codes$embedded_data))
  
  embedded_ppv_probability_02 <- 
    gsub("value", 
         item_02_ppv_prob, 
         gsub("field", "ppv_prob_02", qualtrics_codes$embedded_data))
  
  # FOLLOWUP RISK #################################################
  fu_numbers <- 
    readxl::read_xls("materials/Numbers/numbers_bayes.xls", sheet = 1) %>% 
    filter(format == "fu")
  
  fu_risk <- fu_numbers %>% filter(prob == item_02_ppv_prob) %>% select(fu_risk) %>% pull
  
  embedded_fu_risk_02 <- 
    gsub("value", 
         fu_risk, 
         gsub("field", "fu_risk_02", qualtrics_codes$embedded_data))
  #################################################################
  
  # GET 02 PREVALENCE NAME EMBEDDED DATA ########################
  
  embedded_prevalence_02 <- 
    gsub("value", 
         all_prevalences$prevalence[grep(item_name_02, all_prevalences$name)], 
         gsub("field", "prevalence_02", qualtrics_codes$embedded_data))
  
  # GET 02 ITEM EMBEDDED DATA ###################################
  
  embedded_item_02 <-
    readChar(paste0("materials/text_output/", item_name_02, ".txt"), file.size(paste0("materials/text_output/", item_name_02, ".txt"))) %>% 
    gsub("\\*\\*.*\\*\\*\\n\\n", "", .) %>% gsub("(.*)\\n\\b", "\\1", .) %>% gsub("value", ., gsub("field", "item_02", qualtrics_codes$embedded_data)) %>% 
    remove_placeholders(items = ., item_followup = "item") %>% gsub("\\n", "<br>", .)
  

  
  cat(
    qualtrics_codes$advanced_format,"\n",
    embedded_presentation_format, "\n",
    embedded_problem_context_01, "\n",
    embedded_problem_context_02, "\n",
    embedded_ppv_probability_01, "\n",
    embedded_ppv_probability_02, "\n",
    embedded_fu_risk_01, "\n",
    embedded_fu_risk_02, "\n",
    
    embedded_prevalence_01, "\n",
    embedded_item_01, "\n",
    
    embedded_prevalence_02, "\n",
    embedded_item_02, "\n",
    # DUMB QUESTION
    qualtrics_codes$question_only_text, "\n",
    "DELETE THIS"
    , sep = ""
    , file = paste0(outputdir, 
                    paste(item_pairs[grep(item_name_01, item_pairs$item_01),], collapse = "__"), ".txt")
  )
  
  # # 02. item without response type
  # item_responseless <- 
  #   gsub("(.*)\\n\\[response_start\\].*", "\\1", item_nameless)
  
  # # 03. html format (item responseless)
  # html_item <- 
  #   gsub("\n", html_codes$linebreak,
  #        gsub("QUESTION_TEXT_TO_FORMAT", item_responseless, html_codes$question_font_size)
  #   )
  
  # # 04. response type
  # hmtl_response_type <- 
  #   dir(responsesdir) %>% 
  #   map(~readChar(con = paste0(responsesdir, .x), nchars = file.info(paste0(responsesdir, .x))$size))
  
  # # 05. Combine item elements
  # if (grepl("_gi", item_name)) {
  #   
  #   item_to_export <-
  #     paste(
  #       qualtrics_codes$advanced_format, "\n",
  #       embedded_prevalence, "\n",
  #       qualtrics_codes$question_singlechoice_horizontal, "\n",
  #       html_item, "\n",
  #       qualtrics_codes$question_choices, "\n",
  #       hmtl_response_type
  #       
  #       , sep = "")
  #   
  # } else if (!grepl("_gi", item_name)) {
  #   
  #   item_to_export <- paste(
  #     qualtrics_codes$advanced_format, "\n",
  #     embedded_prevalence, "\n",
  #     qualtrics_codes$question_text, "\n",
  #     html_item
  #     
  #     , sep = "")
  #   
  # }
  
  # # 06. Write item to txt file
  # dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
  # if (removePlaceholders == TRUE) {
  #   cat(remove_placeholders(item_to_export), file = paste0(outputdir, item_name, ".txt"))
  # } else if (removePlaceholders == FALSE) {
  #   cat(item_to_export, file = paste0(outputdir, item_name, ".txt"))
  #   
  # }
  
}
