#include <filesystem>

int main()
{
  auto cwd = std::filesystem::current_path();
  return cwd.string().size();
}
