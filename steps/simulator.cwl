cwlVersion: v1.0
class: CommandLineTool

baseCommand: meqtree-pipeliner.py

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.ms)
        writable: true

arguments: ['--mt', '$( runtime.cores )',
    '-c', '$( inputs.config.path )',
    '[sim]',
    'ms_sel.input_column=$( inputs.input_column )',
    'ms_sel.field_index=$( inputs.field_index )',
    'ms_sel.msname=$( inputs.ms.path )',
    'me.use_smearing=$( inputs.use_smearing )',
    'sim_mode=$( inputs.sim_mode )',
    'noise_stddev=$( (inputs.sefd /  Math.sqrt( 2 * inputs.dtime * inputs.dfreq )) * inputs.flux_scale )',
    'ms_sel.ddid_index=$( inputs.ddid_index )',
    'tiggerlsm.filename=$( inputs.skymodel.path )',
    'ms_sel.output_column=$( inputs.output_column )',
    '/usr/lib/python2.7/dist-packages/Cattery/Siamese/turbo-sim.py',
    '=_simulate_MS']

inputs:
  ms:
    type: Directory

  config:
    type: File

  input_column:
    type: string?
    default: DATA

  output_column:
    type: string?
    default: CORRECTED_DATA

  field_index:
    type: int?
    default: 0

  tiggerskymodel:
    type: int?
    default: 1

  use_smearing:
    type: int?
    default: 0

  sim_mode:
    type: string?
    default: sim only

  sefd:
    type: float?
    default: 420.0

  dtime:
     type: float

  dfreq:
      type: float

  ddid_index:
    type: int?
    default: 0

  skymodel:
    type: File

  flux_scale:
    type: float?
    default: 1
  
outputs:
   ms_out:
     type: Directory
     outputBinding:
       glob: "*.MS"
