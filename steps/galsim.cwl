cwlVersion: v1.0
class: CommandLineTool

baseCommand: [galsim, galsim.yaml]


requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: galsim.yaml
        entry: |
          # based on galsim example #11

          eval_variables :
              fpixel_scale : &pixel_scale 2
              atheta : &theta 0.17 degrees
              fimage_size : &image_size 256
              inobjects : &nobjects 288
              fsize_degrees : '$image_size * pixel_scale / 3600'

          # Ideally we don't have a PSF but galsim becomes slow when we remove the below somehow.
          psf :
              type : InterpolatedImage
              image : "/usr/share/doc/galsim/data/example_sdss_psf_sky0.fits.bz2"
              scale : *pixel_scale

          gal :
              type : COSMOSGalaxy
              gal_type :
                  type : List
                  items : [ 'parametric', 'real' ]
                  index :
                      type : RandomBinomial
                      N : 1
                      p : 0.3

              noise_pad_size : 11.3

              shear :
                  type : PowerSpectrumShear

              magnification :
                  type : PowerSpectrumMagnification

              rotation :
                  type : Random

              scale_flux :
                  $( inputs.scale_flux )

          image :
              type : Scattered
              size : *image_size
              nobjects : *nobjects
              index_convention : 0

              noise :
                  type : Gaussian
                  variance: 5.0e2
                  whiten: False

              random_seed : $( inputs.random_seed )
              nproc : $( runtime.cores )

          stamp :
              draw_method : no_pixel

          input :
              cosmos_catalog :
                  dir : "/data/COSMOS_23.5_training_sample"
                  file_name : real_galaxy_catalog_23.5.fits
                  use_real : True

              power_spectrum :
                  e_power_function : "/usr/share/doc/galsim/data/cosmo-fid.zmed1.00.out.gz"
                  units : radians
                  grid_spacing : 90 # arcsec


hints:
  DockerRequirement:
      dockerImageId: gijzelaerr/spiel


inputs:
  random_seed:
    type: int
    default: 1

  scale_flux:
    type: int
    default: 10000


outputs:
   skymodel:
     type: File
     outputBinding:
       glob: "*.fits"

