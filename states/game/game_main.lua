local Main = Game:addState('Main')
local getPieceAt = require('getPieceAt')

function Main:enteredState()
  local Camera = require('lib/camera')
  self.camera = Camera:new()

  self.grid = Grid:new(8, 8)
  for x, y, _ in self.grid:each() do
    self.grid:set(x, y, {})
  end
  self.grid.wrapX = true
  self.grid.wrapY = true
  do
    function Grid:pixelDimensions()
      local w, h = g.getDimensions()
      return h / self.width / 2, h / self.height / 2
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
  self.gridBatch = g.newSpriteBatch(
    self.preloaded_images['sprites.png'],
    self.grid.width * self.grid.height,
    'static'
  )
  do
    local quads = require('images.sprites').quads
    local quad = quads['tile_341.png']
    local _, _, qw, qh = quad:getViewport()
    local w, h = self.grid:pixelDimensions()
    local sx, sy = w / qw, h / qh
    for x, y, _ in self.grid:each() do
      local px, py = self.grid:toPixels(x, y)
      self.gridBatch:add(quad, px, py, 0, sx, sy)
    end
  end

  self.pieceBatch = g.newSpriteBatch(
    self.preloaded_images['chessPieces.png'],
    self.grid.width * self.grid.height,
    'stream'
  )
  self.bgPieceBatch = g.newSpriteBatch(
    self.preloaded_images['chessPieces.png'],
    self.grid.width * self.grid.height,
    'stream'
  )
  local pieceQuads = {}
  for i=1,6 do
    pieceQuads[i] = g.newQuad((i - 1) * 64, 0, 64, 64, self.pieceBatch:getTexture():getDimensions())
  end
  for i=1,6 do
    pieceQuads[i + 6] = g.newQuad((i - 1) * 64, 64, 64, 64, self.pieceBatch:getTexture():getDimensions())
  end

  local quadToMovement = {
      [pieceQuads[1]] = Movement:new(self.preloaded_movement_data.lpiece1),
      [pieceQuads[2]] = Movement:new(self.preloaded_movement_data.tpiece1),
  }

  local p1 = Player:new({1, 0, 1, 1})
  table.insert(p1.pieces, Piece:new(1, 1, quadToMovement[pieceQuads[1]], pieceQuads[1]))
  local p2 = Player:new({0, 1, 1, 1})
  table.insert(p2.pieces, Piece:new(4, 4, quadToMovement[pieceQuads[2]], pieceQuads[2]))
  table.insert(p2.pieces, Piece:new(4, 3, quadToMovement[pieceQuads[1]], pieceQuads[1]))
  self.players = { p1, p2 }
  self.activePlayerIndex = 1

  g.setFont(self.preloaded_fonts['04b03_16'])
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

  for _, player in ipairs(self.players) do
    local x, y = self.grid:toGridFloored(love.mouse.getPosition())
    self.hoveredPiece = getPieceAt(player, self.grid, x, y)
    if self.hoveredPiece then break end
  end
end

function Main:draw()
  g.draw(self.gridBatch)

  g.push('all')
  g.setShader(self.dehueShader)
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
      g.setColor(1, 1, 0)
      local ox, oy = math.floor(piece.movement.data.width / 2), math.floor(piece.movement.data.height / 2)
      for dx, dy, cell in piece.movement.grid:each() do
        local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
        if not self.grid:out_of_bounds(gx, gy) and cell.active then
          local x, y = self.grid:toPixels(gx, gy)
          g.rectangle('line', x, y, w, h)
        end
      end

      g.setColor(1, 0, 0)
      g.rectangle('line', x, y, w, h)
      g.pop()
    end
  end

  if self.hoveredPiece then
    local piece = self.hoveredPiece
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
          g.rectangle('line', x, y, w, h)
        end
      end

      g.setColor(1, 0, 0, 0.5)
      g.rectangle('line', x, y, w, h)
      g.pop()
    end
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
