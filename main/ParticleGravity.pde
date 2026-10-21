class ParticleGravity implements IParticleForceGenerator
{
  // IParticleForceGenerator
  void UpdateForce(Particle particle, float duration)
  {
    if (particle.mass == 0)
      return;
      
    Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj
      
    particle.AddForce(gravityByMass);
  }
  // ----------------------
}
