## Customize Makefile settings for cryo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

## Customize Makefile settings for cryo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

PMDCO_DISJOINTNESS_REMOVAL_TERMS = $(IMPORTDIR)/pmdco_remove_disjoint.txt
IAO_TO_REMOVE = $(IMPORTDIR)/iao_to_remove.txt
PMDCO_CLASSES_TO_REMOVE = $(IMPORTDIR)/pmdco_classes_to_remove.txt


$(ONTOLOGYTERMS): $(SRCMERGED)
	$(ROBOT) query -f csv -i $< --query cryo_terms.sparql $@


$(IMPORTDIR)/pmdco_import.owl: $(MIRRORDIR)/pmdco.owl $(IMPORTDIR)/pmdco_terms.txt
	@echo "Generating Application Module from pmdco..."
	if [ $(IMP) = true ]; then $(ROBOT) \
	  query -i $< --update ../sparql/preprocess-module.ru \
	  extract --term-file $(IMPORTDIR)/pmdco_terms.txt \
	          --force true \
	          --copy-ontology-annotations true \
	          --intermediates all \
	          --method BOT \
	  \
	  query --update ../sparql/inject-subset-declaration.ru \
	        --update ../sparql/inject-synonymtype-declaration.ru \
	        --update ../sparql/postprocess-module.ru \
	  \
	  remove --term http://purl.obolibrary.org/obo/IAO_0000412 \
             --select annotation \
	  \
	  remove --term-file $(PMDCO_DISJOINTNESS_REMOVAL_TERMS) \
			 --axioms DisjointClasses \
	  remove --term-file $(PMDCO_CLASSES_TO_REMOVE) \
			 --select "classes"\
	  remove --term-file $(IAO_TO_REMOVE) \
			 --select "individuals classes"\
	  $(ANNOTATE_CONVERT_FILE); \
	fi


$(ONT)-base.owl: $(EDIT_PREPROCESSED) $(OTHER_SRC) $(IMPORT_FILES)
	$(ROBOT_RELEASE_IMPORT_MODE) \
	reason --reasoner ELK --equivalent-classes-allowed asserted-only --exclude-tautologies structural --annotate-inferred-axioms False \
	relax \
	reduce -r ELK \
	remove --base-iri $(URIBASE)/ --axioms external --preserve-structure false --trim false \
	$(SHARED_ROBOT_COMMANDS) \
	annotate --link-annotation http://purl.org/dc/elements/1.1/type http://purl.obolibrary.org/obo/IAO_8000001 \
		--ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@


CITATION=cryo: Crystallography Subdomain Ontology. Version $(VERSION), https://w3id.org/pmd/cryo/

ALL_ANNOTATIONS=--ontology-iri https://w3id.org/pmd/cryo/ -V https://w3id.org/pmd/cryo/$(VERSION) \
	--annotation http://purl.org/dc/terms/created "$(TODAY)" \
	--annotation owl:versionInfo "$(VERSION)" \
	--annotation http://purl.org/dc/terms/bibliographicCitation "$(CITATION)"  \
	--link-annotation owl:priorVersion https://w3id.org/pmd/cryo/$(PRIOR_VERSION) \

update-ontology-annotations: 
	$(ROBOT) annotate --input cryo.owl $(ALL_ANNOTATIONS) --output ../../cryo.owl && \
	$(ROBOT) annotate --input cryo.ttl $(ALL_ANNOTATIONS) --output ../../cryo.ttl && \
	$(ROBOT) annotate --input cryo-full.owl $(ALL_ANNOTATIONS) --output ../../cryo-full.owl && \
	$(ROBOT) annotate --input cryo-full.ttl $(ALL_ANNOTATIONS) --output ../../cryo-full.ttl && \
	$(ROBOT) annotate --input cryo-base.owl $(ALL_ANNOTATIONS) --output ../../cryo-base.owl && \
	$(ROBOT) annotate --input cryo-base.ttl $(ALL_ANNOTATIONS) --output ../../cryo-base.ttl && \

all_assets: update-ontology-annotations
	
