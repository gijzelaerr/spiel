cwlVersion: v1.0
class: CommandLineTool

baseCommand: cp

inputs:
  file:
    type: File

  prefix:
    type: int

arguments: ["$(inputs.file.path)", "$(inputs.prefix)-$(inputs.file.basename)"]

outputs:
  renamed:
    type: File
    outputBinding:
      glob: "$(inputs.prefix)-$(inputs.file.basename)"
