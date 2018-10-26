function [ht,hl]=peak(varargin)
%% Label Peaks
%  ht=Label.peak(px) labels the peaks on the current axes at the x positions
%  specified by the real vector px and returns the handle to the text objects
%  that represent the peak labels.
%
%  ht=Label.peak(a,px) creates the labels on the axes specified by the handle a.
%
%  ht=Label.peak(...,Name1,Value1,Name2,Value2,...) specifies the settings of
%  the peak labels in Name-Value syntax. Available parameters are:
%   - Parent       : The handle to the axes wherein the labels are to be
%                    created.
%   - String       : The peak label strings. Can be specified as a string scalar
%                    or a cell vector of strings. The vector must have the same
%                    length as px. If specified as a string scalar, then every
%                    peak will be labeled as the specified string. If not
%                    specified, then the string will be created from the vector
%                    px following the format specified by the parameter
%                    StringFormat.
%   - FormatSpec   : An integer vector of the same length as px. Use this
%                    parameter to format each label differently. For example,
%                    [2, 1, 3, 2, ...] specifies that the first and fourth peaks
%                    will be formatted with the second format, the second peak
%                    will be formatted with the first format, and so forth.
%   - StringFormat : String format for the peak labels. This parameter will not
%                    be used if the String parameter is specified. Can be
%                    specified as a string scalar such as '%.2f', or a function
%                    handle. If specified as a string scalar, then all the peak
%                    labels will be formed using sprintf(StringFormat, px(j)).
%                    If specified as a function handle, then each peak label
%                    will be formed by passing px(j) into the function. The
%                    function must take a real number as an input and returns a
%                    string scalar. This parameter can also be specified as a
%                    cell vector of such strings or function handles. In this
%                    case, each peak label with FormatSpec=i will be formed
%                    using sprintf(StringFormat{i}, px(j)) or
%                    StringFormat{i}(px(j)). If both String and StringFormat are
%                    not specified, then the peak label will be printed using
%                    the format '%.1f'.
%   - FontName     : The font type for the peak labels. Can be specified as a
%                    string scalar or vector. If specified as a string scalar,
%                    then the font type of all the peak labels will be set to
%                    FontName. If specified as a string vector, then the font
%                    type of the peak labels with FormatSpec=i will be set to
%                    FontName{i}. If not specified, then the font type will be
%                    the default font type of the text graphics object.
%   - FontSize     : The font size for the peak labels. Can be specified as a
%                    a scalar or a vector of positive real numbers. This
%                    parameter follows the FormatSpec convention described
%                    above. If not specified, then the font size will be the
%                    default font size of the text graphics object.
%   - FontColor    : The font color for the peak labels. Can be specified as an
%                    RGB triplet, a character representing a color, or a cell
%                    vector of such variable type. This parameter follows the
%                    FormatSpec convention described above. If not specified,
%                    then the font color will be the default color of the text
%                    graphics object.
%   - BackgroundColor: The background color of the labels. Can be specified as
%                    an RGB triplet, a string representing a color, or a cell
%                    vector of such variable type. This parameter follows the
%                    FormatSpec convention described above. Defaults to 'none'
%                    if LineWidth is a zero scalar or vector, otherwise defaults
%                    to the background color of the axes.
%   - LineColor    : The color for the vertical lines under each peak label. Can
%                    be specified as an RGB triplet, a character representing a
%                    color, or a cell vector of such variable type. This
%                    parameter follows the FormatSpec convention described
%                    above. If not specified, then the FontColor will be used as
%                    the LineColor.
%   - LineWidth    : The width of the vertical lines under each peak label. Can
%                    be specified as a scalar or a vector of positive real
%                    numbers. This parameter follows the FormatSpec convention
%                    described above. The vertical lines will not be created if
%                    the line width is set to zero. If not specified, then the
%                    line width will be the default plot line width.
%   - MinYPos      : The minimum y position of the peak labels from the x axis.
%                    Specified as a real scalar between 0 and 1. The labels will
%                    be placed at a height no less than
%                    Y_LIM(1)+MinYPos*diff(Y_LIM).
%   - MinYDist     : The minimum y distance of the peak labels from the plot
%                    lines. Specified as a real scalar between 0 and 1. The
%                    labels will be placed above the plot lines with a distance
%                    of at least MinYDist*diff(Y_LIM). Defaults to 0.01.
%   - PlotLine     : The plot lines that must not be crossed by the peak labels.
%                    Can be specified as a 2-by-n (or m-by-2) real matrix, where
%                    the first row (first column) specifies the x data points
%                    and the second row (second column) specifies the y data
%                    points. Can also be specified as an array of graphics
%                    handles to the Line objects contained in the axes. If not
%                    specified, then all the plot lines contained in the axes
%                    will not be crossed by the labels.
%   - ClipRange    : The x ranges where the peak labels are allowed to cross the
%                    plot lines. Can be specified as a two-element real vector
%                    or a cell vector of such vectors.
%
%  [ht,hl]=Label.peak(...) additionally returns the handles to the vertical
%  lines that are drawn below the peak labels.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 09/09/2018
% Last modified: 23/09/2018

