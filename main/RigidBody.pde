class RigidBody extends Particle
{
    Quaternion rotation = new Quaternion();
    Matrix3x3 rotationMatrix = new Matrix3x3();
    Vector3D angularVelocity = new Vector3D();
    
    float width = 0f;
    float height = 0f;
    float depth = 0f;

    RigidBody(float mass, Vector3D position){
        super(mass, position);
        this.radius = width/5;
    }

    RigidBody(float mass, Vector3D position, Vector3D linearVelocity){
        super(mass, position, linearVelocity);
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
        this.coefCineticFriction = coefCineticFriction;
        this.coefStaticFriction = coefStaticFriction;
    }

    void SetBox(float width, float height, float depth){

        this.width = width;
        this.height = height;
        this.depth = depth;
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
                1 - 2 * (Y * Y + Z * Z), 2 * (X * Y + Z * W ), 2 * (X * Z - X * W),
                2 * (X * Y - Z * W), 1 - 2 * (X * X + Z * Z), 2 * (Y * Z + X * W),
                2 * (X * Z + Y * W), 2 * (Y * Z - X * W), 1 - 2 * (X * X + Y * Y)
            });
    }

    void Draw(color c){
        /*
        pushMatrix();
        stroke(4);
        noFill();
        color(c);
        translate(massCenter.position.x * pixelsPerMeter, massCenter.position.y * pixelsPerMeter, massCenter.position.z * pixelsPerMeter);
        Vector3D angles = rotation.EulerAngles();
        rotateX(radians(angles.x));
        rotateY(radians(angles.y));
        rotateZ(radians(angles.z));
        sphere(radius * pixelsPerMeter);
        popMatrix(); //Reset translation for futur Draws
        */
        pushMatrix();
        stroke(4);
        noFill();
        translate(
            position.x * pixelsPerMeter,
            position.y * pixelsPerMeter,
            position.z * pixelsPerMeter
        );

        float angle = 2 * acos(constrain(rotation.w, -1, 1));
        float s = sqrt(1 - rotation.w * rotation.w);
        if (s > 0.0001) rotate(angle, rotation.x / s, rotation.y / s, rotation.z / s);

        box(width * pixelsPerMeter, height * pixelsPerMeter, depth * pixelsPerMeter);
        popMatrix();
    }

    Vector3D ComputeAngularAcceleration(){

        Matrix3x3 inertiaTensor = ComputeInertiaTensor();

        println(inertiaTensor.GetText());
        
        Matrix3x3 invertInertiaTensor = Matrix3x3.Invert(inertiaTensor);

        Vector3D acceleration = Vector3D.MultiplyByMatrix(invertInertiaTensor, ComputeTorque());

        println("Test : " + acceleration.GetText());

        return acceleration;
    }

    Vector3D ComputeTorque(){

        return new Vector3D(1000f, 1000f, 10f);
    }

    void Update(float deltaTime){
        Draw(color(255, 0, 0));
    }

    void UpdatePhysics(float deltaTime){
        super.UpdatePhysics(deltaTime);
        
        angularVelocity = angularVelocity.Add(ComputeAngularAcceleration().MultiplyByScalar(deltaTime));

        Quaternion wQuaternion = new Quaternion(0, angularVelocity.x, angularVelocity.y, angularVelocity.z);

        Quaternion qw = rotation.MultiplyByQ(wQuaternion).MultiplyByF(deltaTime * 0.5);
        SetRotation(rotation.Add(qw).Normalize());

        //println("Quaternion : (x: " + rotation.x + "y: " + rotation.y + "z: " + rotation.z + "w: " + rotation.w + ")");
        //println(rotation.EulerAngles().GetText());
        //println(rotationMatrix.GetText());
    }

    Matrix3x3 ComputeInertiaTensor(){
        Matrix3x3 result = ComputeInertiaTensorPrimitive();

        // TODO : Apply on offset mass center

        return result;
    }

    Matrix3x3 ComputeInertiaTensorPrimitive(){
        Matrix3x3 result = new Matrix3x3();

        float inertiaMultiplier = (1f/12f) * mass * (width * width + depth * depth);

        result.MultiplyByScalar(inertiaMultiplier);

        return result;
    }
}