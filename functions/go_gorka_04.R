go_gorka_04 <- function() {
  
  # Search GORKA_04 survey
  webElem <- remDr$findElements(using = 'css selector', value = "#SV_3vAg9KkFFygLzkp > td.type-column.ng-scope.angular-ui-tree-handle > span.project-type.ng-binding")
  
  # Keep trying until the element appears
  while (length(webElem) == 0) {
    webElem <- remDr$findElements(using = 'css selector', value = "#SV_3vAg9KkFFygLzkp > td.type-column.ng-scope.angular-ui-tree-handle > span.project-type.ng-binding")
  }
  # Now that GORKA_04 is there, select it and click it.
  webElem <- remDr$findElement(using = 'css selector', value = "#SV_3vAg9KkFFygLzkp > td.type-column.ng-scope.angular-ui-tree-handle > span.project-type.ng-binding")
  webElem$clickElement()
  
  Sys.sleep(1)
  
  # Get all windows 
  windows <- remDr$getWindowHandles()
  
  while (length(windows) == 1) {
    # Get all windows 
    windows <- remDr$getWindowHandles()
  }
  # It is necessary to switch to the new child window
  # Stored current window (in case you want to go back)
  currWindow <-  remDr$getCurrentWindowHandle()
  # Switch to child window
  remDr$switchToWindow(windows[[2]])
  
}
