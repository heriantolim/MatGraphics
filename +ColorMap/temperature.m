function cMap=temperature(varargin)
%% Temperature ColorMap
%  cMap=ColorMap.temperature() returns 256-by-3 real matrix that represents a
%  colormap of 256 RGB triplets. The top row of this matrix, cMap(1,:), gives a
%  blue color to which the lowest value (coldest temperature) would be assigned
%  in the MATLAB colormap convention. The middle row gives a green color to
%  which the middle value would be assigned. The bottom row gives a red color to
%  which the highest value (hottest temperature) would be assigned.
%
%  cMap=ColorMap.temperature(N) uses N as the number of colors instead of 256.
%
%  cMap=ColorMap.temperature(midpos) adjusts the position of the green color in
%  the cMap according to the value of midpos. Midpos is a real scalar between 0
%  and 1. midpos<.5 will make the row corresponding to the green color closer to
%  the top row (blue color). midpos>.5 will make that row closer to the bottom
%  row (red color). Defaults to .5.
%
%  cMap=ColorMap.temperature(N,midpos)
%  cMap=ColorMap.temperature(midpos,N)
%  specifies both the number of colors and mid position.
%
%  cMap=ColorMap.temperature(...,Name1,Value1,Name2,Value2,...) sets the
%  Name-Value options of this function. Available options are:
%   - Saturation: A real sclar between 0 and 1. A saturation of 0 makes the
%                 colors become white. A saturation of 1 corresponds to the
%                 maximum tone of the color sets. Defaults to 1.
%   - Brightness: A real sclar between 0 and 1. Defaults to 0.8.
%
% Output:
%  cMap: A N-by-3 matrix of real numbers between 0 and 1.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2013b
%  - MATLAB R2015b
%  - MATLAB R2017a
%  - MATLAB R2018a
%
% See also: findcolor.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 14/06/2013
% Last modified: 15/04/2013

%% Defaults and Constants
N=256;
mid=.5;
sat=1;
val=.8;
HUE=[2,1,0]/3;% min, mid, max

%% Input Parsing
if nargin>0
	k=1;
	x=varargin{k};
	if isrealscalar(x) && x>=0 && x<=1
		mid=x;
		k=k+1;
		if nargin>1
			x=varargin{k};
			if isintegerscalar(x) && x>1
				N=x;
				k=k+1;
			elseif ~isstringscalar(x)
				error('MatGraphics:ColorMap:temperature:InvalidInput',...
					['Input to the number of colors must be an integer scalar ',...
						'greater than 1.']);
			end
		end
	elseif isintegerscalar(x) && x>1
		N=x;
		k=k+1;
		if nargin>1
			x=varargin{k};
			if isrealscalar(x) && x>=0 && x<=1
				mid=x;
				k=k+1;
			elseif ~isstringscalar(x)
				error('MatGraphics:ColorMap:temperature:InvalidInput',...
					['Input to the middle position must be a real scalar ',...
						'between 0 and 1.']);
			end
		end
	elseif ~isstringscalar(x)
		error('MatGraphics:ColorMap:temperature:UnexpectedInput',...
			 'One or more inputs are not recognized.');
	end
	
	while k<nargin
		assert(isstringscalar(varargin{k}),...
			'MatGraphics:ColorMap:temperature:InvalidInput',...
			'Input to the parameter names must be a string scalar.');
		if strcmpi(varargin{k},'Saturation')
			x=varargin{k+1};
			if isrealscalar(x) && x>=0 && x<=1
				sat=x;
			else
				error('MatGraphics:ColorMap:temperature:InvalidInput',...
					['Input to the saturation must be a real scalar ',...
						'between 0 and 1.']);
			end
		elseif strcmpi(varargin{k},'Brightness')
			x=varargin{k+1};
			if isrealscalar(x) && x>=0 && x<=1
				val=x;
			else
				error('MatGraphics:ColorMap:temperature:InvalidInput',...
					['Input to the brightness must be a real scalar ',...
						'between 0 and 1.']);
			end
		else
			error('MatGraphics:ColorMap:temperature:InvalidInput',...
				'Unrecognized Name-Value pair arguments.');
		end
		k=k+2;
	end
	
	if k<=nargin
		warning('MatGraphics:ColorMap:temperature:IgnoredInput',...
			'An extra input argument was provided, but is ignored.');
	end
end

%% Construct Color Map
cMap=zeros(N,3);
v=linspace(0,1,N);
for i=1:N
	if v(i)<mid
		hue=interp1([0,mid],HUE(1:2),v(i),'linear');
	else
		hue=interp1([mid,1],HUE(2:3),v(i),'linear');
	end
	cMap(i,:)=[hue,sat,val];
end
cMap=hsv2rgb(cMap);

end