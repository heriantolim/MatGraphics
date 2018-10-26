function setdefault(varargin)
%% Set the Default Properties
%  Groot.setdefault(NameArray,ValueArray)
%  Groot.setdefault(Name1,Value1,Name2,Value2,...)
%  does the same as the built-in function:
%     set(groot,'default'NameArray,ValueArray)
%     set(groot,'default'Name1,Value1,'default'Name2,Value2,...)
%  except that the elements in NameArray, Name1, Name2, ... are a regular
%  expression. All the graphic properties that match the regular expression will
%  be set with the corresponding value. Unlike the built-in implementation, the
%  property names should not be prefixed with the string 'default'. This feature
%  is useful for brevity, but caution must be exercised to prevent unintended
%  properties from being matched by the regular expression.
%
% Examples:
%  Groot.setdefault('thesis')
%  sets the default properties using the profile 'thesis'.
%
%  Groot.setdefault('FontName','Arial','Interpreter','latex')
%  sets the default FontName properties of the graphics objects: Axes, Colorbar,
%  Legend, ..., to 'Arial', and the default properties of the graphics objects:
%  AxesTickLabel, ColorbarTickLabel, Legend, ..., to 'latex'.
%
% Warning:
%  The defaults stay until they are changed or the MATLAB session is closed.
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2018a
%
% See also: findprop, getdefault, usedefault.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 31/03/2018
% Last modified: 05/04/2018

if nargin==2
	if iscell(varargin{1})
		prop=varargin{1};
		value=varargin{2};
	else
		prop=varargin(1);
		value=varargin(2);
	end
elseif mod(nargin,2)==0
	prop=varargin(1:2:nargin);
	value=varargin(2:2:nargin);
else
	error('MatGraphics:Groot:setdefault:WrongNargin',...
		'Incorrect number of input arguments.');
end

assert(all(cellfun(@isstringscalar,prop)),...
	'MatGraphics:Groot:setdefault:InvalidInput',...
	'Input to the property names must be a string scalar.');

C=Groot.findprop(prop);
for i=1:numel(prop)
	if isempty(C{i})
		error('MatGraphics:Groot:setdefault:PropertyNotFound',...
			'The expression ''%s'' matches no settable default properties.',...
			prop{i});
	end
	for j=1:numel(C{i})
		try
			set(groot,['default',C{i}{j}],value{i});
		catch ME1
			if isempty(regexpi(ME1.identifier,':DefaultCannotBeSetGet$','once'))
				rethrow(ME1);
			else
				warning('MatGraphics:Groot:setdefault:NoSetAccess',...
					'%s',ME1.message);
			end
		end
	end
end

end