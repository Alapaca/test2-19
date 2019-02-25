#!/bin/bash  

interval=1
cpu_num=`cat /proc/stat | grep cpu[0-9] -c`
for((i=0;i<${cpu_num};i++))
{
    start=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    start_idle[$i]=$(echo ${start} | awk '{print $4}')
    start_total[$i]=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
}
start=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
start_idle[${cpu_num}]=$(echo ${start} | awk '{print $4}')
start_total[${cpu_num}]=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
sleep ${interval}
for((i=0;i<${cpu_num};i++))
{
    end=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
    end_idle=$(echo ${end} | awk '{print $4}')
    end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
    idle=`expr ${end_idle} - ${start_idle[$i]}`
    total=`expr ${end_total} - ${start_total[$i]}`
    idle_normal=`expr ${idle} \* 100`
    cpu_usage=`expr ${idle_normal} / ${total}`
    cpu_rate[$i]=`expr 100 - ${cpu_usage}`
}
end=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
end_idle=$(echo ${end} | awk '{print $4}')
end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
idle=`expr ${end_idle} - ${start_idle[$i]}`
total=`expr ${end_total} - ${start_total[$i]}`
idle_normal=`expr ${idle} \* 100`
cpu_usage=`expr ${idle_normal} / ${total}`
cpu_rate[${cpu_num}]=`expr 100 - ${cpu_usage}`
starttime=$(date +%Y_%m_%d__%H:%M:%S)
temp1=`cat /sys/class/thermal/thermal_zone0/temp`
temp=`echo "scale=2;$temp1/1000"|bc`
status="normal"
if [[ `echo "$temp>70"|bc` -eq 1 ]];then
    status="warning"
elif [[ `echo "$temp>50"|bc` -eq 1 ]];then
    status="note"
fi
echo $starttime `cat /proc/loadavg | cut -d ' ' -f 1-3` "${cpu_rate[${cpu_num}]}" $temp $status
