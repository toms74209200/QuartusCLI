# QuartusCLI

Quartus command line tool on WSL. This script works in WSL bash. 5 different Quartus tools are executed by the argument.

1. Quartus GUI launch(argument is none or project name)
1. Compilation(argument is `sh`)
1. Simulation(argument is `sim`)
1. Make project(argument is `mk`)
1. Archive project(argument is `qar`)

### e.g.

#### 1.

```bash
$ quartus.sh
```

Quartus GUI is launch.

```bash
$ quartus.sh PROJECT
```

Quartus GUI is launch and PROJECT.qpf opens.

#### 2.

```bash
$ quartus.sh sh
Info: *******************************************************************
Info: Running Quartus Prime Shell
~
Info: Command: quartus_sh --flow compile PROJECT
Info: Quartus(args): compile PROJECT
~
```

Compilation of current directory project starts.

```bash
$ quartus.sh sh PROJECT
Info: *******************************************************************
Info: Running Quartus Prime Shell
~
Info: Command: quartus_sh --flow compile PROJECT
Info: Quartus(args): compile PROJECT
~
```

Compilation of project that is specified by the argument starts.

#### 3.

It works similarly argument `sh`.

#### 4.

```bash
$ quartus.sh mk PROJECT
```

Quartus project is made. Source files(VHDL`.vhd`, Verilog HDL`.v`, Block Diagram/Schematic File`.bdf`) are added in project.

#### 5.

```bash
$ quartus.sh qar REV
Info: *******************************************************************
Info: Running Quartus Prime Shell
~
Info: Command: quartus_sh --archive -output ./archive/PROJECT_REV_YYMMDD/PROJECT_REV_YYMMDD PROJECT
Info: Quartus(args): -qar -output ./archive/PROJECT_REV_YYMMDD/PROJECT_REV_YYMMDD PROJECT
```

Archive project. `.qar` file is put in `./archive` directory. The below source files list are copied in `./archive/src` directory.

- VHDL(`.vhd`)
- Verilog HDL(`.v`)
- Block Diagram/Schematic File(`.bdf`)
- Block Symbol FIle(`bsf`)
- Quartus IP file(`.qip`)
- Qsys design file(`.qsys`)

 Programing files(`.sof`, `.pof`, `.jic`) are also copied `./archive/output_files` directory.

### note

`$quaruts_bin` specifies Quartus installation directory. e.g. Quartus Prime 18.0 is `intelFPGA_lite/18.0/quartus/bin64`.

## License

MIT License

## Author

[toms74209200](<https://github.com/toms74209200>)