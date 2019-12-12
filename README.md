# CATNIP

CATNIP = **C**reating **A** **T**ranslational **N**etwork for **I**ndication **P**rediction

Last Updated: 12/12/2019

Correspondence to: Coryandar Gilvary, cmg287 [at] cornell [dot] edu


**Requirements**

R - tested on version 3.5.3

R dependecies: visNetwork (2.0.8)

To Install R Dependencies:
```
install.packages("visNetwork")
```

# Quick Start
**CATNIP Repurposing Network**

The CATNIP repurposing network can be searched either by specifying one or more drugs or diseases. The probability of CATNIP prediction that two drugs will share an indication is 0.95 by default, but can be changed by the user.  

Search by drug(s) of interest:

```
source("/path/to/CATNIP/R/CATNIP.R")
getDrugBasedResult(vectorOfDrugs)
```

Search by disease(s) of interest:

```
source("/path/to/CATNIP/R/CATNIP.R")
getDiseaseBasedResult(vectorOfDiseases)
```
**Visualize**

Visualize CATNIP network results (valid for either query method):
```
source("/path/to/CATNIP/R/CATNIP.R")
getDrugBasedResult(vectorOfDrugs, fileName = "/path/to/figure/output)
```

Color drugs based on ATC codes:
```
source("/path/to/CATNIP/R/CATNIP.R")
getDrugBasedResult(vectorOfDrugs, fileName = "/path/to/figure/output, colorByATC = T)
```

# Citation
Please cite our paper: 

Gilvary, C., Elkhader, J., Madhukar, N., Henchcliffe, C., Goncalves, M.D. and Elemento, O., 2019. A machine learning and network framework to discover new indications for small molecules. bioRxiv, p.748244.
