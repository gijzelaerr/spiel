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
 ra: float
 dec: float
 mgain: float
 niter: int
 scale: string
 size_x: int
 size_y: int
 fov: float
 pb_fwhm: float
 nsrc: int
 column: string

outputs:
  dirty:
    type: File
    outputSource: wsclean/dirty
  cleaned:
    type: File
    outputSource: wsclean/cleaned
  residual:
    type: File
    outputSource: wsclean/residual
  model:
    type: File
    outputSource: wsclean/model
  skymodel:
    type: File
    outputSource: make_skymodel/skymodel
  fitsmodel:
    type: File
    outputSource: trigger_restore/fitsmodel
  simulated_vis:
    type: Directory
    outputSource: simulator/ms_out
    

steps:
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
      [ms]

  make_skymodel:
    run: steps/random_sky.cwl
    in:
      ra: ra
      dec: dec
      seed: random_seed
      freq0: freq0
      fov: fov
      pb_fwhm: pb_fwhm
      nsrc: nsrc
    out:
      [skymodel]


  simulator:
    run: steps/simulator.cwl
    in:
      ms: simms/ms
      config: config
      output_column: column
      skymodel: make_skymodel/skymodel

    out:
      [ms_out]

  wsclean:
    run: steps/wsclean.cwl
    in:
      size_x: size_x
      size_y: size_y
      scale: scale
      niter: niter
      mgain: mgain
      column: column
      ms: simulator/ms_out
    out:
      [cleaned, dirty, residual, model]

  tigger_restore:
    run: steps/tigger_restore.cwl
    in:
      image: wsclean/dirty
      skymodel: make_skymodel/skymodel
    out:
      [fitsmodel]
