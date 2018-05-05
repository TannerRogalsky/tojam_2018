local PointMass = class('PointMass', Base)
local vec3 = require('lib.cpml').vec3

function PointMass:initialize(position, inverse_mass)
  Base.initialize(self)

  self.position = position:clone()
  self.velocity  = vec3()
  self.inverse_mass = inverse_mass

  self.acceleration = vec3()
  self.damping = 0.98
end

function PointMass:applyForce(force)
  self.acceleration = self.acceleration + force * self.inverse_mass
end

function PointMass:increaseDamping(factor)
  self.damping = self.damping * factor
end

function PointMass:update(dt)
  self.velocity:add(self.acceleration, self.velocity)
  self.position:add(self.velocity, self.position)

  self.acceleration.x = 0
  self.acceleration.y = 0
  self.acceleration.z = 0

  if self.velocity:len2() < (0.001 * 0.001) then
    self.velocity.x = 0
    self.velocity.y = 0
    self.velocity.z = 0
  end

  self.velocity:scale(self.damping, self.velocity)

  self.damping = 0.98
end

return PointMass


-- private class PointMass
-- {
--   public Vector3 Position;
--   public Vector3 Velocity;
--   public float InverseMass;

--   private Vector3 acceleration;
--   private float damping = 0.98f;

--   public PointMass(Vector3 position, float invMass)
--   {
--     Position = position;
--     InverseMass = invMass;
--   }

--   public void ApplyForce(Vector3 force)
--   {
--     acceleration += force * InverseMass;
--   }

--   public void IncreaseDamping(float factor)
--   {
--     damping *= factor;
--   }

--   public void Update()
--   {
--     Velocity += acceleration;
--     Position += Velocity;
--     acceleration = Vector3.Zero;
--     if (Velocity.LengthSquared() < 0.001f * 0.001f)
--       Velocity = Vector3.Zero;

--     Velocity *= damping;
--     damping = 0.98f;
--   }
-- }
