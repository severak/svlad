--
--example/test logic
--
--some well known mathematical things
--
module("logic.example",package.seeall)
basic=require "logic.basic"

function showCoords()
  for x=0,100 do
    for y=0,100 do
      GUI.setCell(x,y,x.."x"..y)
    end
  end
end

function showMulti()
  for x=0,20 do
    for y=0,20 do
      if x==0 or y==0 then
        if x==0 then
          GUI.setCell(x,y,y)
        else
          GUI.setCell(x,y,x)  
        end
      else
        GUI.setCell(x,y,x*y)
      end 
    end
  end
end

function showPascal()
  pascal={}
  for x=0,20 do
    pascal[x]={}
    for y=0,20 do
      if x==0 or y==0 then
        pascal[x][y]=1
      else
        pascal[x][y]=pascal[x-1][y]+pascal[x][y-1]  
      end
      GUI.setCell(x,y,pascal[x][y])
    end
  end
end

logic=basic.logic:rewriteSlots({
  modes={"Coordinations","Multiplication table","Pascal triangle"},
  
  init=function(self)
    GUI.setTableList(self.modes)
  end,
  
  tableListChange=function(self,mode)
    GUI.resetTable()
    if mode==self.modes[1] then
      showCoords()
    elseif mode==self.modes[2] then
      showMulti()
    elseif mode==self.modes[3] then
      showPascal()
    end
  end
})