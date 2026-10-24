class Globs_Pair{
    Glob_Single firstGlob;
    Glob_Single secondGlob;

    Globs_Pair(Glob_Single first, Glob_Single second){
        this.firstGlob = first;
        this.secondGlob = second;
    }
}

class Globs_Global implements IUpdatable{

    ArrayList<Glob_Single> allGlobsInGlobal = new ArrayList<Glob_Single>();

    Glob_Single motherGlob;

    float restLengthBetweenGlobs = 2f;
    float maxLengthBetweenGlobs = 4f;
    float elasticity = 10f;
    float cDamping = 0.5f;
    boolean isBungee = true;

    color globColor = color(20, 200, 40);

    void SetGlobColor(color newColor)
    {
        globColor = newColor;
        for (Glob_Single g : allGlobsInGlobal)
            g.SetDrawColors(globColor, globColor);
    }

    Map<Spring, Globs_Pair> springsAssociatedGlobs = new HashMap<Spring, Globs_Pair>();
    Map<Constraint, Globs_Pair> constraintsAssociatedGlobs = new HashMap<Constraint, Globs_Pair>();

    Globs_Global(Vector3D motherGlobPosition, int defaultNumGlobInGlobal){
        
        motherGlob = new Glob_Single();
        allGlobsInGlobal.add(motherGlob);
        motherGlob.position = motherGlobPosition;
        motherGlob.SetDrawColors(globColor, globColor);

        for (int i = 1; i < defaultNumGlobInGlobal; ++i){

            float angle = TWO_PI * (i - 1) / max(1, defaultNumGlobInGlobal - 1);
            float x = motherGlob.position.x + restLengthBetweenGlobs * cos(angle);
            float y = motherGlob.position.y + restLengthBetweenGlobs * sin(angle);
            float z = motherGlob.position.z;

            Glob_Single globToAdd = new Glob_Single(new Vector3D(x, y, z));

            AddGlobToGlobal(globToAdd, motherGlob);

            globToAdd.SetDrawColors(globColor, globColor);
        }
    }

    void DestroyGlobsGlobal(){
        UnregisterFromManagers();

        for (int i = 0; i < allGlobsInGlobal.size(); ++i){
            Glob_Single glob = allGlobsInGlobal.get(i);

            if (glob == null)
                continue;

            glob.DestroyParticle();
        }

        allGlobsInGlobal.clear();

        for (Map.Entry<Spring, Globs_Pair> entry : springsAssociatedGlobs.entrySet()){
            Spring spring = entry.getKey();

            if (spring != null){
                spring.DestroySpring();
            }
        }

        springsAssociatedGlobs.clear();

        for (Map.Entry<Constraint, Globs_Pair> entry : constraintsAssociatedGlobs.entrySet()){
            Constraint constraint = entry.getKey();

            if (constraint != null){
                constraint.DestroyConstraint();
            }
        }

        constraintsAssociatedGlobs.clear();
    }

    void RegisterToManagers(){

        if (updateManager != null){
                updateManager.Register(this);
        }
    }

    void UnregisterFromManagers(){

        if (updateManager != null){
                updateManager.Unregister(this);
        }
    }

    void SetVelocity(Vector3D velocity){
        if (motherGlob == null)
            return;

        motherGlob.linearVelocity = velocity;
    }

    void Update(float deltaTime){

        
    }

    int GetTotalOfGlobInGlobal(){
        return allGlobsInGlobal.size();
    }

    boolean IsGlobInGlobal(Glob_Single glob){

        if (glob == null)
            return false;

        return allGlobsInGlobal.contains(glob);
    }

    boolean CanAttachGlobs(Glob_Single glob, Glob_Single attachToGlob){
        if (glob == null)
            return false;

        if (attachToGlob == null)
            return false;

        if (IsGlobInGlobal(glob) || !IsGlobInGlobal(attachToGlob))
            return false;

        return true;
    }

    void AddGlobToGlobal(Glob_Single glob, Glob_Single attachToGlob){

        if (glob == null)
            return;

        if (attachToGlob == null)
            return;

        if (!CanAttachGlobs(glob, attachToGlob))
            return;

        // Spring
        SpringTwoParticles springTwoParticles = new SpringTwoParticles(restLengthBetweenGlobs, elasticity, cDamping, isBungee);
        springTwoParticles.RegisterNewParticle(glob);
        springTwoParticles.RegisterNewParticle(attachToGlob);

        glob.associatedSprings.add(springTwoParticles);
        attachToGlob.associatedSprings.add(springTwoParticles);
        
        springsAssociatedGlobs.put(springTwoParticles, new Globs_Pair(glob, attachToGlob));

        // Cable
        Constraint cableConstraint = new Constraint(glob.collider, attachToGlob.collider, maxLengthBetweenGlobs, ConstraintType.CABLE);

        glob.associatedConstraints.add(cableConstraint);
        attachToGlob.associatedConstraints.add(cableConstraint);
        
        constraintsAssociatedGlobs.put(cableConstraint, new Globs_Pair(glob, attachToGlob));


        allGlobsInGlobal.add(glob);
    }

    void RemoveGlobFromGlobal(Glob_Single glob){
        if (glob == null)
            return;

        ArrayList<Spring> springsToDestroy = GetSpringsAssociatedByThisGlob(glob);

        for (int i = 0; i < springsToDestroy.size(); ++i){
            
            Spring spring = springsToDestroy.get(i);
            
            if (spring == null)
            continue;
            
            springsAssociatedGlobs.remove(spring);
            spring.DestroySpring();
        }


        ArrayList<Constraint> constraintsToDestroy = GetConstraintsAssociatedByThisGlob(glob);

        for (int i = 0; i < constraintsToDestroy.size(); ++i){

            Constraint constraint = constraintsToDestroy.get(i);

            if (constraint == null)
                continue;

            constraintsAssociatedGlobs.remove(constraint);
            constraint.DestroyConstraint();
        }

        allGlobsInGlobal.remove(glob);
    }

    ArrayList<Spring> GetSpringsAssociatedByThisGlob(Glob_Single glob){
        ArrayList<Spring> springsAffected = new ArrayList<Spring>();

        for (int i = 0; i < glob.associatedSprings.size(); ++i){

            Spring spring = glob.associatedSprings.get(i);

            if (spring == null)
                continue;

            if (!springsAssociatedGlobs.containsKey(spring)){
                springsAffected.add(spring);
                continue;
            }

            Globs_Pair globsPair = springsAssociatedGlobs.get(spring);

            if (globsPair == null)
            {
                springsAffected.add(spring);
                continue;
            }

            if (globsPair.firstGlob != null && globsPair.secondGlob != null)
                continue;

            springsAffected.add(spring);
        }

        return springsAffected;
    }

    ArrayList<Constraint> GetConstraintsAssociatedByThisGlob(Glob_Single glob){
        ArrayList<Constraint> constraintsAffected = new ArrayList<Constraint>();

        for (int i = 0; i < glob.associatedConstraints.size(); ++i){

            Constraint constraint = glob.associatedConstraints.get(i);

            if (constraint == null)
                continue;

            if (!constraintsAssociatedGlobs.containsKey(constraint)){
                constraintsAffected.add(constraint);
                continue;
            }

            Globs_Pair globsPair = constraintsAssociatedGlobs.get(constraint);

            if (globsPair == null)
            {
                constraintsAffected.add(constraint);
                continue;
            }

            if (globsPair.firstGlob != null && globsPair.secondGlob != null)
                continue;

            constraintsAffected.add(constraint);
        }

        return constraintsAffected;
    }
}