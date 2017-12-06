.PHONY: clean run
RUN := runs/run_$(shell date +%F-%H-%M-%S)

all: run

clean:
	rm -rf .virtualenv

.virtualenv/:
	virtualenv -p python2 .virtualenv
 
.virtualenv/bin/cwltool: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/cwltoil: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/udocker: .virtualenv/
	curl https://raw.githubusercontent.com/indigo-dc/udocker/master/udocker.py > .virtualenv/bin/udocker
	chmod u+rx .virtualenv/bin/udocker
	.virtualenv/bin/udocker install

run: .virtualenv/bin/cwltool
	.virtualenv/bin/cwltool \
		--cachedir cache \
		--outdir results \
		spiel.cwl \
		job.cwl

run-udocker: .virtualenv/bin/cwltool
	.virtualenv/bin/cwltool \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--cachedir cache \
		--outdir results \
		spiel.cwl \
		job.cwl


nodocker: .virtualenv/bin/cwltool
	.virtualenv/bin/cwltool \
		--no-container \
		--cachedir cache \
		--outdir results \
		spiel.cwl \
		job.cwl


toil: .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work \
		spiel.cwl \
		job.cwl
