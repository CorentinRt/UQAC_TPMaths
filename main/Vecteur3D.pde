class Vecteur3D
{
  float x = 0;
  float y = 0;
  float z = 0;
  
  Vecteur3D(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  //norme
  //norme au carré
  //normalisation
  //multiplication par un scalaire
  //addition
  //soustraction
  //produit par composantes
  //produit scalaire
  //produit vectoriel
  
  float ScalarProduct(Vecteur3D other)
  {
    return this.x * other.x + this.y * other.y + this.z * other.z;
  }
  
  float Norm()
  {
    return (float)Math.sqrt(SquaredNorm());
  }
  
  float SquaredNorm()
  {
    return (float)(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2));
  }
  
  Vecteur3D Normalize()
  {
    float norm = Norm();
    
    if (norm == 0f)
    {
        return new Vecteur3D(0f, 0f, 0f); 
    }
    
    return new Vecteur3D(this.x / norm, this.y / norm, this.z / norm);
  }
  
  Vecteur3D MultiplyByScalar(float scalar)
  {
    return new Vecteur3D(this.x * scalar, this.y * scalar, this.z * scalar);
  }
}