%% Input Parsing
S=struct();
k=1;
if k<=nargin && isscalar(varargin{k}) && ...
		(isgraphics(varargin{k},'Axes') || isgraphics(varargin{k},'Polaraxes'))
	ax=varargin{k};
	k=k+1;
else
	ax=gca;
end

if k>nargin
	ht=[];
	return
end

if isrealvector(varargin{k})
	px=varargin{k}(:);
	k=k+1;
else
	error('MatGraphics:Label:peak:InvalidInput',...
		'Input to the peak positions must be a real vector.');
end
N=numel(px);

while k<nargin
	if strcmpi(varargin{k},'Parent')
		x=varargin{k+1};
		if isgraphics(x,'Axes') || isgraphics(x,'Polaraxes')
			ax=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the parent handle must be an axes handle.');
		end
	elseif strcmpi(varargin{k},'String')
		x=varargin{k+1};
		if isstringscalar(x)
			S.String=repmat({x},N,1);
		elseif isstringvector(x)
			S.String=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the label string must be a string scalar or vector.');
		end
	elseif strcmpi(varargin{k},'FormatSpec')
		x=varargin{k+1};
		ME=MException('MatGraphics:Label:peak:InvalidInput',...
			['Input to the format specifier must be a positve integer scalar ',...
				'or a positive integer vector of length equal to the number of ',...
				'peak positions.']);
		if isintegervector(x) && all(x>0)
			if isscalar(x)
				S.FormatSpec=x*ones(N,1);
			elseif numel(x)==N
				S.FormatSpec=x;
			else
				throw(ME);
			end
		else
			throw(ME);
		end
	elseif strcmpi(varargin{k},'StringFormat')
		x=varargin{k+1};
		test=@(y) isstringscalar(y) || isa(y,'function_handle');
		if test(x) || (iscell(x) && all(cellfun(test,x)))
			S.StringFormat=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				['Input to the string format must be a string scalar, ',...
					'a function handle, or a cell vector of strings and ',...
					'function handles.']);
		end
	elseif strcmpi(varargin{k},'FontName')
		x=varargin{k+1};
		if isstringscalar(x) || isstringvector(x)
			S.FontName=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the font name must be a string scalar or vector.');
		end
	elseif strcmpi(varargin{k},'FontSize')
		x=varargin{k+1};
		if isrealvector(x) && all(x>0)
			S.FontSize=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the font size must be a positive real vector.');
		end
	elseif strcmpi(varargin{k},'FontColor')
		x=varargin{k+1};
		test=@(y) (ischar(y) && numel(y)==1) || ...
			(isrealvector(y) && numel(y)==3 && all(y>=0 & y<=1));
		if test(x) || (iscell(x) && all(cellfun(test,x)))
			S.FontColor=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				['Input to the font color must be a character representing ',...
					'a color, an RGB triplet, or a cell vector of such data type.']);
		end
	elseif strcmpi(varargin{k},'BackgroundColor')
		x=varargin{k+1};
		test=@(y) isstringscalar(y) || ...
			(isrealvector(y) && numel(y)==3 && all(y>=0 & y<=1));
		if test(x) || (iscell(x) && all(cellfun(test,x)))
			S.BackgroundColor=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				['Input to the background color must be a string representing ',...
					'a color, an RGB triplet, or a cell vector of such data type.']);
		end
	elseif strcmpi(varargin{k},'LineColor')
		x=varargin{k+1};
		test=@(y) (ischar(y) && numel(y)==1) || ...
			(isrealvector(y) && numel(y)==3 && all(y>=0 & y<=1));
		if test(x) || (iscell(x) && all(cellfun(test,x)))
			S.LineColor=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				['Input to the line color must be a character representing ',...
					'a color, an RGB triplet, or a cell vector of such data type.']);
		end
	elseif strcmpi(varargin{k},'LineWidth')
		x=varargin{k+1};
		if isrealvector(x) && all(x>=0)
			S.LineWidth=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the line width must be a positive real vector.');
		end
	elseif strcmpi(varargin{k},'MinYPos')
		x=varargin{k+1};
		if isrealscalar(x) && x>=0 && x<=1
			S.MinYPos=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the min y pos must be a real scalar between 0 and 1.');
		end
	elseif strcmpi(varargin{k},'MinYDist')
		x=varargin{k+1};
		if isrealscalar(x) && x>=0 && x<=1
			S.MinYDist=x;
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				'Input to the min y dist must be a real scalar between 0 and 1.');
		end
	elseif strcmpi(varargin{k},'PlotLine')
		x=varargin{k+1};
		ME=MException('MatGraphics:Label:peak:InvalidInput',...
			['Input to the plot lines must be either a two-row or two-column ',...
				'real matrix or an array of graphics handles to Line objects.']);
		if isrealmatrix(x)
			if size(x,1)==2
				S.PlotLine=x;
			elseif size(x,2)==2
				S.PlotLine=x.';
			else
				throw(ME);
			end
		end
		if isgraphics(x,'Line')
			S.PlotLine=[x.XData; x.YData];
		else
			throw(ME);
		end
	elseif strcmpi(varargin{k},'ClipRange')
		x=varargin{k+1};
		test=@(y) isrealvector(y) || numel(y)==2;
		if test(x)
			S.ClipRange={sort(x)};
		elseif iscell(x) && all(cellfun(test,x))
			S.ClipRange=cellfun(@sort,x,'UniformOutput',false);
		else
			error('MatGraphics:Label:peak:InvalidInput',...
				['Input to the clip range must be a two-element real vector ',...
					'or a cell vector of such vectors.']);
		end
	else
		error('MatGraphics:Label:peak:UnexpectedInput',...
			'One or more inputs are not recognized.');
	end
	k=k+2;
