class PhysicsIntegrationSelector
{
  EIntegrationMethod integrationMethod = EIntegrationMethod.EULER;
  
  TextDisplay textDisplay;
  
  String prefixText = "Current Integration method : ";
  
  PhysicsIntegrationSelector(float x, float y, PFont font)
  {
    textDisplay = new TextDisplay(prefixText + integrationMethod, x, y, font);
  }
  
  
  void ToggleIntegrationMethod()
  {
    switch (integrationMethod)
    {
      case EULER:
        SetIntegrationMethod(EIntegrationMethod.VERLET);
        break;
        
      case VERLET:
        SetIntegrationMethod(EIntegrationMethod.EULER);
        break;
        
      default:
        break;
      
    }
  }
  
  void SetIntegrationMethod(EIntegrationMethod inIntegrationMethod)
  {
    integrationMethod = inIntegrationMethod;
    
    textDisplay.SetText(prefixText + integrationMethod);
  }
  
  EIntegrationMethod GetIntegrationMethod()
  {
    return integrationMethod;
  }
  
  
}
