for chr in 1 2 3

do

	#### Get plink format map and ped from the raw GBS data and keep only the Ugandan boys
	vcftools --gzvcf ../chr${chr}_f.vcf.gz --plink --out c${chr}_gbs

	#### Modify the *ped files
	ped.py c${chr}_gbs.ped  > tmp
	more tmp | cut -f -6  > ped.part1
	more tmp | cut -f 7- | sed "s/0/N/g" > ped.part2
	paste ped.part1 ped.part2 > c${chr}_gbs.ped
	rm ped*
	rm tmp

	#### Add the allele columns in the *map files
	zcat ../chr${chr}_f.vcf.gz | cut -c1-35 | awk -F"\t" '{print$4"\t"$5}' | tail -n +12  > alleles
	paste c${chr}_gbs.map alleles > tmp
	mv tmp c${chr}_gbs.map

	#### Use gtool to transform into oxford format
	gtool -P --ped c${chr}_gbs.ped --map c${chr}_gbs.map --snptest1 --og chr${chr}.gen

done

