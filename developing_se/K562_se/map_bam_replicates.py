mapping = {}

with open("metadata.tsv", "r") as metadata:
    for line in metadata:
        if line[0] == "E":
            components = line.split("\t")
            file_name = components[0]
            file_name = str("downloaded_files/%s.bam" % file_name)
            experiment = components[6]
            experiment = str("merged_bamfile/%s.bam" % experiment)
            file_list = [file_name]
            if components[1] == "bam":
                for key, value in mapping.items():
                    if key == experiment:
                        current_val = mapping[experiment][0]
                        file_list = [current_val, file_name]
                 mapping[experiment] = file_list

with open("bam_file_mappings.tsv", "w") as outfile:
    for exp, files in mapping.items():
        outfile.write("%s\t%s\t%s\n" % (exp, files[0], files[1]))
                                                                                                                                                                                                                                                ~

