local CloudManager = class('CloudManager', Base)

function CloudManager:initialize(img)
  Base.initialize(self)

  self.img = img

  local w, h = g.getDimensions()
  self.clouds = {}
  for i=1,love.math.random(6) do
    table.insert(self.clouds, {
      x = love.math.random(w),
      y = love.math.random(h),
      vx = love.math.random(100) + 100,
      vy = (love.math.random(200) - 100) * 0.5,
    })
  end

  self.t = 0
end

function CloudManager:update(dt)
  self.t = self.t + dt
  if self.t > 1 then
    self.t = self.t - 1
    table.insert(self.clouds, {
      x = -self.img:getWidth(),
      y = love.math.random(g.getHeight()),
      vx = love.math.random(100) + 100,
      vy = (love.math.random(200) - 100) * 0.5,
    })
  end

  local w = g.getWidth()
  for i,cloud in ipairs(self.clouds) do
    cloud.x = cloud.x + cloud.vx * dt
    cloud.y = cloud.y + cloud.vy * dt

    if cloud.x > w then
      table.remove(self.clouds, i)
    end
  end
end

function CloudManager:draw()
  for i,cloud in ipairs(self.clouds) do
    g.draw(self.img, cloud.x, cloud.y)
  end
end

return CloudManager
