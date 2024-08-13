-- ===============================================================================================
-- SIMPLE CLASS IMPLEMENTATION
-- An example of a simple single class implemented in Lua, with no inheritance or class extension functionality
-- =======================================
local Class = {} -- table representing the class itself (not its instances), which doubles as the metatable for the instances of the class. You can think of it as where the class's static data/methods are stored
Class.__index = Class -- failed table lookups on the instance should fall back to the "static" class table, to access the methods defined there (unless the instance has redefined them!)

-- Function for creating a new class instance--the constructor, if you will
-- Here, we've defined it as `Class.new()`, but it's possible to make it just `Class()`;
-- see the comments for BaseClass below for how
function Class.new(init)
  local self = setmetatable({}, Class) -- sets the table from line 5 as the new instance's metatable
  self.value = init -- .value is the key we're using to store arbitrary data in the class instance, you can use as many keys to store data as you wish
  return self -- then return the instance
end

-- setter func for the setting a class instance's data
function Class.set_value(self, newval)
  self.value = newval
end

-- getter func for getting a class instance's data
function Class.get_value(self)
  return self.value
end

-- making a new instance of our class!
print("simple class example code \n================")
local classInstance = Class.new("here's the data!!")

-- notice that since `self` is the first variable, we can use's lua's function call operator `:`,
-- where instad of having to call the instance's method _and_ pass in the instance as an arg, e.g. `classInstance.get_value(classInstance)`,
-- we can use classInstance:get() to implicitly pass the instance itself as the first arg
-- we could have also done this when defining Class's `set/get_value()` funcs and skipped passing in `self` as the first arg,
-- I just haven't here for ease of understanding
classInstance:set_value("set the value in the class with the setter!!!")
print(classInstance:get_value())
print("================")

-- ===========================================================================================
-- BASE AND EXTENDED CLASS IMPLEMENTATION
-- An example of a base class and a class extended from that base class implemented in Lua
-- ===============================================
local BaseClass = {} -- table representing the base class, doubles as metatable for instances of the base class
BaseClass.__index = BaseClass -- failed table lookups on the instance should fall back to the "static" class table, to access the methods defined there (unless the instance has redefined them!)

-- set the metatable for the base class
setmetatable(BaseClass, {
  -- `__call` is a Lua metamethod; it's the function executed when you call the a table like a function, i.e. `BaseClass()`, 
  -- So here, we're telling Lua to call the constructor for new BaseClass instances when we call `BaseClass()`.
  -- Notice how we also call BaseClass:construct(initialValue), to set `.value` for the instance.
  __call = function (cls, ...) 
    local self = setmetatable({}, cls)
    -- if you're not familiar with the ... operator,
    -- it's essentially Lua shorthand for "all other arguments passed into the function not explicitly named"
    -- We're using it here to pass the value from `BaseClass(initialValue)` to `BaseClass:construct(initialValue)`
    self:construct(...)
    print("Address of BaseClass metatable: "..tostring(cls))
    return self
  end,
})

-- This is the code that actually sets `.value` in the instance to what you passed into the constructor
-- It's the same as the `Class.new()` function above, just using the `:` operator instead of `.` for the function call
function BaseClass:construct(initialValue)
  self.value = initialValue
end

-- Same story with this and `BaseClass:get_value()`
function BaseClass:set_value(newVal)
  self.value = newVal
end

function BaseClass:get_value()
  return self.value
end

print("base class example code \n================")

-- making a new instance of our BaseClass and setting and getting its value like with the simple class.
-- Notice how we're using the `:` operator for the function calls instead of `.`,
-- so we can avoid having to pass in the instance as the first arg.
local baseClassInstance = BaseClass("This string is passed into the BaseClass constructor and used as its initial value")
baseClassInstance:set_value("and then it gets overwritten by this one before printing, so you see just this one")
print(baseClassInstance:get_value())

print("Address of BaseClass metatable: "..tostring(BaseClass))
print("================")
