class GlobController
{
    boolean isStretching = false;

    Vector3D startPosition;
    Globs_Global selectedGlob = null;
    float impulseForce = 2;

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
        if (selectedGlob == null) { return; }

        Vector3D impulse = startPosition.Substract(mousePos);
        selectedGlob.SetVelocity(impulse.MultiplyByScalar(impulseForce));
        print("Adding to Glob Impulse of " + impulse.GetText());
    }

    void DrawDebug(float deltaTime, Vector3D currentMousePos){
        if (!isStretching) return;
        if (selectedGlob == null) { return; }

        Vector3D impulse = startPosition.Substract(currentMousePos);
        impulse = impulse.MultiplyByScalar(impulseForce);

        Vector3D accumForcePredicted = new Vector3D(0, 9.81, 0);
        accumForcePredicted = accumForcePredicted.MultiplyByScalar(selectedGlob.motherGlob.mass);

        physicsDebugPredictor.DrawDebugSimulation(integrationSelector.GetIntegrationMethod(), selectedGlob.motherGlob.position, impulse, PhysicsUtilities.ComputeAccelerationByForce(selectedGlob.motherGlob.mass, accumForcePredicted), color(255,0,0), 20.0, 2.0, 0.15, deltaTime);
    }


}