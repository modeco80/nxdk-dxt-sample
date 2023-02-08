libxbdm.lib: xbdm.dll.def
	llvm-dlltool -d "$<" -m i386 -l "$@" -k -f=-s

clean:
	rm -f libxbdm.lib
