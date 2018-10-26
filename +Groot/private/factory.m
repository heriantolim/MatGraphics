function factory()

prop=Groot.findprop();
for i=1:numel(prop)
	set(groot,['default',prop{i}],'remove');
end

end