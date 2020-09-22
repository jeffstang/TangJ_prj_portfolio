library(ComplexHeatmap)
library(tidyverse)
library(circlize)

setwd("~/Jeffrey_Masters/results/complex_heatmap/")

# Load data ---------------------------------------------------------------

dlcschmitz_depleted <- read_tsv("depleted_features.tsv") 
annotations_raw <- read_tsv("schmitzdlc_metadata_coo_clusters.tsv")
gene_order <- read_tsv("schmitz_dlc_metadata_gene_order.tsv")

# Sort data ---------------------------------------------------------------

double_sort <- function (x, y) {
  x_num <- as.integer(as.factor(x))
  y_num <- as.integer(as.factor(y))
  ordering <- x_num + (1 / (-y_num + max(y_num) + 2))
  ordering
}

annotations <- 
  annotations_raw %>%
  mutate(double_sort_num = double_sort(ClusterAIC, COO),
         PID = fct_reorder(PID, double_sort_num)) %>%
  arrange(PID)

# dlc_Schmitz_depleted_mat <- 
#   annotations %>% 
#   select(PID) %>% 
#   left_join(dlcschmitz_depleted, by = "PID")

dlc_Schmitz_depleted_mat <- 
  dlcschmitz_depleted %>% 
  filter(PID %in% annotations$PID) %>% 
  mutate(PID = factor(PID, levels(annotations$PID))) %>% 
  filter(ClusterAIC != "INPP4B_LOSS/PCDH7_LOSS") %>%
  arrange(PID)

ordered_mat <- 
  dlc_Schmitz_depleted_mat %>% 
  select(-ClusterAIC) %>%
  pivot_longer(-PID, names_to = "Feature", values_to = "mut_count") %>%
  pivot_wider(names_from = PID, values_from = mut_count) %>% 
  as.data.frame() %>% 
  column_to_rownames("Feature") %>% 
  as.matrix()

# order_by_cluster_and_gene <- 
#   gene_order %>% 
#   select(Feature) %>%
#   unique() %>%
#   left_join(ordered_mat, by = "Feature") %>%
#   column_to_rownames("Feature")


# Set colours and heatmap annotations -------------------------------------

col_fun <- colorRamp2(c(0,1), c("white", "black"))
# col_fun(seq(-3,3))

# ha <- data.frame(annotations$class, annotations$COO)
# colnames(ha) <- c("class", "coo")
colours <- list("ClusterAIC" = c("BCL2/EZH2_646"= "#F37A20", 
                                 "CXCR4/ST6GAL1" = "#8494FF",
                                 "DTX1/PAX5" = "#E01E26",
                                 "MALT1_GAIN/NFKBIZ_AMP" = "#41AA48",
                                 "MYD88_L265/CDKN2A_LOSS" = "#934599",
                                 "TARP_LOSS/KRAS_Nonsyn" = "#EB7EB1"),
                "COO" = c("GCB" = "#F58F20",
                          "PMBL" = "#8A73EA",
                          "UNC" = "#23AD43",
                          "ABC" = "#05ACEF"))

# colAnn <- HeatmapAnnotation(df=ha, which="col", 
#                             col=colours, 
#                             annotation_width=unit(c(1, 4), "cm"), 
#                             gap=unit(1, "mm"))

colAnn_df <- 
  annotations %>% 
  select(PID, ClusterAIC , COO) %>% 
  as.data.frame() %>% 
  column_to_rownames("PID") %>%
  filter(ClusterAIC != "INPP4B_LOSS/PCDH7_LOSS")

colAnn <- 
  HeatmapAnnotation(colAnn_df, which="column", col=colours, gap=unit(1, "mm"), 
                    annotation_width=unit(c(1, 4), "cm"))

clusters <- unique(gene_order$Clustering)

# Create separate heatmaps for each cluster with different set of  --------
# depleted features -------------------------------------------------------
heatmaps <- list()
for (cluster in clusters) {
  
  depleted_features <- 
    gene_order %>% 
    filter(Clustering == cluster) %>% 
    pull(Feature)
  
  heatmaps[cluster] <- 
    Heatmap(ordered_mat[depleted_features,], 
            col = col_fun,
            name = "mut_status",
            row_names_gp = gpar(fontsize = 8),
            top_annotation = colAnn,
            show_column_names = FALSE,
            cluster_rows = FALSE,
            cluster_columns = FALSE,
            # cluster_column_slices = FALSE,
            column_dend_reorder = FALSE,
            row_dend_reorder = FALSE,
            show_column_dend = FALSE)
  
}


for(i in heatmaps) {
  pdf(paste("heatmap", i, ".pdf", sep = ""))
  print(heatmaps[i])
  dev.off()
}

Heatmap(ordered_mat, 
          col = col_fun,
          name = "mut_status",
          row_names_gp = gpar(fontsize = 8),
          top_annotation = colAnn,
          show_column_names = FALSE,
          cluster_rows = TRUE,
          cluster_columns = FALSE,
          # cluster_column_slices = FALSE,
          column_dend_reorder = FALSE,
          row_dend_reorder = FALSE,
          show_column_dend = FALSE)
