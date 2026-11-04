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
    for (int i = 0; i < 4; i++){
      for (int j = 0; j < 4; j++){
        SetValue(i, j, toCopy.GetValue(i,j));
      }
    }
  }

  float GetValue(int col, int line){
    return this.data[line * 4 + col];
  }

  void SetValue(int col, int line, float value){
    this.data[line * 4 + col] = value;
  }

  boolean IsEqual(Matrix4x4 other){
    for (int i = 0; i < 4; i++){
      for (int j = 0; j < 4; j++){
        if (GetValue(i, j) != other.GetValue(i, j)) return false;
      }
    }
    return true;
  }

  String GetText(){
    String result = "";
    for (int i = 0; i < 4; i++){
      for (int j = 0; j < 4; j++){
        result += "" + GetValue(j, i);
        if (i != 3 || j != 3){
          result += ", ";
        }
      }
      result += "\n";
    }
    return result;
  }

  boolean IsIdentity(){
    for (int i = 0; i < 4; i++){
      for (int j = 0; j < 4; j++){
        float value = i==j ? 1 : 0;
        if (GetValue(i, j) != value) return false;
      }
    }
    return true;
  }

  static Matrix4x4 Identity(){
    return new Matrix4x4(new float[]{
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0
    });
  }
  
  void Add(Matrix4x4 matrixToAdd){
    for (int i = 0; i < this.data.length; i++){
      data[i] = data[i] + matrixToAdd.data[i];
    }
    return;
  }

  static Matrix4x4 Add(Matrix4x4 m1, Matrix4x4 m2){
    Matrix4x4 copy = new Matrix4x4(m1);

    copy.Add(m2);

    return copy;
  }

  void MultiplyByScalar(float k){
    for (int i = 0; i < this.data.length; i++){
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
                result.SetValue(j, i, result.GetValue(j, i) + matrix.GetValue(k, i) * other.GetValue(j, k));
            }
        }
    }
    return result;
  }

  Matrix3x3 SubMatrix(int col, int line){
    Matrix3x3 result = new Matrix3x3();
    for (int i = 0; i < 4; i++)
    {
        if (i == line) continue;
        for (int j = 0; j < 4; j++)
        {
            if (j == col) continue;
            result.SetValue(j - (col<j? 1 : 0), i - (line<i? 1 : 0), GetValue(j, i));
        }
    }
    return result;
  }

  float Determinant(){
    float result = 0;
    result += GetValue(0,0) * SubMatrix(0, 0).Determinant();
    result -= GetValue(1,0) * SubMatrix(1, 0).Determinant();
    result += GetValue(2,0) * SubMatrix(2, 0).Determinant();
    result -= GetValue(3,0) * SubMatrix(3, 0).Determinant();
    return result;
  }

  void Transpose(){
    Matrix4x4 copy = new Matrix4x4(this);
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            SetValue(i, j, copy.GetValue(j, i));
        }
    }
  }

  static Matrix4x4 Transpose(Matrix4x4 m){
    Matrix4x4 copy = new Matrix4x4(m);

    copy.Transpose();

    return copy;
  }

  static Matrix4x4 Adjugate(Matrix4x4 m){
    Matrix4x4 c = new Matrix4x4();
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            float k = m.SubMatrix(j, i).Determinant();
            c.SetValue(i, j,  pow(-1, i + j) * k);
        }
    }
    c.Transpose();
    return c;
  }

  static Matrix4x4 Invert(Matrix4x4 m){
    Matrix4x4 result = Adjugate(m);
    float det = m.Determinant();

    if (det == 0) return null;

    result.MultiplyByScalar(1/det);

    return result;
  }
}
