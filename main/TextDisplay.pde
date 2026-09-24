class TextDisplay implements IUpdatable
{
  String text;
  float x, y;
  PFont font;
  
  color textColor = color(255,255,255,255);
  color bgColor = color(255, 200);
  boolean hasBackground = false;
  int padding = 8;
  int alignment = LEFT;
  int customSize = 25;
  
  TextDisplay(String text, float x, float y, PFont font)
  {
    this.text = text;
    this.x = x;
    this.y = y;
    this.font = font;
  }

  void SetText(String newText)
  {
    text = newText;
  }

  void SetPosition(float newX, float newY)
  {
    x = newX;
    y = newY;
  }

  void SetTextColor(color newColor)
  {
    textColor = newColor;
  }

  void SetBackground(color newColor, boolean enabled)
  {
    bgColor = newColor;
    hasBackground = enabled;
  }

  void SetAlignment(int newAlignment)
  {
    alignment = newAlignment;
  }
  
  void SetSize(int size)
  {
    customSize = size;
  }
  
  void Update(float deltaTime)
  {
    pushStyle();
    pushMatrix();

    resetMatrix();
    camera();

    textFont(font);
    textAlign(alignment);
    if (customSize != 0)
      textSize(customSize);

    // Background
    if (hasBackground)
    {
      float backgroundWidth = textWidth(text) + padding * 2;
      float backgroundHeight = textAscent() + textDescent() + padding * 2;

      float boxX = x - padding;
      if (alignment == CENTER) 
        boxX = x - backgroundWidth / 2;
      else if (alignment == RIGHT) 
        boxX = x - backgroundWidth + padding;

      noStroke();
      fill(bgColor);
      rect(boxX, y - textAscent() - padding, backgroundWidth, backgroundHeight);
    }

    fill(textColor);
    text(text, x, y);

    popMatrix();
    popStyle();
  }
}
