default: matches.tsv
.PHONY: default

MEGARES_VERSION = v3.00
CARD_VERSION = v4.0.0
RESFINDER_VERSION = 4.7.1
RESFINDER_SHA = 85e788724dd8
POINTFINDER_VERSION = 4.7.1
POINTFINDER_SHA = 694919f59a38
NCBI_VERSION = 4.0/2025-03-25.1

BACMET_VERSION = 2.0

ALL_FASTA = input/megares/megares_$(MEGARES_VERSION)/megares_database_$(MEGARES_VERSION).fasta \
 input/card/nucleotide_fasta_protein_homolog_model.fasta \
 input/card/nucleotide_fasta_protein_overexpression_model.fasta \
 input/card/nucleotide_fasta_protein_variant_model.fasta \
 input/card/nucleotide_fasta_rRNA_gene_variant_model.fasta \
 input/resfinder/genomicepidemiology-resfinder_db-$(RESFINDER_SHA)/all.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/enterococcus_faecalis/enterococcus_faecalis.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/enterococcus_faecium/enterococcus_faecium.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/escherichia_coli/escherichia_coli.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/helicobacter_pylori/helicobacter_pylori.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/campylobacter/campylobacter.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/klebsiella/klebsiella.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/mycobacterium_tuberculosis/mycobacterium_tuberculosis.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/neisseria_gonorrhoeae/neisseria_gonorrhoeae.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/plasmodium_falciparum/plasmodium_falciparum.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/salmonella/salmonella.fsa \
 input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/staphylococcus_aureus/staphylococcus_aureus.fsa \
 input/ncbi/AMR_CDS.fa

input/card/%.fasta: input/card/.sentinel
	sed -i -e '$$a\\' $@

input/card/.sentinel: input/broadstreet-$(CARD_VERSION).tar.bz2
	mkdir -p input/card
	tar -xf $< -C input/card
	touch $@

input/broadstreet-$(CARD_VERSION).tar.bz2:
	curl -O --output-dir input https://card.mcmaster.ca/download/0/broadstreet-$(CARD_VERSION).tar.bz2

input/resfinder/genomicepidemiology-resfinder_db-$(RESFINDER_SHA)/%.fsa: input/resfinder/.sentinel
	sed -i -e '$$a\\' $@

input/resfinder/.sentinel: input/resfinder-$(RESFINDER_VERSION).tar.bz2
	mkdir -p input/resfinder
	tar -xf $< -C input/resfinder
	touch $@

input/resfinder-$(RESFINDER_VERSION).tar.bz2:
	curl -O --output-dir input https://bitbucket.org/genomicepidemiology/resfinder_db/get/resfinder-$(RESFINDER_VERSION).tar.bz2

input/pointfinder/genomicepidemiology-pointfinder_db-$(POINTFINDER_SHA)/%.fsa: input/pointfinder/.sentinel
	sed -i -e '$$a\\' $@

input/pointfinder/.sentinel: input/pointfinder-$(POINTFINDER_VERSION).tar.bz2
	mkdir -p input/pointfinder
	tar -xf $< -C input/pointfinder
	touch $@

input/pointfinder-$(POINTFINDER_VERSION).tar.bz2:
	curl -o pointfinder-$(POINTFINDER_VERSION).tar.bz2 --output-dir input https://bitbucket.org/genomicepidemiology/pointfinder_db/get/resfinder-$(POINTFINDER_VERSION).tar.bz2

input/ncbi/AMR_CDS.fa:
	mkdir -p input/ncbi
	curl -O --output-dir input/ncbi ftp://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/$(NCBI_VERSION)/AMR_CDS.fa
	sed -i -e '$$a\\' $@

input/bacmet/BacMet2_EXP_database.fasta:
	mkdir -p input/bacmet
	curl -O --output-dir input/bacmet http://bacmet.biomedicine.gu.se/download/BacMet2_EXP_database.fasta

input/megares/megares_$(MEGARES_VERSION)/megares_database_$(MEGARES_VERSION).fasta: input/megares_$(MEGARES_VERSION).zip
	unzip $< -d input/megares
	sed -i -e '$$a\\' $@

input/megares_$(MEGARES_VERSION).zip:
	curl -O --output-dir input https://www.meglab.org/downloads/megares_$(MEGARES_VERSION).zip

cdhit/Makefile:
	git clone https://github.com/weizhongli/cdhit
	cd cdhit && git checkout 4f6720f573d3d9d4c835793a05f09e098003bfe9

cdhit/cd-hit-est: cdhit/Makefile
	guix shell --container --development --file=cdhit.scm -- $(MAKE) -C cdhit

input/all.fsa: $(ALL_FASTA)
	cat $^ > $@

%.fsa %.fsa.clstr: input/%.fsa cdhit/cd-hit-est
	cdhit/cd-hit-est -i $< -o $@ -G 0 -c 1.0 -AS 0 -AL 0 -aL 1.0 -aS 1.0 -d 200

# TODO docs suggest that the first output is simply new sequences, allowing this to be the first or only step (no 100% clustering?)
update.fsa update.fsa.clstr: input/megares/megares_$(MEGARES_VERSION)/megares_database_$(MEGARES_VERSION).fasta input/all.fsa
	cdhit/cd-hit-est-2d -i input/megares/megares_v3.00/megares_database_v3.00.fasta -i2 input/all.fsa  -o megares-update.fsa -c 0.8 -d 200

matches.tsv: all.fsa update.fsa.clstr
	python dump_matches.py
