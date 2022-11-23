PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf .created-dirs

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs

#Hi team:
#The general format for these is as follows (note the spacing):

#First line is first thing developed by script. Probably a figure!\
# second line is another item developed by script.\
# Once you have listed all tangibles developed by script, end like this:\
#  Now we list what is required to run the script\
#  These are all file paths\
#  You will want to include .created-dirs in order to store outputs in derived_data and figures\
# 	Run your code using "Rscript <name>.Rmd"

#Here I develop the Summarized Experiments. Please note that you MUST change the paths as written
#In the actual .Rmd files. You can look at the loading_se_object.Rmd files for an example, but
# essentially the files being read in to the script need to have the paths described as if the script
# was running from the position of the Makefile. In this case, that is the home 784_RNA_teal directory.

#Another note is that the goal of make is to be able to generate an entire report without having to
# manually run someones code. Mike should be able to just run `make report.pdf` and this file will
# instruct make to run our programs in the correct order. This process can be reversed using
# `make clean`. The instructions for `clean` are above, and basically mean that anything in the
# directories `figures` and `derived_data` will be removed, as well as the directories. The directories
# are automatically remade with the next `make report.pdf` command.
# Slack me with any questions!

#Develop the K562 SEs
derived_data/se_K562.rda\
 derived_data/se_K562.rda:\
  developing_se/K562_se/main_featcount_K562.tsv\
  developing_se/K562_se/column_data_K562.tsv\
  developing_se/rowdata.tsv\
  .created-dirs
		Rscript developing_se/K562_se/loading_K562_se_object.Rmd

#Develop the HEPG2 SEs
derived_data/se_HEPG2.rda\
 derived_data/se2_HEPG2.rda:\
  developing_se/HEPG2_se/HEPG2_count_file.tsv\
  developing_se/HEPG2_se/column_data_HEPG2.tsv\
  developing_se/rowdata.tsv\
  .created-dirs
  	Rscript developing_se/HEPG2_se/loading_HEPG2_se_object.Rmd



#Once we are ready to develop the report, uncomment this section. Replace the ???.png with 
#any figures that we actually want to include in the report to load them into the Rmd.

#report.pdf: figures/???.png figures/???.png
#	R -e "rmarkdown::render(\"report.Rmd\", output_format=\"pdf_document\")"