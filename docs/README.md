# Environmental Linked Features Interoperability Experiment
The ELFIE is intended to test existing OGC and W3C standards with the goal of establishing a best
practice for exposing links between and among environmental domain and sampling features in a
highly adoptible standards compliant way that is compatible with modern web search technology.  

A [Second ELFIE (SELFIE)](https://github.com/opengeospatial/SELFIE) is complete. The outcomes of both IEs are documented here.

### Links
[**ELFIE Engineering Report**](https://docs.opengeospatial.org/per/18-097.html){:target="_blank"}  
[**SELFIE Engineering Report**](https://docs.ogc.org/per/20-067.html){:target="_blank"}  
[**Summary of the ELFIE outcomes**](https://opengeospatial.github.io/ELFIE/presentations/ELFIE_outcomes){:target="_blank"}  
[**ELFIE outcomes presentation**](https://drive.google.com/file/d/1GvyrpWQmUt-AEzwxWdJ_G9VcpltPzSc6/view){:target="_blank"}  
[**ELFIE JSON-LD Contexts**](https://opengeospatial.github.io/ELFIE/json-ld){:target="_blank"}  
[**SELFIE JSON-LD Contexts**](https://opengeospatial.github.io/ELFIE/contexts/elfie-2){:target="_blank"}  
[**SELFIE Example Documents**](https://opengeospatial.github.io/ELFIE/selfie_examples/){:target="_blank"}  

### SELFIE Summary

The business case for the SELFIE can be illustrated considering two use cases:

- indexing and discovering models and research from public sector, private sector, or academic projects about a particular place or environmental feature.
- building a federated multi-organization monitoring network in which all member-systems reference common monitored features and are discoverable through a community index.

These use cases imply needs along several dimensions:

- a shared reference network of environmental features,
- the ability to use the reference network to index and provide access to information resources from many organizations,
- support for multiple disciplines' information models, conceptual models, research topics, and monitoring practices.

While the IE did not come to conclusion on all these fronts, it did show that the core Web architecture to support identification of real-world features and retrieving information about them exists and should be pursued in earnest.

Gaining an appreciation for the nuances of the functionalities and technical use cases required in the context of the broadly varied organizational architectures considered was a large task.  Given that, future work should investigate issues such as variation of content for a single resource, multiple representations of the same feature with variation of content across the providers, and content negotiation of non-information resources to either directly access information resources or access differing profiles of landing content.

OGC API - Features was found to be compatible with all of the above and can be used as a core enabling Web API as networks of linked environmental features are established.

For more, see the [**SELFIE Engineering Report**](https://docs.ogc.org/per/20-067.html){:target="_blank"}

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
