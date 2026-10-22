class SphereCollider {
    float radius;
    Particle owner;

    SphereCollider(Particle owner, float radius){
        this.radius = radius;
        this.owner = owner;
        collisionManager.AddCollider(this);
    }

    public void finalize(){
        collisionManager.RemoveCollider(this);
    }

    void SetRadius(float radius){
        this.radius = radius;
    }
}