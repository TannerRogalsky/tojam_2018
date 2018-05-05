local Grid = class('Grid', Base)
local PointMass = require('grid.point_mass')
local Spring = require('grid.spring')
local vec3 = require('lib.cpml').vec3

function Grid:initialize(width, height, columns, rows)
  Base.initialize(self)

  local spacing_x = width / (columns - 1)
  local spacing_y = height / (rows - 1)
  local fixed_points = {} -- these fixed points will be used to anchor the grid to fixed positions on the screen

  self.vertices = {}
  for i=1,(columns-1) * (rows-1) * 6 do
    table.insert(self.vertices, {0, 0, 0, 0, 1, 1, 1, 1})
  end

  self.springs = {}
  self.points = {}
  for i=1,rows do
    self.points[i] = {}
    fixed_points[i] = {}
  end

  for y=1,rows do
    for x=1,columns do
      local px = (x - 1) * spacing_x
      local py = (y - 1) * spacing_y

      self.points[y][x] = PointMass:new(vec3(px, py, 0), 1)
      fixed_points[y][x] = PointMass:new(vec3(px, py, 0), 0)
    end
  end

  for y=1,rows do
    for x=1,columns do
      if x == 1 or y == 1 or x == columns or y == rows then
        table.insert(self.springs, Spring:new(fixed_points[y][x], self.points[y][x], 1.1, 1.1))
      elseif x % 3 == 1 and y % 3 == 1 then
        table.insert(self.springs, Spring:new(fixed_points[y][x], self.points[y][x], 0.002, 0.02))
      end

      local stiffness = 0.28
      local damping = 0.06

      if x > 1 then
        table.insert(self.springs, Spring:new(self.points[y][x - 1], self.points[y][x], stiffness, damping))
      end
      if y > 1 then
        table.insert(self.springs, Spring:new(self.points[y - 1][x], self.points[y][x], stiffness, damping))
      end
    end
  end
end

local function applyToVertex(v, p, s, t)
  local factor = (p.z + 2000) / 2000
  v[1] = (p.x - GAME_WIDTH / 2) * factor + GAME_WIDTH / 2
  v[2] = (p.y - GAME_HEIGHT / 2) * factor + GAME_HEIGHT / 2
  -- v[1] = p.x
  -- v[2] = p.y
  v[3] = s
  v[4] = t

  -- v[5] = r
  -- v[6] = g
  -- v[7] = b
  -- v[8] = a
end

function Grid:update(dt)
  for i,spring in ipairs(self.springs) do
    spring:update(dt)
  end

  local points = self.points
  for y,row in ipairs(points) do
    for x,point in ipairs(row) do
      point:update(dt)
    end
  end

  local vertex_index = 1
  local vertices = self.vertices
  local w, h = #points, #points[1]

  for y=2,w do
    for x=2,h do
      local br = points[y][x].position
      local bl = points[y][x - 1].position
      local tl = points[y - 1][x - 1].position
      local tr = points[y - 1][x].position

      -- applyToVertex(vertices[vertex_index + 0], tl, 0, 0)
      -- applyToVertex(vertices[vertex_index + 1], bl, 0, 1)
      -- applyToVertex(vertices[vertex_index + 2], tr, 1, 0)
      -- applyToVertex(vertices[vertex_index + 3], tr, 1, 0)
      -- applyToVertex(vertices[vertex_index + 4], bl, 0, 1)
      -- applyToVertex(vertices[vertex_index + 5], br, 1, 1)

      applyToVertex(vertices[vertex_index + 0], tl, (x-1)/w, (y-1)/h)
      applyToVertex(vertices[vertex_index + 1], bl, (x-1)/w, y/h)
      applyToVertex(vertices[vertex_index + 2], tr, x/w, (y-1)/h)
      applyToVertex(vertices[vertex_index + 3], tr, x/w, (y-1)/h)
      applyToVertex(vertices[vertex_index + 4], bl, (x-1)/w, y/h)
      applyToVertex(vertices[vertex_index + 5], br, x/w, y/h)

      vertex_index = vertex_index + 6
    end
  end

  -- print('')
  -- for i,v in ipairs(vertices) do
  --   print(i,unpack(v))
  -- end
end

function Grid:applyDirectedForce(force, position, radius)
  local mforce = vec3()
  for y,row in ipairs(self.points) do
    for x,point in ipairs(row) do
      if position:dist2(point.position) < radius * radius then
        force:scale(10, mforce):scale(1 / (10 + position:dist(point.position)), mforce)
        point:applyForce(mforce)
      end
    end
  end
end

function Grid:applyImplosiveForce(force, position, radius)
  local mforce = vec3()
  for y,row in ipairs(self.points) do
    for x,point in ipairs(row) do
      local dist2 = position:dist2(point.position)
      if dist2 < radius * radius then
        position:sub(point.position, mforce):scale(force, mforce):scale(10, mforce):scale(1 / (100 + dist2), mforce)
        point:applyForce(mforce)
        point:increaseDamping(0.6)
      end
    end
  end
end

