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
   valueFrom: /tmp  # change to $(runtime.tmpdir) once https://github.com/common-workflow-language/cwltool/issues/682 is fixed
 - -no-update-model-required
 - prefix: -name
   valueFrom: $(inputs.ms.basename)

outputs:
  dirty:
    type: File
    outputBinding:
      glob: $(inputs.ms.basename)-dirty.fits

  cleaned:
    type: File
    outputBinding:
      glob: $(inputs.ms.basename)-image.fits

  model:
    type: File
    outputBinding:
      glob: $(inputs.ms.basename)-model.fits

  residual:
    type: File
    outputBinding:
      glob: $(inputs.ms.basename)-residual.fits

