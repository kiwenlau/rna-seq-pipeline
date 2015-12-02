#!/bin/bash

# run RNA-Seq pipeline by using kiwenlau/tophat-cufflinks:latest image
# http://www.nextflow.io/example4.html

current_path=`pwd`

rm -rf output > /dev/null
mkdir output

echo -e "\nStep 1. Builds the genome index required by the mapping process\n"
mkdir output/index
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks bowtie2-build data/ggal_1_48850000_49020000.Ggal71.500bpflank.fa output/index/genome_index

echo -e "\n\n\n\nStep 2. Maps each read-pair by using Tophat2 mapper tool\n"
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks tophat2 -o output/tophat_out_gut output/index/genome_index data/ggal_gut_1.fq data/ggal_gut_2.fq
echo -e "\n\n"
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks tophat2 -o output/tophat_out_liver output/index/genome_index data/ggal_liver_1.fq data/ggal_liver_2.fq

echo -e "\n\n\n\nStep 3. Assembles the transcript by using the cufflinks\n"
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks cufflinks -o output/cufflinks_out_gut output/tophat_out_gut/accepted_hits.bam
echo -e "\n\n"
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks cufflinks -o output/cufflinks_out_liver output/tophat_out_liver/accepted_hits.bam

echo -e "\n\n\n\nStep 4. Run cuffmerge command\n"
echo "output/cufflinks_out_gut/transcripts.gtf" > output/assemblies.txt
echo "output/cufflinks_out_liver/transcripts.gtf" >> output/assemblies.txt
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks cuffmerge -o output/merged_asm output/assemblies.txt

echo -e "\n\n\nStep 5. Run cuffdiff command\n"
sudo docker run -v $current_path/data:/tmp/data -v $current_path/output:/tmp/output -w /tmp kiwenlau/tophat-cufflinks cuffdiff -o output/cuffdiff_out output/merged_asm/merged.gtf output/tophat_out_gut/accepted_hits.bam output/tophat_out_liver/accepted_hits.bam
