
local math =  math
local table = table
local Vector = Vector

prop2mesh.primitive = {}

prop2mesh.primitive.cube = function(vars)
	local dx = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dy = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {
		Vector(dx, -dy, -dz),
		Vector(dx, dy, -dz),
		Vector(dx, dy, dz),
		Vector(dx, -dy, dz),
		Vector(-dx, -dy, -dz),
		Vector(-dx, dy, -dz),
		Vector(-dx, dy, dz),
		Vector(-dx, -dy, dz),
	}

	local indices = {
		{1,2,3,4},
		{2,6,7,3},
		{6,5,8,7},
		{5,1,4,8},
		{4,3,7,8},
		{5,6,2,1},
	}

	return prop2mesh.triangulate(vertices, indices)
end

prop2mesh.primitive.wedge_corner = function(vars)
	local dx = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dy = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {
		Vector(dx, dy, -dz),
		Vector(-dx, -dy, -dz),
		Vector(-dx, dy, -dz),
		Vector(-dx, dy, dz),
	}

	local indices = {
		 {1,3,4},
		 {2,1,4},
		 {3,2,4},
		 {1,2,3},
	}

	return prop2mesh.triangulate(vertices, indices)
end

prop2mesh.primitive.wedge = function(vars)
	local dx = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dy = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {
		Vector(dx, -dy, -dz),
		Vector(dx, dy, -dz),
		Vector(-dx, -dy, -dz),
		Vector(-dx, dy, -dz),
		Vector(-dx, dy, dz),
		Vector(-dx, -dy, dz),
	}

	local indices = {
		{1,2,5,6},
		{2,4,5},
		{4,3,6,5},
		{3,1,6},
		{3,4,2,1},
	}

	return prop2mesh.triangulate(vertices, indices)
end

prop2mesh.primitive.pyramid = function(vars)
	local dx = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dy = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {
		Vector(dx, -dy, -dz),
		Vector(dx, dy, -dz),
		Vector(-dx, -dy, -dz),
		Vector(-dx, dy, -dz),
		Vector(0, 0, dz),
	}

	local indices = {
		{1,2,5},
		{2,4,5},
		{4,3,5},
		{3,1,5},
		{3,4,2,1},
	}

	return prop2mesh.triangulate(vertices, indices)
end

prop2mesh.primitive.tube = function(vars)
	local maxSegments = 32
	local numSegments = math.Clamp(math.abs(math.floor(vars.segments or maxSegments)), 1, maxSegments)

	local dx1 = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dx2 = math.Clamp(dx1 - math.abs(vars.thickness or 1), 0, dx1)
	local dy1 = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dy2 = math.Clamp(dy1 - math.abs(vars.thickness or 1), 0, dy1)
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {}
	for i = 0, numSegments do
		local a = math.rad((i / maxSegments) * -360)
		table.insert(vertices, Vector(math.sin(a)*dx1, math.cos(a)*dy1, dz))
		table.insert(vertices, Vector(math.sin(a)*dx1, math.cos(a)*dy1, -dz))
		table.insert(vertices, Vector(math.sin(a)*dx2, math.cos(a)*dy2, dz))
		table.insert(vertices, Vector(math.sin(a)*dx2, math.cos(a)*dy2, -dz))
	end

	local indices = {}
	for i = 1, #vertices - 4, 4 do
		table.insert(indices, {i + 0, i + 4, i + 6, i + 2})
		table.insert(indices, {i + 4, i + 0, i + 1, i + 5})
		table.insert(indices, {i + 2, i + 6, i + 7, i + 3})
		table.insert(indices, {i + 5, i + 1, i + 3, i + 7})
	end

	if numSegments ~= maxSegments then
		local i = numSegments*4 + 1
		table.insert(indices, {i + 2, i + 0, i + 1, i + 3})
		table.insert(indices, {1, 3, 4, 2})
	end

	return prop2mesh.triangulate(vertices, indices)
end

prop2mesh.primitive.cylinder = function(vars)
	local maxSegments = 32
	local numSegments = math.Clamp(math.abs(math.floor(vars.segments or maxSegments)), 1, maxSegments)

	local dx = math.Clamp(math.abs(vars.dx or 1), 1, 512)*0.5
	local dy = math.Clamp(math.abs(vars.dy or 1), 1, 512)*0.5
	local dz = math.Clamp(math.abs(vars.dz or 1), 1, 512)*0.5

	local vertices = {}
	for i = 0, numSegments do
		local a = math.rad((i / maxSegments) * -360)
		table.insert(vertices, Vector(math.sin(a)*dx, math.cos(a)*dy, dz))
		table.insert(vertices, Vector(math.sin(a)*dx, math.cos(a)*dy, -dz))
		table.insert(vertices, Vector(0, 0, dz))
		table.insert(vertices, Vector(0, 0, -dz))
	end

	local indices = {}
	for i = 1, #vertices - 4, 4 do
		table.insert(indices, {i + 0, i + 4, i + 6, i + 2})
		table.insert(indices, {i + 4, i + 0, i + 1, i + 5})
		table.insert(indices, {i + 2, i + 6, i + 7, i + 3})
		table.insert(indices, {i + 5, i + 1, i + 3, i + 7})
	end

	if numSegments ~= maxSegments then
		local i = numSegments*4 + 1
		table.insert(indices, {i + 2, i + 0, i + 1, i + 3})
		table.insert(indices, {1, 3, 4, 2})
	end

	return prop2mesh.triangulate(vertices, indices)
end
