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
  color eulerColor;
  color verletColor;
  
  ProjectileStatistics(float mass, Vector3D initialVelocity, color eulerColor, color verletColor){
    this.mass = mass;
    this.initialVelocity = initialVelocity;
    this.eulerColor = eulerColor;
    this.verletColor = verletColor;
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
    this.eulerColor = ballDefaultStats.eulerColor;
    this.verletColor = ballDefaultStats.verletColor;
  }
}

public class Boulder extends Particle
{
  
  Boulder(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = boulderDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = boulderDefaultStats.mass;
    this.eulerColor = boulderDefaultStats.eulerColor;
    this.verletColor = boulderDefaultStats.verletColor;
  }
}

public class Fireball extends Particle
{
  
  Fireball(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = fireballDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = fireballDefaultStats.mass;
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
  }
}

public class Laser extends Particle
{
  
  Laser(Vector3D position, Vector3D velocityMultiplier, float damping){
    this.position = position;
    this.linearVelocity = laserDefaultStats.initialVelocity.Multiply(velocityMultiplier);
    this.damping = damping;
    this.mass = laserDefaultStats.mass;
    this.eulerColor = laserDefaultStats.eulerColor;
    this.verletColor = laserDefaultStats.verletColor;
  }
}
