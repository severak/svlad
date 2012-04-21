module("jo.geometry",package.seeall)

require "math"
require "jo"
require "jo.utils"
require "string"

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

color=jo.object:clone():rewriteSlots({
  r=255,
  g=255,
  b=255,
  
  getHexa=function(self)
    return string.format("#%02x%02x%02x",self.r,self.g,self.b)
  end,
  
  setHexa=function(self,hexa)
    if hexa:len()==7 and hexa:sub(1,1)=="#" then
      self.r=tonumber(hexa:sub(2,3),16)
      self.g=tonumber(hexa:sub(4,5),16)
      self.b=tonumber(hexa:sub(6,7),16)
    end
    return self
  end,
  
  --RGB to HSV conversion taken from http://alvyray.com/Papers/CG/hsv2rgb.htm
  
  toHSV=function(self)
    local x=math.min(self.r,self.g,self.b)
    local v=math.max(self.r,self.g,self.b)
    if v==x then
      return nil,0,v
    end
    if self.r==x then
      f=self.g-self.b
    else
      if self.g==x then
        f=self.b-self.r
      else
        f=self.r-self.g
      end
    end
    if self.r==x then
      i=3
    else
      if self.g==x then
        i=5
      else
        i=1
      end
    end
    return (i-f/(v-x)),((v-x)/v),v
  end,
  
  --HSV to RGB conversion taken from http://alvyray.com/Papers/CG/hsv2rgb.htm
  
  toRGB=function(self,h,s,v)
    if h==nil then
      self.r,self.g,self.b=v,v,v
    end
    i=math.floor(h)
    f=h-i
    if i%2==0 then
      f=1-f
    end
    m=v*(1-s)
    n=v*(1-s*f)
    if i==6 or i==0 then
      self.r,self.g,self.b=v,n,m
    elseif i==1 then
      self.r,self.g,self.b=n,v,m
    elseif i==2 then
      self.r,self.g,self.b=m,v,n
    elseif i==3 then 
      self.r,self.g,self.b=m,n,v
    elseif i==4 then
      self.r,self.g,self.b=n,m,v
    elseif i==5 then
      self.r,self.g,self.b=v,m,n
    end
    return self
  end
})