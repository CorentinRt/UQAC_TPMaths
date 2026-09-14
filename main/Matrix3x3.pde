class Matrix3x3{
  float[] matrix = new float[9];
  
  //Constructeur vide = Matrice carré
  Matrix3x3(){
    float[] newMatrix = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
    this.matrix = newMatrix;
  }
  
  //Constructeur Classique
  Matrix3x3(float[] newMatrix){
    if (newMatrix.length > 9 || newMatrix.length < 9){
      println("Your matrix is too large");
      return;
    }
    this.matrix = newMatrix;
  }
  
  
}
