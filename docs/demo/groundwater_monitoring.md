# Ground water monitoring Demo

## Use Case Descrition
This use case is meant to demonstrate how from a given Well URI, any user
(domain expert, machine) can then traverse to the monitoring strategy deployed
and then access to the ground water level time series. Further than advocating
the linked data approach it serves as a demonstration artifact on how typed information
can trigger type-specific data viewer (here map and time series).

[**The demo is available as a video .**](https://opengeospatial.github.io/ELFIE/demo/groundwater_monitoring_video.mp4){:target="_blank"}

### User Story

From a given groundwater well, a user needs to access to the sampling strategy and associated observations of a given aquifer monitored in France.


### Datasets

- Borehole (SOSA:Sample, GWML2:GW\_Well)
- Piezometer (SOSA:Sample)
- Aquifer (GWML2:GW_HydrogeoUnit)
- GroundWater level (OGC SensorThings response to a request for observations)


## Demo Description and Links

This use case is meant to demonstrate the combination of the use of W3C:SOSA, tentative OGC:GroundWaterML2 and OGC:ELFIE json-ld contexts to access and navigate though data representing the groundwater monitoring environnement of a given aquifer in France.
In this demonstration, SOSA terminology is used to link the piezometer (O&M Sampling feature)  to the domain features it monitors (the Aquifer) but also to the observations generated.
It was decided that the observation will be served here following an OGC:SensorThings approach.

The demonstration makes use of BRGM experimental Linked Data Viewer (BLiV) that was developped as a support to ELFIE activities. Given that content is highly typed (@type) it was tried to see to what extent content driven widgets could be fed by a data graph (adding features to a map, viewing a timeseries graph).


### Demo Screenshot(s)

The ground water monitoring demo is a mashup involving a graph library (viz.js), a map viewer (leaflet), json-ld library (jsonld.js) and timeseries representation using plot.ly.

![Screenshot of ground water monitoring  Demo](https://opengeospatial.github.io/ELFIE/images/groundwater_monitoring_screenshot.png)


### Links to Demo Resources

The data index  can be seen in [github here.](https://github.com/opengeospatial/ELFIE/tree/master/data/FR_surface_ground_water_interaction){:target="_blank"}

The primary entry point to the data is the Borehole that can be seen in
[this json-ld document.](https://opengeospatial.github.io/ELFIE/FR/Borehole/sgwi/BSS000DXBD.json){:target="_blank"}  

The Borehole is linked to two features, a piezometer, and a geology log.

Interaction with the json-ld content can be experienced using BRGM experimental Linked Data Viewer (BLiV) which code is available on ELFIE [github repository here.](https://github.com/opengeospatial/ELFIE/tree/master/Tools/Bliv){:target="_blank"}. JSON-LD content just need to be pasted in the dedicated area.


## Demo findings and potential next steps

TODO:
Discuss issues that this demo works around or would otherwise need to be solved to take
it from demonstration/experiment to production.
