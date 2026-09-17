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
    
    lastPosition = position.Substract(linearVelocity.MultiplyByScalar(fixedTimeStep));
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    lastPosition = position.Substract(linearVelocity.MultiplyByScalar(fixedTimeStep));
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float damping){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.damping = damping;
    lastPosition = position.Substract(linearVelocity.MultiplyByScalar(fixedTimeStep));
    
    println(lastPosition.GetText());
  }
  
  float InverseMass() {
    if (mass <= 0)
      return 0;  // Pour éviter un crash et ainsi mettre les objets immobiles sur 0
      
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
    translate(position.x * pixelsPerMeter, position.y * pixelsPerMeter, position.z * pixelsPerMeter);
    sphere(radius);
    popMatrix(); //Reset translation for futur Draws
  }
  
  //Intégrateur pour update pos et vel de Particule (Euler ou Verlet ou les 2 qu'on pourrait switch manuellement)
  //prendre en compte damping
  
  void EulerIntegrate(float deltaTime){
    Vector3D gravitionalForce = gravitationalAcceleration.MultiplyByScalar(mass);  // Fg = 9.81 * Mobj
    Vector3D acceleration = gravitionalForce.MultiplyByScalar(InverseMass()); // Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
    
    linearVelocity = linearVelocity.MultiplyByScalar((float)Math.pow(damping, deltaTime));  // Damping
    
    linearVelocity = linearVelocity.Add(acceleration.MultiplyByScalar(deltaTime));
    
    this.position = position.Add(linearVelocity.MultiplyByScalar(deltaTime));
  }
  
  void VerletIntegrate(float deltaTime){
    Vector3D tempPos = position;
    
    Vector3D gravitionalForce = gravitationalAcceleration.MultiplyByScalar(mass);  // Fg = 9.81 * Mobj
    Vector3D acceleration = gravitionalForce.MultiplyByScalar(InverseMass());  // Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
    
    Vector3D accDeltaTimeSquared = acceleration.MultiplyByScalar((float)Math.pow(deltaTime, 2));
   
    Vector3D twoTimesPos = position.MultiplyByScalar(2);
    
    position = twoTimesPos.Substract(lastPosition).Add(accDeltaTimeSquared);  // formule de Verlet  p1 = 2p0 - p-1 + dt * a²
    
    linearVelocity = tempPos.Substract(lastPosition);  // d
    linearVelocity = linearVelocity.MultiplyByScalar(1 / deltaTime);  // vitesse inst = d / dt
    
    lastPosition = tempPos;
  }
  
}
