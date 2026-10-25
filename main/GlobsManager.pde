class GlobsManager implements IUpdatable
{
    // ----- FIELDS ----- //
    ArrayList<Globs_Global> blobs = new ArrayList<Globs_Global>();
    float splitImpulseForce = 10;
    color newGlobColor = color(0, 0, 0);

    float mergeCooldown = 0; // Evite re-fusion juste apres split

    Globs_Global pendingMergeA = null;
    Globs_Global pendingMergeB = null;
    // ----- FIELDS ----- //

    // ----- IUPDATABLE ----- //
    void Update(float deltaTime)
    {
        // Check merge cooldown
        if (mergeCooldown > 0)
        {
            mergeCooldown -= deltaTime;
            return;
        }

        // Contact envoyé par collision manager -> merge
        if (pendingMergeA != null)
        {
            Merge(pendingMergeA, pendingMergeB);
            pendingMergeA = null;
            pendingMergeB = null;
        }
    }
    // ----- IUPDATABLE ----- //

    void Add(Globs_Global b)
    { 
        blobs.add(b); 
    }

    void GetNewRandomGlobColor()
    {
        newGlobColor = color(random(0, 255), random(0, 255), random(0, 255));
    }

    // ----- SPLIT ----- //
    void Split(Globs_Global blob)
    {
        print("Split global glob");

        if (blob.motherGlob == null || blob.GetTotalOfGlobInGlobal() < 2) // 4 minimum pour avoir 2 globs de 2 avec mother gauche/droite
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
        
        if (new_b.size() < 1 || origin_b.size() < 1) 
            return;

        // Detacher le nouveau blob du blob d'origine
        for (Glob_Single g : new_b)
        {
            blob.RemoveGlobFromGlobal(g);
        }

        // Créer nouveau blob et on détruit sa glob mère
        Globs_Global nb = new Globs_Global(center, 1);
        nb.motherGlob.DestroyParticle();
        nb.allGlobsInGlobal.clear();

        // On update la couleur du nouveau blob pas controlé par le joueur
        GetNewRandomGlobColor();
        nb.SetGlobColor(newGlobColor);

        // On remplace sa blob mère par le 1er de la liste + on met les autres aussi dedans (+ couleur)
        nb.motherGlob = new_b.get(0);
        nb.motherGlob.SetDrawColors(newGlobColor, newGlobColor);
        nb.allGlobsInGlobal.add(nb.motherGlob);

        if (new_b.size() > 1)
        {
            for (int i = 1; i < new_b.size(); i++)
            {
                new_b.get(i).SetDrawColors(newGlobColor, newGlobColor);
                nb.AddGlobToGlobal(new_b.get(i), nb.motherGlob);
            }
        }
        
        // On ajoute le nouveau blob a la liste avec tous
        blobs.add(nb);

        // Impulsion vers gauche ou droite pour les écarter
        for (Glob_Single g : origin_b)
        {
            g.linearVelocity = g.linearVelocity.Add(new Vector3D(g.position.x < center.x ? -splitImpulseForce : splitImpulseForce, 0, 0));
        }
        for (Glob_Single g : new_b)
        {
            g.linearVelocity = g.linearVelocity.Add(new Vector3D(g.position.x < center.x ? -splitImpulseForce : splitImpulseForce, 0, 0));
        }

        mergeCooldown = 1.0f; // Pas re-fusionner direct
    }
    // ----- SPLIT ----- //

    // ----- MERGE ----- //
    void Merge(Globs_Global A, Globs_Global B) // B va dans A
    {
        println("Merge globs");

        // On enlève B de la liste globale vu qu'il va être mis dans A
        blobs.remove(B);

        // Copie de B
        ArrayList<Glob_Single> globsToMoveToA = new ArrayList<Glob_Single>(B.allGlobsInGlobal);

        // On détache chaque glob de B
        for (Glob_Single g : globsToMoveToA)
        {
            B.RemoveGlobFromGlobal(g);
        }

        // Reset B 
        B.motherGlob = null;
        B.UnregisterFromManagers();

        // On rattache ceux de B à A
        for (Glob_Single g : globsToMoveToA)
        {
            g.SetDrawColors(A.globColor, A.globColor);
            A.AddGlobToGlobal(g, Nearest(A, g)); // accroché au + proche pour que ce soit + smooth sans tp si au dessus de length par rapport à la mere
        }
    }

    void OnParticlesColliding(Particle p1, Particle p2) // Called from collision manager
    {
        // Check cooldown & si pas déjà un merge en cours
        if (mergeCooldown > 0 || pendingMergeA != null)
            return;

        // Check si c'est bien des globs
        if (!(p1 instanceof Glob_Single) || !(p2 instanceof Glob_Single))
            return; 

        Globs_Global a = GetBlobOf((Glob_Single) p1);
        Globs_Global b = GetBlobOf((Glob_Single) p2);

        if (a == null || b == null || a == b)
            return; // deux globs du même blob : on ignore

        // Le blob le plus ancien dans la liste survit (= celui du joueur qui est en 1er)
        if (blobs.indexOf(a) > blobs.indexOf(b))
        {
            Globs_Global tmp = a;
            a = b;
            b = tmp;
        }

        pendingMergeA = a;
        pendingMergeB = b;
    }

    // Get le blob global d'un glob single
    Globs_Global GetBlobOf(Glob_Single glob)
    {
        for (Globs_Global blob : blobs)
        {
            if (blob.IsGlobInGlobal(glob))
                return blob;
        }
            
        return null;
    }

    // Get nearest glob in global
    Glob_Single Nearest(Globs_Global blob, Glob_Single from) 
    {
        Glob_Single best = null;
        float bestD = Float.MAX_VALUE;

        for (Glob_Single g : blob.allGlobsInGlobal)
        {
            float d = g.position.Distance(from.position);
            if (d < bestD)
            {
                bestD = d;
                best = g;
            }
        }

        return best;
    }
    // ----- MERGE ----- //
}