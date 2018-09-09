using FixIniConfig.Implementations.Interfaces;
using System;

namespace FixIniConfig.Implementations
{
  public class Paths : IPaths
  {
    public string RunningDirectory => AppDomain.CurrentDomain.BaseDirectory;
  }
}
