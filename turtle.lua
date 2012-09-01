protoTurtle={
	x=320,
	y=240,
	angle=0,
	penIsDown=true,
	fd=function(self,len)
		local prevX=self.x
		local prevY=self.y
		if self.penIsDown then
			self.y=(math.sin(math.rad(self.angle))*len)+prevY
			self.x=(math.cos(math.rad(self.angle))*len)+prevX	
			line(prevX,prevY,self.x,self.y)
		end
	end,
	left=function(self,angle)
		self.angle=self.angle+angle
	end,
	right=function(self,angle)
		self.angle=self.angle-angle
	end,
	home=function(self)
		self.x=320
		self.y=240
		self.angle=0
		self.penIsDown=true
	end,
	penUp=function(self)
		self.penIsDown=false
	end,
	penDown=function(self)
		self.penIsDown=true
	end
}

function newTurtle()
	local nt={}
	setmetatable(nt,{__index=protoTurtle})
	return nt
end

turtle=newTurtle()
exit=os.exit