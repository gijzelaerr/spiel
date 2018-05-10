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

docker:
	docker build -t gijzelaerr/spiel .

run: .virtualenv/bin/cwltool docker
	.virtualenv/bin/cwltool \
		--tmpdir `pwd`/tmp/ \
		--cachedir `pwd`/cache/ \
		--outdir `pwd`/results/ \
		spiel.cwl \
		job.yaml

multi: .virtualenv/bin/cwltoil docker
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--stats \
	    --cleanWorkDir onSuccess \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work \
		multi.cwl \
		job.yaml

srun: .virtualenv/bin/cwltool
	.virtualenv/bin/cwltool \
        --singularity \
		--tmpdir `pwd`/tmp/ \
		--cachedir `pwd`/cache/ \
		--outdir `pwd`/results/ \
		spiel.cwl \
		job.yaml

smulti: .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--stats \
        --singularity \
	    --cleanWorkDir onSuccess \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work \
		multi.cwl \
		job.yaml
