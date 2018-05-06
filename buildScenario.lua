local quadToMovement = require('quadToMovement')
local colors = {
  { 0xd5 / 0xff, 0x42 / 0xff, 0xc2 / 0xff, 1 },
  -- { 0xd0 / 0xff, 0x64 / 0xff, 0x14 / 0xff, 1 },
  { 0x1b / 0xff, 0xa9 / 0xff, 0xeb / 0xff, 1 },
  { 0xf3 / 0xff, 0x2f / 0xff, 0x74 / 0xff, 1 },
  { 0x23 / 0xff, 0xc7 / 0xff, 0x1b / 0xff, 1 },
  { 0xff / 0xff, 0xca / 0xff, 0x27 / 0xff, 1 },
  { 0xff / 0xff, 0x86 / 0xff, 0x25 / 0xff, 1 },
  { 0xe8 / 0xff, 0x26 / 0xff, 0x11 / 0xff, 1 },
}

local function buildScenario(data, atlas, movement_data)
  local names = { -- order matters cause this is what tiled uses for indices
    'Bird-Flamingo.png',
    'Bird-Pelican.png',
    'Bird-Pigeon.png',
    'Bird-Hawk.png',
    'Bird-Tucan.png',
    'Bird-Woodpecker.png',
    'Bird-Owl.png',
    'Bird-Vulture.png',
  }

  local colorsClone = {}
  for i,v in ipairs(colors) do
    table.insert(colorsClone, v)
  end

  local players = {}
  for i, layer in ipairs(data.layers) do
    local i = love.math.random(1, #colorsClone)
    local player = Player:new(colorsClone[i])
    table.remove(colorsClone, i)

    for j,d in ipairs(layer.data) do
      local x = (j - 1) % layer.width + 1
      local y = math.floor((j - 1) / layer.width + 1)

      if d > 0 then
        local quad = atlas.quads[names[d]]
        local piece = Piece:new(x, y, Movement:new(movement_data[quadToMovement[names[d]]]), quad)
        table.insert(player.pieces, piece)
      end
    end

    table.insert(players, player)
  end

  return players
end

return buildScenario
