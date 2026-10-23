class SpringParticleAnchor extends Spring
{
    Particle particle;
    Vector3D anchor;
    boolean hasRegisteredAnchor = false;

    SpringParticleAnchor(float length, float elasticity, float cDamping){
        super(length, elasticity, cDamping);
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

        ParticleSpringForceGenerator particleForce = new ParticleSpringForceGenerator(anchor, new Vector3D(0, 0, 0), elasticity, length, cDamping);

        particleForceRegistry.Add(particle, particleForce);
    }
}