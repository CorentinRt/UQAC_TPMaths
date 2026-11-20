class Corridor implements IUpdatable
{
    // ----- FIELDS ----- //
    ArrayList<Wall> walls = new ArrayList<Wall>();

    ArrayList<PImage> availablePosterTextures = new ArrayList<PImage>();
    ArrayList<Poster> placedPosters = new ArrayList<Poster>();

    float leftWallX;       
    float rightWallX;     

    float ceilingY;        
    float floorLevelY;   

    float entranceZ;       
    float endZ;       
    
    float nextFreeZLeft; // prochain Z libre sur le mur gauche (poster)
    float nextFreeZRight; // prochain Z libre sur le mur droit (poster)

    float corridorLength;
    // ----- FIELDS ----- //

    Corridor(float centerX, float floorY, float startZ,
             float corridorWidth, float corridorHeight, float corridorLength,
             PImage wallTexture, PImage floorTexture, PImage ceilingTexture)
    {
        leftWallX = centerX - corridorWidth / 2;
        rightWallX = centerX + corridorWidth / 2;
        ceilingY = floorY - corridorHeight;
        floorLevelY = floorY;
        entranceZ = startZ;
        endZ = startZ - corridorLength;

        this.corridorLength = corridorLength;

        // Mur gauche
        walls.add(new Wall(new Vector3D(leftWallX, ceilingY, entranceZ), new Vector3D(leftWallX, ceilingY, endZ),
                           new Vector3D(leftWallX, floorLevelY, endZ), new Vector3D(leftWallX, floorLevelY, entranceZ),
                           color(90, 60, 50), wallTexture));

        // Mur droit
        walls.add(new Wall(new Vector3D(rightWallX, ceilingY, entranceZ), new Vector3D(rightWallX, ceilingY, endZ),
                           new Vector3D(rightWallX, floorLevelY, endZ), new Vector3D(rightWallX, floorLevelY, entranceZ),
                           color(90, 60, 50), wallTexture));

        // Sol
        walls.add(new Wall(new Vector3D(leftWallX, floorLevelY, entranceZ), new Vector3D(leftWallX, floorLevelY, endZ),
                           new Vector3D(rightWallX, floorLevelY, endZ), new Vector3D(rightWallX, floorLevelY, entranceZ),
                           color(60), floorTexture));

        // Plafond
        walls.add(new Wall(new Vector3D(leftWallX, ceilingY, entranceZ), new Vector3D(leftWallX, ceilingY, endZ),
                           new Vector3D(rightWallX, ceilingY, endZ), new Vector3D(rightWallX, ceilingY, entranceZ),
                           color(40), ceilingTexture));

        // Fond
        walls.add(new Wall(new Vector3D(leftWallX, ceilingY, endZ), new Vector3D(rightWallX, ceilingY, endZ),
                           new Vector3D(rightWallX, floorLevelY, endZ), new Vector3D(leftWallX, floorLevelY, endZ),
                           color(30), wallTexture));

        nextFreeZLeft  = entranceZ - 5;
        nextFreeZRight = entranceZ - 5;
    }

    // ----- Update ----- //
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

        for (Poster poster : placedPosters)
        {
            poster.Draw();
        }

        lights();                         
    }

    // ----- Posters ----- //
    void AddPosterTexture(PImage posterImage)
    {
        if (posterImage != null)
            availablePosterTextures.add(posterImage);
    }

    boolean AddRandomPoster(float posterHeightRatio)
    {
        if (availablePosterTextures.isEmpty())
            return false;

        // Image random
        PImage chosenTexture = availablePosterTextures.get((int) random(availablePosterTextures.size()));
        boolean onLeftWall = random(1) < 0.5f;

        // Taille avec ratio de l'image
        float corridorHeightMeters = floorLevelY - ceilingY;
        float posterHeightMeters = corridorHeightMeters * posterHeightRatio;
        float posterWidthMeters = posterHeightMeters * chosenTexture.width / chosenTexture.height;

        float nearEdgeZ = onLeftWall ? nextFreeZLeft : nextFreeZRight;

        // Écart aléatoire avant le poster 
        nearEdgeZ -= random(2, 10);

        if (nearEdgeZ - posterWidthMeters < endZ) // plus de place
            return false;

        // Position
        float posterX = onLeftWall ? leftWallX + 0.2f : rightWallX - 0.2f;
        float posterCenterY = random(ceilingY + posterHeightMeters / 2, floorLevelY - posterHeightMeters / 2);

        placedPosters.add(new Poster(chosenTexture, posterX, posterCenterY, nearEdgeZ,
                                    posterWidthMeters, posterHeightMeters, onLeftWall));

        // On avance pour le prochain poster sur le mur
        if (onLeftWall) 
            nextFreeZLeft  = nearEdgeZ - posterWidthMeters;
        else            
            nextFreeZRight = nearEdgeZ - posterWidthMeters;

        return true;
    }

    // Random point pour les targets
    Vector3D GetRandomPointInside(float margin, float minDepthRatio, float maxDepthRatio)
    {
        float x = random(leftWallX + margin, rightWallX - margin);
        float y = random(ceilingY + margin, floorLevelY - margin);

        float depth = random(minDepthRatio, maxDepthRatio) * corridorLength;
        float z = entranceZ - depth;

        return new Vector3D(x, y, z);
    }
}