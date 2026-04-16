
![Build Status](https://github.com/cmllezr/crystallography-subdomain-ontology/actions/workflows/qc.yml/badge.svg)
# CryO: Crystallography ontology  - extension to Platform Material Digital Core Ontology 3.x.

Description: CryO is an subdomain-level ontology in Material Science and Engineering domain focusing on semantic modeling of crystallography. CryO is based on the third version of the [Platform Material Digital Core Ontology (PMDco)](https://github.com/materialdigital/core-ontology).

## File Structure

This folder provides the modular implementation of CryO, developed and maintained using the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit).

### Directories
* **src/:** Main development folder generated and managed through ODK.
  * **ontology/components/:** – Modular ontology components.
  * **ontology/cryo-edit.owl:** – Primary editable ontology file used during development (ontology editors' version).

### Ontology versions
* **cryo-full.owl/ttl:** Complete ontology with all imports and full axiomatization.
* **cryo-base.owl/ttl:** Core entities without extended imports.
* **cryo-simple.owl/ttl:** Simplified version with basic subclass and existential axioms.
* **cryo.owl/ttl:** Main ontology file contains the full version.

### Other files
* README.md, LICENSE.txt, CONTRIBUTING.md – Project overview, license, and contribution guidelines.

## Versions

### Stable release versions

The latest version of the ontology can always be found at:

https://w3id.org/pmd/cryo.owl

(note this will not show up until the request has been approved by obofoundry.org)

### Editors' version

Editors of this ontology should use the edit version, [src/ontology/cryo-edit.owl](src/ontology/cryo-edit.owl)

## Contact

Please use this GitHub repository's [Issue tracker](https://github.com/cmllezr/crystallography-subdomain-ontology/issues) to request new terms/classes or report errors or specific concerns related to the ontology.

## Acknowledgements

This ontology repository was created using the [Ontology Development Kit (ODK)](https://github.com/INCATools/ontology-development-kit).