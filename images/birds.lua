-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:017e24d4527126766bed98d8e74a1b49:3423b357b51303557bd4a0104f9d3828:4e7c038e02cbf60799ad3278fe0baa10$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("birds")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = game.preloaded_images["birds.png"]

Quads["Bird-Flamingo.png"] = love.graphics.newQuad(1, 1, 256, 256, 774, 774)
Quads["Bird-Hawk.png"] = love.graphics.newQuad(1, 259, 256, 256, 774, 774)
Quads["Bird-Owl.png"] = love.graphics.newQuad(1, 517, 256, 256, 774, 774)
Quads["Bird-Pelican.png"] = love.graphics.newQuad(259, 1, 256, 256, 774, 774)
Quads["Bird-Pigeon.png"] = love.graphics.newQuad(517, 1, 256, 256, 774, 774)
Quads["Bird-Tucan.png"] = love.graphics.newQuad(259, 259, 256, 256, 774, 774)
Quads["Bird-Vulture.png"] = love.graphics.newQuad(259, 517, 256, 256, 774, 774)
Quads["Bird-Woodpecker.png"] = love.graphics.newQuad(517, 259, 256, 256, 774, 774)

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil
	end
	local x, y, w, h = quad:getViewport()
  return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
