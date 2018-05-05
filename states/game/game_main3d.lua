local Main = Game:addState('Main3D')
local iqm = require('lib.iqm')
local cpml = require('lib.cpml')

function Main:enteredState()
  local Camera = require('lib/camera')
  self.camera = Camera:new()

  self.model = iqm.load('models/alien.iqm')
  local texture = g.newImage('images/alien.png', { mipmaps = true })
  texture:setMipmapFilter('nearest')
  texture:setFilter('linear', 'linear', 16)
  self.model.mesh:setTexture(texture)

  self.shader = g.newShader('shaders/default_perspective.glsl')

  self.model.textures = {
    alien = g.newImage('images/alien.png', { mipmaps = true })
  }
  for _, texture in pairs(self.model.textures) do
    texture:setFilter('linear', 'linear', 16)
  end
  for _, buffer in ipairs(self.model) do
    local texture = self.model.textures[buffer.material]
    self.model.mesh:setTexture(texture)
    self.model.mesh:setDrawRange(buffer.first, buffer.last)
  end

  -- print(inspect(self.model))
  -- print(inspect(self.model.mesh:getVertexFormat()))

  self.m = g.newMesh({
    { 'VertexPosition', 'float', 4 },
    { 'VertexColor', 'float', 4 },
  }, {
    -- {  0.0, -0.5, 0.0, 1, 0, 0, 1 },
    -- {  0.5,  0.5, 0.0, 1, 0, 0, 1 },
    -- { -0.5,  0.5, 0.0, 1, 0, 0, 1 },

    {  0.0, -0.5, 0.0,  1.0,    0, 1, 0, 1 },
    {  0.5,  0.5, 0.0,  1.0,    0, 1, 0, 1 },
    {  0.75, 0.0, 1.0,  1.0,    0, 1, 0, 1 },
  }, 'triangles', 'static')

  -- print(inspect(self.m:getVertices()))
  for i=1,self.m:getVertexCount() do
    print(self.m:getVertex(i))
  end

  g.setFont(self.preloaded_fonts['04b03_16'])
end

function Main:update(dt)
end

function Main:draw()
  self.camera:set()

  g.push('all')
  g.setShader(self.shader)

  local projection = cpml.mat4.from_perspective(90, g.getWidth() / g.getHeight(), 0.1, 1000)
  local camera = cpml.mat4()
  camera:translate(camera, cpml.vec3(0, 0, -15))
  -- camera:rotate(camera, -math.pi / 2, cpml.vec3.unit_x)
  camera:rotate(camera, love.timer.getTime(), cpml.vec3.unit_x)
  self.shader:send('proj', (camera * projection):to_vec4s())

  -- g.rotate(love.timer.getTime())
  g.circle('fill', 10, 0, 1, 50)
  g.draw(self.m)
  g.draw(self.model.mesh)
  g.pop()

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
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
