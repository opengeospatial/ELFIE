# JSON-LD Context Files

## Summary
Normative [JSON-LD Context Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by 
JSON-LD encoded representations of resources provided by ELFIE participants.

I've tried to stick as close as possible to Joan Maso and Alaitz Zabala's 'Testbed-12 JSON and 
GeoJSON User Guide' [OGC 16-122r1](http://docs.opengeospatial.org/guides/16-122r1.html). Have made the 
assumption that it cumulatively summarises early discussions (e.g. those out of Testbed 11 etc).

The context of a JSON-LD document should not be provided inline but by reference to one of these 
normative context documents. This practices should ensure consistency of encoding (use of the same 
key values etc). Also, it is advantage that some mapping is done before a document is created - 
want to minimise the amount of mediation required when parsing a JSON-LD document.

These contexts assume they are building blocks for a larger graph-of-graphs. As such, they will 
define self-contained representations that make consistent use of links to reference other features 
(only in exceptional circumstances, of which I can think of none, will features by returned as 
embedded objects). The rational is that larger documents, pulling together a set of linked 
features, are use case specific and therefore should be limited by a core set of contexts. 
Obviously, being JSON-LD, an appropriate context should be provided, either in-line or by 
reference, with a vigorous expectation that the semantics of ELFIE contexts be preserved.

## File structure
- Files are named according to the ELFIE view they realize. Either the
 [core set of views](https://github.com/opengeospatial/ELFIE/wiki/Predicates) or the
 [domain-specific views](https://github.com/opengeospatial/ELFIE/wiki/Domain-Features-and-Predicates).
- JSON keyword names are kept as simple as possible (i.e. no extended JSON-LD namespace prefixes). 
This should minimise developer trauma and also take into account the fact that some parsers don't 
like colons in keywords, even though they are legitimate JSON (_ABHR: it is possible that the devs 
who brought this to my attention didn't know to put extended keywords in [] when accessing values._).
- RDF namespace prefixes are used in the context mappings (e.g. "label": "rdfs:label"), even if the 
namespace is only used once. This keeps all the files consistent (namespaces always in the same 
place) and familiar for users used to TTL etc.
- Context files are imported/re-used by creating the context as an array where the first value(s) 
is the path(s) to the imported context, followed by an object - see
 [JSON-LD Syntax, Example 29](https://www.w3.org/TR/json-ld-syntax/#the-context).
- Example files (prefixed 'xample-') always contain a single JSON object - we are interested in 
responses that only ever describe a single resource. _ABHR: true? I can't think of an example where 
we'd want multiple instances of the same resource._

## ELFIE JSON-LD Best Practices
- All files/responses shall:
    - contain only one JSON object describing the requested resource
    - begin with a @context property identifying the context(s) used
    - have a JSON-LD @id (node identifier, equivalent to rdf:about, TTL's 'a') after the @context
    - have a JSON-LD @type (equivalent to rdfs:type) after the @id
- All properties that can be multi-valued (e.g. any relationship) should be presented as an array, 
regardless of the number of related resources. _ABHR: if so, should the @type key always be an 
array? It is possible for features to be of two types, e.g.: sosa:Sample_ and _hyf:HY\_HydrometricFeature._
- Where all members of the array share the same context (overriding the root context) then the
 value should be a JSON object with a @context key and a @graph key whose value is the array.
 See [xample-elf-sosa-sample.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-sosa-sample.json). E.g.:
    ```json
    "isFeatureOfInterestOf": {
        "@context": "https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-observation.jsonld",
        "@graph": [{...},{...},...]
    } 
     ```
- Each mapping shall defer typing of a property to the source RDF scheme, the exception being 
relations - these shall be explicitly typed as @ids to force the use of URIs. (See the last 
paragraph of the summary for why relations will always be by reference.)
- In elf-preview should provide link relations as elf-basic objects, allowing the target resource
 to be typed and supporting decisions by a crawler (adding label key allows creation of hyperlinks. E.g.:  
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
- _Should everything import elf-basic.jsonld (so we can have a friendly label, say for creating 
hyperlinks)?_

## TimeseriesML Examples
- This is a hack - the namespaces are XML ones as the is no RDF encoding for TimeseriesML. _ABHR: perhaps 
we should come up with a temporary ontology?_
- The inline example result is a _tsml:TimeseriesDomainRange_ value - selected as the most 'web friendly' (terse) encoding.
- The inline example only uses the _gml:domainSet_, _gml:rangeSet_ and _tsml:deafultPointMetadata_ properties. In an XML doc 
the latter is nested deeper (gmlcov:metadata\gmlcov:Extension\tsml:TimeseriesMetadataExtension\tsml:defaultPointMetadata) 
but this was ignored for clarity, and to stimulate discussion.
- The inline example vocabulary references ("uom" and "interpolationType") are presented as typed and labelled object stubs.
- The reference example result is an array of references for the same result with different encodings (DR and TVP). _ABHR: 
this feels like a hack and that it is getting too close to the alternative representations problem we're trying to avoid 
getting caught up in. Thoughts?_ An alternative to the typed example (see [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-observation-byref.json)) 
is a simple array.
    ```json
    "hasResult": [
        "https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-result-dr.xml",
        "https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-result-tvp.xml"
    ]
     ```

## Contexts
Assuming one context file per type, e.g. sosa:Sample. For elf-basic, elf-preview and elf-net-* this is effectively rdfs:Class (owl:Thing?).  
skos:editorialNotes have been smuggled into the (e)xample files to explain some decisions that otherwise might get lost in the readme.

| VIEW | CONTEXT FILE | EXAMPLE | COMMENT |
| ---- | ------------ | ------- | ------- |
| eld-all | [elf-all.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-all.jsonld) | [xample-elf-all.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-all.json) | An all components context that imports everything for when you just want to say everything you know. _Necessary? Even more importantly - is this legitimate?_ |
| elf-index | [elf-index.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-index.jsonld) | [xample-elf-index.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-index.json) | Core properties of each feature that support discovery/indexing. Each domain specific JSON file should include these. |
| elf-net-basic | [elf-net-basic.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-net-basic.jsonld) | [xample-elf-net-basic.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-net-basic.json) |  |
| elf-net-spatial | [elf-net-spatial.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-net-spatial.jsonld) | [xample-elf-net-spatial.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-net-spatial.json) | Imports elf-net-basic.jsonld. Deliberately dropped 'sf' prefix from keyword names to reinforce the fact we recommend picking and sticking with one topology model. _(Discuss?)_ |
| elf-net-temporal | [elf-net-temporal.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-net-temporal.jsonld) | [xample-elf-net-temporal.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-net-temporal.json) | Imports elf-net-basic.jsonld. |
| elf-net | [elf-net.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-net.jsonld) |  | Imports elf-net-basic.jsonld, elf-net-spatial.jsonld, elf-net-temporal.jsonld |
| elf-geojson | [elf-geojson.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-geojson.jsonld) | [xample-elf-geojson.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-geojson.json) | See 'Experiment - ELFIE GeoJSON-LD' below. Imports http://geojson.org/geojson-ld/geojson-context.jsonld |
| _elf-sosa_ |  |  | Based on the [O&M ttl examples](https://www.w3.org/TR/vocab-ssn/integrated/examples/om-20.ttl) introduced in [Annex C.10 of SOSA specification](https://www.w3.org/TR/vocab-ssn/#omxml-examples). Restricted to O&M sampling features for simplicity's sake (no sensor descriptions etc). Split into a context per feature type for clarity. Possibly no real need? |
| elf-sosa-sample | [elf-sosa-sample.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-sample.jsonld) | | Context for Samples - in our case sampling features such as monitoring stations, boreholes etc. |
| | | [xample-elf-sosa-sample.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-sosa-sample.json) | Example with multiple observations inline - used the @graph key as all objects in the array share the same context. |
| | | [xample-elf-sosa-sample-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-sosa-sample-byref.json) | As above, but observations by reference. |
| | | [xample-elf-sosa-sample-preview.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-sosa-sample-preview.json) | Monitoring station using only preview and simple relationship keys. |
| elf-sosa-observation | [elf-sosa-observation.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-observation.jsonld) | [xample-elf-sosa-observation.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-sosa-observation.json) | Context for Observations. |
| elf-tsml-observation | [elf-sosa-observation.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-sosa-observation.jsonld) |  | Context for time-series Observations. _See notes above._ |
|  |  | [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-observation-byref.json) | Example where the observation result ("hasResult") is presented as a reference to another file. In this case a pair of TSML GML files (xample-elf-tsml-result-dr.xml; xample-elf-tsml-result-tvp.xml). |
|  |  | [xample-elf-tsml-observation-inline.json](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-observation-inline.json) | Example where the observation result ("hasResult") is presented as an inline JSON object. |
|  |  | [xample-elf-tsml-result-dr.xml](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-result-dr.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Domain-Range encoding. |
|  |  | [xample-elf-tsml-result-tvp.xml](https://opengeospatial.github.io/ELFIE/json-ld/xample-elf-tsml-result-tvp.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Time-Value-Pair encoding. |  

Context and example files are published in the docs folder and can be referred to at the path 
https://opengeospatial.github.io/ELFIE/json-ld/.  
For example: https://opengeospatial.github.io/ELFIE/json-ld/elf-preview.jsonld

## Experiment - ELFIE GeoJSON-LD
There is a [GeoJSON-LD vocabulary](http://geojson.org/geojson-ld/) and I (ABHR) thought it would 
be interesting to extend the [GeoJSON-LD context](http://geojson.org/geojson-ld/geojson-context.jsonld) 
to identify ELFIE properties that can be discovered in the GeoJSON properties object. Basically it 
just imports all the ELFIE view contexts (elf-all.jsonld).

It is really just a convenience document, there's nothing to stop a provided individually 
referencing the specific ELFIE contexts as appropriate.

The example file (xample-elf-geojson.json) is valid according to the [GeoJSONLint validator](http://geojsonlint.com/).

## Deprecated Contexts
The following were removed during the course of the IE.

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

| VIEW | CONTEXT FILE | EXAMPLE | COMMENT |
| ---- | ------------ | ------- | ------- |
| elf-basic | [elf-basic.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-basic.jsonld) |  | rdfs:type from elf-basic maps on to JSON-LD's @type keyword. |
| elf-preview | [elf-preview.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-preview.jsonld) |  |
