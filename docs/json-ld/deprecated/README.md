# Deprecated JSON-LD Context Files

## Summary
The following contexts were removed or renamed during the course of the IE.

Discussions at the Southampton TC showed that the proposed elf-basic and elf-preview contexts were 
muddled and tried to do too many things:

- Support indexing of data
- Provide basic ownership data
- Announce conditions for using the data

As the IE is primarily about linking features and enabling discovery of data we agreed to switch 
focus of the core ELFIE contexts to the indexing/discoverability use case. This is best implemented 
using schema.org. elf-basic and elf-preview can be replaced with the schema.org context file. 
(We'll only use a small subset of keys - those associated with a Thing or Place).

[Issue 53](https://github.com/opengeospatial/ELFIE/issues/53) removed elf-basic and elf-preview 
and added the link to the schema.org context to relevant contexts and example documents.

## Experiment - ELFIE GeoJSON-LD
There is a [GeoJSON-LD vocabulary](http://geojson.org/geojson-ld/) and we thought it would 
be interesting to extend the [GeoJSON-LD context](http://geojson.org/geojson-ld/geojson-context.jsonld) 
to identify ELFIE properties that can be discovered in the GeoJSON properties object. The context is 
simple, it just imports all the ELFIE view contexts (elf-all.jsonld).

As it is just a convenience document, there's nothing to stop a service provider individually 
referencing the specific ELFIE contexts as appropriate.

The example file (xample-elf-geojson.json) is valid according to the [GeoJSONLint validator](http://geojsonlint.com/).

Ultimately this experiment was abandoned as GeoJSON geometries are not legal JSON-LD objects. 
See 'Outstanding issues' in the [GeoJSON JSON-LD vocabulary proposal](http://geojson.org/geojson-ld/).

## Contexts
| VIEW | CONTEXT FILE | EXAMPLE | COMMENT |
| ---- | ------------ | ------- | ------- |
| eld-all | [elf-all.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-all.jsonld) | [xample-elf-all.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-all.json) | An all components context that imports everything for when you just want to say everything you know. _Necessary? Even more importantly - is this legitimate?_ |
| elf-basic | [elf-basic.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-basic.jsonld) |  | rdfs:type from elf-basic maps on to JSON-LD's @type keyword. |
| elf-geojson | [elf-geojson.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-geojson.jsonld) | [xample-elf-geojson.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-geojson.json) | See 'Experiment - ELFIE GeoJSON-LD' above. Imports http://geojson.org/geojson-ld/geojson-context.jsonld |
| elf-index | [elf-index.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-index.jsonld) | [xample-elf-index.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-index.json) | Core properties of each feature that support discovery/indexing. Each domain specific JSON file should include these. |
| elf-net-basic | [elf-net-basic.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-net-basic.jsonld) | [xample-elf-net-basic.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-net-basic.json) |  |
| elf-net-spatial | [elf-net-spatial.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-net-spatial.jsonld) | [xample-elf-net-spatial.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-net-spatial.json) | Imports elf-net-basic.jsonld. Deliberately dropped 'sf' prefix from keyword names to reinforce the fact we recommend picking and sticking with one topology model. _(Discuss?)_ |
| elf-net-temporal | [elf-net-temporal.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-net-temporal.jsonld) | [xample-elf-net-temporal.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-net-temporal.json) | Imports elf-net-basic.jsonld. |
| elf-net | [elf-net.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-net.jsonld) |  | Imports elf-net-basic.jsonld, elf-net-spatial.jsonld, elf-net-temporal.jsonld |
| elf-preview | [elf-preview.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-preview.jsonld) |  |
| _elf-sosa_ |  |  | Based on the [O&M ttl examples](https://www.w3.org/TR/vocab-ssn/integrated/examples/om-20.ttl) introduced in [Annex C.10 of SOSA specification](https://www.w3.org/TR/vocab-ssn/#omxml-examples). Restricted to O&M sampling features for simplicity's sake (no sensor descriptions etc). Split into a context per feature type for clarity. Possibly no real need? |
| elf-sosa-sample | [elf-sosa-sample.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-sosa-sample.jsonld) | | Context for Samples - in our case sampling features such as monitoring stations, boreholes etc. |
| | | [xample-elf-sosa-sample.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-sosa-sample.json) | Example with multiple observations inline - used the @graph key as all objects in the array share the same context. |
| | | [xample-elf-sosa-sample-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-sosa-sample-byref.json) | As above, but observations by reference. |
| | | [xample-elf-sosa-sample-preview.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-sosa-sample-preview.json) | Monitoring station using only preview and simple relationship keys. |
| elf-sosa-observation | [elf-sosa-observation.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-sosa-observation.jsonld) | [xample-elf-sosa-observation.json](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/example/xample-elf-sosa-observation.json) | Context for Observations. |

Context and example files are published in the docs folder and can be referred to at the path 
https://opengeospatial.github.io/ELFIE/json-ld/deprecated.  
For example: https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-geojson.jsonld