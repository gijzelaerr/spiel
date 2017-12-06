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
 config: File
 tigger_filename: File

outputs:
  skymodel:
    type: File
    outputSource: galsim/skymodel
  dirty:
    type: File
    outputSource: wsclean/dirty
  image:
    type: File
    outputSource: wsclean/image

steps:
  galsim:
    run: steps/galsim.cwl
    in:
      script: galsim_script
    out:
        [skymodel]

  importfits:
    run: steps/importfits.cwl
    in:
      fitsfile: galsim/skymodel
    out:
      [casaimage]

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

  ft:
    run: steps/ft.cwl
    in:
      vis: simms/empty_ms
      model: importfits/casaimage
    out:
      [vis_out]

  simulator:
    run: steps/simulator.cwl
    in:
      ms: ft/vis_out
      config: config
      tigger_filename: tigger_filename

    out:
      [ms_sim]

  wsclean:
    run: steps/wsclean.cwl
    in:
      ms: simulator/ms_sim
    out:
      [image, dirty]
