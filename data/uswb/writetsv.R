library(jsonlite)

huc12pp <- fromJSON("usgs_huc12pp_uswb.geojson")
huc12boundary <- fromJSON("usgs_huc12boundary_uswb.geojson")
nhdplusflowline <- fromJSON("usgs_nhdplusflowline_uswb.geojson")

hucs <- huc12pp$features$properties$HUC_12

preds <- c("jsonkey_huc12",	"rdfs:type",	"rdfs:label",	"rdfs:comment",	"owl:versionInfo",	"dcterms:creator",	"owl:sameAs",	"dcterms:license",	"foaf:img")

huc12boundary_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12boundary_info) <- preds
rownames(huc12boundary_info) <- huc12boundary$features$properties$huc12

huc12boundary_info$jsonkey_huc12 <- rownames(huc12boundary_info)
huc12boundary_info$`rdfs:type` <- "hyf:HY_CatchmentDivide"
huc12boundary_info$`rdfs:label` <- huc12boundary$features$properties$name
huc12boundary_info$`rdfs:comment` <- "comment describing each watershed at a high level"
huc12boundary_info$`owl:versionInfo` <- "NHDPlusV2 Watershed Boundary Dataset Snapshot"
huc12boundary_info$`dcterms:creator` <- "U.S. Geological Survey"
huc12boundary_info$`hyf:realizedCatchment` <- paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/", huc12boundary$features$properties$huc12)

write.table(huc12boundary_info, file = "usgs_huc12boundary_uswb.tsv", sep = "\t", row.names = F)

# HUC12 Pour Points
preds <- c("jsonkey_HUC_12",	"rdfs:type",	"rdfs:label",	"rdfs:comment",	"owl:versionInfo",	"dcterms:creator",	"owl:sameAs",	"dcterms:license",	"foaf:img")

huc12pp_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12pp_info) <- preds
rownames(huc12pp_info) <- huc12pp$features$properties$HUC_12
huc12pp_info$jsonkey_HUC_12 <- rownames(huc12pp_info)
huc12pp_info$`rdfs:type` <- "hyf:HY_HydroNexus"
huc12pp_info$`rdfs:label` <- paste("Outlet of",
                                   huc12boundary$features$properties$name[match(rownames(huc12boundary_info),
                                                                                rownames(huc12pp_info))])
huc12pp_info$`rdfs:comment` <- "comment describing the outlet of each watershed"
huc12pp_info$`owl:versionInfo` <- "NHDPlusV2 Watershed Boundary Dataset Snapshot"
huc12pp_info$`dcterms:creator` <- "U.S. Geological Survey"
huc12pp_info$`hyf:contributingCatchment` <- paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/", huc12boundary$features$properties$huc12)
huc12pp_info$`hyf:catchmentRealization` <- paste0("elfie/usgs/huc12/", rownames(huc12pp_info))

write.table(huc12boundary_info, file = "usgs_huc12pp_uswb.tsv", sep = "\t", row.names = F)
