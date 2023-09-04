local Image = {}; Image.__index = Image


--> Helper Functions -----------------------------------------------------------------------------
local function CreatePixels(amount, r,g,b, alpha)
	local pixels = table.create(amount)
	for count = 1, amount do
		table.insert(pixels, r)
		table.insert(pixels, g)
		table.insert(pixels, b)
		table.insert(pixels, alpha)
	end
	return pixels
end

local function Lerp(a, b, t) return a + (b-a) * t end
--------------------------------------------------------------------------------------------------


--> Dynamic Image Bulit-In Functions -------------------------------------------------------------
function Image:Resize(size:Vector2)
	return self.dynamicImage:Resize(size)
end

function Image:WritePixels(position: Vector2, size: Vector2, pixels: {any})
	return self.dynamicImage:WritePixels(position, size, pixels)
end

function Image:DrawImage(position:Vector2, image: DynamicImage, combineType: Enum.ImageCombineType)
	return self.dynamicImage:DrawImage(position, image, combineType)
end

function Image:ReadPixels(position: Vector2, size: Vector2)
	return self.dynamicImage:ReadPixels(position, size)
end

function Image:DrawCircle(center: Vector2, radius: number, color: Color3, transparency: number)
	return self.dynamicImage:DrawCircle(center, radius, color, transparency)
end

function Image:Crop(min:Vector2, max:Vector2)
	return self.dynamicImage:Crop(min, max)
end
--------------------------------------------------------------------------------------------------


function Image:Line(p0, p1, spacingInterval, indicatorSize)
	local p0X, p0Y = p0[1], p0[2]
	local p1X, p1Y = p1[1], p1[2]

	local sizeX, sizeY = self.sizeX, self.sizeY

	for t = 0, 1, spacingInterval do
		local tX = Lerp( p0X, p1X, t )
		local tY = Lerp( p0Y, p1Y, t )

		for x = 0, sizeX do
			if math.abs(tX - x) >= 2 then continue end
			for y = 0, sizeY do
				if math.abs(tY - y) >= 2 then continue end
				self:WritePixels(Vector2.new(x,y), Vector2.new(1,1), { 0,0,0,1 })
			end
		end
	end

	local halfIndicatorSize = indicatorSize/2

	-- p0
	self:WritePixels(
		Vector2.new(math.clamp(p0X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p0Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,1,0,1)
	)

	-- p1
	self:WritePixels(
		Vector2.new(math.clamp(p1X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p1Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,0,1,1)
	)
end

function Image:QuadraticBezier(p0, p1, p2, spacingInterval, indicatorSize)
	local p0X, p0Y = p0[1], p0[2]
	local p1X, p1Y = p1[1], p1[2]
	local p2X, p2Y = p2[1], p2[2]

	local sizeX, sizeY = self.sizeX, self.sizeY

	for t = 0, 1, spacingInterval do
		local tX = Lerp( Lerp(p0X, p1X, t), Lerp(p1X, p2X, t), t )
		local tY = Lerp( Lerp(p0Y, p1Y, t), Lerp(p1Y, p2Y, t), t )

		for x = 0, sizeX do
			if math.abs(tX - x) >= 2 then continue end
			for y = 0, sizeY do
				if math.abs(tY - y) >= 2 then continue end
				self:WritePixels(Vector2.new(x,y), Vector2.new(1,1), { 0,0,0,1 })
			end
		end
	end

	local halfIndicatorSize = indicatorSize/2

	-- p0
	self:WritePixels(
		Vector2.new(math.clamp(p0X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p0Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,1,0,1)
	)
	
	-- p1
	self:WritePixels(
		Vector2.new(math.clamp(p1X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p1Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,0,1,1)
	)

	-- p2
	self:WritePixels(
		Vector2.new(math.clamp(p2X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p2Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 1,0,0,1)
	)
end


function Image:CubicBezier(p0, p1, p2, p3, spacingInterval, indicatorSize)
	local p0X, p0Y = p0[1], p0[2]
	local p1X, p1Y = p1[1], p1[2]
	local p2X, p2Y = p2[1], p2[2]
	local p3X, p3Y = p3[1], p3[2]
	
	local sizeX, sizeY = self.sizeX, self.sizeY
	
	for t = 0, 1, spacingInterval do
		local l1X, l2X, l3X = Lerp(p0X, p1X, t), Lerp(p1X, p2X, t), Lerp(p2X, p3X, t)
		local lAX, lBX = Lerp(l1X, l2X, t), Lerp(l2X, l3X, t)
		local lCX = Lerp(lAX, lBX, t)
		
		local l1Y, l2Y, l3Y = Lerp(p0Y, p1Y, t), Lerp(p1Y, p2Y, t), Lerp(p2Y, p3Y, t)
		local lAY, lBY = Lerp(l1Y, l2Y, t), Lerp(l2Y, l3Y, t)
		local lCY = Lerp(lAY, lBY, t)
		
		for x = 0, sizeX do
			if math.abs(lCX - x) >= 2 then continue end
			for y = 0, sizeY do
				if math.abs(lCY - y) >= 2 then continue end
				self:WritePixels(Vector2.new(x,y), Vector2.new(1,1), { 0,0,0,1 })
			end
		end
	end
	
	local halfIndicatorSize = indicatorSize/2
	
	-- p0
	self:WritePixels(
		Vector2.new(math.clamp(p0X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p0Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,1,0,1)
	)
	
	-- p1
	self:WritePixels(
		Vector2.new(math.clamp(p1X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p1Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,0,1,1)
	)
	
	-- p2
	self:WritePixels(
		Vector2.new(math.clamp(p2X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p2Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 0,0,1,1)
	)
	
	-- p3
	self:WritePixels(
		Vector2.new(math.clamp(p3X-(indicatorSize/2), 0, sizeX-indicatorSize), math.clamp(p3Y-(indicatorSize/2), 0, sizeY-indicatorSize)),
		Vector2.new(indicatorSize,indicatorSize),
		CreatePixels(indicatorSize*indicatorSize, 1,0,0,1)
	)
end


function Image:InstantiateAsLabel()
	local label = Instance.new("ImageLabel")
	--label.BackgroundTransparency = 1
	label.BackgroundColor3 = Color3.new(1,1,1)
	label.Size = UDim2.fromOffset(self.sizeX, self.sizeY)
	self.dynamicImage.Parent = label
	return label
end


function Image:Clear()
	local sizeX, sizeY = self.sizeX, self.sizeY
	self:WritePixels(Vector2.new(0,0), Vector2.new(self.sizeX, self.sizeY), CreatePixels(sizeX*sizeY, 1,1,1,1))
end


return {
	new = function(sizeX:number, sizeY: number)
		local dynamicImage = Instance.new("DynamicImage")
		dynamicImage.Size = Vector2.new(sizeX, sizeY)
		
		return setmetatable({
			dynamicImage = dynamicImage,
			sizeX = sizeX, sizeY = sizeY
		}, Image)
	end,
}
