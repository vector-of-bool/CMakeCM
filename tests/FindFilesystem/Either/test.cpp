#include FS_HEADER

int main()
{
  auto cwd = FS_NAMESPACE::current_path();
  return cwd.string().size();
}
