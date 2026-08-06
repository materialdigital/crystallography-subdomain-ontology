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


#$(IMPORTDIR)/pmdco_import.owl: $(MIRRORDIR)/pmdco.owl $(IMPORTDIR)/pmdco_terms.txt
#	@echo "Generating Application Module from pmdco..."
#	if [ $(IMP) = true ]; then $(ROBOT) \
#	  query -i $< --update ../sparql/preprocess-module.ru \
#	  extract --term-file $(IMPORTDIR)/pmdco_terms.txt \
#	          --force true \
#	          --copy-ontology-annotations true \
#	          --intermediates all \
#	          --method BOT \
#	  \
#	  query --update ../sparql/inject-subset-declaration.ru \
#	        --update ../sparql/inject-synonymtype-declaration.ru \
#	        --update ../sparql/postprocess-module.ru \
#	  \
#	  remove --term http://purl.obolibrary.org/obo/IAO_0000412 \
 #            --select annotation \
#	  \
#	  remove --term-file $(PMDCO_DISJOINTNESS_REMOVAL_TERMS) \
#			 --axioms DisjointClasses \
#	  remove --term-file $(PMDCO_CLASSES_TO_REMOVE) \
#			 --select "individuals classes"\
#	  remove --term-file $(IAO_TO_REMOVE) \
#			 --select "individuals classes"\
#	  $(ANNOTATE_CONVERT_FILE); \
#	fi

$(IMPORTDIR)/pmdco_import.owl: $(MIRRORDIR)/pmdco.owl $(IMPORTDIR)/pmdco_terms.txt
	$(ROBOT) filter --input $(MIRRORDIR)/pmdco.owl \
		--term-file $(IMPORTDIR)/pmdco_terms.txt \
		--allow-punning true \
		--select "annotations self parents" \
		$(ANNOTATE_CONVERT_FILE)

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms.txt \
			   $(IMPORTSEED) | all_robot_plugins
	$(ROBOT) annotate --input $< --remove-annotations \
		 odk:normalize --add-source true \
		 extract --term-file $(IMPORTDIR)/obi_terms.txt $(T_IMPORTSEED) \
		         --force true --copy-ontology-annotations true \
		         --individuals exclude \
		         --method SUBSET \
		 remove --term IAO:0000416 \
		 remove --term CHEBI:33375 \
		 remove --term CHEBI:33359 \
		 remove --term CHEBI:30682 \
		 remove --term CHEBI:33376 \
		 remove --term PATO:0000122 \
		 remove --term PATO:0000918 \
		 remove --term-file $(IMPORTDIR)/unwanted.txt  \
		 remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
		        --term-file $(IMPORTDIR)/obi_terms.txt $(T_IMPORTSEED) \
		        --select complement --select annotation-properties \
		 odk:normalize --base-iri https://w3id.org/pmd/cryo \
		               --subset-decls true --synonym-decls true \
		 repair --merge-axiom-annotations true \
		 $(ANNOTATE_CONVERT_FILE)


$(IMPORTDIR)/cob_import.owl: $(MIRRORDIR)/cob.owl $(IMPORTDIR)/cob_terms.txt | all_robot_plugins
	$(ROBOT) annotate --input $< --remove-annotations \
		 odk:normalize --add-source true \
		 extract --term-file $(IMPORTDIR)/cob_terms.txt $(T_IMPORTSEED) \
		         --force true --copy-ontology-annotations true \
		         --individuals exclude \
		         --method SUBSET \
		 remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
		        --term-file $(IMPORTDIR)/cob_terms.txt $(T_IMPORTSEED) \
		        --select complement --select annotation-properties \
		 odk:normalize --base-iri https://w3id.org/pmd/cryo \
		               --subset-decls true --synonym-decls true \
		 repair --merge-axiom-annotations true \
		 $(ANNOTATE_CONVERT_FILE)

