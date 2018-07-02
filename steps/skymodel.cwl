cwlVersion: v1.0
class: CommandLineTool

baseCommand: python

hints:
  DockerRequirement:
      dockerPull: gijzelaerr/spiel


requirements:
  - class: InlineJavascriptRequirement

arguments:
  - prefix: -c
    valueFrom: |

      from numpy import random

      true = True  # javascript booleans are all lowercase
      false = False

      ra = $( inputs.ra )
      dec = $( inputs.dec )
      seed = $( inputs.seed )
      fov = $( inputs.fov ) 
      nsrc = $( inputs.nsrc )
      pb_fwhm = $( inputs.pb_fwhm )
      freq0 = $( inputs.freq0 )
      flux_scale = $( inputs.flux_scale )

      noise = $( inputs.sefd / Math.sqrt( 2 * inputs.dtime * inputs.dfreq * (inputs.nant * (inputs.nant-1))/2) )

      random.seed(seed)

      fluxes = (random.pareto(5, nsrc) * flux_scale) + noise/10

      if pb_fwhm:
      # Simulate more sources in the primary beam FWHM
          ras = ra - random.randn(nsrc)*pb_fwhm/2
          decs = dec - random.randn(nsrc)*pb_fwhm/2
      else: 
      # use uniform distribution in space
          ras = random.uniform(ra - fov/2.0, ra + fov/2.0, nsrc)
          decs = random.uniform(dec - fov/2.0, ra + fov/2.0, nsrc)
          
      # use a spectral index close to -0.7
      spi = -0.7 + random.randn(nsrc)*.01

      model = open("skymodel.txt", "w")
          
      model.write("#format: name ra_d dec_d i freq0 spi\\n")
      for i in xrange(nsrc):
          model.write("src{name:04d} {ra:.5g} {dec:.5g} {flux:.3g} {freq0:.5g} {spi:.3f}\\n".format(
          name=i, ra=ras[i], dec=decs[i], flux=fluxes[i], freq0=freq0, spi=spi[i]))
      model.close()


inputs:
  seed:
    type: int

  nsrc:
    type: int?
    default: 100

  ra:
    type: float?
    default: 0

  dec:
    type: float?
    default: -30

  fov:
    type: float?
    default: 1

  pb_fwhm:
    type: float?
    default: 0.5

  freq0:
    type: float?
    default: 1.42e9

  flux_scale:
    type: float?
    default: 1

  randomise_pos:
    type: boolean?
    default: false

  sefd:
    type: float

  dtime:
    type: float

  dfreq:
      type: float

  nant:
    type: int

outputs:
  skymodel:
    type: File
    outputBinding:
      glob: skymodel.txt
