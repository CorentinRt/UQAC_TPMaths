//Class used to define default statistics of different projectiles

public enum EProjectileType
{
  BALL,
  BOULDER,
  FIREBALL,
  LASER
}

public class ProjectileStatistics
{
  float mass = 100;
  Vector3D initialVelocity = new Vector3D(8, -15, 0);
  
  ProjectileStatistics(float mass, Vector3D initialVelocity){
    this.mass = mass;
    this.initialVelocity = initialVelocity;
  }
}

//Different Classes extending from Particle 

public class Ball extends Particle
{
  
  Ball(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = ballDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = ballDefaultStats.mass;
  }
}

public class Boulder extends Particle
{
  
  Boulder(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = boulderDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = boulderDefaultStats.mass;
  }
}

public class Fireball extends Particle
{
  
  Fireball(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = fireballDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = fireballDefaultStats.mass;
  }
}

public class Laser extends Particle
{
  
  Laser(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = laserDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = laserDefaultStats.mass;
  }
}
