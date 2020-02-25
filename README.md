# StrainEvolve_TemporalNMF

## Objective:
Explore how strains of paraTB evolved over 6 years from samples of 4 different US states 

## Method: Temporal Non-negative Matrix Factorization (NMF)
### What is NMF?

NMF is a dimension reduction technique: a large matrix X can be represented with two smaller matrices U and V. 

<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/TemporalNMF.png" width="500" />
</p>

Here on the left, X is the SNP data observed, where columns are individuals and rows are SNPs. Values of 0, 0.5, and 1 represent ref allele, heterogeneous alternate allele, and homogeneous alternate allele, respectively. 

On the right side, U represents a panel of strains which were the ancestors of all individuals in the sampled population. Each column shows a distintive SNP pattern for each ancestor strain. 

V is the composition coeffiencts of ancestor strains for each sample. Specifically, for each sample (column), V gives the proportions of ancestor A, B, C etc. 
