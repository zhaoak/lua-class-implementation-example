-- ===============================================================================================
-- SIMPLE CLASS IMPLEMENTATION
-- An example of a simple single class implemented in Lua, with no inheritance or class extension functionality
-- =======================================
local Class = {} -- table representing the class itself (not its instances), which doubles as the metatable for the instances of the class. You can think of it as where the class's static data/methods are stored
Class.__index = Class -- failed table lookups on the instance should fall back to the "static" class table, to access the methods defined there (unless the instance has redefined them!)
-- `__index` is a metamethod; when you call `table[key]` and Lua can't find a value in `table`:
--    1. if `__index` is set to a different table, Lua looks for `key` in that different table, and returns it if it's there
--      1a, 1b, 1c... if Lua can't find `key` in that different table, it calls the different table's `__index` metamethod
--    2. if `__index` is set to a function, it calls that function and returns its value

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
-- BASE CLASS ===================================
local BaseClass = {} -- table representing the base class, doubles as metatable for instances of the base class
BaseClass.__index = BaseClass -- failed table lookups on the instance should fall back to the "static" class table, to access the methods defined there (unless the instance has redefined them!)

-- set the metatable for the base class we defined on line 48
setmetatable(BaseClass, {
  -- `__call` is a Lua metamethod; it's the function executed when you call the a table like a function, i.e. `BaseClass()`, 
  -- so here, we're telling Lua to call the constructor for new BaseClass instances when we call `BaseClass()`.
  -- Notice how we also call BaseClass:construct(initialValue), to set `.value` for the instance.
  -- `__call` always also passes in the table you called like a function as the first arg,
  -- so when we call `BaseClass(initialValue)`, `thisTable` is the table `BaseClass` as defined on line 48
  __call = function (thisTable, ...) 
    local self = setmetatable({}, thisTable)
    -- if you're not familiar with the ... operator,
    -- it's essentially Lua shorthand for "all other arguments passed into the function not explicitly named"
    -- We're using it here to pass on the value from `BaseClass(initialValue)` to `BaseClass:construct(initialValue)`
    self:construct(...)
    return self
  end,
})

-- This is the code that actually sets `.baseClassValue` in the instance to what you passed as the arg to `BaseClass()`
-- It functions the exact same as the `Class.new()` function above,
-- just using the `:` operator instead of `.` for the function call
function BaseClass:construct(initialValue)
  self.baseClassValue = initialValue
end

-- Same story with this and `BaseClass:get_value()`
function BaseClass:set_value(newVal)
  self.baseClassValue = newVal
end

function BaseClass:get_value()
  return self.baseClassValue
end

print("base class example code \n================")
print("Address of BaseClass metatable: "..tostring(BaseClass))
-- making a new instance of our BaseClass and setting and getting its value like with the simple class.
-- Notice how we're using the `:` operator for the function calls instead of `.`,
-- so we can avoid having to pass in the instance as the first arg.
local baseClassInstance = BaseClass("This string is passed into the BaseClass constructor and used as its initial value")
baseClassInstance:set_value("and then it gets overwritten by this one before printing, so you see just this one")
print(baseClassInstance:get_value())

print("================")

-- EXTENDED CLASS ==============================================
local ExtendedClass = {} -- table that represents the extended-from-BaseClass class, once again doubles as ExtendedClass instance metatable
ExtendedClass.__index = ExtendedClass -- if you can't find a method in the ExtendedClass instance, look in the ExtendedClass metatable for it

-- set the metatable for ExtendedClass
setmetatable(ExtendedClass, {
  -- This line right below these comments? This is what makes the inheritance work.
  -- since Lua can't find `BaseClass` methods in the `ExtendedClass` table (line 95),
  -- setting `__index` here tells Lua to look in `BaseClass` for keys and methods it can't find in `ExtendedClass`
  -- This then allows `ExtendedClass` to use `BaseClass` methods.
  __index = BaseClass,
  __call = function(thisTable, ...)
    local self = setmetatable({}, thisTable)
    self:construct(...)
    return self
  end
})

-- The constructor for ExtendedClass instances. Notice that we also need to pass in a value for BaseClass,
-- since ExtendedClass inherits its functionality
function ExtendedClass:construct(baseClassInitialValue, extendedClassInitialValue)
  BaseClass:construct(baseClassInitialValue)
  self.extendedClassValue = extendedClassInitialValue
end

-- Gets the sum of BaseClass's value plus ExtendedClass's value.
function ExtendedClass:getBasePlusExtendedClassValue()
  return self.extendedClassValue + self.baseClassValue
end

-- If you wanted to write a function to retrieve/set just the value of ExtendedClass, you could.
-- It's omitted here for the sake of brevity.

print("Extended class example code \n================")
print("Address of ExtendedClass metatable: "..tostring(ExtendedClass))
local extendedClassInstance = ExtendedClass(3, 4)
print(extendedClassInstance:get_value()) -- will get the value held by BaseClass, not ExtendedClass, since it's calling a BaseClass method
print(extendedClassInstance:getBasePlusExtendedClassValue()) -- will output 7
