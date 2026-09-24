class Particle implements IPhysicsEntity, IUpdatable
{
  EIntegrationMethod integrationMethod = EIntegrationMethod.EULER;
  
  //Variables for class Particle
  Vector3D position = new Vector3D();
  Vector3D linearVelocity = new Vector3D();
  float mass = 0;
  float radius = 20.0f;
  
  color eulerColor;
  color verletColor;
  
  
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
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float damping, EIntegrationMethod inIntegrationMethod){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.damping = damping;
    
    this.integrationMethod = inIntegrationMethod;
  }
  
  // IPhysicsEntity
  void UpdatePhysics(float deltaTime)
  {
    Integrate(deltaTime);
  }
  
  // ------------
  
  // IUpdatable
  void Update(float deltaTime)
  {
    
    /*color predictedColor = color(255, 255, 0);
    switch (integrationMethod)
    {
      case EULER:
        predictedColor = color(0, 255, 0);
        break;
        
      case VERLET:
        predictedColor = color(255, 200, 50);
        break;
        
      default:
        break;
        
    }
    
    physicsDebugPredictor.DrawDebugSimulation(integrationMethod, position, linearVelocity, ComputeGravitationalAcceleration(), damping, predictedColor, 20.0, 2.0, 0.15, deltaTime);
    */
    color c = color(255, 0, 0);
    
    switch (integrationMethod)
    {
      case EULER:
        c = eulerColor;
        break;
        
      case VERLET:
        c = verletColor;
        break;
        
      default:
        c = color(100, 50, 200);
        break;
      
    }
    
    Draw(c,radius);
  }

  // ------------
  
  
  
  void SetIntegrationMethod(EIntegrationMethod inIntegration)
  {
    integrationMethod = inIntegration;
  }
  
  EIntegrationMethod GetIntegrationMethod()
  {
    return integrationMethod;
  }
  
  void SetDrawColors(color eulerColor, color verletColor){
    this.eulerColor = eulerColor;
    this.verletColor = verletColor;
  }
  
  Vector3D ComputeLastPosition(Vector3D currentPos, Vector3D currentVelocity, Vector3D currentAcceleration, float deltaTime)
  {
    return PhysicsUtilities.ComputeLastPosition(currentPos, currentVelocity, currentAcceleration, damping, deltaTime);
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
    return PhysicsUtilities.ComputeGravitationalAcceleration(mass);
  }
  
  void Draw(color c, float radius){
    pushMatrix();
    noStroke();
    fill(c);
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
  
  void EulerIntegrate(float deltaTime)
  {
    PhysicsUtilities.SimulateEulerIntegrate(position, linearVelocity, ComputeGravitationalAcceleration(), damping, deltaTime);
  }
  
  void VerletIntegrate(float deltaTime)
  {
    PhysicsUtilities.SimulateVerletIntegrate(position, linearVelocity, ComputeGravitationalAcceleration(), damping, deltaTime);
  }
  
}
