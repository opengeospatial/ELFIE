setwd("~/Documents/Projects/ELFIE/ELFIE/data/uswb/")
library(jsonlite)
library(dplyr)

huc12pp <- fromJSON("usgs_huc12pp_uswb.json")
huc12boundary <- fromJSON("usgs_huc12boundary_uswb.json")
nhdplusflowline <- fromJSON("usgs_nhdplusflowline_uswb.json")
nwis_sites <- fromJSON("usgs_nwissite_uswb.json")

huc_nwis <- readr::read_delim("huc_nwis.csv", delim = "\t")

nwis_sites$features$properties <-dplyr::left_join(nwis_sites$features$properties, huc_nwis, by = c("site_no" = "nwis"))

hucs <- huc12pp$features$properties$HUC_12

### huc12boundary_info
preds <- c("jsonkey_huc12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image")

huc12boundary_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12boundary_info) <- preds
rownames(huc12boundary_info) <- huc12boundary$features$properties$huc12

huc12boundary_info$jsonkey_huc12 <- rownames(huc12boundary_info)
huc12boundary_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_CatchmentDivide"
huc12boundary_info$`schema:name` <- huc12boundary$features$properties$name
huc12boundary_info$`schema:description` <- "comment describing each watershed at a high level"
huc12boundary_info$`hyf:realizedCatchment` <- paste0("elfie/usgs/huc12/uswb/", huc12boundary$features$properties$huc12)

write.table(huc12boundary_info, file = "usgs_huc12boundary_uswb.tsv", sep = "\t", row.names = F)

### huc12pp_info 
preds <- c("jsonkey_HUC_12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image", 
           "hyf:contributingCatchment", "hyf:nexusRealization")

huc12pp_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))

names(huc12pp_info) <- preds
rownames(huc12pp_info) <- huc12pp$features$properties$HUC_12

huc12pp_info$jsonkey_HUC_12 <- rownames(huc12pp_info)
huc12pp_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_HydroNexus"
huc12pp_info$`schema:name` <- paste("Outlet of",
                                   huc12boundary$features$properties$name[match(rownames(huc12boundary_info),
                                                                                rownames(huc12pp_info))])
huc12pp_info$`schema:description` <- "comment describing the outlet of each watershed"
huc12pp_info$`hyf:contributingCatchment` <- paste0(paste0("elfie/usgs/huc12/uswb/", huc12pp$features$properties$HUC_12))

huc12pp_info <- left_join(huc12pp_info, huc_nwis, by = c("jsonkey_HUC_12" = "huc12")) %>%
  mutate(`hyf:nexusRealization` = paste0("elfie/usgs/nwissite/uswb/", nwis)) %>%
  select(-nwis)

write.table(huc12pp_info, file = "usgs_huc12pp_uswb.tsv", sep = "\t", row.names = F)

### fline_info
preds <- c("jsonkey_huc12",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image", 
           "hyf:realizedCatchment", "hyf:networkStation")

fline_info <- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))
names(fline_info) <- preds
rownames(fline_info) <- nhdplusflowline$features$properties$huc12

fline_info$jsonkey_huc12 <- rownames(fline_info)
fline_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_HydrographicNetwork"
fline_info$`schema:name` <- paste("Hydro Network of",
                                    huc12boundary$features$properties$name[match(rownames(huc12boundary_info),
                                                                                 rownames(fline_info))])
fline_info$`schema:description` <- "comment describing the network of each watershed"
fline_info$`hyf:realizedCatchment` <- paste0("elfie/usgs/huc12/uswb/", huc12boundary$features$properties$huc12)

fline_info <- left_join(fline_info, huc_nwis, by = c("jsonkey_huc12" = "huc12")) %>%
  mutate(`hyf:networkStation` = paste0("https://waterdata.usgs.gov/nwis/inventory/?site_no=", nwis)) %>%
  select(-nwis)

write.table(fline_info, file = "usgs_nhdplusflowline_uswb.tsv", sep = "\t", row.names = F)

### huc12
huc12 <- huc12boundary_info %>%
  mutate(`schema:sameAs` = `hyf:realizedCatchment`) %>%
  select(-`hyf:realizedCatchment`) %>%
  mutate(`rdfs:type` = "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_Catchment")

huc12 <- cbind(huc12,  
               list(`hyf:catchmentRealization` = paste0("elfie/usgs/huc12boundary/uswb/", hucs, 
                                                        "_|_", 
                                                        "elfie/usgs/nhdplusflowline/uswb/", hucs)),
               list(`hyf:outflow` = paste0("elfie/usgs/huc12pp/uswb/", hucs)))

write.table(huc12, file = "usgs_huc12_uswb.tsv", sep = "\t", row.names = F)

### nwissite
preds <- c("jsonkey_site_no",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image",
           "hyf:HY_HydroLocationType", "hyf:realizedNexus")

nwissite<- data.frame(matrix(nrow = length(hucs), ncol = length(preds)))
names(nwissite) <- preds
rownames(nwissite) <- nwis_sites$features$properties$site_no

nwissite$jsonkey_site_no <- rownames(nwissite)
nwissite$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_HydroLocation"
nwissite$`schema:name` <- nwis_sites$features$properties$station_nm
nwissite$`schema:sameAs` <- paste0("https://waterdata.usgs.gov/nwis/inventory/?site_no=", 
                                   nwis_sites$features$properties$site_no)
nwissite$`schema:image` <- paste0("https://waterdata.usgs.gov/nwisweb/graph?agency_cd=USGS&site_no=", 
                                  nwis_sites$features$properties$site_no, "&parm_cd=00060&period=100")
nwissite$`hyf:HY_HydroLocationType` <- "hydrometricStation"
nwissite$`hyf:realizedNexus` <- paste0("elfie/usgs/huc12pp/uswb/", nwis_sites$features$properties$huc12)

write.table(nwissite, file = "usgs_nwissite_uswb.tsv", sep = "\t", row.names = F)
