class Vector3DUnitTests
{
  Vector3DUnitTests()
  {
  }
  
  void TestAll()
  {
    TestNorm();
    TestSquaredNorm();
    TestNormalize();
    TestMultiplyByScalar();
    TestAdd();
    TestMultiply();
    TestScalarProduct();
    TestVectorProduct();
  }
  
  void TestNorm()
  {
    Vector3D testVector = new Vector3D(0, 0.6, 0.8);
    
    float expectedNorm = 1;
    float resultNorm = testVector.Norm();
    
    if (expectedNorm != resultNorm)
      System.out.printf("TEST NORM - FAILED : Expected vector:%f norm : %f, result norm : %f \n", testVector.GetText(), expectedNorm, resultNorm);
    else
      System.out.printf("TEST NORM - COMPLETED\n");
  }
  
  void TestSquaredNorm()
  {
    Vector3D testVector = new Vector3D(1, 1, 1);
    
    float expectedSquaredNorm = 3;
    float resultSquaredNorm = testVector.SquaredNorm();
    
    if (expectedSquaredNorm != resultSquaredNorm)
      System.out.printf("TEST SQUARED NORM - FAILED : Expected vector: %s, squared norm : %f, result squared norm : %f \n", testVector.GetText(), expectedSquaredNorm, resultSquaredNorm);
    else
      System.out.printf("TEST SQUARED NORM - COMPLETED\n");
  }
  
  void TestNormalize()
  {
    Vector3D testVector = new Vector3D(1, 1, 1);
    
    Vector3D expectedNormalizedVector = new Vector3D(1/(float)Math.sqrt(3), 1/(float)Math.sqrt(3), 1/(float)Math.sqrt(3));
    Vector3D resultNormalizedVector = testVector.Normalize();
    
    if (!expectedNormalizedVector.IsEqualWith(resultNormalizedVector))
      System.out.printf("TEST NORMALIZE - FAILED : Expected normalized vector: %s : %s, result normalized vector : %s \n", testVector.GetText(), expectedNormalizedVector.GetText(), resultNormalizedVector.GetText());
    else
      System.out.printf("TEST NORMALIZE - COMPLETED\n");
  }
  
  void TestMultiplyByScalar()
  {
    Vector3D testVector = new Vector3D(1, 2, 3);
    
    float scalar = 2;
    
    Vector3D expectedMultipliedByScalarVector = new Vector3D(2, 4, 6);
    Vector3D resultMultipliedByScalarVector = testVector.MultiplyByScalar(scalar);
    
    if (!expectedMultipliedByScalarVector.IsEqualWith(resultMultipliedByScalarVector))
      System.out.printf("TEST MULTIPLY BY SCALAR - FAILED : Expected multiplied vector: %s by scalar: %f, vector : %s, result normalized vector : %s \n", testVector.GetText(), scalar, expectedMultipliedByScalarVector.GetText(), resultMultipliedByScalarVector.GetText());
    else
      System.out.printf("TEST MULTIPLY BY SCALAR - COMPLETED\n");
  }
  
  void TestAdd()
  {
    Vector3D testVector = new Vector3D(1, 2, 3);
    Vector3D other = new Vector3D(4, 5, 6);
    
    Vector3D expectedAddedVector = new Vector3D(5, 7, 9);
    Vector3D resultAddedVector = testVector.Add(other);
    
    if (!expectedAddedVector.IsEqualWith(resultAddedVector))
      System.out.printf("TEST ADD VECTOR - FAILED : Expected added vector: %s with vector: %s : %s, result added vector : %s \n", testVector.GetText(), other.GetText(), expectedAddedVector.GetText(), resultAddedVector.GetText());
    else
      System.out.printf("TEST ADD VECTOR - COMPLETED\n");
  }
  
  void TestMultiply()
  {
    Vector3D testVector = new Vector3D(1, 2, 3);
    Vector3D other = new Vector3D(4, 5, 6);
    
    Vector3D expectedMultipliedVector = new Vector3D(4, 10, 18);
    Vector3D resultMultipliedVector = testVector.Multiply(other);
    
    if (!expectedMultipliedVector.IsEqualWith(resultMultipliedVector))
      System.out.printf("TEST MULTIPLY VECTOR - FAILED : Expected multplied vector: %s with vector: %s : %s, result multiplied vector : %s \n", testVector.GetText(), other.GetText(), expectedMultipliedVector.GetText(), resultMultipliedVector.GetText());
    else
      System.out.printf("TEST MULTIPLY VECTOR - COMPLETED\n");
  }
  
  void TestScalarProduct()
  {
    Vector3D testVector = new Vector3D(1, 0, 0);
    Vector3D other = new Vector3D(0, 1, 0);
    
    float expectedScalarProductVector = 0;
    float resultScalarProductVector = testVector.ScalarProduct(other);
    
    if (expectedScalarProductVector != resultScalarProductVector)
      System.out.printf("TEST SCALAR PRODUCT VECTOR - FAILED : Expected scalar productor vector: %s with vector: %s : %f, result scalar product vector : %f \n", testVector.GetText(), other.GetText(), expectedScalarProductVector, resultScalarProductVector);
    else
      System.out.printf("TEST SCALAR PRODUCT VECTOR - COMPLETED\n");
  }
  
  void TestVectorProduct()
  {
    Vector3D testVector = new Vector3D(3, -3, 1);
    Vector3D other = new Vector3D(4, 9, 2);
    
    Vector3D expectedVectorProduct = new Vector3D(-15, -2, 39);
    Vector3D resultVectorProduct = testVector.VectorProduct(other);
    
    if (!expectedVectorProduct.IsEqualWith(resultVectorProduct))
      System.out.printf("TEST VECTOR PRODUCT - FAILED : Expected vector product: %s with vector: %s : %s, result vector product : %s \n", testVector.GetText(), other.GetText(), expectedVectorProduct.GetText(), resultVectorProduct.GetText());
    else
      System.out.printf("TEST VECTOR PRODUCT - COMPLETED\n");
  }
}
