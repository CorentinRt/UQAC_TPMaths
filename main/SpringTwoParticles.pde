class SpringTwoParticles extends Spring
{
    Particle firstParticle;
    Particle secondParticle;

    SpringTwoParticles(float length, float elasticity, float cDamping){
        super(length, elasticity, cDamping);
    }

    void RegisterNewParticle(Particle particle){
        if (particle == null)
            return;

        if (firstParticle == null){
            firstParticle = particle;
        }
        else if (secondParticle == null){
            secondParticle = particle;
        }
    }


    void ApplySpringForces(){
        if (firstParticle == null || secondParticle == null)
            return;

        ParticleSpring firstParticleForce = new ParticleSpring(secondParticle, elasticity, length, cDamping);

        ParticleSpring secondParticleForce = new ParticleSpring(firstParticle, elasticity, length, cDamping);

        particleForceRegistry.Add(firstParticle, firstParticleForce);
        particleForceRegistry.Add(secondParticle, secondParticleForce);
    }
}