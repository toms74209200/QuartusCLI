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
    project=$(find -maxdepth 1 -name "*.qpf" -printf '%f\n' | head -1)
}

function make_archive() {
    mkdir -p ./archive/$qar_dir
    $quartus_bin/quartus_sh.exe --archive -output ./archive/$qar_dir/$qar_dir ${project%.*}
    mkdir -p ./archive/$qar_dir/src
    cp -rp ./src ./archive/$qar_dir/
    find -maxdepth 1 -name "*.qsf"  | xargs -I% cp % ./archive/$qar_dir/
    find -maxdepth 1 -name "*.qpf"  | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.vhd"  | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.v"    | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.bdf"  | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.bsf"  | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.qip"  | xargs -I% cp % ./archive/$qar_dir/
    # find -maxdepth 1 -name "*.qsys" | xargs -I% cp % ./archive/$qar_dir/
    mkdir -p ./archive/$qar_dir/program_files
    find -name "*.sof" | xargs -I% cp % ./archive/$qar_dir/program_files/${project%.*}.sof
    find -name "*.pof" | xargs -I% cp % ./archive/$qar_dir/program_files/${project%.*}.sof
    find -name "*.jic" | xargs -I% cp % ./archive/$qar_dir/program_files/${project%.*}.sof
}

# Main script #################################################################

if [ $# = 0 ]; then
    if [ -f *.qpf ]; then
        find_project
        $quartus_bin/quartus.exe ${project%.*} &
    else
        $quartus_bin/quartus.exe &
    fi
elif [ $# = 1 ]; then
    if [ $1 = "sh" ]; then
        if [ -f *.qpf ]; then
            find_project
            $quartus_bin/quartus_sh.exe --flow compile ${project%.*}
        else
            echo "Project is not found."
        fi
    elif [ $1 = "sim" ]; then
        if [ -f  *.qpf ]; then
            find_project
            $quartus_bin/quartus_sh.exe -t $nativelink_dir/qnativesim.tcl --rtl_sim ${project%.*} ${project%.*} &
        else
            echo "Project is not found."
        fi
    elif [ $1 = "qar" ]; then
        if [ -f *.qpf ]; then
            find_project
            today=$(date "+%y%m%d")
            qar_dir="${project%.*}_${today}"
            make_archive
        fi
    elif [ $1 = "mk" ]; then
        echo "Project name is unspecified."
    elif [ $1 = "bs" ]; then
        if [ -f *.qpf ]; then
            find_project
            find -name "*.vhd" | xargs -I% $quartus_bin/quartus_map.exe --read_settings_files=on --write_settings_files=off ${project%.*} -c ${project%.*} --generate_symbol=%
        else
            echo "Project is not found."
        fi
    elif [ $1 = "map" ]; then
        if [ -f *.qpf ]; then
            find_project
            $quartus_bin/quartus_map.exe ${project%.*}
        else
            echo "Project is not found."
        fi
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
            qar_dir="${project%.*}_$2_${today}"
            make_archive
        fi
    elif [ $1 = "map" ]; then
        if [ -f $2.qpf ]; then
            $quartus_bin/quartus_map.exe $2
        else
            echo "Project is not found."
        fi
    elif [ $1 = "mk" ]; then
        project=$2
        make_project
    elif [ $1 = "bs" ]; then
        if [ -f $2.qpf ]; then
            find -name "*.vhd" | xargs -I% $quartus_bin/quartus_map.exe --read_settings_files=on --write_settings_files=off $2 -c $2 --generate_symbol=%
        elif [ -f *.qpf ]; then
            find_project
            $quartus_bin/quartus_map.exe --read_settings_files=on --write_settings_files=off ${project%.*} -c ${project%.*} --generate_symbol=$2
        else
            echo "Project is not found."
        fi
    else
        echo "Invalid argument"
    fi
fi

