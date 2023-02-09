#ifndef CLP_H
#include "clp.h"
#endif

void
bail(lua_State *L, char *msg)
{
    fprintf(stderr, "\nFATAL ERROR:\n  %s %s\n\n", msg, lua_tostring(L, -1));
    exit(1);
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
lua_init(struct app *app)
{
    app->L = luaL_newstate();
    luaL_openlibs(app->L);

    return 0;
}

int
init_app(struct app *app)
{
    lua_init(app);
    if (!(app->L)) {
        return -1;
    }
    lua_path_add(app->L, CLP_PATH);
    if (strcmp(SRC_LUA_PATH, "") != 0) {
        lua_path_add(app->L, SRC_LUA_PATH);
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

        app->program_opts.highlight_line = -1;
        app->program_opts.filetype_override = NULL;
        app->program_opts.color_theme_override = NULL;
        app->program_opts.print_available_overrides = false;
    }

    const char *xdg_config = getenv("XDG_CONFIG_HOME");
    if (xdg_config) {
        snprintf(app->path, sizeof app->path, "%s/clp", xdg_config);
        lua_path_add(app->L, app->path);
    } else if (home && *home) {
        snprintf(app->path, sizeof app->path, "%s/.config/clp", home);
        lua_path_add(app->L, app->path);
    }
    return 0;
}

int
run_lua(struct app *app)
{
    int ret = 0;
    if (app->program_opts.print_available_overrides) {
        printf("in overrides\n");
        lua_getglobal(app->L, "print_available_overrides");
        ret = lua_pcall(app->L, 0, 0, 0);
        if (ret != 0) {
            fprintf(stderr, "%s\n", lua_tostring(app->L, -1));
            return 1;
        }
        app_cleanup(app);
    }
    int status = 0;
    if (!package_exists(app->L, "clp")) {
        fprintf(stderr, "ERROR: failed to load clp.lua\n");
        exit(1);
    }

    lua_getglobal(app->L, "require");
    lua_pushstring(app->L, "clp");
    status = lua_pcall(app->L, 1, 1, 0);
    if (status != 0)
        fprintf(stderr, "%s\n", lua_tostring(app->L, -1));

    lua_getglobal(app->L, "write");
    lua_newtable(app->L);

    if (app->program_opts.filetype_override) {
        lua_pushliteral(app->L, "filetype_override");
        lua_pushstring(app->L, app->program_opts.filetype_override);
        lua_settable(app->L, -3);
    }
    if (app->program_opts.highlight_line >= 0) {
        lua_pushliteral(app->L, "highlight_line");
        lua_pushinteger(app->L, app->program_opts.highlight_line);
        lua_settable(app->L, -3);
    }
    if (app->program_opts.color_theme_override) {
        lua_pushliteral(app->L, "color_theme_override");
        lua_pushstring(app->L, app->program_opts.color_theme_override);
        lua_settable(app->L, -3);
    }
    lua_pushliteral(app->L, "filename");
    lua_pushstring(app->L, app->filename);
    lua_settable(app->L, -3);
    ret = lua_pcall(app->L, 1, 0, 0);
    if (ret != 0) {
        fprintf(stderr, "%s\n", lua_tostring(app->L, -1));
        return 1;
    }
    lua_pushliteral(app->L, "filename");
    lua_pushstring(app->L, app->filename);
    lua_settable(app->L, -3);
    return ret;
}

void
app_cleanup(struct app *app)
{
    lua_close(app->L);
}
