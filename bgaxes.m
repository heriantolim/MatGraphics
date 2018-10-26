function h=bgaxes(varargin)
%% Background Axes
%  h=bgaxes('Position',... other axes arguments) creates a transparent axis for
%  placeholder purposes and returns a handle to the axis.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/04/2018
% Last modified: 06/04/2018

h=axes(varargin{:},'Color','none','XTick',[],'YTick',[],'ZTick',[]);
c=h.Parent.Color;
set(h,'XColor',c,'YColor',c,'ZColor',c);

end