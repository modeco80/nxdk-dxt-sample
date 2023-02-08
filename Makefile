TOP = $(PWD)

BINDIR = bin
OBJDIR = obj

CC = nxdk-cc
CXX = nxdk-cxx
LD = nxdk-link



SLIMFLAGS = -Os -fno-stack-protector -fomit-frame-pointer -ffunction-sections -fdata-sections

CCFLAGS = $(SLIMFLAGS) -std=c99 -I$(TOP)/xbdm
CXXFLAGS = $(SLIMFLAGS) -std=c++20 -I$(TOP)/xbdm

LDFLAGS = -entry:DxtEntry -merge:.tls=.text -merge:.rdata=.data -align:32

DEPGEN = -MT $@ -MD -MP -MF $(OBJDIR)/$*.d

CDXT = $(PWD)/tools/cdxt

# Modify this section for your DXT

NAME = simple_dxt

VPATH = src/

OBJS = \
    $(OBJDIR)/main.o

LIBS = $(NXDK_DIR)/lib/xboxkrnl/libxboxkrnl.lib $(TOP)/xbdm/libxbdm.lib

.PHONY: all clean

all: $(TOP)/xbdm/libxbdm.lib tools/cdxt $(BINDIR)/ $(OBJDIR)/ $(BINDIR)/$(NAME).dxt

$(TOP)/xbdm/libxbdm.lib:
	make -C xbdm

tools/cdxt:
	make -C tools


$(BINDIR)/:
	mkdir -p $@

$(OBJDIR)/:
	mkdir -p $@

$(BINDIR)/$(NAME).dxt: $(OBJDIR)/$(NAME).exe
	$(info CDXT $@)
	$(CDXT) -OUT:$@ $<
	@llvm-strip --strip-unneeded "$@"

$(OBJDIR)/$(NAME).exe: $(OBJS)
	$(info LD $@)
	$(LD) $(LDFLAGS) $(LIBS) -out:'$@' $^

$(OBJDIR)/%.o: %.cpp
	$(info CXX $<)
	$(CXX) -c $< $(CXXFLAGS) $(DEPGEN) -o $@

$(OBJDIR)/%.o: %.c
	$(info CC $<)
	$(CC) -c $< $(CCFLAGS) $(DEPGEN) -o $@

clean:
	make -C xbdm clean
	make -C tools clean
	$(info Cleaning "$(BINDIR)/")
	$(RM) -r $(BINDIR)
	$(info Cleaning "$(OBJDIR)/")
	$(RM) -r $(OBJDIR)/*.o

# This completely removes bin and obj directories
hardclean: clean
	$(info Removing "$(OBJDIR)/")
	$(RM) -r $(OBJDIR)

# include dependencies
-include $(wildcard $(OBJDIR)/*.d)

# Little fun make trick! This will expand usually to
# ".SILENT:" which means make rules won't output commands
# but when V is set to anything, it will expand to
# something meaningless, allowing commands to output.
$V.SILENT:
