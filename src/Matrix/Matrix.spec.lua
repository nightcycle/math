local Vector = require(script.Parent:WaitForChild("Vector"))
local Matrix = require(script.Parent:WaitForChild("Matrix"))

return function()
	-- describe("Matrix", function()
	local iA = Vector.new(1,0)
	local jA = Vector.new(0,1)
	local iB = Vector.new(1,1)
	local jB = Vector.new(1,-1)
	local a = Matrix.new(iA,jA)
	local b = Matrix.new(iB,jB)
	local c = Matrix.new(Vector.new(1,4), Vector.new(2,3))
	local d = Matrix.new(Vector.new(2,11,2), Vector.new(3,8,5), Vector.new(-4,7,3))
	local v = Vector.new(3,7,5)
	it("should add matrices", function()
		expect(a + b).to.equal(Matrix.new(Vector.new(2,1), Vector.new(1,0)))
	end)
	it("should subtract matrices", function()
		expect(a - b).to.equal(Matrix.new(Vector.new(0,-1), Vector.new(-1,2)))
	end)
	it("should multiply two matrices", function()
		local result = Matrix.new(Vector.new(1,4), Vector.new(2,3))
		print("result", result)
		expect(a * c).to.equal(result)
	end)
	it("should multiply numbers", function()
		expect(a * 2).to.equal(Matrix.new(iA*2, jA*2))
	end)
	it("should multiply vectors", function()
		expect(d*v).to.equal(Vector.new(7, 124, 56))
	end)
	it("should get eigenvalue 1", function()
		local eigenVecs, eigenVals = c:GetEigen()
		expect(eigenVals[1]).to.equal(5)
	end)
	it("should get eigenvalue 2", function()
		local eigenVecs, eigenVals = c:GetEigen()
		expect(eigenVals[2]).to.equal(-1)
	end)
	it("should get eigenvector 1", function()
		local eigenVecs, eigenVals = c:GetEigen()
		expect(eigenVecs[1]).to.equal(Vector.new(1, 2))
	end)
	it("should get eigenvector 2", function()
		local eigenVecs, eigenVals = c:GetEigen()
		expect(eigenVecs[1]).to.equal(Vector.new(-1, 1))
	end)
	it("should get determinant", function()
		local det = c:GetDeterminant()
		expect(det).to.equal(-5)
	end)
	-- end)
end