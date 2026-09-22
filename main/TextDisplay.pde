class TextDisplay
{
  String text;
  float x, y;
  PFont font;
  
  color textColor = color(0);
  color bgColor = color(255, 200);
  boolean hasBackground = true;
  int padding = 8;
  int alignment = LEFT;
  
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
  
  void Update()
  {
    pushStyle();
    pushMatrix();

    resetMatrix();
    camera();

    textFont(font);
    textAlign(alignment);

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
