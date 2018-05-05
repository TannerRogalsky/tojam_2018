local Movement = class('Movement', Base):include(Stateful)

function Movement:initialize(movementData)
  Base.initialize(self)

  self.data = movementData
  self.grid = Grid:new(movementData.width, movementData.height)
  for index, active in pairs(movementData.data) do
    local x = (index - 1) % movementData.width + 1
    local y = math.floor((index - 1) / movementData.width + 1)
    self.grid:set(x, y, {
      active = active > 0
    })
  end
end

return Movement
