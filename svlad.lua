--Skeleton SVLADa
require "vcl"

function nasobilka()
  for x=1,9 do
    for y=1,9 do
      tabl:SetCell(x,y,x*y)
    end
  end
end

function sql_dotaz(sender)
  dotaz=table.concat(sql:GetText())
  VCL.ShowMessage(table.concat(sql:GetText(),"\n"))
  if dotaz=="nasobilka" then
    nasobilka()
  end
end

main=VCL.Form("mainWin")
main._={ caption="Svlad", width=500, height=500 }

tabl=VCL.StringGrid(main,"table")
tabl._={ align="alClient", rowCount=99, ColCount=99, AutoEdit=true }

p=VCL.Panel(main,"panel")
p._={ align="alBottom", height=90 }

sql=VCL.Memo(p,"sql")
sql._={ align="alClient",  font={name="Courier"} }

fire=VCL.Button(p,"fire")
fire._={ align="alBottom", caption="PAL!", onclick="sql_dotaz" }

main:ShowModal()