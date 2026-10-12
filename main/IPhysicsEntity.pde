interface IPhysicsEntity
{
  void UpdatePhysics(float deltaTime);
  
  void AddForce(Vector3D force);
  
  void ClearAccum();
  
}
