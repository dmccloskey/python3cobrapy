# Dockerfile to build python3 images for constraint-based modeling
# Based on Ubuntu

# Add python3_scientific
FROM dmccloskey/python3scientific:latest

# File Author / Maintainer
MAINTAINER Douglas McCloskey <dmccloskey87@gmail.com>

# Switch to root for install
USER root

# Install wget
RUN apt-get update && apt-get install -y wget \
    build-essential

# Install glpk from http
# instructions and documentation for glpk: http://www.gnu.org/software/glpk/
WORKDIR /user/local/
RUN wget http://ftp.gnu.org/gnu/glpk/glpk-4.57.tar.gz
RUN tar -zxvf glpk-4.57.tar.gz

# Verify package contents
#gpg --verify glpk-4.57.tar.gz.sig
#gpg --keyserver keys.gnupg.net --recv-keys 5981E818

WORKDIR /user/local/glpk-4.57
RUN ./configure
RUN make
RUN make check
#RUN make install
RUN sudo make install
RUN make distclean

# add glpk libraries to path
RUN sudo ldconfig

# Cleanup
WORKDIR /
RUN rm -rf /user/local/glpk-4.57.tar.gz
RUN apt-get clean

# Install python2.7 packages
RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y python \
  python-scipy \
  python-numpy

# Install optGpSampler from http
# instructions and documentation for python installation: http://cs.ru.nl/~wmegchel/optGpSampler/#install-python.xhtml
WORKDIR /usr/local/
RUN wget http://cs.ru.nl/~wmegchel/optGpSampler/downloads/optGpSampler_1.1_Python_Linux64.tar.gz
RUN tar -zxvf optGpSampler_1.1_Python_Linux64.tar.gz
WORKDIR /usr/local/optGpSampler-1.1

# Run setup.py
RUN python setup.py install

# Install optGpSampler dependencies from http
WORKDIR /usr/local/
RUN wget http://cs.ru.nl/~wmegchel/optGpSampler/downloads/optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
RUN tar -zxvf optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
WORKDIR /usr/local/optGpSampler_1.1_Python_Linux64_dependencies

#Copy the files in libs/lin64 to a directory $LIB_DIR (for example /home/wout/optGpSamplerLibs) on your computer
RUN mv libs /usr/local/lib/python2.7/dist-packages/optGpSampler
RUN mv models /usr/local/lib/python2.7/dist-packages/optGpSampler

# add environment variables for optGpSampler
ENV PYTHONPATH /usr/local/lib/python2.7/dist-packages/optGpSampler/libs:$PYTHONPATH
ENV LD_LIBRARY_PATH /usr/local/lib/python2.7/dist-packages/optGpSampler/libs:$LD_LIBRARY_PATH
ENV OPTGPSAMPLER_LIBS_DIR /usr/local/lib/python2.7/dist-packages/optGpSampler/libs

# Add glpk to the LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Cleanup
WORKDIR /
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64.tar.gz
RUN rm -rf /usr/local/optGpSampler-1.1
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64_dependencies.tar.gz
RUN rm -rf /usr/local/optGpSampler_1.1_Python_Linux64_dependencies
RUN apt-get clean

# Install cobrapy, escher, and dependencies
RUN apt-get update && apt-get install -y libxml2 \
	libxml2-dev \
	zlib1g \
	zlib1g-dev \
	bzip2 \
	libbz2-dev \
	libglpk-dev

#install python packages using pip3
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir python-libsbml
RUN pip3 install --no-cache-dir cobra
RUN pip3 install --no-cache-dir escher
RUN pip3 install --upgrade

#cleanup
RUN apt-get clean
