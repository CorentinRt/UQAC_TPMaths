class RigidBody
{
    Quaternion rotation = new Quaternion();
    Matrix3x3 rotationMatrix = new Matrix3x3();
    Particle massCenter;
    Vector3D angularVelocity = new Vector3D();
    float radius = 20;

    RigidBody(float mass, Vector3D position){
        massCenter = new Particle(mass, position);
        massCenter.radius = radius/5;
    }

    RigidBody(float mass, Vector3D position, Vector3D linearVelocity){
        this(mass, position);
        massCenter.linearVelocity = linearVelocity;
    }

    RigidBody(float mass, Vector3D position, Vector3D linearVelocity, Quaternion rotation){
        this(mass, position, linearVelocity);
        SetRotation(rotation);
    }

    RigidBody(float mass, Vector3D position, Vector3D linearVelocity, Quaternion rotation, Vector3D angularVelocity){
        this(mass, position, linearVelocity, rotation);
        this.angularVelocity = angularVelocity;
    }
    
    RigidBody(float mass, Vector3D position, Vector3D linearVelocity, Quaternion rotation, Vector3D angularVelocity, float coefCineticFriction, float coefStaticFriction){
        this(mass, position, linearVelocity, rotation, angularVelocity);
        massCenter.coefCineticFriction = coefCineticFriction;
        massCenter.coefStaticFriction = coefStaticFriction;
    }

    void SetRotation(Quaternion newRotation){
        rotation = newRotation;
        rotationMatrix = ComputeRotationMatrix();
    }

    Matrix3x3 ComputeRotationMatrix(){
        float X = rotation.x;
        float Y = rotation.y;
        float Z = rotation.z;
        float W = rotation.w;

        return new Matrix3x3(
            new float[] {
                1 - 2 * (Y * Y + Z + Z), 2 * (X * Y + Z * W ), 2 * (X * Z - X * W),
                2 * (X * Y - Z * W), 1 - 2 * (X * X + Z * Z), 2 * (Y * Z + X * W),
                2 * (X * Z + Y * W), 2 * (Y * Z - X * W), 1 - 2 * (X * X + Y * Y)
            });
    }

    void Draw(color c, float radius){
        pushMatrix();
        noStroke();
        fill(c);
        translate(position.x * pixelsPerMeter, position.y * pixelsPerMeter, position.z * pixelsPerMeter);
        sphere(radius * pixelsPerMeter);
        popMatrix(); //Reset translation for futur Draws

        massCenter.Draw();
    }
}