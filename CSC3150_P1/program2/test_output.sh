gcc test.c -o test
make clean
make
sudo insmod program2.ko
sudo rmmod program2.ko
sudo dmesg -c