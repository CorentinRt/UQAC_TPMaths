class Particle
{
  //Accesseurs pour l'attribut InverseMasse
  
  //Variables for class Particle
  Vector3D position = new Vector3D();
  Vector3D linearVelocity = new Vector3D();
  Vector3D lastPosition = new Vector3D();
  float mass = 0;
  
  
  float damping = 0;
  
  Particle(){
    this.mass = 0;
    this.position = new Vector3D(0,0,0);
    lastPosition = position;
    this.linearVelocity = new Vector3D(0,0,0);
  }

  Particle(float mass){
    this.mass = mass;
    this.position = new Vector3D(0,0,0);
    lastPosition = position;
    this.linearVelocity = new Vector3D(0,0,0);
}
  
  Particle(float mass, Vector3D position){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = new Vector3D(0,0,0);
    
    lastPosition = position.Substract(linearVelocity);
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    lastPosition = position.Substract(linearVelocity);
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float damping){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.damping = damping;
    lastPosition = position.Substract(linearVelocity);
    
    println(lastPosition.GetText());
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
    Vector3D acceleration = gravitationalForce.MultiplyByScalar(mass).MultiplyByScalar(InverseMass());  // 9.81 * Mobj * (1 / InverseMobj)
    
    linearVelocity = linearVelocity.MultiplyByScalar((float)Math.pow(damping, deltaTime));  // Damping
    
    linearVelocity = linearVelocity.Add(acceleration.MultiplyByScalar(deltaTime));
    
    this.position = position.Add(linearVelocity.MultiplyByScalar(deltaTime));
  }
  
  void VerletIntegrate (float deltaTime){
    Vector3D tempPos = position;
    
    Vector3D acceleration = gravitationalForce.MultiplyByScalar(mass).MultiplyByScalar(InverseMass());
    
    Vector3D aT = acceleration.MultiplyByScalar((float)Math.pow(deltaTime, 2));
   
    Vector3D twoTimesPos = position.MultiplyByScalar(2);
    
    position = twoTimesPos.Substract(lastPosition).Add(aT);
    
    linearVelocity = tempPos.Substract(lastPosition);
    
    lastPosition = tempPos;
  }
  
}
