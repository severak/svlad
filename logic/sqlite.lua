module("logic.sqlite",package.seeall)
require "jo"
require "luasql.sqlite3"
original=require "logic.basic"

function showresult(conn,dotaz)
  res=assert(conn:execute(dotaz))
  if type(res)=="number" then
    VCL.ShowMessage("Zmeneno "..res.." radek.")
  else
    local rowids={}
    local cols={}
    cnames=res:getcolnames()
    for k,v in pairs(cnames) do
      GUI.setCell(k,0,v)
    end
    row=res:fetch({})
    local r=1
    while row do
      GUI.setCell(0,r,r)
      rowids[r]=row[1]
      for k,v in pairs(row) do
        GUI.setCell(k,r,v)
      end
      row=res:fetch(row)
      r=r+1   
    end
    res:close()
    return rowids,cnames
  end
end

function in_table ( e, t )
  for _,v in pairs(t) do
    if (v==e) then return true end
  end
  return false
end

function rows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    local data=cursor:fetch()
    if data then
      return data
    else
      cursor:close()
    end
  end
end

logic=original.logic:rewriteSlots({

   tables={},
   prevX=0,
   prevY=0,
   prevTxt="",
   rowids={},
   cols={},

   init=function(self)
      dbname="svlad.db3"
      if arg[2] then
        dbname=arg[2]
      end
      env=luasql.sqlite3()
      self.db=assert(env:connect(dbname))
      for name in rows(self.db,"SELECT name FROM sqlite_master WHERE type='table'") do
        self.tables[#self.tables+1]=name
      end
      GUI.setTableList(self.tables)
   end,
   
   tableListChange=function(self,name)
      GUI.resetTable()
      if in_table(name,self.tables) then
        --print("SELECT * FROM "..name)
        self.rowids,self.cols=showresult(self.db,"SELECT rowid, * FROM "..name.." LIMIT 500")  
      end
      self.table=name
      self.editable=true
   end,
    
   processQuery=function(self,sql)
      GUI.resetTable()
      self.editable=false
      passed,mesg=pcall(showresult,self.db,dotaz)
      if not passed then
        VCL.ShowMessage(mesg)  
      end  
   end,
   
   editCell=function(self,x,y,v)
    if x==self.prevX and y==self.prevY then
      if self.prevTxt==v then
        if self.editable then
          print(string.format("UPDATE %s SET %s=%q WHERE rowid=%i",self.table,self.cols[x],v,self.rowids[y]))
        end
      end
      self.prevTxt=v
    else
      --print("Zmena cor",x,y,v)
      self.prevX=x
      self.prevY=y
    end
   end,
   
   close=function(self)
      self.db:close()
   end  

})