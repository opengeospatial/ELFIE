setwd("~/Documents/Projects/ELFIE/ELFIE/Tools/R/")
source("json_ld_functions.R")

use_cases <- list(huc12obs = list(data_path = "../../data/huc12obs",
                                  name = "Observations for a Hydrologic Unit"),
                  uswb = list(data_path = "../../data/uswb",
                              name = "US Water Budgets"),
                  cr = list(data_path = "../../data/cr",
                            name = "Champlain-Richelieu River Data Index"),
                  floodcast = list(data_path = "../../data/floodcast",
                                   name = "Floodcast"))

write("# Environmental Linked Features Interoperability Experiment Demo File Index\n", file = out_md)

unlink("cache/*")

created_ids <- list()

for(use_case in use_cases) {
  data_path <- use_case$data_path
  data_files <- list.files(data_path, pattern = "*.tsv")
  
  write_use_case_name(out_md, use_case)
  
  for(data_file in data_files) {
    print(data_file)
    
    feature_type <- stringr::str_replace(data_file, ".tsv", "")
    
    write_feature_type_title(out_md, feature_type)
    
    id_base <- paste(stringr::str_split(feature_type, "_")[[1]], collapse = "/")
    
    out_path <- file.path(out_path_base, id_base)
    
    if(!dir.exists(out_path)) dir.create(out_path, recursive = T)
    
    tsv_data <- readr::read_delim(file.path(data_path, data_file), delim = "\t", col_types = readr::cols())
    
    geojson_file <- stringr::str_replace(data_file, ".tsv", ".json")
    
    try(rm(geojson), silent = T)
    
    try(geojson <- sf::st_read(file.path(data_path, geojson_file), check_ring_dir = TRUE, quiet = TRUE), silent = T)
    
    if(!exists("geojson")) {
      try(geojson <- sf::st_read(file.path(data_path, geojson_file), quiet = TRUE), silent = T)
    }
    
    joiner <- stringr::str_replace(names(tsv_data)[1], "jsonkey_", "")
    
    try(matcher <- match(tsv_data[,1][[1]], geojson[[joiner]]), silent = T)
    
    if(joiner == "") matcher <- 1
    
    for(i in 1:nrow(tsv_data)) {
      elf_index_list <- build_elf_index_list(id_base, tsv_data[i,], include_missing = F)
      
      if(any(grepl("hyf:", names(tsv_data))) || any(grepl("fc:", names(tsv_data)))) {
        elf_net_hyf_list <- build_hyf_net(tsv_data[i,], elf_index_list$`@id`)
        elf_net_hyf_sublist <- elf_net_hyf_list
        elf_net_hyf_sublist[c("@context", "@id", "@type")] <- NULL
      
        elf_index_list$`@context` <- c(elf_index_list$`@context`, elf_net_hyf_list$`@context`)
      
        elf_index_list <- c(elf_index_list, elf_net_hyf_sublist)
      }
      
      if(any(grepl("time:", names(tsv_data))) || any(grepl("gsp:", names(tsv_data)))) {
        elf_net_list <- build_elf_net(tsv_data[i,], elf_index_list$`@id`)
        elf_net_sublist <- elf_net_list
        elf_net_sublist[c("@context", "@id", "@type")] <- NULL
        
        elf_index_list$`@context` <- c(elf_index_list$`@context`, elf_net_list$`@context`)
        
        elf_index_list <- c(elf_index_list, elf_net_sublist)
      }
      
      if(any(grepl("sosa:", names(tsv_data)))) {
        elf_sosa_list <- build_sosa(tsv_data[i,], elf_index_list$`@id`)
        elf_sosa_sublist <- elf_sosa_list
        elf_sosa_sublist[c("@context", "@id", "@type")] <- NULL
        
        elf_index_list$`@context` <- c(elf_index_list$`@context`, elf_sosa_list$`@context`)
        
        elf_index_list <- c(elf_index_list, elf_sosa_sublist)
      }
      
      if(exists("geojson")) {
        try({geojson_f <- geojson[matcher[i],]
        geojson_out <- paste0(tsv_data[i,][1], ".geojson")
        
        elf_index_list <- c(elf_index_list, 
                            build_schema_geo(geojson_f,
                                             add_context = F,
                                             geojson_id = paste(elf_url_base, id_base, geojson_out, sep = "/")))
        
        geojson_out <- file.path(out_path, geojson_out)
        
        unlink(geojson_out)
        
        sf::write_sf(geojson_f, 
                     geojson_out, 
                     driver = "GeoJSON", 
                     layer_options = c("WRITE_NAME=NO", "RFC7946=YES"))
      })}
      
      jsonlite::write_json(elf_index_list, 
                           file.path(out_path, paste0(tsv_data[i,][1], ".json")),
                           pretty = TRUE, auto_unbox = T)
      
      write_url_line(out_md, elf_index_list$`@id`)
      
      created_ids <- c(created_ids, elf_index_list$`@id`)
    }
    write("  \n", out_md, append = T)
  }
}

for(id in created_ids) {
  json_out <- jsonlite::toJSON(prefetch_ids(id), 
                               pretty = T, 
                               auto_unbox = T)
  
  writeLines(json_out, elfie_url_local(id))
  
  context_out <- get_context_out(jsonlite::fromJSON(json_out))
  
  context_out <- jsonlite::toJSON(context_out, pretty = T, auto_unbox = T)
  
  whisker_list <- list(context = list(context_out), 
                       `json-ld` = json_out, 
                       page_title = gsub("../../docs", "", elfie_url_local(id)))
  
  writeLines(whisker::whisker.render(readLines("html_template.html"), 
                                     whisker_list),
             file.path(gsub(".json", ".html", elfie_url_local(id))))
}

unlink("cache/*")
