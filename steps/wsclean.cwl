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
      position: 1

  size:
    type: string
    default: 2048 2048
    inputBinding:
      prefix: -size

  scale:
    type: string
    default: 1asec
    inputBinding:
      prefix: -scale

outputs:
  dirty:
    type: File
    outputBinding:
      glob: wsclean-dirty.fits

  clean:
    type: File
    outputBinding:
      glob: wsclean-clean.fits

