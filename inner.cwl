cwlVersion: v1.0
class: Workflow

inputs:
 random_seed: int

outputs:
  outputfile:
    type: File
    outputSource: rename_outputfile/renamed


steps:
  mkfile:
    run: steps/mkfile.cwl
    in:
      content: random_seed
    out:
        [outputfile]

  rename_outputfile:
    run: steps/rename.cwl
    in:
      file: mkfile/outputfile
      prefix: random_seed
    out:
      - renamed
