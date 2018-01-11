setwd("~/Documents/Projects/ELFIE/ELFIE/R")
source("json_ld_functions.R")

data_paths <- c("../data/huc12obs",
                "../data/uswb",
                "../data/cr",
                "../data/floodcast")

use_cases <- list(huc12obs = list(data_path = "../data/huc12obs",
                                  name = "Observations for a Hydrologic Unit"),
                  uswb = list(data_path = "../data/uswb",
                              name = "US Water Budgets"),
                  cr = list(data_path = "../data/cr",
                            name = "Champlain-Richelieu River Data Index"),
                  floodcast = list(data_path = "../data/floodcast",
                                   name = "Floodcast"))

out_md <- "../docs/file_index.md"

write("# Environmental Linked Features Interoperability Experiment Demo File Index\n", file = out_md)

unlink("cache/*")

for(use_case in use_cases) {
  data_path <- use_case$data_path
  data_files <- list.files(data_path, pattern = "*.tsv")
  
  out_path_base <- "../docs"
  
  write(paste("##", use_case$name, "use case files\n"), out_md, append = T)
  
  for(data_file in data_files) {
    print(data_file)
    
    feature_type <- stringr::str_replace(data_file, ".tsv", "")
    
    write(paste("### files for feature type", stringr::str_replace_all(feature_type, "_", "-"), " \n"), out_md, append = T)
    
    id_base <- paste(stringr::str_split(feature_type, "_")[[1]], collapse = "/")
    
    out_path <- file.path(out_path_base, id_base)
    
    if(!dir.exists(out_path)) dir.create(out_path, recursive = T)
    
    tsv_data <- readr::read_delim(file.path(data_path, data_file), delim = "\t", col_types = readr::cols())
    
    geojson_file <- stringr::str_replace(data_file, ".tsv", ".json")
    
    try(rm(geojson), silent = T)
    
    try(geojson <- jsonlite::fromJSON(file.path(data_path, geojson_file)), silent = T)
    
    joiner <- stringr::str_replace(names(tsv_data)[1], "jsonkey_", "")
    
    try(matcher <- match(geojson$features$properties[[joiner]], tsv_data[,1][[1]]), silent = T)
    
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
      
      if(exists("geojson")) elf_index_list$geo <- build_schema_geo(geojson$features$geometry[matcher[i],], 
                                                                   id = elf_index_list$`@id`)
      
      jsonlite::write_json(elf_index_list, 
                           file.path(out_path, paste0(tsv_data[i,][1], ".json")),
                           pretty = T, auto_unbox = T)
      
      json_out <- readLines(file.path(out_path, paste0(tsv_data[i,][1], ".json")))
      
      context_out <- list()
      
      for(conx in elf_index_list$`@context`) {
        context <- resolve_context(conx)
        if(length(context)>1) {
          context <- do.call(c, context)
          names(context) <- stringr::str_replace(names(context), "@context.", "")
          context <- list(`@context` = context)
        }
        context_out <- c(context_out, context$`@context`)
      }
      
      context_out <- list(`@context` = context_out)
      
      context_out <- jsonlite::toJSON(context_out, pretty = T, auto_unbox = T)
      
      json_out <- jsonlite::toJSON(elf_index_list, pretty = T, auto_unbox = T)
      
      whisker_list <- list(context = list(context_out), `json-ld` = json_out, page_title = paste0(id_base, "/", tsv_data[i,1]))
      
      writeLines(whisker::whisker.render(readLines("html_template.html"), whisker_list),
                 file.path(out_path, paste0(tsv_data[i,][1], ".html")))
      
      write(paste0("[", elf_index_list$`@id`, "](", elf_index_list$`@id`, ") [plain json](", elf_index_list$`@id`, ".json)  "), out_md, append = T)
    }
    write("  \n", out_md, append = T)
  }
}

unlink("cache/*")
