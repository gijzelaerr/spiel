cwlVersion: v1.0
class: CommandLineTool

baseCommand: wsclean

hints:
  DockerRequirement:
      dockerPull: gijzelaerr/spiel

inputs:
  ms:
    type: Directory
    inputBinding:
      position: 1

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

  auto_mask:
    type: float
    default: 10
    inputBinding:
      prefix: -auto-mask

  auto_threshold:
    type: float
    default: 0.5
    inputBinding:
      prefix: -auto-threshold

  make-psf:
    type: boolean
    inputBinding:
      prefix: -make-psf


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

  psf:
    type: File
    outputBinding:
      glob: wsclean-psf.fits
