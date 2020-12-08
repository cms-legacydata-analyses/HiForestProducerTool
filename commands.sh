#!/bin/sh -l
# parameters: $1 number of events (default: 100), $2 configuration file (default: hiforestanalyzer_cfg.py)
# echo pwd `pwd`: /home/cmsusr/CMSSW_5_3_32/src
# echo $USER cmsusr
sudo chown $USER /mnt/vol

mkdir HiForest
cd HiForest
# For the plain github action with docker, the area would be available in /mnt/vol
# git clone -b HIDiMuon2011 git://github.com/katilp/HiForestProducerTool.git HiForestProducer
cp -av /mnt/vol HiForestProducer
cd HiForestProducer

scram b -j8

if [ -z "$1" ]; then nev=100; else nev=$1; fi
if [ -z "$2" ]; then config=hiforestanalyzer_cfg.py; else config=$2; fi
eventline=$(grep maxEvents $config)
sed -i "s/$eventline/process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32($nev) )/g" $config
sed -i "s/process.GlobalTag.connect/#process.GlobalTag.connect/g" $config
cmsRun $config

root -l -b forest2dimuon.C

cp *.root /mnt/vol/
cp *.png /mnt/vol/
echo  ls -l /mnt/vol
ls -l /mnt/vol