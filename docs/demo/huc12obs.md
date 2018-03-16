# HUC12 Observations Index Demo

## Use Case Descrition

This use case is meant to demonstrate the use of HY\_Features to link a catchment (12 digit hydrologic unit code (HUC12) watershed in this case) to the data representing it as well as
the monitoring network associated with it. It serves as a general demonstration that could be used for a wide array of
linked watershed information use cases.

[**The demo is available as an interactive map.**](https://opengeospatial.github.io/ELFIE/demo/huc12obs_map/)

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

The data index for the huc12obs demo can be seen in [github here.](https://github.com/opengeospatial/ELFIE/tree/master/data/huc12obs)

The primary entry point to the data is the non-spatial catchment that can be seen in 
[this json-ld document.](https://opengeospatial.github.io/ELFIE/usgs/huc/huc12obs/070900020601)  

The catchment is linked to three features, a flowline network, and a boundary polygon, and a hydrometric network.

Navigate to the [use case data home on github](https://github.com/opengeospatial/ELFIE/tree/master/data/huc12obs) and go to the 
`usgs_wqp_huc12obs.tsv` [.tsv](https://github.com/opengeospatial/ELFIE/blob/master/data/huc12obs/usgs_wqp_huc12obs.tsv) 
or [.json](https://github.com/opengeospatial/ELFIE/blob/master/data/huc12obs/usgs_wqp_huc12obs.json) files to see the data
that is in the demo ELFIE json-ld documents such as [this one](https://opengeospatial.github.io/ELFIE/usgs/wqp/huc12obs/USGS-431208089314901).
Other tsv and json files in the use case home were used to construct the linked data documents.

This collection of files is accessed with R code that builds the map in the data visualization that 
[can be seen here.](https://opengeospatial.github.io/ELFIE/demo/huc12obs_map)

## Demo findings and potential next steps

TODO:
Discuss issues that this demo works around or would otherwise need to be solved to take
it from demonstration/experiment to production.

