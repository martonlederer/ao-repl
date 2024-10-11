-- This is for aop6 Boot Loader
-- See: https://github.com/permaweb/aos/issues/342
-- For the Process as the first Message, if On-Boot
-- has the value 'data' then evaluate the data
-- if it is a tx id, then download and evaluate the tx

local drive = { _version = "0.0.1" }

function drive.getData(txId)
  local file = io.open('/data/' .. txId)
  if not file then
    return nil, "File not found!"
  end
  local contents = file:read(
    file:seek('end')
  )
  file:close()
  return contents
end

return function (ao)
  local eval = require(".eval")(ao)
  return function (msg)
    if msg.Tags['On-Boot'] == nil then
      return
    end
    if msg.Tags['On-Boot'] == 'Data' then
      eval(msg)
    else
      local loadedVal = drive.getData(msg.Tags['On-Boot'])
      eval({ Data = loadedVal })
    end
  end 
end