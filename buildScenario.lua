local quadToMovement = require('quadToMovement')
local colors = require('colors').colors
local namesByColors = require('colors').namesByColors

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
    player.name = namesByColors[player.color]
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
