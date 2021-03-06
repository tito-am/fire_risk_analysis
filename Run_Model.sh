#!/bin/bash
# Script name : Run_Model.sh
# Description : To run the various python scripts which generate the fire scores for commercial buildings
# Author : Geoffrey Arnold
# Date : 12/29/2017
export DISPLAY=:0.0
python ./FirePred/getdata.py && python ./FirePred/riskmodel.py && python ./FirePred/merger.py