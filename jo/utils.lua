module("jo.utils",package.seeall)
require "jo"

singleton={
  clone=function(self)
    error("One doesn't simply clone singleton.")
    return false
  end
}

function validateSlots(o,t)
  for k,v in pairs(t) do
    if type(o[k])~=v then
      return false
    end
  end
  return true
end