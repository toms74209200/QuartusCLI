#!/bin/bash
#------------------------------------------------------------------------------
# quartus
# Quartus command line tool on WSL
# 
# Copyright (c) 2019 toms74209200
# 
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------

quartus_bin="<Quartus installation directory>"

# Function ####################################################################

function find_project() {
    project=$(find -name "*.qpf" -printf '%f\n' | sed 's/\.[^\.]*$//' | head -1)
}

function make_archive() {
    mkdir -p ./archive/$qar_dir
    $quartus_bin/quartus_sh.exe --archive -output ./archive/$qar_dir/$qar_dir $project
    mkdir -p ./archive/$qar_dir/src
    find -name "*.vhd"  | xargs -I% cp % ./archive/$qar_dir/src/
    find -name "*.v"    | xargs -I% cp % ./archive/$qar_dir/src/
    find -name "*.bdf"  | xargs -I% cp % ./archive/$qar_dir/src/
    find -name "*.bsf"  | xargs -I% cp % ./archive/$qar_dir/src/
    find -name "*.qip"  | xargs -I% cp % ./archive/$qar_dir/src/
    find -name "*.qsys" | xargs -I% cp % ./archive/$qar_dir/src/
    mkdir -p ./archive/$qar_dir/program_files
    find -name "*.sof" | xargs -I% cp % ./archive/$qar_dir/program_files/${project}.sof
    find -name "*.pof" | xargs -I% cp % ./archive/$qar_dir/program_files/${project}.sof
    find -name "*.jic" | xargs -I% cp % ./archive/$qar_dir/program_files/${project}.sof
}

# Main script #################################################################

if [ $# = 0 ]; then
    if [ -f *.qpf ]; then
        find_project
        $quartus_bin/quartus.exe $project &
    else
        $quartus_bin/quartus.exe &
    fi
elif [ $# = 1 ]; then
    if [ $1 = "sh" ]; then
        if [ -f  *.qpf ]; then
            find_project
            $quartus_bin/quartus_sh.exe --flow compile $project
        else
            echo "Project is not found."
        fi
    elif [ $1 = "sim" ]; then
        if [ -f  *.qpf ]; then
            find_project
            $quartus_bin/quartus_sim.exe $project
        else
            echo "Project is not found."
        fi
    elif [ $1 = "qar" ]; then
        if [ -f  *.qpf ]; then
            find_project
            today=$(date "+%y%m%d")
            qar_dir="${project}_${today}"
            make_archive
        fi
    elif [ $1 = "mk" ]; then
        echo "Project name is unspecified."
    else
        if [ -f $1.qpf ]; then
            $quartus_bin/quartus.exe $1 &
        else
            echo "Project is not found."
        fi
    fi
elif [ $# = 2 ]; then
    if [ $1 = "sh" ]; then
        if [ -f $2.qpf ]; then
            $quartus_bin/quartus_sh.exe --flow compile $2
        else
            echo "Project is not found."
        fi
    elif [ $1 = "sim" ]; then
        if [ -f $2.qpf ]; then
            $quartus_bin/quartus_sim.exe $2
        else
            echo "Project is not found."
        fi
    elif [ $1 = "qar" ]; then
        if [ -f $2.qpf ]; then
            project="$2"
            today=$(date "+%y%m%d")
            qar_dir="$2_${today}"
            make_archive
        else
            find_project
            today=$(date "+%y%m%d")
            qar_dir="${project}_$2_${today}"
            make_archive
        fi
    elif [ $1 = "mk" ]; then
        $quartus_bin/quartus_sh.exe --tcl_eval project_new $2
        echo >> $2.qsf
        echo set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files >> $2.qsf
        find -name "*.vhd" | xargs -I% echo set_global_assignment -name VHDL_FILE % >> $2.qsf
        find -name "*.v"   | xargs -I% echo set_global_assignment -name VERILOG_FILE % >> $2.qsf
        find -name "*.bdf" | xargs -I% echo set_global_assignment -name BDF_FILE % >> $2.qsf
    else
        echo "Invalid argument"
    fi
fi

