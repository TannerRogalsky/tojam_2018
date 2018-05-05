local alpha = 0.5
local pow = math.pow

local function getT(t, p0, p1)
      local a = pow((p1.x-p0.x), 2.0) + pow((p1.y-p0.y), 2.0)
      local b = pow(a, 0.5)
      local c = pow(b, alpha)

      return c + t
end

local function catmullRom(p0, p1, p2, p3, t)
  local t0 = 0
  local t1 = getT(t0, p0, p1)
  local t2 = getT(t1, p1, p2)
  local t3 = getT(t2, p2, p3)

  local t = (t1 + t2) / 2

  local A1 = (t1-t)/(t1-t0)*p0 + (t-t0)/(t1-t0)*p1
  local A2 = (t2-t)/(t2-t1)*p1 + (t-t1)/(t2-t1)*p2
  local A3 = (t3-t)/(t3-t2)*p2 + (t-t2)/(t3-t2)*p3

  local B1 = (t2-t)/(t2-t0)*A1 + (t-t0)/(t2-t0)*A2
  local B2 = (t3-t)/(t3-t1)*A2 + (t-t1)/(t3-t1)*A3

  local C = (t2-t)/(t2-t1)*B1 + (t-t1)/(t2-t1)*B2

  return C
end

return catmullRom

-- void CatmulRom()
-- {
--   newPoints.Clear();

--   Vector2 p0 = new Vector2(points[0].transform.position.x, points[0].transform.position.y);
--   Vector2 p1 = new Vector2(points[1].transform.position.x, points[1].transform.position.y);
--   Vector2 p2 = new Vector2(points[2].transform.position.x, points[2].transform.position.y);
--   Vector2 p3 = new Vector2(points[3].transform.position.x, points[3].transform.position.y);

--   float t0 = 0.0f;
--   float t1 = GetT(t0, p0, p1);
--   float t2 = GetT(t1, p1, p2);
--   float t3 = GetT(t2, p2, p3);

--   for(float t=t1; t<t2; t+=((t2-t1)/amountOfPoints))
--   {
--       Vector2 A1 = (t1-t)/(t1-t0)*p0 + (t-t0)/(t1-t0)*p1;
--       Vector2 A2 = (t2-t)/(t2-t1)*p1 + (t-t1)/(t2-t1)*p2;
--       Vector2 A3 = (t3-t)/(t3-t2)*p2 + (t-t2)/(t3-t2)*p3;

--       Vector2 B1 = (t2-t)/(t2-t0)*A1 + (t-t0)/(t2-t0)*A2;
--       Vector2 B2 = (t3-t)/(t3-t1)*A2 + (t-t1)/(t3-t1)*A3;

--       Vector2 C = (t2-t)/(t2-t1)*B1 + (t-t1)/(t2-t1)*B2;

--       newPoints.Add(C);
--   }
-- }

-- float GetT(float t, Vector2 p0, Vector2 p1)
-- {
--     float a = Mathf.Pow((p1.x-p0.x), 2.0f) + Mathf.Pow((p1.y-p0.y), 2.0f);
--     float b = Mathf.Pow(a, 0.5f);
--     float c = Mathf.Pow(b, alpha);

--     return (c + t);
-- }
