local Piece = class('Piece', Base):include(Stateful)

function Piece:initialize(x, y, movement, quad)
  Base.initialize(self)

  self.quad = quad
  self.x = x
  self.y = y
  self.movement = movement
end

return Piece