end

if k<=nargin
	warning('MatGraphics:Label:peak:IgnoredInput',...
		'An extra input argument was provided, but is ignored.');
end

%% Initialize Parameters
yLim=ax.YLim;

if ~isfield(S,'FormatSpec')
	S.FormatSpec=ones(N,1);
end

if ~isfield(S,'String')
	if ~isfield(S,'StringFormat')
		S.StringFormat='%.1f';
	end
	
	S.String=cell(N,1);
	if iscell(S.StringFormat)
		for j=1:N
			if ischar(S.StringFormat{j})
				S.String{j}=sprintf(S.StringFormat{j},px(j));
			else
				S.String{j}=S.StringFormat{j}(px(j));
			end
		end
	elseif ischar(S.StringFormat)
		for j=1:N
			S.String{j}=sprintf(S.StringFormat,px(j));
		end
	else
		for j=1:N
			S.String{j}=S.StringFormat(px(j));
		end
	end
end

if ~isfield(S,'FontName')
	S.FontName=get(groot,'defaultTextFontName');
end

if ~isfield(S,'FontSize')
	S.FontSize=get(groot,'defaultTextFontSize');
end

if ~isfield(S,'FontColor')
	S.FontColor=get(groot,'defaultTextColor');
end

if ~isfield(S,'LineColor')
	S.LineColor=S.FontColor;
end

if ~isfield(S,'LineWidth')
	S.LineWidth=get(groot,'defaultLineLineWidth');
end

if ~isfield(S,'BackgroundColor')
	if all(S.LineWidth==0)
		S.BackgroundColor='none';
	else
		S.BackgroundColor=ax.Color;
	end
end

if isfield(S,'MinYPos')
	S.MinYPos=yLim(1)+S.MinYPos*diff(yLim);
else
	S.MinYPos=yLim(1);
end

if ~isfield(S,'MinYDist')
	S.MinYDist=.01;
