class Glob_Single extends Particle
{
    ArrayList<Spring> associatedSprings = new ArrayList<Spring>();
    ArrayList<Constraint> associatedConstraints = new ArrayList<Constraint>();

    Glob_Single(){
        //Mass, Position, Velocity, StaticCoef, CineticCoef, Radius
        super(4f, new Vector3D(0, 0, 0), new Vector3D(0, 0, 0), 0.7f, 0.5f, 0.7f);
    }

    Glob_Single(Vector3D position){
        super(4f, position, new Vector3D(0, 0, 0), 0.7f, 0.5f, 0.7f);
    }
}