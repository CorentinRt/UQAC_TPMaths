import java.util.Map;
import java.util.HashMap;


Vector3DUnitTests VectorTests = new Vector3DUnitTests();

Vector3D gravity = new Vector3D(0, 9.81, 0);

// UpdateManager 
UpdateManager updateManager = new UpdateManager();

// Physics Engine
PhysicsEngine physicsEngine = new PhysicsEngine();

// Particle Force Registry
ParticleForceRegistry particleForceRegistry = new ParticleForceRegistry();

// Forces
ParticleGravity gravityForce = new ParticleGravity();


// PhysicsIntegrationSelector
PhysicsIntegrationSelector integrationSelector;

// Physics Debug Predictor
  PhysicsDebugPredictor physicsDebugPredictor = new PhysicsDebugPredictor();

//Projectile Launcher
ProjectileLauncher projectileLauncher = new ProjectileLauncher();

GlobController globController = new GlobController(); 

//Target Manager
TargetManager targetManager = new TargetManager();

// GameManager
GameManager gameManager;

// Texts & Font
PFont font;
TextDisplay deltaTimeDisplay;
TextDisplay timerDisplay;

float pixelsPerMeter = 30;

float INFINITE_MASS = 99999f;

//Projectiles Statistics
ProjectileStatistics ballDefaultStats = new ProjectileStatistics(10, new Vector3D(1 ,1 ,1), color(0,0,255), color(0,0,255));
ProjectileStatistics boulderDefaultStats = new ProjectileStatistics(100, new Vector3D(1 ,0.5 ,1), color(67,67,67), color(67,67,67));
ProjectileStatistics fireballDefaultStats = new ProjectileStatistics(20, new Vector3D(2 ,1.2 ,1), color(255,150,0), color(255,150,0));
ProjectileStatistics laserDefaultStats = new ProjectileStatistics(1, new Vector3D(1.5 ,2 ,1), color(255,0,0), color(255,0,0));

ArrayList<Particle> allParticles = new ArrayList<Particle>();

ArrayList<Particle> inGameProjectiles = new ArrayList<Particle>();

CollisionManager collisionManager = new CollisionManager();
SpringsRegistry springsRegistry = new SpringsRegistry();


Globs_Global globsGlobal = new Globs_Global(new Vector3D(10, 10, 0), 10);

Particle p1 = new Particle(10, new Vector3D(0, 0, 0));
Particle p2 = new Particle(10, new Vector3D(0, 10, 0));

SpringTwoParticles springp1p2 = new SpringTwoParticles(5, 5, 0.5, true);

Particle p3 = new Particle(5, new Vector3D(15, 10, 0));

SpringParticleAnchor springP3Anchor = new SpringParticleAnchor(5, 10, 0.5, true);

Particle p4 = new Particle(10, new Vector3D(-20, 0, 0));
Particle p5 = new Particle(10, new Vector3D(-20, 10, 0));
Constraint cableConstraint = new Constraint(p4.collider, p5.collider, 10, ConstraintType.CABLE);

// Globs Manager
GlobsManager globsManager = new GlobsManager();

//Variables
float lastFrameUpdate = 0;

boolean isFirstFrame = true;

// Ground
boolean groundSetup = false;
ArrayList<Platform> platforms = new ArrayList<Platform>();

static 
  {
    System.setProperty("sun.java2d.uiScale", "1.01"); // If this is 1.0 it does NOT work!
  }

void setup()
{
  fullScreen(P3D);
  background(100);
  
  // Tests unitaires TP1
  VectorTests.TestAll();
  
  // Créations Particules
  springp1p2.RegisterNewParticle(p1);
  springp1p2.RegisterNewParticle(p2);

  springP3Anchor.RegisterNewParticle(p3);
  springP3Anchor.RegisterAnchor(new Vector3D(15, 0, 0));

  // Initialisation deltaTime 1st frame
  lastFrameUpdate = millis();
  
  // Debug possible fonts
  /*
  String[] fontList = PFont.list();
  printArray(fontList);
  */
  
  // Font
  font = createFont("Calibri Bold", 64, true); // true = anti-aliasing, 64 = max size
  
  // Setup texts
  deltaTimeDisplay = new TextDisplay("", width - 10, 30, font);
  deltaTimeDisplay.SetAlignment(RIGHT);
  deltaTimeDisplay.SetSize(30);
  deltaTimeDisplay.SetBackground(color(0, 0, 0, 155), true);
  
  // Init PhysicsIntegrationSelector
  integrationSelector = new PhysicsIntegrationSelector(width - 10, 70, font);
  
  //projectileLauncher.CreateTexts(5, 70.f, font);
  
  // UpdateManager
  updateManager.Register(deltaTimeDisplay);
  updateManager.Register(integrationSelector);
  //updateManager.Register(projectileLauncher);
  updateManager.Register(collisionManager);
  
  //Setup Targets
  targetManager.AddTarget(new Target(new Vector3D(5, -5, 0), 10, 1));
  targetManager.AddTarget(new Target(new Vector3D(10, -8, 0), 15, 2));
  targetManager.AddTarget(new Target(new Vector3D(15, -3, 0), 5, 3));

  //Particle created for testing purposes, to be removed later
  
  // GameManager
  gameManager = new GameManager(font);

  // Globs Manager
  globsManager.Add(globsGlobal);
  updateManager.Register(globsManager);
}


