<h1>Todo list</h1>

<h3>Assignment list</h3>

- [ ] Assignment 1 due: 10-19
- [ ] Assignment 2 due:
- [ ] Assignment 3 due:
- [ ] Assignment 4 due:
- [ ] Assignment 5 due:

<h3>Learning Process</h3>

- [ ] Chapter 1
- [ ] NJU video P1-P4


<h3>Today<h3>



<h1>CSC3150 Note</h1>

<h3>Chapter 1</h3>

1. 把操作系统当作是kernel，一个一直运行在计算机上的程序
2. bootstrap program: 位于计算机固件(firmware), 用来初始化所有硬件设备并启动操作系统
   1. ROM: read-only memory, 一种只读存储器，一旦写入就不能修改
   2. EPROM: erasable programmable ROM, 可擦写可编程ROM
3. local buffer: 位于I/O设备和CPU之间，用来缓存数据
4. interrupt: 用来处理I/O设备的一种机制，当I/O设备准备好数据时，会发送一个中断信号给CPU，CPU会暂停当前的工作，转而去处理I/O设备的数据
5. types of interrupt:
   1. polling interrupt: CPU不断地去轮询I/O设备，看是否有数据准备好了
   2. vectored interrupt: I/O设备准备好数据后，会发送一个中断信号给CPU，CPU会根据中断号从中断向量表中找到对应的中断处理程序的地址，然后跳转到该地址去执行中断处理程序
6. I/O structure:
   1. synchronous I/O: CPU会等待I/O设备完成数据的读写，然后再去做其他的事情。只允许同时进行一个I/O操作。
   2. asynchronous I/O: CPU不会等待I/O设备完成数据的读写，而是直接去做其他的事情，当I/O设备完成数据的读写后，会发送一个中断信号给CPU，CPU会暂停当前的工作，转而去处理I/O设备的数据
7. Storage structure:
   1. main memory: 用来存储程序和数据，是易失性的，断电后数据会丢失
   2. secondary storage: 用来存储程序和数据，是非易失性的，断电后数据不会丢失
   3. cache: 位于CPU和主存之间，用来缓存主存中的数据，是易失性的，断电后数据会丢失
   4. magnetic disk: 位于主存和磁带之间，用来存储程序和数据，是非易失性的，断电后数据不会丢失
   5. optical disk: 位于磁盘和磁带之间，用来存储程序和数据，是非易失性的，断电后数据不会丢失
   6. magnetic tape: 用来存储程序和数据，是非易失性的，断电后数据不会丢失