#!/bin/bash

root_dir="/home/big-dama/pavol/mawi_feature_extraction/"


# SPLIT
for filename in $root_dir/20*
do
        # get filename from "fullpath filename":
        #https://stackoverflow.com/questions/22727107/how-to-find-the-last-field-using-cut/22727211
        file=$filename | rev | cut -d'/' -f 1 | rev
        # original -i 1, for darknet 60s
        editcap -i 1 $filename "$root_dir/splitted/$file"
        echo $file
        #rm $filename
#done

# EXTRACT
for filename in $root_dir/splitted/_0*
do
        SUBSTRING=$(echo $filename | rev | cut -d'/' -f 1 | rev | cut -d'_' -f 3)
        echo $SUBSTRING
        tshark -T fields -n -r $filename -E aggregator=, -e frame.time -e frame.len -e ip.proto -e ip.len -e ip.ttl -e ip.version -e ip.flags -e ip.flags.mf -e ip.frag_offset -e ip.src -e ip.dst -e icmp.type -e icmp.code -e tcp.dstport -e tcp.srcport -e tcp.flags -e tcp.flags.ack -e tcp.flags.cwr -e tcp.flags.fin -e tcp.flags.ecn -e tcp.flags.ns -e tcp.flags.push -e tcp.flags.syn -e tcp.flags.urg -e tcp.flags.reset -e tcp.len -e tcp.window_size -e udp.srcport -e udp.dstport > $root_dir/splitted/extracted/$SUBSTRING
done

# COPY TO HDFS

hdfs_dir="/user/big-dama/pavol/mawi_data_052016/extracted_mawi_052016/"
#hdfs dfs -mkdir -p $hdfs_dir
for filename in $root_dir/splitted/extracted/*
do
        echo $filename
        hdfs dfs -copyFromLocal $filename $hdfs_dir
        #rm $filename

done

