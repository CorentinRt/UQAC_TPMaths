class CollisionManager implements IUpdatable{

    float coefRestitution = 0.5;

    ArrayList<SphereCollider> particles = new ArrayList<SphereCollider>();

    void AddCollider(SphereCollider collider){
        particles.add(collider);
    }

    void RemoveCollider(SphereCollider collider){
        particles.remove(collider);
    }

    void Update(float deltaTime){
        for(int i = 0; i < particles.size(); i++){
            for(int j = i + 1; j < particles.size(); j++){
                SphereCollider colliderA = particles.get(i);
                SphereCollider colliderB = particles.get(j);

                if (colliderA == null || colliderB == null) {
                    continue;
                }

                float distance = colliderA.owner.position.Distance(colliderB.owner.position);
                

                if(distance <= (colliderA.radius + colliderB.radius)){

                    // Handle collision

                    Vector3D velocityA = colliderA.owner.GetLinearVelocity();
                    Vector3D velocityB = colliderB.owner.GetLinearVelocity();

                    if (!velocityA.IsEqualWith(new Vector3D(0,0,0)) || !velocityB.IsEqualWith(new Vector3D(0,0,0))) {
                                                
                        Vector3D relativeVelocity = velocityA.Substract(velocityB);
                        Vector3D collisionNormal = (colliderB.owner.position.Substract(colliderA.owner.position)).Normalize();
                        
                        float velAlongNormal = relativeVelocity.ScalarProduct(collisionNormal);

                        if (velAlongNormal <= 0)
                            continue;

                        float d = abs((colliderA.radius + colliderB.radius) - distance);
                        float massA = colliderA.owner.GetMass();
                        float massB = colliderB.owner.GetMass();
                        if (massA == 0 && massB == 0) {
                            continue;
                        }
                        Vector3D deplacementPA = collisionNormal.MultiplyByScalar((massA * d)/(massA + massB));
                        Vector3D deplacementPB = collisionNormal.MultiplyByScalar((-massB * d)/(massA + massB));

                        colliderA.owner.AddPosition(deplacementPA);
                        colliderB.owner.AddPosition(deplacementPB);

                        float magnitudeNumerator = relativeVelocity.ScalarProduct(collisionNormal);
                        magnitudeNumerator = magnitudeNumerator * (coefRestitution + 1f);

                        float magnitudeDenominator = (collisionNormal.ScalarProduct(collisionNormal)) * (colliderA.owner.InverseMass() + colliderB.owner.InverseMass());

                        if (magnitudeDenominator == 0)
                            continue;

                        float magnitude = magnitudeNumerator / magnitudeDenominator;

                        Vector3D impulsion = collisionNormal.MultiplyByScalar(magnitude).MultiplyByScalar(1);
                        Vector3D impulsionA = impulsion.MultiplyByScalar(colliderA.owner.InverseMass());
                        Vector3D impulsionB = impulsion.MultiplyByScalar(colliderB.owner.InverseMass());

                        Vector3D newVelocityA = velocityA.Substract(impulsionA);
                        Vector3D newVelocityB = velocityB.Add(impulsionB);

                        //Check Object Stationary
                        Vector3D gravityDeltaTime = gravity.MultiplyByScalar(deltaTime);
                        if (gravityDeltaTime.Norm() > velocityA.Norm()){
                            //Object A is stationary, apply impulse to B
                            colliderB.owner.linearVelocity = newVelocityB;
                            continue;
                        }
                        if (gravityDeltaTime.Norm() > velocityB.Norm()){
                            //Object B is stationary, apply impulse to A
                            colliderA.owner.linearVelocity = newVelocityA;
                            continue;
                        }

                        colliderA.owner.linearVelocity = newVelocityA;
                        colliderB.owner.linearVelocity = newVelocityB;
                    }   
                    
                }
            }
        }
    }
}