def get_vcf(wildcards):
	return samples.loc[(wildcards.samples), "VCF"].dropna()
