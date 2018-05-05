local Spring = class('Spring', Base)
local vec3 = require('lib.cpml').vec3

function Spring:initialize(end1, end2, stiffness, damping)
  Base.initialize(self)

  self.end1 = end1
  self.end2 = end2
  self.stiffness = stiffness
  self.damping = damping

  self.target_length = end1.position:dist(end2.position) * 0.95
end

function Spring:update(dt)
  local x = self.end1.position:sub(self.end2.position)

  local length = x:len()
  -- only pull, never push
  if length <= self.target_length then
    return
  end

  x:scale(1 / length, x):scale(length - self.target_length, x)

  local dv = self.end2.velocity:sub(self.end2.velocity)
  local force = x:scale(self.stiffness, x):sub(dv:scale(self.damping), x) -- reuses x!!! CAREFUL

  self.end2:applyForce(force)
  self.end1:applyForce(force:invert(force))
end

return Spring

-- private struct Spring
-- {
--   public PointMass End1;
--   public PointMass End2;
--   public float TargetLength;
--   public float Stiffness;
--   public float Damping;

--   public Spring(PointMass end1, PointMass end2, float stiffness, float damping)
--   {
--     End1 = end1;
--     End2 = end2;
--     Stiffness = stiffness;
--     Damping = damping;
--     TargetLength = Vector3.Distance(end1.Position, end2.Position) * 0.95f;
--   }

--   public void Update()
--   {
--     var x = End1.Position - End2.Position;

--     float length = x.Length();
--     // these springs can only pull, not push
--     if (length <= TargetLength)
--       return;

--     x = (x / length) * (length - TargetLength);
--     var dv = End2.Velocity - End1.Velocity;
--     var force = Stiffness * x - dv * Damping;

--     End1.ApplyForce(-force);
--     End2.ApplyForce(force);
--   }
-- }
