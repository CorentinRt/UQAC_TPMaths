class Wall
{
    // ----- FIELDS ----- //
    Vector3D center;
    Vector3D halfSize;   
    color wallColor;
    PImage tex; // asset en bonus
    // ----- FIELDS ----- //

    Wall(Vector3D center, Vector3D size, color wallColor)
    {
        this.center = center;
        this.halfSize = size.MultiplyByScalar(0.5f);
        this.wallColor = wallColor;
    }

    void Draw()
    {
        pushMatrix();

        // Draw box at pos
        translate(center.x * pixelsPerMeter, center.y * pixelsPerMeter, center.z * pixelsPerMeter);
        fill(wallColor);
        box(halfSize.x * 2 * pixelsPerMeter, halfSize.y * 2 * pixelsPerMeter, halfSize.z * 2 * pixelsPerMeter);

        popMatrix();
    }
}