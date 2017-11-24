source("json_ld_functions.R")

data_paths <- c("../data/huc12obs/",
                "../data/uswb")

for(data_path in data_paths) {
  data_files <- list.files(data_path, pattern = "*.tsv")
  
  out_path_base <- "../docs"
  
  for(data_file in data_files) {
    print(data_file)
    id_base <- paste(stringr::str_split(stringr::str_replace(data_file, 
                                                             ".tsv", ""), 
                                        "_")[[1]], 
                     collapse = "/")
    
    out_path <- file.path(out_path_base, id_base)
    
    if(!dir.exists(out_path)) dir.create(out_path, recursive = T)
    
    tsv_data <- readr::read_delim(file.path(data_path, data_file), delim = "\t")
    
    geojson_file <- stringr::str_replace(data_file, ".tsv", ".json")
    
    geojson <- jsonlite::fromJSON(file.path(data_path, geojson_file))
    
    for(i in 1:nrow(tsv_data)) {
      elf_index_list <- build_elf_index_list(id_base, tsv_data[i,], include_missing = F)
      
      elf_index_list$geo <- build_schema_geo(geojson$features$geometry[1,], id = elf_index_list$`@id`)
      
      jsonlite::write_json(elf_index_list, 
                           file.path(out_path, paste0(tsv_data[i,][1], ".json")),
                           pretty = T, auto_unbox = T)
    }
  }
}



