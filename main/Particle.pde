class Particle
{
  //Accesseurs pour l'attribut InverseMasse
  
  //Variables for class Particle
  Vector3D position = new Vector3D();
  Vector3D linearVelocity = new Vector3D();
  float mass = 0;
  
  
  float damping = 1.0;
  
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
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float damping){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.damping = damping;
    
  }
  
  Vector3D ComputeLastPosition(float deltaTime)
  {
    if (damping != 0)
    {
      Vector3D gravitionalForce = gravitationalAcceleration.MultiplyByScalar(mass);  // Fg = 9.81 * Mobj
      Vector3D acceleration = gravitionalForce.MultiplyByScalar(InverseMass());  // Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
    
      Vector3D accelerationModifier = acceleration.MultiplyByScalar(2.0 * (float)Math.pow(deltaTime, 2));
      
      float inverseDamping = (float)Math.pow(damping, deltaTime);
      
      Vector3D velocityDamped = linearVelocity.MultiplyByScalar(inverseDamping);
    
      //return (position.Substract(velocityDamped.MultiplyByScalar(deltaTime))).Substract(accelerationModifier);
      
      
      return (position.Substract(velocityDamped.MultiplyByScalar(deltaTime))).Substract(acceleration.MultiplyByScalar(deltaTime));
    }
    else
    {
      return  position;
    }
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
    
    Vector3D lastPosition = ComputeLastPosition(deltaTime);
    
    linearVelocity = tempPos.Substract(lastPosition);  // d
    linearVelocity = linearVelocity.MultiplyByScalar(1 / deltaTime);  // vitesse inst = d / dt
    
    Vector3D gravitionalForce = gravitationalAcceleration.MultiplyByScalar(mass);  // Fg = 9.81 * Mobj
    Vector3D acceleration = gravitionalForce.MultiplyByScalar(InverseMass());  // Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
    
    Vector3D accDeltaTimeSquared = acceleration.MultiplyByScalar((float)Math.pow(deltaTime, 2));
   
    Vector3D diffPosDamped = ((position).Substract(lastPosition)).MultiplyByScalar((float)Math.pow(damping, deltaTime));  // p+1 = p + (p - p-1) * damping + dt * a²
   
    position = position.Add(diffPosDamped).Add(accDeltaTimeSquared);  // formule de Verlet  p+1 = 2p0 - p-1 + dt * a²
    
    println(position.GetText());
    
    linearVelocity = position.Substract(tempPos);  // d
    linearVelocity = linearVelocity.MultiplyByScalar(1 / deltaTime);  // vitesse inst = d / dt
    
    lastPosition = tempPos;
  }
  
}
