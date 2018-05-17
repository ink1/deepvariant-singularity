# Deepvariant in Singularity container

This is essentially just a script to build a singularity container which contains Deepvariant (https://github.com/google/deepvariant). Unfortunately Deepvariant does not accept pull requests yet so until then just checkout this repo and run 
```
./build-singularity-image.sh
```
This may take some time but in the end you should get a singularity image in ~/output/

## Dependencies
 - Linux
 - gsutil
 - docker
 - singularity

Tested on CentOS 7, gsutil 4.28, docker 1.12.6, singularity 2.4.2
