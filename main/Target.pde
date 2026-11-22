class Target
{
  Vector3D position;
  float radius;
  boolean isHit = false;
  color colorDefault = color(255,255,0);
  color colorHit = color(255,0,0);
  int scoreValue = 1;

  
  Target(Vector3D newPosition, float radiusToSet)
  {
    position = newPosition;
    radius = radiusToSet;
  }
  
  Target(Vector3D newPosition, float radiusToSet, int customScore)
  {
    position = newPosition;
    radius = radiusToSet;
    scoreValue = customScore;
  }
  
  //Check if a particle hit a target
  boolean CheckCollision(Particle p)
  {
    if (isHit) return false; //Basecase if target is already on

    if (p.CollidesWithSphere(position, radius / pixelsPerMeter))
    {
      TriggerHit();
      return true;
    }
    return false;
    
    /*
    //Distance between particle & target
    float distPtoT = pow(p.position.x - position.x, 2) + pow(p.position.y - position.y, 2) + pow(p.position.z - position.z, 2);
                   
    float combinedRadius = (radius / pixelsPerMeter) + (p.radius / pixelsPerMeter);
    
    if (distPtoT <= (combinedRadius * combinedRadius))
    {
      TriggerHit();
      return true;
    }
    return false;
    */
  }
  
  void TriggerHit()
  {
    isHit = true;
    println("Target touched at : " + position.GetText());
  }
  
  void RespawnElsewhere()
  {
    float margin = radius / pixelsPerMeter;

    position = corridor.GetRandomPointInside(margin, 0.05f, 0.5f);
    isHit = false;
  }
  
  void Draw()
  {
    pushMatrix();
    color c = isHit ? colorHit : colorDefault;
    stroke(c);
    fill(c, 150);
    translate(position.x * pixelsPerMeter, position.y * pixelsPerMeter, position.z * pixelsPerMeter);
    
    sphere(radius);
    popMatrix();
  }
  
  void Reset()
  {
    isHit = false;
  }
}
