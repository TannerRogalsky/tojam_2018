local Title = Game:addState('Title')

function Title:enteredState()
  self.bg = self.preloaded_images['Title.png']
end

function Title:draw()
  do
    g.setColor(1, 1, 1)
    local iw, ih = self.bg:getDimensions()
    local w, h = g.getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.bg, 0, 0, 0, sx, sy)
  end
end

function Title:keyreleased()
  self:gotoState('Select')
end

function Title:mousereleased()
  self:gotoState('Select')
end

function Title:exitedState()
end

return Title
