FROM kernsuite/base:3

ENV USER root

RUN docker-apt-install \
    python-future \
    python-yaml \
    python-pyfits \
    python-pip \
    make \
    galsim \
    simms \
    meqtrees \
    wsclean \
    casalite

RUN pip --no-cache-dir install cwlref-runner html5lib "toil[cwl]"
