cwlVersion: v1.0
class: CommandLineTool

baseCommand: galsim

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.script)
        writable: true

hints:
  DockerRequirement:
      dockerImageId: kernsuite/galsim
      dockerFile: |
        FROM kernsuite/base:3
        RUN docker-apt-install galsim python-future python-yaml python-pyfits

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

