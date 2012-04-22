require "math"
require "jo.geometry"

col=jo.geometry.color:clone()

for u=0,360,0.2 do
  rad=math.rad(u)
  for r=1,255 do
    x=math.cos(rad)*r*0.8
    y=math.sin(rad)*r*0.8
    col:toRGB(rad,1,255-r)
    color(col.r,col.g,col.b)
    point(x+320,y+240)
  end    
end

pause()