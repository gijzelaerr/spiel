doc: CASA task to insert a source model in a visibility set
cwlVersion: v1.0
class: CommandLineTool

baseCommand: casa

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $( inputs.vis )
        writable: true

arguments:
  - prefix: -c
    valueFrom: |

      # javascript uses lowercase bools
      true = True
      false = False

      ft(
        vis="$( inputs.vis.path )",
        field="$( inputs.field )",
        spw="$( inputs.spw )",
        model="$( inputs.model.path )",
        nterms=$( inputs.nterms ),
        complist="$( inputs.complist )",
        incremental=$( inputs.incremental ),
        usescratch=$( inputs.usescratch ),
      )

inputs:

  vis:
    type: Directory
    doc:  Name of input visibility file (MS)

  model:
    type: Directory
    doc: Name of input model image(s)

  field:
    type: string?
    doc: Field selection
    default: ""

  spw:
    type: string?
    doc: Spw selection
    default: ""

  nterms:
    type: int?
    default: 1
    doc: Number of terms used to model the sky

  complist:
    type: string?
    doc: Name of component list
    default: ""

  incremental:
    type: boolean
    default: false
    doc:  Add to the existing model visibility

  usescratch:
    type: boolean
    default: true
    doc:  If True predicted visibility is stored in MODEL_DATA column


outputs:
  vis_out:
    type: Directory
    outputBinding:
      glob: $( inputs.vis.basename )
