local Select = Game:addState('Select')
local quadToMovement = require('quadToMovement')

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

function Select:enteredState()
  self.bg = self.preloaded_images['BackgroundEmpty.png']
  self.scenarios = {}
  for k,v in pairs(self.preloaded_scenario_data) do
    table.insert(self.scenarios, k)
  end
  table.sort(self.scenarios)

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

  self.hoveredIndex = 0
end

function Select:draw()
  g.push('all')
  do
    g.setColor(1, 1, 1)
    local iw, ih = self.bg:getDimensions()
    local w, h = g.getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.bg, 0, 0, 0, sx, sy)
  end

  g.setColor(0, 0, 0)
  local mx, my = love.mouse.getPosition()
  self.hoveredIndex = 0

  local w, h = g.getDimensions()
  local dy = g.getFont():getHeight() * 1.25
  for i,name in ipairs(self.scenarios) do
    local y = dy * i
    g.printf(name, 0, y, g.getWidth(), 'center')

    if my > y then
      self.hoveredIndex = i
    end
  end

  do
    g.rectangle('line', 0, dy * self.hoveredIndex, g.getWidth(), dy)
  end

  do
    local atlas = require('images.birds')

    local d = g.getWidth() / #names
    local y = g.getHeight() - d
    local dx = d / 5
    for i=1,#names do
      local x = (i - 1) * d
      local quad = atlas.quads[names[i]]

      local _, _, qw, qh = quad:getViewport()
      local w, h = dx, dx
      local sx, sy = w / qw, h / qh
      g.setColor(1, 1, 1)
      g.rectangle('line', x, y, d, d)
      local movementData = self.preloaded_movements[quadToMovement[names[i]]]
      for ox, oy, cell in movementData.grid:each() do
        if cell.active then
          g.setColor(0, 0, 0, 0.75)
          g.rectangle('fill', (x - 1) + (ox - 1) * dx, (y - 1) + (oy - 1) * dx, dx, dx)
        end

        if ox == 3 and oy == 3 then
          g.setColor(1, 1, 1)
          g.draw(atlas.texture, quad, (x - 1) + (ox - 1) * dx, (y - 1) + (oy - 1) * dx, 0, sx, sy)
        end
      end
    end
  end
  g.pop()
end

function Select:mousereleased(x, y, button, isTouch)
  local selectedScenario = self.scenarios[self.hoveredIndex]
  if selectedScenario then
    self:gotoState('Menu', self.preloaded_scenario_data[selectedScenario])
  end
end

function Select:exitedState()
end

return Select
