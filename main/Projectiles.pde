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
  Vector3D initialVelocityMultiplier = new Vector3D(1, 1, 1);
  color eulerColor;
  color verletColor;
  
  ProjectileStatistics(float mass, Vector3D initialVelocityMultiplier, color eulerColor, color verletColor){
    this.mass = mass;
    this.initialVelocityMultiplier = initialVelocityMultiplier;
    this.eulerColor = eulerColor;
    this.verletColor = verletColor;
  }
}

//Different Classes extending from Particle 

public class Ball extends Particle
{
  
  Ball(Vector3D position, Vector3D direction){
    this.position = position;
    this.linearVelocity = direction.Multiply(ballDefaultStats.initialVelocityMultiplier);
    this.mass = ballDefaultStats.mass;
    this.eulerColor = ballDefaultStats.eulerColor;
    this.verletColor = ballDefaultStats.verletColor;
    this.coefStaticFriction = 0.4;
    this.coefCineticFriction = 0.3;
  }
}

public class Boulder extends Particle
{
  
  Boulder(Vector3D position, Vector3D direction){
    this.position = position;
    this.linearVelocity = direction.Multiply(boulderDefaultStats.initialVelocityMultiplier);
    this.mass = boulderDefaultStats.mass;
    this.eulerColor = boulderDefaultStats.eulerColor;
    this.verletColor = boulderDefaultStats.verletColor;
    this.coefStaticFriction = 0.7;
    this.coefCineticFriction = 0.5;
  }
}

public class Fireball extends Particle
{
  
  Fireball(Vector3D position, Vector3D direction){
    this.position = position;
    this.linearVelocity = direction.Multiply(fireballDefaultStats.initialVelocityMultiplier);
    this.mass = fireballDefaultStats.mass;
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
    this.coefStaticFriction = 0.3;
    this.coefCineticFriction = 0.1;
  }
}

public class Laser extends Particle
{
  
  Laser(Vector3D position, Vector3D direction){
    this.position = position;
    this.linearVelocity = direction.Multiply(laserDefaultStats.initialVelocityMultiplier);
    this.mass = laserDefaultStats.mass;
    this.eulerColor = laserDefaultStats.eulerColor;
    this.verletColor = laserDefaultStats.verletColor;
    this.coefStaticFriction = 0;
    this.coefCineticFriction = 0;
  }
}
