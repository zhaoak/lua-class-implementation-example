-- ===============================================================================================
-- SIMPLE CLASS IMPLEMENTATION
-- An example of a simple single class implemented in Lua, with no inheritance or class extension functionality
-- =======================================
local Class = {} -- table representing the class, which doubles as the metatable for the instances of the class
Class.__index = Class -- failed table lookups on the instance should fall back to the class table, to access the methods defined there (unless the instance has overloaded them!)

-- function for creating a new class instance--the constructor, if you will
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
print("simple class test code \n================")
local classInstance = Class.new("here's the data!!")
-- notice that since `self` is the first variable, we can use's lua's function call operator `:`,
-- where instad of having to call the instance's method _and_ pass in the instance as an arg, e.g. `classInstance.get_value(classInstance)`,
-- we can use classInstance:get() to implicitly pass the instance itself as the first arg
-- we can also do this when defining Class's `set/get_value()` funcs and skip passing in `self` as the first arg,
-- I just haven't here for ease of understanding

classInstance:set_value("set the value in the class with the setter!!!")
print(classInstance:get_value())
print("================")

-- ===========================================================================================
-- BASE AND INHERITED CLASS IMPLEMENTATION
-- An example of a base class and a class extended from that base class implemented in Lua
-- ===============================================
local BaseClass = {} -- table representing the class, doubles as metatable for instances of the base class
BaseClass.__index = BaseClass -- failed table lookups on the instance should fall back to the class table, to access the methods defined there (unless the instance has overloaded them!)

-- set the metatable for the base class
setmetatable(BaseClass, {
  -- `__call` is the function executed when you call the a table like a function, i.e. `BaseClass()`, 
  -- which we'll use as a constructor for new BaseClass instances
  __call = function (cls, ...) 
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})
