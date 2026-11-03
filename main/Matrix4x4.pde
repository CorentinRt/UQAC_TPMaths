static class Matrix4x4{
  float[] data = new float[16];
  
  //Constructeur vide = Matrice Identité
  Matrix4x4(){
    float[] newMatrix = {
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0
    };
    this.data = newMatrix;
  }

  //Constructeur Classique
  Matrix4x4(float[] newMatrix){
    if (newMatrix.length != 16){
      println("Your matrix is too large");
      return;
    }
    this.data = newMatrix;
  }

  //Constructeur par copie
  Matrix4x4(Matrix4x4 toCopy){
    if (toCopy.data.length != 16){
      println("Your matrix is too large");
      return;
    }
    arrayCopy(this.data, toCopy);
  }

  boolean IsIdentity(){
    float[] identityMatrix = {
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0
    };

    return data == identityMatrix;
  }

  float GetValue(int col, int line){
    return this.data[line * 4 + col];
  }

  void SetValue(int col, int line, float value){
    this.data[line * 4 + col] = value;
  }
  
  void Add(Matrix4x4 matrixToAdd){
    for (int i = 0; i < this.data.length; i = i +1){
      data[i] = data[i] + matrixToAdd.data[i];
    }
    return;
  }

  void MultiplyByScalar(float k){
    for (int i = 0; i < this.data.length; i = i +1){
      data[i] = data[i] * k;
    }
    return;
  }

  static Matrix4x4 MultiplyByScalar(Matrix4x4 matrix, float k){
    Matrix4x4 copy = new Matrix4x4(matrix);

    copy.MultiplyByScalar(k);

    return copy;
  }

  void Multiply(Matrix4x4 other){
    Matrix4x4 result = Multiply(this, other);
    arrayCopy(this.data, result.data);
  }

  static Matrix4x4 Multiply(Matrix4x4 matrix, Matrix4x4 other){
    Matrix4x4 result = new Matrix4x4(); 
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            for (int k = 0; k < 4; k++)
            {
                result.SetValue(i, j, result.GetValue(i,j) + matrix.GetValue(i, k) * other.GetValue(k, j));
            }
        }
    }
    return result;
  }

  float Determinant(){
    return 0;
  }

  void Invert(){

  }

  static Matrix4x4 Invert(Matrix4x4 m){
    Matrix4x4 copy = new Matrix4x4(m);

    copy.Invert();

    return copy;
  }
}
