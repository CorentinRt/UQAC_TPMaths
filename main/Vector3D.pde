static class Vector3D
{
  float x = 0;
  float y = 0;
  float z = 0;
  
  Vector3D()
  {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
  Vector3D(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vector3D(Vector3D v){
    this.x = v.x;
    this.y = v.y;
    this.z = v.z;
  }
  
  boolean IsEqualWith(Vector3D v2) {
    float epsilon = 0.0001f; 
    return Math.abs(x - v2.x) < epsilon && 
           Math.abs(y - v2.y) < epsilon && 
           Math.abs(z - v2.z) < epsilon;
  }
  
  String GetText()
  {
    return "(x: " + x + ", y: " + y + ", z: " + z + ")" ;
  }
  
  
  float Norm()
  {
    return (float)Math.sqrt(SquaredNorm());
  }
  
  float SquaredNorm()
  {
    return (float)(Math.pow(this.x, 2) + Math.pow(this.y, 2) + Math.pow(this.z, 2));
  }
  
  Vector3D Normalize()
  {
    float norm = Norm();
    
    if (norm == 0f)
    {
        return new Vector3D(0f, 0f, 0f); 
    }
    
    return new Vector3D(this.x / norm, this.y / norm, this.z / norm);
  }
  
  Vector3D MultiplyByScalar(float scalar)
  {
    return new Vector3D(this.x * scalar, this.y * scalar, this.z * scalar);
  }
  
  Vector3D Add(Vector3D other)
  {
    return new Vector3D(this.x + other.x, this.y + other.y, this.z + other.z);
  }
  
  Vector3D Substract(Vector3D other)
  {
    return new Vector3D(this.x - other.x, this.y - other.y, this.z - other.z);
  }
  
  Vector3D Multiply(Vector3D other)
  {
    return new Vector3D(this.x * other.x, this.y * other.y, this.z * other.z);
  }
  
  float ScalarProduct(Vector3D other)
  {
    return this.x * other.x + this.y * other.y + this.z * other.z;
  }
  
  Vector3D VectorProduct(Vector3D other)
  {
    Vector3D result = new Vector3D();
    
    result.x = this.y * other.z - this.z * other.y;
    
    result.y = this.z * other.x - this.x * other.z;
    
    result.z = this.x * other.y - this.y * other.x;
    
    return result;
  }
  
  Vector3D Copy(){
    return new Vector3D(this.x, this.y, this.z);
  }

  float Distance(Vector3D other){
    return (float)Math.sqrt(Math.pow(this.x - other.x, 2) + Math.pow(this.y - other.y, 2) + Math.pow(this.z - other.z, 2));
  }

  Vector3D MultiplyByMatrix(Matrix3x3 m, Vector3D v){
    Vector3D result = new Vector3D(v);

    result.MultiplyByMatrix(m);

    return result;
  }

  void MultiplyByMatrix(Matrix3x3 m){
    Vector3D result = new Vector3D();

    result.x = m.GetValue(0, 0) * this.x + m.GetValue(1, 0) * this.y + m.GetValue(2, 0) * this.z;
    result.y = m.GetValue(0, 1) * this.x + m.GetValue(1, 1) * this.y + m.GetValue(2, 1) * this.z;
    result.z = m.GetValue(0, 2) * this.x + m.GetValue(1, 2) * this.y + m.GetValue(2, 2) * this.z;

    this.x = result.x;
    this.y = result.y;
    this.z = result.z;
  }
}
