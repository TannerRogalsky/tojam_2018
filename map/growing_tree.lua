local CONSTANTS  = require('map.constants')
local N, S, E, W = unpack(CONSTANTS.DIRECTIONS)
local DX         = CONSTANTS.DX
local DY         = CONSTANTS.DY
local OPPOSITE   = CONSTANTS.OPPOSITE

local function shuffle(t, r)
  local n = #t -- gets the length of the table
  while n >= 2 do -- only run if the table has more than 1 element
    local k = r:random(n) -- get a random number
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end

local function node(x, y, v)
  return {
    x = x, y = y, value = v,
    neighbors = {},
  }
end

local function generate(width, height, modes, r)
  -- local grid = setmetatable({}, {
  --   __index = function(t, k)
  --     local v = rawget(t, k)
  --     if v == nil then
  --       v = {}
  --       rawset(t, k, v)
  --     end
  --     return v
  --   end
  -- })
  local grid = {}
  for y=1,height do
    grid[y] = {}
    for x=1,width do
      grid[y][x] = 0
    end
  end

  local selectors = {
    random = function(ceil) return r:random(ceil) end,
    newest = function(ceil) return ceil end,
    middle = function(ceil) return ceil / 2 end,
    oldest = function(ceil) return 1 end,
  }

  local total_weight = 0
  local parts = {}
  for name,weight in pairs(modes) do
    total_weight = total_weight + weight
    table.insert(parts, {
      name = name,
      weight = total_weight
    })
  end
  local function next_index(ceil)
    local v = r:random(total_weight)
    for _,part in ipairs(parts) do
      if v <= part.weight then
        return selectors[part.name](ceil)
      end
    end

    error('failed to find command of weight: ' .. v)
  end

  local total = 0

  local cells = {}
  local x, y = r:random(width), r:random(height)
  local root = node(x, y, 0)
  table.insert(cells, root)

  -- 1, 2 -> 2, 2
  -- 2, 2 -> 2, 1
  -- 2, 1 -> 3, 1
  -- 3, 1 -> 3, 2
  -- 3, 2 -> 3, 3
  -- 3, 3 -> 2, 3
  -- 2, 3 -> 1, 3
  -- 1, 3 -> 1, 2
  -- 1, 3 doesn't have 1, 2 as a neighbor... but 2, 2 does

  while #cells > 0 do
    local index = next_index(#cells)
    local current = cells[index]
    local x, y = current.x, current.y
    print('out', x, y)

    total = total + 1
    if total > 25 then
      break
    end

    for _,dir in ipairs(shuffle({N, S, E, W}, r)) do
      local nx, ny = x + DX[dir], y + DY[dir]
      local neighbor = current.neighbors[dir]
      print(neighbor == nil, nx > 0 and ny > 0 and nx <= width and ny <= height, DX[dir], DY[dir])
      if neighbor == nil and nx > 0 and ny > 0 and nx <= width and ny <= height then
        print('in', nx, ny)
        neighbor = node(nx, ny, 0)

        current.value = bit.bor(current.value, dir)
        neighbor.value = bit.bor(neighbor.value, OPPOSITE[dir])

        current.neighbors[dir] = neighbor
        neighbor.neighbors[OPPOSITE[dir]] = current

        table.insert(cells, neighbor)
        index = nil
        break
      end
    end

    if index ~= nil then
      table.remove(cells, index)
    end
  end

  print(inspect(root))

  return root
end

return generate
