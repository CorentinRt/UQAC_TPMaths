class ParticleImpulse implements IParticleForceGenerator
{
  Vector3D impulse;
  
  ParticleImpulse(Vector3D impulse)
  {
    this.impulse = impulse;
  }
  
  void UpdateForce(Particle particle, float duration)
  {
    if (particle.mass == 0)
      return;
      
    particle.AddForce(impulse);
  }
}