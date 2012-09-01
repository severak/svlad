--turtle console
dofile("turtle.lua")
wintitle("Zelva")
maxx,maxy=getwidth()
while true do
	locate(maxx-1,1)
	write(string.rep(" ",maxy-1))
	locate(maxx-1,1)
	local zz=read()
	local f=loadstring(zz)
	local ok,msg=pcall(f)
	if not ok then
		locate(maxx-2,1)
		write(string.rep(" ",maxy-1))
		locate(maxx-2,1)
		color(255,0,0)
		write(msg)
		color(255,255,255)
	end
end