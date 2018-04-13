# This function takes strings and remove all strings defined on placeholders vector, and
# outputs the new string
#TODO: add to remove linebreaks next to placeholders

remove_placeholders <- function(items, item_followup = "item") {
  
  # items <- followUps_items_prev
  
  # all placeholders within items, contexts, questions and responses must be in this vector
  if (item_followup == "item") {
    
    placeholders <- 
      c("first_piece","second_piece","third_piece","item_end",
        "context_start","context_mid","context_end",
        "question_start","question_end",
        "response_start","response_mid","response_end")
    
  } else if (item_followup == "followup") {
    
    placeholders <- 
      c("followUp_start", "followUp_first_piece", "followUp_second_piece", "followUp_third_piece", 
        "questions_start", "second_question", "third_question", "fourth_question", "fifth_question", "followUp_end")
    
  }
  
  # create regex to detect all placeholders
  placeholders_regex <-
    # paste(paste0("\\n{0,1}\\[",placeholders, "\\]\\n{0,1}"), collapse = "|")
    paste(paste0("\\[",placeholders, "\\]\\n{0,1}"), collapse = "|")
  
  # remove placeholders
  gsub(placeholders_regex, "", items)
  
  
}