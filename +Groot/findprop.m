function prop=findprop(varargin)
%% Find the Default Properties
%  Groot.findprop() returns all the settable default properties of MATLAB
%  graphic objects as a string vector.
%
%  Groot.findprop(expr) returns the settable default properties that match a
%  regular expression expr. The input expr can be a string array. In this case,
%  the return is a cell array of the same size. Each element in the cell is a
%  string vector of the properties that match the corresponding expression.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2018a
%
% See also: getdefault, setdefault.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 31/03/2018
% Last modified: 04/04/2018

if nargin>1
	error('MatGraphics:Groot:findprop:WrongNargin',...
		'At most one input argument can be taken.');
elseif nargin==1
	assert(isstringscalar(varargin{1}) || isstringarray(varargin{1}),...
		'MatGraphics:Groot:findprop:InvalidInput',...
		'Input to the search expression must be a string scalar or array.');
end

prop=fields(get(groot,'factory'));
for j=1:numel(prop)
	prop{j}=prop{j}(8:end);
end

if nargin==0
	return
end

if iscell(varargin{1})
	tf=true;
	varargin=varargin{1};
	N=numel(varargin);
else
	tf=false;
	N=1;
end

C=cell(size(varargin));
for i=1:N
	C{i}=prop(~cellfun(@isempty,regexp(prop,varargin{i})));
end

if tf
	prop=C;
else
	prop=C{1};
end

end