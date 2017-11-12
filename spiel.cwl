cwlVersion: v1.0
class: Workflow

inputs:
 galsim_script: File
 telescope: string
 direction: string
 synthesis: float
 dtime: int
 freq0: string
 dfreq: string
 nchan: int

outputs:
  skymodel:
    type: File
    outputSource: galsim/skymodel
  empty_ms:
    type: Directory
    outputSource: simms/empty_ms

steps:
  galsim:
    run: steps/galsim.cwl
    in:
      script: galsim_script
    out:
        [skymodel]

  simms:
    run: steps/simms.cwl
    in:
      telescope: telescope
      direction: direction
      synthesis: synthesis
      dtime: dtime
      freq0: freq0
      dfreq: dfreq
      nchan: nchan
    out:
      [empty_ms]
