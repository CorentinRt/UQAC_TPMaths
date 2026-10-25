class GlobController
{
    boolean isStretching = false;

    Vector3D startPosition;
    Globs_Global selectedGlob = null;

    boolean StartStretching(Vector3D mousePos){
        startPosition = mousePos;
        selectedGlob = null;

        for (Globs_Global globs : globsManager.blobs)
        {
            if (globs.isPositionInContact(mousePos, 2)){
                selectedGlob = globs;
                isStretching = true;
                print("Selected Glob");
                return true;
            }
        }
        return false;
    }

    void StopStretch(Vector3D mousePos){
        isStretching = false;
        Vector3D impulse = startPosition.Substract(mousePos);
        if (selectedGlob == null) { return; }
        selectedGlob.motherGlob.AddForce(impulse.MultiplyByScalar(300));
        print("Adding to Glob Impulse of " + impulse.GetText());
    }


}