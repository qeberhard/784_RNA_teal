#File accession 0
#File format 1
#File type 2
#File format type 3       
#Output type 4    
#File assembly 5   
#Experiment accession 6
#Assay 7
#Donor(s) 8       
#Biosample term id  9
#Biosample term name 10
#Biosample type 11  
#Biosample organism 12
#Biosample treatments 13
#Biosample treatments amount 14
#Biosample treatments duration 15
#Biosample genetic modifications methods 16
#Biosample genetic modifications categories 17
#Biosample genetic modifications targets 18
#Biosample genetic modifications gene targets 19 
#Biosample genetic modifications site coordinates 20
#Biosample genetic modifications zygosity 21        
#Experiment target 22      
#Library made from 23      
#Library depleted in 24    
#Library extraction method 25      
#Library lysis method 26   
#Library crosslinking method 27
#Library strand specific 28
#Experiment date released 29
#Project RBNS protein concentration 30
#Library fragmentation method 31
#Library size range 32
#Biological replicate(s) 33
#Technical replicate(s) 34
#Read length 35
#Mapped read length 36    
#Run type 37
#Paired end  38
#Paired with 39    
#Index of 40    
#Derived from 41
#Size 42
#Lab 43   
#md5sum 44
#dbxrefs 45
#File download URL 46
#Genome annotation 47
#Platform 48
#Controlled by 49
#File Status 50
#s3_uri 51
#Azure URL 52
#File analysis title 53
#File analysis status 54
#Audit WARNING  55
#Audit NOT_COMPLIANT 56
#Audit ERROR 57

experiment_names = {}

with open("../downloaded_files/K562_metadata.tsv", "r") as metadata_file:
    with open("bam_only_file.tsv", "w") as bam_only_file:
        for line in metadata_file:
            cols = line.split("\t")
            if cols[2] == "bam" and cols[5] == "GRCh38":
                bam_only_file.write(line)
                if cols[6] not in experiment_names.keys():
                    experiment_names[cols[6]] = [cols[0]]
                else:
                    bam_list = experiment_names[cols[6]]
                    bam_list.append(cols[0])
                    experiment_names[cols[6]] = bam_list
            elif cols[2] == "File type":
                bam_only_file.write(line)
#print(len(experiment_names))

with open("bam_only_file.tsv", "r") as bam_infile:
    with open("column_data_K562_inbetween.tsv", "w") as colout_file:
        for i,line in enumerate(bam_infile):
            cols = line.split("\t")
            if i == 0:
                cols[46] = "Bam files"
                new_line = "\t".join(cols[6:47])
                colout_file.write(new_line)
            if cols[6] in experiment_names.keys():
                cols[46] = ",".join(experiment_names[cols[6]])
                new_line = "\t".join(cols[6:47])
                colout_file.write("\n%s" % new_line.strip())
                del experiment_names[cols[6]]

with open("../featurecounts/main_featcount_file.tsv", "r") as ordered:
    header_line = ordered.readline()
    headers = header_line.split("\t")
    counter = 0
with open("column_data_K562_inbetween.tsv", "r") as unordered_file:
    unordered_lines = unordered_file.readlines()
    print(len(unordered_lines))
    with open("column_data_K562.tsv", "w") as outfile:
        outfile.write(unordered_lines[0].strip("\n"))
        for header in headers:
            #print(header)
            counter += 1
            
            for line in unordered_lines:
                cols = line.split("\t")
                #print(cols[0])
                if header.strip() == cols[0].strip():
                    #print("success")
                    line = line.strip()
                    outfile.write("\n%s" % line)
print(counter)
