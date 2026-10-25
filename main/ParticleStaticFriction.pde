class ParticleStaticFriction implements IParticleForceGenerator
{
  // IParticleForceGenerator
  void UpdateForce(Particle particle, float duration)
  {
    if (particle.InverseMass() == 0)
        return;

    if (particle.contactNormal.Norm() == 0)
        return;

    if (particle.linearVelocity.Norm() > 0.2f)
        return;


    float normalForce = particle.mass * abs(gravity.ScalarProduct(particle.contactNormal));

    Vector3D appliedForce = particle.accumForce;
    Vector3D perpendicularPart = particle.contactNormal.MultiplyByScalar(appliedForce.ScalarProduct(particle.contactNormal));
    Vector3D slidingForce = appliedForce.Substract(perpendicularPart);

    float maxStaticFriction = normalForce * particle.coefStaticFriction;

    if (slidingForce.Norm() <= maxStaticFriction)
      particle.AddForce(slidingForce.MultiplyByScalar(-1));


    /*
    Vector3D gravityByMass = gravity.MultiplyByScalar(particle.mass);  // Fg = 9.81 * Mobj

    Vector3D gravityAppliedAlongContact = particle.contactNormal.MultiplyByScalar(particle.contactNormal.ScalarProduct(gravityByMass));

    Vector3D forceAppliedAlongContact = particle.accumForce.Normalize().MultiplyByScalar(gravityAppliedAlongContact.Norm());

    float maxFrictionStatic = gravityAppliedAlongContact.MultiplyByScalar(-1).Norm() * particle.coefStaticFriction;

    if (forceAppliedAlongContact.Norm() <= maxFrictionStatic)
    {
        Vector3D friction = forceAppliedAlongContact.MultiplyByScalar(-1);

        particle.AddForce(friction);
    }

    */
  }
  // ----------------------
}
