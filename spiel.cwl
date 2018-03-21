cwlVersion: v1.0
class: Workflow

inputs:
 random_seed: int
 telescope: string
 synthesis: float
 dtime: int
 freq0: float
 dfreq: string
 nchan: int
 config: File
 tigger_filename: File
 ra: float
 dec: float
 dra: float
 ddec: float
 mgain: float
 niter: int
 scale: string
 size_x: int
 size_y: int

outputs:
  dirty:
    type: File
    outputSource: rename_dirty/renamed
  cleaned:
    type: File
    outputSource: rename_cleaned/renamed
  skymodel:
    type: File
    outputSource: rename_skymodel/renamed
  simulated_vis:
    type: Directory
    outputSource: ft/vis_out
    

steps:
  galsim:
    run: steps/galsim.cwl
    in:
      random_seed: random_seed
    out:
        [skymodel]

  add_wcs:
    run: steps/add_wcs.cwl
    in:
      fitsfile: galsim/skymodel
      ra: ra
      dec: dec
      dra: dra
      ddec: ddec
      freq0: freq0
    out:
      [fixedwcs]

  importfits:
    run: steps/importfits.cwl
    in:
      fitsfile: add_wcs/fixedwcs
    out:
      [casaimage]

  simms:
    run: steps/simms.cwl
    in:
      telescope: telescope
      ra: ra
      dec: dec
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
      size_x: size_x
      size_y: size_y
      scale: scale
      niter: niter
      mgain: mgain
      #ms: ft/vis_out
      ms: simulator/ms_sim
    out:
      [cleaned, dirty]

  rename_skymodel:
    run: steps/rename.cwl
    in:
      file: add_wcs/fixedwcs
      prefix: random_seed
    out:
      - renamed

  rename_cleaned:
    run: steps/rename.cwl
    in:
      file: wsclean/cleaned
      prefix: random_seed
    out:
      - renamed

  rename_dirty:
    run: steps/rename.cwl
    in:
      file: wsclean/dirty
      prefix: random_seed
    out:
      - renamed
