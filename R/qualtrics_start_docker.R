qualtrics_start_docker <- function(pass) {
  
  # Passwords ---------------------------------------------------------------
  
  # Qualtrics password
  pass   <<- .rs.askForPassword("Please enter Qualtrics password")
  
  # Email password (cscn2016...)
  # password_mail   <- .rs.askForPassword("Please enter EMAIL password")
  
  
  # Packages -------------------------------------------------------------
  
  if (!require('pacman')) install.packages('pacman'); library('pacman')
  p_load(RSelenium, tidyverse)
  

  
  # Resources ---------------------------------------------------------------
  
  source("functions/get2survey.R")
  source("functions/go_gorka_04.R")
  
  # Play sound and send email on error
  # options(error = beep(sound = 7))
  # options(error = send_email(to_email = "gorkang@gmail.com",
  #                            type = "end",
  #                            password_mail))
  # 
  
  
  # Start docker session ----------------------------------------------------
  # Container name
  container_name <- 'rqualtrics'
  # If container is running stop it
  if (!is_empty(system(sprintf('docker ps -q -f name=%s', container_name), intern = TRUE))) {
    # Stop and remove container
    system(sprintf('docker stop %s', container_name)) # MATALOS todos
  }
  # If container exists remove it
  if (length(system(sprintf('docker container ls -a -f name=%s', container_name), intern = TRUE)) > 1) {
    system(sprintf('docker container rm %s', container_name))
  }
  # Get chrome image (to use VNC use debug)
  # system('docker pull selenium/standalone-chrome-debug')
  system('docker pull selenium/standalone-firefox-debug') 
  
  # Run docker session. Map home directory to download docker container
  # system('docker run -d --name rqualtrics -v /home:/home/seluser/Downloads -P selenium/standalone-chrome-debug')
  # system('docker run -t -d --name rqualtrics -v /home/emrys/Downloads/:/home/seluser/Downloads -P selenium/standalone-firefox-debug') #standalone-firefox 
  system('docker run -t -d --shm-size=2g -e SCREEN_WIDTH=2560 -e SCREEN_HEIGHT=1440 -e SCREEN_DEPTH=24 --name rqualtrics -v /home/emrys/:/home/seluser/Downloads -P selenium/standalone-firefox-debug') #standalone-firefox 
  
  # Get port
  container_port_raw <- system(sprintf('docker port %s', container_name), intern = TRUE)
  container_port <<- container_port_raw %>% gsub('.*([0-9]{5}).*', '\\1', .) %>% as.integer()
  
  
  system('docker ps -f name=rqualtrics')
  # This is the path to materials folder within docker container
  # selenium_path <- "/home/selusxer/Downloads/nic/nostromo/fondecyt/gorka/2017 - Gorka - Fondecyt/Experimentos/Experimento 1/R_condition_creation_GITHUB/R_conditions_creation"
  selenium_path <<- "/home/seluser/Downloads/gorkang@gmail.com/RESEARCH/PROYECTOS/2017 - Gorka - Fondecyt_NO_SHARED/Experimentos/Experimento 1/R_conditions_creation/"
  
  # Wait
  message("* remoteDriver")
  Sys.sleep(2)
  # message(container_port[1])
  
  # Selenium ----------------------------------------------------------------
  # Create browser instance. This should be reflected in the VNC session
  # remDr <- remoteDriver(remoteServerAddr = "localhost", port = container_port[1], browserName = "chrome")
  remDr <<- remoteDriver(remoteServerAddr = "localhost", port = container_port[1], browserName = "firefox")
  
  message("* Open")
  Sys.sleep(1)
  
  remDr$open(silent = TRUE)
  
  message("* get2survey")
  
  Sys.sleep(1)
  
  # Get to GORKA 4 --------------------------------------------------
  # URL to login website
  survey_link <- "https://login.qualtrics.com/login?_ga=2.25607227.743887377.1535235685-1311002066.1535235685"
  
  
  # Get to qualtrics
  get2survey(survey_link)
  
  message("* Open Survey")
  # Sys.sleep(1)
  
  # Open VNC, using second port in container_port
  message(paste0("localhost:", container_port[2]))
  # pwd: secret
  
  
  # Gorka_04
  go_gorka_04()
  
  # If in Chrome: COPY secont tab URL & MANUALLY paste it in first tab
  
  
  
  
  # REMOVE EVERYTHING --------------------------------------------------------
  
  # # To remove blocks
  # remove_blocks_qualtrics(start_on = 1, survey_type = "miro")
  # remDr$refresh()
  # # To remove survey flow elements
  # remove_surveyflow_elements(start_on = 3)
  # remDr$refresh()
  # beepr::beep()

}

