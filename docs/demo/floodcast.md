# ELFIE Demonstration Write Up Template

## Use Case Descrition

The objectives of the Floodcast prototype system are to develop a strategic framework and tool for enhanced flood event decision making.  The framework and tool should help state DOTs to plan, manage risks, mitigate hazards and respond to flood and flash flood events. The FloodCast prototype is a proof of concept designed to show how key data elements (Figure 1) can come together to support DOT emergency response activities. These data elements are produced by a variety of entities (i.e. federal, state, local, public, etc.) across different domains (i.e. meteorology, hydrology, asset management, etc.). Combining data from multiple sources is difficult, if not impossible, if data standards are not in place or if different groups are using different data standards. Data standards have the advantage of creating rules by which data are described and recorded to improve compatibility and interoperability.

Figure 1. Key data elements in Floodcast
![Figure 1. Key data elements in Floodcast](https://opengeospatial.github.io/ELFIE/images/floodcast_fig1.png)

[**Need a prominent link to the demo if possible**](https://opengeospatial.github.io/ELFIE/demo/template)

### User Story

A one sentence story.

### Datasets

- A bulleted
- list of datasets
- that are used
- in the use case.

## Demo Description and Links

The FloodCast study team collaborated with the Open Geospatial Consortium (OGC) Hydrology Domain Working Group (Hydro DWG). In June 2017, members of the FloodCast study team attended the Hydro DWG’s annual workshop at the National Water Center in Tuscaloosa, Alabama focused on kicking off the Environmental Linked Features Interoperability Experiment (ELFIE).  ELFIE’s goal is to test existing standards for publishing environmental and related features on the internet using domain feature models (like HY_Features and Observations and Measurements) as formal documentation.  It is expected that this will set the stage for future automated, generalized software to serve decision support and other appilcations.  

The ELFIE workshop brought together interested stakeholders with the goal of developing a standard for linking different domain features, and observational data about those features. A common approach to encoding such links is required to allow cross-domain and cross-system sharing and interoperability of such linked information. The FloodCast study team presented the FloodCast prototype demonstration to ELFIE participants followed by a discussion of how FloodCast could be included as an “event-driven” use case in ELFIE. The study team contributed example FloodCast datasets (e.g. flood event, flood extents and depths, and transportation assets) to demonstrate the importance of establishing these data types as domain features. Once established as domain features, each feature type will require a standard set of attributes to facilitate flood event analytics. For example, a relational attribute within the flood inundation extent polygon linking to all of the assets that are within (i.e. “threatened” status) or near (i.e. “monitor” status) the flooding.  

The data standards are built upon open source formats.  At the core of a prototype is a flood event triggered by a large precipitation event (henceforth referred simply as “event”).  This event causes flooding in a flooding source like a river or stream in a watershed.  The watershed is a “catchment realization” of the event.  The watershed and stream are interlinked features with the event. At different times during the event, we have various inundation extents modeled.  These inundation extents are captured in “FloodExtent” feature type which in turn links the assets within the extent.   Each inundation extent is also associated with a depth of flooding which is captured in a “FloodDepth” feature type. Figure 2 shows the various links and data types that were established as part of the ELFIE process.  

Figure 2. Various geospatial objects/data types used on the Floodcast system and their linkages  
![Figure 2. Various geospatial objects/data types used on the Floodcast system and their linkages](https://opengeospatial.github.io/ELFIE/images/floodcast_fig2.png)  

### Demo Screenshot(s)

One or more screenshots with a descriptive caption for each.  
Add screenshots to https://github.com/opengeospatial/ELFIE/tree/master/docs/images
so they show up at a path like: `https://opengeospatial.github.io/ELFIE/images/ELFIE_logo.png`  

![alt text -- ELFIE Logo](https://opengeospatial.github.io/ELFIE/images/ELFIE_logo.png)

### Links to Demo Resources

Add links to source files, code used, example JSON-LD files, etc. Add descriptive text so
people can walk through the demo themselves without much prior knowledge. Describe how
the links in the data can be traversed, especially how the links are/were traversed by the demo
application.

## Demo findings and potential next steps

Discuss issues that this demo works around or would otherwise need to be solved to take
it from demonstration/experiment to production.
