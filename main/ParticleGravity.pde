class ParticleGravity implements IParticleForceGenerator
{
  Vector3D gravity = new Vector3D(0, 9.81, 0);
  
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
