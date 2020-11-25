########## External Variables
SHELL:=/bin/sh
NAME:=hello_world.dll

CXX:=g++

LIB_TARGET=$(build_dir)/$(NAME).dll

########## Project structure
src_dir:=src

vpath %.cpp $(src_dir)
vpath %.h $(src_dir) 

vpath %.sh tools

lib_src=src/hello.cpp src/string.cpp

# All srcs
all_src=$(lib_src)

build_dir:=build
compiledb_file:=compile_commands.json

########## Compiling 
CXXSTANDARD:=c++17

CFLAGS+=-I $(src_dir) 

CXXFLAGS:=$(CFLAGS)
CXXFLAGS+=-std=$(CXXSTANDARD)

########## Build
depflags=-MMD -MP -MF $(build_dir)/$*.d

vpath %.o build
vpath %.d build

########## Function
# Return .d files for source files
_dep=$(filter %.d,$(1:%.cpp=$(build_dir)/%.d) $(1:%.c=$(build_dir)/%.d))
dep=$(foreach f,$1 $2 $3 $4 $5 $6 $7 $8 $9,$(call _dep,$(f)))

# Return .o files for source files
_obj=$(filter %.o,$(1:%.cpp=$(build_dir)/%.o) $(1:%.c=$(build_dir)/%.o) $(1:%.res=$(build_dir)/%.o) $(1:%.rc=$(build_dir)/%.o))
obj=$(foreach f,$1 $2 $3 $4 $5 $6 $7 $8 $9,$(call _obj,$(f)))

green=@echo -e "$(GREEN)$(1)$(NC)"
red=@echo -e "$(RED)$(1)$(NC)"

########## Other variables
RM:=rm --recursive --force
MKDIR:=mkdir --parents
RMDIR:=rmdir --ignore-fail-on-non-empty --parent

GREEN:=\e[32m
RED:=\e[31m
NC:=\e[0m

,:=,

########## Rules
.PHONY=all
all: lib # format

.PHONY=lib
lib: $(compiledb_file) $(LIB_TARGET)

$(LIB_TARGET): $(call obj,$(lib_src) $(utl_src))
	$(call green,"Link $@")
	$(LINK.cpp) $(filter %.o,$^) $(LDLIBS) $(OUTPUT_OPTION)

$(build_dir)/%.o: %.cpp
	$(call green,"Compile $@ from $?")
	$(MKDIR) "$(dir $@)"
	$(COMPILE.cpp) $(depflags) $(OUTPUT_OPTION) $<

%.h:
	# Dummy target to make .h fils

include $(wildcard $(call dep,$(all_src)))

$(compiledb_file): compiledb.sh $(MAKEFILE_LIST)
	$<

.PHONY=clean
clean:
	$(call green,"Clean")
	$(RM) "$(build_dir)"
	$(RM) "$(compiledb_file)"

ifndef VERBOSE
.SILENT:
endif

