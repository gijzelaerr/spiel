cwlVersion: v1.0
class: CommandLineTool

baseCommand: wsclean

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

inputs:
  ms:
    type: Directory
    inputBinding:
      position: 4

  size_x:
    type: int
    default: 512

  size_y:
    type: int
    default: 512
 
  niter:
   type: int
   default: 1000
   inputBinding:
     prefix: -niter

  mgain:
   type: float
   default: 0.95
   inputBinding:
     prefix: -mgain

  scale:
    type: string
    default: 1asec
    inputBinding:
      prefix: -scale

arguments:
 - -size
 - $(inputs.size_x)
 - $(inputs.size_y)
 - prefix: -temp-dir
   valueFrom: /tmp
 - -no-update-model-required
 - prefix: -data-column
   valueFrom: MODEL_DATA

outputs:
  dirty:
    type: File
    outputBinding:
      glob: wsclean-dirty.fits

  cleaned:
    type: File
    outputBinding:
      glob: wsclean-image.fits

