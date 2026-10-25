class SpringParticleAnchor extends Spring
{
    Particle particle;
    Vector3D anchor;
    boolean hasRegisteredAnchor = false;

    SpringParticleAnchor(float length, float elasticity, float cDamping, boolean isBungee){
        super(length, elasticity, cDamping, isBungee);
    }

    void RegisterNewParticle(Particle particle){
        if (particle == null)
            return;

        this.particle = particle;
    }

    void RegisterAnchor(Vector3D anchor){
        this.anchor = anchor;
        hasRegisteredAnchor = true;
    }

    void ApplySpringForces(){
        if (particle == null || hasRegisteredAnchor == false)
            return;

        ParticleSpringForceGenerator particleForce = 
            new ParticleSpringForceGenerator(
                anchor, 
                new Vector3D(0, 0, 0), 
                isBungee, elasticity, length, cDamping
            );

        particleForceRegistry.Add(particle, particleForce);
    }
}