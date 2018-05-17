#!/bin/bash

# set the version of DeepVariant to build
VERSION=0.6.1

#=========================================================================================
echo "### Checkout Deepvariant from github"
git clone https://github.com/google/deepvariant
cd deepvariant
git checkout v${VERSION}

cd deepvariant/docker
cp ../../../Dockerfile.patch .

# Check available versions
echo "### Make sure the version you want exists:"
gsutil -m ls gs://deepvariant/binaries/DeepVariant/      
#gs://deepvariant/binaries/DeepVariant/0.4.0/
#gs://deepvariant/binaries/DeepVariant/0.4.1/
#gs://deepvariant/binaries/DeepVariant/0.5.0/
#gs://deepvariant/binaries/DeepVariant/0.5.1/
#gs://deepvariant/binaries/DeepVariant/0.5.2/
#gs://deepvariant/binaries/DeepVariant/0.6.0/
#gs://deepvariant/binaries/DeepVariant/0.6.1/

echo "### Ensure there is only one build for your version"
gsutil -m ls gs://deepvariant/binaries/DeepVariant/${VERSION}/
# Copy the files
gsutil -m cp -r gs://deepvariant/binaries/DeepVariant/${VERSION}/*/* .
chmod +x run-prereq.sh

# Copy the distribution files

cp ../../LICENSE .
cp ../../AUTHORS .

echo "### Patch Dockerfile"
# fix ARG issue
cp Dockerfile Dockerfile.old
patch < Dockerfile.patch

# Or Edit Dockerfile and changed top two lines
#
#FROM ubuntu:16.04
#
#ENV DV_GPU_BUILD=0

echo "### Build Docker image"
docker build --tag deepvariant:${VERSION} .

echo "### Convert Docker image to Singularity image"
docker run -v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/output:/output --privileged -t --rm \
singularityware/docker2singularity deepvariant:${VERSION}

echo "### Your singularity image"
ls -l ~/output/deepvariant_${VERSION}*

# Run Singularity image
#singularity exec ~/output/deepvariant_0.5.2-2018-03-13-686add719556.img \
#python /opt/deepvariant/bin/make_examples.zip -h

