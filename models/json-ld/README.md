# JSON-LD Context Files

## Summary
Normative [JSON-LD Context Files](https://www.w3.org/TR/json-ld/#the-context) to be referenced by JSON-LD encoded representations of resources provided by ELFIE participants.

The context of a JSON-LD document should not be provided inline but by reference to one of these normative context documents. This practices should ensure consistency of encoding (use of the same key values etc). Also, it is advantage that some mapping is done before a document is created - want to minimise the amount of mediation required when parsing a JSON-LD document.

## Contexts
| VIEW | CONTEXT FILE | COMMENT |
| ---- | --------- | ------- |
| elf-basic | elf-basic.json-ld | rdfs:type from elf-basic maps on to JSON-LD's @type keyword. |
| elf-preview | elf-preview.json-ld | Imports elf-basic.jsonld. |
| elf-net-basic | elf-net-basic.json-ld |  |
| elf-net-spatial | elf-net-spatial.json-ld | Imports elf-net-basic.jsonld. Deliberately dropped 'sf' prefix from keyword names to reinforce the fact we recommend picking and sticking with one topology model. (Discus?) |
| elf-net-temporal | elf-net-temporal.json-ld | Imports elf-net-basic.jsonld. |
| elf-net | elf-net.json-ld | Imports elf-net-basic.jsonld, elf-net-spatial.jsonld, elf-net-temporal.jsonld |