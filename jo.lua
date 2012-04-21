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
                        local mt=getmetatable(t1[k])
                        tableMerge(t1[k] or {}, t2[k] or {})
                        setmetatable(t1[k],mt)
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
    local new={}
    setmetatable(new,{__index=self})
    new._H={}
    setmetatable(new._H,{__index=self._H})
    return new  
  end,
  
  rewriteSlots=function(self,add)
    return tableMerge(self,add)
  end 
}


helpful={
  _H={
    help={_basic="Print help from object internal documentation to console.",_usage="Call\n\n    object:help()\n\nor\n\n    object:help('methodName')"},
    getSlots={_basic="Print list of names of enabled slots to console."}
  },

  help=function(self,theme)
    local chapters=self._H
    
    if not chapters then
       print("No help aviable.")
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
    
    local names={"_basic","_usage","_more","_seealso","_example","_notes","_version"}
    
    for k,v in pairs(names) do
      if chapters[v]~=nil then
        print("##"..string.sub(v,2))
        print(chapters[v])
        print("")
      end
    end
  end,
  
  getSlots=function(self,visited)
    if not visited then
      visited={}
    end
    
    for k,v in pairs(self) do
      if visited[k]==nil then
        print(" - "..k.." ("..type(v)..")")
        visited[k]=1
      end  
    end
    local mt=getmetatable(self)
    if type(mt)=="table" and type(mt.__index)=="table" then
      if type(mt.__index.getSlots)=="function" then
        mt.__index:getSlots(visited)
      end
    end
  end
  
  
}

jo.object:rewriteSlots(jo.helpful)