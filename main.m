global obj

args = argv();

obj = UI(args);

if length(args) == 0
    obj.build();
else
    obj.solve()
end






