Vector3DUnitTests VectorTests = new Vector3DUnitTests();

//Constante force gravitationnel
float pixelsPerMeter = 30;
Vector3D gravitationalAcceleration = new Vector3D(0, 9.81, 0);

//Variables
Particle testParticle;
int lastFrameUpdate = 0;

// Fix time step
float accumulator = 0;
float fixedTimeStep = (1.0 / 60.0);

void setup()
{
  size(800,600, P3D);
  background(100);
  
  VectorTests.TestAll();
  
  testParticle = new Particle(1, new Vector3D(-20, 25, 0), new Vector3D(8, -25, 0), 1);
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
  
  //Calcul et utilisation
  
  // Physique
  accumulator += deltaTime;
  
  while (accumulator >= fixedTimeStep)
  {
    accumulator -= fixedTimeStep;
    
    testParticle.EulerIntegrate(fixedTimeStep);
    //testParticle.VerletIntegrate(fixedTimeStep);

  }
  
  
  
  //Affichage
  testParticle.Draw(color(0,0,255), 20);
  
  
  //Drawing Test particle at given position
  //println(testParticle.position.x + ", " + testParticle.position.y + ", " + testParticle.position.z);
  //println(deltaTime);
  
  // Gameloop
  //4 différents projectiles (balles, boulets, laser et boule de feu)
  //Tir
  //Propre vélocité et masse
  //Frottement négligeable (près de 1)
  //Trajectoire des tirs visible
  
  
}
