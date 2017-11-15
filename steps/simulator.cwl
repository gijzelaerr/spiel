# meqtree-pipeliner.py  --mt 2 -c data/tdlconf.profiles [sim]
#    ms_sel.input_column=DATA
#    ms_sel.field_index=0
#    ms_sel.msname=results/meerkat_0h10s.MS
#    me.sky.tiggerskymodel=1
#    me.use_smearing=0
#    sim_mode="sim only"
#    noise_stddev=0.18581724893
#    ms_sel.ddid_index=0
#    tiggerlsm.filename=data/nvss1deg.lsm.html
#    ms_sel.output_column=CORRECTED_DATA
#    /usr/lib/python2.7/dist-packages/Cattery/Siamese/turbo-sim.py =_simulate_MS
#
cwlVersion: v1.0
class: CommandLineTool

baseCommand: meqtree-pipeliner.py

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
    'me.sky.tiggerskymodel=$( inputs.tiggerskymodel )',
    'me.use_smearing=$( inputs.use_smearing )',
    'sim_mode=$( inputs.sim_mode )',
    'noise_stddev=$( inputs.noise_stddev )',
    'ms_sel.ddid_index=$( inputs.ddid_index )',
    'tiggerlsm.filename=$( inputs.tigger_filename.path )',
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

  noise_stddev:
    type: float?
    default: 0.18581724893

  ddid_index:
    type: int?
    default: 0

  tigger_filename:
    type: File
  
outputs:
   ms_sim:
     type: Directory
     outputBinding:
       glob: "*.MS"
