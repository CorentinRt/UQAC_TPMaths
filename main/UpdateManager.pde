class UpdateManager
{
  ArrayList<IUpdatable> updatables = new ArrayList<IUpdatable>();

  void Register(IUpdatable obj)
  {
    updatables.add(obj);
  }

  void Unregister(IUpdatable obj)
  {
    updatables.remove(obj);
  }

  void UpdateAll(float deltaTime)
  {
    for (IUpdatable obj : updatables)
    {
      obj.Update(deltaTime);
    }
  }
}
