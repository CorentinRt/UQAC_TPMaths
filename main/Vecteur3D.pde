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
  
}
