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

--[[
Allows test classes to create reusable test cases for one or multiple
scenarios.

It works by registering one test method per scenario, where the test method
is named after the test case name and the scenario name. Inspired by PHPUnit
data provider structure.
]]
TestCase = {}
    TestCase.__index = TestCase

    -- constructor
    function TestCase.new() return setmetatable({}, TestCase) end

    -- creates one test method per scenario
    function TestCase:register()
        self.scenarios = self.scenarios or {[''] = {}}
        for scenario, data in pairs(self.scenarios) do
            local methodName = 'test_' .. self.name .. (scenario ~= '' and (':' .. scenario) or '')
            if self.testClass[methodName] then error('Test method already exists: ' .. methodName) end
            self.testClass[methodName] = function()
                if type(data) == "function" then
                    data = data()
                end
                self.execution(data)
            end
        end
    end

    -- setters
    function TestCase:setExecution(value) self.execution = value return self end
    function TestCase:setName(value) self.name = value return self end
    function TestCase:setScenarios(value) self.scenarios = value return self end
    function TestCase:setTestClass(value) self.testClass = value return self end
-- end of TestCase

dofile('./tests/spies.lua')

dofile('./tests/%Addon%Test.lua')

lu.ORDER_ACTUAL_EXPECTED=false

os.exit(lu.LuaUnit.run())