function h=subfigure(varargin)
%% Label Sub Figures
%  h=Label.subfigure() creates a text '(a)' or '(b)' or ... on the top left
%  corner of the current axes and returns the handle to the text object. The
%  label string depends on the order in which the axes was created. The first
%  axes is given label '(a)', the second '(b)', ...
%
%  h=Label.subfigure(str) uses str as the label string.
%
%  h=Label.subfigure(a,...) creates the label on the axes specified by the
%  handle a.
%
%  h=Label.subfigure(...,Name1,Value1,Name2,Value2,...) specifies the properties
%  of the text object in Name-Value syntax. Available parameters are:
%   - Parent   : The handle to the axes wherein the label is to be created.
%   - String   : The label string.
%   - Location : The label location. Can be either: 'north', 'south', 'east',
%                'west', 'northeast', 'northwest', 'southeast', 'southwest'.
%                Defaults to 'northwest'.
%   - Position : The [x,y] position of the label from the <location> corner or
%                edge. Can be specified as a vector of two real numbers [x,y] or
%                a real scalar x. In the latter case, the position is set to
%                [x,x] if the location is a corner, [0,x] if it is
%                'north'/'south', or [x,0] if it is 'east'/'west'. Positive
%                position is directed inwards the axes. Defaults to .4;
%   - Units    : The units of the position. Can be either: 'centimeters',
%                'inches', or 'points'.
%  and all other properties of the MATLAB text object.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 06/04/2018
% Last modified: 07/04/2018

S=struct();
k=1;
if k<=nargin && isscalar(varargin{k}) && ...
		(isgraphics(varargin{k},'Axes') || isgraphics(varargin{k},'Polaraxes'))
	S.Parent=varargin{k};
	k=k+1;
else
	S.Parent=gca;
end

if k<=nargin && isstringscalar(varargin{k})
	S.String=varargin{k};
	k=k+1;
else
	A=S.Parent.Parent.Children;
	A=A(isgraphics(A,'Axes') | isgraphics(A,'Polaraxes'));
	S.String=sprintf('(%s)',97+numel(A)-find(S.Parent==A));
end

S.Units='centimeters';
loc='northwest';
pos=.4;
while k<nargin
	if strcmpi(varargin{k},'Parent')
		x=varargin{k+1};
		if isgraphics(x,'Axes') || isgraphics(x,'Polaraxes')
			S.Parent=x;
		else
			error('MatGraphics:Label:subfigure:InvalidInput',...
				'Input to the parent handle must be an axes handle.');
		end
	elseif strcmpi(varargin{k},'String')
		x=varargin{k+1};
		if isstringscalar(x)
			S.String=x;
		else
			error('MatGraphics:Label:subfigure:InvalidInput',...
				'Input to the label string must be a string scalar.');
		end
	elseif strcmpi(varargin{k},'Location')
		x=varargin{k+1};
		if any(strcmpi(x,{'north','south','east','west','northeast',...
				'northwest','southeast','southwest'}))
			loc=lower(x);
		else
			error('MatGraphics:Label:subfigure:InvalidInput',...
				['Input to the label location must be either: ',...
					'''north'', ''south'', ''east'', ''west'', ''northeast'', ',...
					'''northwest'', ''southeast'', ''southwest''.']);
		end
	elseif strcmpi(varargin{k},'Position')
		x=varargin{k+1};
		if isrealvector(x) && numel(x)<=2
			pos=x;
		else
			error('MatGraphics:Label:subfigure:InvalidInput',...
				['Input to the label position must be a vector of ',...
					'one or two real numbers.']);
		end
	elseif strcmpi(varargin{k},'Units')
		x=varargin{k+1};
		if any(strcmpi(x,{'centimeters','inches','points'}))
			S.Units=x;
		else
			error('MatGraphics:Label:subfigure:InvalidInput',...
				['Input to the position units must be either: ',...
					'''centimeters'', ''inches'', ''points''.']);
		end
	elseif isstringscalar(varargin{k})
		S.(varargin{k})=varargin{k+1};
	else
		error('MatGraphics:Label:subfigure:UnexpectedInput',...
			'One or more inputs are not recognized.');
	end
	k=k+2;
end

if k<=nargin
	warning('MatGraphics:Label:subfigure:IgnoredInput',...
		'An extra input argument was provided, but is ignored.');
end

if numel(pos)<2
	switch loc
		case {'northwest','northeast','southwest','southeast'}
			pos=repmat(pos,1,2);
		case {'north','south'}
			pos=[0,pos];
		case {'east','west'}
			pos=[pos,0];
	end
else
	pos=reshape(pos,1,2);
end

switch loc
	case 'northwest'
		S.Position=[pos(1),S.Parent.Position(4)-pos(2)];
		S.VerticalAlignment='top';
		S.HorizontalAlignment='left';
	case 'north'
		S.Position=[S.Parent.Position(3)/2+pos(1),S.Parent.Position(4)-pos(2)];
		S.VerticalAlignment='top';
		S.HorizontalAlignment='center';
	case 'northeast'
		S.Position=S.Parent.Position(3:4)-pos(1:2);
		S.VerticalAlignment='top';
		S.HorizontalAlignment='right';
	case 'west'
		S.Position=[pos(1),S.Parent.Position(4)/2+pos(2)];
		S.VerticalAlignment='middle';
		S.HorizontalAlignment='left';
	case 'east'
		S.Position=[S.Parent.Position(3)-pos(1),S.Parent.Position(4)/2+pos(2)];
		S.VerticalAlignment='middle';
		S.HorizontalAlignment='right';
	case 'southwest'
		S.Position=pos;
		S.VerticalAlignment='bottom';
		S.HorizontalAlignment='left';
	case 'south'
		S.Position=[S.Parent.Position(3)/2+pos(1),pos(2)];
		S.VerticalAlignment='bottom';
		S.HorizontalAlignment='center';
	case 'southeast'
		S.Position=[S.Parent.Position(3)-pos(1),pos(2)];
		S.VerticalAlignment='bottom';
		S.HorizontalAlignment='right';
end

h=text(S);

end