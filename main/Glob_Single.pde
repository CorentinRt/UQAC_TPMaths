class Glob_Single extends Particle
{
    ArrayList<Spring> associatedSprings = new ArrayList<Spring>();
    ArrayList<Constraint> associatedConstraints = new ArrayList<Constraint>();

    Glob_Single(){
        super(2f, new Vector3D(0, 0, 0), new Vector3D(0, 0, 0), 0.5f, 0.3f, 0.7f);
    }

    Glob_Single(Vector3D position){
        super(2f, position, new Vector3D(0, 0, 0), 0.5f, 0.3f, 0.7f);
    }
}