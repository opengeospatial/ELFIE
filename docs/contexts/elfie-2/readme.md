# JSON-LD Context Files

## Summary
This document summarizes normative [JSON-LD Context
Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by
JSON-LD encoded representations of resources provided by SELFIE participants.
Some contexts are new, others are modifications of contexts defined for 
[ELFIE](https://github.com/opengeospatial/ELFIE)

## Contexts

| CONTEXT FILE | COMMENT | 
| ------------ | ------- | 
| [elf-index.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-index.jsonld) | Core properties of each feature that support discovery, indexing and presentation of basic summary information. Each domain specific JSON (any type of resource) file should include these. Modified version of [ELFIE/elf.jsonld](https://opengeospatial.github.io/ELFIE/json-ld/elf.jsonld).  |
| [elf-data.jsonld](https://opengeospatial.github.io/ELFIE/contexts/elfie-2/elf-data.jsonld) | Properties of an object that wraps representations of a real world ('non-information') resource. |
| [gsmlb_minimal_context.jsonld]() | A minimal but complete set of [GeoscieML](https://www.opengeospatial.org/standards/geosciml) classes and associations. |
| [gwml2_minimal_context.jsonld]() | A minimal but complete set of [GroundwaterML2](https://www.opengeospatial.org/standards/gwml2) classes and associations. |
| [hyf_minimal_context.jsonld]() | A minimal but complete set of [HY\_Features](https://www.opengeospatial.org/standards/waterml) classes and associations. |
| [qudt.jsonld]() | JSON-LD context for some [Quantities Units Dimensions and Types (QUDT)](http://qudt.org/) associations. |
| [spatial.jsonld]() | Useful [schema.org](https://schema.org) spatial content. |
| [ssn-ext.jsonld]() | [Extended Semantic Sensor Network Onotology](https://www.w3.org/TR/vocab-ssn-ext/) associations for feature of interest and observation collections. |
| [void.jsonld]() | [Context for the Vocabulary of Interlinked Datasets (VOID)](http://rdfs.org/ns/void) |
