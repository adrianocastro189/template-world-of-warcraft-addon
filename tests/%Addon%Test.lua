TestAddonTable = BaseTestClass:new()

-- @covers AddonTable
TestCase.new()
    :setName('addon table')
    :setTestClass(TestAddonTable)
    :setExecution(function()
        lu.assertNotIsNil(AddonTable)
    end)
    :register()
-- end of TestAddonTable
