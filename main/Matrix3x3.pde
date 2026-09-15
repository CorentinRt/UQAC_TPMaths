class Matrix3x3{
  float[] data = new float[9];
  
  //Constructeur vide = Matrice carré
  Matrix3x3(){
    float[] newMatrix = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
    this.data = newMatrix;
  }
  
  //Constructeur Classique
  Matrix3x3(float[] newMatrix){
    if (newMatrix.length > 9 || newMatrix.length < 9){
      println("Your matrix is too large");
      return;
    }
    this.data = newMatrix;
  }
  
  void Add(Matrix3x3 matrixToAdd){
    for (int i = 0; i < this.data.length; i = i +1){
      data[i] = data[i] + matrixToAdd.data[i];
    }
    return;
  }
  
  
}
