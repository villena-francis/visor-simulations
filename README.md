# Purpose
This repository is used for exploratory analyses with [VISOR](https://github.com/davidebolo1993/VISOR) application, focusing on simulating long reads with structural variations (SVs) characteristic of multiple myeloma (MM).

# Initial test
The `trial_test.sh` was created to better understand how the HACk and LASeR modules of VISOR work.

Each stage of MM is represented by a specific folder in `data`. These folders contain .bed files that provide the necessary [instructions to insert the SVs](https://davidebolo1993.github.io/visordoc/usage/usage.html#visor-hack) into the reference genome. For this trial the only stage aviable is `data/test`.

```shell
#create the environment
mamba env create -f envs/visor_test.yaml
#activate the environment
mamba activate visor_test
#execute the pipeline for stage "test"
bash scripts/trial_test.sh test
```