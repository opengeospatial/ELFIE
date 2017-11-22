# This script pulls down and formats data for the uswb use case.
library(rgdal)
library(sp)
library(dplyr)
library(NWCEd)
# HUC12 Watershed List
watersheds <- c("070200121110", "070700051701", "031601130201", "160201020603",
                "020401050911", "102600080802", "180201041203", "170601080803",
                "150302040410", "101102050210", "120302030102", "130201011304",
                "051202021001", "051302050708", "050200050808", "140100051906", 
                "100301012008", "170900120202", "180400012103", "010300032404",
                "102200031006", "071000091206", "030701060405", "030300050405",
                "110100040606", "100800071208", "150100120904", "160401081002")

# Watershed Outlets
ws_outlet_wfs_base <- "https://www.sciencebase.gov/catalogMaps/mapping/ows/5762b664e4b07657d19a71ea"
# https://www.sciencebase.gov/catalogMaps/mapping/ows/5762b664e4b07657d19a71ea?service=wfs&request=DescribeFeatureType&version=1.0.0&typeName=sb:fpp
ws_outlet_wfs_typeName <- "sb:fpp"
ws_outlet_wfs_propertyName <- "sb:HUC_12"

ws_boundary_wfs_base <- "https://cida.usgs.gov/nwc/geoserver/ows"
ws_boundary_wfs_typeName <- "WBD:huc12agg"
ws_boundary_wfs_propertyName <- "huc12"

ws_network_nldi_base <- "https://cida.usgs.gov/nldi/huc12pp"

# Dumped from a BIG table Not going to check in:
# COPY (SELECT comid, streamorde FROM public.nhdflowline_network) To '/Users/dblodgett/Documents/Projects/ELFIE/ELFIE/data/uswb/streamorder.csv' With CSV;
ws_network_streamorder <- readr::read_csv("~/Documents/Projects/ELFIE/ELFIE/data/uswb/streamorder.csv",col_names = F)
names(ws_network_streamorder) <- c("comid", "streamorder")

ws_network_streamorder <- ws_network_streamorder %>%
  filter(streamorder > 4)

for(ws in watersheds) {
  print(ws)
  filter<-URLencode(paste0("<Filter><PropertyIsEqualTo><PropertyName>",
                           ws_outlet_wfs_propertyName,
                           "</PropertyName><Literal>",
                           ws,
                           "</Literal></PropertyIsEqualTo></Filter>"))

  dataURL<-paste0(ws_outlet_wfs_base,
                  "?service=WFS&version=1.0.0&request=GetFeature&typeName=",
                  ws_outlet_wfs_typeName,
                  "&filter=",filter,
                  "&outputFormat=application/json&srsName=EPSG:4326")

  download.file(dataURL, "temp.geojson", quiet = T)

  ws_outlet <- readOGR(dsn="temp.geojson", layer = "OGRGeoJSON", stringsAsFactors = F, verbose = F)

  filter<-URLencode(paste0("<Filter><PropertyIsEqualTo><PropertyName>",
                           ws_boundary_wfs_propertyName,
                           "</PropertyName><Literal>",
                           ws,
                           "</Literal></PropertyIsEqualTo></Filter>"))

  dataURL<-paste0(ws_boundary_wfs_base,
                  "?service=WFS&version=1.0.0&request=GetFeature&typeName=",
                  ws_boundary_wfs_typeName,
                  "&filter=",filter,
                  "&outputFormat=application/json&srsName=EPSG:4326")

  download.file(dataURL, "temp.geojson", quiet = T)

  ws_boundary <- readOGR(dsn="temp.geojson", layer = "OGRGeoJSON", stringsAsFactors = F, verbose = F)

  dataURL <- paste0(ws_network_nldi_base, "/",
                    ws, "/",
                    "navigate/UT")

  if(dataURL == "https://cida.usgs.gov/nldi/huc12pp/051202021001/navigate/UT") {
    dataURL <- "https://cida.usgs.gov/nldi/nwissite/USGS-03374000/navigate/UT"
  }

  download.file(dataURL, "temp.geojson", quiet = T)

  ws_network <- readOGR(dsn="temp.geojson", layer = "OGRGeoJSON", stringsAsFactors = F, verbose = F)

  # Only keep comids with streamorder that we want.
  keep <- which(ws_network@data$nhdplus_comid %in% ws_network_streamorder$comid)
  ws_network <- ws_network[keep,]

  ws_network_list <- list(length(ws_network@lines))

  for(l in 1:length(ws_network@lines)) {
    ws_network_list[l] <- ws_network@lines[[l]]@Lines
  }

  ws_network <- SpatialLinesDataFrame(SpatialLines(list(Lines(ws_network_list, ID=ws)),
                                          proj4string = ws_network@proj4string),
                             as.data.frame(list(huc12 = ws), stringsAsFactors = F, row.names = ws))

  if(!exists("ws_networks")) {
    ws_outlets <- ws_outlet
    ws_boundaries <- ws_boundary
    ws_networks <- ws_network
  } else {
    ws_outlets <- rbind(ws_outlets, ws_outlet)
    ws_boundaries <- rbind(ws_boundaries, ws_boundary)
    ws_networks <- rbind(ws_networks, ws_network)
  }
}

writeOGR(ws_outlets,"usgs_huc12pp_uswb.geojson", layer = "usgs_huc12pp_uswb", driver = "GeoJSON")
writeOGR(ws_boundaries, "usgs_huc12boundary_uswb.geojson", layer = "usgs_huc12boundary_uswb", driver = "GeoJSON")
writeOGR(ws_networks, "usgs_nhdplusflowline_uswb.geojson", layer = "usgs_nhdplusflowline_uswb", driver = "GeoJSON")

if(!exists("wb_data")) wb_data <- list()
for(ws in watersheds) {
  print(paste0("https://cida.usgs.gov/nwc/#!waterbudget/achuc/",ws))
  wb_data[ws] <- list(getNWCData(ws, local = F))
}

saveRDS(wb_data, "wb_data.rds")
