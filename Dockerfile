# Dockerfile to build python3 images for constraint-based modeling
# Based on Ubuntu

# # Set the base image to Ubuntu
# FROM ubuntu:latest

# Add python3_scientific
FROM dmccloskey/python3scientific:latest
# # Add optGpSampler
# FROM dmccloskey/optgpsampler

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

# Install cobrapy, escher, and dependencies
RUN apt-get update && apt-get install -y libxml2 \
	libxml2-dev \
	zlib1g \
	zlib1g-dev \
	bzip2 \
	libbz2-dev

#install python packages using pip3
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir python-libsbml
RUN pip3 install --no-cache-dir git+https://github.com/opencobra/cobrapy.git
RUN pip3 install --no-cache-dir git+https://github.com/zakandrewking/escher.git
RUN pip3 install --upgrade

#cleanup
RUN apt-get clean
