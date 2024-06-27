AddonTable = StormwindLibrary_vx_y_z.new({
    colors = {
      primary = '%hexadecimalColor%'
    },
    command = '%command%',
    data = '%Table%',
    name = '%addonName%'
  })

local events = AddonTable.events

events:listen(events.EVENT_NAME_PLAYER_LOGIN, function ()
    -- %code here%
end)