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

  column:
    type: string
    default: CORRECTED_DATA
    inputBinding:
      prefix: -data-column

  weight:
    type: string
    inputBinding:
      prefix: -weight


arguments:
 - -size
 - $(inputs.size_x)
 - $(inputs.size_y)
 - prefix: -temp-dir
   valueFrom: /tmp
 - -no-update-model-required

outputs:
  dirty:
    type: File
    outputBinding:
      glob: wsclean-dirty.fits

  cleaned:
    type: File
    outputBinding:
      glob: wsclean-image.fits

  model:
    type: File
    outputBinding:
      glob: wsclean-model.fits

  residual:
    type: File
    outputBinding:
      glob: wsclean-residual.fits

