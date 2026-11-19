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
  float initialVelocityMultiplier = 5;
  color eulerColor;
  color verletColor;

  float width = 0f;
  float height = 0f;
  float depth = 0f;
  
  ProjectileStatistics(float mass, float initialVelocityMultiplier, color eulerColor, color verletColor, float width, float height, float depth){
    this.mass = mass;
    this.initialVelocityMultiplier = initialVelocityMultiplier;
    this.eulerColor = eulerColor;
    this.verletColor = verletColor;
    this.width = width;
    this.height = height;
    this.depth = depth;
  }
}

//Different Classes extending from Particle 

public class Ball extends RigidBody
{ 
  Ball(Vector3D position, Vector3D direction, Vector3D massOffset){
    super(ballDefaultStats.mass, position, direction.MultiplyByScalar(ballDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), massOffset, 0.4, 0.3);
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
    super.SetBox(fireballDefaultStats.width, fireballDefaultStats.height, fireballDefaultStats.depth);
  }
}

public class Boulder extends RigidBody
{
  Boulder(Vector3D position, Vector3D direction, Vector3D massOffset){
    super(boulderDefaultStats.mass, position, direction.MultiplyByScalar(boulderDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), massOffset, 0.7, 0.5);
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
    super.SetBox(fireballDefaultStats.width, fireballDefaultStats.height, fireballDefaultStats.depth);
  }
}

public class Fireball extends RigidBody
{ 
  Fireball(Vector3D position, Vector3D direction, Vector3D massOffset){
    super(fireballDefaultStats.mass, position, direction.MultiplyByScalar(fireballDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), massOffset, 0.3, 0.1);
    this.eulerColor = fireballDefaultStats.eulerColor;
    this.verletColor = fireballDefaultStats.verletColor;
    super.SetBox(fireballDefaultStats.width, fireballDefaultStats.height, fireballDefaultStats.depth);
  }
}

public class Laser extends RigidBody
{
  Laser(Vector3D position, Vector3D direction, Vector3D massOffset){
    super(laserDefaultStats.mass, position, direction.MultiplyByScalar(laserDefaultStats.initialVelocityMultiplier), new Quaternion(), new Vector3D(), new Vector3D(), 0, 0);
    super.SetBox(fireballDefaultStats.width, fireballDefaultStats.height, fireballDefaultStats.depth);
  }
}
