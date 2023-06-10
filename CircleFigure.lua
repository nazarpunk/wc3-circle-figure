MyClass = Class()

function MyClass:init()
    self.members = {}
end

function MyClass:__newindex(index, value)
    if index == "testMember" then
        self.members[index] = value
        print("Set member " .. index .. " to " .. value)
    else
        rawset(self, index, value)
    end
end

function MyClass:__index(index)
    if index == "testMember" then
        print("Getting " .. index)
        return self.members[index]
    else
        return rawget(self, index)
    end
end

foo = MyClass()

foo.testMember = 5
foo.testMember = 2

print(foo.testMember)