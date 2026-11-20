class Slider implements IUpdatable
{
    float currentPosition;
    float sliderWidth, sliderHeight;
    float x, y;
    float minPosition, maxPosition;
    color sliderColor;
    boolean selected = false;
    float thresholdSelection = 5.f;

    Slider(float x, float y, float givenWidth, float givenHeight, color sliderColor)
    {
        this.sliderWidth = givenWidth;
        this.sliderHeight = givenHeight;
        this.x = x;
        this.y = y;
        currentPosition = x + givenWidth / 2;
        this.minPosition = x;
        this.maxPosition = x + givenWidth;
        this.sliderColor = sliderColor;

        updateManager.Register(this);
    }

    void Draw(){
        noStroke();
        fill(sliderColor);
        rect(minPosition, y, this.sliderWidth, this.sliderHeight);
        if (IsMouseOver() || selected) {
         fill(0, 0, 0);
        } else {
         fill(102, 102, 102);
        }
        rect(currentPosition - this.sliderHeight/2, y, this.sliderHeight, this.sliderHeight * 1.5);
    }

    void Update(float deltaTime)
    {
        Vector3D mousePosition = new Vector3D(mouseX - width/2, mouseY - height/2, 0).MultiplyByScalar(1.08f);
        if (IsMouseOver() && mousePressed) { selected = true; }
        
        if (selected)
        {
            println("SELECTED");
            if (!mousePressed) 
            { 
                selected = false; 
            }
            else
            {
                currentPosition = constrain(mousePosition.x, minPosition, maxPosition);
            }
        }

        Draw();
    }

    boolean IsMouseOver()
    {
        Vector3D mousePosition = new Vector3D(mouseX - width/2, mouseY - height/2, 0).MultiplyByScalar(1.08f);
        if (mousePosition.x > x - thresholdSelection && mousePosition.x < x + this.sliderWidth + thresholdSelection && mousePosition.y > y - thresholdSelection && mousePosition.y < y + this.sliderHeight + thresholdSelection) 
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