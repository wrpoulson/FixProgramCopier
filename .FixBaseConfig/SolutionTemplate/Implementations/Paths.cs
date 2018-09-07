using FixBase.Implementations.Interfaces;
using System;

namespace FixBase.Implementations
{
  public class Paths : IPaths
  {
    public string RunningDirectory => AppDomain.CurrentDomain.BaseDirectory;
  }
}
