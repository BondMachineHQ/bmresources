WORKING_DIR=working_dir
CURRENT_DIR=$(shell pwd)
SOURCE_NEURALBOND=banknote.json
NEURALBOND_LIBRARY=neurons
BOARD=ebaz4205
MAPFILE=ebaz4205_maps.json
SHOWARGS=-dot-detail 5
SHOWRENDERER=dot
VERILOG_OPTIONS=-comment-verilog
DBASM_ARGS=-d
BENCHCORE=i0,p22o0
#HDL_REGRESSION=bondmachine.sv
#BM_REGRESSION=bondmachine.json
include bmapi.mk
include crosscompile.mk
include buildroot.mk
