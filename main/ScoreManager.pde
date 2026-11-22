class ScoreManager
{
  ScoreManager()
  {
    this.currentScore = 0;
  }
  
  int currentScore = 0;
  
  void AddScore(int amount)
  {
    currentScore += amount;

    corridor.AddRandomPoster(random(0.2, 0.7));

    scoreSound.play();
  }
   
  int GetScore()
  {
    return currentScore;
  }
  
  void Reset()
  {
    currentScore = 0;

    corridor.ResetPosters();
  }
}
