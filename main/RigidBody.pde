class RigidBody implements IPhysicsEntity, IUpdatable
{
    Quaternion rotation = new Quaternion();
    Matrix3x3 rotationMatrix = new Matrix3x3();
    Particle massCenter;
    Vector3D angularVelocity = new Vector3D();
    float radius = 20;

    RigidBody(float mass, Vector3D position){
        massCenter = new Particle(mass, position);
        massCenter.radius = radius/5;
        RegisterToManagers();
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

    void RegisterToManagers(){
        physicsEngine.Register(this);
        updateManager.Register(this);
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

    void Draw(color c){
        pushMatrix();
        stroke(4);
        noFill();
        color(c);
        Vector3D angles = rotation.EulerAngles();
        rotateX(radians(angles.x));
        rotateY(radians(angles.y));
        rotateZ(radians(angles.z));
        translate(massCenter.position.x * pixelsPerMeter, massCenter.position.y * pixelsPerMeter, massCenter.position.z * pixelsPerMeter);
        sphere(radius * pixelsPerMeter);
        popMatrix(); //Reset translation for futur Draws
    }

    Vector3D ComputeAngularAcceleration(){
        return new Vector3D(1, 1, 1);
    }

    void Update(float deltaTime){
        Draw(color(255, 0, 0));
    }

    void UpdatePhysics(float deltaTime){
        //angularVelocity = angularVelocity.Add(ComputeAngularAcceleration().MultiplyByScalar(deltaTime));

        Quaternion wQuaternion = new Quaternion(0, angularVelocity.x, angularVelocity.y, angularVelocity.z);

        SetRotation(rotation.Add(rotation.MultiplyByQ(wQuaternion).MultiplyByF(deltaTime * 0.5)));

        println("Quaternion : (x: " + rotation.x + "y: " + rotation.y + "z: " + rotation.z + "w: " + rotation.w + ")");
        println(rotation.EulerAngles().GetText());
        println(rotationMatrix.GetText());
    }

    void AddForce(Vector3D force){
        massCenter.AddForce(force);
    }

    void ClearAccum(){
        massCenter.ClearAccum();
    }

    void AddPosition(Vector3D position){
        massCenter.AddPosition(position);
    }

    Vector3D GetLinearVelocity(){
        return massCenter.GetLinearVelocity();
    }

    float GetMass(){
        return massCenter.GetMass();
    }
}