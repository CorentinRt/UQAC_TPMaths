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

  float Determinant(){
    // NEGATIVE
    float firstNegative = this.GetValue(0, 2) * this.GetValue(1, 1) * this.GetValue(2, 0);
    
    float secondNegative = this.GetValue(0, 0) * this.GetValue(1, 2) * this.GetValue(2, 1);
    
    float thirdNegative = this.GetValue(0, 1) * this.GetValue(1, 0) * this.GetValue(2, 2);
    
    // POSITIVE
    float firstPositive = this.GetValue(0, 0) * this.GetValue(1, 1) * this.GetValue(2, 2);
    
    float secondPositive = this.GetValue(0, 1) * this.GetValue(1, 2) * this.GetValue(2, 0);
    
    float thirdPositive = this.GetValue(0, 2) * this.GetValue(1, 0) * this.GetValue(2, 1);
    
    return - firstNegative - secondNegative - thirdNegative + firstPositive + secondPositive + thirdPositive;
  }

  static float Determinant(Matrix3x3 m){
    return m.Determinant();
  }

  void Transpose(){
    Matrix3x3 tempMatrix = new Matrix3x3(this);

    for (int i = 0; i < 3; ++i){
      for (int j = 0; j < 3; ++j){

        this.SetValue(j, i, tempMatrix.GetValue(i, j));
      }
    }
  }

  static Matrix3x3 Transpose(Matrix3x3 m){
    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.Transpose();

    return newMatrix;
  }

  void Adjugate(){
    
    Matrix3x3 tempMatrix = new Matrix3x3();

    float a11 = this.GetValue(0, 0);
    float a21 = this.GetValue(1, 0);
    float a31 = this.GetValue(2, 0);

    float a12 = this.GetValue(0, 1);
    float a22 = this.GetValue(1, 1);
    float a32 = this.GetValue(2, 1);

    float a13 = this.GetValue(0, 2);
    float a23 = this.GetValue(1, 2);
    float a33 = this.GetValue(2, 2);

    tempMatrix.SetValue(0, 0, (a22 * a33) - (a23 * a32));
    tempMatrix.SetValue(1, 0, (a12 * a33) - (a13 * a32));
    tempMatrix.SetValue(2, 0, (a12 * a23) - (a13 * a22));

    tempMatrix.SetValue(0, 1, (a21 * a33) - (a23 * a31));
    tempMatrix.SetValue(1, 1, (a11 * a33) - (a13 * a31));
    tempMatrix.SetValue(2, 1, (a11 * a23) - (a13 * a21));

    tempMatrix.SetValue(0, 2, (a21 * a32) - (a22 * a31));
    tempMatrix.SetValue(1, 2, (a11 * a32) - (a12 * a31));
    tempMatrix.SetValue(2, 2, (a11 * a22) - (a12 * a21));

    this.data = tempMatrix.data;
  }

  Matrix3x3 Adjugate(Matrix3x3 m){
    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.Adjugate();

    return newMatrix;
  }

  void Invert(){

    float det = this.Determinant();

    if (det == 0f){

      return;
    }

    float invertDet = 1f / det;

    Matrix3x3 adjugate = new Matrix3x3(this);
    adjugate.Adjugate();

    adjugate.MultiplyByScalar(invertDet);

    this.data = adjugate.data;
  }

  Matrix3x3 Invert(Matrix3x3 m){
    Matrix3x3 newMatrix = new Matrix3x3(m);

    newMatrix.Invert();

    return newMatrix;
  }
}
