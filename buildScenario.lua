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

local function buildScenario(filename, atlas, movement_data)
  local data = require(filename)

  local names = {}
  for k,v in pairs(atlas.quads) do
    table.insert(names, k)
  end

  local quadToMovement = {
    [atlas.quads['Bird-Flamingo.png']] = Movement:new(movement_data.lpiece1),
    [atlas.quads['Bird-Hawk.png']] = Movement:new(movement_data.tpiece1),
    [atlas.quads['Bird-Owl.png']] = Movement:new(movement_data.line1),
    [atlas.quads['Bird-Pelican.png']] = Movement:new(movement_data.square1),
    [atlas.quads['Bird-Pigeon.png']] = Movement:new(movement_data.triangle1),
    [atlas.quads['Bird-Tucan.png']] = Movement:new(movement_data.square2),
    [atlas.quads['Bird-Vulture.png']] = Movement:new(movement_data.triangle1),
    [atlas.quads['Bird-Woodpecker.png']] = Movement:new(movement_data.square2),
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
        local piece = Piece:new(x, y, quadToMovement[quad], quad)
        table.insert(player.pieces, piece)
      end
    end

    table.insert(players, player)
  end

  return players
end

return buildScenario
