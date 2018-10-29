# JSON-LD Context Files

## Summary
This document summarizes normative [JSON-LD Context
Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by
JSON-LD encoded representations of resources provided by ELFIE participants.
These contexts and the example files linked below are general in nature and
do not make reference to any ELFIE use cases or specific demos. This is
due to the fact that they were developed in support of all use cases and
slightly preceding primary implementation of the demos.

They have been designed using the 'Testbed-12 JSON and GeoJSON User Guide'
[OGC 16-122r1](http://docs.opengeospatial.org/guides/16-122r1.html) as a
guideline. The ELFIE team relied on that guide as a cumulative summary 
of earlier discussions (e.g. those out of Testbed 11). The contexts and 
linking recommendations were later reviewed against the Architecture DWG's 
draft [JSON Best Practice](https://github.com/opengeospatial/architecture-dwg/tree/master/json-best-practice).

To ensure confidence that normative contexts are being used the context of 
a JSON-LD document should not be provided inline but by reference to 
the normative context document. This practice should ensure consistency of 
encoding (e.g. use of the same key values) as an in-line context object 
could be modified by the provider.

These contexts assume they are building blocks for a larger graph-of-graphs.
As such, they will define self-contained representations that make consistent
use of links to reference other features. The rationale is that larger documents,
pulling together a set of linked features, are use case specific and therefore
should not be limited by a core set of contexts. Obviously, being JSON-LD, an
appropriate context should be referenced with a vigorous expectation that the 
semantics of ELFIE contexts be preserved.

## File structure
- JSON keyword names are kept as simple as possible (i.e. no extended JSON-LD
namespace prefixes). This should minimize "developer trauma" and also take into
account the fact that some parsers don't like colons in keywords, even though
they are legitimate JSON.
- RDF namespace prefixes are used in the context mappings (e.g. "label":
"rdfs:label"), even if the namespace is only used once. This keeps all
the files consistent (namespaces always in the same place) and familiar
for users used to TTL etc.
- Context files are imported/re-used by creating the context as an array
where the first value(s) is the path(s) to the imported context, followed by
an object - see
[JSON-LD Syntax, Example 29](https://www.w3.org/TR/json-ld-syntax/#the-context).
- Example files should only contain a single JSON object - we are only interested 
in documenys that describe a single resource.

## ELFIE JSON-LD Best Practices
- All files/responses shall:
    - contain only one JSON object describing the requested resource
    - begin with a @context property identifying the context(s) used
    - have a JSON-LD @id (node identifier, equivalent to rdf:about, TTL's 'a') 
    after the @context
    - have a JSON-LD @type (equivalent to rdfs:type) after the @id
- All properties that can be multi-valued (e.g. any relationship) should be
presented as an array, regardless of the number of related resources. This raises 
the question: if so, should the @type key always be an array? It is possible 
for features to be of two types, e.g.: a _sosa:Sample_ and _hyf:HY\_HydrometricFeature._
- Documents should provide link relations as object stubs, allowing the
target resource to be typed and supporting decisions by a crawler (adding name
key allows creation of hyperlinks. E.g.:  

    ```json
    "relation": [
         {"@id": "http://data.example.org/id/thing/1", "@type": "sosa:Sample"},
         {"@id": "http://data.example.org/id/thing/2", "@type": "hyf:HY_River"}
    ]  
     ```

    instead of  

    ```json
    "relation": [
        "http://data.example.org/id/thing/1",
        "http://data.example.org/id/thing/2"
    ]
    ```
- We believe this approach is consistent with the ['Links in JSON'](https://github.com/opengeospatial/architecture-dwg/blob/master/json-best-practice/clause-json-encoding.adoc)
recommendations in the Architecture DWG's JSON Best Practice document.

## Contexts

| CONTEXT FILE | EXAMPLE | COMMENT | 
| ------------ | ------- | ------- | 
| [elf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf.jsonld) |  | Core properties of each feature that support discovery, indexing and basic linking. Each domain specific JSON file should include these. | 
| [elf-network.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-network.jsonld) |  | A simple set of spatial and temporal topological relations from [GeoSPARQL](https://www.opengeospatial.org/standards/geosparql) and [OWL Time](https://www.w3.org/TR/owl-time/). | 
| [floodcast.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/floodcast.jsonld) | [TX_Harvey2017_1.json](https://opengeospatial.github.io/ELFIE/dewberry/fe-harvey/floodcast/TX_Harvey2017_1.json) | FloodCast classes. |
| [gsml.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/gsml.jsonld) | [BSS001REWW.json](https://opengeospatial.github.io/ELFIE/FR/Borehole/sgsr/BSS001REWW.json) | GeoSciML 4.0 classes. |
| [gw.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/gw.jsonld) | [507AC00.json](https://opengeospatial.github.io/ELFIE/FR/Aquifer/sgsr/507AC00.json) | GroundWaterML 2.0 classes. |
| [hyf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/hyf.jsonld) | [010300032404.json](https://opengeospatial.github.io/ELFIE/usgs/nhdplusflowline/uswb/010300032404.json) | HY Features classes and relations. |
| [skos.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/skos.jsonld) | [skos-concept-nzsc-uym.json](https://opengeospatial.github.io/ELFIE/mwnz/skos-concept-nzsc-uym.json) | SKOS classes and relations. |
| [soilie.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/soilie.jsonld) | [soilie-soil-2108.json](https://opengeospatial.github.io/ELFIE/mwnz/soilie-soil-2108.json) | Soil Data IE application schema classes and relations. |
| [sosa.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/sosa.jsonld) | [sosa-sample-2108.json](https://opengeospatial.github.io/ELFIE/mwnz/sosa-sample-2108.json) | Based on the [O&M ttl examples](https://www.w3.org/TR/vocab-ssn/integrated/examples/om-20.ttl) introduced in [Annex C.10 of SOSA specification](https://www.w3.org/TR/vocab-ssn/#omxml-examples). Restricted to O&M sampling and observation features for simplicity's sake (no sensor descriptions etc). |
| [tsml.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/tsml.jsonld) |  | Context for time-series Observations. _See notes below._ |
| | [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/tsml/xample-elf-tsml-observation-byref.json) | Example where the observation result ("hasResult") is presented as a reference to another file. In this case a pair of TSML GML files (xample-elf-tsml-result-dr.xml; xample-elf-tsml-result-tvp.xml). |
| | [xample-elf-tsml-observation-inline.json](https://opengeospatial.github.io/ELFIE/tsml/xample-elf-tsml-observation-inline.json) | Example where the observation result ("hasResult") is presented as an inline JSON object. |
| | [xample-elf-tsml-result-dr.xml](https://opengeospatial.github.io/ELFIE/tsml/xample-elf-tsml-result-dr.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Domain-Range encoding. |
| | [xample-elf-tsml-result-tvp.xml](https://opengeospatial.github.io/ELFIE/tsml/xample-elf-tsml-result-tvp.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Time-Value-Pair encoding. | 

## Deprecated Contexts
A number of contexts were deprecated or renamed as the experiment progressed. These can be found 
[here](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/).

## TimeseriesML Experiment
A simple experiment to test the provision of time-series data using the Timeseries 
profile of Observations and Measurements ([OGC 15-043r3](http://docs.opengeospatial.org/is/15-043r3/15-043r3.html)).
- Note that the namespaces here are from XML as there is no RDF encoding for
TimeseriesML. This would be a valuable additional encoding to create.
- The inline example result is a _tsml:TimeseriesDomainRange_ value - selected
as the most 'web friendly' (terse) encoding.
- The inline example only uses the _gml:domainSet_, _gml:rangeSet_ and
_tsml:deafultPointMetadata_ properties. In an XML doc the latter is nested more deeply 
`(gmlcov:metadata\gmlcov:Extension\tsml:TimeseriesMetadataExtension\tsml:defaultPointMetadata)`
but this was ignored for clarity, and to stimulate discussion.
- The inline example vocabulary references ("uom" and "interpolationType") are
presented as typed and labelled object stubs.
- The reference example result is an array of references for the same result
with different encodings (DR and TVP). _ABHR: this feels like a hack and that
it is getting too close to the alternative representations problem we're trying
to avoid getting caught up in. Thoughts?_ An alternative to the typed example 
(see [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-observation-byref.json)) 
is a simple array.

    ```json
    "hasResult": [
        "https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-dr.xml",
        "https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-tvp.xml"
    ]
     ```