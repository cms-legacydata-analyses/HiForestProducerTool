# HiForestProducerTool
Tool to produce HiForest root file from the 2010 Heavy Ion Open Data.

This repository hosts a set of simple examples that use CMSSW EDAnalyzers to extract trigger information and produce HiForest root file from CMS public heavy-ion data. Currently, this repository has two main branches, [2010](https://github.com/cms-legacydata-analyses/HiForestProducerTool/tree/2010) and [2011](https://github.com/cms-legacydata-analyses/HiForestProducerTool/tree/2011) corresponding to the CMS heavy-ion data that has been so far released.  Please choose the one you need as instructions may vary a little, and follow the instructions therein.

## Usage instructions

### Prepare and compile

First, you have to either
- create a [VM](http://opendata.cern.ch/docs/cms-virtual-machine-2010 "CMS 2010 Virtual Machines: How to install") from the CMS Open Data website and create the CMSSW environment, and intialize it with 

  ```
  cmsrel CMSSW_3_9_2_patch2
  cd CMSSW_3_9_2_patch2/src/
  cmsenv
  ```
- or set up a [Docker container](http://opendata.cern.ch/docs/cms-guide-docker) with

  ```
  docker run --name opendata -it  gitlab-registry.cern.ch/cms-cloud/cmssw-docker/cmssw_3_9_2_patch5-slc5_amd64_gcc434:2020-11-17-e0b0b7a6 /bin/bash
  ```

Then follow these steps:

- Obtain the code from git and move it to the `src` area:

  ```
  git clone -b 2010 git://github.com/cms-legacy-analyses/HiForestProducerTool.git HiForestProducer
  cd HiForestProducer
  ```

- Compile everything:

  ```
  scram b
  ```
  
### Run the producer

- In the VM, make symbolic links to the conditions database

  ```
  ln -sf /cvmfs/cms-opendata-conddb.cern.ch/GR_R_39X_V6B GR_R_39X_V6B
  ln -sf /cvmfs/cms-opendata-conddb.cern.ch/GR_R_39X_V6B.db GR_R_39X_V6B.db
  ```

You should now see the `cms-opendata-conddb.cern.ch` link in the `/cvmfs` area.

- In the docker container, comment the line starting with  `process.GlobalTag.connect` in the configuration file `hiforestanalyzer_cfg.py`

- Set the number of events in the configuration file. The default -1 runs over all events.

- Run the CMSSW executable in the background and dump the output in a log file with any name (full.log in this case)

  ```
  cmsRun hiforestanalyzer_cfg.py > full.log 2>&1 &
  ```

This file reads the input root files from the full list of files CMS_HIRun2010_HIAllPhysics_ZS-v2_RECO_file_index.txt

This will produce the HiForestAOD_DATAtest.root file as an output.

One can modify [src/Analyzer.cc](src/Analyzer.cc) file in order to include other object (tracks, electrons, etc) in the hiforest output. the instructions a given inside it.


### Run the analysis

[forest2dimuon.C](forest2dimuon.C) is a script to analyze the output root file. It applies a trigger filter, does some basic analysis selections and produces a histogram with the dimuon invariant mass.

Run this analysis script with
```
root -l forest2dimuon.C
```
## Continuous Integration

This repository contains also [a github workflow](.github/workflows/main.yml), which runs a test job on the CMS open data container using github free resources. It uses a docker container and runs a HiForest root file producer workflow defined in [commands.sh](commands.sh) and makes an example plot with [plot.sh](plot.sh). The ouput is returned as a github artifcat. The workflow is triggered by a pull request. 




