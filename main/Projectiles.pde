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

  float coefStaticFriction = 0.5f;
  float coefCineticFriction = 0.3f;

  float angularDamping = 0.98f;

  color drawOldPositionColor = color (255, 0, 0);
  
  ProjectileStatistics(float mass, float initialVelocityMultiplier, color eulerColor, color verletColor, float coefStaticFriction, float coefCineticFriction, float angularDamping, float width, float height, float depth, color drawOldPositionColor){
    this.mass = mass;
    this.initialVelocityMultiplier = initialVelocityMultiplier;
    this.eulerColor = eulerColor;
    this.verletColor = verletColor;
    this.width = width;
    this.height = height;
    this.depth = depth;
    this.coefStaticFriction = coefStaticFriction;
    this.coefCineticFriction = coefCineticFriction;
    this.drawOldPositionColor = drawOldPositionColor;
    this.angularDamping = angularDamping;
  }
}

//Different Classes extending from Particle

public class Projectile extends RigidBody
{
  class PositionRotationPair{
    Vector3D position = new Vector3D();
    Quaternion rotation = new Quaternion();

    PositionRotationPair(Vector3D position, Quaternion rotation){
        this.position = position;
        this.rotation = rotation;
    }
  }

  ArrayList<PositionRotationPair> lastPositions = new ArrayList<PositionRotationPair>();
  color drawOldPositionColor = color(0, 255, 0);

  float timeBetweenEachOldPosition = 0.25f;
  float currentDurationBeforeDrawNewOldPosition = 0f;

  Projectile(ProjectileStatistics stat, Vector3D position, Vector3D direction, Vector3D massOffset, Vector3D initialAngularVelocity){
    super(stat.mass, position, direction.MultiplyByScalar(stat.initialVelocityMultiplier), new Quaternion(), initialAngularVelocity, massOffset, stat.coefStaticFriction, stat.coefCineticFriction);
    this.drawOldPositionColor = stat.drawOldPositionColor;
    this.eulerColor = stat.eulerColor;
    this.verletColor = stat.verletColor;
    super.SetBox(stat.width, stat.height, stat.depth);

    this.rigidBodyColor = stat.drawOldPositionColor;
    this.angularDamping = stat.angularDamping;
  }

  void Update(float deltaTime)
  {
    super.Update(deltaTime);

    UpdateLastPositions(deltaTime);

    for (int i = 0; i < lastPositions.size(); ++i){
      Vector3D positionToDraw = lastPositions.get(i).position;
      Quaternion rotationToDraw = lastPositions.get(i).rotation;

      if (positionToDraw == null)
        continue;
      
      Draw(positionToDraw, rotationToDraw, drawOldPositionColor, false);
    }
  }

  void UpdateLastPositions(float deltaTime){

    if (currentDurationBeforeDrawNewOldPosition > 0f){
      currentDurationBeforeDrawNewOldPosition -= deltaTime;
      return;
    }

    currentDurationBeforeDrawNewOldPosition = timeBetweenEachOldPosition;

    lastPositions.add(new PositionRotationPair(this.position.Copy(), this.rotation.Copy()));

    if (lastPositions.size() >= 5){
      PositionRotationPair firstPair = lastPositions.get(0);

      if (lastPositions != null){
        lastPositions.remove(firstPair);
      }
    }
  }
}

public class Ball extends Projectile
{ 
  Ball(Vector3D position, Vector3D direction, Vector3D massOffset, Vector3D initialAngularVelocity){
    super(ballDefaultStats, position, direction, massOffset, initialAngularVelocity);
  }
}

public class Boulder extends Projectile
{
  Boulder(Vector3D position, Vector3D direction, Vector3D massOffset, Vector3D initialAngularVelocity){
    super(boulderDefaultStats, position, direction, massOffset, initialAngularVelocity);
  }
}

public class Fireball extends Projectile
{ 
  Fireball(Vector3D position, Vector3D direction, Vector3D massOffset, Vector3D initialAngularVelocity){
    super(fireballDefaultStats, position, direction, massOffset, initialAngularVelocity);
  }
}

public class Laser extends Projectile
{
  Laser(Vector3D position, Vector3D direction, Vector3D massOffset, Vector3D initialAngularVelocity){
    super(laserDefaultStats, position, direction, massOffset, initialAngularVelocity);
  }
}
