#' @title build elfie index
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id_base character giving feature type a unique id in @id url like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' 
build_elf_index_list <- function(id_base, tsv_data, key, include_missing = FALSE) {
  tsv_data <- lapply(tsv_data, elfie_sub)
  
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
    
    if(grepl("Polygon", geojson_geometry$type)) geo_name = "polygon"
    if(grepl("Line", geojson_geometry$type)) geo_name = "line"
    
    if(is.null(id)) stop("must specify an id for geojson")
    
    out <- list("@type" = "schema:GeoShape")
    out[[geo_name]] <- list("@context" = "http://geojson.org/geojson-ld/geojson-context.jsonld",
                                "type" = "Feature",
                                "id" = id,
                                "geometry" = list("type" = geojson_geometry$type,
                                                  "coordinates" = geojson_geometry$coordinates))
    
    return(out)
    
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
#' This function attempts to build an HY_IndirectPosition if it finds a "linearElement" reference.
#' This functionality requires values for: hyf:linearElement, hyf:HY_DistanceFromReferent/interpolative, 
#' and hyf:HY_DistanceDescription and only supports that form of linear referencing.
#' 
build_hyf_net <- function(tsv_data, id, include_missing = F) {
  tsv_data <- lapply(tsv_data, elfie_sub)
  
  outlist <- list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/hyf.jsonld",
                  "@id" = id,
                  "@type" = tsv_data$`rdfs:type`)
  
  if(any(grepl("linearElement", names(tsv_data)))) {
    warning("found a linearElement, attempting to create an HY_IndirectPosition read the docs for limitations")
    
    linref <- list(referencedPosition = 
                     list(HY_IndirectPosition = 
                            list(distanceExpression = 
                                   list(HY_DistanceFromReferent = 
                                          list(interpolative = tsv_data$`hyf:HY_DistanceFromReferent/interpolative`)),
                                 distanceDescription = 
                                   list(HY_DistanceDescription = tsv_data$`hyf:HY_DistanceDescription`),
                                 linearElement = tsv_data$`hyf:linearElement`)))
    
    tsv_data$`hyf:linearElement` <- 
      tsv_data$`hyf:HY_DistanceFromReferent/interpolative` <- 
      tsv_data$`hyf:HY_DistanceDescription` <- NULL
    
    outlist <- c(outlist, linref)
    
  }
  
  for(i in 1:length(names(tsv_data))) {
    if(grepl("hyf:", names(tsv_data)[i])) {
      outlist <- c(outlist, hyf_mapper(names(tsv_data)[i], tsv_data[[names(tsv_data)[i]]]))
    }
  }
  
  outlist <- check_outlist(outlist)
  
  if(!include_missing) {
    return(remove_missing(outlist))
  } else {
    return(outlist)
  }
  
}

hyf_mapper <- function(name, value) {
  out <- list()
  
  if(grepl("/", name)) {
    extension <- strsplit(name, "/")[[1]]
    
    name <- extension[1]
    
    if(length(extension) > 2) {
      stop("nesting deeper than 1 not supported yet.")
    }
    
    value_list <- list()
    value_list[[extension[2]]] <- value
    
    value <- value_list
  }
  
  tryCatch({
    mapper <- list(`hyf:upstreamWaterBody` = "upstreamWaterBody",
                   `hyf:downstreamWaterBody` = "downstreamWaterBody",
                   `hyf:lowerCatchment` = "lowerCatchment",
                   `hyf:upperCatchment` = "upperCatchment",
                   `hyf:realizedCatchment` = "realizedCatchment",
                   `hyf:catchmentRealization` = "catchmentRealization",
                   `hyf:contributingCatchment` = "contributingCatchment",
                   `hyf:outflow` = "outflow",
                   `hyf:nexusRealization` = "nexusRealization",
                   `hyf:networkStation` = "networkStation",
                   `hyf:hydrometricNetwork` = "hydrometricNetwork",
                   `hyf:HY_HydroLocationType` = "HY_HydroLocationType",
                   `hyf:linearElement` = "linearElement",
                   `hyf:HY_DistanceFromReferent` = "HY_DistanceFromReferent",
                   `hyf:HY_DistanceDescription` = "HY_DistanceDescription")
    
    out[[mapper[[name]]]] <- value
  }, error = function(e) {
    warning(paste(e, name, "\n", value))
  })
  
  return(out)
}

sosa_mapper <- function(name, value) {
  out <- list()
  tryCatch({
    mapper <- list(`sosa:hasFeatureOfInterest` = "hasFeatureOfInterest",
                   `sosa:hasResult` = "hasResult",
                   `sosa:observedProperty` = "observedProperty",
                   `sosa:phenomenonTime` = "phenomenonTime",
                   `sosa:resultTime` = "resultTime",
                   `sosa:madeBySensor` = "madeBySensor",
                   `sosa:usedProcedure` = "usedProcedure",
                   `time:hasBeginning` = "hasBeginning",
                   `time:hasEnd` = "hasEnd",
                   `geo:hasGeometry` = "hasGeometry",
                   `sosa:isSampleOf` = "isSampleOf",
                   `sosa:isFeatureOfInterestOf` = "isFeatureOfInterestOf",
                   `sosa:hasSampleRelationship` = "hasSampleRelationship",
                   `sosa:natureOfRelationship` = "natureOfRelationship",
                   `sosa:relatedSample` = "relatedSample")
  }, error = function(e) {
    warn(paste(e, "\n", "name", "\n", "value"))
  })
  out[[mapper[[name]]]] <- value
  return(out)
}

remove_missing <- function(x) {
  x[sapply(x, is.null)] <- NULL
  x[sapply(x, is.na)] <- NULL
  return(x)
}

elfie_sub <- function(x) gsub("elfie/", "https://opengeospatial.github.io/ELFIE/", x)

check_outlist <- function(outlist) {
  dups <- grepl("_\\|_", outlist)
  if(any(dups)) {
    outlist[[which(dups)]] <- strsplit(outlist[dups][[1]], split = "_\\|_")
  }
  outlist
}
