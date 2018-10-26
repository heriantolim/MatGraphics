function h=docfigure(size,varargin)
%% Create Figure for Documents
%  h=docfigure(size) creates a figure with the specified size=[width,height] and
%  returns the figure handle. The PaperSize of the figure is set to be equal to
%  size, the Position and PaperPosition of the figure are set to [0,0,size]. The
%  Units of the figure is set to be equal to its PaperUnits.
%
%  h=docfigure(size,Name1,Value1,Name2,Value2) sets other figure properties in
%  Name-Value syntax. Setting the Position, PaperPosition, or PaperSize,
%  however, is not allowed and will return an error. Setting the Units will also
%  set the PaperUnits to the same value. Likewise, setting the PaperUnits will
%  also set the Units to the same value. The allowed values for the Units are
%  restricted to those of the PaperUnits.
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 07/04/2018
% Last modified: 07/04/2018

assert(isrealvector(size) && numel(size)==2 && all(size>0),...
	'MatGraphics:docfigure:InvalidInput',...
	'Input to the size must be a vector of two positive real numbers.');
size=reshape(size,1,2);

P=inputParser;
P.KeepUnmatched=true;
P.addParameter('Units','');
P.addParameter('PaperUnits','');
P.addParameter('Position',[],@(x)false);
P.addParameter('PaperPosition',[],@(x)false);
P.addParameter('PaperSize',[],@(x)false);
try
	P.parse(varargin{:});
catch ME1
	if isempty(regexp(ME1.identifier,'FailedValidation$','once'))
		error('MatGraphics:docfigure:InvalidInput',...
			['Setting the PaperSize, Position, or PaperPosition property via ',...
				'the Name-Value arguments is not allowed.']);
	else
		error('MatGraphics:docfigure:UnexpectedInput',...
			'One or more inputs are not recognized.');
	end
end
R=P.Results;
P=P.Unmatched;

if isempty(R.PaperUnits)
	if isempty(R.Units)
		P.PaperUnits=get(groot,'defaultFigurePaperUnits');
	else
		P.PaperUnits=R.Units;
	end
end
P.Units=P.PaperUnits;

P.Position=[0,0,size];
P.PaperPosition=P.Position;
P.PaperSize=size;

h=figure(P);

end
