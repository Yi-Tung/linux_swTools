CFLAGS ?= 

define add_include_path
  CFLAGS += -I$(1)
endef

define add_define_int
  CFLAGS += -D$(1)=$(2)
endef

define add_define_string
  CFLAGS += -D$(1)=\"$(2)\"
endef

define check_pkg_config
  $(if $(shell command -v pkg-config 2>/dev/null),,$(error not found pkg-config))
endef

define check_pkg_packages
  $(eval missing_pkg_packages := $(shell \
    for package in $(1); \
    do \
      pkg-config --exists "$$package" || printf '%s ' "$$package"; \
    done
  ))
  $(if $(strip $(missing_pkg_packages)),$(error not found pkg-packages: $(missing_pkg_packages)))
endef
