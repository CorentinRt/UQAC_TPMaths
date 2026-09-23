class GameManager
{
  GameState state = GameState.WAITING;
  
  // Score & timer
  ScoreManager scoreManager = new ScoreManager();
  GameTimer gameTimer = new GameTimer(10); // secondes par partie (court pour test)

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
    scoreDisplay = new TextDisplay("Score : 0", 0, 20, font);
    timerDisplay = new TextDisplay("", width / 2, 20, font);
    timerDisplay.SetAlignment(CENTER);
    
    waitingDisplayClickToPlay = new TextDisplay("Appuyez sur une touche pour commencer", width / 2, height / 2, font);
    waitingDisplayClickToPlay.SetAlignment(CENTER);
    
    gameOverDisplayScore = new TextDisplay("", width / 2, height / 2, font);
    gameOverDisplayScore.SetAlignment(CENTER);
    
    gameOverClickToRestart = new TextDisplay("Appuyez sur une touche pour retenter votre chance", width / 2, height / 2 + 50, font);
    gameOverClickToRestart.SetAlignment(CENTER);
    
    menuDisplayNames = new TextDisplay("Un jeu créé par Volodia Bussereau, Jérémy Lombard, Corentin Remot & Manon Wimmer", width / 2, height - 20, font);
    menuDisplayNames.SetAlignment(CENTER);
    
    menuGameName = new TextDisplay("Projectile Game", width / 2, height / 2 -50, font);
    menuGameName.SetAlignment(CENTER);
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
}
