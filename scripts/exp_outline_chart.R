# Packages
if (!require('pacman',quietly = TRUE)) install.packages('pacman'); library('pacman', quietly = TRUE)
p_load(grid, Gmisc)

# OPEN A JPG FILE
h <- 800
png("materials/experiment_design/output/outline.png", h, h*.843333)

# Create clean canvas
grid.newpage()

# set some parameters to use repeatedly
leftx <- .25
midx <- .35
rightx <- .75
width <- .25
gp <- gpar(fill = "lightgrey")

# Create boxes ------------------------------------------------------------

start_y <- .83

# pilot warning
(expgen <- boxGrob("FDCYT 2017 - Experiment 1", 
                  x=.5, y=.95, box_gp = gp, width = width))

# pilot warning
(pilot <- boxGrob("Pilot warning (for now)", 
                  x=midx, y=start_y, box_gp = gp, width = width))
# consent form
(consent <- boxGrob("Consent form", 
                    x=midx, y=start_y-.095, box_gp = gp, width = width))

# CONNECT
connectGrob(pilot, consent, "v")

# sociodemographics
(sociodem <- boxGrob("Sociodemographic Scale", 
                    x=midx, y=start_y-(.095*2), box_gp = gp, width = width))

# CONNECT
connectGrob(consent, sociodem, "v")

# Screening block

# custom x position for screening block
screen01_x <- midx

# screnning block 1
(screen01 <- boxGrob("Screening Block 01", 
                     x=screen01_x, y=start_y-(.095*3), box_gp = gp, width = width))
# CONNECT
connectGrob(sociodem, screen01, "v")

# Screening block 2
(screen02 <- boxGrob("Screening Block 02", 
                     x=midx, y=start_y-(.095*4), box_gp = gp, width = width))
# CONNECT
connectGrob(screen01, screen02, "v")

# scales
(scales <- boxGrob("Scales (randomized)\nsee list below ", 
                     x=midx, y=start_y-(.095*5), box_gp = gp, width = width))
# CONNECT
connectGrob(screen02, scales, "v")

# Previous experience
(prevexp <- boxGrob("Previous experience", 
                   x=midx, y=start_y-(.095*6), box_gp = gp, width = width))
# CONNECT
connectGrob(scales, prevexp, "v")

# Comments
(comm <- boxGrob("Comments", 
                    x=midx, y=start_y-(.095*7), box_gp = gp, width = width))
# CONNECT
connectGrob(prevexp, comm, "v")

# Survey Effort
(effort <- boxGrob("Survey effort", 
                 x=midx, y=start_y-(.095*8), box_gp = gp, width = width))
# CONNECT
connectGrob(comm, effort, "v")

# SCREENING BLOCK EXAMPLE -------------------------------------------------

# Custom position for example of conent within screening blocks
rightside <- midx+.3
screen01_y <- .4

# Screening title
(screen012 <- boxGrob("SCRENNING BLOCK EXAMPLE", 
                      x=rightside, y=screen01_y+.3, box_gp = gp, width = width))
# PPV item
(ppv01 <- boxGrob("PPV item 01/2", 
                  x=rightside, y=screen01_y+.2, box_gp = gp, width = width))
# Willingness to screen
(will01 <- boxGrob("Willingness to screen 01/2", 
                   x=rightside, y=screen01_y+.1, box_gp = gp, width = width))
# Comprehension
(comp01 <- boxGrob("Comprehension 01/2", 
                   x=rightside, y=screen01_y, box_gp = gp, width = width))
# Follow-up
(followup <- boxGrob("Follow-up Item 01/2", 
                     x=rightside, y=screen01_y-.1, box_gp = gp, width = width))
# Severity Emotion scale
(sevEmo01 <- boxGrob("Severity Emotion scale 01/2", 
                     x=rightside, y=screen01_y-.2, box_gp = gp, width = width))

# CONNECT example screening block
connectGrob(screen012, ppv01, "v")
connectGrob(ppv01, will01, "v")
connectGrob(will01, comp01, "v")
connectGrob(comp01, followup, "v")
connectGrob(followup, sevEmo01, "v")
# ---------------------------------------------------------------------

# CLOSE JPG FILE
invisible(dev.off())

