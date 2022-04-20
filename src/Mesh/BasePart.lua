
local replicatedStorage = game:GetService("ReplicatedStorage")

local surfaceUtils = require(script.Parent:WaitForChild("SurfaceUtils"))
local draw = require(script.Parent.Parent:WaitForChild("Draw"))

function getWorldPosition(part:BasePart, offset: Vector3)
	return (part.CFrame * CFrame.new(offset)).p
end

local module = {}

function module.getVertices(block: BasePart)
	local x = block.Size.X/2
	local y = block.Size.Y/2
	local z = block.Size.Z/2

	local vertices = {
		getWorldPosition(block, Vector3.new(x, -y, z)),
		getWorldPosition(block, Vector3.new(-x, -y, z)),
		getWorldPosition(block, Vector3.new(x, y, z)),
		getWorldPosition(block, Vector3.new(-x, y, z)),
		getWorldPosition(block, Vector3.new(x, -y, -z)),
		getWorldPosition(block, Vector3.new(-x, -y, -z)),
		getWorldPosition(block, Vector3.new(x, y, -z)),
		getWorldPosition(block, Vector3.new(-x, y, -z)),
	}
	-- draw.point(vertices[1], Color3.new(1,0,0))
	-- draw.point(vertices[2], Color3.new(1,0,0))
	-- draw.point(vertices[3], Color3.new(1,0,0))
	-- draw.point(vertices[4], Color3.new(1,0,0))
	return vertices
end

function module.getLines(block: BasePart)
	local x = block.Size.X/2
	local y = block.Size.Y/2
	local z = block.Size.Z/2

	local lines = {
		nwColumn = {
			getWorldPosition(block, Vector3.new(-x, -y, z)),
			getWorldPosition(block, Vector3.new(-x, y, z)),
		},
		neColumn = {
			getWorldPosition(block, Vector3.new(x, -y, z)),
			getWorldPosition(block, Vector3.new(x, y, z)),
		},
		seColumn = {
			getWorldPosition(block, Vector3.new(x, -y, -z)),
			getWorldPosition(block, Vector3.new(x, y, -z)),
		},
		swColumn = {
			getWorldPosition(block, Vector3.new(-x, -y, -z)),
			getWorldPosition(block, Vector3.new(-x, y, -z)),
		},
		nBorder = {
			getWorldPosition(block, Vector3.new(x, -y, z)),
			getWorldPosition(block, Vector3.new(-x, -y, z)),
		},
		sBorder = {
			getWorldPosition(block, Vector3.new(x, -y, -z)),
			getWorldPosition(block, Vector3.new(-x, -y, -z)),
		},
		wBorder = {
			getWorldPosition(block, Vector3.new(-x, -y, -z)),
			getWorldPosition(block, Vector3.new(-x, -y, z)),
		},
		eBorder = {
			getWorldPosition(block, Vector3.new(x, -y, -z)),
			getWorldPosition(block, Vector3.new(x, -y, z)),
		},
		sTerrace = {
			getWorldPosition(block, Vector3.new(x, y, -z)),
			getWorldPosition(block, Vector3.new(-x, y, -z)),
		},
		nTerrace = {
			getWorldPosition(block, Vector3.new(x, y, z)),
			getWorldPosition(block, Vector3.new(-x, y, z)),
		},
		wTerrace = {
			getWorldPosition(block, Vector3.new(-x, y, -z)),
			getWorldPosition(block, Vector3.new(-x, y, z)),
		},
		eTerrace = {
			getWorldPosition(block, Vector3.new(x, y, -z)),
			getWorldPosition(block, Vector3.new(x, y, z)),
		},
	}
	-- local function drawLine(line)
	-- 	draw.point(line[1], (line[2] - line[1]).Unit, Color3.new(1,1,0))
	-- end
	-- drawLine(lines.nwColumn)
	-- drawLine(lines.nTerrace)
	-- drawLine(lines.nBorder)
	-- drawLine(lines.newColumn)
	return lines
end

function module.getSurfaces(block: Part)
	local lines = module.getLines(block)
	local surfaces = {}

	local vector = {
		top = surfaceUtils.getSurfaceCFrame(block, Vector3.new(0,1,0)).LookVector,
		bottom = surfaceUtils.getSurfaceCFrame(block, Vector3.new(0,-1,0)).LookVector,
		west = surfaceUtils.getSurfaceCFrame(block, Vector3.new(-1,0,0)).LookVector,
		east = surfaceUtils.getSurfaceCFrame(block, Vector3.new(1,0,0)).LookVector,
		north = surfaceUtils.getSurfaceCFrame(block, Vector3.new(0,0,1)).LookVector,
		south = surfaceUtils.getSurfaceCFrame(block, Vector3.new(0,0,-1)).LookVector,
	}
	local surfaceLines = {}
	local surfaceDirection = {}
	for k, surfaceLineKeys in pairs({
		top = {"sTerrace", "nTerrace", "eTerrace", "wTerrace"},
		bottom = {"sBorder", "nBorder", "eBorder", "wBorder"},
		east = {"seColumn", "neColumn", "eBorder", "eTerrace"},
		west = {"swColumn", "nwColumn", "wBorder", "wTerrace"},
		north = {"neColumn", "nwColumn", "nBorder", "nTerrace"},
		south = {"seColumn", "swColumn", "sBorder", "sTerrace"},
	}) do
		local surfaceSpecificLines = {}
		for i, bondKey in pairs(surfaceLineKeys) do
			table.insert(surfaceSpecificLines, lines[bondKey])
		end
		surfaceDirection[k] = vector[k]
		surfaceLines[k] = surfaceSpecificLines
	end

	return surfaceDirection, surfaceLines
end

return module