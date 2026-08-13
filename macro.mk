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
