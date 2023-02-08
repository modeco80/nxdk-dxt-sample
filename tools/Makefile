
CDXT_SOURCES = \
    Cdxt.cpp \
    $(NXDK_DIR)/tools/cxbe/Common.cpp \
    $(NXDK_DIR)/tools/cxbe/Error.cpp \
    $(NXDK_DIR)/tools/cxbe/Exe.cpp \
    $(NXDK_DIR)/tools/cxbe/Logo.cpp \
    $(NXDK_DIR)/tools/cxbe/Xbe.cpp

all: cdxt

cdxt: $(CDXT_SOURCES)
	$(CXX) -I$(NXDK_DIR)/tools/cxbe $(CDXT_SOURCES) -o $@

clean: 
	rm -f cdxt
