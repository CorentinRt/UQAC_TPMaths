class Matrix3x3UnitTest{

    Matrix3x3UnitTest(){

    }

    void TestAll(){
        TestAdd();
        TestIdentity();
        TestMultiplyByScalar();
        TestMultiply();
        TestDeterminant();
        TestTranspose();
        TestAdjugate();
        TestInvert();
    }

    void PrintTestResult(String testName, boolean success){
        if (success){
            println("TEST Matrix3x3 : " + testName + " : SUCCESS");
        }else{
            println("TEST Matrix3x3 : " + testName + " : FAIL");
        }
    }

    void TestAdd(){
        
        float[] dm1 = {
            1.0, 0.0, 0.0, 
            0.0, 1.0, 0.0, 
            0.0, 0.0, 1.0
        };

        float[] dm2 = {
            3.0, 4.0, 0.0, 
            1.0, 1.0, 5.0, 
            0.0, 6.0, 1.0
        };

        float[] dm3 = {
            4.0, 4.0, 0.0, 
            1.0, 2.0, 5.0, 
            0.0, 6.0, 2.0
        };


        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);
        Matrix3x3 m3 = new Matrix3x3(dm3);

        boolean success = Matrix3x3.Add(m1, m2).Equals(m3);

        PrintTestResult("ADD", success);
    }

    void TestIdentity(){

        Matrix3x3 m = new Matrix3x3();

        boolean success = m.IsIdentity();

        PrintTestResult("IDENTITY", success);
    }

    void TestMultiply(){

        float[] dm1 = {
            1.0, 2.0, 0.0, 
            0.0, 1.0, 1.0, 
            1.0, 0.0, 2.0
        };

        float[] dm2 = {
            1.0, 0.0, 1.0, 
            2.0, 1.0, 0.0, 
            0.0, 1.0, 1.0
        };

        float[] dm3 = {
            5.0, 2.0, 1.0, 
            2.0, 2.0, 1.0, 
            1.0, 2.0, 3.0
        };

        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);
        Matrix3x3 m3 = new Matrix3x3(dm3);

        boolean success = Matrix3x3.Multiply(m1, m2).Equals(m3);

        PrintTestResult("MULTIPLY", success);
    }

    void TestMultiplyByScalar(){

        float[] dm1 = {
            1.0, 0.0, 2.0, 
            0.0, 4.0, 5.0, 
            3.0, 0.0, 1.0
        };

        float[] dm2 = {
            3.0, 0.0, 6.0, 
            0.0, 12.0, 15.0, 
            9.0, 0.0, 3.0
        };

        float scalar = 3f;
        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);

        boolean success = Matrix3x3.MulitplyByScalar(m1, scalar).Equals(m2);

        PrintTestResult("MULTIPLY_BY_SCALAR", success);
    }

    void TestDeterminant(){

        float[] dm1 = {
            1.0, 0.0, 2.0,
            0.0, 4.0, 5.0,
            3.0, 0.0, 1.0
        };

        Matrix3x3 m1 = new Matrix3x3(dm1);

        float det = -20f;

        boolean success = m1.Determinant() == det;

        PrintTestResult("DETERMINANT", success);
    }

    void TestTranspose(){
        float[] dm1 = {
            1.0, 0.0, 2.0,
            0.0, 4.0, 5.0,
            3.0, 0.0, 1.0
        };

        float[] dm2 = {
            1.0, 0.0, 3.0,
            0.0, 4.0, 0.0,
            2.0, 5.0, 1.0
        };

        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);
        Matrix3x3 m3 = Matrix3x3.Transpose(m1);

        boolean success = m3.Equals(m2);

        PrintTestResult("TRANSPOSE", success);
    }

    void TestAdjugate(){

        float[] dm1 = {
            1.0, 2.0, 0.0,
            0.0, 1.0, 1.0,
            1.0, 0.0, 2.0
        };

        float[] dm2 = {
            2.0, -4.0, 2.0,
            1.0, 2.0, -1.0,
            -1.0, 2.0, 1.0
        };

        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);
        

        boolean success = Matrix3x3.Adjugate(m1).Equals(m2);

        PrintTestResult("ADJUGATE", success);
    }

    void TestInvert(){

        float[] dm1 = {
            1.0, 0.0, 2.0,
            0.0, 4.0, 5.0,
            3.0, 0.0, 1.0
        };

        float[] dm2 = {
            -1.0/5.0, 0.0, 2.0/5.0,
            -3.0/4.0, 1.0/4.0, 1.0/4.0,
            3.0/5.0, 0.0, -1.0/5.0
        };

        Matrix3x3 m1 = new Matrix3x3(dm1);
        Matrix3x3 m2 = new Matrix3x3(dm2);
        
        boolean success = Matrix3x3.Multiply(m1, m2).Equals(Matrix3x3.Identity());

        PrintTestResult("INVERT", success);
    }
}