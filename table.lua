local t = { 1, 2, 3 }

t[2] = nil;
print(#t);

for k, v in pairs(t) do
    print(k, v);
end



