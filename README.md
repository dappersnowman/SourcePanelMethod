# SourcePanelMethod
A lightweight matlab implementation of the source vortex panel method to arbitrary 2D airfoils. Originally written for a class assignment, this implementation has been polished for more general usage, with arbitrary resolution. Outputs a chordwise pressure distribution across the airfoil.

Call using the following inputs and outputs.

[xmid, Cpi] = sourcepanel(x, y, panelNumber, alpha, shouldPlot)

xmid : The chordwise location of pressure coefficient values. Also refers to the midpoints of all source panels used in the aerodynamic analysis.
Cpi : Pressure coefficient values.
x, y : Airfoil shape coordinates. Chord is assumed to lie along the x-axis. If an angle of attack is desired, it should be defined by "alpha", instead of buried in the airfoil coordinates.
panelNumber : The number of panels that should be used in the analysis. Essentially is the "resolution" of the analysis. Must be even. If an odd number is given, this number will automatically round up to an even value. Defaults to 5000 panels.
alpha : The angle of attack of the given airfoil. Defaults to zero angle of attack.
shouldPlot : If value is '-y', a plot of the calculated pressure distribution along the airfoil chord will be generated. Defaults to '-n'.
