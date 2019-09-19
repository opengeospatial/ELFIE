# Environmental Linked Features Interoperability Experiment
The ELFIE is intended to test existing OGC and W3C standards with the goal of establishing a best 
practice for exposing links between and among environmental domain and sampling features in a 
highly adoptible standards compliant way that is compatible with modern web search technology.  

A [Second ELFIE (SELFIE)](https://github.com/opengeospatial/SELFIE) is in progress. The outcomes of both IEs will be documented here.

### Links
[**ELFIE Engineering Report**](https://docs.opengeospatial.org/per/18-097.html){:target="_blank"}  
[**Summary of the ELFIE outcomes**](https://opengeospatial.github.io/ELFIE/presentations/ELFIE_outcomes){:target="_blank"}  
[**ELFIE outcomes presentation**](https://drive.google.com/file/d/1GvyrpWQmUt-AEzwxWdJ_G9VcpltPzSc6/view){:target="_blank"}  
[**ELFIE JSON-LD Contexts**](https://opengeospatial.github.io/ELFIE/json-ld){:target="_blank"}
[**DRAFT SELFIE JSON-LD Contexts**](https://opengeospatial.github.io/SELFIE/contexts/){:target="_blank"}
[**DRAFT SELFIE Example Documents**](https://opengeospatial.github.io/SELFIE/examples/){:target="_blank"}

### ELFIE Summary
The IE is focused on two cross-domain use cases:  
  1) exposing topological and domain feature model relationships between features and   
  2) description of sampling data available for and linked to sampled domain features  

While addressing these use cases, the IE has aimed to address issues of encoding data as specific 
views of a linked data graph that would be passed between systems. These linked data graph views are 
expected to support archictures involving linked data catalogs and registries. 

For example, data providers can use the linked data graph views as a way to advertise their monitoring 
or domain features to catalogs or other applications that want to crawl and index available data. 
Similarly, integrated catalogs that index and construct links between features can use the views as a 
linked data response to search queries.

Slides summarizing how environmental domain use cases were used for ELFIE can be found [here.](https://opengeospatial.github.io/ELFIE/presentations/use_cases){:target="_blank"}

The IE has produced numerous experimental demonstration JSON-LD instance files. The full list is available here as html preview files and plain .json files: [**ELFIE Demo Files**](https://opengeospatial.github.io/ELFIE/file_index){:target="_blank"}

The IE produced a number of demonstration visualizations. 
- [**Watershed Data Index Demo**](https://opengeospatial.github.io/ELFIE/demo/huc12obs){:target="_blank"}
- [**US Water Budgets Demo**](https://opengeospatial.github.io/ELFIE/demo/uswb){:target="_blank"}
- [**Surface-Ground Water Networks Interaction Demo**](https://opengeospatial.github.io/ELFIE/demo/surface_groundwater_network_interaction){:target="_blank"}
- [**Ground Water Monitoring Demo**](https://opengeospatial.github.io/ELFIE/demo/groundwater_monitoring){:target="_blank"}
- [**FloodCast Demo**](https://opengeospatial.github.io/ELFIE/demo/floodcast){:target="_blank"}
