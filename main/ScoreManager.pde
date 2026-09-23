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
  }
   
  int GetScore()
  {
    return currentScore;
  }
  
  void Reset()
  {
    currentScore = 0;
  }
}
