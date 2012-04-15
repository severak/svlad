module('jo',package.seeall)

--author: Anonymous
--License: MIT/X11
--http://snippets.luacode.org/snippets/Deep_copy_of_a_Lua_Table_2
function deepcopy(t)
    if type(t) ~= 'table' then return t end
    local mt = getmetatable(t)
    local res = {}
    for k,v in pairs(t) do
      if type(v) == 'table' then
        v = deepcopy(v)
      end
      res[k] = v
    end
    setmetatable(res,mt)
    return res
end

--author: RCIX from stackoverflow
--based on code by Doug Currie
--http://stackoverflow.com/questions/1283388/lua-merge-tables
function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
                if type(t1[k] or false) == "table" then
                        tableMerge(t1[k] or {}, t2[k] or {})
                else
                        t1[k] = v
                end
        else
                t1[k] = v
        end
    end
    return t1
end

--author: Steven Donovan
--license: MIT/X11
--http://snippets.luacode.org/snippets/Simple_Table_Dump_7
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

object={
--documentation-----------------------------------------------------------------  
  _H={
    _Name="jo.object",
    _basic="Basic jo object. It can be also some it's undocumented descendants.",
    _usage=
[[Clone this object by

    newInstance=jo.object:clone()

then you can change it by calling rewriteSlots function with an change table parameter

    newInstance:rewriteSlots({changed=1})
]],
    clone={
      _Name="clone()",
      _basic="Clones object. Returns its clone.",
      _example=" \n    clonedObject=someObject:clone()"
    },
    rewriteSlots={
      _Name="rewriteSlots(t)",
      _basic="Merges object with its parameter t. Used to adding new features.",
      _example=
[[
    --changes color and adds new function getColor
    --assume that oldObject.color="red"
    oldObject:rewriteSlots({
      color="blue",
      getColor=function(self)
        return self.color
      end
    })
]]
    }    
  },
--------------------------------------------------------------------------------  
  clone=function(self)
    local new=deepcopy(self)
    return new  
  end,
  
  rewriteSlots=function(self,add)
    return tableMerge(self,add)
  end 
}


helpful={
  help=function(self,theme)
    local chapters=self._H
    
    if not chapters then
       return false
    end
    
    if theme then
      if chapters[theme] then
        chapters=chapters[theme]
      else
         print("Undocumented feature or missing function. Object help shown instead.")
      end
    end
    
    if chapters._Name~=nil then
      print(chapters._Name)
      print(string.rep("=",string.len(chapters._Name)))
    end
    
    for k,v in pairs(chapters) do
      if string.sub(k,1,1)=="_" and k~="_Name" then
        print("##"..string.sub(k,2))
        print(v)
        print("")
      end
    end
  end
}

jo.object:rewriteSlots(jo.helpful)