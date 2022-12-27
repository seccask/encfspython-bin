#include <INIReader.h>
#include <fmt/format.h>
#include <pybind11/embed.h>
#include <pybind11/stl.h>
#include <spdlog/spdlog.h>

#include <CLI/App.hpp>
#include <CLI/Config.hpp>
#include <CLI/Formatter.hpp>
#include <boost/filesystem.hpp>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <magic_enum.hpp>
#include <sstream>
#include <vector>

#include "seccask/encfs.h"
#include "seccask/util.h"

using namespace seccask;
namespace py = pybind11;

inline constexpr const char* kClassName = "main";

double g_sc_time_spent_on_io = 0.0;

PYBIND11_EMBEDDED_MODULE(cpp_io_profiler, m) {
  m.def("get", []() -> double { return g_sc_time_spent_on_io; });
}

inline static void InitLogging() {
  spdlog::set_level(spdlog::level::debug);
  spdlog::set_pattern("[%H:%M:%S %z] [%^---%L---%$] [thread %t] %v");
}

inline static void DebugShowArgcArgv(int argc, const char** argv) {
  util::log::Debug(kClassName, "argc = {}", argc);
  util::log::Debug(kClassName, "argv = [{}]",
                   fmt::join(argv, argv + argc, ", "));
}

inline static void DebugShowSysPath() {
  auto sys_path =
      py::module::import("sys").attr("path").cast<std::vector<std::string>>();
  util::log::Debug(kClassName, "sys.path = [{}]", fmt::join(sys_path, ", "));
}

inline static std::string GetFileContent(std::string path) {
  std::ifstream t(path);
  std::stringstream buffer;
  buffer << t.rdbuf();
  return buffer.str();
}

void inline static RunPythonFile(const std::string& file_path,
                                 const std::vector<std::string>& args) {
  util::log::Debug(kClassName, "Python file path: {}", file_path);

  std::vector<const char*> args_c;
  std::transform(args.cbegin(), args.cend(), std::back_inserter(args_c),
                 [](const std::string& s) { return s.c_str(); });
  args_c.insert(args_c.begin(), file_path.c_str());

  util::log::Debug(kClassName, "Python interpreter args: [{}]",
                   fmt::join(args_c, ", "));

  util::log::Info(kClassName, "Starting Python interpreter...");
  py::scoped_interpreter interp(true, args_c.size(), args_c.data(), false);
  util::log::Info(kClassName, "OK");

  DebugShowSysPath();

  try {
    py::exec(GetFileContent(file_path).c_str());
  } catch (const py::error_already_set& e) {
    util::log::Error(kClassName, "Python error: {}", e.what());
  }

  if (getenv("SECCASK_PROFILE_IO") != NULL) {
    printf("IO SPENT: %lf\n", g_sc_time_spent_on_io);
  }
  util::log::Warn(kClassName, "Script done");

  fflush(stdout);
}

int main(int argc, const char** argv) {
  // g_sc_time_spent_on_io = (double*)malloc(sizeof(double));
  char unbuffered_c[] = "PYTHONUNBUFFERED=1";
  putenv(unbuffered_c);
  setvbuf(stdout, NULL, _IOLBF, 0);

  InitLogging();
  DebugShowArgcArgv(argc, argv);

  std::string input_file_path;
  std::vector<std::string> args;
  std::string key;

  CLI::App app{"EncFSPython"};
  app.add_option("--input", input_file_path, "Input file path");
  app.add_option("--key", key, "Component key");
  app.add_option("--args", args, "Arguments")->delimiter(',');

  CLI11_PARSE(app, argc, argv);

  if (input_file_path.size() == 0) {
    util::log::Error(kClassName,
                     "Should specify a Python script to start the coordinator");
    return -1;
  }

  if (key.size() != 0) {
    encfs::InitWithKey(key);
  }

  RunPythonFile(input_file_path, args);

  util::log::Warn(kClassName, "Bye");

  return 0;
}