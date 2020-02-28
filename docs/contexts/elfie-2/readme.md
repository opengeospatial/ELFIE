# JSON-LD Context Files

## Summary
This document summarizes normative [JSON-LD Context
Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by
JSON-LD encoded representations of resources provided by SELFIE participants.
Some contexts are new, others are modifications of contexts defined for 
[ELFIE](https://github.com/opengeospatial/ELFIE).  

See the [ELFIE-1 discussion](https://opengeospatial.github.io/ELFIE/json-ld/)
of contexts for additional background.

## Contexts

| CONTEXT FILE | COMMENT | 
| ------------ | ------- | 
| [elf-index.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-index.jsonld) | Core properties of each feature that support discovery, indexing and presentation of basic summary information. Each domain specific JSON (any type of resource) file should include these. Modified version of [ELFIE/elf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf.jsonld).  |
| [elf-data.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-data.jsonld) | Properties of an object that wraps representations of a real world ('non-information') resource. |
| [elf-network.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-network.jsonld) | A simple set of spatial and temporal topological relations from [GeoSPARQL](https://www.opengeospatial.org/standards/geosparql) and [OWL Time](https://www.w3.org/TR/owl-time/). |
| [elf-spatial.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-spatial.jsonld) | Useful [schema.org](https://schema.org) spatial content. |
| [gsmlb.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/gsmlb.jsonld) | A minimal but complete set of [GeoscieML](https://www.opengeospatial.org/standards/geosciml) classes and associations. |
| [gwml2.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/gwml2.jsonld) | A minimal but complete set of [GroundwaterML2](https://www.opengeospatial.org/standards/gwml2) classes and associations. |
| [hy_features.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/hy_features.jsonld) | A minimal but complete set of [HY\_Features](https://www.opengeospatial.org/standards/waterml) classes and associations. |
| [qudt.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/qudt.jsonld) | JSON-LD context for some [Quantities Units Dimensions and Types (QUDT)](http://qudt.org/) associations. |
| [skos.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/skos.jsonld) | SKOS classes and relations. |
| [soilie.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/soilie.jsonld) | Soil Data IE application schema classes and relations. |
| [sosa.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/sosa.jsonld) | Based on the [O&M ttl examples](https://www.w3.org/TR/vocab-ssn/integrated/examples/om-20.ttl) introduced in [Annex C.10 of SOSA specification](https://www.w3.org/TR/vocab-ssn/#omxml-examples). Restricted to O&M sampling and observation features for simplicity's sake (no sensor descriptions etc). Includes [Extended Semantic Sensor Network Onotology](https://www.w3.org/TR/vocab-ssn-ext/) associations for feature of interest and observation collections. |
| [tsml.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/tsml.jsonld) | Context for time-series Observations. |
| [void.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/void.jsonld) | [Context for the Vocabulary of Interlinked Datasets (VOID)](http://rdfs.org/ns/void) |
