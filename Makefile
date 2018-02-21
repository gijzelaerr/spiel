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

run: .virtualenv/bin/cwltool docker
	.virtualenv/bin/cwltool \
		--tmpdir `pwd`/tmp/ \
		--cachedir `pwd`/cache/ \
		--outdir `pwd`/results/ \
		spiel.cwl \

toil: .virtualenv/bin/cwltoil docker
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work \
		spiel.cwl \
		job.yaml

docker:
	docker build -t gijzelaerr/spiel .

