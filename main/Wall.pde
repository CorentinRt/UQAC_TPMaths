class Wall
{
    // ----- FIELDS ----- //
    Vector3D cornerA;
    Vector3D cornerB; 
    Vector3D cornerC; 
    Vector3D cornerD; 

    color wallColor;
    PImage tex;
    float tileSize = 16; // taille de texture (en metres)
    // ----- FIELDS ----- //

    Wall(Vector3D cornerA, Vector3D cornerB, Vector3D cornerC, Vector3D cornerD, color wallColor, PImage tex)
    {
        this.cornerA = cornerA; 
        this.cornerB = cornerB; 
        this.cornerC = cornerC; 
        this.cornerD = cornerD;

        this.wallColor = wallColor;
        this.tex = tex;
    }

    void Draw()
    {
        // répétitions : longueur de a->b et de b->c divisées par la taille d'un motif
        float u = dist(cornerA.x, cornerA.y, cornerA.z, cornerB.x, cornerB.y, cornerB.z) / tileSize;
        float v = dist(cornerB.x, cornerB.y, cornerB.z, cornerC.x, cornerC.y, cornerC.z) / tileSize;

        noStroke();
        beginShape(QUADS);

        if (tex != null) 
        { 
            fill(255); 
            texture(tex); 
        }
        else             
        { 
            fill(wallColor);
        }

        // Quad
        vertex(cornerA.x * pixelsPerMeter, cornerA.y * pixelsPerMeter, cornerA.z * pixelsPerMeter, 0, 0);
        vertex(cornerB.x * pixelsPerMeter, cornerB.y * pixelsPerMeter, cornerB.z * pixelsPerMeter, u, 0);
        vertex(cornerC.x * pixelsPerMeter, cornerC.y * pixelsPerMeter, cornerC.z * pixelsPerMeter, u, v);
        vertex(cornerD.x * pixelsPerMeter, cornerD.y * pixelsPerMeter, cornerD.z * pixelsPerMeter, 0, v);

        endShape();
    }
}