// Projectile Launcher class

public class ProjectileLauncher implements IUpdatable
{
  int selectedProjectile = 0;
  EProjectileType[] availableProjectiles = {EProjectileType.BALL, EProjectileType.BOULDER, EProjectileType.FIREBALL, EProjectileType.LASER};
  
  Vector3D direction = new Vector3D(1, 1, 1);
  Vector3D launchPosition = new Vector3D(-40, 20, 0);
  
  float launchCooldown = 0.5f;
  float launchClock = 0.5f;

  Vector3D currentMassOffsetToApply = new Vector3D();
  Vector3D currentInitialAngularVelocityToApply = new Vector3D();
  
  // Physics Debug Predictor
  PhysicsDebugPredictor physicsDebugPredictor = new PhysicsDebugPredictor();
  
   
  //Text Displays
  TextDisplay textDisplaySelectedProjectile;
  TextDisplay textDisplayProjectileStatistics;
  TextDisplay textDisplayInputs;
  
  String prefixText = "Current Selected Projectile : ";
  String prefixMassText = "Mass : ";
  String prefixVelocityText = ", Velocity Multiplier : ";
    
  public void CreateTexts(float x, float y, PFont font){
    textDisplaySelectedProjectile = new TextDisplay(prefixText + availableProjectiles[selectedProjectile], x, y, font);
    
    ProjectileStatistics stats = GetSelectedProjectileStatistics();
    textDisplayProjectileStatistics = new TextDisplay(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocityMultiplier + " ", x, y + 35.0, font);
    textDisplayInputs = new TextDisplay("UP or DOWN arrows to switch selected projectile", x, y + 70.0, font);
    
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
    textDisplayProjectileStatistics.SetText(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocityMultiplier + " ");
  }
  
  public void DecrementSelectedProjectile()
  {
    selectedProjectile -= 1;
    if (selectedProjectile < 0) selectedProjectile = availableProjectiles.length - 1;
    
    textDisplaySelectedProjectile.SetText(prefixText + availableProjectiles[selectedProjectile]);
    ProjectileStatistics stats = GetSelectedProjectileStatistics();
    textDisplayProjectileStatistics.SetText(prefixMassText + stats.mass + prefixVelocityText + stats.initialVelocityMultiplier + " ");
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
        return new ProjectileStatistics(1, 5, color(0), color(0), 0.5f, 0.5f, 20, 20, 20, color(0));
    }
  }
  
  public Particle LaunchProjectile()
  {
    launchClock = 0;
    println("direction" + direction.GetText());
    
    switch( GetSelectedProjectileType() ){
      case BALL:
        println("Projectile Type : " + "BALL");
        return new Ball(launchPosition.Copy(), direction, currentMassOffsetToApply, currentInitialAngularVelocityToApply);
      case BOULDER:
        println("Projectile Type : " + "BOULDER");
        return new Boulder(launchPosition.Copy(), direction, currentMassOffsetToApply, currentInitialAngularVelocityToApply);
      case FIREBALL:
        println("Projectile Type : " + "FIREBALL");
        return new Fireball(launchPosition.Copy(), direction, currentMassOffsetToApply, currentInitialAngularVelocityToApply);
      case LASER:
        println("Projectile Type : " + "LASER");
        return new Laser(launchPosition.Copy(), direction, currentMassOffsetToApply, currentInitialAngularVelocityToApply);
      default:
      println("Projectile Type : " + "DEFAULT");
        RigidBody rb = new RigidBody(1, launchPosition.Copy(), direction, new Quaternion(), currentInitialAngularVelocityToApply, currentMassOffsetToApply);
        rb.SetBox(5, 5, 5);
        return rb;
    }
  }
  
  public boolean CanLaunchProjectile()
  {
    return launchClock >= launchCooldown;
  }
  
  // IUpdatable
  void Update(float deltaTime)
  {
    Vector3D mousePosition = new Vector3D((mouseX - width/2)/pixelsPerMeter, (mouseY - height/2)/pixelsPerMeter, launchPosition.z);
    direction = (mousePosition.Substract(launchPosition)).Normalize();
    direction = direction.MultiplyByScalar(pixelsPerMeter * 1.5);
    
    if (launchClock <= launchCooldown)
    {
      launchClock += deltaTime;
    }
    
    textDisplaySelectedProjectile.Update(deltaTime);
    textDisplayProjectileStatistics.Update(deltaTime);
    textDisplayInputs.Update(deltaTime);
    
    textDisplayProjectileStatistics.SetText(direction.GetText());

    DrawTrajectory(deltaTime);
  }
  
  public void DrawTrajectory(float deltaTime)
  {
    ProjectileStatistics projectileStatistics = GetSelectedProjectileStatistics();
    
    color c = integrationSelector.GetIntegrationMethod() == EIntegrationMethod.EULER ? color(0,255,0) : color(255,255,0);
    
    Vector3D accumForcePredicted = new Vector3D(0, 9.81, 0);
    accumForcePredicted = accumForcePredicted.MultiplyByScalar(projectileStatistics.mass);
    
    physicsDebugPredictor.DrawDebugSimulation(integrationSelector.GetIntegrationMethod(), launchPosition, direction.MultiplyByScalar(projectileStatistics.initialVelocityMultiplier), PhysicsUtilities.ComputeAccelerationByForce(projectileStatistics.mass, accumForcePredicted), c, 20.0, 2.0, 0.15, deltaTime);
  }
}
