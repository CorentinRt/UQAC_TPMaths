class GameTimer implements IUpdatable
{
  float duration;
  float elapsedTime = 0;
  boolean isRunning = false;

  GameTimer(float duration)
  {
    this.duration = duration;
  }

  void Update(float deltaTime)
  {
    if (!isRunning) return;
    elapsedTime += deltaTime;
  }

  void Start()
  {
    elapsedTime = 0;
    isRunning = true;
  }

  void Stop()
  {
    isRunning = false;
  }

  boolean IsFinished()
  {
    return elapsedTime >= duration;
  }

  float GetRemainingTime()
  {
    return max(0, duration - elapsedTime);
  }
}
