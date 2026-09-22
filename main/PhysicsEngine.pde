class PhysicsEngine
{
  ArrayList<IPhysicsEntity> physicsEntities = new ArrayList<IPhysicsEntity>();
  
  void Register(IPhysicsEntity obj)
  {
    physicsEntities.add(obj);
  }

  void Unregister(IPhysicsEntity obj)
  {
    physicsEntities.remove(obj);
  }

  void UpdateAll(float deltaTime)
  {
    for (IPhysicsEntity obj : physicsEntities)
    {
      obj.UpdatePhysics(deltaTime);
    }
  }
}
