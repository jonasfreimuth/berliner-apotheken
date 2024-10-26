# Examination of pharmacy abundances in Berlin between 2014 & 2023

After seeing
[this article](https://www.rbb24.de/wirtschaft/beitrag/2024/10/apothekensterben-berlin-brandenburg-ahrensfelde.html)
by RBB ([archive](https://archive.is/YsyWU)), I though the
[map](https://www.datawrapper.de/_/cVmHP/) displayed was not really showing me
the information I would be most interested in, namely the change across the
period for which there were data available. Comparing the absolute values of
pharmacies across districts doesn't really tell me anything since it contains no
information contextualizing what the value means for each district.

![Original plot](/original_plot_screenshot.png "Screenshot of the original
interactive plot in the article.")

Since the RBB appears to have decent standards for publishing data alongside the
plot, I can just build the plot I want myself. The data is available inside
[this PDF document](https://pardok.parlament-berlin.de/starweb/adis/citat/VT/19/SchrAnfr/S19-19998.pdf)
from the Berlin Senate-Administration, although it isn't particularly
accessible. I just used an online OCR service and manually cleaned up the data.

Getting spatial data of the administrative boundaries within Berlin is not
trivial, as this lies below level 3 of the data provided by
[GADM](https://gadm.org). I am getting the map data from the
[Berlin Open Data Information Office](https://daten.odis-berlin.de/), but this
offering is deprecated and instead, it seems the
[Berlin Geoportal](https://gdi.berlin.de/geonetwork/srv/ger/catalog.search#/metadata/f91871d1-8e8e-3910-baa0-61defd811c88)
is the place to go for this kind of data. However, since I have not worked with
spatial data in a while, I was not able to figure out why reading their WFS file
gave me warnings about duplicated fields, so I just went with the ODIS data as
that behaved nicely.

The plots can be generated using `pharmacy_density.R`, if
[Guix](https://guix.gnu.org/) is installed, the plots can be reproduced by
running

```sh
guix time-machine -C channels.scm -- \
    shell -m manifest.scm -- \
        Rscript --vanilla pharmacy_density.R
```

And there we have it:

![New plot](/period_change_map.png "Map showing the relative change in
pharmacies from 2014 to 2023.")

Not only the absolute number of pharmacies varies across districts, there are
also considerable differences in the change across the ten years for which data
were available: While it seems that Spandau the number of pharmacies is
decreasing only slowly, loosing about a 15th of their pharmacies, on the other
end of the spectrum is Lichtenberg, which lost more than a quarter of its
pharmacies.

![Additional plot 1](/period_change_plot.png "Barplot for change in number per
district.")

![Additional plot 2](/counts_by_time_plot.png "Number of pharmacies per district
over time.")

Comparing the density of pharmacies per number of residents across time, by
average age, or by socio-economic indicators would be even more interesting, but
I can't be asked to go looking for that information right now.
