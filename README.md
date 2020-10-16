# TASTE

TASTE combines the PARAFAC2 model with non-negative matrix factorization to model a temporal and a static tensor. It performs two import tasks in healthcare: 1- computational phenotyping 2- Predictive modeling by analyzing electronic health records (EHRs).

[Yanxin Ye](https://github.com/Yanxin-Ye) processed the CMS data using Hive.

[Xinze Wang]() did case-control mapping using Pymatch.

[Xingchi Li](https://lixingchi.com) translated MATLAB code of TASTE and [Nonnegative matrix factorization (NMF) algorithms based on alternating non-negativity constrained least squares](https://www.cc.gatech.edu/~hpark/nmfsoftware.php) to Python then did compatibility modification.

[Hung-Yi Li]() did the cross validation and numerous experiments to do better comparison.

Previous TASTE code can be found in [legacy](legacy/) which is implemented in MATLAB by [Ardavan (Ari) Afshar](aafshar8@gatech.edu).

<img src="Images/TASTE_Framework.png" width=800 alt="centered image">

TASTE applied on dynamically-evolving structured EHR data and static patient information. Each <img src="https://latex.codecogs.com/svg.latex?\Large&space;X_k" /> represents the medical features recorded for different clinical visits for patient <img src="https://latex.codecogs.com/svg.latex?\Large&space;k" />.  Matrix <img src="https://latex.codecogs.com/svg.latex?\Large&space;A" /> includes the static information (e.g., race, gender) of patients. TASTE decomposes <img src="https://latex.codecogs.com/svg.latex?\Large&space;\{X_k\}" /> into three parts: <img src="https://latex.codecogs.com/svg.latex?\Large&space;\{U_k\}" />, <img src="https://latex.codecogs.com/svg.latex?\Large&space;\{S_k\}" />, and <img src="https://latex.codecogs.com/svg.latex?\Large&space;V" />. Static matrix <img src="https://latex.codecogs.com/svg.latex?\Large&space;A" /> is decomposed into two parts: <img src="https://latex.codecogs.com/svg.latex?\Large&space;\{S_k\}" /> and <img src="https://latex.codecogs.com/svg.latex?\Large&space;F" />. Note that <img src="https://latex.codecogs.com/svg.latex?\Large&space;\{S_k\}" /> (personalized phenotype scores) is shared between static and dynamically-evolving features. 

## Relevant Publication
TASTE implements the code in the following paper:

```
Afshar, Ardavan, Ioakeim Perros, Haesun Park, Christopher deFilippi, Xiaowei Yan, Walter Stewart,
Joyce Ho, and Jimeng Sun. "TASTE: Temporal and Static Tensor Factorization for Phenotyping Electronic
Health Records." ACM CHIL 2020.
```

### Code description

[Nonnegative matrix factorization (NMF) algorithms based on alternating non-negativity constrained least squares](https://www.cc.gatech.edu/~hpark/nmfsoftware.php) has been imported and translated in [nonnegfac.py](nonnegfac.py).

<!-- Before running the codes you need to import the following packages:
* Tensor Toolbox Version 2.6 which can be downloaded from: https://www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html -->

There are two main functions defined in `main.py`: `fit(R, A, X)` and `project(R, A, X, V, F, H)`:
* `R` denotes the number of phenotypes
* `A` denotes the static feature matrix
* `X` denotes the temporal feature matrix
* `V`, `F`, `H` are the matrices obtained from the `fit` function.

### In Memory of Ardavan (Ari) Afshar

Ari is a good mentor in directing us with this project. It is really sad to see a good person not around any more. RIP Ari, you will be missed. [Kudoboard](https://www.kudoboard.com/boards/7Rxs5p8Q)
