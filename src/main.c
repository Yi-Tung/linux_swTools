#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <libconfig.h>

#ifdef mk_configs_path
  #define CONFIGS_PATH mk_configs_path
#else
  #define CONFIGS_PATH "."
#endif


int main(int argc, char *argv[]) {

  const char *apps_mng_file = (CONFIGS_PATH "/apps_mng.cfg");
  const char *copyright_ann, *license_ann;
  config_t cfg;

  if(access(apps_mng_file, F_OK | R_OK) != 0) {
    fprintf(stderr, "%s: %s\n", apps_mng_file, strerror(errno));
    return EXIT_FAILURE;
  }

  config_init(&cfg);
  config_set_include_dir(&cfg, CONFIGS_PATH);

  if(!config_read_file(&cfg, apps_mng_file)){
    fprintf(stderr, "%s:%d: %s\n"
      , config_error_file(&cfg)
      , config_error_line(&cfg)
      , config_error_text(&cfg));
    config_destroy(&cfg);
    return EXIT_FAILURE;
  }
  if(!config_lookup_string(&cfg, "copyright.announce", &copyright_ann)) {
    fprintf(stderr, "%s: not found copyright.announce\n", cfg.filenames[0]);
    config_destroy(&cfg);
    return EXIT_FAILURE;
  }
  if(!config_lookup_string(&cfg, "license.announce", &license_ann)) {
    fprintf(stderr, "%s: not found license.announce\n", cfg.filenames[0]);
    config_destroy(&cfg);
    return EXIT_FAILURE;
  }

  fprintf(stdout, "%s %s\n", copyright_ann, license_ann);
  config_destroy(&cfg);
  return EXIT_SUCCESS;
}
