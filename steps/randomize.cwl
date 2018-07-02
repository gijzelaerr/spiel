cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: gijzelaerr/spiel
                                                       

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

  synthesis_min:
    type: float

  synthesis_max:
     type: float

  dfreq_min:
     type: float

  dfreq_max:
     type: float

  flux_scale_min:
     type: float

  flux_scale_max:
     type: float


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
      synthesis = random.uniform($(inputs.synthesis_min), $(inputs.synthesis_max))
      dfreq = int(random.uniform($(inputs.dfreq_min), $(inputs.dfreq_max)))

      flux_scale = 10**random.uniform($(inputs.flux_scale_min), $(inputs.flux_scale_max))

      print(json.dumps({
        'dec': dec,
        'synthesis': synthesis,
        'dfreq': dfreq,
        'flux_scale': flux_scale
      }))

stdout: cwl.output.json

outputs:
  dec:
    type: float

  synthesis:
    type: float

  dfreq:
    type: float

  flux_scale:
    type: float