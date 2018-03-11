cwlVersion: v1.0
class: Workflow

requirements:
  - SubworkflowFeatureRequirement

inputs:
 random_seeds: int[]
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
    type: File[]
    outputSource: simulate/dirty
  image:
    type: File[]
    outputSource: simulate/image
  fixed_sky:
    type: File[]
    outputSource: simulate/fixedwcs

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
    tigger_filename: tigger_filename
    ra: ra
    dec: dec
    dra: dra
    ddec: ddec
    mgain: mgain
    niter: niter
    scale: scale
    size_x: size_x
    size_y: size_y

  scatter: random_seeds

  out: [skymodel, dirty, image, fixed_sky, simulated_vis]

    
