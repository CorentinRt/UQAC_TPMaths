class Corridor implements IUpdatable
{
    // ----- FIELDS ----- //
    ArrayList<Wall> walls = new ArrayList<Wall>();
    // ----- FIELDS ----- //

    Corridor(float centerX, float floorY, float startZ,
             float width, float height, float length,
             PImage wallTex, PImage floorTex, PImage ceilTex)
    {
        float xl = centerX - width / 2;     // x du mur gauche
        float xr = centerX + width / 2;     // x du mur droit
        float yt = floorY - height;         // y du plafond (y négatif = haut)
        float yb = floorY;                  // y du sol
        float zn = startZ;                  // z de l'entrée
        float zf = startZ - length;         // z du fond

        // Mur gauche
        walls.add(new Wall(new Vector3D(xl, yt, zn), new Vector3D(xl, yt, zf),
                           new Vector3D(xl, yb, zf), new Vector3D(xl, yb, zn),
                           color(90, 60, 50), wallTex));

        // Mur droit
        walls.add(new Wall(new Vector3D(xr, yt, zn), new Vector3D(xr, yt, zf),
                           new Vector3D(xr, yb, zf), new Vector3D(xr, yb, zn),
                           color(90, 60, 50), wallTex));

        // Sol
        walls.add(new Wall(new Vector3D(xl, yb, zn), new Vector3D(xl, yb, zf),
                           new Vector3D(xr, yb, zf), new Vector3D(xr, yb, zn),
                           color(60), floorTex));
                           
        // Plafond
        walls.add(new Wall(new Vector3D(xl, yt, zn), new Vector3D(xl, yt, zf),
                           new Vector3D(xr, yt, zf), new Vector3D(xr, yt, zn),
                           color(40), ceilTex));
                           
        // Fond
        walls.add(new Wall(new Vector3D(xl, yt, zf), new Vector3D(xr, yt, zf),
                           new Vector3D(xr, yb, zf), new Vector3D(xl, yb, zf),
                           color(30), wallTex));
    }

    void Update(float deltaTime)
    {
        Draw();
    }

    void Draw()
    {
        noLights();   

        for (Wall w : walls) 
        {
            w.Draw();
        }

        lights();                         
    }
}