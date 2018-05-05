local Player = class('Player', Base):include(Stateful)

function Player:initialize()
  Base.initialize(self)

  self.pieces = {}
end

return Player
