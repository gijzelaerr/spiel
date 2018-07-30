cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
 random_seeds: int[]
 telescope: string
 antennas: Directory 
 dtime: float
 freq0: float
 nchan: int
 config: File
 ra: float
 dec: float
 mgain: float
 niter: int
 scale: string
 size_x: int
 size_y: int
 column: string
 fov: float
 nsrc: int
 pb_fwhm: float
 weight: string
 randomise_pos: boolean
 sefd: float
 auto_mask: float
 auto_threshold: float
 nant: int
 synthesis_min: float
 synthesis_max: float
 dfreq_min: float
 dfreq_max: float
 gain_errors: int 
 gainamp_min_error: float 
 gainamp_max_error: float 
 gainphase_min_error: float 
 gainphase_max_error: float 
 flux_scale_min: float
 flux_scale_max: float

outputs:
  dirty:
    type: File[]
    outputSource: simulate/dirty
  cleaned:
    type: File[]
    outputSource: simulate/cleaned
  model:
    type: File[]
    outputSource: simulate/model
  residual:
    type: File[]
    outputSource: simulate/residual
  skymodel:
    type: File[]
    outputSource: simulate/skymodel
  fitsmodel:
    type: File[]
    outputSource: simulate/fitsmodel
  psf:
    type: File[]
    outputSource: simulate/psf
  settings:
    type: File[]
    outputSource: simulate/settings
  bigpsf:
    type: File[]
    outputSource: simulate/bigpsf

steps:
  simulate:
    run: spiel.cwl
    in:
      random_seed: random_seeds
      telescope: telescope
      antennas: antennas
      dtime: dtime
      freq0: freq0
      nchan: nchan
      config: config
      ra: ra
      dec: dec
      mgain: mgain
      niter: niter
      scale: scale
      size_x: size_x
      size_y: size_y
      column: column
      fov: fov
      nsrc: nsrc
      pb_fwhm: pb_fwhm
      weight: weight
      randomise_pos: randomise_pos
      sefd: sefd
      dtime: dtime
      auto_mask: auto_mask
      auto_threshold: auto_threshold
      nant: nant
      synthesis_min: synthesis_min
      synthesis_max: synthesis_max
      dfreq_min: dfreq_min
      dfreq_max: dfreq_max
      gain_errors: gain_errors
      gainamp_min_error: gainamp_min_error
      gainamp_max_error: gainamp_max_error
      gainphase_min_error: gainphase_min_error
      gainphase_max_error: gainphase_max_error
      flux_scale_min: flux_scale_min
      flux_scale_max: flux_scale_max

    scatter: random_seed

    out: [skymodel, dirty, cleaned, model, residual, fitsmodel, simulated_vis, psf, settings, bigpsf]
