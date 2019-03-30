.PHONY: clean run docker
RUN := runs/run_$(shell date +%F-%H-%M-%S)
VENV=$(CURDIR)/.virtualenv/
JOB=jobs/meerkat16_oleg_flux100.yaml
TOIL=$(VENV)bin/toil-cwl-runner --cleanWorkDir always \
		--logFile $(RUN)/log --outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work --tmpdir-prefix=$(CURDIR)/tmp \
		--tmp-outdir-prefix=$(CURDIR)/tmp --clean always

CWLTOOL=$(VENV)bin/cwltool --tmpdir $(CRUDIR)/tmp/ --cachedir \
		$(CURDIR)/cache/ --outdir $(CURDIR)/results/

all: run

$(VENV):
	virtualenv -p python2 $(VENV)
 
$(VENV)bin/cwltool: $(VENV)
	$(VENV)bin/pip install -r requirements.txt
	touch $(VENV)bin/cwltool

$(VENV)bin/cwltoil: $(VENV)
	$(VENV)bin/pip install -r requirements.txt
	touch $(VENV)bin/cwltoil

docker:
	docker build -t gijzelaerr/spiel .

run: $(VENV)bin/cwltool docker
	$(CWLTOOL) spiel.cwl ${JOB}

multi: $(VENV)bin/cwltoil docker
	mkdir -p $(RUN)/results
	TMPDIR=$(CURDIR)/tmp $(TOIL) multi.cwl ${JOB}

multi-psf: .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	$(TOIL) multi-psf.cwl ${JOB}

mesos: .virtualenv-system/bin/cwltoil docker
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--batchSystem mesos \
		--mesosMaster stem6.sdp.kat.ac.za:5050 \
		multi.cwl \
		${JOB}

slurm: .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	$(TOIL) --batchSystem slurm --singularity multi.cwl ${JOB}


srun: .virtualenv/bin/cwltool
	$(CWLTOOL) --singularity spiel.cwl $(JOB)

smulti: .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	$(TOIL) --singularity multi.cwl $(JOB)

clean:
	rm -rf runs/* cache/* results/*
