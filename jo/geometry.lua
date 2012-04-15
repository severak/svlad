module("jo.geometry",package.seeall)

require "math"
require "jo"
require "jo.utils"

point=jo.object:clone():rewriteSlots({
  x=0,
  y=0,
  
  with=function(self,x,y)
    self.x=x
    self.y=y
    return self
  end,
  
  distanceFrom=function(self,b)
    if jo.utils.validateSlots(b, { x="number",y="number" }) then
      return math.sqrt(math.pow(self.x-b.x,2)+math.pow(self.y-b.y,2))
    end
    return nil
  end
  
})

vector=jo.object:clone():rewriteSlots({
  sx=0,
  sy=0,
  
  

})