class Slider implements IUpdatable
{
    float currentPosition;
    float sliderWidth, sliderHeight;
    float x, y;
    float minPosition, maxPosition;
    color sliderColor;
    color buttonColorDefault;
    color buttonColorPressed;
    boolean selected = false;
    float thresholdSelection = 1f;

    Slider(float x, float y, float givenWidth, float givenHeight, color sliderColor, color buttonColorDefault, color buttonColorPressed)
    {
        this.sliderWidth = givenWidth;
        this.sliderHeight = givenHeight;
        this.x = x;
        this.y = y;
        currentPosition = x + givenWidth / 2;
        this.minPosition = x;
        this.maxPosition = x + givenWidth;
        this.sliderColor = sliderColor;
        this.buttonColorDefault = buttonColorDefault;
        this.buttonColorPressed = buttonColorPressed;

        updateManager.Register(this);
    }

    void Draw(){
        pushMatrix();

        resetMatrix();
        camera();

        noStroke();
        fill(sliderColor);
        rect(minPosition, y, this.sliderWidth, this.sliderHeight);
        if (IsMouseOver() || selected)
        {
            fill(buttonColorPressed);
        } 
        else 
        {
            fill(buttonColorDefault);
        }
        rect(currentPosition - this.sliderHeight / 2, y - this.sliderHeight / 3, this.sliderHeight, this.sliderHeight * 1.5);

        popMatrix();
    }

    void Update(float deltaTime)
    {
        if (!bIsSelectingSlider && IsMouseOver() && mousePressed) 
        {
            bIsSelectingSlider = true; 
            selected = true; 
        }
        
        if (selected)
        {
            println("SELECTED");
            if (!mousePressed) 
            { 
                bIsSelectingSlider = false;
                selected = false;
            }
            else
            {
                currentPosition = constrain(mouseX, minPosition, maxPosition);
            }
        }

        Draw();
    }

    boolean IsMouseOver()
    {
        if (mouseX > x - thresholdSelection && mouseX < x + this.sliderWidth + thresholdSelection && mouseY > y - thresholdSelection && mouseY < y + this.sliderHeight + thresholdSelection) 
        {
            return true;
        } 
        else 
        {
            return false;   
        }
    }

    float GetValue(float minValue, float maxValue){
        return minValue + GetPercentage() * (maxValue - minValue);
    }

    float GetPercentage(){
        return (currentPosition - minPosition) / this.sliderWidth;
    }
}