# MatGraphics
**MatGraphics** extends the functionalities of the graphics tools in MATLAB R2018a for doing specific tasks. The functions provided in this repo may be less relevant for newer versions of MATLAB. Some examples can be found in my other repositories for MATLAB.

## Licensing
This software is licensed under the GNU General Public License (version 3).

## Functionalities
### Setting Default Properties
The defaults of MATLAB R2018a Graphics are suited for making on-screen plots, but not for prints. For example, the positioning properties are defaulted to use normalized units to make it easier for scaling on screens. This behavior is not ideal for plotting where fixed and precise positioning is preferred.

The [+Groot](../master/+Groot) package allows the default properties of MATLAB graphics objects to be conveniently 'get' and 'set'. The function [Groot.getdefault](../master/+Groot/getdefault.m) and [Groot.setdefault](../master/+Groot/setdefault.m) implement regular expression to perform the get and set, allowing many default properties to be retrieved or changed with a simple command. The function [Groot.usedefault](../master/+Groot/usedefault.m) allows one to load a 'profile' of default properties as well as reset the default properties to factory settings. A customizable profile that suits the styles of typical LaTeX documents is provided.

The function [docfigure](../master/docfigure.m) is a simpler alternative to the builtin function `figure` for creating a figure object that is optimized for making plots for prints.

The axes' ticks in MATLAB are, by default, set to vary in length according to the axes' dimensions. The function [fixticklength](../master/fixticklength.m) allows the tick lengths to be set to a fixed value.

### Working on Colormaps
It is sometimes useful to be able to locate specific colors in a MATLAB colormap, given a colormap limit. [ColorMap.findcolor](../master/+ColorMap/findcolor.m) provides a functionality to find the RGB triplet for each element in a real array from a specified colormap. The [+ColorMap](../master/+ColorMap) package also provides additional custom colormaps for plotting surface data.

### Making Figure Labels
The package [+Label](../master/+Label) provides some functions to conveniently add labels to a figure. The function [Label.subfigure](../master/+Label/subfigure.m) is useful to annotate subfigures with, for example, alphabetical letters. The function [Label.peak](../master/+Label/peak.m) is used in the examples in [PeakFit](https://github.com/heriantolim/PeakFit) repository to annotate the positions of the peaks.
