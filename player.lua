local Player = class('Player', Base):include(Stateful)

function Player:initialize(color)
  Base.initialize(self)

  self.color = color
  self.pieces = {}
end

return Player
