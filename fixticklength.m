function fixticklength(varargin)
%% Fix Tick Length
%  fixticklength(L) sets the tick length of the current axes (gca) to a fixed
%  length L.
%
%  fixticklength(h,L) fixes the tick length of the axes with handle h.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 07/04/2018
% Last modified: 07/04/2018

k=nargin;
if k==0 || k>2
	error('MatGraphics:fixticklength:WrongNargin',...
		'Incorrect number of input arguments.');
end

if isrealscalar(varargin{k}) && varargin{k}>=0
	L=varargin{k};
else
	error('MatGraphics:fixticklength:InvalidInput',...
		'Input to the length must be a positive real scalar.');
end

if k==1
	h=gca;
elseif isgraphics(varargin{k},'Axes') || isgraphics(varargin{k},'Polaraxes')
	h=varargin{k};
else
	error('MatGraphics:fixticklength:InvalidInput',...
		'Invalid input to the axes handle.');
end

set(h,'TickLength',[L,L]/max(h.Position(3:4)));

end