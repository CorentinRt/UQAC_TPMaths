class RigidBody extends Particle
{
    Quaternion rotation = new Quaternion();
    Matrix3x3 rotationMatrix = new Matrix3x3();
    Vector3D angularVelocity = new Vector3D();
    
    Vector3D torqueAccum = new Vector3D();

    float width = 10f;
    float height = 10f;
    float depth = 10f;

    float angularDamping = 0.98f;

    color rigidBodyColor = color(255, 0, 0);
    
    Vector3D massOffset = new Vector3D();

    RigidBody(float mass, Vector3D position){
        super(mass, position);
        RegisterToManagers();
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

    RigidBody(float mass, Vector3D position, Vector3D linearVelocity, Quaternion rotation, Vector3D angularVelocity, Vector3D massOffset){
        this(mass, position, linearVelocity, rotation, angularVelocity);
        this.massOffset = massOffset;
    }
    
    RigidBody(float mass, Vector3D position, Vector3D linearVelocity, Quaternion rotation, Vector3D angularVelocity, Vector3D massOffset, float coefStaticFriction, float coefCineticFriction){
        this(mass, position, linearVelocity, rotation, angularVelocity, massOffset);
        this.coefCineticFriction = coefCineticFriction;
        this.coefStaticFriction = coefStaticFriction;
    }

    void SetBox(float width, float height, float depth){

        this.width = width;
        this.height = height;
        this.depth = depth;

        this.radius = width/10;
    }

    void SetRotation(Quaternion newRotation){
        rotation = newRotation;
        rotationMatrix = ComputeRotationMatrix(rotation);
    }

    Matrix3x3 ComputeRotationMatrix(Quaternion quaternionRotation){
        float X = quaternionRotation.x;
        float Y = quaternionRotation.y;
        float Z = quaternionRotation.z;
        float W = quaternionRotation.w;

        return new Matrix3x3(
            new float[] {
                1 - 2 * (Y * Y + Z * Z), 2 * (X * Y - Z * W ), 2 * (X * Z + Y * W),
                2 * (X * Y + Z * W), 1 - 2 * (X * X + Z * Z), 2 * (Y * Z - X * W),
                2 * (X * Z - Y * W), 2 * (Y * Z + X * W), 1 - 2 * (X * X + Y * Y)
            });
    }

    void Draw(){
        super.Draw();

        this.Draw(position, rotation, rigidBodyColor, true);
    }
    
    void Draw(Vector3D positionToDraw, Quaternion rotationToDraw, color c, boolean fill){

        pushMatrix();
        stroke(4);

        if (fill){
            fill(c);
        }
        else{
            noFill();
        }

        Matrix3x3 currentRotationMatrix = ComputeRotationMatrix(rotationToDraw);

        Vector3D rotatedOffset = Vector3D.MultiplyByMatrix(currentRotationMatrix, massOffset);

        translate((positionToDraw.x - rotatedOffset.x) * pixelsPerMeter,
                (positionToDraw.y - rotatedOffset.y) * pixelsPerMeter,
                (positionToDraw.z - rotatedOffset.z) * pixelsPerMeter);

        float angle = 2 * acos(constrain(rotationToDraw.w, -1, 1));
        float s = sqrt(1 - rotationToDraw.w * rotationToDraw.w);
        if (s > 0.0001) rotate(angle, rotationToDraw.x / s, rotationToDraw.y / s, rotationToDraw.z / s);

        box(width * pixelsPerMeter, height * pixelsPerMeter, depth * pixelsPerMeter);

        popMatrix();
    }

    Vector3D ComputeAngularAcceleration(){

        Matrix3x3 inertiaTensor = ComputeInertiaTensor();

        //println(inertiaTensor.GetText());
        
        Matrix3x3 invertInertiaTensor = Matrix3x3.Invert(inertiaTensor);

        Matrix3x3 R = rotationMatrix;

        Matrix3x3 invIWorld = Matrix3x3.Multiply(R, invertInertiaTensor);
        invIWorld = Matrix3x3.Multiply(invIWorld, Matrix3x3.Transpose(R));

        Vector3D acceleration = Vector3D.MultiplyByMatrix(invertInertiaTensor, torqueAccum);

        //println("Test : " + acceleration.GetText());

        return acceleration;
    }

    Vector3D ComputeTorque(Vector3D forceApplied, Vector3D l){
        torqueAccum = torqueAccum.Add(forceApplied.VectorProduct(l));

        return torqueAccum;
    }

    void Update(float deltaTime){
        Draw();
    }

    void UpdatePhysics(float deltaTime){
        IntegrateAngular(deltaTime);

        super.UpdatePhysics(deltaTime);
    }

    void IntegrateAngular(float deltaTime){
        angularVelocity = angularVelocity.Add(ComputeAngularAcceleration().MultiplyByScalar(deltaTime));

        angularVelocity = angularVelocity.MultiplyByScalar(pow(angularDamping, deltaTime));

        Quaternion wQuaternion = new Quaternion(0, angularVelocity.x, angularVelocity.y, angularVelocity.z);

        Quaternion qw = rotation.MultiplyByQ(wQuaternion).MultiplyByF(deltaTime * 0.5);
        SetRotation(rotation.Add(qw).Normalize());
    }

    void AddForceAtPosition(Vector3D force, Vector3D position){
        // this.position represents axe of rotation, not necessary the mass center (in our case it is)
        Vector3D l = position.Substract(this.position);

        //CurrentForce not Accumulated Force
        ComputeTorque(force, l);

        AddForce(force);
    }

    void ClearAccum(){
        super.ClearAccum();

        torqueAccum = new Vector3D(0, 0, 0);
    }

    Matrix3x3 ComputeInertiaTensor(){
        Matrix3x3 result = ComputeInertiaTensorPrimitive();

        float x = this.position.x;
        float y = this.position.y;
        float z = this.position.z;

        Matrix3x3 translation = new Matrix3x3(new float[] {
            y * y + z * z, -x * y, -x * z,
            -x * y, x * x + z * z, -y * z,
            -x * z, -y * z, x * x + y * y
        });

        translation.MultiplyByScalar(this.mass);

        result.Add(translation);        

        return result;
    }

    Matrix3x3 ComputeInertiaTensorPrimitive(){
        float Ix = (1f/12f) * mass * (height * height + depth * depth);
        float Iy = (1f/12f) * mass * (width * width + depth * depth);
        float Iz = (1f/12f) * mass * (width * width + height * height);

        Matrix3x3 result = new Matrix3x3(new float[] {
            Ix, 0, 0,
            0, Iy, 0,
            0, 0, Iz
        });

        return result;
    }

    boolean CollidesWithSphere(Vector3D center, float sphereRadius)
    {
    Matrix3x3 R = ComputeRotationMatrix(rotation);

    //centre reel de la boîte
    Vector3D rotatedOffset = Vector3D.MultiplyByMatrix(R, massOffset);
    float cx = position.x - rotatedOffset.x;
    float cy = position.y - rotatedOffset.y;
    float cz = position.z - rotatedOffset.z;

    //centre boite
    float dx = center.x - cx;
    float dy = center.y - cy;
    float dz = center.z - cz;

    //axe local to world
    Vector3D ax = Vector3D.MultiplyByMatrix(R, new Vector3D(1, 0, 0));
    Vector3D ay = Vector3D.MultiplyByMatrix(R, new Vector3D(0, 1, 0));
    Vector3D az = Vector3D.MultiplyByMatrix(R, new Vector3D(0, 0, 1));

    //sphere in box
    float lx = dx*ax.x + dy*ax.y + dz*ax.z;
    float ly = dx*ay.x + dy*ay.y + dz*ay.z;
    float lz = dx*az.x + dy*az.y + dz*az.z;

    //point de la boite + proche de la sphere
    float px = constrain(lx, -width  / 2, width  / 2);
    float py = constrain(ly, -height / 2, height / 2);
    float pz = constrain(lz, -depth  / 2, depth  / 2);

    float ex = lx - px;
    float ey = ly - py;
    float ez = lz - pz;

    return ex*ex + ey*ey + ez*ez <= sphereRadius * sphereRadius;
    }
}