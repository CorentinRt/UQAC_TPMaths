Vector3DUnitTests VectorTests = new Vector3DUnitTests();

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
  
  VectorTests.TestAll();
  
  eulerParticle = new Particle(1, new Vector3D(-15, 10, 0), new Vector3D(8, -15, 0), 1.0);
  
  verletParticle = new Particle(1, new Vector3D(-15, 10, 0), new Vector3D(8, -15, 0), 1.0);
  verletParticle.SetIntegrationMethod(EIntegrationMethod.VERLET);
  
  lastFrameUpdate = millis();
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
  
  text("Frame Rate : " + deltaTime, 0, 0);
  
  println(deltaTime);
  
  //Calcul et utilisation
  // Physique
  eulerParticle.Integrate(deltaTime);
  verletParticle.Integrate(deltaTime);
  
  
  //Affichage
  eulerParticle.Draw(color(0,0,255), 20);
  verletParticle.Draw(color(255, 0, 0), 20);
  
  
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
