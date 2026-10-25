class ParticleCineticFriction implements IParticleForceGenerator
{
    void UpdateForce(Particle particle, float duration)
    {
        if (particle.InverseMass() <= 0)
            return;

        if (particle.contactNormal.Norm() == 0)
            return;

        float speed = particle.linearVelocity.Norm();
        if (speed <= 0.2f)
            return;


        // Force normale
        float normalForce = particle.mass * abs(gravity.ScalarProduct(particle.contactNormal));

        //Oppose a la vitesse
        Vector3D direction = particle.linearVelocity.MultiplyByScalar(-1.0f / speed);

        particle.AddForce(direction.MultiplyByScalar(normalForce * particle.coefCineticFriction));

        /*
        Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj
        
        Vector3D gravityAppliedAlongContact = particle.contactNormal.MultiplyByScalar(particle.contactNormal.ScalarProduct(gravityByMass));

        Vector3D forceAppliedAlongContact = particle.accumForce.Normalize().MultiplyByScalar(gravityAppliedAlongContact.Norm());

        float frictionCineticMagnitude = gravityAppliedAlongContact.MultiplyByScalar(-1).Norm() * particle.coefCineticFriction;

        Vector3D frictionCinetic = forceAppliedAlongContact.MultiplyByScalar(-1).Normalize().MultiplyByScalar(frictionCineticMagnitude);

        particle.AddForce(frictionCinetic);
        */
    }
}