void draw()
{
  pushMatrix();
  //Basic Camera just to display (TODO: Verify with teacher if we are allowed to use all this)
  background(100); // background géré dans game manager en fonction des menus
  camera(/*mouseX*/width/2, height/2, (height/2) / tan(PI/6), /*mouseX*/width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
  //sphere(1); //Center of Scene
 
  //Delta time
  float deltaTime = (millis() - lastFrameUpdate) / 1000.0;
  lastFrameUpdate = millis();
  
  if (isFirstFrame)
  {
    isFirstFrame = false;
    return;
  }


  //Gameplay

  //Blob Stretcher
  if (globController.isStretching && !mousePressed){
    Vector3D mousePosition = new Vector3D((mouseX - width/2)/pixelsPerMeter, (mouseY - height/2)/pixelsPerMeter, 0);
    mousePosition = mousePosition.MultiplyByScalar(1.1);
    globController.StopStretch(mousePosition);
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
  particleForceRegistry.Clear();
  
  
  // Update texts
  deltaTimeDisplay.SetText("Delta Time : " + nf(deltaTime, 0, 3) + "ms");
   
  // UpdateManager
  updateManager.UpdateAll(deltaTime);
  
  
  //Calcul et utilisation
  
  if (gameManager.state == GameState.PLAYING)
  {
    // Physique
    physicsEngine.UpdateAll(deltaTime);
    
    //Targets
    targetManager.CheckCollisions(allParticles);

    // Ground - Setup 
    if (!groundSetup)
    {
      SetupNewGround();
    }
  }
  else
  {
    // Ground - Reset 
    if (groundSetup)
    {
      ResetGround();
    }
  }
  /*
  else if (inGameProjectiles.size() > 0){
   while (inGameProjectiles.size() > 0){
      physicsEngine.Unregister(inGameProjectiles.get(0));
      updateManager.Unregister(inGameProjectiles.get(0));
      inGameProjectiles.remove(0);
    }
  }
    */

  //Removes Projectiles outside of screen on x positive and y positive (doesn't remove balls falling down back on screen)
  RemoveOutsideProjectiles();
  
  //Affichage
  //projectileLauncher.DrawTrajectory(deltaTime);

  Vector3D mousePosition = new Vector3D((mouseX - width/2)/pixelsPerMeter, (mouseY - height/2)/pixelsPerMeter, 0);
  mousePosition = mousePosition.MultiplyByScalar(1.1);
  globController.DrawDebug(deltaTime, mousePosition);

  //Targets DrawCall
  targetManager.DrawAll();

  popMatrix();
  camera();

  // GameManager (en dernier pour avoir la box background des menus au dessus de tout)
  gameManager.Update(deltaTime);
}

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
  
  // Split glob
  if (key == 's') 
    {
      println("Split glob input");

      if (globsManager.blobs.size() > 0)
        globsManager.Split(globsManager.blobs.get(0));
    }
}

void mousePressed()
{
  // Start game ?
  if (gameManager.state == GameState.WAITING)
  {
    gameManager.StartGame();
    return; 
  }
  
  // Restart game ? 
  if (gameManager.state == GameState.GAME_OVER)
  {
    gameManager.StartGame();
    return;
  }
  
  /*
  if (projectileLauncher.CanLaunchProjectile())
  {
    //Launching Projectile
    Particle launchedProjectile = projectileLauncher.LaunchProjectile();
    launchedProjectile.SetIntegrationMethod(integrationSelector.GetIntegrationMethod());
    inGameProjectiles.add(launchedProjectile);
    println("Summoning projectile at position : " + projectileLauncher.launchPosition.GetText());
  }
  */

  if (!globController.isStretching){
    Vector3D mousePosition = new Vector3D((mouseX - width/2)/pixelsPerMeter, (mouseY - height/2)/pixelsPerMeter, 0);
    mousePosition = mousePosition.MultiplyByScalar(1.1);
    globController.StartStretching(mousePosition);
  }
}

void RemoveOutsideProjectiles()
{
  int i = 0;
  while (i < inGameProjectiles.size()){; 
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

void SetupNewGround()
{
  float halfW = (width / 2.0f) / pixelsPerMeter * 1.1f;    // ~47 m
  float bottomY = (height / 2.0f) / pixelsPerMeter * 1.1f; // ~26 m
  float r = 0.5f;

  //Sol
  platforms.add(new Platform(new Vector3D(-halfW, bottomY - 1, 0), new Vector3D(halfW, bottomY - 1, 0), r));

  //Plateformes dans la moitié basse
  platforms.add(new Platform(new Vector3D(-30, 20, 0), new Vector3D(-15, 20, 0), r));   // gauche, basse
  platforms.add(new Platform(new Vector3D(-5, 17, 0),  new Vector3D(10, 21, 0),  r));   // inclinée vers le bas
  platforms.add(new Platform(new Vector3D(20, 18, 0),  new Vector3D(35, 18, 0),  r));   // droite
  platforms.add(new Platform(new Vector3D(-20, 12, 0), new Vector3D(-8, 12, 0),  r));   // étage supérieur

  for (Platform p : platforms)
    p.Build();

  groundSetup = true;
}

void ResetGround()
{
  for (Platform p : platforms)
    p.Destroy();

  platforms.clear();
  groundSetup = false;
}
