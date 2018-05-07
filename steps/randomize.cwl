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

      print(json.dumps({
        'dec': dec,
      }))

stdout: cwl.output.json

outputs:
  dec:
    type: float
