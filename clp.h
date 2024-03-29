#ifndef CLP_H
#define CLP_H

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

#ifndef PATHMAX
#define PATHMAX 4096
#endif

#ifndef CLP_PATH
#define CLP_PATH "/usr/local/share/clp"
#endif

#ifndef SRC_LUA_PATH
#define SRC_LUA_PATH ""
#endif

struct clp_ctx {
    lua_State *L;
    char path[PATHMAX];
    struct {
        bool print_available_overrides;
        char *filetype_override;
        char *color_theme_override;
        int highlight_line;
    } program_opts;
    char filename[PATHMAX];
};

void bail(lua_State *L, char *msg);

void usage();

int print_lua_path(lua_State *L);

bool lua_path_add(lua_State *L, const char *path);

bool lua_paths_get(lua_State *L, char **lpath, char **cpath);

int lua_init(struct clp_ctx *ctx);

int clp_init(struct clp_ctx *ctx);

int clp_open_file(struct clp_ctx *ctx, struct stat *buf, char *filename);

int clp_run(struct clp_ctx *ctx);

void clp_cleanup(struct clp_ctx *ctx);

#endif /* CLP_H */
