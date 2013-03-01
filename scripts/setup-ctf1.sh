#!/bin/sh -e
#
# File:
# Purpose:
#

cd $(dirname "$0"); . ./common.sh; cd ..

for i in $ctf1/code/level*; do
    test -f $i/Makefile && (cd $i; make)
done

for i in $ctf1_extra/home/level*; do
    test -f $i/Makefile && (cd $i; make)
done

create_users0=/tmp/create-users.sh
create_users=$extract$create_users0
for i in 1 2 3 4 5 6; do
    pass=pass$i
    echo "# level0$i"
    echo "adduser -s /bin/sh -u 110$i -D level0$i"
    echo "echo level0$i:$pass | chpasswd --md5"
    echo "echo $pass > /home/level0$i/.password"
    echo
done | tee $create_users

chmod 755 $create_users
sudo chroot $extract $create_users0
sudo rm $create_users

sudo rsync -av $ctf1/code/level0? $extract/home/
sudo rsync -av $ctf1_extra/home/level0? $extract/home/ --exclude level01.c

sudo chmod 0755 $extract/home/level0?
sudo chmod 0400 $extract/home/level0?/.password

for i in 1 2 3 4 5 6; do
    sudo chown -R 110$i.110$i $extract/home/level0$i
    j=$((i+1))
    sudo chown 110$j.110$j $extract/home/level0$i/level0$i
    sudo chmod u+s $extract/home/level0$i/level0$i
done

# eof
