# VERSION       0.3

FROM continuumio/miniconda3

MAINTAINER Eduardo Gonzalez

RUN apt-get update && apt-get install -y gcc procps && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

COPY environment.yml /root/environment.yml
RUN conda env update -n base -f /root/environment.yml && \
    conda clean -y -a
RUN /opt/conda/bin/jupyter serverextension enable --py nbserverproxy
RUN /opt/conda/bin/jupyter labextension install @jupyterlab/hub-extension
RUN /opt/conda/bin/jupyter labextension install jupyterlab_bokeh
RUN /opt/conda/bin/jupyter labextension install @pyviz/jupyterlab_pyviz
RUN mkdir -p /opt/conda/share/jupyter/lab/settings && echo '{ "hub_prefix": "/jupyter" }' > /opt/conda/share/jupyter/lab/settings/page_config.json

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app
ADD ipython /etc/ipython
ADD jupyterlab_imaxt /opt/app/jupyterlab_imaxt
RUN cd /opt/app/jupyterlab_imaxt && jupyter labextension install 

RUN groupadd -g 1111 imaxt
RUN groupadd -g 3785 docker
RUN useradd -m -u 1111 -g imaxt imaxt
RUN usermod -a -G docker imaxt
USER imaxt
ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]

