FROM kernsuite/base:3

# we need to set this for casa to work properly inside docker
ENV USER root

RUN docker-apt-install \
    python-future \
    python-yaml \
    python-pyfits \
    python-pip \
    make \
    simms \
    meqtrees \
    wsclean \
    casalite \
    python-astropy \
    tigger-lsm
