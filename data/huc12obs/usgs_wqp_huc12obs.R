# relative to ELFIE project root.
setwd("data/huc12_obs")

library(jsonlite)

wqp <- fromJSON("usgs_wqp_070900020601.json")
wqp_ids <- wqp$features$properties$identifier

# library(dataRetrieval)
# sites <- list()
# for(site in wqp_ids) {
#   sites[site] <- list(whatWQPsites(siteid=site))
# }
# saveRDS(sites, "usgs_wqp_070900020601.rds")

sites <- readRDS("usgs_wqp_070900020601.rds")

preds <- c("jsonkey_identifier",	"rdfs:type",	"rdfs:label",	"rdfs:comment",	"owl:versionInfo",	"dcterms:creator",	"owl:sameAs",	"dcterms:license",	"foaf:img")

wqp_site_info <- data.frame(matrix(nrow = length(sites), ncol = length(preds)))

names(wqp_site_info) <- preds
rownames(wqp_site_info) <- names(sites)

for(site in names(sites)) {
  wqp_site_info[site,"jsonkey_identifier"] <- sites[site][[1]]$MonitoringLocationIdentifier
  wqp_site_info[site, "rdfs:type"] <- "https://waterqualitydata.us/def/site" # made this up.
  wqp_site_info[site, "rdfs:label"] <- sites[site][[1]]$MonitoringLocationName
  #wqp_site_info[site, "rdfs:comment"] <- sites[site][[1]]
  wqp_site_info[site, "dcterms:creator"] <- paste0("https://www.waterqualitydata.us/provider/STORET/", sites[site][[1]]$OrganizationFormalName)
  wqp_site_info[site, "owl:sameAs"] <- paste0("https://www.waterqualitydata.us/provider/STORET/", 
                                              sites[site][[1]]$OrganizationFormalName, "/",
                                              sites[site][[1]]$MonitoringLocationIdentifier)
}
  
write.table(wqp_site_info, file = "usgs_wqp_070900020601.tsv", sep = "\t", row.names = F)  
  
