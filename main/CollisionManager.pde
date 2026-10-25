class CollisionManager implements IUpdatable{

    float coefRestitution = 0.5;

    ArrayList<SphereCollider> particles = new ArrayList<SphereCollider>();

    ArrayList<Constraint> constraints = new ArrayList<Constraint>();

    void AddCollider(SphereCollider collider){
        particles.add(collider);
    }

    void RemoveCollider(SphereCollider collider){
        particles.remove(collider);
    }

    void AddConstraint(Constraint constraint){
        constraints.add(constraint);
    }

    void RemoveConstraint(Constraint constraint){
        constraints.remove(constraint);
    }

    void Update(float deltaTime){
        for(int i = 0; i < particles.size(); i++){
            for(int j = i + 1; j < particles.size(); j++){
                SphereCollider colliderA = particles.get(i);
                SphereCollider colliderB = particles.get(j);

                if (colliderA == null || colliderB == null)
                    continue;

                if(!IsColliding(colliderA, colliderB))
                    continue;

                // Merge blobs
                if (globsManager != null)
                    globsManager.OnParticlesColliding(colliderA.owner, colliderB.owner);

                Vector3D velocityA = colliderA.owner.GetLinearVelocity();
                Vector3D velocityB = colliderB.owner.GetLinearVelocity();
                Vector3D relativeVelocity = velocityA.Substract(velocityB);
                
                Vector3D collisionNormal = (colliderB.owner.position.Substract(colliderA.owner.position)).Normalize();

                CorrectCollidingPosition(colliderA, colliderB, collisionNormal);
                    
                collisionNormal = (colliderB.owner.position.Substract(colliderA.owner.position)).Normalize();

                ApplyCollisionImpulse(colliderA, colliderB, velocityA, velocityB, relativeVelocity, collisionNormal, deltaTime);

                colliderA.owner.contactNormal = collisionNormal.MultiplyByScalar(-1);
                colliderB.owner.contactNormal = collisionNormal;
            }
        }

        SolveConstraints(deltaTime);
    }

    void SolveConstraints(float deltaTime)
    {
        for(int i = 0; i < constraints.size(); i++)
        {
            Constraint constraint = constraints.get(i);
            if (constraint == null) continue;
            if (!constraint.IsValid()) continue;

            float stretchAmount = constraint.GetStretchAmount();

            switch (constraint.constraintType)
            {
                case ROD:
                    if (abs(stretchAmount - constraint.length) > 0){
                        Vector3D collisionNormal = constraint.GetCollisionNormal();

                        CorrectConstraintPosition(constraint.collider1, constraint.collider2, collisionNormal, constraint.length);
                    }

                    break;
                case CABLE:
                    if (stretchAmount - constraint.length > 0){
                        Vector3D collisionNormal = constraint.GetCollisionNormal();

                        CorrectConstraintPosition(constraint.collider1, constraint.collider2, collisionNormal, constraint.length);
                        
                        Vector3D velocity1 = constraint.collider1.owner.GetLinearVelocity();
                        Vector3D velocity2 = constraint.collider2.owner.GetLinearVelocity();
                        Vector3D relativeVelocity = velocity1.Substract(velocity2);

                        ApplyCollisionImpulse(constraint.collider1, constraint.collider2, constraint.collider1.owner.GetLinearVelocity(), constraint.collider2.owner.GetLinearVelocity(), relativeVelocity, collisionNormal, deltaTime);
                    }
                    break;
                default:
                    break;
            }
        }
    }


    boolean IsColliding(SphereCollider collA, SphereCollider collB){

        float distance = collA.owner.position.Distance(collB.owner.position);

        if (collA.owner.InverseMass() == 0 && collB.owner.InverseMass() == 0)
            return false;
            
        if(distance > (collA.owner.radius + collB.owner.radius))
            return false;

        return true;
    }

    void CorrectCollidingPosition(SphereCollider collA, SphereCollider collB, Vector3D collisionNormal){

        float distance = collA.owner.position.Distance(collB.owner.position);

        float d = distance - (collA.owner.radius + collB.owner.radius);
        float massA = collA.owner.GetMass();
        float massB = collB.owner.GetMass();

        if (massA == 0 && massB == 0)
            return;

        if (massA == INFINITE_MASS && massB == INFINITE_MASS)
            return;

        Vector3D deplacementPA = collisionNormal.MultiplyByScalar((massB * d)/(massA + massB));
        Vector3D deplacementPB = collisionNormal.MultiplyByScalar((-massA * d)/(massA + massB));

        collA.owner.AddPosition(deplacementPA);
        collB.owner.AddPosition(deplacementPB);
    }

    void CorrectConstraintPosition(SphereCollider collA, SphereCollider collB, Vector3D collisionNormal, float constraintLength){
        float distance = collA.owner.position.Distance(collB.owner.position);

        float d = (distance - constraintLength);
        float massA = collA.owner.GetMass();
        float massB = collB.owner.GetMass();

        if (massA == 0 && massB == 0)
            return;

        if (massA == INFINITE_MASS && massB == INFINITE_MASS)
            return;

        Vector3D deplacementPA = collisionNormal.MultiplyByScalar((massB * d)/(massA + massB));
        Vector3D deplacementPB = collisionNormal.MultiplyByScalar((-massA * d)/(massA + massB));

        collA.owner.AddPosition(deplacementPA);
        collB.owner.AddPosition(deplacementPB);
    }

    void ApplyCollisionImpulse(SphereCollider collA, SphereCollider collB, Vector3D velocityA, Vector3D velocityB, Vector3D relativeVelocity, Vector3D collisionNormal, float deltaTime){

        float velAlongNormal = relativeVelocity.ScalarProduct(collisionNormal);

        if (velAlongNormal <= 0)
            return;

        float massA = collA.owner.GetMass();
        float massB = collB.owner.GetMass();

        if (massA == 0 && massB == 0)
            return;

        float magnitude = ComputeMagnitudeImpulsion(collA.owner.InverseMass(), collB.owner.InverseMass(), relativeVelocity, collisionNormal, coefRestitution);
        
        if (magnitude == 0)
            return;

        Vector3D impulsion = collisionNormal.MultiplyByScalar(magnitude).MultiplyByScalar(1);
        Vector3D impulsionA = impulsion.MultiplyByScalar(collA.owner.InverseMass());
        Vector3D impulsionB = impulsion.MultiplyByScalar(collB.owner.InverseMass());

        Vector3D newVelocityA = velocityA.Substract(impulsionA);
        Vector3D newVelocityB = velocityB.Add(impulsionB);

        //Check Object Stationary
        Vector3D gravityDeltaTime = gravity.MultiplyByScalar(deltaTime);

        collA.owner.isResting = false;
        collB.owner.isResting = false;

        if (gravityDeltaTime.Norm() > velocityA.Norm()){
            //Object A is stationary, apply impulse to B
            collA.owner.isResting = true;
            collB.owner.linearVelocity = newVelocityB;
            return;
        }
        if (gravityDeltaTime.Norm() > velocityB.Norm()){
            //Object B is stationary, apply impulse to A
            collB.owner.isResting = true;
            collA.owner.linearVelocity = newVelocityA;
            return;
        }

        collA.owner.linearVelocity = newVelocityA;
        collB.owner.linearVelocity = newVelocityB;
    }

    float ComputeMagnitudeImpulsion(float InverseMassA, float InverseMassB, Vector3D relativeVelocity, Vector3D collisionNormal, float coefRestitution){

        float magnitudeNumerator = relativeVelocity.ScalarProduct(collisionNormal);
        magnitudeNumerator = magnitudeNumerator * (coefRestitution + 1f);

        float magnitudeDenominator = (collisionNormal.ScalarProduct(collisionNormal)) * (InverseMassA + InverseMassB);

        if (magnitudeDenominator == 0)
            return 0;

        float magnitude = magnitudeNumerator / magnitudeDenominator;

        return magnitude;
    }

}