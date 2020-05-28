local KeyboardMgr = class("KeyboardMgr")

function KeyboardMgr:ctor()
	self.inputfield = false
	self.orginPos = false
end

function KeyboardMgr:AddListenerInputfield(inputfield)
	self.inputfield = inputfield
	self.orginPos = inputfield.position
end

function KeyboardMgr:RemoveListenerInputfield(inputfield)
	self.inputfield = false
	self.orginPos = false
end

function KeyboardMgr:KeyboardDidShowCallback(x, y, width, height)
	if self.inputfield then
		self.inputfield.y = y - self.inputfield.height
	end
end

function KeyboardMgr:KeyboardDidHideCallback()
	if self.inputfield and self.orginPos then
		self.inputfield.position = self.orginPos
	end
end

function KeyboardMgr:KeyboardDidChangeFrameCallback(x, y, width, height)
	if self.inputfield then
		self.inputfield.y = y - self.inputfield.height
	end
end

return KeyboardMgr