class Particle implements IPhysicsEntity, IUpdatable
{
  EIntegrationMethod integrationMethod = EIntegrationMethod.EULER;
  
  //Variables for class Particle
  Vector3D position = new Vector3D();
  Vector3D linearVelocity = new Vector3D();
  
  Vector3D accumForce = new Vector3D();
  
  float coefStaticFriction = 0.5f;
  float coefCineticFriction = 0.3f;

  float mass = 0;
  float radius = 1.0f;

  boolean isResting = false;
  Vector3D contactNormal = new Vector3D();

  SphereCollider collider = new SphereCollider(this, radius);
  
  color eulerColor;
  color verletColor;

  boolean affectedByGravity = true;
  
  Particle(){
    this.mass = 0;
    this.position = new Vector3D(0,0,0);
    this.linearVelocity = new Vector3D(0,0,0);
    
    RegisterToManagers();
  }

  Particle(float mass){
    this.mass = mass;
    this.position = new Vector3D(0,0,0);
    
    this.linearVelocity = new Vector3D(0,0,0);

    RegisterToManagers();
}
  
  Particle(float mass, Vector3D position){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = new Vector3D(0,0,0);

    RegisterToManagers();
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;

    RegisterToManagers();
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float coefStaticFriction, float coefCineticFriction){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.coefStaticFriction = coefStaticFriction;
    this.coefCineticFriction = coefCineticFriction;

    RegisterToManagers();
  }

  Particle(float mass, Vector3D position, Vector3D linearVelocity, float coefStaticFriction, float coefCineticFriction, float radius){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.coefStaticFriction = coefStaticFriction;
    this.coefCineticFriction = coefCineticFriction;
    this.radius = radius;

    this.collider = new SphereCollider(this, radius);

    RegisterToManagers();
  }
  
  Particle(float mass, Vector3D position, Vector3D linearVelocity, float coefStaticFriction, float coefCineticFriction, EIntegrationMethod inIntegrationMethod){
    this.mass = mass;
    this.position = position;
    this.linearVelocity = linearVelocity;
    this.coefStaticFriction = coefStaticFriction;
    this.coefCineticFriction = coefCineticFriction;

    this.integrationMethod = inIntegrationMethod;

    RegisterToManagers();
  }

  void RegisterToManagers(){
    physicsEngine.Register(this);
    updateManager.Register(this);

    allParticles.add(this);
  }

  void DestroyParticle(){
    physicsEngine.Unregister(this);
    updateManager.Unregister(this);

    allParticles.remove(this);
  }

  void SetAffectedByGravity(boolean newAffectedByGravity)
  {
    affectedByGravity = newAffectedByGravity;
  }
  
  // IPhysicsEntity
  void UpdatePhysics(float deltaTime)
  {
    Integrate(deltaTime);

    ClearAccum();
  }
  
  void AddForce(Vector3D force)
  {
    accumForce = accumForce.Add(force);
  }
  
  void ClearAccum()
  {
    accumForce = new Vector3D(0, 0, 0);
  }

  void AddPosition(Vector3D position)
  {
    this.position = this.position.Add(position);
  }

  Vector3D GetLinearVelocity(){
    return linearVelocity;
  }

  float GetMass(){
    return mass;
  }
  
  // ------------
  
  // IUpdatable
  void Update(float deltaTime)
  {
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
  
  public void finalize(){
    collider = null;
  }
  
  
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
    return PhysicsUtilities.ComputeLastPosition(currentPos, currentVelocity, currentAcceleration, deltaTime);
  }
  
  float InverseMass() {
    if (mass <= 0)
      return 0;  // Pour éviter un crash et ainsi mettre les objets immobiles sur 0

    if (mass == INFINITE_MASS)
      return 0;

    return 1 / mass;
  }
  
  void SetPosition(Vector3D newPosition){
    position = newPosition;
  }
  
  void SetPosition(float x, float y, float z){
    position = new Vector3D(x, y, z);
  }
  
  Vector3D ComputeAccelerationByForce()
  {
    return PhysicsUtilities.ComputeAccelerationByForce(mass, accumForce);
  }
  
  void Draw(color c, float radius){
    pushMatrix();
    noStroke();
    fill(c);
    translate(position.x * pixelsPerMeter, position.y * pixelsPerMeter, position.z * pixelsPerMeter);
    sphere(radius * pixelsPerMeter);
    popMatrix(); //Reset translation for futur Draws
  }
  
  void DrawAtPosition(Vector3D inPosition, color c, float radius)
  {
    pushMatrix();
    stroke(c);
    translate(inPosition.x * pixelsPerMeter, inPosition.y * pixelsPerMeter, inPosition.z * pixelsPerMeter);
    sphere(radius * pixelsPerMeter);
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
    if (InverseMass() == 0.0)
      return;
      
    PhysicsUtilities.SimulateEulerIntegrate(position, linearVelocity, ComputeAccelerationByForce(), deltaTime);
  }
  
  void VerletIntegrate(float deltaTime)
  {
    if (InverseMass() == 0.0)
      return;
      
    PhysicsUtilities.SimulateVerletIntegrate(position, linearVelocity, ComputeAccelerationByForce(), deltaTime);
  }
  
  boolean isPositionInContact(Vector3D otherPosition, float threshold)
  {
      return otherPosition.Distance(position) < radius + threshold;
  }
  
  
}
