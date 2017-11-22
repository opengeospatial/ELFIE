context_urls <- c("https://opengeospatial.github.io/ELFIE/json-ld/elf-all.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-index.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-net.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-net-basic.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-net-basic.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-net-spatial.jsonld",
                  "https://opengeospatial.github.io/ELFIE/json-ld/elf-net-temporal.jsonld")
              # Maybe Later
                  # "https://opengeospatial.github.io/ELFIE/json-ld/elf-geojson.jsonld"
                  # "http://geojson.org/geojson-ld/geojson-context.jsonld",
                  # "https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-sample.jsonld",
                  # "https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-observation.jsonld")

contexts <- setNames(rep(list(list()), length(context_urls)), 
                     context_urls)

resolve_context <- function(conx) {
  context <- jsonlite::fromJSON(conx)
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

for(conx in names(contexts)) {
  contexts[conx] <- list(resolve_context(conx))
  if(length(contexts[[conx]])>1) {
    contexts[[conx]] <- do.call(c, contexts[[conx]])
    names(contexts[[conx]]) <- stringr::str_replace(names(contexts[[conx]]), "@context.", "")
  }
}
