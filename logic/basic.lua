--
--Skeleton for Svlad's logic
--
module("logic.basic",package.seeall)
require "jo"

logic=jo.object:clone():rewriteSlots({

  init=function(self)
    print("logic:init()")
  end,
  
  close=function(self)
    print("logic:close()")
  end,
  
  tableListChange=function(self,text)
    print("logic:tableListChange("..text..")")
  end,
  
  editCell=function(self,x,y,text)
    print("logic:editCell("..x..", "..y..", "..text..")")
  end,
  
  getCellForEdit=function(self,x,y,text)
    print("logic:getCellForEdit("..x..", "..y..", "..text..")")
    return text
  end,
  
  processQuery=function(self,query)
    print("logic:processQuery("..query..")")
  end,
  
  colHeaderClick=function(self,index)
    print("logic:colHeaderClick("..index..")")
  end,

  rowHeaderClick=function(self,index)
    print("logic:rowHeaderClick("..index..")")
  end

})