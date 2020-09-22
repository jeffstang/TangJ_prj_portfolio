# skeleton for updating CN status
setwd("/home/jtang/Chapuy_cnv/")

library(data.table)
library(tidyverse)
# Create wrapper for read.table so that it will create a file ID for each file it reads 
# Since each file describes a patient, column will be named "Patient_ID
read.data <- function(file) {
  dat <- read.table(file,header=T,sep="\t")
  dat$Patient_ID <- file
  return(dat)
}

# Merge all oncoSNP results for DLC
cnvs <- do.call(rbind, lapply(list.files(pattern="cns$"), read.data)) %>%
  mutate(Patient_ID=gsub(".call.cns", "", Patient_ID)) %>%
  mutate(Patient_ID=gsub("-Tumor", "", Patient_ID)) %>%
  rename(Chromosome=chromosome, Start=start, End=end) %>%
  arrange(Chromosome, Start) %>%
  filter(Chromosome != "X", Chromosome != "Y") %>%
  mutate(Chromosome = as.integer(Chromosome))


fwrite(x = cnvs, file = "/home/jtang/Jeffrey_cohorts_dlbcl_ml_classification/results/cnvs/Chapuy_cnvs.tsv")

# Assemble regions for copy number analysis -------------------------------------------------------------------------------------------------------------------------------------------------------
curate_regions <- fread("/home/jtang/All_Cohorts/03-copynumber_matrix/12-12-2018/cnv_regions.txt") %>% 
  arrange(chr, startpos) %>%
  select(Chromosome = chr, Start = startpos, End = endpos, Cohort, Gene, CNV.Class) %>%
  mutate(Chromosome = gsub("chr","", Chromosome)) %>%
  mutate(CNV.Class = gsub("DEL", "LOSS", CNV.Class)) %>%
  mutate(CNV.Class = gsub("AMP", "GAIN", CNV.Class)) %>%
  mutate(Chromosome = as.integer(Chromosome)) %>%
  as.data.table() 
setkey(curate_regions, Chromosome, Start, End)

# Look for matching events from DLC CNVs ----------------------------------------------------------------------------------------------------------------------
# First filter cnvs data table for non-neutral state copy number
cnvs <- cnvs %>%
  filter(cn != 2) %>%
  as.data.table()
setkey(cnvs, Chromosome, Start, End)

overlaps <- foverlaps(cnvs, curate_regions) %>%
  mutate(CopyNumber_Status = ifelse(cn > 3, "AMP", 
                                    ifelse(cn < 1, "HOMDEL", 
                                           ifelse(cn == 1, "HETLOSS", "GAIN"))))

genes_of_interest <- overlaps %>%
  mutate(CopyNumber_Status = gsub("HOMDEL", "LOSS", CopyNumber_Status)) %>%
  mutate(CopyNumber_Status = gsub("HETLOSS", "LOSS", CopyNumber_Status)) %>%
  mutate(CopyNumber_Status = gsub("AMP", "GAIN", CopyNumber_Status)) %>%
  filter(CNV.Class == CopyNumber_Status) %>%
  unite("Feature", c("Gene", "CNV.Class"), sep = "_")

copynum_summary <- genes_of_interest %>%
  group_by(Patient_ID, Feature) %>%
  summarise(mut_count=n()) %>%
  complete(Feature, nesting(Patient_ID), fill = list(mut_count = NA)) %>%
  ungroup() %>%
  spread(Feature, mut_count,fill=0) %>%
  drop_na() %>%
  as.data.table() %>% 
  mutate_if(is.numeric, list(~replace(., . > 1, 1)))

amp_region <- fread("/home/jtang/All_Cohorts/03-copynumber_matrix/12-12-2018/cnv_regions.txt") %>% 
  arrange(chr, startpos) %>%
  dplyr::select(Chromosome = chr, Start = startpos, End = endpos, Cohort, Gene, CNV.Class) %>%
  mutate(Chromosome = gsub("chr","", Chromosome)) %>%
  mutate(Chromosome = as.integer(Chromosome)) %>%
  as.data.table()
setkey(amp_region, Chromosome, Start, End)

amp_overlap <- foverlaps(cnvs, amp_region) %>%
  mutate(CopyNumber_Status = ifelse(cn > 3, "AMP", 
                                    ifelse(cn < 1, "HOMDEL", 
                                           ifelse(cn == 1, "HETLOSS", "GAIN")))) %>%
  filter(CNV.Class == CopyNumber_Status) %>%
  unite("Feature", c("Gene", "CNV.Class"), sep = "_")

nfkbiz_amp <- amp_overlap %>%
  group_by(Patient_ID, Feature) %>%
  summarise(mut_count=n()) %>%
  complete(Feature, nesting(Patient_ID), fill = list(mut_count = NA)) %>%
  ungroup() %>%
  spread(Feature, mut_count,fill=0) %>%
  drop_na() %>%
  as.data.table() %>%
  select(Patient_ID, NFKBIZ_AMP)

all_cnvs_nfkbiz_amp_dlc <- merge(copynum_summary, nfkbiz_amp, all = TRUE) %>%
  merge(cnvs %>% select(Patient_ID) %>% unique(), by = "Patient_ID", all = TRUE) %>%
  mutate_if(is.numeric, list(~replace(., is.na(.), 0))) %>%
  mutate_if(is.numeric, list(~replace(., . > 1, 1)))


# write files ------------------------------------------------------------------------------------------------------------------------------------------  
fwrite(all_cnvs_nfkbiz_amp_dlc, file = "~/Chapuy_cnv/chapuy_cnv_matrix.tsv", sep = "\t", quote = FALSE, row.names = TRUE)
