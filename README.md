# Spiel

CWL version based on the simulation example from Stimela.

https://github.com/SpheMakh/Stimela/blob/master/examples/simulation_pipeline.py


# requirements

* virtualenv to bootstrap CWLrunner
* make if you want to use the helper Makefile 
* [Docker](https://www.docker.com/) if you want to run containers
* Ubuntu 16.04 with [KERN-3](http://kernsuite.info) repository enabled if you
  dont want to use containers

Example the Makefile, it is an example on how to run our pipeline.

To run the pipeline with the example dataset just run:
```bash
$ make
```

If you want to try out toil run:
```bash
$ make multi
```

[![spiel graph](https://github.com/gijzelaerr/spiel/blob/master/spiel.png?raw=true "spiel graph")

