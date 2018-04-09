cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
 random_seeds: int[]
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
 column: string
 fov: float
 nsrc: int
 pb_fwhm: float


outputs:
  dirty:
    type: File[]
    outputSource: simulate/dirty
  image:
    type: File[]
    outputSource: simulate/cleaned
  fixed_sky:
    type: File[]
    outputSource: simulate/skymodel

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

    scatter: random_seed

    out: [skymodel, dirty, cleaned, simulated_vis]
