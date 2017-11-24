#' @title elfi-index-core
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id_base character giving feature type a unique id in @id url like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' 
build_elf_index_list <- function(id_base, tsv_data, key, include_missing = FALSE) {
  outlist <- list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/elf-index.jsonld", 
                  "@id" = paste("https://opengeospatial.github.io/ELFIE/json-ld", 
                                id_base,
                                tsv_data[1], 
                                sep = "/"), 
                  "@type" = tsv_data$`rdfs:type`,
                  "name" = tsv_data$`schema:name`,
                  "description" = tsv_data$`schema:description`,
                  "sameAs" = tsv_data$`schema:sameAs`,
                  "image" = tsv_data$`schema:image`)
  if(!include_missing) {
    outlist[sapply(outlist, is.null)] <- NULL
    outlist[sapply(outlist, is.na)] <- NULL
  }
  return(outlist)
}

build_schema_geo <- function(geojson_geometry, id = NULL) {
  if(geojson_geometry$type == "Point") {
    return(list("@type" = "schema:GeoCoordinates",
                "latitude" = geojson_geometry$coordinates[[1]][2],
                "longitude" = geojson_geometry$coordinates[[1]][1]))
  } else if(grepl("Polygon", geojson_geometry$type) | grepl("Line", geojson_geometry$type)) {
    if(is.null(id)) stop("must specify an id for geojson")
    return(list("@type" = "schema:GeoShape",
           "polygon" = list("@context" = "http://geojson.org/geojson-ld/geojson-context.jsonld",
                            "type" = "Feature",
                            "id" = id,
                            "geometry" = list("type" = geojson_geometry$type,
                                              "coordinates" = geojson_geometry$coordinates))))
  } else {
    print("Unsupported geometry type. Only supports Point (Multi)Line and (Multi)Polygon")
    return(NULL)
  }
}
