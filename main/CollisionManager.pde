class CollisionManager implements IUpdatable{
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

                float distance = dist(colliderA.position.x, colliderA.position.y, colliderA.position.z,
                                      colliderB.position.x, colliderB.position.y, colliderB.position.z);

                if(distance <= (colliderA.radius + colliderB.radius)){

                    // Handle collision

                    Vector3D velocityA = colliderA.owner.GetLinearVelocity();
                    Vector3D velocityB = colliderB.owner.GetLinearVelocity();

                    if (!velocityA.IsEqualWith(new Vector3D(0,0,0)) && !velocityB.IsEqualWith(new Vector3D(0,0,0))) {
                                                
                        Vector3D relativeVelocity = velocityA.Substract(velocityB);
                        Vector3D collisionNormal = colliderB.position.Substract(colliderA.position).Normalize();
                        
                        float d = abs((colliderA.radius + colliderB.radius) - distance);
                        float massA = colliderA.owner.GetMass();
                        float massB = colliderB.owner.GetMass();
                        if (massA == 0 && massB == 0) {
                            continue;
                        }
                        Vector3D deplacementPA = collisionNormal.MultiplyByScalar((massB * d)/(massA + massB));
                        Vector3D deplacementPB = collisionNormal.MultiplyByScalar((-massA * d)/(massA + massB));

                        colliderA.owner.AddPosition(deplacementPA);
                        colliderB.owner.AddPosition(deplacementPB);

                        float magnitude = collisionNormal.ScalarProduct(relativeVelocity);
                        Vector3D impulseA = collisionNormal.MultiplyByScalar(magnitude);
                        ParticleImpulse impulseGeneratorA = new ParticleImpulse(impulseA);
                        ParticleImpulse impulseGeneratorB = new ParticleImpulse(impulseA.MultiplyByScalar(-1));
                              

                        //Check Object Stationary
                        Vector3D gravityDeltaTime = gravity.MultiplyByScalar(deltaTime);
                        if (gravityDeltaTime.Norm() > velocityA.Norm()){
                            //Object A is stationary, apply impulse to B
                            particleForceRegistry.Add(colliderB.owner, impulseGeneratorB);
                            return;
                        }
                        if (gravityDeltaTime.Norm() > velocityB.Norm()){
                            //Object B is stationary, apply impulse to A
                            particleForceRegistry.Add(colliderA.owner, impulseGeneratorA);
                            return;
                        }

                        particleForceRegistry.Add(colliderA.owner, impulseGeneratorA);
                        particleForceRegistry.Add(colliderB.owner, impulseGeneratorB);
                    }   
                    
                }
            }
        }
    }
}