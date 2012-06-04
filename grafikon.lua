require "luasql.sqlite3"

function rows (connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    local data=cursor:fetch({})
    if data then
      return data
    else
      cursor:close()
    end
  end
end


env=luasql.sqlite3()
db=assert(env:connect("szeged2.sqlite"))
print(db)
--prepare select
stopsSQL=[[SELECT s.stop_id, sp.stop_lon, sp.stop_lat
FROM stop_times s
JOIN stops sp ON s.stop_id=sp.stop_id
WHERE s.trip_id=(SELECT trip_id FROM trips WHERE route_id='45' LIMIT 1)
ORDER BY CAST(stop_sequence AS integer) ASC]]
--Calculating distances
distances={}
totalDistance=nil
orders={}
order=0
for data in rows(db,stopsSQL) do
  if totalDistance==nil then
    prevX=data[2]
    prevY=data[3]
    totalDistance=0
  end
  dist=math.sqrt( math.pow(data[3]-prevY,2), math.pow(data[2]-prevX,2) )
  print(data[1],dist)
  totalDistance=totalDistance+dist
  distances[data[1]]=totalDistance
  orders[data[1]]=order
  print(data[1],order)
  prevX=data[2]
  prevY=data[3]
  order=order+1
end

--now prepare main query
mainSQL=[[SELECT stop_id, departure_time, s.trip_id
FROM stop_times_fixed s
JOIN trips t ON t.trip_id=s.trip_id
WHERE t.route_id='45'
ORDER BY s.trip_id ASC, CAST(stop_sequence AS integer) ASC]]

--calculate sums
timeSum=24*60
tRes=200
maxOrder=order
print(maxOrder)

print("Preparing graph")

--preparing file
outp=io.open("grafikon.svg","w+")
outp:write('<svg xmlns="http://www.w3.org/2000/svg" width="'..timeSum..'" height="'..tRes..'">\n')

--createGrid
--hours
for i=1,24 do
  outp:write('<path stroke="gray" fill="none" d="M'..(i*60)..' 0 L'..(i*60)..' 200"/>\n')
end
--stops
for k,v in pairs(distances) do
--  outp:write('<path stroke="lightgray" fill="none" d="M0 '..(orders[k]/maxOrder)*tRes..' L '..timeSum..' '..(orders[k]/maxOrder)*tRes..'"/>\n')  
end


--create graph
lastTripId=0
d={}
for data in rows(db,mainSQL) do
  --print(data[1],data[2])
  hh,mm,ss=string.match(data[2],"(%d+):(%d+):(%d+)")
  --print(distances[data[1]],hh*mm)
  if lastTripId==data[3] and distances[data[1]] then
    d[#d+1]="L"..((hh*60)+mm).." "..(orders[data[1]]/maxOrder)*tRes
    --print((orders[data[1]]/maxOrder)*tRes)
    --print(hh,mm)
  else
    if #d>0 then
      local r=math.random(255)
      local g=math.random(255)
      local b=math.random(255)
      col=string.format("#%02x%02x%02x",r,g,b)
      outp:write('<path d="'..table.concat(d," ")..'" fill="none" stroke="'..col..'"/>\n')
      print("Trip "..data[3].." finished...")
    end
    d={}
    if data and distances[data[1]] and hh then
      d[1]="M "..((hh*60)+mm).." "..(orders[data[1]]/maxOrder)*tRes
    end     
  end
  lastTripId=data[3]
end

--outp:write('<path d="'..table.concat(d," ")..'" fill="none" stroke="black"/>\n')

outp:write('</svg>')
outp:close()
db:close()