cwlVersion: v1.0
class: CommandLineTool

inputs:
  random_seed:
    type: int?
    default: 0

  dec_min:
    type: float?
    default: -90

  dec_max:
    type: float?
    default: 0

  flux_scale_min:
    type: float?
    default: 0.0000001

  flux_scale_max:
    type: float?
    default: 1

  nsrc_min:
    type: int?
    default: 1

  nsrc_max:
    type: int?
    default: 100

baseCommand: python

arguments:
  - prefix: -c
    valueFrom: |
      import json
      import numpy.random as random
      true = True
      false = False

      random.seed($(inputs.random_seed))

      dec = random.uniform($(inputs.dec_min), $(inputs.dec_max))
      flux_scale = random.uniform($(inputs.flux_scale_min), $(inputs.flux_scale_max))
      nsrc = random.uniform($(inputs.nsrc_min), $(inputs.nsrc_max))

      print(json.dumps({
        'dec': dec,
        'flux_scale': flux_scale,
        'nsrc': nsrc,
      }))

stdout: cwl.output.json

outputs:
  dec:
    type: float
  flux_scale:
    type: float
  nsrc:
    type: float
