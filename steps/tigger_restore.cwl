cwlVersion: v1.0
class: CommandLineTool

baseCommand: tigger-restore

hints:
  DockerRequirement:
      dockerPull: gijzelaerr/spiel

inputs:
  image:
    type: File
    inputBinding:
      position: 0

  skymodel:
    type: File
    inputBinding:
      position: 1

arguments:
 - -b 0
 - --clear
 - position: 2
   valueFrom: skymodel.fits

outputs:
  fitsmodel:
    type: File
    outputBinding:
      glob: skymodel.fits

