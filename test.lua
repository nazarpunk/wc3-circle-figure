local t = {}

t[3] = 1;
t[2] = nil;
t[1] = 1;
for k, v in pairs(t) do
    print(k, v)
end