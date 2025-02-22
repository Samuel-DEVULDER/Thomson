# Common Tecmake definitions for Lua 5.2

SFX = 52
PROJNAME = lua$(SFX)
OPT = Yes           # Turn optimization on
USE_NODEPEND = Yes  # Disable dependencies
NO_SCRIPTS = Yes    # Disable scripts and batch files creation
NO_DYNAMIC = no     # Build also dynamic libraries with gcc in Windows

DEFINES = 
                          
# All non-Windows (posix)                         
ifeq ($(findstring Win, $(TEC_SYSNAME)), )
  DEFINES += LUA_USE_POSIX
  
  # MacOS X
	ifneq ($(findstring Darwin, $(TEC_UNAME)), )
	  DEFINES += LUA_DL_DYLD
	else
	  DEFINES += LUA_USE_DLOPEN
	endif
	
	# Linux Only
	ifneq ($(findstring Linux, $(TEC_UNAME)), )
	  DEFINES += LUA_USE_READLINE
	endif
	
	# BSD Only
	ifneq ($(findstring BSD, $(TEC_UNAME)), )
	  DEFINES += LUA_USE_READLINE
	endif
endif


# For Executables only
ifdef APPNAME
  # Disable strip
  STRIP = 
  
  APPTYPE = console

  ifneq ($(findstring Win, $(TEC_SYSNAME)), )
    # In Windows, use the Dynamic Libraries
    USE_DLL = Yes
    LIBS += lua$(SFX)
    
    ifneq ($(findstring mingw4, $(TEC_UNAME)), )
      LDIR += ../lib/dllw4
    else 
    ifneq ($(findstring cygw, $(TEC_UNAME)), )
  	  DEFINES += LUA_USE_READLINE
      LIBS += lua$(SFX)
      LDIR += ../lib/$(TEC_UNAME)   
      LDFLAGS = -s
    else
      SLIB += setargv.obj
      ifeq "$(TEC_SYSNAME)" "Win32"
        LDIR += ../lib/dll9
      else
        LDIR += ../lib/dll9_64
      endif
    endif
    endif
  else
    #UNIX Use Static Libraries
    SLIB += ../lib/$(TEC_UNAME)/liblua$(SFX).a
  endif
  
  ifneq ($(findstring Linux, $(TEC_UNAME)), )
    LIBS += dl 
    LFLAGS = -Wl,-E
    LIBS += readline history curses ncurses
  endif
  
  ifneq ($(findstring BSD, $(TEC_UNAME)), )
    LFLAGS = -Wl,-E
    LIBS += readline history curses ncurses
  endif
  
  ifneq ($(findstring SunOS, $(TEC_UNAME)), )
    LIBS += dl 
  endif
  
  ifneq ($(findstring cygw, $(TEC_UNAME)), )
    LIBS += readline history
  endif
endif
