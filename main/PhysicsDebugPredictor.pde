class PhysicsDebugPredictor
{
  void DrawAtPosition(Vector3D inPosition, color c, float radius)
  {
    pushMatrix();
    stroke(c);
    translate(inPosition.x * pixelsPerMeter, inPosition.y * pixelsPerMeter, inPosition.z * pixelsPerMeter);
    sphere(radius);
    popMatrix(); //Reset translation for futur Draws
  }
  
  void DrawDebugSimulation(EIntegrationMethod inIntegrationMethod, Vector3D startPosition, Vector3D startVelocity, Vector3D inAcceleration, float damping, color c, float radius, float predictedTime, float stepTimeByDraw, float deltaTime)
  {
    Vector3D currentSimulatedPos = new Vector3D(startPosition.x, startPosition.y, startPosition.z);
    
    Vector3D currentSimulatedVelocity = new Vector3D(startVelocity.x, startVelocity.y, startVelocity.z);
    
    float currentSimulatedTime = 0.0;
    
    float currentStepTimeByDraw = 0.0;
    
    boolean canDraw = true;
    
    
    while (currentSimulatedTime < predictedTime)
    {
      switch (inIntegrationMethod)
      {
        case EULER:
          PhysicsUtilities.SimulateEulerIntegrate(currentSimulatedPos, currentSimulatedVelocity, inAcceleration, damping, deltaTime);
          break;
          
        case VERLET:
          PhysicsUtilities.SimulateVerletIntegrate(currentSimulatedPos, currentSimulatedVelocity, inAcceleration, damping, deltaTime);
          break;
          
        default:
          break;
        
      }
      
      currentSimulatedTime += deltaTime;
      
      currentStepTimeByDraw += deltaTime;
      
      if (currentStepTimeByDraw > stepTimeByDraw)
      {
        canDraw = true;
        currentStepTimeByDraw = 0.0;
      }
      
      if (canDraw)
      { 
        DrawAtPosition(currentSimulatedPos, c, 20);
        
        canDraw = false;
      }
    }
  }
}
