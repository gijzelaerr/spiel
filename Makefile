.PHONY: clean run docker

RUN := runs/run_$(shell date +%F-%H-%M-%S)

VENV=$(CURDIR)/.virtualenv/

JOB=job.yaml

CWLTOOL=$(VENV)bin/cwltool \
	--tmpdir $(CRUDIR)/tmp/ \
	--cachedir $(CURDIR)/cache/ \
	--outdir $(CURDIR)/results/

all: run


$(VENV):
	python3 -m venv $(VENV)


$(VENV)bin/cwltool: $(VENV)
	$(VENV)bin/pip install -r requirements.txt
	touch $(VENV)bin/cwltool


docker:
	docker build -t gijzelaerr/spiel .


run: $(VENV)bin/cwltool
	$(CWLTOOL) spiel.cwl $(JOB)


multiple: $(VENV)bin/cwltool
	$(CWLTOOL) multiple.cwl $(JOB)


clean:
	rm -rf runs/* cache/* results/* tmp/*
