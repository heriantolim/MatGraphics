function C=findcolor(A,cLim,cMap,varargin)
%% Find Color
%  C=ColorMap.findcolor(A,cLim,cmap,...) finds the RGB triplet for each element
%  in the real array A from the colormap cMap with respect to the interval cLim.
%  cLim is a vector of two real numbers [a,b] with a < b. If an element in A is
%  less than a then the corresponding RGB triplet is the top row in the m-by-3
%  real matrix cMap, i.e. cMap(1,:). If an element in A is greater than b then
%  the corresponding RGB triplet is the bottom row of cMap. For any element in
%  between the interval, the RGB triplet is calculated by a linear mapping
%  between the continuous interval and the finite set of rows in cMap.
%
% Inputs:
%  A   : An array of real numbers for which the RGB triplets are to be found.
%  cLim: An increasing vector of two real numbers.
%  cMap: Can be specified as a three-column matrix of real numbers between 0 and
%        1, a handle to a function that returns such matrix, or a string that
%        specifies the name of a function that returns such matrix. MATLAB has
%        several built-in functions that return a colormap matrix. The string
%        can also be the name of a function defined in the ColorMap package,
%        e.g. 'temperature'.
%  ... : Extra arguments will be passed to the function specified in cMap. Many
%        of the built-in functions that return a colormap matrix can take one
%        argument which sets the number of colors to be returned.
%
% Outputs:
%  C, a matrix of real numbers between 0 and 1. If A is a row vector, then C is
%  a three-row matrix. If A is a column matrix, then C is a three-column matrix.
%  If A is an array with a higher dimension, then C is an array with size equal
%  to [size(A),3].
%
% Requires package:
%  - MatCommon_v1.0.0+
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 05/04/2018
% Last modified: 23/09/2018

assert(isrealarray(A),...
	'MatGraphics:ColorMap:findcolor:InvalidInput',...
	'Input to the value array must be a real array.');
assert(isrealvector(cLim) && numel(cLim)==2 && cLim(1)<cLim(2),...
	'MatGraphics:ColorMap:findcolor:InvalidInput',...
	['Input to the value interval must be an increasing vector ',...
		'of two real numbers.']);

if isa(cMap,'function_handle')
	cMap=cMap(varargin{:});
elseif isstringscalar(cMap)
	try
		cMap=feval(cMap,varargin{:});
	catch ME1
		if isempty(regexpi(ME1.identifier,':UndefinedFunction$','once'))
			rethrow(ME1);
		else
			try
				cMap=feval(['ColorMap.',cMap],varargin{:});
			catch ME2
				if isempty(regexpi(ME1.identifier,':UndefinedFunction$','once'))
					rethrow(ME1);
				else
					error('MatGraphics:ColorMap:findcolor:FunctionNotFound',...
						'Could not found a function named ''%s''.',cMap);
				end
			end
		end
	end
end

if ~isrealmatrix(cMap) || size(cMap,2)~=3 || any(cMap(:)<0 | cMap(:)>1)
	error('MatGraphics:ColorMap:findcolor:InvalidInput',...
		['Input to the color map must be a three-column matrix of real ',...
			'numbers between 0 and 1, or a handle to, or a string that ',...
			'specifies the name of, a function that returns such matrix.']);
end

N=size(cMap,1);
A=ceil((A-cLim(1))/diff(cLim)*N);
A(A<1)=1;
A(A>N)=N;
C=cMap(A(:),:);
if ~iscolumn(A)
	if isrow(A)
		C=C.';
	else
		C=reshape(C,[size(A),3]);
	end
end

end
