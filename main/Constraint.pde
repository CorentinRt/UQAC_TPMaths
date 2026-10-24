class Constraint {
    SphereCollider collider1;
    SphereCollider collider2;
    ConstraintType constraintType;
    float length = 0;

    Constraint(SphereCollider collider1, SphereCollider collider2, float length, ConstraintType constraintType) {
        this.collider1 = collider1;
        this.collider2 = collider2;
        this.length = length;
        this.constraintType = constraintType;

        RegisterToManagers();
    }

    void RegisterToManagers(){
        if (collisionManager != null){
            collisionManager.AddConstraint(cableConstraint);
        }


    }

    void UnregisterFromManagers(){
        if (collisionManager != null){
            collisionManager.RemoveConstraint(cableConstraint);
        }
    }

    void DestroyConstraint(){

        UnregisterFromManagers();
    }

    boolean IsValid(){
        return collider1 != null && collider2 != null;
    }

    float GetStretchAmount(){
        return collider1.owner.position.Distance(collider2.owner.position);
    }

    Vector3D GetCollisionNormal(){
        return collider2.owner.position.Substract(collider1.owner.position).Normalize();
    }

}

enum ConstraintType
{
    CABLE,
    ROD
}