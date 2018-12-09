#include <experimental/filesystem>

int main()
{
  auto cwd = std::experimental::filesystem::current_path();
  return cwd.string().size();
}
