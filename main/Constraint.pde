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
    }

    boolean IsValid(){
        return collider1 != null && collider2 != null;
    }

    float GetStretchAmount(){
        return collider1.owner.position.Distance(collider2.owner.position) + (collider1.owner.radius + collider2.owner.radius);
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