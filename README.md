# QuartusCLI

Quartus command line tool on WSL. This script works in WSL bash. 3 different Quartus tools are executed by the argument.

1. Quartus GUI launch(argument is none or project name)
2. Compilation(argument is `sh`)
3. Simulation(argument is `sim`)

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

### note

`$quaruts_bin` specifies Quartus installation directory. e.g. Quartus Prime 18.0 is `intelFPGA_lite/18.0/quartus/bin64`.

## License

MIT License

## Author

[toms74209200](<https://github.com/toms74209200>)