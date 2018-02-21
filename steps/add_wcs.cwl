cwlVersion: v1.0
class: CommandLineTool

baseCommand: python

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

      from astropy.io.fits import open, update, writeto
      import astropy.wcs as WCS
      import numpy

      with open("$( inputs.fitsfile.path )") as hdu:
          hdr = hdu[0].header
          if $( inputs.add_stokes_axis ) or $( inputs.add_freq_axis ):
              data = hdu[0].data
      
      ndim = hdr["NAXIS"]
      radim = hdr["NAXIS1"]
      decdim = hdr["NAXIS2"]
      hdr.clear()
      
      hdr.update({
              "CRVAL1"  : ($( inputs.ra ), ""),
              "CRVAL2"  : ($( inputs.dec ), ""),
              "CDELT1"  : ($( inputs.dra ), ""),
              "CDELT2"  : ($( inputs.ddec ), ""),
              "CRPIX1"  : (radim/2 , ""),
              "CRPIX2"  : (decdim/2, ""),
              "CUNIT1"  : ("deg",""),
              "CUNIT2"  : ("deg",""),
              "BUNIT"   : ("Jy/PIXEL", ""),
              "CTYPE1"  : ("RA---TAN", ""),
              "CTYPE2"  : ("DEC--TAN", ""),
              "EQUINOX" : (2000.0, "EQUINOX"),
              "RADECSYS": ("FK5", ""),
              "BTYPE"   : "Intensity",
          })
      
      if $( inputs.add_freq_axis ):
          data = numpy.expand_dims(data, axis=0)
          hdr.update({
                  "CTYPE{:d}".format(ndim+1) : "FREQ",
                  "CRVAL{:d}".format(ndim+1) : $( inputs.freq0 ),
                  "CRPIX{:d}".format(ndim+1) : 1,
                  "CDELT{:d}".format(ndim+1) : $( inputs.dfreq ),
                  "CUNIT{:d}".format(ndim+1) : "Hz",
              })
          ndim += 1

      if $( inputs.add_stokes_axis ):
          data = numpy.expand_dims(data, axis=0)
          hdr.update({
                  "CTYPE{:d}".format(ndim+1) : "STOKES",
                  "CRVAL{:d}".format(ndim+1) : 1,
                  "CRPIX{:d}".format(ndim+1) : 1,
                  "CDELT{:d}".format(ndim+1) : 1,
                  "CUNIT{:d}".format(ndim+1) : "Jy/PIXEL",
              })

      writeto("$(inputs.fitsfile.nameroot)_wcsfix.fits", data=data, header=hdr)

inputs:
  fitsfile:
    type: File

  ra:
    type: float

  dec:
    type: float

  dra:
    type: float

  ddec:
    type: float

  add_freq_axis:
    type: boolean?
    default: True

  freq0:
    type: float?
    default: 1.4e9

  dfreq:
    type: float?
    default: 1e6

  add_stokes_axis:
    type: boolean?
    default: True

outputs:
  fixedwcs:
    type: File
    outputBinding:
      glob: $(inputs.fitsfile.nameroot)_wcsfix.fits
