#ifndef CLP_H
#include "clp.h"
#endif

#define OPTPARSE_IMPLEMENTATION
#include "optparse.h"
// maybe we should make the opts set some flags in an options struct
// and pass it to a func that sets up the lua accordingly
int
main(int argc, char *argv[])
{
    struct clp_ctx ctx;
    clp_init(&ctx);
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
            ctx.program_opts.print_available_overrides = true;
            break;
        case 't':
            ctx.program_opts.filetype_override = options.optarg;
            break;
        case 'h':
            ctx.program_opts.highlight_line = atoi(options.optarg);
            break;
        case 's':
            ctx.program_opts.color_theme_override = options.optarg;
            break;
        default:
            usage();
            exit(1);
        }
    }

    filename = optparse_arg(&options);

    struct stat buf;

    if (!ctx.program_opts.print_available_overrides &&
        clp_open_file(&ctx, &buf, filename)) {
        return 1;
    }

    clp_run(&ctx);
    clp_cleanup(&ctx);
    return 0;
}
