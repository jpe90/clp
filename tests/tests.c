#ifndef CLP_H
#include "../clp.h"
#endif
#define PCRE2_CODE_UNIT_WIDTH 8

#include <pcre2.h>
#include <stdio.h>
#include <string.h>

#define SRC_LIMIT 8192

int
match_regex(const char *pattern, int pattern_len, const char *subject)
{
    PCRE2_SPTR pat = (PCRE2_SPTR)pattern;
    PCRE2_SPTR sbj = (PCRE2_SPTR)subject;

    int errornumber;
    PCRE2_SIZE erroroffset;

    size_t sbj_len = strlen((char *)sbj);

    pcre2_code *re = pcre2_compile(pat, PCRE2_ZERO_TERMINATED, 0, &errornumber,
                                   &erroroffset, NULL);

    if (re == NULL) {
        PCRE2_UCHAR buffer[256];
        pcre2_get_error_message(errornumber, buffer, sizeof(buffer));
        printf("PCRE2 compilation failed at offset %d: %s\n", (int)erroroffset,
               buffer);
        return 1;
    }

    pcre2_match_data *match_data =
        pcre2_match_data_create_from_pattern(re, NULL);
    int rc = pcre2_match(re, sbj, sbj_len, 0, 0, match_data, NULL);

    if (rc < 0) {
        if (rc == PCRE2_ERROR_NOMATCH)
            printf("didn't find %s.. ", pattern);
        else
            printf("encountered PCRE2 error: %d.. ", rc);
        return 1;
    }

    return 0;
}

int
run_tests(const char *filename, const char *highlighted[],
          const char *not_highlighted[])
{
    printf("running tests for %s.. ", filename);
    int pipefd[2];
    pid_t pid;

    if (pipe(pipefd) == -1) {
        perror("pipe");
        return 1;
    }

    pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        close(pipefd[0]);               // Close unused read end
        dup2(pipefd[1], STDOUT_FILENO); // Redirect stdout to pipe
        struct app app;
        init_app(&app);
        strcpy(app.filename, filename);
        run_lua(&app);

        close(pipefd[1]); // Close the write end of the pipe
    } else {
        int status;
        char buffer[SRC_LIMIT];

        close(pipefd[1]);         // Close the write end of the pipe
        waitpid(pid, &status, 0); // Wait for the child process to complete

        int n = read(pipefd[0], buffer, SRC_LIMIT); // Read from the pipe
        if (n == -1) {
            perror("read");
            return 1;
        }
        buffer[n] = '\0';

        bool pass = true;
        for (int i = 0; highlighted[i] != NULL; i++) {
            char match_pat[100];
            sprintf(match_pat, "\\[\\d\\dm%s", highlighted[i]);
            if (match_regex(match_pat, n, buffer) != 0) {
                pass = false;
            }
        }
        for (int i = 0; not_highlighted[i] != NULL; i++) {
            char match_pat[100];
            sprintf(match_pat, "\\[0m%s", not_highlighted[i]);
            if (match_regex(match_pat, n, buffer) != 0) {
                pass = false;
            }
        }

        if (pass)
            printf("PASS\n");
        else
            printf("FAIL\n");
    }
    return 0;
}
// include headers with lua_init and run_lua defs
int
main(int argc, char *argv[])
{
    run_tests("tests/syntax/test.c", (const char *[]){"void", "\"hello", NULL},
              (const char *[]){"main", "printf", NULL});
    run_tests("tests/syntax/test.lua",
              (const char *[]){"function", "return", "2", NULL},
              (const char *[]){"add", "print", "result", NULL});
    return 0;
}
