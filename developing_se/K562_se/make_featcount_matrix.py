import os


dir_name = "./featcounts/"
outfile_dict = {}
column_list = []
first_time = True

with open("main_featcount_file.tsv", "w") as outfile:
    for files in os.listdir(dir_name):
        if files.endswith(".out"):
            if first_time == True:
                with open("./featcounts/" +files, "r") as infile:
                    experiment_name = files.strip(".out")
                    column_list.append(experiment_name.strip(".out"))
                
                    for line in infile:
                        if line[0] != "#" and line[0] != "G":
                            cols = line.split("\t")
                            gene_id = cols[0]
                            count = cols[6]
                            outfile_dict[gene_id] = [count]
                first_time = False

            else:
                with open("./featcounts/" +files, "r") as infile:
                    experiment_name = files.strip(".out")
                    column_list.append(experiment_name)

                    for line in infile:
                        if line[0] != "#" and line[0] != "G":
                            cols = line.split("\t")
                            gene_id = cols[0]
                            count = cols[6]
                            count_list = outfile_dict[gene_id]
                            count_list.append(count)
                            outfile_dict[gene_id] = count_list
    
    outfile.write("Gene.id")
    for exp in column_list:
        outfile.write("\t%s" % exp.strip())

    for key, value in outfile_dict.items():
        outfile.write("\n%s" % key.strip())
        for val in value:
            outfile.write("\t%s" % val.strip())

