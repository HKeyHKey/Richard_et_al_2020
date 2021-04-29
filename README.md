Scripts and intermediary data for analyses published in [Richard et al. (Autophagy, 2020)](https://pubmed.ncbi.nlm.nih.gov/32686621/).

1. For Figure 1A: volcano plot tracing (after decompressing the 'Results_exonCore.csv.bz2' data file):

``R CMD BATCH R_commands_Patricia_s_data_analysis_November2019``


2. Lists of genes with higher and lower DRIP signal in DRIP-seq are named 'Annotated_Higher_in_KD.tsv' and 'Annotated_Lower_in_KD.tsv' respectively. Microarray and RNA-Seq results are in 'Comparison_array_seq.dat'.

3. Gene name synchronization:

``cat Annotated_Higher_in_KD.tsv Annotated_Lower_in_KD.tsv | sed -e 's|\t.*||' -e 's| |\
|g' | grep -vw NA | sort | uniq > list_DRIP_gene_names;grep -v '^#' Comparison_array_seq.dat | awk -F '\t' '{print $1}' | sed 's|/|\
|' | sort | uniq > list_Patricia_gene_names;cat list_Patricia_gene_names list_DRIP_gene_names list_DRIP_gene_names | sort | uniq -c | grep '^ *[12] '| awk '{print $2}' > list_for_synchronization;./Module_synchronizes_gene_names_Patricia.pl list_for_synchronization > synchronization;./Module_Patricize_DRIP_gene_names.pl``

Resulting files: 'Patricized_DRIP_Higher_in_KD.tsv' and 'Patricized_DRIP_Lower_in_KD.tsv' (where gene names have been updated, as much as possible, in order to match gene names in 'Microarray_results.tsv').

4. Statistical analysis and boxplot tracing:

``R CMD BATCH R_commands_Patricia_transcriptomics_vs_DRIP``
