class ParticleSpring implements IParticleForceGenerator
{
    Particle other;
    float k;
    float restLength;
    float c;

    ParticleSpring(Particle other, float k, float restLength, float c){
        this.other = other;
        this.k = k;
        this.restLength = restLength;
        this.c = c;
    }

    void UpdateForce(Particle particle, float duration){
        if (particle == null || other == null)
            return;

        Vector3D d = other.position.Substract(particle.position);

        float l = d.Norm();

        if (l == 0)
            return;

        float stretchAmount = l - restLength;

        d = d.Normalize();

        particle.AddForce(d.MultiplyByScalar((k * stretchAmount)));

        Vector3D relVelocity = other.linearVelocity.Substract(particle.linearVelocity);

        particle.AddForce(relVelocity.MultiplyByScalar(c));
    }

}