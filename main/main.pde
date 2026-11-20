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

ProjectileStatistics ballDefaultStats = new ProjectileStatistics(10, 1, color(0,0,255), color(0,0,255), 0.4f, 0.3f, 0.8f, 2, 4, 3, color(0,255,0));
ProjectileStatistics boulderDefaultStats = new ProjectileStatistics(100, 3, color(67,67,67), color(67,67,67), 0.3f, 0.5f, 0.4f, 8, 8, 23, color(255,0,255));
ProjectileStatistics fireballDefaultStats = new ProjectileStatistics(20, 2, color(255,150,0), color(255,150,0), 0.7f, 0.2f, 0.3f, 10, 13, 15, color(0,150,255));
ProjectileStatistics laserDefaultStats = new ProjectileStatistics(1, 3, color(255,0,0), color(255,0,0), 0f, 0f, 0.9f, 10, 5, 5, color(0,0,255));

ArrayList<Particle> allParticles = new ArrayList<Particle>();
ArrayList<Particle> inGameProjectiles = new ArrayList<Particle>();

// ----- Collisions, Constraints & Springs ----- //
CollisionManager collisionManager = new CollisionManager();
SpringsRegistry springsRegistry = new SpringsRegistry();

// ----- Rigidbody ----- //
ArrayList<RigidBody> inGameRigidBodies = new ArrayList<RigidBody>();

// ----- Frame ----- //
float lastFrameUpdate = 0;
boolean isFirstFrame = true;

// ----- Level ----- //
Corridor corridor;
float camZ;

// ----- Slider ----- //
boolean bIsSelectingSlider = false;
VectorSlider massOffsetSlider;
VectorSlider angularVelocitySlider;
VectorSlider forceOffsetSlider;

// ----- Targets ----- //
TargetManager targetManager = new TargetManager();

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
  ((PGraphicsOpenGL)g).textureSampling(2);   // 2 = pixels nets, sans lissage

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

  // Textures
  textureMode(NORMAL);   // UV en nombre de répétitions
  textureWrap(REPEAT);   // la texture se répète au lieu de s'étirer

  PImage wallTex  = loadImage("wall.png");
  PImage floorTex = loadImage("floor.png");
  PImage ceilTex  = loadImage("ceiling.png");

  // Level
  pixelsPerMeter = 15; // a voir si besoin de faire 
  camZ = (height / 2.0f) / tan(PI / 6); // pi / 3 c le fov par défaut de processing à 60 degres

  float sceneOffsetZ = -100; // pour compenser le translate au draw apres la cam de -100                        
  float k = (camZ - sceneOffsetZ) / camZ * 1.02f;

  float corridorWidth  = width  * k / pixelsPerMeter;
  float corridorHeight = height * k / pixelsPerMeter;
  float corridorLength = 500;

  corridor = new Corridor(0, corridorHeight / 2, 0, corridorWidth, corridorHeight, corridorLength, wallTex, floorTex, ceilTex);
  updateManager.Register(corridor);

  //Sliders
  massOffsetSlider = new VectorSlider(5, height - 650, width / 4, 20, 35, "Mass Offset", color(255, 93, 93), color(255, 170, 170), color(255, 60, 60));
  angularVelocitySlider = new VectorSlider(5, height - 475, width / 4, 20, 35, "Initial Angular Velocity", color(255, 247, 53), color(255, 249, 123), color(241, 231, 0));
  forceOffsetSlider = new VectorSlider(5, height - 300, width / 4, 20, 35, "Launch Force Offset", color(122, 187, 255), color(201, 227, 255), color(87, 150, 216));

  // Posters
  for (int i = 1; i <= 15; i++)
  {
      corridor.AddPosterTexture(loadImage("poster" + i + ".jpg"));
  }

  for (int i = 0; i < 30; i++)
  {
      corridor.AddRandomPoster(random(0.2, 0.7));
  }

  // Targets
  for (int i = 0; i < 5; i++)
  {
      Target target = new Target(new Vector3D(0, 0, 0), 50);  
      target.RespawnElsewhere();                               
      targetManager.AddTarget(target);
  }
}

// ----- Draw ----- //
void draw()
{
  pushMatrix();
  background(100);
  camera(width/2, height/2, camZ, width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
  lights();
  fill(220, 120, 60); 
 
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

    //RigidBody
    for (RigidBody rb : inGameRigidBodies)
    {
      rb.AddForce(gravity.MultiplyByScalar(rb.mass)); //On peut faire AddForceAtLocation a tester
      rb.Integrate(deltaTime);
    }

    // UpdateManager
    updateManager.UpdateAll(deltaTime);

    // Targets
    targetManager.CheckCollisions(inGameProjectiles);
    targetManager.DrawAll();
  }
  
  // Remove projectiles outside of screen on x positive and y positive (doesn't remove balls falling down back on screen)
  RemoveOutsideProjectiles();

  //Update Values according to Slider :

  //--- TODO: Mettre les vrai valeur de width, height et depth du rigidbody
  Vector3D RigidbodyWHD = new Vector3D(10.f, 10.f, 10.f);
  Vector3D minValue = new Vector3D(- RigidbodyWHD.x /2, - RigidbodyWHD.y / 2, - RigidbodyWHD.z / 2);
  Vector3D maxValue = new Vector3D(RigidbodyWHD.x /2, RigidbodyWHD.y / 2, RigidbodyWHD.z / 2);

  Vector3D massOffset = massOffsetSlider.GetValueVector(minValue, maxValue);
  projectileLauncher.SetMassOffsetToApply(massOffset);

   //--- TODO: Implémenter la valeur de force Offset et Mettre les vrai valeur de width, height et depth du rigidbody
  Vector3D forceOffset = forceOffsetSlider.GetValueVector(minValue, maxValue);

  Vector3D angularVelocity = angularVelocitySlider.GetValueVector(new Vector3D(-20f, -20f, -20f), new Vector3D(20f, 20f, 20f));
  projectileLauncher.SetInitialAngularVelocityToApply(angularVelocity);
 


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
  
  if (gameManager.state == GameState.PLAYING){
    if (!massOffsetSlider.IsMouseOver() && !forceOffsetSlider.IsMouseOver() && !angularVelocitySlider.IsMouseOver() && !bIsSelectingSlider)
    {
        //LaunchRigidBody(new Vector3D(2, 15, 0), new Vector3D(0, -0.3, -1), 25);
        Vector3D offset = forceOffsetSlider.GetValueVector(new Vector3D(-10,-10,-10), new Vector3D(10,10,10));
        projectileLauncher.LaunchProjectile(offset);
    }
  }

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

void LaunchRigidBody(Vector3D startPos, Vector3D direction, float speed)
{
  Vector3D offset = forceOffsetSlider.GetValueVector(new Vector3D(-10,-10,-10), new Vector3D(10,10,10));
  //Vector3D velocity = direction.Normalize().MultiplyByScalar(speed);
  Vector3D velocity = new Vector3D(0,0,0);

  RigidBody rb = new RigidBody(
    5f,
    startPos,
    velocity,
    new Quaternion(),
    new Vector3D(0,0,0), //Vitesse angulaire mais on peut la mettre avec addposatloc
    projectileLauncher.currentMassOffsetToApply
  );
  rb.SetBox(10f, 10f, 10f);
  inGameRigidBodies.add(rb);
  rb.AddForceAtPosition(new Vector3D(0,0,-10000), offset);
}