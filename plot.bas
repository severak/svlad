#include once "Lua/lua.bi"
#include once "Lua/lauxlib.bi"
#include once "Lua/lualib.bi"

function plotpoint cdecl (byval L as lua_State ptr) as integer
  dim x as integer
  dim y as integer
  x=lua_tointeger(L,1)
  y=lua_tointeger(L,2)
  pset (x,y)
  plotpoint=0  
end function

function plotline cdecl (byval L as lua_State ptr) as integer
  dim ax as integer
  dim ay as integer
  dim bx as integer
  dim by as integer
  ax=lua_tointeger(L,1)
  ay=lua_tointeger(L,2)
  bx=lua_tointeger(L,3)
  by=lua_tointeger(L,4)
  line (ax,ay)-(bx,by)
  plotline=0  
end function


function plotcolor cdecl (byval L as lua_State ptr) as integer
  dim r as integer
  dim g as integer
  dim b as integer
  r=lua_tointeger(L,1)
  g=lua_tointeger(L,2)
  b=lua_tointeger(L,3)
  Color RGB(r,g,b)
  plotcolor=0
end function

function plotcls cdecl (byval L as lua_State ptr) as integer
  cls
  plotcls=0
end function

function plotpause cdecl (byval L as lua_State ptr) as integer
  sleep
  plotpause=0
end function

function plotprint cdecl (byval L as lua_State ptr) as integer
  dim as zstring ptr text
  text=lua_tostring(L,1)
  print *text;
  plotprint=0
end function

function plotinput cdecl (byval L as lua_State ptr) as integer
  dim text as string
  Line Input ; text
  lua_pushlstring(L,text,Len(text))
  plotinput=1
end function

function curses_getkey cdecl (byval L as lua_State ptr) as integer
	lua_pushnumber(L,getkey)
	curses_getkey=1
end function

function curses_locate cdecl (byval L as lua_State ptr) as integer
	dim x as integer
	dim y as integer
	dim show as integer
	x=lua_tointeger(L,1)
	y=lua_tointeger(L,2)
	show=lua_toboolean(L,3)
	locate x,y,show
	curses_locate=0
end function

function curses_sleep cdecl (byval L as lua_State ptr) as integer
	dim ms as integer
	ms=lua_tointeger(L,1)
	sleep ms
	curses_sleep=0
end function

function curses_csrlin cdecl (byval L as lua_State ptr) as integer
	lua_pushnumber(L,csrlin)
	curses_csrlin=1
end function

function curses_pos cdecl (byval L as lua_State ptr) as integer
	lua_pushnumber(L,pos)
	curses_pos=1
end function

function plotwintitle cdecl (byval L as lua_State ptr) as integer	
  dim as zstring ptr titulek
  titulek=lua_tostring(L,1)
  WindowTitle *titulek
	plotwintitle=0
end function

function curses_getwidth cdecl (byval L as lua_State ptr) as integer
  Dim As Integer w
  w = Width
  lua_pushnumber(L,HiWord(w))
  lua_pushnumber(L,LoWord(w))
  curses_getwidth=2
end function

WindowTitle "Plot"
Screenres 640,480,32
dim L as lua_State ptr
dim f as string

If Right(COMMAND$(0),8)<>"plot.exe" Then
  f="plot.lua"
Else
  print "Enter name of file:"
  Line Input f
  cls
End If
' create a lua state
L = lua_open( )
' load the base lua library (needed for 'print')
luaL_openlibs( L )
' register the function to be called from lua as MinMax
lua_register( L, "point", @plotpoint )
lua_register( L, "line", @plotline )
lua_register( L, "color", @plotcolor )
lua_register( L, "cls", @plotcls )
lua_register( L, "pause", @plotpause )
lua_register( L, "write", @plotprint )
lua_register( L, "read", @plotinput )
lua_register( L, "getkey", @curses_getkey )
lua_register( L, "locate", @curses_locate )
lua_register( L, "sleep", @curses_sleep )
lua_register( L, "csrlin", @curses_csrlin )
lua_register( L, "pos", @curses_pos )
lua_register( L, "wintitle", @plotwintitle )
lua_register( L, "getwidth", @curses_getwidth )

'
' execute the lua script from a file
luaL_dofile( L, f )
' release the lua state
lua_close( L )
print "Ended"
sleep