munion <- function(x, y, by = c("Tumor_Sample_Barcode", "Chromosome", "Start_Position", 
                                "End_Position", "Tumor_Seq_Allele2", "Variant_Type"), track = TRUE) {
  # Input:
  #   x, y       Data.tables of MAF files
  #   by         Character vector of columns to merge on.
  #   track      Adds "track" column indicating original variant data.table
  # Output:
  #   Returns a data.table of merged MAFs with a union of variants
  
  z <- merge(x, y, by = by, all = TRUE)
  
  x_only <- z %>% filter(is.na(Hugo_Symbol.y) & !is.na(Hugo_Symbol.x))
  y_only <- z %>% filter(is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y))
  xy <- z %>% filter(!is.na(Hugo_Symbol.x) & !is.na(Hugo_Symbol.y))
  
  if (track) {
    x_only <- x_only[ ,var_origin.x := "x"]
    y_only <- y_only[ ,var_origin.y := "y"]
    xy     <- xy[, var_origin.x := "both"]
  }
  
  x_keys  <- c(by, colnames(x_only)[ends_with(".x", vars = colnames(x_only))])
  y_keys  <- c(by, colnames(y_only)[ends_with(".y", vars = colnames(y_only))])
  xy_keys <- c(by, colnames(x_only)[ends_with(".x", vars = colnames(x_only))])
  
  setnames(x_only, x_keys, gsub(".x$", "", x_keys))
  setnames(y_only, y_keys, gsub(".y$", "", y_keys))
  setnames(xy, xy_keys, gsub(".x$", "", xy_keys))
  
  final_cols <- intersect(colnames(x_only), colnames(y_only))
  
  return(rbind(x_only[, ..final_cols], 
               xy[, ..final_cols], 
               y_only[, ..final_cols]))
}
