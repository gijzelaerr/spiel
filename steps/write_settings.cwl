cwlVersion: v1.0
class: CommandLineTool

baseCommand: python

hints:
  DockerRequirement:
      dockerPull: gijzelaerr/spiel


requirements:
  - class: InlineJavascriptRequirement

arguments:
  - prefix: -c
    valueFrom: |


      true = True  # javascript booleans are all lowercase
      false = False

      telescope = "$(inputs.telescope)"
      ra = $( inputs.ra )
      dec = $( inputs.dec )
      seed = $( inputs.seed )
      fov = $( inputs.fov )
      pb_fwhm = $( inputs.pb_fwhm )
      freq0 = $( inputs.freq0 )
      dfreq = $( inputs.dfreq )
      synthesis = $( inputs.synthesis )

      with open("settings.txt", "w") as f:
          for i in ("ra", "dec", "seed", "fov", "pb_fwhm", "freq0", "dfreq", "synthesis"):
              f.write("{}: {}\\n".format(i, locals()[i]))

inputs:
  telescope:
    type: string

  seed:
    type: int

  ra:
    type: float

  dec:
    type: float

  fov:
    type: float

  pb_fwhm:
    type: float

  freq0:
    type: float

  randomise_pos:
    type: boolean

  nant:
    type: int

  synthesis:
    type: float

  dfreq:
    type: float


outputs:
  settings:
    type: File
    outputBinding:
      glob: settings.txt
