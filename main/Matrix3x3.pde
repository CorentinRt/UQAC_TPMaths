static class Matrix3x3{
  float[] data = new float[9];
  
  //Constructeur vide = Matrice carré
  Matrix3x3(){
    float[] newMatrix = {
      1.0, 0.0, 0.0, 
      0.0, 1.0, 0.0, 
      0.0, 0.0, 1.0
    };
    this.data = newMatrix;
  }
  
  //Constructeur Classique
  Matrix3x3(float[] newMatrix){
    if (newMatrix.length != 9){
      println("Your matrix is too large");
      return;
    }
    this.data = newMatrix;
  }

  Matrix3x3(Matrix3x3 m){
    this.data = m.data;
  }
  
  void Add(Matrix3x3 matrixToAdd){
    for (int i = 0; i < this.data.length; ++i){
      data[i] = data[i] + matrixToAdd.data[i];
    }
    return;
  }

  Matrix3x3 Add(Matrix3x3 m, Matrix3x3 matrixToAdd){
    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.Add(matrixToAdd);

    return newMatrix;
  }

  float GetValue(int columnIndex, int rowIndex){
    return data[(rowIndex * 3) + columnIndex];
  }
  
  void SetValue(int columnIndex, int rowIndex, float value){
    data[(rowIndex * 3) + columnIndex] = value;
  }
  
  static Matrix3x3 Identity(){
    float[] newMatrix = {
      1.0, 0.0, 0.0, 
      0.0, 1.0, 0.0, 
      0.0, 0.0, 1.0
    };

    return new Matrix3x3(newMatrix);
  }

  boolean IsIdentity(){
    for (int i = 0; i < data.length; ++i){
      if (i % 3 != 0)
        continue;

      if (data[i] != 1)
        return false;
    }

    return true;
  }

  void MultiplyByScalar(float k){

    for (int i = 0; i < data.length; ++i){

      data[i] *= k;
    }
  }

  static Matrix3x3 MulitplyByScalar(Matrix3x3 m, float k){

    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.MultiplyByScalar(k);

    return newMatrix;
  }

  void Multiply(Matrix3x3 matrixToMultiply){
    this.SetValue(0, 0, 
      this.GetValue(0, 0) * matrixToMultiply.GetValue(0, 0) + this.GetValue(1, 0) * matrixToMultiply.GetValue(0, 1) + this.GetValue(2, 0) * matrixToMultiply.GetValue(0, 2)
    );
    this.SetValue(1, 0, 
    this.GetValue(0, 0) * matrixToMultiply.GetValue(1, 0) + this.GetValue(1, 0) * matrixToMultiply.GetValue(1, 1) + this.GetValue(2, 0) * matrixToMultiply.GetValue(1, 2)
    );
    this.SetValue(2, 0, 
    this.GetValue(0, 0) * matrixToMultiply.GetValue(2, 0) + this.GetValue(1, 0) * matrixToMultiply.GetValue(2, 1) + this.GetValue(2, 0) * matrixToMultiply.GetValue(2, 2)
    );

    this.SetValue(0, 1, 
    this.GetValue(0, 1) * matrixToMultiply.GetValue(0, 0) + this.GetValue(1, 1) * matrixToMultiply.GetValue(0, 1) + this.GetValue(2, 1) * matrixToMultiply.GetValue(0, 2)
    );
    this.SetValue(1, 1, 
    this.GetValue(0, 1) * matrixToMultiply.GetValue(1, 0) + this.GetValue(1, 1) * matrixToMultiply.GetValue(1, 1) + this.GetValue(2, 1) * matrixToMultiply.GetValue(1, 2)
    );
    this.SetValue(2, 1, 
    this.GetValue(0, 1) * matrixToMultiply.GetValue(2, 0) + this.GetValue(1, 1) * matrixToMultiply.GetValue(2, 1) + this.GetValue(2, 1) * matrixToMultiply.GetValue(2, 2)
    );

    this.SetValue(0, 2,
    this.GetValue(0, 2) * matrixToMultiply.GetValue(0, 0) + this.GetValue(1, 2) * matrixToMultiply.GetValue(0, 1) + this.GetValue(2, 2) * matrixToMultiply.GetValue(0, 2)
    );
    this.SetValue(1, 2, 
    this.GetValue(0, 2) * matrixToMultiply.GetValue(1, 0) + this.GetValue(1, 2) * matrixToMultiply.GetValue(1, 1) + this.GetValue(2, 2) * matrixToMultiply.GetValue(1, 2)
    );
    this.SetValue(2, 2, 
    this.GetValue(0, 2) * matrixToMultiply.GetValue(2, 0) + this.GetValue(1, 2) * matrixToMultiply.GetValue(2, 1) + this.GetValue(2, 2) * matrixToMultiply.GetValue(2, 2)
    );
  }

  static Matrix3x3 Multiply(Matrix3x3 m, Matrix3x3 matrixToMultiply){
    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.Multiply(matrixToMultiply);

    return newMatrix;
  }
}
