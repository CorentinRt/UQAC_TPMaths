class Matrix4x4UnitTests
{
    Matrix4x4UnitTests()
    {
    }

    void PrintTestResult(String testName, boolean success, String failReason){
        if (success){
            println("TEST Matrix4x4 : " + testName + " : SUCCESS");
        }else{
            println("TEST Matrix4x4 : " + testName + " : FAIL, \n " + failReason);
        }
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

    void TestAdd(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 m2 = new Matrix4x4(new float[]{
            2, 1, 0, 3,
            1, 3, 2, 0,
            4, 0, 1, 2,
            2, 5, 3, 1
        });

        Matrix4x4 result = new Matrix4x4(new float[]{
            3, 3, 3, 7,
            6, 9, 9, 8,
            6, 3, 6, 9,
            3, 9, 5, 7
        });

        Matrix4x4 m3 = Matrix4x4.Add(m1, m2);

        boolean success = m3.IsEqual(result);

        String failReason = "Sum of \n" + m1.GetText() + " and \n" + m2.GetText() + " should be equal to \n" + result.GetText() + " but is equal to \n" + m3.GetText();
        PrintTestResult("ADD", success, failReason);
    }

    void TestIdentity(){
        Matrix4x4 identityMatrix = new Matrix4x4(new float[]{
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        });

        boolean success = identityMatrix.IsIdentity();
        if (!success){
            String failReason = "Identity matrix : " + identityMatrix.GetText() + "is not considered identity";
            PrintTestResult("IDENTITY", false, failReason);
            return;
        }

        identityMatrix.SetValue(0, 0, 0);
        success = !identityMatrix.IsIdentity();
        if (!success){
            String failReason = "Identity matrix : " + identityMatrix.GetText() + "is considered identity";
            PrintTestResult("IDENTITY", false, failReason);
            return;
        }

        PrintTestResult("IDENTITY", true, "");
    }

    void TestMultiplyByScalar(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 result = new Matrix4x4(new float[]{
            3,  6,  9, 12,
            15, 18, 21, 24,
            6,  9, 15, 21,
            3, 12,  6, 18
        });

        Matrix4x4 m2 = Matrix4x4.MultiplyByScalar(m1, 3);

        boolean success = m2.IsEqual(result);

        PrintTestResult("MULTIPLYBYSCALAR", success, "");
    }

    void TestMultiply(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 m2 = new Matrix4x4(new float[]{
            2, 1, 0, 3,
            1, 3, 2, 0,
            4, 0, 1, 2,
            2, 5, 3, 1
        });

        Matrix4x4 result = new Matrix4x4(new float[]{
            24, 27, 19, 13,
            60, 63, 43, 37,
            41, 46, 32, 23,
            26, 43, 28, 13
        });

        Matrix4x4 m3 = Matrix4x4.Multiply(m1, m2);

        boolean success = m3.IsEqual(result);

        String failReason = "Product of \n" + m1.GetText() + " and \n" + m2.GetText() + " should be equal to \n" + result.GetText() + " but is equal to \n" + m3.GetText();
        
        PrintTestResult("MULTIPLY", success, failReason);
    }

    void TestDeterminant(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        float expected = -24.0f;

        float result = m1.Determinant();

        boolean success = result == expected;

        PrintTestResult("DETERMINANT", success, "");
    }

    void TestTranspose(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 expected = new Matrix4x4(new float[]{
            1, 5, 2, 1,
            2, 6, 3, 4,
            3, 7, 5, 2,
            4, 8, 7, 6
        });

        Matrix4x4 result = Matrix4x4.Transpose(m1);

        boolean success = result.IsEqual(expected);

        PrintTestResult("TRANSPOSE", success, "");
    }

    void TestAdjugate(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 expected = new Matrix4x4(new float[]{
            54, -6, -24,   0,
            -37, -3,  28,  -4,
            -40,  0,  16,   8,
            29,  3, -20,  -4
        });

        Matrix4x4 result = Matrix4x4.Adjugate(m1);

        boolean success = result.IsEqual(expected);

        PrintTestResult("AJDUGATE", success, "");
    }

    void TestInvert(){
        Matrix4x4 m1 = new Matrix4x4(new float[]{
            1, 2, 3, 4,
            5, 6, 7, 8,
            2, 3, 5, 7,
            1, 4, 2, 6
        });

        Matrix4x4 expected = new Matrix4x4(new float[]{
            -2.25f,       0.25f,  1.0f,       0.0f,
            1.5416667f,  0.125f, -1.1666667f, 0.1666667f,
            1.6666667f,  0.0f,  -0.6666667f, -0.3333333f,
            -1.2083333f, -0.125f,  0.8333333f,  0.1666667f
        });

        Matrix4x4 result = Matrix4x4.Invert(m1);

        boolean success = result.IsNearlyEqual(expected, 0.001f);

        String failReason = "Matrix : \n" + m1.GetText() + " Invert should be : \n " + expected.GetText() + " but is : \n" + result.GetText();

        PrintTestResult("INVERT", success, failReason);
    }
}