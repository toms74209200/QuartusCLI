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

if [ $# = 0 ]; then
    if [ -f *.qpf ]; then
        find -name *.qpf -printf '%f\n' | sed 's/\.[^\.]*$//' | xargs -I% $quartus_bin/quartus.exe % &
    else
        $quartus_bin/quartus.exe &
    fi
elif [ $# = 1 ]; then
    if [ $1 = "sh" ]; then
        if [ -f *.qpf ]; then
            find -name *.qpf -printf '%f\n' | sed 's/\.[^\.]*$//' | xargs -I% $quartus_bin/quartus_sh.exe --flow compile %
        else
            echo "Project is not found."
        fi
    elif [ $1 = "sim" ]; then
        if [ -f *.qpf ]; then
            find -name *.qpf -printf '%f\n' | sed 's/\.[^\.]*$//' | xargs -I% $quartus_bin/quartus_sim.exe %
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
    else
        echo "Invalid argument"
    fi
fi