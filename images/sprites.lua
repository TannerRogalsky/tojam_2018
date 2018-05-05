-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:606431cfb7cf9b48f6dd4b1c7d12c5bd:0f50f2f7cec1cb79476f8148f96892f1:ce59e0ef6b4af9fefc088af809f682f1$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("sprites")
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
local Texture = game.preloaded_images["sprites.png"]

Quads["boss_alpha.png"] = love.graphics.newQuad(1, 261, 62, 83, 960, 462)
Quads["boss_body.png"] = love.graphics.newQuad(1, 1, 128, 128, 960, 462)
Quads["boss_color.png"] = love.graphics.newQuad(131, 1, 72, 93, 960, 462)
Quads["boss_contrast.png"] = love.graphics.newQuad(1, 131, 128, 128, 960, 462)
Quads["enemy1_alpha.png"] = love.graphics.newQuad(259, 265, 51, 52, 960, 462)
Quads["enemy1_body.png"] = love.graphics.newQuad(199, 264, 58, 59, 960, 462)
Quads["enemy1_color.png"] = love.graphics.newQuad(859, 397, 51, 52, 960, 462)
Quads["enemy2_alpha.png"] = love.graphics.newQuad(117, 417, 40, 41, 960, 462)
Quads["enemy2_body.png"] = love.graphics.newQuad(133, 360, 64, 55, 960, 462)
Quads["enemy2_color.png"] = love.graphics.newQuad(906, 265, 40, 41, 960, 462)
Quads["enemy3_alpha.png"] = love.graphics.newQuad(1, 412, 56, 49, 960, 462)
Quads["enemy3_body.png"] = love.graphics.newQuad(205, 67, 64, 63, 960, 462)
Quads["enemy3_color.png"] = love.graphics.newQuad(59, 412, 56, 49, 960, 462)
Quads["exit_alpha.png"] = love.graphics.newQuad(159, 417, 32, 32, 960, 462)
Quads["exit_body.png"] = love.graphics.newQuad(912, 397, 32, 32, 960, 462)
Quads["exit_color.png"] = love.graphics.newQuad(923, 133, 32, 32, 960, 462)
Quads["player_1_body.png"] = love.graphics.newQuad(923, 235, 31, 24, 960, 462)
Quads["player_1_life.png"] = love.graphics.newQuad(923, 167, 32, 32, 960, 462)
Quads["player_1_life_ring.png"] = love.graphics.newQuad(923, 201, 32, 32, 960, 462)
Quads["player_1_sword.png"] = love.graphics.newQuad(67, 393, 53, 8, 960, 462)
Quads["player_2_body.png"] = love.graphics.newQuad(914, 431, 31, 24, 960, 462)
Quads["player_2_life.png"] = love.graphics.newQuad(925, 308, 32, 32, 960, 462)
Quads["player_2_life_ring.png"] = love.graphics.newQuad(925, 342, 32, 32, 960, 462)
Quads["player_2_sword.png"] = love.graphics.newQuad(859, 451, 53, 8, 960, 462)
Quads["powerup_attack.png"] = love.graphics.newQuad(931, 32, 27, 28, 960, 462)
Quads["powerup_health.png"] = love.graphics.newQuad(931, 1, 28, 29, 960, 462)
Quads["tile_280.png"] = love.graphics.newQuad(131, 96, 64, 64, 960, 462)
Quads["tile_280_mask.png"] = love.graphics.newQuad(205, 1, 64, 64, 960, 462)
Quads["tile_281.png"] = love.graphics.newQuad(65, 261, 64, 64, 960, 462)
Quads["tile_281_mask.png"] = love.graphics.newQuad(131, 162, 64, 64, 960, 462)
Quads["tile_282.png"] = love.graphics.newQuad(271, 1, 64, 64, 960, 462)
Quads["tile_282_mask.png"] = love.graphics.newQuad(131, 228, 64, 64, 960, 462)
Quads["tile_283.png"] = love.graphics.newQuad(337, 1, 64, 64, 960, 462)
Quads["tile_283_mask.png"] = love.graphics.newQuad(403, 1, 64, 64, 960, 462)
Quads["tile_284.png"] = love.graphics.newQuad(469, 1, 64, 64, 960, 462)
Quads["tile_284_mask.png"] = love.graphics.newQuad(535, 1, 64, 64, 960, 462)
Quads["tile_285.png"] = love.graphics.newQuad(601, 1, 64, 64, 960, 462)
Quads["tile_285_mask.png"] = love.graphics.newQuad(667, 1, 64, 64, 960, 462)
Quads["tile_286.png"] = love.graphics.newQuad(733, 1, 64, 64, 960, 462)
Quads["tile_286_mask.png"] = love.graphics.newQuad(799, 1, 64, 64, 960, 462)
Quads["tile_287.png"] = love.graphics.newQuad(865, 1, 64, 64, 960, 462)
Quads["tile_287_mask.png"] = love.graphics.newQuad(1, 346, 64, 64, 960, 462)
Quads["tile_288.png"] = love.graphics.newQuad(67, 327, 64, 64, 960, 462)
Quads["tile_288_mask.png"] = love.graphics.newQuad(133, 294, 64, 64, 960, 462)
Quads["tile_307.png"] = love.graphics.newQuad(271, 67, 64, 64, 960, 462)
Quads["tile_307_mask.png"] = love.graphics.newQuad(337, 67, 64, 64, 960, 462)
Quads["tile_308.png"] = love.graphics.newQuad(403, 67, 64, 64, 960, 462)
Quads["tile_308_mask.png"] = love.graphics.newQuad(469, 67, 64, 64, 960, 462)
Quads["tile_309.png"] = love.graphics.newQuad(535, 67, 64, 64, 960, 462)
Quads["tile_309_mask.png"] = love.graphics.newQuad(601, 67, 64, 64, 960, 462)
Quads["tile_310.png"] = love.graphics.newQuad(667, 67, 64, 64, 960, 462)
Quads["tile_310_mask.png"] = love.graphics.newQuad(733, 67, 64, 64, 960, 462)
Quads["tile_311.png"] = love.graphics.newQuad(799, 67, 64, 64, 960, 462)
Quads["tile_311_mask.png"] = love.graphics.newQuad(865, 67, 64, 64, 960, 462)
Quads["tile_312.png"] = love.graphics.newQuad(197, 132, 64, 64, 960, 462)
Quads["tile_312_mask.png"] = love.graphics.newQuad(197, 198, 64, 64, 960, 462)
Quads["tile_313.png"] = love.graphics.newQuad(263, 133, 64, 64, 960, 462)
Quads["tile_313_mask.png"] = love.graphics.newQuad(329, 133, 64, 64, 960, 462)
Quads["tile_314.png"] = love.graphics.newQuad(395, 133, 64, 64, 960, 462)
Quads["tile_314_mask.png"] = love.graphics.newQuad(461, 133, 64, 64, 960, 462)
Quads["tile_315.png"] = love.graphics.newQuad(527, 133, 64, 64, 960, 462)
Quads["tile_315_mask.png"] = love.graphics.newQuad(593, 133, 64, 64, 960, 462)
Quads["tile_334.png"] = love.graphics.newQuad(659, 133, 64, 64, 960, 462)
Quads["tile_334_mask.png"] = love.graphics.newQuad(725, 133, 64, 64, 960, 462)
Quads["tile_335.png"] = love.graphics.newQuad(791, 133, 64, 64, 960, 462)
Quads["tile_335_mask.png"] = love.graphics.newQuad(857, 133, 64, 64, 960, 462)
Quads["tile_336.png"] = love.graphics.newQuad(263, 199, 64, 64, 960, 462)
Quads["tile_336_mask.png"] = love.graphics.newQuad(329, 199, 64, 64, 960, 462)
Quads["tile_337.png"] = love.graphics.newQuad(395, 199, 64, 64, 960, 462)
Quads["tile_337_mask.png"] = love.graphics.newQuad(461, 199, 64, 64, 960, 462)
Quads["tile_338.png"] = love.graphics.newQuad(527, 199, 64, 64, 960, 462)
Quads["tile_338_mask.png"] = love.graphics.newQuad(593, 199, 64, 64, 960, 462)
Quads["tile_339.png"] = love.graphics.newQuad(659, 199, 64, 64, 960, 462)
Quads["tile_339_mask.png"] = love.graphics.newQuad(725, 199, 64, 64, 960, 462)
Quads["tile_340.png"] = love.graphics.newQuad(791, 199, 64, 64, 960, 462)
Quads["tile_340_mask.png"] = love.graphics.newQuad(857, 199, 64, 64, 960, 462)
Quads["tile_341.png"] = love.graphics.newQuad(199, 325, 64, 64, 960, 462)
Quads["tile_341_mask.png"] = love.graphics.newQuad(312, 265, 64, 64, 960, 462)
Quads["tile_361.png"] = love.graphics.newQuad(378, 265, 64, 64, 960, 462)
Quads["tile_361_mask.png"] = love.graphics.newQuad(444, 265, 64, 64, 960, 462)
Quads["tile_362.png"] = love.graphics.newQuad(510, 265, 64, 64, 960, 462)
Quads["tile_362_mask.png"] = love.graphics.newQuad(576, 265, 64, 64, 960, 462)
Quads["tile_363.png"] = love.graphics.newQuad(642, 265, 64, 64, 960, 462)
Quads["tile_363_mask.png"] = love.graphics.newQuad(708, 265, 64, 64, 960, 462)
Quads["tile_364.png"] = love.graphics.newQuad(774, 265, 64, 64, 960, 462)
Quads["tile_364_mask.png"] = love.graphics.newQuad(840, 265, 64, 64, 960, 462)
Quads["tile_365.png"] = love.graphics.newQuad(199, 391, 64, 64, 960, 462)
Quads["tile_365_mask.png"] = love.graphics.newQuad(265, 331, 64, 64, 960, 462)
Quads["tile_366.png"] = love.graphics.newQuad(265, 397, 64, 64, 960, 462)
Quads["tile_366_mask.png"] = love.graphics.newQuad(331, 331, 64, 64, 960, 462)
Quads["tile_390.png"] = love.graphics.newQuad(331, 397, 64, 64, 960, 462)
Quads["tile_390_mask.png"] = love.graphics.newQuad(397, 331, 64, 64, 960, 462)
Quads["tile_391.png"] = love.graphics.newQuad(397, 397, 64, 64, 960, 462)
Quads["tile_391_mask.png"] = love.graphics.newQuad(463, 331, 64, 64, 960, 462)
Quads["tile_392.png"] = love.graphics.newQuad(463, 397, 64, 64, 960, 462)
Quads["tile_392_mask.png"] = love.graphics.newQuad(529, 331, 64, 64, 960, 462)
Quads["tile_393.png"] = love.graphics.newQuad(529, 397, 64, 64, 960, 462)
Quads["tile_393_mask.png"] = love.graphics.newQuad(595, 331, 64, 64, 960, 462)
Quads["tile_417.png"] = love.graphics.newQuad(595, 397, 64, 64, 960, 462)
Quads["tile_417_mask.png"] = love.graphics.newQuad(661, 331, 64, 64, 960, 462)
Quads["tile_418.png"] = love.graphics.newQuad(661, 397, 64, 64, 960, 462)
Quads["tile_418_mask.png"] = love.graphics.newQuad(727, 331, 64, 64, 960, 462)
Quads["tile_419.png"] = love.graphics.newQuad(727, 397, 64, 64, 960, 462)
Quads["tile_419_mask.png"] = love.graphics.newQuad(793, 331, 64, 64, 960, 462)
Quads["tile_420.png"] = love.graphics.newQuad(793, 397, 64, 64, 960, 462)
Quads["tile_420_mask.png"] = love.graphics.newQuad(859, 331, 64, 64, 960, 462)

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