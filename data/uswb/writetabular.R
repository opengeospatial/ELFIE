library(jsonlite)

huc12pp <- fromJSON("usgs_huc12pp_uswb.json")
huc12boundary <- fromJSON("usgs_huc12boundary_uswb.json")
nhdplusflowline <- fromJSON("usgs_nhdplusflowline_uswb.json")

hucs <- huc12pp$features$properties$HUC_12

preds <- c("jsonkey_huc12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image")

huc12boundary_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12boundary_info) <- preds
rownames(huc12boundary_info) <- huc12boundary$features$properties$huc12

huc12boundary_info$jsonkey_huc12 <- rownames(huc12boundary_info)
huc12boundary_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_CatchmentDivide"
huc12boundary_info$`schema:name` <- huc12boundary$features$properties$name
huc12boundary_info$`schema:description` <- "comment describing each watershed at a high level"
huc12boundary_info$`hyf:realizedCatchment` <- paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/", huc12boundary$features$properties$huc12)

write.table(huc12boundary_info, file = "usgs_huc12boundary_uswb.tsv", sep = "\t", row.names = F)

# HUC12 Pour Points
preds <- c("jsonkey_HUC_12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image")

huc12pp_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12pp_info) <- preds
rownames(huc12pp_info) <- huc12pp$features$properties$HUC_12
huc12pp_info$jsonkey_HUC_12 <- rownames(huc12pp_info)
huc12pp_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_HydroNexus"
huc12pp_info$`schema:name` <- paste("Outlet of",
                                   huc12boundary$features$properties$name[match(rownames(huc12boundary_info),
                                                                                rownames(huc12pp_info))])
huc12pp_info$`schema:description` <- "comment describing the outlet of each watershed"
huc12pp_info$`hyf:contributingCatchment` <- paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/", huc12boundary$features$properties$huc12)
huc12pp_info$`hyf:catchmentRealization` <- paste0("elfie/usgs/huc12/", rownames(huc12pp_info))

write.table(huc12boundary_info, file = "usgs_huc12pp_uswb.tsv", sep = "\t", row.names = F)

# NHDPlus FlowLines 
preds <- c("jsonkey_huc12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image", "hyf:realizedCatchment")

fline_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))
names(fline_info) <- preds
rownames(fline_info) <- nhdplusflowline$features$properties$huc12
fline_info$jsonkey_huc12 <- rownames(fline_info)
fline_info$`rdfs:type` <- "hyf:HY_HydrographicNetwork"
fline_info$`schema:name` <- paste("Hydro Network of",
                                    huc12boundary$features$properties$name[match(rownames(huc12boundary_info),
                                                                                 rownames(fline_info))])
fline_info$`schema:description` <- "comment describing the network of each watershed"
fline_info$`hyf:realizedCatchment` <- paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/", huc12boundary$features$properties$huc12)

write.table(huc12boundary_info, file = "usgs_nhdplusflowline_uswb.tsv", sep = "\t", row.names = F)

