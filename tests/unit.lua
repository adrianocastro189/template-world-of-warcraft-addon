lu = require('luaunit')

--[[
This is a base test class that sets up the addon table before each test.

Every test class should inherit from this class to have the addon set up
before each test. That way, mocking the addon methods and properties on tests
won't affect the results of other tests.

The setUp() method is expected to be called before each test.
]]
BaseTestClass = {
    new = function(self)
        local instance = {}
        setmetatable(instance, self)
        self.__index = self
        return instance
    end,
    
    setUp = function()
        -- this makes the Environment class to return the proper client flavor when
        -- running this test suite
        _G['TEST_ENVIRONMENT'] = true

        dofile('./tests/wow-mocks.lua')

        dofile('./lib/stormwind-library.lua')

        dofile('./%Addon%.lua')

        -- %Table% = nil
        AddonTable.events:handleOriginal(nil, 'PLAYER_LOGIN')
        AddonTable.output:setTestingMode()

        function dd(...) AddonTable:dd(...) end
    end,

    -- guarantees that every test class inherits from this class by forcing
    -- the global addon usages to throw an error if it's not set, so tests
    -- that miss inheriting from this class will fail
    tearDown = function()
        AddonTable = nil
    end,
}

dofile('./tests/%Addon%Test.lua')

lu.ORDER_ACTUAL_EXPECTED=false

os.exit(lu.LuaUnit.run())