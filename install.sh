#!/bin/bash
# Stop on error
set -e

CUR_DIR=$(pwd)

conda create -n fast_iclip --file requirements.txt -y -c defaults -c conda-forge -c bioconda

############ install additional packages

source activate fast_iclip

CONDA_BIN=$(dirname $(which activate))
CONDA_EXTRA="$CONDA_BIN/../extra"
mkdir -p $CONDA_EXTRA

#### install iCLIPro

cd $CONDA_EXTRA
wget http://www.biolab.si/iCLIPro/dist/iCLIPro-0.1.1.tar.gz -N
tar -xvzf iCLIPro-0.1.1.tar.gz
rm -f iCLIPro-0.1.1.tar.gz
cd iCLIPro-0.1.1
python setup.py install --record files.txt

cd $CUR_DIR

# 2. Downloading genome files
# "docs_lite.tar.gz" is not publicly available
echo "Downloading and unzipping hg19 and mm9 genome files"
wget https://s3.amazonaws.com/changlabguest/FAST-iCLIP/docs_new.tar.gz
mkdir docs
tar xvzf docs_new.tar.gz -C docs && rm -f docs_new.tar.gz

# 3. Downloading example files
wget https://s3.amazonaws.com/changlabguest/FAST-iCLIP/rawdata.tar.gz
mkdir rawdata
tar xvzf rawdata.tar.gz -C rawdata && rm -f rawdata.tar.gz
mkdir results

echo === Installing dependencies successfully done. ===

# 4. install FAST-iCLIP
python setup.py install --record files.txt

# 5. save environment variables
#cd $CONDA_PREFIX
#mkdir -p ./etc/conda/activate.d
#cat > ./etc/conda/activate.d/env_vars.sh <<EOF
##!/bin/sh
#
#export FASTICLIP_PATH=~/.local/bin/
#export PATH=$FASTICLIP_PATH:$PATH
#EOF
#chmod +x ./etc/conda/activate.d/env_vars.sh
#mkdir -p ./etc/conda/deactivate.d
#cat > ./etc/conda/deactivate.d/env_vars.sh <<EOF
##!/bin/sh
#
#unset FASTICLIP_PATH
#unset PATH
#EOF
#chmod +x ./etc/conda/deactivate.d/env_vars.sh
cd $CUR_DIR

source deactivate

echo === Installing FAST-iCLIP successfully done. ===
