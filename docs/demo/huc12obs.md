# HUC12 Observations Index Demo

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
