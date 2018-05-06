local Main = Game:addState('Main')
local getPieceAt = require('getPieceAt')
local buildScenario = require('buildScenario')
local CloudManager = require('cloud_manager')

function Main:enteredState(scenarioData)
  local Camera = require('lib/camera')
  self.camera = Camera:new()

  self.bg = self.preloaded_images['background.png']
  self.CloudManager = CloudManager:new(self.preloaded_images['cloud.png'])

  self.grid = Grid:new(scenarioData.width, scenarioData.height)
  for x, y, _ in self.grid:each() do
    self.grid:set(x, y, {})
  end
  self.grid.wrapX = true
  -- self.grid.wrapY = true
  do
    function Grid:pixelDimensions()
      local w, h = g.getDimensions()
      -- return w / self.width * 0.8, h / self.height * 0.8
      return h / self.height * 0.8, h / self.height * 0.8
    end
    local w, h = self.grid:pixelDimensions()
    local centerOffsetX = g.getWidth() / 2 - w * self.grid.width / 2
    local centerOffsetY = g.getHeight() / 2 - h * self.grid.height / 2
    function Grid:toPixels(x, y)
      local w, h = self:pixelDimensions()
      return (x - 1) * w + centerOffsetX, (y - 1) * h + centerOffsetY
    end
    function Grid:toGrid(x, y)
      local w, h = self:pixelDimensions()
      return (x - centerOffsetX) / w + 1, (y - centerOffsetY) / h + 1
    end
    function Grid:toGridFloored(x, y)
      local w, h = self:pixelDimensions()
      return math.floor((x - centerOffsetX) / w + 1), math.floor((y - centerOffsetY) / h + 1)
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
    self.gridBatch:setColor(157 / 255, 216 / 255, 253 / 255, 0.3)
    for x, y, _ in self.grid:each() do
      local px, py = self.grid:toPixels(x, y)
      -- this fucked up shit accounts for even and odd sized board tiling
      if (index + (x * (1 - self.grid.height % 2))) % 2 == 0 then
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

    self.players = buildScenario(scenarioData, atlas, self.preloaded_movement_data)
    self.activePlayerIndex = 1
  end

  do
    local h = g.getHeight() * 0.05
    local fontSize = self.font_sizes[1]
    for i,v in ipairs(self.font_sizes) do
      fontSize = v
      if v > h then
        break
      end
    end
    g.setFont(self.preloaded_fonts['GrandHotel_' .. fontSize])
  end
  self.dehueShader = g.newShader('shaders/dehue.glsl')
end

function Main:update(dt)
  -- WIN CONDITION
  do
    for i=#self.players,1,-1 do
      if #self.players[i].pieces == 0 then
        table.remove(self.players, i)
      end
    end
    if #self.players == 1 then
      self:gotoState('Over', self.players[1])
      return
    end
  end

  self.CloudManager:update(dt)

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
        -- self.bgPieceBatch:setColor(cell.player.color)
        self.bgPieceBatch:setColor(0.3, 0.3, 0.3, 1)
        self.bgPieceBatch:add(cell.quad, px, py, 0, sx, sy)
      end
    end
  end

  do -- pieceBatch
    self.pieceBatch:clear()
    for _, player in ipairs(self.players) do
      self.pieceBatch:setColor(player.color)
      for _, piece in ipairs(player.pieces) do
        local _, _, qw, qh = piece.quad:getViewport()
        local w, h = self.grid:pixelDimensions()
        local sx, sy = w / qw, h / qh

        if self.pieceMovement and self.pieceMovement.piece == piece then
          local px, py = self.pieceMovement.curve:evaluate(self.pieceMovement.t)
          self.pieceBatch:add(piece.quad, px, py, 0, sx, sy)

          self.pieceMovement.t = self.pieceMovement.t + dt
          if self.pieceMovement.t > 1 then
            self.pieceMovement.callback()
            self.pieceMovement = nil
          end
        else
          local px, py = self.grid:toPixels(piece.x, piece.y)
          self.pieceBatch:add(piece.quad, px, py, 0, sx, sy)
        end
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
      local red, green, blue = unpack(self.players[self.activePlayerIndex].color)
      g.setColor(red, green, blue, 0.5)
      local ox, oy = math.floor(piece.movement.data.width / 2), math.floor(piece.movement.data.height / 2)
      for dx, dy, cell in piece.movement.grid:each() do
        local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
        if not self.grid:out_of_bounds(gx, gy) and cell.active then
          local x, y = self.grid:toPixels(gx, gy)
          g.rectangle('fill', x, y, w, h)
        end
      end

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

      local piece, player = nil, nil
      for _,p in ipairs(self.players) do
        piece = getPieceAt(p, self.grid, gx, gy)
        if piece then
          player = p
          break
        end
      end

      g.push('all')

      if piece then
        local red, green, blue = unpack(player.color)
        g.setColor(red, green, blue, 0.5)
        -- if player == self.players[self.activePlayerIndex] then
        --   g.setColor(red, green, blue, 0.5)
        -- else
        --   g.setColor(red, green, blue, 0.2)
        -- end
      else
        local red, green, blue = 0.3, 0.3, 0.3
        g.setColor(red, green, blue, 0.5)
      end
      if cell.movement and not self.selectedPiece or cell.movement and (self.selectedPiece and (self.selectedPiece.x ~= gx or self.selectedPiece.y ~= gy)) then
        local ox, oy = math.floor(cell.movement.data.width / 2), math.floor(cell.movement.data.height / 2)
        for dx, dy, cell in cell.movement.grid:each() do
          local gx, gy = self.grid:adjustForWrap(gx + dx - ox - 1, gy + dy - oy - 1)
          if not self.grid:out_of_bounds(gx, gy) and cell.active then
            local x, y = self.grid:toPixels(gx, gy)
            if player == self.players[self.activePlayerIndex] then
              g.rectangle('fill', x, y, w, h)
            else
              g.push('all')
              g.setLineWidth(math.max(1, math.floor(g.getHeight() * 0.01)))
              g.rectangle('line', x, y, w, h)
              g.pop()
            end
          end
        end
      else
        g.setColor(1, 1, 1, 1)
        g.rectangle('line', x, y, w, h)
      end
      g.pop()
    end
  end

  self.CloudManager:draw()

  do
    local _, y = self.grid:toPixels(1, 1)
    local player = self.players[self.activePlayerIndex]
    g.printf(
      {
        player.color, player.name .. " Player",
        {0, 0, 0, 1}, "'s Turn",
      }, 0, y - g.getFont():getHeight(), g.getWidth(), 'center'
    )
  end
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  if self.pieceMovement then return end

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
            local sx, sy = self.grid:toPixels(piece.x, piece.y)
            local tx, ty = self.grid:toPixels(gx, gy)
            local midX, midY = (sx + ty) / 2, (sy + ty) / 2
            local w, h = self.grid:pixelDimensions()
            local cx, cy = love.math.randomNormal(w, midX) + midX, love.math.randomNormal(h, midY)
            local curve = love.math.newBezierCurve(sx, sy, cx, cy, tx, ty)
            self.pieceMovement = {
              curve = curve,
              t = 0,
              piece = piece,
              callback = function()
                piece.x = gx
                piece.y = gy

                local cell = self.grid:get(gx, gy)
                if cell.movement then
                  piece.quad = cell.quad
                  piece.movement = cell.movement
                end
                self.activePlayerIndex = (self.activePlayerIndex % #self.players) + 1
              end
            }
          end
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
  if key == 'esc' then
    self:gotoState('Select')
  elseif game.debug and key == 'r' then
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
