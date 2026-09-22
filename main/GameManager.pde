class GameManager
{
  GameState state = GameState.WAITING;
  // score manager to do
  GameTimer gameTimer = new GameTimer(60); // 60 secondes par partie

  TextDisplay scoreDisplay;
  TextDisplay timerDisplay;
  TextDisplay gameOverDisplay;
  
  GameManager(PFont font)
  {
    // Init texts
    scoreDisplay = new TextDisplay("Score : 0", 0, 20, font);

    timerDisplay = new TextDisplay("", width / 2, 20, font);
    timerDisplay.SetAlignment(CENTER);
  }
  
  void StartGame()
  {
    state = GameState.PLAYING;
    // reset score
    gameTimer.Start();
  }
  
  void EndGame()
  {
    state = GameState.GAME_OVER;
    gameTimer.Stop();
    // show msg end game
  }

  boolean CheckEndCondition()
  {
    return gameTimer.IsFinished();
  }
  
   void Update(float deltaTime)
  {
    if (state != GameState.PLAYING) 
    return;

    timerDisplay.SetText("Temps : " + nf(gameTimer.GetRemainingTime(), 0, 1) + "s");
    // update score txt
    
    UpdateTexts(deltaTime);
    
    if (CheckEndCondition())
    {
      EndGame();
    }
  }
  
  void UpdateTexts(float deltaTime)
  {
    switch (state)
    {
      case WAITING:
        break;
        
      case PLAYING:
        scoreDisplay.Update(deltaTime);
        timerDisplay.Update(deltaTime);
        gameTimer.Update(deltaTime);
        break;
        
      case GAME_OVER:
        gameOverDisplay.Update(deltaTime);
        break;
    }
  }
}
