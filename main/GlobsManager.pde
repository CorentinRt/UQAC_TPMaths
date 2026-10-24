class GlobsManager implements IUpdatable
{
    // ----- FIELDS ----- //
    ArrayList<Globs_Global> blobs = new ArrayList<Globs_Global>();
    // ----- FIELDS ----- //

    // ----- IUPDATABLE ----- //
    void Update(float deltaTime)
    {
        // Si contact -> merge
    }
    // ----- IUPDATABLE ----- //

    void Add(Globs_Global b)
    { 
        blobs.add(b); 
    }

    // ----- SPLIT ----- //
    void Split(Globs_Global blob)
    {
        if (blob.motherGlob == null || blob.GetTotalOfGlobInGlobal() < 4) // 4 minimum pour avoir 2 globs de 2 avec mother gauche/droite
            return;

        // Moyenne des positions des glob pour un centre a peu près ok
        Vector3D center = new Vector3D(0, 0, 0);
        for (Glob_Single g : blob.allGlobsInGlobal)
        {
            center = center.Add(g.position);
        }
        center = center.MultiplyByScalar(1.0f / blob.GetTotalOfGlobInGlobal());

        // Check si gauche ou droite du centre pour chaque blob
        ArrayList<Glob_Single> left = new ArrayList<Glob_Single>();
        ArrayList<Glob_Single> right = new ArrayList<Glob_Single>();
        for (Glob_Single g : blob.allGlobsInGlobal)
        {
            if (g.position.x < center.x)
                left.add(g);
            else
                right.add(g);
        }
        
        ArrayList<Glob_Single> new_b = new ArrayList<Glob_Single>(); // nouveau blob
        ArrayList<Glob_Single> origin_b = new ArrayList<Glob_Single>(); // blob d'origine

        // Groupe gauche/droite qui a la mama reste dans le blob d'origine
        if (left.contains(blob.motherGlob))
        {
            new_b = right;
            origin_b = left;
        }
        else
        {
            new_b = left;
            origin_b = right;
        }
        
        if (new_b.size() < 2 || origin_b.size() < 2) 
            return;

        // Detacher le nouveau blob du blob d'origine
        for (Glob_Single g : new_b)
        {
            Detach(blob, g);
            blob.allGlobsInGlobal.remove(g);
        }

        // Créer nouveau blob et on détruit sa glob mère
        Globs_Global nb = new Globs_Global(center, 1);
        nb.motherGlob.DestroyParticle();
        nb.allGlobsInGlobal.clear();

        // On remplace sa blob mère par le 1er de la liste + on met les autres aussi dedans
        nb.motherGlob = new_b.get(0);
        nb.allGlobsInGlobal.add(nb.motherGlob);
        for (int i = 1; i < new_b.size(); i++)
        {
            nb.AddGlobToGlobal(new_b.get(i), nb.motherGlob);
        }

        // On ajoute le nouveau blob a la liste avec tous
        blobs.add(nb);

        // Impulsion vers gauche ou droite pour les écarter
        for (Glob_Single g : origin_b)
        {
            g.linearVelocity = g.linearVelocity.Add(new Vector3D(g.position.x < center.x ? -3 : 3, 0, 0));
        }
         for (Glob_Single g : new_b)
        {
            g.linearVelocity = g.linearVelocity.Add(new Vector3D(g.position.x < center.x ? -3 : 3, 0, 0));
        }
    }

    void Detach(Globs_Global blob, Glob_Single g)
    {
        // to do : detach springs avec les autres globs + pareil pour constraints
    }
    // ----- SPLIT ----- //
}