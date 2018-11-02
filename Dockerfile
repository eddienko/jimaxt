# VERSION       0.1

FROM continuumio/miniconda3

MAINTAINER Eduardo Gonzalez

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN conda config --append channels conda-forge && \
    conda install -y python=3.7 gcc_linux-64 \
                     numpy scipy astropy matplotlib dask distributed dask-image transaction sqlalchemy pyzmq \
                     aiohttp ipython psycopg2 pyyaml requests tornado voluptuous bokeh holoviews lz4 xarray \
                     scikit-learn scikit-image \
                     datashader cython && \
    conda clean -y -a

RUN ln -s /opt/conda/bin/x86_64-conda_cos6-linux-gnu-gcc /opt/conda/bin/gcc

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]

