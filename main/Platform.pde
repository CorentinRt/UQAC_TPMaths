class Platform
{
  Vector3D start, end;
  float radius;
  ArrayList<Particle> particles = new ArrayList<Particle>();

  Platform(Vector3D start, Vector3D end, float radius)
  {
    this.start = start;
    this.end = end;
    this.radius = radius;
  }

  void Build()
  {
    float dx = end.x - start.x;
    float dy = end.y - start.y;
    float length = sqrt(dx * dx + dy * dy);

    float spacing = radius * 1.2f;
    int count = max(2, ceil(length / spacing) + 1);

    for (int i = 0; i < count; i++)
    {
      float t = i / (float)(count - 1);
      Vector3D pos = new Vector3D(start.x + dx * t, start.y + dy * t, 0);

      Particle p = new Particle(INFINITE_MASS, pos, new Vector3D(0, 0, 0), 0, 0, radius);
      p.SetAffectedByGravity(false);
      color c = color(255, 255, 255);
      p.SetDrawColors(c, c);
      particles.add(p);
    }
  }

  void Destroy()
  {
    for (Particle p : particles) p.DestroyParticle();
    particles.clear();
  }
}