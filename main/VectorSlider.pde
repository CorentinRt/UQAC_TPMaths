class VectorSlider
{
    ArrayList<Slider> sliders = new ArrayList<Slider>();
    ArrayList<TextDisplay> texts = new ArrayList<TextDisplay>();
    float heightPadding;
    float x, y;
    float w, h;

    float textHeightSize = 30;

    VectorSlider(float x, float y, float width, float height, float heightPadding, String title, color mainColor, color secondaryColor, color thirdColor)
    {
        this.heightPadding = heightPadding;
        this.x = x;
        this.y = y;
        w = width;
        h = height;
        CreateTexts(title, mainColor);
        CreateSliders(secondaryColor, mainColor, thirdColor);
    }

    void CreateTexts(String title, color c)
    {
        texts.clear();

        texts.add(new TextDisplay(title, x, y, font));
        texts.get(0).SetText(title);
        texts.get(0).SetAlignment(LEFT);
        texts.get(0).SetTextColor(c);
        updateManager.Register(texts.get(0));


        float newY = y + textHeightSize * 1.5;
        texts.add(new TextDisplay("X : ", x, newY, font));
        texts.get(1).SetAlignment(LEFT);
        texts.get(1).SetTextColor(c);
        updateManager.Register(texts.get(1));

        newY += h / 3 + heightPadding;
        texts.add(new TextDisplay("Y : ", x, newY, font));
        texts.get(2).SetAlignment(LEFT);
        texts.get(2).SetTextColor(c);
        updateManager.Register(texts.get(2));

        newY += h / 3 + heightPadding;
        texts.add(new TextDisplay("Z : ", x, newY, font));
        texts.get(3).SetAlignment(LEFT);
        texts.get(3).SetTextColor(c);
        updateManager.Register(texts.get(3));
    }

    void CreateSliders(color sliderColor, color defaultButton, color pressedButton)
    {
        sliders.clear();

        float newY = y + textHeightSize;
        sliders.add(new Slider(x + 30, newY, w, h, sliderColor, defaultButton, pressedButton));

        newY += h / 3 + heightPadding;
        sliders.add(new Slider(x + 30, newY, w, h, sliderColor, defaultButton, pressedButton));

        newY += h / 3 + heightPadding;
        sliders.add(new Slider(x + 30, newY, w, h, sliderColor, defaultButton, pressedButton));
    }

    boolean IsMouseOver()
    {
        for (Slider slider : sliders)
        {
            if (slider.IsMouseOver()) return true;
        }
        return false;
    }
}