library(tidyverse)
library(VennDiagram)

# Create Venn Diagram -----------------------------------------------------
grid.newpage()

draw.pairwise.venn(34642, 22857, 8630, category = c("Geneious_and_Truseq", "DLC380_No_Normal_Pipeline"), 
                   lty = rep("blank", 2), fill = c("light blue", "pink"), alpha = rep(0.5, 2), cat.pos = c(0, 0), 
                   cat.dist = rep(0.025, 2), scaled = FALSE)

grid.newpage()
draw.pairwise.venn(6094, 3442, 2833, category = c("Geneious_and_Truseq", "DLC380_No_Normal_Pipeline"), 
                   lty = rep("blank", 2), fill = c("light blue", "pink"), alpha = rep(0.5, 2), cat.pos = c(0, 0), 
                   cat.dist = rep(0.025, 2), scaled = FALSE)

grid.newpage()
draw.pairwise.venn(6091, 3442, 2833, category = c("Geneious", "DLC380_No_Normal_Pipeline"), 
                   lty = rep("blank", 2), fill = c("light blue", "pink"), alpha = rep(0.5, 2), cat.pos = c(0, 0), 
                   cat.dist = rep(0.025, 2), scaled = FALSE)
