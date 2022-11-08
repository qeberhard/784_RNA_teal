cat /nas/longleaf/home/kwamek/BCB784_proj/784_RNA_teal/developing_se/K562_se/SEEDS.txt | while read prefix ; do


        infile1="/nas/longleaf/home/kwamek/BCB784_proj/784_RNA_teal/developing_se/K562_se/${prefix}"


        name=${prefix}

        sbatch -J  ${name} -o ${name}.out -e  ${name}.err runPlots.sh ${infile1}

done
