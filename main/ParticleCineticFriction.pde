class ParticleCineticFriction implements IParticleForceGenerator
{
    void UpdateForce(Particle particle, float duration)
    {
        if (particle.InverseMass() <= 0)
            return;

        if (particle.contactNormal.Norm() == 0)
            return;

        Vector3D velocity = particle.linearVelocity;

        float speed = velocity.Norm();
        
        if (speed <= 0.2f)
            return;

        Vector3D velocityAppliedOnContact = particle.contactNormal.MultiplyByScalar(velocity.ScalarProduct(particle.contactNormal));

        Vector3D slidingVelocity = velocity.Substract(velocityAppliedOnContact);
        Vector3D slidingVelocityDir = slidingVelocity.Normalize();

        Vector3D g = gravity.MultiplyByScalar(particle.mass);
        Vector3D gn = particle.contactNormal.MultiplyByScalar(g.ScalarProduct(particle.contactNormal));

        Vector3D n = gn.MultiplyByScalar(-1);

        if (slidingVelocityDir.Norm() <= 0.00001f)
            return;

        float cineticFriction = particle.coefCineticFriction * n.Norm();

        Vector3D cineticFrictionForce = slidingVelocityDir.MultiplyByScalar(-1 * cineticFriction);

        particle.AddForce(cineticFrictionForce);

        /*
        // Force normale
        float normalForce = particle.mass * abs(gravity.ScalarProduct(particle.contactNormal));

        //Oppose a la vitesse
        Vector3D direction = particle.linearVelocity.MultiplyByScalar(-1.0f / speed);

        particle.AddForce(direction.MultiplyByScalar(normalForce * particle.coefCineticFriction));
        */
    }
}