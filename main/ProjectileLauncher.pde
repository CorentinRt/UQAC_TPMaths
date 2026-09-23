// Projectile Launcher class

public class ProjectileLauncher implements IUpdatable
{
  int selectedProjectile = 0;
  EProjectileType[] availableProjectiles = {EProjectileType.BALL, EProjectileType.BOULDER, EProjectileType.FIREBALL, EProjectileType.LASER};
  
  float damping = 1.0f;
  Vector3D velocityMultiplier = new Vector3D(1, 1, 1);
  Vector3D launchPosition = new Vector3D(-15, 10, 0);
  
  float launchCooldown = 0.5f;
  float launchClock = 0.5f;
  
  // Physics Debug Predictor
  PhysicsDebugPredictor physicsDebugPredictor = new PhysicsDebugPredictor();
  
  public void IncrementSelectedProjectile()
  {
    selectedProjectile += 1;
    if (selectedProjectile >= availableProjectiles.length) selectedProjectile = 0;
  }
  
  public void DecrementSelectedProjectile()
  {
    selectedProjectile -= 1;
    if (selectedProjectile < 0) selectedProjectile = availableProjectiles.length - 1;
  }
  
  public EProjectileType GetSelectedProjectileType()
  {
    return availableProjectiles[selectedProjectile];
  }
  
  public Particle LaunchProjectile()
  {
    launchClock = 0;
    println(velocityMultiplier.GetText());
    
    switch( GetSelectedProjectileType() ){
      case BALL:
        return new Ball(launchPosition.Copy(), velocityMultiplier, damping);
      case BOULDER:
        return new Boulder(launchPosition.Copy(), velocityMultiplier, damping);
      case FIREBALL:
        return new Fireball(launchPosition.Copy(), velocityMultiplier, damping);
      case LASER:
        return new Laser(launchPosition.Copy(), velocityMultiplier, damping);
      default:
        return new Particle();
    }
  }
  
  public boolean CanLaunchProjectile()
  {
    return launchClock >= launchCooldown;
  }
  
  // IUpdatable
  void Update(float deltaTime)
  {
    velocityMultiplier.x = 1 + ((mouseX - width/2) / pixelsPerMeter) / 10;
    velocityMultiplier.y = 1 + ((height/2 - mouseY) / pixelsPerMeter) / 10;
    
    if (launchClock <= launchCooldown)
    {
      launchClock += deltaTime;
    }
    
  }
  
  public void DrawTrajectory(float deltaTime)
  {
    ProjectileStatistics projectileStatistics;
    switch (availableProjectiles[selectedProjectile])
    {
      case BALL:
        projectileStatistics = ballDefaultStats;
        break;
      case BOULDER:
        projectileStatistics = boulderDefaultStats;
        break;
      case FIREBALL:
        projectileStatistics = fireballDefaultStats;
        break;
      case LASER:
        projectileStatistics = laserDefaultStats;
        break;
      default:
      projectileStatistics = new ProjectileStatistics(1, new Vector3D());
    }
    physicsDebugPredictor.DrawDebugSimulation(integrationSelector.GetIntegrationMethod(), launchPosition, projectileStatistics.initialVelocity.Multiply(velocityMultiplier), PhysicsUtilities.ComputeGravitationalAcceleration(projectileStatistics.mass), damping, color(100, 101, 250), 20.0, 2.0, 0.15, deltaTime);
  }
}
