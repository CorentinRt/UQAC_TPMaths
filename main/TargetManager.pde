class TargetManager
{
  ArrayList<Target> targets;
  
  TargetManager()
  {
    targets = new ArrayList<Target>();
  }
  
  void AddTarget(Target t)
  {
    targets.add(t);
  }
  
  void CheckCollisions(ArrayList<Particle> projectiles)
  {
    for (Target t : targets)
    {
      if (t.isHit) continue;
      
      for (Particle p : projectiles)
      {
        if (t.CheckCollision(p))
        {
          println("Target Collision Check Launched");
          break; 
        }
      }
    }
  }
  
  void DrawAll()
  {
    for (Target t : targets)
    {
      t.Draw();
    }
  }
  
  void ResetTargets()
  {
    for (Target t : targets)
    {
      t.Reset();
    }
  }
}
