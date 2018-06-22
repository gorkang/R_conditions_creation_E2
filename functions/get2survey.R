get2survey <- function(survey_link) {
  
  # Re-load site because at first qualtrics opens the survey list
  remDr$navigate(survey_link)
  Sys.sleep(1)
  
  # User name
  username <- remDr$findElement(using = "css selector", value = '#UserName') # username text-entry element
  username$clearElement() # click element
  username$sendKeysToElement(list("gorka.navarrete@uai.cl")) # send username to username field
  
  # Password
  passwd <- remDr$findElement(using = "css selector", value = '#UserPassword') # password text-entry element
  passwd$clearElement() # click element
  passwd$sendKeysToElement(list(pass)) # send password (previously set on object "pass")
  
  # Sing in
  webElem <- remDr$findElement(using = 'css selector', value = '#loginButton')
  webElem$clickElement()
  Sys.sleep(1)
  
}