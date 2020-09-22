# Adopted from Prasath's munion code

library(data.table)
library(tidyverse)

setwd("~/Jeffrey_Masters/results/compare_maf/")

dlc_new <- fread("DLC_CAPPSeq_380.maf") %>%
# reformat PID
  mutate(Tumor_Sample_Barcode = gsub(".mdups.bqsr.grch37", "", Tumor_Sample_Barcode)) %>%
  mutate(Chromosome = gsub("X", "23", Chromosome)) %>%
  mutate(Chromosome = gsub("Y", "24", Chromosome)) %>%
  mutate(Chromosome = as.integer(Chromosome)) %>%
  as.data.table()

dlc_old <- fread("2019-07-13.DLC380.maf") %>%
  mutate(Chromosome = gsub("X", "23", Chromosome)) %>%
  mutate(Chromosome = gsub("Y", "24", Chromosome)) %>%
  mutate(Chromosome = as.integer(Chromosome)) %>%
  as.data.table()

z <- merge(dlc_old, 
      dlc_new, 
      by = c("Tumor_Sample_Barcode", "Chromosome", "Start_Position", 
              "End_Position", "Tumor_Seq_Allele2", "Variant_Type"),
      all = TRUE) %>%
  select(Tumor_Sample_Barcode, Chromosome, Start_Position, End_Position, 
         Tumor_Seq_Allele2, Variant_Type, Hugo_Symbol.x, Hugo_Symbol.y, Variant_Classification.x, Variant_Classification.y)


x_only <- z %>% 
  filter(is.na(Hugo_Symbol.y) & !is.na(Hugo_Symbol.x))

y_only <- z %>% 
  filter(is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y))

xy <- z %>% 
  filter(!is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y))

all_variants <- setDT(rbind(x_only, y_only, xy)) %>%
  rename(Hugo_Symbol_old = Hugo_Symbol.x, 
         Hugo_Symbol_new = Hugo_Symbol.y)


# Filter for nonsynonymous mutations --------------------------------------

vclass <- list()

vclass$genic <- 
  c("Frame_Shift_Del", "Frame_Shift_Ins", "In_Frame_Del", "In_Frame_Ins", 
    "Missense_Mutation", "Nonsense_Mutation", "Silent", "Splice_Site", 
    "Translation_Start_Site", "Nonstop_Mutation", "3'UTR", "5'UTR", 
    "3'Flank", "5'Flank", "Intron")

vclass$silent <- c("3'UTR", "5'UTR", "3'Flank", "5'Flank", "Intron", "Silent")

vclass$nonsyn <- setdiff(vclass$genic, vclass$silent)

# Parse out t_ref and t_alt counts to calculate VAF ----------------------

z_VAF <- merge(dlc_old, 
           dlc_new, 
           by = c("Tumor_Sample_Barcode", "Chromosome", "Start_Position", 
                  "End_Position", "Tumor_Seq_Allele2", "Variant_Type"),
           all = TRUE) %>%
  select(Tumor_Sample_Barcode, Chromosome, Start_Position, End_Position, 
         Tumor_Seq_Allele2, Variant_Type, Hugo_Symbol.x, Hugo_Symbol.y, 
         Variant_Classification.x, Variant_Classification.y, 
         t_alt_count.x, t_ref_count.x, t_alt_count.y, t_ref_count.y)

x_only_vaf <- z_VAF %>% 
  filter(is.na(Hugo_Symbol.y) & !is.na(Hugo_Symbol.x)) %>%
  filter(Variant_Classification.x %in% vclass$nonsyn) %>%
  mutate(VAF_old = t_alt_count.x/(t_alt_count.x+t_ref_count.x))
  
y_only_vaf <- z_VAF %>% 
  filter(is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y)) %>%
  filter(Variant_Classification.y %in% vclass$nonsyn) %>%
  mutate(VAF_new = t_alt_count.y/(t_alt_count.y+t_ref_count.y))

xy_vaf <- z_VAF %>% 
  filter(!is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y)) %>%
  filter(Variant_Classification.x == Variant_Classification.y) %>%
  filter(Variant_Classification.x %in% vclass$nonsyn) %>%
  mutate(VAF_old = t_alt_count.x/(t_alt_count.x+t_ref_count.x)) %>%
  mutate(VAF_new = t_alt_count.y/(t_alt_count.y+t_ref_count.y))

cohort_x <- x_only_vaf %>%
  mutate(type = "old_maf") %>%
  select(type, VAF = VAF_old)

cohort_y <- y_only_vaf %>%
  mutate(type = "new_maf") %>%
  select(type, VAF = VAF_new)

cohort_xy <- xy_vaf %>%
  mutate(type = "intersect") %>%
  select(type, VAF = VAF_old)

vafs_compare <- rbind(cohort_x, cohort_y, cohort_xy)

ggplot(vafs_compare, aes(x = type, y = VAF, color = type, fill = type)) +
         geom_violin()
       
       