end
S.MinYDist=S.MinYDist*diff(yLim);

if ~isfield(S,'PlotLine')
	x=ax.Children(isgraphics(ax.Children,'Line'));
	S.PlotLine=[x.XData; x.YData];
end

% Clip the plot lines
if isfield(S,'ClipRange')
	ix=false(1,size(S.PlotLine,2));
	for x=S.ClipRange
		ix=ix | (S.PlotLine(1,:)>=x{1}(1) & S.PlotLine(1,:)<=x{1}(2));
	end
	S.PlotLine(2,ix)=yLim(1);
end

% Sanitize the plot-line data
[~,ix]=sort(S.PlotLine(2,:),'descend');
S.PlotLine=S.PlotLine(:,ix);
[~,ix]=unique(S.PlotLine(1,:));
S.PlotLine=S.PlotLine(:,ix);

%% Main
% Print peak labels.
pt=S.FormatSpec;
py=zeros(N,1);
for j=N:-1:1
	py(j)=max(S.MinYPos,interp1(S.PlotLine(1,:),S.PlotLine(2,:),px(j)));
	ht(j)=text(ax,px(j),py(j),S.String{j},...
		'HorizontalAlignment','center',...
		'VerticalAlignment','bottom',...
		'Margin',.1);
	if iscell(S.FontName)
		ht(j).FontName=S.FontName{pt(j)};
	else
		ht(j).FontName=S.FontName;
	end
	if isscalar(S.FontSize)
		ht(j).FontSize=S.FontSize;
	else
		ht(j).FontSize=S.FontSize(pt(j));
	end
	if iscell(S.FontColor)
		ht(j).Color=S.FontColor{pt(j)};
	else
		ht(j).Color=S.FontColor;
	end
	if iscell(S.BackgroundColor)
		ht(j).BackgroundColor=S.BackgroundColor{pt(j)};
	else
		ht(j).BackgroundColor=S.BackgroundColor;
	end
end

% Get the extent of the peak labels.
ex=zeros(N,4);
for j=1:N
	ex(j,:)=ht(j).Extent;
end
if strcmpi(ax.XDir,'reverse')
	ex(:,1)=ex(:,1)-ex(:,3);
end
if strcmpi(ax.YDir,'reverse')
	ex(:,2)=ex(:,2)-ex(:,4);
end

% Move labels above the plot lines.
for j=1:N
	y=S.MinYDist+max(S.PlotLine(2,...
		S.PlotLine(1,:)>=ex(j,1) & S.PlotLine(1,:)<=ex(j,1)+ex(j,3)));
	if y>py(j)
		ht(j).Position=[px(j),y];
		ex(j,2)=ex(j,2)+y-py(j);
		py(j)=y;
	end
end

% Sort the labels based on their y positions.
[py,ix]=sort(py);
px=px(ix);
ex=ex(ix,:);
ht=ht(ix);

% Move labels above until it does not intersect with other labels.
% Lower positioned labels are given a higher priority.
for j=2:N
	k=1;
	while k<j
		if ex(j,1)+ex(j,3)>ex(k,1) && ex(j,1)<ex(k,1)+ex(k,3)...
				&& ex(j,2)+ex(j,4)>ex(k,2) && ex(j,2)<ex(k,2)+ex(k,4)
			ex(j,2)=ex(k,2)+ex(k,4);
			py(j)=ex(j,2);
			k=1;
		else
			k=k+1;
		end
	end
	ht(j).Position=[px(j),py(j)];
end

% Reverse the sort.
[~,ix]=sort(ix);
px=px(ix);
py=py(ix);
% ex=ex(ix,:);
ht=ht(ix);

% Draw vertical lines.
if all(S.LineWidth>0)
	for j=N:-1:1
		hl(j)=plot(ax,[px(j),px(j)],[yLim(1),py(j)]);
		if isscalar(S.LineWidth)
			hl(j).LineWidth=S.LineWidth;
		else
			hl(j).LineWidth=S.LineWidth(pt(j));
		end
		if iscell(S.LineColor)
			hl(j).Color=S.LineColor{pt(j)};
		else
			hl(j).Color=S.LineColor;
		end
	end
else
	hl=[];
end

% Bring all the peak labels to front.
for j=1:N
	uistack(ht(j),'top');
end

end