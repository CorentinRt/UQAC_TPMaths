class ParticleSpringForceGenerator implements IParticleForceGenerator
{
    Vector3D otherPosition;
    Vector3D otherVelocity;
    float k;
    float restLength;
    float c;

    ParticleSpringForceGenerator(Vector3D otherPosition, Vector3D otherVelocity, float k, float restLength, float c){
        this.otherPosition = otherPosition;
        this.otherVelocity = otherVelocity;
        this.k = k;
        this.restLength = restLength;
        this.c = c;
    }

    void UpdateForce(Particle particle, float duration){
        if (particle == null)
            return;

        Vector3D d = otherPosition.Substract(particle.position);

        float l = d.Norm();

        if (l == 0)
            return;

        float stretchAmount = l - restLength;

        d = d.Normalize();

        particle.AddForce(d.MultiplyByScalar((k * stretchAmount)));

        Vector3D relVelocity = otherVelocity.Substract(particle.linearVelocity);

        particle.AddForce(relVelocity.MultiplyByScalar(c)); // Ajout friction
    }

}