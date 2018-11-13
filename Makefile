.PHONY: clean run docker
RUN := runs/run_$(shell date +%F-%H-%M-%S)
VENV=$(CURDIR)/.virtualenv/
JOB=jobs/meerkat16_deep2_sphe.yaml
TOIL=$(VENV)bin/toil-cwl-runner --stats --cleanWorkDir onSuccess \
		--logFile $(RUN)/log --outdir $(RUN)/results \
		--jobStore file:///$(CURDIR)/$(RUN)/job_store \
		--workDir $(CURDIR)/work

CWLTOOL=$(VENV)bin/cwltool --tmpdir $(CRUDIR)/tmp/ --cachedir \
		$(CURDIR)/cache/ --outdir $(CURDIR)/results/

all: run

clean:
	rm -rf $(VENV)

$(VENV):
	virtualenv -p python2 $(VENV)
 
$(VENV)bin/cwltool: $(VENV)
	$(VENV)bin/pip install -r requirements.txt

$(VENV)bin/cwltoil: $(VENV)
	$(VENV)bin/pip install -r requirements.txt

docker:
	docker build -t gijzelaerr/spiel .

run: $(VENV)bin/cwltool docker
	$(CWLTOOL) spiel.cwl ${JOB}

multi: $(VENV)bin/cwltoil docker
	mkdir -p $(RUN)/results
	$(TOIL) multi.cwl ${JOB}

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
