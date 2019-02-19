#!/bin/bash


function findfile(){
    ans=(0 0 0)
    str=(0 0 0)
    dir=(0 0 0)
    for i in `find -type f`; do
        file $i | grep text 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
            continue
        fi
            for j in `cat $i|tr -c 'a-zA-Z0-9' " "`; do
                if [[ ${#j} -gt ${ans[0]} ]]; then
                    ans[2]=${ans[1]}
                    str[2]=${str[1]}
                    dir[2]=${dir[1]}

                    ans[1]=${ans[0]}
                    str[1]=${ans[0]}
                    dir[1]=${dir[0]}

                    ans[0]=${#j}
                    str[0]=$j
                    dir[0]=$i
                    elif [[ ${#j} -gt ${ans[1]} ]]; then
                        ans[2]=${ans[1]}
                        str[2]=${str[1]}
                        dir[2]=${dir[1]}

                        ans[1]=${#j}
                        str[1]=$j
                        dir[1]=$i
                    elif [[ ${#j} -gt ${ans[2]} ]]; then
                        ans[2]=${#j}
                        str[2]=$j
                        dir[2]=$i
                fi
            done
    done
    echo 1 ${str[0]}:${ans[0]} ${dir[0]}
    echo 2 ${str[1]}:${ans[1]} ${dir[1]}
    echo 3 ${str[2]}:${ans[2]} ${dir[2]}
}

findfile
