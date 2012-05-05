module("logic.sqlite",package.seeall)
require "jo"
require "luasql.sqlite3"
original=require "logic.basic"

function showresult(dotaz)
  res=assert(conn:execute(dotaz))
  if type(res)=="number" then
    VCL.ShowMessage("Zmeneno "..res.." radek.")
  else
    cnames=res:getcolnames()
    tabl.colCount=#cnames+1
    tabl.rowCount=1
    for k,v in pairs(cnames) do
      tabl:SetCell(k,0,v)
    end
    row=res:fetch({})
    while row do
      r=tabl:AddRow()
      tabl:SetCell(0,r,r)
      for k,v in pairs(row) do
        tabl:SetCell(k,r,v)
      end
      row=res:fetch(row)   
    end
    res:close()
  end
end


logic=original:rewriteSlots({

   init=function(self)
      env=luasql.sqlite3()
      conn=assert(env:connect("prachy.db3"))
   end,

   processQuery=function(self,sql)
      passed,mesg=pcall(showresult,dotaz)
      if not passed then
        VCL.ShowMessage(mesg)  
      end  
   end  

})