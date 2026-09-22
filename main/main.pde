Vector3DUnitTests VectorTests = new Vector3DUnitTests();

// UpdateManager 
UpdateManager updateManager = new UpdateManager();

// Physics Engine
PhysicsEngine physicsEngine = new PhysicsEngine();

// PhysicsIntegrationSelector
PhysicsIntegrationSelector integrationSelector;

// GameManager
GameManager gameManager;

// Texts & Font
PFont font;
TextDisplay deltaTimeDisplay;
TextDisplay timerDisplay;

//Constante force gravitationnel
float pixelsPerMeter = 30;
Vector3D gravitationalAcceleration = new Vector3D(0, 9.81, 0);

//Variables
Particle eulerParticle;
Particle verletParticle;
int lastFrameUpdate = 0;

boolean isFirstFrame = true;


void setup()
{
  size(800,600, P3D);
  background(100);
  
  // Tests unitaires TP1
  VectorTests.TestAll();
  
  // Créations Particules
  eulerParticle = new Particle(1, new Vector3D(-15, 10, 0), new Vector3D(8, -15, 0), 1.0);
  verletParticle = new Particle(1, new Vector3D(-15, 10, 0), new Vector3D(8, -15, 0), 1.0);
  verletParticle.SetIntegrationMethod(EIntegrationMethod.VERLET);
  
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
  updateManager.Register(eulerParticle);
  updateManager.Register(verletParticle);
  updateManager.Register(integrationSelector);
  
  // PhysicsEngine
  physicsEngine.Register(eulerParticle);
  physicsEngine.Register(verletParticle);
  
  // GameManager
  gameManager = new GameManager(font);
  gameManager.StartGame(); // a faire plus tard quand click sur jouer 
}


void draw()
{
  //Basic Camera just to display (TODO: Verify with teacher if we are allowed to use all this)
  background(100);
  camera(/*mouseX*/width/2, height/2, (height/2) / tan(PI/6), /*mouseX*/width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
  sphere(1); //Center of Scene
 
  //Delta time
  float deltaTime = (millis() - lastFrameUpdate) / 1000.0;
  lastFrameUpdate = millis();
  
  if (mousePressed){
    deltaTime *= 20;
  }
  
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
  
  //Affichage
  
  
  // Gameloop
  //4 différents projectiles (balles, boulets, laser et boule de feu)
  //Tir
  //Propre vélocité et masse
  //Frottement négligeable (près de 1)
  //Trajectoire des tirs visible
}

void keyPressed()
{
  
  if (key == CODED)
  {
    if (keyCode == LEFT || keyCode == RIGHT)
    {
      integrationSelector.ToggleIntegrationMethod();
    }
  }
  
}
