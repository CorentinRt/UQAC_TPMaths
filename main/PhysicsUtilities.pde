static class PhysicsUtilities
{
  static void SimulateEulerIntegrate(Vector3D outPosition, Vector3D outVelocity, Vector3D inAcceleration, float deltaTime)
  {
    Vector3D tempPos = new Vector3D(outPosition.x, outPosition.y, outPosition.z);
    Vector3D tempVelocity = new Vector3D(outVelocity.x, outVelocity.y, outVelocity.z);
    
    tempVelocity = tempVelocity.Add(inAcceleration.MultiplyByScalar(deltaTime));
    
    tempPos = tempPos.Add(tempVelocity.MultiplyByScalar(deltaTime));
    
    outPosition.x = tempPos.x;
    outPosition.y = tempPos.y;
    outPosition.z = tempPos.z;
    
    outVelocity.x = tempVelocity.x;
    outVelocity.y = tempVelocity.y;
    outVelocity.z = tempVelocity.z;
  }
  
  static void SimulateVerletIntegrate(Vector3D outPosition, Vector3D outVelocity, Vector3D inAcceleration, float deltaTime)
  {
    Vector3D tempPos = new Vector3D(outPosition.x, outPosition.y, outPosition.z);
    Vector3D tempVelocity = new Vector3D(outVelocity.x, outVelocity.y, outVelocity.z);
    
    Vector3D lastPosition = ComputeLastPosition(tempPos, tempVelocity, inAcceleration, deltaTime);
    
    
    Vector3D accDeltaTimeSquared = inAcceleration.MultiplyByScalar(deltaTime * deltaTime);
      
    tempPos = tempPos.MultiplyByScalar(2.0).Substract(lastPosition).Add(accDeltaTimeSquared);  // formule de Verlet  p+1 = 2p0 - p-1 + dt * a²
    
    tempVelocity = (tempPos.Substract(lastPosition)).MultiplyByScalar(1 / (2.0 * deltaTime));  // vitesse inst = d / dt
    
    outPosition.x = tempPos.x;
    outPosition.y = tempPos.y;
    outPosition.z = tempPos.z;
    
    outVelocity.x = tempVelocity.x;
    outVelocity.y = tempVelocity.y;
    outVelocity.z = tempVelocity.z;
  }
  
  static Vector3D ComputeLastPosition(Vector3D currentPos, Vector3D currentVelocity, Vector3D currentAcceleration, float deltaTime)
  {
      Vector3D accelerationModifier = currentAcceleration.MultiplyByScalar(0.5 * (float)Math.pow(deltaTime, 2));
      
      return (currentPos.Substract(currentVelocity.MultiplyByScalar(deltaTime)).Substract(accelerationModifier));
  }
  
  static float InverseMass(float inMass)
  {
    if (inMass <= 0)
      return 0;  // Pour éviter un crash et ainsi mettre les objets immobiles sur 0
    else
      return 1 / inMass;
  }
  
  static Vector3D ComputeAccelerationByForce(float inMass, Vector3D accumForces)
  {
    float inverseMass = InverseMass(inMass);
    
    return accumForces.MultiplyByScalar(inverseMass); // si seulement gravité : Accg = Fg * (1/m) = 9.81 (retour case départ) car F = a * m donc a = F * (1 / m)
  }
}
