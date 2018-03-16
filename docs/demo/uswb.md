# US Water Budgets Demo

## Use Case Descrition

This use case provides a person interested in a basic summary of the water budget for a given watershed information about a collection of watersheds and their water budget data. It links together various hydrographic representations of each watershed as well as observational water budget data and related web resources.

[**The demo is available as a static data visualization**](https://opengeospatial.github.io/ELFIE/demo/uswb-viz)

### User Story

A person curious about what a watershed looks like and how it's waterbudget compares to other watersheds needs relevant hydrographic and hydrologic datasets linked together and built into a visualization.

### Datasets

- Watershed boundaries (HY\_CatchmentBoundary)
- River Network (HY\_HydrographicNetwork)
- Watershed outlet (HY\_Nexus location)
- Waterbudget Components
- Links to related resources

## Demo Description and Links

This demonstration tests the ELFIE json-ld formats by leveraging ELFIE demo json-ld files to create geospatial views of watersheds (HY\_Catchment features with multiple realizations) and high level summaries of water budget components. It was implemented in R, using the [USGS VizLab](https://github.com/USGS-VIZLAB/vizlab) framework. Geospatial content is derived direclty from the preview geometries in the json-ld files and waterbudget data is accessed via linked resource URLs. This demo involves both HY\_Features relationships between catchments and their realizations and HY\_Features nexus locations and observed water budget components linked to those locations. 

### Demo Screenshot(s)

![Screenshot of US Water Budgets Demo](https://opengeospatial.github.io/ELFIE/images/uswb_screenshot.png)

The US Water Budgets demo is a static HTML and SVG visualization of various ELFIE linked resources.

### Links to Demo Resources

The data index for the USWB demo can be seen in [github here.](https://github.com/opengeospatial/ELFIE/tree/master/data/uswb)

The primary entry point to the data is the non-spatial set of catchments as can be seen in 
[this tsv file.](https://github.com/opengeospatial/ELFIE/blob/master/data/uswb/usgs_huc12_uswb.tsv)

Each catchment is linked to three spatial features, an outflow, a flowline network, and a boundary polygon. 
This can be seen in a json-ld document such as [this one.](https://opengeospatial.github.io/ELFIE/usgs/huc12/uswb/070200121110)

Navigate to the [use case data home on github](https://github.com/opengeospatial/ELFIE/tree/master/data/uswb) and go to the 
`usgs_huc12boundary_uswb` [.tsv](https://github.com/opengeospatial/ELFIE/blob/master/data/uswb/usgs_huc12boundary_uswb.tsv) 
or [.json](https://github.com/opengeospatial/ELFIE/blob/master/data/uswb/usgs_huc12boundary_uswb.json) files to see the data
that is in the demo ELFIE json-ld documents such as [this one](https://opengeospatial.github.io/ELFIE/usgs/huc12boundary/uswb/070200121110).

This collection of files is accessed with R code that builds the map in the data visualization that 
[can be seen here.](https://dblodgett-usgs.github.io/uswb-viz/)

## Demo findings and potential next steps

TODO:
Discuss issues that this demo works around or would otherwise need to be solved to take
it from demonstration/experiment to production.

