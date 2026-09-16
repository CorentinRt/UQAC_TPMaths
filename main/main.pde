Vector3DUnitTests VectorTests = new Vector3DUnitTests();
Particle testParticle = new Particle();



void setup()
{
  size(800,600, P3D);
  background(100);
  
  VectorTests.TestAll();

}


void draw()
{
  //Basic Camera just to display (TODO: Verify with teacher if we are allowed to use all this)
  background(100);
  camera(mouseX, height/2, (height/2) / tan(PI/6), mouseX, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, -100); //Center of Scene
  stroke(color(0,0,0));
  sphere(1); //Center of Scene
 
  //Delta time
  //Calcul et utilisation
  //Affichage
  
  //Drawing Test particle at given position
  testParticle.SetPosition(100, 0, -400);
  testParticle.Draw(color(0,0,255), 20);
  
  
  // Gameloop
  //4 différents projectiles (balles, boulets, laser et boule de feu)
  //Tir
  //Propre vélocité et masse
  //Frottement négligeable (près de 1)
  //Trajectoire des tirs visible
  
  
}
