cwlVersion: v1.0
class: CommandLineTool

baseCommand: "true"

inputs:
  content:
    type: int

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: outputfile
        entry: |
          bla
          $(inputs.content)
          bla

outputs:
  outputfile:
    type: File
    outputBinding:
      glob: "outputfile"
