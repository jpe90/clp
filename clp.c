#include <lauxlib.h>
#include <libgen.h>
#include <lua.h>
#include <lualib.h>
#include <pwd.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define OPTPARSE_IMPLEMENTATION
#include "optparse.h"

#ifndef PATHMAX
#define PATHMAX 4096
#endif

#ifndef CLP_PATH
#define CLP_PATH "/usr/local/share/clp"
#endif

#ifndef SRC_LUA_PATH
#define SRC_LUA_PATH ""
#endif

void bail(lua_State *L, char *msg) {
  fprintf(stderr, "\nFATAL ERROR:\n  %s: %s\n\n", msg, lua_tostring(L, -1));
  exit(1);
}

int print_lua_path(lua_State *L) {
  lua_getglobal(L, "package");
  lua_getfield(L, -1, "path");
  const char *cur_path;
  cur_path = lua_tostring(L, -1);
  printf("%s\n", cur_path);
  return 0;
}

bool lua_path_add(lua_State *L, const char *path) {
  if (!L || !path)
    return false;
  lua_getglobal(L, "package");
  lua_pushstring(L, path);
  lua_pushstring(L, "/?.lua;");
  lua_getfield(L, -3, "path");
  lua_concat(L, 3);
  lua_setfield(L, -2, "path");
  lua_pop(L, 1); /* package */
  return true;
}

bool lua_paths_get(lua_State *L, char **lpath, char **cpath) {
  if (!L)
    return false;
  const char *s;
  lua_getglobal(L, "package");
  lua_getfield(L, -1, "path");
  s = lua_tostring(L, -1);
  *lpath = s ? strdup(s) : NULL;
  lua_getfield(L, -2, "cpath");
  s = lua_tostring(L, -1);
  *cpath = s ? strdup(s) : NULL;
  return true;
}

static bool package_exists(lua_State *L, const char *name) {
  const char lua[] =
      "local name = ...\n"
      "for _, searcher in ipairs(package.searchers or package.loaders) do\n"
      "local loader = searcher(name)\n"
      "if type(loader) == 'function' then\n"
      "return true\n"
      "end\n"
      "end\n"
      "return false\n";
  if (luaL_loadstring(L, lua) != LUA_OK)
    return false;
  lua_pushstring(L, name);
  /* an error indicates package exists */
  bool ret = lua_pcall(L, 1, 1, 0) != LUA_OK || lua_toboolean(L, -1);
  lua_pop(L, 1);
  return ret;
}

int main(int argc, char *argv[]) {
  struct optparse_long longopts[] = {
      {"highlight-line", 'h', OPTPARSE_REQUIRED},
      {"override-filetype", 't', OPTPARSE_REQUIRED},
      {"list-overrides", 'l', OPTPARSE_NONE},
      {0}};

  lua_State *L = luaL_newstate();
  if (!L) {
    return -1;
  }

  luaL_openlibs(L);

  char path[PATH_MAX];
  lua_path_add(L, CLP_PATH);
  if (strcmp(SRC_LUA_PATH, "") != 0) {
    lua_path_add(L, SRC_LUA_PATH);
  }

  const char *home = getenv("HOME");
  if (!home || !*home) {
    struct passwd *pw = getpwuid(getuid());
    if (pw)
      home = pw->pw_dir;
  }

  lua_path_add(L, CLP_PATH);

  const char *xdg_config = getenv("XDG_CONFIG_HOME");
  if (xdg_config) {
    snprintf(path, sizeof path, "%s/clp", xdg_config);
    lua_path_add(L, path);
  } else if (home && *home) {
    snprintf(path, sizeof path, "%s/.config/clp", home);
    lua_path_add(L, path);
  }

  int ret = 0;
  int status = 0;
  if (!package_exists(L, "clp")) {
    fprintf(stderr, "ERROR: failed to load clp.lua\n");
    exit(1);
  }

  lua_getglobal(L, "require");
  lua_pushstring(L, "clp");
  status = lua_pcall(L, 1, 1, 0);
  if (status != 0)
    fprintf(stderr, "%s\n", lua_tostring(L, -1));

  lua_getglobal(L, "write");
  lua_newtable(L);

  int option = 0;
  char *filename = "";
  char *filetype_override = "";
  int highlight_line = 0;
  struct optparse options;
  optparse_init(&options, argv);
  while ((option = optparse_long(&options, longopts, NULL)) != -1) {
    switch (option) {
    case 'l':
      lua_getglobal(L, "print_available_overrides");
      ret = lua_pcall(L, 0, 0, 0);
      if (ret != 0) {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        return 1;
      }
      lua_close(L);
      return 0;
    case 't':
      filetype_override = options.optarg;
      lua_pushliteral(L, "filetype_override");
      lua_pushstring(L, filetype_override);
      lua_settable(L, -3);
      break;
    case 'h':
      highlight_line = atoi(options.optarg);
      lua_pushliteral(L, "highlight_line");
      lua_pushinteger(L, highlight_line);
      lua_settable(L, -3);
      break;
    }
  }

  filename = optparse_arg(&options);

  struct stat buf;

  if (stat(filename, &buf) == -1) {
    /* stat failed, file does not exist or is inaccessible */
    perror("stat");
    return 1;
  }

  if (!S_ISREG(buf.st_mode)) {
    /* file exists but is not a regular file */
    printf("%s is not a regular file\n", argv[1]);
    return 1;
  }

  lua_pushliteral(L, "filename");
  lua_pushstring(L, filename);
  lua_settable(L, -3);
  ret = lua_pcall(L, 1, 0, 0);
  if (ret != 0) {
    fprintf(stderr, "%s\n", lua_tostring(L, -1));
    return 1;
  }

  lua_close(L);
  return 0;
}
