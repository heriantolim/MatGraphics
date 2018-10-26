function varargout=data2pos(varargin)
%% Convert Data Coordinates to Position Coordinates
%  [pos_x,pos_y,...]=data2pos(data_x,data_y,...) converts data point coordinates
%  in the current axes into the position coordinates of the axes relative to its
%  parent. data_x, data_y, ... must be a real array. Each of the outputs: pos_x,
%  pos_y, ..., has the same size as the corresponding input.
%
%  pos=data2pos(data) is another syntax of this function. data must be a
%  D-column matrix, where D is the number of dimension of the current axes. The
%  output has the same size as the input.
%
%  ...=data2pos(h,...) performs the conversion using the axes with handle h.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 07/04/2018
% Last modified: 07/04/2018

ME=MException('MatGraphics:data2pos:WrongNargin',...
	'Insufficient input arguments.');
if 1>nargin
	throw(ME);
end

k=1;
h=varargin{k};
flag=isscalar(h) & [isgraphics(h,'Axes'),isgraphics(h,'Polaraxes')];
if ~any(flag)
	h=gca;
	flag=[isgraphics(h,'Axes'),isgraphics(h,'Polaraxes')];
elseif k<nargin
	k=k+1;
else
	throw(ME);
end

if flag(1)
	if all(h.View==[0,90])
		D=2;
	else
% 		D=3;
		error('MatGraphics:data2pos:NotImplemented',...
			'Conversion for 3D catersian axes is not supported.');
	end
else%if flag(2)
% 	D=2;
	error('MatGraphics:data2pos:NotImplemented',...
		'Conversion for polar axes is not supported.');
end

if k==nargin
	x=size(varargin{k});
	if numel(x)==2 && x(2)==D
		varargin=mat2cell(varargin{k},x(1),ones(1,D));
	else
		error('MatGraphics:data2pos:InvalidInput',...
			['Input to the data coordinates as a matrix must have the number ',...
				'of columns equal to the number of dimensions of the axes.']);
	end
	x=true;
elseif k-1+D==nargin
	varargin=varargin(k:nargin);
	x=false;
else
	error('MatGraphics:data2pos:WrongNargin',...
		'Incorrect number of input arguments.');
end
assert(all(cellfun(@isrealarray,varargin)),...
	'MatGraphics:data2pos:InvalidInput',...
	'Input to the data coordinates must be a real array.');

varargout=cell(1,D);
if flag(1)
	f={'XLim','YLim','ZLim'};
	pos=h.Position;
	if D==2
		for i=1:D
			lim=h.(f{i});
			varargout{i}=pos(i)+(varargin{i}-lim(1))/diff(lim)*pos(i+2);
		end
	else
		% Silence is golden.
	end
else%if flag(2)
	% Silence is golden.
end

if x
	varargout={[varargout{:}]};
end

end