# FloodCast Linked Flood Information Demo

## Use Case Descrition

The objectives of the Floodcast prototype system are to develop a strategic framework and tool for enhanced flood event decision making.  The framework and tool should help state DOTs to plan, manage risks, mitigate hazards and respond to flood and flash flood events. The FloodCast prototype is a proof of concept designed to show how key data elements (Figure 1) can come together to support DOT emergency response activities. These data elements are produced by a variety of entities (i.e. federal, state, local, public, etc.) across different domains (i.e. meteorology, hydrology, asset management, etc.). Combining data from multiple sources is difficult, if not impossible, if data standards are not in place or if different groups are using different data standards. Data standards have the advantage of creating rules by which data are described and recorded to improve compatibility and interoperability.

Figure 1. Key data elements in Floodcast
![Figure 1. Key data elements in Floodcast](https://opengeospatial.github.io/ELFIE/images/floodcast_fig1.png)

### User Story

A person who needs to operate or use transportation or other critical infrastructure needs a dashboard showing what assets and roads are expected to be impacted durring a forecast flood event.

### Datasets

- Flood Event Feature
- Contributing Catchment
- Streamgages
- Flooding Depth
- Inundation Extent
- Transportation Assets

## Demo Description and Links

The FloodCast study team collaborated with the Open Geospatial Consortium (OGC) Hydrology Domain Working Group (Hydro DWG). In June 2017, members of the FloodCast study team attended the Hydro DWG’s annual workshop at the National Water Center in Tuscaloosa, Alabama focused on kicking off the Environmental Linked Features Interoperability Experiment (ELFIE).  ELFIE’s goal is to test existing standards for publishing environmental and related features on the internet using domain feature models (like HY_Features and Observations and Measurements) as formal documentation.  It is expected that this will set the stage for future automated, generalized software to serve decision support and other applications.  

The ELFIE workshop brought together interested stakeholders with the goal of developing a standard for linking different domain features, and observational data about those features. A common approach to encoding such links is required to allow cross-domain and cross-system sharing and interoperability of such linked information. The FloodCast study team presented the FloodCast prototype demonstration to ELFIE participants followed by a discussion of how FloodCast could be included as an “event-driven” use case in ELFIE. The study team contributed example FloodCast datasets (e.g. flood event, flood extents and depths, and transportation assets) to demonstrate the importance of establishing these data types as domain features. Once established as domain features, each feature type will require a standard set of attributes to facilitate flood event analytics. For example, a relational attribute within the flood inundation extent polygon linking to all of the assets that are within (i.e. “threatened” status) or near (i.e. “monitor” status) the flooding.  

The data standards are built upon open source formats.  At the core of a prototype is a flood event triggered by a large precipitation event (henceforth referred simply as “event”).  This event causes flooding in a flooding source like a river or stream in a watershed.  The watershed is a “catchment realization” of the event.  The watershed and stream are interlinked features with the event. At different times during the event, we have various inundation extents modeled.  These inundation extents are captured in “FloodExtent” feature type which in turn links the assets within the extent.   Each inundation extent is also associated with a depth of flooding which is captured in a “FloodDepth” feature type. Figure 2 shows the various links and data types that were established as part of the ELFIE process.  

Figure 2. Various geospatial objects/data types used on the Floodcast system and their linkages  
![Figure 2. Various geospatial objects/data types used on the Floodcast system and their linkages](https://opengeospatial.github.io/ELFIE/images/floodcast_fig2.png)  
![Figure 2-1](https://opengeospatial.github.io/ELFIE/images/floodcast_fig2-1.png)  

### Demo Screenshot(s)

![Floodcast Demo Screenshot](https://opengeospatial.github.io/ELFIE/images/floodcast_screenshot.png)

### Links to Demo Resources

The URLs below displays the information in JSON-LD context for the Floodcast feature types. These URLs also depict the relations that are representative of ELFIE’s recommendations on data standards for linked geospatial features.

FloodEvent:  
[https://opengeospatial.github.io/ELFIE/dewberry/fe-harvey/floodcast/TX_Harvey2017_1](https://opengeospatial.github.io/ELFIE/dewberry/fe-harvey/floodcast/TX_Harvey2017_1)  
HY_Catchment:  
[https://opengeospatial.github.io/ELFIE/usgs/huc10/floodcast/1204010403](https://opengeospatial.github.io/ELFIE/usgs/huc10/floodcast/1204010403)  
HY_HydrometricFeature:  
[https://opengeospatial.github.io/ELFIE/tx/flowlines/floodcast/FS_BuffaloBayou](https://opengeospatial.github.io/ELFIE/tx/flowlines/floodcast/FS_BuffaloBayou)  
HY_HydroLocation:  
[https://opengeospatial.github.io/ELFIE/usgs/nwissite/floodcast/08072600](https://opengeospatial.github.io/ELFIE/usgs/nwissite/floodcast/08072600)  
FloodExtent:  
[https://opengeospatial.github.io/ELFIE/dewberry/fp-action/floodcast/TX_FP_ACT_1](https://opengeospatial.github.io/ELFIE/dewberry/fp-action/floodcast/TX_FP_ACT_1)  
[https://opengeospatial.github.io/ELFIE/dewberry/fp-moderate/floodcast/TX_FP_MOD_1](https://opengeospatial.github.io/ELFIE/dewberry/fp-moderate/floodcast/TX_FP_MOD_1)  
[https://opengeospatial.github.io/ELFIE/dewberry/fp-major/floodcast/TX_FP_MAJ_1](https://opengeospatial.github.io/ELFIE/dewberry/fp-major/floodcast/TX_FP_MAJ_1)  
FloodDepth:  
[https://opengeospatial.github.io/ELFIE/dewberry/fd-action/floodcast/TX_cov_depth_act.json](https://opengeospatial.github.io/ELFIE/dewberry/fd-action/floodcast/TX_cov_depth_act.json)  
[https://opengeospatial.github.io/ELFIE/dewberry/fd-moderate/floodcast/TX_cov_depth_mod.json](https://opengeospatial.github.io/ELFIE/dewberry/fd-moderate/floodcast/TX_cov_depth_mod.json)  
[https://opengeospatial.github.io/ELFIE/dewberry/fd-major/floodcast/TX_cov_depth_maj.json](https://opengeospatial.github.io/ELFIE/dewberry/fd-major/floodcast/TX_cov_depth_maj.json)  

## Demo findings and potential next steps

Given currently available data and information models, the floodcast demo was the most ambitious undertaken in the project. A lack of a flood event feature model for inundation areas and impact types meant that some feature types and relations were created specifically for the use case. A significant next step toward further applications of linked flood information is establishment of such an information model to link hydrologic features, observed and modeled data, and inundated areas and assets.

