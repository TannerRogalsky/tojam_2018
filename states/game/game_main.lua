local Main = Game:addState('Main')
local getPieceAt = require('getPieceAt')
local buildScenario = require('buildScenario')

function Main:enteredState()
  local Camera = require('lib/camera')
  self.camera = Camera:new()

  self.bg = self.preloaded_images['background.png']

  self.grid = Grid:new(7, 7)
  for x, y, _ in self.grid:each() do
    self.grid:set(x, y, {})
  end
  self.grid.wrapX = true
  -- self.grid.wrapY = true
  do
    function Grid:pixelDimensions()
      local w, h = g.getDimensions()
      return h / self.width * 0.8, h / self.height * 0.8
    end
    local w, h = self.grid:pixelDimensions()
    local centerOffsetX = g.getWidth() / 2 - w * self.grid.width / 2
    local centerOffsetY = g.getHeight() / 2 - h * self.grid.height / 2
    function Grid:toPixels(x, y)
      local w, h = self:pixelDimensions()
      return (x - 1) * h + centerOffsetX, (y - 1) * h + centerOffsetY
    end
    function Grid:toGrid(x, y)
      local w, h = self:pixelDimensions()
      return (x - centerOffsetX) / h + 1, (y - centerOffsetY) / h + 1
    end
    function Grid:toGridFloored(x, y)
      local w, h = self:pixelDimensions()
      return math.floor((x - centerOffsetX) / h + 1), math.floor((y - centerOffsetY) / h + 1)
    end
  end

  do -- fuck you mean
    local img = love.image.newImageData(1, 1)
    img:setPixel(0, 0, 1, 1, 1, 1)
    self.gridBatch = g.newSpriteBatch(
      g.newImage(img),
      self.grid.width * self.grid.height,
      'static'
    )
    local quad = g.newQuad(0, 0, 1, 1, 1, 1)
    local w, h = self.grid:pixelDimensions()
    local index = 0
    self.gridBatch:setColor(0, 0, 0, 0.3)
    for x, y, _ in self.grid:each() do
      local px, py = self.grid:toPixels(x, y)
      if index % 2 == 0 then
        self.gridBatch:add(px, py, 0, w, h)
      end
      index = index + 1
    end
  end

  do -- players and pieces
    local atlas = require('images.birds')

    self.pieceBatch = g.newSpriteBatch(
      atlas.texture,
      self.grid.width * self.grid.height,
      'stream'
    )
    self.bgPieceBatch = g.newSpriteBatch(
      atlas.texture,
      self.grid.width * self.grid.height,
      'stream'
    )

    local names = {
      'Bird-Flamingo.png',
      'Bird-Hawk.png',
      'Bird-Owl.png',
      'Bird-Pelican.png',
      'Bird-Pigeon.png',
      'Bird-Tucan.png',
      'Bird-Vulture.png',
      'Bird-Woodpecker.png',
    }
    local quadToMovement = {
        [atlas.quads['Bird-Flamingo.png']] = Movement:new(self.preloaded_movement_data.lpiece1),
        [atlas.quads['Bird-Hawk.png']] = Movement:new(self.preloaded_movement_data.tpiece1),
        [atlas.quads['Bird-Owl.png']] = Movement:new(self.preloaded_movement_data.line1),
        [atlas.quads['Bird-Pelican.png']] = Movement:new(self.preloaded_movement_data.square1),
        [atlas.quads['Bird-Pigeon.png']] = Movement:new(self.preloaded_movement_data.triangle1),
        [atlas.quads['Bird-Tucan.png']] = Movement:new(self.preloaded_movement_data.square2),
        [atlas.quads['Bird-Vulture.png']] = Movement:new(self.preloaded_movement_data.triangle1),
        [atlas.quads['Bird-Woodpecker.png']] = Movement:new(self.preloaded_movement_data.square2),
    }

    local function buildPiece(x, y)
      local i = love.math.random(1, #names)
      local quad = atlas.quads[names[i]]
      return Piece:new(x, y, quadToMovement[quad], quad)
    end

    local p1 = Player:new({213 / 255, 66 / 255, 194 / 255, 1})
    table.insert(p1.pieces, buildPiece(1, 1))
    local p2 = Player:new({27 / 255, 169 / 255, 235 / 255, 1})
    table.insert(p2.pieces, buildPiece(4, 4))
    table.insert(p2.pieces, buildPiece(4, 3))
    self.players = buildScenario('scenarios.scenario1', atlas, self.preloaded_movement_data)
    self.activePlayerIndex = 1
  end

  g.setFont(self.preloaded_fonts['04b03_24'])
  self.dehueShader = g.newShader('shaders/dehue.glsl')
end

function Main:update(dt)
  -- WIN CONDITION
  for _, player in ipairs(self.players) do
    if #player.pieces == 0 then
      self:gotoState('Main')
      return
    end
  end

  do -- update movement powers
    for _, player in ipairs(self.players) do -- is the space occupied?
      for _, piece in ipairs(player.pieces) do
        local cell = self.grid:get(piece.x, piece.y)
        cell.movement = piece.movement
        cell.quad = piece.quad
        cell.player = player
      end
    end
    self.bgPieceBatch:clear()
    for x, y, cell in self.grid:each() do
      if cell.quad then
        local _, _, qw, qh = cell.quad:getViewport()
        local w, h = self.grid:pixelDimensions()
        local sx, sy = w / qw, h / qh
        local px, py = self.grid:toPixels(x, y)
        self.bgPieceBatch:setColor(cell.player.color)
        self.bgPieceBatch:add(cell.quad, px, py, 0, sx, sy)
      end
    end
  end

  do -- pieceBatch
    self.pieceBatch:clear()
    for _, player in ipairs(self.players) do
      for _, piece in ipairs(player.pieces) do
        local _, _, qw, qh = piece.quad:getViewport()
        local w, h = self.grid:pixelDimensions()
        local sx, sy = w / qw, h / qh
        local px, py = self.grid:toPixels(piece.x, piece.y)
        self.pieceBatch:setColor(player.color)
        self.pieceBatch:add(piece.quad, px, py, 0, sx, sy)
      end
    end
  end
end

function Main:draw()
  do
    local iw, ih = self.bg:getDimensions()
    local w, h = g.getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.bg, 0, 0, 0, sx, sy)
  end
  g.draw(self.gridBatch)
  do
    local x, y = self.grid:toPixels(0.25, 0.25)
    local gw, gh = self.grid:pixelDimensions()
    local w, h = (self.grid.width + 1.5) * gw, (self.grid.height + 1.5) * gh
    local iw, ih = self.preloaded_images['frame.png']:getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.preloaded_images['frame.png'], x, y, 0, sx, sy)
  end

  g.push('all')
  g.setShader(self.dehueShader)
  -- g.setColorMask(true, false, true, true)
  g.setColor(1, 1, 1, 0.3)
  g.draw(self.bgPieceBatch)
  g.setColor(1, 1, 1)
  g.draw(self.pieceBatch)
  g.pop()

  if self.selectedPiece then
    local piece = self.selectedPiece
    local mx, my = love.mouse.getPosition()
    local gx, gy = piece.x, piece.y
    local w, h = self.grid:pixelDimensions()
    do
      local x, y = self.grid:toPixels(gx, gy)
      g.push('all')
      g.setColor(1, 1, 0, 0.5)
      local ox, oy = math.floor(piece.movement.data.width / 2), math.floor(piece.movement.data.height / 2)
      for dx, dy, cell in piece.movement.grid:each() do
        local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
        if not self.grid:out_of_bounds(gx, gy) and cell.active then
          local x, y = self.grid:toPixels(gx, gy)
          g.rectangle('fill', x, y, w, h)
        end
      end

      g.setColor(1, 0, 0, 0.5)
      g.rectangle('fill', x, y, w, h)
      g.pop()
    end
  end

  do -- hovered
    local mx, my = love.mouse.getPosition()
    local gx, gy = self.grid:toGridFloored(mx, my)
    local w, h = self.grid:pixelDimensions()
    if not self.grid:out_of_bounds(gx, gy) then
      local cell = self.grid:get(gx, gy)
      local x, y = self.grid:toPixels(gx, gy)
      g.push('all')
      if cell.movement then
        g.setColor(1, 1, 0, 0.5)
        local ox, oy = math.floor(cell.movement.data.width / 2), math.floor(cell.movement.data.height / 2)
        for dx, dy, cell in cell.movement.grid:each() do
          local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
          if not self.grid:out_of_bounds(gx, gy) and cell.active then
            local x, y = self.grid:toPixels(gx, gy)
            g.rectangle('line', x, y, w, h)
          end
        end
      end

      g.setColor(1, 0, 0, 0.5)
      g.rectangle('line', x, y, w, h)
      g.pop()
    end
  end

  do
    local _, y = self.grid:toPixels(1, 1)
    g.printf(
      {
        self.players[self.activePlayerIndex].color, "Player" .. self.activePlayerIndex,
        {0, 0, 0, 1}, "'s Turn",
      }, 0, y - 50, g.getWidth(), 'center'
    )
  end
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  if self.selectedPiece then
    local piece = self.selectedPiece
    local mx, my = self.grid:toGridFloored(x, y)
    local gx, gy = piece.x, piece.y
    if mx ~= gx or my ~= gy then -- you can't move to the same square
      local ox, oy = math.floor(piece.movement.data.width / 2), math.floor(piece.movement.data.height / 2)
      for dx, dy, cell in piece.movement.grid:each() do
        local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
        local selfOccupied = getPieceAt(self.players[self.activePlayerIndex], self.grid, gx, gy) -- our own piece is in the way
        if not selfOccupied and not self.grid:out_of_bounds(gx, gy) and cell.active and gx == mx and gy == my then
          for _, player in ipairs(self.players) do -- is the space occupied?
            local killed, index = getPieceAt(player, self.grid, gx, gy)
            if killed then
              table.remove(player.pieces, index)
            end
          end

          do
            local sx, sy = self.grid:toPixels(mx, my)
            local tx, ty = self.grid:toPixels(gx, gy)
            local cx, cy = love.math.random(g.getWidth()), love.math.random(g.getHeight())
            self.pieceMovement = {
              curve = love.math.newBezierCurve(sx, sy, cx, cy, tx, ty),
              t = 0,
              callback = function()
              end
            }
          end

          piece.x = gx
          piece.y = gy

          local cell = self.grid:get(gx, gy)
          if cell.movement then
            piece.quad = cell.quad
            piece.movement = cell.movement
          end
          self.activePlayerIndex = (self.activePlayerIndex % #self.players) + 1
          break
        end
      end
    end
    self.selectedPiece = nil
  else
    self.selectedPiece = getPieceAt(self.players[self.activePlayerIndex], self.grid, self.grid:toGridFloored(x, y))
  end
end

function Main:keypressed(key, scancode, isrepeat)
  if key == 'r' then
    love.event.quit('restart')
  end
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
