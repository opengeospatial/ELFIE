#' @title build elfie index
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id_base character giving feature type a unique id in @id url like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' 
build_elf_index_list <- function(id_base, tsv_data, key, include_missing = FALSE) {
  outlist <- list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/elf-index.jsonld", 
                  "@id" = paste("https://opengeospatial.github.io/ELFIE", 
                                id_base,
                                paste0(tsv_data[1], ".json"), 
                                sep = "/"), 
                  "@type" = tsv_data$`rdfs:type`,
                  "name" = tsv_data$`schema:name`,
                  "description" = tsv_data$`schema:description`,
                  "sameAs" = tsv_data$`schema:sameAs`,
                  "image" = tsv_data$`schema:image`)
  if(!include_missing) {
    return(remove_missing(outlist))
  } else {
    return(outlist)
  }
}

#' @title build schema.org geo
#' @param geojson_geometry geojson data for one feature with coordinates and type fields.
#' @param id character the id of the feature in question like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' 
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

#' @title build elfie net for hy_features
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id character the id of the feature in question like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' @details Note that this can be combined with other elf lists. If it is, care must be 
#' taken to handle the @context, @id, and @type between existing and new content.
#' 
build_hyf_net <- function(tsv_data, id, include_missing = F) {
  tsv_data <- lapply(tsv_data, function(x) gsub("elfie/", "https://opengeospatial.github.io/ELFIE/", x))
  
  outlist <- suppressWarnings(list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/hyf.jsonld",
                  "@id" = id,
                  "@type" = tsv_data$`rdfs:type`,
                  "upstreamWaterBody" = tsv_data$`hyf:upstreamWaterBody`,
                  "downstreamWaterBody" = tsv_data$`hyf:downstreamWaterBody`,
                  "lowerCatchment" = tsv_data$`hyf:lowerCatchment`,
                  "upperCatchment" = tsv_data$`hyf:upperCatchment`,
                  "realizedCatchment" = tsv_data$`hyf:realizedCatchment`,
                  "catchmentRealization" = tsv_data$`hyf:catchmentRealization`,
                  "contributingCatchment" = tsv_data$`hyf:contributingCatchment`,
                  "outflow" = tsv_data$`hyf:outflow`))
  
  if(!include_missing) {
    return(remove_missing(outlist))
  } else {
    return(outlist)
  }
  
}

remove_missing <- function(x) {
  x[sapply(x, is.null)] <- NULL
  x[sapply(x, is.na)] <- NULL
  return(x)
}
