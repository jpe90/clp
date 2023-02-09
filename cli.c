#ifndef CLP_H
#include "clp.h"
#endif

#define OPTPARSE_IMPLEMENTATION
#include "optparse.h"
// maybe we should make the opts set some flags in an options struct
// and pass it to a func that sets up the lua accordingly
int
main(int argc, char *argv[]) {
    struct app app;
    init_app(&app);
    struct optparse_long longopts[] = {
        {"highlight-line", 'h', OPTPARSE_REQUIRED},
        {"override-filetype", 't', OPTPARSE_REQUIRED},
        {"list-overrides", 'l', OPTPARSE_NONE},
        {"override-colortheme", 's', OPTPARSE_REQUIRED},
        {0}};

    int option = 0;
    char *filename = "";
    struct optparse options;
    optparse_init(&options, argv);
    while ((option = optparse_long(&options, longopts, NULL)) != -1) {
        switch (option) {
        case 'l':
            app.program_opts.print_available_overrides = true;
            return 0;
        case 't':
            app.program_opts.filetype_override = options.optarg;
            break;
        case 'h':
            app.program_opts.highlight_line = atoi(options.optarg);
            break;
        case 's':
            app.program_opts.color_theme_override = options.optarg;
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

    // copy filename to app.filename
    strcpy(app.filename, filename);
    run_lua(&app);
    lua_close(app.L);
    return 0;
}
