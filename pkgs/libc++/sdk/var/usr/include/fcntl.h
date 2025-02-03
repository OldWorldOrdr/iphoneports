#pragma once

#include_next <fcntl.h>

#ifndef AT_FDCWD
#define AT_FDCWD -2
#endif
#ifndef AT_REMOVEDIR
#define AT_REMOVEDIR 0x0080
#endif

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) &&                              \
     __IPHONE_OS_VERSION_MIN_REQUIRED < 80000) ||                              \
    (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) &&                               \
     __MAC_OS_X_VERSION_MIN_REQUIRED < 101000)

#include <limits.h>
#include <stdarg.h>
#include <string.h>

static inline int openat(int fd, const char *path, int flags, ...) {
  mode_t mode = 0;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  if (fd == AT_FDCWD || path[0] == '/')
    return open(path, flags, mode);

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 2];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  return open(new_path, flags, mode);
}

#endif
