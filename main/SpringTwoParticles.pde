class SpringTwoParticles extends Spring
{
    Particle firstParticle;
    Particle secondParticle;


    SpringTwoParticles(float length, float elasticity, float cDamping, boolean isBungee){
        super(length, elasticity, cDamping, isBungee);
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

        ParticleSpringForceGenerator firstParticleForce = 
            new ParticleSpringForceGenerator(
                secondParticle.position, 
                secondParticle.linearVelocity, 
                isBungee, elasticity, length, cDamping
            );

        ParticleSpringForceGenerator secondParticleForce = 
            new ParticleSpringForceGenerator(
                firstParticle.position, 
                firstParticle.linearVelocity, 
                isBungee, elasticity, length, cDamping
            );

        particleForceRegistry.Add(firstParticle, firstParticleForce);
        particleForceRegistry.Add(secondParticle, secondParticleForce);
    }
}