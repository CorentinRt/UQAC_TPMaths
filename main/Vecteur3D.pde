class Vecteur3D
{
  float x = 0;
  float y = 0;
  float z = 0;
  
  Vecteur3D()
  {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
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
  
  
  Vecteur3D Add(Vecteur3D other)
  {
    return new Vecteur3D(this.x + other.x, this.y + other.y, this.z + other.z);
  }
  
  Vecteur3D Multiply(Vecteur3D other)
  {
    return new Vecteur3D(this.x * other.x, this.y * other.y, this.z * other.z);
  }
  
  float ScalarProduct(Vecteur3D other)
  {
    return this.x * other.x + this.y * other.y + this.z * other.z;
  }
  
  Vecteur3D VectorielProduct(Vecteur3D other)
  {
    Vecteur3D result = new Vecteur3D();
    
    result.x = this.y * other.z - this.z * other.y;
    
    result.y = this.z * other.x - this.x * other.z;
    
    result.z = this.x * other.y - this.y * other.x;
    
    return result;
  }
  
  
}
