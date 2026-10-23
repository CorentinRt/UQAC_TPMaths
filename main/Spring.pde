class Spring
{
    float length;
    float elasticity;
    float cDamping;
    boolean isBungee = false;

    Spring(float length, float elasticity, float cDamping, boolean isBungee){
        this.length = length;
        this.elasticity = elasticity;
        this.cDamping = cDamping;
        this.isBungee = isBungee;
    }

    void ApplySpringForces(){

    }

    void SetBungee(boolean isBungee){
        this.isBungee = isBungee;
    }
}