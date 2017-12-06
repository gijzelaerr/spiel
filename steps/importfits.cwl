#CASA <3>: inp(importfits)
#  importfits :: Convert an image FITS file into a CASA image
#fitsimage           =         ''        #  Name of input image FITS file
#imagename           =         ''        #  Name of output CASA image
#whichrep            =          0        #  If fits image has multiple coordinate
#                                        #   reps, choose one.
#whichhdu            =         -1        #  If its file contains multiple images,
#                                        #   choose one (0 = first HDU, -1 =
#                                        #   first valid image).
#zeroblanks          =       True        #  Set blanked pixels to zero (not NaN)
#overwrite           =      False        #  Overwrite pre-existing imagename
#defaultaxes         =      False        #  Add the default 4D coordinate axes
#                                        #   where they are missing; value True
#                                        #   requires setting defaultaxesvalues
#defaultaxesvalues   =         []        #  List of values to assign to added
#                                        #   degenerate axes when
#                                        #   defaultaxes==True
#                                        #   (ra,dec,freq,stokes)
#beam                =         []        #  List of values to be used to define
#                                        #   the synthesized beam [BMAJ,BMIN,BPA]
#                                        #   (as in the FITS keywords)

cwlVersion: v1.0
class: CommandLineTool

baseCommand: casa

hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel

requirements:
  - class: InlineJavascriptRequirement

arguments:
  - prefix: -c
    valueFrom: |

      # javascript uses lowercase bools
      true = True
      false = False

      importfits(
        fitsimage="$( inputs.fitsfile.path )",
        imagename="casaimage",
        whichrep=$( inputs.whichrep ),
        whichhdu=$( inputs.whichhdu ),
        zeroblanks=$( inputs.zeroblanks ),
        overwrite=$( inputs.overwrite ),
        defaultaxes=$( inputs.defaultaxes ),
        defaultaxesvalues=$( inputs.defaultaxesvalues ),
        beam=$( inputs.beam ),
      )

inputs:
  fitsfile:
    type: File

  whichrep:
    type: int?
    default: 0

  whichhdu:
    type: int?
    default: -1

  zeroblanks:
    type: boolean?
    default: True

  overwrite:
    type: boolean?
    default: False

  defaultaxes:
    type: boolean?
    default: False

  defaultaxesvalues:
    type: string?
    default: "[]"

  beam:
    type: string?
    default: "[]"

outputs:
  casaimage:
    type: Directory
    outputBinding:
      glob: casaimage