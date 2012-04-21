require "jo"

helpful={
  help=function(self)
    for k,v in pairs(self._H) do
      print(string.upper(k))
      print(v)
      print("")
    end
  end
}

animal=jo.object:clone():rewriteSlots({
  living=true,
  name="animal",
  breath=function(self)
    print(self.name..": Aaaach!")
  end,
  _H={_Name="an animal",_basic="An animal."}
  
})

bird=animal:clone():rewriteSlots({
  name="bird",
  beep=function(self)
     print(self.name..":Tweeet!")
  end,
  _H={_Name="a bird"}
})

crow=bird:clone():rewriteSlots({
  color="black",
  beep=function(self)
     print(self.name..":Crou! Crou!")
  end,
  _H={_Name="a crow",_usage="Can beep and breath."}
})

Jarku=crow:clone()
Jarku.name="Jarku"

Jarku:breath()
Jarku:beep()
print("Jarku is "..Jarku.color..".")

--Jarku:rewriteSlots(jo.helpful):help()

