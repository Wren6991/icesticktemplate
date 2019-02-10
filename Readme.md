Template for icestick projects
==============================

At some point I'll pull things in properly through submodules etc

Useful Makefiles
----------------

`synth/Makefile`

```
make synth -- run logic synthesis
make pnr -- run place and route (and synthesis if necessary)
make bit -- generate bitstream (and run pnr if necessary)
make prog -- program bitstream into device (and generate it first if necessary)
make clean -- clean up generated files

Synthesis and PnR logs can be found at synth.log and pnr.log
```

`test/fpga/Makefile`

```
make gui -- Build simulator and run it with waveform viewer
make sim -- Build and run simulator without waveform gui
make clean -- clean up generated files
```

Source Files
------------

 - `hdl/`: all HDL (hardware description language) source files
 - `hdl/fpga`: files for top-level module
 - `hdl/fpga/fpga.v`: top-level wrapper file
 - `hdl/fpga/fpga.f`: top-level dependency file
 - `hdl/common/blinky.v` blinky logic
 - `test/fpga/tb.v`: Testbench for simulation
 - `test/fpga/tb.v`: Dependency file for simulation

A note on .f files
------------------

These are used for describing file dependency lists. The resulting tree is processed into a flat file list. They consist of the following commands

```
file (filename)
    adds a file to the list
include (dir)
	add a directory to include path, if output format supports this
wildcard (.extension) (dir)
    add all files with a given extension in a given directory
list (filename)
    recurse on another filelist file
```

The tool `scripts/listfiles` processes these into various formats required by different tools, e.g. Xilinx project files.
