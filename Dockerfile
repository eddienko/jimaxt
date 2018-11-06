# VERSION       0.1

FROM continuumio/miniconda3

MAINTAINER Eduardo Gonzalez

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

COPY environment.yml /root/environment.yml
RUN conda env create -n imaxt -f /root/environment.yml && \
    conda install -y gcc_linux-64 && \
    conda clean -y -a

RUN ln -s /opt/conda/bin/x86_64-conda_cos6-linux-gnu-gcc /opt/conda/bin/gcc

COPY prepare.sh /usr/bin/prepare.sh
RUN chmod +x /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/bin/prepare.sh"]

