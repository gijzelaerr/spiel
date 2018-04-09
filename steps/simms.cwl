cwlVersion: v1.0
class: CommandLineTool

baseCommand: simms

requirements:
    - class: EnvVarRequirement
      envDef:
        USER: root

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

arguments:
  - prefix: --ra
    valueFrom: $(inputs.ra)deg
  - prefix: --dec
    valueFrom: $(inputs.dec)deg

inputs:
  telescope:
    type: string
    inputBinding:
      prefix: --tel

  ra:
    type: float
    doc: Phase tracking centre of observation

  dec:
    type: float
    doc: Phase tracking centre of observation

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
    type: float
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
   ms:
     type: Directory
     outputBinding:
       glob: "*.MS"
