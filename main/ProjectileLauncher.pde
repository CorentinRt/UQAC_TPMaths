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
  
   
  //Text Displays
  TextDisplay textDisplaySelectedProjectile;
  TextDisplay textDisplayProjectileStatistics;
  TextDisplay textDisplayInputs;
  
  String prefixText = "Current Selected Projectile : ";
  String prefixMassText = "Mass : ";
  String prefixVelocityText = ", Initial Velocity : ";
    
  public void CreateTexts(float x, float y, PFont font){
    textDisplaySelectedProjectile = new TextDisplay(prefixText + availableProjectiles[selectedProjectile], x, y, font);
    
    ProjectileStatistics stats = GetSelectedProjectileStatistics();
    textDisplayProjectileStatistics = new TextDisplay(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocity.GetText() + " ", x, y + 35.0, font);
    textDisplayInputs = new TextDisplay(" UP or DOWN arrows to switch selected projectile", x, y + 70.0, font);
    
    textDisplaySelectedProjectile.SetAlignment(LEFT);
    textDisplayProjectileStatistics.SetAlignment(LEFT);
    textDisplayInputs.SetAlignment(LEFT);
    
    textDisplaySelectedProjectile.SetBackground(color(255, 255, 255, 50), true);
    textDisplayProjectileStatistics.SetBackground(color(255,255,255,50), true);
    textDisplayInputs.SetBackground(color(255, 255, 255, 50), true); 
  }
  
  public void IncrementSelectedProjectile()
  {
    selectedProjectile += 1;
    if (selectedProjectile >= availableProjectiles.length) selectedProjectile = 0;
    
    textDisplaySelectedProjectile.SetText(prefixText + availableProjectiles[selectedProjectile]);
    ProjectileStatistics stats = GetSelectedProjectileStatistics();
    textDisplayProjectileStatistics.SetText(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocity.GetText() + " ");
  }
  
  public void DecrementSelectedProjectile()
  {
    selectedProjectile -= 1;
    if (selectedProjectile < 0) selectedProjectile = availableProjectiles.length - 1;
    
    textDisplaySelectedProjectile.SetText(prefixText + availableProjectiles[selectedProjectile]);
    ProjectileStatistics stats = GetSelectedProjectileStatistics();
    textDisplayProjectileStatistics.SetText(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocity.GetText() + " ");
  }
  
  public EProjectileType GetSelectedProjectileType()
  {
    return availableProjectiles[selectedProjectile];
  }
  
  public ProjectileStatistics GetSelectedProjectileStatistics(){
    switch (availableProjectiles[selectedProjectile])
    {
      case BALL:
        return ballDefaultStats;
      case BOULDER:
        return boulderDefaultStats;
      case FIREBALL:
        return fireballDefaultStats;
      case LASER:
        return laserDefaultStats;
      default:
        return new ProjectileStatistics(1, new Vector3D());
    }
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
    
    textDisplaySelectedProjectile.Update(deltaTime);
    textDisplayProjectileStatistics.Update(deltaTime);
    textDisplayInputs.Update(deltaTime);
    
  }
  
  public void DrawTrajectory(float deltaTime)
  {
    ProjectileStatistics projectileStatistics = GetSelectedProjectileStatistics();
    
    physicsDebugPredictor.DrawDebugSimulation(integrationSelector.GetIntegrationMethod(), launchPosition, projectileStatistics.initialVelocity.Multiply(velocityMultiplier), PhysicsUtilities.ComputeGravitationalAcceleration(projectileStatistics.mass), damping, color(100, 101, 250), 20.0, 2.0, 0.15, deltaTime);
  }
}
