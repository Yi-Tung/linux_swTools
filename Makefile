include macro.mk

GCC := cc
CFLAGS := -std=c11 -Werror -MMD
LDFLAGS := 
platform := $(shell uname -s)

main_target := exe
test_target := test
target := $(main_target)

main_c := src/main.c
lib_c := $(shell find lib -name "*.c" 2>/dev/null)

ifeq ($(build_mode),release)
  CFLAGS += -O2 -ffunction-sections -fdata-sections
  ifeq ($(platform),Darwin)
    LDFLAGS += -Wl,-dead_strip
  else ifeq ($(platform),Linux)
    LDFLAGS += -Wl,--gc-sections
  endif
  target := $(main_target)
  main_c := $(build_main_c)
  $(eval $(call add_define_int,mk_debug_switch,0))
else ifeq ($(build_mode),debug)
  CFLAGS += -O0 -g
  target := $(main_target)
  main_c := $(build_main_c)
  $(eval $(call add_define_int,mk_debug_switch,1))
else ifeq ($(build_mode),test)
  CFLAGS += -O0
  target := $(test_target)
  main_c := $(build_main_c)
else
  CFLAGS += -O2
  target := $(main_target)
  main_c := src/main.c
endif

src_c := $(main_c) $(lib_c)
src_o := $(patsubst %.c,%.o,$(src_c))
src_d := $(patsubst %.c,%.d,$(src_c))

ifneq ($(build_configs_path),)
  $(eval $(call add_define_string,mk_configs_path,$(build_configs_path)))
endif

$(eval $(call add_include_path,include))


$(target): $(src_o)
	$(GCC) $(LDFLAGS) -o $(target) $(src_o)

%.o: %.c
	$(GCC) $(CFLAGS) -c $< -o $@

-include $(src_d)


.PHONY: clean_all clean

clean_all:
	@rm -rf $(main_target) $(test_target) bin \
    $(shell find . -name "*.o" 2>/dev/null) \
    $(shell find . -name "*.d" 2>/dev/null)

clean:
	@find . \( -name "*.o" -o -name "*.d" \) -delete
