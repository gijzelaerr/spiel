.PHONY: clean run

all: run

clean:
	rm -rf .virtualenv

.virtualenv/:
	virtualenv -p python2 .virtualenv
 
.virtualenv/bin/cwltool: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

run: .virtualenv/bin/cwltool
	.virtualenv/bin/cwltool \
		--cachedir cache \
		--outdir results \
		--force-docker-pull \
		spel.cwl \
		job.cwl
