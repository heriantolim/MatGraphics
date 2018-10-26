function value=getdefault(varargin)
%% Get the Default Properties
%  value=Groot.getdefault() returns the values of all the settable default
%  properties of MATLAB graphic objects. The values are contained in a cell. Use
%  Groot.findprop() to get the property names that correspond to these values.
%
%  value=Groot.getdefault(Name)
%  value=Groot.getdefault(NameArray)
%  does the same as the built-in function:
%     value=get(groot,'default'Name)
%     value=get(groot,'default'NameArray)
%  except that the elements in NameArray, Name1, Name2, ... are a regular
%  expression. The values of all the properties that match the regular
%  expression will be returned. Unlike the built-in implementation, the property
%  names should not be prefixed with the string 'default'. In the first syntax,
%  the output is a cell vector containing the values. In the second syntax, the
%  output is a cell array of such cell vectors. The size of the cell array is
%  the same as that of the NameArray.
%
% Tested on:
%  - MATLAB R2018a
%
% See also: findprop, setdefault, usedefault.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 04/04/2018
% Last modified: 05/04/2018

assert(nargin<2,...
	'MatGraphics:Groot:getdefault:WrongNargin',...
	'At most one input argument can be taken.');

if nargin>0 && iscell(varargin{1})
	tf=false;
	prop=Groot.findprop(varargin{1});
	varargin=varargin{1};
else
	tf=true;
	prop={Groot.findprop(varargin{:})};
end

value=cell(size(prop));
for i=1:numel(prop)
	if isempty(prop{i})
		error('MatGraphics:Groot:getdefault:PropertyNotFound',...
			'The expression ''%s'' matches no gettable default properties.',...
			varargin{i});
	end
	value{i}=cell(size(prop{i}));
	for j=1:numel(prop{i})
		try
			value{i}{j}=get(groot,['default',prop{i}{j}]);
		catch ME1
			if isempty(regexpi(ME1.identifier,':DefaultCannotBeSetGet$','once'))
				rethrow(ME1);
			else
				warning('MatGraphics:Groot:getdefault:NoGetAccess',...
					'%s',ME1.message);
			end
		end
	end
end

if tf
	value=value{1};
end

end