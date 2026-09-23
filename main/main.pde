Vector3DUnitTests VectorTests = new Vector3DUnitTests();

// UpdateManager 
UpdateManager updateManager = new UpdateManager();


// Physics Engine
PhysicsEngine physicsEngine = new PhysicsEngine();

// PhysicsIntegrationSelector
PhysicsIntegrationSelector integrationSelector;

//Projectile Launcher
ProjectileLauncher projectileLauncher = new ProjectileLauncher();

// GameManager
GameManager gameManager;

// Texts & Font
PFont font;
TextDisplay deltaTimeDisplay;
TextDisplay timerDisplay;

float pixelsPerMeter = 30;

//Projectiles Statistics
ProjectileStatistics ballDefaultStats = new ProjectileStatistics(10, new Vector3D(8,-15,0));
ProjectileStatistics boulderDefaultStats = new ProjectileStatistics(100, new Vector3D(8,-8,0));
ProjectileStatistics fireballDefaultStats = new ProjectileStatistics(20, new Vector3D(10,-15,0));
ProjectileStatistics laserDefaultStats = new ProjectileStatistics(1, new Vector3D(15,-5,0));

ArrayList<Particle> inGameProjectiles = new ArrayList<Particle>();

//Variables
float lastFrameUpdate = 0;

boolean isFirstFrame = true;


void setup()
{
  size(800,600, P3D);
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
  font = createFont("Arial Bold", 16, true); // true = anti-aliasing
  
  // Setup texts
  deltaTimeDisplay = new TextDisplay("", width, 20, font);
  deltaTimeDisplay.SetAlignment(RIGHT);
  deltaTimeDisplay.SetBackground(color(255, 255, 255, 155), true);
  
  // Init PhysicsIntegrationSelector
  integrationSelector = new PhysicsIntegrationSelector(width, 60, font);
  
  // UpdateManager
  updateManager.Register(deltaTimeDisplay);
  updateManager.Register(integrationSelector);
  updateManager.Register(projectileLauncher);
  
  // PhysicsEngine
  
  // GameManager
  gameManager = new GameManager(font);
  gameManager.StartGame(); // a faire plus tard quand click sur jouer 
}


void draw()
{
  pushMatrix();
  //Basic Camera just to display (TODO: Verify with teacher if we are allowed to use all this)
  background(100);
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
  
  // GameManager
  gameManager.Update(deltaTime);
  
  //Calcul et utilisation
  
  if (gameManager.state == GameState.PLAYING)
  {
    // Physique
    physicsEngine.UpdateAll(deltaTime);
  }
  
  //Removes Projectiles outside of screen on x positive and y positive (doesn't remove balls falling down back on screen)
  RemoveOutsideProjectiles();
  
  //Affichage
  projectileLauncher.DrawTrajectory(deltaTime);
  
  
  // Gameloop
  //4 différents projectiles (balles, boulets, laser et boule de feu)
  //Tir
  //Propre vélocité et masse
  //Frottement négligeable (près de 1)
  //Trajectoire des tirs visible
  
  
  popMatrix();
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

void mousePressed(){
    if (projectileLauncher.CanLaunchProjectile())
    {
      //Launching Projectile
      Particle launchedProjectile = projectileLauncher.LaunchProjectile();
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
