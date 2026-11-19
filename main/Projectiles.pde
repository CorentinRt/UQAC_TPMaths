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

public class Ball extends RigidBody
{ 
  Ball(Vector3D position, Vector3D direction){
    super(ballDefaultStats.mass, position, direction.Multiply(ballDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), new Vector3D(), 0.4, 0.3);
  }
}

public class Boulder extends RigidBody
{
  Boulder(Vector3D position, Vector3D direction){
    super(boulderDefaultStats.mass, position, direction.Multiply(boulderDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), new Vector3D(), 0.7, 0.5);
  }
}

public class Fireball extends RigidBody
{ 
  Fireball(Vector3D position, Vector3D direction){
    super(fireballDefaultStats.mass, position, direction.Multiply(fireballDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), new Vector3D(), 0.3, 0.1);
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
  }
}

public class Laser extends RigidBody
{
  Laser(Vector3D position, Vector3D direction){
    super(laserDefaultStats.mass, position, direction.Multiply(laserDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), new Vector3D(), 0, 0);
  }
}
