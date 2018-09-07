using FixBase.Implementations.Interfaces;
using System;

namespace FixBase.Implementations
{
  public class FixBase : IFix
  {
    public void Fix()
    {
      Console.WriteLine("This app isn't magically going to write itself, get to work.");
      Console.ReadLine();
    }
  }
}
