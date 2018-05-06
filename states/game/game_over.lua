local Over = Game:addState('Over')

function Over:enteredState(winner)
  self.winner = winner

  self.bg = self.preloaded_images['GameOver.png']
end

function Over:draw()
  do
    g.setColor(1, 1, 1)
    local iw, ih = self.bg:getDimensions()
    local w, h = g.getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.bg, 0, 0, 0, sx, sy)
  end

  g.printf(
    {
      self.winner.color, self.winner.name .. " Player",
      {1, 1, 1, 1}, " Won!!",
    }, 0, g.getHeight() / 2, g.getWidth(), 'center'
  )
end

function Over:keyreleased()
  self:gotoState('Title')
end

function Over:mousereleased()
  self:gotoState('Title')
end

function Over:exitedState()
  self.winner = nil
end

return Over
