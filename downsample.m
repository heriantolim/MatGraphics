function A=downsample(A,varargin)
%% Downsample
%  B=downsample(A,N) scales down every dimension of A to N. Each element in the
%  new array is the median value of every N-by-N-by-... sub-array of A.
%
%  B=downsample(A,n1,n2,...) scales down each dimension of A to n1, n2, ...,
%  respectively.
%
%  B=downsample(A,...,f) maps the sub-array of A using the specified function
%  instead of median. Input f as a function handle.
%
% Outputs:
%  A scaled-down array with size equal to min(size(A),[n1,n2,...])
%
% Tested on:
%  - MATLAB R2018a
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 15/04/2018
% Last modified: 15/04/2018

%% Input Parsing
assert(isnumeric(A),...
	'MatGraphics:downsample:InvalidInput',...
	'Input to the sample array must be numeric.');
S=size(A);
D=numel(S);

ME1=MException('MatGraphics:downsample:InvalidInput',...
	['Input to the new sample dimensions must be either positive integer ',...
		'scalars or a positive integer vector with length equal to the ',...
		'number of dimensions of the sample array.']);
k=numel(varargin);
if k==0
	error('MatGraphics:downsample:WrongNargin',...
		'At least two input arguments are required.');
elseif isintegervector(varargin{1}) && all(varargin{1}>0)
	if k>1 && isa(varargin{k},'function_handle')
		f=varargin{k};
		k=k-1;
	else
		f=@median;
	end
	ME2=MException('MatGraphics:downsample:WrongNargin',...
		'Incorrect number of input arguments.');
	if isscalar(varargin{1})
		if k==1
			N=varargin{1}*ones(1,D);
		elseif k~=D
			throw(ME2);
		elseif all(cellfun(@isintegerscalar,varargin(1:k)))
			N=cell2mat(varargin(1:k));
		else
			throw(ME1);
		end
	elseif k~=1
		throw(ME2);
	elseif numel(varargin{1})==D
		N=varargin{1};
	else
		throw(ME1);
	end
else
	throw(ME1);
end

if prod(S)<=1
	return
end

%% Array Slicing
M=cell(1,D);
for k=1:D
	if N(k)==1
		M{k}=S(k);
	elseif S(k)<=N(k)
		M{k}=ones(1,S(k));
	elseif N(k)==2
		m=S(k)/2;
		M{k}=[ceil(m),floor(m)];
	else
		d=floor(S(k)/N(k));
		m=S(k)-d*N(k);
		if m==0
			M{k}=d*ones(1,N(k));
		else
			if m+d>N(k)-2
				d=d+1;
				m=S(k)-d*N(k);
			end
			m=m/2+d;
			M{k}=[ceil(m),d*ones(1,N(k)-2),floor(m)];
		end
	end
end
A=mat2cell(A,M{:});

%% Array Mapping
for k=1:numel(A)
	A{k}=A{k}(:);
end

try
	A=cellfun(f,A);
catch ME1
	if isempty(regexp(ME1.identifier,':NotAScalarOutput$','once'))
		throw(ME1);
	else
		error('MatGraphics:downsample:NotAScalarOutput',...
			'The mapping function must return a numeric scalar.');
	end
end

end