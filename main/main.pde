Vector3DUnitTests VectorTests = new Vector3DUnitTests();

// UpdateManager 
UpdateManager updateManager = new UpdateManager();

// Physics Engine
PhysicsEngine physicsEngine = new PhysicsEngine();

// PhysicsIntegrationSelector
PhysicsIntegrationSelector integrationSelector;

//Projectile Launcher
ProjectileLauncher projectileLauncher = new ProjectileLauncher();

//Target Manager
TargetManager targetManager = new TargetManager();

// GameManager
GameManager gameManager;

// Texts & Font
PFont font;
TextDisplay deltaTimeDisplay;
TextDisplay timerDisplay;

float pixelsPerMeter = 30;

//Projectiles Statistics
ProjectileStatistics ballDefaultStats = new ProjectileStatistics(10, new Vector3D(8,-15,0), color(0,0,255), color(0,0,255));
ProjectileStatistics boulderDefaultStats = new ProjectileStatistics(100, new Vector3D(8,-8,0), color(67,67,67), color(67,67,67));
ProjectileStatistics fireballDefaultStats = new ProjectileStatistics(20, new Vector3D(10,-15,0), color(255,150,0), color(255,150,0));
ProjectileStatistics laserDefaultStats = new ProjectileStatistics(1, new Vector3D(15,-5,0), color(255,0,0), color(255,0,0));

ArrayList<Particle> inGameProjectiles = new ArrayList<Particle>();

//Variables
float lastFrameUpdate = 0;

boolean isFirstFrame = true;

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
  
  projectileLauncher.CreateTexts(5, 70.f, font);
  
  // UpdateManager
  updateManager.Register(deltaTimeDisplay);
  updateManager.Register(integrationSelector);
  updateManager.Register(projectileLauncher);
  
  //Setup Targets
  targetManager.AddTarget(new Target(new Vector3D(5, -5, 0), 1.5));
  targetManager.AddTarget(new Target(new Vector3D(10, -8, 0), 1.0));
  targetManager.AddTarget(new Target(new Vector3D(15, -3, 0), 2.0));
  
  // GameManager
  gameManager = new GameManager(font);
}


void draw()
{
  pushMatrix();
  //Basic Camera just to display (TODO: Verify with teacher if we are allowed to use all this)
  background(100); // background géré dans game manager en fonction des menus
  camera(/*mouseX*/width/2, height/2, (height/2) / tan(PI/6), /*mouseX*/width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
  sphere(1); //Center of Scene
 
  //Delta time
  float deltaTime = (millis() - lastFrameUpdate) / 1000.0;
  lastFrameUpdate = millis();
  
  if (isFirstFrame)
  {
    isFirstFrame = false;
    return;
  }
  
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
    targetManager.CheckCollisions(inGameProjectiles);
  }
  else if (inGameProjectiles.size() > 0){
   while (inGameProjectiles.size() > 0){
      physicsEngine.Unregister(inGameProjectiles.get(0));
      updateManager.Unregister(inGameProjectiles.get(0));
      inGameProjectiles.remove(0);
    }
  }

  //Removes Projectiles outside of screen on x positive and y positive (doesn't remove balls falling down back on screen)
  RemoveOutsideProjectiles();
  
  //Affichage
  projectileLauncher.DrawTrajectory(deltaTime);
    
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
  
  if (projectileLauncher.CanLaunchProjectile())
  {
    //Launching Projectile
    Particle launchedProjectile = projectileLauncher.LaunchProjectile();
    launchedProjectile.SetIntegrationMethod(integrationSelector.GetIntegrationMethod());
    inGameProjectiles.add(launchedProjectile);
    println("Summoning projectile at position : " + projectileLauncher.launchPosition.GetText());
    physicsEngine.Register(launchedProjectile);
    updateManager.Register(launchedProjectile);
  }
}

void RemoveOutsideProjectiles()
{
  int i = 0;
  while (i < inGameProjectiles.size()){; 
    if (inGameProjectiles.get(i).position.x > (width * 2) / pixelsPerMeter || inGameProjectiles.get(i).position.y > (height * 2) / pixelsPerMeter)
    {
      println("Removing projectile : " + inGameProjectiles.get(i).position.GetText());
      physicsEngine.Unregister(inGameProjectiles.get(i));
      updateManager.Unregister(inGameProjectiles.get(i));
      inGameProjectiles.remove(i);
      continue;
    }
    i++;
  }
}
