FROM ubuntu:16.04

ENV CONDA_ALWAYS_YES="true"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y git wget bzip2 build-essential libssl-dev libffi-dev curl bzip2 apt-utils expect libgeos-dev

RUN adduser --disabled-password --gecos "" gremlin --uid 2001 && groupmod --gid 2001 gremlin

RUN wget --no-verbose https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p anaconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH /anaconda/bin:$PATH
# ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

RUN chown -R gremlin:gremlin /anaconda

USER gremlin

RUN /anaconda/bin/conda update -n base conda

# force conda-forge to be top channel priority
RUN /anaconda/bin/conda config --add channels conda-forge

# fixes weird proj warnings related to rasterio
ENV PROJ_LIB='/anaconda/envs/gbdx_py3/share/proj'

# ENV DEFAULT_PACKAGES="scipy=1.0.0 dask=1.1.4 rasterio gdal=2.3 libiconv ncurses proj4 gbdxtools=0.16.5"
# RUN /anaconda/bin/conda create -n gbdx_py2 python=2.7 jupyter notebook=5.6.0 ipykernel && \
#     /anaconda/bin/conda create -n gbdx_py3 python=3.6 jupyter notebook=5.6.0 ipykernel

# RUN /anaconda/bin/conda install -n gbdx_py2 -c conda-forge -c digitalglobe -y ${DEFAULT_PACKAGES} && \
#     /anaconda/bin/conda install -n gbdx_py3 -c conda-forge -c digitalglobe -y ${DEFAULT_PACKAGES}

RUN /anaconda/bin/conda create -n gbdx_py2 python=2.7 jupyter notebook=5.6.0 ipykernel && \
    /anaconda/bin/conda create -n gbdx_py3 python=3.6 jupyter notebook=5.6.0 ipykernel

RUN /anaconda/bin/conda install -n gbdx_py2 -c conda-forge -c digitalglobe -y scipy=1.0.0 gbdxtools=0.16.5 dask=1.1.4 && \
    /anaconda/bin/conda install -n gbdx_py3 -c conda-forge -c digitalglobe -y scipy=1.0.0 gbdxtools=0.16.5 dask=1.1.4

RUN /anaconda/bin/conda install -n gbdx_py2 -y --channel conda-forge rasterio gdal=2.4 libiconv ncurses proj4 && \
    /anaconda/bin/conda install -n gbdx_py3 -y --channel conda-forge rasterio gdal=2.4 libiconv ncurses proj4

RUN /anaconda/envs/gbdx_py2/bin/pip install rio_hist && \
    /anaconda/envs/gbdx_py3/bin/pip install rio_hist

RUN /anaconda/bin/conda clean -tipsy && \
    /anaconda/bin/conda clean -y --all 
    # /anaconda/bin/conda build purge-all 


# USER root
# RUN /anaconda/envs/gbdx_py2/bin/ipython kernel install --name python2 --display-name "Python 2 (gbdx_py2)" && \
#     /anaconda/envs/gbdx_py3/bin/ipython kernel install --name python3 --display-name "Python 3 (gbdx_py3)"

# USER gremlin
WORKDIR /home/gremlin

# ADD kernel-startup-py2.sh /anaconda/envs/gbdx_py2/share/jupyter/kernels/python2/kernel-startup-py2.sh
# ADD kernel-startup-py3.sh /anaconda/envs/gbdx_py3/share/jupyter/kernels/python3/kernel-startup-py3.sh

# ADD kernel2.json /anaconda/envs/gbdx_py2/share/jupyter/kernels/python2/kernel.json
# ADD kernel3.json /anaconda/envs/gbdx_py3/share/jupyter/kernels/python3/kernel.json

ADD test_imports.py /home/gremlin/test_imports.py
RUN /anaconda/envs/gbdx_py3/bin/python test_imports.py && \
    /anaconda/envs/gbdx_py2/bin/python test_imports.py && \
    rm /home/gremlin/test_imports.py
