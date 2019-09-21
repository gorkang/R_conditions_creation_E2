send_email <- function(to_email = "gorka.navarrete@uai.cl", type = "error", password_mail) {
  
  # to_email = "gorka.navarrete@uai.cl"
  # type = "error"
  # password_mail = ""
  
  # Libraries ---------------------------------------------------------------
    devtools::install_github("datawookie/emayili")
  
    library(emayili)
    library(beepr)
    library(dplyr)
  

  # Parameters --------------------------------------------------------------
  
    if (type == "error") {
      subject_text = "ERROR!"
      body_text = "There was an error in the script... :("
      beepr::beep(sound = 7)  
    } else {
      subject_text = "Finished"
      body_text = "Import_survey_qualtrics.R finished without errors :)"
      beepr::beep(sound = 1)
    }
  

  # Send email --------------------------------------------------------------
  
    email <- envelope() %>%
      from("cscn@uai.cl") %>%
      to(to_email) %>%
      subject(subject_text) %>%
      emayili::body(body_text)
    
    
    smtp <- server(host = "smtp.office365.com",
                   port = 587,
                   username = "cscn@uai.cl",
                   password = password_mail)
    
    smtp(email, verbose = TRUE)
    
    
    # USING curl
    
    # library(curl)
    # library(magrittr)
    # 
    # message <- body_text
    # recipients <- to_email
    # sender <- "cscn@uai.cl"
    # username <- 'cscn@uai.cl'
    # password <- password_mail
    # send_mail(mail_from=sender, mail_rcpt=recipients, smtp_server = "smtp.office365.com:587",
    #           message = message, username = username, password = password_mail)
    
    
}
