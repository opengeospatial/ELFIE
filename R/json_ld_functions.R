## Constants
out_md <- "../docs/file_index.md"

out_path_base <- "../docs"

elf_url_base <- "https://opengeospatial.github.io/ELFIE"

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
                                tsv_data[1], 
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
#' Some floodcast relations can also be added with this function.
#' 
build_hyf_net <- function(tsv_data, id, include_missing = F) {
  tsv_data <- lapply(tsv_data, elfie_sub)
  
  outlist <- list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/hyf.jsonld",
                  "@id" = id,
                  "@type" = tsv_data$`rdfs:type`)
  
  if(any(grepl("fc:", names(tsv_data)))) {
    outlist$`@context` <- c(outlist$`@context`, 
                            "https://opengeospatial.github.io/ELFIE/json-ld/floodcast.jsonld")
  }
  
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
    if(grepl("fc:", names(tsv_data)[i])) {
      outlist <- c(outlist, floodcast_mapper(names(tsv_data)[i], tsv_data[[names(tsv_data)[i]]]))
    }
  }
  
  outlist <- check_outlist(outlist)
  
  if(!include_missing) {
    return(remove_missing(outlist))
  } else {
    return(outlist)
  }
  
}

#' @title build elfie net as described [here](https://github.com/opengeospatial/ELFIE/wiki/ELFIE-Relations)
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id character the id of the feature in question like:
#' "https://opengeospatial.github.io/ELFIE/json-ld/{{id_base}}/{{id}}"
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' @details Note that this can be combined with other elf lists. If it is, care must be 
#' taken to handle the @context, @id, and @type between existing and new content.
#' 
build_elf_net <- function(tsv_data, id, include_missing = F) {
  tsv_data <- lapply(tsv_data, elfie_sub)
  
  outlist <- list("@context" = "https://opengeospatial.github.io/ELFIE/json-ld/elf-net.jsonld",
                  "@id" = id,
                  "@type" = tsv_data$`rdfs:type`)
  
  for(i in 1:length(names(tsv_data))) {
    if(grepl("gsp:", names(tsv_data)[i])) {
      
      outlist <- c(outlist, geo_mapper(names(tsv_data)[i], tsv_data[[names(tsv_data)[i]]]))
      
    }
    if(grepl("time:", names(tsv_data)[i])) {
      
      outlist <- c(outlist, time_mapper(names(tsv_data)[i], tsv_data[[names(tsv_data)[i]]]))
      
    }
    if("skos:related" == names(tsv_data)[i]) {
      
      outlist <- c(outlist, list("skos:related" = tsv_data[[names(tsv_data)[i]]]))
      
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
                   `hyf:HY_DistanceDescription` = "HY_DistanceDescription",
                   `hyf:realizedNexus` = "realizedNexus")
    
    out[[mapper[[name]]]] <- value
    
  }, error = function(e) {
    warning(paste(e, name, "\n", value))
  })
  
  return(out)
}

geo_mapper <- function(name, value) {
  out <- list()
  
  tryCatch({
    mapper <- list(`gsp:sfIntersects` = "intersects",
                   `gsp:sfTouches` = "touches",
                   `gsp:sfWithin` = "within",
                   `gsp:hasGeometry` = "hasGeometry")
    
    out[[mapper[[name]]]] <- value
    
  }, error = function(e) {
    warning(paste(e, name, "\n", value))
  })
  
  return(out)
}

time_mapper <- function(name, value) {
  out <- list()
  tryCatch({
    mapper <- list(`time:hasBeginning` = "hasBeginning",
                   `time:hasEnd` = "hasEnd",
                   `time:after` = "after",
                   `time:before` = "before",
                   `time:intervalAfter` = "intervalAfter",
                   `time:intervalBefore` = "intervalBefore",
                   `time:intervalDuring` = "intervalDuring")
    
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
                   `sosa:isSampleOf` = "isSampleOf",
                   `sosa:isFeatureOfInterestOf` = "isFeatureOfInterestOf",
                   `sosa:hasSampleRelationship` = "hasSampleRelationship",
                   `sosa:natureOfRelationship` = "natureOfRelationship",
                   `sosa:relatedSample` = "relatedSample")
    
    out[[mapper[[name]]]] <- value
    
  }, error = function(e) {
    warning(paste(e, name, "\n", value))
  })
  
  return(out)
}

floodcast_mapper <- function(name, value) {
  out <- list()
  
  tryCatch({
    mapper <- list(`fc:AssetsThreatened` = "AssetsThreatened",
                   `fc:AssetsMonitored` = "AssetsMonitored",
                   `fc:FloodEvent` = "FloodEvent")
    
    out[[mapper[[name]]]] <- value
    
  }, error = function(e) {
    warning(paste(e, name, "\n", value))
  })
  
  return(out)
}

remove_missing <- function(x) {
  x[sapply(x, function(x) all(is.null(x)))] <- NULL
  x[sapply(x, function(x) all(is.na(x)))] <- NULL
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

#' @title resolve context
#' @param conx A URL to a json-ld context
#' @return A fully resolved json-ld context
#' 
resolve_context <- function(conx) {
  cached <- file.path("cache", stringr::str_replace_all(stringr::str_replace_all(conx, "/", ""), ":", ""))
  
  if(file.exists(cached)) {
    context <- readRDS(cached)
  } else {
    context <- grab_context(conx, cached)
  }
  
  if(!is.list(context[[1]])) {
    context_out <- list()
    for(conx2 in context[[1]]) {
      context_out <- c(context_out,
                       resolve_context(conx2))
    }
  } else {
    context_out <- context
  }
  return(context_out)
}

grab_context <- function(conx, cached) {
  context <- jsonlite::fromJSON(conx)
  saveRDS(context, file.path(cached))
  return(context)
}

get_context_out <- function(json_ld) {
  context_out <- list()
  
  for(conx in json_ld$`@context`) {
    try({
      context <- resolve_context(conx)
      if(length(context)>1) {
        context <- do.call(c, context)
        names(context) <- stringr::str_replace(names(context), "@context.", "")
        context <- list(`@context` = context)
      }
      context_out <- c(context_out, context$`@context`)
    }, silent = F)
  }
  
  context_out <- list(`@context` = context_out)
}

write_use_case_name <- function(out_md, use_case) {
  write(paste("##", use_case$name, "use case files\n"), out_md, append = T)
}

write_feature_type_title <- function(out_md, feature_type) {
  write(paste("### files for feature type", stringr::str_replace_all(feature_type, "_", "-"), " \n"), out_md, append = T)
}

write_url_line <- function(out_md, main_url) {
  write(paste0("[", main_url, "](", main_url, ") [plain json](", main_url, ".json)  "), out_md, append = T)
}
