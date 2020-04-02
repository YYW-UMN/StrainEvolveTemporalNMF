# StrainEvolve_TemporalNMF

## Objective:
Explore how strains of paraTB evolved over 6 years from samples of 4 different US states 

## Method: Temporal Non-negative Matrix Factorization (NMF)
### What is NMF?

NMF is a dimension reduction technique: a large matrix X can be represented with two smaller matrices U and V. 

<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/NMF.png" width="500" />
</p>

Here on the left, X is the SNP data observed, where columns are individuals and rows are SNPs. Values of 0, 0.5, and 1 represent ref allele, heterogeneous alternate allele, and homogeneous alternate allele, respectively. 

On the right side, U represents a panel of strains which were the ancestors of all individuals in the sampled population. Each column shows a distintive SNP pattern for each ancestor strain. 

V shows the composition coeffiencts of each ancestor strain for each sample, such as proportions of ancestor A, B, C etc among sample m. 

### What is temporal NMF?
To explore how strains evolve over time, NMF is performed at each time point. Minor changes are allowed for U, the ancestor panel, based on the assumption that the majority of SNPs in ancestor strains will not change over time. 

<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/TemporalNMF.png" width="500" />
</p>

### How to visualize changes among ancestor strains and samples?
Results from the temporal NMF are then converted to XY coordinates using tsne so that they can be visualized on a 2D space.
1. Evolving Strains (compressed view)
<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/templateStrainsCompressed.png" width="500" />
</p>

2. Strains within samples (compressed view)
<p float="left"> 
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/Mixtures_compressed.png" width="500" />
</p>


Original views
<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/templateStrains.png" width="700" />
</p>


<p float="left">
<img src="https://github.com/YYW-UMN/StrainEvolve_TemporalNMF/blob/master/Mixtures.png" width="700" />
</p>



