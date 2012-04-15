--Skeleton SVLADa
require "vcl"
require "luasql.sqlite3"

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

function sql_dotaz(sender)
  dotaz=table.concat(sql:GetText())
  passed,mesg=pcall(showresult,dotaz)
  if not passed then
    VCL.ShowMessage(mesg)  
  end
end

function listtables()
  showresult("SELECT * FROM sqlite_master")
end

function appEnd()
  conn:close()
  --main:Free()
end

env=luasql.sqlite3()
conn=assert(env:connect("prachy.db3"))


main=VCL.Form("mainWin")
main._={ caption="Svlad", width=500, height=500, onshow="listtables", onclose="appEnd" }

tabl=VCL.StringGrid(main,"table")
tabl._={ align="alClient", rowCount=99, ColCount=99,  AutoEdit=1 }

p=VCL.Panel(main,"panel")
p._={ align="alBottom", height=90 }

sql=VCL.Memo(p,"sql")
sql._={ align="alClient",  font={name="Courier"} }

fire=VCL.Button(p,"fire")
fire._={ align="alBottom", caption="PAL!", onclick="sql_dotaz" }

main:ShowModal()