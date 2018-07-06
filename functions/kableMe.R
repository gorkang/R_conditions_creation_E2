kableME <- function(some_table) {
  some_table %>%  
    mutate(no = seq(nrow(.))) %>% select(no, names(.)) %>% 
    kable() %>% kable_styling(., "striped")
}