## Default module type (slme)
$(IMPORTDIR)/ro_import.owl: $(MIRRORDIR)/ro.owl $(IMPORTDIR)/ro_terms.txt \
			   $(IMPORTSEED) | all_robot_plugins
	$(ROBOT) annotate --input $< --remove-annotations \
	     remove --select "RO:*" --select complement --select "classes"  --axioms annotation \
		 odk:normalize --add-source true \
		 extract --term-file $(IMPORTDIR)/ro_terms.txt  \
		         --force true --copy-ontology-annotations true \
		         --individuals exclude \
		         --method SUBSET \
		 remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
		        --term-file $(IMPORTDIR)/ro_terms.txt \
		        --select complement --select annotation-properties \
		 remove --term-file $(IMPORTDIR)/unwanted.txt  \
		 odk:normalize --base-iri https://w3id.org/pmd/cryo \
		               --subset-decls true --synonym-decls true \
		 $(ANNOTATE_CONVERT_FILE)


$(IMPORTDIR)/iao_import.owl: $(MIRRORDIR)/iao.owl $(IMPORTDIR)/iao_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		remove --select "IAO:*" --select complement --select "classes object-properties data-properties"  --axioms annotation \
		extract --term-file $(IMPORTDIR)/iao_terms.txt  --force true --copy-ontology-annotations true --individuals exclude --intermediates none --method BOT \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
 		remove --term IAO:0000032 --axioms subclass \
 		remove --term-file $(IMPORTDIR)/unwanted.txt  \
 		remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
			  --term-file $(IMPORTDIR)/iao_terms.txt \
		      --select complement --select annotation-properties \
		$(ANNOTATE_CONVERT_FILE); fi


$(IMPORTDIR)/bfo_import.owl: $(MIRRORDIR)/bfo.owl $(IMPORTDIR)/bfo_terms.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T $(IMPORTDIR)/bfo_terms.txt --force true --copy-ontology-annotations true --method SUBSET \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
 		remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
			  --term-file $(IMPORTDIR)/bfo_terms.txt \
		      --select complement --select annotation-properties \
		$(ANNOTATE_CONVERT_FILE); fi	

$(IMPORTDIR)/uo_import.owl: $(MIRRORDIR)/uo.owl $(IMPORTDIR)/uo_terms.txt
	$(ROBOT) filter --input $(MIRRORDIR)/uo.owl \
		--term-file $(IMPORTDIR)/uo_terms.txt \
		--allow-punning true \
		--select "annotations self parents" \
		$(ANNOTATE_CONVERT_FILE)

$(IMPORTDIR)/qudt_import.owl: $(MIRRORDIR)/qudt.owl $(IMPORTDIR)/qudt_terms.txt
	$(ROBOT) filter --input $(MIRRORDIR)/qudt.owl \
		--term-file $(IMPORTDIR)/qudt_terms.txt \
		--allow-punning true \
		--select "annotations self" \
		$(ANNOTATE_CONVERT_FILE)


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
	--annotation http://purl.org/dc/terms/bibliographicCitation "$(CITATION)" \
	--link-annotation owl:priorVersion https://w3id.org/pmd/cryo/$(PRIOR_VERSION)

update-ontology-annotations:
	@echo "Publishing CryO assets to root directory..."
	$(ROBOT) annotate --input cryo.owl $(ALL_ANNOTATIONS) --output ../../cryo.owl
	$(ROBOT) annotate --input cryo.ttl $(ALL_ANNOTATIONS) --output ../../cryo.ttl
	$(ROBOT) annotate --input cryo-full.owl $(ALL_ANNOTATIONS) --output ../../cryo-full.owl
	$(ROBOT) annotate --input cryo-full.ttl $(ALL_ANNOTATIONS) --output ../../cryo-full.ttl
	$(ROBOT) annotate --input cryo-base.owl $(ALL_ANNOTATIONS) --output ../../cryo-base.owl
	$(ROBOT) annotate --input cryo-base.ttl $(ALL_ANNOTATIONS) --output ../../cryo-base.ttl

all_assets: update-ontology-annotations
