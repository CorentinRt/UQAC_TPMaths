class Poster
{
    // ----- FIELDS ----- //
    PImage posterTexture;        
    float wallSurfaceX;    

    float centerY;               
    float nearEdgeZ;   

    float widthMeters;           
    float heightMeters;    

    boolean isOnLeftWall;
    // ----- FIELDS ----- //

    Poster(PImage posterTexture, float wallSurfaceX, float centerY, float nearEdgeZ,
           float widthMeters, float heightMeters, boolean isOnLeftWall)
    {
        this.posterTexture = posterTexture;

        this.wallSurfaceX = wallSurfaceX;
        this.centerY = centerY;
        this.nearEdgeZ = nearEdgeZ;

        this.widthMeters = widthMeters;
        this.heightMeters = heightMeters;

        this.isOnLeftWall = isOnLeftWall;
    }

    void Draw()
    {
        // Conversion mètres -> pixels
        float xPixels = wallSurfaceX * pixelsPerMeter;
        float topPixels = (centerY - heightMeters / 2) * pixelsPerMeter;
        float bottomPixels = (centerY + heightMeters / 2) * pixelsPerMeter;
        float nearZPixels = nearEdgeZ * pixelsPerMeter;
        float farZPixels = (nearEdgeZ - widthMeters) * pixelsPerMeter;

        noStroke();
        fill(255);   

        beginShape(QUADS);
        texture(posterTexture);

        if (isOnLeftWall)
        {
            // Mur gauche : le côté gauche de l'image est vers l'entrée
            vertex(xPixels, topPixels, nearZPixels, 0, 0);
            vertex(xPixels, topPixels, farZPixels,  1, 0);
            vertex(xPixels, bottomPixels, farZPixels,  1, 1);
            vertex(xPixels, bottomPixels, nearZPixels, 0, 1);
        }
        else
        {
            // Mur droit : sens inversé, sinon l'image serait en miroir
            vertex(xPixels, topPixels, farZPixels,  0, 0);
            vertex(xPixels, topPixels, nearZPixels, 1, 0);
            vertex(xPixels, bottomPixels, nearZPixels, 1, 1);
            vertex(xPixels, bottomPixels, farZPixels,  0, 1);
        }

        endShape();
    }
}