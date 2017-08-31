# ELFIE Datasets

This folder contains a collection of datasets for inclusion in the ELFIE. Each 
folder should follow the same pattern. As the project progresses, reusable scripts 
will be crafted to convert the submitted content into JSON-LD, RDF, TTL, etc. 
encoded documents. This document is a work in progress, please contribute to it!

Please review the `huc12_obs` dataset for reference.

- Each feature type should have a `.json` file and a `.tsv` file.  
  - File nameing should be in the form `{{organization}}_{{featuretype id}}_{{use case id}}`
  - The IDs provide what is needed to construct URIs like: https://opengeospatial.gihub.io/ELFIE/usgs/huc/huc12obs/070900020601
- The `.json` file should contain valid geojson for visualization of the feature.  
  - The geojson properties must contain a unique attribute to map between the tsv and json.  
  - Any properties other than the unique key will be ignored.  
  - The json ID is not required to map to the unique key, but it might.  
- The `.tsv` file should contain a table of predicates for the features of the featuretype.  
  - Column 1 should be labeled `jsonkey_{{jsonkey}}` where `{{jsonkey}}` is the unique key property of the json file.
  - Other columns should contain predicates from [this wiki page.](https://github.com/opengeospatial/ELFIE/wiki/Predicates)
- For convenience, consider providing a preview image and a `.qgis` file for data visualization.

For predicates that link features to eachother and the features to be linked are 
published in the ELFIE domain, express links as `elfie/{{organization}}/{{feautretype id}}/{{jsonkey id}}`. 
Where jsonkey is the value of unqie key that connects the `.json` and `.tsv` files 
for the organization/featuretype in question. 

In the case that a given featuretype is a single feature for the whole use case, 
such as is the case for a hydrographicnetwork, the jsonkey id can be left as `NA` 
in the tsv file and left off in the feature URI.

**Please add additional conventions to this document as they are needed and or implemented.**

