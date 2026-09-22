class Particle
{
  EIntegrationMethod integrationMethod = EIntegrationMethod.EULER;
  
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
  
  void SetIntegrationMethod(EIntegrationMethod inIntegration)
  {
    integrationMethod = inIntegration;
  }
  
  Vector3D ComputeLastPosition(float deltaTime)
  {
    if (damping != 0)
    {
      Vector3D acceleration = ComputeGravitationalAcceleration();
    
      Vector3D accelerationModifier = acceleration.MultiplyByScalar(0.5 * (float)Math.pow(deltaTime, 2));
      
      float dampingDt = (float)Math.pow(damping, deltaTime);
                
      Vector3D velocityDamped = linearVelocity.MultiplyByScalar(dampingDt);
    
      return (position.Substract(velocityDamped.MultiplyByScalar(deltaTime)).Substract(accelerationModifier));
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
  
  Vector3D ComputeGravitationalAcceleration()
  {
    Vector3D gravitionalForce = gravitationalAcceleration.MultiplyByScalar(mass);  // Fg = 9.81 * Mobj
    
    return gravitionalForce.MultiplyByScalar(InverseMass());  // Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
  }
  
  void Draw(color c, float radius){
    pushMatrix();
    stroke(c);
    translate(position.x * pixelsPerMeter, position.y * pixelsPerMeter, position.z * pixelsPerMeter);
    sphere(radius);
    popMatrix(); //Reset translation for futur Draws
  }
  
  void DrawAtPosition(Vector3D inPosition, color c, float radius)
  {
    pushMatrix();
    stroke(c);
    translate(inPosition.x * pixelsPerMeter, inPosition.y * pixelsPerMeter, inPosition.z * pixelsPerMeter);
    sphere(radius);
    popMatrix(); //Reset translation for futur Draws
  }
  
  void DrawPredictedTrajectoryDebug(float predictedTime, float deltaTime, float stepTimeByDraw)
  {
    switch (integrationMethod)
    {
      case EULER:
        DrawEulerPredictedTrajectoryDebug(predictedTime, deltaTime, stepTimeByDraw);
        break;
        
      case VERLET:
        DrawVerletPredictedTrajectoryDebug(predictedTime, deltaTime);
        break;
        
      default:
        break;
      
    }
  }
  
  void DrawEulerPredictedTrajectoryDebug(float predictedTime, float deltaTime, float stepTimeByDraw)
  {
    Vector3D currentSimulatedPos = new Vector3D(position.x, position.y, position.z);
    
    Vector3D currentSimulatedVelocity = new Vector3D(linearVelocity.x, linearVelocity.y, linearVelocity.z);
    
    float currentSimulatedTime = 0.0;
    
    float currentStepTimeByDraw = 0.0;
    
    boolean canDraw = true;
    
    while (currentSimulatedTime < predictedTime)
    {
      SimulateEulerIntegrate(currentSimulatedPos, currentSimulatedVelocity, deltaTime);
      
      currentSimulatedTime += deltaTime;
      
      currentStepTimeByDraw += deltaTime;
      
      if (currentStepTimeByDraw > stepTimeByDraw)
      {
        canDraw = true;
        currentStepTimeByDraw = 0.0;
      }
      
      if (canDraw)
      {
        DrawAtPosition(currentSimulatedPos, color(0, 255, 0), 20);
        
        canDraw = false;
      }
      
    }
  }
  
  void DrawVerletPredictedTrajectoryDebug(float predictedTime, float deltaTime)
  {
    
    
  }
  
  void SimulateEulerIntegrate(Vector3D outPosition, Vector3D outVelocity, float deltaTime)
  {
    Vector3D tempPos = new Vector3D(outPosition.x, outPosition.y, outPosition.z);
    Vector3D tempVelocity = new Vector3D(outVelocity.x, outVelocity.y, outVelocity.z);
    
    Vector3D acceleration = ComputeGravitationalAcceleration();
    
    tempVelocity = tempVelocity.MultiplyByScalar((float)Math.pow(damping, deltaTime));  // Damping
    
    tempVelocity = tempVelocity.Add(acceleration.MultiplyByScalar(deltaTime));
    
    tempPos = tempPos.Add(tempVelocity.MultiplyByScalar(deltaTime));
    
    outPosition.x = tempPos.x;
    outPosition.y = tempPos.y;
    outPosition.z = tempPos.z;
    
    outVelocity.x = tempVelocity.x;
    outVelocity.y = tempVelocity.y;
    outVelocity.z = tempVelocity.z;
  }
  
  void Integrate(float deltaTime){
    
    switch (integrationMethod)
    {
      case EULER:
        EulerIntegrate(deltaTime);
        break;
        
       case VERLET:
         VerletIntegrate(deltaTime);
         break;
         
       default:
         break;
    }
  }
  
  void EulerIntegrate(float deltaTime){
    
    Vector3D acceleration = ComputeGravitationalAcceleration();
    
    linearVelocity = linearVelocity.MultiplyByScalar((float)Math.pow(damping, deltaTime));  // Damping
    
    linearVelocity = linearVelocity.Add(acceleration.MultiplyByScalar(deltaTime));
    
    this.position = position.Add(linearVelocity.MultiplyByScalar(deltaTime));
  }
  
  void VerletIntegrate(float deltaTime){
    
    Vector3D lastPosition = ComputeLastPosition(deltaTime);
    
    Vector3D acceleration = ComputeGravitationalAcceleration();
    
    Vector3D accDeltaTimeSquared = acceleration.MultiplyByScalar(deltaTime * deltaTime);
      
    position = position.MultiplyByScalar(2.0).Substract(lastPosition).Add(accDeltaTimeSquared);  // formule de Verlet  p+1 = 2p0 - p-1 + dt * a²
    
    //println(position.GetText());
    
    float dampingDt = (float)Math.pow(damping, deltaTime);
    
    linearVelocity = (position.Substract(lastPosition)).MultiplyByScalar(1 / (2.0 * deltaTime));  // vitesse inst = d / dt
    linearVelocity = linearVelocity.MultiplyByScalar(dampingDt);  // apply damping
  }
  
}
