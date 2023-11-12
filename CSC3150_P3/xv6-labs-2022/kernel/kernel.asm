
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00026117          	auipc	sp,0x26
    80000004:	ca010113          	addi	sp,sp,-864 # 80025ca0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	329050ef          	jal	ra,80005b3e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002e797          	auipc	a5,0x2e
    80000034:	d7078793          	addi	a5,a5,-656 # 8002dda0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8e090913          	addi	s2,s2,-1824 # 80008930 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	4d0080e7          	jalr	1232(ra) # 8000652a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	570080e7          	jalr	1392(ra) # 800065de <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	f64080e7          	jalr	-156(ra) # 80005fee <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	84450513          	addi	a0,a0,-1980 # 80008930 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3a6080e7          	jalr	934(ra) # 8000649a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	ca050513          	addi	a0,a0,-864 # 8002dda0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	80e48493          	addi	s1,s1,-2034 # 80008930 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	3fe080e7          	jalr	1022(ra) # 8000652a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7f650513          	addi	a0,a0,2038 # 80008930 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	49a080e7          	jalr	1178(ra) # 800065de <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7ca50513          	addi	a0,a0,1994 # 80008930 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	470080e7          	jalr	1136(ra) # 800065de <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if (cpuid() == 0)
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	ae6080e7          	jalr	-1306(ra) # 80000e0c <cpuid>
    __sync_synchronize();
    started = 1;
  }
  else
  {
    while (started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5d270713          	addi	a4,a4,1490 # 80008900 <started>
  if (cpuid() == 0)
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while (started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	aca080e7          	jalr	-1334(ra) # 80000e0c <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	ce4080e7          	jalr	-796(ra) # 80006038 <printf>
    kvminithart();  // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	772080e7          	jalr	1906(ra) # 80001ad6 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	184080e7          	jalr	388(ra) # 800054f0 <plicinithart>
  }

  scheduler();
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fba080e7          	jalr	-70(ra) # 8000132e <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	b84080e7          	jalr	-1148(ra) # 80005f00 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	e94080e7          	jalr	-364(ra) # 80006218 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	ca4080e7          	jalr	-860(ra) # 80006038 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	c94080e7          	jalr	-876(ra) # 80006038 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	c84080e7          	jalr	-892(ra) # 80006038 <printf>
    kinit();            // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();          // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();      // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();         // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	984080e7          	jalr	-1660(ra) # 80000d58 <procinit>
    trapinit();         // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6d2080e7          	jalr	1746(ra) # 80001aae <trapinit>
    trapinithart();     // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6f2080e7          	jalr	1778(ra) # 80001ad6 <trapinithart>
    plicinit();         // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	0ee080e7          	jalr	238(ra) # 800054da <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	0fc080e7          	jalr	252(ra) # 800054f0 <plicinithart>
    binit();            // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f20080e7          	jalr	-224(ra) # 8000231c <binit>
    iinit();            // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5c6080e7          	jalr	1478(ra) # 800029ca <iinit>
    fileinit();         // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	568080e7          	jalr	1384(ra) # 80003974 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	1e4080e7          	jalr	484(ra) # 800055f8 <virtio_disk_init>
    userinit();         // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cf4080e7          	jalr	-780(ra) # 80001110 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4cf72b23          	sw	a5,1238(a4) # 80008900 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	4ca7b783          	ld	a5,1226(a5) # 80008908 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	b64080e7          	jalr	-1180(ra) # 80005fee <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	77fd                	lui	a5,0xfffff
    80000562:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000566:	15fd                	addi	a1,a1,-1
    80000568:	00c589b3          	add	s3,a1,a2
    8000056c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000570:	8952                	mv	s2,s4
    80000572:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00006097          	auipc	ra,0x6
    800005b4:	a3e080e7          	jalr	-1474(ra) # 80005fee <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	a2e080e7          	jalr	-1490(ra) # 80005fee <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00006097          	auipc	ra,0x6
    80000610:	9e2080e7          	jalr	-1566(ra) # 80005fee <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	af8080e7          	jalr	-1288(ra) # 80000118 <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4a080e7          	jalr	-1206(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	5ee080e7          	jalr	1518(ra) # 80000cc2 <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	20a7b723          	sd	a0,526(a5) # 80008908 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
        // if (do_free == -1)
          continue;
        // else
        //   panic("uvmunmap: not mapped");
      }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6a85                	lui	s5,0x1
    80000736:	0535ea63          	bltu	a1,s3,8000078a <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00006097          	auipc	ra,0x6
    8000075c:	896080e7          	jalr	-1898(ra) # 80005fee <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	886080e7          	jalr	-1914(ra) # 80005fee <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00006097          	auipc	ra,0x6
    8000077c:	876080e7          	jalr	-1930(ra) # 80005fee <panic>
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	9956                	add	s2,s2,s5
    80000786:	fb397ae3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	ccc080e7          	jalr	-820(ra) # 8000045c <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d179                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    8000079c:	611c                	ld	a5,0(a0)
    8000079e:	0017f713          	andi	a4,a5,1
    800007a2:	d36d                	beqz	a4,80000784 <uvmunmap+0x7a>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff7f713          	andi	a4,a5,1023
    800007a8:	fd7704e3          	beq	a4,s7,80000770 <uvmunmap+0x66>
    if(do_free){
    800007ac:	fc0b0ae3          	beqz	s6,80000780 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800007b0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007b2:	00c79513          	slli	a0,a5,0xc
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	866080e7          	jalr	-1946(ra) # 8000001c <kfree>
    800007be:	b7c9                	j	80000780 <uvmunmap+0x76>

00000000800007c0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c0:	1101                	addi	sp,sp,-32
    800007c2:	ec06                	sd	ra,24(sp)
    800007c4:	e822                	sd	s0,16(sp)
    800007c6:	e426                	sd	s1,8(sp)
    800007c8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	94e080e7          	jalr	-1714(ra) # 80000118 <kalloc>
    800007d2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d4:	c519                	beqz	a0,800007e2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007d6:	6605                	lui	a2,0x1
    800007d8:	4581                	li	a1,0
    800007da:	00000097          	auipc	ra,0x0
    800007de:	99e080e7          	jalr	-1634(ra) # 80000178 <memset>
  return pagetable;
}
    800007e2:	8526                	mv	a0,s1
    800007e4:	60e2                	ld	ra,24(sp)
    800007e6:	6442                	ld	s0,16(sp)
    800007e8:	64a2                	ld	s1,8(sp)
    800007ea:	6105                	addi	sp,sp,32
    800007ec:	8082                	ret

00000000800007ee <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007ee:	7179                	addi	sp,sp,-48
    800007f0:	f406                	sd	ra,40(sp)
    800007f2:	f022                	sd	s0,32(sp)
    800007f4:	ec26                	sd	s1,24(sp)
    800007f6:	e84a                	sd	s2,16(sp)
    800007f8:	e44e                	sd	s3,8(sp)
    800007fa:	e052                	sd	s4,0(sp)
    800007fc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800007fe:	6785                	lui	a5,0x1
    80000800:	04f67863          	bgeu	a2,a5,80000850 <uvmfirst+0x62>
    80000804:	8a2a                	mv	s4,a0
    80000806:	89ae                	mv	s3,a1
    80000808:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	90e080e7          	jalr	-1778(ra) # 80000118 <kalloc>
    80000812:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000814:	6605                	lui	a2,0x1
    80000816:	4581                	li	a1,0
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	960080e7          	jalr	-1696(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000820:	4779                	li	a4,30
    80000822:	86ca                	mv	a3,s2
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	8552                	mv	a0,s4
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	d1a080e7          	jalr	-742(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000832:	8626                	mv	a2,s1
    80000834:	85ce                	mv	a1,s3
    80000836:	854a                	mv	a0,s2
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	99c080e7          	jalr	-1636(ra) # 800001d4 <memmove>
}
    80000840:	70a2                	ld	ra,40(sp)
    80000842:	7402                	ld	s0,32(sp)
    80000844:	64e2                	ld	s1,24(sp)
    80000846:	6942                	ld	s2,16(sp)
    80000848:	69a2                	ld	s3,8(sp)
    8000084a:	6a02                	ld	s4,0(sp)
    8000084c:	6145                	addi	sp,sp,48
    8000084e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000850:	00008517          	auipc	a0,0x8
    80000854:	87050513          	addi	a0,a0,-1936 # 800080c0 <etext+0xc0>
    80000858:	00005097          	auipc	ra,0x5
    8000085c:	796080e7          	jalr	1942(ra) # 80005fee <panic>

0000000080000860 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000860:	1101                	addi	sp,sp,-32
    80000862:	ec06                	sd	ra,24(sp)
    80000864:	e822                	sd	s0,16(sp)
    80000866:	e426                	sd	s1,8(sp)
    80000868:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000086a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000086c:	00b67d63          	bgeu	a2,a1,80000886 <uvmdealloc+0x26>
    80000870:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000872:	6785                	lui	a5,0x1
    80000874:	17fd                	addi	a5,a5,-1
    80000876:	00f60733          	add	a4,a2,a5
    8000087a:	767d                	lui	a2,0xfffff
    8000087c:	8f71                	and	a4,a4,a2
    8000087e:	97ae                	add	a5,a5,a1
    80000880:	8ff1                	and	a5,a5,a2
    80000882:	00f76863          	bltu	a4,a5,80000892 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000886:	8526                	mv	a0,s1
    80000888:	60e2                	ld	ra,24(sp)
    8000088a:	6442                	ld	s0,16(sp)
    8000088c:	64a2                	ld	s1,8(sp)
    8000088e:	6105                	addi	sp,sp,32
    80000890:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000892:	8f99                	sub	a5,a5,a4
    80000894:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000896:	4685                	li	a3,1
    80000898:	0007861b          	sext.w	a2,a5
    8000089c:	85ba                	mv	a1,a4
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	e6c080e7          	jalr	-404(ra) # 8000070a <uvmunmap>
    800008a6:	b7c5                	j	80000886 <uvmdealloc+0x26>

00000000800008a8 <uvmalloc>:
  if(newsz < oldsz)
    800008a8:	0ab66563          	bltu	a2,a1,80000952 <uvmalloc+0xaa>
{
    800008ac:	7139                	addi	sp,sp,-64
    800008ae:	fc06                	sd	ra,56(sp)
    800008b0:	f822                	sd	s0,48(sp)
    800008b2:	f426                	sd	s1,40(sp)
    800008b4:	f04a                	sd	s2,32(sp)
    800008b6:	ec4e                	sd	s3,24(sp)
    800008b8:	e852                	sd	s4,16(sp)
    800008ba:	e456                	sd	s5,8(sp)
    800008bc:	e05a                	sd	s6,0(sp)
    800008be:	0080                	addi	s0,sp,64
    800008c0:	8aaa                	mv	s5,a0
    800008c2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c4:	6985                	lui	s3,0x1
    800008c6:	19fd                	addi	s3,s3,-1
    800008c8:	95ce                	add	a1,a1,s3
    800008ca:	79fd                	lui	s3,0xfffff
    800008cc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d0:	08c9f363          	bgeu	s3,a2,80000956 <uvmalloc+0xae>
    800008d4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008d6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008da:	00000097          	auipc	ra,0x0
    800008de:	83e080e7          	jalr	-1986(ra) # 80000118 <kalloc>
    800008e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e4:	c51d                	beqz	a0,80000912 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008e6:	6605                	lui	a2,0x1
    800008e8:	4581                	li	a1,0
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	88e080e7          	jalr	-1906(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008f2:	875a                	mv	a4,s6
    800008f4:	86a6                	mv	a3,s1
    800008f6:	6605                	lui	a2,0x1
    800008f8:	85ca                	mv	a1,s2
    800008fa:	8556                	mv	a0,s5
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	c48080e7          	jalr	-952(ra) # 80000544 <mappages>
    80000904:	e90d                	bnez	a0,80000936 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	6785                	lui	a5,0x1
    80000908:	993e                	add	s2,s2,a5
    8000090a:	fd4968e3          	bltu	s2,s4,800008da <uvmalloc+0x32>
  return newsz;
    8000090e:	8552                	mv	a0,s4
    80000910:	a809                	j	80000922 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000912:	864e                	mv	a2,s3
    80000914:	85ca                	mv	a1,s2
    80000916:	8556                	mv	a0,s5
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	f48080e7          	jalr	-184(ra) # 80000860 <uvmdealloc>
      return 0;
    80000920:	4501                	li	a0,0
}
    80000922:	70e2                	ld	ra,56(sp)
    80000924:	7442                	ld	s0,48(sp)
    80000926:	74a2                	ld	s1,40(sp)
    80000928:	7902                	ld	s2,32(sp)
    8000092a:	69e2                	ld	s3,24(sp)
    8000092c:	6a42                	ld	s4,16(sp)
    8000092e:	6aa2                	ld	s5,8(sp)
    80000930:	6b02                	ld	s6,0(sp)
    80000932:	6121                	addi	sp,sp,64
    80000934:	8082                	ret
      kfree(mem);
    80000936:	8526                	mv	a0,s1
    80000938:	fffff097          	auipc	ra,0xfffff
    8000093c:	6e4080e7          	jalr	1764(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000940:	864e                	mv	a2,s3
    80000942:	85ca                	mv	a1,s2
    80000944:	8556                	mv	a0,s5
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	f1a080e7          	jalr	-230(ra) # 80000860 <uvmdealloc>
      return 0;
    8000094e:	4501                	li	a0,0
    80000950:	bfc9                	j	80000922 <uvmalloc+0x7a>
    return oldsz;
    80000952:	852e                	mv	a0,a1
}
    80000954:	8082                	ret
  return newsz;
    80000956:	8532                	mv	a0,a2
    80000958:	b7e9                	j	80000922 <uvmalloc+0x7a>

000000008000095a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095a:	7179                	addi	sp,sp,-48
    8000095c:	f406                	sd	ra,40(sp)
    8000095e:	f022                	sd	s0,32(sp)
    80000960:	ec26                	sd	s1,24(sp)
    80000962:	e84a                	sd	s2,16(sp)
    80000964:	e44e                	sd	s3,8(sp)
    80000966:	e052                	sd	s4,0(sp)
    80000968:	1800                	addi	s0,sp,48
    8000096a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000096c:	84aa                	mv	s1,a0
    8000096e:	6905                	lui	s2,0x1
    80000970:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000972:	4985                	li	s3,1
    80000974:	a821                	j	8000098c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000976:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000978:	0532                	slli	a0,a0,0xc
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	fe0080e7          	jalr	-32(ra) # 8000095a <freewalk>
      pagetable[i] = 0;
    80000982:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000986:	04a1                	addi	s1,s1,8
    80000988:	03248163          	beq	s1,s2,800009aa <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000098c:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000098e:	00f57793          	andi	a5,a0,15
    80000992:	ff3782e3          	beq	a5,s3,80000976 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000996:	8905                	andi	a0,a0,1
    80000998:	d57d                	beqz	a0,80000986 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000099a:	00007517          	auipc	a0,0x7
    8000099e:	74650513          	addi	a0,a0,1862 # 800080e0 <etext+0xe0>
    800009a2:	00005097          	auipc	ra,0x5
    800009a6:	64c080e7          	jalr	1612(ra) # 80005fee <panic>
    }
  }
  kfree((void*)pagetable);
    800009aa:	8552                	mv	a0,s4
    800009ac:	fffff097          	auipc	ra,0xfffff
    800009b0:	670080e7          	jalr	1648(ra) # 8000001c <kfree>
}
    800009b4:	70a2                	ld	ra,40(sp)
    800009b6:	7402                	ld	s0,32(sp)
    800009b8:	64e2                	ld	s1,24(sp)
    800009ba:	6942                	ld	s2,16(sp)
    800009bc:	69a2                	ld	s3,8(sp)
    800009be:	6a02                	ld	s4,0(sp)
    800009c0:	6145                	addi	sp,sp,48
    800009c2:	8082                	ret

00000000800009c4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c4:	1101                	addi	sp,sp,-32
    800009c6:	ec06                	sd	ra,24(sp)
    800009c8:	e822                	sd	s0,16(sp)
    800009ca:	e426                	sd	s1,8(sp)
    800009cc:	1000                	addi	s0,sp,32
    800009ce:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d0:	e999                	bnez	a1,800009e6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d2:	8526                	mv	a0,s1
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	f86080e7          	jalr	-122(ra) # 8000095a <freewalk>
}
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6105                	addi	sp,sp,32
    800009e4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e6:	6605                	lui	a2,0x1
    800009e8:	167d                	addi	a2,a2,-1
    800009ea:	962e                	add	a2,a2,a1
    800009ec:	4685                	li	a3,1
    800009ee:	8231                	srli	a2,a2,0xc
    800009f0:	4581                	li	a1,0
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	d18080e7          	jalr	-744(ra) # 8000070a <uvmunmap>
    800009fa:	bfe1                	j	800009d2 <uvmfree+0xe>

00000000800009fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009fc:	c269                	beqz	a2,80000abe <uvmcopy+0xc2>
{
    800009fe:	715d                	addi	sp,sp,-80
    80000a00:	e486                	sd	ra,72(sp)
    80000a02:	e0a2                	sd	s0,64(sp)
    80000a04:	fc26                	sd	s1,56(sp)
    80000a06:	f84a                	sd	s2,48(sp)
    80000a08:	f44e                	sd	s3,40(sp)
    80000a0a:	f052                	sd	s4,32(sp)
    80000a0c:	ec56                	sd	s5,24(sp)
    80000a0e:	e85a                	sd	s6,16(sp)
    80000a10:	e45e                	sd	s7,8(sp)
    80000a12:	0880                	addi	s0,sp,80
    80000a14:	8aaa                	mv	s5,a0
    80000a16:	8b2e                	mv	s6,a1
    80000a18:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a1a:	4481                	li	s1,0
    80000a1c:	a829                	j	80000a36 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a1e:	00007517          	auipc	a0,0x7
    80000a22:	6d250513          	addi	a0,a0,1746 # 800080f0 <etext+0xf0>
    80000a26:	00005097          	auipc	ra,0x5
    80000a2a:	5c8080e7          	jalr	1480(ra) # 80005fee <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	6785                	lui	a5,0x1
    80000a30:	94be                	add	s1,s1,a5
    80000a32:	0944f463          	bgeu	s1,s4,80000aba <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a36:	4601                	li	a2,0
    80000a38:	85a6                	mv	a1,s1
    80000a3a:	8556                	mv	a0,s5
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	a20080e7          	jalr	-1504(ra) # 8000045c <walk>
    80000a44:	dd69                	beqz	a0,80000a1e <uvmcopy+0x22>
    if((*pte & PTE_V) == 0) continue;
    80000a46:	6118                	ld	a4,0(a0)
    80000a48:	00177793          	andi	a5,a4,1
    80000a4c:	d3ed                	beqz	a5,80000a2e <uvmcopy+0x32>
      // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4e:	00a75593          	srli	a1,a4,0xa
    80000a52:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a56:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	6be080e7          	jalr	1726(ra) # 80000118 <kalloc>
    80000a62:	89aa                	mv	s3,a0
    80000a64:	c515                	beqz	a0,80000a90 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85de                	mv	a1,s7
    80000a6a:	fffff097          	auipc	ra,0xfffff
    80000a6e:	76a080e7          	jalr	1898(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a72:	874a                	mv	a4,s2
    80000a74:	86ce                	mv	a3,s3
    80000a76:	6605                	lui	a2,0x1
    80000a78:	85a6                	mv	a1,s1
    80000a7a:	855a                	mv	a0,s6
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	ac8080e7          	jalr	-1336(ra) # 80000544 <mappages>
    80000a84:	d54d                	beqz	a0,80000a2e <uvmcopy+0x32>
      kfree(mem);
    80000a86:	854e                	mv	a0,s3
    80000a88:	fffff097          	auipc	ra,0xfffff
    80000a8c:	594080e7          	jalr	1428(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a90:	4685                	li	a3,1
    80000a92:	00c4d613          	srli	a2,s1,0xc
    80000a96:	4581                	li	a1,0
    80000a98:	855a                	mv	a0,s6
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	c70080e7          	jalr	-912(ra) # 8000070a <uvmunmap>
  return -1;
    80000aa2:	557d                	li	a0,-1
}
    80000aa4:	60a6                	ld	ra,72(sp)
    80000aa6:	6406                	ld	s0,64(sp)
    80000aa8:	74e2                	ld	s1,56(sp)
    80000aaa:	7942                	ld	s2,48(sp)
    80000aac:	79a2                	ld	s3,40(sp)
    80000aae:	7a02                	ld	s4,32(sp)
    80000ab0:	6ae2                	ld	s5,24(sp)
    80000ab2:	6b42                	ld	s6,16(sp)
    80000ab4:	6ba2                	ld	s7,8(sp)
    80000ab6:	6161                	addi	sp,sp,80
    80000ab8:	8082                	ret
  return 0;
    80000aba:	4501                	li	a0,0
    80000abc:	b7e5                	j	80000aa4 <uvmcopy+0xa8>
    80000abe:	4501                	li	a0,0
}
    80000ac0:	8082                	ret

0000000080000ac2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ac2:	1141                	addi	sp,sp,-16
    80000ac4:	e406                	sd	ra,8(sp)
    80000ac6:	e022                	sd	s0,0(sp)
    80000ac8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aca:	4601                	li	a2,0
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	990080e7          	jalr	-1648(ra) # 8000045c <walk>
  if(pte == 0)
    80000ad4:	c901                	beqz	a0,80000ae4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ad6:	611c                	ld	a5,0(a0)
    80000ad8:	9bbd                	andi	a5,a5,-17
    80000ada:	e11c                	sd	a5,0(a0)
}
    80000adc:	60a2                	ld	ra,8(sp)
    80000ade:	6402                	ld	s0,0(sp)
    80000ae0:	0141                	addi	sp,sp,16
    80000ae2:	8082                	ret
    panic("uvmclear");
    80000ae4:	00007517          	auipc	a0,0x7
    80000ae8:	62c50513          	addi	a0,a0,1580 # 80008110 <etext+0x110>
    80000aec:	00005097          	auipc	ra,0x5
    80000af0:	502080e7          	jalr	1282(ra) # 80005fee <panic>

0000000080000af4 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af4:	c6bd                	beqz	a3,80000b62 <copyout+0x6e>
{
    80000af6:	715d                	addi	sp,sp,-80
    80000af8:	e486                	sd	ra,72(sp)
    80000afa:	e0a2                	sd	s0,64(sp)
    80000afc:	fc26                	sd	s1,56(sp)
    80000afe:	f84a                	sd	s2,48(sp)
    80000b00:	f44e                	sd	s3,40(sp)
    80000b02:	f052                	sd	s4,32(sp)
    80000b04:	ec56                	sd	s5,24(sp)
    80000b06:	e85a                	sd	s6,16(sp)
    80000b08:	e45e                	sd	s7,8(sp)
    80000b0a:	e062                	sd	s8,0(sp)
    80000b0c:	0880                	addi	s0,sp,80
    80000b0e:	8b2a                	mv	s6,a0
    80000b10:	8c2e                	mv	s8,a1
    80000b12:	8a32                	mv	s4,a2
    80000b14:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b16:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b18:	6a85                	lui	s5,0x1
    80000b1a:	a015                	j	80000b3e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b1c:	9562                	add	a0,a0,s8
    80000b1e:	0004861b          	sext.w	a2,s1
    80000b22:	85d2                	mv	a1,s4
    80000b24:	41250533          	sub	a0,a0,s2
    80000b28:	fffff097          	auipc	ra,0xfffff
    80000b2c:	6ac080e7          	jalr	1708(ra) # 800001d4 <memmove>

    len -= n;
    80000b30:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b34:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b36:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b3a:	02098263          	beqz	s3,80000b5e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b3e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b42:	85ca                	mv	a1,s2
    80000b44:	855a                	mv	a0,s6
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	9bc080e7          	jalr	-1604(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b4e:	cd01                	beqz	a0,80000b66 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b50:	418904b3          	sub	s1,s2,s8
    80000b54:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b56:	fc99f3e3          	bgeu	s3,s1,80000b1c <copyout+0x28>
    80000b5a:	84ce                	mv	s1,s3
    80000b5c:	b7c1                	j	80000b1c <copyout+0x28>
  }
  return 0;
    80000b5e:	4501                	li	a0,0
    80000b60:	a021                	j	80000b68 <copyout+0x74>
    80000b62:	4501                	li	a0,0
}
    80000b64:	8082                	ret
      return -1;
    80000b66:	557d                	li	a0,-1
}
    80000b68:	60a6                	ld	ra,72(sp)
    80000b6a:	6406                	ld	s0,64(sp)
    80000b6c:	74e2                	ld	s1,56(sp)
    80000b6e:	7942                	ld	s2,48(sp)
    80000b70:	79a2                	ld	s3,40(sp)
    80000b72:	7a02                	ld	s4,32(sp)
    80000b74:	6ae2                	ld	s5,24(sp)
    80000b76:	6b42                	ld	s6,16(sp)
    80000b78:	6ba2                	ld	s7,8(sp)
    80000b7a:	6c02                	ld	s8,0(sp)
    80000b7c:	6161                	addi	sp,sp,80
    80000b7e:	8082                	ret

0000000080000b80 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b80:	caa5                	beqz	a3,80000bf0 <copyin+0x70>
{
    80000b82:	715d                	addi	sp,sp,-80
    80000b84:	e486                	sd	ra,72(sp)
    80000b86:	e0a2                	sd	s0,64(sp)
    80000b88:	fc26                	sd	s1,56(sp)
    80000b8a:	f84a                	sd	s2,48(sp)
    80000b8c:	f44e                	sd	s3,40(sp)
    80000b8e:	f052                	sd	s4,32(sp)
    80000b90:	ec56                	sd	s5,24(sp)
    80000b92:	e85a                	sd	s6,16(sp)
    80000b94:	e45e                	sd	s7,8(sp)
    80000b96:	e062                	sd	s8,0(sp)
    80000b98:	0880                	addi	s0,sp,80
    80000b9a:	8b2a                	mv	s6,a0
    80000b9c:	8a2e                	mv	s4,a1
    80000b9e:	8c32                	mv	s8,a2
    80000ba0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ba2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ba4:	6a85                	lui	s5,0x1
    80000ba6:	a01d                	j	80000bcc <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba8:	018505b3          	add	a1,a0,s8
    80000bac:	0004861b          	sext.w	a2,s1
    80000bb0:	412585b3          	sub	a1,a1,s2
    80000bb4:	8552                	mv	a0,s4
    80000bb6:	fffff097          	auipc	ra,0xfffff
    80000bba:	61e080e7          	jalr	1566(ra) # 800001d4 <memmove>

    len -= n;
    80000bbe:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bc2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bc4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bc8:	02098263          	beqz	s3,80000bec <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bcc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bd0:	85ca                	mv	a1,s2
    80000bd2:	855a                	mv	a0,s6
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	92e080e7          	jalr	-1746(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bdc:	cd01                	beqz	a0,80000bf4 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bde:	418904b3          	sub	s1,s2,s8
    80000be2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000be4:	fc99f2e3          	bgeu	s3,s1,80000ba8 <copyin+0x28>
    80000be8:	84ce                	mv	s1,s3
    80000bea:	bf7d                	j	80000ba8 <copyin+0x28>
  }
  return 0;
    80000bec:	4501                	li	a0,0
    80000bee:	a021                	j	80000bf6 <copyin+0x76>
    80000bf0:	4501                	li	a0,0
}
    80000bf2:	8082                	ret
      return -1;
    80000bf4:	557d                	li	a0,-1
}
    80000bf6:	60a6                	ld	ra,72(sp)
    80000bf8:	6406                	ld	s0,64(sp)
    80000bfa:	74e2                	ld	s1,56(sp)
    80000bfc:	7942                	ld	s2,48(sp)
    80000bfe:	79a2                	ld	s3,40(sp)
    80000c00:	7a02                	ld	s4,32(sp)
    80000c02:	6ae2                	ld	s5,24(sp)
    80000c04:	6b42                	ld	s6,16(sp)
    80000c06:	6ba2                	ld	s7,8(sp)
    80000c08:	6c02                	ld	s8,0(sp)
    80000c0a:	6161                	addi	sp,sp,80
    80000c0c:	8082                	ret

0000000080000c0e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c0e:	c6c5                	beqz	a3,80000cb6 <copyinstr+0xa8>
{
    80000c10:	715d                	addi	sp,sp,-80
    80000c12:	e486                	sd	ra,72(sp)
    80000c14:	e0a2                	sd	s0,64(sp)
    80000c16:	fc26                	sd	s1,56(sp)
    80000c18:	f84a                	sd	s2,48(sp)
    80000c1a:	f44e                	sd	s3,40(sp)
    80000c1c:	f052                	sd	s4,32(sp)
    80000c1e:	ec56                	sd	s5,24(sp)
    80000c20:	e85a                	sd	s6,16(sp)
    80000c22:	e45e                	sd	s7,8(sp)
    80000c24:	0880                	addi	s0,sp,80
    80000c26:	8a2a                	mv	s4,a0
    80000c28:	8b2e                	mv	s6,a1
    80000c2a:	8bb2                	mv	s7,a2
    80000c2c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c2e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c30:	6985                	lui	s3,0x1
    80000c32:	a035                	j	80000c5e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c34:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c38:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c3a:	0017b793          	seqz	a5,a5
    80000c3e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c42:	60a6                	ld	ra,72(sp)
    80000c44:	6406                	ld	s0,64(sp)
    80000c46:	74e2                	ld	s1,56(sp)
    80000c48:	7942                	ld	s2,48(sp)
    80000c4a:	79a2                	ld	s3,40(sp)
    80000c4c:	7a02                	ld	s4,32(sp)
    80000c4e:	6ae2                	ld	s5,24(sp)
    80000c50:	6b42                	ld	s6,16(sp)
    80000c52:	6ba2                	ld	s7,8(sp)
    80000c54:	6161                	addi	sp,sp,80
    80000c56:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c58:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c5c:	c8a9                	beqz	s1,80000cae <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c5e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c62:	85ca                	mv	a1,s2
    80000c64:	8552                	mv	a0,s4
    80000c66:	00000097          	auipc	ra,0x0
    80000c6a:	89c080e7          	jalr	-1892(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c6e:	c131                	beqz	a0,80000cb2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c70:	41790833          	sub	a6,s2,s7
    80000c74:	984e                	add	a6,a6,s3
    if(n > max)
    80000c76:	0104f363          	bgeu	s1,a6,80000c7c <copyinstr+0x6e>
    80000c7a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c7c:	955e                	add	a0,a0,s7
    80000c7e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c82:	fc080be3          	beqz	a6,80000c58 <copyinstr+0x4a>
    80000c86:	985a                	add	a6,a6,s6
    80000c88:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c8a:	41650633          	sub	a2,a0,s6
    80000c8e:	14fd                	addi	s1,s1,-1
    80000c90:	9b26                	add	s6,s6,s1
    80000c92:	00f60733          	add	a4,a2,a5
    80000c96:	00074703          	lbu	a4,0(a4)
    80000c9a:	df49                	beqz	a4,80000c34 <copyinstr+0x26>
        *dst = *p;
    80000c9c:	00e78023          	sb	a4,0(a5)
      --max;
    80000ca0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000ca4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ca6:	ff0796e3          	bne	a5,a6,80000c92 <copyinstr+0x84>
      dst++;
    80000caa:	8b42                	mv	s6,a6
    80000cac:	b775                	j	80000c58 <copyinstr+0x4a>
    80000cae:	4781                	li	a5,0
    80000cb0:	b769                	j	80000c3a <copyinstr+0x2c>
      return -1;
    80000cb2:	557d                	li	a0,-1
    80000cb4:	b779                	j	80000c42 <copyinstr+0x34>
  int got_null = 0;
    80000cb6:	4781                	li	a5,0
  if(got_null){
    80000cb8:	0017b793          	seqz	a5,a5
    80000cbc:	40f00533          	neg	a0,a5
}
    80000cc0:	8082                	ret

0000000080000cc2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cc2:	7139                	addi	sp,sp,-64
    80000cc4:	fc06                	sd	ra,56(sp)
    80000cc6:	f822                	sd	s0,48(sp)
    80000cc8:	f426                	sd	s1,40(sp)
    80000cca:	f04a                	sd	s2,32(sp)
    80000ccc:	ec4e                	sd	s3,24(sp)
    80000cce:	e852                	sd	s4,16(sp)
    80000cd0:	e456                	sd	s5,8(sp)
    80000cd2:	e05a                	sd	s6,0(sp)
    80000cd4:	0080                	addi	s0,sp,64
    80000cd6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd8:	00008497          	auipc	s1,0x8
    80000cdc:	0a848493          	addi	s1,s1,168 # 80008d80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ce0:	8b26                	mv	s6,s1
    80000ce2:	00007a97          	auipc	s5,0x7
    80000ce6:	31ea8a93          	addi	s5,s5,798 # 80008000 <etext>
    80000cea:	04000937          	lui	s2,0x4000
    80000cee:	197d                	addi	s2,s2,-1
    80000cf0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	0001aa17          	auipc	s4,0x1a
    80000cf6:	a8ea0a13          	addi	s4,s4,-1394 # 8001a780 <tickslock>
    char *pa = kalloc();
    80000cfa:	fffff097          	auipc	ra,0xfffff
    80000cfe:	41e080e7          	jalr	1054(ra) # 80000118 <kalloc>
    80000d02:	862a                	mv	a2,a0
    if(pa == 0)
    80000d04:	c131                	beqz	a0,80000d48 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d06:	416485b3          	sub	a1,s1,s6
    80000d0a:	858d                	srai	a1,a1,0x3
    80000d0c:	000ab783          	ld	a5,0(s5)
    80000d10:	02f585b3          	mul	a1,a1,a5
    80000d14:	2585                	addiw	a1,a1,1
    80000d16:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d1a:	4719                	li	a4,6
    80000d1c:	6685                	lui	a3,0x1
    80000d1e:	40b905b3          	sub	a1,s2,a1
    80000d22:	854e                	mv	a0,s3
    80000d24:	00000097          	auipc	ra,0x0
    80000d28:	8c0080e7          	jalr	-1856(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2c:	46848493          	addi	s1,s1,1128
    80000d30:	fd4495e3          	bne	s1,s4,80000cfa <proc_mapstacks+0x38>
  }
}
    80000d34:	70e2                	ld	ra,56(sp)
    80000d36:	7442                	ld	s0,48(sp)
    80000d38:	74a2                	ld	s1,40(sp)
    80000d3a:	7902                	ld	s2,32(sp)
    80000d3c:	69e2                	ld	s3,24(sp)
    80000d3e:	6a42                	ld	s4,16(sp)
    80000d40:	6aa2                	ld	s5,8(sp)
    80000d42:	6b02                	ld	s6,0(sp)
    80000d44:	6121                	addi	sp,sp,64
    80000d46:	8082                	ret
      panic("kalloc");
    80000d48:	00007517          	auipc	a0,0x7
    80000d4c:	3d850513          	addi	a0,a0,984 # 80008120 <etext+0x120>
    80000d50:	00005097          	auipc	ra,0x5
    80000d54:	29e080e7          	jalr	670(ra) # 80005fee <panic>

0000000080000d58 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d58:	7139                	addi	sp,sp,-64
    80000d5a:	fc06                	sd	ra,56(sp)
    80000d5c:	f822                	sd	s0,48(sp)
    80000d5e:	f426                	sd	s1,40(sp)
    80000d60:	f04a                	sd	s2,32(sp)
    80000d62:	ec4e                	sd	s3,24(sp)
    80000d64:	e852                	sd	s4,16(sp)
    80000d66:	e456                	sd	s5,8(sp)
    80000d68:	e05a                	sd	s6,0(sp)
    80000d6a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d6c:	00007597          	auipc	a1,0x7
    80000d70:	3bc58593          	addi	a1,a1,956 # 80008128 <etext+0x128>
    80000d74:	00008517          	auipc	a0,0x8
    80000d78:	bdc50513          	addi	a0,a0,-1060 # 80008950 <pid_lock>
    80000d7c:	00005097          	auipc	ra,0x5
    80000d80:	71e080e7          	jalr	1822(ra) # 8000649a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3ac58593          	addi	a1,a1,940 # 80008130 <etext+0x130>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	bdc50513          	addi	a0,a0,-1060 # 80008968 <wait_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	706080e7          	jalr	1798(ra) # 8000649a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9c:	00008497          	auipc	s1,0x8
    80000da0:	fe448493          	addi	s1,s1,-28 # 80008d80 <proc>
      initlock(&p->lock, "proc");
    80000da4:	00007b17          	auipc	s6,0x7
    80000da8:	39cb0b13          	addi	s6,s6,924 # 80008140 <etext+0x140>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dac:	8aa6                	mv	s5,s1
    80000dae:	00007a17          	auipc	s4,0x7
    80000db2:	252a0a13          	addi	s4,s4,594 # 80008000 <etext>
    80000db6:	04000937          	lui	s2,0x4000
    80000dba:	197d                	addi	s2,s2,-1
    80000dbc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbe:	0001a997          	auipc	s3,0x1a
    80000dc2:	9c298993          	addi	s3,s3,-1598 # 8001a780 <tickslock>
      initlock(&p->lock, "proc");
    80000dc6:	85da                	mv	a1,s6
    80000dc8:	8526                	mv	a0,s1
    80000dca:	00005097          	auipc	ra,0x5
    80000dce:	6d0080e7          	jalr	1744(ra) # 8000649a <initlock>
      p->state = UNUSED;
    80000dd2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000dd6:	415487b3          	sub	a5,s1,s5
    80000dda:	878d                	srai	a5,a5,0x3
    80000ddc:	000a3703          	ld	a4,0(s4)
    80000de0:	02e787b3          	mul	a5,a5,a4
    80000de4:	2785                	addiw	a5,a5,1
    80000de6:	00d7979b          	slliw	a5,a5,0xd
    80000dea:	40f907b3          	sub	a5,s2,a5
    80000dee:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df0:	46848493          	addi	s1,s1,1128
    80000df4:	fd3499e3          	bne	s1,s3,80000dc6 <procinit+0x6e>
  }
}
    80000df8:	70e2                	ld	ra,56(sp)
    80000dfa:	7442                	ld	s0,48(sp)
    80000dfc:	74a2                	ld	s1,40(sp)
    80000dfe:	7902                	ld	s2,32(sp)
    80000e00:	69e2                	ld	s3,24(sp)
    80000e02:	6a42                	ld	s4,16(sp)
    80000e04:	6aa2                	ld	s5,8(sp)
    80000e06:	6b02                	ld	s6,0(sp)
    80000e08:	6121                	addi	sp,sp,64
    80000e0a:	8082                	ret

0000000080000e0c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e0c:	1141                	addi	sp,sp,-16
    80000e0e:	e422                	sd	s0,8(sp)
    80000e10:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e12:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e14:	2501                	sext.w	a0,a0
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
    80000e22:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e24:	2781                	sext.w	a5,a5
    80000e26:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e28:	00008517          	auipc	a0,0x8
    80000e2c:	b5850513          	addi	a0,a0,-1192 # 80008980 <cpus>
    80000e30:	953e                	add	a0,a0,a5
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e38:	1101                	addi	sp,sp,-32
    80000e3a:	ec06                	sd	ra,24(sp)
    80000e3c:	e822                	sd	s0,16(sp)
    80000e3e:	e426                	sd	s1,8(sp)
    80000e40:	1000                	addi	s0,sp,32
  push_off();
    80000e42:	00005097          	auipc	ra,0x5
    80000e46:	69c080e7          	jalr	1692(ra) # 800064de <push_off>
    80000e4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4c:	2781                	sext.w	a5,a5
    80000e4e:	079e                	slli	a5,a5,0x7
    80000e50:	00008717          	auipc	a4,0x8
    80000e54:	b0070713          	addi	a4,a4,-1280 # 80008950 <pid_lock>
    80000e58:	97ba                	add	a5,a5,a4
    80000e5a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	722080e7          	jalr	1826(ra) # 8000657e <pop_off>
  return p;
}
    80000e64:	8526                	mv	a0,s1
    80000e66:	60e2                	ld	ra,24(sp)
    80000e68:	6442                	ld	s0,16(sp)
    80000e6a:	64a2                	ld	s1,8(sp)
    80000e6c:	6105                	addi	sp,sp,32
    80000e6e:	8082                	ret

0000000080000e70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e406                	sd	ra,8(sp)
    80000e74:	e022                	sd	s0,0(sp)
    80000e76:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e78:	00000097          	auipc	ra,0x0
    80000e7c:	fc0080e7          	jalr	-64(ra) # 80000e38 <myproc>
    80000e80:	00005097          	auipc	ra,0x5
    80000e84:	75e080e7          	jalr	1886(ra) # 800065de <release>

  if (first) {
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	a287a783          	lw	a5,-1496(a5) # 800088b0 <first.1>
    80000e90:	eb89                	bnez	a5,80000ea2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e92:	00001097          	auipc	ra,0x1
    80000e96:	c5c080e7          	jalr	-932(ra) # 80001aee <usertrapret>
}
    80000e9a:	60a2                	ld	ra,8(sp)
    80000e9c:	6402                	ld	s0,0(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
    first = 0;
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	a007a723          	sw	zero,-1522(a5) # 800088b0 <first.1>
    fsinit(ROOTDEV);
    80000eaa:	4505                	li	a0,1
    80000eac:	00002097          	auipc	ra,0x2
    80000eb0:	a9e080e7          	jalr	-1378(ra) # 8000294a <fsinit>
    80000eb4:	bff9                	j	80000e92 <forkret+0x22>

0000000080000eb6 <allocpid>:
{
    80000eb6:	1101                	addi	sp,sp,-32
    80000eb8:	ec06                	sd	ra,24(sp)
    80000eba:	e822                	sd	s0,16(sp)
    80000ebc:	e426                	sd	s1,8(sp)
    80000ebe:	e04a                	sd	s2,0(sp)
    80000ec0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ec2:	00008917          	auipc	s2,0x8
    80000ec6:	a8e90913          	addi	s2,s2,-1394 # 80008950 <pid_lock>
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	65e080e7          	jalr	1630(ra) # 8000652a <acquire>
  pid = nextpid;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	9e078793          	addi	a5,a5,-1568 # 800088b4 <nextpid>
    80000edc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ede:	0014871b          	addiw	a4,s1,1
    80000ee2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	6f8080e7          	jalr	1784(ra) # 800065de <release>
}
    80000eee:	8526                	mv	a0,s1
    80000ef0:	60e2                	ld	ra,24(sp)
    80000ef2:	6442                	ld	s0,16(sp)
    80000ef4:	64a2                	ld	s1,8(sp)
    80000ef6:	6902                	ld	s2,0(sp)
    80000ef8:	6105                	addi	sp,sp,32
    80000efa:	8082                	ret

0000000080000efc <proc_pagetable>:
{
    80000efc:	1101                	addi	sp,sp,-32
    80000efe:	ec06                	sd	ra,24(sp)
    80000f00:	e822                	sd	s0,16(sp)
    80000f02:	e426                	sd	s1,8(sp)
    80000f04:	e04a                	sd	s2,0(sp)
    80000f06:	1000                	addi	s0,sp,32
    80000f08:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	8b6080e7          	jalr	-1866(ra) # 800007c0 <uvmcreate>
    80000f12:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f14:	c121                	beqz	a0,80000f54 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f16:	4729                	li	a4,10
    80000f18:	00006697          	auipc	a3,0x6
    80000f1c:	0e868693          	addi	a3,a3,232 # 80007000 <_trampoline>
    80000f20:	6605                	lui	a2,0x1
    80000f22:	040005b7          	lui	a1,0x4000
    80000f26:	15fd                	addi	a1,a1,-1
    80000f28:	05b2                	slli	a1,a1,0xc
    80000f2a:	fffff097          	auipc	ra,0xfffff
    80000f2e:	61a080e7          	jalr	1562(ra) # 80000544 <mappages>
    80000f32:	02054863          	bltz	a0,80000f62 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f36:	4719                	li	a4,6
    80000f38:	05893683          	ld	a3,88(s2)
    80000f3c:	6605                	lui	a2,0x1
    80000f3e:	020005b7          	lui	a1,0x2000
    80000f42:	15fd                	addi	a1,a1,-1
    80000f44:	05b6                	slli	a1,a1,0xd
    80000f46:	8526                	mv	a0,s1
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	5fc080e7          	jalr	1532(ra) # 80000544 <mappages>
    80000f50:	02054163          	bltz	a0,80000f72 <proc_pagetable+0x76>
}
    80000f54:	8526                	mv	a0,s1
    80000f56:	60e2                	ld	ra,24(sp)
    80000f58:	6442                	ld	s0,16(sp)
    80000f5a:	64a2                	ld	s1,8(sp)
    80000f5c:	6902                	ld	s2,0(sp)
    80000f5e:	6105                	addi	sp,sp,32
    80000f60:	8082                	ret
    uvmfree(pagetable, 0);
    80000f62:	4581                	li	a1,0
    80000f64:	8526                	mv	a0,s1
    80000f66:	00000097          	auipc	ra,0x0
    80000f6a:	a5e080e7          	jalr	-1442(ra) # 800009c4 <uvmfree>
    return 0;
    80000f6e:	4481                	li	s1,0
    80000f70:	b7d5                	j	80000f54 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f72:	4681                	li	a3,0
    80000f74:	4605                	li	a2,1
    80000f76:	040005b7          	lui	a1,0x4000
    80000f7a:	15fd                	addi	a1,a1,-1
    80000f7c:	05b2                	slli	a1,a1,0xc
    80000f7e:	8526                	mv	a0,s1
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	78a080e7          	jalr	1930(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000f88:	4581                	li	a1,0
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	00000097          	auipc	ra,0x0
    80000f90:	a38080e7          	jalr	-1480(ra) # 800009c4 <uvmfree>
    return 0;
    80000f94:	4481                	li	s1,0
    80000f96:	bf7d                	j	80000f54 <proc_pagetable+0x58>

0000000080000f98 <proc_freepagetable>:
{
    80000f98:	1101                	addi	sp,sp,-32
    80000f9a:	ec06                	sd	ra,24(sp)
    80000f9c:	e822                	sd	s0,16(sp)
    80000f9e:	e426                	sd	s1,8(sp)
    80000fa0:	e04a                	sd	s2,0(sp)
    80000fa2:	1000                	addi	s0,sp,32
    80000fa4:	84aa                	mv	s1,a0
    80000fa6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa8:	4681                	li	a3,0
    80000faa:	4605                	li	a2,1
    80000fac:	040005b7          	lui	a1,0x4000
    80000fb0:	15fd                	addi	a1,a1,-1
    80000fb2:	05b2                	slli	a1,a1,0xc
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	756080e7          	jalr	1878(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fbc:	4681                	li	a3,0
    80000fbe:	4605                	li	a2,1
    80000fc0:	020005b7          	lui	a1,0x2000
    80000fc4:	15fd                	addi	a1,a1,-1
    80000fc6:	05b6                	slli	a1,a1,0xd
    80000fc8:	8526                	mv	a0,s1
    80000fca:	fffff097          	auipc	ra,0xfffff
    80000fce:	740080e7          	jalr	1856(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fd2:	85ca                	mv	a1,s2
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	00000097          	auipc	ra,0x0
    80000fda:	9ee080e7          	jalr	-1554(ra) # 800009c4 <uvmfree>
}
    80000fde:	60e2                	ld	ra,24(sp)
    80000fe0:	6442                	ld	s0,16(sp)
    80000fe2:	64a2                	ld	s1,8(sp)
    80000fe4:	6902                	ld	s2,0(sp)
    80000fe6:	6105                	addi	sp,sp,32
    80000fe8:	8082                	ret

0000000080000fea <freeproc>:
{
    80000fea:	1101                	addi	sp,sp,-32
    80000fec:	ec06                	sd	ra,24(sp)
    80000fee:	e822                	sd	s0,16(sp)
    80000ff0:	e426                	sd	s1,8(sp)
    80000ff2:	1000                	addi	s0,sp,32
    80000ff4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ff6:	6d28                	ld	a0,88(a0)
    80000ff8:	c509                	beqz	a0,80001002 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	022080e7          	jalr	34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001002:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001006:	68a8                	ld	a0,80(s1)
    80001008:	c511                	beqz	a0,80001014 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000100a:	64ac                	ld	a1,72(s1)
    8000100c:	00000097          	auipc	ra,0x0
    80001010:	f8c080e7          	jalr	-116(ra) # 80000f98 <proc_freepagetable>
  p->pagetable = 0;
    80001014:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001018:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000101c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001020:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001024:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001028:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000102c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001030:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001034:	0004ac23          	sw	zero,24(s1)
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6105                	addi	sp,sp,32
    80001040:	8082                	ret

0000000080001042 <allocproc>:
{
    80001042:	1101                	addi	sp,sp,-32
    80001044:	ec06                	sd	ra,24(sp)
    80001046:	e822                	sd	s0,16(sp)
    80001048:	e426                	sd	s1,8(sp)
    8000104a:	e04a                	sd	s2,0(sp)
    8000104c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000104e:	00008497          	auipc	s1,0x8
    80001052:	d3248493          	addi	s1,s1,-718 # 80008d80 <proc>
    80001056:	00019917          	auipc	s2,0x19
    8000105a:	72a90913          	addi	s2,s2,1834 # 8001a780 <tickslock>
    acquire(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	4ca080e7          	jalr	1226(ra) # 8000652a <acquire>
    if(p->state == UNUSED) {
    80001068:	4c9c                	lw	a5,24(s1)
    8000106a:	cf81                	beqz	a5,80001082 <allocproc+0x40>
      release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00005097          	auipc	ra,0x5
    80001072:	570080e7          	jalr	1392(ra) # 800065de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001076:	46848493          	addi	s1,s1,1128
    8000107a:	ff2492e3          	bne	s1,s2,8000105e <allocproc+0x1c>
  return 0;
    8000107e:	4481                	li	s1,0
    80001080:	a889                	j	800010d2 <allocproc+0x90>
  p->pid = allocpid();
    80001082:	00000097          	auipc	ra,0x0
    80001086:	e34080e7          	jalr	-460(ra) # 80000eb6 <allocpid>
    8000108a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000108c:	4785                	li	a5,1
    8000108e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001090:	fffff097          	auipc	ra,0xfffff
    80001094:	088080e7          	jalr	136(ra) # 80000118 <kalloc>
    80001098:	892a                	mv	s2,a0
    8000109a:	eca8                	sd	a0,88(s1)
    8000109c:	c131                	beqz	a0,800010e0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000109e:	8526                	mv	a0,s1
    800010a0:	00000097          	auipc	ra,0x0
    800010a4:	e5c080e7          	jalr	-420(ra) # 80000efc <proc_pagetable>
    800010a8:	892a                	mv	s2,a0
    800010aa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010ac:	c531                	beqz	a0,800010f8 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ae:	07000613          	li	a2,112
    800010b2:	4581                	li	a1,0
    800010b4:	06048513          	addi	a0,s1,96
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	0c0080e7          	jalr	192(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010c0:	00000797          	auipc	a5,0x0
    800010c4:	db078793          	addi	a5,a5,-592 # 80000e70 <forkret>
    800010c8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ca:	60bc                	ld	a5,64(s1)
    800010cc:	6705                	lui	a4,0x1
    800010ce:	97ba                	add	a5,a5,a4
    800010d0:	f4bc                	sd	a5,104(s1)
}
    800010d2:	8526                	mv	a0,s1
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6902                	ld	s2,0(sp)
    800010dc:	6105                	addi	sp,sp,32
    800010de:	8082                	ret
    freeproc(p);
    800010e0:	8526                	mv	a0,s1
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	f08080e7          	jalr	-248(ra) # 80000fea <freeproc>
    release(&p->lock);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00005097          	auipc	ra,0x5
    800010f0:	4f2080e7          	jalr	1266(ra) # 800065de <release>
    return 0;
    800010f4:	84ca                	mv	s1,s2
    800010f6:	bff1                	j	800010d2 <allocproc+0x90>
    freeproc(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	ef0080e7          	jalr	-272(ra) # 80000fea <freeproc>
    release(&p->lock);
    80001102:	8526                	mv	a0,s1
    80001104:	00005097          	auipc	ra,0x5
    80001108:	4da080e7          	jalr	1242(ra) # 800065de <release>
    return 0;
    8000110c:	84ca                	mv	s1,s2
    8000110e:	b7d1                	j	800010d2 <allocproc+0x90>

0000000080001110 <userinit>:
{
    80001110:	1101                	addi	sp,sp,-32
    80001112:	ec06                	sd	ra,24(sp)
    80001114:	e822                	sd	s0,16(sp)
    80001116:	e426                	sd	s1,8(sp)
    80001118:	1000                	addi	s0,sp,32
  p = allocproc();
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	f28080e7          	jalr	-216(ra) # 80001042 <allocproc>
    80001122:	84aa                	mv	s1,a0
  initproc = p;
    80001124:	00007797          	auipc	a5,0x7
    80001128:	7ea7b623          	sd	a0,2028(a5) # 80008910 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112c:	03400613          	li	a2,52
    80001130:	00007597          	auipc	a1,0x7
    80001134:	79058593          	addi	a1,a1,1936 # 800088c0 <initcode>
    80001138:	6928                	ld	a0,80(a0)
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	6b4080e7          	jalr	1716(ra) # 800007ee <uvmfirst>
  p->sz = PGSIZE;
    80001142:	6785                	lui	a5,0x1
    80001144:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001146:	6cb8                	ld	a4,88(s1)
    80001148:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000114c:	6cb8                	ld	a4,88(s1)
    8000114e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001150:	4641                	li	a2,16
    80001152:	00007597          	auipc	a1,0x7
    80001156:	ff658593          	addi	a1,a1,-10 # 80008148 <etext+0x148>
    8000115a:	15848513          	addi	a0,s1,344
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	164080e7          	jalr	356(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001166:	00007517          	auipc	a0,0x7
    8000116a:	ff250513          	addi	a0,a0,-14 # 80008158 <etext+0x158>
    8000116e:	00002097          	auipc	ra,0x2
    80001172:	1fe080e7          	jalr	510(ra) # 8000336c <namei>
    80001176:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000117a:	478d                	li	a5,3
    8000117c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	45e080e7          	jalr	1118(ra) # 800065de <release>
}
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6105                	addi	sp,sp,32
    80001190:	8082                	ret

0000000080001192 <growproc>:
{
    80001192:	1101                	addi	sp,sp,-32
    80001194:	ec06                	sd	ra,24(sp)
    80001196:	e822                	sd	s0,16(sp)
    80001198:	e426                	sd	s1,8(sp)
    8000119a:	e04a                	sd	s2,0(sp)
    8000119c:	1000                	addi	s0,sp,32
    8000119e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	c98080e7          	jalr	-872(ra) # 80000e38 <myproc>
    800011a8:	84aa                	mv	s1,a0
  sz = p->sz;
    800011aa:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011ac:	01204c63          	bgtz	s2,800011c4 <growproc+0x32>
  } else if(n < 0){
    800011b0:	02094663          	bltz	s2,800011dc <growproc+0x4a>
  p->sz = sz;
    800011b4:	e4ac                	sd	a1,72(s1)
  return 0;
    800011b6:	4501                	li	a0,0
}
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6902                	ld	s2,0(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011c4:	4691                	li	a3,4
    800011c6:	00b90633          	add	a2,s2,a1
    800011ca:	6928                	ld	a0,80(a0)
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	6dc080e7          	jalr	1756(ra) # 800008a8 <uvmalloc>
    800011d4:	85aa                	mv	a1,a0
    800011d6:	fd79                	bnez	a0,800011b4 <growproc+0x22>
      return -1;
    800011d8:	557d                	li	a0,-1
    800011da:	bff9                	j	800011b8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011dc:	00b90633          	add	a2,s2,a1
    800011e0:	6928                	ld	a0,80(a0)
    800011e2:	fffff097          	auipc	ra,0xfffff
    800011e6:	67e080e7          	jalr	1662(ra) # 80000860 <uvmdealloc>
    800011ea:	85aa                	mv	a1,a0
    800011ec:	b7e1                	j	800011b4 <growproc+0x22>

00000000800011ee <fork>:
{
    800011ee:	7139                	addi	sp,sp,-64
    800011f0:	fc06                	sd	ra,56(sp)
    800011f2:	f822                	sd	s0,48(sp)
    800011f4:	f426                	sd	s1,40(sp)
    800011f6:	f04a                	sd	s2,32(sp)
    800011f8:	ec4e                	sd	s3,24(sp)
    800011fa:	e852                	sd	s4,16(sp)
    800011fc:	e456                	sd	s5,8(sp)
    800011fe:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001200:	00000097          	auipc	ra,0x0
    80001204:	c38080e7          	jalr	-968(ra) # 80000e38 <myproc>
    80001208:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	e38080e7          	jalr	-456(ra) # 80001042 <allocproc>
    80001212:	10050c63          	beqz	a0,8000132a <fork+0x13c>
    80001216:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001218:	048ab603          	ld	a2,72(s5)
    8000121c:	692c                	ld	a1,80(a0)
    8000121e:	050ab503          	ld	a0,80(s5)
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	7da080e7          	jalr	2010(ra) # 800009fc <uvmcopy>
    8000122a:	04054863          	bltz	a0,8000127a <fork+0x8c>
  np->sz = p->sz;
    8000122e:	048ab783          	ld	a5,72(s5)
    80001232:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001236:	058ab683          	ld	a3,88(s5)
    8000123a:	87b6                	mv	a5,a3
    8000123c:	058a3703          	ld	a4,88(s4)
    80001240:	12068693          	addi	a3,a3,288
    80001244:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001248:	6788                	ld	a0,8(a5)
    8000124a:	6b8c                	ld	a1,16(a5)
    8000124c:	6f90                	ld	a2,24(a5)
    8000124e:	01073023          	sd	a6,0(a4)
    80001252:	e708                	sd	a0,8(a4)
    80001254:	eb0c                	sd	a1,16(a4)
    80001256:	ef10                	sd	a2,24(a4)
    80001258:	02078793          	addi	a5,a5,32
    8000125c:	02070713          	addi	a4,a4,32
    80001260:	fed792e3          	bne	a5,a3,80001244 <fork+0x56>
  np->trapframe->a0 = 0;
    80001264:	058a3783          	ld	a5,88(s4)
    80001268:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000126c:	0d0a8493          	addi	s1,s5,208
    80001270:	0d0a0913          	addi	s2,s4,208
    80001274:	150a8993          	addi	s3,s5,336
    80001278:	a00d                	j	8000129a <fork+0xac>
    freeproc(np);
    8000127a:	8552                	mv	a0,s4
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	d6e080e7          	jalr	-658(ra) # 80000fea <freeproc>
    release(&np->lock);
    80001284:	8552                	mv	a0,s4
    80001286:	00005097          	auipc	ra,0x5
    8000128a:	358080e7          	jalr	856(ra) # 800065de <release>
    return -1;
    8000128e:	597d                	li	s2,-1
    80001290:	a059                	j	80001316 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001292:	04a1                	addi	s1,s1,8
    80001294:	0921                	addi	s2,s2,8
    80001296:	01348b63          	beq	s1,s3,800012ac <fork+0xbe>
    if(p->ofile[i])
    8000129a:	6088                	ld	a0,0(s1)
    8000129c:	d97d                	beqz	a0,80001292 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000129e:	00002097          	auipc	ra,0x2
    800012a2:	768080e7          	jalr	1896(ra) # 80003a06 <filedup>
    800012a6:	00a93023          	sd	a0,0(s2)
    800012aa:	b7e5                	j	80001292 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ac:	150ab503          	ld	a0,336(s5)
    800012b0:	00002097          	auipc	ra,0x2
    800012b4:	8d8080e7          	jalr	-1832(ra) # 80002b88 <idup>
    800012b8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012bc:	4641                	li	a2,16
    800012be:	158a8593          	addi	a1,s5,344
    800012c2:	158a0513          	addi	a0,s4,344
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	ffc080e7          	jalr	-4(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012ce:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012d2:	8552                	mv	a0,s4
    800012d4:	00005097          	auipc	ra,0x5
    800012d8:	30a080e7          	jalr	778(ra) # 800065de <release>
  acquire(&wait_lock);
    800012dc:	00007497          	auipc	s1,0x7
    800012e0:	68c48493          	addi	s1,s1,1676 # 80008968 <wait_lock>
    800012e4:	8526                	mv	a0,s1
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	244080e7          	jalr	580(ra) # 8000652a <acquire>
  np->parent = p;
    800012ee:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800012f2:	8526                	mv	a0,s1
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	2ea080e7          	jalr	746(ra) # 800065de <release>
  acquire(&np->lock);
    800012fc:	8552                	mv	a0,s4
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	22c080e7          	jalr	556(ra) # 8000652a <acquire>
  np->state = RUNNABLE;
    80001306:	478d                	li	a5,3
    80001308:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000130c:	8552                	mv	a0,s4
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	2d0080e7          	jalr	720(ra) # 800065de <release>
}
    80001316:	854a                	mv	a0,s2
    80001318:	70e2                	ld	ra,56(sp)
    8000131a:	7442                	ld	s0,48(sp)
    8000131c:	74a2                	ld	s1,40(sp)
    8000131e:	7902                	ld	s2,32(sp)
    80001320:	69e2                	ld	s3,24(sp)
    80001322:	6a42                	ld	s4,16(sp)
    80001324:	6aa2                	ld	s5,8(sp)
    80001326:	6121                	addi	sp,sp,64
    80001328:	8082                	ret
    return -1;
    8000132a:	597d                	li	s2,-1
    8000132c:	b7ed                	j	80001316 <fork+0x128>

000000008000132e <scheduler>:
{
    8000132e:	7139                	addi	sp,sp,-64
    80001330:	fc06                	sd	ra,56(sp)
    80001332:	f822                	sd	s0,48(sp)
    80001334:	f426                	sd	s1,40(sp)
    80001336:	f04a                	sd	s2,32(sp)
    80001338:	ec4e                	sd	s3,24(sp)
    8000133a:	e852                	sd	s4,16(sp)
    8000133c:	e456                	sd	s5,8(sp)
    8000133e:	e05a                	sd	s6,0(sp)
    80001340:	0080                	addi	s0,sp,64
    80001342:	8792                	mv	a5,tp
  int id = r_tp();
    80001344:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001346:	00779a93          	slli	s5,a5,0x7
    8000134a:	00007717          	auipc	a4,0x7
    8000134e:	60670713          	addi	a4,a4,1542 # 80008950 <pid_lock>
    80001352:	9756                	add	a4,a4,s5
    80001354:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001358:	00007717          	auipc	a4,0x7
    8000135c:	63070713          	addi	a4,a4,1584 # 80008988 <cpus+0x8>
    80001360:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001362:	498d                	li	s3,3
        p->state = RUNNING;
    80001364:	4b11                	li	s6,4
        c->proc = p;
    80001366:	079e                	slli	a5,a5,0x7
    80001368:	00007a17          	auipc	s4,0x7
    8000136c:	5e8a0a13          	addi	s4,s4,1512 # 80008950 <pid_lock>
    80001370:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001372:	00019917          	auipc	s2,0x19
    80001376:	40e90913          	addi	s2,s2,1038 # 8001a780 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000137e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001382:	10079073          	csrw	sstatus,a5
    80001386:	00008497          	auipc	s1,0x8
    8000138a:	9fa48493          	addi	s1,s1,-1542 # 80008d80 <proc>
    8000138e:	a811                	j	800013a2 <scheduler+0x74>
      release(&p->lock);
    80001390:	8526                	mv	a0,s1
    80001392:	00005097          	auipc	ra,0x5
    80001396:	24c080e7          	jalr	588(ra) # 800065de <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	46848493          	addi	s1,s1,1128
    8000139e:	fd248ee3          	beq	s1,s2,8000137a <scheduler+0x4c>
      acquire(&p->lock);
    800013a2:	8526                	mv	a0,s1
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	186080e7          	jalr	390(ra) # 8000652a <acquire>
      if(p->state == RUNNABLE) {
    800013ac:	4c9c                	lw	a5,24(s1)
    800013ae:	ff3791e3          	bne	a5,s3,80001390 <scheduler+0x62>
        p->state = RUNNING;
    800013b2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ba:	06048593          	addi	a1,s1,96
    800013be:	8556                	mv	a0,s5
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	684080e7          	jalr	1668(ra) # 80001a44 <swtch>
        c->proc = 0;
    800013c8:	020a3823          	sd	zero,48(s4)
    800013cc:	b7d1                	j	80001390 <scheduler+0x62>

00000000800013ce <sched>:
{
    800013ce:	7179                	addi	sp,sp,-48
    800013d0:	f406                	sd	ra,40(sp)
    800013d2:	f022                	sd	s0,32(sp)
    800013d4:	ec26                	sd	s1,24(sp)
    800013d6:	e84a                	sd	s2,16(sp)
    800013d8:	e44e                	sd	s3,8(sp)
    800013da:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	a5c080e7          	jalr	-1444(ra) # 80000e38 <myproc>
    800013e4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	0ca080e7          	jalr	202(ra) # 800064b0 <holding>
    800013ee:	c93d                	beqz	a0,80001464 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013f0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013f2:	2781                	sext.w	a5,a5
    800013f4:	079e                	slli	a5,a5,0x7
    800013f6:	00007717          	auipc	a4,0x7
    800013fa:	55a70713          	addi	a4,a4,1370 # 80008950 <pid_lock>
    800013fe:	97ba                	add	a5,a5,a4
    80001400:	0a87a703          	lw	a4,168(a5)
    80001404:	4785                	li	a5,1
    80001406:	06f71763          	bne	a4,a5,80001474 <sched+0xa6>
  if(p->state == RUNNING)
    8000140a:	4c98                	lw	a4,24(s1)
    8000140c:	4791                	li	a5,4
    8000140e:	06f70b63          	beq	a4,a5,80001484 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001412:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001416:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001418:	efb5                	bnez	a5,80001494 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000141a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000141c:	00007917          	auipc	s2,0x7
    80001420:	53490913          	addi	s2,s2,1332 # 80008950 <pid_lock>
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	97ca                	add	a5,a5,s2
    8000142a:	0ac7a983          	lw	s3,172(a5)
    8000142e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001430:	2781                	sext.w	a5,a5
    80001432:	079e                	slli	a5,a5,0x7
    80001434:	00007597          	auipc	a1,0x7
    80001438:	55458593          	addi	a1,a1,1364 # 80008988 <cpus+0x8>
    8000143c:	95be                	add	a1,a1,a5
    8000143e:	06048513          	addi	a0,s1,96
    80001442:	00000097          	auipc	ra,0x0
    80001446:	602080e7          	jalr	1538(ra) # 80001a44 <swtch>
    8000144a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0b37a623          	sw	s3,172(a5)
}
    80001456:	70a2                	ld	ra,40(sp)
    80001458:	7402                	ld	s0,32(sp)
    8000145a:	64e2                	ld	s1,24(sp)
    8000145c:	6942                	ld	s2,16(sp)
    8000145e:	69a2                	ld	s3,8(sp)
    80001460:	6145                	addi	sp,sp,48
    80001462:	8082                	ret
    panic("sched p->lock");
    80001464:	00007517          	auipc	a0,0x7
    80001468:	cfc50513          	addi	a0,a0,-772 # 80008160 <etext+0x160>
    8000146c:	00005097          	auipc	ra,0x5
    80001470:	b82080e7          	jalr	-1150(ra) # 80005fee <panic>
    panic("sched locks");
    80001474:	00007517          	auipc	a0,0x7
    80001478:	cfc50513          	addi	a0,a0,-772 # 80008170 <etext+0x170>
    8000147c:	00005097          	auipc	ra,0x5
    80001480:	b72080e7          	jalr	-1166(ra) # 80005fee <panic>
    panic("sched running");
    80001484:	00007517          	auipc	a0,0x7
    80001488:	cfc50513          	addi	a0,a0,-772 # 80008180 <etext+0x180>
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	b62080e7          	jalr	-1182(ra) # 80005fee <panic>
    panic("sched interruptible");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	cfc50513          	addi	a0,a0,-772 # 80008190 <etext+0x190>
    8000149c:	00005097          	auipc	ra,0x5
    800014a0:	b52080e7          	jalr	-1198(ra) # 80005fee <panic>

00000000800014a4 <yield>:
{
    800014a4:	1101                	addi	sp,sp,-32
    800014a6:	ec06                	sd	ra,24(sp)
    800014a8:	e822                	sd	s0,16(sp)
    800014aa:	e426                	sd	s1,8(sp)
    800014ac:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	98a080e7          	jalr	-1654(ra) # 80000e38 <myproc>
    800014b6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	072080e7          	jalr	114(ra) # 8000652a <acquire>
  p->state = RUNNABLE;
    800014c0:	478d                	li	a5,3
    800014c2:	cc9c                	sw	a5,24(s1)
  sched();
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	f0a080e7          	jalr	-246(ra) # 800013ce <sched>
  release(&p->lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	110080e7          	jalr	272(ra) # 800065de <release>
}
    800014d6:	60e2                	ld	ra,24(sp)
    800014d8:	6442                	ld	s0,16(sp)
    800014da:	64a2                	ld	s1,8(sp)
    800014dc:	6105                	addi	sp,sp,32
    800014de:	8082                	ret

00000000800014e0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014e0:	7179                	addi	sp,sp,-48
    800014e2:	f406                	sd	ra,40(sp)
    800014e4:	f022                	sd	s0,32(sp)
    800014e6:	ec26                	sd	s1,24(sp)
    800014e8:	e84a                	sd	s2,16(sp)
    800014ea:	e44e                	sd	s3,8(sp)
    800014ec:	1800                	addi	s0,sp,48
    800014ee:	89aa                	mv	s3,a0
    800014f0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	946080e7          	jalr	-1722(ra) # 80000e38 <myproc>
    800014fa:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	02e080e7          	jalr	46(ra) # 8000652a <acquire>
  release(lk);
    80001504:	854a                	mv	a0,s2
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	0d8080e7          	jalr	216(ra) # 800065de <release>

  // Go to sleep.
  p->chan = chan;
    8000150e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001512:	4789                	li	a5,2
    80001514:	cc9c                	sw	a5,24(s1)

  sched();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	eb8080e7          	jalr	-328(ra) # 800013ce <sched>

  // Tidy up.
  p->chan = 0;
    8000151e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001522:	8526                	mv	a0,s1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	0ba080e7          	jalr	186(ra) # 800065de <release>
  acquire(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	ffc080e7          	jalr	-4(ra) # 8000652a <acquire>
}
    80001536:	70a2                	ld	ra,40(sp)
    80001538:	7402                	ld	s0,32(sp)
    8000153a:	64e2                	ld	s1,24(sp)
    8000153c:	6942                	ld	s2,16(sp)
    8000153e:	69a2                	ld	s3,8(sp)
    80001540:	6145                	addi	sp,sp,48
    80001542:	8082                	ret

0000000080001544 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001544:	7139                	addi	sp,sp,-64
    80001546:	fc06                	sd	ra,56(sp)
    80001548:	f822                	sd	s0,48(sp)
    8000154a:	f426                	sd	s1,40(sp)
    8000154c:	f04a                	sd	s2,32(sp)
    8000154e:	ec4e                	sd	s3,24(sp)
    80001550:	e852                	sd	s4,16(sp)
    80001552:	e456                	sd	s5,8(sp)
    80001554:	0080                	addi	s0,sp,64
    80001556:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001558:	00008497          	auipc	s1,0x8
    8000155c:	82848493          	addi	s1,s1,-2008 # 80008d80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001560:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001562:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001564:	00019917          	auipc	s2,0x19
    80001568:	21c90913          	addi	s2,s2,540 # 8001a780 <tickslock>
    8000156c:	a811                	j	80001580 <wakeup+0x3c>
      }
      release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	06e080e7          	jalr	110(ra) # 800065de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001578:	46848493          	addi	s1,s1,1128
    8000157c:	03248663          	beq	s1,s2,800015a8 <wakeup+0x64>
    if(p != myproc()){
    80001580:	00000097          	auipc	ra,0x0
    80001584:	8b8080e7          	jalr	-1864(ra) # 80000e38 <myproc>
    80001588:	fea488e3          	beq	s1,a0,80001578 <wakeup+0x34>
      acquire(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	f9c080e7          	jalr	-100(ra) # 8000652a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001596:	4c9c                	lw	a5,24(s1)
    80001598:	fd379be3          	bne	a5,s3,8000156e <wakeup+0x2a>
    8000159c:	709c                	ld	a5,32(s1)
    8000159e:	fd4798e3          	bne	a5,s4,8000156e <wakeup+0x2a>
        p->state = RUNNABLE;
    800015a2:	0154ac23          	sw	s5,24(s1)
    800015a6:	b7e1                	j	8000156e <wakeup+0x2a>
    }
  }
}
    800015a8:	70e2                	ld	ra,56(sp)
    800015aa:	7442                	ld	s0,48(sp)
    800015ac:	74a2                	ld	s1,40(sp)
    800015ae:	7902                	ld	s2,32(sp)
    800015b0:	69e2                	ld	s3,24(sp)
    800015b2:	6a42                	ld	s4,16(sp)
    800015b4:	6aa2                	ld	s5,8(sp)
    800015b6:	6121                	addi	sp,sp,64
    800015b8:	8082                	ret

00000000800015ba <reparent>:
{
    800015ba:	7179                	addi	sp,sp,-48
    800015bc:	f406                	sd	ra,40(sp)
    800015be:	f022                	sd	s0,32(sp)
    800015c0:	ec26                	sd	s1,24(sp)
    800015c2:	e84a                	sd	s2,16(sp)
    800015c4:	e44e                	sd	s3,8(sp)
    800015c6:	e052                	sd	s4,0(sp)
    800015c8:	1800                	addi	s0,sp,48
    800015ca:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015cc:	00007497          	auipc	s1,0x7
    800015d0:	7b448493          	addi	s1,s1,1972 # 80008d80 <proc>
      pp->parent = initproc;
    800015d4:	00007a17          	auipc	s4,0x7
    800015d8:	33ca0a13          	addi	s4,s4,828 # 80008910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015dc:	00019997          	auipc	s3,0x19
    800015e0:	1a498993          	addi	s3,s3,420 # 8001a780 <tickslock>
    800015e4:	a029                	j	800015ee <reparent+0x34>
    800015e6:	46848493          	addi	s1,s1,1128
    800015ea:	01348d63          	beq	s1,s3,80001604 <reparent+0x4a>
    if(pp->parent == p){
    800015ee:	7c9c                	ld	a5,56(s1)
    800015f0:	ff279be3          	bne	a5,s2,800015e6 <reparent+0x2c>
      pp->parent = initproc;
    800015f4:	000a3503          	ld	a0,0(s4)
    800015f8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	f4a080e7          	jalr	-182(ra) # 80001544 <wakeup>
    80001602:	b7d5                	j	800015e6 <reparent+0x2c>
}
    80001604:	70a2                	ld	ra,40(sp)
    80001606:	7402                	ld	s0,32(sp)
    80001608:	64e2                	ld	s1,24(sp)
    8000160a:	6942                	ld	s2,16(sp)
    8000160c:	69a2                	ld	s3,8(sp)
    8000160e:	6a02                	ld	s4,0(sp)
    80001610:	6145                	addi	sp,sp,48
    80001612:	8082                	ret

0000000080001614 <exit>:
{
    80001614:	7179                	addi	sp,sp,-48
    80001616:	f406                	sd	ra,40(sp)
    80001618:	f022                	sd	s0,32(sp)
    8000161a:	ec26                	sd	s1,24(sp)
    8000161c:	e84a                	sd	s2,16(sp)
    8000161e:	e44e                	sd	s3,8(sp)
    80001620:	e052                	sd	s4,0(sp)
    80001622:	1800                	addi	s0,sp,48
    80001624:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001626:	00000097          	auipc	ra,0x0
    8000162a:	812080e7          	jalr	-2030(ra) # 80000e38 <myproc>
    8000162e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001630:	00007797          	auipc	a5,0x7
    80001634:	2e07b783          	ld	a5,736(a5) # 80008910 <initproc>
    80001638:	0d050493          	addi	s1,a0,208
    8000163c:	15050913          	addi	s2,a0,336
    80001640:	02a79363          	bne	a5,a0,80001666 <exit+0x52>
    panic("init exiting");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b6450513          	addi	a0,a0,-1180 # 800081a8 <etext+0x1a8>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	9a2080e7          	jalr	-1630(ra) # 80005fee <panic>
      fileclose(f);
    80001654:	00002097          	auipc	ra,0x2
    80001658:	404080e7          	jalr	1028(ra) # 80003a58 <fileclose>
      p->ofile[fd] = 0;
    8000165c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001660:	04a1                	addi	s1,s1,8
    80001662:	01248563          	beq	s1,s2,8000166c <exit+0x58>
    if(p->ofile[fd]){
    80001666:	6088                	ld	a0,0(s1)
    80001668:	f575                	bnez	a0,80001654 <exit+0x40>
    8000166a:	bfdd                	j	80001660 <exit+0x4c>
  begin_op();
    8000166c:	00002097          	auipc	ra,0x2
    80001670:	f20080e7          	jalr	-224(ra) # 8000358c <begin_op>
  iput(p->cwd);
    80001674:	1509b503          	ld	a0,336(s3)
    80001678:	00001097          	auipc	ra,0x1
    8000167c:	708080e7          	jalr	1800(ra) # 80002d80 <iput>
  end_op();
    80001680:	00002097          	auipc	ra,0x2
    80001684:	f8c080e7          	jalr	-116(ra) # 8000360c <end_op>
  p->cwd = 0;
    80001688:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000168c:	00007497          	auipc	s1,0x7
    80001690:	2dc48493          	addi	s1,s1,732 # 80008968 <wait_lock>
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	e94080e7          	jalr	-364(ra) # 8000652a <acquire>
  reparent(p);
    8000169e:	854e                	mv	a0,s3
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	f1a080e7          	jalr	-230(ra) # 800015ba <reparent>
  wakeup(p->parent);
    800016a8:	0389b503          	ld	a0,56(s3)
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	e98080e7          	jalr	-360(ra) # 80001544 <wakeup>
  acquire(&p->lock);
    800016b4:	854e                	mv	a0,s3
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	e74080e7          	jalr	-396(ra) # 8000652a <acquire>
  p->xstate = status;
    800016be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016c2:	4795                	li	a5,5
    800016c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016c8:	8526                	mv	a0,s1
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	f14080e7          	jalr	-236(ra) # 800065de <release>
  sched();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	cfc080e7          	jalr	-772(ra) # 800013ce <sched>
  panic("zombie exit");
    800016da:	00007517          	auipc	a0,0x7
    800016de:	ade50513          	addi	a0,a0,-1314 # 800081b8 <etext+0x1b8>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	90c080e7          	jalr	-1780(ra) # 80005fee <panic>

00000000800016ea <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016ea:	7179                	addi	sp,sp,-48
    800016ec:	f406                	sd	ra,40(sp)
    800016ee:	f022                	sd	s0,32(sp)
    800016f0:	ec26                	sd	s1,24(sp)
    800016f2:	e84a                	sd	s2,16(sp)
    800016f4:	e44e                	sd	s3,8(sp)
    800016f6:	1800                	addi	s0,sp,48
    800016f8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800016fa:	00007497          	auipc	s1,0x7
    800016fe:	68648493          	addi	s1,s1,1670 # 80008d80 <proc>
    80001702:	00019997          	auipc	s3,0x19
    80001706:	07e98993          	addi	s3,s3,126 # 8001a780 <tickslock>
    acquire(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	e1e080e7          	jalr	-482(ra) # 8000652a <acquire>
    if(p->pid == pid){
    80001714:	589c                	lw	a5,48(s1)
    80001716:	01278d63          	beq	a5,s2,80001730 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	ec2080e7          	jalr	-318(ra) # 800065de <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001724:	46848493          	addi	s1,s1,1128
    80001728:	ff3491e3          	bne	s1,s3,8000170a <kill+0x20>
  }
  return -1;
    8000172c:	557d                	li	a0,-1
    8000172e:	a829                	j	80001748 <kill+0x5e>
      p->killed = 1;
    80001730:	4785                	li	a5,1
    80001732:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001734:	4c98                	lw	a4,24(s1)
    80001736:	4789                	li	a5,2
    80001738:	00f70f63          	beq	a4,a5,80001756 <kill+0x6c>
      release(&p->lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	ea0080e7          	jalr	-352(ra) # 800065de <release>
      return 0;
    80001746:	4501                	li	a0,0
}
    80001748:	70a2                	ld	ra,40(sp)
    8000174a:	7402                	ld	s0,32(sp)
    8000174c:	64e2                	ld	s1,24(sp)
    8000174e:	6942                	ld	s2,16(sp)
    80001750:	69a2                	ld	s3,8(sp)
    80001752:	6145                	addi	sp,sp,48
    80001754:	8082                	ret
        p->state = RUNNABLE;
    80001756:	478d                	li	a5,3
    80001758:	cc9c                	sw	a5,24(s1)
    8000175a:	b7cd                	j	8000173c <kill+0x52>

000000008000175c <setkilled>:

void
setkilled(struct proc *p)
{
    8000175c:	1101                	addi	sp,sp,-32
    8000175e:	ec06                	sd	ra,24(sp)
    80001760:	e822                	sd	s0,16(sp)
    80001762:	e426                	sd	s1,8(sp)
    80001764:	1000                	addi	s0,sp,32
    80001766:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	dc2080e7          	jalr	-574(ra) # 8000652a <acquire>
  p->killed = 1;
    80001770:	4785                	li	a5,1
    80001772:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	e68080e7          	jalr	-408(ra) # 800065de <release>
}
    8000177e:	60e2                	ld	ra,24(sp)
    80001780:	6442                	ld	s0,16(sp)
    80001782:	64a2                	ld	s1,8(sp)
    80001784:	6105                	addi	sp,sp,32
    80001786:	8082                	ret

0000000080001788 <killed>:

int
killed(struct proc *p)
{
    80001788:	1101                	addi	sp,sp,-32
    8000178a:	ec06                	sd	ra,24(sp)
    8000178c:	e822                	sd	s0,16(sp)
    8000178e:	e426                	sd	s1,8(sp)
    80001790:	e04a                	sd	s2,0(sp)
    80001792:	1000                	addi	s0,sp,32
    80001794:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001796:	00005097          	auipc	ra,0x5
    8000179a:	d94080e7          	jalr	-620(ra) # 8000652a <acquire>
  k = p->killed;
    8000179e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017a2:	8526                	mv	a0,s1
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	e3a080e7          	jalr	-454(ra) # 800065de <release>
  return k;
}
    800017ac:	854a                	mv	a0,s2
    800017ae:	60e2                	ld	ra,24(sp)
    800017b0:	6442                	ld	s0,16(sp)
    800017b2:	64a2                	ld	s1,8(sp)
    800017b4:	6902                	ld	s2,0(sp)
    800017b6:	6105                	addi	sp,sp,32
    800017b8:	8082                	ret

00000000800017ba <wait>:
{
    800017ba:	715d                	addi	sp,sp,-80
    800017bc:	e486                	sd	ra,72(sp)
    800017be:	e0a2                	sd	s0,64(sp)
    800017c0:	fc26                	sd	s1,56(sp)
    800017c2:	f84a                	sd	s2,48(sp)
    800017c4:	f44e                	sd	s3,40(sp)
    800017c6:	f052                	sd	s4,32(sp)
    800017c8:	ec56                	sd	s5,24(sp)
    800017ca:	e85a                	sd	s6,16(sp)
    800017cc:	e45e                	sd	s7,8(sp)
    800017ce:	e062                	sd	s8,0(sp)
    800017d0:	0880                	addi	s0,sp,80
    800017d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017d4:	fffff097          	auipc	ra,0xfffff
    800017d8:	664080e7          	jalr	1636(ra) # 80000e38 <myproc>
    800017dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017de:	00007517          	auipc	a0,0x7
    800017e2:	18a50513          	addi	a0,a0,394 # 80008968 <wait_lock>
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	d44080e7          	jalr	-700(ra) # 8000652a <acquire>
    havekids = 0;
    800017ee:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800017f0:	4a15                	li	s4,5
        havekids = 1;
    800017f2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f4:	00019997          	auipc	s3,0x19
    800017f8:	f8c98993          	addi	s3,s3,-116 # 8001a780 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fc:	00007c17          	auipc	s8,0x7
    80001800:	16cc0c13          	addi	s8,s8,364 # 80008968 <wait_lock>
    havekids = 0;
    80001804:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001806:	00007497          	auipc	s1,0x7
    8000180a:	57a48493          	addi	s1,s1,1402 # 80008d80 <proc>
    8000180e:	a0bd                	j	8000187c <wait+0xc2>
          pid = pp->pid;
    80001810:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001814:	000b0e63          	beqz	s6,80001830 <wait+0x76>
    80001818:	4691                	li	a3,4
    8000181a:	02c48613          	addi	a2,s1,44
    8000181e:	85da                	mv	a1,s6
    80001820:	05093503          	ld	a0,80(s2)
    80001824:	fffff097          	auipc	ra,0xfffff
    80001828:	2d0080e7          	jalr	720(ra) # 80000af4 <copyout>
    8000182c:	02054563          	bltz	a0,80001856 <wait+0x9c>
          freeproc(pp);
    80001830:	8526                	mv	a0,s1
    80001832:	fffff097          	auipc	ra,0xfffff
    80001836:	7b8080e7          	jalr	1976(ra) # 80000fea <freeproc>
          release(&pp->lock);
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	da2080e7          	jalr	-606(ra) # 800065de <release>
          release(&wait_lock);
    80001844:	00007517          	auipc	a0,0x7
    80001848:	12450513          	addi	a0,a0,292 # 80008968 <wait_lock>
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	d92080e7          	jalr	-622(ra) # 800065de <release>
          return pid;
    80001854:	a0b5                	j	800018c0 <wait+0x106>
            release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	d86080e7          	jalr	-634(ra) # 800065de <release>
            release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	10850513          	addi	a0,a0,264 # 80008968 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	d76080e7          	jalr	-650(ra) # 800065de <release>
            return -1;
    80001870:	59fd                	li	s3,-1
    80001872:	a0b9                	j	800018c0 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001874:	46848493          	addi	s1,s1,1128
    80001878:	03348463          	beq	s1,s3,800018a0 <wait+0xe6>
      if(pp->parent == p){
    8000187c:	7c9c                	ld	a5,56(s1)
    8000187e:	ff279be3          	bne	a5,s2,80001874 <wait+0xba>
        acquire(&pp->lock);
    80001882:	8526                	mv	a0,s1
    80001884:	00005097          	auipc	ra,0x5
    80001888:	ca6080e7          	jalr	-858(ra) # 8000652a <acquire>
        if(pp->state == ZOMBIE){
    8000188c:	4c9c                	lw	a5,24(s1)
    8000188e:	f94781e3          	beq	a5,s4,80001810 <wait+0x56>
        release(&pp->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	d4a080e7          	jalr	-694(ra) # 800065de <release>
        havekids = 1;
    8000189c:	8756                	mv	a4,s5
    8000189e:	bfd9                	j	80001874 <wait+0xba>
    if(!havekids || killed(p)){
    800018a0:	c719                	beqz	a4,800018ae <wait+0xf4>
    800018a2:	854a                	mv	a0,s2
    800018a4:	00000097          	auipc	ra,0x0
    800018a8:	ee4080e7          	jalr	-284(ra) # 80001788 <killed>
    800018ac:	c51d                	beqz	a0,800018da <wait+0x120>
      release(&wait_lock);
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	0ba50513          	addi	a0,a0,186 # 80008968 <wait_lock>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	d28080e7          	jalr	-728(ra) # 800065de <release>
      return -1;
    800018be:	59fd                	li	s3,-1
}
    800018c0:	854e                	mv	a0,s3
    800018c2:	60a6                	ld	ra,72(sp)
    800018c4:	6406                	ld	s0,64(sp)
    800018c6:	74e2                	ld	s1,56(sp)
    800018c8:	7942                	ld	s2,48(sp)
    800018ca:	79a2                	ld	s3,40(sp)
    800018cc:	7a02                	ld	s4,32(sp)
    800018ce:	6ae2                	ld	s5,24(sp)
    800018d0:	6b42                	ld	s6,16(sp)
    800018d2:	6ba2                	ld	s7,8(sp)
    800018d4:	6c02                	ld	s8,0(sp)
    800018d6:	6161                	addi	sp,sp,80
    800018d8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018da:	85e2                	mv	a1,s8
    800018dc:	854a                	mv	a0,s2
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	c02080e7          	jalr	-1022(ra) # 800014e0 <sleep>
    havekids = 0;
    800018e6:	bf39                	j	80001804 <wait+0x4a>

00000000800018e8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e8:	7179                	addi	sp,sp,-48
    800018ea:	f406                	sd	ra,40(sp)
    800018ec:	f022                	sd	s0,32(sp)
    800018ee:	ec26                	sd	s1,24(sp)
    800018f0:	e84a                	sd	s2,16(sp)
    800018f2:	e44e                	sd	s3,8(sp)
    800018f4:	e052                	sd	s4,0(sp)
    800018f6:	1800                	addi	s0,sp,48
    800018f8:	84aa                	mv	s1,a0
    800018fa:	892e                	mv	s2,a1
    800018fc:	89b2                	mv	s3,a2
    800018fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	538080e7          	jalr	1336(ra) # 80000e38 <myproc>
  if(user_dst){
    80001908:	c08d                	beqz	s1,8000192a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000190a:	86d2                	mv	a3,s4
    8000190c:	864e                	mv	a2,s3
    8000190e:	85ca                	mv	a1,s2
    80001910:	6928                	ld	a0,80(a0)
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	1e2080e7          	jalr	482(ra) # 80000af4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000191a:	70a2                	ld	ra,40(sp)
    8000191c:	7402                	ld	s0,32(sp)
    8000191e:	64e2                	ld	s1,24(sp)
    80001920:	6942                	ld	s2,16(sp)
    80001922:	69a2                	ld	s3,8(sp)
    80001924:	6a02                	ld	s4,0(sp)
    80001926:	6145                	addi	sp,sp,48
    80001928:	8082                	ret
    memmove((char *)dst, src, len);
    8000192a:	000a061b          	sext.w	a2,s4
    8000192e:	85ce                	mv	a1,s3
    80001930:	854a                	mv	a0,s2
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	8a2080e7          	jalr	-1886(ra) # 800001d4 <memmove>
    return 0;
    8000193a:	8526                	mv	a0,s1
    8000193c:	bff9                	j	8000191a <either_copyout+0x32>

000000008000193e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000193e:	7179                	addi	sp,sp,-48
    80001940:	f406                	sd	ra,40(sp)
    80001942:	f022                	sd	s0,32(sp)
    80001944:	ec26                	sd	s1,24(sp)
    80001946:	e84a                	sd	s2,16(sp)
    80001948:	e44e                	sd	s3,8(sp)
    8000194a:	e052                	sd	s4,0(sp)
    8000194c:	1800                	addi	s0,sp,48
    8000194e:	892a                	mv	s2,a0
    80001950:	84ae                	mv	s1,a1
    80001952:	89b2                	mv	s3,a2
    80001954:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	4e2080e7          	jalr	1250(ra) # 80000e38 <myproc>
  if(user_src){
    8000195e:	c08d                	beqz	s1,80001980 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001960:	86d2                	mv	a3,s4
    80001962:	864e                	mv	a2,s3
    80001964:	85ca                	mv	a1,s2
    80001966:	6928                	ld	a0,80(a0)
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	218080e7          	jalr	536(ra) # 80000b80 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001970:	70a2                	ld	ra,40(sp)
    80001972:	7402                	ld	s0,32(sp)
    80001974:	64e2                	ld	s1,24(sp)
    80001976:	6942                	ld	s2,16(sp)
    80001978:	69a2                	ld	s3,8(sp)
    8000197a:	6a02                	ld	s4,0(sp)
    8000197c:	6145                	addi	sp,sp,48
    8000197e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001980:	000a061b          	sext.w	a2,s4
    80001984:	85ce                	mv	a1,s3
    80001986:	854a                	mv	a0,s2
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	84c080e7          	jalr	-1972(ra) # 800001d4 <memmove>
    return 0;
    80001990:	8526                	mv	a0,s1
    80001992:	bff9                	j	80001970 <either_copyin+0x32>

0000000080001994 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001994:	715d                	addi	sp,sp,-80
    80001996:	e486                	sd	ra,72(sp)
    80001998:	e0a2                	sd	s0,64(sp)
    8000199a:	fc26                	sd	s1,56(sp)
    8000199c:	f84a                	sd	s2,48(sp)
    8000199e:	f44e                	sd	s3,40(sp)
    800019a0:	f052                	sd	s4,32(sp)
    800019a2:	ec56                	sd	s5,24(sp)
    800019a4:	e85a                	sd	s6,16(sp)
    800019a6:	e45e                	sd	s7,8(sp)
    800019a8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019aa:	00006517          	auipc	a0,0x6
    800019ae:	69e50513          	addi	a0,a0,1694 # 80008048 <etext+0x48>
    800019b2:	00004097          	auipc	ra,0x4
    800019b6:	686080e7          	jalr	1670(ra) # 80006038 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ba:	00007497          	auipc	s1,0x7
    800019be:	51e48493          	addi	s1,s1,1310 # 80008ed8 <proc+0x158>
    800019c2:	00019917          	auipc	s2,0x19
    800019c6:	f1690913          	addi	s2,s2,-234 # 8001a8d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ca:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019cc:	00006997          	auipc	s3,0x6
    800019d0:	7fc98993          	addi	s3,s3,2044 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    800019d4:	00006a97          	auipc	s5,0x6
    800019d8:	7fca8a93          	addi	s5,s5,2044 # 800081d0 <etext+0x1d0>
    printf("\n");
    800019dc:	00006a17          	auipc	s4,0x6
    800019e0:	66ca0a13          	addi	s4,s4,1644 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	00007b97          	auipc	s7,0x7
    800019e8:	82cb8b93          	addi	s7,s7,-2004 # 80008210 <states.0>
    800019ec:	a00d                	j	80001a0e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	ed86a583          	lw	a1,-296(a3)
    800019f2:	8556                	mv	a0,s5
    800019f4:	00004097          	auipc	ra,0x4
    800019f8:	644080e7          	jalr	1604(ra) # 80006038 <printf>
    printf("\n");
    800019fc:	8552                	mv	a0,s4
    800019fe:	00004097          	auipc	ra,0x4
    80001a02:	63a080e7          	jalr	1594(ra) # 80006038 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a06:	46848493          	addi	s1,s1,1128
    80001a0a:	03248263          	beq	s1,s2,80001a2e <procdump+0x9a>
    if(p->state == UNUSED)
    80001a0e:	86a6                	mv	a3,s1
    80001a10:	ec04a783          	lw	a5,-320(s1)
    80001a14:	dbed                	beqz	a5,80001a06 <procdump+0x72>
      state = "???";
    80001a16:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a18:	fcfb6be3          	bltu	s6,a5,800019ee <procdump+0x5a>
    80001a1c:	02079713          	slli	a4,a5,0x20
    80001a20:	01d75793          	srli	a5,a4,0x1d
    80001a24:	97de                	add	a5,a5,s7
    80001a26:	6390                	ld	a2,0(a5)
    80001a28:	f279                	bnez	a2,800019ee <procdump+0x5a>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    80001a2c:	b7c9                	j	800019ee <procdump+0x5a>
  }
}
    80001a2e:	60a6                	ld	ra,72(sp)
    80001a30:	6406                	ld	s0,64(sp)
    80001a32:	74e2                	ld	s1,56(sp)
    80001a34:	7942                	ld	s2,48(sp)
    80001a36:	79a2                	ld	s3,40(sp)
    80001a38:	7a02                	ld	s4,32(sp)
    80001a3a:	6ae2                	ld	s5,24(sp)
    80001a3c:	6b42                	ld	s6,16(sp)
    80001a3e:	6ba2                	ld	s7,8(sp)
    80001a40:	6161                	addi	sp,sp,80
    80001a42:	8082                	ret

0000000080001a44 <swtch>:
    80001a44:	00153023          	sd	ra,0(a0)
    80001a48:	00253423          	sd	sp,8(a0)
    80001a4c:	e900                	sd	s0,16(a0)
    80001a4e:	ed04                	sd	s1,24(a0)
    80001a50:	03253023          	sd	s2,32(a0)
    80001a54:	03353423          	sd	s3,40(a0)
    80001a58:	03453823          	sd	s4,48(a0)
    80001a5c:	03553c23          	sd	s5,56(a0)
    80001a60:	05653023          	sd	s6,64(a0)
    80001a64:	05753423          	sd	s7,72(a0)
    80001a68:	05853823          	sd	s8,80(a0)
    80001a6c:	05953c23          	sd	s9,88(a0)
    80001a70:	07a53023          	sd	s10,96(a0)
    80001a74:	07b53423          	sd	s11,104(a0)
    80001a78:	0005b083          	ld	ra,0(a1)
    80001a7c:	0085b103          	ld	sp,8(a1)
    80001a80:	6980                	ld	s0,16(a1)
    80001a82:	6d84                	ld	s1,24(a1)
    80001a84:	0205b903          	ld	s2,32(a1)
    80001a88:	0285b983          	ld	s3,40(a1)
    80001a8c:	0305ba03          	ld	s4,48(a1)
    80001a90:	0385ba83          	ld	s5,56(a1)
    80001a94:	0405bb03          	ld	s6,64(a1)
    80001a98:	0485bb83          	ld	s7,72(a1)
    80001a9c:	0505bc03          	ld	s8,80(a1)
    80001aa0:	0585bc83          	ld	s9,88(a1)
    80001aa4:	0605bd03          	ld	s10,96(a1)
    80001aa8:	0685bd83          	ld	s11,104(a1)
    80001aac:	8082                	ret

0000000080001aae <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001aae:	1141                	addi	sp,sp,-16
    80001ab0:	e406                	sd	ra,8(sp)
    80001ab2:	e022                	sd	s0,0(sp)
    80001ab4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab6:	00006597          	auipc	a1,0x6
    80001aba:	78a58593          	addi	a1,a1,1930 # 80008240 <states.0+0x30>
    80001abe:	00019517          	auipc	a0,0x19
    80001ac2:	cc250513          	addi	a0,a0,-830 # 8001a780 <tickslock>
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	9d4080e7          	jalr	-1580(ra) # 8000649a <initlock>
}
    80001ace:	60a2                	ld	ra,8(sp)
    80001ad0:	6402                	ld	s0,0(sp)
    80001ad2:	0141                	addi	sp,sp,16
    80001ad4:	8082                	ret

0000000080001ad6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001ad6:	1141                	addi	sp,sp,-16
    80001ad8:	e422                	sd	s0,8(sp)
    80001ada:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001adc:	00004797          	auipc	a5,0x4
    80001ae0:	94478793          	addi	a5,a5,-1724 # 80005420 <kernelvec>
    80001ae4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae8:	6422                	ld	s0,8(sp)
    80001aea:	0141                	addi	sp,sp,16
    80001aec:	8082                	ret

0000000080001aee <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e406                	sd	ra,8(sp)
    80001af2:	e022                	sd	s0,0(sp)
    80001af4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af6:	fffff097          	auipc	ra,0xfffff
    80001afa:	342080e7          	jalr	834(ra) # 80000e38 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001afe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b04:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b08:	00005617          	auipc	a2,0x5
    80001b0c:	4f860613          	addi	a2,a2,1272 # 80007000 <_trampoline>
    80001b10:	00005697          	auipc	a3,0x5
    80001b14:	4f068693          	addi	a3,a3,1264 # 80007000 <_trampoline>
    80001b18:	8e91                	sub	a3,a3,a2
    80001b1a:	040007b7          	lui	a5,0x4000
    80001b1e:	17fd                	addi	a5,a5,-1
    80001b20:	07b2                	slli	a5,a5,0xc
    80001b22:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b24:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b28:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b2a:	180026f3          	csrr	a3,satp
    80001b2e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b30:	6d38                	ld	a4,88(a0)
    80001b32:	6134                	ld	a3,64(a0)
    80001b34:	6585                	lui	a1,0x1
    80001b36:	96ae                	add	a3,a3,a1
    80001b38:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b3a:	6d38                	ld	a4,88(a0)
    80001b3c:	00000697          	auipc	a3,0x0
    80001b40:	13068693          	addi	a3,a3,304 # 80001c6c <usertrap>
    80001b44:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b46:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b48:	8692                	mv	a3,tp
    80001b4a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b50:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b54:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b58:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b5c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5e:	6f18                	ld	a4,24(a4)
    80001b60:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b64:	6928                	ld	a0,80(a0)
    80001b66:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b68:	00005717          	auipc	a4,0x5
    80001b6c:	53470713          	addi	a4,a4,1332 # 8000709c <userret>
    80001b70:	8f11                	sub	a4,a4,a2
    80001b72:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b74:	577d                	li	a4,-1
    80001b76:	177e                	slli	a4,a4,0x3f
    80001b78:	8d59                	or	a0,a0,a4
    80001b7a:	9782                	jalr	a5
}
    80001b7c:	60a2                	ld	ra,8(sp)
    80001b7e:	6402                	ld	s0,0(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8e:	00019497          	auipc	s1,0x19
    80001b92:	bf248493          	addi	s1,s1,-1038 # 8001a780 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00005097          	auipc	ra,0x5
    80001b9c:	992080e7          	jalr	-1646(ra) # 8000652a <acquire>
  ticks++;
    80001ba0:	00007517          	auipc	a0,0x7
    80001ba4:	d7850513          	addi	a0,a0,-648 # 80008918 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	996080e7          	jalr	-1642(ra) # 80001544 <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00005097          	auipc	ra,0x5
    80001bbc:	a26080e7          	jalr	-1498(ra) # 800065de <release>
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001bd8:	00074d63          	bltz	a4,80001bf2 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001bdc:	57fd                	li	a5,-1
    80001bde:	17fe                	slli	a5,a5,0x3f
    80001be0:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001be2:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001be4:	06f70363          	beq	a4,a5,80001c4a <devintr+0x80>
  }
}
    80001be8:	60e2                	ld	ra,24(sp)
    80001bea:	6442                	ld	s0,16(sp)
    80001bec:	64a2                	ld	s1,8(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret
      (scause & 0xff) == 9)
    80001bf2:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80001bf6:	46a5                	li	a3,9
    80001bf8:	fed792e3          	bne	a5,a3,80001bdc <devintr+0x12>
    int irq = plic_claim();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	92c080e7          	jalr	-1748(ra) # 80005528 <plic_claim>
    80001c04:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001c06:	47a9                	li	a5,10
    80001c08:	02f50763          	beq	a0,a5,80001c36 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001c0c:	4785                	li	a5,1
    80001c0e:	02f50963          	beq	a0,a5,80001c40 <devintr+0x76>
    return 1;
    80001c12:	4505                	li	a0,1
    else if (irq)
    80001c14:	d8f1                	beqz	s1,80001be8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c16:	85a6                	mv	a1,s1
    80001c18:	00006517          	auipc	a0,0x6
    80001c1c:	63050513          	addi	a0,a0,1584 # 80008248 <states.0+0x38>
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	418080e7          	jalr	1048(ra) # 80006038 <printf>
      plic_complete(irq);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	922080e7          	jalr	-1758(ra) # 8000554c <plic_complete>
    return 1;
    80001c32:	4505                	li	a0,1
    80001c34:	bf55                	j	80001be8 <devintr+0x1e>
      uartintr();
    80001c36:	00005097          	auipc	ra,0x5
    80001c3a:	814080e7          	jalr	-2028(ra) # 8000644a <uartintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x5e>
      virtio_disk_intr();
    80001c40:	00004097          	auipc	ra,0x4
    80001c44:	dd8080e7          	jalr	-552(ra) # 80005a18 <virtio_disk_intr>
    80001c48:	b7c5                	j	80001c28 <devintr+0x5e>
    if (cpuid() == 0)
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	1c2080e7          	jalr	450(ra) # 80000e0c <cpuid>
    80001c52:	c901                	beqz	a0,80001c62 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c54:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c5a:	14479073          	csrw	sip,a5
    return 2;
    80001c5e:	4509                	li	a0,2
    80001c60:	b761                	j	80001be8 <devintr+0x1e>
      clockintr();
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	f22080e7          	jalr	-222(ra) # 80001b84 <clockintr>
    80001c6a:	b7ed                	j	80001c54 <devintr+0x8a>

0000000080001c6c <usertrap>:
{
    80001c6c:	7139                	addi	sp,sp,-64
    80001c6e:	fc06                	sd	ra,56(sp)
    80001c70:	f822                	sd	s0,48(sp)
    80001c72:	f426                	sd	s1,40(sp)
    80001c74:	f04a                	sd	s2,32(sp)
    80001c76:	ec4e                	sd	s3,24(sp)
    80001c78:	e852                	sd	s4,16(sp)
    80001c7a:	e456                	sd	s5,8(sp)
    80001c7c:	e05a                	sd	s6,0(sp)
    80001c7e:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c80:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001c84:	1007f793          	andi	a5,a5,256
    80001c88:	e7c1                	bnez	a5,80001d10 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8a:	00003797          	auipc	a5,0x3
    80001c8e:	79678793          	addi	a5,a5,1942 # 80005420 <kernelvec>
    80001c92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	1a2080e7          	jalr	418(ra) # 80000e38 <myproc>
    80001c9e:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001ca0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ca2:	14102773          	csrr	a4,sepc
    80001ca6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca8:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001cac:	47a1                	li	a5,8
    80001cae:	06f70963          	beq	a4,a5,80001d20 <usertrap+0xb4>
  else if ((which_dev = devintr()) != 0)
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	f18080e7          	jalr	-232(ra) # 80001bca <devintr>
    80001cba:	84aa                	mv	s1,a0
    80001cbc:	18051963          	bnez	a0,80001e4e <usertrap+0x1e2>
    80001cc0:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001cc4:	47b5                	li	a5,13
    80001cc6:	0af70c63          	beq	a4,a5,80001d7e <usertrap+0x112>
    80001cca:	14202773          	csrr	a4,scause
    80001cce:	47bd                	li	a5,15
    80001cd0:	0af70763          	beq	a4,a5,80001d7e <usertrap+0x112>
    80001cd4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd8:	03092603          	lw	a2,48(s2)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5c450513          	addi	a0,a0,1476 # 800082a0 <states.0+0x90>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	354080e7          	jalr	852(ra) # 80006038 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5dc50513          	addi	a0,a0,1500 # 800082d0 <states.0+0xc0>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	33c080e7          	jalr	828(ra) # 80006038 <printf>
    setkilled(p);
    80001d04:	854a                	mv	a0,s2
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	a56080e7          	jalr	-1450(ra) # 8000175c <setkilled>
    80001d0e:	a82d                	j	80001d48 <usertrap+0xdc>
    panic("usertrap: not from user mode");
    80001d10:	00006517          	auipc	a0,0x6
    80001d14:	55850513          	addi	a0,a0,1368 # 80008268 <states.0+0x58>
    80001d18:	00004097          	auipc	ra,0x4
    80001d1c:	2d6080e7          	jalr	726(ra) # 80005fee <panic>
    if (killed(p))
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	a68080e7          	jalr	-1432(ra) # 80001788 <killed>
    80001d28:	e529                	bnez	a0,80001d72 <usertrap+0x106>
    p->trapframe->epc += 4;
    80001d2a:	05893703          	ld	a4,88(s2)
    80001d2e:	6f1c                	ld	a5,24(a4)
    80001d30:	0791                	addi	a5,a5,4
    80001d32:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d34:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d38:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d3c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	382080e7          	jalr	898(ra) # 800020c2 <syscall>
  if (killed(p))
    80001d48:	854a                	mv	a0,s2
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a3e080e7          	jalr	-1474(ra) # 80001788 <killed>
    80001d52:	10051563          	bnez	a0,80001e5c <usertrap+0x1f0>
  usertrapret();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	d98080e7          	jalr	-616(ra) # 80001aee <usertrapret>
}
    80001d5e:	70e2                	ld	ra,56(sp)
    80001d60:	7442                	ld	s0,48(sp)
    80001d62:	74a2                	ld	s1,40(sp)
    80001d64:	7902                	ld	s2,32(sp)
    80001d66:	69e2                	ld	s3,24(sp)
    80001d68:	6a42                	ld	s4,16(sp)
    80001d6a:	6aa2                	ld	s5,8(sp)
    80001d6c:	6b02                	ld	s6,0(sp)
    80001d6e:	6121                	addi	sp,sp,64
    80001d70:	8082                	ret
      exit(-1);
    80001d72:	557d                	li	a0,-1
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	8a0080e7          	jalr	-1888(ra) # 80001614 <exit>
    80001d7c:	b77d                	j	80001d2a <usertrap+0xbe>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7e:	14302a73          	csrr	s4,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001d82:	77fd                	lui	a5,0xfffff
    80001d84:	00fa7a33          	and	s4,s4,a5
    void *mem = kalloc();
    80001d88:	ffffe097          	auipc	ra,0xffffe
    80001d8c:	390080e7          	jalr	912(ra) # 80000118 <kalloc>
    80001d90:	8aaa                	mv	s5,a0
    if (mem == 0)
    80001d92:	d129                	beqz	a0,80001cd4 <usertrap+0x68>
    80001d94:	16890793          	addi	a5,s2,360
    80001d98:	a021                	j	80001da0 <usertrap+0x134>
    for (int i = 0; i < MAXVA; i++)
    80001d9a:	2485                	addiw	s1,s1,1
    80001d9c:	03078793          	addi	a5,a5,48 # fffffffffffff030 <end+0xffffffff7ffd1290>
      if (va >= (uint64)p->vma[i].addr && va < (uint64)p->vma[i].addr + p->sz)
    80001da0:	0007b983          	ld	s3,0(a5)
    80001da4:	ff3a6be3          	bltu	s4,s3,80001d9a <usertrap+0x12e>
    80001da8:	04893703          	ld	a4,72(s2)
    80001dac:	974e                	add	a4,a4,s3
    80001dae:	feea76e3          	bgeu	s4,a4,80001d9a <usertrap+0x12e>
    if (idx == -1)
    80001db2:	57fd                	li	a5,-1
    80001db4:	f2f480e3          	beq	s1,a5,80001cd4 <usertrap+0x68>
      struct vma v = p->vma[idx];
    80001db8:	00149793          	slli	a5,s1,0x1
    80001dbc:	00978733          	add	a4,a5,s1
    80001dc0:	0712                	slli	a4,a4,0x4
    80001dc2:	974a                	add	a4,a4,s2
    80001dc4:	18072b03          	lw	s6,384(a4)
    80001dc8:	19073483          	ld	s1,400(a4)
      memset(mem, 0, PGSIZE); // zero out the memory
    80001dcc:	6605                	lui	a2,0x1
    80001dce:	4581                	li	a1,0
    80001dd0:	8556                	mv	a0,s5
    80001dd2:	ffffe097          	auipc	ra,0xffffe
    80001dd6:	3a6080e7          	jalr	934(ra) # 80000178 <memset>
      if (mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80001dda:	4779                	li	a4,30
    80001ddc:	86d6                	mv	a3,s5
    80001dde:	6605                	lui	a2,0x1
    80001de0:	85d2                	mv	a1,s4
    80001de2:	05093503          	ld	a0,80(s2)
    80001de6:	ffffe097          	auipc	ra,0xffffe
    80001dea:	75e080e7          	jalr	1886(ra) # 80000544 <mappages>
    80001dee:	e931                	bnez	a0,80001e42 <usertrap+0x1d6>
      ilock(v.ip); // lock the inode
    80001df0:	8526                	mv	a0,s1
    80001df2:	00001097          	auipc	ra,0x1
    80001df6:	dd4080e7          	jalr	-556(ra) # 80002bc6 <ilock>
      readi(v.ip, 0, (uint64)mem, va - (uint64)v.addr + v.offset, PGSIZE);
    80001dfa:	016a06bb          	addw	a3,s4,s6
    80001dfe:	6705                	lui	a4,0x1
    80001e00:	413686bb          	subw	a3,a3,s3
    80001e04:	8656                	mv	a2,s5
    80001e06:	4581                	li	a1,0
    80001e08:	8526                	mv	a0,s1
    80001e0a:	00001097          	auipc	ra,0x1
    80001e0e:	070080e7          	jalr	112(ra) # 80002e7a <readi>
      printf("usertrap(): off %d\n", va - (uint64)v.addr);
    80001e12:	413a05b3          	sub	a1,s4,s3
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	47250513          	addi	a0,a0,1138 # 80008288 <states.0+0x78>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	21a080e7          	jalr	538(ra) # 80006038 <printf>
      iunlock(v.ip); // unlock the inode
    80001e26:	8526                	mv	a0,s1
    80001e28:	00001097          	auipc	ra,0x1
    80001e2c:	e60080e7          	jalr	-416(ra) # 80002c88 <iunlock>
      if (p->killed)
    80001e30:	02892783          	lw	a5,40(s2)
    80001e34:	db91                	beqz	a5,80001d48 <usertrap+0xdc>
        exit(-1);
    80001e36:	557d                	li	a0,-1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	7dc080e7          	jalr	2012(ra) # 80001614 <exit>
    80001e40:	b721                	j	80001d48 <usertrap+0xdc>
        kfree(mem);
    80001e42:	8556                	mv	a0,s5
    80001e44:	ffffe097          	auipc	ra,0xffffe
    80001e48:	1d8080e7          	jalr	472(ra) # 8000001c <kfree>
        goto err;
    80001e4c:	b561                	j	80001cd4 <usertrap+0x68>
  if (killed(p))
    80001e4e:	854a                	mv	a0,s2
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	938080e7          	jalr	-1736(ra) # 80001788 <killed>
    80001e58:	c901                	beqz	a0,80001e68 <usertrap+0x1fc>
    80001e5a:	a011                	j	80001e5e <usertrap+0x1f2>
    80001e5c:	4481                	li	s1,0
    exit(-1);
    80001e5e:	557d                	li	a0,-1
    80001e60:	fffff097          	auipc	ra,0xfffff
    80001e64:	7b4080e7          	jalr	1972(ra) # 80001614 <exit>
  if (which_dev == 2)
    80001e68:	4789                	li	a5,2
    80001e6a:	eef496e3          	bne	s1,a5,80001d56 <usertrap+0xea>
    yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	636080e7          	jalr	1590(ra) # 800014a4 <yield>
    80001e76:	b5c5                	j	80001d56 <usertrap+0xea>

0000000080001e78 <kerneltrap>:
{
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	e84a                	sd	s2,16(sp)
    80001e82:	e44e                	sd	s3,8(sp)
    80001e84:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e86:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e8e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e92:	1004f793          	andi	a5,s1,256
    80001e96:	cb85                	beqz	a5,80001ec6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e9c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001e9e:	ef85                	bnez	a5,80001ed6 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	d2a080e7          	jalr	-726(ra) # 80001bca <devintr>
    80001ea8:	cd1d                	beqz	a0,80001ee6 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eaa:	4789                	li	a5,2
    80001eac:	06f50a63          	beq	a0,a5,80001f20 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eb0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb4:	10049073          	csrw	sstatus,s1
}
    80001eb8:	70a2                	ld	ra,40(sp)
    80001eba:	7402                	ld	s0,32(sp)
    80001ebc:	64e2                	ld	s1,24(sp)
    80001ebe:	6942                	ld	s2,16(sp)
    80001ec0:	69a2                	ld	s3,8(sp)
    80001ec2:	6145                	addi	sp,sp,48
    80001ec4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	42a50513          	addi	a0,a0,1066 # 800082f0 <states.0+0xe0>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	120080e7          	jalr	288(ra) # 80005fee <panic>
    panic("kerneltrap: interrupts enabled");
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	44250513          	addi	a0,a0,1090 # 80008318 <states.0+0x108>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	110080e7          	jalr	272(ra) # 80005fee <panic>
    printf("scause %p\n", scause);
    80001ee6:	85ce                	mv	a1,s3
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	45050513          	addi	a0,a0,1104 # 80008338 <states.0+0x128>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	148080e7          	jalr	328(ra) # 80006038 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	44850513          	addi	a0,a0,1096 # 80008348 <states.0+0x138>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	130080e7          	jalr	304(ra) # 80006038 <printf>
    panic("kerneltrap");
    80001f10:	00006517          	auipc	a0,0x6
    80001f14:	45050513          	addi	a0,a0,1104 # 80008360 <states.0+0x150>
    80001f18:	00004097          	auipc	ra,0x4
    80001f1c:	0d6080e7          	jalr	214(ra) # 80005fee <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	f18080e7          	jalr	-232(ra) # 80000e38 <myproc>
    80001f28:	d541                	beqz	a0,80001eb0 <kerneltrap+0x38>
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	f0e080e7          	jalr	-242(ra) # 80000e38 <myproc>
    80001f32:	4d18                	lw	a4,24(a0)
    80001f34:	4791                	li	a5,4
    80001f36:	f6f71de3          	bne	a4,a5,80001eb0 <kerneltrap+0x38>
    yield();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	56a080e7          	jalr	1386(ra) # 800014a4 <yield>
    80001f42:	b7bd                	j	80001eb0 <kerneltrap+0x38>

0000000080001f44 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	ee8080e7          	jalr	-280(ra) # 80000e38 <myproc>
  switch (n) {
    80001f58:	4795                	li	a5,5
    80001f5a:	0497e163          	bltu	a5,s1,80001f9c <argraw+0x58>
    80001f5e:	048a                	slli	s1,s1,0x2
    80001f60:	00006717          	auipc	a4,0x6
    80001f64:	43870713          	addi	a4,a4,1080 # 80008398 <states.0+0x188>
    80001f68:	94ba                	add	s1,s1,a4
    80001f6a:	409c                	lw	a5,0(s1)
    80001f6c:	97ba                	add	a5,a5,a4
    80001f6e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f70:	6d3c                	ld	a5,88(a0)
    80001f72:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6105                	addi	sp,sp,32
    80001f7c:	8082                	ret
    return p->trapframe->a1;
    80001f7e:	6d3c                	ld	a5,88(a0)
    80001f80:	7fa8                	ld	a0,120(a5)
    80001f82:	bfcd                	j	80001f74 <argraw+0x30>
    return p->trapframe->a2;
    80001f84:	6d3c                	ld	a5,88(a0)
    80001f86:	63c8                	ld	a0,128(a5)
    80001f88:	b7f5                	j	80001f74 <argraw+0x30>
    return p->trapframe->a3;
    80001f8a:	6d3c                	ld	a5,88(a0)
    80001f8c:	67c8                	ld	a0,136(a5)
    80001f8e:	b7dd                	j	80001f74 <argraw+0x30>
    return p->trapframe->a4;
    80001f90:	6d3c                	ld	a5,88(a0)
    80001f92:	6bc8                	ld	a0,144(a5)
    80001f94:	b7c5                	j	80001f74 <argraw+0x30>
    return p->trapframe->a5;
    80001f96:	6d3c                	ld	a5,88(a0)
    80001f98:	6fc8                	ld	a0,152(a5)
    80001f9a:	bfe9                	j	80001f74 <argraw+0x30>
  panic("argraw");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	3d450513          	addi	a0,a0,980 # 80008370 <states.0+0x160>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	04a080e7          	jalr	74(ra) # 80005fee <panic>

0000000080001fac <fetchaddr>:
{
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	e04a                	sd	s2,0(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84aa                	mv	s1,a0
    80001fba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	e7c080e7          	jalr	-388(ra) # 80000e38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fc4:	653c                	ld	a5,72(a0)
    80001fc6:	02f4f863          	bgeu	s1,a5,80001ff6 <fetchaddr+0x4a>
    80001fca:	00848713          	addi	a4,s1,8
    80001fce:	02e7e663          	bltu	a5,a4,80001ffa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fd2:	46a1                	li	a3,8
    80001fd4:	8626                	mv	a2,s1
    80001fd6:	85ca                	mv	a1,s2
    80001fd8:	6928                	ld	a0,80(a0)
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	ba6080e7          	jalr	-1114(ra) # 80000b80 <copyin>
    80001fe2:	00a03533          	snez	a0,a0
    80001fe6:	40a00533          	neg	a0,a0
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret
    return -1;
    80001ff6:	557d                	li	a0,-1
    80001ff8:	bfcd                	j	80001fea <fetchaddr+0x3e>
    80001ffa:	557d                	li	a0,-1
    80001ffc:	b7fd                	j	80001fea <fetchaddr+0x3e>

0000000080001ffe <fetchstr>:
{
    80001ffe:	7179                	addi	sp,sp,-48
    80002000:	f406                	sd	ra,40(sp)
    80002002:	f022                	sd	s0,32(sp)
    80002004:	ec26                	sd	s1,24(sp)
    80002006:	e84a                	sd	s2,16(sp)
    80002008:	e44e                	sd	s3,8(sp)
    8000200a:	1800                	addi	s0,sp,48
    8000200c:	892a                	mv	s2,a0
    8000200e:	84ae                	mv	s1,a1
    80002010:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	e26080e7          	jalr	-474(ra) # 80000e38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000201a:	86ce                	mv	a3,s3
    8000201c:	864a                	mv	a2,s2
    8000201e:	85a6                	mv	a1,s1
    80002020:	6928                	ld	a0,80(a0)
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	bec080e7          	jalr	-1044(ra) # 80000c0e <copyinstr>
    8000202a:	00054e63          	bltz	a0,80002046 <fetchstr+0x48>
  return strlen(buf);
    8000202e:	8526                	mv	a0,s1
    80002030:	ffffe097          	auipc	ra,0xffffe
    80002034:	2c4080e7          	jalr	708(ra) # 800002f4 <strlen>
}
    80002038:	70a2                	ld	ra,40(sp)
    8000203a:	7402                	ld	s0,32(sp)
    8000203c:	64e2                	ld	s1,24(sp)
    8000203e:	6942                	ld	s2,16(sp)
    80002040:	69a2                	ld	s3,8(sp)
    80002042:	6145                	addi	sp,sp,48
    80002044:	8082                	ret
    return -1;
    80002046:	557d                	li	a0,-1
    80002048:	bfc5                	j	80002038 <fetchstr+0x3a>

000000008000204a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	addi	s0,sp,32
    80002054:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	eee080e7          	jalr	-274(ra) # 80001f44 <argraw>
    8000205e:	c088                	sw	a0,0(s1)
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	ece080e7          	jalr	-306(ra) # 80001f44 <argraw>
    8000207e:	e088                	sd	a0,0(s1)
}
    80002080:	60e2                	ld	ra,24(sp)
    80002082:	6442                	ld	s0,16(sp)
    80002084:	64a2                	ld	s1,8(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000208a:	7179                	addi	sp,sp,-48
    8000208c:	f406                	sd	ra,40(sp)
    8000208e:	f022                	sd	s0,32(sp)
    80002090:	ec26                	sd	s1,24(sp)
    80002092:	e84a                	sd	s2,16(sp)
    80002094:	1800                	addi	s0,sp,48
    80002096:	84ae                	mv	s1,a1
    80002098:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000209a:	fd840593          	addi	a1,s0,-40
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	fcc080e7          	jalr	-52(ra) # 8000206a <argaddr>
  return fetchstr(addr, buf, max);
    800020a6:	864a                	mv	a2,s2
    800020a8:	85a6                	mv	a1,s1
    800020aa:	fd843503          	ld	a0,-40(s0)
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	f50080e7          	jalr	-176(ra) # 80001ffe <fetchstr>
}
    800020b6:	70a2                	ld	ra,40(sp)
    800020b8:	7402                	ld	s0,32(sp)
    800020ba:	64e2                	ld	s1,24(sp)
    800020bc:	6942                	ld	s2,16(sp)
    800020be:	6145                	addi	sp,sp,48
    800020c0:	8082                	ret

00000000800020c2 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	e426                	sd	s1,8(sp)
    800020ca:	e04a                	sd	s2,0(sp)
    800020cc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	d6a080e7          	jalr	-662(ra) # 80000e38 <myproc>
    800020d6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d8:	05853903          	ld	s2,88(a0)
    800020dc:	0a893783          	ld	a5,168(s2)
    800020e0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020e4:	37fd                	addiw	a5,a5,-1
    800020e6:	4759                	li	a4,22
    800020e8:	00f76f63          	bltu	a4,a5,80002106 <syscall+0x44>
    800020ec:	00369713          	slli	a4,a3,0x3
    800020f0:	00006797          	auipc	a5,0x6
    800020f4:	2c078793          	addi	a5,a5,704 # 800083b0 <syscalls>
    800020f8:	97ba                	add	a5,a5,a4
    800020fa:	639c                	ld	a5,0(a5)
    800020fc:	c789                	beqz	a5,80002106 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020fe:	9782                	jalr	a5
    80002100:	06a93823          	sd	a0,112(s2)
    80002104:	a839                	j	80002122 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002106:	15848613          	addi	a2,s1,344
    8000210a:	588c                	lw	a1,48(s1)
    8000210c:	00006517          	auipc	a0,0x6
    80002110:	26c50513          	addi	a0,a0,620 # 80008378 <states.0+0x168>
    80002114:	00004097          	auipc	ra,0x4
    80002118:	f24080e7          	jalr	-220(ra) # 80006038 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000211c:	6cbc                	ld	a5,88(s1)
    8000211e:	577d                	li	a4,-1
    80002120:	fbb8                	sd	a4,112(a5)
  }
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	64a2                	ld	s1,8(sp)
    80002128:	6902                	ld	s2,0(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000212e:	1101                	addi	sp,sp,-32
    80002130:	ec06                	sd	ra,24(sp)
    80002132:	e822                	sd	s0,16(sp)
    80002134:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002136:	fec40593          	addi	a1,s0,-20
    8000213a:	4501                	li	a0,0
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	f0e080e7          	jalr	-242(ra) # 8000204a <argint>
  exit(n);
    80002144:	fec42503          	lw	a0,-20(s0)
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	4cc080e7          	jalr	1228(ra) # 80001614 <exit>
  return 0;  // not reached
}
    80002150:	4501                	li	a0,0
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000215a:	1141                	addi	sp,sp,-16
    8000215c:	e406                	sd	ra,8(sp)
    8000215e:	e022                	sd	s0,0(sp)
    80002160:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	cd6080e7          	jalr	-810(ra) # 80000e38 <myproc>
}
    8000216a:	5908                	lw	a0,48(a0)
    8000216c:	60a2                	ld	ra,8(sp)
    8000216e:	6402                	ld	s0,0(sp)
    80002170:	0141                	addi	sp,sp,16
    80002172:	8082                	ret

0000000080002174 <sys_fork>:

uint64
sys_fork(void)
{
    80002174:	1141                	addi	sp,sp,-16
    80002176:	e406                	sd	ra,8(sp)
    80002178:	e022                	sd	s0,0(sp)
    8000217a:	0800                	addi	s0,sp,16
  return fork();
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	072080e7          	jalr	114(ra) # 800011ee <fork>
}
    80002184:	60a2                	ld	ra,8(sp)
    80002186:	6402                	ld	s0,0(sp)
    80002188:	0141                	addi	sp,sp,16
    8000218a:	8082                	ret

000000008000218c <sys_wait>:

uint64
sys_wait(void)
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002194:	fe840593          	addi	a1,s0,-24
    80002198:	4501                	li	a0,0
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	ed0080e7          	jalr	-304(ra) # 8000206a <argaddr>
  return wait(p);
    800021a2:	fe843503          	ld	a0,-24(s0)
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	614080e7          	jalr	1556(ra) # 800017ba <wait>
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021b6:	7179                	addi	sp,sp,-48
    800021b8:	f406                	sd	ra,40(sp)
    800021ba:	f022                	sd	s0,32(sp)
    800021bc:	ec26                	sd	s1,24(sp)
    800021be:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021c0:	fdc40593          	addi	a1,s0,-36
    800021c4:	4501                	li	a0,0
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	e84080e7          	jalr	-380(ra) # 8000204a <argint>
  addr = myproc()->sz;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	c6a080e7          	jalr	-918(ra) # 80000e38 <myproc>
    800021d6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021d8:	fdc42503          	lw	a0,-36(s0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	fb6080e7          	jalr	-74(ra) # 80001192 <growproc>
    800021e4:	00054863          	bltz	a0,800021f4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021e8:	8526                	mv	a0,s1
    800021ea:	70a2                	ld	ra,40(sp)
    800021ec:	7402                	ld	s0,32(sp)
    800021ee:	64e2                	ld	s1,24(sp)
    800021f0:	6145                	addi	sp,sp,48
    800021f2:	8082                	ret
    return -1;
    800021f4:	54fd                	li	s1,-1
    800021f6:	bfcd                	j	800021e8 <sys_sbrk+0x32>

00000000800021f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021f8:	7139                	addi	sp,sp,-64
    800021fa:	fc06                	sd	ra,56(sp)
    800021fc:	f822                	sd	s0,48(sp)
    800021fe:	f426                	sd	s1,40(sp)
    80002200:	f04a                	sd	s2,32(sp)
    80002202:	ec4e                	sd	s3,24(sp)
    80002204:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002206:	fcc40593          	addi	a1,s0,-52
    8000220a:	4501                	li	a0,0
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	e3e080e7          	jalr	-450(ra) # 8000204a <argint>
  if(n < 0)
    80002214:	fcc42783          	lw	a5,-52(s0)
    80002218:	0607cf63          	bltz	a5,80002296 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000221c:	00018517          	auipc	a0,0x18
    80002220:	56450513          	addi	a0,a0,1380 # 8001a780 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	306080e7          	jalr	774(ra) # 8000652a <acquire>
  ticks0 = ticks;
    8000222c:	00006917          	auipc	s2,0x6
    80002230:	6ec92903          	lw	s2,1772(s2) # 80008918 <ticks>
  while(ticks - ticks0 < n){
    80002234:	fcc42783          	lw	a5,-52(s0)
    80002238:	cf9d                	beqz	a5,80002276 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000223a:	00018997          	auipc	s3,0x18
    8000223e:	54698993          	addi	s3,s3,1350 # 8001a780 <tickslock>
    80002242:	00006497          	auipc	s1,0x6
    80002246:	6d648493          	addi	s1,s1,1750 # 80008918 <ticks>
    if(killed(myproc())){
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	bee080e7          	jalr	-1042(ra) # 80000e38 <myproc>
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	536080e7          	jalr	1334(ra) # 80001788 <killed>
    8000225a:	e129                	bnez	a0,8000229c <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000225c:	85ce                	mv	a1,s3
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	280080e7          	jalr	640(ra) # 800014e0 <sleep>
  while(ticks - ticks0 < n){
    80002268:	409c                	lw	a5,0(s1)
    8000226a:	412787bb          	subw	a5,a5,s2
    8000226e:	fcc42703          	lw	a4,-52(s0)
    80002272:	fce7ece3          	bltu	a5,a4,8000224a <sys_sleep+0x52>
  }
  release(&tickslock);
    80002276:	00018517          	auipc	a0,0x18
    8000227a:	50a50513          	addi	a0,a0,1290 # 8001a780 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	360080e7          	jalr	864(ra) # 800065de <release>
  return 0;
    80002286:	4501                	li	a0,0
}
    80002288:	70e2                	ld	ra,56(sp)
    8000228a:	7442                	ld	s0,48(sp)
    8000228c:	74a2                	ld	s1,40(sp)
    8000228e:	7902                	ld	s2,32(sp)
    80002290:	69e2                	ld	s3,24(sp)
    80002292:	6121                	addi	sp,sp,64
    80002294:	8082                	ret
    n = 0;
    80002296:	fc042623          	sw	zero,-52(s0)
    8000229a:	b749                	j	8000221c <sys_sleep+0x24>
      release(&tickslock);
    8000229c:	00018517          	auipc	a0,0x18
    800022a0:	4e450513          	addi	a0,a0,1252 # 8001a780 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	33a080e7          	jalr	826(ra) # 800065de <release>
      return -1;
    800022ac:	557d                	li	a0,-1
    800022ae:	bfe9                	j	80002288 <sys_sleep+0x90>

00000000800022b0 <sys_kill>:

uint64
sys_kill(void)
{
    800022b0:	1101                	addi	sp,sp,-32
    800022b2:	ec06                	sd	ra,24(sp)
    800022b4:	e822                	sd	s0,16(sp)
    800022b6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022b8:	fec40593          	addi	a1,s0,-20
    800022bc:	4501                	li	a0,0
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	d8c080e7          	jalr	-628(ra) # 8000204a <argint>
  return kill(pid);
    800022c6:	fec42503          	lw	a0,-20(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	420080e7          	jalr	1056(ra) # 800016ea <kill>
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	6105                	addi	sp,sp,32
    800022d8:	8082                	ret

00000000800022da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022da:	1101                	addi	sp,sp,-32
    800022dc:	ec06                	sd	ra,24(sp)
    800022de:	e822                	sd	s0,16(sp)
    800022e0:	e426                	sd	s1,8(sp)
    800022e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022e4:	00018517          	auipc	a0,0x18
    800022e8:	49c50513          	addi	a0,a0,1180 # 8001a780 <tickslock>
    800022ec:	00004097          	auipc	ra,0x4
    800022f0:	23e080e7          	jalr	574(ra) # 8000652a <acquire>
  xticks = ticks;
    800022f4:	00006497          	auipc	s1,0x6
    800022f8:	6244a483          	lw	s1,1572(s1) # 80008918 <ticks>
  release(&tickslock);
    800022fc:	00018517          	auipc	a0,0x18
    80002300:	48450513          	addi	a0,a0,1156 # 8001a780 <tickslock>
    80002304:	00004097          	auipc	ra,0x4
    80002308:	2da080e7          	jalr	730(ra) # 800065de <release>
  return xticks;
}
    8000230c:	02049513          	slli	a0,s1,0x20
    80002310:	9101                	srli	a0,a0,0x20
    80002312:	60e2                	ld	ra,24(sp)
    80002314:	6442                	ld	s0,16(sp)
    80002316:	64a2                	ld	s1,8(sp)
    80002318:	6105                	addi	sp,sp,32
    8000231a:	8082                	ret

000000008000231c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000231c:	7179                	addi	sp,sp,-48
    8000231e:	f406                	sd	ra,40(sp)
    80002320:	f022                	sd	s0,32(sp)
    80002322:	ec26                	sd	s1,24(sp)
    80002324:	e84a                	sd	s2,16(sp)
    80002326:	e44e                	sd	s3,8(sp)
    80002328:	e052                	sd	s4,0(sp)
    8000232a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000232c:	00006597          	auipc	a1,0x6
    80002330:	14458593          	addi	a1,a1,324 # 80008470 <syscalls+0xc0>
    80002334:	00018517          	auipc	a0,0x18
    80002338:	46450513          	addi	a0,a0,1124 # 8001a798 <bcache>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	15e080e7          	jalr	350(ra) # 8000649a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002344:	00020797          	auipc	a5,0x20
    80002348:	45478793          	addi	a5,a5,1108 # 80022798 <bcache+0x8000>
    8000234c:	00020717          	auipc	a4,0x20
    80002350:	6b470713          	addi	a4,a4,1716 # 80022a00 <bcache+0x8268>
    80002354:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002358:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000235c:	00018497          	auipc	s1,0x18
    80002360:	45448493          	addi	s1,s1,1108 # 8001a7b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002364:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002366:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002368:	00006a17          	auipc	s4,0x6
    8000236c:	110a0a13          	addi	s4,s4,272 # 80008478 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002370:	2b893783          	ld	a5,696(s2)
    80002374:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002376:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000237a:	85d2                	mv	a1,s4
    8000237c:	01048513          	addi	a0,s1,16
    80002380:	00001097          	auipc	ra,0x1
    80002384:	4ca080e7          	jalr	1226(ra) # 8000384a <initsleeplock>
    bcache.head.next->prev = b;
    80002388:	2b893783          	ld	a5,696(s2)
    8000238c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000238e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002392:	45848493          	addi	s1,s1,1112
    80002396:	fd349de3          	bne	s1,s3,80002370 <binit+0x54>
  }
}
    8000239a:	70a2                	ld	ra,40(sp)
    8000239c:	7402                	ld	s0,32(sp)
    8000239e:	64e2                	ld	s1,24(sp)
    800023a0:	6942                	ld	s2,16(sp)
    800023a2:	69a2                	ld	s3,8(sp)
    800023a4:	6a02                	ld	s4,0(sp)
    800023a6:	6145                	addi	sp,sp,48
    800023a8:	8082                	ret

00000000800023aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023aa:	7179                	addi	sp,sp,-48
    800023ac:	f406                	sd	ra,40(sp)
    800023ae:	f022                	sd	s0,32(sp)
    800023b0:	ec26                	sd	s1,24(sp)
    800023b2:	e84a                	sd	s2,16(sp)
    800023b4:	e44e                	sd	s3,8(sp)
    800023b6:	1800                	addi	s0,sp,48
    800023b8:	892a                	mv	s2,a0
    800023ba:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023bc:	00018517          	auipc	a0,0x18
    800023c0:	3dc50513          	addi	a0,a0,988 # 8001a798 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	166080e7          	jalr	358(ra) # 8000652a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023cc:	00020497          	auipc	s1,0x20
    800023d0:	6844b483          	ld	s1,1668(s1) # 80022a50 <bcache+0x82b8>
    800023d4:	00020797          	auipc	a5,0x20
    800023d8:	62c78793          	addi	a5,a5,1580 # 80022a00 <bcache+0x8268>
    800023dc:	02f48f63          	beq	s1,a5,8000241a <bread+0x70>
    800023e0:	873e                	mv	a4,a5
    800023e2:	a021                	j	800023ea <bread+0x40>
    800023e4:	68a4                	ld	s1,80(s1)
    800023e6:	02e48a63          	beq	s1,a4,8000241a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023ea:	449c                	lw	a5,8(s1)
    800023ec:	ff279ce3          	bne	a5,s2,800023e4 <bread+0x3a>
    800023f0:	44dc                	lw	a5,12(s1)
    800023f2:	ff3799e3          	bne	a5,s3,800023e4 <bread+0x3a>
      b->refcnt++;
    800023f6:	40bc                	lw	a5,64(s1)
    800023f8:	2785                	addiw	a5,a5,1
    800023fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023fc:	00018517          	auipc	a0,0x18
    80002400:	39c50513          	addi	a0,a0,924 # 8001a798 <bcache>
    80002404:	00004097          	auipc	ra,0x4
    80002408:	1da080e7          	jalr	474(ra) # 800065de <release>
      acquiresleep(&b->lock);
    8000240c:	01048513          	addi	a0,s1,16
    80002410:	00001097          	auipc	ra,0x1
    80002414:	474080e7          	jalr	1140(ra) # 80003884 <acquiresleep>
      return b;
    80002418:	a8b9                	j	80002476 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000241a:	00020497          	auipc	s1,0x20
    8000241e:	62e4b483          	ld	s1,1582(s1) # 80022a48 <bcache+0x82b0>
    80002422:	00020797          	auipc	a5,0x20
    80002426:	5de78793          	addi	a5,a5,1502 # 80022a00 <bcache+0x8268>
    8000242a:	00f48863          	beq	s1,a5,8000243a <bread+0x90>
    8000242e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002430:	40bc                	lw	a5,64(s1)
    80002432:	cf81                	beqz	a5,8000244a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002434:	64a4                	ld	s1,72(s1)
    80002436:	fee49de3          	bne	s1,a4,80002430 <bread+0x86>
  panic("bget: no buffers");
    8000243a:	00006517          	auipc	a0,0x6
    8000243e:	04650513          	addi	a0,a0,70 # 80008480 <syscalls+0xd0>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	bac080e7          	jalr	-1108(ra) # 80005fee <panic>
      b->dev = dev;
    8000244a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000244e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002452:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002456:	4785                	li	a5,1
    80002458:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000245a:	00018517          	auipc	a0,0x18
    8000245e:	33e50513          	addi	a0,a0,830 # 8001a798 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	17c080e7          	jalr	380(ra) # 800065de <release>
      acquiresleep(&b->lock);
    8000246a:	01048513          	addi	a0,s1,16
    8000246e:	00001097          	auipc	ra,0x1
    80002472:	416080e7          	jalr	1046(ra) # 80003884 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002476:	409c                	lw	a5,0(s1)
    80002478:	cb89                	beqz	a5,8000248a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000247a:	8526                	mv	a0,s1
    8000247c:	70a2                	ld	ra,40(sp)
    8000247e:	7402                	ld	s0,32(sp)
    80002480:	64e2                	ld	s1,24(sp)
    80002482:	6942                	ld	s2,16(sp)
    80002484:	69a2                	ld	s3,8(sp)
    80002486:	6145                	addi	sp,sp,48
    80002488:	8082                	ret
    virtio_disk_rw(b, 0);
    8000248a:	4581                	li	a1,0
    8000248c:	8526                	mv	a0,s1
    8000248e:	00003097          	auipc	ra,0x3
    80002492:	356080e7          	jalr	854(ra) # 800057e4 <virtio_disk_rw>
    b->valid = 1;
    80002496:	4785                	li	a5,1
    80002498:	c09c                	sw	a5,0(s1)
  return b;
    8000249a:	b7c5                	j	8000247a <bread+0xd0>

000000008000249c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000249c:	1101                	addi	sp,sp,-32
    8000249e:	ec06                	sd	ra,24(sp)
    800024a0:	e822                	sd	s0,16(sp)
    800024a2:	e426                	sd	s1,8(sp)
    800024a4:	1000                	addi	s0,sp,32
    800024a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024a8:	0541                	addi	a0,a0,16
    800024aa:	00001097          	auipc	ra,0x1
    800024ae:	474080e7          	jalr	1140(ra) # 8000391e <holdingsleep>
    800024b2:	cd01                	beqz	a0,800024ca <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024b4:	4585                	li	a1,1
    800024b6:	8526                	mv	a0,s1
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	32c080e7          	jalr	812(ra) # 800057e4 <virtio_disk_rw>
}
    800024c0:	60e2                	ld	ra,24(sp)
    800024c2:	6442                	ld	s0,16(sp)
    800024c4:	64a2                	ld	s1,8(sp)
    800024c6:	6105                	addi	sp,sp,32
    800024c8:	8082                	ret
    panic("bwrite");
    800024ca:	00006517          	auipc	a0,0x6
    800024ce:	fce50513          	addi	a0,a0,-50 # 80008498 <syscalls+0xe8>
    800024d2:	00004097          	auipc	ra,0x4
    800024d6:	b1c080e7          	jalr	-1252(ra) # 80005fee <panic>

00000000800024da <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	e04a                	sd	s2,0(sp)
    800024e4:	1000                	addi	s0,sp,32
    800024e6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e8:	01050913          	addi	s2,a0,16
    800024ec:	854a                	mv	a0,s2
    800024ee:	00001097          	auipc	ra,0x1
    800024f2:	430080e7          	jalr	1072(ra) # 8000391e <holdingsleep>
    800024f6:	c92d                	beqz	a0,80002568 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024f8:	854a                	mv	a0,s2
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	3e0080e7          	jalr	992(ra) # 800038da <releasesleep>

  acquire(&bcache.lock);
    80002502:	00018517          	auipc	a0,0x18
    80002506:	29650513          	addi	a0,a0,662 # 8001a798 <bcache>
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	020080e7          	jalr	32(ra) # 8000652a <acquire>
  b->refcnt--;
    80002512:	40bc                	lw	a5,64(s1)
    80002514:	37fd                	addiw	a5,a5,-1
    80002516:	0007871b          	sext.w	a4,a5
    8000251a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000251c:	eb05                	bnez	a4,8000254c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000251e:	68bc                	ld	a5,80(s1)
    80002520:	64b8                	ld	a4,72(s1)
    80002522:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002524:	64bc                	ld	a5,72(s1)
    80002526:	68b8                	ld	a4,80(s1)
    80002528:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000252a:	00020797          	auipc	a5,0x20
    8000252e:	26e78793          	addi	a5,a5,622 # 80022798 <bcache+0x8000>
    80002532:	2b87b703          	ld	a4,696(a5)
    80002536:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002538:	00020717          	auipc	a4,0x20
    8000253c:	4c870713          	addi	a4,a4,1224 # 80022a00 <bcache+0x8268>
    80002540:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002542:	2b87b703          	ld	a4,696(a5)
    80002546:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002548:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000254c:	00018517          	auipc	a0,0x18
    80002550:	24c50513          	addi	a0,a0,588 # 8001a798 <bcache>
    80002554:	00004097          	auipc	ra,0x4
    80002558:	08a080e7          	jalr	138(ra) # 800065de <release>
}
    8000255c:	60e2                	ld	ra,24(sp)
    8000255e:	6442                	ld	s0,16(sp)
    80002560:	64a2                	ld	s1,8(sp)
    80002562:	6902                	ld	s2,0(sp)
    80002564:	6105                	addi	sp,sp,32
    80002566:	8082                	ret
    panic("brelse");
    80002568:	00006517          	auipc	a0,0x6
    8000256c:	f3850513          	addi	a0,a0,-200 # 800084a0 <syscalls+0xf0>
    80002570:	00004097          	auipc	ra,0x4
    80002574:	a7e080e7          	jalr	-1410(ra) # 80005fee <panic>

0000000080002578 <bpin>:

void
bpin(struct buf *b) {
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
    80002582:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002584:	00018517          	auipc	a0,0x18
    80002588:	21450513          	addi	a0,a0,532 # 8001a798 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	f9e080e7          	jalr	-98(ra) # 8000652a <acquire>
  b->refcnt++;
    80002594:	40bc                	lw	a5,64(s1)
    80002596:	2785                	addiw	a5,a5,1
    80002598:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000259a:	00018517          	auipc	a0,0x18
    8000259e:	1fe50513          	addi	a0,a0,510 # 8001a798 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	03c080e7          	jalr	60(ra) # 800065de <release>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret

00000000800025b4 <bunpin>:

void
bunpin(struct buf *b) {
    800025b4:	1101                	addi	sp,sp,-32
    800025b6:	ec06                	sd	ra,24(sp)
    800025b8:	e822                	sd	s0,16(sp)
    800025ba:	e426                	sd	s1,8(sp)
    800025bc:	1000                	addi	s0,sp,32
    800025be:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c0:	00018517          	auipc	a0,0x18
    800025c4:	1d850513          	addi	a0,a0,472 # 8001a798 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	f62080e7          	jalr	-158(ra) # 8000652a <acquire>
  b->refcnt--;
    800025d0:	40bc                	lw	a5,64(s1)
    800025d2:	37fd                	addiw	a5,a5,-1
    800025d4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d6:	00018517          	auipc	a0,0x18
    800025da:	1c250513          	addi	a0,a0,450 # 8001a798 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	000080e7          	jalr	ra # 800065de <release>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret

00000000800025f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025f0:	1101                	addi	sp,sp,-32
    800025f2:	ec06                	sd	ra,24(sp)
    800025f4:	e822                	sd	s0,16(sp)
    800025f6:	e426                	sd	s1,8(sp)
    800025f8:	e04a                	sd	s2,0(sp)
    800025fa:	1000                	addi	s0,sp,32
    800025fc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025fe:	00d5d59b          	srliw	a1,a1,0xd
    80002602:	00021797          	auipc	a5,0x21
    80002606:	8727a783          	lw	a5,-1934(a5) # 80022e74 <sb+0x1c>
    8000260a:	9dbd                	addw	a1,a1,a5
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	d9e080e7          	jalr	-610(ra) # 800023aa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002614:	0074f713          	andi	a4,s1,7
    80002618:	4785                	li	a5,1
    8000261a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000261e:	14ce                	slli	s1,s1,0x33
    80002620:	90d9                	srli	s1,s1,0x36
    80002622:	00950733          	add	a4,a0,s1
    80002626:	05874703          	lbu	a4,88(a4)
    8000262a:	00e7f6b3          	and	a3,a5,a4
    8000262e:	c69d                	beqz	a3,8000265c <bfree+0x6c>
    80002630:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002632:	94aa                	add	s1,s1,a0
    80002634:	fff7c793          	not	a5,a5
    80002638:	8ff9                	and	a5,a5,a4
    8000263a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	126080e7          	jalr	294(ra) # 80003764 <log_write>
  brelse(bp);
    80002646:	854a                	mv	a0,s2
    80002648:	00000097          	auipc	ra,0x0
    8000264c:	e92080e7          	jalr	-366(ra) # 800024da <brelse>
}
    80002650:	60e2                	ld	ra,24(sp)
    80002652:	6442                	ld	s0,16(sp)
    80002654:	64a2                	ld	s1,8(sp)
    80002656:	6902                	ld	s2,0(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret
    panic("freeing free block");
    8000265c:	00006517          	auipc	a0,0x6
    80002660:	e4c50513          	addi	a0,a0,-436 # 800084a8 <syscalls+0xf8>
    80002664:	00004097          	auipc	ra,0x4
    80002668:	98a080e7          	jalr	-1654(ra) # 80005fee <panic>

000000008000266c <balloc>:
{
    8000266c:	711d                	addi	sp,sp,-96
    8000266e:	ec86                	sd	ra,88(sp)
    80002670:	e8a2                	sd	s0,80(sp)
    80002672:	e4a6                	sd	s1,72(sp)
    80002674:	e0ca                	sd	s2,64(sp)
    80002676:	fc4e                	sd	s3,56(sp)
    80002678:	f852                	sd	s4,48(sp)
    8000267a:	f456                	sd	s5,40(sp)
    8000267c:	f05a                	sd	s6,32(sp)
    8000267e:	ec5e                	sd	s7,24(sp)
    80002680:	e862                	sd	s8,16(sp)
    80002682:	e466                	sd	s9,8(sp)
    80002684:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002686:	00020797          	auipc	a5,0x20
    8000268a:	7d67a783          	lw	a5,2006(a5) # 80022e5c <sb+0x4>
    8000268e:	10078163          	beqz	a5,80002790 <balloc+0x124>
    80002692:	8baa                	mv	s7,a0
    80002694:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002696:	00020b17          	auipc	s6,0x20
    8000269a:	7c2b0b13          	addi	s6,s6,1986 # 80022e58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000269e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026a4:	6c89                	lui	s9,0x2
    800026a6:	a061                	j	8000272e <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026a8:	974a                	add	a4,a4,s2
    800026aa:	8fd5                	or	a5,a5,a3
    800026ac:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	0b2080e7          	jalr	178(ra) # 80003764 <log_write>
        brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	e1e080e7          	jalr	-482(ra) # 800024da <brelse>
  bp = bread(dev, bno);
    800026c4:	85a6                	mv	a1,s1
    800026c6:	855e                	mv	a0,s7
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	ce2080e7          	jalr	-798(ra) # 800023aa <bread>
    800026d0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026d2:	40000613          	li	a2,1024
    800026d6:	4581                	li	a1,0
    800026d8:	05850513          	addi	a0,a0,88
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	a9c080e7          	jalr	-1380(ra) # 80000178 <memset>
  log_write(bp);
    800026e4:	854a                	mv	a0,s2
    800026e6:	00001097          	auipc	ra,0x1
    800026ea:	07e080e7          	jalr	126(ra) # 80003764 <log_write>
  brelse(bp);
    800026ee:	854a                	mv	a0,s2
    800026f0:	00000097          	auipc	ra,0x0
    800026f4:	dea080e7          	jalr	-534(ra) # 800024da <brelse>
}
    800026f8:	8526                	mv	a0,s1
    800026fa:	60e6                	ld	ra,88(sp)
    800026fc:	6446                	ld	s0,80(sp)
    800026fe:	64a6                	ld	s1,72(sp)
    80002700:	6906                	ld	s2,64(sp)
    80002702:	79e2                	ld	s3,56(sp)
    80002704:	7a42                	ld	s4,48(sp)
    80002706:	7aa2                	ld	s5,40(sp)
    80002708:	7b02                	ld	s6,32(sp)
    8000270a:	6be2                	ld	s7,24(sp)
    8000270c:	6c42                	ld	s8,16(sp)
    8000270e:	6ca2                	ld	s9,8(sp)
    80002710:	6125                	addi	sp,sp,96
    80002712:	8082                	ret
    brelse(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	dc4080e7          	jalr	-572(ra) # 800024da <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000271e:	015c87bb          	addw	a5,s9,s5
    80002722:	00078a9b          	sext.w	s5,a5
    80002726:	004b2703          	lw	a4,4(s6)
    8000272a:	06eaf363          	bgeu	s5,a4,80002790 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000272e:	41fad79b          	sraiw	a5,s5,0x1f
    80002732:	0137d79b          	srliw	a5,a5,0x13
    80002736:	015787bb          	addw	a5,a5,s5
    8000273a:	40d7d79b          	sraiw	a5,a5,0xd
    8000273e:	01cb2583          	lw	a1,28(s6)
    80002742:	9dbd                	addw	a1,a1,a5
    80002744:	855e                	mv	a0,s7
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	c64080e7          	jalr	-924(ra) # 800023aa <bread>
    8000274e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002750:	004b2503          	lw	a0,4(s6)
    80002754:	000a849b          	sext.w	s1,s5
    80002758:	8662                	mv	a2,s8
    8000275a:	faa4fde3          	bgeu	s1,a0,80002714 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000275e:	41f6579b          	sraiw	a5,a2,0x1f
    80002762:	01d7d69b          	srliw	a3,a5,0x1d
    80002766:	00c6873b          	addw	a4,a3,a2
    8000276a:	00777793          	andi	a5,a4,7
    8000276e:	9f95                	subw	a5,a5,a3
    80002770:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002774:	4037571b          	sraiw	a4,a4,0x3
    80002778:	00e906b3          	add	a3,s2,a4
    8000277c:	0586c683          	lbu	a3,88(a3)
    80002780:	00d7f5b3          	and	a1,a5,a3
    80002784:	d195                	beqz	a1,800026a8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002786:	2605                	addiw	a2,a2,1
    80002788:	2485                	addiw	s1,s1,1
    8000278a:	fd4618e3          	bne	a2,s4,8000275a <balloc+0xee>
    8000278e:	b759                	j	80002714 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002790:	00006517          	auipc	a0,0x6
    80002794:	d3050513          	addi	a0,a0,-720 # 800084c0 <syscalls+0x110>
    80002798:	00004097          	auipc	ra,0x4
    8000279c:	8a0080e7          	jalr	-1888(ra) # 80006038 <printf>
  return 0;
    800027a0:	4481                	li	s1,0
    800027a2:	bf99                	j	800026f8 <balloc+0x8c>

00000000800027a4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027a4:	7179                	addi	sp,sp,-48
    800027a6:	f406                	sd	ra,40(sp)
    800027a8:	f022                	sd	s0,32(sp)
    800027aa:	ec26                	sd	s1,24(sp)
    800027ac:	e84a                	sd	s2,16(sp)
    800027ae:	e44e                	sd	s3,8(sp)
    800027b0:	e052                	sd	s4,0(sp)
    800027b2:	1800                	addi	s0,sp,48
    800027b4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027b6:	47ad                	li	a5,11
    800027b8:	02b7e863          	bltu	a5,a1,800027e8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027bc:	02059793          	slli	a5,a1,0x20
    800027c0:	01e7d593          	srli	a1,a5,0x1e
    800027c4:	00b504b3          	add	s1,a0,a1
    800027c8:	0504a903          	lw	s2,80(s1)
    800027cc:	06091e63          	bnez	s2,80002848 <bmap+0xa4>
      addr = balloc(ip->dev);
    800027d0:	4108                	lw	a0,0(a0)
    800027d2:	00000097          	auipc	ra,0x0
    800027d6:	e9a080e7          	jalr	-358(ra) # 8000266c <balloc>
    800027da:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027de:	06090563          	beqz	s2,80002848 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800027e2:	0524a823          	sw	s2,80(s1)
    800027e6:	a08d                	j	80002848 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027e8:	ff45849b          	addiw	s1,a1,-12
    800027ec:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f0:	0ff00793          	li	a5,255
    800027f4:	08e7e563          	bltu	a5,a4,8000287e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027f8:	08052903          	lw	s2,128(a0)
    800027fc:	00091d63          	bnez	s2,80002816 <bmap+0x72>
      addr = balloc(ip->dev);
    80002800:	4108                	lw	a0,0(a0)
    80002802:	00000097          	auipc	ra,0x0
    80002806:	e6a080e7          	jalr	-406(ra) # 8000266c <balloc>
    8000280a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000280e:	02090d63          	beqz	s2,80002848 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002812:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002816:	85ca                	mv	a1,s2
    80002818:	0009a503          	lw	a0,0(s3)
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	b8e080e7          	jalr	-1138(ra) # 800023aa <bread>
    80002824:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002826:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000282a:	02049713          	slli	a4,s1,0x20
    8000282e:	01e75593          	srli	a1,a4,0x1e
    80002832:	00b784b3          	add	s1,a5,a1
    80002836:	0004a903          	lw	s2,0(s1)
    8000283a:	02090063          	beqz	s2,8000285a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000283e:	8552                	mv	a0,s4
    80002840:	00000097          	auipc	ra,0x0
    80002844:	c9a080e7          	jalr	-870(ra) # 800024da <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002848:	854a                	mv	a0,s2
    8000284a:	70a2                	ld	ra,40(sp)
    8000284c:	7402                	ld	s0,32(sp)
    8000284e:	64e2                	ld	s1,24(sp)
    80002850:	6942                	ld	s2,16(sp)
    80002852:	69a2                	ld	s3,8(sp)
    80002854:	6a02                	ld	s4,0(sp)
    80002856:	6145                	addi	sp,sp,48
    80002858:	8082                	ret
      addr = balloc(ip->dev);
    8000285a:	0009a503          	lw	a0,0(s3)
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	e0e080e7          	jalr	-498(ra) # 8000266c <balloc>
    80002866:	0005091b          	sext.w	s2,a0
      if(addr){
    8000286a:	fc090ae3          	beqz	s2,8000283e <bmap+0x9a>
        a[bn] = addr;
    8000286e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002872:	8552                	mv	a0,s4
    80002874:	00001097          	auipc	ra,0x1
    80002878:	ef0080e7          	jalr	-272(ra) # 80003764 <log_write>
    8000287c:	b7c9                	j	8000283e <bmap+0x9a>
  panic("bmap: out of range");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	c5a50513          	addi	a0,a0,-934 # 800084d8 <syscalls+0x128>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	768080e7          	jalr	1896(ra) # 80005fee <panic>

000000008000288e <iget>:
{
    8000288e:	7179                	addi	sp,sp,-48
    80002890:	f406                	sd	ra,40(sp)
    80002892:	f022                	sd	s0,32(sp)
    80002894:	ec26                	sd	s1,24(sp)
    80002896:	e84a                	sd	s2,16(sp)
    80002898:	e44e                	sd	s3,8(sp)
    8000289a:	e052                	sd	s4,0(sp)
    8000289c:	1800                	addi	s0,sp,48
    8000289e:	89aa                	mv	s3,a0
    800028a0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a2:	00020517          	auipc	a0,0x20
    800028a6:	5d650513          	addi	a0,a0,1494 # 80022e78 <itable>
    800028aa:	00004097          	auipc	ra,0x4
    800028ae:	c80080e7          	jalr	-896(ra) # 8000652a <acquire>
  empty = 0;
    800028b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b4:	00020497          	auipc	s1,0x20
    800028b8:	5dc48493          	addi	s1,s1,1500 # 80022e90 <itable+0x18>
    800028bc:	00022697          	auipc	a3,0x22
    800028c0:	06468693          	addi	a3,a3,100 # 80024920 <log>
    800028c4:	a039                	j	800028d2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c6:	02090b63          	beqz	s2,800028fc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ca:	08848493          	addi	s1,s1,136
    800028ce:	02d48a63          	beq	s1,a3,80002902 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d2:	449c                	lw	a5,8(s1)
    800028d4:	fef059e3          	blez	a5,800028c6 <iget+0x38>
    800028d8:	4098                	lw	a4,0(s1)
    800028da:	ff3716e3          	bne	a4,s3,800028c6 <iget+0x38>
    800028de:	40d8                	lw	a4,4(s1)
    800028e0:	ff4713e3          	bne	a4,s4,800028c6 <iget+0x38>
      ip->ref++;
    800028e4:	2785                	addiw	a5,a5,1
    800028e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e8:	00020517          	auipc	a0,0x20
    800028ec:	59050513          	addi	a0,a0,1424 # 80022e78 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	cee080e7          	jalr	-786(ra) # 800065de <release>
      return ip;
    800028f8:	8926                	mv	s2,s1
    800028fa:	a03d                	j	80002928 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fc:	f7f9                	bnez	a5,800028ca <iget+0x3c>
    800028fe:	8926                	mv	s2,s1
    80002900:	b7e9                	j	800028ca <iget+0x3c>
  if(empty == 0)
    80002902:	02090c63          	beqz	s2,8000293a <iget+0xac>
  ip->dev = dev;
    80002906:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000290a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000290e:	4785                	li	a5,1
    80002910:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002914:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002918:	00020517          	auipc	a0,0x20
    8000291c:	56050513          	addi	a0,a0,1376 # 80022e78 <itable>
    80002920:	00004097          	auipc	ra,0x4
    80002924:	cbe080e7          	jalr	-834(ra) # 800065de <release>
}
    80002928:	854a                	mv	a0,s2
    8000292a:	70a2                	ld	ra,40(sp)
    8000292c:	7402                	ld	s0,32(sp)
    8000292e:	64e2                	ld	s1,24(sp)
    80002930:	6942                	ld	s2,16(sp)
    80002932:	69a2                	ld	s3,8(sp)
    80002934:	6a02                	ld	s4,0(sp)
    80002936:	6145                	addi	sp,sp,48
    80002938:	8082                	ret
    panic("iget: no inodes");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	bb650513          	addi	a0,a0,-1098 # 800084f0 <syscalls+0x140>
    80002942:	00003097          	auipc	ra,0x3
    80002946:	6ac080e7          	jalr	1708(ra) # 80005fee <panic>

000000008000294a <fsinit>:
fsinit(int dev) {
    8000294a:	7179                	addi	sp,sp,-48
    8000294c:	f406                	sd	ra,40(sp)
    8000294e:	f022                	sd	s0,32(sp)
    80002950:	ec26                	sd	s1,24(sp)
    80002952:	e84a                	sd	s2,16(sp)
    80002954:	e44e                	sd	s3,8(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295a:	4585                	li	a1,1
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	a4e080e7          	jalr	-1458(ra) # 800023aa <bread>
    80002964:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002966:	00020997          	auipc	s3,0x20
    8000296a:	4f298993          	addi	s3,s3,1266 # 80022e58 <sb>
    8000296e:	02000613          	li	a2,32
    80002972:	05850593          	addi	a1,a0,88
    80002976:	854e                	mv	a0,s3
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	85c080e7          	jalr	-1956(ra) # 800001d4 <memmove>
  brelse(bp);
    80002980:	8526                	mv	a0,s1
    80002982:	00000097          	auipc	ra,0x0
    80002986:	b58080e7          	jalr	-1192(ra) # 800024da <brelse>
  if(sb.magic != FSMAGIC)
    8000298a:	0009a703          	lw	a4,0(s3)
    8000298e:	102037b7          	lui	a5,0x10203
    80002992:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002996:	02f71263          	bne	a4,a5,800029ba <fsinit+0x70>
  initlog(dev, &sb);
    8000299a:	00020597          	auipc	a1,0x20
    8000299e:	4be58593          	addi	a1,a1,1214 # 80022e58 <sb>
    800029a2:	854a                	mv	a0,s2
    800029a4:	00001097          	auipc	ra,0x1
    800029a8:	b42080e7          	jalr	-1214(ra) # 800034e6 <initlog>
}
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    panic("invalid file system");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	b4650513          	addi	a0,a0,-1210 # 80008500 <syscalls+0x150>
    800029c2:	00003097          	auipc	ra,0x3
    800029c6:	62c080e7          	jalr	1580(ra) # 80005fee <panic>

00000000800029ca <iinit>:
{
    800029ca:	7179                	addi	sp,sp,-48
    800029cc:	f406                	sd	ra,40(sp)
    800029ce:	f022                	sd	s0,32(sp)
    800029d0:	ec26                	sd	s1,24(sp)
    800029d2:	e84a                	sd	s2,16(sp)
    800029d4:	e44e                	sd	s3,8(sp)
    800029d6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d8:	00006597          	auipc	a1,0x6
    800029dc:	b4058593          	addi	a1,a1,-1216 # 80008518 <syscalls+0x168>
    800029e0:	00020517          	auipc	a0,0x20
    800029e4:	49850513          	addi	a0,a0,1176 # 80022e78 <itable>
    800029e8:	00004097          	auipc	ra,0x4
    800029ec:	ab2080e7          	jalr	-1358(ra) # 8000649a <initlock>
  for(i = 0; i < NINODE; i++) {
    800029f0:	00020497          	auipc	s1,0x20
    800029f4:	4b048493          	addi	s1,s1,1200 # 80022ea0 <itable+0x28>
    800029f8:	00022997          	auipc	s3,0x22
    800029fc:	f3898993          	addi	s3,s3,-200 # 80024930 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a00:	00006917          	auipc	s2,0x6
    80002a04:	b2090913          	addi	s2,s2,-1248 # 80008520 <syscalls+0x170>
    80002a08:	85ca                	mv	a1,s2
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	00001097          	auipc	ra,0x1
    80002a10:	e3e080e7          	jalr	-450(ra) # 8000384a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a14:	08848493          	addi	s1,s1,136
    80002a18:	ff3498e3          	bne	s1,s3,80002a08 <iinit+0x3e>
}
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret

0000000080002a2a <ialloc>:
{
    80002a2a:	715d                	addi	sp,sp,-80
    80002a2c:	e486                	sd	ra,72(sp)
    80002a2e:	e0a2                	sd	s0,64(sp)
    80002a30:	fc26                	sd	s1,56(sp)
    80002a32:	f84a                	sd	s2,48(sp)
    80002a34:	f44e                	sd	s3,40(sp)
    80002a36:	f052                	sd	s4,32(sp)
    80002a38:	ec56                	sd	s5,24(sp)
    80002a3a:	e85a                	sd	s6,16(sp)
    80002a3c:	e45e                	sd	s7,8(sp)
    80002a3e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a40:	00020717          	auipc	a4,0x20
    80002a44:	42472703          	lw	a4,1060(a4) # 80022e64 <sb+0xc>
    80002a48:	4785                	li	a5,1
    80002a4a:	04e7fa63          	bgeu	a5,a4,80002a9e <ialloc+0x74>
    80002a4e:	8aaa                	mv	s5,a0
    80002a50:	8bae                	mv	s7,a1
    80002a52:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a54:	00020a17          	auipc	s4,0x20
    80002a58:	404a0a13          	addi	s4,s4,1028 # 80022e58 <sb>
    80002a5c:	00048b1b          	sext.w	s6,s1
    80002a60:	0044d793          	srli	a5,s1,0x4
    80002a64:	018a2583          	lw	a1,24(s4)
    80002a68:	9dbd                	addw	a1,a1,a5
    80002a6a:	8556                	mv	a0,s5
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	93e080e7          	jalr	-1730(ra) # 800023aa <bread>
    80002a74:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a76:	05850993          	addi	s3,a0,88
    80002a7a:	00f4f793          	andi	a5,s1,15
    80002a7e:	079a                	slli	a5,a5,0x6
    80002a80:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a82:	00099783          	lh	a5,0(s3)
    80002a86:	c3a1                	beqz	a5,80002ac6 <ialloc+0x9c>
    brelse(bp);
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	a52080e7          	jalr	-1454(ra) # 800024da <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a90:	0485                	addi	s1,s1,1
    80002a92:	00ca2703          	lw	a4,12(s4)
    80002a96:	0004879b          	sext.w	a5,s1
    80002a9a:	fce7e1e3          	bltu	a5,a4,80002a5c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	a8a50513          	addi	a0,a0,-1398 # 80008528 <syscalls+0x178>
    80002aa6:	00003097          	auipc	ra,0x3
    80002aaa:	592080e7          	jalr	1426(ra) # 80006038 <printf>
  return 0;
    80002aae:	4501                	li	a0,0
}
    80002ab0:	60a6                	ld	ra,72(sp)
    80002ab2:	6406                	ld	s0,64(sp)
    80002ab4:	74e2                	ld	s1,56(sp)
    80002ab6:	7942                	ld	s2,48(sp)
    80002ab8:	79a2                	ld	s3,40(sp)
    80002aba:	7a02                	ld	s4,32(sp)
    80002abc:	6ae2                	ld	s5,24(sp)
    80002abe:	6b42                	ld	s6,16(sp)
    80002ac0:	6ba2                	ld	s7,8(sp)
    80002ac2:	6161                	addi	sp,sp,80
    80002ac4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ac6:	04000613          	li	a2,64
    80002aca:	4581                	li	a1,0
    80002acc:	854e                	mv	a0,s3
    80002ace:	ffffd097          	auipc	ra,0xffffd
    80002ad2:	6aa080e7          	jalr	1706(ra) # 80000178 <memset>
      dip->type = type;
    80002ad6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ada:	854a                	mv	a0,s2
    80002adc:	00001097          	auipc	ra,0x1
    80002ae0:	c88080e7          	jalr	-888(ra) # 80003764 <log_write>
      brelse(bp);
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	9f4080e7          	jalr	-1548(ra) # 800024da <brelse>
      return iget(dev, inum);
    80002aee:	85da                	mv	a1,s6
    80002af0:	8556                	mv	a0,s5
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	d9c080e7          	jalr	-612(ra) # 8000288e <iget>
    80002afa:	bf5d                	j	80002ab0 <ialloc+0x86>

0000000080002afc <iupdate>:
{
    80002afc:	1101                	addi	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	e04a                	sd	s2,0(sp)
    80002b06:	1000                	addi	s0,sp,32
    80002b08:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b0a:	415c                	lw	a5,4(a0)
    80002b0c:	0047d79b          	srliw	a5,a5,0x4
    80002b10:	00020597          	auipc	a1,0x20
    80002b14:	3605a583          	lw	a1,864(a1) # 80022e70 <sb+0x18>
    80002b18:	9dbd                	addw	a1,a1,a5
    80002b1a:	4108                	lw	a0,0(a0)
    80002b1c:	00000097          	auipc	ra,0x0
    80002b20:	88e080e7          	jalr	-1906(ra) # 800023aa <bread>
    80002b24:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b26:	05850793          	addi	a5,a0,88
    80002b2a:	40c8                	lw	a0,4(s1)
    80002b2c:	893d                	andi	a0,a0,15
    80002b2e:	051a                	slli	a0,a0,0x6
    80002b30:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b32:	04449703          	lh	a4,68(s1)
    80002b36:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b3a:	04649703          	lh	a4,70(s1)
    80002b3e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b42:	04849703          	lh	a4,72(s1)
    80002b46:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b4a:	04a49703          	lh	a4,74(s1)
    80002b4e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b52:	44f8                	lw	a4,76(s1)
    80002b54:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b56:	03400613          	li	a2,52
    80002b5a:	05048593          	addi	a1,s1,80
    80002b5e:	0531                	addi	a0,a0,12
    80002b60:	ffffd097          	auipc	ra,0xffffd
    80002b64:	674080e7          	jalr	1652(ra) # 800001d4 <memmove>
  log_write(bp);
    80002b68:	854a                	mv	a0,s2
    80002b6a:	00001097          	auipc	ra,0x1
    80002b6e:	bfa080e7          	jalr	-1030(ra) # 80003764 <log_write>
  brelse(bp);
    80002b72:	854a                	mv	a0,s2
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	966080e7          	jalr	-1690(ra) # 800024da <brelse>
}
    80002b7c:	60e2                	ld	ra,24(sp)
    80002b7e:	6442                	ld	s0,16(sp)
    80002b80:	64a2                	ld	s1,8(sp)
    80002b82:	6902                	ld	s2,0(sp)
    80002b84:	6105                	addi	sp,sp,32
    80002b86:	8082                	ret

0000000080002b88 <idup>:
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	e426                	sd	s1,8(sp)
    80002b90:	1000                	addi	s0,sp,32
    80002b92:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b94:	00020517          	auipc	a0,0x20
    80002b98:	2e450513          	addi	a0,a0,740 # 80022e78 <itable>
    80002b9c:	00004097          	auipc	ra,0x4
    80002ba0:	98e080e7          	jalr	-1650(ra) # 8000652a <acquire>
  ip->ref++;
    80002ba4:	449c                	lw	a5,8(s1)
    80002ba6:	2785                	addiw	a5,a5,1
    80002ba8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002baa:	00020517          	auipc	a0,0x20
    80002bae:	2ce50513          	addi	a0,a0,718 # 80022e78 <itable>
    80002bb2:	00004097          	auipc	ra,0x4
    80002bb6:	a2c080e7          	jalr	-1492(ra) # 800065de <release>
}
    80002bba:	8526                	mv	a0,s1
    80002bbc:	60e2                	ld	ra,24(sp)
    80002bbe:	6442                	ld	s0,16(sp)
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret

0000000080002bc6 <ilock>:
{
    80002bc6:	1101                	addi	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	e426                	sd	s1,8(sp)
    80002bce:	e04a                	sd	s2,0(sp)
    80002bd0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bd2:	c115                	beqz	a0,80002bf6 <ilock+0x30>
    80002bd4:	84aa                	mv	s1,a0
    80002bd6:	451c                	lw	a5,8(a0)
    80002bd8:	00f05f63          	blez	a5,80002bf6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bdc:	0541                	addi	a0,a0,16
    80002bde:	00001097          	auipc	ra,0x1
    80002be2:	ca6080e7          	jalr	-858(ra) # 80003884 <acquiresleep>
  if(ip->valid == 0){
    80002be6:	40bc                	lw	a5,64(s1)
    80002be8:	cf99                	beqz	a5,80002c06 <ilock+0x40>
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6902                	ld	s2,0(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret
    panic("ilock");
    80002bf6:	00006517          	auipc	a0,0x6
    80002bfa:	94a50513          	addi	a0,a0,-1718 # 80008540 <syscalls+0x190>
    80002bfe:	00003097          	auipc	ra,0x3
    80002c02:	3f0080e7          	jalr	1008(ra) # 80005fee <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c06:	40dc                	lw	a5,4(s1)
    80002c08:	0047d79b          	srliw	a5,a5,0x4
    80002c0c:	00020597          	auipc	a1,0x20
    80002c10:	2645a583          	lw	a1,612(a1) # 80022e70 <sb+0x18>
    80002c14:	9dbd                	addw	a1,a1,a5
    80002c16:	4088                	lw	a0,0(s1)
    80002c18:	fffff097          	auipc	ra,0xfffff
    80002c1c:	792080e7          	jalr	1938(ra) # 800023aa <bread>
    80002c20:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c22:	05850593          	addi	a1,a0,88
    80002c26:	40dc                	lw	a5,4(s1)
    80002c28:	8bbd                	andi	a5,a5,15
    80002c2a:	079a                	slli	a5,a5,0x6
    80002c2c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c2e:	00059783          	lh	a5,0(a1)
    80002c32:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c36:	00259783          	lh	a5,2(a1)
    80002c3a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c3e:	00459783          	lh	a5,4(a1)
    80002c42:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c46:	00659783          	lh	a5,6(a1)
    80002c4a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c4e:	459c                	lw	a5,8(a1)
    80002c50:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c52:	03400613          	li	a2,52
    80002c56:	05b1                	addi	a1,a1,12
    80002c58:	05048513          	addi	a0,s1,80
    80002c5c:	ffffd097          	auipc	ra,0xffffd
    80002c60:	578080e7          	jalr	1400(ra) # 800001d4 <memmove>
    brelse(bp);
    80002c64:	854a                	mv	a0,s2
    80002c66:	00000097          	auipc	ra,0x0
    80002c6a:	874080e7          	jalr	-1932(ra) # 800024da <brelse>
    ip->valid = 1;
    80002c6e:	4785                	li	a5,1
    80002c70:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c72:	04449783          	lh	a5,68(s1)
    80002c76:	fbb5                	bnez	a5,80002bea <ilock+0x24>
      panic("ilock: no type");
    80002c78:	00006517          	auipc	a0,0x6
    80002c7c:	8d050513          	addi	a0,a0,-1840 # 80008548 <syscalls+0x198>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	36e080e7          	jalr	878(ra) # 80005fee <panic>

0000000080002c88 <iunlock>:
{
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	e04a                	sd	s2,0(sp)
    80002c92:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c94:	c905                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002c96:	84aa                	mv	s1,a0
    80002c98:	01050913          	addi	s2,a0,16
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	c80080e7          	jalr	-896(ra) # 8000391e <holdingsleep>
    80002ca6:	cd19                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002ca8:	449c                	lw	a5,8(s1)
    80002caa:	00f05d63          	blez	a5,80002cc4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cae:	854a                	mv	a0,s2
    80002cb0:	00001097          	auipc	ra,0x1
    80002cb4:	c2a080e7          	jalr	-982(ra) # 800038da <releasesleep>
}
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6902                	ld	s2,0(sp)
    80002cc0:	6105                	addi	sp,sp,32
    80002cc2:	8082                	ret
    panic("iunlock");
    80002cc4:	00006517          	auipc	a0,0x6
    80002cc8:	89450513          	addi	a0,a0,-1900 # 80008558 <syscalls+0x1a8>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	322080e7          	jalr	802(ra) # 80005fee <panic>

0000000080002cd4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd4:	7179                	addi	sp,sp,-48
    80002cd6:	f406                	sd	ra,40(sp)
    80002cd8:	f022                	sd	s0,32(sp)
    80002cda:	ec26                	sd	s1,24(sp)
    80002cdc:	e84a                	sd	s2,16(sp)
    80002cde:	e44e                	sd	s3,8(sp)
    80002ce0:	e052                	sd	s4,0(sp)
    80002ce2:	1800                	addi	s0,sp,48
    80002ce4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce6:	05050493          	addi	s1,a0,80
    80002cea:	08050913          	addi	s2,a0,128
    80002cee:	a021                	j	80002cf6 <itrunc+0x22>
    80002cf0:	0491                	addi	s1,s1,4
    80002cf2:	01248d63          	beq	s1,s2,80002d0c <itrunc+0x38>
    if(ip->addrs[i]){
    80002cf6:	408c                	lw	a1,0(s1)
    80002cf8:	dde5                	beqz	a1,80002cf0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cfa:	0009a503          	lw	a0,0(s3)
    80002cfe:	00000097          	auipc	ra,0x0
    80002d02:	8f2080e7          	jalr	-1806(ra) # 800025f0 <bfree>
      ip->addrs[i] = 0;
    80002d06:	0004a023          	sw	zero,0(s1)
    80002d0a:	b7dd                	j	80002cf0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d0c:	0809a583          	lw	a1,128(s3)
    80002d10:	e185                	bnez	a1,80002d30 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d12:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d16:	854e                	mv	a0,s3
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	de4080e7          	jalr	-540(ra) # 80002afc <iupdate>
}
    80002d20:	70a2                	ld	ra,40(sp)
    80002d22:	7402                	ld	s0,32(sp)
    80002d24:	64e2                	ld	s1,24(sp)
    80002d26:	6942                	ld	s2,16(sp)
    80002d28:	69a2                	ld	s3,8(sp)
    80002d2a:	6a02                	ld	s4,0(sp)
    80002d2c:	6145                	addi	sp,sp,48
    80002d2e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d30:	0009a503          	lw	a0,0(s3)
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	676080e7          	jalr	1654(ra) # 800023aa <bread>
    80002d3c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d3e:	05850493          	addi	s1,a0,88
    80002d42:	45850913          	addi	s2,a0,1112
    80002d46:	a021                	j	80002d4e <itrunc+0x7a>
    80002d48:	0491                	addi	s1,s1,4
    80002d4a:	01248b63          	beq	s1,s2,80002d60 <itrunc+0x8c>
      if(a[j])
    80002d4e:	408c                	lw	a1,0(s1)
    80002d50:	dde5                	beqz	a1,80002d48 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d52:	0009a503          	lw	a0,0(s3)
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	89a080e7          	jalr	-1894(ra) # 800025f0 <bfree>
    80002d5e:	b7ed                	j	80002d48 <itrunc+0x74>
    brelse(bp);
    80002d60:	8552                	mv	a0,s4
    80002d62:	fffff097          	auipc	ra,0xfffff
    80002d66:	778080e7          	jalr	1912(ra) # 800024da <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d6a:	0809a583          	lw	a1,128(s3)
    80002d6e:	0009a503          	lw	a0,0(s3)
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	87e080e7          	jalr	-1922(ra) # 800025f0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d7a:	0809a023          	sw	zero,128(s3)
    80002d7e:	bf51                	j	80002d12 <itrunc+0x3e>

0000000080002d80 <iput>:
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	e04a                	sd	s2,0(sp)
    80002d8a:	1000                	addi	s0,sp,32
    80002d8c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d8e:	00020517          	auipc	a0,0x20
    80002d92:	0ea50513          	addi	a0,a0,234 # 80022e78 <itable>
    80002d96:	00003097          	auipc	ra,0x3
    80002d9a:	794080e7          	jalr	1940(ra) # 8000652a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9e:	4498                	lw	a4,8(s1)
    80002da0:	4785                	li	a5,1
    80002da2:	02f70363          	beq	a4,a5,80002dc8 <iput+0x48>
  ip->ref--;
    80002da6:	449c                	lw	a5,8(s1)
    80002da8:	37fd                	addiw	a5,a5,-1
    80002daa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dac:	00020517          	auipc	a0,0x20
    80002db0:	0cc50513          	addi	a0,a0,204 # 80022e78 <itable>
    80002db4:	00004097          	auipc	ra,0x4
    80002db8:	82a080e7          	jalr	-2006(ra) # 800065de <release>
}
    80002dbc:	60e2                	ld	ra,24(sp)
    80002dbe:	6442                	ld	s0,16(sp)
    80002dc0:	64a2                	ld	s1,8(sp)
    80002dc2:	6902                	ld	s2,0(sp)
    80002dc4:	6105                	addi	sp,sp,32
    80002dc6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc8:	40bc                	lw	a5,64(s1)
    80002dca:	dff1                	beqz	a5,80002da6 <iput+0x26>
    80002dcc:	04a49783          	lh	a5,74(s1)
    80002dd0:	fbf9                	bnez	a5,80002da6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dd2:	01048913          	addi	s2,s1,16
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	00001097          	auipc	ra,0x1
    80002ddc:	aac080e7          	jalr	-1364(ra) # 80003884 <acquiresleep>
    release(&itable.lock);
    80002de0:	00020517          	auipc	a0,0x20
    80002de4:	09850513          	addi	a0,a0,152 # 80022e78 <itable>
    80002de8:	00003097          	auipc	ra,0x3
    80002dec:	7f6080e7          	jalr	2038(ra) # 800065de <release>
    itrunc(ip);
    80002df0:	8526                	mv	a0,s1
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	ee2080e7          	jalr	-286(ra) # 80002cd4 <itrunc>
    ip->type = 0;
    80002dfa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dfe:	8526                	mv	a0,s1
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	cfc080e7          	jalr	-772(ra) # 80002afc <iupdate>
    ip->valid = 0;
    80002e08:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	00001097          	auipc	ra,0x1
    80002e12:	acc080e7          	jalr	-1332(ra) # 800038da <releasesleep>
    acquire(&itable.lock);
    80002e16:	00020517          	auipc	a0,0x20
    80002e1a:	06250513          	addi	a0,a0,98 # 80022e78 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	70c080e7          	jalr	1804(ra) # 8000652a <acquire>
    80002e26:	b741                	j	80002da6 <iput+0x26>

0000000080002e28 <iunlockput>:
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	1000                	addi	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	e54080e7          	jalr	-428(ra) # 80002c88 <iunlock>
  iput(ip);
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	f42080e7          	jalr	-190(ra) # 80002d80 <iput>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret

0000000080002e50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e50:	1141                	addi	sp,sp,-16
    80002e52:	e422                	sd	s0,8(sp)
    80002e54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e56:	411c                	lw	a5,0(a0)
    80002e58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e5a:	415c                	lw	a5,4(a0)
    80002e5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e5e:	04451783          	lh	a5,68(a0)
    80002e62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e66:	04a51783          	lh	a5,74(a0)
    80002e6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e6e:	04c56783          	lwu	a5,76(a0)
    80002e72:	e99c                	sd	a5,16(a1)
}
    80002e74:	6422                	ld	s0,8(sp)
    80002e76:	0141                	addi	sp,sp,16
    80002e78:	8082                	ret

0000000080002e7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7a:	457c                	lw	a5,76(a0)
    80002e7c:	0ed7e963          	bltu	a5,a3,80002f6e <readi+0xf4>
{
    80002e80:	7159                	addi	sp,sp,-112
    80002e82:	f486                	sd	ra,104(sp)
    80002e84:	f0a2                	sd	s0,96(sp)
    80002e86:	eca6                	sd	s1,88(sp)
    80002e88:	e8ca                	sd	s2,80(sp)
    80002e8a:	e4ce                	sd	s3,72(sp)
    80002e8c:	e0d2                	sd	s4,64(sp)
    80002e8e:	fc56                	sd	s5,56(sp)
    80002e90:	f85a                	sd	s6,48(sp)
    80002e92:	f45e                	sd	s7,40(sp)
    80002e94:	f062                	sd	s8,32(sp)
    80002e96:	ec66                	sd	s9,24(sp)
    80002e98:	e86a                	sd	s10,16(sp)
    80002e9a:	e46e                	sd	s11,8(sp)
    80002e9c:	1880                	addi	s0,sp,112
    80002e9e:	8b2a                	mv	s6,a0
    80002ea0:	8bae                	mv	s7,a1
    80002ea2:	8a32                	mv	s4,a2
    80002ea4:	84b6                	mv	s1,a3
    80002ea6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ea8:	9f35                	addw	a4,a4,a3
    return 0;
    80002eaa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eac:	0ad76063          	bltu	a4,a3,80002f4c <readi+0xd2>
  if(off + n > ip->size)
    80002eb0:	00e7f463          	bgeu	a5,a4,80002eb8 <readi+0x3e>
    n = ip->size - off;
    80002eb4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb8:	0a0a8963          	beqz	s5,80002f6a <readi+0xf0>
    80002ebc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ebe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ec2:	5c7d                	li	s8,-1
    80002ec4:	a82d                	j	80002efe <readi+0x84>
    80002ec6:	020d1d93          	slli	s11,s10,0x20
    80002eca:	020ddd93          	srli	s11,s11,0x20
    80002ece:	05890793          	addi	a5,s2,88
    80002ed2:	86ee                	mv	a3,s11
    80002ed4:	963e                	add	a2,a2,a5
    80002ed6:	85d2                	mv	a1,s4
    80002ed8:	855e                	mv	a0,s7
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	a0e080e7          	jalr	-1522(ra) # 800018e8 <either_copyout>
    80002ee2:	05850d63          	beq	a0,s8,80002f3c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee6:	854a                	mv	a0,s2
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	5f2080e7          	jalr	1522(ra) # 800024da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef0:	013d09bb          	addw	s3,s10,s3
    80002ef4:	009d04bb          	addw	s1,s10,s1
    80002ef8:	9a6e                	add	s4,s4,s11
    80002efa:	0559f763          	bgeu	s3,s5,80002f48 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002efe:	00a4d59b          	srliw	a1,s1,0xa
    80002f02:	855a                	mv	a0,s6
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	8a0080e7          	jalr	-1888(ra) # 800027a4 <bmap>
    80002f0c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f10:	cd85                	beqz	a1,80002f48 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f12:	000b2503          	lw	a0,0(s6)
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	494080e7          	jalr	1172(ra) # 800023aa <bread>
    80002f1e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f20:	3ff4f613          	andi	a2,s1,1023
    80002f24:	40cc87bb          	subw	a5,s9,a2
    80002f28:	413a873b          	subw	a4,s5,s3
    80002f2c:	8d3e                	mv	s10,a5
    80002f2e:	2781                	sext.w	a5,a5
    80002f30:	0007069b          	sext.w	a3,a4
    80002f34:	f8f6f9e3          	bgeu	a3,a5,80002ec6 <readi+0x4c>
    80002f38:	8d3a                	mv	s10,a4
    80002f3a:	b771                	j	80002ec6 <readi+0x4c>
      brelse(bp);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	59c080e7          	jalr	1436(ra) # 800024da <brelse>
      tot = -1;
    80002f46:	59fd                	li	s3,-1
  }
  return tot;
    80002f48:	0009851b          	sext.w	a0,s3
}
    80002f4c:	70a6                	ld	ra,104(sp)
    80002f4e:	7406                	ld	s0,96(sp)
    80002f50:	64e6                	ld	s1,88(sp)
    80002f52:	6946                	ld	s2,80(sp)
    80002f54:	69a6                	ld	s3,72(sp)
    80002f56:	6a06                	ld	s4,64(sp)
    80002f58:	7ae2                	ld	s5,56(sp)
    80002f5a:	7b42                	ld	s6,48(sp)
    80002f5c:	7ba2                	ld	s7,40(sp)
    80002f5e:	7c02                	ld	s8,32(sp)
    80002f60:	6ce2                	ld	s9,24(sp)
    80002f62:	6d42                	ld	s10,16(sp)
    80002f64:	6da2                	ld	s11,8(sp)
    80002f66:	6165                	addi	sp,sp,112
    80002f68:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6a:	89d6                	mv	s3,s5
    80002f6c:	bff1                	j	80002f48 <readi+0xce>
    return 0;
    80002f6e:	4501                	li	a0,0
}
    80002f70:	8082                	ret

0000000080002f72 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f72:	457c                	lw	a5,76(a0)
    80002f74:	10d7e863          	bltu	a5,a3,80003084 <writei+0x112>
{
    80002f78:	7159                	addi	sp,sp,-112
    80002f7a:	f486                	sd	ra,104(sp)
    80002f7c:	f0a2                	sd	s0,96(sp)
    80002f7e:	eca6                	sd	s1,88(sp)
    80002f80:	e8ca                	sd	s2,80(sp)
    80002f82:	e4ce                	sd	s3,72(sp)
    80002f84:	e0d2                	sd	s4,64(sp)
    80002f86:	fc56                	sd	s5,56(sp)
    80002f88:	f85a                	sd	s6,48(sp)
    80002f8a:	f45e                	sd	s7,40(sp)
    80002f8c:	f062                	sd	s8,32(sp)
    80002f8e:	ec66                	sd	s9,24(sp)
    80002f90:	e86a                	sd	s10,16(sp)
    80002f92:	e46e                	sd	s11,8(sp)
    80002f94:	1880                	addi	s0,sp,112
    80002f96:	8aaa                	mv	s5,a0
    80002f98:	8bae                	mv	s7,a1
    80002f9a:	8a32                	mv	s4,a2
    80002f9c:	8936                	mv	s2,a3
    80002f9e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fa0:	00e687bb          	addw	a5,a3,a4
    80002fa4:	0ed7e263          	bltu	a5,a3,80003088 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa8:	00043737          	lui	a4,0x43
    80002fac:	0ef76063          	bltu	a4,a5,8000308c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fb0:	0c0b0863          	beqz	s6,80003080 <writei+0x10e>
    80002fb4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fba:	5c7d                	li	s8,-1
    80002fbc:	a091                	j	80003000 <writei+0x8e>
    80002fbe:	020d1d93          	slli	s11,s10,0x20
    80002fc2:	020ddd93          	srli	s11,s11,0x20
    80002fc6:	05848793          	addi	a5,s1,88
    80002fca:	86ee                	mv	a3,s11
    80002fcc:	8652                	mv	a2,s4
    80002fce:	85de                	mv	a1,s7
    80002fd0:	953e                	add	a0,a0,a5
    80002fd2:	fffff097          	auipc	ra,0xfffff
    80002fd6:	96c080e7          	jalr	-1684(ra) # 8000193e <either_copyin>
    80002fda:	07850263          	beq	a0,s8,8000303e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fde:	8526                	mv	a0,s1
    80002fe0:	00000097          	auipc	ra,0x0
    80002fe4:	784080e7          	jalr	1924(ra) # 80003764 <log_write>
    brelse(bp);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	4f0080e7          	jalr	1264(ra) # 800024da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff2:	013d09bb          	addw	s3,s10,s3
    80002ff6:	012d093b          	addw	s2,s10,s2
    80002ffa:	9a6e                	add	s4,s4,s11
    80002ffc:	0569f663          	bgeu	s3,s6,80003048 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003000:	00a9559b          	srliw	a1,s2,0xa
    80003004:	8556                	mv	a0,s5
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	79e080e7          	jalr	1950(ra) # 800027a4 <bmap>
    8000300e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003012:	c99d                	beqz	a1,80003048 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003014:	000aa503          	lw	a0,0(s5)
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	392080e7          	jalr	914(ra) # 800023aa <bread>
    80003020:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003022:	3ff97513          	andi	a0,s2,1023
    80003026:	40ac87bb          	subw	a5,s9,a0
    8000302a:	413b073b          	subw	a4,s6,s3
    8000302e:	8d3e                	mv	s10,a5
    80003030:	2781                	sext.w	a5,a5
    80003032:	0007069b          	sext.w	a3,a4
    80003036:	f8f6f4e3          	bgeu	a3,a5,80002fbe <writei+0x4c>
    8000303a:	8d3a                	mv	s10,a4
    8000303c:	b749                	j	80002fbe <writei+0x4c>
      brelse(bp);
    8000303e:	8526                	mv	a0,s1
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	49a080e7          	jalr	1178(ra) # 800024da <brelse>
  }

  if(off > ip->size)
    80003048:	04caa783          	lw	a5,76(s5)
    8000304c:	0127f463          	bgeu	a5,s2,80003054 <writei+0xe2>
    ip->size = off;
    80003050:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003054:	8556                	mv	a0,s5
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	aa6080e7          	jalr	-1370(ra) # 80002afc <iupdate>

  return tot;
    8000305e:	0009851b          	sext.w	a0,s3
}
    80003062:	70a6                	ld	ra,104(sp)
    80003064:	7406                	ld	s0,96(sp)
    80003066:	64e6                	ld	s1,88(sp)
    80003068:	6946                	ld	s2,80(sp)
    8000306a:	69a6                	ld	s3,72(sp)
    8000306c:	6a06                	ld	s4,64(sp)
    8000306e:	7ae2                	ld	s5,56(sp)
    80003070:	7b42                	ld	s6,48(sp)
    80003072:	7ba2                	ld	s7,40(sp)
    80003074:	7c02                	ld	s8,32(sp)
    80003076:	6ce2                	ld	s9,24(sp)
    80003078:	6d42                	ld	s10,16(sp)
    8000307a:	6da2                	ld	s11,8(sp)
    8000307c:	6165                	addi	sp,sp,112
    8000307e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003080:	89da                	mv	s3,s6
    80003082:	bfc9                	j	80003054 <writei+0xe2>
    return -1;
    80003084:	557d                	li	a0,-1
}
    80003086:	8082                	ret
    return -1;
    80003088:	557d                	li	a0,-1
    8000308a:	bfe1                	j	80003062 <writei+0xf0>
    return -1;
    8000308c:	557d                	li	a0,-1
    8000308e:	bfd1                	j	80003062 <writei+0xf0>

0000000080003090 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003090:	1141                	addi	sp,sp,-16
    80003092:	e406                	sd	ra,8(sp)
    80003094:	e022                	sd	s0,0(sp)
    80003096:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003098:	4639                	li	a2,14
    8000309a:	ffffd097          	auipc	ra,0xffffd
    8000309e:	1ae080e7          	jalr	430(ra) # 80000248 <strncmp>
}
    800030a2:	60a2                	ld	ra,8(sp)
    800030a4:	6402                	ld	s0,0(sp)
    800030a6:	0141                	addi	sp,sp,16
    800030a8:	8082                	ret

00000000800030aa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030aa:	7139                	addi	sp,sp,-64
    800030ac:	fc06                	sd	ra,56(sp)
    800030ae:	f822                	sd	s0,48(sp)
    800030b0:	f426                	sd	s1,40(sp)
    800030b2:	f04a                	sd	s2,32(sp)
    800030b4:	ec4e                	sd	s3,24(sp)
    800030b6:	e852                	sd	s4,16(sp)
    800030b8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ba:	04451703          	lh	a4,68(a0)
    800030be:	4785                	li	a5,1
    800030c0:	00f71a63          	bne	a4,a5,800030d4 <dirlookup+0x2a>
    800030c4:	892a                	mv	s2,a0
    800030c6:	89ae                	mv	s3,a1
    800030c8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ca:	457c                	lw	a5,76(a0)
    800030cc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ce:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d0:	e79d                	bnez	a5,800030fe <dirlookup+0x54>
    800030d2:	a8a5                	j	8000314a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030d4:	00005517          	auipc	a0,0x5
    800030d8:	48c50513          	addi	a0,a0,1164 # 80008560 <syscalls+0x1b0>
    800030dc:	00003097          	auipc	ra,0x3
    800030e0:	f12080e7          	jalr	-238(ra) # 80005fee <panic>
      panic("dirlookup read");
    800030e4:	00005517          	auipc	a0,0x5
    800030e8:	49450513          	addi	a0,a0,1172 # 80008578 <syscalls+0x1c8>
    800030ec:	00003097          	auipc	ra,0x3
    800030f0:	f02080e7          	jalr	-254(ra) # 80005fee <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f4:	24c1                	addiw	s1,s1,16
    800030f6:	04c92783          	lw	a5,76(s2)
    800030fa:	04f4f763          	bgeu	s1,a5,80003148 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030fe:	4741                	li	a4,16
    80003100:	86a6                	mv	a3,s1
    80003102:	fc040613          	addi	a2,s0,-64
    80003106:	4581                	li	a1,0
    80003108:	854a                	mv	a0,s2
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	d70080e7          	jalr	-656(ra) # 80002e7a <readi>
    80003112:	47c1                	li	a5,16
    80003114:	fcf518e3          	bne	a0,a5,800030e4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003118:	fc045783          	lhu	a5,-64(s0)
    8000311c:	dfe1                	beqz	a5,800030f4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000311e:	fc240593          	addi	a1,s0,-62
    80003122:	854e                	mv	a0,s3
    80003124:	00000097          	auipc	ra,0x0
    80003128:	f6c080e7          	jalr	-148(ra) # 80003090 <namecmp>
    8000312c:	f561                	bnez	a0,800030f4 <dirlookup+0x4a>
      if(poff)
    8000312e:	000a0463          	beqz	s4,80003136 <dirlookup+0x8c>
        *poff = off;
    80003132:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003136:	fc045583          	lhu	a1,-64(s0)
    8000313a:	00092503          	lw	a0,0(s2)
    8000313e:	fffff097          	auipc	ra,0xfffff
    80003142:	750080e7          	jalr	1872(ra) # 8000288e <iget>
    80003146:	a011                	j	8000314a <dirlookup+0xa0>
  return 0;
    80003148:	4501                	li	a0,0
}
    8000314a:	70e2                	ld	ra,56(sp)
    8000314c:	7442                	ld	s0,48(sp)
    8000314e:	74a2                	ld	s1,40(sp)
    80003150:	7902                	ld	s2,32(sp)
    80003152:	69e2                	ld	s3,24(sp)
    80003154:	6a42                	ld	s4,16(sp)
    80003156:	6121                	addi	sp,sp,64
    80003158:	8082                	ret

000000008000315a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000315a:	711d                	addi	sp,sp,-96
    8000315c:	ec86                	sd	ra,88(sp)
    8000315e:	e8a2                	sd	s0,80(sp)
    80003160:	e4a6                	sd	s1,72(sp)
    80003162:	e0ca                	sd	s2,64(sp)
    80003164:	fc4e                	sd	s3,56(sp)
    80003166:	f852                	sd	s4,48(sp)
    80003168:	f456                	sd	s5,40(sp)
    8000316a:	f05a                	sd	s6,32(sp)
    8000316c:	ec5e                	sd	s7,24(sp)
    8000316e:	e862                	sd	s8,16(sp)
    80003170:	e466                	sd	s9,8(sp)
    80003172:	1080                	addi	s0,sp,96
    80003174:	84aa                	mv	s1,a0
    80003176:	8aae                	mv	s5,a1
    80003178:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000317a:	00054703          	lbu	a4,0(a0)
    8000317e:	02f00793          	li	a5,47
    80003182:	02f70363          	beq	a4,a5,800031a8 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003186:	ffffe097          	auipc	ra,0xffffe
    8000318a:	cb2080e7          	jalr	-846(ra) # 80000e38 <myproc>
    8000318e:	15053503          	ld	a0,336(a0)
    80003192:	00000097          	auipc	ra,0x0
    80003196:	9f6080e7          	jalr	-1546(ra) # 80002b88 <idup>
    8000319a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000319c:	02f00913          	li	s2,47
  len = path - s;
    800031a0:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800031a2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031a4:	4b85                	li	s7,1
    800031a6:	a865                	j	8000325e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031a8:	4585                	li	a1,1
    800031aa:	4505                	li	a0,1
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	6e2080e7          	jalr	1762(ra) # 8000288e <iget>
    800031b4:	89aa                	mv	s3,a0
    800031b6:	b7dd                	j	8000319c <namex+0x42>
      iunlockput(ip);
    800031b8:	854e                	mv	a0,s3
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	c6e080e7          	jalr	-914(ra) # 80002e28 <iunlockput>
      return 0;
    800031c2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031c4:	854e                	mv	a0,s3
    800031c6:	60e6                	ld	ra,88(sp)
    800031c8:	6446                	ld	s0,80(sp)
    800031ca:	64a6                	ld	s1,72(sp)
    800031cc:	6906                	ld	s2,64(sp)
    800031ce:	79e2                	ld	s3,56(sp)
    800031d0:	7a42                	ld	s4,48(sp)
    800031d2:	7aa2                	ld	s5,40(sp)
    800031d4:	7b02                	ld	s6,32(sp)
    800031d6:	6be2                	ld	s7,24(sp)
    800031d8:	6c42                	ld	s8,16(sp)
    800031da:	6ca2                	ld	s9,8(sp)
    800031dc:	6125                	addi	sp,sp,96
    800031de:	8082                	ret
      iunlock(ip);
    800031e0:	854e                	mv	a0,s3
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	aa6080e7          	jalr	-1370(ra) # 80002c88 <iunlock>
      return ip;
    800031ea:	bfe9                	j	800031c4 <namex+0x6a>
      iunlockput(ip);
    800031ec:	854e                	mv	a0,s3
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	c3a080e7          	jalr	-966(ra) # 80002e28 <iunlockput>
      return 0;
    800031f6:	89e6                	mv	s3,s9
    800031f8:	b7f1                	j	800031c4 <namex+0x6a>
  len = path - s;
    800031fa:	40b48633          	sub	a2,s1,a1
    800031fe:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003202:	099c5463          	bge	s8,s9,8000328a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003206:	4639                	li	a2,14
    80003208:	8552                	mv	a0,s4
    8000320a:	ffffd097          	auipc	ra,0xffffd
    8000320e:	fca080e7          	jalr	-54(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	01279763          	bne	a5,s2,80003224 <namex+0xca>
    path++;
    8000321a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	ff278de3          	beq	a5,s2,8000321a <namex+0xc0>
    ilock(ip);
    80003224:	854e                	mv	a0,s3
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	9a0080e7          	jalr	-1632(ra) # 80002bc6 <ilock>
    if(ip->type != T_DIR){
    8000322e:	04499783          	lh	a5,68(s3)
    80003232:	f97793e3          	bne	a5,s7,800031b8 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003236:	000a8563          	beqz	s5,80003240 <namex+0xe6>
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	d3cd                	beqz	a5,800031e0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003240:	865a                	mv	a2,s6
    80003242:	85d2                	mv	a1,s4
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	e64080e7          	jalr	-412(ra) # 800030aa <dirlookup>
    8000324e:	8caa                	mv	s9,a0
    80003250:	dd51                	beqz	a0,800031ec <namex+0x92>
    iunlockput(ip);
    80003252:	854e                	mv	a0,s3
    80003254:	00000097          	auipc	ra,0x0
    80003258:	bd4080e7          	jalr	-1068(ra) # 80002e28 <iunlockput>
    ip = next;
    8000325c:	89e6                	mv	s3,s9
  while(*path == '/')
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	05279763          	bne	a5,s2,800032b0 <namex+0x156>
    path++;
    80003266:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	ff278de3          	beq	a5,s2,80003266 <namex+0x10c>
  if(*path == 0)
    80003270:	c79d                	beqz	a5,8000329e <namex+0x144>
    path++;
    80003272:	85a6                	mv	a1,s1
  len = path - s;
    80003274:	8cda                	mv	s9,s6
    80003276:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003278:	01278963          	beq	a5,s2,8000328a <namex+0x130>
    8000327c:	dfbd                	beqz	a5,800031fa <namex+0xa0>
    path++;
    8000327e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	ff279ce3          	bne	a5,s2,8000327c <namex+0x122>
    80003288:	bf8d                	j	800031fa <namex+0xa0>
    memmove(name, s, len);
    8000328a:	2601                	sext.w	a2,a2
    8000328c:	8552                	mv	a0,s4
    8000328e:	ffffd097          	auipc	ra,0xffffd
    80003292:	f46080e7          	jalr	-186(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003296:	9cd2                	add	s9,s9,s4
    80003298:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000329c:	bf9d                	j	80003212 <namex+0xb8>
  if(nameiparent){
    8000329e:	f20a83e3          	beqz	s5,800031c4 <namex+0x6a>
    iput(ip);
    800032a2:	854e                	mv	a0,s3
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	adc080e7          	jalr	-1316(ra) # 80002d80 <iput>
    return 0;
    800032ac:	4981                	li	s3,0
    800032ae:	bf19                	j	800031c4 <namex+0x6a>
  if(*path == 0)
    800032b0:	d7fd                	beqz	a5,8000329e <namex+0x144>
  while(*path != '/' && *path != 0)
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	85a6                	mv	a1,s1
    800032b8:	b7d1                	j	8000327c <namex+0x122>

00000000800032ba <dirlink>:
{
    800032ba:	7139                	addi	sp,sp,-64
    800032bc:	fc06                	sd	ra,56(sp)
    800032be:	f822                	sd	s0,48(sp)
    800032c0:	f426                	sd	s1,40(sp)
    800032c2:	f04a                	sd	s2,32(sp)
    800032c4:	ec4e                	sd	s3,24(sp)
    800032c6:	e852                	sd	s4,16(sp)
    800032c8:	0080                	addi	s0,sp,64
    800032ca:	892a                	mv	s2,a0
    800032cc:	8a2e                	mv	s4,a1
    800032ce:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032d0:	4601                	li	a2,0
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	dd8080e7          	jalr	-552(ra) # 800030aa <dirlookup>
    800032da:	e93d                	bnez	a0,80003350 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032dc:	04c92483          	lw	s1,76(s2)
    800032e0:	c49d                	beqz	s1,8000330e <dirlink+0x54>
    800032e2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e4:	4741                	li	a4,16
    800032e6:	86a6                	mv	a3,s1
    800032e8:	fc040613          	addi	a2,s0,-64
    800032ec:	4581                	li	a1,0
    800032ee:	854a                	mv	a0,s2
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	b8a080e7          	jalr	-1142(ra) # 80002e7a <readi>
    800032f8:	47c1                	li	a5,16
    800032fa:	06f51163          	bne	a0,a5,8000335c <dirlink+0xa2>
    if(de.inum == 0)
    800032fe:	fc045783          	lhu	a5,-64(s0)
    80003302:	c791                	beqz	a5,8000330e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003304:	24c1                	addiw	s1,s1,16
    80003306:	04c92783          	lw	a5,76(s2)
    8000330a:	fcf4ede3          	bltu	s1,a5,800032e4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000330e:	4639                	li	a2,14
    80003310:	85d2                	mv	a1,s4
    80003312:	fc240513          	addi	a0,s0,-62
    80003316:	ffffd097          	auipc	ra,0xffffd
    8000331a:	f6e080e7          	jalr	-146(ra) # 80000284 <strncpy>
  de.inum = inum;
    8000331e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003322:	4741                	li	a4,16
    80003324:	86a6                	mv	a3,s1
    80003326:	fc040613          	addi	a2,s0,-64
    8000332a:	4581                	li	a1,0
    8000332c:	854a                	mv	a0,s2
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	c44080e7          	jalr	-956(ra) # 80002f72 <writei>
    80003336:	1541                	addi	a0,a0,-16
    80003338:	00a03533          	snez	a0,a0
    8000333c:	40a00533          	neg	a0,a0
}
    80003340:	70e2                	ld	ra,56(sp)
    80003342:	7442                	ld	s0,48(sp)
    80003344:	74a2                	ld	s1,40(sp)
    80003346:	7902                	ld	s2,32(sp)
    80003348:	69e2                	ld	s3,24(sp)
    8000334a:	6a42                	ld	s4,16(sp)
    8000334c:	6121                	addi	sp,sp,64
    8000334e:	8082                	ret
    iput(ip);
    80003350:	00000097          	auipc	ra,0x0
    80003354:	a30080e7          	jalr	-1488(ra) # 80002d80 <iput>
    return -1;
    80003358:	557d                	li	a0,-1
    8000335a:	b7dd                	j	80003340 <dirlink+0x86>
      panic("dirlink read");
    8000335c:	00005517          	auipc	a0,0x5
    80003360:	22c50513          	addi	a0,a0,556 # 80008588 <syscalls+0x1d8>
    80003364:	00003097          	auipc	ra,0x3
    80003368:	c8a080e7          	jalr	-886(ra) # 80005fee <panic>

000000008000336c <namei>:

struct inode*
namei(char *path)
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003374:	fe040613          	addi	a2,s0,-32
    80003378:	4581                	li	a1,0
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	de0080e7          	jalr	-544(ra) # 8000315a <namex>
}
    80003382:	60e2                	ld	ra,24(sp)
    80003384:	6442                	ld	s0,16(sp)
    80003386:	6105                	addi	sp,sp,32
    80003388:	8082                	ret

000000008000338a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000338a:	1141                	addi	sp,sp,-16
    8000338c:	e406                	sd	ra,8(sp)
    8000338e:	e022                	sd	s0,0(sp)
    80003390:	0800                	addi	s0,sp,16
    80003392:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003394:	4585                	li	a1,1
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	dc4080e7          	jalr	-572(ra) # 8000315a <namex>
}
    8000339e:	60a2                	ld	ra,8(sp)
    800033a0:	6402                	ld	s0,0(sp)
    800033a2:	0141                	addi	sp,sp,16
    800033a4:	8082                	ret

00000000800033a6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033a6:	1101                	addi	sp,sp,-32
    800033a8:	ec06                	sd	ra,24(sp)
    800033aa:	e822                	sd	s0,16(sp)
    800033ac:	e426                	sd	s1,8(sp)
    800033ae:	e04a                	sd	s2,0(sp)
    800033b0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033b2:	00021917          	auipc	s2,0x21
    800033b6:	56e90913          	addi	s2,s2,1390 # 80024920 <log>
    800033ba:	01892583          	lw	a1,24(s2)
    800033be:	02892503          	lw	a0,40(s2)
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	fe8080e7          	jalr	-24(ra) # 800023aa <bread>
    800033ca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033cc:	02c92683          	lw	a3,44(s2)
    800033d0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033d2:	02d05863          	blez	a3,80003402 <write_head+0x5c>
    800033d6:	00021797          	auipc	a5,0x21
    800033da:	57a78793          	addi	a5,a5,1402 # 80024950 <log+0x30>
    800033de:	05c50713          	addi	a4,a0,92
    800033e2:	36fd                	addiw	a3,a3,-1
    800033e4:	02069613          	slli	a2,a3,0x20
    800033e8:	01e65693          	srli	a3,a2,0x1e
    800033ec:	00021617          	auipc	a2,0x21
    800033f0:	56860613          	addi	a2,a2,1384 # 80024954 <log+0x34>
    800033f4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033f6:	4390                	lw	a2,0(a5)
    800033f8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033fa:	0791                	addi	a5,a5,4
    800033fc:	0711                	addi	a4,a4,4
    800033fe:	fed79ce3          	bne	a5,a3,800033f6 <write_head+0x50>
  }
  bwrite(buf);
    80003402:	8526                	mv	a0,s1
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	098080e7          	jalr	152(ra) # 8000249c <bwrite>
  brelse(buf);
    8000340c:	8526                	mv	a0,s1
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	0cc080e7          	jalr	204(ra) # 800024da <brelse>
}
    80003416:	60e2                	ld	ra,24(sp)
    80003418:	6442                	ld	s0,16(sp)
    8000341a:	64a2                	ld	s1,8(sp)
    8000341c:	6902                	ld	s2,0(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret

0000000080003422 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003422:	00021797          	auipc	a5,0x21
    80003426:	52a7a783          	lw	a5,1322(a5) # 8002494c <log+0x2c>
    8000342a:	0af05d63          	blez	a5,800034e4 <install_trans+0xc2>
{
    8000342e:	7139                	addi	sp,sp,-64
    80003430:	fc06                	sd	ra,56(sp)
    80003432:	f822                	sd	s0,48(sp)
    80003434:	f426                	sd	s1,40(sp)
    80003436:	f04a                	sd	s2,32(sp)
    80003438:	ec4e                	sd	s3,24(sp)
    8000343a:	e852                	sd	s4,16(sp)
    8000343c:	e456                	sd	s5,8(sp)
    8000343e:	e05a                	sd	s6,0(sp)
    80003440:	0080                	addi	s0,sp,64
    80003442:	8b2a                	mv	s6,a0
    80003444:	00021a97          	auipc	s5,0x21
    80003448:	50ca8a93          	addi	s5,s5,1292 # 80024950 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000344e:	00021997          	auipc	s3,0x21
    80003452:	4d298993          	addi	s3,s3,1234 # 80024920 <log>
    80003456:	a00d                	j	80003478 <install_trans+0x56>
    brelse(lbuf);
    80003458:	854a                	mv	a0,s2
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	080080e7          	jalr	128(ra) # 800024da <brelse>
    brelse(dbuf);
    80003462:	8526                	mv	a0,s1
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	076080e7          	jalr	118(ra) # 800024da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346c:	2a05                	addiw	s4,s4,1
    8000346e:	0a91                	addi	s5,s5,4
    80003470:	02c9a783          	lw	a5,44(s3)
    80003474:	04fa5e63          	bge	s4,a5,800034d0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003478:	0189a583          	lw	a1,24(s3)
    8000347c:	014585bb          	addw	a1,a1,s4
    80003480:	2585                	addiw	a1,a1,1
    80003482:	0289a503          	lw	a0,40(s3)
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f24080e7          	jalr	-220(ra) # 800023aa <bread>
    8000348e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003490:	000aa583          	lw	a1,0(s5)
    80003494:	0289a503          	lw	a0,40(s3)
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	f12080e7          	jalr	-238(ra) # 800023aa <bread>
    800034a0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034a2:	40000613          	li	a2,1024
    800034a6:	05890593          	addi	a1,s2,88
    800034aa:	05850513          	addi	a0,a0,88
    800034ae:	ffffd097          	auipc	ra,0xffffd
    800034b2:	d26080e7          	jalr	-730(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	fe4080e7          	jalr	-28(ra) # 8000249c <bwrite>
    if(recovering == 0)
    800034c0:	f80b1ce3          	bnez	s6,80003458 <install_trans+0x36>
      bunpin(dbuf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	0ee080e7          	jalr	238(ra) # 800025b4 <bunpin>
    800034ce:	b769                	j	80003458 <install_trans+0x36>
}
    800034d0:	70e2                	ld	ra,56(sp)
    800034d2:	7442                	ld	s0,48(sp)
    800034d4:	74a2                	ld	s1,40(sp)
    800034d6:	7902                	ld	s2,32(sp)
    800034d8:	69e2                	ld	s3,24(sp)
    800034da:	6a42                	ld	s4,16(sp)
    800034dc:	6aa2                	ld	s5,8(sp)
    800034de:	6b02                	ld	s6,0(sp)
    800034e0:	6121                	addi	sp,sp,64
    800034e2:	8082                	ret
    800034e4:	8082                	ret

00000000800034e6 <initlog>:
{
    800034e6:	7179                	addi	sp,sp,-48
    800034e8:	f406                	sd	ra,40(sp)
    800034ea:	f022                	sd	s0,32(sp)
    800034ec:	ec26                	sd	s1,24(sp)
    800034ee:	e84a                	sd	s2,16(sp)
    800034f0:	e44e                	sd	s3,8(sp)
    800034f2:	1800                	addi	s0,sp,48
    800034f4:	892a                	mv	s2,a0
    800034f6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034f8:	00021497          	auipc	s1,0x21
    800034fc:	42848493          	addi	s1,s1,1064 # 80024920 <log>
    80003500:	00005597          	auipc	a1,0x5
    80003504:	09858593          	addi	a1,a1,152 # 80008598 <syscalls+0x1e8>
    80003508:	8526                	mv	a0,s1
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	f90080e7          	jalr	-112(ra) # 8000649a <initlock>
  log.start = sb->logstart;
    80003512:	0149a583          	lw	a1,20(s3)
    80003516:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003518:	0109a783          	lw	a5,16(s3)
    8000351c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000351e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003522:	854a                	mv	a0,s2
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	e86080e7          	jalr	-378(ra) # 800023aa <bread>
  log.lh.n = lh->n;
    8000352c:	4d34                	lw	a3,88(a0)
    8000352e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	02d05663          	blez	a3,8000355c <initlog+0x76>
    80003534:	05c50793          	addi	a5,a0,92
    80003538:	00021717          	auipc	a4,0x21
    8000353c:	41870713          	addi	a4,a4,1048 # 80024950 <log+0x30>
    80003540:	36fd                	addiw	a3,a3,-1
    80003542:	02069613          	slli	a2,a3,0x20
    80003546:	01e65693          	srli	a3,a2,0x1e
    8000354a:	06050613          	addi	a2,a0,96
    8000354e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003550:	4390                	lw	a2,0(a5)
    80003552:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003554:	0791                	addi	a5,a5,4
    80003556:	0711                	addi	a4,a4,4
    80003558:	fed79ce3          	bne	a5,a3,80003550 <initlog+0x6a>
  brelse(buf);
    8000355c:	fffff097          	auipc	ra,0xfffff
    80003560:	f7e080e7          	jalr	-130(ra) # 800024da <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003564:	4505                	li	a0,1
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	ebc080e7          	jalr	-324(ra) # 80003422 <install_trans>
  log.lh.n = 0;
    8000356e:	00021797          	auipc	a5,0x21
    80003572:	3c07af23          	sw	zero,990(a5) # 8002494c <log+0x2c>
  write_head(); // clear the log
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	e30080e7          	jalr	-464(ra) # 800033a6 <write_head>
}
    8000357e:	70a2                	ld	ra,40(sp)
    80003580:	7402                	ld	s0,32(sp)
    80003582:	64e2                	ld	s1,24(sp)
    80003584:	6942                	ld	s2,16(sp)
    80003586:	69a2                	ld	s3,8(sp)
    80003588:	6145                	addi	sp,sp,48
    8000358a:	8082                	ret

000000008000358c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000358c:	1101                	addi	sp,sp,-32
    8000358e:	ec06                	sd	ra,24(sp)
    80003590:	e822                	sd	s0,16(sp)
    80003592:	e426                	sd	s1,8(sp)
    80003594:	e04a                	sd	s2,0(sp)
    80003596:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003598:	00021517          	auipc	a0,0x21
    8000359c:	38850513          	addi	a0,a0,904 # 80024920 <log>
    800035a0:	00003097          	auipc	ra,0x3
    800035a4:	f8a080e7          	jalr	-118(ra) # 8000652a <acquire>
  while(1){
    if(log.committing){
    800035a8:	00021497          	auipc	s1,0x21
    800035ac:	37848493          	addi	s1,s1,888 # 80024920 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b0:	4979                	li	s2,30
    800035b2:	a039                	j	800035c0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b4:	85a6                	mv	a1,s1
    800035b6:	8526                	mv	a0,s1
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	f28080e7          	jalr	-216(ra) # 800014e0 <sleep>
    if(log.committing){
    800035c0:	50dc                	lw	a5,36(s1)
    800035c2:	fbed                	bnez	a5,800035b4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c4:	509c                	lw	a5,32(s1)
    800035c6:	0017871b          	addiw	a4,a5,1
    800035ca:	0007069b          	sext.w	a3,a4
    800035ce:	0027179b          	slliw	a5,a4,0x2
    800035d2:	9fb9                	addw	a5,a5,a4
    800035d4:	0017979b          	slliw	a5,a5,0x1
    800035d8:	54d8                	lw	a4,44(s1)
    800035da:	9fb9                	addw	a5,a5,a4
    800035dc:	00f95963          	bge	s2,a5,800035ee <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e0:	85a6                	mv	a1,s1
    800035e2:	8526                	mv	a0,s1
    800035e4:	ffffe097          	auipc	ra,0xffffe
    800035e8:	efc080e7          	jalr	-260(ra) # 800014e0 <sleep>
    800035ec:	bfd1                	j	800035c0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ee:	00021517          	auipc	a0,0x21
    800035f2:	33250513          	addi	a0,a0,818 # 80024920 <log>
    800035f6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035f8:	00003097          	auipc	ra,0x3
    800035fc:	fe6080e7          	jalr	-26(ra) # 800065de <release>
      break;
    }
  }
}
    80003600:	60e2                	ld	ra,24(sp)
    80003602:	6442                	ld	s0,16(sp)
    80003604:	64a2                	ld	s1,8(sp)
    80003606:	6902                	ld	s2,0(sp)
    80003608:	6105                	addi	sp,sp,32
    8000360a:	8082                	ret

000000008000360c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360c:	7139                	addi	sp,sp,-64
    8000360e:	fc06                	sd	ra,56(sp)
    80003610:	f822                	sd	s0,48(sp)
    80003612:	f426                	sd	s1,40(sp)
    80003614:	f04a                	sd	s2,32(sp)
    80003616:	ec4e                	sd	s3,24(sp)
    80003618:	e852                	sd	s4,16(sp)
    8000361a:	e456                	sd	s5,8(sp)
    8000361c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000361e:	00021497          	auipc	s1,0x21
    80003622:	30248493          	addi	s1,s1,770 # 80024920 <log>
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	f02080e7          	jalr	-254(ra) # 8000652a <acquire>
  log.outstanding -= 1;
    80003630:	509c                	lw	a5,32(s1)
    80003632:	37fd                	addiw	a5,a5,-1
    80003634:	0007891b          	sext.w	s2,a5
    80003638:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000363a:	50dc                	lw	a5,36(s1)
    8000363c:	e7b9                	bnez	a5,8000368a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000363e:	04091e63          	bnez	s2,8000369a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003642:	00021497          	auipc	s1,0x21
    80003646:	2de48493          	addi	s1,s1,734 # 80024920 <log>
    8000364a:	4785                	li	a5,1
    8000364c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000364e:	8526                	mv	a0,s1
    80003650:	00003097          	auipc	ra,0x3
    80003654:	f8e080e7          	jalr	-114(ra) # 800065de <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003658:	54dc                	lw	a5,44(s1)
    8000365a:	06f04763          	bgtz	a5,800036c8 <end_op+0xbc>
    acquire(&log.lock);
    8000365e:	00021497          	auipc	s1,0x21
    80003662:	2c248493          	addi	s1,s1,706 # 80024920 <log>
    80003666:	8526                	mv	a0,s1
    80003668:	00003097          	auipc	ra,0x3
    8000366c:	ec2080e7          	jalr	-318(ra) # 8000652a <acquire>
    log.committing = 0;
    80003670:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003674:	8526                	mv	a0,s1
    80003676:	ffffe097          	auipc	ra,0xffffe
    8000367a:	ece080e7          	jalr	-306(ra) # 80001544 <wakeup>
    release(&log.lock);
    8000367e:	8526                	mv	a0,s1
    80003680:	00003097          	auipc	ra,0x3
    80003684:	f5e080e7          	jalr	-162(ra) # 800065de <release>
}
    80003688:	a03d                	j	800036b6 <end_op+0xaa>
    panic("log.committing");
    8000368a:	00005517          	auipc	a0,0x5
    8000368e:	f1650513          	addi	a0,a0,-234 # 800085a0 <syscalls+0x1f0>
    80003692:	00003097          	auipc	ra,0x3
    80003696:	95c080e7          	jalr	-1700(ra) # 80005fee <panic>
    wakeup(&log);
    8000369a:	00021497          	auipc	s1,0x21
    8000369e:	28648493          	addi	s1,s1,646 # 80024920 <log>
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	ea0080e7          	jalr	-352(ra) # 80001544 <wakeup>
  release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	f30080e7          	jalr	-208(ra) # 800065de <release>
}
    800036b6:	70e2                	ld	ra,56(sp)
    800036b8:	7442                	ld	s0,48(sp)
    800036ba:	74a2                	ld	s1,40(sp)
    800036bc:	7902                	ld	s2,32(sp)
    800036be:	69e2                	ld	s3,24(sp)
    800036c0:	6a42                	ld	s4,16(sp)
    800036c2:	6aa2                	ld	s5,8(sp)
    800036c4:	6121                	addi	sp,sp,64
    800036c6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c8:	00021a97          	auipc	s5,0x21
    800036cc:	288a8a93          	addi	s5,s5,648 # 80024950 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d0:	00021a17          	auipc	s4,0x21
    800036d4:	250a0a13          	addi	s4,s4,592 # 80024920 <log>
    800036d8:	018a2583          	lw	a1,24(s4)
    800036dc:	012585bb          	addw	a1,a1,s2
    800036e0:	2585                	addiw	a1,a1,1
    800036e2:	028a2503          	lw	a0,40(s4)
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	cc4080e7          	jalr	-828(ra) # 800023aa <bread>
    800036ee:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f0:	000aa583          	lw	a1,0(s5)
    800036f4:	028a2503          	lw	a0,40(s4)
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	cb2080e7          	jalr	-846(ra) # 800023aa <bread>
    80003700:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003702:	40000613          	li	a2,1024
    80003706:	05850593          	addi	a1,a0,88
    8000370a:	05848513          	addi	a0,s1,88
    8000370e:	ffffd097          	auipc	ra,0xffffd
    80003712:	ac6080e7          	jalr	-1338(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003716:	8526                	mv	a0,s1
    80003718:	fffff097          	auipc	ra,0xfffff
    8000371c:	d84080e7          	jalr	-636(ra) # 8000249c <bwrite>
    brelse(from);
    80003720:	854e                	mv	a0,s3
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	db8080e7          	jalr	-584(ra) # 800024da <brelse>
    brelse(to);
    8000372a:	8526                	mv	a0,s1
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	dae080e7          	jalr	-594(ra) # 800024da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003734:	2905                	addiw	s2,s2,1
    80003736:	0a91                	addi	s5,s5,4
    80003738:	02ca2783          	lw	a5,44(s4)
    8000373c:	f8f94ee3          	blt	s2,a5,800036d8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003740:	00000097          	auipc	ra,0x0
    80003744:	c66080e7          	jalr	-922(ra) # 800033a6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003748:	4501                	li	a0,0
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	cd8080e7          	jalr	-808(ra) # 80003422 <install_trans>
    log.lh.n = 0;
    80003752:	00021797          	auipc	a5,0x21
    80003756:	1e07ad23          	sw	zero,506(a5) # 8002494c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	c4c080e7          	jalr	-948(ra) # 800033a6 <write_head>
    80003762:	bdf5                	j	8000365e <end_op+0x52>

0000000080003764 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003764:	1101                	addi	sp,sp,-32
    80003766:	ec06                	sd	ra,24(sp)
    80003768:	e822                	sd	s0,16(sp)
    8000376a:	e426                	sd	s1,8(sp)
    8000376c:	e04a                	sd	s2,0(sp)
    8000376e:	1000                	addi	s0,sp,32
    80003770:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003772:	00021917          	auipc	s2,0x21
    80003776:	1ae90913          	addi	s2,s2,430 # 80024920 <log>
    8000377a:	854a                	mv	a0,s2
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	dae080e7          	jalr	-594(ra) # 8000652a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003784:	02c92603          	lw	a2,44(s2)
    80003788:	47f5                	li	a5,29
    8000378a:	06c7c563          	blt	a5,a2,800037f4 <log_write+0x90>
    8000378e:	00021797          	auipc	a5,0x21
    80003792:	1ae7a783          	lw	a5,430(a5) # 8002493c <log+0x1c>
    80003796:	37fd                	addiw	a5,a5,-1
    80003798:	04f65e63          	bge	a2,a5,800037f4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000379c:	00021797          	auipc	a5,0x21
    800037a0:	1a47a783          	lw	a5,420(a5) # 80024940 <log+0x20>
    800037a4:	06f05063          	blez	a5,80003804 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037a8:	4781                	li	a5,0
    800037aa:	06c05563          	blez	a2,80003814 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ae:	44cc                	lw	a1,12(s1)
    800037b0:	00021717          	auipc	a4,0x21
    800037b4:	1a070713          	addi	a4,a4,416 # 80024950 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037b8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ba:	4314                	lw	a3,0(a4)
    800037bc:	04b68c63          	beq	a3,a1,80003814 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c0:	2785                	addiw	a5,a5,1
    800037c2:	0711                	addi	a4,a4,4
    800037c4:	fef61be3          	bne	a2,a5,800037ba <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037c8:	0621                	addi	a2,a2,8
    800037ca:	060a                	slli	a2,a2,0x2
    800037cc:	00021797          	auipc	a5,0x21
    800037d0:	15478793          	addi	a5,a5,340 # 80024920 <log>
    800037d4:	963e                	add	a2,a2,a5
    800037d6:	44dc                	lw	a5,12(s1)
    800037d8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037da:	8526                	mv	a0,s1
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	d9c080e7          	jalr	-612(ra) # 80002578 <bpin>
    log.lh.n++;
    800037e4:	00021717          	auipc	a4,0x21
    800037e8:	13c70713          	addi	a4,a4,316 # 80024920 <log>
    800037ec:	575c                	lw	a5,44(a4)
    800037ee:	2785                	addiw	a5,a5,1
    800037f0:	d75c                	sw	a5,44(a4)
    800037f2:	a835                	j	8000382e <log_write+0xca>
    panic("too big a transaction");
    800037f4:	00005517          	auipc	a0,0x5
    800037f8:	dbc50513          	addi	a0,a0,-580 # 800085b0 <syscalls+0x200>
    800037fc:	00002097          	auipc	ra,0x2
    80003800:	7f2080e7          	jalr	2034(ra) # 80005fee <panic>
    panic("log_write outside of trans");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	dc450513          	addi	a0,a0,-572 # 800085c8 <syscalls+0x218>
    8000380c:	00002097          	auipc	ra,0x2
    80003810:	7e2080e7          	jalr	2018(ra) # 80005fee <panic>
  log.lh.block[i] = b->blockno;
    80003814:	00878713          	addi	a4,a5,8
    80003818:	00271693          	slli	a3,a4,0x2
    8000381c:	00021717          	auipc	a4,0x21
    80003820:	10470713          	addi	a4,a4,260 # 80024920 <log>
    80003824:	9736                	add	a4,a4,a3
    80003826:	44d4                	lw	a3,12(s1)
    80003828:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000382a:	faf608e3          	beq	a2,a5,800037da <log_write+0x76>
  }
  release(&log.lock);
    8000382e:	00021517          	auipc	a0,0x21
    80003832:	0f250513          	addi	a0,a0,242 # 80024920 <log>
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	da8080e7          	jalr	-600(ra) # 800065de <release>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret

000000008000384a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000384a:	1101                	addi	sp,sp,-32
    8000384c:	ec06                	sd	ra,24(sp)
    8000384e:	e822                	sd	s0,16(sp)
    80003850:	e426                	sd	s1,8(sp)
    80003852:	e04a                	sd	s2,0(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	84aa                	mv	s1,a0
    80003858:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000385a:	00005597          	auipc	a1,0x5
    8000385e:	d8e58593          	addi	a1,a1,-626 # 800085e8 <syscalls+0x238>
    80003862:	0521                	addi	a0,a0,8
    80003864:	00003097          	auipc	ra,0x3
    80003868:	c36080e7          	jalr	-970(ra) # 8000649a <initlock>
  lk->name = name;
    8000386c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003870:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003874:	0204a423          	sw	zero,40(s1)
}
    80003878:	60e2                	ld	ra,24(sp)
    8000387a:	6442                	ld	s0,16(sp)
    8000387c:	64a2                	ld	s1,8(sp)
    8000387e:	6902                	ld	s2,0(sp)
    80003880:	6105                	addi	sp,sp,32
    80003882:	8082                	ret

0000000080003884 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	e04a                	sd	s2,0(sp)
    8000388e:	1000                	addi	s0,sp,32
    80003890:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003892:	00850913          	addi	s2,a0,8
    80003896:	854a                	mv	a0,s2
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	c92080e7          	jalr	-878(ra) # 8000652a <acquire>
  while (lk->locked) {
    800038a0:	409c                	lw	a5,0(s1)
    800038a2:	cb89                	beqz	a5,800038b4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a4:	85ca                	mv	a1,s2
    800038a6:	8526                	mv	a0,s1
    800038a8:	ffffe097          	auipc	ra,0xffffe
    800038ac:	c38080e7          	jalr	-968(ra) # 800014e0 <sleep>
  while (lk->locked) {
    800038b0:	409c                	lw	a5,0(s1)
    800038b2:	fbed                	bnez	a5,800038a4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b4:	4785                	li	a5,1
    800038b6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	580080e7          	jalr	1408(ra) # 80000e38 <myproc>
    800038c0:	591c                	lw	a5,48(a0)
    800038c2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c4:	854a                	mv	a0,s2
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	d18080e7          	jalr	-744(ra) # 800065de <release>
}
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	64a2                	ld	s1,8(sp)
    800038d4:	6902                	ld	s2,0(sp)
    800038d6:	6105                	addi	sp,sp,32
    800038d8:	8082                	ret

00000000800038da <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038da:	1101                	addi	sp,sp,-32
    800038dc:	ec06                	sd	ra,24(sp)
    800038de:	e822                	sd	s0,16(sp)
    800038e0:	e426                	sd	s1,8(sp)
    800038e2:	e04a                	sd	s2,0(sp)
    800038e4:	1000                	addi	s0,sp,32
    800038e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e8:	00850913          	addi	s2,a0,8
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	c3c080e7          	jalr	-964(ra) # 8000652a <acquire>
  lk->locked = 0;
    800038f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038fa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038fe:	8526                	mv	a0,s1
    80003900:	ffffe097          	auipc	ra,0xffffe
    80003904:	c44080e7          	jalr	-956(ra) # 80001544 <wakeup>
  release(&lk->lk);
    80003908:	854a                	mv	a0,s2
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	cd4080e7          	jalr	-812(ra) # 800065de <release>
}
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	6105                	addi	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000391e:	7179                	addi	sp,sp,-48
    80003920:	f406                	sd	ra,40(sp)
    80003922:	f022                	sd	s0,32(sp)
    80003924:	ec26                	sd	s1,24(sp)
    80003926:	e84a                	sd	s2,16(sp)
    80003928:	e44e                	sd	s3,8(sp)
    8000392a:	1800                	addi	s0,sp,48
    8000392c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000392e:	00850913          	addi	s2,a0,8
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	bf6080e7          	jalr	-1034(ra) # 8000652a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	ef99                	bnez	a5,8000395c <holdingsleep+0x3e>
    80003940:	4481                	li	s1,0
  release(&lk->lk);
    80003942:	854a                	mv	a0,s2
    80003944:	00003097          	auipc	ra,0x3
    80003948:	c9a080e7          	jalr	-870(ra) # 800065de <release>
  return r;
}
    8000394c:	8526                	mv	a0,s1
    8000394e:	70a2                	ld	ra,40(sp)
    80003950:	7402                	ld	s0,32(sp)
    80003952:	64e2                	ld	s1,24(sp)
    80003954:	6942                	ld	s2,16(sp)
    80003956:	69a2                	ld	s3,8(sp)
    80003958:	6145                	addi	sp,sp,48
    8000395a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395c:	0284a983          	lw	s3,40(s1)
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	4d8080e7          	jalr	1240(ra) # 80000e38 <myproc>
    80003968:	5904                	lw	s1,48(a0)
    8000396a:	413484b3          	sub	s1,s1,s3
    8000396e:	0014b493          	seqz	s1,s1
    80003972:	bfc1                	j	80003942 <holdingsleep+0x24>

0000000080003974 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003974:	1141                	addi	sp,sp,-16
    80003976:	e406                	sd	ra,8(sp)
    80003978:	e022                	sd	s0,0(sp)
    8000397a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000397c:	00005597          	auipc	a1,0x5
    80003980:	c7c58593          	addi	a1,a1,-900 # 800085f8 <syscalls+0x248>
    80003984:	00021517          	auipc	a0,0x21
    80003988:	0e450513          	addi	a0,a0,228 # 80024a68 <ftable>
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	b0e080e7          	jalr	-1266(ra) # 8000649a <initlock>
}
    80003994:	60a2                	ld	ra,8(sp)
    80003996:	6402                	ld	s0,0(sp)
    80003998:	0141                	addi	sp,sp,16
    8000399a:	8082                	ret

000000008000399c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000399c:	1101                	addi	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a6:	00021517          	auipc	a0,0x21
    800039aa:	0c250513          	addi	a0,a0,194 # 80024a68 <ftable>
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	b7c080e7          	jalr	-1156(ra) # 8000652a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b6:	00021497          	auipc	s1,0x21
    800039ba:	0ca48493          	addi	s1,s1,202 # 80024a80 <ftable+0x18>
    800039be:	00022717          	auipc	a4,0x22
    800039c2:	06270713          	addi	a4,a4,98 # 80025a20 <disk>
    if(f->ref == 0){
    800039c6:	40dc                	lw	a5,4(s1)
    800039c8:	cf99                	beqz	a5,800039e6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ca:	02848493          	addi	s1,s1,40
    800039ce:	fee49ce3          	bne	s1,a4,800039c6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039d2:	00021517          	auipc	a0,0x21
    800039d6:	09650513          	addi	a0,a0,150 # 80024a68 <ftable>
    800039da:	00003097          	auipc	ra,0x3
    800039de:	c04080e7          	jalr	-1020(ra) # 800065de <release>
  return 0;
    800039e2:	4481                	li	s1,0
    800039e4:	a819                	j	800039fa <filealloc+0x5e>
      f->ref = 1;
    800039e6:	4785                	li	a5,1
    800039e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ea:	00021517          	auipc	a0,0x21
    800039ee:	07e50513          	addi	a0,a0,126 # 80024a68 <ftable>
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	bec080e7          	jalr	-1044(ra) # 800065de <release>
}
    800039fa:	8526                	mv	a0,s1
    800039fc:	60e2                	ld	ra,24(sp)
    800039fe:	6442                	ld	s0,16(sp)
    80003a00:	64a2                	ld	s1,8(sp)
    80003a02:	6105                	addi	sp,sp,32
    80003a04:	8082                	ret

0000000080003a06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a06:	1101                	addi	sp,sp,-32
    80003a08:	ec06                	sd	ra,24(sp)
    80003a0a:	e822                	sd	s0,16(sp)
    80003a0c:	e426                	sd	s1,8(sp)
    80003a0e:	1000                	addi	s0,sp,32
    80003a10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a12:	00021517          	auipc	a0,0x21
    80003a16:	05650513          	addi	a0,a0,86 # 80024a68 <ftable>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	b10080e7          	jalr	-1264(ra) # 8000652a <acquire>
  if(f->ref < 1)
    80003a22:	40dc                	lw	a5,4(s1)
    80003a24:	02f05263          	blez	a5,80003a48 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a28:	2785                	addiw	a5,a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a2c:	00021517          	auipc	a0,0x21
    80003a30:	03c50513          	addi	a0,a0,60 # 80024a68 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	baa080e7          	jalr	-1110(ra) # 800065de <release>
  return f;
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret
    panic("filedup");
    80003a48:	00005517          	auipc	a0,0x5
    80003a4c:	bb850513          	addi	a0,a0,-1096 # 80008600 <syscalls+0x250>
    80003a50:	00002097          	auipc	ra,0x2
    80003a54:	59e080e7          	jalr	1438(ra) # 80005fee <panic>

0000000080003a58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a58:	7139                	addi	sp,sp,-64
    80003a5a:	fc06                	sd	ra,56(sp)
    80003a5c:	f822                	sd	s0,48(sp)
    80003a5e:	f426                	sd	s1,40(sp)
    80003a60:	f04a                	sd	s2,32(sp)
    80003a62:	ec4e                	sd	s3,24(sp)
    80003a64:	e852                	sd	s4,16(sp)
    80003a66:	e456                	sd	s5,8(sp)
    80003a68:	0080                	addi	s0,sp,64
    80003a6a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a6c:	00021517          	auipc	a0,0x21
    80003a70:	ffc50513          	addi	a0,a0,-4 # 80024a68 <ftable>
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	ab6080e7          	jalr	-1354(ra) # 8000652a <acquire>
  if(f->ref < 1)
    80003a7c:	40dc                	lw	a5,4(s1)
    80003a7e:	06f05163          	blez	a5,80003ae0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a82:	37fd                	addiw	a5,a5,-1
    80003a84:	0007871b          	sext.w	a4,a5
    80003a88:	c0dc                	sw	a5,4(s1)
    80003a8a:	06e04363          	bgtz	a4,80003af0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a8e:	0004a903          	lw	s2,0(s1)
    80003a92:	0094ca83          	lbu	s5,9(s1)
    80003a96:	0104ba03          	ld	s4,16(s1)
    80003a9a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a9e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aa2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa6:	00021517          	auipc	a0,0x21
    80003aaa:	fc250513          	addi	a0,a0,-62 # 80024a68 <ftable>
    80003aae:	00003097          	auipc	ra,0x3
    80003ab2:	b30080e7          	jalr	-1232(ra) # 800065de <release>

  if(ff.type == FD_PIPE){
    80003ab6:	4785                	li	a5,1
    80003ab8:	04f90d63          	beq	s2,a5,80003b12 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003abc:	3979                	addiw	s2,s2,-2
    80003abe:	4785                	li	a5,1
    80003ac0:	0527e063          	bltu	a5,s2,80003b00 <fileclose+0xa8>
    begin_op();
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	ac8080e7          	jalr	-1336(ra) # 8000358c <begin_op>
    iput(ff.ip);
    80003acc:	854e                	mv	a0,s3
    80003ace:	fffff097          	auipc	ra,0xfffff
    80003ad2:	2b2080e7          	jalr	690(ra) # 80002d80 <iput>
    end_op();
    80003ad6:	00000097          	auipc	ra,0x0
    80003ada:	b36080e7          	jalr	-1226(ra) # 8000360c <end_op>
    80003ade:	a00d                	j	80003b00 <fileclose+0xa8>
    panic("fileclose");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	b2850513          	addi	a0,a0,-1240 # 80008608 <syscalls+0x258>
    80003ae8:	00002097          	auipc	ra,0x2
    80003aec:	506080e7          	jalr	1286(ra) # 80005fee <panic>
    release(&ftable.lock);
    80003af0:	00021517          	auipc	a0,0x21
    80003af4:	f7850513          	addi	a0,a0,-136 # 80024a68 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	ae6080e7          	jalr	-1306(ra) # 800065de <release>
  }
}
    80003b00:	70e2                	ld	ra,56(sp)
    80003b02:	7442                	ld	s0,48(sp)
    80003b04:	74a2                	ld	s1,40(sp)
    80003b06:	7902                	ld	s2,32(sp)
    80003b08:	69e2                	ld	s3,24(sp)
    80003b0a:	6a42                	ld	s4,16(sp)
    80003b0c:	6aa2                	ld	s5,8(sp)
    80003b0e:	6121                	addi	sp,sp,64
    80003b10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b12:	85d6                	mv	a1,s5
    80003b14:	8552                	mv	a0,s4
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	3a6080e7          	jalr	934(ra) # 80003ebc <pipeclose>
    80003b1e:	b7cd                	j	80003b00 <fileclose+0xa8>

0000000080003b20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b20:	715d                	addi	sp,sp,-80
    80003b22:	e486                	sd	ra,72(sp)
    80003b24:	e0a2                	sd	s0,64(sp)
    80003b26:	fc26                	sd	s1,56(sp)
    80003b28:	f84a                	sd	s2,48(sp)
    80003b2a:	f44e                	sd	s3,40(sp)
    80003b2c:	0880                	addi	s0,sp,80
    80003b2e:	84aa                	mv	s1,a0
    80003b30:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b32:	ffffd097          	auipc	ra,0xffffd
    80003b36:	306080e7          	jalr	774(ra) # 80000e38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b3a:	409c                	lw	a5,0(s1)
    80003b3c:	37f9                	addiw	a5,a5,-2
    80003b3e:	4705                	li	a4,1
    80003b40:	04f76763          	bltu	a4,a5,80003b8e <filestat+0x6e>
    80003b44:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b46:	6c88                	ld	a0,24(s1)
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	07e080e7          	jalr	126(ra) # 80002bc6 <ilock>
    stati(f->ip, &st);
    80003b50:	fb840593          	addi	a1,s0,-72
    80003b54:	6c88                	ld	a0,24(s1)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	2fa080e7          	jalr	762(ra) # 80002e50 <stati>
    iunlock(f->ip);
    80003b5e:	6c88                	ld	a0,24(s1)
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	128080e7          	jalr	296(ra) # 80002c88 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b68:	46e1                	li	a3,24
    80003b6a:	fb840613          	addi	a2,s0,-72
    80003b6e:	85ce                	mv	a1,s3
    80003b70:	05093503          	ld	a0,80(s2)
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	f80080e7          	jalr	-128(ra) # 80000af4 <copyout>
    80003b7c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b80:	60a6                	ld	ra,72(sp)
    80003b82:	6406                	ld	s0,64(sp)
    80003b84:	74e2                	ld	s1,56(sp)
    80003b86:	7942                	ld	s2,48(sp)
    80003b88:	79a2                	ld	s3,40(sp)
    80003b8a:	6161                	addi	sp,sp,80
    80003b8c:	8082                	ret
  return -1;
    80003b8e:	557d                	li	a0,-1
    80003b90:	bfc5                	j	80003b80 <filestat+0x60>

0000000080003b92 <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003b92:	7179                	addi	sp,sp,-48
    80003b94:	f406                	sd	ra,40(sp)
    80003b96:	f022                	sd	s0,32(sp)
    80003b98:	ec26                	sd	s1,24(sp)
    80003b9a:	e84a                	sd	s2,16(sp)
    80003b9c:	e44e                	sd	s3,8(sp)
    80003b9e:	1800                	addi	s0,sp,48
    80003ba0:	84aa                	mv	s1,a0
    80003ba2:	89ae                	mv	s3,a1
    80003ba4:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003ba6:	85b2                	mv	a1,a2
    80003ba8:	00005517          	auipc	a0,0x5
    80003bac:	a7050513          	addi	a0,a0,-1424 # 80008618 <syscalls+0x268>
    80003bb0:	00002097          	auipc	ra,0x2
    80003bb4:	488080e7          	jalr	1160(ra) # 80006038 <printf>
  ilock(f->ip);
    80003bb8:	6c88                	ld	a0,24(s1)
    80003bba:	fffff097          	auipc	ra,0xfffff
    80003bbe:	00c080e7          	jalr	12(ra) # 80002bc6 <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003bc2:	6705                	lui	a4,0x1
    80003bc4:	86ca                	mv	a3,s2
    80003bc6:	864e                	mv	a2,s3
    80003bc8:	4581                	li	a1,0
    80003bca:	6c88                	ld	a0,24(s1)
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	2ae080e7          	jalr	686(ra) # 80002e7a <readi>
  iunlock(f->ip);
    80003bd4:	6c88                	ld	a0,24(s1)
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	0b2080e7          	jalr	178(ra) # 80002c88 <iunlock>
}
    80003bde:	70a2                	ld	ra,40(sp)
    80003be0:	7402                	ld	s0,32(sp)
    80003be2:	64e2                	ld	s1,24(sp)
    80003be4:	6942                	ld	s2,16(sp)
    80003be6:	69a2                	ld	s3,8(sp)
    80003be8:	6145                	addi	sp,sp,48
    80003bea:	8082                	ret

0000000080003bec <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bec:	7179                	addi	sp,sp,-48
    80003bee:	f406                	sd	ra,40(sp)
    80003bf0:	f022                	sd	s0,32(sp)
    80003bf2:	ec26                	sd	s1,24(sp)
    80003bf4:	e84a                	sd	s2,16(sp)
    80003bf6:	e44e                	sd	s3,8(sp)
    80003bf8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bfa:	00854783          	lbu	a5,8(a0)
    80003bfe:	c3d5                	beqz	a5,80003ca2 <fileread+0xb6>
    80003c00:	84aa                	mv	s1,a0
    80003c02:	89ae                	mv	s3,a1
    80003c04:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c06:	411c                	lw	a5,0(a0)
    80003c08:	4705                	li	a4,1
    80003c0a:	04e78963          	beq	a5,a4,80003c5c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c0e:	470d                	li	a4,3
    80003c10:	04e78d63          	beq	a5,a4,80003c6a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c14:	4709                	li	a4,2
    80003c16:	06e79e63          	bne	a5,a4,80003c92 <fileread+0xa6>
    ilock(f->ip);
    80003c1a:	6d08                	ld	a0,24(a0)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	faa080e7          	jalr	-86(ra) # 80002bc6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c24:	874a                	mv	a4,s2
    80003c26:	5094                	lw	a3,32(s1)
    80003c28:	864e                	mv	a2,s3
    80003c2a:	4585                	li	a1,1
    80003c2c:	6c88                	ld	a0,24(s1)
    80003c2e:	fffff097          	auipc	ra,0xfffff
    80003c32:	24c080e7          	jalr	588(ra) # 80002e7a <readi>
    80003c36:	892a                	mv	s2,a0
    80003c38:	00a05563          	blez	a0,80003c42 <fileread+0x56>
      f->off += r;
    80003c3c:	509c                	lw	a5,32(s1)
    80003c3e:	9fa9                	addw	a5,a5,a0
    80003c40:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c42:	6c88                	ld	a0,24(s1)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	044080e7          	jalr	68(ra) # 80002c88 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c4c:	854a                	mv	a0,s2
    80003c4e:	70a2                	ld	ra,40(sp)
    80003c50:	7402                	ld	s0,32(sp)
    80003c52:	64e2                	ld	s1,24(sp)
    80003c54:	6942                	ld	s2,16(sp)
    80003c56:	69a2                	ld	s3,8(sp)
    80003c58:	6145                	addi	sp,sp,48
    80003c5a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c5c:	6908                	ld	a0,16(a0)
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	3c6080e7          	jalr	966(ra) # 80004024 <piperead>
    80003c66:	892a                	mv	s2,a0
    80003c68:	b7d5                	j	80003c4c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c6a:	02451783          	lh	a5,36(a0)
    80003c6e:	03079693          	slli	a3,a5,0x30
    80003c72:	92c1                	srli	a3,a3,0x30
    80003c74:	4725                	li	a4,9
    80003c76:	02d76863          	bltu	a4,a3,80003ca6 <fileread+0xba>
    80003c7a:	0792                	slli	a5,a5,0x4
    80003c7c:	00021717          	auipc	a4,0x21
    80003c80:	d4c70713          	addi	a4,a4,-692 # 800249c8 <devsw>
    80003c84:	97ba                	add	a5,a5,a4
    80003c86:	639c                	ld	a5,0(a5)
    80003c88:	c38d                	beqz	a5,80003caa <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c8a:	4505                	li	a0,1
    80003c8c:	9782                	jalr	a5
    80003c8e:	892a                	mv	s2,a0
    80003c90:	bf75                	j	80003c4c <fileread+0x60>
    panic("fileread");
    80003c92:	00005517          	auipc	a0,0x5
    80003c96:	98e50513          	addi	a0,a0,-1650 # 80008620 <syscalls+0x270>
    80003c9a:	00002097          	auipc	ra,0x2
    80003c9e:	354080e7          	jalr	852(ra) # 80005fee <panic>
    return -1;
    80003ca2:	597d                	li	s2,-1
    80003ca4:	b765                	j	80003c4c <fileread+0x60>
      return -1;
    80003ca6:	597d                	li	s2,-1
    80003ca8:	b755                	j	80003c4c <fileread+0x60>
    80003caa:	597d                	li	s2,-1
    80003cac:	b745                	j	80003c4c <fileread+0x60>

0000000080003cae <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cae:	715d                	addi	sp,sp,-80
    80003cb0:	e486                	sd	ra,72(sp)
    80003cb2:	e0a2                	sd	s0,64(sp)
    80003cb4:	fc26                	sd	s1,56(sp)
    80003cb6:	f84a                	sd	s2,48(sp)
    80003cb8:	f44e                	sd	s3,40(sp)
    80003cba:	f052                	sd	s4,32(sp)
    80003cbc:	ec56                	sd	s5,24(sp)
    80003cbe:	e85a                	sd	s6,16(sp)
    80003cc0:	e45e                	sd	s7,8(sp)
    80003cc2:	e062                	sd	s8,0(sp)
    80003cc4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cc6:	00954783          	lbu	a5,9(a0)
    80003cca:	10078663          	beqz	a5,80003dd6 <filewrite+0x128>
    80003cce:	892a                	mv	s2,a0
    80003cd0:	8aae                	mv	s5,a1
    80003cd2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cd4:	411c                	lw	a5,0(a0)
    80003cd6:	4705                	li	a4,1
    80003cd8:	02e78263          	beq	a5,a4,80003cfc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cdc:	470d                	li	a4,3
    80003cde:	02e78663          	beq	a5,a4,80003d0a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ce2:	4709                	li	a4,2
    80003ce4:	0ee79163          	bne	a5,a4,80003dc6 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ce8:	0ac05d63          	blez	a2,80003da2 <filewrite+0xf4>
    int i = 0;
    80003cec:	4981                	li	s3,0
    80003cee:	6b05                	lui	s6,0x1
    80003cf0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cf4:	6b85                	lui	s7,0x1
    80003cf6:	c00b8b9b          	addiw	s7,s7,-1024
    80003cfa:	a861                	j	80003d92 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cfc:	6908                	ld	a0,16(a0)
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	22e080e7          	jalr	558(ra) # 80003f2c <pipewrite>
    80003d06:	8a2a                	mv	s4,a0
    80003d08:	a045                	j	80003da8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d0a:	02451783          	lh	a5,36(a0)
    80003d0e:	03079693          	slli	a3,a5,0x30
    80003d12:	92c1                	srli	a3,a3,0x30
    80003d14:	4725                	li	a4,9
    80003d16:	0cd76263          	bltu	a4,a3,80003dda <filewrite+0x12c>
    80003d1a:	0792                	slli	a5,a5,0x4
    80003d1c:	00021717          	auipc	a4,0x21
    80003d20:	cac70713          	addi	a4,a4,-852 # 800249c8 <devsw>
    80003d24:	97ba                	add	a5,a5,a4
    80003d26:	679c                	ld	a5,8(a5)
    80003d28:	cbdd                	beqz	a5,80003dde <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d2a:	4505                	li	a0,1
    80003d2c:	9782                	jalr	a5
    80003d2e:	8a2a                	mv	s4,a0
    80003d30:	a8a5                	j	80003da8 <filewrite+0xfa>
    80003d32:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	856080e7          	jalr	-1962(ra) # 8000358c <begin_op>
      ilock(f->ip);
    80003d3e:	01893503          	ld	a0,24(s2)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	e84080e7          	jalr	-380(ra) # 80002bc6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d4a:	8762                	mv	a4,s8
    80003d4c:	02092683          	lw	a3,32(s2)
    80003d50:	01598633          	add	a2,s3,s5
    80003d54:	4585                	li	a1,1
    80003d56:	01893503          	ld	a0,24(s2)
    80003d5a:	fffff097          	auipc	ra,0xfffff
    80003d5e:	218080e7          	jalr	536(ra) # 80002f72 <writei>
    80003d62:	84aa                	mv	s1,a0
    80003d64:	00a05763          	blez	a0,80003d72 <filewrite+0xc4>
        f->off += r;
    80003d68:	02092783          	lw	a5,32(s2)
    80003d6c:	9fa9                	addw	a5,a5,a0
    80003d6e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d72:	01893503          	ld	a0,24(s2)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	f12080e7          	jalr	-238(ra) # 80002c88 <iunlock>
      end_op();
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	88e080e7          	jalr	-1906(ra) # 8000360c <end_op>

      if(r != n1){
    80003d86:	009c1f63          	bne	s8,s1,80003da4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d8a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d8e:	0149db63          	bge	s3,s4,80003da4 <filewrite+0xf6>
      int n1 = n - i;
    80003d92:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d96:	84be                	mv	s1,a5
    80003d98:	2781                	sext.w	a5,a5
    80003d9a:	f8fb5ce3          	bge	s6,a5,80003d32 <filewrite+0x84>
    80003d9e:	84de                	mv	s1,s7
    80003da0:	bf49                	j	80003d32 <filewrite+0x84>
    int i = 0;
    80003da2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003da4:	013a1f63          	bne	s4,s3,80003dc2 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003da8:	8552                	mv	a0,s4
    80003daa:	60a6                	ld	ra,72(sp)
    80003dac:	6406                	ld	s0,64(sp)
    80003dae:	74e2                	ld	s1,56(sp)
    80003db0:	7942                	ld	s2,48(sp)
    80003db2:	79a2                	ld	s3,40(sp)
    80003db4:	7a02                	ld	s4,32(sp)
    80003db6:	6ae2                	ld	s5,24(sp)
    80003db8:	6b42                	ld	s6,16(sp)
    80003dba:	6ba2                	ld	s7,8(sp)
    80003dbc:	6c02                	ld	s8,0(sp)
    80003dbe:	6161                	addi	sp,sp,80
    80003dc0:	8082                	ret
    ret = (i == n ? n : -1);
    80003dc2:	5a7d                	li	s4,-1
    80003dc4:	b7d5                	j	80003da8 <filewrite+0xfa>
    panic("filewrite");
    80003dc6:	00005517          	auipc	a0,0x5
    80003dca:	86a50513          	addi	a0,a0,-1942 # 80008630 <syscalls+0x280>
    80003dce:	00002097          	auipc	ra,0x2
    80003dd2:	220080e7          	jalr	544(ra) # 80005fee <panic>
    return -1;
    80003dd6:	5a7d                	li	s4,-1
    80003dd8:	bfc1                	j	80003da8 <filewrite+0xfa>
      return -1;
    80003dda:	5a7d                	li	s4,-1
    80003ddc:	b7f1                	j	80003da8 <filewrite+0xfa>
    80003dde:	5a7d                	li	s4,-1
    80003de0:	b7e1                	j	80003da8 <filewrite+0xfa>

0000000080003de2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003de2:	7179                	addi	sp,sp,-48
    80003de4:	f406                	sd	ra,40(sp)
    80003de6:	f022                	sd	s0,32(sp)
    80003de8:	ec26                	sd	s1,24(sp)
    80003dea:	e84a                	sd	s2,16(sp)
    80003dec:	e44e                	sd	s3,8(sp)
    80003dee:	e052                	sd	s4,0(sp)
    80003df0:	1800                	addi	s0,sp,48
    80003df2:	84aa                	mv	s1,a0
    80003df4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003df6:	0005b023          	sd	zero,0(a1)
    80003dfa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	b9e080e7          	jalr	-1122(ra) # 8000399c <filealloc>
    80003e06:	e088                	sd	a0,0(s1)
    80003e08:	c551                	beqz	a0,80003e94 <pipealloc+0xb2>
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	b92080e7          	jalr	-1134(ra) # 8000399c <filealloc>
    80003e12:	00aa3023          	sd	a0,0(s4)
    80003e16:	c92d                	beqz	a0,80003e88 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e18:	ffffc097          	auipc	ra,0xffffc
    80003e1c:	300080e7          	jalr	768(ra) # 80000118 <kalloc>
    80003e20:	892a                	mv	s2,a0
    80003e22:	c125                	beqz	a0,80003e82 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e24:	4985                	li	s3,1
    80003e26:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e2a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e2e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e32:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e36:	00005597          	auipc	a1,0x5
    80003e3a:	80a58593          	addi	a1,a1,-2038 # 80008640 <syscalls+0x290>
    80003e3e:	00002097          	auipc	ra,0x2
    80003e42:	65c080e7          	jalr	1628(ra) # 8000649a <initlock>
  (*f0)->type = FD_PIPE;
    80003e46:	609c                	ld	a5,0(s1)
    80003e48:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e4c:	609c                	ld	a5,0(s1)
    80003e4e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e52:	609c                	ld	a5,0(s1)
    80003e54:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e58:	609c                	ld	a5,0(s1)
    80003e5a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e5e:	000a3783          	ld	a5,0(s4)
    80003e62:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e66:	000a3783          	ld	a5,0(s4)
    80003e6a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e6e:	000a3783          	ld	a5,0(s4)
    80003e72:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e76:	000a3783          	ld	a5,0(s4)
    80003e7a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e7e:	4501                	li	a0,0
    80003e80:	a025                	j	80003ea8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e82:	6088                	ld	a0,0(s1)
    80003e84:	e501                	bnez	a0,80003e8c <pipealloc+0xaa>
    80003e86:	a039                	j	80003e94 <pipealloc+0xb2>
    80003e88:	6088                	ld	a0,0(s1)
    80003e8a:	c51d                	beqz	a0,80003eb8 <pipealloc+0xd6>
    fileclose(*f0);
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	bcc080e7          	jalr	-1076(ra) # 80003a58 <fileclose>
  if(*f1)
    80003e94:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e98:	557d                	li	a0,-1
  if(*f1)
    80003e9a:	c799                	beqz	a5,80003ea8 <pipealloc+0xc6>
    fileclose(*f1);
    80003e9c:	853e                	mv	a0,a5
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	bba080e7          	jalr	-1094(ra) # 80003a58 <fileclose>
  return -1;
    80003ea6:	557d                	li	a0,-1
}
    80003ea8:	70a2                	ld	ra,40(sp)
    80003eaa:	7402                	ld	s0,32(sp)
    80003eac:	64e2                	ld	s1,24(sp)
    80003eae:	6942                	ld	s2,16(sp)
    80003eb0:	69a2                	ld	s3,8(sp)
    80003eb2:	6a02                	ld	s4,0(sp)
    80003eb4:	6145                	addi	sp,sp,48
    80003eb6:	8082                	ret
  return -1;
    80003eb8:	557d                	li	a0,-1
    80003eba:	b7fd                	j	80003ea8 <pipealloc+0xc6>

0000000080003ebc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ebc:	1101                	addi	sp,sp,-32
    80003ebe:	ec06                	sd	ra,24(sp)
    80003ec0:	e822                	sd	s0,16(sp)
    80003ec2:	e426                	sd	s1,8(sp)
    80003ec4:	e04a                	sd	s2,0(sp)
    80003ec6:	1000                	addi	s0,sp,32
    80003ec8:	84aa                	mv	s1,a0
    80003eca:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	65e080e7          	jalr	1630(ra) # 8000652a <acquire>
  if(writable){
    80003ed4:	02090d63          	beqz	s2,80003f0e <pipeclose+0x52>
    pi->writeopen = 0;
    80003ed8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003edc:	21848513          	addi	a0,s1,536
    80003ee0:	ffffd097          	auipc	ra,0xffffd
    80003ee4:	664080e7          	jalr	1636(ra) # 80001544 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ee8:	2204b783          	ld	a5,544(s1)
    80003eec:	eb95                	bnez	a5,80003f20 <pipeclose+0x64>
    release(&pi->lock);
    80003eee:	8526                	mv	a0,s1
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	6ee080e7          	jalr	1774(ra) # 800065de <release>
    kfree((char*)pi);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	ffffc097          	auipc	ra,0xffffc
    80003efe:	122080e7          	jalr	290(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6902                	ld	s2,0(sp)
    80003f0a:	6105                	addi	sp,sp,32
    80003f0c:	8082                	ret
    pi->readopen = 0;
    80003f0e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f12:	21c48513          	addi	a0,s1,540
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	62e080e7          	jalr	1582(ra) # 80001544 <wakeup>
    80003f1e:	b7e9                	j	80003ee8 <pipeclose+0x2c>
    release(&pi->lock);
    80003f20:	8526                	mv	a0,s1
    80003f22:	00002097          	auipc	ra,0x2
    80003f26:	6bc080e7          	jalr	1724(ra) # 800065de <release>
}
    80003f2a:	bfe1                	j	80003f02 <pipeclose+0x46>

0000000080003f2c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f2c:	711d                	addi	sp,sp,-96
    80003f2e:	ec86                	sd	ra,88(sp)
    80003f30:	e8a2                	sd	s0,80(sp)
    80003f32:	e4a6                	sd	s1,72(sp)
    80003f34:	e0ca                	sd	s2,64(sp)
    80003f36:	fc4e                	sd	s3,56(sp)
    80003f38:	f852                	sd	s4,48(sp)
    80003f3a:	f456                	sd	s5,40(sp)
    80003f3c:	f05a                	sd	s6,32(sp)
    80003f3e:	ec5e                	sd	s7,24(sp)
    80003f40:	e862                	sd	s8,16(sp)
    80003f42:	1080                	addi	s0,sp,96
    80003f44:	84aa                	mv	s1,a0
    80003f46:	8aae                	mv	s5,a1
    80003f48:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	eee080e7          	jalr	-274(ra) # 80000e38 <myproc>
    80003f52:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f54:	8526                	mv	a0,s1
    80003f56:	00002097          	auipc	ra,0x2
    80003f5a:	5d4080e7          	jalr	1492(ra) # 8000652a <acquire>
  while(i < n){
    80003f5e:	0b405663          	blez	s4,8000400a <pipewrite+0xde>
  int i = 0;
    80003f62:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f64:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f66:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f6a:	21c48b93          	addi	s7,s1,540
    80003f6e:	a089                	j	80003fb0 <pipewrite+0x84>
      release(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	66c080e7          	jalr	1644(ra) # 800065de <release>
      return -1;
    80003f7a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	60e6                	ld	ra,88(sp)
    80003f80:	6446                	ld	s0,80(sp)
    80003f82:	64a6                	ld	s1,72(sp)
    80003f84:	6906                	ld	s2,64(sp)
    80003f86:	79e2                	ld	s3,56(sp)
    80003f88:	7a42                	ld	s4,48(sp)
    80003f8a:	7aa2                	ld	s5,40(sp)
    80003f8c:	7b02                	ld	s6,32(sp)
    80003f8e:	6be2                	ld	s7,24(sp)
    80003f90:	6c42                	ld	s8,16(sp)
    80003f92:	6125                	addi	sp,sp,96
    80003f94:	8082                	ret
      wakeup(&pi->nread);
    80003f96:	8562                	mv	a0,s8
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	5ac080e7          	jalr	1452(ra) # 80001544 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fa0:	85a6                	mv	a1,s1
    80003fa2:	855e                	mv	a0,s7
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	53c080e7          	jalr	1340(ra) # 800014e0 <sleep>
  while(i < n){
    80003fac:	07495063          	bge	s2,s4,8000400c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fb0:	2204a783          	lw	a5,544(s1)
    80003fb4:	dfd5                	beqz	a5,80003f70 <pipewrite+0x44>
    80003fb6:	854e                	mv	a0,s3
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	7d0080e7          	jalr	2000(ra) # 80001788 <killed>
    80003fc0:	f945                	bnez	a0,80003f70 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc2:	2184a783          	lw	a5,536(s1)
    80003fc6:	21c4a703          	lw	a4,540(s1)
    80003fca:	2007879b          	addiw	a5,a5,512
    80003fce:	fcf704e3          	beq	a4,a5,80003f96 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd2:	4685                	li	a3,1
    80003fd4:	01590633          	add	a2,s2,s5
    80003fd8:	faf40593          	addi	a1,s0,-81
    80003fdc:	0509b503          	ld	a0,80(s3)
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	ba0080e7          	jalr	-1120(ra) # 80000b80 <copyin>
    80003fe8:	03650263          	beq	a0,s6,8000400c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fec:	21c4a783          	lw	a5,540(s1)
    80003ff0:	0017871b          	addiw	a4,a5,1
    80003ff4:	20e4ae23          	sw	a4,540(s1)
    80003ff8:	1ff7f793          	andi	a5,a5,511
    80003ffc:	97a6                	add	a5,a5,s1
    80003ffe:	faf44703          	lbu	a4,-81(s0)
    80004002:	00e78c23          	sb	a4,24(a5)
      i++;
    80004006:	2905                	addiw	s2,s2,1
    80004008:	b755                	j	80003fac <pipewrite+0x80>
  int i = 0;
    8000400a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000400c:	21848513          	addi	a0,s1,536
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	534080e7          	jalr	1332(ra) # 80001544 <wakeup>
  release(&pi->lock);
    80004018:	8526                	mv	a0,s1
    8000401a:	00002097          	auipc	ra,0x2
    8000401e:	5c4080e7          	jalr	1476(ra) # 800065de <release>
  return i;
    80004022:	bfa9                	j	80003f7c <pipewrite+0x50>

0000000080004024 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004024:	715d                	addi	sp,sp,-80
    80004026:	e486                	sd	ra,72(sp)
    80004028:	e0a2                	sd	s0,64(sp)
    8000402a:	fc26                	sd	s1,56(sp)
    8000402c:	f84a                	sd	s2,48(sp)
    8000402e:	f44e                	sd	s3,40(sp)
    80004030:	f052                	sd	s4,32(sp)
    80004032:	ec56                	sd	s5,24(sp)
    80004034:	e85a                	sd	s6,16(sp)
    80004036:	0880                	addi	s0,sp,80
    80004038:	84aa                	mv	s1,a0
    8000403a:	892e                	mv	s2,a1
    8000403c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	dfa080e7          	jalr	-518(ra) # 80000e38 <myproc>
    80004046:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004048:	8526                	mv	a0,s1
    8000404a:	00002097          	auipc	ra,0x2
    8000404e:	4e0080e7          	jalr	1248(ra) # 8000652a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004052:	2184a703          	lw	a4,536(s1)
    80004056:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000405a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000405e:	02f71763          	bne	a4,a5,8000408c <piperead+0x68>
    80004062:	2244a783          	lw	a5,548(s1)
    80004066:	c39d                	beqz	a5,8000408c <piperead+0x68>
    if(killed(pr)){
    80004068:	8552                	mv	a0,s4
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	71e080e7          	jalr	1822(ra) # 80001788 <killed>
    80004072:	e941                	bnez	a0,80004102 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004074:	85a6                	mv	a1,s1
    80004076:	854e                	mv	a0,s3
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	468080e7          	jalr	1128(ra) # 800014e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004080:	2184a703          	lw	a4,536(s1)
    80004084:	21c4a783          	lw	a5,540(s1)
    80004088:	fcf70de3          	beq	a4,a5,80004062 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000408e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004090:	05505363          	blez	s5,800040d6 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004094:	2184a783          	lw	a5,536(s1)
    80004098:	21c4a703          	lw	a4,540(s1)
    8000409c:	02f70d63          	beq	a4,a5,800040d6 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040a0:	0017871b          	addiw	a4,a5,1
    800040a4:	20e4ac23          	sw	a4,536(s1)
    800040a8:	1ff7f793          	andi	a5,a5,511
    800040ac:	97a6                	add	a5,a5,s1
    800040ae:	0187c783          	lbu	a5,24(a5)
    800040b2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040b6:	4685                	li	a3,1
    800040b8:	fbf40613          	addi	a2,s0,-65
    800040bc:	85ca                	mv	a1,s2
    800040be:	050a3503          	ld	a0,80(s4)
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	a32080e7          	jalr	-1486(ra) # 80000af4 <copyout>
    800040ca:	01650663          	beq	a0,s6,800040d6 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ce:	2985                	addiw	s3,s3,1
    800040d0:	0905                	addi	s2,s2,1
    800040d2:	fd3a91e3          	bne	s5,s3,80004094 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040d6:	21c48513          	addi	a0,s1,540
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	46a080e7          	jalr	1130(ra) # 80001544 <wakeup>
  release(&pi->lock);
    800040e2:	8526                	mv	a0,s1
    800040e4:	00002097          	auipc	ra,0x2
    800040e8:	4fa080e7          	jalr	1274(ra) # 800065de <release>
  return i;
}
    800040ec:	854e                	mv	a0,s3
    800040ee:	60a6                	ld	ra,72(sp)
    800040f0:	6406                	ld	s0,64(sp)
    800040f2:	74e2                	ld	s1,56(sp)
    800040f4:	7942                	ld	s2,48(sp)
    800040f6:	79a2                	ld	s3,40(sp)
    800040f8:	7a02                	ld	s4,32(sp)
    800040fa:	6ae2                	ld	s5,24(sp)
    800040fc:	6b42                	ld	s6,16(sp)
    800040fe:	6161                	addi	sp,sp,80
    80004100:	8082                	ret
      release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	4da080e7          	jalr	1242(ra) # 800065de <release>
      return -1;
    8000410c:	59fd                	li	s3,-1
    8000410e:	bff9                	j	800040ec <piperead+0xc8>

0000000080004110 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004110:	1141                	addi	sp,sp,-16
    80004112:	e422                	sd	s0,8(sp)
    80004114:	0800                	addi	s0,sp,16
    80004116:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004118:	8905                	andi	a0,a0,1
    8000411a:	c111                	beqz	a0,8000411e <flags2perm+0xe>
      perm = PTE_X;
    8000411c:	4521                	li	a0,8
    if(flags & 0x2)
    8000411e:	8b89                	andi	a5,a5,2
    80004120:	c399                	beqz	a5,80004126 <flags2perm+0x16>
      perm |= PTE_W;
    80004122:	00456513          	ori	a0,a0,4
    return perm;
}
    80004126:	6422                	ld	s0,8(sp)
    80004128:	0141                	addi	sp,sp,16
    8000412a:	8082                	ret

000000008000412c <exec>:

int
exec(char *path, char **argv)
{
    8000412c:	de010113          	addi	sp,sp,-544
    80004130:	20113c23          	sd	ra,536(sp)
    80004134:	20813823          	sd	s0,528(sp)
    80004138:	20913423          	sd	s1,520(sp)
    8000413c:	21213023          	sd	s2,512(sp)
    80004140:	ffce                	sd	s3,504(sp)
    80004142:	fbd2                	sd	s4,496(sp)
    80004144:	f7d6                	sd	s5,488(sp)
    80004146:	f3da                	sd	s6,480(sp)
    80004148:	efde                	sd	s7,472(sp)
    8000414a:	ebe2                	sd	s8,464(sp)
    8000414c:	e7e6                	sd	s9,456(sp)
    8000414e:	e3ea                	sd	s10,448(sp)
    80004150:	ff6e                	sd	s11,440(sp)
    80004152:	1400                	addi	s0,sp,544
    80004154:	892a                	mv	s2,a0
    80004156:	dea43423          	sd	a0,-536(s0)
    8000415a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	cda080e7          	jalr	-806(ra) # 80000e38 <myproc>
    80004166:	84aa                	mv	s1,a0

  begin_op();
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	424080e7          	jalr	1060(ra) # 8000358c <begin_op>

  if((ip = namei(path)) == 0){
    80004170:	854a                	mv	a0,s2
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	1fa080e7          	jalr	506(ra) # 8000336c <namei>
    8000417a:	c93d                	beqz	a0,800041f0 <exec+0xc4>
    8000417c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	a48080e7          	jalr	-1464(ra) # 80002bc6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004186:	04000713          	li	a4,64
    8000418a:	4681                	li	a3,0
    8000418c:	e5040613          	addi	a2,s0,-432
    80004190:	4581                	li	a1,0
    80004192:	8556                	mv	a0,s5
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	ce6080e7          	jalr	-794(ra) # 80002e7a <readi>
    8000419c:	04000793          	li	a5,64
    800041a0:	00f51a63          	bne	a0,a5,800041b4 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041a4:	e5042703          	lw	a4,-432(s0)
    800041a8:	464c47b7          	lui	a5,0x464c4
    800041ac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041b0:	04f70663          	beq	a4,a5,800041fc <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041b4:	8556                	mv	a0,s5
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	c72080e7          	jalr	-910(ra) # 80002e28 <iunlockput>
    end_op();
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	44e080e7          	jalr	1102(ra) # 8000360c <end_op>
  }
  return -1;
    800041c6:	557d                	li	a0,-1
}
    800041c8:	21813083          	ld	ra,536(sp)
    800041cc:	21013403          	ld	s0,528(sp)
    800041d0:	20813483          	ld	s1,520(sp)
    800041d4:	20013903          	ld	s2,512(sp)
    800041d8:	79fe                	ld	s3,504(sp)
    800041da:	7a5e                	ld	s4,496(sp)
    800041dc:	7abe                	ld	s5,488(sp)
    800041de:	7b1e                	ld	s6,480(sp)
    800041e0:	6bfe                	ld	s7,472(sp)
    800041e2:	6c5e                	ld	s8,464(sp)
    800041e4:	6cbe                	ld	s9,456(sp)
    800041e6:	6d1e                	ld	s10,448(sp)
    800041e8:	7dfa                	ld	s11,440(sp)
    800041ea:	22010113          	addi	sp,sp,544
    800041ee:	8082                	ret
    end_op();
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	41c080e7          	jalr	1052(ra) # 8000360c <end_op>
    return -1;
    800041f8:	557d                	li	a0,-1
    800041fa:	b7f9                	j	800041c8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041fc:	8526                	mv	a0,s1
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	cfe080e7          	jalr	-770(ra) # 80000efc <proc_pagetable>
    80004206:	8b2a                	mv	s6,a0
    80004208:	d555                	beqz	a0,800041b4 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420a:	e7042783          	lw	a5,-400(s0)
    8000420e:	e8845703          	lhu	a4,-376(s0)
    80004212:	c735                	beqz	a4,8000427e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004214:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004216:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000421a:	6a05                	lui	s4,0x1
    8000421c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004220:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004224:	6d85                	lui	s11,0x1
    80004226:	7d7d                	lui	s10,0xfffff
    80004228:	a481                	j	80004468 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000422a:	00004517          	auipc	a0,0x4
    8000422e:	41e50513          	addi	a0,a0,1054 # 80008648 <syscalls+0x298>
    80004232:	00002097          	auipc	ra,0x2
    80004236:	dbc080e7          	jalr	-580(ra) # 80005fee <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000423a:	874a                	mv	a4,s2
    8000423c:	009c86bb          	addw	a3,s9,s1
    80004240:	4581                	li	a1,0
    80004242:	8556                	mv	a0,s5
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	c36080e7          	jalr	-970(ra) # 80002e7a <readi>
    8000424c:	2501                	sext.w	a0,a0
    8000424e:	1aa91a63          	bne	s2,a0,80004402 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004252:	009d84bb          	addw	s1,s11,s1
    80004256:	013d09bb          	addw	s3,s10,s3
    8000425a:	1f74f763          	bgeu	s1,s7,80004448 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    8000425e:	02049593          	slli	a1,s1,0x20
    80004262:	9181                	srli	a1,a1,0x20
    80004264:	95e2                	add	a1,a1,s8
    80004266:	855a                	mv	a0,s6
    80004268:	ffffc097          	auipc	ra,0xffffc
    8000426c:	29a080e7          	jalr	666(ra) # 80000502 <walkaddr>
    80004270:	862a                	mv	a2,a0
    if(pa == 0)
    80004272:	dd45                	beqz	a0,8000422a <exec+0xfe>
      n = PGSIZE;
    80004274:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004276:	fd49f2e3          	bgeu	s3,s4,8000423a <exec+0x10e>
      n = sz - i;
    8000427a:	894e                	mv	s2,s3
    8000427c:	bf7d                	j	8000423a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427e:	4901                	li	s2,0
  iunlockput(ip);
    80004280:	8556                	mv	a0,s5
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	ba6080e7          	jalr	-1114(ra) # 80002e28 <iunlockput>
  end_op();
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	382080e7          	jalr	898(ra) # 8000360c <end_op>
  p = myproc();
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	ba6080e7          	jalr	-1114(ra) # 80000e38 <myproc>
    8000429a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000429c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042a0:	6785                	lui	a5,0x1
    800042a2:	17fd                	addi	a5,a5,-1
    800042a4:	993e                	add	s2,s2,a5
    800042a6:	77fd                	lui	a5,0xfffff
    800042a8:	00f977b3          	and	a5,s2,a5
    800042ac:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042b0:	4691                	li	a3,4
    800042b2:	6609                	lui	a2,0x2
    800042b4:	963e                	add	a2,a2,a5
    800042b6:	85be                	mv	a1,a5
    800042b8:	855a                	mv	a0,s6
    800042ba:	ffffc097          	auipc	ra,0xffffc
    800042be:	5ee080e7          	jalr	1518(ra) # 800008a8 <uvmalloc>
    800042c2:	8c2a                	mv	s8,a0
  ip = 0;
    800042c4:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042c6:	12050e63          	beqz	a0,80004402 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042ca:	75f9                	lui	a1,0xffffe
    800042cc:	95aa                	add	a1,a1,a0
    800042ce:	855a                	mv	a0,s6
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	7f2080e7          	jalr	2034(ra) # 80000ac2 <uvmclear>
  stackbase = sp - PGSIZE;
    800042d8:	7afd                	lui	s5,0xfffff
    800042da:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042dc:	df043783          	ld	a5,-528(s0)
    800042e0:	6388                	ld	a0,0(a5)
    800042e2:	c925                	beqz	a0,80004352 <exec+0x226>
    800042e4:	e9040993          	addi	s3,s0,-368
    800042e8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042ec:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042ee:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042f0:	ffffc097          	auipc	ra,0xffffc
    800042f4:	004080e7          	jalr	4(ra) # 800002f4 <strlen>
    800042f8:	0015079b          	addiw	a5,a0,1
    800042fc:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004300:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004304:	13596663          	bltu	s2,s5,80004430 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004308:	df043d83          	ld	s11,-528(s0)
    8000430c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004310:	8552                	mv	a0,s4
    80004312:	ffffc097          	auipc	ra,0xffffc
    80004316:	fe2080e7          	jalr	-30(ra) # 800002f4 <strlen>
    8000431a:	0015069b          	addiw	a3,a0,1
    8000431e:	8652                	mv	a2,s4
    80004320:	85ca                	mv	a1,s2
    80004322:	855a                	mv	a0,s6
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	7d0080e7          	jalr	2000(ra) # 80000af4 <copyout>
    8000432c:	10054663          	bltz	a0,80004438 <exec+0x30c>
    ustack[argc] = sp;
    80004330:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004334:	0485                	addi	s1,s1,1
    80004336:	008d8793          	addi	a5,s11,8
    8000433a:	def43823          	sd	a5,-528(s0)
    8000433e:	008db503          	ld	a0,8(s11)
    80004342:	c911                	beqz	a0,80004356 <exec+0x22a>
    if(argc >= MAXARG)
    80004344:	09a1                	addi	s3,s3,8
    80004346:	fb3c95e3          	bne	s9,s3,800042f0 <exec+0x1c4>
  sz = sz1;
    8000434a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000434e:	4a81                	li	s5,0
    80004350:	a84d                	j	80004402 <exec+0x2d6>
  sp = sz;
    80004352:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004354:	4481                	li	s1,0
  ustack[argc] = 0;
    80004356:	00349793          	slli	a5,s1,0x3
    8000435a:	f9040713          	addi	a4,s0,-112
    8000435e:	97ba                	add	a5,a5,a4
    80004360:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd1160>
  sp -= (argc+1) * sizeof(uint64);
    80004364:	00148693          	addi	a3,s1,1
    80004368:	068e                	slli	a3,a3,0x3
    8000436a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000436e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004372:	01597663          	bgeu	s2,s5,8000437e <exec+0x252>
  sz = sz1;
    80004376:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000437a:	4a81                	li	s5,0
    8000437c:	a059                	j	80004402 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000437e:	e9040613          	addi	a2,s0,-368
    80004382:	85ca                	mv	a1,s2
    80004384:	855a                	mv	a0,s6
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	76e080e7          	jalr	1902(ra) # 80000af4 <copyout>
    8000438e:	0a054963          	bltz	a0,80004440 <exec+0x314>
  p->trapframe->a1 = sp;
    80004392:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004396:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000439a:	de843783          	ld	a5,-536(s0)
    8000439e:	0007c703          	lbu	a4,0(a5)
    800043a2:	cf11                	beqz	a4,800043be <exec+0x292>
    800043a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043a6:	02f00693          	li	a3,47
    800043aa:	a039                	j	800043b8 <exec+0x28c>
      last = s+1;
    800043ac:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800043b0:	0785                	addi	a5,a5,1
    800043b2:	fff7c703          	lbu	a4,-1(a5)
    800043b6:	c701                	beqz	a4,800043be <exec+0x292>
    if(*s == '/')
    800043b8:	fed71ce3          	bne	a4,a3,800043b0 <exec+0x284>
    800043bc:	bfc5                	j	800043ac <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800043be:	4641                	li	a2,16
    800043c0:	de843583          	ld	a1,-536(s0)
    800043c4:	158b8513          	addi	a0,s7,344
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	efa080e7          	jalr	-262(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043d0:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043d4:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043d8:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043dc:	058bb783          	ld	a5,88(s7)
    800043e0:	e6843703          	ld	a4,-408(s0)
    800043e4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043e6:	058bb783          	ld	a5,88(s7)
    800043ea:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043ee:	85ea                	mv	a1,s10
    800043f0:	ffffd097          	auipc	ra,0xffffd
    800043f4:	ba8080e7          	jalr	-1112(ra) # 80000f98 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043f8:	0004851b          	sext.w	a0,s1
    800043fc:	b3f1                	j	800041c8 <exec+0x9c>
    800043fe:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004402:	df843583          	ld	a1,-520(s0)
    80004406:	855a                	mv	a0,s6
    80004408:	ffffd097          	auipc	ra,0xffffd
    8000440c:	b90080e7          	jalr	-1136(ra) # 80000f98 <proc_freepagetable>
  if(ip){
    80004410:	da0a92e3          	bnez	s5,800041b4 <exec+0x88>
  return -1;
    80004414:	557d                	li	a0,-1
    80004416:	bb4d                	j	800041c8 <exec+0x9c>
    80004418:	df243c23          	sd	s2,-520(s0)
    8000441c:	b7dd                	j	80004402 <exec+0x2d6>
    8000441e:	df243c23          	sd	s2,-520(s0)
    80004422:	b7c5                	j	80004402 <exec+0x2d6>
    80004424:	df243c23          	sd	s2,-520(s0)
    80004428:	bfe9                	j	80004402 <exec+0x2d6>
    8000442a:	df243c23          	sd	s2,-520(s0)
    8000442e:	bfd1                	j	80004402 <exec+0x2d6>
  sz = sz1;
    80004430:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004434:	4a81                	li	s5,0
    80004436:	b7f1                	j	80004402 <exec+0x2d6>
  sz = sz1;
    80004438:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000443c:	4a81                	li	s5,0
    8000443e:	b7d1                	j	80004402 <exec+0x2d6>
  sz = sz1;
    80004440:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004444:	4a81                	li	s5,0
    80004446:	bf75                	j	80004402 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004448:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000444c:	e0843783          	ld	a5,-504(s0)
    80004450:	0017869b          	addiw	a3,a5,1
    80004454:	e0d43423          	sd	a3,-504(s0)
    80004458:	e0043783          	ld	a5,-512(s0)
    8000445c:	0387879b          	addiw	a5,a5,56
    80004460:	e8845703          	lhu	a4,-376(s0)
    80004464:	e0e6dee3          	bge	a3,a4,80004280 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004468:	2781                	sext.w	a5,a5
    8000446a:	e0f43023          	sd	a5,-512(s0)
    8000446e:	03800713          	li	a4,56
    80004472:	86be                	mv	a3,a5
    80004474:	e1840613          	addi	a2,s0,-488
    80004478:	4581                	li	a1,0
    8000447a:	8556                	mv	a0,s5
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	9fe080e7          	jalr	-1538(ra) # 80002e7a <readi>
    80004484:	03800793          	li	a5,56
    80004488:	f6f51be3          	bne	a0,a5,800043fe <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    8000448c:	e1842783          	lw	a5,-488(s0)
    80004490:	4705                	li	a4,1
    80004492:	fae79de3          	bne	a5,a4,8000444c <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004496:	e4043483          	ld	s1,-448(s0)
    8000449a:	e3843783          	ld	a5,-456(s0)
    8000449e:	f6f4ede3          	bltu	s1,a5,80004418 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044a2:	e2843783          	ld	a5,-472(s0)
    800044a6:	94be                	add	s1,s1,a5
    800044a8:	f6f4ebe3          	bltu	s1,a5,8000441e <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800044ac:	de043703          	ld	a4,-544(s0)
    800044b0:	8ff9                	and	a5,a5,a4
    800044b2:	fbad                	bnez	a5,80004424 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044b4:	e1c42503          	lw	a0,-484(s0)
    800044b8:	00000097          	auipc	ra,0x0
    800044bc:	c58080e7          	jalr	-936(ra) # 80004110 <flags2perm>
    800044c0:	86aa                	mv	a3,a0
    800044c2:	8626                	mv	a2,s1
    800044c4:	85ca                	mv	a1,s2
    800044c6:	855a                	mv	a0,s6
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	3e0080e7          	jalr	992(ra) # 800008a8 <uvmalloc>
    800044d0:	dea43c23          	sd	a0,-520(s0)
    800044d4:	d939                	beqz	a0,8000442a <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044d6:	e2843c03          	ld	s8,-472(s0)
    800044da:	e2042c83          	lw	s9,-480(s0)
    800044de:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044e2:	f60b83e3          	beqz	s7,80004448 <exec+0x31c>
    800044e6:	89de                	mv	s3,s7
    800044e8:	4481                	li	s1,0
    800044ea:	bb95                	j	8000425e <exec+0x132>

00000000800044ec <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044ec:	7179                	addi	sp,sp,-48
    800044ee:	f406                	sd	ra,40(sp)
    800044f0:	f022                	sd	s0,32(sp)
    800044f2:	ec26                	sd	s1,24(sp)
    800044f4:	e84a                	sd	s2,16(sp)
    800044f6:	1800                	addi	s0,sp,48
    800044f8:	892e                	mv	s2,a1
    800044fa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044fc:	fdc40593          	addi	a1,s0,-36
    80004500:	ffffe097          	auipc	ra,0xffffe
    80004504:	b4a080e7          	jalr	-1206(ra) # 8000204a <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004508:	fdc42703          	lw	a4,-36(s0)
    8000450c:	47bd                	li	a5,15
    8000450e:	02e7eb63          	bltu	a5,a4,80004544 <argfd+0x58>
    80004512:	ffffd097          	auipc	ra,0xffffd
    80004516:	926080e7          	jalr	-1754(ra) # 80000e38 <myproc>
    8000451a:	fdc42703          	lw	a4,-36(s0)
    8000451e:	01a70793          	addi	a5,a4,26
    80004522:	078e                	slli	a5,a5,0x3
    80004524:	953e                	add	a0,a0,a5
    80004526:	611c                	ld	a5,0(a0)
    80004528:	c385                	beqz	a5,80004548 <argfd+0x5c>
    return -1;
  if (pfd)
    8000452a:	00090463          	beqz	s2,80004532 <argfd+0x46>
    *pfd = fd;
    8000452e:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004532:	4501                	li	a0,0
  if (pf)
    80004534:	c091                	beqz	s1,80004538 <argfd+0x4c>
    *pf = f;
    80004536:	e09c                	sd	a5,0(s1)
}
    80004538:	70a2                	ld	ra,40(sp)
    8000453a:	7402                	ld	s0,32(sp)
    8000453c:	64e2                	ld	s1,24(sp)
    8000453e:	6942                	ld	s2,16(sp)
    80004540:	6145                	addi	sp,sp,48
    80004542:	8082                	ret
    return -1;
    80004544:	557d                	li	a0,-1
    80004546:	bfcd                	j	80004538 <argfd+0x4c>
    80004548:	557d                	li	a0,-1
    8000454a:	b7fd                	j	80004538 <argfd+0x4c>

000000008000454c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000454c:	1101                	addi	sp,sp,-32
    8000454e:	ec06                	sd	ra,24(sp)
    80004550:	e822                	sd	s0,16(sp)
    80004552:	e426                	sd	s1,8(sp)
    80004554:	1000                	addi	s0,sp,32
    80004556:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004558:	ffffd097          	auipc	ra,0xffffd
    8000455c:	8e0080e7          	jalr	-1824(ra) # 80000e38 <myproc>
    80004560:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    80004562:	0d050793          	addi	a5,a0,208
    80004566:	4501                	li	a0,0
    80004568:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    8000456a:	6398                	ld	a4,0(a5)
    8000456c:	cb19                	beqz	a4,80004582 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    8000456e:	2505                	addiw	a0,a0,1
    80004570:	07a1                	addi	a5,a5,8
    80004572:	fed51ce3          	bne	a0,a3,8000456a <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004576:	557d                	li	a0,-1
}
    80004578:	60e2                	ld	ra,24(sp)
    8000457a:	6442                	ld	s0,16(sp)
    8000457c:	64a2                	ld	s1,8(sp)
    8000457e:	6105                	addi	sp,sp,32
    80004580:	8082                	ret
      p->ofile[fd] = f;
    80004582:	01a50793          	addi	a5,a0,26
    80004586:	078e                	slli	a5,a5,0x3
    80004588:	963e                	add	a2,a2,a5
    8000458a:	e204                	sd	s1,0(a2)
      return fd;
    8000458c:	b7f5                	j	80004578 <fdalloc+0x2c>

000000008000458e <create>:
  return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    8000458e:	715d                	addi	sp,sp,-80
    80004590:	e486                	sd	ra,72(sp)
    80004592:	e0a2                	sd	s0,64(sp)
    80004594:	fc26                	sd	s1,56(sp)
    80004596:	f84a                	sd	s2,48(sp)
    80004598:	f44e                	sd	s3,40(sp)
    8000459a:	f052                	sd	s4,32(sp)
    8000459c:	ec56                	sd	s5,24(sp)
    8000459e:	e85a                	sd	s6,16(sp)
    800045a0:	0880                	addi	s0,sp,80
    800045a2:	8b2e                	mv	s6,a1
    800045a4:	89b2                	mv	s3,a2
    800045a6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800045a8:	fb040593          	addi	a1,s0,-80
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	dde080e7          	jalr	-546(ra) # 8000338a <nameiparent>
    800045b4:	84aa                	mv	s1,a0
    800045b6:	14050f63          	beqz	a0,80004714 <create+0x186>
    return 0;

  ilock(dp);
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	60c080e7          	jalr	1548(ra) # 80002bc6 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    800045c2:	4601                	li	a2,0
    800045c4:	fb040593          	addi	a1,s0,-80
    800045c8:	8526                	mv	a0,s1
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	ae0080e7          	jalr	-1312(ra) # 800030aa <dirlookup>
    800045d2:	8aaa                	mv	s5,a0
    800045d4:	c931                	beqz	a0,80004628 <create+0x9a>
  {
    iunlockput(dp);
    800045d6:	8526                	mv	a0,s1
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	850080e7          	jalr	-1968(ra) # 80002e28 <iunlockput>
    ilock(ip);
    800045e0:	8556                	mv	a0,s5
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	5e4080e7          	jalr	1508(ra) # 80002bc6 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045ea:	000b059b          	sext.w	a1,s6
    800045ee:	4789                	li	a5,2
    800045f0:	02f59563          	bne	a1,a5,8000461a <create+0x8c>
    800045f4:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd12a4>
    800045f8:	37f9                	addiw	a5,a5,-2
    800045fa:	17c2                	slli	a5,a5,0x30
    800045fc:	93c1                	srli	a5,a5,0x30
    800045fe:	4705                	li	a4,1
    80004600:	00f76d63          	bltu	a4,a5,8000461a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004604:	8556                	mv	a0,s5
    80004606:	60a6                	ld	ra,72(sp)
    80004608:	6406                	ld	s0,64(sp)
    8000460a:	74e2                	ld	s1,56(sp)
    8000460c:	7942                	ld	s2,48(sp)
    8000460e:	79a2                	ld	s3,40(sp)
    80004610:	7a02                	ld	s4,32(sp)
    80004612:	6ae2                	ld	s5,24(sp)
    80004614:	6b42                	ld	s6,16(sp)
    80004616:	6161                	addi	sp,sp,80
    80004618:	8082                	ret
    iunlockput(ip);
    8000461a:	8556                	mv	a0,s5
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	80c080e7          	jalr	-2036(ra) # 80002e28 <iunlockput>
    return 0;
    80004624:	4a81                	li	s5,0
    80004626:	bff9                	j	80004604 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004628:	85da                	mv	a1,s6
    8000462a:	4088                	lw	a0,0(s1)
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	3fe080e7          	jalr	1022(ra) # 80002a2a <ialloc>
    80004634:	8a2a                	mv	s4,a0
    80004636:	c539                	beqz	a0,80004684 <create+0xf6>
  ilock(ip);
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	58e080e7          	jalr	1422(ra) # 80002bc6 <ilock>
  ip->major = major;
    80004640:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004644:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004648:	4905                	li	s2,1
    8000464a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000464e:	8552                	mv	a0,s4
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	4ac080e7          	jalr	1196(ra) # 80002afc <iupdate>
  if (type == T_DIR)
    80004658:	000b059b          	sext.w	a1,s6
    8000465c:	03258b63          	beq	a1,s2,80004692 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    80004660:	004a2603          	lw	a2,4(s4)
    80004664:	fb040593          	addi	a1,s0,-80
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	c50080e7          	jalr	-944(ra) # 800032ba <dirlink>
    80004672:	06054f63          	bltz	a0,800046f0 <create+0x162>
  iunlockput(dp);
    80004676:	8526                	mv	a0,s1
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	7b0080e7          	jalr	1968(ra) # 80002e28 <iunlockput>
  return ip;
    80004680:	8ad2                	mv	s5,s4
    80004682:	b749                	j	80004604 <create+0x76>
    iunlockput(dp);
    80004684:	8526                	mv	a0,s1
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	7a2080e7          	jalr	1954(ra) # 80002e28 <iunlockput>
    return 0;
    8000468e:	8ad2                	mv	s5,s4
    80004690:	bf95                	j	80004604 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004692:	004a2603          	lw	a2,4(s4)
    80004696:	00004597          	auipc	a1,0x4
    8000469a:	fd258593          	addi	a1,a1,-46 # 80008668 <syscalls+0x2b8>
    8000469e:	8552                	mv	a0,s4
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	c1a080e7          	jalr	-998(ra) # 800032ba <dirlink>
    800046a8:	04054463          	bltz	a0,800046f0 <create+0x162>
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	00004597          	auipc	a1,0x4
    800046b2:	fc258593          	addi	a1,a1,-62 # 80008670 <syscalls+0x2c0>
    800046b6:	8552                	mv	a0,s4
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	c02080e7          	jalr	-1022(ra) # 800032ba <dirlink>
    800046c0:	02054863          	bltz	a0,800046f0 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    800046c4:	004a2603          	lw	a2,4(s4)
    800046c8:	fb040593          	addi	a1,s0,-80
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	bec080e7          	jalr	-1044(ra) # 800032ba <dirlink>
    800046d6:	00054d63          	bltz	a0,800046f0 <create+0x162>
    dp->nlink++; // for ".."
    800046da:	04a4d783          	lhu	a5,74(s1)
    800046de:	2785                	addiw	a5,a5,1
    800046e0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046e4:	8526                	mv	a0,s1
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	416080e7          	jalr	1046(ra) # 80002afc <iupdate>
    800046ee:	b761                	j	80004676 <create+0xe8>
  ip->nlink = 0;
    800046f0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046f4:	8552                	mv	a0,s4
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	406080e7          	jalr	1030(ra) # 80002afc <iupdate>
  iunlockput(ip);
    800046fe:	8552                	mv	a0,s4
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	728080e7          	jalr	1832(ra) # 80002e28 <iunlockput>
  iunlockput(dp);
    80004708:	8526                	mv	a0,s1
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	71e080e7          	jalr	1822(ra) # 80002e28 <iunlockput>
  return 0;
    80004712:	bdcd                	j	80004604 <create+0x76>
    return 0;
    80004714:	8aaa                	mv	s5,a0
    80004716:	b5fd                	j	80004604 <create+0x76>

0000000080004718 <sys_dup>:
{
    80004718:	7179                	addi	sp,sp,-48
    8000471a:	f406                	sd	ra,40(sp)
    8000471c:	f022                	sd	s0,32(sp)
    8000471e:	ec26                	sd	s1,24(sp)
    80004720:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004722:	fd840613          	addi	a2,s0,-40
    80004726:	4581                	li	a1,0
    80004728:	4501                	li	a0,0
    8000472a:	00000097          	auipc	ra,0x0
    8000472e:	dc2080e7          	jalr	-574(ra) # 800044ec <argfd>
    return -1;
    80004732:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004734:	02054363          	bltz	a0,8000475a <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80004738:	fd843503          	ld	a0,-40(s0)
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	e10080e7          	jalr	-496(ra) # 8000454c <fdalloc>
    80004744:	84aa                	mv	s1,a0
    return -1;
    80004746:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004748:	00054963          	bltz	a0,8000475a <sys_dup+0x42>
  filedup(f);
    8000474c:	fd843503          	ld	a0,-40(s0)
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	2b6080e7          	jalr	694(ra) # 80003a06 <filedup>
  return fd;
    80004758:	87a6                	mv	a5,s1
}
    8000475a:	853e                	mv	a0,a5
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	64e2                	ld	s1,24(sp)
    80004762:	6145                	addi	sp,sp,48
    80004764:	8082                	ret

0000000080004766 <sys_read>:
{
    80004766:	7179                	addi	sp,sp,-48
    80004768:	f406                	sd	ra,40(sp)
    8000476a:	f022                	sd	s0,32(sp)
    8000476c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000476e:	fd840593          	addi	a1,s0,-40
    80004772:	4505                	li	a0,1
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	8f6080e7          	jalr	-1802(ra) # 8000206a <argaddr>
  argint(2, &n);
    8000477c:	fe440593          	addi	a1,s0,-28
    80004780:	4509                	li	a0,2
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	8c8080e7          	jalr	-1848(ra) # 8000204a <argint>
  if (argfd(0, 0, &f) < 0)
    8000478a:	fe840613          	addi	a2,s0,-24
    8000478e:	4581                	li	a1,0
    80004790:	4501                	li	a0,0
    80004792:	00000097          	auipc	ra,0x0
    80004796:	d5a080e7          	jalr	-678(ra) # 800044ec <argfd>
    8000479a:	87aa                	mv	a5,a0
    return -1;
    8000479c:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000479e:	0007cc63          	bltz	a5,800047b6 <sys_read+0x50>
  return fileread(f, p, n);
    800047a2:	fe442603          	lw	a2,-28(s0)
    800047a6:	fd843583          	ld	a1,-40(s0)
    800047aa:	fe843503          	ld	a0,-24(s0)
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	43e080e7          	jalr	1086(ra) # 80003bec <fileread>
}
    800047b6:	70a2                	ld	ra,40(sp)
    800047b8:	7402                	ld	s0,32(sp)
    800047ba:	6145                	addi	sp,sp,48
    800047bc:	8082                	ret

00000000800047be <sys_write>:
{
    800047be:	7179                	addi	sp,sp,-48
    800047c0:	f406                	sd	ra,40(sp)
    800047c2:	f022                	sd	s0,32(sp)
    800047c4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047c6:	fd840593          	addi	a1,s0,-40
    800047ca:	4505                	li	a0,1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	89e080e7          	jalr	-1890(ra) # 8000206a <argaddr>
  argint(2, &n);
    800047d4:	fe440593          	addi	a1,s0,-28
    800047d8:	4509                	li	a0,2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	870080e7          	jalr	-1936(ra) # 8000204a <argint>
  if (argfd(0, 0, &f) < 0)
    800047e2:	fe840613          	addi	a2,s0,-24
    800047e6:	4581                	li	a1,0
    800047e8:	4501                	li	a0,0
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	d02080e7          	jalr	-766(ra) # 800044ec <argfd>
    800047f2:	87aa                	mv	a5,a0
    return -1;
    800047f4:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047f6:	0007cc63          	bltz	a5,8000480e <sys_write+0x50>
  return filewrite(f, p, n);
    800047fa:	fe442603          	lw	a2,-28(s0)
    800047fe:	fd843583          	ld	a1,-40(s0)
    80004802:	fe843503          	ld	a0,-24(s0)
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	4a8080e7          	jalr	1192(ra) # 80003cae <filewrite>
}
    8000480e:	70a2                	ld	ra,40(sp)
    80004810:	7402                	ld	s0,32(sp)
    80004812:	6145                	addi	sp,sp,48
    80004814:	8082                	ret

0000000080004816 <sys_close>:
{
    80004816:	1101                	addi	sp,sp,-32
    80004818:	ec06                	sd	ra,24(sp)
    8000481a:	e822                	sd	s0,16(sp)
    8000481c:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000481e:	fe040613          	addi	a2,s0,-32
    80004822:	fec40593          	addi	a1,s0,-20
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	cc4080e7          	jalr	-828(ra) # 800044ec <argfd>
    return -1;
    80004830:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004832:	02054463          	bltz	a0,8000485a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	602080e7          	jalr	1538(ra) # 80000e38 <myproc>
    8000483e:	fec42783          	lw	a5,-20(s0)
    80004842:	07e9                	addi	a5,a5,26
    80004844:	078e                	slli	a5,a5,0x3
    80004846:	97aa                	add	a5,a5,a0
    80004848:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000484c:	fe043503          	ld	a0,-32(s0)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	208080e7          	jalr	520(ra) # 80003a58 <fileclose>
  return 0;
    80004858:	4781                	li	a5,0
}
    8000485a:	853e                	mv	a0,a5
    8000485c:	60e2                	ld	ra,24(sp)
    8000485e:	6442                	ld	s0,16(sp)
    80004860:	6105                	addi	sp,sp,32
    80004862:	8082                	ret

0000000080004864 <sys_fstat>:
{
    80004864:	1101                	addi	sp,sp,-32
    80004866:	ec06                	sd	ra,24(sp)
    80004868:	e822                	sd	s0,16(sp)
    8000486a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000486c:	fe040593          	addi	a1,s0,-32
    80004870:	4505                	li	a0,1
    80004872:	ffffd097          	auipc	ra,0xffffd
    80004876:	7f8080e7          	jalr	2040(ra) # 8000206a <argaddr>
  if (argfd(0, 0, &f) < 0)
    8000487a:	fe840613          	addi	a2,s0,-24
    8000487e:	4581                	li	a1,0
    80004880:	4501                	li	a0,0
    80004882:	00000097          	auipc	ra,0x0
    80004886:	c6a080e7          	jalr	-918(ra) # 800044ec <argfd>
    8000488a:	87aa                	mv	a5,a0
    return -1;
    8000488c:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000488e:	0007ca63          	bltz	a5,800048a2 <sys_fstat+0x3e>
  return filestat(f, st);
    80004892:	fe043583          	ld	a1,-32(s0)
    80004896:	fe843503          	ld	a0,-24(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	286080e7          	jalr	646(ra) # 80003b20 <filestat>
}
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_link>:
{
    800048aa:	7169                	addi	sp,sp,-304
    800048ac:	f606                	sd	ra,296(sp)
    800048ae:	f222                	sd	s0,288(sp)
    800048b0:	ee26                	sd	s1,280(sp)
    800048b2:	ea4a                	sd	s2,272(sp)
    800048b4:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b6:	08000613          	li	a2,128
    800048ba:	ed040593          	addi	a1,s0,-304
    800048be:	4501                	li	a0,0
    800048c0:	ffffd097          	auipc	ra,0xffffd
    800048c4:	7ca080e7          	jalr	1994(ra) # 8000208a <argstr>
    return -1;
    800048c8:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ca:	10054e63          	bltz	a0,800049e6 <sys_link+0x13c>
    800048ce:	08000613          	li	a2,128
    800048d2:	f5040593          	addi	a1,s0,-176
    800048d6:	4505                	li	a0,1
    800048d8:	ffffd097          	auipc	ra,0xffffd
    800048dc:	7b2080e7          	jalr	1970(ra) # 8000208a <argstr>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e2:	10054263          	bltz	a0,800049e6 <sys_link+0x13c>
  begin_op();
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	ca6080e7          	jalr	-858(ra) # 8000358c <begin_op>
  if ((ip = namei(old)) == 0)
    800048ee:	ed040513          	addi	a0,s0,-304
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	a7a080e7          	jalr	-1414(ra) # 8000336c <namei>
    800048fa:	84aa                	mv	s1,a0
    800048fc:	c551                	beqz	a0,80004988 <sys_link+0xde>
  ilock(ip);
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	2c8080e7          	jalr	712(ra) # 80002bc6 <ilock>
  if (ip->type == T_DIR)
    80004906:	04449703          	lh	a4,68(s1)
    8000490a:	4785                	li	a5,1
    8000490c:	08f70463          	beq	a4,a5,80004994 <sys_link+0xea>
  ip->nlink++;
    80004910:	04a4d783          	lhu	a5,74(s1)
    80004914:	2785                	addiw	a5,a5,1
    80004916:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	1e0080e7          	jalr	480(ra) # 80002afc <iupdate>
  iunlock(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	362080e7          	jalr	866(ra) # 80002c88 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000492e:	fd040593          	addi	a1,s0,-48
    80004932:	f5040513          	addi	a0,s0,-176
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	a54080e7          	jalr	-1452(ra) # 8000338a <nameiparent>
    8000493e:	892a                	mv	s2,a0
    80004940:	c935                	beqz	a0,800049b4 <sys_link+0x10a>
  ilock(dp);
    80004942:	ffffe097          	auipc	ra,0xffffe
    80004946:	284080e7          	jalr	644(ra) # 80002bc6 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    8000494a:	00092703          	lw	a4,0(s2)
    8000494e:	409c                	lw	a5,0(s1)
    80004950:	04f71d63          	bne	a4,a5,800049aa <sys_link+0x100>
    80004954:	40d0                	lw	a2,4(s1)
    80004956:	fd040593          	addi	a1,s0,-48
    8000495a:	854a                	mv	a0,s2
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	95e080e7          	jalr	-1698(ra) # 800032ba <dirlink>
    80004964:	04054363          	bltz	a0,800049aa <sys_link+0x100>
  iunlockput(dp);
    80004968:	854a                	mv	a0,s2
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	4be080e7          	jalr	1214(ra) # 80002e28 <iunlockput>
  iput(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	40c080e7          	jalr	1036(ra) # 80002d80 <iput>
  end_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	c90080e7          	jalr	-880(ra) # 8000360c <end_op>
  return 0;
    80004984:	4781                	li	a5,0
    80004986:	a085                	j	800049e6 <sys_link+0x13c>
    end_op();
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	c84080e7          	jalr	-892(ra) # 8000360c <end_op>
    return -1;
    80004990:	57fd                	li	a5,-1
    80004992:	a891                	j	800049e6 <sys_link+0x13c>
    iunlockput(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	492080e7          	jalr	1170(ra) # 80002e28 <iunlockput>
    end_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	c6e080e7          	jalr	-914(ra) # 8000360c <end_op>
    return -1;
    800049a6:	57fd                	li	a5,-1
    800049a8:	a83d                	j	800049e6 <sys_link+0x13c>
    iunlockput(dp);
    800049aa:	854a                	mv	a0,s2
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	47c080e7          	jalr	1148(ra) # 80002e28 <iunlockput>
  ilock(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	210080e7          	jalr	528(ra) # 80002bc6 <ilock>
  ip->nlink--;
    800049be:	04a4d783          	lhu	a5,74(s1)
    800049c2:	37fd                	addiw	a5,a5,-1
    800049c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049c8:	8526                	mv	a0,s1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	132080e7          	jalr	306(ra) # 80002afc <iupdate>
  iunlockput(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	454080e7          	jalr	1108(ra) # 80002e28 <iunlockput>
  end_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	c30080e7          	jalr	-976(ra) # 8000360c <end_op>
  return -1;
    800049e4:	57fd                	li	a5,-1
}
    800049e6:	853e                	mv	a0,a5
    800049e8:	70b2                	ld	ra,296(sp)
    800049ea:	7412                	ld	s0,288(sp)
    800049ec:	64f2                	ld	s1,280(sp)
    800049ee:	6952                	ld	s2,272(sp)
    800049f0:	6155                	addi	sp,sp,304
    800049f2:	8082                	ret

00000000800049f4 <sys_unlink>:
{
    800049f4:	7151                	addi	sp,sp,-240
    800049f6:	f586                	sd	ra,232(sp)
    800049f8:	f1a2                	sd	s0,224(sp)
    800049fa:	eda6                	sd	s1,216(sp)
    800049fc:	e9ca                	sd	s2,208(sp)
    800049fe:	e5ce                	sd	s3,200(sp)
    80004a00:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004a02:	08000613          	li	a2,128
    80004a06:	f3040593          	addi	a1,s0,-208
    80004a0a:	4501                	li	a0,0
    80004a0c:	ffffd097          	auipc	ra,0xffffd
    80004a10:	67e080e7          	jalr	1662(ra) # 8000208a <argstr>
    80004a14:	18054163          	bltz	a0,80004b96 <sys_unlink+0x1a2>
  begin_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	b74080e7          	jalr	-1164(ra) # 8000358c <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004a20:	fb040593          	addi	a1,s0,-80
    80004a24:	f3040513          	addi	a0,s0,-208
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	962080e7          	jalr	-1694(ra) # 8000338a <nameiparent>
    80004a30:	84aa                	mv	s1,a0
    80004a32:	c979                	beqz	a0,80004b08 <sys_unlink+0x114>
  ilock(dp);
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	192080e7          	jalr	402(ra) # 80002bc6 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a3c:	00004597          	auipc	a1,0x4
    80004a40:	c2c58593          	addi	a1,a1,-980 # 80008668 <syscalls+0x2b8>
    80004a44:	fb040513          	addi	a0,s0,-80
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	648080e7          	jalr	1608(ra) # 80003090 <namecmp>
    80004a50:	14050a63          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
    80004a54:	00004597          	auipc	a1,0x4
    80004a58:	c1c58593          	addi	a1,a1,-996 # 80008670 <syscalls+0x2c0>
    80004a5c:	fb040513          	addi	a0,s0,-80
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	630080e7          	jalr	1584(ra) # 80003090 <namecmp>
    80004a68:	12050e63          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a6c:	f2c40613          	addi	a2,s0,-212
    80004a70:	fb040593          	addi	a1,s0,-80
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	634080e7          	jalr	1588(ra) # 800030aa <dirlookup>
    80004a7e:	892a                	mv	s2,a0
    80004a80:	12050263          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
  ilock(ip);
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	142080e7          	jalr	322(ra) # 80002bc6 <ilock>
  if (ip->nlink < 1)
    80004a8c:	04a91783          	lh	a5,74(s2)
    80004a90:	08f05263          	blez	a5,80004b14 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004a94:	04491703          	lh	a4,68(s2)
    80004a98:	4785                	li	a5,1
    80004a9a:	08f70563          	beq	a4,a5,80004b24 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a9e:	4641                	li	a2,16
    80004aa0:	4581                	li	a1,0
    80004aa2:	fc040513          	addi	a0,s0,-64
    80004aa6:	ffffb097          	auipc	ra,0xffffb
    80004aaa:	6d2080e7          	jalr	1746(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aae:	4741                	li	a4,16
    80004ab0:	f2c42683          	lw	a3,-212(s0)
    80004ab4:	fc040613          	addi	a2,s0,-64
    80004ab8:	4581                	li	a1,0
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	4b6080e7          	jalr	1206(ra) # 80002f72 <writei>
    80004ac4:	47c1                	li	a5,16
    80004ac6:	0af51563          	bne	a0,a5,80004b70 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004aca:	04491703          	lh	a4,68(s2)
    80004ace:	4785                	li	a5,1
    80004ad0:	0af70863          	beq	a4,a5,80004b80 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	352080e7          	jalr	850(ra) # 80002e28 <iunlockput>
  ip->nlink--;
    80004ade:	04a95783          	lhu	a5,74(s2)
    80004ae2:	37fd                	addiw	a5,a5,-1
    80004ae4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	012080e7          	jalr	18(ra) # 80002afc <iupdate>
  iunlockput(ip);
    80004af2:	854a                	mv	a0,s2
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	334080e7          	jalr	820(ra) # 80002e28 <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	b10080e7          	jalr	-1264(ra) # 8000360c <end_op>
  return 0;
    80004b04:	4501                	li	a0,0
    80004b06:	a84d                	j	80004bb8 <sys_unlink+0x1c4>
    end_op();
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	b04080e7          	jalr	-1276(ra) # 8000360c <end_op>
    return -1;
    80004b10:	557d                	li	a0,-1
    80004b12:	a05d                	j	80004bb8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b14:	00004517          	auipc	a0,0x4
    80004b18:	b6450513          	addi	a0,a0,-1180 # 80008678 <syscalls+0x2c8>
    80004b1c:	00001097          	auipc	ra,0x1
    80004b20:	4d2080e7          	jalr	1234(ra) # 80005fee <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b24:	04c92703          	lw	a4,76(s2)
    80004b28:	02000793          	li	a5,32
    80004b2c:	f6e7f9e3          	bgeu	a5,a4,80004a9e <sys_unlink+0xaa>
    80004b30:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b34:	4741                	li	a4,16
    80004b36:	86ce                	mv	a3,s3
    80004b38:	f1840613          	addi	a2,s0,-232
    80004b3c:	4581                	li	a1,0
    80004b3e:	854a                	mv	a0,s2
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	33a080e7          	jalr	826(ra) # 80002e7a <readi>
    80004b48:	47c1                	li	a5,16
    80004b4a:	00f51b63          	bne	a0,a5,80004b60 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004b4e:	f1845783          	lhu	a5,-232(s0)
    80004b52:	e7a1                	bnez	a5,80004b9a <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b54:	29c1                	addiw	s3,s3,16
    80004b56:	04c92783          	lw	a5,76(s2)
    80004b5a:	fcf9ede3          	bltu	s3,a5,80004b34 <sys_unlink+0x140>
    80004b5e:	b781                	j	80004a9e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b60:	00004517          	auipc	a0,0x4
    80004b64:	b3050513          	addi	a0,a0,-1232 # 80008690 <syscalls+0x2e0>
    80004b68:	00001097          	auipc	ra,0x1
    80004b6c:	486080e7          	jalr	1158(ra) # 80005fee <panic>
    panic("unlink: writei");
    80004b70:	00004517          	auipc	a0,0x4
    80004b74:	b3850513          	addi	a0,a0,-1224 # 800086a8 <syscalls+0x2f8>
    80004b78:	00001097          	auipc	ra,0x1
    80004b7c:	476080e7          	jalr	1142(ra) # 80005fee <panic>
    dp->nlink--;
    80004b80:	04a4d783          	lhu	a5,74(s1)
    80004b84:	37fd                	addiw	a5,a5,-1
    80004b86:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	f70080e7          	jalr	-144(ra) # 80002afc <iupdate>
    80004b94:	b781                	j	80004ad4 <sys_unlink+0xe0>
    return -1;
    80004b96:	557d                	li	a0,-1
    80004b98:	a005                	j	80004bb8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b9a:	854a                	mv	a0,s2
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	28c080e7          	jalr	652(ra) # 80002e28 <iunlockput>
  iunlockput(dp);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	282080e7          	jalr	642(ra) # 80002e28 <iunlockput>
  end_op();
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	a5e080e7          	jalr	-1442(ra) # 8000360c <end_op>
  return -1;
    80004bb6:	557d                	li	a0,-1
}
    80004bb8:	70ae                	ld	ra,232(sp)
    80004bba:	740e                	ld	s0,224(sp)
    80004bbc:	64ee                	ld	s1,216(sp)
    80004bbe:	694e                	ld	s2,208(sp)
    80004bc0:	69ae                	ld	s3,200(sp)
    80004bc2:	616d                	addi	sp,sp,240
    80004bc4:	8082                	ret

0000000080004bc6 <sys_mmap>:
{
    80004bc6:	715d                	addi	sp,sp,-80
    80004bc8:	e486                	sd	ra,72(sp)
    80004bca:	e0a2                	sd	s0,64(sp)
    80004bcc:	fc26                	sd	s1,56(sp)
    80004bce:	f84a                	sd	s2,48(sp)
    80004bd0:	f44e                	sd	s3,40(sp)
    80004bd2:	f052                	sd	s4,32(sp)
    80004bd4:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004bd6:	ffffc097          	auipc	ra,0xffffc
    80004bda:	262080e7          	jalr	610(ra) # 80000e38 <myproc>
    80004bde:	892a                	mv	s2,a0
  argint(1, &length);
    80004be0:	fcc40593          	addi	a1,s0,-52
    80004be4:	4505                	li	a0,1
    80004be6:	ffffd097          	auipc	ra,0xffffd
    80004bea:	464080e7          	jalr	1124(ra) # 8000204a <argint>
  argint(2, &prot);
    80004bee:	fc840593          	addi	a1,s0,-56
    80004bf2:	4509                	li	a0,2
    80004bf4:	ffffd097          	auipc	ra,0xffffd
    80004bf8:	456080e7          	jalr	1110(ra) # 8000204a <argint>
  argint(3, &flags);
    80004bfc:	fc440593          	addi	a1,s0,-60
    80004c00:	450d                	li	a0,3
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	448080e7          	jalr	1096(ra) # 8000204a <argint>
  argfd(4, &fd, &mfile);
    80004c0a:	fb040613          	addi	a2,s0,-80
    80004c0e:	fc040593          	addi	a1,s0,-64
    80004c12:	4511                	li	a0,4
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	8d8080e7          	jalr	-1832(ra) # 800044ec <argfd>
  argint(5, &offset);
    80004c1c:	fbc40593          	addi	a1,s0,-68
    80004c20:	4515                	li	a0,5
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	428080e7          	jalr	1064(ra) # 8000204a <argint>
  if (length < 0 || prot < 0 || flags < 0 || fd < 0 || offset < 0)
    80004c2a:	fcc42583          	lw	a1,-52(s0)
    80004c2e:	0405c763          	bltz	a1,80004c7c <sys_mmap+0xb6>
    80004c32:	fc842603          	lw	a2,-56(s0)
    80004c36:	04064363          	bltz	a2,80004c7c <sys_mmap+0xb6>
    80004c3a:	fc442803          	lw	a6,-60(s0)
    80004c3e:	02084f63          	bltz	a6,80004c7c <sys_mmap+0xb6>
    80004c42:	fc042883          	lw	a7,-64(s0)
    80004c46:	0208cb63          	bltz	a7,80004c7c <sys_mmap+0xb6>
    80004c4a:	fbc42303          	lw	t1,-68(s0)
    80004c4e:	02034763          	bltz	t1,80004c7c <sys_mmap+0xb6>
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004c52:	fb043503          	ld	a0,-80(s0)
    80004c56:	00954783          	lbu	a5,9(a0)
    80004c5a:	e781                	bnez	a5,80004c62 <sys_mmap+0x9c>
    80004c5c:	00267793          	andi	a5,a2,2
    80004c60:	ef9d                	bnez	a5,80004c9e <sys_mmap+0xd8>
  while (idx < VMASIZE)
    80004c62:	17090793          	addi	a5,s2,368
{
    80004c66:	4481                	li	s1,0
  while (idx < VMASIZE)
    80004c68:	46c1                	li	a3,16
    if (p->vma[idx].length == 0) // free vma
    80004c6a:	4398                	lw	a4,0(a5)
    80004c6c:	c731                	beqz	a4,80004cb8 <sys_mmap+0xf2>
    idx++;
    80004c6e:	2485                	addiw	s1,s1,1
  while (idx < VMASIZE)
    80004c70:	03078793          	addi	a5,a5,48
    80004c74:	fed49be3          	bne	s1,a3,80004c6a <sys_mmap+0xa4>
  return -1;
    80004c78:	557d                	li	a0,-1
    80004c7a:	a811                	j	80004c8e <sys_mmap+0xc8>
    printf("sys_mmap(): invalid argument\n");
    80004c7c:	00004517          	auipc	a0,0x4
    80004c80:	a3c50513          	addi	a0,a0,-1476 # 800086b8 <syscalls+0x308>
    80004c84:	00001097          	auipc	ra,0x1
    80004c88:	3b4080e7          	jalr	948(ra) # 80006038 <printf>
    return -1;
    80004c8c:	557d                	li	a0,-1
}
    80004c8e:	60a6                	ld	ra,72(sp)
    80004c90:	6406                	ld	s0,64(sp)
    80004c92:	74e2                	ld	s1,56(sp)
    80004c94:	7942                	ld	s2,48(sp)
    80004c96:	79a2                	ld	s3,40(sp)
    80004c98:	7a02                	ld	s4,32(sp)
    80004c9a:	6161                	addi	sp,sp,80
    80004c9c:	8082                	ret
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004c9e:	00187793          	andi	a5,a6,1
    80004ca2:	d3e1                	beqz	a5,80004c62 <sys_mmap+0x9c>
    printf("sys_mmap(): permission/flags conflict\n");
    80004ca4:	00004517          	auipc	a0,0x4
    80004ca8:	a3450513          	addi	a0,a0,-1484 # 800086d8 <syscalls+0x328>
    80004cac:	00001097          	auipc	ra,0x1
    80004cb0:	38c080e7          	jalr	908(ra) # 80006038 <printf>
    return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	bfe1                	j	80004c8e <sys_mmap+0xc8>
      p->vma[idx].addr = (void *)p->sz;
    80004cb8:	00149a13          	slli	s4,s1,0x1
    80004cbc:	009a09b3          	add	s3,s4,s1
    80004cc0:	0992                	slli	s3,s3,0x4
    80004cc2:	99ca                	add	s3,s3,s2
    80004cc4:	04893783          	ld	a5,72(s2)
    80004cc8:	16f9b423          	sd	a5,360(s3)
      p->vma[idx].length = length;
    80004ccc:	16b9a823          	sw	a1,368(s3)
      p->vma[idx].prot = prot;
    80004cd0:	16c9aa23          	sw	a2,372(s3)
      p->vma[idx].flags = flags;
    80004cd4:	1709ac23          	sw	a6,376(s3)
      p->vma[idx].fd = fd;
    80004cd8:	1719ae23          	sw	a7,380(s3)
      p->vma[idx].offset = offset;
    80004cdc:	1869a023          	sw	t1,384(s3)
      p->vma[idx].mfile = filedup(mfile); // increment the reference count
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	d26080e7          	jalr	-730(ra) # 80003a06 <filedup>
    80004ce8:	18a9b423          	sd	a0,392(s3)
      p->vma[idx].ip = mfile->ip;
    80004cec:	fb043783          	ld	a5,-80(s0)
    80004cf0:	6f9c                	ld	a5,24(a5)
    80004cf2:	18f9b823          	sd	a5,400(s3)
      p->sz += PGROUNDUP(length);
    80004cf6:	fcc42783          	lw	a5,-52(s0)
    80004cfa:	6705                	lui	a4,0x1
    80004cfc:	377d                	addiw	a4,a4,-1
    80004cfe:	9fb9                	addw	a5,a5,a4
    80004d00:	777d                	lui	a4,0xfffff
    80004d02:	8ff9                	and	a5,a5,a4
    80004d04:	2781                	sext.w	a5,a5
    80004d06:	04893703          	ld	a4,72(s2)
    80004d0a:	97ba                	add	a5,a5,a4
    80004d0c:	04f93423          	sd	a5,72(s2)
      printf("sys_mmap(): off %d\n", offset);
    80004d10:	fbc42583          	lw	a1,-68(s0)
    80004d14:	00004517          	auipc	a0,0x4
    80004d18:	9ec50513          	addi	a0,a0,-1556 # 80008700 <syscalls+0x350>
    80004d1c:	00001097          	auipc	ra,0x1
    80004d20:	31c080e7          	jalr	796(ra) # 80006038 <printf>
      return (uint64)p->vma[idx].addr;
    80004d24:	1689b503          	ld	a0,360(s3)
    80004d28:	b79d                	j	80004c8e <sys_mmap+0xc8>

0000000080004d2a <sys_munmap>:
{
    80004d2a:	715d                	addi	sp,sp,-80
    80004d2c:	e486                	sd	ra,72(sp)
    80004d2e:	e0a2                	sd	s0,64(sp)
    80004d30:	fc26                	sd	s1,56(sp)
    80004d32:	f84a                	sd	s2,48(sp)
    80004d34:	f44e                	sd	s3,40(sp)
    80004d36:	f052                	sd	s4,32(sp)
    80004d38:	ec56                	sd	s5,24(sp)
    80004d3a:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004d3c:	ffffc097          	auipc	ra,0xffffc
    80004d40:	0fc080e7          	jalr	252(ra) # 80000e38 <myproc>
    80004d44:	892a                	mv	s2,a0
  argaddr(0, &va);
    80004d46:	fb840593          	addi	a1,s0,-72
    80004d4a:	4501                	li	a0,0
    80004d4c:	ffffd097          	auipc	ra,0xffffd
    80004d50:	31e080e7          	jalr	798(ra) # 8000206a <argaddr>
  argint(1, &length);
    80004d54:	fb440593          	addi	a1,s0,-76
    80004d58:	4505                	li	a0,1
    80004d5a:	ffffd097          	auipc	ra,0xffffd
    80004d5e:	2f0080e7          	jalr	752(ra) # 8000204a <argint>
  if (va < 0 || length < 0)
    80004d62:	fb442783          	lw	a5,-76(s0)
    80004d66:	1607cb63          	bltz	a5,80004edc <sys_munmap+0x1b2>
    if (va >= (uint64)p->vma[i].addr && va < (uint64)p->vma[i].addr + p->sz)
    80004d6a:	fb843683          	ld	a3,-72(s0)
    80004d6e:	16890713          	addi	a4,s2,360
  for (int i = 0; i < VMASIZE; i++)
    80004d72:	4481                	li	s1,0
    80004d74:	4641                	li	a2,16
    80004d76:	a031                	j	80004d82 <sys_munmap+0x58>
    80004d78:	2485                	addiw	s1,s1,1
    80004d7a:	03070713          	addi	a4,a4,48 # fffffffffffff030 <end+0xffffffff7ffd1290>
    80004d7e:	00c48b63          	beq	s1,a2,80004d94 <sys_munmap+0x6a>
    if (va >= (uint64)p->vma[i].addr && va < (uint64)p->vma[i].addr + p->sz)
    80004d82:	631c                	ld	a5,0(a4)
    80004d84:	fef6eae3          	bltu	a3,a5,80004d78 <sys_munmap+0x4e>
    80004d88:	04893583          	ld	a1,72(s2)
    80004d8c:	97ae                	add	a5,a5,a1
    80004d8e:	fef6f5e3          	bgeu	a3,a5,80004d78 <sys_munmap+0x4e>
    80004d92:	a011                	j	80004d96 <sys_munmap+0x6c>
  int idx = -1;
    80004d94:	54fd                	li	s1,-1
  struct vma v = p->vma[idx];
    80004d96:	00149793          	slli	a5,s1,0x1
    80004d9a:	97a6                	add	a5,a5,s1
    80004d9c:	0792                	slli	a5,a5,0x4
    80004d9e:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004da0:	1747a783          	lw	a5,372(a5)
    80004da4:	8b89                	andi	a5,a5,2
    80004da6:	cb91                	beqz	a5,80004dba <sys_munmap+0x90>
  struct vma v = p->vma[idx];
    80004da8:	00149793          	slli	a5,s1,0x1
    80004dac:	97a6                	add	a5,a5,s1
    80004dae:	0792                	slli	a5,a5,0x4
    80004db0:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004db2:	1787a783          	lw	a5,376(a5)
    80004db6:	8b85                	andi	a5,a5,1
    80004db8:	e3c1                	bnez	a5,80004e38 <sys_munmap+0x10e>
  uint64 npages = min(p->sz, PGROUNDUP(length)) / PGSIZE;
    80004dba:	fb442603          	lw	a2,-76(s0)
    80004dbe:	6785                	lui	a5,0x1
    80004dc0:	37fd                	addiw	a5,a5,-1
    80004dc2:	9e3d                	addw	a2,a2,a5
    80004dc4:	77fd                	lui	a5,0xfffff
    80004dc6:	8e7d                	and	a2,a2,a5
    80004dc8:	04893783          	ld	a5,72(s2)
    80004dcc:	2601                	sext.w	a2,a2
    80004dce:	00c7f363          	bgeu	a5,a2,80004dd4 <sys_munmap+0xaa>
    80004dd2:	863e                	mv	a2,a5
  uvmunmap(p->pagetable, va, npages, 1);
    80004dd4:	4685                	li	a3,1
    80004dd6:	8231                	srli	a2,a2,0xc
    80004dd8:	fb843583          	ld	a1,-72(s0)
    80004ddc:	05093503          	ld	a0,80(s2)
    80004de0:	ffffc097          	auipc	ra,0xffffc
    80004de4:	92a080e7          	jalr	-1750(ra) # 8000070a <uvmunmap>
  v.length -= length;
    80004de8:	fb442683          	lw	a3,-76(s0)
  va += length;
    80004dec:	fb843783          	ld	a5,-72(s0)
    80004df0:	97b6                	add	a5,a5,a3
    80004df2:	faf43c23          	sd	a5,-72(s0)
  p->vma[idx].addr += length;
    80004df6:	00149793          	slli	a5,s1,0x1
    80004dfa:	97a6                	add	a5,a5,s1
    80004dfc:	0792                	slli	a5,a5,0x4
    80004dfe:	97ca                	add	a5,a5,s2
    80004e00:	1687b703          	ld	a4,360(a5) # fffffffffffff168 <end+0xffffffff7ffd13c8>
    80004e04:	9736                	add	a4,a4,a3
    80004e06:	16e7b423          	sd	a4,360(a5)
  p->vma[idx].offset += length;
    80004e0a:	1807a703          	lw	a4,384(a5)
    80004e0e:	9f35                	addw	a4,a4,a3
    80004e10:	18e7a023          	sw	a4,384(a5)
  p->vma[idx].length -= length;
    80004e14:	1707a703          	lw	a4,368(a5)
    80004e18:	9f15                	subw	a4,a4,a3
    80004e1a:	0007069b          	sext.w	a3,a4
    80004e1e:	16e7a823          	sw	a4,368(a5)
  return 0;
    80004e22:	4501                	li	a0,0
  if (p->vma[idx].length == 0)
    80004e24:	ced9                	beqz	a3,80004ec2 <sys_munmap+0x198>
}
    80004e26:	60a6                	ld	ra,72(sp)
    80004e28:	6406                	ld	s0,64(sp)
    80004e2a:	74e2                	ld	s1,56(sp)
    80004e2c:	7942                	ld	s2,48(sp)
    80004e2e:	79a2                	ld	s3,40(sp)
    80004e30:	7a02                	ld	s4,32(sp)
    80004e32:	6ae2                	ld	s5,24(sp)
    80004e34:	6161                	addi	sp,sp,80
    80004e36:	8082                	ret
  struct vma v = p->vma[idx];
    80004e38:	00149793          	slli	a5,s1,0x1
    80004e3c:	97a6                	add	a5,a5,s1
    80004e3e:	0792                	slli	a5,a5,0x4
    80004e40:	97ca                	add	a5,a5,s2
    80004e42:	1687ba03          	ld	s4,360(a5)
    80004e46:	1807aa83          	lw	s5,384(a5)
    80004e4a:	1907b983          	ld	s3,400(a5)
    begin_op();
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	73e080e7          	jalr	1854(ra) # 8000358c <begin_op>
    ilock(v.ip);
    80004e56:	854e                	mv	a0,s3
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	d6e080e7          	jalr	-658(ra) # 80002bc6 <ilock>
    printf("sys_munmap(): off %d\n", va - (uint64)v.addr);
    80004e60:	fb843583          	ld	a1,-72(s0)
    80004e64:	414585b3          	sub	a1,a1,s4
    80004e68:	00004517          	auipc	a0,0x4
    80004e6c:	8b050513          	addi	a0,a0,-1872 # 80008718 <syscalls+0x368>
    80004e70:	00001097          	auipc	ra,0x1
    80004e74:	1c8080e7          	jalr	456(ra) # 80006038 <printf>
    writei(v.ip, 1, (uint64)v.addr, va - (uint64)v.addr + v.offset, min(p->sz, PGROUNDUP(length))); // fix
    80004e78:	fb442703          	lw	a4,-76(s0)
    80004e7c:	6785                	lui	a5,0x1
    80004e7e:	37fd                	addiw	a5,a5,-1
    80004e80:	9f3d                	addw	a4,a4,a5
    80004e82:	77fd                	lui	a5,0xfffff
    80004e84:	8f7d                	and	a4,a4,a5
    80004e86:	04893783          	ld	a5,72(s2)
    80004e8a:	2701                	sext.w	a4,a4
    80004e8c:	00e7f363          	bgeu	a5,a4,80004e92 <sys_munmap+0x168>
    80004e90:	873e                	mv	a4,a5
    80004e92:	fb843683          	ld	a3,-72(s0)
    80004e96:	015686bb          	addw	a3,a3,s5
    80004e9a:	2701                	sext.w	a4,a4
    80004e9c:	414686bb          	subw	a3,a3,s4
    80004ea0:	8652                	mv	a2,s4
    80004ea2:	4585                	li	a1,1
    80004ea4:	854e                	mv	a0,s3
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	0cc080e7          	jalr	204(ra) # 80002f72 <writei>
    iunlock(v.ip);
    80004eae:	854e                	mv	a0,s3
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	dd8080e7          	jalr	-552(ra) # 80002c88 <iunlock>
    end_op();
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	754080e7          	jalr	1876(ra) # 8000360c <end_op>
    80004ec0:	bded                	j	80004dba <sys_munmap+0x90>
    fileclose(p->vma[idx].mfile);
    80004ec2:	00149793          	slli	a5,s1,0x1
    80004ec6:	94be                	add	s1,s1,a5
    80004ec8:	0492                	slli	s1,s1,0x4
    80004eca:	9926                	add	s2,s2,s1
    80004ecc:	18893503          	ld	a0,392(s2)
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	b88080e7          	jalr	-1144(ra) # 80003a58 <fileclose>
  return 0;
    80004ed8:	4501                	li	a0,0
    80004eda:	b7b1                	j	80004e26 <sys_munmap+0xfc>
    return -1;
    80004edc:	557d                	li	a0,-1
    80004ede:	b7a1                	j	80004e26 <sys_munmap+0xfc>

0000000080004ee0 <sys_open>:

uint64
sys_open(void)
{
    80004ee0:	7131                	addi	sp,sp,-192
    80004ee2:	fd06                	sd	ra,184(sp)
    80004ee4:	f922                	sd	s0,176(sp)
    80004ee6:	f526                	sd	s1,168(sp)
    80004ee8:	f14a                	sd	s2,160(sp)
    80004eea:	ed4e                	sd	s3,152(sp)
    80004eec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004eee:	f4c40593          	addi	a1,s0,-180
    80004ef2:	4505                	li	a0,1
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	156080e7          	jalr	342(ra) # 8000204a <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004efc:	08000613          	li	a2,128
    80004f00:	f5040593          	addi	a1,s0,-176
    80004f04:	4501                	li	a0,0
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	184080e7          	jalr	388(ra) # 8000208a <argstr>
    80004f0e:	87aa                	mv	a5,a0
    return -1;
    80004f10:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f12:	0a07c963          	bltz	a5,80004fc4 <sys_open+0xe4>

  begin_op();
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	676080e7          	jalr	1654(ra) # 8000358c <begin_op>

  if (omode & O_CREATE)
    80004f1e:	f4c42783          	lw	a5,-180(s0)
    80004f22:	2007f793          	andi	a5,a5,512
    80004f26:	cfc5                	beqz	a5,80004fde <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004f28:	4681                	li	a3,0
    80004f2a:	4601                	li	a2,0
    80004f2c:	4589                	li	a1,2
    80004f2e:	f5040513          	addi	a0,s0,-176
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	65c080e7          	jalr	1628(ra) # 8000458e <create>
    80004f3a:	84aa                	mv	s1,a0
    if (ip == 0)
    80004f3c:	c959                	beqz	a0,80004fd2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004f3e:	04449703          	lh	a4,68(s1)
    80004f42:	478d                	li	a5,3
    80004f44:	00f71763          	bne	a4,a5,80004f52 <sys_open+0x72>
    80004f48:	0464d703          	lhu	a4,70(s1)
    80004f4c:	47a5                	li	a5,9
    80004f4e:	0ce7ed63          	bltu	a5,a4,80005028 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f52:	fffff097          	auipc	ra,0xfffff
    80004f56:	a4a080e7          	jalr	-1462(ra) # 8000399c <filealloc>
    80004f5a:	89aa                	mv	s3,a0
    80004f5c:	10050363          	beqz	a0,80005062 <sys_open+0x182>
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	5ec080e7          	jalr	1516(ra) # 8000454c <fdalloc>
    80004f68:	892a                	mv	s2,a0
    80004f6a:	0e054763          	bltz	a0,80005058 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004f6e:	04449703          	lh	a4,68(s1)
    80004f72:	478d                	li	a5,3
    80004f74:	0cf70563          	beq	a4,a5,8000503e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004f78:	4789                	li	a5,2
    80004f7a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f7e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f82:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f86:	f4c42783          	lw	a5,-180(s0)
    80004f8a:	0017c713          	xori	a4,a5,1
    80004f8e:	8b05                	andi	a4,a4,1
    80004f90:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f94:	0037f713          	andi	a4,a5,3
    80004f98:	00e03733          	snez	a4,a4
    80004f9c:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004fa0:	4007f793          	andi	a5,a5,1024
    80004fa4:	c791                	beqz	a5,80004fb0 <sys_open+0xd0>
    80004fa6:	04449703          	lh	a4,68(s1)
    80004faa:	4789                	li	a5,2
    80004fac:	0af70063          	beq	a4,a5,8000504c <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004fb0:	8526                	mv	a0,s1
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	cd6080e7          	jalr	-810(ra) # 80002c88 <iunlock>
  end_op();
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	652080e7          	jalr	1618(ra) # 8000360c <end_op>

  return fd;
    80004fc2:	854a                	mv	a0,s2
}
    80004fc4:	70ea                	ld	ra,184(sp)
    80004fc6:	744a                	ld	s0,176(sp)
    80004fc8:	74aa                	ld	s1,168(sp)
    80004fca:	790a                	ld	s2,160(sp)
    80004fcc:	69ea                	ld	s3,152(sp)
    80004fce:	6129                	addi	sp,sp,192
    80004fd0:	8082                	ret
      end_op();
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	63a080e7          	jalr	1594(ra) # 8000360c <end_op>
      return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	b7e5                	j	80004fc4 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004fde:	f5040513          	addi	a0,s0,-176
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	38a080e7          	jalr	906(ra) # 8000336c <namei>
    80004fea:	84aa                	mv	s1,a0
    80004fec:	c905                	beqz	a0,8000501c <sys_open+0x13c>
    ilock(ip);
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	bd8080e7          	jalr	-1064(ra) # 80002bc6 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004ff6:	04449703          	lh	a4,68(s1)
    80004ffa:	4785                	li	a5,1
    80004ffc:	f4f711e3          	bne	a4,a5,80004f3e <sys_open+0x5e>
    80005000:	f4c42783          	lw	a5,-180(s0)
    80005004:	d7b9                	beqz	a5,80004f52 <sys_open+0x72>
      iunlockput(ip);
    80005006:	8526                	mv	a0,s1
    80005008:	ffffe097          	auipc	ra,0xffffe
    8000500c:	e20080e7          	jalr	-480(ra) # 80002e28 <iunlockput>
      end_op();
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	5fc080e7          	jalr	1532(ra) # 8000360c <end_op>
      return -1;
    80005018:	557d                	li	a0,-1
    8000501a:	b76d                	j	80004fc4 <sys_open+0xe4>
      end_op();
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	5f0080e7          	jalr	1520(ra) # 8000360c <end_op>
      return -1;
    80005024:	557d                	li	a0,-1
    80005026:	bf79                	j	80004fc4 <sys_open+0xe4>
    iunlockput(ip);
    80005028:	8526                	mv	a0,s1
    8000502a:	ffffe097          	auipc	ra,0xffffe
    8000502e:	dfe080e7          	jalr	-514(ra) # 80002e28 <iunlockput>
    end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	5da080e7          	jalr	1498(ra) # 8000360c <end_op>
    return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	b761                	j	80004fc4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000503e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005042:	04649783          	lh	a5,70(s1)
    80005046:	02f99223          	sh	a5,36(s3)
    8000504a:	bf25                	j	80004f82 <sys_open+0xa2>
    itrunc(ip);
    8000504c:	8526                	mv	a0,s1
    8000504e:	ffffe097          	auipc	ra,0xffffe
    80005052:	c86080e7          	jalr	-890(ra) # 80002cd4 <itrunc>
    80005056:	bfa9                	j	80004fb0 <sys_open+0xd0>
      fileclose(f);
    80005058:	854e                	mv	a0,s3
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	9fe080e7          	jalr	-1538(ra) # 80003a58 <fileclose>
    iunlockput(ip);
    80005062:	8526                	mv	a0,s1
    80005064:	ffffe097          	auipc	ra,0xffffe
    80005068:	dc4080e7          	jalr	-572(ra) # 80002e28 <iunlockput>
    end_op();
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	5a0080e7          	jalr	1440(ra) # 8000360c <end_op>
    return -1;
    80005074:	557d                	li	a0,-1
    80005076:	b7b9                	j	80004fc4 <sys_open+0xe4>

0000000080005078 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005078:	7175                	addi	sp,sp,-144
    8000507a:	e506                	sd	ra,136(sp)
    8000507c:	e122                	sd	s0,128(sp)
    8000507e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	50c080e7          	jalr	1292(ra) # 8000358c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005088:	08000613          	li	a2,128
    8000508c:	f7040593          	addi	a1,s0,-144
    80005090:	4501                	li	a0,0
    80005092:	ffffd097          	auipc	ra,0xffffd
    80005096:	ff8080e7          	jalr	-8(ra) # 8000208a <argstr>
    8000509a:	02054963          	bltz	a0,800050cc <sys_mkdir+0x54>
    8000509e:	4681                	li	a3,0
    800050a0:	4601                	li	a2,0
    800050a2:	4585                	li	a1,1
    800050a4:	f7040513          	addi	a0,s0,-144
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	4e6080e7          	jalr	1254(ra) # 8000458e <create>
    800050b0:	cd11                	beqz	a0,800050cc <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	d76080e7          	jalr	-650(ra) # 80002e28 <iunlockput>
  end_op();
    800050ba:	ffffe097          	auipc	ra,0xffffe
    800050be:	552080e7          	jalr	1362(ra) # 8000360c <end_op>
  return 0;
    800050c2:	4501                	li	a0,0
}
    800050c4:	60aa                	ld	ra,136(sp)
    800050c6:	640a                	ld	s0,128(sp)
    800050c8:	6149                	addi	sp,sp,144
    800050ca:	8082                	ret
    end_op();
    800050cc:	ffffe097          	auipc	ra,0xffffe
    800050d0:	540080e7          	jalr	1344(ra) # 8000360c <end_op>
    return -1;
    800050d4:	557d                	li	a0,-1
    800050d6:	b7fd                	j	800050c4 <sys_mkdir+0x4c>

00000000800050d8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050d8:	7135                	addi	sp,sp,-160
    800050da:	ed06                	sd	ra,152(sp)
    800050dc:	e922                	sd	s0,144(sp)
    800050de:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050e0:	ffffe097          	auipc	ra,0xffffe
    800050e4:	4ac080e7          	jalr	1196(ra) # 8000358c <begin_op>
  argint(1, &major);
    800050e8:	f6c40593          	addi	a1,s0,-148
    800050ec:	4505                	li	a0,1
    800050ee:	ffffd097          	auipc	ra,0xffffd
    800050f2:	f5c080e7          	jalr	-164(ra) # 8000204a <argint>
  argint(2, &minor);
    800050f6:	f6840593          	addi	a1,s0,-152
    800050fa:	4509                	li	a0,2
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	f4e080e7          	jalr	-178(ra) # 8000204a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005104:	08000613          	li	a2,128
    80005108:	f7040593          	addi	a1,s0,-144
    8000510c:	4501                	li	a0,0
    8000510e:	ffffd097          	auipc	ra,0xffffd
    80005112:	f7c080e7          	jalr	-132(ra) # 8000208a <argstr>
    80005116:	02054b63          	bltz	a0,8000514c <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    8000511a:	f6841683          	lh	a3,-152(s0)
    8000511e:	f6c41603          	lh	a2,-148(s0)
    80005122:	458d                	li	a1,3
    80005124:	f7040513          	addi	a0,s0,-144
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	466080e7          	jalr	1126(ra) # 8000458e <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005130:	cd11                	beqz	a0,8000514c <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005132:	ffffe097          	auipc	ra,0xffffe
    80005136:	cf6080e7          	jalr	-778(ra) # 80002e28 <iunlockput>
  end_op();
    8000513a:	ffffe097          	auipc	ra,0xffffe
    8000513e:	4d2080e7          	jalr	1234(ra) # 8000360c <end_op>
  return 0;
    80005142:	4501                	li	a0,0
}
    80005144:	60ea                	ld	ra,152(sp)
    80005146:	644a                	ld	s0,144(sp)
    80005148:	610d                	addi	sp,sp,160
    8000514a:	8082                	ret
    end_op();
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	4c0080e7          	jalr	1216(ra) # 8000360c <end_op>
    return -1;
    80005154:	557d                	li	a0,-1
    80005156:	b7fd                	j	80005144 <sys_mknod+0x6c>

0000000080005158 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005158:	7135                	addi	sp,sp,-160
    8000515a:	ed06                	sd	ra,152(sp)
    8000515c:	e922                	sd	s0,144(sp)
    8000515e:	e526                	sd	s1,136(sp)
    80005160:	e14a                	sd	s2,128(sp)
    80005162:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005164:	ffffc097          	auipc	ra,0xffffc
    80005168:	cd4080e7          	jalr	-812(ra) # 80000e38 <myproc>
    8000516c:	892a                	mv	s2,a0

  begin_op();
    8000516e:	ffffe097          	auipc	ra,0xffffe
    80005172:	41e080e7          	jalr	1054(ra) # 8000358c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005176:	08000613          	li	a2,128
    8000517a:	f6040593          	addi	a1,s0,-160
    8000517e:	4501                	li	a0,0
    80005180:	ffffd097          	auipc	ra,0xffffd
    80005184:	f0a080e7          	jalr	-246(ra) # 8000208a <argstr>
    80005188:	04054b63          	bltz	a0,800051de <sys_chdir+0x86>
    8000518c:	f6040513          	addi	a0,s0,-160
    80005190:	ffffe097          	auipc	ra,0xffffe
    80005194:	1dc080e7          	jalr	476(ra) # 8000336c <namei>
    80005198:	84aa                	mv	s1,a0
    8000519a:	c131                	beqz	a0,800051de <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    8000519c:	ffffe097          	auipc	ra,0xffffe
    800051a0:	a2a080e7          	jalr	-1494(ra) # 80002bc6 <ilock>
  if (ip->type != T_DIR)
    800051a4:	04449703          	lh	a4,68(s1)
    800051a8:	4785                	li	a5,1
    800051aa:	04f71063          	bne	a4,a5,800051ea <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051ae:	8526                	mv	a0,s1
    800051b0:	ffffe097          	auipc	ra,0xffffe
    800051b4:	ad8080e7          	jalr	-1320(ra) # 80002c88 <iunlock>
  iput(p->cwd);
    800051b8:	15093503          	ld	a0,336(s2)
    800051bc:	ffffe097          	auipc	ra,0xffffe
    800051c0:	bc4080e7          	jalr	-1084(ra) # 80002d80 <iput>
  end_op();
    800051c4:	ffffe097          	auipc	ra,0xffffe
    800051c8:	448080e7          	jalr	1096(ra) # 8000360c <end_op>
  p->cwd = ip;
    800051cc:	14993823          	sd	s1,336(s2)
  return 0;
    800051d0:	4501                	li	a0,0
}
    800051d2:	60ea                	ld	ra,152(sp)
    800051d4:	644a                	ld	s0,144(sp)
    800051d6:	64aa                	ld	s1,136(sp)
    800051d8:	690a                	ld	s2,128(sp)
    800051da:	610d                	addi	sp,sp,160
    800051dc:	8082                	ret
    end_op();
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	42e080e7          	jalr	1070(ra) # 8000360c <end_op>
    return -1;
    800051e6:	557d                	li	a0,-1
    800051e8:	b7ed                	j	800051d2 <sys_chdir+0x7a>
    iunlockput(ip);
    800051ea:	8526                	mv	a0,s1
    800051ec:	ffffe097          	auipc	ra,0xffffe
    800051f0:	c3c080e7          	jalr	-964(ra) # 80002e28 <iunlockput>
    end_op();
    800051f4:	ffffe097          	auipc	ra,0xffffe
    800051f8:	418080e7          	jalr	1048(ra) # 8000360c <end_op>
    return -1;
    800051fc:	557d                	li	a0,-1
    800051fe:	bfd1                	j	800051d2 <sys_chdir+0x7a>

0000000080005200 <sys_exec>:

uint64
sys_exec(void)
{
    80005200:	7145                	addi	sp,sp,-464
    80005202:	e786                	sd	ra,456(sp)
    80005204:	e3a2                	sd	s0,448(sp)
    80005206:	ff26                	sd	s1,440(sp)
    80005208:	fb4a                	sd	s2,432(sp)
    8000520a:	f74e                	sd	s3,424(sp)
    8000520c:	f352                	sd	s4,416(sp)
    8000520e:	ef56                	sd	s5,408(sp)
    80005210:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005212:	e3840593          	addi	a1,s0,-456
    80005216:	4505                	li	a0,1
    80005218:	ffffd097          	auipc	ra,0xffffd
    8000521c:	e52080e7          	jalr	-430(ra) # 8000206a <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    80005220:	08000613          	li	a2,128
    80005224:	f4040593          	addi	a1,s0,-192
    80005228:	4501                	li	a0,0
    8000522a:	ffffd097          	auipc	ra,0xffffd
    8000522e:	e60080e7          	jalr	-416(ra) # 8000208a <argstr>
    80005232:	87aa                	mv	a5,a0
  {
    return -1;
    80005234:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80005236:	0c07c263          	bltz	a5,800052fa <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000523a:	10000613          	li	a2,256
    8000523e:	4581                	li	a1,0
    80005240:	e4040513          	addi	a0,s0,-448
    80005244:	ffffb097          	auipc	ra,0xffffb
    80005248:	f34080e7          	jalr	-204(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    8000524c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005250:	89a6                	mv	s3,s1
    80005252:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80005254:	02000a13          	li	s4,32
    80005258:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    8000525c:	00391793          	slli	a5,s2,0x3
    80005260:	e3040593          	addi	a1,s0,-464
    80005264:	e3843503          	ld	a0,-456(s0)
    80005268:	953e                	add	a0,a0,a5
    8000526a:	ffffd097          	auipc	ra,0xffffd
    8000526e:	d42080e7          	jalr	-702(ra) # 80001fac <fetchaddr>
    80005272:	02054a63          	bltz	a0,800052a6 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80005276:	e3043783          	ld	a5,-464(s0)
    8000527a:	c3b9                	beqz	a5,800052c0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000527c:	ffffb097          	auipc	ra,0xffffb
    80005280:	e9c080e7          	jalr	-356(ra) # 80000118 <kalloc>
    80005284:	85aa                	mv	a1,a0
    80005286:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    8000528a:	cd11                	beqz	a0,800052a6 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000528c:	6605                	lui	a2,0x1
    8000528e:	e3043503          	ld	a0,-464(s0)
    80005292:	ffffd097          	auipc	ra,0xffffd
    80005296:	d6c080e7          	jalr	-660(ra) # 80001ffe <fetchstr>
    8000529a:	00054663          	bltz	a0,800052a6 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    8000529e:	0905                	addi	s2,s2,1
    800052a0:	09a1                	addi	s3,s3,8
    800052a2:	fb491be3          	bne	s2,s4,80005258 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052a6:	10048913          	addi	s2,s1,256
    800052aa:	6088                	ld	a0,0(s1)
    800052ac:	c531                	beqz	a0,800052f8 <sys_exec+0xf8>
    kfree(argv[i]);
    800052ae:	ffffb097          	auipc	ra,0xffffb
    800052b2:	d6e080e7          	jalr	-658(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052b6:	04a1                	addi	s1,s1,8
    800052b8:	ff2499e3          	bne	s1,s2,800052aa <sys_exec+0xaa>
  return -1;
    800052bc:	557d                	li	a0,-1
    800052be:	a835                	j	800052fa <sys_exec+0xfa>
      argv[i] = 0;
    800052c0:	0a8e                	slli	s5,s5,0x3
    800052c2:	fc040793          	addi	a5,s0,-64
    800052c6:	9abe                	add	s5,s5,a5
    800052c8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800052cc:	e4040593          	addi	a1,s0,-448
    800052d0:	f4040513          	addi	a0,s0,-192
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	e58080e7          	jalr	-424(ra) # 8000412c <exec>
    800052dc:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052de:	10048993          	addi	s3,s1,256
    800052e2:	6088                	ld	a0,0(s1)
    800052e4:	c901                	beqz	a0,800052f4 <sys_exec+0xf4>
    kfree(argv[i]);
    800052e6:	ffffb097          	auipc	ra,0xffffb
    800052ea:	d36080e7          	jalr	-714(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052ee:	04a1                	addi	s1,s1,8
    800052f0:	ff3499e3          	bne	s1,s3,800052e2 <sys_exec+0xe2>
  return ret;
    800052f4:	854a                	mv	a0,s2
    800052f6:	a011                	j	800052fa <sys_exec+0xfa>
  return -1;
    800052f8:	557d                	li	a0,-1
}
    800052fa:	60be                	ld	ra,456(sp)
    800052fc:	641e                	ld	s0,448(sp)
    800052fe:	74fa                	ld	s1,440(sp)
    80005300:	795a                	ld	s2,432(sp)
    80005302:	79ba                	ld	s3,424(sp)
    80005304:	7a1a                	ld	s4,416(sp)
    80005306:	6afa                	ld	s5,408(sp)
    80005308:	6179                	addi	sp,sp,464
    8000530a:	8082                	ret

000000008000530c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000530c:	7139                	addi	sp,sp,-64
    8000530e:	fc06                	sd	ra,56(sp)
    80005310:	f822                	sd	s0,48(sp)
    80005312:	f426                	sd	s1,40(sp)
    80005314:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005316:	ffffc097          	auipc	ra,0xffffc
    8000531a:	b22080e7          	jalr	-1246(ra) # 80000e38 <myproc>
    8000531e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005320:	fd840593          	addi	a1,s0,-40
    80005324:	4501                	li	a0,0
    80005326:	ffffd097          	auipc	ra,0xffffd
    8000532a:	d44080e7          	jalr	-700(ra) # 8000206a <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000532e:	fc840593          	addi	a1,s0,-56
    80005332:	fd040513          	addi	a0,s0,-48
    80005336:	fffff097          	auipc	ra,0xfffff
    8000533a:	aac080e7          	jalr	-1364(ra) # 80003de2 <pipealloc>
    return -1;
    8000533e:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80005340:	0c054463          	bltz	a0,80005408 <sys_pipe+0xfc>
  fd0 = -1;
    80005344:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005348:	fd043503          	ld	a0,-48(s0)
    8000534c:	fffff097          	auipc	ra,0xfffff
    80005350:	200080e7          	jalr	512(ra) # 8000454c <fdalloc>
    80005354:	fca42223          	sw	a0,-60(s0)
    80005358:	08054b63          	bltz	a0,800053ee <sys_pipe+0xe2>
    8000535c:	fc843503          	ld	a0,-56(s0)
    80005360:	fffff097          	auipc	ra,0xfffff
    80005364:	1ec080e7          	jalr	492(ra) # 8000454c <fdalloc>
    80005368:	fca42023          	sw	a0,-64(s0)
    8000536c:	06054863          	bltz	a0,800053dc <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005370:	4691                	li	a3,4
    80005372:	fc440613          	addi	a2,s0,-60
    80005376:	fd843583          	ld	a1,-40(s0)
    8000537a:	68a8                	ld	a0,80(s1)
    8000537c:	ffffb097          	auipc	ra,0xffffb
    80005380:	778080e7          	jalr	1912(ra) # 80000af4 <copyout>
    80005384:	02054063          	bltz	a0,800053a4 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80005388:	4691                	li	a3,4
    8000538a:	fc040613          	addi	a2,s0,-64
    8000538e:	fd843583          	ld	a1,-40(s0)
    80005392:	0591                	addi	a1,a1,4
    80005394:	68a8                	ld	a0,80(s1)
    80005396:	ffffb097          	auipc	ra,0xffffb
    8000539a:	75e080e7          	jalr	1886(ra) # 80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000539e:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053a0:	06055463          	bgez	a0,80005408 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800053a4:	fc442783          	lw	a5,-60(s0)
    800053a8:	07e9                	addi	a5,a5,26
    800053aa:	078e                	slli	a5,a5,0x3
    800053ac:	97a6                	add	a5,a5,s1
    800053ae:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd1260>
    p->ofile[fd1] = 0;
    800053b2:	fc042503          	lw	a0,-64(s0)
    800053b6:	0569                	addi	a0,a0,26
    800053b8:	050e                	slli	a0,a0,0x3
    800053ba:	94aa                	add	s1,s1,a0
    800053bc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053c0:	fd043503          	ld	a0,-48(s0)
    800053c4:	ffffe097          	auipc	ra,0xffffe
    800053c8:	694080e7          	jalr	1684(ra) # 80003a58 <fileclose>
    fileclose(wf);
    800053cc:	fc843503          	ld	a0,-56(s0)
    800053d0:	ffffe097          	auipc	ra,0xffffe
    800053d4:	688080e7          	jalr	1672(ra) # 80003a58 <fileclose>
    return -1;
    800053d8:	57fd                	li	a5,-1
    800053da:	a03d                	j	80005408 <sys_pipe+0xfc>
    if (fd0 >= 0)
    800053dc:	fc442783          	lw	a5,-60(s0)
    800053e0:	0007c763          	bltz	a5,800053ee <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800053e4:	07e9                	addi	a5,a5,26
    800053e6:	078e                	slli	a5,a5,0x3
    800053e8:	94be                	add	s1,s1,a5
    800053ea:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053ee:	fd043503          	ld	a0,-48(s0)
    800053f2:	ffffe097          	auipc	ra,0xffffe
    800053f6:	666080e7          	jalr	1638(ra) # 80003a58 <fileclose>
    fileclose(wf);
    800053fa:	fc843503          	ld	a0,-56(s0)
    800053fe:	ffffe097          	auipc	ra,0xffffe
    80005402:	65a080e7          	jalr	1626(ra) # 80003a58 <fileclose>
    return -1;
    80005406:	57fd                	li	a5,-1
}
    80005408:	853e                	mv	a0,a5
    8000540a:	70e2                	ld	ra,56(sp)
    8000540c:	7442                	ld	s0,48(sp)
    8000540e:	74a2                	ld	s1,40(sp)
    80005410:	6121                	addi	sp,sp,64
    80005412:	8082                	ret
	...

0000000080005420 <kernelvec>:
    80005420:	7111                	addi	sp,sp,-256
    80005422:	e006                	sd	ra,0(sp)
    80005424:	e40a                	sd	sp,8(sp)
    80005426:	e80e                	sd	gp,16(sp)
    80005428:	ec12                	sd	tp,24(sp)
    8000542a:	f016                	sd	t0,32(sp)
    8000542c:	f41a                	sd	t1,40(sp)
    8000542e:	f81e                	sd	t2,48(sp)
    80005430:	fc22                	sd	s0,56(sp)
    80005432:	e0a6                	sd	s1,64(sp)
    80005434:	e4aa                	sd	a0,72(sp)
    80005436:	e8ae                	sd	a1,80(sp)
    80005438:	ecb2                	sd	a2,88(sp)
    8000543a:	f0b6                	sd	a3,96(sp)
    8000543c:	f4ba                	sd	a4,104(sp)
    8000543e:	f8be                	sd	a5,112(sp)
    80005440:	fcc2                	sd	a6,120(sp)
    80005442:	e146                	sd	a7,128(sp)
    80005444:	e54a                	sd	s2,136(sp)
    80005446:	e94e                	sd	s3,144(sp)
    80005448:	ed52                	sd	s4,152(sp)
    8000544a:	f156                	sd	s5,160(sp)
    8000544c:	f55a                	sd	s6,168(sp)
    8000544e:	f95e                	sd	s7,176(sp)
    80005450:	fd62                	sd	s8,184(sp)
    80005452:	e1e6                	sd	s9,192(sp)
    80005454:	e5ea                	sd	s10,200(sp)
    80005456:	e9ee                	sd	s11,208(sp)
    80005458:	edf2                	sd	t3,216(sp)
    8000545a:	f1f6                	sd	t4,224(sp)
    8000545c:	f5fa                	sd	t5,232(sp)
    8000545e:	f9fe                	sd	t6,240(sp)
    80005460:	a19fc0ef          	jal	ra,80001e78 <kerneltrap>
    80005464:	6082                	ld	ra,0(sp)
    80005466:	6122                	ld	sp,8(sp)
    80005468:	61c2                	ld	gp,16(sp)
    8000546a:	7282                	ld	t0,32(sp)
    8000546c:	7322                	ld	t1,40(sp)
    8000546e:	73c2                	ld	t2,48(sp)
    80005470:	7462                	ld	s0,56(sp)
    80005472:	6486                	ld	s1,64(sp)
    80005474:	6526                	ld	a0,72(sp)
    80005476:	65c6                	ld	a1,80(sp)
    80005478:	6666                	ld	a2,88(sp)
    8000547a:	7686                	ld	a3,96(sp)
    8000547c:	7726                	ld	a4,104(sp)
    8000547e:	77c6                	ld	a5,112(sp)
    80005480:	7866                	ld	a6,120(sp)
    80005482:	688a                	ld	a7,128(sp)
    80005484:	692a                	ld	s2,136(sp)
    80005486:	69ca                	ld	s3,144(sp)
    80005488:	6a6a                	ld	s4,152(sp)
    8000548a:	7a8a                	ld	s5,160(sp)
    8000548c:	7b2a                	ld	s6,168(sp)
    8000548e:	7bca                	ld	s7,176(sp)
    80005490:	7c6a                	ld	s8,184(sp)
    80005492:	6c8e                	ld	s9,192(sp)
    80005494:	6d2e                	ld	s10,200(sp)
    80005496:	6dce                	ld	s11,208(sp)
    80005498:	6e6e                	ld	t3,216(sp)
    8000549a:	7e8e                	ld	t4,224(sp)
    8000549c:	7f2e                	ld	t5,232(sp)
    8000549e:	7fce                	ld	t6,240(sp)
    800054a0:	6111                	addi	sp,sp,256
    800054a2:	10200073          	sret
    800054a6:	00000013          	nop
    800054aa:	00000013          	nop
    800054ae:	0001                	nop

00000000800054b0 <timervec>:
    800054b0:	34051573          	csrrw	a0,mscratch,a0
    800054b4:	e10c                	sd	a1,0(a0)
    800054b6:	e510                	sd	a2,8(a0)
    800054b8:	e914                	sd	a3,16(a0)
    800054ba:	6d0c                	ld	a1,24(a0)
    800054bc:	7110                	ld	a2,32(a0)
    800054be:	6194                	ld	a3,0(a1)
    800054c0:	96b2                	add	a3,a3,a2
    800054c2:	e194                	sd	a3,0(a1)
    800054c4:	4589                	li	a1,2
    800054c6:	14459073          	csrw	sip,a1
    800054ca:	6914                	ld	a3,16(a0)
    800054cc:	6510                	ld	a2,8(a0)
    800054ce:	610c                	ld	a1,0(a0)
    800054d0:	34051573          	csrrw	a0,mscratch,a0
    800054d4:	30200073          	mret
	...

00000000800054da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054da:	1141                	addi	sp,sp,-16
    800054dc:	e422                	sd	s0,8(sp)
    800054de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054e0:	0c0007b7          	lui	a5,0xc000
    800054e4:	4705                	li	a4,1
    800054e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054e8:	c3d8                	sw	a4,4(a5)
}
    800054ea:	6422                	ld	s0,8(sp)
    800054ec:	0141                	addi	sp,sp,16
    800054ee:	8082                	ret

00000000800054f0 <plicinithart>:

void
plicinithart(void)
{
    800054f0:	1141                	addi	sp,sp,-16
    800054f2:	e406                	sd	ra,8(sp)
    800054f4:	e022                	sd	s0,0(sp)
    800054f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054f8:	ffffc097          	auipc	ra,0xffffc
    800054fc:	914080e7          	jalr	-1772(ra) # 80000e0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005500:	0085171b          	slliw	a4,a0,0x8
    80005504:	0c0027b7          	lui	a5,0xc002
    80005508:	97ba                	add	a5,a5,a4
    8000550a:	40200713          	li	a4,1026
    8000550e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005512:	00d5151b          	slliw	a0,a0,0xd
    80005516:	0c2017b7          	lui	a5,0xc201
    8000551a:	953e                	add	a0,a0,a5
    8000551c:	00052023          	sw	zero,0(a0)
}
    80005520:	60a2                	ld	ra,8(sp)
    80005522:	6402                	ld	s0,0(sp)
    80005524:	0141                	addi	sp,sp,16
    80005526:	8082                	ret

0000000080005528 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005528:	1141                	addi	sp,sp,-16
    8000552a:	e406                	sd	ra,8(sp)
    8000552c:	e022                	sd	s0,0(sp)
    8000552e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005530:	ffffc097          	auipc	ra,0xffffc
    80005534:	8dc080e7          	jalr	-1828(ra) # 80000e0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005538:	00d5179b          	slliw	a5,a0,0xd
    8000553c:	0c201537          	lui	a0,0xc201
    80005540:	953e                	add	a0,a0,a5
  return irq;
}
    80005542:	4148                	lw	a0,4(a0)
    80005544:	60a2                	ld	ra,8(sp)
    80005546:	6402                	ld	s0,0(sp)
    80005548:	0141                	addi	sp,sp,16
    8000554a:	8082                	ret

000000008000554c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000554c:	1101                	addi	sp,sp,-32
    8000554e:	ec06                	sd	ra,24(sp)
    80005550:	e822                	sd	s0,16(sp)
    80005552:	e426                	sd	s1,8(sp)
    80005554:	1000                	addi	s0,sp,32
    80005556:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005558:	ffffc097          	auipc	ra,0xffffc
    8000555c:	8b4080e7          	jalr	-1868(ra) # 80000e0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005560:	00d5151b          	slliw	a0,a0,0xd
    80005564:	0c2017b7          	lui	a5,0xc201
    80005568:	97aa                	add	a5,a5,a0
    8000556a:	c3c4                	sw	s1,4(a5)
}
    8000556c:	60e2                	ld	ra,24(sp)
    8000556e:	6442                	ld	s0,16(sp)
    80005570:	64a2                	ld	s1,8(sp)
    80005572:	6105                	addi	sp,sp,32
    80005574:	8082                	ret

0000000080005576 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005576:	1141                	addi	sp,sp,-16
    80005578:	e406                	sd	ra,8(sp)
    8000557a:	e022                	sd	s0,0(sp)
    8000557c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000557e:	479d                	li	a5,7
    80005580:	04a7cc63          	blt	a5,a0,800055d8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005584:	00020797          	auipc	a5,0x20
    80005588:	49c78793          	addi	a5,a5,1180 # 80025a20 <disk>
    8000558c:	97aa                	add	a5,a5,a0
    8000558e:	0187c783          	lbu	a5,24(a5)
    80005592:	ebb9                	bnez	a5,800055e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005594:	00451613          	slli	a2,a0,0x4
    80005598:	00020797          	auipc	a5,0x20
    8000559c:	48878793          	addi	a5,a5,1160 # 80025a20 <disk>
    800055a0:	6394                	ld	a3,0(a5)
    800055a2:	96b2                	add	a3,a3,a2
    800055a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055a8:	6398                	ld	a4,0(a5)
    800055aa:	9732                	add	a4,a4,a2
    800055ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800055b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055b8:	953e                	add	a0,a0,a5
    800055ba:	4785                	li	a5,1
    800055bc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800055c0:	00020517          	auipc	a0,0x20
    800055c4:	47850513          	addi	a0,a0,1144 # 80025a38 <disk+0x18>
    800055c8:	ffffc097          	auipc	ra,0xffffc
    800055cc:	f7c080e7          	jalr	-132(ra) # 80001544 <wakeup>
}
    800055d0:	60a2                	ld	ra,8(sp)
    800055d2:	6402                	ld	s0,0(sp)
    800055d4:	0141                	addi	sp,sp,16
    800055d6:	8082                	ret
    panic("free_desc 1");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	15850513          	addi	a0,a0,344 # 80008730 <syscalls+0x380>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	a0e080e7          	jalr	-1522(ra) # 80005fee <panic>
    panic("free_desc 2");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	15850513          	addi	a0,a0,344 # 80008740 <syscalls+0x390>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	9fe080e7          	jalr	-1538(ra) # 80005fee <panic>

00000000800055f8 <virtio_disk_init>:
{
    800055f8:	1101                	addi	sp,sp,-32
    800055fa:	ec06                	sd	ra,24(sp)
    800055fc:	e822                	sd	s0,16(sp)
    800055fe:	e426                	sd	s1,8(sp)
    80005600:	e04a                	sd	s2,0(sp)
    80005602:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005604:	00003597          	auipc	a1,0x3
    80005608:	14c58593          	addi	a1,a1,332 # 80008750 <syscalls+0x3a0>
    8000560c:	00020517          	auipc	a0,0x20
    80005610:	53c50513          	addi	a0,a0,1340 # 80025b48 <disk+0x128>
    80005614:	00001097          	auipc	ra,0x1
    80005618:	e86080e7          	jalr	-378(ra) # 8000649a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000561c:	100017b7          	lui	a5,0x10001
    80005620:	4398                	lw	a4,0(a5)
    80005622:	2701                	sext.w	a4,a4
    80005624:	747277b7          	lui	a5,0x74727
    80005628:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000562c:	14f71c63          	bne	a4,a5,80005784 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	43dc                	lw	a5,4(a5)
    80005636:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005638:	4709                	li	a4,2
    8000563a:	14e79563          	bne	a5,a4,80005784 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	479c                	lw	a5,8(a5)
    80005644:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005646:	12e79f63          	bne	a5,a4,80005784 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000564a:	100017b7          	lui	a5,0x10001
    8000564e:	47d8                	lw	a4,12(a5)
    80005650:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005652:	554d47b7          	lui	a5,0x554d4
    80005656:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000565a:	12f71563          	bne	a4,a5,80005784 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000565e:	100017b7          	lui	a5,0x10001
    80005662:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005666:	4705                	li	a4,1
    80005668:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000566a:	470d                	li	a4,3
    8000566c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000566e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005670:	c7ffe737          	lui	a4,0xc7ffe
    80005674:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd09bf>
    80005678:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000567a:	2701                	sext.w	a4,a4
    8000567c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000567e:	472d                	li	a4,11
    80005680:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005682:	5bbc                	lw	a5,112(a5)
    80005684:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005688:	8ba1                	andi	a5,a5,8
    8000568a:	10078563          	beqz	a5,80005794 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000568e:	100017b7          	lui	a5,0x10001
    80005692:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005696:	43fc                	lw	a5,68(a5)
    80005698:	2781                	sext.w	a5,a5
    8000569a:	10079563          	bnez	a5,800057a4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000569e:	100017b7          	lui	a5,0x10001
    800056a2:	5bdc                	lw	a5,52(a5)
    800056a4:	2781                	sext.w	a5,a5
  if(max == 0)
    800056a6:	10078763          	beqz	a5,800057b4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800056aa:	471d                	li	a4,7
    800056ac:	10f77c63          	bgeu	a4,a5,800057c4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800056b0:	ffffb097          	auipc	ra,0xffffb
    800056b4:	a68080e7          	jalr	-1432(ra) # 80000118 <kalloc>
    800056b8:	00020497          	auipc	s1,0x20
    800056bc:	36848493          	addi	s1,s1,872 # 80025a20 <disk>
    800056c0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056c2:	ffffb097          	auipc	ra,0xffffb
    800056c6:	a56080e7          	jalr	-1450(ra) # 80000118 <kalloc>
    800056ca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056cc:	ffffb097          	auipc	ra,0xffffb
    800056d0:	a4c080e7          	jalr	-1460(ra) # 80000118 <kalloc>
    800056d4:	87aa                	mv	a5,a0
    800056d6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056d8:	6088                	ld	a0,0(s1)
    800056da:	cd6d                	beqz	a0,800057d4 <virtio_disk_init+0x1dc>
    800056dc:	00020717          	auipc	a4,0x20
    800056e0:	34c73703          	ld	a4,844(a4) # 80025a28 <disk+0x8>
    800056e4:	cb65                	beqz	a4,800057d4 <virtio_disk_init+0x1dc>
    800056e6:	c7fd                	beqz	a5,800057d4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800056e8:	6605                	lui	a2,0x1
    800056ea:	4581                	li	a1,0
    800056ec:	ffffb097          	auipc	ra,0xffffb
    800056f0:	a8c080e7          	jalr	-1396(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056f4:	00020497          	auipc	s1,0x20
    800056f8:	32c48493          	addi	s1,s1,812 # 80025a20 <disk>
    800056fc:	6605                	lui	a2,0x1
    800056fe:	4581                	li	a1,0
    80005700:	6488                	ld	a0,8(s1)
    80005702:	ffffb097          	auipc	ra,0xffffb
    80005706:	a76080e7          	jalr	-1418(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000570a:	6605                	lui	a2,0x1
    8000570c:	4581                	li	a1,0
    8000570e:	6888                	ld	a0,16(s1)
    80005710:	ffffb097          	auipc	ra,0xffffb
    80005714:	a68080e7          	jalr	-1432(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005718:	100017b7          	lui	a5,0x10001
    8000571c:	4721                	li	a4,8
    8000571e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005720:	4098                	lw	a4,0(s1)
    80005722:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005726:	40d8                	lw	a4,4(s1)
    80005728:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000572c:	6498                	ld	a4,8(s1)
    8000572e:	0007069b          	sext.w	a3,a4
    80005732:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005736:	9701                	srai	a4,a4,0x20
    80005738:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000573c:	6898                	ld	a4,16(s1)
    8000573e:	0007069b          	sext.w	a3,a4
    80005742:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005746:	9701                	srai	a4,a4,0x20
    80005748:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000574c:	4705                	li	a4,1
    8000574e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005750:	00e48c23          	sb	a4,24(s1)
    80005754:	00e48ca3          	sb	a4,25(s1)
    80005758:	00e48d23          	sb	a4,26(s1)
    8000575c:	00e48da3          	sb	a4,27(s1)
    80005760:	00e48e23          	sb	a4,28(s1)
    80005764:	00e48ea3          	sb	a4,29(s1)
    80005768:	00e48f23          	sb	a4,30(s1)
    8000576c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005770:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005774:	0727a823          	sw	s2,112(a5)
}
    80005778:	60e2                	ld	ra,24(sp)
    8000577a:	6442                	ld	s0,16(sp)
    8000577c:	64a2                	ld	s1,8(sp)
    8000577e:	6902                	ld	s2,0(sp)
    80005780:	6105                	addi	sp,sp,32
    80005782:	8082                	ret
    panic("could not find virtio disk");
    80005784:	00003517          	auipc	a0,0x3
    80005788:	fdc50513          	addi	a0,a0,-36 # 80008760 <syscalls+0x3b0>
    8000578c:	00001097          	auipc	ra,0x1
    80005790:	862080e7          	jalr	-1950(ra) # 80005fee <panic>
    panic("virtio disk FEATURES_OK unset");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	fec50513          	addi	a0,a0,-20 # 80008780 <syscalls+0x3d0>
    8000579c:	00001097          	auipc	ra,0x1
    800057a0:	852080e7          	jalr	-1966(ra) # 80005fee <panic>
    panic("virtio disk should not be ready");
    800057a4:	00003517          	auipc	a0,0x3
    800057a8:	ffc50513          	addi	a0,a0,-4 # 800087a0 <syscalls+0x3f0>
    800057ac:	00001097          	auipc	ra,0x1
    800057b0:	842080e7          	jalr	-1982(ra) # 80005fee <panic>
    panic("virtio disk has no queue 0");
    800057b4:	00003517          	auipc	a0,0x3
    800057b8:	00c50513          	addi	a0,a0,12 # 800087c0 <syscalls+0x410>
    800057bc:	00001097          	auipc	ra,0x1
    800057c0:	832080e7          	jalr	-1998(ra) # 80005fee <panic>
    panic("virtio disk max queue too short");
    800057c4:	00003517          	auipc	a0,0x3
    800057c8:	01c50513          	addi	a0,a0,28 # 800087e0 <syscalls+0x430>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	822080e7          	jalr	-2014(ra) # 80005fee <panic>
    panic("virtio disk kalloc");
    800057d4:	00003517          	auipc	a0,0x3
    800057d8:	02c50513          	addi	a0,a0,44 # 80008800 <syscalls+0x450>
    800057dc:	00001097          	auipc	ra,0x1
    800057e0:	812080e7          	jalr	-2030(ra) # 80005fee <panic>

00000000800057e4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057e4:	7119                	addi	sp,sp,-128
    800057e6:	fc86                	sd	ra,120(sp)
    800057e8:	f8a2                	sd	s0,112(sp)
    800057ea:	f4a6                	sd	s1,104(sp)
    800057ec:	f0ca                	sd	s2,96(sp)
    800057ee:	ecce                	sd	s3,88(sp)
    800057f0:	e8d2                	sd	s4,80(sp)
    800057f2:	e4d6                	sd	s5,72(sp)
    800057f4:	e0da                	sd	s6,64(sp)
    800057f6:	fc5e                	sd	s7,56(sp)
    800057f8:	f862                	sd	s8,48(sp)
    800057fa:	f466                	sd	s9,40(sp)
    800057fc:	f06a                	sd	s10,32(sp)
    800057fe:	ec6e                	sd	s11,24(sp)
    80005800:	0100                	addi	s0,sp,128
    80005802:	8aaa                	mv	s5,a0
    80005804:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005806:	00c52d03          	lw	s10,12(a0)
    8000580a:	001d1d1b          	slliw	s10,s10,0x1
    8000580e:	1d02                	slli	s10,s10,0x20
    80005810:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005814:	00020517          	auipc	a0,0x20
    80005818:	33450513          	addi	a0,a0,820 # 80025b48 <disk+0x128>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	d0e080e7          	jalr	-754(ra) # 8000652a <acquire>
  for(int i = 0; i < 3; i++){
    80005824:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005826:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005828:	00020b97          	auipc	s7,0x20
    8000582c:	1f8b8b93          	addi	s7,s7,504 # 80025a20 <disk>
  for(int i = 0; i < 3; i++){
    80005830:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005832:	00020c97          	auipc	s9,0x20
    80005836:	316c8c93          	addi	s9,s9,790 # 80025b48 <disk+0x128>
    8000583a:	a08d                	j	8000589c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000583c:	00fb8733          	add	a4,s7,a5
    80005840:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005844:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005846:	0207c563          	bltz	a5,80005870 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000584a:	2905                	addiw	s2,s2,1
    8000584c:	0611                	addi	a2,a2,4
    8000584e:	05690c63          	beq	s2,s6,800058a6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005852:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005854:	00020717          	auipc	a4,0x20
    80005858:	1cc70713          	addi	a4,a4,460 # 80025a20 <disk>
    8000585c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000585e:	01874683          	lbu	a3,24(a4)
    80005862:	fee9                	bnez	a3,8000583c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005864:	2785                	addiw	a5,a5,1
    80005866:	0705                	addi	a4,a4,1
    80005868:	fe979be3          	bne	a5,s1,8000585e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000586c:	57fd                	li	a5,-1
    8000586e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005870:	01205d63          	blez	s2,8000588a <virtio_disk_rw+0xa6>
    80005874:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005876:	000a2503          	lw	a0,0(s4)
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	cfc080e7          	jalr	-772(ra) # 80005576 <free_desc>
      for(int j = 0; j < i; j++)
    80005882:	2d85                	addiw	s11,s11,1
    80005884:	0a11                	addi	s4,s4,4
    80005886:	ffb918e3          	bne	s2,s11,80005876 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000588a:	85e6                	mv	a1,s9
    8000588c:	00020517          	auipc	a0,0x20
    80005890:	1ac50513          	addi	a0,a0,428 # 80025a38 <disk+0x18>
    80005894:	ffffc097          	auipc	ra,0xffffc
    80005898:	c4c080e7          	jalr	-948(ra) # 800014e0 <sleep>
  for(int i = 0; i < 3; i++){
    8000589c:	f8040a13          	addi	s4,s0,-128
{
    800058a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800058a2:	894e                	mv	s2,s3
    800058a4:	b77d                	j	80005852 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058a6:	f8042583          	lw	a1,-128(s0)
    800058aa:	00a58793          	addi	a5,a1,10
    800058ae:	0792                	slli	a5,a5,0x4

  if(write)
    800058b0:	00020617          	auipc	a2,0x20
    800058b4:	17060613          	addi	a2,a2,368 # 80025a20 <disk>
    800058b8:	00f60733          	add	a4,a2,a5
    800058bc:	018036b3          	snez	a3,s8
    800058c0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058c6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058ca:	f6078693          	addi	a3,a5,-160
    800058ce:	6218                	ld	a4,0(a2)
    800058d0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058d2:	00878513          	addi	a0,a5,8
    800058d6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058d8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058da:	6208                	ld	a0,0(a2)
    800058dc:	96aa                	add	a3,a3,a0
    800058de:	4741                	li	a4,16
    800058e0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058e2:	4705                	li	a4,1
    800058e4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800058e8:	f8442703          	lw	a4,-124(s0)
    800058ec:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058f0:	0712                	slli	a4,a4,0x4
    800058f2:	953a                	add	a0,a0,a4
    800058f4:	058a8693          	addi	a3,s5,88
    800058f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800058fa:	6208                	ld	a0,0(a2)
    800058fc:	972a                	add	a4,a4,a0
    800058fe:	40000693          	li	a3,1024
    80005902:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005904:	001c3c13          	seqz	s8,s8
    80005908:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000590a:	001c6c13          	ori	s8,s8,1
    8000590e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005912:	f8842603          	lw	a2,-120(s0)
    80005916:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000591a:	00020697          	auipc	a3,0x20
    8000591e:	10668693          	addi	a3,a3,262 # 80025a20 <disk>
    80005922:	00258713          	addi	a4,a1,2
    80005926:	0712                	slli	a4,a4,0x4
    80005928:	9736                	add	a4,a4,a3
    8000592a:	587d                	li	a6,-1
    8000592c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005930:	0612                	slli	a2,a2,0x4
    80005932:	9532                	add	a0,a0,a2
    80005934:	f9078793          	addi	a5,a5,-112
    80005938:	97b6                	add	a5,a5,a3
    8000593a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000593c:	629c                	ld	a5,0(a3)
    8000593e:	97b2                	add	a5,a5,a2
    80005940:	4605                	li	a2,1
    80005942:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005944:	4509                	li	a0,2
    80005946:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000594a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000594e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005952:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005956:	6698                	ld	a4,8(a3)
    80005958:	00275783          	lhu	a5,2(a4)
    8000595c:	8b9d                	andi	a5,a5,7
    8000595e:	0786                	slli	a5,a5,0x1
    80005960:	97ba                	add	a5,a5,a4
    80005962:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005966:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000596a:	6698                	ld	a4,8(a3)
    8000596c:	00275783          	lhu	a5,2(a4)
    80005970:	2785                	addiw	a5,a5,1
    80005972:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005976:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000597a:	100017b7          	lui	a5,0x10001
    8000597e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005982:	004aa783          	lw	a5,4(s5)
    80005986:	02c79163          	bne	a5,a2,800059a8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000598a:	00020917          	auipc	s2,0x20
    8000598e:	1be90913          	addi	s2,s2,446 # 80025b48 <disk+0x128>
  while(b->disk == 1) {
    80005992:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005994:	85ca                	mv	a1,s2
    80005996:	8556                	mv	a0,s5
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	b48080e7          	jalr	-1208(ra) # 800014e0 <sleep>
  while(b->disk == 1) {
    800059a0:	004aa783          	lw	a5,4(s5)
    800059a4:	fe9788e3          	beq	a5,s1,80005994 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800059a8:	f8042903          	lw	s2,-128(s0)
    800059ac:	00290793          	addi	a5,s2,2
    800059b0:	00479713          	slli	a4,a5,0x4
    800059b4:	00020797          	auipc	a5,0x20
    800059b8:	06c78793          	addi	a5,a5,108 # 80025a20 <disk>
    800059bc:	97ba                	add	a5,a5,a4
    800059be:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059c2:	00020997          	auipc	s3,0x20
    800059c6:	05e98993          	addi	s3,s3,94 # 80025a20 <disk>
    800059ca:	00491713          	slli	a4,s2,0x4
    800059ce:	0009b783          	ld	a5,0(s3)
    800059d2:	97ba                	add	a5,a5,a4
    800059d4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059d8:	854a                	mv	a0,s2
    800059da:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	b98080e7          	jalr	-1128(ra) # 80005576 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059e6:	8885                	andi	s1,s1,1
    800059e8:	f0ed                	bnez	s1,800059ca <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059ea:	00020517          	auipc	a0,0x20
    800059ee:	15e50513          	addi	a0,a0,350 # 80025b48 <disk+0x128>
    800059f2:	00001097          	auipc	ra,0x1
    800059f6:	bec080e7          	jalr	-1044(ra) # 800065de <release>
}
    800059fa:	70e6                	ld	ra,120(sp)
    800059fc:	7446                	ld	s0,112(sp)
    800059fe:	74a6                	ld	s1,104(sp)
    80005a00:	7906                	ld	s2,96(sp)
    80005a02:	69e6                	ld	s3,88(sp)
    80005a04:	6a46                	ld	s4,80(sp)
    80005a06:	6aa6                	ld	s5,72(sp)
    80005a08:	6b06                	ld	s6,64(sp)
    80005a0a:	7be2                	ld	s7,56(sp)
    80005a0c:	7c42                	ld	s8,48(sp)
    80005a0e:	7ca2                	ld	s9,40(sp)
    80005a10:	7d02                	ld	s10,32(sp)
    80005a12:	6de2                	ld	s11,24(sp)
    80005a14:	6109                	addi	sp,sp,128
    80005a16:	8082                	ret

0000000080005a18 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	e426                	sd	s1,8(sp)
    80005a20:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a22:	00020497          	auipc	s1,0x20
    80005a26:	ffe48493          	addi	s1,s1,-2 # 80025a20 <disk>
    80005a2a:	00020517          	auipc	a0,0x20
    80005a2e:	11e50513          	addi	a0,a0,286 # 80025b48 <disk+0x128>
    80005a32:	00001097          	auipc	ra,0x1
    80005a36:	af8080e7          	jalr	-1288(ra) # 8000652a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a3a:	10001737          	lui	a4,0x10001
    80005a3e:	533c                	lw	a5,96(a4)
    80005a40:	8b8d                	andi	a5,a5,3
    80005a42:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a44:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a48:	689c                	ld	a5,16(s1)
    80005a4a:	0204d703          	lhu	a4,32(s1)
    80005a4e:	0027d783          	lhu	a5,2(a5)
    80005a52:	04f70863          	beq	a4,a5,80005aa2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a56:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a5a:	6898                	ld	a4,16(s1)
    80005a5c:	0204d783          	lhu	a5,32(s1)
    80005a60:	8b9d                	andi	a5,a5,7
    80005a62:	078e                	slli	a5,a5,0x3
    80005a64:	97ba                	add	a5,a5,a4
    80005a66:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a68:	00278713          	addi	a4,a5,2
    80005a6c:	0712                	slli	a4,a4,0x4
    80005a6e:	9726                	add	a4,a4,s1
    80005a70:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a74:	e721                	bnez	a4,80005abc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a76:	0789                	addi	a5,a5,2
    80005a78:	0792                	slli	a5,a5,0x4
    80005a7a:	97a6                	add	a5,a5,s1
    80005a7c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a7e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a82:	ffffc097          	auipc	ra,0xffffc
    80005a86:	ac2080e7          	jalr	-1342(ra) # 80001544 <wakeup>

    disk.used_idx += 1;
    80005a8a:	0204d783          	lhu	a5,32(s1)
    80005a8e:	2785                	addiw	a5,a5,1
    80005a90:	17c2                	slli	a5,a5,0x30
    80005a92:	93c1                	srli	a5,a5,0x30
    80005a94:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a98:	6898                	ld	a4,16(s1)
    80005a9a:	00275703          	lhu	a4,2(a4)
    80005a9e:	faf71ce3          	bne	a4,a5,80005a56 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005aa2:	00020517          	auipc	a0,0x20
    80005aa6:	0a650513          	addi	a0,a0,166 # 80025b48 <disk+0x128>
    80005aaa:	00001097          	auipc	ra,0x1
    80005aae:	b34080e7          	jalr	-1228(ra) # 800065de <release>
}
    80005ab2:	60e2                	ld	ra,24(sp)
    80005ab4:	6442                	ld	s0,16(sp)
    80005ab6:	64a2                	ld	s1,8(sp)
    80005ab8:	6105                	addi	sp,sp,32
    80005aba:	8082                	ret
      panic("virtio_disk_intr status");
    80005abc:	00003517          	auipc	a0,0x3
    80005ac0:	d5c50513          	addi	a0,a0,-676 # 80008818 <syscalls+0x468>
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	52a080e7          	jalr	1322(ra) # 80005fee <panic>

0000000080005acc <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005acc:	1141                	addi	sp,sp,-16
    80005ace:	e422                	sd	s0,8(sp)
    80005ad0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ad2:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ad6:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005ada:	0037979b          	slliw	a5,a5,0x3
    80005ade:	02004737          	lui	a4,0x2004
    80005ae2:	97ba                	add	a5,a5,a4
    80005ae4:	0200c737          	lui	a4,0x200c
    80005ae8:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005aec:	000f4637          	lui	a2,0xf4
    80005af0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005af4:	95b2                	add	a1,a1,a2
    80005af6:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005af8:	00269713          	slli	a4,a3,0x2
    80005afc:	9736                	add	a4,a4,a3
    80005afe:	00371693          	slli	a3,a4,0x3
    80005b02:	00020717          	auipc	a4,0x20
    80005b06:	05e70713          	addi	a4,a4,94 # 80025b60 <timer_scratch>
    80005b0a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b0c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b0e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b10:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b14:	00000797          	auipc	a5,0x0
    80005b18:	99c78793          	addi	a5,a5,-1636 # 800054b0 <timervec>
    80005b1c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b20:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b24:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b28:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b2c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b30:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b34:	30479073          	csrw	mie,a5
}
    80005b38:	6422                	ld	s0,8(sp)
    80005b3a:	0141                	addi	sp,sp,16
    80005b3c:	8082                	ret

0000000080005b3e <start>:
{
    80005b3e:	1141                	addi	sp,sp,-16
    80005b40:	e406                	sd	ra,8(sp)
    80005b42:	e022                	sd	s0,0(sp)
    80005b44:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b46:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b4a:	7779                	lui	a4,0xffffe
    80005b4c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0a5f>
    80005b50:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b52:	6705                	lui	a4,0x1
    80005b54:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b58:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b5a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b5e:	ffffa797          	auipc	a5,0xffffa
    80005b62:	7c078793          	addi	a5,a5,1984 # 8000031e <main>
    80005b66:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b6a:	4781                	li	a5,0
    80005b6c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b70:	67c1                	lui	a5,0x10
    80005b72:	17fd                	addi	a5,a5,-1
    80005b74:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b78:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b7c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b80:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b84:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b88:	57fd                	li	a5,-1
    80005b8a:	83a9                	srli	a5,a5,0xa
    80005b8c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b90:	47bd                	li	a5,15
    80005b92:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	f36080e7          	jalr	-202(ra) # 80005acc <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b9e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ba2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ba4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ba6:	30200073          	mret
}
    80005baa:	60a2                	ld	ra,8(sp)
    80005bac:	6402                	ld	s0,0(sp)
    80005bae:	0141                	addi	sp,sp,16
    80005bb0:	8082                	ret

0000000080005bb2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bb2:	715d                	addi	sp,sp,-80
    80005bb4:	e486                	sd	ra,72(sp)
    80005bb6:	e0a2                	sd	s0,64(sp)
    80005bb8:	fc26                	sd	s1,56(sp)
    80005bba:	f84a                	sd	s2,48(sp)
    80005bbc:	f44e                	sd	s3,40(sp)
    80005bbe:	f052                	sd	s4,32(sp)
    80005bc0:	ec56                	sd	s5,24(sp)
    80005bc2:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bc4:	04c05663          	blez	a2,80005c10 <consolewrite+0x5e>
    80005bc8:	8a2a                	mv	s4,a0
    80005bca:	84ae                	mv	s1,a1
    80005bcc:	89b2                	mv	s3,a2
    80005bce:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005bd0:	5afd                	li	s5,-1
    80005bd2:	4685                	li	a3,1
    80005bd4:	8626                	mv	a2,s1
    80005bd6:	85d2                	mv	a1,s4
    80005bd8:	fbf40513          	addi	a0,s0,-65
    80005bdc:	ffffc097          	auipc	ra,0xffffc
    80005be0:	d62080e7          	jalr	-670(ra) # 8000193e <either_copyin>
    80005be4:	01550c63          	beq	a0,s5,80005bfc <consolewrite+0x4a>
      break;
    uartputc(c);
    80005be8:	fbf44503          	lbu	a0,-65(s0)
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	780080e7          	jalr	1920(ra) # 8000636c <uartputc>
  for(i = 0; i < n; i++){
    80005bf4:	2905                	addiw	s2,s2,1
    80005bf6:	0485                	addi	s1,s1,1
    80005bf8:	fd299de3          	bne	s3,s2,80005bd2 <consolewrite+0x20>
  }

  return i;
}
    80005bfc:	854a                	mv	a0,s2
    80005bfe:	60a6                	ld	ra,72(sp)
    80005c00:	6406                	ld	s0,64(sp)
    80005c02:	74e2                	ld	s1,56(sp)
    80005c04:	7942                	ld	s2,48(sp)
    80005c06:	79a2                	ld	s3,40(sp)
    80005c08:	7a02                	ld	s4,32(sp)
    80005c0a:	6ae2                	ld	s5,24(sp)
    80005c0c:	6161                	addi	sp,sp,80
    80005c0e:	8082                	ret
  for(i = 0; i < n; i++){
    80005c10:	4901                	li	s2,0
    80005c12:	b7ed                	j	80005bfc <consolewrite+0x4a>

0000000080005c14 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c14:	7159                	addi	sp,sp,-112
    80005c16:	f486                	sd	ra,104(sp)
    80005c18:	f0a2                	sd	s0,96(sp)
    80005c1a:	eca6                	sd	s1,88(sp)
    80005c1c:	e8ca                	sd	s2,80(sp)
    80005c1e:	e4ce                	sd	s3,72(sp)
    80005c20:	e0d2                	sd	s4,64(sp)
    80005c22:	fc56                	sd	s5,56(sp)
    80005c24:	f85a                	sd	s6,48(sp)
    80005c26:	f45e                	sd	s7,40(sp)
    80005c28:	f062                	sd	s8,32(sp)
    80005c2a:	ec66                	sd	s9,24(sp)
    80005c2c:	e86a                	sd	s10,16(sp)
    80005c2e:	1880                	addi	s0,sp,112
    80005c30:	8aaa                	mv	s5,a0
    80005c32:	8a2e                	mv	s4,a1
    80005c34:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c36:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c3a:	00028517          	auipc	a0,0x28
    80005c3e:	06650513          	addi	a0,a0,102 # 8002dca0 <cons>
    80005c42:	00001097          	auipc	ra,0x1
    80005c46:	8e8080e7          	jalr	-1816(ra) # 8000652a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c4a:	00028497          	auipc	s1,0x28
    80005c4e:	05648493          	addi	s1,s1,86 # 8002dca0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c52:	00028917          	auipc	s2,0x28
    80005c56:	0e690913          	addi	s2,s2,230 # 8002dd38 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c5a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c5c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c5e:	4ca9                	li	s9,10
  while(n > 0){
    80005c60:	07305b63          	blez	s3,80005cd6 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005c64:	0984a783          	lw	a5,152(s1)
    80005c68:	09c4a703          	lw	a4,156(s1)
    80005c6c:	02f71763          	bne	a4,a5,80005c9a <consoleread+0x86>
      if(killed(myproc())){
    80005c70:	ffffb097          	auipc	ra,0xffffb
    80005c74:	1c8080e7          	jalr	456(ra) # 80000e38 <myproc>
    80005c78:	ffffc097          	auipc	ra,0xffffc
    80005c7c:	b10080e7          	jalr	-1264(ra) # 80001788 <killed>
    80005c80:	e535                	bnez	a0,80005cec <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005c82:	85a6                	mv	a1,s1
    80005c84:	854a                	mv	a0,s2
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	85a080e7          	jalr	-1958(ra) # 800014e0 <sleep>
    while(cons.r == cons.w){
    80005c8e:	0984a783          	lw	a5,152(s1)
    80005c92:	09c4a703          	lw	a4,156(s1)
    80005c96:	fcf70de3          	beq	a4,a5,80005c70 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c9a:	0017871b          	addiw	a4,a5,1
    80005c9e:	08e4ac23          	sw	a4,152(s1)
    80005ca2:	07f7f713          	andi	a4,a5,127
    80005ca6:	9726                	add	a4,a4,s1
    80005ca8:	01874703          	lbu	a4,24(a4)
    80005cac:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005cb0:	077d0563          	beq	s10,s7,80005d1a <consoleread+0x106>
    cbuf = c;
    80005cb4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cb8:	4685                	li	a3,1
    80005cba:	f9f40613          	addi	a2,s0,-97
    80005cbe:	85d2                	mv	a1,s4
    80005cc0:	8556                	mv	a0,s5
    80005cc2:	ffffc097          	auipc	ra,0xffffc
    80005cc6:	c26080e7          	jalr	-986(ra) # 800018e8 <either_copyout>
    80005cca:	01850663          	beq	a0,s8,80005cd6 <consoleread+0xc2>
    dst++;
    80005cce:	0a05                	addi	s4,s4,1
    --n;
    80005cd0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005cd2:	f99d17e3          	bne	s10,s9,80005c60 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005cd6:	00028517          	auipc	a0,0x28
    80005cda:	fca50513          	addi	a0,a0,-54 # 8002dca0 <cons>
    80005cde:	00001097          	auipc	ra,0x1
    80005ce2:	900080e7          	jalr	-1792(ra) # 800065de <release>

  return target - n;
    80005ce6:	413b053b          	subw	a0,s6,s3
    80005cea:	a811                	j	80005cfe <consoleread+0xea>
        release(&cons.lock);
    80005cec:	00028517          	auipc	a0,0x28
    80005cf0:	fb450513          	addi	a0,a0,-76 # 8002dca0 <cons>
    80005cf4:	00001097          	auipc	ra,0x1
    80005cf8:	8ea080e7          	jalr	-1814(ra) # 800065de <release>
        return -1;
    80005cfc:	557d                	li	a0,-1
}
    80005cfe:	70a6                	ld	ra,104(sp)
    80005d00:	7406                	ld	s0,96(sp)
    80005d02:	64e6                	ld	s1,88(sp)
    80005d04:	6946                	ld	s2,80(sp)
    80005d06:	69a6                	ld	s3,72(sp)
    80005d08:	6a06                	ld	s4,64(sp)
    80005d0a:	7ae2                	ld	s5,56(sp)
    80005d0c:	7b42                	ld	s6,48(sp)
    80005d0e:	7ba2                	ld	s7,40(sp)
    80005d10:	7c02                	ld	s8,32(sp)
    80005d12:	6ce2                	ld	s9,24(sp)
    80005d14:	6d42                	ld	s10,16(sp)
    80005d16:	6165                	addi	sp,sp,112
    80005d18:	8082                	ret
      if(n < target){
    80005d1a:	0009871b          	sext.w	a4,s3
    80005d1e:	fb677ce3          	bgeu	a4,s6,80005cd6 <consoleread+0xc2>
        cons.r--;
    80005d22:	00028717          	auipc	a4,0x28
    80005d26:	00f72b23          	sw	a5,22(a4) # 8002dd38 <cons+0x98>
    80005d2a:	b775                	j	80005cd6 <consoleread+0xc2>

0000000080005d2c <consputc>:
{
    80005d2c:	1141                	addi	sp,sp,-16
    80005d2e:	e406                	sd	ra,8(sp)
    80005d30:	e022                	sd	s0,0(sp)
    80005d32:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d34:	10000793          	li	a5,256
    80005d38:	00f50a63          	beq	a0,a5,80005d4c <consputc+0x20>
    uartputc_sync(c);
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	55e080e7          	jalr	1374(ra) # 8000629a <uartputc_sync>
}
    80005d44:	60a2                	ld	ra,8(sp)
    80005d46:	6402                	ld	s0,0(sp)
    80005d48:	0141                	addi	sp,sp,16
    80005d4a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d4c:	4521                	li	a0,8
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	54c080e7          	jalr	1356(ra) # 8000629a <uartputc_sync>
    80005d56:	02000513          	li	a0,32
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	540080e7          	jalr	1344(ra) # 8000629a <uartputc_sync>
    80005d62:	4521                	li	a0,8
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	536080e7          	jalr	1334(ra) # 8000629a <uartputc_sync>
    80005d6c:	bfe1                	j	80005d44 <consputc+0x18>

0000000080005d6e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d6e:	1101                	addi	sp,sp,-32
    80005d70:	ec06                	sd	ra,24(sp)
    80005d72:	e822                	sd	s0,16(sp)
    80005d74:	e426                	sd	s1,8(sp)
    80005d76:	e04a                	sd	s2,0(sp)
    80005d78:	1000                	addi	s0,sp,32
    80005d7a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d7c:	00028517          	auipc	a0,0x28
    80005d80:	f2450513          	addi	a0,a0,-220 # 8002dca0 <cons>
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	7a6080e7          	jalr	1958(ra) # 8000652a <acquire>

  switch(c){
    80005d8c:	47d5                	li	a5,21
    80005d8e:	0af48663          	beq	s1,a5,80005e3a <consoleintr+0xcc>
    80005d92:	0297ca63          	blt	a5,s1,80005dc6 <consoleintr+0x58>
    80005d96:	47a1                	li	a5,8
    80005d98:	0ef48763          	beq	s1,a5,80005e86 <consoleintr+0x118>
    80005d9c:	47c1                	li	a5,16
    80005d9e:	10f49a63          	bne	s1,a5,80005eb2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	bf2080e7          	jalr	-1038(ra) # 80001994 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005daa:	00028517          	auipc	a0,0x28
    80005dae:	ef650513          	addi	a0,a0,-266 # 8002dca0 <cons>
    80005db2:	00001097          	auipc	ra,0x1
    80005db6:	82c080e7          	jalr	-2004(ra) # 800065de <release>
}
    80005dba:	60e2                	ld	ra,24(sp)
    80005dbc:	6442                	ld	s0,16(sp)
    80005dbe:	64a2                	ld	s1,8(sp)
    80005dc0:	6902                	ld	s2,0(sp)
    80005dc2:	6105                	addi	sp,sp,32
    80005dc4:	8082                	ret
  switch(c){
    80005dc6:	07f00793          	li	a5,127
    80005dca:	0af48e63          	beq	s1,a5,80005e86 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005dce:	00028717          	auipc	a4,0x28
    80005dd2:	ed270713          	addi	a4,a4,-302 # 8002dca0 <cons>
    80005dd6:	0a072783          	lw	a5,160(a4)
    80005dda:	09872703          	lw	a4,152(a4)
    80005dde:	9f99                	subw	a5,a5,a4
    80005de0:	07f00713          	li	a4,127
    80005de4:	fcf763e3          	bltu	a4,a5,80005daa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005de8:	47b5                	li	a5,13
    80005dea:	0cf48763          	beq	s1,a5,80005eb8 <consoleintr+0x14a>
      consputc(c);
    80005dee:	8526                	mv	a0,s1
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	f3c080e7          	jalr	-196(ra) # 80005d2c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005df8:	00028797          	auipc	a5,0x28
    80005dfc:	ea878793          	addi	a5,a5,-344 # 8002dca0 <cons>
    80005e00:	0a07a683          	lw	a3,160(a5)
    80005e04:	0016871b          	addiw	a4,a3,1
    80005e08:	0007061b          	sext.w	a2,a4
    80005e0c:	0ae7a023          	sw	a4,160(a5)
    80005e10:	07f6f693          	andi	a3,a3,127
    80005e14:	97b6                	add	a5,a5,a3
    80005e16:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e1a:	47a9                	li	a5,10
    80005e1c:	0cf48563          	beq	s1,a5,80005ee6 <consoleintr+0x178>
    80005e20:	4791                	li	a5,4
    80005e22:	0cf48263          	beq	s1,a5,80005ee6 <consoleintr+0x178>
    80005e26:	00028797          	auipc	a5,0x28
    80005e2a:	f127a783          	lw	a5,-238(a5) # 8002dd38 <cons+0x98>
    80005e2e:	9f1d                	subw	a4,a4,a5
    80005e30:	08000793          	li	a5,128
    80005e34:	f6f71be3          	bne	a4,a5,80005daa <consoleintr+0x3c>
    80005e38:	a07d                	j	80005ee6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e3a:	00028717          	auipc	a4,0x28
    80005e3e:	e6670713          	addi	a4,a4,-410 # 8002dca0 <cons>
    80005e42:	0a072783          	lw	a5,160(a4)
    80005e46:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e4a:	00028497          	auipc	s1,0x28
    80005e4e:	e5648493          	addi	s1,s1,-426 # 8002dca0 <cons>
    while(cons.e != cons.w &&
    80005e52:	4929                	li	s2,10
    80005e54:	f4f70be3          	beq	a4,a5,80005daa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e58:	37fd                	addiw	a5,a5,-1
    80005e5a:	07f7f713          	andi	a4,a5,127
    80005e5e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e60:	01874703          	lbu	a4,24(a4)
    80005e64:	f52703e3          	beq	a4,s2,80005daa <consoleintr+0x3c>
      cons.e--;
    80005e68:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e6c:	10000513          	li	a0,256
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	ebc080e7          	jalr	-324(ra) # 80005d2c <consputc>
    while(cons.e != cons.w &&
    80005e78:	0a04a783          	lw	a5,160(s1)
    80005e7c:	09c4a703          	lw	a4,156(s1)
    80005e80:	fcf71ce3          	bne	a4,a5,80005e58 <consoleintr+0xea>
    80005e84:	b71d                	j	80005daa <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e86:	00028717          	auipc	a4,0x28
    80005e8a:	e1a70713          	addi	a4,a4,-486 # 8002dca0 <cons>
    80005e8e:	0a072783          	lw	a5,160(a4)
    80005e92:	09c72703          	lw	a4,156(a4)
    80005e96:	f0f70ae3          	beq	a4,a5,80005daa <consoleintr+0x3c>
      cons.e--;
    80005e9a:	37fd                	addiw	a5,a5,-1
    80005e9c:	00028717          	auipc	a4,0x28
    80005ea0:	eaf72223          	sw	a5,-348(a4) # 8002dd40 <cons+0xa0>
      consputc(BACKSPACE);
    80005ea4:	10000513          	li	a0,256
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	e84080e7          	jalr	-380(ra) # 80005d2c <consputc>
    80005eb0:	bded                	j	80005daa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005eb2:	ee048ce3          	beqz	s1,80005daa <consoleintr+0x3c>
    80005eb6:	bf21                	j	80005dce <consoleintr+0x60>
      consputc(c);
    80005eb8:	4529                	li	a0,10
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	e72080e7          	jalr	-398(ra) # 80005d2c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ec2:	00028797          	auipc	a5,0x28
    80005ec6:	dde78793          	addi	a5,a5,-546 # 8002dca0 <cons>
    80005eca:	0a07a703          	lw	a4,160(a5)
    80005ece:	0017069b          	addiw	a3,a4,1
    80005ed2:	0006861b          	sext.w	a2,a3
    80005ed6:	0ad7a023          	sw	a3,160(a5)
    80005eda:	07f77713          	andi	a4,a4,127
    80005ede:	97ba                	add	a5,a5,a4
    80005ee0:	4729                	li	a4,10
    80005ee2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ee6:	00028797          	auipc	a5,0x28
    80005eea:	e4c7ab23          	sw	a2,-426(a5) # 8002dd3c <cons+0x9c>
        wakeup(&cons.r);
    80005eee:	00028517          	auipc	a0,0x28
    80005ef2:	e4a50513          	addi	a0,a0,-438 # 8002dd38 <cons+0x98>
    80005ef6:	ffffb097          	auipc	ra,0xffffb
    80005efa:	64e080e7          	jalr	1614(ra) # 80001544 <wakeup>
    80005efe:	b575                	j	80005daa <consoleintr+0x3c>

0000000080005f00 <consoleinit>:

void
consoleinit(void)
{
    80005f00:	1141                	addi	sp,sp,-16
    80005f02:	e406                	sd	ra,8(sp)
    80005f04:	e022                	sd	s0,0(sp)
    80005f06:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f08:	00003597          	auipc	a1,0x3
    80005f0c:	92858593          	addi	a1,a1,-1752 # 80008830 <syscalls+0x480>
    80005f10:	00028517          	auipc	a0,0x28
    80005f14:	d9050513          	addi	a0,a0,-624 # 8002dca0 <cons>
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	582080e7          	jalr	1410(ra) # 8000649a <initlock>

  uartinit();
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	32a080e7          	jalr	810(ra) # 8000624a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f28:	0001f797          	auipc	a5,0x1f
    80005f2c:	aa078793          	addi	a5,a5,-1376 # 800249c8 <devsw>
    80005f30:	00000717          	auipc	a4,0x0
    80005f34:	ce470713          	addi	a4,a4,-796 # 80005c14 <consoleread>
    80005f38:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f3a:	00000717          	auipc	a4,0x0
    80005f3e:	c7870713          	addi	a4,a4,-904 # 80005bb2 <consolewrite>
    80005f42:	ef98                	sd	a4,24(a5)
}
    80005f44:	60a2                	ld	ra,8(sp)
    80005f46:	6402                	ld	s0,0(sp)
    80005f48:	0141                	addi	sp,sp,16
    80005f4a:	8082                	ret

0000000080005f4c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f4c:	7179                	addi	sp,sp,-48
    80005f4e:	f406                	sd	ra,40(sp)
    80005f50:	f022                	sd	s0,32(sp)
    80005f52:	ec26                	sd	s1,24(sp)
    80005f54:	e84a                	sd	s2,16(sp)
    80005f56:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f58:	c219                	beqz	a2,80005f5e <printint+0x12>
    80005f5a:	08054663          	bltz	a0,80005fe6 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f5e:	2501                	sext.w	a0,a0
    80005f60:	4881                	li	a7,0
    80005f62:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f66:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f68:	2581                	sext.w	a1,a1
    80005f6a:	00003617          	auipc	a2,0x3
    80005f6e:	8f660613          	addi	a2,a2,-1802 # 80008860 <digits>
    80005f72:	883a                	mv	a6,a4
    80005f74:	2705                	addiw	a4,a4,1
    80005f76:	02b577bb          	remuw	a5,a0,a1
    80005f7a:	1782                	slli	a5,a5,0x20
    80005f7c:	9381                	srli	a5,a5,0x20
    80005f7e:	97b2                	add	a5,a5,a2
    80005f80:	0007c783          	lbu	a5,0(a5)
    80005f84:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f88:	0005079b          	sext.w	a5,a0
    80005f8c:	02b5553b          	divuw	a0,a0,a1
    80005f90:	0685                	addi	a3,a3,1
    80005f92:	feb7f0e3          	bgeu	a5,a1,80005f72 <printint+0x26>

  if(sign)
    80005f96:	00088b63          	beqz	a7,80005fac <printint+0x60>
    buf[i++] = '-';
    80005f9a:	fe040793          	addi	a5,s0,-32
    80005f9e:	973e                	add	a4,a4,a5
    80005fa0:	02d00793          	li	a5,45
    80005fa4:	fef70823          	sb	a5,-16(a4)
    80005fa8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fac:	02e05763          	blez	a4,80005fda <printint+0x8e>
    80005fb0:	fd040793          	addi	a5,s0,-48
    80005fb4:	00e784b3          	add	s1,a5,a4
    80005fb8:	fff78913          	addi	s2,a5,-1
    80005fbc:	993a                	add	s2,s2,a4
    80005fbe:	377d                	addiw	a4,a4,-1
    80005fc0:	1702                	slli	a4,a4,0x20
    80005fc2:	9301                	srli	a4,a4,0x20
    80005fc4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fc8:	fff4c503          	lbu	a0,-1(s1)
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	d60080e7          	jalr	-672(ra) # 80005d2c <consputc>
  while(--i >= 0)
    80005fd4:	14fd                	addi	s1,s1,-1
    80005fd6:	ff2499e3          	bne	s1,s2,80005fc8 <printint+0x7c>
}
    80005fda:	70a2                	ld	ra,40(sp)
    80005fdc:	7402                	ld	s0,32(sp)
    80005fde:	64e2                	ld	s1,24(sp)
    80005fe0:	6942                	ld	s2,16(sp)
    80005fe2:	6145                	addi	sp,sp,48
    80005fe4:	8082                	ret
    x = -xx;
    80005fe6:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fea:	4885                	li	a7,1
    x = -xx;
    80005fec:	bf9d                	j	80005f62 <printint+0x16>

0000000080005fee <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fee:	1101                	addi	sp,sp,-32
    80005ff0:	ec06                	sd	ra,24(sp)
    80005ff2:	e822                	sd	s0,16(sp)
    80005ff4:	e426                	sd	s1,8(sp)
    80005ff6:	1000                	addi	s0,sp,32
    80005ff8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ffa:	00028797          	auipc	a5,0x28
    80005ffe:	d607a323          	sw	zero,-666(a5) # 8002dd60 <pr+0x18>
  printf("panic: ");
    80006002:	00003517          	auipc	a0,0x3
    80006006:	83650513          	addi	a0,a0,-1994 # 80008838 <syscalls+0x488>
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	02e080e7          	jalr	46(ra) # 80006038 <printf>
  printf(s);
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	024080e7          	jalr	36(ra) # 80006038 <printf>
  printf("\n");
    8000601c:	00002517          	auipc	a0,0x2
    80006020:	02c50513          	addi	a0,a0,44 # 80008048 <etext+0x48>
    80006024:	00000097          	auipc	ra,0x0
    80006028:	014080e7          	jalr	20(ra) # 80006038 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000602c:	4785                	li	a5,1
    8000602e:	00003717          	auipc	a4,0x3
    80006032:	8ef72723          	sw	a5,-1810(a4) # 8000891c <panicked>
  for(;;)
    80006036:	a001                	j	80006036 <panic+0x48>

0000000080006038 <printf>:
{
    80006038:	7131                	addi	sp,sp,-192
    8000603a:	fc86                	sd	ra,120(sp)
    8000603c:	f8a2                	sd	s0,112(sp)
    8000603e:	f4a6                	sd	s1,104(sp)
    80006040:	f0ca                	sd	s2,96(sp)
    80006042:	ecce                	sd	s3,88(sp)
    80006044:	e8d2                	sd	s4,80(sp)
    80006046:	e4d6                	sd	s5,72(sp)
    80006048:	e0da                	sd	s6,64(sp)
    8000604a:	fc5e                	sd	s7,56(sp)
    8000604c:	f862                	sd	s8,48(sp)
    8000604e:	f466                	sd	s9,40(sp)
    80006050:	f06a                	sd	s10,32(sp)
    80006052:	ec6e                	sd	s11,24(sp)
    80006054:	0100                	addi	s0,sp,128
    80006056:	8a2a                	mv	s4,a0
    80006058:	e40c                	sd	a1,8(s0)
    8000605a:	e810                	sd	a2,16(s0)
    8000605c:	ec14                	sd	a3,24(s0)
    8000605e:	f018                	sd	a4,32(s0)
    80006060:	f41c                	sd	a5,40(s0)
    80006062:	03043823          	sd	a6,48(s0)
    80006066:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000606a:	00028d97          	auipc	s11,0x28
    8000606e:	cf6dad83          	lw	s11,-778(s11) # 8002dd60 <pr+0x18>
  if(locking)
    80006072:	020d9b63          	bnez	s11,800060a8 <printf+0x70>
  if (fmt == 0)
    80006076:	040a0263          	beqz	s4,800060ba <printf+0x82>
  va_start(ap, fmt);
    8000607a:	00840793          	addi	a5,s0,8
    8000607e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006082:	000a4503          	lbu	a0,0(s4)
    80006086:	14050f63          	beqz	a0,800061e4 <printf+0x1ac>
    8000608a:	4981                	li	s3,0
    if(c != '%'){
    8000608c:	02500a93          	li	s5,37
    switch(c){
    80006090:	07000b93          	li	s7,112
  consputc('x');
    80006094:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006096:	00002b17          	auipc	s6,0x2
    8000609a:	7cab0b13          	addi	s6,s6,1994 # 80008860 <digits>
    switch(c){
    8000609e:	07300c93          	li	s9,115
    800060a2:	06400c13          	li	s8,100
    800060a6:	a82d                	j	800060e0 <printf+0xa8>
    acquire(&pr.lock);
    800060a8:	00028517          	auipc	a0,0x28
    800060ac:	ca050513          	addi	a0,a0,-864 # 8002dd48 <pr>
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	47a080e7          	jalr	1146(ra) # 8000652a <acquire>
    800060b8:	bf7d                	j	80006076 <printf+0x3e>
    panic("null fmt");
    800060ba:	00002517          	auipc	a0,0x2
    800060be:	78e50513          	addi	a0,a0,1934 # 80008848 <syscalls+0x498>
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	f2c080e7          	jalr	-212(ra) # 80005fee <panic>
      consputc(c);
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	c62080e7          	jalr	-926(ra) # 80005d2c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060d2:	2985                	addiw	s3,s3,1
    800060d4:	013a07b3          	add	a5,s4,s3
    800060d8:	0007c503          	lbu	a0,0(a5)
    800060dc:	10050463          	beqz	a0,800061e4 <printf+0x1ac>
    if(c != '%'){
    800060e0:	ff5515e3          	bne	a0,s5,800060ca <printf+0x92>
    c = fmt[++i] & 0xff;
    800060e4:	2985                	addiw	s3,s3,1
    800060e6:	013a07b3          	add	a5,s4,s3
    800060ea:	0007c783          	lbu	a5,0(a5)
    800060ee:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800060f2:	cbed                	beqz	a5,800061e4 <printf+0x1ac>
    switch(c){
    800060f4:	05778a63          	beq	a5,s7,80006148 <printf+0x110>
    800060f8:	02fbf663          	bgeu	s7,a5,80006124 <printf+0xec>
    800060fc:	09978863          	beq	a5,s9,8000618c <printf+0x154>
    80006100:	07800713          	li	a4,120
    80006104:	0ce79563          	bne	a5,a4,800061ce <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006108:	f8843783          	ld	a5,-120(s0)
    8000610c:	00878713          	addi	a4,a5,8
    80006110:	f8e43423          	sd	a4,-120(s0)
    80006114:	4605                	li	a2,1
    80006116:	85ea                	mv	a1,s10
    80006118:	4388                	lw	a0,0(a5)
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	e32080e7          	jalr	-462(ra) # 80005f4c <printint>
      break;
    80006122:	bf45                	j	800060d2 <printf+0x9a>
    switch(c){
    80006124:	09578f63          	beq	a5,s5,800061c2 <printf+0x18a>
    80006128:	0b879363          	bne	a5,s8,800061ce <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000612c:	f8843783          	ld	a5,-120(s0)
    80006130:	00878713          	addi	a4,a5,8
    80006134:	f8e43423          	sd	a4,-120(s0)
    80006138:	4605                	li	a2,1
    8000613a:	45a9                	li	a1,10
    8000613c:	4388                	lw	a0,0(a5)
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	e0e080e7          	jalr	-498(ra) # 80005f4c <printint>
      break;
    80006146:	b771                	j	800060d2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006148:	f8843783          	ld	a5,-120(s0)
    8000614c:	00878713          	addi	a4,a5,8
    80006150:	f8e43423          	sd	a4,-120(s0)
    80006154:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006158:	03000513          	li	a0,48
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	bd0080e7          	jalr	-1072(ra) # 80005d2c <consputc>
  consputc('x');
    80006164:	07800513          	li	a0,120
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	bc4080e7          	jalr	-1084(ra) # 80005d2c <consputc>
    80006170:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006172:	03c95793          	srli	a5,s2,0x3c
    80006176:	97da                	add	a5,a5,s6
    80006178:	0007c503          	lbu	a0,0(a5)
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	bb0080e7          	jalr	-1104(ra) # 80005d2c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006184:	0912                	slli	s2,s2,0x4
    80006186:	34fd                	addiw	s1,s1,-1
    80006188:	f4ed                	bnez	s1,80006172 <printf+0x13a>
    8000618a:	b7a1                	j	800060d2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000618c:	f8843783          	ld	a5,-120(s0)
    80006190:	00878713          	addi	a4,a5,8
    80006194:	f8e43423          	sd	a4,-120(s0)
    80006198:	6384                	ld	s1,0(a5)
    8000619a:	cc89                	beqz	s1,800061b4 <printf+0x17c>
      for(; *s; s++)
    8000619c:	0004c503          	lbu	a0,0(s1)
    800061a0:	d90d                	beqz	a0,800060d2 <printf+0x9a>
        consputc(*s);
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	b8a080e7          	jalr	-1142(ra) # 80005d2c <consputc>
      for(; *s; s++)
    800061aa:	0485                	addi	s1,s1,1
    800061ac:	0004c503          	lbu	a0,0(s1)
    800061b0:	f96d                	bnez	a0,800061a2 <printf+0x16a>
    800061b2:	b705                	j	800060d2 <printf+0x9a>
        s = "(null)";
    800061b4:	00002497          	auipc	s1,0x2
    800061b8:	68c48493          	addi	s1,s1,1676 # 80008840 <syscalls+0x490>
      for(; *s; s++)
    800061bc:	02800513          	li	a0,40
    800061c0:	b7cd                	j	800061a2 <printf+0x16a>
      consputc('%');
    800061c2:	8556                	mv	a0,s5
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	b68080e7          	jalr	-1176(ra) # 80005d2c <consputc>
      break;
    800061cc:	b719                	j	800060d2 <printf+0x9a>
      consputc('%');
    800061ce:	8556                	mv	a0,s5
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	b5c080e7          	jalr	-1188(ra) # 80005d2c <consputc>
      consputc(c);
    800061d8:	8526                	mv	a0,s1
    800061da:	00000097          	auipc	ra,0x0
    800061de:	b52080e7          	jalr	-1198(ra) # 80005d2c <consputc>
      break;
    800061e2:	bdc5                	j	800060d2 <printf+0x9a>
  if(locking)
    800061e4:	020d9163          	bnez	s11,80006206 <printf+0x1ce>
}
    800061e8:	70e6                	ld	ra,120(sp)
    800061ea:	7446                	ld	s0,112(sp)
    800061ec:	74a6                	ld	s1,104(sp)
    800061ee:	7906                	ld	s2,96(sp)
    800061f0:	69e6                	ld	s3,88(sp)
    800061f2:	6a46                	ld	s4,80(sp)
    800061f4:	6aa6                	ld	s5,72(sp)
    800061f6:	6b06                	ld	s6,64(sp)
    800061f8:	7be2                	ld	s7,56(sp)
    800061fa:	7c42                	ld	s8,48(sp)
    800061fc:	7ca2                	ld	s9,40(sp)
    800061fe:	7d02                	ld	s10,32(sp)
    80006200:	6de2                	ld	s11,24(sp)
    80006202:	6129                	addi	sp,sp,192
    80006204:	8082                	ret
    release(&pr.lock);
    80006206:	00028517          	auipc	a0,0x28
    8000620a:	b4250513          	addi	a0,a0,-1214 # 8002dd48 <pr>
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	3d0080e7          	jalr	976(ra) # 800065de <release>
}
    80006216:	bfc9                	j	800061e8 <printf+0x1b0>

0000000080006218 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006218:	1101                	addi	sp,sp,-32
    8000621a:	ec06                	sd	ra,24(sp)
    8000621c:	e822                	sd	s0,16(sp)
    8000621e:	e426                	sd	s1,8(sp)
    80006220:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006222:	00028497          	auipc	s1,0x28
    80006226:	b2648493          	addi	s1,s1,-1242 # 8002dd48 <pr>
    8000622a:	00002597          	auipc	a1,0x2
    8000622e:	62e58593          	addi	a1,a1,1582 # 80008858 <syscalls+0x4a8>
    80006232:	8526                	mv	a0,s1
    80006234:	00000097          	auipc	ra,0x0
    80006238:	266080e7          	jalr	614(ra) # 8000649a <initlock>
  pr.locking = 1;
    8000623c:	4785                	li	a5,1
    8000623e:	cc9c                	sw	a5,24(s1)
}
    80006240:	60e2                	ld	ra,24(sp)
    80006242:	6442                	ld	s0,16(sp)
    80006244:	64a2                	ld	s1,8(sp)
    80006246:	6105                	addi	sp,sp,32
    80006248:	8082                	ret

000000008000624a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000624a:	1141                	addi	sp,sp,-16
    8000624c:	e406                	sd	ra,8(sp)
    8000624e:	e022                	sd	s0,0(sp)
    80006250:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006252:	100007b7          	lui	a5,0x10000
    80006256:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000625a:	f8000713          	li	a4,-128
    8000625e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006262:	470d                	li	a4,3
    80006264:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006268:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000626c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006270:	469d                	li	a3,7
    80006272:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006276:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000627a:	00002597          	auipc	a1,0x2
    8000627e:	5fe58593          	addi	a1,a1,1534 # 80008878 <digits+0x18>
    80006282:	00028517          	auipc	a0,0x28
    80006286:	ae650513          	addi	a0,a0,-1306 # 8002dd68 <uart_tx_lock>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	210080e7          	jalr	528(ra) # 8000649a <initlock>
}
    80006292:	60a2                	ld	ra,8(sp)
    80006294:	6402                	ld	s0,0(sp)
    80006296:	0141                	addi	sp,sp,16
    80006298:	8082                	ret

000000008000629a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
    800062a4:	84aa                	mv	s1,a0
  push_off();
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	238080e7          	jalr	568(ra) # 800064de <push_off>

  if(panicked){
    800062ae:	00002797          	auipc	a5,0x2
    800062b2:	66e7a783          	lw	a5,1646(a5) # 8000891c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062b6:	10000737          	lui	a4,0x10000
  if(panicked){
    800062ba:	c391                	beqz	a5,800062be <uartputc_sync+0x24>
    for(;;)
    800062bc:	a001                	j	800062bc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062be:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062c2:	0207f793          	andi	a5,a5,32
    800062c6:	dfe5                	beqz	a5,800062be <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062c8:	0ff4f513          	zext.b	a0,s1
    800062cc:	100007b7          	lui	a5,0x10000
    800062d0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	2aa080e7          	jalr	682(ra) # 8000657e <pop_off>
}
    800062dc:	60e2                	ld	ra,24(sp)
    800062de:	6442                	ld	s0,16(sp)
    800062e0:	64a2                	ld	s1,8(sp)
    800062e2:	6105                	addi	sp,sp,32
    800062e4:	8082                	ret

00000000800062e6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062e6:	00002797          	auipc	a5,0x2
    800062ea:	63a7b783          	ld	a5,1594(a5) # 80008920 <uart_tx_r>
    800062ee:	00002717          	auipc	a4,0x2
    800062f2:	63a73703          	ld	a4,1594(a4) # 80008928 <uart_tx_w>
    800062f6:	06f70a63          	beq	a4,a5,8000636a <uartstart+0x84>
{
    800062fa:	7139                	addi	sp,sp,-64
    800062fc:	fc06                	sd	ra,56(sp)
    800062fe:	f822                	sd	s0,48(sp)
    80006300:	f426                	sd	s1,40(sp)
    80006302:	f04a                	sd	s2,32(sp)
    80006304:	ec4e                	sd	s3,24(sp)
    80006306:	e852                	sd	s4,16(sp)
    80006308:	e456                	sd	s5,8(sp)
    8000630a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000630c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006310:	00028a17          	auipc	s4,0x28
    80006314:	a58a0a13          	addi	s4,s4,-1448 # 8002dd68 <uart_tx_lock>
    uart_tx_r += 1;
    80006318:	00002497          	auipc	s1,0x2
    8000631c:	60848493          	addi	s1,s1,1544 # 80008920 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006320:	00002997          	auipc	s3,0x2
    80006324:	60898993          	addi	s3,s3,1544 # 80008928 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006328:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000632c:	02077713          	andi	a4,a4,32
    80006330:	c705                	beqz	a4,80006358 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006332:	01f7f713          	andi	a4,a5,31
    80006336:	9752                	add	a4,a4,s4
    80006338:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000633c:	0785                	addi	a5,a5,1
    8000633e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006340:	8526                	mv	a0,s1
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	202080e7          	jalr	514(ra) # 80001544 <wakeup>
    
    WriteReg(THR, c);
    8000634a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000634e:	609c                	ld	a5,0(s1)
    80006350:	0009b703          	ld	a4,0(s3)
    80006354:	fcf71ae3          	bne	a4,a5,80006328 <uartstart+0x42>
  }
}
    80006358:	70e2                	ld	ra,56(sp)
    8000635a:	7442                	ld	s0,48(sp)
    8000635c:	74a2                	ld	s1,40(sp)
    8000635e:	7902                	ld	s2,32(sp)
    80006360:	69e2                	ld	s3,24(sp)
    80006362:	6a42                	ld	s4,16(sp)
    80006364:	6aa2                	ld	s5,8(sp)
    80006366:	6121                	addi	sp,sp,64
    80006368:	8082                	ret
    8000636a:	8082                	ret

000000008000636c <uartputc>:
{
    8000636c:	7179                	addi	sp,sp,-48
    8000636e:	f406                	sd	ra,40(sp)
    80006370:	f022                	sd	s0,32(sp)
    80006372:	ec26                	sd	s1,24(sp)
    80006374:	e84a                	sd	s2,16(sp)
    80006376:	e44e                	sd	s3,8(sp)
    80006378:	e052                	sd	s4,0(sp)
    8000637a:	1800                	addi	s0,sp,48
    8000637c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000637e:	00028517          	auipc	a0,0x28
    80006382:	9ea50513          	addi	a0,a0,-1558 # 8002dd68 <uart_tx_lock>
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	1a4080e7          	jalr	420(ra) # 8000652a <acquire>
  if(panicked){
    8000638e:	00002797          	auipc	a5,0x2
    80006392:	58e7a783          	lw	a5,1422(a5) # 8000891c <panicked>
    80006396:	e7c9                	bnez	a5,80006420 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006398:	00002717          	auipc	a4,0x2
    8000639c:	59073703          	ld	a4,1424(a4) # 80008928 <uart_tx_w>
    800063a0:	00002797          	auipc	a5,0x2
    800063a4:	5807b783          	ld	a5,1408(a5) # 80008920 <uart_tx_r>
    800063a8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063ac:	00028997          	auipc	s3,0x28
    800063b0:	9bc98993          	addi	s3,s3,-1604 # 8002dd68 <uart_tx_lock>
    800063b4:	00002497          	auipc	s1,0x2
    800063b8:	56c48493          	addi	s1,s1,1388 # 80008920 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063bc:	00002917          	auipc	s2,0x2
    800063c0:	56c90913          	addi	s2,s2,1388 # 80008928 <uart_tx_w>
    800063c4:	00e79f63          	bne	a5,a4,800063e2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800063c8:	85ce                	mv	a1,s3
    800063ca:	8526                	mv	a0,s1
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	114080e7          	jalr	276(ra) # 800014e0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d4:	00093703          	ld	a4,0(s2)
    800063d8:	609c                	ld	a5,0(s1)
    800063da:	02078793          	addi	a5,a5,32
    800063de:	fee785e3          	beq	a5,a4,800063c8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063e2:	00028497          	auipc	s1,0x28
    800063e6:	98648493          	addi	s1,s1,-1658 # 8002dd68 <uart_tx_lock>
    800063ea:	01f77793          	andi	a5,a4,31
    800063ee:	97a6                	add	a5,a5,s1
    800063f0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800063f4:	0705                	addi	a4,a4,1
    800063f6:	00002797          	auipc	a5,0x2
    800063fa:	52e7b923          	sd	a4,1330(a5) # 80008928 <uart_tx_w>
  uartstart();
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	ee8080e7          	jalr	-280(ra) # 800062e6 <uartstart>
  release(&uart_tx_lock);
    80006406:	8526                	mv	a0,s1
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	1d6080e7          	jalr	470(ra) # 800065de <release>
}
    80006410:	70a2                	ld	ra,40(sp)
    80006412:	7402                	ld	s0,32(sp)
    80006414:	64e2                	ld	s1,24(sp)
    80006416:	6942                	ld	s2,16(sp)
    80006418:	69a2                	ld	s3,8(sp)
    8000641a:	6a02                	ld	s4,0(sp)
    8000641c:	6145                	addi	sp,sp,48
    8000641e:	8082                	ret
    for(;;)
    80006420:	a001                	j	80006420 <uartputc+0xb4>

0000000080006422 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006422:	1141                	addi	sp,sp,-16
    80006424:	e422                	sd	s0,8(sp)
    80006426:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006428:	100007b7          	lui	a5,0x10000
    8000642c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006430:	8b85                	andi	a5,a5,1
    80006432:	cb91                	beqz	a5,80006446 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006434:	100007b7          	lui	a5,0x10000
    80006438:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000643c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80006440:	6422                	ld	s0,8(sp)
    80006442:	0141                	addi	sp,sp,16
    80006444:	8082                	ret
    return -1;
    80006446:	557d                	li	a0,-1
    80006448:	bfe5                	j	80006440 <uartgetc+0x1e>

000000008000644a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000644a:	1101                	addi	sp,sp,-32
    8000644c:	ec06                	sd	ra,24(sp)
    8000644e:	e822                	sd	s0,16(sp)
    80006450:	e426                	sd	s1,8(sp)
    80006452:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006454:	54fd                	li	s1,-1
    80006456:	a029                	j	80006460 <uartintr+0x16>
      break;
    consoleintr(c);
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	916080e7          	jalr	-1770(ra) # 80005d6e <consoleintr>
    int c = uartgetc();
    80006460:	00000097          	auipc	ra,0x0
    80006464:	fc2080e7          	jalr	-62(ra) # 80006422 <uartgetc>
    if(c == -1)
    80006468:	fe9518e3          	bne	a0,s1,80006458 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000646c:	00028497          	auipc	s1,0x28
    80006470:	8fc48493          	addi	s1,s1,-1796 # 8002dd68 <uart_tx_lock>
    80006474:	8526                	mv	a0,s1
    80006476:	00000097          	auipc	ra,0x0
    8000647a:	0b4080e7          	jalr	180(ra) # 8000652a <acquire>
  uartstart();
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	e68080e7          	jalr	-408(ra) # 800062e6 <uartstart>
  release(&uart_tx_lock);
    80006486:	8526                	mv	a0,s1
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	156080e7          	jalr	342(ra) # 800065de <release>
}
    80006490:	60e2                	ld	ra,24(sp)
    80006492:	6442                	ld	s0,16(sp)
    80006494:	64a2                	ld	s1,8(sp)
    80006496:	6105                	addi	sp,sp,32
    80006498:	8082                	ret

000000008000649a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000649a:	1141                	addi	sp,sp,-16
    8000649c:	e422                	sd	s0,8(sp)
    8000649e:	0800                	addi	s0,sp,16
  lk->name = name;
    800064a0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064a2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064a6:	00053823          	sd	zero,16(a0)
}
    800064aa:	6422                	ld	s0,8(sp)
    800064ac:	0141                	addi	sp,sp,16
    800064ae:	8082                	ret

00000000800064b0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064b0:	411c                	lw	a5,0(a0)
    800064b2:	e399                	bnez	a5,800064b8 <holding+0x8>
    800064b4:	4501                	li	a0,0
  return r;
}
    800064b6:	8082                	ret
{
    800064b8:	1101                	addi	sp,sp,-32
    800064ba:	ec06                	sd	ra,24(sp)
    800064bc:	e822                	sd	s0,16(sp)
    800064be:	e426                	sd	s1,8(sp)
    800064c0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064c2:	6904                	ld	s1,16(a0)
    800064c4:	ffffb097          	auipc	ra,0xffffb
    800064c8:	958080e7          	jalr	-1704(ra) # 80000e1c <mycpu>
    800064cc:	40a48533          	sub	a0,s1,a0
    800064d0:	00153513          	seqz	a0,a0
}
    800064d4:	60e2                	ld	ra,24(sp)
    800064d6:	6442                	ld	s0,16(sp)
    800064d8:	64a2                	ld	s1,8(sp)
    800064da:	6105                	addi	sp,sp,32
    800064dc:	8082                	ret

00000000800064de <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064de:	1101                	addi	sp,sp,-32
    800064e0:	ec06                	sd	ra,24(sp)
    800064e2:	e822                	sd	s0,16(sp)
    800064e4:	e426                	sd	s1,8(sp)
    800064e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064e8:	100024f3          	csrr	s1,sstatus
    800064ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064f2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064f6:	ffffb097          	auipc	ra,0xffffb
    800064fa:	926080e7          	jalr	-1754(ra) # 80000e1c <mycpu>
    800064fe:	5d3c                	lw	a5,120(a0)
    80006500:	cf89                	beqz	a5,8000651a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006502:	ffffb097          	auipc	ra,0xffffb
    80006506:	91a080e7          	jalr	-1766(ra) # 80000e1c <mycpu>
    8000650a:	5d3c                	lw	a5,120(a0)
    8000650c:	2785                	addiw	a5,a5,1
    8000650e:	dd3c                	sw	a5,120(a0)
}
    80006510:	60e2                	ld	ra,24(sp)
    80006512:	6442                	ld	s0,16(sp)
    80006514:	64a2                	ld	s1,8(sp)
    80006516:	6105                	addi	sp,sp,32
    80006518:	8082                	ret
    mycpu()->intena = old;
    8000651a:	ffffb097          	auipc	ra,0xffffb
    8000651e:	902080e7          	jalr	-1790(ra) # 80000e1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006522:	8085                	srli	s1,s1,0x1
    80006524:	8885                	andi	s1,s1,1
    80006526:	dd64                	sw	s1,124(a0)
    80006528:	bfe9                	j	80006502 <push_off+0x24>

000000008000652a <acquire>:
{
    8000652a:	1101                	addi	sp,sp,-32
    8000652c:	ec06                	sd	ra,24(sp)
    8000652e:	e822                	sd	s0,16(sp)
    80006530:	e426                	sd	s1,8(sp)
    80006532:	1000                	addi	s0,sp,32
    80006534:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006536:	00000097          	auipc	ra,0x0
    8000653a:	fa8080e7          	jalr	-88(ra) # 800064de <push_off>
  if(holding(lk))
    8000653e:	8526                	mv	a0,s1
    80006540:	00000097          	auipc	ra,0x0
    80006544:	f70080e7          	jalr	-144(ra) # 800064b0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006548:	4705                	li	a4,1
  if(holding(lk))
    8000654a:	e115                	bnez	a0,8000656e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000654c:	87ba                	mv	a5,a4
    8000654e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006552:	2781                	sext.w	a5,a5
    80006554:	ffe5                	bnez	a5,8000654c <acquire+0x22>
  __sync_synchronize();
    80006556:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000655a:	ffffb097          	auipc	ra,0xffffb
    8000655e:	8c2080e7          	jalr	-1854(ra) # 80000e1c <mycpu>
    80006562:	e888                	sd	a0,16(s1)
}
    80006564:	60e2                	ld	ra,24(sp)
    80006566:	6442                	ld	s0,16(sp)
    80006568:	64a2                	ld	s1,8(sp)
    8000656a:	6105                	addi	sp,sp,32
    8000656c:	8082                	ret
    panic("acquire");
    8000656e:	00002517          	auipc	a0,0x2
    80006572:	31250513          	addi	a0,a0,786 # 80008880 <digits+0x20>
    80006576:	00000097          	auipc	ra,0x0
    8000657a:	a78080e7          	jalr	-1416(ra) # 80005fee <panic>

000000008000657e <pop_off>:

void
pop_off(void)
{
    8000657e:	1141                	addi	sp,sp,-16
    80006580:	e406                	sd	ra,8(sp)
    80006582:	e022                	sd	s0,0(sp)
    80006584:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006586:	ffffb097          	auipc	ra,0xffffb
    8000658a:	896080e7          	jalr	-1898(ra) # 80000e1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000658e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006592:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006594:	e78d                	bnez	a5,800065be <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006596:	5d3c                	lw	a5,120(a0)
    80006598:	02f05b63          	blez	a5,800065ce <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000659c:	37fd                	addiw	a5,a5,-1
    8000659e:	0007871b          	sext.w	a4,a5
    800065a2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065a4:	eb09                	bnez	a4,800065b6 <pop_off+0x38>
    800065a6:	5d7c                	lw	a5,124(a0)
    800065a8:	c799                	beqz	a5,800065b6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065b2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065b6:	60a2                	ld	ra,8(sp)
    800065b8:	6402                	ld	s0,0(sp)
    800065ba:	0141                	addi	sp,sp,16
    800065bc:	8082                	ret
    panic("pop_off - interruptible");
    800065be:	00002517          	auipc	a0,0x2
    800065c2:	2ca50513          	addi	a0,a0,714 # 80008888 <digits+0x28>
    800065c6:	00000097          	auipc	ra,0x0
    800065ca:	a28080e7          	jalr	-1496(ra) # 80005fee <panic>
    panic("pop_off");
    800065ce:	00002517          	auipc	a0,0x2
    800065d2:	2d250513          	addi	a0,a0,722 # 800088a0 <digits+0x40>
    800065d6:	00000097          	auipc	ra,0x0
    800065da:	a18080e7          	jalr	-1512(ra) # 80005fee <panic>

00000000800065de <release>:
{
    800065de:	1101                	addi	sp,sp,-32
    800065e0:	ec06                	sd	ra,24(sp)
    800065e2:	e822                	sd	s0,16(sp)
    800065e4:	e426                	sd	s1,8(sp)
    800065e6:	1000                	addi	s0,sp,32
    800065e8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065ea:	00000097          	auipc	ra,0x0
    800065ee:	ec6080e7          	jalr	-314(ra) # 800064b0 <holding>
    800065f2:	c115                	beqz	a0,80006616 <release+0x38>
  lk->cpu = 0;
    800065f4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065f8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800065fc:	0f50000f          	fence	iorw,ow
    80006600:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006604:	00000097          	auipc	ra,0x0
    80006608:	f7a080e7          	jalr	-134(ra) # 8000657e <pop_off>
}
    8000660c:	60e2                	ld	ra,24(sp)
    8000660e:	6442                	ld	s0,16(sp)
    80006610:	64a2                	ld	s1,8(sp)
    80006612:	6105                	addi	sp,sp,32
    80006614:	8082                	ret
    panic("release");
    80006616:	00002517          	auipc	a0,0x2
    8000661a:	29250513          	addi	a0,a0,658 # 800088a8 <digits+0x48>
    8000661e:	00000097          	auipc	ra,0x0
    80006622:	9d0080e7          	jalr	-1584(ra) # 80005fee <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
