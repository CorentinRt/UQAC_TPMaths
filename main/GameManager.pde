class GameManager
{
  GameState state = GameState.WAITING;
  
  // Score & timer
  ScoreManager scoreManager = new ScoreManager();
  GameTimer gameTimer = new GameTimer(15); // secondes par partie (court pour test)

  // Texts
  TextDisplay scoreDisplay;
  TextDisplay timerDisplay;
  TextDisplay waitingDisplay;
  TextDisplay gameOverDisplay;
  
  GameManager(PFont font)
  {
    // Init texts
    scoreDisplay = new TextDisplay("Score : 0", 0, 20, font);
    timerDisplay = new TextDisplay("", width / 2, 20, font);
    timerDisplay.SetAlignment(CENTER);
    
    waitingDisplay = new TextDisplay("Appuyez sur une touche pour commencer", width / 2, height / 2, font);
    waitingDisplay.SetAlignment(CENTER);
    
    gameOverDisplay = new TextDisplay("", width / 2, height / 2, font);
    gameOverDisplay.SetAlignment(CENTER);
  }
  
  void StartGame()
  {
    state = GameState.PLAYING;
    scoreManager.Reset();
    gameTimer.Start();
  }
  
  void EndGame()
  {
    state = GameState.GAME_OVER;
    gameTimer.Stop();
    
    gameOverDisplay.SetText("Partie terminée ! Score final : " + scoreManager.GetScore());
  }

  boolean CheckEndCondition()
  {
    return gameTimer.IsFinished();
  }
  
   void Update(float deltaTime)
  {
    // Update texts draws
    UpdateTexts(deltaTime);
    
    if (state != GameState.PLAYING) 
      return;
      
    // --- Game playing updates --- //

    // Update texts values
    timerDisplay.SetText("Temps : " + nf(gameTimer.GetRemainingTime(), 0, 1) + "s");
    scoreDisplay.SetText("Score : " + scoreManager.GetScore());
    
    gameTimer.Update(deltaTime);
    
    if (CheckEndCondition())
    {
      EndGame();
    }
    // --- Game playing updates --- //
  }
  
  void UpdateTexts(float deltaTime)
  {
    switch (state)
    {
      // Waiting = waiting display
      case WAITING:
        DrawFullscreenOverlay(color(0, 0, 0, 255));
        waitingDisplay.Update(deltaTime);
        break;
        
      // Play = score + timer
      case PLAYING:
        scoreDisplay.Update(deltaTime);
        timerDisplay.Update(deltaTime);
        break;
        
      // Game over = game over display
      case GAME_OVER:
        DrawFullscreenOverlay(color(0, 0, 0, 255));
        gameOverDisplay.Update(deltaTime);
        break;
    }
  }
  
  void DrawFullscreenOverlay(color c)
  {
    pushStyle();
    noStroke();
    fill(c);
    rect(0, 0, width, height);
    popStyle();
  }
}
