function usedefault(varargin)
%  Groot.usedefault(profile) sets the default properties of MATLAB graphic
%  objects using the specified profile (a string scalar). This calls a function
%  or script named equal to profile inside the private folder of +Groot.
%
%  Groot.usedefault() equals to calling Groot.usedefault('factory'). This
%  resets the defaults of all MATLAB graphic objects to their factory settings.
%
%  Groot.usedefault(profile,...) passes the extra input arguments to the
%  function profile.
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
% See also: findprop, getdefault, setdefault.
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 05/04/2018
% Last modified: 06/04/2018

if nargin==0
	factory();
else
	% Check if name exists in the private folder.
	if isempty(regexp(which(varargin{1}),[regexptranslate('escape',...
			[filesep,'+Groot',filesep,'private',filesep]),'\w+\.m$'],'once'))
		error('MatGraphics:Groot:usedefault:ProfileNotFound',...
			'The profile ''%s'' does not exist.',varargin{1});
	end
	
	% Execute the private function or script.
	feval(varargin{:});
end

end