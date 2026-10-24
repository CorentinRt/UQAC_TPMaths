class SpringsRegistry{

    ArrayList<Spring> allSprings = new ArrayList<Spring>();

    void RegisterSpring(Spring spring){

        if (spring == null)
            return;

        allSprings.add(spring);
    }

    void UnregisterSpring(Spring spring){

        if (spring == null)
            return;

        allSprings.remove(spring);
    }

    void ApplyAllSpringsForces(){
        for (int i = 0; i < allSprings.size(); ++i){

            Spring spring = allSprings.get(i);

            if (spring == null)
                continue;
            
            spring.ApplySpringForces();
        }
    }

}