function S=tiledaxes(varargin)

P=inputParser;
f=@(x)isintegerscalar(x) && x>0;
P.addRequired('NumRows',f);
P.addRequired('NumColumns',f);
P.addRequired('AxesSize',...% [width, height]
	@(x)isrealvector(x) && numel(x)==2 && all(x>0));
f=@(x)isrealvector(x) && numel(x)==4;
P.addOptional('AxesMargin',zeros(1,4),f);% [top, right, bottom, left]
P.addOptional('ContainerMargin',zeros(1,4),f);% [top, right, bottom, left]
P.addOptional('ContainerPadding',zeros(1,4),f);% [top, right, bottom, left]
P.addOptional('PaperPadding',zeros(1,4),f);% [top, right, bottom, left]
P.parse(varargin{:});
P=P.Results;

M=P.NumRows;
N=P.NumColumns;
w=sum(P.AxesMargin([2,4]))+P.AxesSize(1);
h=sum(P.AxesMargin([1,3]))+P.AxesSize(2);
S=struct();
S.NumRows=M;
S.NumColumns=N;
S.Axes.Width=P.AxesSize(1);
S.Axes.Height=P.AxesSize(2);
S.Axes.Position=cell(M,N);
S.Container.Width=sum(P.ContainerPadding([2,4]))+N*w;
S.Container.Height=sum(P.ContainerPadding([1,3]))+M*h;
S.Container.Position=[...
	P.ContainerMargin(4)+P.PaperPadding(4),...
	P.ContainerMargin(3)+P.PaperPadding(3),...
	S.Container.Width,S.Container.Height];
x=S.Container.Position(1)+P.ContainerPadding(4)+P.AxesMargin(4);
y=S.Container.Position(2)+P.ContainerPadding(3)+P.AxesMargin(3);
for i=1:M
	for j=1:N
		S.Axes.Position{i,j}=[x+(j-1)*w,y+(M-i)*h,P.AxesSize];
	end
end
S.Paper.Width=sum(S.Container.Position([1,3])) ...
	+P.ContainerMargin(2)+P.PaperPadding(2);
S.Paper.Height=sum(S.Container.Position([2,4])) ...
	+P.ContainerMargin(1)+P.PaperPadding(1);
S.Paper.Position=[0,0,S.Paper.Width,S.Paper.Height];

end