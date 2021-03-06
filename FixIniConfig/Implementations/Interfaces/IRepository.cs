using System.Linq;

namespace FixIniConfig.Implementations.Interfaces
{
  public interface IRepository<T>
  {
    IQueryable<T> LoadAll();
    T LoadSingle(int modelId);
    void Create(T model);
    void Update(T model);
    void Delete(T model);
  }
}
