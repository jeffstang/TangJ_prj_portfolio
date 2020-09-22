library(ComplexHeatmap)
library(tidyverse)
library(circlize)

setwd("~/results/complex_heatmap/")

# Load data ---------------------------------------------------------------

dlc_schmitz <- read_tsv("~/Jeffrey_Masters/dlbcl_classification/analysis/clusters/combined_cohorts_include_ashm/results/schmitzdlc_ftmat_clustassigned.tsv") 
annotations_raw <- read_tsv("schmitzdlc_metadata_coo_clusters.tsv")
gene_order <- read_tsv("~/Jeffrey_Masters/dlbcl_classification/analysis/clusters/combined_cohorts_include_ashm/data/metadata/genes_of_interest_sig_chisq_test_top5.tsv")

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
  #mutate(double_sort_num2 = double_sort(LymphGen, COO),
  #       double_sort_tot = double_sort_num+double_sort_num2,
  #       PID = fct_reorder(PID, double_sort_tot)) %>%
  arrange(PID)

# dlc_Schmitz_depleted_mat <- 
#   annotations %>% 
#   select(PID) %>% 
#   left_join(dlcschmitz_depleted, by = "PID")

dlc_schmitz_mat <- 
  dlc_schmitz %>% 
  filter(PID %in% annotations$PID) %>% 
  mutate(PID = factor(PID, levels(annotations$PID))) %>%
  arrange(PID) %>%
  select(-ClusterICL)

ordered_mat <- 
  dlc_schmitz_mat %>% 
  select(-ClusterAIC) %>%
  pivot_longer(-PID, names_to = "Feature", values_to = "mut_count") %>%
  pivot_wider(names_from = PID, values_from = mut_count) %>% 
  as.data.frame()

ordered_mat <- gene_order %>% 
  mutate(Clustering = gsub("KRAS_Nonsyn", "BCL7A", Clustering)) %>%
  select(Feature) %>% 
  left_join(ordered_mat) %>%
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
                                 "TARP_LOSS/BCL7A" = "#EB7EB1",
                                 "INPP4B_LOSS/PCDH7_LOSS" = "#2579B5"),
                "COO" = c("GCB" = "#F58F20",
                          "PMBL" = "#8A73EA",
                          "UNC" = "#23AD43",
                          "ABC" = "#05ACEF"),
                # Clusters from paper
                "LymphGen" = c("Other" = "#fff7bc",
                               "MCD" = "#0c0eef",
                               "BN2" = "#c51b8a",
                               "EZB" = "#d95f0e",
                               "A53" = "#abcdef",
                               "ST2" = "#2cd5c4",
                               "EZB/ST2/A53" = "#9fcfbe",
                               "EZB/A53" = "#dabca3",
                               "MCD/A53" = "#ffb6c1",
                               "BN2/MCD" = "#b3c5f8",
                               "EZB/ST2" = "#000000",
                               "ST2/A53" = "#d3ffc3",
                               "N1/A53" = "#e1fcff",
                               "BN2/ST2" = "#fa4d57",
                               "BN2/EZB" = "#123456",
                               "BN2/A53" = "#304860",
                               "N1/ST2" = "#E01E26",
                               "EZB/ST2/A53" = "#05ACEF",
                               "MCD/ST2" = "#41AA48",
                               "EZB/N1/ST2/A53" = "#E6AB02",
                               "EZB/MCD" = "#7570B3",
                               "N1" = "#1B9E77"))

# colAnn <- HeatmapAnnotation(df=ha, which="col", 
#                             col=colours, 
#                             annotation_width=unit(c(1, 4), "cm"), 
#                             gap=unit(1, "mm"))

colAnn_df <- 
  annotations %>% 
  select(PID, ClusterAIC , COO, LymphGen, Cohort) %>% 
  as.data.frame() %>% 
  column_to_rownames("PID")

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

Heatmap(ordered_mat, 
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
