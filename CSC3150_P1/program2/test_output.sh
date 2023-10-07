cd /home/seed/csc3150_toby/CSC3150_P1/program2
gcc test.c -o test
make clean
make
sudo insmod program2.ko
sudo rmmod program2.ko
sudo dmesg -c