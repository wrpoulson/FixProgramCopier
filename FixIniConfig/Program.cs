using System;
using System.IO;
using System.Linq;

namespace FixIniConfig
{
  class Program
  {
    static void Main(string[] args)
    {
            string path = @"Content/Xpeditor.ini";
            var iniFile = File.ReadAllLines(path).ToList();
            bool lineAdded = false;
            for(int i = 0; i < iniFile.Count; i++)
            {
                if (iniFile[i].Contains("COB ROLLUP") && !lineAdded)
                {
                    var lineCopy = iniFile[i];
                    iniFile[i] = iniFile[i].Replace("COB ROLLUP", "COB ROLLUP Replacement 1");
                    lineCopy = lineCopy.Replace("COB ROLLUP", "COB ROLLUP Replacement 2");
                    iniFile.Insert(i, lineCopy);
                    lineAdded = true;
                }
            }
            File.WriteAllLines(path, iniFile.ToArray());
            Console.ReadLine();
    }
  }
}
