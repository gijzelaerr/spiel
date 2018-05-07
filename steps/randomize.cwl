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
    default: 0.001

  flux_scale_max:
    type: float?
    default: 1

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

      print(json.dumps({
        'dec': dec,
        'flux_scale': flux_scale,
      }))

stdout: cwl.output.json

outputs:
  dec:
    type: float
  flux_scale:
    type: float
