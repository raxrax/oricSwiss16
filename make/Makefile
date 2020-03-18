#)              _
#)  ___ ___ _ _|_|___ ___
#) |  _| .'|_'_| |_ -|_ -|
#) |_| |__,|_,_|_|___|___|
#)    raxiss (c) 2019,2020

PROJECT                 := swiss16-demo
PROJECT_DIR             := $(shell pwd)
PROJECT_LABEL           := swiss16-demo

# # # Only for FlopyBuilder
# PROJECT_DSK           := $(PROJECT).dsk

# # # Autorun main project file
PROJECT_AUTORUN         := 1

# # # Leave DOS
PROJECT_QUITDOS         := 1

# # # 6502, 65816
CPU                     := 6502

# # # Toolchain OSDK or CC65
TOOLCHAIN               := OSDK

# # #
START_ADDRESS           := $(shell echo $$((0x1000)))

PICTURES                := pic_0 pic_1 pic_2 pic_3 pic_4 pic_5 pic_6 pic_7 pic_8

ATAPS                   := $(PROJECT)
BTAPS                   :=
CTAPS                   :=
OTAPS                   :=

TAPS                    := $(addsuffix .tap,$(ATAPS) $(BTAPS) $(CTAPS) $(OTAPS))

#

$(PROJECT)_SRC          := sw16.s swiss16.s lzfh6502.s $(addsuffix .s,$(PICTURES))
$(PROJECT)_AUTORUN      := 1
$(PROJECT)_ADDRESS      := $(START_ADDRESS)
$(PROJECT)_ACPP         := 1

#
include Makefile.local

OSDK                    := $(OSDK_DIR)
OSDK_OPT                := 0
CC65                    := $(CC65_DIR)
CC65_ALIGNED            := 0

EMU                     := ./oricutron
EMUDIR                  := $(EMUL_DIR)
EMUARG                  := -ma
EMUARG                  += --serial none
EMUARG                  += --vsynchack off
EMUARG                  += -s $(PROJECT_DIR)/$(PROJECT).sym
EMUARG                  += -r :$(PROJECT_DIR)/$(PROJECT).brk
EMUARG                  += #-r $(START_ADDRESS)

SRC                     := ../src/
LIBS                    := ../libs/
PICS                    := ../res/pics/

VPATH                   := $(VPATH) $(LIBS) $(SRC) $(PICS)

PREPARE                 := prepare
FINALIZE                := finalize

#
include $($(TOOLCHAIN))/atmos.make

AFLAGS                  += $(addprefix -I,$(VPATH))
AFLAGS                  += -DASSEMBLER
AFLAGS                  += -DSTART_ADDRESS=$(START_ADDRESS)

CFLAGS                  += $(addprefix -I,$(VPATH))
CFLAGS                  += -DSTART_ADDRESS=$(START_ADDRESS)

# $(PROJECT)_AFLAGS       +=
# $(PROJECT)_CFLAGS       +=
# $(PROJECT)_LFLAGS       +=

TEMP_FILES              +=

prepare: #res
	@echo "Building with $(TOOLCHAIN)..."

finalize: #hxc
	@([ -e $(PROJECT).brk ] || touch $(PROJECT).brk) || echo -n
	@echo   "[NFO]   ------------------------------"
	@printf "[MEM]   $(PROJECT)  : #%.4X .. #%.4X\\n" $$(($(START_ADDRESS))) $$(expr `cat $(PROJECT) | wc -c` + $$(($(START_ADDRESS))))
	@echo   "[CRC]   $$(crc32 $(PROJECT))"


.PHONY: res pictures show showtap

res: pictures

pictures:
	@make -C res/pics all

show: $(PROJECT).dsk
	$(Q) [ -f "$(PWD)/$(PROJECT).dsk" ] && cd $(EMUDIR) && $(EMU) $(EMUARG) "$(PWD)/$(PROJECT).dsk" $(EMUPARAM)

showtap: $(PROJECT).tap
	$(Q) [ -f "$(PWD)/$(PROJECT).tap" ] && cd $(EMUDIR) && $(EMU) $(EMUARG) "$(PWD)/$(PROJECT).tap" $(EMUPARAM)

