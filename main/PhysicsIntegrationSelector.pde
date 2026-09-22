class PhysicsIntegrationSelector implements IUpdatable
{
  EIntegrationMethod integrationMethod = EIntegrationMethod.EULER;
  
  TextDisplay textDisplayCurrentIntegration;
  
  TextDisplay textInputsToggleIntegration;
  
  String prefixText = "Current Integration method : ";
  
  PhysicsIntegrationSelector(float x, float y, PFont font)
  {
    textDisplayCurrentIntegration = new TextDisplay(prefixText + integrationMethod, x, y, font);
    textInputsToggleIntegration = new TextDisplay("<- or -> to switch integration method", x, y + 35.0, font);
    
    textDisplayCurrentIntegration.SetAlignment(RIGHT);
    textInputsToggleIntegration.SetAlignment(RIGHT);
    
    textDisplayCurrentIntegration.SetBackground(color(255, 255, 255, 155), true);
    textInputsToggleIntegration.SetBackground(color(255, 255, 255, 155), true);
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
    
    textDisplayCurrentIntegration.SetText(prefixText + integrationMethod);
  }
  
  EIntegrationMethod GetIntegrationMethod()
  {
    return integrationMethod;
  }
  
  
  // IUpdatable
  void Update(float deltaTime)
  {
    textDisplayCurrentIntegration.Update(deltaTime);
    textInputsToggleIntegration.Update(deltaTime);
    
  }

  // ------------
  
}
