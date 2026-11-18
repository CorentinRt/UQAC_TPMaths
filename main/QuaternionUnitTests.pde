class QuaternionUnitTests
{
    float EPS = 0.0001f;
    int passed = 0;
    int failed = 0;

    QuaternionUnitTests()
    {
    }

    // ---------- Utilitaires ----------

    void PrintTestResult(String testName, boolean success, String failReason){
        if (success){
            passed++;
            println("TEST Quaternion : " + testName + " : SUCCESS");
        }else{
            failed++;
            println("TEST Quaternion : " + testName + " : FAIL, \n " + failReason);
        }
    }

    boolean Near(float a, float b){
        return abs(a - b) < EPS;
    }

    boolean NearlyEqual(Quaternion a, Quaternion b){
        return Near(a.w, b.w) && Near(a.x, b.x) && Near(a.y, b.y) && Near(a.z, b.z);
    }

    boolean NearlyEqualRotation(Quaternion a, Quaternion b){
        return NearlyEqual(a, b) || NearlyEqual(a, b.Negate());
    }

    String Expected(Quaternion expected, Quaternion actual){
        return "Expected " + expected.EulerAngles().GetText() + " but got " + actual.EulerAngles().GetText();
    }

    Quaternion RotZ(float deg){
        return new Quaternion(new Vector3D(0, 0, 1), radians(deg));
    }

    // ---------- Lancement ----------

    void TestAll(){
        passed = 0;
        failed = 0;

        // Constructeurs
        TestConstructorDefault();
        TestConstructorWXYZ();
        TestConstructorAxisAngle();
        TestConstructorAxisAngleNonUnitAxis();

        // Opérations
        TestAdd();
        TestSubtract();
        TestNegate();
        TestMultiplyByQ();
        TestMultiplyByQIdentity();
        TestMultiplyByQNonCommutative();
        TestMultiplyByF();
        TestConjugate();
        TestNorm();
        TestInvertUnit();
        TestInvertNonUnit();
        TestIsEqual();
        TestIsIdentity();
        TestDifference();
        TestScalarProduct();
        TestExpo();
        TestExpoIdentity();
        TestSlerp();
        TestSlerpShortestPath();
        TestEulerAngles();
        TestNormalize();

        println("TEST Quaternion : " + passed + " passed, " + failed + " failed");
    }

    // ---------- Constructeurs ----------

    void TestConstructorDefault(){
        Quaternion q = new Quaternion();
        Quaternion expected = new Quaternion(1, 0, 0, 0);
        boolean success = NearlyEqual(q, expected);
        PrintTestResult("CONSTRUCTOR DEFAULT (identity)", success, Expected(expected, q));
    }

    void TestConstructorWXYZ(){
        Quaternion q = new Quaternion(1, 2, 3, 4);
        boolean success = q.w == 1 && q.x == 2 && q.y == 3 && q.z == 4;
        PrintTestResult("CONSTRUCTOR W X Y Z", success, "Expected (1, 2, 3, 4) but got " + q.GetText());
    }

    void TestConstructorAxisAngle(){
        Quaternion q = new Quaternion(new Vector3D(0, 0, 1), HALF_PI);
        float s = sqrt(2) / 2;
        Quaternion expected = new Quaternion(s, 0, 0, s);
        boolean success = NearlyEqual(q, expected);
        PrintTestResult("CONSTRUCTOR AXIS ANGLE", success, Expected(expected, q));
    }

    void TestConstructorAxisAngleNonUnitAxis(){

        Quaternion q = new Quaternion(new Vector3D(0, 0, 2), HALF_PI);
        boolean success = Near(q.Norm(), 1);
        PrintTestResult("CONSTRUCTOR AXIS ANGLE (non-unit axis is normalized)", success,
            "Quaternion should be unit (norm = 1) but norm = " + q.Norm());
    }

    // ---------- Arithmétique ----------

    void TestAdd(){
        Quaternion a = new Quaternion(1, 2, 3, 4);
        Quaternion b = new Quaternion(5, 6, 7, 8);
        Quaternion expected = new Quaternion(6, 8, 10, 12);
        Quaternion result = a.Add(b);
        PrintTestResult("ADD", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestSubtract(){
        Quaternion a = new Quaternion(5, 6, 7, 8);
        Quaternion b = new Quaternion(1, 2, 3, 4);
        Quaternion expected = new Quaternion(4, 4, 4, 4);
        Quaternion result = a.Subtract(b);
        PrintTestResult("SUBTRACT", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestNegate(){
        Quaternion q = new Quaternion(1, -2, 3, -4);
        Quaternion expected = new Quaternion(-1, 2, -3, 4);
        Quaternion result = q.Negate();
        PrintTestResult("NEGATE", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestMultiplyByQ(){
        Quaternion a = new Quaternion(1, 2, 3, 4);
        Quaternion b = new Quaternion(5, 6, 7, 8);
        Quaternion expected = new Quaternion(-60, 12, 30, 24);
        Quaternion result = a.MultiplyByQ(b);
        PrintTestResult("MULTIPLY BY Q", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestMultiplyByQIdentity(){
        Quaternion q = new Quaternion(1, 2, 3, 4);
        Quaternion id = new Quaternion();
        boolean success = NearlyEqual(q.MultiplyByQ(id), q) && NearlyEqual(id.MultiplyByQ(q), q);
        PrintTestResult("MULTIPLY BY Q (identity)", success, "q * identity and identity * q should both be equal to q");
    }

    void TestMultiplyByQNonCommutative(){
        Quaternion i = new Quaternion(0, 1, 0, 0);
        Quaternion j = new Quaternion(0, 0, 1, 0);
        Quaternion k = new Quaternion(0, 0, 0, 1);

        Quaternion ij = i.MultiplyByQ(j);
        Quaternion ji = j.MultiplyByQ(i);

        boolean success = NearlyEqual(ij, k) && NearlyEqual(ji, k.Negate());
        String failReason = "i*j should be " + k.GetText() + " but is " + ij.GetText() + " ; j*i should be " + k.Negate().GetText() + " but is " + ij.GetText();
        PrintTestResult("MULTIPLY BY Q (non commutative)", success, failReason);
    }

    void TestMultiplyByF(){
        Quaternion q = new Quaternion(1, -2, 3, -4);
        Quaternion expected = new Quaternion(2, -4, 6, -8);
        Quaternion result = q.MultiplyByF(2);
        PrintTestResult("MULTIPLY BY F", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestConjugate(){
        Quaternion q = new Quaternion(1, 2, 3, 4);
        Quaternion expected = new Quaternion(1, -2, -3, -4);
        Quaternion result = q.Conjugate();
        PrintTestResult("CONJUGATE", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestNorm(){
        Quaternion q = new Quaternion(1, 2, 3, 4);
        float expected = sqrt(30);
        float result = q.Norm();
        boolean success = Near(result, expected) && Near(new Quaternion().Norm(), 1);
        PrintTestResult("NORM", success, "Norm of (1, 2, 3, 4) should be " + expected + " but is " + result);
    }

    void TestInvertUnit(){
        Quaternion q = RotZ(60);
        Quaternion result = q.MultiplyByQ(q.Invert());
        Quaternion expected = new Quaternion();
        PrintTestResult("INVERT (unit quaternion)", NearlyEqual(result, expected), Expected(expected, result));
    }

    void TestInvertNonUnit(){
        Quaternion q = new Quaternion(1, 2, 3, 4);
        Quaternion result = q.MultiplyByQ(q.Invert());
        Quaternion expected = new Quaternion();
        PrintTestResult("INVERT (non-unit quaternion)", NearlyEqual(result, expected), Expected(expected, result));
    }

    // ---------- Comparaisons ----------

    void TestIsEqual(){
        Quaternion a = new Quaternion(1, 2, 3, 4);
        Quaternion b = new Quaternion(1, 2, 3, 4);
        Quaternion c = new Quaternion(1, 2, 3, 5);
        boolean success = a.IsEqual(b) && !a.IsEqual(c);
        PrintTestResult("IS EQUAL", success, "(1,2,3,4) should equal (1,2,3,4) and differ from (1,2,3,5)");
    }

    void TestIsIdentity(){
        Quaternion id = new Quaternion();
        Quaternion minusId = new Quaternion(-1, 0, 0, 0);
        Quaternion notId = RotZ(90);

        boolean success = id.IsIdentity() && minusId.IsIdentity() && !notId.IsIdentity();
        String failReason = "identity: " + id.IsIdentity() + " (expected true), -identity: " + minusId.IsIdentity()
            + " (expected true), 90 deg rotation: " + notId.IsIdentity() + " (expected false)";
        PrintTestResult("IS IDENTITY", success, failReason);
    }

    // ---------- Rotation : différence, produit scalaire, expo, slerp ----------

    void TestDifference(){
        Quaternion q1 = RotZ(30);
        Quaternion q2 = RotZ(90);

        Quaternion d = q1.Difference(q2);
        Quaternion expectedD = RotZ(60);
        Quaternion recomposed = d.MultiplyByQ(q1);

        boolean success = NearlyEqualRotation(d, expectedD) && NearlyEqualRotation(recomposed, q2);
        String failReason = "d should be " + expectedD.GetText() + " but is " + d.GetText()
            + " ; d * q1 should be " + q2.GetText() + " but is " + recomposed.GetText();
        PrintTestResult("DIFFERENCE", success, failReason);
    }

    void TestScalarProduct(){
        Quaternion a = new Quaternion(1, 2, 3, 4);
        Quaternion b = new Quaternion(5, 6, 7, 8);
        float result = a.ScalarProduct(b);
        PrintTestResult("SCALAR PRODUCT", Near(result, 70), "Expected 70 but got " + result);
    }

    void TestExpo(){
        Quaternion q = RotZ(90);

        Quaternion half = q.Expo(0.5);     
        Quaternion twice = q.Expo(2);      
        Quaternion zero = q.Expo(0);       
        Quaternion one = q.Expo(1);        

        boolean success = NearlyEqual(half, RotZ(45))
            && NearlyEqual(twice, RotZ(180))
            && NearlyEqual(zero, new Quaternion())
            && NearlyEqual(one, q);

        String failReason = "q^0.5 should be " + RotZ(45).GetText() + " but is " + half.GetText()
            + " ; q^2 should be " + RotZ(180).GetText() + " but is " + twice.GetText()
            + " ; q^0 should be identity but is " + zero.GetText()
            + " ; q^1 should be " + q.GetText() + " but is " + one.GetText();
        PrintTestResult("EXPO", success, failReason);
    }

    void TestExpoIdentity(){
        Quaternion result = new Quaternion().Expo(0.5);
        boolean success = !Float.isNaN(result.w) && !Float.isNaN(result.x)
            && !Float.isNaN(result.y) && !Float.isNaN(result.z)
            && NearlyEqual(result, new Quaternion());
        PrintTestResult("EXPO (identity, no NaN)", success, "identity^0.5 should be identity but is " + result.GetText());
    }

    void TestSlerp(){

        Quaternion q0 = RotZ(30);
        Quaternion q1 = RotZ(90);

        Quaternion atStart = q0.Slerp(q0, q1, 0);
        Quaternion atEnd = q0.Slerp(q0, q1, 1);
        Quaternion atMiddle = q0.Slerp(q0, q1, 0.5);

        boolean success = NearlyEqualRotation(atStart, q0)
            && NearlyEqualRotation(atEnd, q1)
            && NearlyEqualRotation(atMiddle, RotZ(60));

        String failReason = "t=0 should be " + q0.GetText() + " but is " + atStart.GetText()
            + " ; t=1 should be " + q1.GetText() + " but is " + atEnd.GetText()
            + " ; t=0.5 should be " + RotZ(60).GetText() + " but is " + atMiddle.GetText();
        PrintTestResult("SLERP", success, failReason);
    }

    void TestSlerpShortestPath(){
        Quaternion q0 = new Quaternion();
        Quaternion q1 = RotZ(90).Negate();

        Quaternion result = q0.Slerp(q0, q1, 0.5);
        Quaternion expected = RotZ(45);

        boolean success = NearlyEqualRotation(result, expected);
        PrintTestResult("SLERP (shortest path)", success, Expected(expected, result));
    }

    // ---------- Conversions ----------

    void TestEulerAngles(){
        Vector3D aroundZ = RotZ(90).EulerAngles();
        Vector3D aroundX = new Quaternion(new Vector3D(1, 0, 0), HALF_PI).EulerAngles();
        Vector3D none = new Quaternion().EulerAngles();

        boolean success = Near(aroundZ.x, 0) && Near(aroundZ.y, 0) && Near(aroundZ.z, 90)
            && Near(aroundX.x, 90) && Near(aroundX.y, 0) && Near(aroundX.z, 0)
            && Near(none.x, 0) && Near(none.y, 0) && Near(none.z, 0);

        String failReason = "90 deg around Z should be (0, 0, 90) but is (" + aroundZ.x + ", " + aroundZ.y + ", " + aroundZ.z + ")"
            + " ; 90 deg around X should be (90, 0, 0) but is (" + aroundX.x + ", " + aroundX.y + ", " + aroundX.z + ")";
        PrintTestResult("EULER ANGLES", success, failReason);
    }

    void TestNormalize(){
        Quaternion q = new Quaternion(0, 0, 3, 4);       
        Quaternion expected = new Quaternion(0, 0, 0.6f, 0.8f);
        Quaternion result = q.Normalize();
        boolean success = NearlyEqual(result, expected) && Near(result.Norm(), 1);
        PrintTestResult("NORMALIZE", success, Expected(expected, result));
    }
}
