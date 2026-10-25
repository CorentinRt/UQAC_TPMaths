class ParticleCineticFriction implements IParticleForceGenerator
{
    void UpdateForce(Particle particle, float duration)
    {
        if (particle.mass <= 0)
            return;

        if (particle.linearVelocity.Norm() <= 0.2f)
            return;

        Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj
        
        Vector3D gravityAppliedAlongContact = particle.contactNormal.MultiplyByScalar(particle.contactNormal.ScalarProduct(gravityByMass));

        Vector3D forceAppliedAlongContact = particle.accumForce.Normalize().MultiplyByScalar(gravityAppliedAlongContact.Norm());

        float frictionCineticMagnitude = gravityAppliedAlongContact.MultiplyByScalar(-1).Norm() * particle.coefCineticFriction;

        Vector3D frictionCinetic = forceAppliedAlongContact.MultiplyByScalar(-1).Normalize().MultiplyByScalar(frictionCineticMagnitude);

        particle.AddForce(frictionCinetic);
    }
}