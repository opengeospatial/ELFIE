# HUC12 Observations Index Demo

## Use Case Descrition

This use case is meant to demonstrate the use of HY\_Features to link a catchment (12 digit hydrologic unit code (HUC12) watershed in this case) to the data representing it as well as
the monitoring network associated with it. It serves as a general demonstration that could be used for a wide array of
linked watershed information use cases.

[**The demo is available as an interactive map.**](https://opengeospatial.github.io/ELFIE/demo/huc12obs_map){:target="_blank"}

### User Story

A water quality analyst needs to find hydrographic data and all stream flow and water quality data that is available for the waterhsed they are evaluating so they can develop a model of water quality for the watershed.

### Datasets

- Watershed boundaries (HY\_CatchmentBoundary)
- River Network (HY\_HydrographicNetwork)
- Stream gage location
- Water quality monitoring locations

## Demo Description and Links

This demonstration is a basic test of linking a watershed to its realizations and monitoring locations in the watershed. In this case, monitoring locations are linked to the watershed as a monitoring network realization of the watershed rather than linking them to a hydrologic location at the outlet of the watershed or linked to the waterbodies in the watershed.

### Demo Screenshot(s)

![Screenshot of US Water Budgets Demo](https://opengeospatial.github.io/ELFIE/images/huc12obs_screenshot.png)

The HUC12 Oservations demo is a simple interactive leaflet map of watershed hydrography and linked observational data locations.

### Links to Demo Resources

The data index for the huc12obs demo can be seen in [github here.](https://github.com/opengeospatial/ELFIE/tree/master/data/huc12obs){:target="_blank"}

The primary entry point to the data is the non-spatial catchment that can be seen in 
[this json-ld document.](https://opengeospatial.github.io/ELFIE/usgs/huc/huc12obs/070900020601){:target="_blank"}  

The catchment is linked to three features, a flowline network, and a boundary polygon, and a hydrometric network.

Navigate to the [use case data home on github](https://github.com/opengeospatial/ELFIE/tree/master/data/huc12obs){:target="_blank"} and go to the 
`usgs_wqp_huc12obs.tsv` [.tsv](https://github.com/opengeospatial/ELFIE/blob/master/data/huc12obs/usgs_wqp_huc12obs.tsv){:target="_blank"} 
or [.json](https://github.com/opengeospatial/ELFIE/blob/master/data/huc12obs/usgs_wqp_huc12obs.json){:target="_blank"} files to see the data
that is in the demo ELFIE json-ld documents such as [this one](https://opengeospatial.github.io/ELFIE/usgs/wqp/huc12obs/USGS-431208089314901){:target="_blank"}.
Other tsv and json files in the use case home were used to construct the linked data documents.

This collection of files is accessed with R code that builds the map in the data visualization that 
[can be seen here.](https://opengeospatial.github.io/ELFIE/demo/huc12obs_map){:target="_blank"}

## Demo findings and potential next steps

This demonstration showed that the linked data graph views defined for ELFIE will satisfy technical requirements of the use cases. Parsing and working with the content was straight forward and building a simple interactive geospatial visual that satisfied the use case was not challenging. From a pragmatic point of view, this approach is satisfactory, however, significant work remains to enable general implementation on the internet between multiple data providers. The major gap (which was known and out of scope for ELFIE) was the lack of published feature identifiers and a linked-data baseline to build on. On this front, a clear next step is for data providers to establish URIs for features and to choose the default behavior of a linked-data URI broker. 

HY\_Features feature types and relations encoded in JSON-LD were used successfully and showed promise for use in the way the schema.org and other linked data types and relations are used. Similar to feature URIs, canonical feature type and relation URIs and best practices for dereferencing bahavior for them is needed in order to move forward using HY\_Features (an other domain feature models) in this way. Apart from HY\_features, even when published, the response from a given relation or feature URI is rarely consistant.  
For example: 
- [schema.org](https://schema.org/docs/developers.html): e.g. https://schema.org/GeoCoordinates
  - Defaults to an html page `curl https://schema.org/GeoCoordinates`
  - Supports several `Accept` headers `curl --header "Accept: application/ld+json" -L https://schema.org/GeoCoordinates`
  - Supports url suffixes `curl https://schema.org/GeoCoordinates.jsonld`
- [skos](https://www.w3.org/TR/skos-reference/): e.g. http://www.w3.org/2004/02/skos/core#related
  - Defaults to an html page `curl http://www.w3.org/2004/02/skos/core#related`
  - Supports `Accept` headers `curl --header "Accept: application/rdf+xml" -L http://www.w3.org/2004/02/skos/core#related`
  - Returns incorrect content types: `curl --header "Accept: application/ld+json" -L http://www.w3.org/2004/02/skos/core#related`
- [GeoSPARQL](http://www.opengeospatial.org/standards/geosparql/asWKT)
  - No canonical URI and / or does not resolve.

While the list above is not at all exhaustive, it demonstrates the diversity in completion and diversity of core domain-agnostic resources that are required to satisfy use cases like the one illustrated here.

