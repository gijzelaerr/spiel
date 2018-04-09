import numpy.random as random

def make_sky_model(lsmname, ra, dec, seed, fov=1.0, nsrc=100, pb_fwhm=None, freq0=1.42e9):
    fluxes = random.pareto(5, nsrc) / 100

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

    model = open(lsmname, "w")
    
    model.write("#format: name ra_d dec_d i freq0 spi\n")
    for i in xrange(nsrc):
        model.write("src{name:04d} {ra:.5g} {dec:.5g} {flux:.3g} {freq0:.5g} {spi:.3f}\n".format(
        name=i, ra=ras[i], dec=decs[i], flux=fluxes[i], freq0=freq0, spi=spi[i]))
    model.close()
