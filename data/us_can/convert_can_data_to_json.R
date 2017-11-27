setwd("~/Documents/Projects/ELFIE/ELFIE/data/us_can/")
library(sf)

can_watersheds <- sf::st_layers("can/Watersheds.gdb/")
can_watersheds <- can_watersheds$name[3]
can_watersheds <- sf::read_sf("can/Watersheds.gdb/", layer = can_watersheds)

can_aquifer <- sf::read_sf("can/richelieu_aq/richelieu_aq.shp")

can_well <- sf::read_sf("can/rich_well/richelieu_well.shp") 

can_mon_well <- sf::read_sf("can/mon_rich/mon_rich.shp")

can_hydat <- sf::st_layers("can/Hydat_converted_Champlain.gdb") # Not sure why this doesn't work
# ogrinfo Hydat_converted_Champlain.gdb did work grapping "GageLoc" layer
can_hydat <- sf::read_sf("can/Hydat_converted_Champlain.gdb/", layer = "GageLoc")

sf::write_sf(sf::st_transform(can_watersheds, crs = "+init=epsg:4326"), "nrcan_watersheds_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_aquifer, crs = "+init=epsg:4326"), "nrcan_aquifer_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_well, crs = "+init=epsg:4326"), "nrcan_well_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_mon_well, crs = "+init=epsg:4326"), "nrcan_mon-well_cr.json", driver = "GeoJSON")
sf::write_sf(sf::st_transform(can_hydat, crs = "+init=epsg:4326"), "nrcan_hydat_cr.json", driver = "GeoJSON")

us_nhdplusflowline <- sf::read_sf("usgs_nhdplusflowline_cr.json")
us_nwissite <- sf::read_sf("usgs_nwissite_cr.json")
us_WUBHU8 <- sf::read_sf("usgs_WBDHU8_cr.json")
us_wqp <- sf::read_sf("usgs_wqp_cr.json")

wqp_ids <- wqp$features$properties$identifier

# library(dataRetrieval)
# sites <- list()
# for(site in wqp_ids) {
#   sites[site] <- list(whatWQPsites(siteid=site))
# }

# can_aquifer
preds <- c("jsonkey_id_code",	"rdfs:type",	"schema:name",
           "schema:description", "schema:sameAs", "schema:image")

can_aquifer_info <- data.frame(matrix(nrow = nrow(can_aquifer), ncol = length(preds)))
names(can_aquifer_info) <- preds
rownames(can_aquifer_info) <- can_aquifer$id_code

can_aquifer_info$jsonkey_id_code <- can_aquifer$id_code
can_aquifer_info$`rdfs:type` <- "gwml2:GW_HydrogeoUnit"
can_aquifer_info$`schema:name` <- can_aquifer$id_code
can_aquifer_info$`schema:description` <- "description not available"
can_aquifer_info$`schema:sameAs` <- "need a sameas url for each aquifer?"
can_aquifer_info$`schema:image` <- NA

write.table(can_aquifer_info, file = "can_aquifer_cr.tsv", sep = "\t", row.names = F)

# can_hydat
preds[1] <- "jsonkey_Source_FeatureID"

can_hydat_info <- data.frame(matrix(nrow = nrow(can_hydat), ncol = length(preds)))
names(can_hydat_info) <- preds
rownames(can_hydat_info) <- can_hydat$Source_FeatureID

can_hydat_info$jsonkey_Source_FeatureID <- can_hydat$Source_FeatureID
can_hydat_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_HydrometricFeature"
can_hydat_info$`schema:name` <- can_hydat$Source_FeatureID
can_hydat_info$`schema:description` <- "description not available"
can_hydat_info$`schema:sameAs` <- can_hydat$FeatureDetailURL
can_hydat_info$`schema:image` <- NA

write.table(can_hydat_info, file = "can_hydat_cr.tsv", sep = "\t", row.names = F)

# can_mon_well
preds[1] <- "jsonkey_feature_of"

can_mon_well_info <- data.frame(matrix(nrow = nrow(can_mon_well), ncol = length(preds)))
names(can_mon_well_info) <- preds
rownames(can_mon_well_info) <- can_mon_well$feature_of

can_mon_well_info$jsonkey_feature_of <- can_mon_well$feature_of
can_mon_well_info$`rdfs:type` <- "gwml2:GW_MonitoringSite"
can_mon_well_info$`schema:name` <- can_mon_well$feature__2
can_mon_well_info$`schema:description` <- "description not available"
can_mon_well_info$`schema:sameAs` <- can_mon_well$schema_lin
can_mon_well_info$`schema:image` <- NA

write.table(can_mon_well_info, file = "can_mon_well_cr.tsv", sep = "\t", row.names = F)

# can_watersheds
preds[1] <- "jsonkey_HUC_8"

can_watersheds_info <- data.frame(matrix(nrow = nrow(can_watersheds), ncol = length(preds)))
names(can_watersheds_info) <- preds
rownames(can_watersheds_info) <- can_watersheds$HUC_8

can_watersheds_info$jsonkey_HUC_8 <- can_watersheds$HUC_8
can_watersheds_info$`rdfs:type` <- "http://www.opengeospatial.org/standards/waterml2/hy_features/HY_CatchmentDivide"
can_watersheds_info$`schema:name` <- can_watersheds$SUBBASIN
can_watersheds_info$`schema:description` <- paste(can_watersheds$REGION, can_watersheds$SUBREGION, can_watersheds$BASIN)
can_watersheds_info$`schema:sameAs` <- NA
can_watersheds_info$`schema:image` <- NA

write.table(can_watersheds_info, file = "can_watersheds_cr.tsv", sep = "\t", row.names = F)

# can_well
preds[1] <- "jsonkey_statid"

can_well_info <- data.frame(matrix(nrow = nrow(can_well), ncol = length(preds)))
names(can_well_info) <- preds
rownames(can_well_info) <- can_well$statid

can_well_info$jsonkey_statid <- can_well$statid
can_well_info$`rdfs:type` <- "gwml2:GW_Well"
can_well_info$`schema:name` <- NA
can_well_info$`schema:description` <- "description not available"
can_well_info$`schema:sameAs` <- NA
can_well_info$`schema:image` <- NA

write.table(can_well_info, file = "can_well_cr.tsv", sep = "\t", row.names = F)


# us_nhdplusflowline
# us_nwissite
# us_wqp
# us_WUBHU8
