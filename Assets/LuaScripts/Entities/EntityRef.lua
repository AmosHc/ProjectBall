local EntityRef = {}

local EntityNullRef = {
	valid = false
}

function EntityRef.New(e)
	if e == nil then
		return EntityNullRef
	end

	local ref = {}

	ref.valid = true
	ref.OnDestroyed = EntityRef.OnDestroyed
	ref.Destroy = function(self)
		local mt = getmetatable(self)
		mt.__index:Destroy()
	end
	ref.DestroyImmediate = function(self)
		local mt = getmetatable(self)
		mt.__index:DestroyImmediate()
	end

	setmetatable(ref, {__index = e, __newindex = e})
	return ref
end

function EntityRef:OnDestroyed()
	self.valid = false
	setmetatable(self, nil)
end

return EntityRef