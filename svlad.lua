--
--SVLAD
--
--custom spreadsheet with changeable logic
--
require "vcl"
logicName="basic"
if arg and type(arg)=="table" then
  logicName=arg[1]
  print("Loading custom logic "..logicName)
end

brain=require("logic."..logicName)
logic=brain.logic

function sql_dotaz(sender)
  dotaz=table.concat(sql:GetText(),"\n")
  logic:processQuery(dotaz)
end

function appEnd()
  logic:close()
  --main:Free()
end

function getEdit(sender,x,y,v)
  return logic:getCellForEdit(x,y,v)
end

function setEdit(sender,x,y,v)
  logic:editCell(x,y,v)
  return false
end

function OnHeaderClick(sender,IsColumn,index)
  if IsColumn then
    logic:colHeaderClick(index)
  else
    logic:rowHeaderClick(index)
  end
end

function showAbout(sender)
  VCL.ShowMessage("SVLAD\n\nTable editor by Severak")
end

function showTables(sender)
  --showresult("SELECT * FROM sqlite_master WHERE type='table' ORDER BY name ASC")
end

function tableListChange(sender)
  logic:tableListChange(tablelist.Text)
end

function appStart()
  logic:init()
end

GUI={
  setTableList=function(tabl)
    tablelist:SetText(tabl)
  end,
  
  resetTable=function()
    tabl.colCount=1
    tabl.rowCount=1
  end,
  
  setCell=function(x,y,v)
    if tabl.rowCount<y+1 then
      tabl.rowCount=y+1
    end
    if tabl.colCount<x+1 then
      tabl.colCount=x+1
    end
    tabl:SetCell(x,y,v)
  end
}

menu={
  {caption="&Databases",submenu={
    {caption="&Attach"},
    {caption="&Import"},
    {caption="&Export"}
  }},
  {caption="&Actions",submenu={
    {caption="&Show tables",onclick="showTables"}
  }},
  {caption="&About",submenu={
    {name="about",caption="&About",onclick="showAbout"},
    {caption="-"},
    {caption="&Info"}
  }}
}

main=VCL.Form("mainWin")
main._={ caption="Svlad", width=500, height=500, onshow="appStart", onclose="appEnd" }

mainMenu=VCL.MainMenu("mm")
mainMenu:LoadFromTable(menu)

tabl=VCL.StringGrid(main,"table")
tabl._={ align="alClient", rowCount=99, ColCount=99,  AutoEdit=1, Options="goEditing,goRowSizing,goColSizing", OnSetEditText="setEdit", OnGetEditText="getEdit", OnHeaderClick="OnHeaderClick" }

p=VCL.Panel(main,"panel")
p._={ align="alBottom", height=90 }

tablelist=VCL.ComboBox(main,"tbllist")
tablelist._={ align="alTop", onchange="tableListChange"}

sql=VCL.Memo(p,"sql")
sql._={ align="alClient",  font={name="Courier"} }

fire=VCL.Button(p,"fire")
fire._={ align="alBottom", caption="PAL!", onclick="sql_dotaz" }

main:ShowModal()