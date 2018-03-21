cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
 random_seeds: int[]

outputs:
  dirty:
    type: File[]
    outputSource: inner/outputfile

steps:
  inner:
    run: inner.cwl
    in:
      random_seed: random_seeds

    scatter: random_seed

    out: [outputfile]


