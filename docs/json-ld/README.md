# JSON-LD Context Files

## Summary
This document summarizes normative [JSON-LD Context
Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by
JSON-LD encoded representations of resources provided by ELFIE participants.

They have been designed with the 'Testbed-12 JSON and GeoJSON User Guide'
[OGC 16-122r1](http://docs.opengeospatial.org/guides/16-122r1.html) as a
guideline. The ELFIE team is relying on that guide as a cumulative summary  
of earlier discussions (e.g. those out of Testbed 11 etc).

The context of a JSON-LD document should not be provided inline but by
reference to normative context documents. This practices should ensure
consistency of encoding (use of the same key values etc). Also, it is
advantageous to do some data mapping prior to creating a document - in other
words, minimizing the amount of mediation required when parsing a JSON-LD
document is a good thing.

These contexts assume they are building blocks for a larger graph-of-graphs.
As such, they will define self-contained representations that make consistent
use of links to reference other features. The rational is that larger documents,
pulling together a set of linked features, are use case specific and therefore
should be limited by a core set of contexts. Obviously, being JSON-LD, an
appropriate context should be provided, either in-line or by reference, with
a vigorous expectation that the semantics of ELFIE contexts be preserved.

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
- Example files (prefixed 'xample-') always contain a single JSON object - we
are interested in responses that only ever describe a single resource.

## ELFIE JSON-LD Best Practices
- All files/responses shall:
    - contain only one JSON object describing the requested resource
    - begin with a @context property identifying the context(s) used
    - have a JSON-LD @id (node identifier, equivalent to rdf:about, TTL's 'a') after the @context
    - have a JSON-LD @type (equivalent to rdfs:type) after the @id
- All properties that can be multi-valued (e.g. any relationship) should be
presented as an array, regardless of the number of related resources. _ABHR:
if so, should the @type key always be an array? It is possible for features to
be of two types, e.g.: sosa:Sample_ and _hyf:HY\_HydrometricFeature._
- Each mapping shall defer typing of a property to the source RDF scheme, the
exception being relations - these shall be explicitly typed as @ids to force
the use of URIs. (See the last paragraph of the summary for why relations will
always be by reference.) _NOTE_ This is no longer the case as our approach to
'linking' uses object stubs rather than IRIs as literal values. See below.
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

## TimeseriesML Examples
- Note that the namespaces here are from XML as there is no RDF encoding for
TimeseriesML. This would be a valuable additional encoding to create.
- The inline example result is a _tsml:TimeseriesDomainRange_ value - selected
as the most 'web friendly' (terse) encoding.
- The inline example only uses the _gml:domainSet_, _gml:rangeSet_ and
_tsml:deafultPointMetadata_ properties. In an XML doc the latter is nested more deeply `(gmlcov:metadata\gmlcov:Extension\tsml:TimeseriesMetadataExtension\tsml:defaultPointMetadata)`
but this was ignored for clarity, and to stimulate discussion.
- The inline example vocabulary references ("uom" and "interpolationType") are
presented as typed and labelled object stubs.
- The reference example result is an array of references for the same result
with different encodings (DR and TVP). _ABHR: this feels like a hack and that
it is getting too close to the alternative representations problem we're trying
to avoid getting caught up in. Thoughts?_ An alternative to the typed example (see [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-observation-byref.json)) is a simple array.

    ```json
    "hasResult": [
        "https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-dr.xml",
        "https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-tvp.xml"
    ]
     ```

## Contexts
Assuming one context file per type, e.g. sosa:Sample. For elf-basic,
elf-preview and elf-net-* this is effectively rdfs:Class (owl:Thing?).  
skos:editorialNotes have been added into the (e)xample files to explain  
some decisions that otherwise might get lost in the readme.

| CONTEXT FILE | EXAMPLE | COMMENT |
| ------------ | ------- | ------- |
| [elf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf.jsonld) | [xample-elf-all.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-all.json) | Core properties of each feature that support discovery, indexing and basic linking. Each domain specific JSON file should include these. |
| [elf-network.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf-network.jsonld) | [xample-elf-net-basic.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-net-basic.json) |  |
| [sosa.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/sosa.jsonld) |  | Based on the [O&M ttl examples](https://www.w3.org/TR/vocab-ssn/integrated/examples/om-20.ttl) introduced in [Annex C.10 of SOSA specification](https://www.w3.org/TR/vocab-ssn/#omxml-examples). Restricted to O&M sampling and observation features for simplicity's sake (no sensor descriptions etc). Split into a context per feature type for clarity. Possibly no real need? |
| [tsml.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/tsml.jsonld) |  | Context for time-series Observations. _See notes above._ |
| | [xample-elf-tsml-observation-byref.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-observation-byref.json) | Example where the observation result ("hasResult") is presented as a reference to another file. In this case a pair of TSML GML files (xample-elf-tsml-result-dr.xml; xample-elf-tsml-result-tvp.xml). |
| | [xample-elf-tsml-observation-inline.json](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-observation-inline.json) | Example where the observation result ("hasResult") is presented as an inline JSON object. |
| | [xample-elf-tsml-result-dr.xml](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-dr.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Domain-Range encoding. |
| | [xample-elf-tsml-result-tvp.xml](https://opengeospatial.github.io/ELFIE/json-ld/examples/xample-elf-tsml-result-tvp.xml) | Target of the reference in xample-elf-tsml-observation-byref.json. Time-Value-Pair encoding. |  
| [floodcast.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/floodcast.jsonld) |  | FloodCast classes. |
| [gw.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/gw.jsonld) |  | GWML 2.0 classes. |
| [hyf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/hyf.jsonld) |  | HY Features classes and relations. |

## Deprecated Contexts
The following were removed during the course of the IE.

Discussions at the Southampton TC showed that the proposed elf-basic and
elf-preview contexts were muddled and tried to do too many things:

- Support indexing of data
- Provide basic ownership data
- Announce conditions for using the data

As the IE is primarily about linking features and enabling discovery of data
we agreed to switch focus of the core ELFIE contexts to the
indexing/discoverability use case. This is best implemented using schema.org.
elf-basic and elf-preview can be replaced with the schema.org context file.
(We'll only use a small subset of keys - those associated with a Thing or Place).

[Issue 53](https://github.com/opengeospatial/ELFIE/issues/53) removed
elf-basic and elf-preview and added the link to the schema.org context
to relevant contexts and example documents.

| VIEW | CONTEXT FILE | EXAMPLE | COMMENT |
| ---- | ------------ | ------- | ------- |
| elf-basic | [elf-basic.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-basic.jsonld) |  | rdfs:type from elf-basic maps on to JSON-LD's @type keyword. |
| elf-preview | [elf-preview.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/deprecated/elf-preview.jsonld) |  |

Other deprecations are of less interest to the outcome of the project and
are not listed here.