function Grid:applyExplosiveForce(force, position, radius)
  local mforce = vec3()
  for y,row in ipairs(self.points) do
    for x,point in ipairs(row) do
      local dist2 = position:dist2(point.position)
      if dist2 < radius * radius then
        point.position:sub(position, mforce):scale(force, mforce):scale(100, mforce):scale(1 / (10000 + dist2), mforce)
        -- point:applyForce((point.position - position) * force * 100 / (10000 + dist2))
        point:applyForce(mforce)
        point:increaseDamping(0.6)
      end
    end
  end
end

return Grid

-- do
--   local points = self.grid.points
--   local w, h = #points, #points[1]
--   local lx, ly, ux, uy, ulx, uly
--   for y=1,w do
--     for x=1,h do
--       local px, py = toVec2(points[y][x].position)
--       -- g.circle('fill', px, py, 10)
--       if x > 1 then
--         lx, ly = toVec2(points[y][x - 1].position)
--         g.line(lx, ly, px, py)

--         -- lx, ly = toVec2(points[y][x - 1].position)
--         -- local clamped_x = math.min(x + 1, h - 1)
--         -- -- print(clamped_x, y, w, h, points[y][clamped_x])

--         -- local ax, ay = toVec2(points[y][x - 2].position)
--         -- local dx, dy = toVec2(points[y][clamped_x].position)
--         -- local left, p = vec2(lx, ly), vec2(px, py)
--         -- local mid = catmullRom(vec2(ax, ay), left, p, vec2(dx, dy), 0.5)

--         -- if mid:dist2((left + p) / 2) > 1 then
--         --   g.line(lx, ly, mid.x, mid.y)
--         --   g.line(mid.x, mid.y, px, py)
--         -- else
--         --   g.line(lx, ly, px, py)
--         -- end
--       end
--       if y > 1 then
--         ux, uy = toVec2(points[y - 1][x].position)
--         g.line(ux, uy, px, py)
--       end
--       -- if x > 1 and y > 1 then
--       --   ulx, uly = toVec2(points[y - 1][x - 1].position)
--       --   g.line(0.5 * (ulx + ux), 0.5 * (uly + uy), 0.5 * (lx + px), 0.5 * (ly + py))
--       --   g.line(0.5 * (ulx + lx), 0.5 * (uly + ly), 0.5 * (ux + px), 0.5 * (uy + py))
--       -- end
--     end
--   end
-- end

-- public void ApplyDirectedForce(Vector3 force, Vector3 position, float radius)
-- {
--     foreach (var mass in points)
--         if (Vector3.DistanceSquared(position, mass.Position) < radius * radius)
--             mass.ApplyForce(10 * force / (10 + Vector3.Distance(position, mass.Position)));
-- }

-- public void ApplyImplosiveForce(float force, Vector3 position, float radius)
-- {
--     foreach (var mass in points)
--     {
--         float dist2 = Vector3.DistanceSquared(position, mass.Position);
--         if (dist2 < radius * radius)
--         {
--             mass.ApplyForce(10 * force * (position - mass.Position) / (100 + dist2));
--             mass.IncreaseDamping(0.6f);
--         }
--     }
-- }

-- public void ApplyExplosiveForce(float force, Vector3 position, float radius)
-- {
--     foreach (var mass in points)
--     {
--         float dist2 = Vector3.DistanceSquared(position, mass.Position);
--         if (dist2 < radius * radius)
--         {
--             mass.ApplyForce(100 * force * (mass.Position - position) / (10000 + dist2));
--             mass.IncreaseDamping(0.6f);
--         }
--     }
-- }

-- Spring[] springs;
-- PointMass[,] points;

-- public Grid(Rectangle size, Vector2 spacing)
-- {
--   var springList  = new List();

--   int numColumns = (int)(size.Width / spacing.X) + 1;
--   int numRows = (int)(size.Height / spacing.Y) + 1;
--   points = new PointMass[numColumns, numRows];

--   // these fixed points will be used to anchor the grid to fixed positions on the screen
--   PointMass[,] fixedPoints = new PointMass[numColumns, numRows];

--   // create the point masses
--   int column = 0, row = 0;
--   for (float y = size.Top; y <= size.Bottom; y += spacing.Y)
--   {
--     for (float x = size.Left; x <= size.Right; x += spacing.X)
--     {
--       points[column, row] = new PointMass(new Vector3(x, y, 0), 1);
--       fixedPoints[column, row] = new PointMass(new Vector3(x, y, 0), 0);
--       column++;
--     }
--     row++;
--     column = 0;
--   }

--   // link the point masses with springs
--   for (int y = 0; y < numRows; y++)
--     for (int x = 0; x < numColumns; x++)
--     {
--       if (x == 0 || y == 0 || x == numColumns - 1 || y == numRows - 1)  // anchor the border of the grid
--         springList.Add(new Spring(fixedPoints[x, y], points[x, y], 0.1f, 0.1f));
--       else if (x % 3 == 0 && y % 3 == 0)                  // loosely anchor 1/9th of the point masses
--         springList.Add(new Spring(fixedPoints[x, y], points[x, y], 0.002f, 0.02f));

--       const float stiffness = 0.28f;
--       const float damping = 0.06f;
--       if (x > 0)
--         springList.Add(new Spring(points[x - 1, y], points[x, y], stiffness, damping));
--       if (y > 0)
--         springList.Add(new Spring(points[x, y - 1], points[x, y], stiffness, damping));
--     }

--   springs = springList.ToArray();
-- }
