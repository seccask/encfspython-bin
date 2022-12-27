#pragma once

#include <string>

extern "C" {
extern unsigned char *g_component_key; /*< 256-bit key */
extern double g_sc_time_spent_on_io;
}

namespace seccask {
namespace encfs {
void InitWithKey(const std::string &component_key);
}  // namespace encfs
}  // namespace seccask