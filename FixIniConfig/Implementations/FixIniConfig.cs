using FixIniConfig.Implementations.Interfaces;
using System;

namespace FixIniConfig.Implementations
{
  public class FixIniConfig : IFix
  {
    public void Fix()
    {
      Console.WriteLine("This app isn't magically going to write itself, get to work.");
      Console.ReadLine();
    }
  }
}
