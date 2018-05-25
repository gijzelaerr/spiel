cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
 random_seeds: int[]
 telescope: string
 synthesis: float
 dtime: float
 freq0: float
 dfreq: float
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

steps:
  simulate:
    run: spiel.cwl
    in:
      random_seed: random_seeds
      telescope: telescope
      synthesis: synthesis
      dtime: dtime
      freq0: freq0
      dfreq: dfreq
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
      dfreq: dfreq
      auto_mask: auto_mask
      auto_threshold: auto_threshold

    scatter: random_seed

    out: [skymodel, dirty, cleaned, model, residual, fitsmodel, simulated_vis, psf]
