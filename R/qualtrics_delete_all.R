qualtrics_delete_all <- function(variables) {
  
  # To remove blocks
  remove_blocks_qualtrics(start_on = 1, survey_type = "miro")
  remDr$refresh()
  
  
  # To remove survey flow elements
  remove_surveyflow_elements(start_on = 3)
  remDr$refresh()
  beepr::beep()
  
  
}