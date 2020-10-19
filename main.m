global obj

args = "";

_args = argv();

% Verifies if some argument was passed
% and if it is a octave script
if length(_args) > 0 && _args{1}(end) == 'm'
    args = _args{1}
end

obj = UI(args);

if length(args) == 0
    obj.build();
else
    obj.solve()
end