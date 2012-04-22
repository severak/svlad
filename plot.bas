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
  print *text
  plotprint=0
end function

function plotinput cdecl (byval L as lua_State ptr) as integer
  dim text as string
  Line Input text
  lua_pushlstring(L,text,Len(text))
  plotinput=1
end function

WindowTitle "Plot"
Screenres 640,480,32
dim L as lua_State ptr
dim f as string

print "Enter name of file:"
Line Input f
cls
' create a lua state
L = lua_open( )
' load the base lua library (needed for 'print')
luaL_openlibs( L )
' register the function to be called from lua as MinMax
lua_register( L, "point", @plotpoint )
lua_register( L, "color", @plotcolor )
lua_register( L, "cls", @plotcls )
lua_register( L, "pause", @plotpause )
lua_register( L, "write", @plotprint )
lua_register( L, "read", @plotinput )
' execute the lua script from a file
luaL_dofile( L, f )
' release the lua state
lua_close( L )
print "Ended"
sleep