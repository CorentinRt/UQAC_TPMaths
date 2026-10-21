class SphereCollider {
    float radius;
    Vector3D position = new Vector3D(0, 0, 0);
    Particle owner;

    SphereCollider(Particle owner, float radius){
        this.radius = radius;
        this.owner = owner;
        collisionManager.AddCollider(this);
    }

    SphereCollider(Particle owner, float radius, Vector3D position){
        this.radius = radius;
        this.position = position;
        this.owner = owner;
        collisionManager.AddCollider(this);
    }

    public void finalize(){
        collisionManager.RemoveCollider(this);
    }

    void SetRadius(float radius){
        this.radius = radius;
    }

    void UpdatePosition(Vector3D position){
        this.position = position;
    }
}