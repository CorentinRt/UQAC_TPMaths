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
    
    Quaternion(Vector3D axis, float angle)
    {
        float angle_divided_by_2 = angle/2;
        this.w = cos(angle_divided_by_2);
        this.x = sin(angle_divided_by_2) * axis.x;
        this.y = sin(angle_divided_by_2) * axis.y;
        this.z = sin(angle_divided_by_2) * axis.z;
    }

    void Add(Quaternion quaternionToAdd){
        this.w += quaternionToAdd.w;
        this.x += quaternionToAdd.x;
        this.y += quaternionToAdd.y;
        this.z += quaternionToAdd.z;
    }

    void Subtract(Quaternion quaternionToRemove){
        this.w -= quaternionToRemove.w;
        this.x -= quaternionToRemove.x;
        this.y -= quaternionToRemove.y;
        this.z -= quaternionToRemove.z;
    }

}