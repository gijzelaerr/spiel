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

  scale:
    type: string
    default: 1asec
    inputBinding:
      prefix: -scale


arguments:
 - -size
 - $(2 * inputs.size_x)
 - $(2 * inputs.size_y)
 - -name
 - bigpsf
 - -make-psf-only

outputs:
  bigpsf:
    type: File
    outputBinding:
      glob: bigpsf-psf.fits
