class ParticleStaticFriction implements IParticleForceGenerator
{
  // IParticleForceGenerator
  void UpdateForce(Particle particle, float duration)
  {
    if (particle.mass == 0)
      return;

    if (particle.linearVelocity.Norm() > 0.2f)
      return;

    Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj
    
    Vector3D normalGravityApplied = gravityByMass.MultiplyByScalar(-1);

    float total = normalGravityApplied.Norm() * particle.coefStaticFriction;

    if (particle.accumForce.Norm() < total)
    {
        particle.AddForce(particle.accumForce.MultiplyByScalar(-1));
    }
  }
  // ----------------------
}
