class ParticleStaticFriction implements IParticleForceGenerator
{
  // IParticleForceGenerator
  void UpdateForce(Particle particle, float duration)
  {
    if (particle.InverseMass() <= 0)
        return;

    if (particle.contactNormal.Norm() == 0)
        return;

    if (particle.linearVelocity.Norm() > 0.2f)
        return;

    Vector3D g = gravity.MultiplyByScalar(particle.mass);
    Vector3D gn = particle.contactNormal.MultiplyByScalar(g.ScalarProduct(particle.contactNormal));

    Vector3D n = gn.MultiplyByScalar(-1);

    Vector3D currentTotaForce = particle.accumForce;
    Vector3D forceAppliedOnContact = particle.contactNormal.MultiplyByScalar(currentTotaForce.ScalarProduct(particle.contactNormal));
    Vector3D slidingForce = currentTotaForce.Substract(forceAppliedOnContact);

    float maxStaticFriction = particle.coefStaticFriction * n.Norm();

    if (slidingForce.Norm() <= maxStaticFriction)
    {
      particle.AddForce(slidingForce.MultiplyByScalar(-1));
    }
  }
  // ----------------------
}
