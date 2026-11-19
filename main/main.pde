import java.util.Map;
import java.util.HashMap;

// ----- Constants ----- //
Vector3D gravity = new Vector3D(0, 9.81, 0);
float pixelsPerMeter = 15;
float INFINITE_MASS = 99999f;

// ----- Unit tests ----- //
Vector3DUnitTests VectorTests = new Vector3DUnitTests();
Matrix3x3UnitTest Matrix3x3Tests = new Matrix3x3UnitTest();
Matrix4x4UnitTests Matrix4x4Tests = new Matrix4x4UnitTests();
QuaternionUnitTests QuaternionTests = new QuaternionUnitTests();


// ----- Update ----- //
UpdateManager updateManager = new UpdateManager();

// ----- Physics ----- //
PhysicsEngine physicsEngine = new PhysicsEngine();
PhysicsIntegrationSelector integrationSelector;
PhysicsDebugPredictor physicsDebugPredictor = new PhysicsDebugPredictor();

// ----- Forces ----- //
ParticleForceRegistry particleForceRegistry = new ParticleForceRegistry();
ParticleGravity gravityForce = new ParticleGravity();

// ----- Game ----- //
GameManager gameManager;

// ----- Texts ----- //
TextDisplay deltaTimeDisplay;
TextDisplay timerDisplay;

PFont font;

// ----- Projectiles ----- //
ProjectileLauncher projectileLauncher = new ProjectileLauncher();

ProjectileStatistics ballDefaultStats = new ProjectileStatistics(10, 2, color(0,0,255), color(0,0,255), 0.4f, 0.3f, 0.8f, 2, 4, 3, color(0,255,0));
ProjectileStatistics boulderDefaultStats = new ProjectileStatistics(100, 1, color(67,67,67), color(67,67,67), 0.3f, 0.5f, 0.4f, 8, 8, 23, color(255,0,255));
ProjectileStatistics fireballDefaultStats = new ProjectileStatistics(20, 5, color(255,150,0), color(255,150,0), 0.7f, 0.2f, 0.3f, 10, 13, 15, color(0,150,255));
ProjectileStatistics laserDefaultStats = new ProjectileStatistics(1, 7, color(255,0,0), color(255,0,0), 0f, 0f, 0.9f, 10, 5, 5, color(0,0,255));

ArrayList<Particle> allParticles = new ArrayList<Particle>();
ArrayList<Particle> inGameProjectiles = new ArrayList<Particle>();

// ----- Collisions, Constraints & Springs ----- //
CollisionManager collisionManager = new CollisionManager();
SpringsRegistry springsRegistry = new SpringsRegistry();

// ----- Rigidbody ----- //


// ----- Frame ----- //
float lastFrameUpdate = 0;
boolean isFirstFrame = true;

// ----- Fullscreen ----- //
static 
{
  System.setProperty("sun.java2d.uiScale", "1.01"); 
}

// ----- Setup ----- //
void setup()
{
  fullScreen(P3D);
  background(100);

  // Unit tests
  VectorTests.TestAll();
  Matrix3x3Tests.TestAll();
  Matrix4x4Tests.TestAll();
  QuaternionTests.TestAll();
  
  // Init deltaTime 1st frame
  lastFrameUpdate = millis();
  
  // Font
  font = createFont("Calibri Bold", 64, true); // true = anti-aliasing, 64 = max size
  
  // Setup texts
  deltaTimeDisplay = new TextDisplay("", width - 10, 30, font);
  deltaTimeDisplay.SetAlignment(RIGHT);
  deltaTimeDisplay.SetSize(30);
  deltaTimeDisplay.SetBackground(color(0, 0, 0, 155), true);

  projectileLauncher.CreateTexts(5, 70.f, font);
  
  // Init PhysicsIntegrationSelector
  integrationSelector = new PhysicsIntegrationSelector(width - 10, 70, font);
  
  // UpdateManager
  updateManager.Register(deltaTimeDisplay);
  updateManager.Register(integrationSelector);
  updateManager.Register(collisionManager);
  updateManager.Register(projectileLauncher);
  
  // GameManager
  gameManager = new GameManager(font);
}

// ----- Draw ----- //
void draw()
{
  pushMatrix();
  background(100);
  camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
 
  //Delta time
  float deltaTime = (millis() - lastFrameUpdate) / 1000.0;
  lastFrameUpdate = millis();
  
  if (isFirstFrame)
  {
    isFirstFrame = false;
    return;
  }

  // Force Registry
  springsRegistry.ApplyAllSpringsForces();
  
  for (int i = 0; i < allParticles.size(); ++i)
  {
    Particle particle = allParticles.get(i);

    if (particle.InverseMass() == 0)
      continue;

    particleForceRegistry.Add(particle, gravityForce);
    particleForceRegistry.Add(particle, new ParticleStaticFriction());
    particleForceRegistry.Add(particle, new ParticleCineticFriction());
  }

  particleForceRegistry.UpdateForces(deltaTime);

  for (int i = 0; i < allParticles.size(); ++i)
    allParticles.get(i).contactNormal = new Vector3D(0, 0, 0);

  particleForceRegistry.Clear();
  
  // Update texts
  deltaTimeDisplay.SetText("Delta Time : " + nf(deltaTime, 0, 3) + "ms");
   
  if (gameManager.state == GameState.PLAYING)
  {
    // Physique
    physicsEngine.UpdateAll(deltaTime);

    // UpdateManager
    updateManager.UpdateAll(deltaTime);
  }
  
  // Remove projectiles outside of screen on x positive and y positive (doesn't remove balls falling down back on screen)
  RemoveOutsideProjectiles();

  popMatrix();
  camera();

  // GameManager (en dernier pour avoir la box background des menus au dessus de tout)
  gameManager.Update(deltaTime);
}

// ----- Key pressed ----- //
void keyPressed()
{
  if (key == CODED)
  {
    if (keyCode == LEFT || keyCode == RIGHT)
    {
      integrationSelector.ToggleIntegrationMethod();
    }
    if (keyCode == DOWN)
    {
       projectileLauncher.DecrementSelectedProjectile();
    }
    else if (keyCode == UP)
    {
      projectileLauncher.IncrementSelectedProjectile();
    }
  }
}

// ----- Mouse pressed ----- //
void mousePressed()
{
  // Start game ?
  if (gameManager.state == GameState.WAITING)
  {
    gameManager.StartGame();
    return; 
  }
  
  projectileLauncher.LaunchProjectile();

  // Restart game ? 
  if (gameManager.state == GameState.GAME_OVER)
  {
    gameManager.StartGame();
    return;
  }
}

// ----- Remove Outside Projectiles ----- //
void RemoveOutsideProjectiles()
{
  int i = 0;

  while (i < inGameProjectiles.size())
  {
    if (inGameProjectiles.get(i).position.x > (width * 2) / pixelsPerMeter || inGameProjectiles.get(i).position.y > (height * 2) / pixelsPerMeter)
    {
      println("Removing projectile : " + inGameProjectiles.get(i).position.GetText());
      
      Particle projectile = inGameProjectiles.get(i);

      if (projectile == null)
        continue;

      inGameProjectiles.remove(i);
      projectile.DestroyParticle();

      continue;
    }

    i++;
  }
}