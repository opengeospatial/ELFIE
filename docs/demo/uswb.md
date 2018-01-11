# US Water Budgets Demo

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