class Corridor implements IUpdatable
{
    // ----- FIELDS ----- //
    ArrayList<Wall> walls = new ArrayList<Wall>();
    // ----- FIELDS ----- //

    Corridor(float centerX, float floorY, float startZ, float width, float height, float length, float thickness)
    {
        float midZ = startZ - length / 2;         
        float midY = floorY - height / 2;

        // Mur gauche
        walls.add(new Wall(new Vector3D(centerX - width/2 - thickness/2, midY, midZ), new Vector3D(thickness, height, length), color(90, 60, 50)));

        // Mur droit
        walls.add(new Wall(new Vector3D(centerX + width/2 + thickness/2, midY, midZ), new Vector3D(thickness, height, length), color(90, 60, 50)));

        // Sol
        walls.add(new Wall(new Vector3D(centerX, floorY + thickness/2, midZ), new Vector3D(width + 2*thickness, thickness, length), color(60)));

        // Plafond
        walls.add(new Wall(new Vector3D(centerX, floorY - height - thickness/2, midZ), new Vector3D(width + 2*thickness, thickness, length), color(40)));

        // Fond 
        walls.add(new Wall(new Vector3D(centerX, midY, startZ - length - thickness/2), new Vector3D(width + 2*thickness, height, thickness), color(30)));
    }

    void Update(float deltaTime)
    {
        Draw();
    }

    void Draw()
    {
        for (Wall w : walls) w.Draw();
    }
}