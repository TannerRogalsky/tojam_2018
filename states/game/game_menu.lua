local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.bg = self.preloaded_images['Instruction.png']
end

function Menu:draw()
  do
    g.setColor(1, 1, 1)
    local iw, ih = self.bg:getDimensions()
    local w, h = g.getDimensions()
    local sx, sy = w / iw, h / ih
    g.draw(self.bg, 0, 0, 0, sx, sy)
  end

end

function Menu:exitedState()
end

return Menu
