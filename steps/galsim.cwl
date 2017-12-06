cwlVersion: v1.0
class: CommandLineTool

baseCommand: galsim

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.script)
#        writable: true

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

inputs:
  script:
    type: File
    inputBinding:
      position: 1

outputs:
   skymodel:
     type: File
     outputBinding:
       glob: "*.fits"

