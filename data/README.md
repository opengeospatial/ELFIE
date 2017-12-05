# ELFIE Dataset Convention

## _STOP: Read this file carefully before proceeding!_

This folder contains a collection of datasets for inclusion in the ELFIE. Each 
folder should follow the same convention. As the project progresses, reusable scripts 
will be crafted to convert the submitted content into JSON-LD, RDF, TTL, etc. 
encoded documents. This document is a work in progress, please contribute to it!

Please review the [`huc12obs`](https://github.com/opengeospatial/ELFIE/tree/master/data/huc12obs) 
dataset for  a reference.

- Each featuretype should have a `.json` file and a `.tsv` file.  
  - File nameing should be in the form `{{organization}}_{{featuretype id}}_{{usecase id}}`
  - With these names we can construct URIs like: https://opengeospatial.gihub.io/ELFIE/usgs/huc/huc12obs/070900020601 where `070900020601` is an identifier for a feature stored in the `.json` or `.tsv` file.
- The `.json` file should contain valid geojson for visualization of each feature.  
  - The geojson properties must contain a unique attribute to map between the `.tsv` and `.json`.  
  - Any properties other than the unique key will be ignored.  
  - The json ID is not required to map to the unique key.
- The `.tsv` file should contain a table of associations for the features of the featuretype.  
  - The table is of the form `(row = rdf:subject)` - `(column header = rdf:predicate)` - `(value = rdf:object)`  
  - Column 1 should be labeled `jsonkey_{{key}}` where `{{key}}` is the unique key property in the json file.  
  - Other columns should contain associations (rdf:predicate) from [this wiki page.](https://github.com/opengeospatial/ELFIE/wiki/ELFIE-Associations)  
- For convenience, consider providing a preview image and a `.qgs` file for data visualization and mapping.  
- If one to many relationships are needed, delimit lists for a single `rdf:predicate` with the string `_|_`. It's a hack, but it'll do with how infrequently we'll deal with one to manys.

For associations that link ELFIE features to eachother, express links as 
`elfie/{{organization}}/{{featuretype id}}/{{usecase id}}/{{jsonkey id}}`. 
Where `{{jsonkey}}` is the value of unique key that connects the `.json` and `.tsv` files 
for the organization/featuretype in question.  

In the case that a given featuretype is a single feature for the whole use case, 
such as is the case for a hydrographic network, the jsonkey id should be set to a use-case wide ID 
in the tsv file and left off in the feature URI.

**Please add additional conventions to this document as they are needed and or implemented.**

