#include <dirent.h>
#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>

DIR *fdopendir(int fd) {
  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return NULL;

  return opendir(fdpath);
}

int openat(int fd, const char *path, int flags, ...) {
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

  char new_path[strlen(fdpath) + strlen(path) + 1];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  return open(new_path, flags, mode);
}

int unlinkat(int fd, const char *path, int flags) {
  if (fd == AT_FDCWD || path[0] == '/') {
    if (flags & AT_REMOVEDIR)
      return rmdir(path);
    return unlink(path);
  }

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 1];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  if (flags & AT_REMOVEDIR)
    return rmdir(new_path);
  return unlink(new_path);
}
