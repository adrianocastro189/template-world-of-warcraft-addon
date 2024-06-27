TestAddonTable = BaseTestClass:new()
    -- @covers AddonTable
    function TestAddonTable:testMainAddonFile()
        lu.assertNotIsNil(AddonTable)
    end
-- end of MultiTargetsTest