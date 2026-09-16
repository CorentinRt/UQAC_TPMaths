class Particle
{
  //Accesseurs pour l'attribut InverseMasse
  
  //Variables for class Particle
  Vector3D position = new Vector3D();
  Vector3D linearVelocity = new Vector3D();
  float mass = 0;
  
  Particle(){
    this.mass = 0;
    this.position = new Vector3D(0,0,0);
    this.linearVelocity = new Vector3D(0,0,0);
  }

  Particle(float mass){
    this.mass = mass;
    this.position = new Vector3D(0,0,0);
    this.linearVelocity = new Vector3D(0,0,0);
}
  
  Particle(float mass, Vector3D position){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = new Vector3D(0,0,0);
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
  }
  
  float InverseMass() {
    return 1 / mass;
  }
  
  void SetPosition(Vector3D newPosition){
    position = newPosition;
  }
  
  void SetPosition(float x, float y, float z){
    position = new Vector3D(x, y, z);
  }
  
  void Draw(color c, float radius){
    pushMatrix();
    stroke(c);
    translate(position.x, position.y, position.z);
    sphere(radius);
    popMatrix(); //Reset translation for futur Draws
  }
  
  //Intégrateur pour update pos et vel de Particule (Euler ou Verlet ou les 2 qu'on pourrait switch manuellement)
  //prendre en compte damping
  
  void EulerIntegrate(float deltaTime){
    Vector3D acceleration = gravitationalForce.MultiplyByScalar(InverseMass());
    this.linearVelocity = linearVelocity.Add(acceleration.MultiplyByScalar(deltaTime));
    this.position = position.Add(linearVelocity.MultiplyByScalar(deltaTime));
  }
  
}
