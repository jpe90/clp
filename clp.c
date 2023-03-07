#ifndef CLP_H
#include "clp.h"
#endif

void
bail(lua_State *L, char *msg)
{
    fprintf(stderr, "\nFATAL ERROR:\n  %s %s\n\n", msg, lua_tostring(L, -1));
    exit(1);
}

void
usage()
{
    printf("usage: clp <filename>\n\
        [--highlight-line <line number>]\n\
        [--override-filetype <filetype>]\n\
        [--list-overrides]\n\
        [--override-colortheme <colortheme>]\n");
}

int
print_lua_path(lua_State *L)
{
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "path");
    const char *cur_path;
    cur_path = lua_tostring(L, -1);
    printf("%s\n", cur_path);
    return 0;
}

bool
lua_path_add(lua_State *L, const char *path)
{
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

bool
lua_paths_get(lua_State *L, char **lpath, char **cpath)
{
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

static bool
package_exists(lua_State *L, const char *name)
{
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

int
lua_init(struct clp_ctx *ctx)
{
    ctx->L = luaL_newstate();
    luaL_openlibs(ctx->L);

    return 0;
}

int
clp_init(struct clp_ctx *ctx)
{
    lua_init(ctx);
    if (!(ctx->L)) {
        return -1;
    }
    lua_path_add(ctx->L, CLP_PATH);
    if (strcmp(SRC_LUA_PATH, "") != 0) {
        lua_path_add(ctx->L, SRC_LUA_PATH);
    }

    char *home = getenv("HOME");
    if (home == NULL) {
        struct passwd *pw = getpwuid(getuid());
        if (pw) {
            home = pw->pw_dir;
        }
    }

    if (home && *home) {
        if (strlen(home) > PATH_MAX) {
            printf(
                "Error: The length of the return value of getenv() is greater "
                "than PATH_MAX\n");
            return 1;
        }

        ctx->program_opts.highlight_line = -1;
        ctx->program_opts.filetype_override = NULL;
        ctx->program_opts.color_theme_override = NULL;
        ctx->program_opts.print_available_overrides = false;
    }

    const char *xdg_config = getenv("XDG_CONFIG_HOME");
    if (xdg_config) {
        snprintf(ctx->path, sizeof ctx->path, "%s/clp", xdg_config);
        lua_path_add(ctx->L, ctx->path);
    } else if (home && *home) {
        snprintf(ctx->path, sizeof ctx->path, "%s/.config/clp", home);
        lua_path_add(ctx->L, ctx->path);
    }
    return 0;
}

int
clp_open_file(struct clp_ctx *ctx, struct stat *buf, char *filename)
{
    if (stat(filename, buf) == -1) {
        fprintf(stderr, "Unable to stat %s: ", filename);
        perror(0);
        fprintf(stderr, "Did you provide a valid file?\n");
        return 1;
    }

    if (!S_ISREG(buf->st_mode)) {
        fprintf(stderr, "%s exists but is not a regular file\n", filename);
        return 1;
    }
    strcpy(ctx->filename, filename);
    return 0;
}

int
clp_run(struct clp_ctx *ctx)
{
    int ret = 0;

    int status = 0;
    if (!package_exists(ctx->L, "clp")) {
        fprintf(stderr, "ERROR: failed to load clp.lua on CLP_PATH %s\n",CLP_PATH);
        exit(1);
    }

    lua_getglobal(ctx->L, "require");
    lua_pushstring(ctx->L, "clp");
    status = lua_pcall(ctx->L, 1, 1, 0);
    if (status != 0)
        fprintf(stderr, "%s\n", lua_tostring(ctx->L, -1));

    if (ctx->program_opts.print_available_overrides) {
        lua_getglobal(ctx->L, "print_available_overrides");
        ret = lua_pcall(ctx->L, 0, 0, 0);
        if (ret != 0) {
            fprintf(stderr, "error printing overrides: %s\n",
                    lua_tostring(ctx->L, -1));
            return 1;
        }
        return 0;
    }

    lua_getglobal(ctx->L, "write");
    lua_newtable(ctx->L);

    if (ctx->program_opts.filetype_override) {
        printf("in ft override, see %s\n", ctx->program_opts.filetype_override);
        lua_pushliteral(ctx->L, "filetype_override");
        lua_pushstring(ctx->L, ctx->program_opts.filetype_override);
        lua_settable(ctx->L, -3);
    }
    if (ctx->program_opts.highlight_line >= 0) {
        lua_pushliteral(ctx->L, "highlight_line");
        lua_pushinteger(ctx->L, ctx->program_opts.highlight_line);
        lua_settable(ctx->L, -3);
    }
    if (ctx->program_opts.color_theme_override) {
        lua_pushliteral(ctx->L, "color_theme_override");
        lua_pushstring(ctx->L, ctx->program_opts.color_theme_override);
        lua_settable(ctx->L, -3);
    }
    lua_pushliteral(ctx->L, "filename");
    lua_pushstring(ctx->L, ctx->filename);
    lua_settable(ctx->L, -3);
    ret = lua_pcall(ctx->L, 1, 0, 0);
    if (ret != 0) {
        fprintf(stderr, "%s\n", lua_tostring(ctx->L, -1));
        return 1;
    }
    return ret;
}

void
clp_cleanup(struct clp_ctx *ctx)
{
    lua_close(ctx->L);
}
