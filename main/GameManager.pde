class GameManager
{
  GameState state = GameState.WAITING;
  
  // Score & timer
  ScoreManager scoreManager = new ScoreManager();
  GameTimer gameTimer = new GameTimer(40); // secondes par partie (court pour test)

  // Texts
  TextDisplay scoreDisplay;
  TextDisplay timerDisplay;
  
  TextDisplay waitingDisplayClickToPlay;
  TextDisplay gameOverDisplayScore;
  TextDisplay gameOverClickToRestart;
  
  TextDisplay menuDisplayNames;
  TextDisplay menuGameName;
  
  GameManager(PFont font)
  {
    // Init texts
    scoreDisplay = new TextDisplay("Score : 0", 5, 30, font);
    scoreDisplay.SetBackground(color(0, 0, 0, 155), true);
    scoreDisplay.SetSize(30);
     
    timerDisplay = new TextDisplay("", width / 2, 42, font);
    timerDisplay.SetAlignment(CENTER);
    timerDisplay.SetSize(45);
   
    timerDisplay.SetBackground(color(0, 0, 0, 155), true);
    
    waitingDisplayClickToPlay = new TextDisplay("Appuyez sur clic gauche pour commencer", width / 2, height / 2, font);
    waitingDisplayClickToPlay.SetAlignment(CENTER);
    waitingDisplayClickToPlay.SetSize(25);
    
    gameOverDisplayScore = new TextDisplay("", width / 2, height / 2, font);
    gameOverDisplayScore.SetAlignment(CENTER);
    gameOverDisplayScore.SetSize(25);
    
    gameOverClickToRestart = new TextDisplay("Appuyez sur clic gauche pour retenter votre chance", width / 2, height / 2 + 40, font);
    gameOverClickToRestart.SetAlignment(CENTER);
    gameOverClickToRestart.SetSize(25);
    
    menuDisplayNames = new TextDisplay("Un jeu créé par Volodia Bussereau, Jérémy Lombard, Corentin Remot & Manon Wimmer", width / 2, height - 100, font);
    menuDisplayNames.SetAlignment(CENTER);
    menuDisplayNames.SetSize(20);
    
    menuGameName = new TextDisplay("Maths TP - Phase 1", width / 2, height / 2 -50, font);
    menuGameName.SetAlignment(CENTER);
    menuGameName.SetSize(80);
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
    
    gameOverDisplayScore.SetText("Partie terminée ! Score final : " + scoreManager.GetScore());
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
        waitingDisplayClickToPlay.Update(deltaTime);
        menuDisplayNames.Update(deltaTime);
        menuGameName.Update(deltaTime);
        break;
        
      // Play = score + timer
      case PLAYING:
        scoreDisplay.Update(deltaTime);
        timerDisplay.Update(deltaTime);
        break;
        
      // Game over = game over display
      case GAME_OVER:
        DrawFullscreenOverlay(color(0, 0, 0, 255));
        gameOverDisplayScore.Update(deltaTime);
        menuDisplayNames.Update(deltaTime);
        menuGameName.Update(deltaTime);
        gameOverClickToRestart.Update(deltaTime);
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
  
  void AddScore(int amount)
  {
    scoreManager.AddScore(amount);
  }
}
