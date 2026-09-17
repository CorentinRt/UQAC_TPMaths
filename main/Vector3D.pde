class Vector3D
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
}
