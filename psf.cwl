cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement


inputs:
 random_seed: int
 telescope: string
 dtime: float
 freq0: float
 nchan: int
 config: File
 ra: float
 dec_min: float
 dec_max: float
 mgain: float
 niter: int
 scale: string
 size_x: int
 size_y: int
 fov: float
 pb_fwhm: float
 nsrc: int
 column: string
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
 antennas: Directory

outputs:
  settings:
    type: File
    outputSource: rename_settings/renamed
  bigpsf:
    type: File
    outputSource: rename_bigpsf/renamed


steps:
  randomize:
    run: steps/randomize.cwl
    in:
       dec_min: dec_min
       dec_max: dec_max
       random_seed: random_seed
       dfreq_max: dfreq_max
       dfreq_min: dfreq_min
       synthesis_max: synthesis_max
       synthesis_min: synthesis_min
       flux_scale_min: flux_scale_min
       flux_scale_max: flux_scale_max
    out:
       [dec, synthesis, dfreq, flux_scale]

  simms:
    run: steps/simms.cwl
    in:
      telescope: telescope
      ra: ra
      dec: randomize/dec
      synthesis: randomize/synthesis
      dtime: dtime
      freq0: freq0
      dfreq: randomize/dfreq
      nchan: nchan
      pos: antennas
      type:
        valueFrom: casa

    out:
      [ms]

  write_settings:
    run: steps/write_settings.cwl
    in:
      ra: ra
      dec: randomize/dec
      seed: random_seed
      freq0: freq0
      fov: fov
      pb_fwhm: pb_fwhm
      telescope: telescope
      dfreq: randomize/dfreq
      synthesis: randomize/synthesis
      nant: nant
      randomise_pos: randomise_pos

  make_bigpsf:
    run: steps/bigpsf.cwl
    in:
      size_x: size_x
      size_y: size_y
      scale: scale
      ms: simms/ms
    out:
      [bigpsf]

  rename_bigpsf:
    run: steps/rename.cwl
    in:
      file: make_bigpsf/bigpsf
      prefix: random_seed
    out:
      - renamed

  rename_settings:
    run: steps/rename.cwl
    in:
      file: write_settings/settings
      prefix: random_seed
    out:
      - renamed
