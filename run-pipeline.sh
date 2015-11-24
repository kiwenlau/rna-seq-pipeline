#!/bin/bash

# run RNA-Seq pipeline by using kiwenlau/tophat-cufflinks:latest image
current_path=`pwd`
#current_path=${current_path%$'\n'} 
#echo $current_path 

mkdir output

#echo "Step 1. Builds the genome index required by the mapping process"
mkdir output/index
#docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks ls data
docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks bowtie2-build data/ggal_1_48850000_49020000.Ggal71.500bpflank.fa output/index/genome_index
#docker run -v /root/mac/rna-seq-pipeline/data:/tmp/data -v /root/mac/rna-seq-pipeline/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks bowtie2-build data/ggal_1_48850000_49020000.Ggal71.500bpflank.fa output/index/genome_index

#echo "Step 2. Maps each read-pair by using Tophat2 mapper tool"
#tophat2 -o output/tophat_out_gut output/index/genome_index data/ggal_gut_1.fq data/ggal_gut_2.fq
#tophat2 -o output/tophat_out_liver output/index/genome_index data/ggal_liver_1.fq data/ggal_liver_2.fq
#
#echo "Step 3. Assembles the transcript by using the cufflinks"
#cufflinks -o output/cufflinks_out_gut output/tophat_out_gut/accepted_hits.bam
#cufflinks -o output/cufflinks_out_liver output/tophat_out_liver/accepted_hits.bam
#
#echo "Step 4"
#echo "output/cufflinks_out_gut/transcripts.gtf" > output/assemblies.txt
#echo "output/cufflinks_out_liver/transcripts.gtf" >> output/assemblies.txt
#cuffmerge -o output/merged_asm output/assemblies.txt
#
#echo "Step 5"
#cuffdiff -o output/cuffdiff_out output/merged_asm/merged.gtf output/tophat_out_gut/accepted_hits.bam output/tophat_out_liver/accepted_hits.bam