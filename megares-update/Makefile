default: input/card/nucleotide_fasta_protein_homolog_model.fasta input/resfinder/genomicepidemiology-resfinder_db-d1e607b89892/all.fsa input/ncbi/ncbi_dataset/data/nucleotide.fna input/megares/megares_v3.00/megares_database_v3.00.fasta
.PHONY: default

input/card/nucleotide_fasta_protein_homolog_model.fasta: input/broadstreet-v4.0.0.tar.bz2
	mkdir -p input/card
	tar -xf input/broadstreet-v4.0.0.tar.bz2 -C input/card
	touch -c input/card/nucleotide_fasta_protein_homolog_model.fasta

input/broadstreet-v4.0.0.tar.bz2:
	curl -O --output-dir input https://card.mcmaster.ca/download/0/broadstreet-v4.0.0.tar.bz2

input/resfinder/genomicepidemiology-resfinder_db-d1e607b89892/all.fsa: input/resfinder-4.6.0.tar.bz2
	mkdir -p input/resfinder
	tar -xf input/resfinder-4.6.0.tar.bz2 -C input/resfinder
	touch -c input/resfinder/genomicepidemiology-resfinder_db-d1e607b89892/all.fsa

input/resfinder-4.6.0.tar.bz2:
	curl -O --output-dir input https://bitbucket.org/genomicepidemiology/resfinder_db/get/resfinder-4.6.0.tar.bz2

input/ncbi/ncbi_dataset/data/nucleotide.fna:
	unzip input/refgene_catalog.zip -d input/ncbi
	touch -c input/ncbi/ncbi_dataset/data/nucleotide.fna

input/megares/megares_v3.00/megares_database_v3.00.fasta: input/megares_v3.00.zip
	unzip input/megares_v3.00.zip -d input/megares
	touch -c input/megares/megares_v3.00/megares_database_v3.00.fasta

input/megares_v3.00.zip:
	curl -O --output-dir input https://www.meglab.org/downloads/megares_v3.00.zip
