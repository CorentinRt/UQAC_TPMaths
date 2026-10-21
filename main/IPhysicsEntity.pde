interface IPhysicsEntity
{
  void UpdatePhysics(float deltaTime);
  
  void AddForce(Vector3D force);
  
  void ClearAccum();

  void AddPosition(Vector3D position);

  Vector3D GetLinearVelocity();

  float GetMass();
  
}
