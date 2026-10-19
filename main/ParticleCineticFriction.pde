class ParticleCineticFriction implements IParticleForceGenerator
{
    Vector3D gravity = new Vector3D(0, 9.81, 0);    

    void UpdateForce(Particle particle, float duration)
    {
        if (particle.mass == 0)
            return;

        if (particle.linearVelocity.Norm() <= 0.2f)
            return;

        Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj
        
        Vector3D normalGravityApplied = gravityByMass.MultiplyByScalar(-1);

        float totalCineticFrictionNorm = normalGravityApplied.Norm() * particle.coefCineticFriction;

        Vector3D currentForceAppliedNormalized = particle.accumForce;
        currentForceAppliedNormalized = currentForceAppliedNormalized.Normalize();

        Vector3D cineticFriction = currentForceAppliedNormalized.MultiplyByScalar(-1 * totalCineticFrictionNorm);

        particle.AddForce(cineticFriction);
    }
}