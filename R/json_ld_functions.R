## Constants
out_md <- "../docs/file_index.md"

out_path_base <- "../docs"

elf_url_base <- "https://opengeospatial.github.io/ELFIE"

#' @title build elfie index
#' @param tsv_data one row data.frame with predicates to be added to an R list
#' @param id_base character giving feature type a unique id in @id url like:
#' "https://opengeospatial.github.io/ELFIE/{{id_base}}/{{id}}"
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
#' @param add_context boolean if False, no context will be in the returned document.
#' @param schema_lat schema.org latitude value
#' @param schema_lon schema.org longitude value
#' @return list ready to be written with jsonlite::toJSON({{list}}, auto_unbox = T)
#' 
build_schema_geo <- function(geojson_geometry, add_context, schema_lat = NULL, schema_lon = NULL) {
  
  add_schema_geo <- is.null(schema_lat) && is.null(schema_lon)
  
  coords <- geojson_geometry$coordinates[[1]]
  
  if(add_schema_geo) {
    if(geojson_geometry$type == "Point") {
      schema_lat <- coords[2]
      schema_lon <- coords[1]
    } else if(grepl("Polygon", geojson_geometry$type) | grepl("Line", geojson_geometry$type)) {
      
      if(is.list(coords)) {
        if(length(coords) == 1) coords <- coords[[1]]
        remover <- c()
        for(l in 1:length(coords)) {
          if(is.list(coords[[l]])) {
            coords <- c(coords, coords[[l]])
            remover <- c(remover, l)
          }
        }
        coords[remover] <- NULL
        
        mean_ind <- function(x, ind = 1) mean(drop(x)[,ind])
        
        schema_lat <- mean(unlist(lapply(coords, mean_ind, ind = 2)))
        schema_lon <- mean(unlist(lapply(coords, mean_ind, ind = 1)))
        
      } else {
        schema_lat <- mean(drop(coords)[,2])
        schema_lon <- mean(drop(coords)[,1])
      }
    } else {
      print("Unsupported geometry type. Only supports Point (Multi)Line and (Multi)Polygon")
      return(NULL)
    }
  }
  
  if(add_context) out[["@context"]] <- "http://geojson.org/geojson-ld/geojson-context.jsonld"
  
  out <- list("geo" = list("@type" = "schema:GeoCoordinates",
                           "latitude" = schema_lat,
                           "longitude" = schema_lon),
              "geometry" = list("@type" = geojson_geometry$type,
                                "coordinates" = geojson_geometry$coordinates[[1]]))
  return(out)
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
#' "https://opengeospatial.github.io/ELFIE/{{id_base}}/{{id}}"
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

#' @title Parse ELFIE JSON-LD
#' @param url url that will return json-ld data.
#' @return parsed geosaptial content as sf and other json-ld elements
#' 
parse_elfie_json <- function(url) {
  jl <- jsonlite::fromJSON(url)
  name <- jl$`@type`
  if(!is.null(jl$geo) && !is.null(jl$geo$`@type`)) {
    if(jl$geo$`@type` == "schema:GeoCoordinates") {
      sfg <- sf::st_point(c(jl$geo$longitude, jl$geo$latitude))
      jl$geo <- sfg
    }
    if(!is.null(jl$geometry)) {
      names(jl$geometry)[which(names(jl$geometry) == "@type")] <- "type"
      jl$geometry <- sf::read_sf(jsonlite::toJSON(jl$geometry, auto_unbox = T))$geometry[[1]]
    }
  }
  return(jl)
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
                   `fc:FloodEvent` = "FloodEvent",
                   `fc:FloodExtent` = "FloodExtent",
                   `fc:FloodDepth` = "FloodDepth",
                   `fc:TransportationAssets` = "TransportationAssets")
    
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

elfie_sub <- function(x) {
  gsub("elfie/", "https://opengeospatial.github.io/ELFIE/", x)
}

elfie_url_local <- function(x) {
  if(!grepl(".json", x)) x <- paste0(x, ".json")
  gsub("https://opengeospatial.github.io/ELFIE/", "../docs/", x)
}

check_outlist <- function(outlist) {
  dups <- grepl("_\\|_", outlist)
  for(i in 1:length(outlist)) {
    if(dups[i]) {
      outlist[[i]] <- strsplit(outlist[i][[1]], split = "_\\|_")
    }
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
  contexts <- json_ld$`@context`
  for(el in names(json_ld)) {
    if(any(names(json_ld[[el]]) == "@context")) contexts <- c(contexts, json_ld[[el]]$`@context`)
  }
  for(conx in contexts) {
    try({
      context <- resolve_context(conx)
      if(length(context)>1) {
        context <- do.call(c, context)
        names(context) <- stringr::str_replace(names(context), "@context.", "")
        context <- list(`@context` = context)
      }
      
      name_check <- names(context$`@context`) %in% names(context_out)
      if(any(name_check)) {
        reverse_name_check <- names(context_out) %in% names(context$`@context`)
        if(context$`@context`[which(name_check)][[1]] == context_out[which(reverse_name_check)][[1]]) {
          warning(paste("Found context name conflict.", 
                        names(context$`@context`[which(name_check)]),
                        context$`@context`[which(name_check)][[1]],
                        names(context_out[which(reverse_name_check)]),
                        context_out[which(reverse_name_check)],
                        "Removing the first."))
        }
        context$`@context`[name_check] <- NULL
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

prefetch_ids <- function(id) {
  
  js <- jsonlite::fromJSON(elfie_url_local(id), simplifyVector = F)
  
  for(el in names(js)) {             # This is only going one level deep!!! 
    if(!grepl("@", el)) {            # Skip @id, @type, and @context
      for(u in 1:length(js[[el]])) { # If there's a list in the element -- look into its elements.
        if(!"@type" %in% names(js[[el]][[u]]) &&  # If the list has an @type already, punt
           is.character(js[[el]][[u]])) { # If the list element is not a character, punt.
          
          pre_url <- js[[el]][[u]]
          
          if(grepl("https://opengeospatial.github.io/ELFIE", pre_url)) { # Only prefetch ELFIE URLs
            if(!is.list(js[[el]])) js[[el]] <- as.list(js[[el]]) # initialize the thing as a list.
            
            prefetch <- jsonlite::fromJSON(elfie_url_local(pre_url)) # get the local file
            
            js[[el]][u] <- list(list(`@id` = pre_url, `@type` = prefetch$`@type`)) # make it @id and @type !!
          }
        }
      }
    }
  }
  return(js)
}
