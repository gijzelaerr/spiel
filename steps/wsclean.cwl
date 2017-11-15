cwlVersion: v1.0
class: CommandLineTool

baseCommand: wsclean

hints:
  DockerRequirement:
      dockerImageId: kernsuite/wsclean
      dockerFile: |
        FROM kernsuite/base:3
        RUN docker-apt-install wsclean

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

  scale:
    type: string
    default: 1asec
    inputBinding:
      prefix: -scale

arguments:
 - valueFrom: -size
   position: 1
 - valueFrom: $(inputs.size_x)
   position: 2
 - valueFrom: $(inputs.size_y)
   position: 3

outputs:
  dirty:
    type: File
    outputBinding:
      glob: wsclean-dirty.fits

  image:
    type: File
    outputBinding:
      glob: wsclean-image.fits

