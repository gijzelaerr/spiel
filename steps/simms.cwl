cwlVersion: v1.0
class: CommandLineTool

baseCommand: simms

#requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.script)
#        writable: true

#hints:
  #DockerRequirement:
      #dockerImageId: kernsuite/simms
      #dockerFile: |
        #FROM kernsuite/base:3
        #RUN docker-apt-install simms

inputs:
  telescope:
    type: string
    inputBinding:
      prefix: --tel

  direction:
    type: string
    doc: Phase tracking centre of observation
    inputBinding:
      prefix: --direction

  synthesis:
    type: float
    doc: Synthesis time of observation
    inputBinding:
      prefix: --synthesis-time

  dtime:
    type: int
    doc: Integration time
    inputBinding:
      prefix: --dtime

  freq0:
    type: string
    doc: Start frequency of observation
    inputBinding:
      prefix: --freq0

  dfreq:
    type: string
    doc: Channel width
    inputBinding:
      prefix: --dfreq

  nchan:
    type: int
    doc: Number of channels
    inputBinding:
      prefix: --nchan

outputs:
   empty_ms:
     type: Directory
     outputBinding:
       glob: "*.MS"
