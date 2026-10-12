class ParticleForceRegistry
{
  ArrayList<ParticleForceRegistration> registry = new ArrayList<ParticleForceRegistration>();
  
  void Add(Particle particle, IParticleForceGenerator forceGenerator)
  {
    ParticleForceRegistration tempRegistration = new ParticleForceRegistration();
    
    tempRegistration.particle = particle;
    tempRegistration.fG = forceGenerator;
    
    registry.add(tempRegistration);
  }
  
  void Remove(Particle particle, IParticleForceGenerator forceGenerator)
  {
    ParticleForceRegistration tempRegistration = new ParticleForceRegistration();
    
    tempRegistration.particle = particle;
    tempRegistration.fG = forceGenerator;
    
    for (int i = 0; i < registry.size(); ++i)
    {
      ParticleForceRegistration registration = registry.get(i);
      
      if (registration == null)
        continue;
        
        if (registration.particle == particle && registration.fG == forceGenerator)
        {
           registry.remove(i);
           return;
        }
    }
    
    registry.remove(tempRegistration);
  }
  
  void Clear()
  {
    registry.clear();
  }
  
  void UpdateForces(float duration)
  {
    for (int i = 0; i < registry.size(); ++i)
    {
      ParticleForceRegistration registration = registry.get(i);
      
      if (registration == null)
        continue;
      
      registration.fG.UpdateForce(registration.particle, duration);
    }   
  }
}


class ParticleForceRegistration
{
  Particle particle;
  IParticleForceGenerator fG;
}
