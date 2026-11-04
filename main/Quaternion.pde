static class Quaternion
{
    float x = 0;
    float y = 0;
    float z = 0;
    float w = 0;
    
    Quaternion()
    {
        this.w = 1;
        this.x = 0;
        this.y = 0;
        this.z = 0;
    }

    Quaternion(float w, float x, float y, float z){
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    Quaternion(Vector3D axis, float angle)
    {
        float angle_divided_by_2 = angle/2;
        this.w = cos(angle_divided_by_2);
        this.x = sin(angle_divided_by_2) * axis.x;
        this.y = sin(angle_divided_by_2) * axis.y;
        this.z = sin(angle_divided_by_2) * axis.z;
    }

    Quaternion Add(Quaternion quaternionToAdd){
        return new Quaternion(
        this.w + quaternionToAdd.w,
        this.x + quaternionToAdd.x,
        this.y + quaternionToAdd.y,
        this.z + quaternionToAdd.z
        );
    }

    Quaternion Subtract(Quaternion quaternionToRemove){
        return new Quaternion(
        this.w - quaternionToRemove.w,
        this.x - quaternionToRemove.x,
        this.y - quaternionToRemove.y,
        this.z - quaternionToRemove.z
        );
    }

    Quaternion Negate(){
        return new Quaternion(
        -this.w,
        -this.x,
        -this.y,
        -this.z
        );
    }

    Quaternion MultiplyByQ(Quaternion quaternionToMultiply){

        Vector3D v1 = new Vector3D(this.x, this.y, this.z);
        Vector3D v2 = new Vector3D(quaternionToMultiply.x, quaternionToMultiply.y, quaternionToMultiply.z);

        Vector3D vectorProduct = v1.VectorProduct(v2);

        float w = this.w * quaternionToMultiply.w - v1.ScalarProduct(v2);
        float x = this.w * quaternionToMultiply.x + quaternionToMultiply.w * this.x + vectorProduct.x;
        float y = this.w * quaternionToMultiply.y + quaternionToMultiply.w * this.y + vectorProduct.y;
        float z = this.w * quaternionToMultiply.z + quaternionToMultiply.w * this.z + vectorProduct.z;

        //kms

        return new Quaternion(w, x , y , z);
    }

    Quaternion MultiplyByF(float value){
        return new Quaternion(w * value, x * value , y * value , z * value);
    }

    Quaternion Conjugate(){
        return new Quaternion(
            this.w,
            -this.x,
            -this.y,
            -this.z
        );
    }
    
    float Norm(){
        return sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
    }

    Quaternion Invert(){
        return this.Conjugate().MultiplyByF(1 / this.Norm());
    }

    boolean IsEqual(Quaternion q){
        return this.w == q.w && this.x == q.x && this.y == q.y && this.z == q.z;
    }
    
    boolean IsIdentity(){
        Quaternion id1 = new Quaternion();
        Quaternion id2 = new Quaternion();
        id2.w = -1;

        return this.IsEqual(id1) || this.IsEqual(id2);
    }

    Quaternion Difference(Quaternion q){
        // TODO : check si on doit verifier que la norme = 1 de q1
        return q.MultiplyByQ(this.Conjugate());
    } 

}