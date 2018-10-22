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
  dirty:
    type: File
    outputSource: rename_dirty/renamed
  cleaned:
    type: File
    outputSource: rename_cleaned/renamed
  residual:
    type: File
    outputSource: rename_residual/renamed
  model:
    type: File
    outputSource: rename_model/renamed

  cleaned_iuwt:
    type: File
    outputSource: rename_cleaned_iuwt/renamed
  residual_iuwt:
    type: File
    outputSource: rename_residual_iuwt/renamed
  model_iuwt:
    type: File
    outputSource: rename_model_iuwt/renamed

  skymodel:
    type: File
    outputSource: rename_skymodel/renamed
  fitsmodel:
    type: File
    outputSource: rename_fitsmodel/renamed
  psf:
    type: File
    outputSource: rename_psf/renamed
  simulated_vis:
    type: Directory
    outputSource: simulator/ms_out
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

  make_skymodel:
    run: steps/skymodel.cwl
    in:
      ra: ra
      dec: randomize/dec
      seed: random_seed
      freq0: freq0
      fov: fov
      pb_fwhm: pb_fwhm
      nsrc: nsrc
      sefd: sefd
      dtime: dtime
      dfreq: randomize/dfreq
      nant: nant
      flux_scale: randomize/flux_scale

    out:
      [skymodel]


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


    out:
      [settings]


  simulator:
    run: steps/simulator.cwl
    in:
      ms: simms/ms
      config: config
      output_column: column
      skymodel: make_skymodel/skymodel
      sefd: sefd
      dtime: dtime
      dfreq: randomize/dfreq
      gain_errors: gain_errors
      gainamp_min_error: gainamp_min_error
      gainamp_max_error: gainamp_max_error
      gainphase_min_error: gainphase_min_error
      gainphase_max_error: gainphase_max_error

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
      weight: weight
      ms: simulator/ms_out
      make-psf:
        valueFrom: $(true)
      auto_mask: auto_mask
      auto_threshold: auto_threshold
    out:
      [cleaned, dirty, residual, model, psf]

  wsclean_iuwt:
    run: steps/wsclean.cwl
    in:
      size_x: size_x
      size_y: size_y
      scale: scale
      niter: niter
      mgain: mgain
      column: column
      weight: weight
      ms: simulator/ms_out
      make-psf:
        valueFrom: $(true)
      auto_mask: auto_mask
      auto_threshold: auto_threshold
      iuwt:
        valueFrom: $(true)
      name:
        valueFrom: "iuwt"
    out:
      [cleaned, dirty, residual, model, psf]


  make_bigpsf:
    run: steps/bigpsf.cwl
    in:
      size_x: size_x
      size_y: size_y
      scale: scale
      ms: simulator/ms_out
    out:
      [bigpsf]

  tigger_restore:
    run: steps/tigger_restore.cwl
    in:
      image: wsclean/dirty
      skymodel: make_skymodel/skymodel
    out:
      [fitsmodel]

  rename_skymodel:
    run: steps/rename.cwl
    in:
      file: make_skymodel/skymodel
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

  rename_residual:
    run: steps/rename.cwl
    in:
      file: wsclean/residual
      prefix: random_seed
    out:
      - renamed

  rename_model:
    run: steps/rename.cwl
    in:
      file: wsclean/model
      prefix: random_seed
    out:
      - renamed




  rename_cleaned_iuwt:
    run: steps/rename.cwl
    in:
      file: wsclean_iuwt/cleaned
      prefix: random_seed
    out:
      - renamed

  rename_residual_iuwt:
    run: steps/rename.cwl
    in:
      file: wsclean_iuwt/residual
      prefix: random_seed
    out:
      - renamed

  rename_model_iuwt:
    run: steps/rename.cwl
    in:
      file: wsclean_iuwt/model
      prefix: random_seed
    out:
      - renamed




  rename_fitsmodel:
    run: steps/rename.cwl
    in:
      file: tigger_restore/fitsmodel
      prefix: random_seed
    out:
      - renamed


  rename_psf:
    run: steps/rename.cwl
    in:
      file: wsclean/psf
      prefix: random_seed
    out:
      - renamed

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
