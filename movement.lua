local Movement = class('Movement', Base):include(Stateful)

function Movement:initialize(movementData)
  Base.initialize(self)

  self.data = movementData
  self.grid = Grid:new(movementData.width, movementData.height)
  for index, active in pairs(movementData.data) do
    local x = (index - 1) % movementData.width + 1
    local y = math.floor((index - 1) / movementData.width + 1)
    self.grid:set(x, y, {})
  end
  for index, active in pairs(movementData.data) do
    local x = (index - 1) % movementData.width + 1
    local y = math.floor((index - 1) / movementData.width + 1)
    self.grid:get(x, y, 0).active = self.grid:get(x, y, 0).active or active > 0
    self.grid:get(x, y, 90).active = self.grid:get(x, y, 90).active or active > 0
    self.grid:get(x, y, 180).active = self.grid:get(x, y, 180).active or active > 0
    self.grid:get(x, y, 270).active = self.grid:get(x, y, 270).active or active > 0
  end
end

return Movement
