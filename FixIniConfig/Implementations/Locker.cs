using FixIniConfig.Implementations.Interfaces;
using System.IO;
using System.Reflection;

namespace FixIniConfig.Implementations
{
  public class Locker : ILocker
  {
    private readonly string lockFile;

    public Locker(IPaths paths)
    {
      lockFile = Path.Combine(paths.RunningDirectory, $"{Assembly.GetExecutingAssembly().GetName().Name}.lock");
    }

    public void Lock()
    {
      if (!File.Exists(lockFile))
      {
        File.Create(lockFile).Dispose();
      }
    }

    public void Unlock()
    {
      if (File.Exists(lockFile))
      {
        File.Delete(lockFile);
      }
    }
  }
}
