local Map = class("Map", Base):include(Stateful)
local createObscuringMesh = require('map.create_obscuring_mesh')
local buildSpriteBatch = require('map.build_sprite_batch')
local growingTree = require('map.growing_tree')
local findLongestPath = require('map.find_longest_path')
local connectNeighboringDeadEnds = require('map.connect_neighboring_dead_ends')
local buildNodeGraph = require('map.build_node_graph')
local applyNotCornerBit = require('map.apply_not_corner_bit')
-- local drawMap = require('map.draw_map')

-- local createPlayer = require('create_player')

local function fixRelativePath(asset_path)
  local path = asset_path:gsub(".*/source_images/", "")
  return path
end

function Map:initialize(width, height)
  Base.initialize(self)

  self.enemies = {}
  self.collider = HC.new(128)

  local tile_width, tile_height = 64, 64
  local seed = math.floor(love.math.random(math.pow(2, 53)))
  -- seed = 802340023866905
  seed = 5933188686640389
  local random = love.math.newRandomGenerator(seed)
  self.random = random
  print(string.format('Seed: %u', seed))
  local grid, longest_path
  -- repeat
    grid = growingTree(width, height, {random = 1, newest = 1}, random)
    -- connectNeighboringDeadEnds(grid)
    -- longest_path = findLongestPath(grid)
  -- until(#longest_path >= width * 1.5)
  -- applyNotCornerBit(grid)
  local spritebatch = buildSpriteBatch(grid, width, height, tile_width, tile_height)

  self.grid_width = width
  self.grid_height = height
  self.tile_width = tile_width
  self.tile_height = tile_height
  self.batch = spritebatch
  self.start_node = longest_path[1]
  self.end_node = longest_path[#longest_path]
  -- self.node_graph = buildNodeGraph(grid)

  do
    local x, y = self:toPixel(self.end_node.x, self.end_node.y)
    self.end_collider = self.collider:rectangle(x, y, self.tile_width, self.tile_height)
  end

  self.seen = {}
  for i=1,self.grid_height do
    self.seen[i] = {}
  end

  -- self.obscuring_mesh = createObscuringMesh(self)

  -- do
  --   self.player = createPlayer(self)
  --   local x, y = self:toPixel(self.start_node.x + 0.5, self.start_node.y + 0.5)
  --   local w, h = self.tile_width * 0.9, self.tile_height * 0.9
  --   self.player.collider = self.collider:rectangle(x - w / 2, y - h / 2, w, h)
  -- end
end

function Map:toGrid(x, y)
  return math.ceil((x + 1) / self.tile_width), math.ceil((y + 1) / self.tile_height)
end

function Map:toPixel(x, y)
  return (x - 1) * self.tile_width, (y - 1) * self.tile_height
end

function Map:update(dt)
end

function Map:draw()
  -- drawMap(self)
  g.draw(self.batch)
end

return Map
