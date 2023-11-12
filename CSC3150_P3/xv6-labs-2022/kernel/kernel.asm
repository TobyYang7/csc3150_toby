
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00026117          	auipc	sp,0x26
    80000004:	c8010113          	addi	sp,sp,-896 # 80025c80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	339050ef          	jal	ra,80005b4e <start>

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
    80000034:	d5078793          	addi	a5,a5,-688 # 8002dd80 <end>
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
    80000054:	8c090913          	addi	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	4e0080e7          	jalr	1248(ra) # 8000653a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	580080e7          	jalr	1408(ra) # 800065ee <release>
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
    8000008e:	f74080e7          	jalr	-140(ra) # 80005ffe <panic>

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
    800000f0:	82450513          	addi	a0,a0,-2012 # 80008910 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3b6080e7          	jalr	950(ra) # 800064aa <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	c8050513          	addi	a0,a0,-896 # 8002dd80 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7ee48493          	addi	s1,s1,2030 # 80008910 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	40e080e7          	jalr	1038(ra) # 8000653a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7d650513          	addi	a0,a0,2006 # 80008910 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	4aa080e7          	jalr	1194(ra) # 800065ee <release>

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
    8000016a:	7aa50513          	addi	a0,a0,1962 # 80008910 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	480080e7          	jalr	1152(ra) # 800065ee <release>
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
    80000332:	5b270713          	addi	a4,a4,1458 # 800088e0 <started>
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
    80000358:	cf4080e7          	jalr	-780(ra) # 80006048 <printf>
    kvminithart();  // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	7d2080e7          	jalr	2002(ra) # 80001b36 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	194080e7          	jalr	404(ra) # 80005500 <plicinithart>
  }

  scheduler();
    80000374:	00001097          	auipc	ra,0x1
    80000378:	01a080e7          	jalr	26(ra) # 8000138e <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	b94080e7          	jalr	-1132(ra) # 80005f10 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	ea4080e7          	jalr	-348(ra) # 80006228 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	cb4080e7          	jalr	-844(ra) # 80006048 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	ca4080e7          	jalr	-860(ra) # 80006048 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	c94080e7          	jalr	-876(ra) # 80006048 <printf>
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
    800003e0:	732080e7          	jalr	1842(ra) # 80001b0e <trapinit>
    trapinithart();     // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	752080e7          	jalr	1874(ra) # 80001b36 <trapinithart>
    plicinit();         // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	0fe080e7          	jalr	254(ra) # 800054ea <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	10c080e7          	jalr	268(ra) # 80005500 <plicinithart>
    binit();            // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f8c080e7          	jalr	-116(ra) # 80002388 <binit>
    iinit();            // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	632080e7          	jalr	1586(ra) # 80002a36 <iinit>
    fileinit();         // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	5d4080e7          	jalr	1492(ra) # 800039e0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	1f4080e7          	jalr	500(ra) # 80005608 <virtio_disk_init>
    userinit();         // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cf4080e7          	jalr	-780(ra) # 80001110 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4af72b23          	sw	a5,1206(a4) # 800088e0 <started>
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
    80000442:	4aa7b783          	ld	a5,1194(a5) # 800088e8 <kernel_pagetable>
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
    8000048e:	b74080e7          	jalr	-1164(ra) # 80005ffe <panic>
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
    800005b4:	a4e080e7          	jalr	-1458(ra) # 80005ffe <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	a3e080e7          	jalr	-1474(ra) # 80005ffe <panic>
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
    80000610:	9f2080e7          	jalr	-1550(ra) # 80005ffe <panic>

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
    800006fe:	1ea7b723          	sd	a0,494(a5) # 800088e8 <kernel_pagetable>
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
    8000075c:	8a6080e7          	jalr	-1882(ra) # 80005ffe <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	896080e7          	jalr	-1898(ra) # 80005ffe <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00006097          	auipc	ra,0x6
    8000077c:	886080e7          	jalr	-1914(ra) # 80005ffe <panic>
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
    8000085c:	7a6080e7          	jalr	1958(ra) # 80005ffe <panic>

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
    800009a6:	65c080e7          	jalr	1628(ra) # 80005ffe <panic>
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
    80000a2a:	5d8080e7          	jalr	1496(ra) # 80005ffe <panic>
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
    80000af0:	512080e7          	jalr	1298(ra) # 80005ffe <panic>

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
void proc_mapstacks(pagetable_t kpgtbl)
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

  for (p = proc; p < &proc[NPROC]; p++)
    80000cd8:	00008497          	auipc	s1,0x8
    80000cdc:	08848493          	addi	s1,s1,136 # 80008d60 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000ce0:	8b26                	mv	s6,s1
    80000ce2:	00007a97          	auipc	s5,0x7
    80000ce6:	31ea8a93          	addi	s5,s5,798 # 80008000 <etext>
    80000cea:	04000937          	lui	s2,0x4000
    80000cee:	197d                	addi	s2,s2,-1
    80000cf0:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000cf2:	0001aa17          	auipc	s4,0x1a
    80000cf6:	a6ea0a13          	addi	s4,s4,-1426 # 8001a760 <tickslock>
    char *pa = kalloc();
    80000cfa:	fffff097          	auipc	ra,0xfffff
    80000cfe:	41e080e7          	jalr	1054(ra) # 80000118 <kalloc>
    80000d02:	862a                	mv	a2,a0
    if (pa == 0)
    80000d04:	c131                	beqz	a0,80000d48 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
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
  for (p = proc; p < &proc[NPROC]; p++)
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
    80000d54:	2ae080e7          	jalr	686(ra) # 80005ffe <panic>

0000000080000d58 <procinit>:

// initialize the proc table.
void procinit(void)
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
    80000d78:	bbc50513          	addi	a0,a0,-1092 # 80008930 <pid_lock>
    80000d7c:	00005097          	auipc	ra,0x5
    80000d80:	72e080e7          	jalr	1838(ra) # 800064aa <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3ac58593          	addi	a1,a1,940 # 80008130 <etext+0x130>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	bbc50513          	addi	a0,a0,-1092 # 80008948 <wait_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	716080e7          	jalr	1814(ra) # 800064aa <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d9c:	00008497          	auipc	s1,0x8
    80000da0:	fc448493          	addi	s1,s1,-60 # 80008d60 <proc>
  {
    initlock(&p->lock, "proc");
    80000da4:	00007b17          	auipc	s6,0x7
    80000da8:	39cb0b13          	addi	s6,s6,924 # 80008140 <etext+0x140>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000dac:	8aa6                	mv	s5,s1
    80000dae:	00007a17          	auipc	s4,0x7
    80000db2:	252a0a13          	addi	s4,s4,594 # 80008000 <etext>
    80000db6:	04000937          	lui	s2,0x4000
    80000dba:	197d                	addi	s2,s2,-1
    80000dbc:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000dbe:	0001a997          	auipc	s3,0x1a
    80000dc2:	9a298993          	addi	s3,s3,-1630 # 8001a760 <tickslock>
    initlock(&p->lock, "proc");
    80000dc6:	85da                	mv	a1,s6
    80000dc8:	8526                	mv	a0,s1
    80000dca:	00005097          	auipc	ra,0x5
    80000dce:	6e0080e7          	jalr	1760(ra) # 800064aa <initlock>
    p->state = UNUSED;
    80000dd2:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000dd6:	415487b3          	sub	a5,s1,s5
    80000dda:	878d                	srai	a5,a5,0x3
    80000ddc:	000a3703          	ld	a4,0(s4)
    80000de0:	02e787b3          	mul	a5,a5,a4
    80000de4:	2785                	addiw	a5,a5,1
    80000de6:	00d7979b          	slliw	a5,a5,0xd
    80000dea:	40f907b3          	sub	a5,s2,a5
    80000dee:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
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
int cpuid()
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
struct cpu *
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
    80000e2c:	b3850513          	addi	a0,a0,-1224 # 80008960 <cpus>
    80000e30:	953e                	add	a0,a0,a5
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e38:	1101                	addi	sp,sp,-32
    80000e3a:	ec06                	sd	ra,24(sp)
    80000e3c:	e822                	sd	s0,16(sp)
    80000e3e:	e426                	sd	s1,8(sp)
    80000e40:	1000                	addi	s0,sp,32
  push_off();
    80000e42:	00005097          	auipc	ra,0x5
    80000e46:	6ac080e7          	jalr	1708(ra) # 800064ee <push_off>
    80000e4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4c:	2781                	sext.w	a5,a5
    80000e4e:	079e                	slli	a5,a5,0x7
    80000e50:	00008717          	auipc	a4,0x8
    80000e54:	ae070713          	addi	a4,a4,-1312 # 80008930 <pid_lock>
    80000e58:	97ba                	add	a5,a5,a4
    80000e5a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	732080e7          	jalr	1842(ra) # 8000658e <pop_off>
  return p;
}
    80000e64:	8526                	mv	a0,s1
    80000e66:	60e2                	ld	ra,24(sp)
    80000e68:	6442                	ld	s0,16(sp)
    80000e6a:	64a2                	ld	s1,8(sp)
    80000e6c:	6105                	addi	sp,sp,32
    80000e6e:	8082                	ret

0000000080000e70 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
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
    80000e84:	76e080e7          	jalr	1902(ra) # 800065ee <release>

  if (first)
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	a087a783          	lw	a5,-1528(a5) # 80008890 <first.1>
    80000e90:	eb89                	bnez	a5,80000ea2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e92:	00001097          	auipc	ra,0x1
    80000e96:	cbc080e7          	jalr	-836(ra) # 80001b4e <usertrapret>
}
    80000e9a:	60a2                	ld	ra,8(sp)
    80000e9c:	6402                	ld	s0,0(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
    first = 0;
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	9e07a723          	sw	zero,-1554(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80000eaa:	4505                	li	a0,1
    80000eac:	00002097          	auipc	ra,0x2
    80000eb0:	b0a080e7          	jalr	-1270(ra) # 800029b6 <fsinit>
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
    80000ec6:	a6e90913          	addi	s2,s2,-1426 # 80008930 <pid_lock>
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	66e080e7          	jalr	1646(ra) # 8000653a <acquire>
  pid = nextpid;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	9c078793          	addi	a5,a5,-1600 # 80008894 <nextpid>
    80000edc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ede:	0014871b          	addiw	a4,s1,1
    80000ee2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	708080e7          	jalr	1800(ra) # 800065ee <release>
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
  if (pagetable == 0)
    80000f14:	c121                	beqz	a0,80000f54 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
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
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
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
  if (p->trapframe)
    80000ff6:	6d28                	ld	a0,88(a0)
    80000ff8:	c509                	beqz	a0,80001002 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	022080e7          	jalr	34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001002:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
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
  for (p = proc; p < &proc[NPROC]; p++)
    8000104e:	00008497          	auipc	s1,0x8
    80001052:	d1248493          	addi	s1,s1,-750 # 80008d60 <proc>
    80001056:	00019917          	auipc	s2,0x19
    8000105a:	70a90913          	addi	s2,s2,1802 # 8001a760 <tickslock>
    acquire(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	4da080e7          	jalr	1242(ra) # 8000653a <acquire>
    if (p->state == UNUSED)
    80001068:	4c9c                	lw	a5,24(s1)
    8000106a:	cf81                	beqz	a5,80001082 <allocproc+0x40>
      release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00005097          	auipc	ra,0x5
    80001072:	580080e7          	jalr	1408(ra) # 800065ee <release>
  for (p = proc; p < &proc[NPROC]; p++)
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
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
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
  if (p->pagetable == 0)
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
    800010f0:	502080e7          	jalr	1282(ra) # 800065ee <release>
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
    80001108:	4ea080e7          	jalr	1258(ra) # 800065ee <release>
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
    80001128:	7ca7b623          	sd	a0,1996(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112c:	03400613          	li	a2,52
    80001130:	00007597          	auipc	a1,0x7
    80001134:	77058593          	addi	a1,a1,1904 # 800088a0 <initcode>
    80001138:	6928                	ld	a0,80(a0)
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	6b4080e7          	jalr	1716(ra) # 800007ee <uvmfirst>
  p->sz = PGSIZE;
    80001142:	6785                	lui	a5,0x1
    80001144:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001146:	6cb8                	ld	a4,88(s1)
    80001148:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
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
    80001172:	26a080e7          	jalr	618(ra) # 800033d8 <namei>
    80001176:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000117a:	478d                	li	a5,3
    8000117c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	46e080e7          	jalr	1134(ra) # 800065ee <release>
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
  if (n > 0)
    800011ac:	01204c63          	bgtz	s2,800011c4 <growproc+0x32>
  else if (n < 0)
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
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
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
    80001208:	8a2a                	mv	s4,a0
  if ((np = allocproc()) == 0)
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	e38080e7          	jalr	-456(ra) # 80001042 <allocproc>
    80001212:	16050c63          	beqz	a0,8000138a <fork+0x19c>
    80001216:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001218:	048a3603          	ld	a2,72(s4)
    8000121c:	692c                	ld	a1,80(a0)
    8000121e:	050a3503          	ld	a0,80(s4)
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	7da080e7          	jalr	2010(ra) # 800009fc <uvmcopy>
    8000122a:	00054d63          	bltz	a0,80001244 <fork+0x56>
  np->sz = p->sz;
    8000122e:	048a3783          	ld	a5,72(s4)
    80001232:	04f9b423          	sd	a5,72(s3)
  for (int idx = 0; idx < VMASIZE; idx++)
    80001236:	168a0493          	addi	s1,s4,360
    8000123a:	16898913          	addi	s2,s3,360
    8000123e:	468a0a93          	addi	s5,s4,1128
    80001242:	a01d                	j	80001268 <fork+0x7a>
    freeproc(np);
    80001244:	854e                	mv	a0,s3
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	da4080e7          	jalr	-604(ra) # 80000fea <freeproc>
    release(&np->lock);
    8000124e:	854e                	mv	a0,s3
    80001250:	00005097          	auipc	ra,0x5
    80001254:	39e080e7          	jalr	926(ra) # 800065ee <release>
    return -1;
    80001258:	597d                	li	s2,-1
    8000125a:	aa31                	j	80001376 <fork+0x188>
  for (int idx = 0; idx < VMASIZE; idx++)
    8000125c:	03048493          	addi	s1,s1,48
    80001260:	03090913          	addi	s2,s2,48
    80001264:	05548563          	beq	s1,s5,800012ae <fork+0xc0>
    np->vma[idx].addr = p->vma[idx].addr;
    80001268:	609c                	ld	a5,0(s1)
    8000126a:	00f93023          	sd	a5,0(s2)
    np->vma[idx].length = p->vma[idx].length;
    8000126e:	449c                	lw	a5,8(s1)
    80001270:	00f92423          	sw	a5,8(s2)
    np->vma[idx].prot = p->vma[idx].prot;
    80001274:	44d8                	lw	a4,12(s1)
    80001276:	00e92623          	sw	a4,12(s2)
    np->vma[idx].flags = p->vma[idx].flags;
    8000127a:	4898                	lw	a4,16(s1)
    8000127c:	00e92823          	sw	a4,16(s2)
    np->vma[idx].fd = p->vma[idx].fd;
    80001280:	48d8                	lw	a4,20(s1)
    80001282:	00e92a23          	sw	a4,20(s2)
    np->vma[idx].offset = p->vma[idx].offset;
    80001286:	4c98                	lw	a4,24(s1)
    80001288:	00e92c23          	sw	a4,24(s2)
    if (np->vma[idx].length > 0) // if the vma is valid
    8000128c:	fcf058e3          	blez	a5,8000125c <fork+0x6e>
      np->vma[idx].mfile = filedup(p->vma[idx].mfile); // increase reference count
    80001290:	7088                	ld	a0,32(s1)
    80001292:	00002097          	auipc	ra,0x2
    80001296:	7e0080e7          	jalr	2016(ra) # 80003a72 <filedup>
    8000129a:	02a93023          	sd	a0,32(s2)
      np->vma[idx].ip = idup(p->vma[idx].ip);          // increase inode reference count}
    8000129e:	7488                	ld	a0,40(s1)
    800012a0:	00002097          	auipc	ra,0x2
    800012a4:	954080e7          	jalr	-1708(ra) # 80002bf4 <idup>
    800012a8:	02a93423          	sd	a0,40(s2)
    800012ac:	bf45                	j	8000125c <fork+0x6e>
  *(np->trapframe) = *(p->trapframe);
    800012ae:	058a3683          	ld	a3,88(s4)
    800012b2:	87b6                	mv	a5,a3
    800012b4:	0589b703          	ld	a4,88(s3)
    800012b8:	12068693          	addi	a3,a3,288
    800012bc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c0:	6788                	ld	a0,8(a5)
    800012c2:	6b8c                	ld	a1,16(a5)
    800012c4:	6f90                	ld	a2,24(a5)
    800012c6:	01073023          	sd	a6,0(a4)
    800012ca:	e708                	sd	a0,8(a4)
    800012cc:	eb0c                	sd	a1,16(a4)
    800012ce:	ef10                	sd	a2,24(a4)
    800012d0:	02078793          	addi	a5,a5,32
    800012d4:	02070713          	addi	a4,a4,32
    800012d8:	fed792e3          	bne	a5,a3,800012bc <fork+0xce>
  np->trapframe->a0 = 0;
    800012dc:	0589b783          	ld	a5,88(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800012e4:	0d0a0493          	addi	s1,s4,208
    800012e8:	0d098913          	addi	s2,s3,208
    800012ec:	150a0a93          	addi	s5,s4,336
    800012f0:	a029                	j	800012fa <fork+0x10c>
    800012f2:	04a1                	addi	s1,s1,8
    800012f4:	0921                	addi	s2,s2,8
    800012f6:	01548b63          	beq	s1,s5,8000130c <fork+0x11e>
    if (p->ofile[i])
    800012fa:	6088                	ld	a0,0(s1)
    800012fc:	d97d                	beqz	a0,800012f2 <fork+0x104>
      np->ofile[i] = filedup(p->ofile[i]);
    800012fe:	00002097          	auipc	ra,0x2
    80001302:	774080e7          	jalr	1908(ra) # 80003a72 <filedup>
    80001306:	00a93023          	sd	a0,0(s2)
    8000130a:	b7e5                	j	800012f2 <fork+0x104>
  np->cwd = idup(p->cwd);
    8000130c:	150a3503          	ld	a0,336(s4)
    80001310:	00002097          	auipc	ra,0x2
    80001314:	8e4080e7          	jalr	-1820(ra) # 80002bf4 <idup>
    80001318:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131c:	4641                	li	a2,16
    8000131e:	158a0593          	addi	a1,s4,344
    80001322:	15898513          	addi	a0,s3,344
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	f9c080e7          	jalr	-100(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    8000132e:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	2ba080e7          	jalr	698(ra) # 800065ee <release>
  acquire(&wait_lock);
    8000133c:	00007497          	auipc	s1,0x7
    80001340:	60c48493          	addi	s1,s1,1548 # 80008948 <wait_lock>
    80001344:	8526                	mv	a0,s1
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	1f4080e7          	jalr	500(ra) # 8000653a <acquire>
  np->parent = p;
    8000134e:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	29a080e7          	jalr	666(ra) # 800065ee <release>
  acquire(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	1dc080e7          	jalr	476(ra) # 8000653a <acquire>
  np->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	280080e7          	jalr	640(ra) # 800065ee <release>
}
    80001376:	854a                	mv	a0,s2
    80001378:	70e2                	ld	ra,56(sp)
    8000137a:	7442                	ld	s0,48(sp)
    8000137c:	74a2                	ld	s1,40(sp)
    8000137e:	7902                	ld	s2,32(sp)
    80001380:	69e2                	ld	s3,24(sp)
    80001382:	6a42                	ld	s4,16(sp)
    80001384:	6aa2                	ld	s5,8(sp)
    80001386:	6121                	addi	sp,sp,64
    80001388:	8082                	ret
    return -1;
    8000138a:	597d                	li	s2,-1
    8000138c:	b7ed                	j	80001376 <fork+0x188>

000000008000138e <scheduler>:
{
    8000138e:	7139                	addi	sp,sp,-64
    80001390:	fc06                	sd	ra,56(sp)
    80001392:	f822                	sd	s0,48(sp)
    80001394:	f426                	sd	s1,40(sp)
    80001396:	f04a                	sd	s2,32(sp)
    80001398:	ec4e                	sd	s3,24(sp)
    8000139a:	e852                	sd	s4,16(sp)
    8000139c:	e456                	sd	s5,8(sp)
    8000139e:	e05a                	sd	s6,0(sp)
    800013a0:	0080                	addi	s0,sp,64
    800013a2:	8792                	mv	a5,tp
  int id = r_tp();
    800013a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a6:	00779a93          	slli	s5,a5,0x7
    800013aa:	00007717          	auipc	a4,0x7
    800013ae:	58670713          	addi	a4,a4,1414 # 80008930 <pid_lock>
    800013b2:	9756                	add	a4,a4,s5
    800013b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b8:	00007717          	auipc	a4,0x7
    800013bc:	5b070713          	addi	a4,a4,1456 # 80008968 <cpus+0x8>
    800013c0:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800013c2:	498d                	li	s3,3
        p->state = RUNNING;
    800013c4:	4b11                	li	s6,4
        c->proc = p;
    800013c6:	079e                	slli	a5,a5,0x7
    800013c8:	00007a17          	auipc	s4,0x7
    800013cc:	568a0a13          	addi	s4,s4,1384 # 80008930 <pid_lock>
    800013d0:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800013d2:	00019917          	auipc	s2,0x19
    800013d6:	38e90913          	addi	s2,s2,910 # 8001a760 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e2:	10079073          	csrw	sstatus,a5
    800013e6:	00008497          	auipc	s1,0x8
    800013ea:	97a48493          	addi	s1,s1,-1670 # 80008d60 <proc>
    800013ee:	a811                	j	80001402 <scheduler+0x74>
      release(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	1fc080e7          	jalr	508(ra) # 800065ee <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800013fa:	46848493          	addi	s1,s1,1128
    800013fe:	fd248ee3          	beq	s1,s2,800013da <scheduler+0x4c>
      acquire(&p->lock);
    80001402:	8526                	mv	a0,s1
    80001404:	00005097          	auipc	ra,0x5
    80001408:	136080e7          	jalr	310(ra) # 8000653a <acquire>
      if (p->state == RUNNABLE)
    8000140c:	4c9c                	lw	a5,24(s1)
    8000140e:	ff3791e3          	bne	a5,s3,800013f0 <scheduler+0x62>
        p->state = RUNNING;
    80001412:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001416:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141a:	06048593          	addi	a1,s1,96
    8000141e:	8556                	mv	a0,s5
    80001420:	00000097          	auipc	ra,0x0
    80001424:	684080e7          	jalr	1668(ra) # 80001aa4 <swtch>
        c->proc = 0;
    80001428:	020a3823          	sd	zero,48(s4)
    8000142c:	b7d1                	j	800013f0 <scheduler+0x62>

000000008000142e <sched>:
{
    8000142e:	7179                	addi	sp,sp,-48
    80001430:	f406                	sd	ra,40(sp)
    80001432:	f022                	sd	s0,32(sp)
    80001434:	ec26                	sd	s1,24(sp)
    80001436:	e84a                	sd	s2,16(sp)
    80001438:	e44e                	sd	s3,8(sp)
    8000143a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	9fc080e7          	jalr	-1540(ra) # 80000e38 <myproc>
    80001444:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	07a080e7          	jalr	122(ra) # 800064c0 <holding>
    8000144e:	c93d                	beqz	a0,800014c4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001450:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001452:	2781                	sext.w	a5,a5
    80001454:	079e                	slli	a5,a5,0x7
    80001456:	00007717          	auipc	a4,0x7
    8000145a:	4da70713          	addi	a4,a4,1242 # 80008930 <pid_lock>
    8000145e:	97ba                	add	a5,a5,a4
    80001460:	0a87a703          	lw	a4,168(a5)
    80001464:	4785                	li	a5,1
    80001466:	06f71763          	bne	a4,a5,800014d4 <sched+0xa6>
  if (p->state == RUNNING)
    8000146a:	4c98                	lw	a4,24(s1)
    8000146c:	4791                	li	a5,4
    8000146e:	06f70b63          	beq	a4,a5,800014e4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001472:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001476:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001478:	efb5                	bnez	a5,800014f4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147c:	00007917          	auipc	s2,0x7
    80001480:	4b490913          	addi	s2,s2,1204 # 80008930 <pid_lock>
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	97ca                	add	a5,a5,s2
    8000148a:	0ac7a983          	lw	s3,172(a5)
    8000148e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001490:	2781                	sext.w	a5,a5
    80001492:	079e                	slli	a5,a5,0x7
    80001494:	00007597          	auipc	a1,0x7
    80001498:	4d458593          	addi	a1,a1,1236 # 80008968 <cpus+0x8>
    8000149c:	95be                	add	a1,a1,a5
    8000149e:	06048513          	addi	a0,s1,96
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	602080e7          	jalr	1538(ra) # 80001aa4 <swtch>
    800014aa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	97ca                	add	a5,a5,s2
    800014b2:	0b37a623          	sw	s3,172(a5)
}
    800014b6:	70a2                	ld	ra,40(sp)
    800014b8:	7402                	ld	s0,32(sp)
    800014ba:	64e2                	ld	s1,24(sp)
    800014bc:	6942                	ld	s2,16(sp)
    800014be:	69a2                	ld	s3,8(sp)
    800014c0:	6145                	addi	sp,sp,48
    800014c2:	8082                	ret
    panic("sched p->lock");
    800014c4:	00007517          	auipc	a0,0x7
    800014c8:	c9c50513          	addi	a0,a0,-868 # 80008160 <etext+0x160>
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	b32080e7          	jalr	-1230(ra) # 80005ffe <panic>
    panic("sched locks");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	c9c50513          	addi	a0,a0,-868 # 80008170 <etext+0x170>
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	b22080e7          	jalr	-1246(ra) # 80005ffe <panic>
    panic("sched running");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	c9c50513          	addi	a0,a0,-868 # 80008180 <etext+0x180>
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	b12080e7          	jalr	-1262(ra) # 80005ffe <panic>
    panic("sched interruptible");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	c9c50513          	addi	a0,a0,-868 # 80008190 <etext+0x190>
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	b02080e7          	jalr	-1278(ra) # 80005ffe <panic>

0000000080001504 <yield>:
{
    80001504:	1101                	addi	sp,sp,-32
    80001506:	ec06                	sd	ra,24(sp)
    80001508:	e822                	sd	s0,16(sp)
    8000150a:	e426                	sd	s1,8(sp)
    8000150c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	92a080e7          	jalr	-1750(ra) # 80000e38 <myproc>
    80001516:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	022080e7          	jalr	34(ra) # 8000653a <acquire>
  p->state = RUNNABLE;
    80001520:	478d                	li	a5,3
    80001522:	cc9c                	sw	a5,24(s1)
  sched();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	f0a080e7          	jalr	-246(ra) # 8000142e <sched>
  release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	0c0080e7          	jalr	192(ra) # 800065ee <release>
}
    80001536:	60e2                	ld	ra,24(sp)
    80001538:	6442                	ld	s0,16(sp)
    8000153a:	64a2                	ld	s1,8(sp)
    8000153c:	6105                	addi	sp,sp,32
    8000153e:	8082                	ret

0000000080001540 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001540:	7179                	addi	sp,sp,-48
    80001542:	f406                	sd	ra,40(sp)
    80001544:	f022                	sd	s0,32(sp)
    80001546:	ec26                	sd	s1,24(sp)
    80001548:	e84a                	sd	s2,16(sp)
    8000154a:	e44e                	sd	s3,8(sp)
    8000154c:	1800                	addi	s0,sp,48
    8000154e:	89aa                	mv	s3,a0
    80001550:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001552:	00000097          	auipc	ra,0x0
    80001556:	8e6080e7          	jalr	-1818(ra) # 80000e38 <myproc>
    8000155a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	fde080e7          	jalr	-34(ra) # 8000653a <acquire>
  release(lk);
    80001564:	854a                	mv	a0,s2
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	088080e7          	jalr	136(ra) # 800065ee <release>

  // Go to sleep.
  p->chan = chan;
    8000156e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001572:	4789                	li	a5,2
    80001574:	cc9c                	sw	a5,24(s1)

  sched();
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	eb8080e7          	jalr	-328(ra) # 8000142e <sched>

  // Tidy up.
  p->chan = 0;
    8000157e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	06a080e7          	jalr	106(ra) # 800065ee <release>
  acquire(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	fac080e7          	jalr	-84(ra) # 8000653a <acquire>
}
    80001596:	70a2                	ld	ra,40(sp)
    80001598:	7402                	ld	s0,32(sp)
    8000159a:	64e2                	ld	s1,24(sp)
    8000159c:	6942                	ld	s2,16(sp)
    8000159e:	69a2                	ld	s3,8(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800015a4:	7139                	addi	sp,sp,-64
    800015a6:	fc06                	sd	ra,56(sp)
    800015a8:	f822                	sd	s0,48(sp)
    800015aa:	f426                	sd	s1,40(sp)
    800015ac:	f04a                	sd	s2,32(sp)
    800015ae:	ec4e                	sd	s3,24(sp)
    800015b0:	e852                	sd	s4,16(sp)
    800015b2:	e456                	sd	s5,8(sp)
    800015b4:	0080                	addi	s0,sp,64
    800015b6:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800015b8:	00007497          	auipc	s1,0x7
    800015bc:	7a848493          	addi	s1,s1,1960 # 80008d60 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800015c0:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800015c2:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800015c4:	00019917          	auipc	s2,0x19
    800015c8:	19c90913          	addi	s2,s2,412 # 8001a760 <tickslock>
    800015cc:	a811                	j	800015e0 <wakeup+0x3c>
      }
      release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	01e080e7          	jalr	30(ra) # 800065ee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800015d8:	46848493          	addi	s1,s1,1128
    800015dc:	03248663          	beq	s1,s2,80001608 <wakeup+0x64>
    if (p != myproc())
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	858080e7          	jalr	-1960(ra) # 80000e38 <myproc>
    800015e8:	fea488e3          	beq	s1,a0,800015d8 <wakeup+0x34>
      acquire(&p->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	f4c080e7          	jalr	-180(ra) # 8000653a <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800015f6:	4c9c                	lw	a5,24(s1)
    800015f8:	fd379be3          	bne	a5,s3,800015ce <wakeup+0x2a>
    800015fc:	709c                	ld	a5,32(s1)
    800015fe:	fd4798e3          	bne	a5,s4,800015ce <wakeup+0x2a>
        p->state = RUNNABLE;
    80001602:	0154ac23          	sw	s5,24(s1)
    80001606:	b7e1                	j	800015ce <wakeup+0x2a>
    }
  }
}
    80001608:	70e2                	ld	ra,56(sp)
    8000160a:	7442                	ld	s0,48(sp)
    8000160c:	74a2                	ld	s1,40(sp)
    8000160e:	7902                	ld	s2,32(sp)
    80001610:	69e2                	ld	s3,24(sp)
    80001612:	6a42                	ld	s4,16(sp)
    80001614:	6aa2                	ld	s5,8(sp)
    80001616:	6121                	addi	sp,sp,64
    80001618:	8082                	ret

000000008000161a <reparent>:
{
    8000161a:	7179                	addi	sp,sp,-48
    8000161c:	f406                	sd	ra,40(sp)
    8000161e:	f022                	sd	s0,32(sp)
    80001620:	ec26                	sd	s1,24(sp)
    80001622:	e84a                	sd	s2,16(sp)
    80001624:	e44e                	sd	s3,8(sp)
    80001626:	e052                	sd	s4,0(sp)
    80001628:	1800                	addi	s0,sp,48
    8000162a:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000162c:	00007497          	auipc	s1,0x7
    80001630:	73448493          	addi	s1,s1,1844 # 80008d60 <proc>
      pp->parent = initproc;
    80001634:	00007a17          	auipc	s4,0x7
    80001638:	2bca0a13          	addi	s4,s4,700 # 800088f0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000163c:	00019997          	auipc	s3,0x19
    80001640:	12498993          	addi	s3,s3,292 # 8001a760 <tickslock>
    80001644:	a029                	j	8000164e <reparent+0x34>
    80001646:	46848493          	addi	s1,s1,1128
    8000164a:	01348d63          	beq	s1,s3,80001664 <reparent+0x4a>
    if (pp->parent == p)
    8000164e:	7c9c                	ld	a5,56(s1)
    80001650:	ff279be3          	bne	a5,s2,80001646 <reparent+0x2c>
      pp->parent = initproc;
    80001654:	000a3503          	ld	a0,0(s4)
    80001658:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	f4a080e7          	jalr	-182(ra) # 800015a4 <wakeup>
    80001662:	b7d5                	j	80001646 <reparent+0x2c>
}
    80001664:	70a2                	ld	ra,40(sp)
    80001666:	7402                	ld	s0,32(sp)
    80001668:	64e2                	ld	s1,24(sp)
    8000166a:	6942                	ld	s2,16(sp)
    8000166c:	69a2                	ld	s3,8(sp)
    8000166e:	6a02                	ld	s4,0(sp)
    80001670:	6145                	addi	sp,sp,48
    80001672:	8082                	ret

0000000080001674 <exit>:
{
    80001674:	7179                	addi	sp,sp,-48
    80001676:	f406                	sd	ra,40(sp)
    80001678:	f022                	sd	s0,32(sp)
    8000167a:	ec26                	sd	s1,24(sp)
    8000167c:	e84a                	sd	s2,16(sp)
    8000167e:	e44e                	sd	s3,8(sp)
    80001680:	e052                	sd	s4,0(sp)
    80001682:	1800                	addi	s0,sp,48
    80001684:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001686:	fffff097          	auipc	ra,0xfffff
    8000168a:	7b2080e7          	jalr	1970(ra) # 80000e38 <myproc>
    8000168e:	89aa                	mv	s3,a0
  if (p == initproc)
    80001690:	00007797          	auipc	a5,0x7
    80001694:	2607b783          	ld	a5,608(a5) # 800088f0 <initproc>
    80001698:	0d050493          	addi	s1,a0,208
    8000169c:	15050913          	addi	s2,a0,336
    800016a0:	02a79363          	bne	a5,a0,800016c6 <exit+0x52>
    panic("init exiting");
    800016a4:	00007517          	auipc	a0,0x7
    800016a8:	b0450513          	addi	a0,a0,-1276 # 800081a8 <etext+0x1a8>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	952080e7          	jalr	-1710(ra) # 80005ffe <panic>
      fileclose(f);
    800016b4:	00002097          	auipc	ra,0x2
    800016b8:	410080e7          	jalr	1040(ra) # 80003ac4 <fileclose>
      p->ofile[fd] = 0;
    800016bc:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800016c0:	04a1                	addi	s1,s1,8
    800016c2:	01248563          	beq	s1,s2,800016cc <exit+0x58>
    if (p->ofile[fd])
    800016c6:	6088                	ld	a0,0(s1)
    800016c8:	f575                	bnez	a0,800016b4 <exit+0x40>
    800016ca:	bfdd                	j	800016c0 <exit+0x4c>
  begin_op();
    800016cc:	00002097          	auipc	ra,0x2
    800016d0:	f2c080e7          	jalr	-212(ra) # 800035f8 <begin_op>
  iput(p->cwd);
    800016d4:	1509b503          	ld	a0,336(s3)
    800016d8:	00001097          	auipc	ra,0x1
    800016dc:	714080e7          	jalr	1812(ra) # 80002dec <iput>
  end_op();
    800016e0:	00002097          	auipc	ra,0x2
    800016e4:	f98080e7          	jalr	-104(ra) # 80003678 <end_op>
  p->cwd = 0;
    800016e8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016ec:	00007497          	auipc	s1,0x7
    800016f0:	25c48493          	addi	s1,s1,604 # 80008948 <wait_lock>
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	e44080e7          	jalr	-444(ra) # 8000653a <acquire>
  reparent(p);
    800016fe:	854e                	mv	a0,s3
    80001700:	00000097          	auipc	ra,0x0
    80001704:	f1a080e7          	jalr	-230(ra) # 8000161a <reparent>
  wakeup(p->parent);
    80001708:	0389b503          	ld	a0,56(s3)
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	e98080e7          	jalr	-360(ra) # 800015a4 <wakeup>
  acquire(&p->lock);
    80001714:	854e                	mv	a0,s3
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	e24080e7          	jalr	-476(ra) # 8000653a <acquire>
  p->xstate = status;
    8000171e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001722:	4795                	li	a5,5
    80001724:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	ec4080e7          	jalr	-316(ra) # 800065ee <release>
  sched();
    80001732:	00000097          	auipc	ra,0x0
    80001736:	cfc080e7          	jalr	-772(ra) # 8000142e <sched>
  panic("zombie exit");
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	a7e50513          	addi	a0,a0,-1410 # 800081b8 <etext+0x1b8>
    80001742:	00005097          	auipc	ra,0x5
    80001746:	8bc080e7          	jalr	-1860(ra) # 80005ffe <panic>

000000008000174a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000174a:	7179                	addi	sp,sp,-48
    8000174c:	f406                	sd	ra,40(sp)
    8000174e:	f022                	sd	s0,32(sp)
    80001750:	ec26                	sd	s1,24(sp)
    80001752:	e84a                	sd	s2,16(sp)
    80001754:	e44e                	sd	s3,8(sp)
    80001756:	1800                	addi	s0,sp,48
    80001758:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000175a:	00007497          	auipc	s1,0x7
    8000175e:	60648493          	addi	s1,s1,1542 # 80008d60 <proc>
    80001762:	00019997          	auipc	s3,0x19
    80001766:	ffe98993          	addi	s3,s3,-2 # 8001a760 <tickslock>
  {
    acquire(&p->lock);
    8000176a:	8526                	mv	a0,s1
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	dce080e7          	jalr	-562(ra) # 8000653a <acquire>
    if (p->pid == pid)
    80001774:	589c                	lw	a5,48(s1)
    80001776:	01278d63          	beq	a5,s2,80001790 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	e72080e7          	jalr	-398(ra) # 800065ee <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001784:	46848493          	addi	s1,s1,1128
    80001788:	ff3491e3          	bne	s1,s3,8000176a <kill+0x20>
  }
  return -1;
    8000178c:	557d                	li	a0,-1
    8000178e:	a829                	j	800017a8 <kill+0x5e>
      p->killed = 1;
    80001790:	4785                	li	a5,1
    80001792:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80001794:	4c98                	lw	a4,24(s1)
    80001796:	4789                	li	a5,2
    80001798:	00f70f63          	beq	a4,a5,800017b6 <kill+0x6c>
      release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	e50080e7          	jalr	-432(ra) # 800065ee <release>
      return 0;
    800017a6:	4501                	li	a0,0
}
    800017a8:	70a2                	ld	ra,40(sp)
    800017aa:	7402                	ld	s0,32(sp)
    800017ac:	64e2                	ld	s1,24(sp)
    800017ae:	6942                	ld	s2,16(sp)
    800017b0:	69a2                	ld	s3,8(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret
        p->state = RUNNABLE;
    800017b6:	478d                	li	a5,3
    800017b8:	cc9c                	sw	a5,24(s1)
    800017ba:	b7cd                	j	8000179c <kill+0x52>

00000000800017bc <setkilled>:

void setkilled(struct proc *p)
{
    800017bc:	1101                	addi	sp,sp,-32
    800017be:	ec06                	sd	ra,24(sp)
    800017c0:	e822                	sd	s0,16(sp)
    800017c2:	e426                	sd	s1,8(sp)
    800017c4:	1000                	addi	s0,sp,32
    800017c6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	d72080e7          	jalr	-654(ra) # 8000653a <acquire>
  p->killed = 1;
    800017d0:	4785                	li	a5,1
    800017d2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	e18080e7          	jalr	-488(ra) # 800065ee <release>
}
    800017de:	60e2                	ld	ra,24(sp)
    800017e0:	6442                	ld	s0,16(sp)
    800017e2:	64a2                	ld	s1,8(sp)
    800017e4:	6105                	addi	sp,sp,32
    800017e6:	8082                	ret

00000000800017e8 <killed>:

int killed(struct proc *p)
{
    800017e8:	1101                	addi	sp,sp,-32
    800017ea:	ec06                	sd	ra,24(sp)
    800017ec:	e822                	sd	s0,16(sp)
    800017ee:	e426                	sd	s1,8(sp)
    800017f0:	e04a                	sd	s2,0(sp)
    800017f2:	1000                	addi	s0,sp,32
    800017f4:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	d44080e7          	jalr	-700(ra) # 8000653a <acquire>
  k = p->killed;
    800017fe:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001802:	8526                	mv	a0,s1
    80001804:	00005097          	auipc	ra,0x5
    80001808:	dea080e7          	jalr	-534(ra) # 800065ee <release>
  return k;
}
    8000180c:	854a                	mv	a0,s2
    8000180e:	60e2                	ld	ra,24(sp)
    80001810:	6442                	ld	s0,16(sp)
    80001812:	64a2                	ld	s1,8(sp)
    80001814:	6902                	ld	s2,0(sp)
    80001816:	6105                	addi	sp,sp,32
    80001818:	8082                	ret

000000008000181a <wait>:
{
    8000181a:	715d                	addi	sp,sp,-80
    8000181c:	e486                	sd	ra,72(sp)
    8000181e:	e0a2                	sd	s0,64(sp)
    80001820:	fc26                	sd	s1,56(sp)
    80001822:	f84a                	sd	s2,48(sp)
    80001824:	f44e                	sd	s3,40(sp)
    80001826:	f052                	sd	s4,32(sp)
    80001828:	ec56                	sd	s5,24(sp)
    8000182a:	e85a                	sd	s6,16(sp)
    8000182c:	e45e                	sd	s7,8(sp)
    8000182e:	e062                	sd	s8,0(sp)
    80001830:	0880                	addi	s0,sp,80
    80001832:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	604080e7          	jalr	1540(ra) # 80000e38 <myproc>
    8000183c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000183e:	00007517          	auipc	a0,0x7
    80001842:	10a50513          	addi	a0,a0,266 # 80008948 <wait_lock>
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	cf4080e7          	jalr	-780(ra) # 8000653a <acquire>
    havekids = 0;
    8000184e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80001850:	4a15                	li	s4,5
        havekids = 1;
    80001852:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001854:	00019997          	auipc	s3,0x19
    80001858:	f0c98993          	addi	s3,s3,-244 # 8001a760 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000185c:	00007c17          	auipc	s8,0x7
    80001860:	0ecc0c13          	addi	s8,s8,236 # 80008948 <wait_lock>
    havekids = 0;
    80001864:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001866:	00007497          	auipc	s1,0x7
    8000186a:	4fa48493          	addi	s1,s1,1274 # 80008d60 <proc>
    8000186e:	a0bd                	j	800018dc <wait+0xc2>
          pid = pp->pid;
    80001870:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001874:	000b0e63          	beqz	s6,80001890 <wait+0x76>
    80001878:	4691                	li	a3,4
    8000187a:	02c48613          	addi	a2,s1,44
    8000187e:	85da                	mv	a1,s6
    80001880:	05093503          	ld	a0,80(s2)
    80001884:	fffff097          	auipc	ra,0xfffff
    80001888:	270080e7          	jalr	624(ra) # 80000af4 <copyout>
    8000188c:	02054563          	bltz	a0,800018b6 <wait+0x9c>
          freeproc(pp);
    80001890:	8526                	mv	a0,s1
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	758080e7          	jalr	1880(ra) # 80000fea <freeproc>
          release(&pp->lock);
    8000189a:	8526                	mv	a0,s1
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	d52080e7          	jalr	-686(ra) # 800065ee <release>
          release(&wait_lock);
    800018a4:	00007517          	auipc	a0,0x7
    800018a8:	0a450513          	addi	a0,a0,164 # 80008948 <wait_lock>
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	d42080e7          	jalr	-702(ra) # 800065ee <release>
          return pid;
    800018b4:	a0b5                	j	80001920 <wait+0x106>
            release(&pp->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	d36080e7          	jalr	-714(ra) # 800065ee <release>
            release(&wait_lock);
    800018c0:	00007517          	auipc	a0,0x7
    800018c4:	08850513          	addi	a0,a0,136 # 80008948 <wait_lock>
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	d26080e7          	jalr	-730(ra) # 800065ee <release>
            return -1;
    800018d0:	59fd                	li	s3,-1
    800018d2:	a0b9                	j	80001920 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800018d4:	46848493          	addi	s1,s1,1128
    800018d8:	03348463          	beq	s1,s3,80001900 <wait+0xe6>
      if (pp->parent == p)
    800018dc:	7c9c                	ld	a5,56(s1)
    800018de:	ff279be3          	bne	a5,s2,800018d4 <wait+0xba>
        acquire(&pp->lock);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	c56080e7          	jalr	-938(ra) # 8000653a <acquire>
        if (pp->state == ZOMBIE)
    800018ec:	4c9c                	lw	a5,24(s1)
    800018ee:	f94781e3          	beq	a5,s4,80001870 <wait+0x56>
        release(&pp->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	cfa080e7          	jalr	-774(ra) # 800065ee <release>
        havekids = 1;
    800018fc:	8756                	mv	a4,s5
    800018fe:	bfd9                	j	800018d4 <wait+0xba>
    if (!havekids || killed(p))
    80001900:	c719                	beqz	a4,8000190e <wait+0xf4>
    80001902:	854a                	mv	a0,s2
    80001904:	00000097          	auipc	ra,0x0
    80001908:	ee4080e7          	jalr	-284(ra) # 800017e8 <killed>
    8000190c:	c51d                	beqz	a0,8000193a <wait+0x120>
      release(&wait_lock);
    8000190e:	00007517          	auipc	a0,0x7
    80001912:	03a50513          	addi	a0,a0,58 # 80008948 <wait_lock>
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	cd8080e7          	jalr	-808(ra) # 800065ee <release>
      return -1;
    8000191e:	59fd                	li	s3,-1
}
    80001920:	854e                	mv	a0,s3
    80001922:	60a6                	ld	ra,72(sp)
    80001924:	6406                	ld	s0,64(sp)
    80001926:	74e2                	ld	s1,56(sp)
    80001928:	7942                	ld	s2,48(sp)
    8000192a:	79a2                	ld	s3,40(sp)
    8000192c:	7a02                	ld	s4,32(sp)
    8000192e:	6ae2                	ld	s5,24(sp)
    80001930:	6b42                	ld	s6,16(sp)
    80001932:	6ba2                	ld	s7,8(sp)
    80001934:	6c02                	ld	s8,0(sp)
    80001936:	6161                	addi	sp,sp,80
    80001938:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000193a:	85e2                	mv	a1,s8
    8000193c:	854a                	mv	a0,s2
    8000193e:	00000097          	auipc	ra,0x0
    80001942:	c02080e7          	jalr	-1022(ra) # 80001540 <sleep>
    havekids = 0;
    80001946:	bf39                	j	80001864 <wait+0x4a>

0000000080001948 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001948:	7179                	addi	sp,sp,-48
    8000194a:	f406                	sd	ra,40(sp)
    8000194c:	f022                	sd	s0,32(sp)
    8000194e:	ec26                	sd	s1,24(sp)
    80001950:	e84a                	sd	s2,16(sp)
    80001952:	e44e                	sd	s3,8(sp)
    80001954:	e052                	sd	s4,0(sp)
    80001956:	1800                	addi	s0,sp,48
    80001958:	84aa                	mv	s1,a0
    8000195a:	892e                	mv	s2,a1
    8000195c:	89b2                	mv	s3,a2
    8000195e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	4d8080e7          	jalr	1240(ra) # 80000e38 <myproc>
  if (user_dst)
    80001968:	c08d                	beqz	s1,8000198a <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    8000196a:	86d2                	mv	a3,s4
    8000196c:	864e                	mv	a2,s3
    8000196e:	85ca                	mv	a1,s2
    80001970:	6928                	ld	a0,80(a0)
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	182080e7          	jalr	386(ra) # 80000af4 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000197a:	70a2                	ld	ra,40(sp)
    8000197c:	7402                	ld	s0,32(sp)
    8000197e:	64e2                	ld	s1,24(sp)
    80001980:	6942                	ld	s2,16(sp)
    80001982:	69a2                	ld	s3,8(sp)
    80001984:	6a02                	ld	s4,0(sp)
    80001986:	6145                	addi	sp,sp,48
    80001988:	8082                	ret
    memmove((char *)dst, src, len);
    8000198a:	000a061b          	sext.w	a2,s4
    8000198e:	85ce                	mv	a1,s3
    80001990:	854a                	mv	a0,s2
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	842080e7          	jalr	-1982(ra) # 800001d4 <memmove>
    return 0;
    8000199a:	8526                	mv	a0,s1
    8000199c:	bff9                	j	8000197a <either_copyout+0x32>

000000008000199e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000199e:	7179                	addi	sp,sp,-48
    800019a0:	f406                	sd	ra,40(sp)
    800019a2:	f022                	sd	s0,32(sp)
    800019a4:	ec26                	sd	s1,24(sp)
    800019a6:	e84a                	sd	s2,16(sp)
    800019a8:	e44e                	sd	s3,8(sp)
    800019aa:	e052                	sd	s4,0(sp)
    800019ac:	1800                	addi	s0,sp,48
    800019ae:	892a                	mv	s2,a0
    800019b0:	84ae                	mv	s1,a1
    800019b2:	89b2                	mv	s3,a2
    800019b4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	482080e7          	jalr	1154(ra) # 80000e38 <myproc>
  if (user_src)
    800019be:	c08d                	beqz	s1,800019e0 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800019c0:	86d2                	mv	a3,s4
    800019c2:	864e                	mv	a2,s3
    800019c4:	85ca                	mv	a1,s2
    800019c6:	6928                	ld	a0,80(a0)
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	1b8080e7          	jalr	440(ra) # 80000b80 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800019d0:	70a2                	ld	ra,40(sp)
    800019d2:	7402                	ld	s0,32(sp)
    800019d4:	64e2                	ld	s1,24(sp)
    800019d6:	6942                	ld	s2,16(sp)
    800019d8:	69a2                	ld	s3,8(sp)
    800019da:	6a02                	ld	s4,0(sp)
    800019dc:	6145                	addi	sp,sp,48
    800019de:	8082                	ret
    memmove(dst, (char *)src, len);
    800019e0:	000a061b          	sext.w	a2,s4
    800019e4:	85ce                	mv	a1,s3
    800019e6:	854a                	mv	a0,s2
    800019e8:	ffffe097          	auipc	ra,0xffffe
    800019ec:	7ec080e7          	jalr	2028(ra) # 800001d4 <memmove>
    return 0;
    800019f0:	8526                	mv	a0,s1
    800019f2:	bff9                	j	800019d0 <either_copyin+0x32>

00000000800019f4 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019f4:	715d                	addi	sp,sp,-80
    800019f6:	e486                	sd	ra,72(sp)
    800019f8:	e0a2                	sd	s0,64(sp)
    800019fa:	fc26                	sd	s1,56(sp)
    800019fc:	f84a                	sd	s2,48(sp)
    800019fe:	f44e                	sd	s3,40(sp)
    80001a00:	f052                	sd	s4,32(sp)
    80001a02:	ec56                	sd	s5,24(sp)
    80001a04:	e85a                	sd	s6,16(sp)
    80001a06:	e45e                	sd	s7,8(sp)
    80001a08:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001a0a:	00006517          	auipc	a0,0x6
    80001a0e:	63e50513          	addi	a0,a0,1598 # 80008048 <etext+0x48>
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	636080e7          	jalr	1590(ra) # 80006048 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a1a:	00007497          	auipc	s1,0x7
    80001a1e:	49e48493          	addi	s1,s1,1182 # 80008eb8 <proc+0x158>
    80001a22:	00019917          	auipc	s2,0x19
    80001a26:	e9690913          	addi	s2,s2,-362 # 8001a8b8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a2c:	00006997          	auipc	s3,0x6
    80001a30:	79c98993          	addi	s3,s3,1948 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a34:	00006a97          	auipc	s5,0x6
    80001a38:	79ca8a93          	addi	s5,s5,1948 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001a3c:	00006a17          	auipc	s4,0x6
    80001a40:	60ca0a13          	addi	s4,s4,1548 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a44:	00006b97          	auipc	s7,0x6
    80001a48:	7ccb8b93          	addi	s7,s7,1996 # 80008210 <states.0>
    80001a4c:	a00d                	j	80001a6e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a4e:	ed86a583          	lw	a1,-296(a3)
    80001a52:	8556                	mv	a0,s5
    80001a54:	00004097          	auipc	ra,0x4
    80001a58:	5f4080e7          	jalr	1524(ra) # 80006048 <printf>
    printf("\n");
    80001a5c:	8552                	mv	a0,s4
    80001a5e:	00004097          	auipc	ra,0x4
    80001a62:	5ea080e7          	jalr	1514(ra) # 80006048 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a66:	46848493          	addi	s1,s1,1128
    80001a6a:	03248263          	beq	s1,s2,80001a8e <procdump+0x9a>
    if (p->state == UNUSED)
    80001a6e:	86a6                	mv	a3,s1
    80001a70:	ec04a783          	lw	a5,-320(s1)
    80001a74:	dbed                	beqz	a5,80001a66 <procdump+0x72>
      state = "???";
    80001a76:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a78:	fcfb6be3          	bltu	s6,a5,80001a4e <procdump+0x5a>
    80001a7c:	02079713          	slli	a4,a5,0x20
    80001a80:	01d75793          	srli	a5,a4,0x1d
    80001a84:	97de                	add	a5,a5,s7
    80001a86:	6390                	ld	a2,0(a5)
    80001a88:	f279                	bnez	a2,80001a4e <procdump+0x5a>
      state = "???";
    80001a8a:	864e                	mv	a2,s3
    80001a8c:	b7c9                	j	80001a4e <procdump+0x5a>
  }
}
    80001a8e:	60a6                	ld	ra,72(sp)
    80001a90:	6406                	ld	s0,64(sp)
    80001a92:	74e2                	ld	s1,56(sp)
    80001a94:	7942                	ld	s2,48(sp)
    80001a96:	79a2                	ld	s3,40(sp)
    80001a98:	7a02                	ld	s4,32(sp)
    80001a9a:	6ae2                	ld	s5,24(sp)
    80001a9c:	6b42                	ld	s6,16(sp)
    80001a9e:	6ba2                	ld	s7,8(sp)
    80001aa0:	6161                	addi	sp,sp,80
    80001aa2:	8082                	ret

0000000080001aa4 <swtch>:
    80001aa4:	00153023          	sd	ra,0(a0)
    80001aa8:	00253423          	sd	sp,8(a0)
    80001aac:	e900                	sd	s0,16(a0)
    80001aae:	ed04                	sd	s1,24(a0)
    80001ab0:	03253023          	sd	s2,32(a0)
    80001ab4:	03353423          	sd	s3,40(a0)
    80001ab8:	03453823          	sd	s4,48(a0)
    80001abc:	03553c23          	sd	s5,56(a0)
    80001ac0:	05653023          	sd	s6,64(a0)
    80001ac4:	05753423          	sd	s7,72(a0)
    80001ac8:	05853823          	sd	s8,80(a0)
    80001acc:	05953c23          	sd	s9,88(a0)
    80001ad0:	07a53023          	sd	s10,96(a0)
    80001ad4:	07b53423          	sd	s11,104(a0)
    80001ad8:	0005b083          	ld	ra,0(a1)
    80001adc:	0085b103          	ld	sp,8(a1)
    80001ae0:	6980                	ld	s0,16(a1)
    80001ae2:	6d84                	ld	s1,24(a1)
    80001ae4:	0205b903          	ld	s2,32(a1)
    80001ae8:	0285b983          	ld	s3,40(a1)
    80001aec:	0305ba03          	ld	s4,48(a1)
    80001af0:	0385ba83          	ld	s5,56(a1)
    80001af4:	0405bb03          	ld	s6,64(a1)
    80001af8:	0485bb83          	ld	s7,72(a1)
    80001afc:	0505bc03          	ld	s8,80(a1)
    80001b00:	0585bc83          	ld	s9,88(a1)
    80001b04:	0605bd03          	ld	s10,96(a1)
    80001b08:	0685bd83          	ld	s11,104(a1)
    80001b0c:	8082                	ret

0000000080001b0e <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b0e:	1141                	addi	sp,sp,-16
    80001b10:	e406                	sd	ra,8(sp)
    80001b12:	e022                	sd	s0,0(sp)
    80001b14:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b16:	00006597          	auipc	a1,0x6
    80001b1a:	72a58593          	addi	a1,a1,1834 # 80008240 <states.0+0x30>
    80001b1e:	00019517          	auipc	a0,0x19
    80001b22:	c4250513          	addi	a0,a0,-958 # 8001a760 <tickslock>
    80001b26:	00005097          	auipc	ra,0x5
    80001b2a:	984080e7          	jalr	-1660(ra) # 800064aa <initlock>
}
    80001b2e:	60a2                	ld	ra,8(sp)
    80001b30:	6402                	ld	s0,0(sp)
    80001b32:	0141                	addi	sp,sp,16
    80001b34:	8082                	ret

0000000080001b36 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b36:	1141                	addi	sp,sp,-16
    80001b38:	e422                	sd	s0,8(sp)
    80001b3a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3c:	00004797          	auipc	a5,0x4
    80001b40:	8f478793          	addi	a5,a5,-1804 # 80005430 <kernelvec>
    80001b44:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b48:	6422                	ld	s0,8(sp)
    80001b4a:	0141                	addi	sp,sp,16
    80001b4c:	8082                	ret

0000000080001b4e <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b4e:	1141                	addi	sp,sp,-16
    80001b50:	e406                	sd	ra,8(sp)
    80001b52:	e022                	sd	s0,0(sp)
    80001b54:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b56:	fffff097          	auipc	ra,0xfffff
    80001b5a:	2e2080e7          	jalr	738(ra) # 80000e38 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b62:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b64:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b68:	00005617          	auipc	a2,0x5
    80001b6c:	49860613          	addi	a2,a2,1176 # 80007000 <_trampoline>
    80001b70:	00005697          	auipc	a3,0x5
    80001b74:	49068693          	addi	a3,a3,1168 # 80007000 <_trampoline>
    80001b78:	8e91                	sub	a3,a3,a2
    80001b7a:	040007b7          	lui	a5,0x4000
    80001b7e:	17fd                	addi	a5,a5,-1
    80001b80:	07b2                	slli	a5,a5,0xc
    80001b82:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b84:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b88:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b8a:	180026f3          	csrr	a3,satp
    80001b8e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b90:	6d38                	ld	a4,88(a0)
    80001b92:	6134                	ld	a3,64(a0)
    80001b94:	6585                	lui	a1,0x1
    80001b96:	96ae                	add	a3,a3,a1
    80001b98:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b9a:	6d38                	ld	a4,88(a0)
    80001b9c:	00000697          	auipc	a3,0x0
    80001ba0:	13068693          	addi	a3,a3,304 # 80001ccc <usertrap>
    80001ba4:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001ba6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ba8:	8692                	mv	a3,tp
    80001baa:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bac:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb0:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb4:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb8:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bbc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bbe:	6f18                	ld	a4,24(a4)
    80001bc0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bc4:	6928                	ld	a0,80(a0)
    80001bc6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bc8:	00005717          	auipc	a4,0x5
    80001bcc:	4d470713          	addi	a4,a4,1236 # 8000709c <userret>
    80001bd0:	8f11                	sub	a4,a4,a2
    80001bd2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bd4:	577d                	li	a4,-1
    80001bd6:	177e                	slli	a4,a4,0x3f
    80001bd8:	8d59                	or	a0,a0,a4
    80001bda:	9782                	jalr	a5
}
    80001bdc:	60a2                	ld	ra,8(sp)
    80001bde:	6402                	ld	s0,0(sp)
    80001be0:	0141                	addi	sp,sp,16
    80001be2:	8082                	ret

0000000080001be4 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001be4:	1101                	addi	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bee:	00019497          	auipc	s1,0x19
    80001bf2:	b7248493          	addi	s1,s1,-1166 # 8001a760 <tickslock>
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00005097          	auipc	ra,0x5
    80001bfc:	942080e7          	jalr	-1726(ra) # 8000653a <acquire>
  ticks++;
    80001c00:	00007517          	auipc	a0,0x7
    80001c04:	cf850513          	addi	a0,a0,-776 # 800088f8 <ticks>
    80001c08:	411c                	lw	a5,0(a0)
    80001c0a:	2785                	addiw	a5,a5,1
    80001c0c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	996080e7          	jalr	-1642(ra) # 800015a4 <wakeup>
  release(&tickslock);
    80001c16:	8526                	mv	a0,s1
    80001c18:	00005097          	auipc	ra,0x5
    80001c1c:	9d6080e7          	jalr	-1578(ra) # 800065ee <release>
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	6105                	addi	sp,sp,32
    80001c28:	8082                	ret

0000000080001c2a <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c2a:	1101                	addi	sp,sp,-32
    80001c2c:	ec06                	sd	ra,24(sp)
    80001c2e:	e822                	sd	s0,16(sp)
    80001c30:	e426                	sd	s1,8(sp)
    80001c32:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c34:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001c38:	00074d63          	bltz	a4,80001c52 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001c3c:	57fd                	li	a5,-1
    80001c3e:	17fe                	slli	a5,a5,0x3f
    80001c40:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001c42:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001c44:	06f70363          	beq	a4,a5,80001caa <devintr+0x80>
  }
}
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret
      (scause & 0xff) == 9)
    80001c52:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80001c56:	46a5                	li	a3,9
    80001c58:	fed792e3          	bne	a5,a3,80001c3c <devintr+0x12>
    int irq = plic_claim();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	8dc080e7          	jalr	-1828(ra) # 80005538 <plic_claim>
    80001c64:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001c66:	47a9                	li	a5,10
    80001c68:	02f50763          	beq	a0,a5,80001c96 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001c6c:	4785                	li	a5,1
    80001c6e:	02f50963          	beq	a0,a5,80001ca0 <devintr+0x76>
    return 1;
    80001c72:	4505                	li	a0,1
    else if (irq)
    80001c74:	d8f1                	beqz	s1,80001c48 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c76:	85a6                	mv	a1,s1
    80001c78:	00006517          	auipc	a0,0x6
    80001c7c:	5d050513          	addi	a0,a0,1488 # 80008248 <states.0+0x38>
    80001c80:	00004097          	auipc	ra,0x4
    80001c84:	3c8080e7          	jalr	968(ra) # 80006048 <printf>
      plic_complete(irq);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	8d2080e7          	jalr	-1838(ra) # 8000555c <plic_complete>
    return 1;
    80001c92:	4505                	li	a0,1
    80001c94:	bf55                	j	80001c48 <devintr+0x1e>
      uartintr();
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	7c4080e7          	jalr	1988(ra) # 8000645a <uartintr>
    80001c9e:	b7ed                	j	80001c88 <devintr+0x5e>
      virtio_disk_intr();
    80001ca0:	00004097          	auipc	ra,0x4
    80001ca4:	d88080e7          	jalr	-632(ra) # 80005a28 <virtio_disk_intr>
    80001ca8:	b7c5                	j	80001c88 <devintr+0x5e>
    if (cpuid() == 0)
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	162080e7          	jalr	354(ra) # 80000e0c <cpuid>
    80001cb2:	c901                	beqz	a0,80001cc2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cb4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cb8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cba:	14479073          	csrw	sip,a5
    return 2;
    80001cbe:	4509                	li	a0,2
    80001cc0:	b761                	j	80001c48 <devintr+0x1e>
      clockintr();
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f22080e7          	jalr	-222(ra) # 80001be4 <clockintr>
    80001cca:	b7ed                	j	80001cb4 <devintr+0x8a>

0000000080001ccc <usertrap>:
{
    80001ccc:	7139                	addi	sp,sp,-64
    80001cce:	fc06                	sd	ra,56(sp)
    80001cd0:	f822                	sd	s0,48(sp)
    80001cd2:	f426                	sd	s1,40(sp)
    80001cd4:	f04a                	sd	s2,32(sp)
    80001cd6:	ec4e                	sd	s3,24(sp)
    80001cd8:	e852                	sd	s4,16(sp)
    80001cda:	e456                	sd	s5,8(sp)
    80001cdc:	e05a                	sd	s6,0(sp)
    80001cde:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce0:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce4:	1007f793          	andi	a5,a5,256
    80001ce8:	e7c1                	bnez	a5,80001d70 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cea:	00003797          	auipc	a5,0x3
    80001cee:	74678793          	addi	a5,a5,1862 # 80005430 <kernelvec>
    80001cf2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	142080e7          	jalr	322(ra) # 80000e38 <myproc>
    80001cfe:	892a                	mv	s2,a0
  p->trapframe->epc = r_sepc();
    80001d00:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d02:	14102773          	csrr	a4,sepc
    80001d06:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d08:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001d0c:	47a1                	li	a5,8
    80001d0e:	06f70963          	beq	a4,a5,80001d80 <usertrap+0xb4>
  else if ((which_dev = devintr()) != 0)
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	f18080e7          	jalr	-232(ra) # 80001c2a <devintr>
    80001d1a:	84aa                	mv	s1,a0
    80001d1c:	18051f63          	bnez	a0,80001eba <usertrap+0x1ee>
    80001d20:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001d24:	47b5                	li	a5,13
    80001d26:	0af70c63          	beq	a4,a5,80001dde <usertrap+0x112>
    80001d2a:	14202773          	csrr	a4,scause
    80001d2e:	47bd                	li	a5,15
    80001d30:	0af70763          	beq	a4,a5,80001dde <usertrap+0x112>
    80001d34:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d38:	03092603          	lw	a2,48(s2)
    80001d3c:	00006517          	auipc	a0,0x6
    80001d40:	5b450513          	addi	a0,a0,1460 # 800082f0 <states.0+0xe0>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	304080e7          	jalr	772(ra) # 80006048 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d50:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	5cc50513          	addi	a0,a0,1484 # 80008320 <states.0+0x110>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	2ec080e7          	jalr	748(ra) # 80006048 <printf>
    setkilled(p);
    80001d64:	854a                	mv	a0,s2
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	a56080e7          	jalr	-1450(ra) # 800017bc <setkilled>
    80001d6e:	a82d                	j	80001da8 <usertrap+0xdc>
    panic("usertrap: not from user mode");
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	4f850513          	addi	a0,a0,1272 # 80008268 <states.0+0x58>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	286080e7          	jalr	646(ra) # 80005ffe <panic>
    if (killed(p))
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	a68080e7          	jalr	-1432(ra) # 800017e8 <killed>
    80001d88:	e529                	bnez	a0,80001dd2 <usertrap+0x106>
    p->trapframe->epc += 4;
    80001d8a:	05893703          	ld	a4,88(s2)
    80001d8e:	6f1c                	ld	a5,24(a4)
    80001d90:	0791                	addi	a5,a5,4
    80001d92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	38e080e7          	jalr	910(ra) # 8000212e <syscall>
  if (killed(p))
    80001da8:	854a                	mv	a0,s2
    80001daa:	00000097          	auipc	ra,0x0
    80001dae:	a3e080e7          	jalr	-1474(ra) # 800017e8 <killed>
    80001db2:	10051b63          	bnez	a0,80001ec8 <usertrap+0x1fc>
  usertrapret();
    80001db6:	00000097          	auipc	ra,0x0
    80001dba:	d98080e7          	jalr	-616(ra) # 80001b4e <usertrapret>
}
    80001dbe:	70e2                	ld	ra,56(sp)
    80001dc0:	7442                	ld	s0,48(sp)
    80001dc2:	74a2                	ld	s1,40(sp)
    80001dc4:	7902                	ld	s2,32(sp)
    80001dc6:	69e2                	ld	s3,24(sp)
    80001dc8:	6a42                	ld	s4,16(sp)
    80001dca:	6aa2                	ld	s5,8(sp)
    80001dcc:	6b02                	ld	s6,0(sp)
    80001dce:	6121                	addi	sp,sp,64
    80001dd0:	8082                	ret
      exit(-1);
    80001dd2:	557d                	li	a0,-1
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	8a0080e7          	jalr	-1888(ra) # 80001674 <exit>
    80001ddc:	b77d                	j	80001d8a <usertrap+0xbe>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dde:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001de2:	767d                	lui	a2,0xfffff
    80001de4:	00c9f9b3          	and	s3,s3,a2
    char *mem = kalloc();
    80001de8:	ffffe097          	auipc	ra,0xffffe
    80001dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80001df0:	8a2a                	mv	s4,a0
    if (mem == 0)
    80001df2:	16890793          	addi	a5,s2,360
    for (int i = 0; i < VMASIZE; i++)
    80001df6:	4841                	li	a6,16
    if (mem == 0)
    80001df8:	ed19                	bnez	a0,80001e16 <usertrap+0x14a>
      printf("usertrap(): out of memory\n");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	48e50513          	addi	a0,a0,1166 # 80008288 <states.0+0x78>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	246080e7          	jalr	582(ra) # 80006048 <printf>
      goto err;
    80001e0a:	b72d                	j	80001d34 <usertrap+0x68>
    for (int i = 0; i < VMASIZE; i++)
    80001e0c:	2485                	addiw	s1,s1,1
    80001e0e:	03078793          	addi	a5,a5,48
    80001e12:	07048d63          	beq	s1,a6,80001e8c <usertrap+0x1c0>
      if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) // fix
    80001e16:	6398                	ld	a4,0(a5)
    80001e18:	fee9eae3          	bltu	s3,a4,80001e0c <usertrap+0x140>
    80001e1c:	4790                	lw	a2,8(a5)
    80001e1e:	9732                	add	a4,a4,a2
    80001e20:	fee9f6e3          	bgeu	s3,a4,80001e0c <usertrap+0x140>
    if (idx == -1)
    80001e24:	57fd                	li	a5,-1
    80001e26:	06f48363          	beq	s1,a5,80001e8c <usertrap+0x1c0>
      struct vma v = p->vma[idx];
    80001e2a:	00149793          	slli	a5,s1,0x1
    80001e2e:	00978733          	add	a4,a5,s1
    80001e32:	0712                	slli	a4,a4,0x4
    80001e34:	974a                	add	a4,a4,s2
    80001e36:	16873a83          	ld	s5,360(a4)
    80001e3a:	18072b03          	lw	s6,384(a4)
    80001e3e:	18873483          	ld	s1,392(a4)
      memset(mem, 0, PGSIZE); // zero out the memory
    80001e42:	6605                	lui	a2,0x1
    80001e44:	4581                	li	a1,0
    80001e46:	8552                	mv	a0,s4
    80001e48:	ffffe097          	auipc	ra,0xffffe
    80001e4c:	330080e7          	jalr	816(ra) # 80000178 <memset>
      if (mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80001e50:	4779                	li	a4,30
    80001e52:	86d2                	mv	a3,s4
    80001e54:	6605                	lui	a2,0x1
    80001e56:	85ce                	mv	a1,s3
    80001e58:	05093503          	ld	a0,80(s2)
    80001e5c:	ffffe097          	auipc	ra,0xffffe
    80001e60:	6e8080e7          	jalr	1768(ra) # 80000544 <mappages>
    80001e64:	ed0d                	bnez	a0,80001e9e <usertrap+0x1d2>
      mapfile(v.mfile, mem, va - v.addr + v.offset);
    80001e66:	0169863b          	addw	a2,s3,s6
    80001e6a:	4156063b          	subw	a2,a2,s5
    80001e6e:	85d2                	mv	a1,s4
    80001e70:	8526                	mv	a0,s1
    80001e72:	00002097          	auipc	ra,0x2
    80001e76:	d8c080e7          	jalr	-628(ra) # 80003bfe <mapfile>
      if (p->killed)
    80001e7a:	02892783          	lw	a5,40(s2)
    80001e7e:	d78d                	beqz	a5,80001da8 <usertrap+0xdc>
        exit(-1);
    80001e80:	557d                	li	a0,-1
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	7f2080e7          	jalr	2034(ra) # 80001674 <exit>
    80001e8a:	bf39                	j	80001da8 <usertrap+0xdc>
      printf("usertrap(): invalid memory access\n");
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	41c50513          	addi	a0,a0,1052 # 800082a8 <states.0+0x98>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	1b4080e7          	jalr	436(ra) # 80006048 <printf>
      goto err;
    80001e9c:	bd61                	j	80001d34 <usertrap+0x68>
        kfree(mem);
    80001e9e:	8552                	mv	a0,s4
    80001ea0:	ffffe097          	auipc	ra,0xffffe
    80001ea4:	17c080e7          	jalr	380(ra) # 8000001c <kfree>
        printf("usertrap(): out of memory (2)\n");
    80001ea8:	00006517          	auipc	a0,0x6
    80001eac:	42850513          	addi	a0,a0,1064 # 800082d0 <states.0+0xc0>
    80001eb0:	00004097          	auipc	ra,0x4
    80001eb4:	198080e7          	jalr	408(ra) # 80006048 <printf>
        goto err;
    80001eb8:	bdb5                	j	80001d34 <usertrap+0x68>
  if (killed(p))
    80001eba:	854a                	mv	a0,s2
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	92c080e7          	jalr	-1748(ra) # 800017e8 <killed>
    80001ec4:	c901                	beqz	a0,80001ed4 <usertrap+0x208>
    80001ec6:	a011                	j	80001eca <usertrap+0x1fe>
    80001ec8:	4481                	li	s1,0
    exit(-1);
    80001eca:	557d                	li	a0,-1
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	7a8080e7          	jalr	1960(ra) # 80001674 <exit>
  if (which_dev == 2)
    80001ed4:	4789                	li	a5,2
    80001ed6:	eef490e3          	bne	s1,a5,80001db6 <usertrap+0xea>
    yield();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	62a080e7          	jalr	1578(ra) # 80001504 <yield>
    80001ee2:	bdd1                	j	80001db6 <usertrap+0xea>

0000000080001ee4 <kerneltrap>:
{
    80001ee4:	7179                	addi	sp,sp,-48
    80001ee6:	f406                	sd	ra,40(sp)
    80001ee8:	f022                	sd	s0,32(sp)
    80001eea:	ec26                	sd	s1,24(sp)
    80001eec:	e84a                	sd	s2,16(sp)
    80001eee:	e44e                	sd	s3,8(sp)
    80001ef0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efa:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001efe:	1004f793          	andi	a5,s1,256
    80001f02:	cb85                	beqz	a5,80001f32 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f04:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f08:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001f0a:	ef85                	bnez	a5,80001f42 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	d1e080e7          	jalr	-738(ra) # 80001c2a <devintr>
    80001f14:	cd1d                	beqz	a0,80001f52 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f16:	4789                	li	a5,2
    80001f18:	06f50a63          	beq	a0,a5,80001f8c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f1c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f20:	10049073          	csrw	sstatus,s1
}
    80001f24:	70a2                	ld	ra,40(sp)
    80001f26:	7402                	ld	s0,32(sp)
    80001f28:	64e2                	ld	s1,24(sp)
    80001f2a:	6942                	ld	s2,16(sp)
    80001f2c:	69a2                	ld	s3,8(sp)
    80001f2e:	6145                	addi	sp,sp,48
    80001f30:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	40e50513          	addi	a0,a0,1038 # 80008340 <states.0+0x130>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	0c4080e7          	jalr	196(ra) # 80005ffe <panic>
    panic("kerneltrap: interrupts enabled");
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	42650513          	addi	a0,a0,1062 # 80008368 <states.0+0x158>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	0b4080e7          	jalr	180(ra) # 80005ffe <panic>
    printf("scause %p\n", scause);
    80001f52:	85ce                	mv	a1,s3
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	43450513          	addi	a0,a0,1076 # 80008388 <states.0+0x178>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	0ec080e7          	jalr	236(ra) # 80006048 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f68:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	42c50513          	addi	a0,a0,1068 # 80008398 <states.0+0x188>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	0d4080e7          	jalr	212(ra) # 80006048 <printf>
    panic("kerneltrap");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	43450513          	addi	a0,a0,1076 # 800083b0 <states.0+0x1a0>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	07a080e7          	jalr	122(ra) # 80005ffe <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	eac080e7          	jalr	-340(ra) # 80000e38 <myproc>
    80001f94:	d541                	beqz	a0,80001f1c <kerneltrap+0x38>
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	ea2080e7          	jalr	-350(ra) # 80000e38 <myproc>
    80001f9e:	4d18                	lw	a4,24(a0)
    80001fa0:	4791                	li	a5,4
    80001fa2:	f6f71de3          	bne	a4,a5,80001f1c <kerneltrap+0x38>
    yield();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	55e080e7          	jalr	1374(ra) # 80001504 <yield>
    80001fae:	b7bd                	j	80001f1c <kerneltrap+0x38>

0000000080001fb0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	1000                	addi	s0,sp,32
    80001fba:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	e7c080e7          	jalr	-388(ra) # 80000e38 <myproc>
  switch (n) {
    80001fc4:	4795                	li	a5,5
    80001fc6:	0497e163          	bltu	a5,s1,80002008 <argraw+0x58>
    80001fca:	048a                	slli	s1,s1,0x2
    80001fcc:	00006717          	auipc	a4,0x6
    80001fd0:	41c70713          	addi	a4,a4,1052 # 800083e8 <states.0+0x1d8>
    80001fd4:	94ba                	add	s1,s1,a4
    80001fd6:	409c                	lw	a5,0(s1)
    80001fd8:	97ba                	add	a5,a5,a4
    80001fda:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret
    return p->trapframe->a1;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	7fa8                	ld	a0,120(a5)
    80001fee:	bfcd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a2;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	63c8                	ld	a0,128(a5)
    80001ff4:	b7f5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a3;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	67c8                	ld	a0,136(a5)
    80001ffa:	b7dd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a4;
    80001ffc:	6d3c                	ld	a5,88(a0)
    80001ffe:	6bc8                	ld	a0,144(a5)
    80002000:	b7c5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a5;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	6fc8                	ld	a0,152(a5)
    80002006:	bfe9                	j	80001fe0 <argraw+0x30>
  panic("argraw");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	3b850513          	addi	a0,a0,952 # 800083c0 <states.0+0x1b0>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	fee080e7          	jalr	-18(ra) # 80005ffe <panic>

0000000080002018 <fetchaddr>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
    80002024:	84aa                	mv	s1,a0
    80002026:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	e10080e7          	jalr	-496(ra) # 80000e38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002030:	653c                	ld	a5,72(a0)
    80002032:	02f4f863          	bgeu	s1,a5,80002062 <fetchaddr+0x4a>
    80002036:	00848713          	addi	a4,s1,8
    8000203a:	02e7e663          	bltu	a5,a4,80002066 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000203e:	46a1                	li	a3,8
    80002040:	8626                	mv	a2,s1
    80002042:	85ca                	mv	a1,s2
    80002044:	6928                	ld	a0,80(a0)
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	b3a080e7          	jalr	-1222(ra) # 80000b80 <copyin>
    8000204e:	00a03533          	snez	a0,a0
    80002052:	40a00533          	neg	a0,a0
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6902                	ld	s2,0(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret
    return -1;
    80002062:	557d                	li	a0,-1
    80002064:	bfcd                	j	80002056 <fetchaddr+0x3e>
    80002066:	557d                	li	a0,-1
    80002068:	b7fd                	j	80002056 <fetchaddr+0x3e>

000000008000206a <fetchstr>:
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
    80002078:	892a                	mv	s2,a0
    8000207a:	84ae                	mv	s1,a1
    8000207c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	dba080e7          	jalr	-582(ra) # 80000e38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002086:	86ce                	mv	a3,s3
    80002088:	864a                	mv	a2,s2
    8000208a:	85a6                	mv	a1,s1
    8000208c:	6928                	ld	a0,80(a0)
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	b80080e7          	jalr	-1152(ra) # 80000c0e <copyinstr>
    80002096:	00054e63          	bltz	a0,800020b2 <fetchstr+0x48>
  return strlen(buf);
    8000209a:	8526                	mv	a0,s1
    8000209c:	ffffe097          	auipc	ra,0xffffe
    800020a0:	258080e7          	jalr	600(ra) # 800002f4 <strlen>
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret
    return -1;
    800020b2:	557d                	li	a0,-1
    800020b4:	bfc5                	j	800020a4 <fetchstr+0x3a>

00000000800020b6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	eee080e7          	jalr	-274(ra) # 80001fb0 <argraw>
    800020ca:	c088                	sw	a0,0(s1)
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	1000                	addi	s0,sp,32
    800020e0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	ece080e7          	jalr	-306(ra) # 80001fb0 <argraw>
    800020ea:	e088                	sd	a0,0(s1)
}
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020f6:	7179                	addi	sp,sp,-48
    800020f8:	f406                	sd	ra,40(sp)
    800020fa:	f022                	sd	s0,32(sp)
    800020fc:	ec26                	sd	s1,24(sp)
    800020fe:	e84a                	sd	s2,16(sp)
    80002100:	1800                	addi	s0,sp,48
    80002102:	84ae                	mv	s1,a1
    80002104:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002106:	fd840593          	addi	a1,s0,-40
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	fcc080e7          	jalr	-52(ra) # 800020d6 <argaddr>
  return fetchstr(addr, buf, max);
    80002112:	864a                	mv	a2,s2
    80002114:	85a6                	mv	a1,s1
    80002116:	fd843503          	ld	a0,-40(s0)
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	f50080e7          	jalr	-176(ra) # 8000206a <fetchstr>
}
    80002122:	70a2                	ld	ra,40(sp)
    80002124:	7402                	ld	s0,32(sp)
    80002126:	64e2                	ld	s1,24(sp)
    80002128:	6942                	ld	s2,16(sp)
    8000212a:	6145                	addi	sp,sp,48
    8000212c:	8082                	ret

000000008000212e <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    8000212e:	1101                	addi	sp,sp,-32
    80002130:	ec06                	sd	ra,24(sp)
    80002132:	e822                	sd	s0,16(sp)
    80002134:	e426                	sd	s1,8(sp)
    80002136:	e04a                	sd	s2,0(sp)
    80002138:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	cfe080e7          	jalr	-770(ra) # 80000e38 <myproc>
    80002142:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002144:	05853903          	ld	s2,88(a0)
    80002148:	0a893783          	ld	a5,168(s2)
    8000214c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002150:	37fd                	addiw	a5,a5,-1
    80002152:	4759                	li	a4,22
    80002154:	00f76f63          	bltu	a4,a5,80002172 <syscall+0x44>
    80002158:	00369713          	slli	a4,a3,0x3
    8000215c:	00006797          	auipc	a5,0x6
    80002160:	2a478793          	addi	a5,a5,676 # 80008400 <syscalls>
    80002164:	97ba                	add	a5,a5,a4
    80002166:	639c                	ld	a5,0(a5)
    80002168:	c789                	beqz	a5,80002172 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000216a:	9782                	jalr	a5
    8000216c:	06a93823          	sd	a0,112(s2)
    80002170:	a839                	j	8000218e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002172:	15848613          	addi	a2,s1,344
    80002176:	588c                	lw	a1,48(s1)
    80002178:	00006517          	auipc	a0,0x6
    8000217c:	25050513          	addi	a0,a0,592 # 800083c8 <states.0+0x1b8>
    80002180:	00004097          	auipc	ra,0x4
    80002184:	ec8080e7          	jalr	-312(ra) # 80006048 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002188:	6cbc                	ld	a5,88(s1)
    8000218a:	577d                	li	a4,-1
    8000218c:	fbb8                	sd	a4,112(a5)
  }
}
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	64a2                	ld	s1,8(sp)
    80002194:	6902                	ld	s2,0(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021a2:	fec40593          	addi	a1,s0,-20
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	f0e080e7          	jalr	-242(ra) # 800020b6 <argint>
  exit(n);
    800021b0:	fec42503          	lw	a0,-20(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	4c0080e7          	jalr	1216(ra) # 80001674 <exit>
  return 0;  // not reached
}
    800021bc:	4501                	li	a0,0
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021c6:	1141                	addi	sp,sp,-16
    800021c8:	e406                	sd	ra,8(sp)
    800021ca:	e022                	sd	s0,0(sp)
    800021cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	c6a080e7          	jalr	-918(ra) # 80000e38 <myproc>
}
    800021d6:	5908                	lw	a0,48(a0)
    800021d8:	60a2                	ld	ra,8(sp)
    800021da:	6402                	ld	s0,0(sp)
    800021dc:	0141                	addi	sp,sp,16
    800021de:	8082                	ret

00000000800021e0 <sys_fork>:

uint64
sys_fork(void)
{
    800021e0:	1141                	addi	sp,sp,-16
    800021e2:	e406                	sd	ra,8(sp)
    800021e4:	e022                	sd	s0,0(sp)
    800021e6:	0800                	addi	s0,sp,16
  return fork();
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	006080e7          	jalr	6(ra) # 800011ee <fork>
}
    800021f0:	60a2                	ld	ra,8(sp)
    800021f2:	6402                	ld	s0,0(sp)
    800021f4:	0141                	addi	sp,sp,16
    800021f6:	8082                	ret

00000000800021f8 <sys_wait>:

uint64
sys_wait(void)
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002200:	fe840593          	addi	a1,s0,-24
    80002204:	4501                	li	a0,0
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	ed0080e7          	jalr	-304(ra) # 800020d6 <argaddr>
  return wait(p);
    8000220e:	fe843503          	ld	a0,-24(s0)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	608080e7          	jalr	1544(ra) # 8000181a <wait>
}
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002222:	7179                	addi	sp,sp,-48
    80002224:	f406                	sd	ra,40(sp)
    80002226:	f022                	sd	s0,32(sp)
    80002228:	ec26                	sd	s1,24(sp)
    8000222a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000222c:	fdc40593          	addi	a1,s0,-36
    80002230:	4501                	li	a0,0
    80002232:	00000097          	auipc	ra,0x0
    80002236:	e84080e7          	jalr	-380(ra) # 800020b6 <argint>
  addr = myproc()->sz;
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	bfe080e7          	jalr	-1026(ra) # 80000e38 <myproc>
    80002242:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002244:	fdc42503          	lw	a0,-36(s0)
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	f4a080e7          	jalr	-182(ra) # 80001192 <growproc>
    80002250:	00054863          	bltz	a0,80002260 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002254:	8526                	mv	a0,s1
    80002256:	70a2                	ld	ra,40(sp)
    80002258:	7402                	ld	s0,32(sp)
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	6145                	addi	sp,sp,48
    8000225e:	8082                	ret
    return -1;
    80002260:	54fd                	li	s1,-1
    80002262:	bfcd                	j	80002254 <sys_sbrk+0x32>

0000000080002264 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002264:	7139                	addi	sp,sp,-64
    80002266:	fc06                	sd	ra,56(sp)
    80002268:	f822                	sd	s0,48(sp)
    8000226a:	f426                	sd	s1,40(sp)
    8000226c:	f04a                	sd	s2,32(sp)
    8000226e:	ec4e                	sd	s3,24(sp)
    80002270:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002272:	fcc40593          	addi	a1,s0,-52
    80002276:	4501                	li	a0,0
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	e3e080e7          	jalr	-450(ra) # 800020b6 <argint>
  if(n < 0)
    80002280:	fcc42783          	lw	a5,-52(s0)
    80002284:	0607cf63          	bltz	a5,80002302 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002288:	00018517          	auipc	a0,0x18
    8000228c:	4d850513          	addi	a0,a0,1240 # 8001a760 <tickslock>
    80002290:	00004097          	auipc	ra,0x4
    80002294:	2aa080e7          	jalr	682(ra) # 8000653a <acquire>
  ticks0 = ticks;
    80002298:	00006917          	auipc	s2,0x6
    8000229c:	66092903          	lw	s2,1632(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800022a0:	fcc42783          	lw	a5,-52(s0)
    800022a4:	cf9d                	beqz	a5,800022e2 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022a6:	00018997          	auipc	s3,0x18
    800022aa:	4ba98993          	addi	s3,s3,1210 # 8001a760 <tickslock>
    800022ae:	00006497          	auipc	s1,0x6
    800022b2:	64a48493          	addi	s1,s1,1610 # 800088f8 <ticks>
    if(killed(myproc())){
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	b82080e7          	jalr	-1150(ra) # 80000e38 <myproc>
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	52a080e7          	jalr	1322(ra) # 800017e8 <killed>
    800022c6:	e129                	bnez	a0,80002308 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022c8:	85ce                	mv	a1,s3
    800022ca:	8526                	mv	a0,s1
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	274080e7          	jalr	628(ra) # 80001540 <sleep>
  while(ticks - ticks0 < n){
    800022d4:	409c                	lw	a5,0(s1)
    800022d6:	412787bb          	subw	a5,a5,s2
    800022da:	fcc42703          	lw	a4,-52(s0)
    800022de:	fce7ece3          	bltu	a5,a4,800022b6 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022e2:	00018517          	auipc	a0,0x18
    800022e6:	47e50513          	addi	a0,a0,1150 # 8001a760 <tickslock>
    800022ea:	00004097          	auipc	ra,0x4
    800022ee:	304080e7          	jalr	772(ra) # 800065ee <release>
  return 0;
    800022f2:	4501                	li	a0,0
}
    800022f4:	70e2                	ld	ra,56(sp)
    800022f6:	7442                	ld	s0,48(sp)
    800022f8:	74a2                	ld	s1,40(sp)
    800022fa:	7902                	ld	s2,32(sp)
    800022fc:	69e2                	ld	s3,24(sp)
    800022fe:	6121                	addi	sp,sp,64
    80002300:	8082                	ret
    n = 0;
    80002302:	fc042623          	sw	zero,-52(s0)
    80002306:	b749                	j	80002288 <sys_sleep+0x24>
      release(&tickslock);
    80002308:	00018517          	auipc	a0,0x18
    8000230c:	45850513          	addi	a0,a0,1112 # 8001a760 <tickslock>
    80002310:	00004097          	auipc	ra,0x4
    80002314:	2de080e7          	jalr	734(ra) # 800065ee <release>
      return -1;
    80002318:	557d                	li	a0,-1
    8000231a:	bfe9                	j	800022f4 <sys_sleep+0x90>

000000008000231c <sys_kill>:

uint64
sys_kill(void)
{
    8000231c:	1101                	addi	sp,sp,-32
    8000231e:	ec06                	sd	ra,24(sp)
    80002320:	e822                	sd	s0,16(sp)
    80002322:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002324:	fec40593          	addi	a1,s0,-20
    80002328:	4501                	li	a0,0
    8000232a:	00000097          	auipc	ra,0x0
    8000232e:	d8c080e7          	jalr	-628(ra) # 800020b6 <argint>
  return kill(pid);
    80002332:	fec42503          	lw	a0,-20(s0)
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	414080e7          	jalr	1044(ra) # 8000174a <kill>
}
    8000233e:	60e2                	ld	ra,24(sp)
    80002340:	6442                	ld	s0,16(sp)
    80002342:	6105                	addi	sp,sp,32
    80002344:	8082                	ret

0000000080002346 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002346:	1101                	addi	sp,sp,-32
    80002348:	ec06                	sd	ra,24(sp)
    8000234a:	e822                	sd	s0,16(sp)
    8000234c:	e426                	sd	s1,8(sp)
    8000234e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002350:	00018517          	auipc	a0,0x18
    80002354:	41050513          	addi	a0,a0,1040 # 8001a760 <tickslock>
    80002358:	00004097          	auipc	ra,0x4
    8000235c:	1e2080e7          	jalr	482(ra) # 8000653a <acquire>
  xticks = ticks;
    80002360:	00006497          	auipc	s1,0x6
    80002364:	5984a483          	lw	s1,1432(s1) # 800088f8 <ticks>
  release(&tickslock);
    80002368:	00018517          	auipc	a0,0x18
    8000236c:	3f850513          	addi	a0,a0,1016 # 8001a760 <tickslock>
    80002370:	00004097          	auipc	ra,0x4
    80002374:	27e080e7          	jalr	638(ra) # 800065ee <release>
  return xticks;
}
    80002378:	02049513          	slli	a0,s1,0x20
    8000237c:	9101                	srli	a0,a0,0x20
    8000237e:	60e2                	ld	ra,24(sp)
    80002380:	6442                	ld	s0,16(sp)
    80002382:	64a2                	ld	s1,8(sp)
    80002384:	6105                	addi	sp,sp,32
    80002386:	8082                	ret

0000000080002388 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002388:	7179                	addi	sp,sp,-48
    8000238a:	f406                	sd	ra,40(sp)
    8000238c:	f022                	sd	s0,32(sp)
    8000238e:	ec26                	sd	s1,24(sp)
    80002390:	e84a                	sd	s2,16(sp)
    80002392:	e44e                	sd	s3,8(sp)
    80002394:	e052                	sd	s4,0(sp)
    80002396:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002398:	00006597          	auipc	a1,0x6
    8000239c:	12858593          	addi	a1,a1,296 # 800084c0 <syscalls+0xc0>
    800023a0:	00018517          	auipc	a0,0x18
    800023a4:	3d850513          	addi	a0,a0,984 # 8001a778 <bcache>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	102080e7          	jalr	258(ra) # 800064aa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023b0:	00020797          	auipc	a5,0x20
    800023b4:	3c878793          	addi	a5,a5,968 # 80022778 <bcache+0x8000>
    800023b8:	00020717          	auipc	a4,0x20
    800023bc:	62870713          	addi	a4,a4,1576 # 800229e0 <bcache+0x8268>
    800023c0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023c4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c8:	00018497          	auipc	s1,0x18
    800023cc:	3c848493          	addi	s1,s1,968 # 8001a790 <bcache+0x18>
    b->next = bcache.head.next;
    800023d0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023d2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023d4:	00006a17          	auipc	s4,0x6
    800023d8:	0f4a0a13          	addi	s4,s4,244 # 800084c8 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023dc:	2b893783          	ld	a5,696(s2)
    800023e0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023e2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023e6:	85d2                	mv	a1,s4
    800023e8:	01048513          	addi	a0,s1,16
    800023ec:	00001097          	auipc	ra,0x1
    800023f0:	4ca080e7          	jalr	1226(ra) # 800038b6 <initsleeplock>
    bcache.head.next->prev = b;
    800023f4:	2b893783          	ld	a5,696(s2)
    800023f8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023fa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023fe:	45848493          	addi	s1,s1,1112
    80002402:	fd349de3          	bne	s1,s3,800023dc <binit+0x54>
  }
}
    80002406:	70a2                	ld	ra,40(sp)
    80002408:	7402                	ld	s0,32(sp)
    8000240a:	64e2                	ld	s1,24(sp)
    8000240c:	6942                	ld	s2,16(sp)
    8000240e:	69a2                	ld	s3,8(sp)
    80002410:	6a02                	ld	s4,0(sp)
    80002412:	6145                	addi	sp,sp,48
    80002414:	8082                	ret

0000000080002416 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002416:	7179                	addi	sp,sp,-48
    80002418:	f406                	sd	ra,40(sp)
    8000241a:	f022                	sd	s0,32(sp)
    8000241c:	ec26                	sd	s1,24(sp)
    8000241e:	e84a                	sd	s2,16(sp)
    80002420:	e44e                	sd	s3,8(sp)
    80002422:	1800                	addi	s0,sp,48
    80002424:	892a                	mv	s2,a0
    80002426:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002428:	00018517          	auipc	a0,0x18
    8000242c:	35050513          	addi	a0,a0,848 # 8001a778 <bcache>
    80002430:	00004097          	auipc	ra,0x4
    80002434:	10a080e7          	jalr	266(ra) # 8000653a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002438:	00020497          	auipc	s1,0x20
    8000243c:	5f84b483          	ld	s1,1528(s1) # 80022a30 <bcache+0x82b8>
    80002440:	00020797          	auipc	a5,0x20
    80002444:	5a078793          	addi	a5,a5,1440 # 800229e0 <bcache+0x8268>
    80002448:	02f48f63          	beq	s1,a5,80002486 <bread+0x70>
    8000244c:	873e                	mv	a4,a5
    8000244e:	a021                	j	80002456 <bread+0x40>
    80002450:	68a4                	ld	s1,80(s1)
    80002452:	02e48a63          	beq	s1,a4,80002486 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002456:	449c                	lw	a5,8(s1)
    80002458:	ff279ce3          	bne	a5,s2,80002450 <bread+0x3a>
    8000245c:	44dc                	lw	a5,12(s1)
    8000245e:	ff3799e3          	bne	a5,s3,80002450 <bread+0x3a>
      b->refcnt++;
    80002462:	40bc                	lw	a5,64(s1)
    80002464:	2785                	addiw	a5,a5,1
    80002466:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002468:	00018517          	auipc	a0,0x18
    8000246c:	31050513          	addi	a0,a0,784 # 8001a778 <bcache>
    80002470:	00004097          	auipc	ra,0x4
    80002474:	17e080e7          	jalr	382(ra) # 800065ee <release>
      acquiresleep(&b->lock);
    80002478:	01048513          	addi	a0,s1,16
    8000247c:	00001097          	auipc	ra,0x1
    80002480:	474080e7          	jalr	1140(ra) # 800038f0 <acquiresleep>
      return b;
    80002484:	a8b9                	j	800024e2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002486:	00020497          	auipc	s1,0x20
    8000248a:	5a24b483          	ld	s1,1442(s1) # 80022a28 <bcache+0x82b0>
    8000248e:	00020797          	auipc	a5,0x20
    80002492:	55278793          	addi	a5,a5,1362 # 800229e0 <bcache+0x8268>
    80002496:	00f48863          	beq	s1,a5,800024a6 <bread+0x90>
    8000249a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000249c:	40bc                	lw	a5,64(s1)
    8000249e:	cf81                	beqz	a5,800024b6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a0:	64a4                	ld	s1,72(s1)
    800024a2:	fee49de3          	bne	s1,a4,8000249c <bread+0x86>
  panic("bget: no buffers");
    800024a6:	00006517          	auipc	a0,0x6
    800024aa:	02a50513          	addi	a0,a0,42 # 800084d0 <syscalls+0xd0>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	b50080e7          	jalr	-1200(ra) # 80005ffe <panic>
      b->dev = dev;
    800024b6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024ba:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024be:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024c2:	4785                	li	a5,1
    800024c4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024c6:	00018517          	auipc	a0,0x18
    800024ca:	2b250513          	addi	a0,a0,690 # 8001a778 <bcache>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	120080e7          	jalr	288(ra) # 800065ee <release>
      acquiresleep(&b->lock);
    800024d6:	01048513          	addi	a0,s1,16
    800024da:	00001097          	auipc	ra,0x1
    800024de:	416080e7          	jalr	1046(ra) # 800038f0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024e2:	409c                	lw	a5,0(s1)
    800024e4:	cb89                	beqz	a5,800024f6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024e6:	8526                	mv	a0,s1
    800024e8:	70a2                	ld	ra,40(sp)
    800024ea:	7402                	ld	s0,32(sp)
    800024ec:	64e2                	ld	s1,24(sp)
    800024ee:	6942                	ld	s2,16(sp)
    800024f0:	69a2                	ld	s3,8(sp)
    800024f2:	6145                	addi	sp,sp,48
    800024f4:	8082                	ret
    virtio_disk_rw(b, 0);
    800024f6:	4581                	li	a1,0
    800024f8:	8526                	mv	a0,s1
    800024fa:	00003097          	auipc	ra,0x3
    800024fe:	2fa080e7          	jalr	762(ra) # 800057f4 <virtio_disk_rw>
    b->valid = 1;
    80002502:	4785                	li	a5,1
    80002504:	c09c                	sw	a5,0(s1)
  return b;
    80002506:	b7c5                	j	800024e6 <bread+0xd0>

0000000080002508 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002508:	1101                	addi	sp,sp,-32
    8000250a:	ec06                	sd	ra,24(sp)
    8000250c:	e822                	sd	s0,16(sp)
    8000250e:	e426                	sd	s1,8(sp)
    80002510:	1000                	addi	s0,sp,32
    80002512:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002514:	0541                	addi	a0,a0,16
    80002516:	00001097          	auipc	ra,0x1
    8000251a:	474080e7          	jalr	1140(ra) # 8000398a <holdingsleep>
    8000251e:	cd01                	beqz	a0,80002536 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002520:	4585                	li	a1,1
    80002522:	8526                	mv	a0,s1
    80002524:	00003097          	auipc	ra,0x3
    80002528:	2d0080e7          	jalr	720(ra) # 800057f4 <virtio_disk_rw>
}
    8000252c:	60e2                	ld	ra,24(sp)
    8000252e:	6442                	ld	s0,16(sp)
    80002530:	64a2                	ld	s1,8(sp)
    80002532:	6105                	addi	sp,sp,32
    80002534:	8082                	ret
    panic("bwrite");
    80002536:	00006517          	auipc	a0,0x6
    8000253a:	fb250513          	addi	a0,a0,-78 # 800084e8 <syscalls+0xe8>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	ac0080e7          	jalr	-1344(ra) # 80005ffe <panic>

0000000080002546 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002546:	1101                	addi	sp,sp,-32
    80002548:	ec06                	sd	ra,24(sp)
    8000254a:	e822                	sd	s0,16(sp)
    8000254c:	e426                	sd	s1,8(sp)
    8000254e:	e04a                	sd	s2,0(sp)
    80002550:	1000                	addi	s0,sp,32
    80002552:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002554:	01050913          	addi	s2,a0,16
    80002558:	854a                	mv	a0,s2
    8000255a:	00001097          	auipc	ra,0x1
    8000255e:	430080e7          	jalr	1072(ra) # 8000398a <holdingsleep>
    80002562:	c92d                	beqz	a0,800025d4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002564:	854a                	mv	a0,s2
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	3e0080e7          	jalr	992(ra) # 80003946 <releasesleep>

  acquire(&bcache.lock);
    8000256e:	00018517          	auipc	a0,0x18
    80002572:	20a50513          	addi	a0,a0,522 # 8001a778 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	fc4080e7          	jalr	-60(ra) # 8000653a <acquire>
  b->refcnt--;
    8000257e:	40bc                	lw	a5,64(s1)
    80002580:	37fd                	addiw	a5,a5,-1
    80002582:	0007871b          	sext.w	a4,a5
    80002586:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002588:	eb05                	bnez	a4,800025b8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000258a:	68bc                	ld	a5,80(s1)
    8000258c:	64b8                	ld	a4,72(s1)
    8000258e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002590:	64bc                	ld	a5,72(s1)
    80002592:	68b8                	ld	a4,80(s1)
    80002594:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002596:	00020797          	auipc	a5,0x20
    8000259a:	1e278793          	addi	a5,a5,482 # 80022778 <bcache+0x8000>
    8000259e:	2b87b703          	ld	a4,696(a5)
    800025a2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025a4:	00020717          	auipc	a4,0x20
    800025a8:	43c70713          	addi	a4,a4,1084 # 800229e0 <bcache+0x8268>
    800025ac:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025ae:	2b87b703          	ld	a4,696(a5)
    800025b2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025b4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025b8:	00018517          	auipc	a0,0x18
    800025bc:	1c050513          	addi	a0,a0,448 # 8001a778 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	02e080e7          	jalr	46(ra) # 800065ee <release>
}
    800025c8:	60e2                	ld	ra,24(sp)
    800025ca:	6442                	ld	s0,16(sp)
    800025cc:	64a2                	ld	s1,8(sp)
    800025ce:	6902                	ld	s2,0(sp)
    800025d0:	6105                	addi	sp,sp,32
    800025d2:	8082                	ret
    panic("brelse");
    800025d4:	00006517          	auipc	a0,0x6
    800025d8:	f1c50513          	addi	a0,a0,-228 # 800084f0 <syscalls+0xf0>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	a22080e7          	jalr	-1502(ra) # 80005ffe <panic>

00000000800025e4 <bpin>:

void
bpin(struct buf *b) {
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f0:	00018517          	auipc	a0,0x18
    800025f4:	18850513          	addi	a0,a0,392 # 8001a778 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	f42080e7          	jalr	-190(ra) # 8000653a <acquire>
  b->refcnt++;
    80002600:	40bc                	lw	a5,64(s1)
    80002602:	2785                	addiw	a5,a5,1
    80002604:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002606:	00018517          	auipc	a0,0x18
    8000260a:	17250513          	addi	a0,a0,370 # 8001a778 <bcache>
    8000260e:	00004097          	auipc	ra,0x4
    80002612:	fe0080e7          	jalr	-32(ra) # 800065ee <release>
}
    80002616:	60e2                	ld	ra,24(sp)
    80002618:	6442                	ld	s0,16(sp)
    8000261a:	64a2                	ld	s1,8(sp)
    8000261c:	6105                	addi	sp,sp,32
    8000261e:	8082                	ret

0000000080002620 <bunpin>:

void
bunpin(struct buf *b) {
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	e426                	sd	s1,8(sp)
    80002628:	1000                	addi	s0,sp,32
    8000262a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000262c:	00018517          	auipc	a0,0x18
    80002630:	14c50513          	addi	a0,a0,332 # 8001a778 <bcache>
    80002634:	00004097          	auipc	ra,0x4
    80002638:	f06080e7          	jalr	-250(ra) # 8000653a <acquire>
  b->refcnt--;
    8000263c:	40bc                	lw	a5,64(s1)
    8000263e:	37fd                	addiw	a5,a5,-1
    80002640:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002642:	00018517          	auipc	a0,0x18
    80002646:	13650513          	addi	a0,a0,310 # 8001a778 <bcache>
    8000264a:	00004097          	auipc	ra,0x4
    8000264e:	fa4080e7          	jalr	-92(ra) # 800065ee <release>
}
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret

000000008000265c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000265c:	1101                	addi	sp,sp,-32
    8000265e:	ec06                	sd	ra,24(sp)
    80002660:	e822                	sd	s0,16(sp)
    80002662:	e426                	sd	s1,8(sp)
    80002664:	e04a                	sd	s2,0(sp)
    80002666:	1000                	addi	s0,sp,32
    80002668:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000266a:	00d5d59b          	srliw	a1,a1,0xd
    8000266e:	00020797          	auipc	a5,0x20
    80002672:	7e67a783          	lw	a5,2022(a5) # 80022e54 <sb+0x1c>
    80002676:	9dbd                	addw	a1,a1,a5
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	d9e080e7          	jalr	-610(ra) # 80002416 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002680:	0074f713          	andi	a4,s1,7
    80002684:	4785                	li	a5,1
    80002686:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000268a:	14ce                	slli	s1,s1,0x33
    8000268c:	90d9                	srli	s1,s1,0x36
    8000268e:	00950733          	add	a4,a0,s1
    80002692:	05874703          	lbu	a4,88(a4)
    80002696:	00e7f6b3          	and	a3,a5,a4
    8000269a:	c69d                	beqz	a3,800026c8 <bfree+0x6c>
    8000269c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000269e:	94aa                	add	s1,s1,a0
    800026a0:	fff7c793          	not	a5,a5
    800026a4:	8ff9                	and	a5,a5,a4
    800026a6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026aa:	00001097          	auipc	ra,0x1
    800026ae:	126080e7          	jalr	294(ra) # 800037d0 <log_write>
  brelse(bp);
    800026b2:	854a                	mv	a0,s2
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	e92080e7          	jalr	-366(ra) # 80002546 <brelse>
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6902                	ld	s2,0(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("freeing free block");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	e3050513          	addi	a0,a0,-464 # 800084f8 <syscalls+0xf8>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	92e080e7          	jalr	-1746(ra) # 80005ffe <panic>

00000000800026d8 <balloc>:
{
    800026d8:	711d                	addi	sp,sp,-96
    800026da:	ec86                	sd	ra,88(sp)
    800026dc:	e8a2                	sd	s0,80(sp)
    800026de:	e4a6                	sd	s1,72(sp)
    800026e0:	e0ca                	sd	s2,64(sp)
    800026e2:	fc4e                	sd	s3,56(sp)
    800026e4:	f852                	sd	s4,48(sp)
    800026e6:	f456                	sd	s5,40(sp)
    800026e8:	f05a                	sd	s6,32(sp)
    800026ea:	ec5e                	sd	s7,24(sp)
    800026ec:	e862                	sd	s8,16(sp)
    800026ee:	e466                	sd	s9,8(sp)
    800026f0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026f2:	00020797          	auipc	a5,0x20
    800026f6:	74a7a783          	lw	a5,1866(a5) # 80022e3c <sb+0x4>
    800026fa:	10078163          	beqz	a5,800027fc <balloc+0x124>
    800026fe:	8baa                	mv	s7,a0
    80002700:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002702:	00020b17          	auipc	s6,0x20
    80002706:	736b0b13          	addi	s6,s6,1846 # 80022e38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000270c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002710:	6c89                	lui	s9,0x2
    80002712:	a061                	j	8000279a <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002714:	974a                	add	a4,a4,s2
    80002716:	8fd5                	or	a5,a5,a3
    80002718:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000271c:	854a                	mv	a0,s2
    8000271e:	00001097          	auipc	ra,0x1
    80002722:	0b2080e7          	jalr	178(ra) # 800037d0 <log_write>
        brelse(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	e1e080e7          	jalr	-482(ra) # 80002546 <brelse>
  bp = bread(dev, bno);
    80002730:	85a6                	mv	a1,s1
    80002732:	855e                	mv	a0,s7
    80002734:	00000097          	auipc	ra,0x0
    80002738:	ce2080e7          	jalr	-798(ra) # 80002416 <bread>
    8000273c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000273e:	40000613          	li	a2,1024
    80002742:	4581                	li	a1,0
    80002744:	05850513          	addi	a0,a0,88
    80002748:	ffffe097          	auipc	ra,0xffffe
    8000274c:	a30080e7          	jalr	-1488(ra) # 80000178 <memset>
  log_write(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	07e080e7          	jalr	126(ra) # 800037d0 <log_write>
  brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	dea080e7          	jalr	-534(ra) # 80002546 <brelse>
}
    80002764:	8526                	mv	a0,s1
    80002766:	60e6                	ld	ra,88(sp)
    80002768:	6446                	ld	s0,80(sp)
    8000276a:	64a6                	ld	s1,72(sp)
    8000276c:	6906                	ld	s2,64(sp)
    8000276e:	79e2                	ld	s3,56(sp)
    80002770:	7a42                	ld	s4,48(sp)
    80002772:	7aa2                	ld	s5,40(sp)
    80002774:	7b02                	ld	s6,32(sp)
    80002776:	6be2                	ld	s7,24(sp)
    80002778:	6c42                	ld	s8,16(sp)
    8000277a:	6ca2                	ld	s9,8(sp)
    8000277c:	6125                	addi	sp,sp,96
    8000277e:	8082                	ret
    brelse(bp);
    80002780:	854a                	mv	a0,s2
    80002782:	00000097          	auipc	ra,0x0
    80002786:	dc4080e7          	jalr	-572(ra) # 80002546 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000278a:	015c87bb          	addw	a5,s9,s5
    8000278e:	00078a9b          	sext.w	s5,a5
    80002792:	004b2703          	lw	a4,4(s6)
    80002796:	06eaf363          	bgeu	s5,a4,800027fc <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000279a:	41fad79b          	sraiw	a5,s5,0x1f
    8000279e:	0137d79b          	srliw	a5,a5,0x13
    800027a2:	015787bb          	addw	a5,a5,s5
    800027a6:	40d7d79b          	sraiw	a5,a5,0xd
    800027aa:	01cb2583          	lw	a1,28(s6)
    800027ae:	9dbd                	addw	a1,a1,a5
    800027b0:	855e                	mv	a0,s7
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	c64080e7          	jalr	-924(ra) # 80002416 <bread>
    800027ba:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027bc:	004b2503          	lw	a0,4(s6)
    800027c0:	000a849b          	sext.w	s1,s5
    800027c4:	8662                	mv	a2,s8
    800027c6:	faa4fde3          	bgeu	s1,a0,80002780 <balloc+0xa8>
      m = 1 << (bi % 8);
    800027ca:	41f6579b          	sraiw	a5,a2,0x1f
    800027ce:	01d7d69b          	srliw	a3,a5,0x1d
    800027d2:	00c6873b          	addw	a4,a3,a2
    800027d6:	00777793          	andi	a5,a4,7
    800027da:	9f95                	subw	a5,a5,a3
    800027dc:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027e0:	4037571b          	sraiw	a4,a4,0x3
    800027e4:	00e906b3          	add	a3,s2,a4
    800027e8:	0586c683          	lbu	a3,88(a3)
    800027ec:	00d7f5b3          	and	a1,a5,a3
    800027f0:	d195                	beqz	a1,80002714 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f2:	2605                	addiw	a2,a2,1
    800027f4:	2485                	addiw	s1,s1,1
    800027f6:	fd4618e3          	bne	a2,s4,800027c6 <balloc+0xee>
    800027fa:	b759                	j	80002780 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	d1450513          	addi	a0,a0,-748 # 80008510 <syscalls+0x110>
    80002804:	00004097          	auipc	ra,0x4
    80002808:	844080e7          	jalr	-1980(ra) # 80006048 <printf>
  return 0;
    8000280c:	4481                	li	s1,0
    8000280e:	bf99                	j	80002764 <balloc+0x8c>

0000000080002810 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002810:	7179                	addi	sp,sp,-48
    80002812:	f406                	sd	ra,40(sp)
    80002814:	f022                	sd	s0,32(sp)
    80002816:	ec26                	sd	s1,24(sp)
    80002818:	e84a                	sd	s2,16(sp)
    8000281a:	e44e                	sd	s3,8(sp)
    8000281c:	e052                	sd	s4,0(sp)
    8000281e:	1800                	addi	s0,sp,48
    80002820:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002822:	47ad                	li	a5,11
    80002824:	02b7e863          	bltu	a5,a1,80002854 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002828:	02059793          	slli	a5,a1,0x20
    8000282c:	01e7d593          	srli	a1,a5,0x1e
    80002830:	00b504b3          	add	s1,a0,a1
    80002834:	0504a903          	lw	s2,80(s1)
    80002838:	06091e63          	bnez	s2,800028b4 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000283c:	4108                	lw	a0,0(a0)
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	e9a080e7          	jalr	-358(ra) # 800026d8 <balloc>
    80002846:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000284a:	06090563          	beqz	s2,800028b4 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000284e:	0524a823          	sw	s2,80(s1)
    80002852:	a08d                	j	800028b4 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002854:	ff45849b          	addiw	s1,a1,-12
    80002858:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000285c:	0ff00793          	li	a5,255
    80002860:	08e7e563          	bltu	a5,a4,800028ea <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002864:	08052903          	lw	s2,128(a0)
    80002868:	00091d63          	bnez	s2,80002882 <bmap+0x72>
      addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e6a080e7          	jalr	-406(ra) # 800026d8 <balloc>
    80002876:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000287a:	02090d63          	beqz	s2,800028b4 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000287e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002882:	85ca                	mv	a1,s2
    80002884:	0009a503          	lw	a0,0(s3)
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	b8e080e7          	jalr	-1138(ra) # 80002416 <bread>
    80002890:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002892:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002896:	02049713          	slli	a4,s1,0x20
    8000289a:	01e75593          	srli	a1,a4,0x1e
    8000289e:	00b784b3          	add	s1,a5,a1
    800028a2:	0004a903          	lw	s2,0(s1)
    800028a6:	02090063          	beqz	s2,800028c6 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028aa:	8552                	mv	a0,s4
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	c9a080e7          	jalr	-870(ra) # 80002546 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028b4:	854a                	mv	a0,s2
    800028b6:	70a2                	ld	ra,40(sp)
    800028b8:	7402                	ld	s0,32(sp)
    800028ba:	64e2                	ld	s1,24(sp)
    800028bc:	6942                	ld	s2,16(sp)
    800028be:	69a2                	ld	s3,8(sp)
    800028c0:	6a02                	ld	s4,0(sp)
    800028c2:	6145                	addi	sp,sp,48
    800028c4:	8082                	ret
      addr = balloc(ip->dev);
    800028c6:	0009a503          	lw	a0,0(s3)
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	e0e080e7          	jalr	-498(ra) # 800026d8 <balloc>
    800028d2:	0005091b          	sext.w	s2,a0
      if(addr){
    800028d6:	fc090ae3          	beqz	s2,800028aa <bmap+0x9a>
        a[bn] = addr;
    800028da:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028de:	8552                	mv	a0,s4
    800028e0:	00001097          	auipc	ra,0x1
    800028e4:	ef0080e7          	jalr	-272(ra) # 800037d0 <log_write>
    800028e8:	b7c9                	j	800028aa <bmap+0x9a>
  panic("bmap: out of range");
    800028ea:	00006517          	auipc	a0,0x6
    800028ee:	c3e50513          	addi	a0,a0,-962 # 80008528 <syscalls+0x128>
    800028f2:	00003097          	auipc	ra,0x3
    800028f6:	70c080e7          	jalr	1804(ra) # 80005ffe <panic>

00000000800028fa <iget>:
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	e44e                	sd	s3,8(sp)
    80002906:	e052                	sd	s4,0(sp)
    80002908:	1800                	addi	s0,sp,48
    8000290a:	89aa                	mv	s3,a0
    8000290c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000290e:	00020517          	auipc	a0,0x20
    80002912:	54a50513          	addi	a0,a0,1354 # 80022e58 <itable>
    80002916:	00004097          	auipc	ra,0x4
    8000291a:	c24080e7          	jalr	-988(ra) # 8000653a <acquire>
  empty = 0;
    8000291e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002920:	00020497          	auipc	s1,0x20
    80002924:	55048493          	addi	s1,s1,1360 # 80022e70 <itable+0x18>
    80002928:	00022697          	auipc	a3,0x22
    8000292c:	fd868693          	addi	a3,a3,-40 # 80024900 <log>
    80002930:	a039                	j	8000293e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002932:	02090b63          	beqz	s2,80002968 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002936:	08848493          	addi	s1,s1,136
    8000293a:	02d48a63          	beq	s1,a3,8000296e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000293e:	449c                	lw	a5,8(s1)
    80002940:	fef059e3          	blez	a5,80002932 <iget+0x38>
    80002944:	4098                	lw	a4,0(s1)
    80002946:	ff3716e3          	bne	a4,s3,80002932 <iget+0x38>
    8000294a:	40d8                	lw	a4,4(s1)
    8000294c:	ff4713e3          	bne	a4,s4,80002932 <iget+0x38>
      ip->ref++;
    80002950:	2785                	addiw	a5,a5,1
    80002952:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002954:	00020517          	auipc	a0,0x20
    80002958:	50450513          	addi	a0,a0,1284 # 80022e58 <itable>
    8000295c:	00004097          	auipc	ra,0x4
    80002960:	c92080e7          	jalr	-878(ra) # 800065ee <release>
      return ip;
    80002964:	8926                	mv	s2,s1
    80002966:	a03d                	j	80002994 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002968:	f7f9                	bnez	a5,80002936 <iget+0x3c>
    8000296a:	8926                	mv	s2,s1
    8000296c:	b7e9                	j	80002936 <iget+0x3c>
  if(empty == 0)
    8000296e:	02090c63          	beqz	s2,800029a6 <iget+0xac>
  ip->dev = dev;
    80002972:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002976:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000297a:	4785                	li	a5,1
    8000297c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002980:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002984:	00020517          	auipc	a0,0x20
    80002988:	4d450513          	addi	a0,a0,1236 # 80022e58 <itable>
    8000298c:	00004097          	auipc	ra,0x4
    80002990:	c62080e7          	jalr	-926(ra) # 800065ee <release>
}
    80002994:	854a                	mv	a0,s2
    80002996:	70a2                	ld	ra,40(sp)
    80002998:	7402                	ld	s0,32(sp)
    8000299a:	64e2                	ld	s1,24(sp)
    8000299c:	6942                	ld	s2,16(sp)
    8000299e:	69a2                	ld	s3,8(sp)
    800029a0:	6a02                	ld	s4,0(sp)
    800029a2:	6145                	addi	sp,sp,48
    800029a4:	8082                	ret
    panic("iget: no inodes");
    800029a6:	00006517          	auipc	a0,0x6
    800029aa:	b9a50513          	addi	a0,a0,-1126 # 80008540 <syscalls+0x140>
    800029ae:	00003097          	auipc	ra,0x3
    800029b2:	650080e7          	jalr	1616(ra) # 80005ffe <panic>

00000000800029b6 <fsinit>:
fsinit(int dev) {
    800029b6:	7179                	addi	sp,sp,-48
    800029b8:	f406                	sd	ra,40(sp)
    800029ba:	f022                	sd	s0,32(sp)
    800029bc:	ec26                	sd	s1,24(sp)
    800029be:	e84a                	sd	s2,16(sp)
    800029c0:	e44e                	sd	s3,8(sp)
    800029c2:	1800                	addi	s0,sp,48
    800029c4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029c6:	4585                	li	a1,1
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	a4e080e7          	jalr	-1458(ra) # 80002416 <bread>
    800029d0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029d2:	00020997          	auipc	s3,0x20
    800029d6:	46698993          	addi	s3,s3,1126 # 80022e38 <sb>
    800029da:	02000613          	li	a2,32
    800029de:	05850593          	addi	a1,a0,88
    800029e2:	854e                	mv	a0,s3
    800029e4:	ffffd097          	auipc	ra,0xffffd
    800029e8:	7f0080e7          	jalr	2032(ra) # 800001d4 <memmove>
  brelse(bp);
    800029ec:	8526                	mv	a0,s1
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	b58080e7          	jalr	-1192(ra) # 80002546 <brelse>
  if(sb.magic != FSMAGIC)
    800029f6:	0009a703          	lw	a4,0(s3)
    800029fa:	102037b7          	lui	a5,0x10203
    800029fe:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a02:	02f71263          	bne	a4,a5,80002a26 <fsinit+0x70>
  initlog(dev, &sb);
    80002a06:	00020597          	auipc	a1,0x20
    80002a0a:	43258593          	addi	a1,a1,1074 # 80022e38 <sb>
    80002a0e:	854a                	mv	a0,s2
    80002a10:	00001097          	auipc	ra,0x1
    80002a14:	b42080e7          	jalr	-1214(ra) # 80003552 <initlog>
}
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6145                	addi	sp,sp,48
    80002a24:	8082                	ret
    panic("invalid file system");
    80002a26:	00006517          	auipc	a0,0x6
    80002a2a:	b2a50513          	addi	a0,a0,-1238 # 80008550 <syscalls+0x150>
    80002a2e:	00003097          	auipc	ra,0x3
    80002a32:	5d0080e7          	jalr	1488(ra) # 80005ffe <panic>

0000000080002a36 <iinit>:
{
    80002a36:	7179                	addi	sp,sp,-48
    80002a38:	f406                	sd	ra,40(sp)
    80002a3a:	f022                	sd	s0,32(sp)
    80002a3c:	ec26                	sd	s1,24(sp)
    80002a3e:	e84a                	sd	s2,16(sp)
    80002a40:	e44e                	sd	s3,8(sp)
    80002a42:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a44:	00006597          	auipc	a1,0x6
    80002a48:	b2458593          	addi	a1,a1,-1244 # 80008568 <syscalls+0x168>
    80002a4c:	00020517          	auipc	a0,0x20
    80002a50:	40c50513          	addi	a0,a0,1036 # 80022e58 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	a56080e7          	jalr	-1450(ra) # 800064aa <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a5c:	00020497          	auipc	s1,0x20
    80002a60:	42448493          	addi	s1,s1,1060 # 80022e80 <itable+0x28>
    80002a64:	00022997          	auipc	s3,0x22
    80002a68:	eac98993          	addi	s3,s3,-340 # 80024910 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a6c:	00006917          	auipc	s2,0x6
    80002a70:	b0490913          	addi	s2,s2,-1276 # 80008570 <syscalls+0x170>
    80002a74:	85ca                	mv	a1,s2
    80002a76:	8526                	mv	a0,s1
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	e3e080e7          	jalr	-450(ra) # 800038b6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a80:	08848493          	addi	s1,s1,136
    80002a84:	ff3498e3          	bne	s1,s3,80002a74 <iinit+0x3e>
}
    80002a88:	70a2                	ld	ra,40(sp)
    80002a8a:	7402                	ld	s0,32(sp)
    80002a8c:	64e2                	ld	s1,24(sp)
    80002a8e:	6942                	ld	s2,16(sp)
    80002a90:	69a2                	ld	s3,8(sp)
    80002a92:	6145                	addi	sp,sp,48
    80002a94:	8082                	ret

0000000080002a96 <ialloc>:
{
    80002a96:	715d                	addi	sp,sp,-80
    80002a98:	e486                	sd	ra,72(sp)
    80002a9a:	e0a2                	sd	s0,64(sp)
    80002a9c:	fc26                	sd	s1,56(sp)
    80002a9e:	f84a                	sd	s2,48(sp)
    80002aa0:	f44e                	sd	s3,40(sp)
    80002aa2:	f052                	sd	s4,32(sp)
    80002aa4:	ec56                	sd	s5,24(sp)
    80002aa6:	e85a                	sd	s6,16(sp)
    80002aa8:	e45e                	sd	s7,8(sp)
    80002aaa:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aac:	00020717          	auipc	a4,0x20
    80002ab0:	39872703          	lw	a4,920(a4) # 80022e44 <sb+0xc>
    80002ab4:	4785                	li	a5,1
    80002ab6:	04e7fa63          	bgeu	a5,a4,80002b0a <ialloc+0x74>
    80002aba:	8aaa                	mv	s5,a0
    80002abc:	8bae                	mv	s7,a1
    80002abe:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac0:	00020a17          	auipc	s4,0x20
    80002ac4:	378a0a13          	addi	s4,s4,888 # 80022e38 <sb>
    80002ac8:	00048b1b          	sext.w	s6,s1
    80002acc:	0044d793          	srli	a5,s1,0x4
    80002ad0:	018a2583          	lw	a1,24(s4)
    80002ad4:	9dbd                	addw	a1,a1,a5
    80002ad6:	8556                	mv	a0,s5
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	93e080e7          	jalr	-1730(ra) # 80002416 <bread>
    80002ae0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ae2:	05850993          	addi	s3,a0,88
    80002ae6:	00f4f793          	andi	a5,s1,15
    80002aea:	079a                	slli	a5,a5,0x6
    80002aec:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aee:	00099783          	lh	a5,0(s3)
    80002af2:	c3a1                	beqz	a5,80002b32 <ialloc+0x9c>
    brelse(bp);
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	a52080e7          	jalr	-1454(ra) # 80002546 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afc:	0485                	addi	s1,s1,1
    80002afe:	00ca2703          	lw	a4,12(s4)
    80002b02:	0004879b          	sext.w	a5,s1
    80002b06:	fce7e1e3          	bltu	a5,a4,80002ac8 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b0a:	00006517          	auipc	a0,0x6
    80002b0e:	a6e50513          	addi	a0,a0,-1426 # 80008578 <syscalls+0x178>
    80002b12:	00003097          	auipc	ra,0x3
    80002b16:	536080e7          	jalr	1334(ra) # 80006048 <printf>
  return 0;
    80002b1a:	4501                	li	a0,0
}
    80002b1c:	60a6                	ld	ra,72(sp)
    80002b1e:	6406                	ld	s0,64(sp)
    80002b20:	74e2                	ld	s1,56(sp)
    80002b22:	7942                	ld	s2,48(sp)
    80002b24:	79a2                	ld	s3,40(sp)
    80002b26:	7a02                	ld	s4,32(sp)
    80002b28:	6ae2                	ld	s5,24(sp)
    80002b2a:	6b42                	ld	s6,16(sp)
    80002b2c:	6ba2                	ld	s7,8(sp)
    80002b2e:	6161                	addi	sp,sp,80
    80002b30:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b32:	04000613          	li	a2,64
    80002b36:	4581                	li	a1,0
    80002b38:	854e                	mv	a0,s3
    80002b3a:	ffffd097          	auipc	ra,0xffffd
    80002b3e:	63e080e7          	jalr	1598(ra) # 80000178 <memset>
      dip->type = type;
    80002b42:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b46:	854a                	mv	a0,s2
    80002b48:	00001097          	auipc	ra,0x1
    80002b4c:	c88080e7          	jalr	-888(ra) # 800037d0 <log_write>
      brelse(bp);
    80002b50:	854a                	mv	a0,s2
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	9f4080e7          	jalr	-1548(ra) # 80002546 <brelse>
      return iget(dev, inum);
    80002b5a:	85da                	mv	a1,s6
    80002b5c:	8556                	mv	a0,s5
    80002b5e:	00000097          	auipc	ra,0x0
    80002b62:	d9c080e7          	jalr	-612(ra) # 800028fa <iget>
    80002b66:	bf5d                	j	80002b1c <ialloc+0x86>

0000000080002b68 <iupdate>:
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	e426                	sd	s1,8(sp)
    80002b70:	e04a                	sd	s2,0(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b76:	415c                	lw	a5,4(a0)
    80002b78:	0047d79b          	srliw	a5,a5,0x4
    80002b7c:	00020597          	auipc	a1,0x20
    80002b80:	2d45a583          	lw	a1,724(a1) # 80022e50 <sb+0x18>
    80002b84:	9dbd                	addw	a1,a1,a5
    80002b86:	4108                	lw	a0,0(a0)
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	88e080e7          	jalr	-1906(ra) # 80002416 <bread>
    80002b90:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b92:	05850793          	addi	a5,a0,88
    80002b96:	40c8                	lw	a0,4(s1)
    80002b98:	893d                	andi	a0,a0,15
    80002b9a:	051a                	slli	a0,a0,0x6
    80002b9c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b9e:	04449703          	lh	a4,68(s1)
    80002ba2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ba6:	04649703          	lh	a4,70(s1)
    80002baa:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bae:	04849703          	lh	a4,72(s1)
    80002bb2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bb6:	04a49703          	lh	a4,74(s1)
    80002bba:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bbe:	44f8                	lw	a4,76(s1)
    80002bc0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bc2:	03400613          	li	a2,52
    80002bc6:	05048593          	addi	a1,s1,80
    80002bca:	0531                	addi	a0,a0,12
    80002bcc:	ffffd097          	auipc	ra,0xffffd
    80002bd0:	608080e7          	jalr	1544(ra) # 800001d4 <memmove>
  log_write(bp);
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	00001097          	auipc	ra,0x1
    80002bda:	bfa080e7          	jalr	-1030(ra) # 800037d0 <log_write>
  brelse(bp);
    80002bde:	854a                	mv	a0,s2
    80002be0:	00000097          	auipc	ra,0x0
    80002be4:	966080e7          	jalr	-1690(ra) # 80002546 <brelse>
}
    80002be8:	60e2                	ld	ra,24(sp)
    80002bea:	6442                	ld	s0,16(sp)
    80002bec:	64a2                	ld	s1,8(sp)
    80002bee:	6902                	ld	s2,0(sp)
    80002bf0:	6105                	addi	sp,sp,32
    80002bf2:	8082                	ret

0000000080002bf4 <idup>:
{
    80002bf4:	1101                	addi	sp,sp,-32
    80002bf6:	ec06                	sd	ra,24(sp)
    80002bf8:	e822                	sd	s0,16(sp)
    80002bfa:	e426                	sd	s1,8(sp)
    80002bfc:	1000                	addi	s0,sp,32
    80002bfe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c00:	00020517          	auipc	a0,0x20
    80002c04:	25850513          	addi	a0,a0,600 # 80022e58 <itable>
    80002c08:	00004097          	auipc	ra,0x4
    80002c0c:	932080e7          	jalr	-1742(ra) # 8000653a <acquire>
  ip->ref++;
    80002c10:	449c                	lw	a5,8(s1)
    80002c12:	2785                	addiw	a5,a5,1
    80002c14:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c16:	00020517          	auipc	a0,0x20
    80002c1a:	24250513          	addi	a0,a0,578 # 80022e58 <itable>
    80002c1e:	00004097          	auipc	ra,0x4
    80002c22:	9d0080e7          	jalr	-1584(ra) # 800065ee <release>
}
    80002c26:	8526                	mv	a0,s1
    80002c28:	60e2                	ld	ra,24(sp)
    80002c2a:	6442                	ld	s0,16(sp)
    80002c2c:	64a2                	ld	s1,8(sp)
    80002c2e:	6105                	addi	sp,sp,32
    80002c30:	8082                	ret

0000000080002c32 <ilock>:
{
    80002c32:	1101                	addi	sp,sp,-32
    80002c34:	ec06                	sd	ra,24(sp)
    80002c36:	e822                	sd	s0,16(sp)
    80002c38:	e426                	sd	s1,8(sp)
    80002c3a:	e04a                	sd	s2,0(sp)
    80002c3c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c3e:	c115                	beqz	a0,80002c62 <ilock+0x30>
    80002c40:	84aa                	mv	s1,a0
    80002c42:	451c                	lw	a5,8(a0)
    80002c44:	00f05f63          	blez	a5,80002c62 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c48:	0541                	addi	a0,a0,16
    80002c4a:	00001097          	auipc	ra,0x1
    80002c4e:	ca6080e7          	jalr	-858(ra) # 800038f0 <acquiresleep>
  if(ip->valid == 0){
    80002c52:	40bc                	lw	a5,64(s1)
    80002c54:	cf99                	beqz	a5,80002c72 <ilock+0x40>
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6902                	ld	s2,0(sp)
    80002c5e:	6105                	addi	sp,sp,32
    80002c60:	8082                	ret
    panic("ilock");
    80002c62:	00006517          	auipc	a0,0x6
    80002c66:	92e50513          	addi	a0,a0,-1746 # 80008590 <syscalls+0x190>
    80002c6a:	00003097          	auipc	ra,0x3
    80002c6e:	394080e7          	jalr	916(ra) # 80005ffe <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c72:	40dc                	lw	a5,4(s1)
    80002c74:	0047d79b          	srliw	a5,a5,0x4
    80002c78:	00020597          	auipc	a1,0x20
    80002c7c:	1d85a583          	lw	a1,472(a1) # 80022e50 <sb+0x18>
    80002c80:	9dbd                	addw	a1,a1,a5
    80002c82:	4088                	lw	a0,0(s1)
    80002c84:	fffff097          	auipc	ra,0xfffff
    80002c88:	792080e7          	jalr	1938(ra) # 80002416 <bread>
    80002c8c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8e:	05850593          	addi	a1,a0,88
    80002c92:	40dc                	lw	a5,4(s1)
    80002c94:	8bbd                	andi	a5,a5,15
    80002c96:	079a                	slli	a5,a5,0x6
    80002c98:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c9a:	00059783          	lh	a5,0(a1)
    80002c9e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ca2:	00259783          	lh	a5,2(a1)
    80002ca6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002caa:	00459783          	lh	a5,4(a1)
    80002cae:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cb2:	00659783          	lh	a5,6(a1)
    80002cb6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cba:	459c                	lw	a5,8(a1)
    80002cbc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cbe:	03400613          	li	a2,52
    80002cc2:	05b1                	addi	a1,a1,12
    80002cc4:	05048513          	addi	a0,s1,80
    80002cc8:	ffffd097          	auipc	ra,0xffffd
    80002ccc:	50c080e7          	jalr	1292(ra) # 800001d4 <memmove>
    brelse(bp);
    80002cd0:	854a                	mv	a0,s2
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	874080e7          	jalr	-1932(ra) # 80002546 <brelse>
    ip->valid = 1;
    80002cda:	4785                	li	a5,1
    80002cdc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cde:	04449783          	lh	a5,68(s1)
    80002ce2:	fbb5                	bnez	a5,80002c56 <ilock+0x24>
      panic("ilock: no type");
    80002ce4:	00006517          	auipc	a0,0x6
    80002ce8:	8b450513          	addi	a0,a0,-1868 # 80008598 <syscalls+0x198>
    80002cec:	00003097          	auipc	ra,0x3
    80002cf0:	312080e7          	jalr	786(ra) # 80005ffe <panic>

0000000080002cf4 <iunlock>:
{
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	e04a                	sd	s2,0(sp)
    80002cfe:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d00:	c905                	beqz	a0,80002d30 <iunlock+0x3c>
    80002d02:	84aa                	mv	s1,a0
    80002d04:	01050913          	addi	s2,a0,16
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00001097          	auipc	ra,0x1
    80002d0e:	c80080e7          	jalr	-896(ra) # 8000398a <holdingsleep>
    80002d12:	cd19                	beqz	a0,80002d30 <iunlock+0x3c>
    80002d14:	449c                	lw	a5,8(s1)
    80002d16:	00f05d63          	blez	a5,80002d30 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00001097          	auipc	ra,0x1
    80002d20:	c2a080e7          	jalr	-982(ra) # 80003946 <releasesleep>
}
    80002d24:	60e2                	ld	ra,24(sp)
    80002d26:	6442                	ld	s0,16(sp)
    80002d28:	64a2                	ld	s1,8(sp)
    80002d2a:	6902                	ld	s2,0(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret
    panic("iunlock");
    80002d30:	00006517          	auipc	a0,0x6
    80002d34:	87850513          	addi	a0,a0,-1928 # 800085a8 <syscalls+0x1a8>
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	2c6080e7          	jalr	710(ra) # 80005ffe <panic>

0000000080002d40 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d40:	7179                	addi	sp,sp,-48
    80002d42:	f406                	sd	ra,40(sp)
    80002d44:	f022                	sd	s0,32(sp)
    80002d46:	ec26                	sd	s1,24(sp)
    80002d48:	e84a                	sd	s2,16(sp)
    80002d4a:	e44e                	sd	s3,8(sp)
    80002d4c:	e052                	sd	s4,0(sp)
    80002d4e:	1800                	addi	s0,sp,48
    80002d50:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d52:	05050493          	addi	s1,a0,80
    80002d56:	08050913          	addi	s2,a0,128
    80002d5a:	a021                	j	80002d62 <itrunc+0x22>
    80002d5c:	0491                	addi	s1,s1,4
    80002d5e:	01248d63          	beq	s1,s2,80002d78 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d62:	408c                	lw	a1,0(s1)
    80002d64:	dde5                	beqz	a1,80002d5c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	8f2080e7          	jalr	-1806(ra) # 8000265c <bfree>
      ip->addrs[i] = 0;
    80002d72:	0004a023          	sw	zero,0(s1)
    80002d76:	b7dd                	j	80002d5c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d78:	0809a583          	lw	a1,128(s3)
    80002d7c:	e185                	bnez	a1,80002d9c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d7e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d82:	854e                	mv	a0,s3
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	de4080e7          	jalr	-540(ra) # 80002b68 <iupdate>
}
    80002d8c:	70a2                	ld	ra,40(sp)
    80002d8e:	7402                	ld	s0,32(sp)
    80002d90:	64e2                	ld	s1,24(sp)
    80002d92:	6942                	ld	s2,16(sp)
    80002d94:	69a2                	ld	s3,8(sp)
    80002d96:	6a02                	ld	s4,0(sp)
    80002d98:	6145                	addi	sp,sp,48
    80002d9a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	fffff097          	auipc	ra,0xfffff
    80002da4:	676080e7          	jalr	1654(ra) # 80002416 <bread>
    80002da8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002daa:	05850493          	addi	s1,a0,88
    80002dae:	45850913          	addi	s2,a0,1112
    80002db2:	a021                	j	80002dba <itrunc+0x7a>
    80002db4:	0491                	addi	s1,s1,4
    80002db6:	01248b63          	beq	s1,s2,80002dcc <itrunc+0x8c>
      if(a[j])
    80002dba:	408c                	lw	a1,0(s1)
    80002dbc:	dde5                	beqz	a1,80002db4 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002dbe:	0009a503          	lw	a0,0(s3)
    80002dc2:	00000097          	auipc	ra,0x0
    80002dc6:	89a080e7          	jalr	-1894(ra) # 8000265c <bfree>
    80002dca:	b7ed                	j	80002db4 <itrunc+0x74>
    brelse(bp);
    80002dcc:	8552                	mv	a0,s4
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	778080e7          	jalr	1912(ra) # 80002546 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dd6:	0809a583          	lw	a1,128(s3)
    80002dda:	0009a503          	lw	a0,0(s3)
    80002dde:	00000097          	auipc	ra,0x0
    80002de2:	87e080e7          	jalr	-1922(ra) # 8000265c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002de6:	0809a023          	sw	zero,128(s3)
    80002dea:	bf51                	j	80002d7e <itrunc+0x3e>

0000000080002dec <iput>:
{
    80002dec:	1101                	addi	sp,sp,-32
    80002dee:	ec06                	sd	ra,24(sp)
    80002df0:	e822                	sd	s0,16(sp)
    80002df2:	e426                	sd	s1,8(sp)
    80002df4:	e04a                	sd	s2,0(sp)
    80002df6:	1000                	addi	s0,sp,32
    80002df8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dfa:	00020517          	auipc	a0,0x20
    80002dfe:	05e50513          	addi	a0,a0,94 # 80022e58 <itable>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	738080e7          	jalr	1848(ra) # 8000653a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e0a:	4498                	lw	a4,8(s1)
    80002e0c:	4785                	li	a5,1
    80002e0e:	02f70363          	beq	a4,a5,80002e34 <iput+0x48>
  ip->ref--;
    80002e12:	449c                	lw	a5,8(s1)
    80002e14:	37fd                	addiw	a5,a5,-1
    80002e16:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e18:	00020517          	auipc	a0,0x20
    80002e1c:	04050513          	addi	a0,a0,64 # 80022e58 <itable>
    80002e20:	00003097          	auipc	ra,0x3
    80002e24:	7ce080e7          	jalr	1998(ra) # 800065ee <release>
}
    80002e28:	60e2                	ld	ra,24(sp)
    80002e2a:	6442                	ld	s0,16(sp)
    80002e2c:	64a2                	ld	s1,8(sp)
    80002e2e:	6902                	ld	s2,0(sp)
    80002e30:	6105                	addi	sp,sp,32
    80002e32:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e34:	40bc                	lw	a5,64(s1)
    80002e36:	dff1                	beqz	a5,80002e12 <iput+0x26>
    80002e38:	04a49783          	lh	a5,74(s1)
    80002e3c:	fbf9                	bnez	a5,80002e12 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e3e:	01048913          	addi	s2,s1,16
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	aac080e7          	jalr	-1364(ra) # 800038f0 <acquiresleep>
    release(&itable.lock);
    80002e4c:	00020517          	auipc	a0,0x20
    80002e50:	00c50513          	addi	a0,a0,12 # 80022e58 <itable>
    80002e54:	00003097          	auipc	ra,0x3
    80002e58:	79a080e7          	jalr	1946(ra) # 800065ee <release>
    itrunc(ip);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	ee2080e7          	jalr	-286(ra) # 80002d40 <itrunc>
    ip->type = 0;
    80002e66:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e6a:	8526                	mv	a0,s1
    80002e6c:	00000097          	auipc	ra,0x0
    80002e70:	cfc080e7          	jalr	-772(ra) # 80002b68 <iupdate>
    ip->valid = 0;
    80002e74:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	acc080e7          	jalr	-1332(ra) # 80003946 <releasesleep>
    acquire(&itable.lock);
    80002e82:	00020517          	auipc	a0,0x20
    80002e86:	fd650513          	addi	a0,a0,-42 # 80022e58 <itable>
    80002e8a:	00003097          	auipc	ra,0x3
    80002e8e:	6b0080e7          	jalr	1712(ra) # 8000653a <acquire>
    80002e92:	b741                	j	80002e12 <iput+0x26>

0000000080002e94 <iunlockput>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	1000                	addi	s0,sp,32
    80002e9e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	e54080e7          	jalr	-428(ra) # 80002cf4 <iunlock>
  iput(ip);
    80002ea8:	8526                	mv	a0,s1
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	f42080e7          	jalr	-190(ra) # 80002dec <iput>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6105                	addi	sp,sp,32
    80002eba:	8082                	ret

0000000080002ebc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ebc:	1141                	addi	sp,sp,-16
    80002ebe:	e422                	sd	s0,8(sp)
    80002ec0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ec2:	411c                	lw	a5,0(a0)
    80002ec4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ec6:	415c                	lw	a5,4(a0)
    80002ec8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eca:	04451783          	lh	a5,68(a0)
    80002ece:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ed2:	04a51783          	lh	a5,74(a0)
    80002ed6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eda:	04c56783          	lwu	a5,76(a0)
    80002ede:	e99c                	sd	a5,16(a1)
}
    80002ee0:	6422                	ld	s0,8(sp)
    80002ee2:	0141                	addi	sp,sp,16
    80002ee4:	8082                	ret

0000000080002ee6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee6:	457c                	lw	a5,76(a0)
    80002ee8:	0ed7e963          	bltu	a5,a3,80002fda <readi+0xf4>
{
    80002eec:	7159                	addi	sp,sp,-112
    80002eee:	f486                	sd	ra,104(sp)
    80002ef0:	f0a2                	sd	s0,96(sp)
    80002ef2:	eca6                	sd	s1,88(sp)
    80002ef4:	e8ca                	sd	s2,80(sp)
    80002ef6:	e4ce                	sd	s3,72(sp)
    80002ef8:	e0d2                	sd	s4,64(sp)
    80002efa:	fc56                	sd	s5,56(sp)
    80002efc:	f85a                	sd	s6,48(sp)
    80002efe:	f45e                	sd	s7,40(sp)
    80002f00:	f062                	sd	s8,32(sp)
    80002f02:	ec66                	sd	s9,24(sp)
    80002f04:	e86a                	sd	s10,16(sp)
    80002f06:	e46e                	sd	s11,8(sp)
    80002f08:	1880                	addi	s0,sp,112
    80002f0a:	8b2a                	mv	s6,a0
    80002f0c:	8bae                	mv	s7,a1
    80002f0e:	8a32                	mv	s4,a2
    80002f10:	84b6                	mv	s1,a3
    80002f12:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f14:	9f35                	addw	a4,a4,a3
    return 0;
    80002f16:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f18:	0ad76063          	bltu	a4,a3,80002fb8 <readi+0xd2>
  if(off + n > ip->size)
    80002f1c:	00e7f463          	bgeu	a5,a4,80002f24 <readi+0x3e>
    n = ip->size - off;
    80002f20:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f24:	0a0a8963          	beqz	s5,80002fd6 <readi+0xf0>
    80002f28:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f2e:	5c7d                	li	s8,-1
    80002f30:	a82d                	j	80002f6a <readi+0x84>
    80002f32:	020d1d93          	slli	s11,s10,0x20
    80002f36:	020ddd93          	srli	s11,s11,0x20
    80002f3a:	05890793          	addi	a5,s2,88
    80002f3e:	86ee                	mv	a3,s11
    80002f40:	963e                	add	a2,a2,a5
    80002f42:	85d2                	mv	a1,s4
    80002f44:	855e                	mv	a0,s7
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	a02080e7          	jalr	-1534(ra) # 80001948 <either_copyout>
    80002f4e:	05850d63          	beq	a0,s8,80002fa8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f52:	854a                	mv	a0,s2
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	5f2080e7          	jalr	1522(ra) # 80002546 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5c:	013d09bb          	addw	s3,s10,s3
    80002f60:	009d04bb          	addw	s1,s10,s1
    80002f64:	9a6e                	add	s4,s4,s11
    80002f66:	0559f763          	bgeu	s3,s5,80002fb4 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f6a:	00a4d59b          	srliw	a1,s1,0xa
    80002f6e:	855a                	mv	a0,s6
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	8a0080e7          	jalr	-1888(ra) # 80002810 <bmap>
    80002f78:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f7c:	cd85                	beqz	a1,80002fb4 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f7e:	000b2503          	lw	a0,0(s6)
    80002f82:	fffff097          	auipc	ra,0xfffff
    80002f86:	494080e7          	jalr	1172(ra) # 80002416 <bread>
    80002f8a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8c:	3ff4f613          	andi	a2,s1,1023
    80002f90:	40cc87bb          	subw	a5,s9,a2
    80002f94:	413a873b          	subw	a4,s5,s3
    80002f98:	8d3e                	mv	s10,a5
    80002f9a:	2781                	sext.w	a5,a5
    80002f9c:	0007069b          	sext.w	a3,a4
    80002fa0:	f8f6f9e3          	bgeu	a3,a5,80002f32 <readi+0x4c>
    80002fa4:	8d3a                	mv	s10,a4
    80002fa6:	b771                	j	80002f32 <readi+0x4c>
      brelse(bp);
    80002fa8:	854a                	mv	a0,s2
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	59c080e7          	jalr	1436(ra) # 80002546 <brelse>
      tot = -1;
    80002fb2:	59fd                	li	s3,-1
  }
  return tot;
    80002fb4:	0009851b          	sext.w	a0,s3
}
    80002fb8:	70a6                	ld	ra,104(sp)
    80002fba:	7406                	ld	s0,96(sp)
    80002fbc:	64e6                	ld	s1,88(sp)
    80002fbe:	6946                	ld	s2,80(sp)
    80002fc0:	69a6                	ld	s3,72(sp)
    80002fc2:	6a06                	ld	s4,64(sp)
    80002fc4:	7ae2                	ld	s5,56(sp)
    80002fc6:	7b42                	ld	s6,48(sp)
    80002fc8:	7ba2                	ld	s7,40(sp)
    80002fca:	7c02                	ld	s8,32(sp)
    80002fcc:	6ce2                	ld	s9,24(sp)
    80002fce:	6d42                	ld	s10,16(sp)
    80002fd0:	6da2                	ld	s11,8(sp)
    80002fd2:	6165                	addi	sp,sp,112
    80002fd4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd6:	89d6                	mv	s3,s5
    80002fd8:	bff1                	j	80002fb4 <readi+0xce>
    return 0;
    80002fda:	4501                	li	a0,0
}
    80002fdc:	8082                	ret

0000000080002fde <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fde:	457c                	lw	a5,76(a0)
    80002fe0:	10d7e863          	bltu	a5,a3,800030f0 <writei+0x112>
{
    80002fe4:	7159                	addi	sp,sp,-112
    80002fe6:	f486                	sd	ra,104(sp)
    80002fe8:	f0a2                	sd	s0,96(sp)
    80002fea:	eca6                	sd	s1,88(sp)
    80002fec:	e8ca                	sd	s2,80(sp)
    80002fee:	e4ce                	sd	s3,72(sp)
    80002ff0:	e0d2                	sd	s4,64(sp)
    80002ff2:	fc56                	sd	s5,56(sp)
    80002ff4:	f85a                	sd	s6,48(sp)
    80002ff6:	f45e                	sd	s7,40(sp)
    80002ff8:	f062                	sd	s8,32(sp)
    80002ffa:	ec66                	sd	s9,24(sp)
    80002ffc:	e86a                	sd	s10,16(sp)
    80002ffe:	e46e                	sd	s11,8(sp)
    80003000:	1880                	addi	s0,sp,112
    80003002:	8aaa                	mv	s5,a0
    80003004:	8bae                	mv	s7,a1
    80003006:	8a32                	mv	s4,a2
    80003008:	8936                	mv	s2,a3
    8000300a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000300c:	00e687bb          	addw	a5,a3,a4
    80003010:	0ed7e263          	bltu	a5,a3,800030f4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003014:	00043737          	lui	a4,0x43
    80003018:	0ef76063          	bltu	a4,a5,800030f8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000301c:	0c0b0863          	beqz	s6,800030ec <writei+0x10e>
    80003020:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003022:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003026:	5c7d                	li	s8,-1
    80003028:	a091                	j	8000306c <writei+0x8e>
    8000302a:	020d1d93          	slli	s11,s10,0x20
    8000302e:	020ddd93          	srli	s11,s11,0x20
    80003032:	05848793          	addi	a5,s1,88
    80003036:	86ee                	mv	a3,s11
    80003038:	8652                	mv	a2,s4
    8000303a:	85de                	mv	a1,s7
    8000303c:	953e                	add	a0,a0,a5
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	960080e7          	jalr	-1696(ra) # 8000199e <either_copyin>
    80003046:	07850263          	beq	a0,s8,800030aa <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000304a:	8526                	mv	a0,s1
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	784080e7          	jalr	1924(ra) # 800037d0 <log_write>
    brelse(bp);
    80003054:	8526                	mv	a0,s1
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	4f0080e7          	jalr	1264(ra) # 80002546 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305e:	013d09bb          	addw	s3,s10,s3
    80003062:	012d093b          	addw	s2,s10,s2
    80003066:	9a6e                	add	s4,s4,s11
    80003068:	0569f663          	bgeu	s3,s6,800030b4 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000306c:	00a9559b          	srliw	a1,s2,0xa
    80003070:	8556                	mv	a0,s5
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	79e080e7          	jalr	1950(ra) # 80002810 <bmap>
    8000307a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000307e:	c99d                	beqz	a1,800030b4 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003080:	000aa503          	lw	a0,0(s5)
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	392080e7          	jalr	914(ra) # 80002416 <bread>
    8000308c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308e:	3ff97513          	andi	a0,s2,1023
    80003092:	40ac87bb          	subw	a5,s9,a0
    80003096:	413b073b          	subw	a4,s6,s3
    8000309a:	8d3e                	mv	s10,a5
    8000309c:	2781                	sext.w	a5,a5
    8000309e:	0007069b          	sext.w	a3,a4
    800030a2:	f8f6f4e3          	bgeu	a3,a5,8000302a <writei+0x4c>
    800030a6:	8d3a                	mv	s10,a4
    800030a8:	b749                	j	8000302a <writei+0x4c>
      brelse(bp);
    800030aa:	8526                	mv	a0,s1
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	49a080e7          	jalr	1178(ra) # 80002546 <brelse>
  }

  if(off > ip->size)
    800030b4:	04caa783          	lw	a5,76(s5)
    800030b8:	0127f463          	bgeu	a5,s2,800030c0 <writei+0xe2>
    ip->size = off;
    800030bc:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030c0:	8556                	mv	a0,s5
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	aa6080e7          	jalr	-1370(ra) # 80002b68 <iupdate>

  return tot;
    800030ca:	0009851b          	sext.w	a0,s3
}
    800030ce:	70a6                	ld	ra,104(sp)
    800030d0:	7406                	ld	s0,96(sp)
    800030d2:	64e6                	ld	s1,88(sp)
    800030d4:	6946                	ld	s2,80(sp)
    800030d6:	69a6                	ld	s3,72(sp)
    800030d8:	6a06                	ld	s4,64(sp)
    800030da:	7ae2                	ld	s5,56(sp)
    800030dc:	7b42                	ld	s6,48(sp)
    800030de:	7ba2                	ld	s7,40(sp)
    800030e0:	7c02                	ld	s8,32(sp)
    800030e2:	6ce2                	ld	s9,24(sp)
    800030e4:	6d42                	ld	s10,16(sp)
    800030e6:	6da2                	ld	s11,8(sp)
    800030e8:	6165                	addi	sp,sp,112
    800030ea:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ec:	89da                	mv	s3,s6
    800030ee:	bfc9                	j	800030c0 <writei+0xe2>
    return -1;
    800030f0:	557d                	li	a0,-1
}
    800030f2:	8082                	ret
    return -1;
    800030f4:	557d                	li	a0,-1
    800030f6:	bfe1                	j	800030ce <writei+0xf0>
    return -1;
    800030f8:	557d                	li	a0,-1
    800030fa:	bfd1                	j	800030ce <writei+0xf0>

00000000800030fc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030fc:	1141                	addi	sp,sp,-16
    800030fe:	e406                	sd	ra,8(sp)
    80003100:	e022                	sd	s0,0(sp)
    80003102:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003104:	4639                	li	a2,14
    80003106:	ffffd097          	auipc	ra,0xffffd
    8000310a:	142080e7          	jalr	322(ra) # 80000248 <strncmp>
}
    8000310e:	60a2                	ld	ra,8(sp)
    80003110:	6402                	ld	s0,0(sp)
    80003112:	0141                	addi	sp,sp,16
    80003114:	8082                	ret

0000000080003116 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003116:	7139                	addi	sp,sp,-64
    80003118:	fc06                	sd	ra,56(sp)
    8000311a:	f822                	sd	s0,48(sp)
    8000311c:	f426                	sd	s1,40(sp)
    8000311e:	f04a                	sd	s2,32(sp)
    80003120:	ec4e                	sd	s3,24(sp)
    80003122:	e852                	sd	s4,16(sp)
    80003124:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003126:	04451703          	lh	a4,68(a0)
    8000312a:	4785                	li	a5,1
    8000312c:	00f71a63          	bne	a4,a5,80003140 <dirlookup+0x2a>
    80003130:	892a                	mv	s2,a0
    80003132:	89ae                	mv	s3,a1
    80003134:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003136:	457c                	lw	a5,76(a0)
    80003138:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000313a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313c:	e79d                	bnez	a5,8000316a <dirlookup+0x54>
    8000313e:	a8a5                	j	800031b6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003140:	00005517          	auipc	a0,0x5
    80003144:	47050513          	addi	a0,a0,1136 # 800085b0 <syscalls+0x1b0>
    80003148:	00003097          	auipc	ra,0x3
    8000314c:	eb6080e7          	jalr	-330(ra) # 80005ffe <panic>
      panic("dirlookup read");
    80003150:	00005517          	auipc	a0,0x5
    80003154:	47850513          	addi	a0,a0,1144 # 800085c8 <syscalls+0x1c8>
    80003158:	00003097          	auipc	ra,0x3
    8000315c:	ea6080e7          	jalr	-346(ra) # 80005ffe <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003160:	24c1                	addiw	s1,s1,16
    80003162:	04c92783          	lw	a5,76(s2)
    80003166:	04f4f763          	bgeu	s1,a5,800031b4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000316a:	4741                	li	a4,16
    8000316c:	86a6                	mv	a3,s1
    8000316e:	fc040613          	addi	a2,s0,-64
    80003172:	4581                	li	a1,0
    80003174:	854a                	mv	a0,s2
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	d70080e7          	jalr	-656(ra) # 80002ee6 <readi>
    8000317e:	47c1                	li	a5,16
    80003180:	fcf518e3          	bne	a0,a5,80003150 <dirlookup+0x3a>
    if(de.inum == 0)
    80003184:	fc045783          	lhu	a5,-64(s0)
    80003188:	dfe1                	beqz	a5,80003160 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000318a:	fc240593          	addi	a1,s0,-62
    8000318e:	854e                	mv	a0,s3
    80003190:	00000097          	auipc	ra,0x0
    80003194:	f6c080e7          	jalr	-148(ra) # 800030fc <namecmp>
    80003198:	f561                	bnez	a0,80003160 <dirlookup+0x4a>
      if(poff)
    8000319a:	000a0463          	beqz	s4,800031a2 <dirlookup+0x8c>
        *poff = off;
    8000319e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031a2:	fc045583          	lhu	a1,-64(s0)
    800031a6:	00092503          	lw	a0,0(s2)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	750080e7          	jalr	1872(ra) # 800028fa <iget>
    800031b2:	a011                	j	800031b6 <dirlookup+0xa0>
  return 0;
    800031b4:	4501                	li	a0,0
}
    800031b6:	70e2                	ld	ra,56(sp)
    800031b8:	7442                	ld	s0,48(sp)
    800031ba:	74a2                	ld	s1,40(sp)
    800031bc:	7902                	ld	s2,32(sp)
    800031be:	69e2                	ld	s3,24(sp)
    800031c0:	6a42                	ld	s4,16(sp)
    800031c2:	6121                	addi	sp,sp,64
    800031c4:	8082                	ret

00000000800031c6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031c6:	711d                	addi	sp,sp,-96
    800031c8:	ec86                	sd	ra,88(sp)
    800031ca:	e8a2                	sd	s0,80(sp)
    800031cc:	e4a6                	sd	s1,72(sp)
    800031ce:	e0ca                	sd	s2,64(sp)
    800031d0:	fc4e                	sd	s3,56(sp)
    800031d2:	f852                	sd	s4,48(sp)
    800031d4:	f456                	sd	s5,40(sp)
    800031d6:	f05a                	sd	s6,32(sp)
    800031d8:	ec5e                	sd	s7,24(sp)
    800031da:	e862                	sd	s8,16(sp)
    800031dc:	e466                	sd	s9,8(sp)
    800031de:	1080                	addi	s0,sp,96
    800031e0:	84aa                	mv	s1,a0
    800031e2:	8aae                	mv	s5,a1
    800031e4:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031e6:	00054703          	lbu	a4,0(a0)
    800031ea:	02f00793          	li	a5,47
    800031ee:	02f70363          	beq	a4,a5,80003214 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031f2:	ffffe097          	auipc	ra,0xffffe
    800031f6:	c46080e7          	jalr	-954(ra) # 80000e38 <myproc>
    800031fa:	15053503          	ld	a0,336(a0)
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	9f6080e7          	jalr	-1546(ra) # 80002bf4 <idup>
    80003206:	89aa                	mv	s3,a0
  while(*path == '/')
    80003208:	02f00913          	li	s2,47
  len = path - s;
    8000320c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000320e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003210:	4b85                	li	s7,1
    80003212:	a865                	j	800032ca <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003214:	4585                	li	a1,1
    80003216:	4505                	li	a0,1
    80003218:	fffff097          	auipc	ra,0xfffff
    8000321c:	6e2080e7          	jalr	1762(ra) # 800028fa <iget>
    80003220:	89aa                	mv	s3,a0
    80003222:	b7dd                	j	80003208 <namex+0x42>
      iunlockput(ip);
    80003224:	854e                	mv	a0,s3
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	c6e080e7          	jalr	-914(ra) # 80002e94 <iunlockput>
      return 0;
    8000322e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003230:	854e                	mv	a0,s3
    80003232:	60e6                	ld	ra,88(sp)
    80003234:	6446                	ld	s0,80(sp)
    80003236:	64a6                	ld	s1,72(sp)
    80003238:	6906                	ld	s2,64(sp)
    8000323a:	79e2                	ld	s3,56(sp)
    8000323c:	7a42                	ld	s4,48(sp)
    8000323e:	7aa2                	ld	s5,40(sp)
    80003240:	7b02                	ld	s6,32(sp)
    80003242:	6be2                	ld	s7,24(sp)
    80003244:	6c42                	ld	s8,16(sp)
    80003246:	6ca2                	ld	s9,8(sp)
    80003248:	6125                	addi	sp,sp,96
    8000324a:	8082                	ret
      iunlock(ip);
    8000324c:	854e                	mv	a0,s3
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	aa6080e7          	jalr	-1370(ra) # 80002cf4 <iunlock>
      return ip;
    80003256:	bfe9                	j	80003230 <namex+0x6a>
      iunlockput(ip);
    80003258:	854e                	mv	a0,s3
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	c3a080e7          	jalr	-966(ra) # 80002e94 <iunlockput>
      return 0;
    80003262:	89e6                	mv	s3,s9
    80003264:	b7f1                	j	80003230 <namex+0x6a>
  len = path - s;
    80003266:	40b48633          	sub	a2,s1,a1
    8000326a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000326e:	099c5463          	bge	s8,s9,800032f6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003272:	4639                	li	a2,14
    80003274:	8552                	mv	a0,s4
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	f5e080e7          	jalr	-162(ra) # 800001d4 <memmove>
  while(*path == '/')
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	01279763          	bne	a5,s2,80003290 <namex+0xca>
    path++;
    80003286:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003288:	0004c783          	lbu	a5,0(s1)
    8000328c:	ff278de3          	beq	a5,s2,80003286 <namex+0xc0>
    ilock(ip);
    80003290:	854e                	mv	a0,s3
    80003292:	00000097          	auipc	ra,0x0
    80003296:	9a0080e7          	jalr	-1632(ra) # 80002c32 <ilock>
    if(ip->type != T_DIR){
    8000329a:	04499783          	lh	a5,68(s3)
    8000329e:	f97793e3          	bne	a5,s7,80003224 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032a2:	000a8563          	beqz	s5,800032ac <namex+0xe6>
    800032a6:	0004c783          	lbu	a5,0(s1)
    800032aa:	d3cd                	beqz	a5,8000324c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ac:	865a                	mv	a2,s6
    800032ae:	85d2                	mv	a1,s4
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	e64080e7          	jalr	-412(ra) # 80003116 <dirlookup>
    800032ba:	8caa                	mv	s9,a0
    800032bc:	dd51                	beqz	a0,80003258 <namex+0x92>
    iunlockput(ip);
    800032be:	854e                	mv	a0,s3
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	bd4080e7          	jalr	-1068(ra) # 80002e94 <iunlockput>
    ip = next;
    800032c8:	89e6                	mv	s3,s9
  while(*path == '/')
    800032ca:	0004c783          	lbu	a5,0(s1)
    800032ce:	05279763          	bne	a5,s2,8000331c <namex+0x156>
    path++;
    800032d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d4:	0004c783          	lbu	a5,0(s1)
    800032d8:	ff278de3          	beq	a5,s2,800032d2 <namex+0x10c>
  if(*path == 0)
    800032dc:	c79d                	beqz	a5,8000330a <namex+0x144>
    path++;
    800032de:	85a6                	mv	a1,s1
  len = path - s;
    800032e0:	8cda                	mv	s9,s6
    800032e2:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800032e4:	01278963          	beq	a5,s2,800032f6 <namex+0x130>
    800032e8:	dfbd                	beqz	a5,80003266 <namex+0xa0>
    path++;
    800032ea:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032ec:	0004c783          	lbu	a5,0(s1)
    800032f0:	ff279ce3          	bne	a5,s2,800032e8 <namex+0x122>
    800032f4:	bf8d                	j	80003266 <namex+0xa0>
    memmove(name, s, len);
    800032f6:	2601                	sext.w	a2,a2
    800032f8:	8552                	mv	a0,s4
    800032fa:	ffffd097          	auipc	ra,0xffffd
    800032fe:	eda080e7          	jalr	-294(ra) # 800001d4 <memmove>
    name[len] = 0;
    80003302:	9cd2                	add	s9,s9,s4
    80003304:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003308:	bf9d                	j	8000327e <namex+0xb8>
  if(nameiparent){
    8000330a:	f20a83e3          	beqz	s5,80003230 <namex+0x6a>
    iput(ip);
    8000330e:	854e                	mv	a0,s3
    80003310:	00000097          	auipc	ra,0x0
    80003314:	adc080e7          	jalr	-1316(ra) # 80002dec <iput>
    return 0;
    80003318:	4981                	li	s3,0
    8000331a:	bf19                	j	80003230 <namex+0x6a>
  if(*path == 0)
    8000331c:	d7fd                	beqz	a5,8000330a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000331e:	0004c783          	lbu	a5,0(s1)
    80003322:	85a6                	mv	a1,s1
    80003324:	b7d1                	j	800032e8 <namex+0x122>

0000000080003326 <dirlink>:
{
    80003326:	7139                	addi	sp,sp,-64
    80003328:	fc06                	sd	ra,56(sp)
    8000332a:	f822                	sd	s0,48(sp)
    8000332c:	f426                	sd	s1,40(sp)
    8000332e:	f04a                	sd	s2,32(sp)
    80003330:	ec4e                	sd	s3,24(sp)
    80003332:	e852                	sd	s4,16(sp)
    80003334:	0080                	addi	s0,sp,64
    80003336:	892a                	mv	s2,a0
    80003338:	8a2e                	mv	s4,a1
    8000333a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000333c:	4601                	li	a2,0
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	dd8080e7          	jalr	-552(ra) # 80003116 <dirlookup>
    80003346:	e93d                	bnez	a0,800033bc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003348:	04c92483          	lw	s1,76(s2)
    8000334c:	c49d                	beqz	s1,8000337a <dirlink+0x54>
    8000334e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003350:	4741                	li	a4,16
    80003352:	86a6                	mv	a3,s1
    80003354:	fc040613          	addi	a2,s0,-64
    80003358:	4581                	li	a1,0
    8000335a:	854a                	mv	a0,s2
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	b8a080e7          	jalr	-1142(ra) # 80002ee6 <readi>
    80003364:	47c1                	li	a5,16
    80003366:	06f51163          	bne	a0,a5,800033c8 <dirlink+0xa2>
    if(de.inum == 0)
    8000336a:	fc045783          	lhu	a5,-64(s0)
    8000336e:	c791                	beqz	a5,8000337a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003370:	24c1                	addiw	s1,s1,16
    80003372:	04c92783          	lw	a5,76(s2)
    80003376:	fcf4ede3          	bltu	s1,a5,80003350 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000337a:	4639                	li	a2,14
    8000337c:	85d2                	mv	a1,s4
    8000337e:	fc240513          	addi	a0,s0,-62
    80003382:	ffffd097          	auipc	ra,0xffffd
    80003386:	f02080e7          	jalr	-254(ra) # 80000284 <strncpy>
  de.inum = inum;
    8000338a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000338e:	4741                	li	a4,16
    80003390:	86a6                	mv	a3,s1
    80003392:	fc040613          	addi	a2,s0,-64
    80003396:	4581                	li	a1,0
    80003398:	854a                	mv	a0,s2
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	c44080e7          	jalr	-956(ra) # 80002fde <writei>
    800033a2:	1541                	addi	a0,a0,-16
    800033a4:	00a03533          	snez	a0,a0
    800033a8:	40a00533          	neg	a0,a0
}
    800033ac:	70e2                	ld	ra,56(sp)
    800033ae:	7442                	ld	s0,48(sp)
    800033b0:	74a2                	ld	s1,40(sp)
    800033b2:	7902                	ld	s2,32(sp)
    800033b4:	69e2                	ld	s3,24(sp)
    800033b6:	6a42                	ld	s4,16(sp)
    800033b8:	6121                	addi	sp,sp,64
    800033ba:	8082                	ret
    iput(ip);
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	a30080e7          	jalr	-1488(ra) # 80002dec <iput>
    return -1;
    800033c4:	557d                	li	a0,-1
    800033c6:	b7dd                	j	800033ac <dirlink+0x86>
      panic("dirlink read");
    800033c8:	00005517          	auipc	a0,0x5
    800033cc:	21050513          	addi	a0,a0,528 # 800085d8 <syscalls+0x1d8>
    800033d0:	00003097          	auipc	ra,0x3
    800033d4:	c2e080e7          	jalr	-978(ra) # 80005ffe <panic>

00000000800033d8 <namei>:

struct inode*
namei(char *path)
{
    800033d8:	1101                	addi	sp,sp,-32
    800033da:	ec06                	sd	ra,24(sp)
    800033dc:	e822                	sd	s0,16(sp)
    800033de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033e0:	fe040613          	addi	a2,s0,-32
    800033e4:	4581                	li	a1,0
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	de0080e7          	jalr	-544(ra) # 800031c6 <namex>
}
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	6105                	addi	sp,sp,32
    800033f4:	8082                	ret

00000000800033f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033f6:	1141                	addi	sp,sp,-16
    800033f8:	e406                	sd	ra,8(sp)
    800033fa:	e022                	sd	s0,0(sp)
    800033fc:	0800                	addi	s0,sp,16
    800033fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003400:	4585                	li	a1,1
    80003402:	00000097          	auipc	ra,0x0
    80003406:	dc4080e7          	jalr	-572(ra) # 800031c6 <namex>
}
    8000340a:	60a2                	ld	ra,8(sp)
    8000340c:	6402                	ld	s0,0(sp)
    8000340e:	0141                	addi	sp,sp,16
    80003410:	8082                	ret

0000000080003412 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003412:	1101                	addi	sp,sp,-32
    80003414:	ec06                	sd	ra,24(sp)
    80003416:	e822                	sd	s0,16(sp)
    80003418:	e426                	sd	s1,8(sp)
    8000341a:	e04a                	sd	s2,0(sp)
    8000341c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000341e:	00021917          	auipc	s2,0x21
    80003422:	4e290913          	addi	s2,s2,1250 # 80024900 <log>
    80003426:	01892583          	lw	a1,24(s2)
    8000342a:	02892503          	lw	a0,40(s2)
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	fe8080e7          	jalr	-24(ra) # 80002416 <bread>
    80003436:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003438:	02c92683          	lw	a3,44(s2)
    8000343c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000343e:	02d05863          	blez	a3,8000346e <write_head+0x5c>
    80003442:	00021797          	auipc	a5,0x21
    80003446:	4ee78793          	addi	a5,a5,1262 # 80024930 <log+0x30>
    8000344a:	05c50713          	addi	a4,a0,92
    8000344e:	36fd                	addiw	a3,a3,-1
    80003450:	02069613          	slli	a2,a3,0x20
    80003454:	01e65693          	srli	a3,a2,0x1e
    80003458:	00021617          	auipc	a2,0x21
    8000345c:	4dc60613          	addi	a2,a2,1244 # 80024934 <log+0x34>
    80003460:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003462:	4390                	lw	a2,0(a5)
    80003464:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003466:	0791                	addi	a5,a5,4
    80003468:	0711                	addi	a4,a4,4
    8000346a:	fed79ce3          	bne	a5,a3,80003462 <write_head+0x50>
  }
  bwrite(buf);
    8000346e:	8526                	mv	a0,s1
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	098080e7          	jalr	152(ra) # 80002508 <bwrite>
  brelse(buf);
    80003478:	8526                	mv	a0,s1
    8000347a:	fffff097          	auipc	ra,0xfffff
    8000347e:	0cc080e7          	jalr	204(ra) # 80002546 <brelse>
}
    80003482:	60e2                	ld	ra,24(sp)
    80003484:	6442                	ld	s0,16(sp)
    80003486:	64a2                	ld	s1,8(sp)
    80003488:	6902                	ld	s2,0(sp)
    8000348a:	6105                	addi	sp,sp,32
    8000348c:	8082                	ret

000000008000348e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348e:	00021797          	auipc	a5,0x21
    80003492:	49e7a783          	lw	a5,1182(a5) # 8002492c <log+0x2c>
    80003496:	0af05d63          	blez	a5,80003550 <install_trans+0xc2>
{
    8000349a:	7139                	addi	sp,sp,-64
    8000349c:	fc06                	sd	ra,56(sp)
    8000349e:	f822                	sd	s0,48(sp)
    800034a0:	f426                	sd	s1,40(sp)
    800034a2:	f04a                	sd	s2,32(sp)
    800034a4:	ec4e                	sd	s3,24(sp)
    800034a6:	e852                	sd	s4,16(sp)
    800034a8:	e456                	sd	s5,8(sp)
    800034aa:	e05a                	sd	s6,0(sp)
    800034ac:	0080                	addi	s0,sp,64
    800034ae:	8b2a                	mv	s6,a0
    800034b0:	00021a97          	auipc	s5,0x21
    800034b4:	480a8a93          	addi	s5,s5,1152 # 80024930 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ba:	00021997          	auipc	s3,0x21
    800034be:	44698993          	addi	s3,s3,1094 # 80024900 <log>
    800034c2:	a00d                	j	800034e4 <install_trans+0x56>
    brelse(lbuf);
    800034c4:	854a                	mv	a0,s2
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	080080e7          	jalr	128(ra) # 80002546 <brelse>
    brelse(dbuf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	076080e7          	jalr	118(ra) # 80002546 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d8:	2a05                	addiw	s4,s4,1
    800034da:	0a91                	addi	s5,s5,4
    800034dc:	02c9a783          	lw	a5,44(s3)
    800034e0:	04fa5e63          	bge	s4,a5,8000353c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034e4:	0189a583          	lw	a1,24(s3)
    800034e8:	014585bb          	addw	a1,a1,s4
    800034ec:	2585                	addiw	a1,a1,1
    800034ee:	0289a503          	lw	a0,40(s3)
    800034f2:	fffff097          	auipc	ra,0xfffff
    800034f6:	f24080e7          	jalr	-220(ra) # 80002416 <bread>
    800034fa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034fc:	000aa583          	lw	a1,0(s5)
    80003500:	0289a503          	lw	a0,40(s3)
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	f12080e7          	jalr	-238(ra) # 80002416 <bread>
    8000350c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000350e:	40000613          	li	a2,1024
    80003512:	05890593          	addi	a1,s2,88
    80003516:	05850513          	addi	a0,a0,88
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	cba080e7          	jalr	-838(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003522:	8526                	mv	a0,s1
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	fe4080e7          	jalr	-28(ra) # 80002508 <bwrite>
    if(recovering == 0)
    8000352c:	f80b1ce3          	bnez	s6,800034c4 <install_trans+0x36>
      bunpin(dbuf);
    80003530:	8526                	mv	a0,s1
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	0ee080e7          	jalr	238(ra) # 80002620 <bunpin>
    8000353a:	b769                	j	800034c4 <install_trans+0x36>
}
    8000353c:	70e2                	ld	ra,56(sp)
    8000353e:	7442                	ld	s0,48(sp)
    80003540:	74a2                	ld	s1,40(sp)
    80003542:	7902                	ld	s2,32(sp)
    80003544:	69e2                	ld	s3,24(sp)
    80003546:	6a42                	ld	s4,16(sp)
    80003548:	6aa2                	ld	s5,8(sp)
    8000354a:	6b02                	ld	s6,0(sp)
    8000354c:	6121                	addi	sp,sp,64
    8000354e:	8082                	ret
    80003550:	8082                	ret

0000000080003552 <initlog>:
{
    80003552:	7179                	addi	sp,sp,-48
    80003554:	f406                	sd	ra,40(sp)
    80003556:	f022                	sd	s0,32(sp)
    80003558:	ec26                	sd	s1,24(sp)
    8000355a:	e84a                	sd	s2,16(sp)
    8000355c:	e44e                	sd	s3,8(sp)
    8000355e:	1800                	addi	s0,sp,48
    80003560:	892a                	mv	s2,a0
    80003562:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003564:	00021497          	auipc	s1,0x21
    80003568:	39c48493          	addi	s1,s1,924 # 80024900 <log>
    8000356c:	00005597          	auipc	a1,0x5
    80003570:	07c58593          	addi	a1,a1,124 # 800085e8 <syscalls+0x1e8>
    80003574:	8526                	mv	a0,s1
    80003576:	00003097          	auipc	ra,0x3
    8000357a:	f34080e7          	jalr	-204(ra) # 800064aa <initlock>
  log.start = sb->logstart;
    8000357e:	0149a583          	lw	a1,20(s3)
    80003582:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003584:	0109a783          	lw	a5,16(s3)
    80003588:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000358a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000358e:	854a                	mv	a0,s2
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	e86080e7          	jalr	-378(ra) # 80002416 <bread>
  log.lh.n = lh->n;
    80003598:	4d34                	lw	a3,88(a0)
    8000359a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000359c:	02d05663          	blez	a3,800035c8 <initlog+0x76>
    800035a0:	05c50793          	addi	a5,a0,92
    800035a4:	00021717          	auipc	a4,0x21
    800035a8:	38c70713          	addi	a4,a4,908 # 80024930 <log+0x30>
    800035ac:	36fd                	addiw	a3,a3,-1
    800035ae:	02069613          	slli	a2,a3,0x20
    800035b2:	01e65693          	srli	a3,a2,0x1e
    800035b6:	06050613          	addi	a2,a0,96
    800035ba:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035bc:	4390                	lw	a2,0(a5)
    800035be:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035c0:	0791                	addi	a5,a5,4
    800035c2:	0711                	addi	a4,a4,4
    800035c4:	fed79ce3          	bne	a5,a3,800035bc <initlog+0x6a>
  brelse(buf);
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	f7e080e7          	jalr	-130(ra) # 80002546 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035d0:	4505                	li	a0,1
    800035d2:	00000097          	auipc	ra,0x0
    800035d6:	ebc080e7          	jalr	-324(ra) # 8000348e <install_trans>
  log.lh.n = 0;
    800035da:	00021797          	auipc	a5,0x21
    800035de:	3407a923          	sw	zero,850(a5) # 8002492c <log+0x2c>
  write_head(); // clear the log
    800035e2:	00000097          	auipc	ra,0x0
    800035e6:	e30080e7          	jalr	-464(ra) # 80003412 <write_head>
}
    800035ea:	70a2                	ld	ra,40(sp)
    800035ec:	7402                	ld	s0,32(sp)
    800035ee:	64e2                	ld	s1,24(sp)
    800035f0:	6942                	ld	s2,16(sp)
    800035f2:	69a2                	ld	s3,8(sp)
    800035f4:	6145                	addi	sp,sp,48
    800035f6:	8082                	ret

00000000800035f8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f8:	1101                	addi	sp,sp,-32
    800035fa:	ec06                	sd	ra,24(sp)
    800035fc:	e822                	sd	s0,16(sp)
    800035fe:	e426                	sd	s1,8(sp)
    80003600:	e04a                	sd	s2,0(sp)
    80003602:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003604:	00021517          	auipc	a0,0x21
    80003608:	2fc50513          	addi	a0,a0,764 # 80024900 <log>
    8000360c:	00003097          	auipc	ra,0x3
    80003610:	f2e080e7          	jalr	-210(ra) # 8000653a <acquire>
  while(1){
    if(log.committing){
    80003614:	00021497          	auipc	s1,0x21
    80003618:	2ec48493          	addi	s1,s1,748 # 80024900 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361c:	4979                	li	s2,30
    8000361e:	a039                	j	8000362c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003620:	85a6                	mv	a1,s1
    80003622:	8526                	mv	a0,s1
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	f1c080e7          	jalr	-228(ra) # 80001540 <sleep>
    if(log.committing){
    8000362c:	50dc                	lw	a5,36(s1)
    8000362e:	fbed                	bnez	a5,80003620 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003630:	509c                	lw	a5,32(s1)
    80003632:	0017871b          	addiw	a4,a5,1
    80003636:	0007069b          	sext.w	a3,a4
    8000363a:	0027179b          	slliw	a5,a4,0x2
    8000363e:	9fb9                	addw	a5,a5,a4
    80003640:	0017979b          	slliw	a5,a5,0x1
    80003644:	54d8                	lw	a4,44(s1)
    80003646:	9fb9                	addw	a5,a5,a4
    80003648:	00f95963          	bge	s2,a5,8000365a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000364c:	85a6                	mv	a1,s1
    8000364e:	8526                	mv	a0,s1
    80003650:	ffffe097          	auipc	ra,0xffffe
    80003654:	ef0080e7          	jalr	-272(ra) # 80001540 <sleep>
    80003658:	bfd1                	j	8000362c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000365a:	00021517          	auipc	a0,0x21
    8000365e:	2a650513          	addi	a0,a0,678 # 80024900 <log>
    80003662:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003664:	00003097          	auipc	ra,0x3
    80003668:	f8a080e7          	jalr	-118(ra) # 800065ee <release>
      break;
    }
  }
}
    8000366c:	60e2                	ld	ra,24(sp)
    8000366e:	6442                	ld	s0,16(sp)
    80003670:	64a2                	ld	s1,8(sp)
    80003672:	6902                	ld	s2,0(sp)
    80003674:	6105                	addi	sp,sp,32
    80003676:	8082                	ret

0000000080003678 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003678:	7139                	addi	sp,sp,-64
    8000367a:	fc06                	sd	ra,56(sp)
    8000367c:	f822                	sd	s0,48(sp)
    8000367e:	f426                	sd	s1,40(sp)
    80003680:	f04a                	sd	s2,32(sp)
    80003682:	ec4e                	sd	s3,24(sp)
    80003684:	e852                	sd	s4,16(sp)
    80003686:	e456                	sd	s5,8(sp)
    80003688:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000368a:	00021497          	auipc	s1,0x21
    8000368e:	27648493          	addi	s1,s1,630 # 80024900 <log>
    80003692:	8526                	mv	a0,s1
    80003694:	00003097          	auipc	ra,0x3
    80003698:	ea6080e7          	jalr	-346(ra) # 8000653a <acquire>
  log.outstanding -= 1;
    8000369c:	509c                	lw	a5,32(s1)
    8000369e:	37fd                	addiw	a5,a5,-1
    800036a0:	0007891b          	sext.w	s2,a5
    800036a4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036a6:	50dc                	lw	a5,36(s1)
    800036a8:	e7b9                	bnez	a5,800036f6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036aa:	04091e63          	bnez	s2,80003706 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036ae:	00021497          	auipc	s1,0x21
    800036b2:	25248493          	addi	s1,s1,594 # 80024900 <log>
    800036b6:	4785                	li	a5,1
    800036b8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ba:	8526                	mv	a0,s1
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	f32080e7          	jalr	-206(ra) # 800065ee <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036c4:	54dc                	lw	a5,44(s1)
    800036c6:	06f04763          	bgtz	a5,80003734 <end_op+0xbc>
    acquire(&log.lock);
    800036ca:	00021497          	auipc	s1,0x21
    800036ce:	23648493          	addi	s1,s1,566 # 80024900 <log>
    800036d2:	8526                	mv	a0,s1
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	e66080e7          	jalr	-410(ra) # 8000653a <acquire>
    log.committing = 0;
    800036dc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036e0:	8526                	mv	a0,s1
    800036e2:	ffffe097          	auipc	ra,0xffffe
    800036e6:	ec2080e7          	jalr	-318(ra) # 800015a4 <wakeup>
    release(&log.lock);
    800036ea:	8526                	mv	a0,s1
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	f02080e7          	jalr	-254(ra) # 800065ee <release>
}
    800036f4:	a03d                	j	80003722 <end_op+0xaa>
    panic("log.committing");
    800036f6:	00005517          	auipc	a0,0x5
    800036fa:	efa50513          	addi	a0,a0,-262 # 800085f0 <syscalls+0x1f0>
    800036fe:	00003097          	auipc	ra,0x3
    80003702:	900080e7          	jalr	-1792(ra) # 80005ffe <panic>
    wakeup(&log);
    80003706:	00021497          	auipc	s1,0x21
    8000370a:	1fa48493          	addi	s1,s1,506 # 80024900 <log>
    8000370e:	8526                	mv	a0,s1
    80003710:	ffffe097          	auipc	ra,0xffffe
    80003714:	e94080e7          	jalr	-364(ra) # 800015a4 <wakeup>
  release(&log.lock);
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	ed4080e7          	jalr	-300(ra) # 800065ee <release>
}
    80003722:	70e2                	ld	ra,56(sp)
    80003724:	7442                	ld	s0,48(sp)
    80003726:	74a2                	ld	s1,40(sp)
    80003728:	7902                	ld	s2,32(sp)
    8000372a:	69e2                	ld	s3,24(sp)
    8000372c:	6a42                	ld	s4,16(sp)
    8000372e:	6aa2                	ld	s5,8(sp)
    80003730:	6121                	addi	sp,sp,64
    80003732:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003734:	00021a97          	auipc	s5,0x21
    80003738:	1fca8a93          	addi	s5,s5,508 # 80024930 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000373c:	00021a17          	auipc	s4,0x21
    80003740:	1c4a0a13          	addi	s4,s4,452 # 80024900 <log>
    80003744:	018a2583          	lw	a1,24(s4)
    80003748:	012585bb          	addw	a1,a1,s2
    8000374c:	2585                	addiw	a1,a1,1
    8000374e:	028a2503          	lw	a0,40(s4)
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	cc4080e7          	jalr	-828(ra) # 80002416 <bread>
    8000375a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000375c:	000aa583          	lw	a1,0(s5)
    80003760:	028a2503          	lw	a0,40(s4)
    80003764:	fffff097          	auipc	ra,0xfffff
    80003768:	cb2080e7          	jalr	-846(ra) # 80002416 <bread>
    8000376c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000376e:	40000613          	li	a2,1024
    80003772:	05850593          	addi	a1,a0,88
    80003776:	05848513          	addi	a0,s1,88
    8000377a:	ffffd097          	auipc	ra,0xffffd
    8000377e:	a5a080e7          	jalr	-1446(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003782:	8526                	mv	a0,s1
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	d84080e7          	jalr	-636(ra) # 80002508 <bwrite>
    brelse(from);
    8000378c:	854e                	mv	a0,s3
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	db8080e7          	jalr	-584(ra) # 80002546 <brelse>
    brelse(to);
    80003796:	8526                	mv	a0,s1
    80003798:	fffff097          	auipc	ra,0xfffff
    8000379c:	dae080e7          	jalr	-594(ra) # 80002546 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a0:	2905                	addiw	s2,s2,1
    800037a2:	0a91                	addi	s5,s5,4
    800037a4:	02ca2783          	lw	a5,44(s4)
    800037a8:	f8f94ee3          	blt	s2,a5,80003744 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	c66080e7          	jalr	-922(ra) # 80003412 <write_head>
    install_trans(0); // Now install writes to home locations
    800037b4:	4501                	li	a0,0
    800037b6:	00000097          	auipc	ra,0x0
    800037ba:	cd8080e7          	jalr	-808(ra) # 8000348e <install_trans>
    log.lh.n = 0;
    800037be:	00021797          	auipc	a5,0x21
    800037c2:	1607a723          	sw	zero,366(a5) # 8002492c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037c6:	00000097          	auipc	ra,0x0
    800037ca:	c4c080e7          	jalr	-948(ra) # 80003412 <write_head>
    800037ce:	bdf5                	j	800036ca <end_op+0x52>

00000000800037d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037d0:	1101                	addi	sp,sp,-32
    800037d2:	ec06                	sd	ra,24(sp)
    800037d4:	e822                	sd	s0,16(sp)
    800037d6:	e426                	sd	s1,8(sp)
    800037d8:	e04a                	sd	s2,0(sp)
    800037da:	1000                	addi	s0,sp,32
    800037dc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037de:	00021917          	auipc	s2,0x21
    800037e2:	12290913          	addi	s2,s2,290 # 80024900 <log>
    800037e6:	854a                	mv	a0,s2
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	d52080e7          	jalr	-686(ra) # 8000653a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037f0:	02c92603          	lw	a2,44(s2)
    800037f4:	47f5                	li	a5,29
    800037f6:	06c7c563          	blt	a5,a2,80003860 <log_write+0x90>
    800037fa:	00021797          	auipc	a5,0x21
    800037fe:	1227a783          	lw	a5,290(a5) # 8002491c <log+0x1c>
    80003802:	37fd                	addiw	a5,a5,-1
    80003804:	04f65e63          	bge	a2,a5,80003860 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003808:	00021797          	auipc	a5,0x21
    8000380c:	1187a783          	lw	a5,280(a5) # 80024920 <log+0x20>
    80003810:	06f05063          	blez	a5,80003870 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003814:	4781                	li	a5,0
    80003816:	06c05563          	blez	a2,80003880 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381a:	44cc                	lw	a1,12(s1)
    8000381c:	00021717          	auipc	a4,0x21
    80003820:	11470713          	addi	a4,a4,276 # 80024930 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003824:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003826:	4314                	lw	a3,0(a4)
    80003828:	04b68c63          	beq	a3,a1,80003880 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000382c:	2785                	addiw	a5,a5,1
    8000382e:	0711                	addi	a4,a4,4
    80003830:	fef61be3          	bne	a2,a5,80003826 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003834:	0621                	addi	a2,a2,8
    80003836:	060a                	slli	a2,a2,0x2
    80003838:	00021797          	auipc	a5,0x21
    8000383c:	0c878793          	addi	a5,a5,200 # 80024900 <log>
    80003840:	963e                	add	a2,a2,a5
    80003842:	44dc                	lw	a5,12(s1)
    80003844:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003846:	8526                	mv	a0,s1
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	d9c080e7          	jalr	-612(ra) # 800025e4 <bpin>
    log.lh.n++;
    80003850:	00021717          	auipc	a4,0x21
    80003854:	0b070713          	addi	a4,a4,176 # 80024900 <log>
    80003858:	575c                	lw	a5,44(a4)
    8000385a:	2785                	addiw	a5,a5,1
    8000385c:	d75c                	sw	a5,44(a4)
    8000385e:	a835                	j	8000389a <log_write+0xca>
    panic("too big a transaction");
    80003860:	00005517          	auipc	a0,0x5
    80003864:	da050513          	addi	a0,a0,-608 # 80008600 <syscalls+0x200>
    80003868:	00002097          	auipc	ra,0x2
    8000386c:	796080e7          	jalr	1942(ra) # 80005ffe <panic>
    panic("log_write outside of trans");
    80003870:	00005517          	auipc	a0,0x5
    80003874:	da850513          	addi	a0,a0,-600 # 80008618 <syscalls+0x218>
    80003878:	00002097          	auipc	ra,0x2
    8000387c:	786080e7          	jalr	1926(ra) # 80005ffe <panic>
  log.lh.block[i] = b->blockno;
    80003880:	00878713          	addi	a4,a5,8
    80003884:	00271693          	slli	a3,a4,0x2
    80003888:	00021717          	auipc	a4,0x21
    8000388c:	07870713          	addi	a4,a4,120 # 80024900 <log>
    80003890:	9736                	add	a4,a4,a3
    80003892:	44d4                	lw	a3,12(s1)
    80003894:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003896:	faf608e3          	beq	a2,a5,80003846 <log_write+0x76>
  }
  release(&log.lock);
    8000389a:	00021517          	auipc	a0,0x21
    8000389e:	06650513          	addi	a0,a0,102 # 80024900 <log>
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	d4c080e7          	jalr	-692(ra) # 800065ee <release>
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
    800038c4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038c6:	00005597          	auipc	a1,0x5
    800038ca:	d7258593          	addi	a1,a1,-654 # 80008638 <syscalls+0x238>
    800038ce:	0521                	addi	a0,a0,8
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	bda080e7          	jalr	-1062(ra) # 800064aa <initlock>
  lk->name = name;
    800038d8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038dc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e0:	0204a423          	sw	zero,40(s1)
}
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	64a2                	ld	s1,8(sp)
    800038ea:	6902                	ld	s2,0(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret

00000000800038f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	e04a                	sd	s2,0(sp)
    800038fa:	1000                	addi	s0,sp,32
    800038fc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038fe:	00850913          	addi	s2,a0,8
    80003902:	854a                	mv	a0,s2
    80003904:	00003097          	auipc	ra,0x3
    80003908:	c36080e7          	jalr	-970(ra) # 8000653a <acquire>
  while (lk->locked) {
    8000390c:	409c                	lw	a5,0(s1)
    8000390e:	cb89                	beqz	a5,80003920 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003910:	85ca                	mv	a1,s2
    80003912:	8526                	mv	a0,s1
    80003914:	ffffe097          	auipc	ra,0xffffe
    80003918:	c2c080e7          	jalr	-980(ra) # 80001540 <sleep>
  while (lk->locked) {
    8000391c:	409c                	lw	a5,0(s1)
    8000391e:	fbed                	bnez	a5,80003910 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003920:	4785                	li	a5,1
    80003922:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003924:	ffffd097          	auipc	ra,0xffffd
    80003928:	514080e7          	jalr	1300(ra) # 80000e38 <myproc>
    8000392c:	591c                	lw	a5,48(a0)
    8000392e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	cbc080e7          	jalr	-836(ra) # 800065ee <release>
}
    8000393a:	60e2                	ld	ra,24(sp)
    8000393c:	6442                	ld	s0,16(sp)
    8000393e:	64a2                	ld	s1,8(sp)
    80003940:	6902                	ld	s2,0(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003946:	1101                	addi	sp,sp,-32
    80003948:	ec06                	sd	ra,24(sp)
    8000394a:	e822                	sd	s0,16(sp)
    8000394c:	e426                	sd	s1,8(sp)
    8000394e:	e04a                	sd	s2,0(sp)
    80003950:	1000                	addi	s0,sp,32
    80003952:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003954:	00850913          	addi	s2,a0,8
    80003958:	854a                	mv	a0,s2
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	be0080e7          	jalr	-1056(ra) # 8000653a <acquire>
  lk->locked = 0;
    80003962:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003966:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000396a:	8526                	mv	a0,s1
    8000396c:	ffffe097          	auipc	ra,0xffffe
    80003970:	c38080e7          	jalr	-968(ra) # 800015a4 <wakeup>
  release(&lk->lk);
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	c78080e7          	jalr	-904(ra) # 800065ee <release>
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6902                	ld	s2,0(sp)
    80003986:	6105                	addi	sp,sp,32
    80003988:	8082                	ret

000000008000398a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000398a:	7179                	addi	sp,sp,-48
    8000398c:	f406                	sd	ra,40(sp)
    8000398e:	f022                	sd	s0,32(sp)
    80003990:	ec26                	sd	s1,24(sp)
    80003992:	e84a                	sd	s2,16(sp)
    80003994:	e44e                	sd	s3,8(sp)
    80003996:	1800                	addi	s0,sp,48
    80003998:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000399a:	00850913          	addi	s2,a0,8
    8000399e:	854a                	mv	a0,s2
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	b9a080e7          	jalr	-1126(ra) # 8000653a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a8:	409c                	lw	a5,0(s1)
    800039aa:	ef99                	bnez	a5,800039c8 <holdingsleep+0x3e>
    800039ac:	4481                	li	s1,0
  release(&lk->lk);
    800039ae:	854a                	mv	a0,s2
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	c3e080e7          	jalr	-962(ra) # 800065ee <release>
  return r;
}
    800039b8:	8526                	mv	a0,s1
    800039ba:	70a2                	ld	ra,40(sp)
    800039bc:	7402                	ld	s0,32(sp)
    800039be:	64e2                	ld	s1,24(sp)
    800039c0:	6942                	ld	s2,16(sp)
    800039c2:	69a2                	ld	s3,8(sp)
    800039c4:	6145                	addi	sp,sp,48
    800039c6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c8:	0284a983          	lw	s3,40(s1)
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	46c080e7          	jalr	1132(ra) # 80000e38 <myproc>
    800039d4:	5904                	lw	s1,48(a0)
    800039d6:	413484b3          	sub	s1,s1,s3
    800039da:	0014b493          	seqz	s1,s1
    800039de:	bfc1                	j	800039ae <holdingsleep+0x24>

00000000800039e0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039e0:	1141                	addi	sp,sp,-16
    800039e2:	e406                	sd	ra,8(sp)
    800039e4:	e022                	sd	s0,0(sp)
    800039e6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039e8:	00005597          	auipc	a1,0x5
    800039ec:	c6058593          	addi	a1,a1,-928 # 80008648 <syscalls+0x248>
    800039f0:	00021517          	auipc	a0,0x21
    800039f4:	05850513          	addi	a0,a0,88 # 80024a48 <ftable>
    800039f8:	00003097          	auipc	ra,0x3
    800039fc:	ab2080e7          	jalr	-1358(ra) # 800064aa <initlock>
}
    80003a00:	60a2                	ld	ra,8(sp)
    80003a02:	6402                	ld	s0,0(sp)
    80003a04:	0141                	addi	sp,sp,16
    80003a06:	8082                	ret

0000000080003a08 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a08:	1101                	addi	sp,sp,-32
    80003a0a:	ec06                	sd	ra,24(sp)
    80003a0c:	e822                	sd	s0,16(sp)
    80003a0e:	e426                	sd	s1,8(sp)
    80003a10:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a12:	00021517          	auipc	a0,0x21
    80003a16:	03650513          	addi	a0,a0,54 # 80024a48 <ftable>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	b20080e7          	jalr	-1248(ra) # 8000653a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a22:	00021497          	auipc	s1,0x21
    80003a26:	03e48493          	addi	s1,s1,62 # 80024a60 <ftable+0x18>
    80003a2a:	00022717          	auipc	a4,0x22
    80003a2e:	fd670713          	addi	a4,a4,-42 # 80025a00 <disk>
    if(f->ref == 0){
    80003a32:	40dc                	lw	a5,4(s1)
    80003a34:	cf99                	beqz	a5,80003a52 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a36:	02848493          	addi	s1,s1,40
    80003a3a:	fee49ce3          	bne	s1,a4,80003a32 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a3e:	00021517          	auipc	a0,0x21
    80003a42:	00a50513          	addi	a0,a0,10 # 80024a48 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	ba8080e7          	jalr	-1112(ra) # 800065ee <release>
  return 0;
    80003a4e:	4481                	li	s1,0
    80003a50:	a819                	j	80003a66 <filealloc+0x5e>
      f->ref = 1;
    80003a52:	4785                	li	a5,1
    80003a54:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a56:	00021517          	auipc	a0,0x21
    80003a5a:	ff250513          	addi	a0,a0,-14 # 80024a48 <ftable>
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	b90080e7          	jalr	-1136(ra) # 800065ee <release>
}
    80003a66:	8526                	mv	a0,s1
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret

0000000080003a72 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a72:	1101                	addi	sp,sp,-32
    80003a74:	ec06                	sd	ra,24(sp)
    80003a76:	e822                	sd	s0,16(sp)
    80003a78:	e426                	sd	s1,8(sp)
    80003a7a:	1000                	addi	s0,sp,32
    80003a7c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a7e:	00021517          	auipc	a0,0x21
    80003a82:	fca50513          	addi	a0,a0,-54 # 80024a48 <ftable>
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	ab4080e7          	jalr	-1356(ra) # 8000653a <acquire>
  if(f->ref < 1)
    80003a8e:	40dc                	lw	a5,4(s1)
    80003a90:	02f05263          	blez	a5,80003ab4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a94:	2785                	addiw	a5,a5,1
    80003a96:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a98:	00021517          	auipc	a0,0x21
    80003a9c:	fb050513          	addi	a0,a0,-80 # 80024a48 <ftable>
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	b4e080e7          	jalr	-1202(ra) # 800065ee <release>
  return f;
}
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret
    panic("filedup");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	b9c50513          	addi	a0,a0,-1124 # 80008650 <syscalls+0x250>
    80003abc:	00002097          	auipc	ra,0x2
    80003ac0:	542080e7          	jalr	1346(ra) # 80005ffe <panic>

0000000080003ac4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ac4:	7139                	addi	sp,sp,-64
    80003ac6:	fc06                	sd	ra,56(sp)
    80003ac8:	f822                	sd	s0,48(sp)
    80003aca:	f426                	sd	s1,40(sp)
    80003acc:	f04a                	sd	s2,32(sp)
    80003ace:	ec4e                	sd	s3,24(sp)
    80003ad0:	e852                	sd	s4,16(sp)
    80003ad2:	e456                	sd	s5,8(sp)
    80003ad4:	0080                	addi	s0,sp,64
    80003ad6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ad8:	00021517          	auipc	a0,0x21
    80003adc:	f7050513          	addi	a0,a0,-144 # 80024a48 <ftable>
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	a5a080e7          	jalr	-1446(ra) # 8000653a <acquire>
  if(f->ref < 1)
    80003ae8:	40dc                	lw	a5,4(s1)
    80003aea:	06f05163          	blez	a5,80003b4c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aee:	37fd                	addiw	a5,a5,-1
    80003af0:	0007871b          	sext.w	a4,a5
    80003af4:	c0dc                	sw	a5,4(s1)
    80003af6:	06e04363          	bgtz	a4,80003b5c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003afa:	0004a903          	lw	s2,0(s1)
    80003afe:	0094ca83          	lbu	s5,9(s1)
    80003b02:	0104ba03          	ld	s4,16(s1)
    80003b06:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b0a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b0e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b12:	00021517          	auipc	a0,0x21
    80003b16:	f3650513          	addi	a0,a0,-202 # 80024a48 <ftable>
    80003b1a:	00003097          	auipc	ra,0x3
    80003b1e:	ad4080e7          	jalr	-1324(ra) # 800065ee <release>

  if(ff.type == FD_PIPE){
    80003b22:	4785                	li	a5,1
    80003b24:	04f90d63          	beq	s2,a5,80003b7e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b28:	3979                	addiw	s2,s2,-2
    80003b2a:	4785                	li	a5,1
    80003b2c:	0527e063          	bltu	a5,s2,80003b6c <fileclose+0xa8>
    begin_op();
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	ac8080e7          	jalr	-1336(ra) # 800035f8 <begin_op>
    iput(ff.ip);
    80003b38:	854e                	mv	a0,s3
    80003b3a:	fffff097          	auipc	ra,0xfffff
    80003b3e:	2b2080e7          	jalr	690(ra) # 80002dec <iput>
    end_op();
    80003b42:	00000097          	auipc	ra,0x0
    80003b46:	b36080e7          	jalr	-1226(ra) # 80003678 <end_op>
    80003b4a:	a00d                	j	80003b6c <fileclose+0xa8>
    panic("fileclose");
    80003b4c:	00005517          	auipc	a0,0x5
    80003b50:	b0c50513          	addi	a0,a0,-1268 # 80008658 <syscalls+0x258>
    80003b54:	00002097          	auipc	ra,0x2
    80003b58:	4aa080e7          	jalr	1194(ra) # 80005ffe <panic>
    release(&ftable.lock);
    80003b5c:	00021517          	auipc	a0,0x21
    80003b60:	eec50513          	addi	a0,a0,-276 # 80024a48 <ftable>
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	a8a080e7          	jalr	-1398(ra) # 800065ee <release>
  }
}
    80003b6c:	70e2                	ld	ra,56(sp)
    80003b6e:	7442                	ld	s0,48(sp)
    80003b70:	74a2                	ld	s1,40(sp)
    80003b72:	7902                	ld	s2,32(sp)
    80003b74:	69e2                	ld	s3,24(sp)
    80003b76:	6a42                	ld	s4,16(sp)
    80003b78:	6aa2                	ld	s5,8(sp)
    80003b7a:	6121                	addi	sp,sp,64
    80003b7c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b7e:	85d6                	mv	a1,s5
    80003b80:	8552                	mv	a0,s4
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	3a6080e7          	jalr	934(ra) # 80003f28 <pipeclose>
    80003b8a:	b7cd                	j	80003b6c <fileclose+0xa8>

0000000080003b8c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b8c:	715d                	addi	sp,sp,-80
    80003b8e:	e486                	sd	ra,72(sp)
    80003b90:	e0a2                	sd	s0,64(sp)
    80003b92:	fc26                	sd	s1,56(sp)
    80003b94:	f84a                	sd	s2,48(sp)
    80003b96:	f44e                	sd	s3,40(sp)
    80003b98:	0880                	addi	s0,sp,80
    80003b9a:	84aa                	mv	s1,a0
    80003b9c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	29a080e7          	jalr	666(ra) # 80000e38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ba6:	409c                	lw	a5,0(s1)
    80003ba8:	37f9                	addiw	a5,a5,-2
    80003baa:	4705                	li	a4,1
    80003bac:	04f76763          	bltu	a4,a5,80003bfa <filestat+0x6e>
    80003bb0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bb2:	6c88                	ld	a0,24(s1)
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	07e080e7          	jalr	126(ra) # 80002c32 <ilock>
    stati(f->ip, &st);
    80003bbc:	fb840593          	addi	a1,s0,-72
    80003bc0:	6c88                	ld	a0,24(s1)
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	2fa080e7          	jalr	762(ra) # 80002ebc <stati>
    iunlock(f->ip);
    80003bca:	6c88                	ld	a0,24(s1)
    80003bcc:	fffff097          	auipc	ra,0xfffff
    80003bd0:	128080e7          	jalr	296(ra) # 80002cf4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bd4:	46e1                	li	a3,24
    80003bd6:	fb840613          	addi	a2,s0,-72
    80003bda:	85ce                	mv	a1,s3
    80003bdc:	05093503          	ld	a0,80(s2)
    80003be0:	ffffd097          	auipc	ra,0xffffd
    80003be4:	f14080e7          	jalr	-236(ra) # 80000af4 <copyout>
    80003be8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bec:	60a6                	ld	ra,72(sp)
    80003bee:	6406                	ld	s0,64(sp)
    80003bf0:	74e2                	ld	s1,56(sp)
    80003bf2:	7942                	ld	s2,48(sp)
    80003bf4:	79a2                	ld	s3,40(sp)
    80003bf6:	6161                	addi	sp,sp,80
    80003bf8:	8082                	ret
  return -1;
    80003bfa:	557d                	li	a0,-1
    80003bfc:	bfc5                	j	80003bec <filestat+0x60>

0000000080003bfe <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003bfe:	7179                	addi	sp,sp,-48
    80003c00:	f406                	sd	ra,40(sp)
    80003c02:	f022                	sd	s0,32(sp)
    80003c04:	ec26                	sd	s1,24(sp)
    80003c06:	e84a                	sd	s2,16(sp)
    80003c08:	e44e                	sd	s3,8(sp)
    80003c0a:	1800                	addi	s0,sp,48
    80003c0c:	84aa                	mv	s1,a0
    80003c0e:	89ae                	mv	s3,a1
    80003c10:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003c12:	85b2                	mv	a1,a2
    80003c14:	00005517          	auipc	a0,0x5
    80003c18:	a5450513          	addi	a0,a0,-1452 # 80008668 <syscalls+0x268>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	42c080e7          	jalr	1068(ra) # 80006048 <printf>
  ilock(f->ip);
    80003c24:	6c88                	ld	a0,24(s1)
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	00c080e7          	jalr	12(ra) # 80002c32 <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003c2e:	6705                	lui	a4,0x1
    80003c30:	86ca                	mv	a3,s2
    80003c32:	864e                	mv	a2,s3
    80003c34:	4581                	li	a1,0
    80003c36:	6c88                	ld	a0,24(s1)
    80003c38:	fffff097          	auipc	ra,0xfffff
    80003c3c:	2ae080e7          	jalr	686(ra) # 80002ee6 <readi>
  iunlock(f->ip);
    80003c40:	6c88                	ld	a0,24(s1)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	0b2080e7          	jalr	178(ra) # 80002cf4 <iunlock>
}
    80003c4a:	70a2                	ld	ra,40(sp)
    80003c4c:	7402                	ld	s0,32(sp)
    80003c4e:	64e2                	ld	s1,24(sp)
    80003c50:	6942                	ld	s2,16(sp)
    80003c52:	69a2                	ld	s3,8(sp)
    80003c54:	6145                	addi	sp,sp,48
    80003c56:	8082                	ret

0000000080003c58 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c58:	7179                	addi	sp,sp,-48
    80003c5a:	f406                	sd	ra,40(sp)
    80003c5c:	f022                	sd	s0,32(sp)
    80003c5e:	ec26                	sd	s1,24(sp)
    80003c60:	e84a                	sd	s2,16(sp)
    80003c62:	e44e                	sd	s3,8(sp)
    80003c64:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c66:	00854783          	lbu	a5,8(a0)
    80003c6a:	c3d5                	beqz	a5,80003d0e <fileread+0xb6>
    80003c6c:	84aa                	mv	s1,a0
    80003c6e:	89ae                	mv	s3,a1
    80003c70:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c72:	411c                	lw	a5,0(a0)
    80003c74:	4705                	li	a4,1
    80003c76:	04e78963          	beq	a5,a4,80003cc8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c7a:	470d                	li	a4,3
    80003c7c:	04e78d63          	beq	a5,a4,80003cd6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c80:	4709                	li	a4,2
    80003c82:	06e79e63          	bne	a5,a4,80003cfe <fileread+0xa6>
    ilock(f->ip);
    80003c86:	6d08                	ld	a0,24(a0)
    80003c88:	fffff097          	auipc	ra,0xfffff
    80003c8c:	faa080e7          	jalr	-86(ra) # 80002c32 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c90:	874a                	mv	a4,s2
    80003c92:	5094                	lw	a3,32(s1)
    80003c94:	864e                	mv	a2,s3
    80003c96:	4585                	li	a1,1
    80003c98:	6c88                	ld	a0,24(s1)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	24c080e7          	jalr	588(ra) # 80002ee6 <readi>
    80003ca2:	892a                	mv	s2,a0
    80003ca4:	00a05563          	blez	a0,80003cae <fileread+0x56>
      f->off += r;
    80003ca8:	509c                	lw	a5,32(s1)
    80003caa:	9fa9                	addw	a5,a5,a0
    80003cac:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	044080e7          	jalr	68(ra) # 80002cf4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cb8:	854a                	mv	a0,s2
    80003cba:	70a2                	ld	ra,40(sp)
    80003cbc:	7402                	ld	s0,32(sp)
    80003cbe:	64e2                	ld	s1,24(sp)
    80003cc0:	6942                	ld	s2,16(sp)
    80003cc2:	69a2                	ld	s3,8(sp)
    80003cc4:	6145                	addi	sp,sp,48
    80003cc6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cc8:	6908                	ld	a0,16(a0)
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	3c6080e7          	jalr	966(ra) # 80004090 <piperead>
    80003cd2:	892a                	mv	s2,a0
    80003cd4:	b7d5                	j	80003cb8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cd6:	02451783          	lh	a5,36(a0)
    80003cda:	03079693          	slli	a3,a5,0x30
    80003cde:	92c1                	srli	a3,a3,0x30
    80003ce0:	4725                	li	a4,9
    80003ce2:	02d76863          	bltu	a4,a3,80003d12 <fileread+0xba>
    80003ce6:	0792                	slli	a5,a5,0x4
    80003ce8:	00021717          	auipc	a4,0x21
    80003cec:	cc070713          	addi	a4,a4,-832 # 800249a8 <devsw>
    80003cf0:	97ba                	add	a5,a5,a4
    80003cf2:	639c                	ld	a5,0(a5)
    80003cf4:	c38d                	beqz	a5,80003d16 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cf6:	4505                	li	a0,1
    80003cf8:	9782                	jalr	a5
    80003cfa:	892a                	mv	s2,a0
    80003cfc:	bf75                	j	80003cb8 <fileread+0x60>
    panic("fileread");
    80003cfe:	00005517          	auipc	a0,0x5
    80003d02:	97250513          	addi	a0,a0,-1678 # 80008670 <syscalls+0x270>
    80003d06:	00002097          	auipc	ra,0x2
    80003d0a:	2f8080e7          	jalr	760(ra) # 80005ffe <panic>
    return -1;
    80003d0e:	597d                	li	s2,-1
    80003d10:	b765                	j	80003cb8 <fileread+0x60>
      return -1;
    80003d12:	597d                	li	s2,-1
    80003d14:	b755                	j	80003cb8 <fileread+0x60>
    80003d16:	597d                	li	s2,-1
    80003d18:	b745                	j	80003cb8 <fileread+0x60>

0000000080003d1a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d1a:	715d                	addi	sp,sp,-80
    80003d1c:	e486                	sd	ra,72(sp)
    80003d1e:	e0a2                	sd	s0,64(sp)
    80003d20:	fc26                	sd	s1,56(sp)
    80003d22:	f84a                	sd	s2,48(sp)
    80003d24:	f44e                	sd	s3,40(sp)
    80003d26:	f052                	sd	s4,32(sp)
    80003d28:	ec56                	sd	s5,24(sp)
    80003d2a:	e85a                	sd	s6,16(sp)
    80003d2c:	e45e                	sd	s7,8(sp)
    80003d2e:	e062                	sd	s8,0(sp)
    80003d30:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d32:	00954783          	lbu	a5,9(a0)
    80003d36:	10078663          	beqz	a5,80003e42 <filewrite+0x128>
    80003d3a:	892a                	mv	s2,a0
    80003d3c:	8aae                	mv	s5,a1
    80003d3e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d40:	411c                	lw	a5,0(a0)
    80003d42:	4705                	li	a4,1
    80003d44:	02e78263          	beq	a5,a4,80003d68 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d48:	470d                	li	a4,3
    80003d4a:	02e78663          	beq	a5,a4,80003d76 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d4e:	4709                	li	a4,2
    80003d50:	0ee79163          	bne	a5,a4,80003e32 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d54:	0ac05d63          	blez	a2,80003e0e <filewrite+0xf4>
    int i = 0;
    80003d58:	4981                	li	s3,0
    80003d5a:	6b05                	lui	s6,0x1
    80003d5c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d60:	6b85                	lui	s7,0x1
    80003d62:	c00b8b9b          	addiw	s7,s7,-1024
    80003d66:	a861                	j	80003dfe <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d68:	6908                	ld	a0,16(a0)
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	22e080e7          	jalr	558(ra) # 80003f98 <pipewrite>
    80003d72:	8a2a                	mv	s4,a0
    80003d74:	a045                	j	80003e14 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d76:	02451783          	lh	a5,36(a0)
    80003d7a:	03079693          	slli	a3,a5,0x30
    80003d7e:	92c1                	srli	a3,a3,0x30
    80003d80:	4725                	li	a4,9
    80003d82:	0cd76263          	bltu	a4,a3,80003e46 <filewrite+0x12c>
    80003d86:	0792                	slli	a5,a5,0x4
    80003d88:	00021717          	auipc	a4,0x21
    80003d8c:	c2070713          	addi	a4,a4,-992 # 800249a8 <devsw>
    80003d90:	97ba                	add	a5,a5,a4
    80003d92:	679c                	ld	a5,8(a5)
    80003d94:	cbdd                	beqz	a5,80003e4a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d96:	4505                	li	a0,1
    80003d98:	9782                	jalr	a5
    80003d9a:	8a2a                	mv	s4,a0
    80003d9c:	a8a5                	j	80003e14 <filewrite+0xfa>
    80003d9e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	856080e7          	jalr	-1962(ra) # 800035f8 <begin_op>
      ilock(f->ip);
    80003daa:	01893503          	ld	a0,24(s2)
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	e84080e7          	jalr	-380(ra) # 80002c32 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003db6:	8762                	mv	a4,s8
    80003db8:	02092683          	lw	a3,32(s2)
    80003dbc:	01598633          	add	a2,s3,s5
    80003dc0:	4585                	li	a1,1
    80003dc2:	01893503          	ld	a0,24(s2)
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	218080e7          	jalr	536(ra) # 80002fde <writei>
    80003dce:	84aa                	mv	s1,a0
    80003dd0:	00a05763          	blez	a0,80003dde <filewrite+0xc4>
        f->off += r;
    80003dd4:	02092783          	lw	a5,32(s2)
    80003dd8:	9fa9                	addw	a5,a5,a0
    80003dda:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dde:	01893503          	ld	a0,24(s2)
    80003de2:	fffff097          	auipc	ra,0xfffff
    80003de6:	f12080e7          	jalr	-238(ra) # 80002cf4 <iunlock>
      end_op();
    80003dea:	00000097          	auipc	ra,0x0
    80003dee:	88e080e7          	jalr	-1906(ra) # 80003678 <end_op>

      if(r != n1){
    80003df2:	009c1f63          	bne	s8,s1,80003e10 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003df6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dfa:	0149db63          	bge	s3,s4,80003e10 <filewrite+0xf6>
      int n1 = n - i;
    80003dfe:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e02:	84be                	mv	s1,a5
    80003e04:	2781                	sext.w	a5,a5
    80003e06:	f8fb5ce3          	bge	s6,a5,80003d9e <filewrite+0x84>
    80003e0a:	84de                	mv	s1,s7
    80003e0c:	bf49                	j	80003d9e <filewrite+0x84>
    int i = 0;
    80003e0e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e10:	013a1f63          	bne	s4,s3,80003e2e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e14:	8552                	mv	a0,s4
    80003e16:	60a6                	ld	ra,72(sp)
    80003e18:	6406                	ld	s0,64(sp)
    80003e1a:	74e2                	ld	s1,56(sp)
    80003e1c:	7942                	ld	s2,48(sp)
    80003e1e:	79a2                	ld	s3,40(sp)
    80003e20:	7a02                	ld	s4,32(sp)
    80003e22:	6ae2                	ld	s5,24(sp)
    80003e24:	6b42                	ld	s6,16(sp)
    80003e26:	6ba2                	ld	s7,8(sp)
    80003e28:	6c02                	ld	s8,0(sp)
    80003e2a:	6161                	addi	sp,sp,80
    80003e2c:	8082                	ret
    ret = (i == n ? n : -1);
    80003e2e:	5a7d                	li	s4,-1
    80003e30:	b7d5                	j	80003e14 <filewrite+0xfa>
    panic("filewrite");
    80003e32:	00005517          	auipc	a0,0x5
    80003e36:	84e50513          	addi	a0,a0,-1970 # 80008680 <syscalls+0x280>
    80003e3a:	00002097          	auipc	ra,0x2
    80003e3e:	1c4080e7          	jalr	452(ra) # 80005ffe <panic>
    return -1;
    80003e42:	5a7d                	li	s4,-1
    80003e44:	bfc1                	j	80003e14 <filewrite+0xfa>
      return -1;
    80003e46:	5a7d                	li	s4,-1
    80003e48:	b7f1                	j	80003e14 <filewrite+0xfa>
    80003e4a:	5a7d                	li	s4,-1
    80003e4c:	b7e1                	j	80003e14 <filewrite+0xfa>

0000000080003e4e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e4e:	7179                	addi	sp,sp,-48
    80003e50:	f406                	sd	ra,40(sp)
    80003e52:	f022                	sd	s0,32(sp)
    80003e54:	ec26                	sd	s1,24(sp)
    80003e56:	e84a                	sd	s2,16(sp)
    80003e58:	e44e                	sd	s3,8(sp)
    80003e5a:	e052                	sd	s4,0(sp)
    80003e5c:	1800                	addi	s0,sp,48
    80003e5e:	84aa                	mv	s1,a0
    80003e60:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e62:	0005b023          	sd	zero,0(a1)
    80003e66:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	b9e080e7          	jalr	-1122(ra) # 80003a08 <filealloc>
    80003e72:	e088                	sd	a0,0(s1)
    80003e74:	c551                	beqz	a0,80003f00 <pipealloc+0xb2>
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	b92080e7          	jalr	-1134(ra) # 80003a08 <filealloc>
    80003e7e:	00aa3023          	sd	a0,0(s4)
    80003e82:	c92d                	beqz	a0,80003ef4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e84:	ffffc097          	auipc	ra,0xffffc
    80003e88:	294080e7          	jalr	660(ra) # 80000118 <kalloc>
    80003e8c:	892a                	mv	s2,a0
    80003e8e:	c125                	beqz	a0,80003eee <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e90:	4985                	li	s3,1
    80003e92:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e96:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e9a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e9e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ea2:	00004597          	auipc	a1,0x4
    80003ea6:	7ee58593          	addi	a1,a1,2030 # 80008690 <syscalls+0x290>
    80003eaa:	00002097          	auipc	ra,0x2
    80003eae:	600080e7          	jalr	1536(ra) # 800064aa <initlock>
  (*f0)->type = FD_PIPE;
    80003eb2:	609c                	ld	a5,0(s1)
    80003eb4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eb8:	609c                	ld	a5,0(s1)
    80003eba:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ebe:	609c                	ld	a5,0(s1)
    80003ec0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ec4:	609c                	ld	a5,0(s1)
    80003ec6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eca:	000a3783          	ld	a5,0(s4)
    80003ece:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ed2:	000a3783          	ld	a5,0(s4)
    80003ed6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eda:	000a3783          	ld	a5,0(s4)
    80003ede:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ee2:	000a3783          	ld	a5,0(s4)
    80003ee6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eea:	4501                	li	a0,0
    80003eec:	a025                	j	80003f14 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eee:	6088                	ld	a0,0(s1)
    80003ef0:	e501                	bnez	a0,80003ef8 <pipealloc+0xaa>
    80003ef2:	a039                	j	80003f00 <pipealloc+0xb2>
    80003ef4:	6088                	ld	a0,0(s1)
    80003ef6:	c51d                	beqz	a0,80003f24 <pipealloc+0xd6>
    fileclose(*f0);
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	bcc080e7          	jalr	-1076(ra) # 80003ac4 <fileclose>
  if(*f1)
    80003f00:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f04:	557d                	li	a0,-1
  if(*f1)
    80003f06:	c799                	beqz	a5,80003f14 <pipealloc+0xc6>
    fileclose(*f1);
    80003f08:	853e                	mv	a0,a5
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	bba080e7          	jalr	-1094(ra) # 80003ac4 <fileclose>
  return -1;
    80003f12:	557d                	li	a0,-1
}
    80003f14:	70a2                	ld	ra,40(sp)
    80003f16:	7402                	ld	s0,32(sp)
    80003f18:	64e2                	ld	s1,24(sp)
    80003f1a:	6942                	ld	s2,16(sp)
    80003f1c:	69a2                	ld	s3,8(sp)
    80003f1e:	6a02                	ld	s4,0(sp)
    80003f20:	6145                	addi	sp,sp,48
    80003f22:	8082                	ret
  return -1;
    80003f24:	557d                	li	a0,-1
    80003f26:	b7fd                	j	80003f14 <pipealloc+0xc6>

0000000080003f28 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f28:	1101                	addi	sp,sp,-32
    80003f2a:	ec06                	sd	ra,24(sp)
    80003f2c:	e822                	sd	s0,16(sp)
    80003f2e:	e426                	sd	s1,8(sp)
    80003f30:	e04a                	sd	s2,0(sp)
    80003f32:	1000                	addi	s0,sp,32
    80003f34:	84aa                	mv	s1,a0
    80003f36:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f38:	00002097          	auipc	ra,0x2
    80003f3c:	602080e7          	jalr	1538(ra) # 8000653a <acquire>
  if(writable){
    80003f40:	02090d63          	beqz	s2,80003f7a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f44:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f48:	21848513          	addi	a0,s1,536
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	658080e7          	jalr	1624(ra) # 800015a4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f54:	2204b783          	ld	a5,544(s1)
    80003f58:	eb95                	bnez	a5,80003f8c <pipeclose+0x64>
    release(&pi->lock);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	692080e7          	jalr	1682(ra) # 800065ee <release>
    kfree((char*)pi);
    80003f64:	8526                	mv	a0,s1
    80003f66:	ffffc097          	auipc	ra,0xffffc
    80003f6a:	0b6080e7          	jalr	182(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f6e:	60e2                	ld	ra,24(sp)
    80003f70:	6442                	ld	s0,16(sp)
    80003f72:	64a2                	ld	s1,8(sp)
    80003f74:	6902                	ld	s2,0(sp)
    80003f76:	6105                	addi	sp,sp,32
    80003f78:	8082                	ret
    pi->readopen = 0;
    80003f7a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f7e:	21c48513          	addi	a0,s1,540
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	622080e7          	jalr	1570(ra) # 800015a4 <wakeup>
    80003f8a:	b7e9                	j	80003f54 <pipeclose+0x2c>
    release(&pi->lock);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	00002097          	auipc	ra,0x2
    80003f92:	660080e7          	jalr	1632(ra) # 800065ee <release>
}
    80003f96:	bfe1                	j	80003f6e <pipeclose+0x46>

0000000080003f98 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f98:	711d                	addi	sp,sp,-96
    80003f9a:	ec86                	sd	ra,88(sp)
    80003f9c:	e8a2                	sd	s0,80(sp)
    80003f9e:	e4a6                	sd	s1,72(sp)
    80003fa0:	e0ca                	sd	s2,64(sp)
    80003fa2:	fc4e                	sd	s3,56(sp)
    80003fa4:	f852                	sd	s4,48(sp)
    80003fa6:	f456                	sd	s5,40(sp)
    80003fa8:	f05a                	sd	s6,32(sp)
    80003faa:	ec5e                	sd	s7,24(sp)
    80003fac:	e862                	sd	s8,16(sp)
    80003fae:	1080                	addi	s0,sp,96
    80003fb0:	84aa                	mv	s1,a0
    80003fb2:	8aae                	mv	s5,a1
    80003fb4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	e82080e7          	jalr	-382(ra) # 80000e38 <myproc>
    80003fbe:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	00002097          	auipc	ra,0x2
    80003fc6:	578080e7          	jalr	1400(ra) # 8000653a <acquire>
  while(i < n){
    80003fca:	0b405663          	blez	s4,80004076 <pipewrite+0xde>
  int i = 0;
    80003fce:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fd2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fd6:	21c48b93          	addi	s7,s1,540
    80003fda:	a089                	j	8000401c <pipewrite+0x84>
      release(&pi->lock);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	00002097          	auipc	ra,0x2
    80003fe2:	610080e7          	jalr	1552(ra) # 800065ee <release>
      return -1;
    80003fe6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fe8:	854a                	mv	a0,s2
    80003fea:	60e6                	ld	ra,88(sp)
    80003fec:	6446                	ld	s0,80(sp)
    80003fee:	64a6                	ld	s1,72(sp)
    80003ff0:	6906                	ld	s2,64(sp)
    80003ff2:	79e2                	ld	s3,56(sp)
    80003ff4:	7a42                	ld	s4,48(sp)
    80003ff6:	7aa2                	ld	s5,40(sp)
    80003ff8:	7b02                	ld	s6,32(sp)
    80003ffa:	6be2                	ld	s7,24(sp)
    80003ffc:	6c42                	ld	s8,16(sp)
    80003ffe:	6125                	addi	sp,sp,96
    80004000:	8082                	ret
      wakeup(&pi->nread);
    80004002:	8562                	mv	a0,s8
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	5a0080e7          	jalr	1440(ra) # 800015a4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000400c:	85a6                	mv	a1,s1
    8000400e:	855e                	mv	a0,s7
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	530080e7          	jalr	1328(ra) # 80001540 <sleep>
  while(i < n){
    80004018:	07495063          	bge	s2,s4,80004078 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000401c:	2204a783          	lw	a5,544(s1)
    80004020:	dfd5                	beqz	a5,80003fdc <pipewrite+0x44>
    80004022:	854e                	mv	a0,s3
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	7c4080e7          	jalr	1988(ra) # 800017e8 <killed>
    8000402c:	f945                	bnez	a0,80003fdc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000402e:	2184a783          	lw	a5,536(s1)
    80004032:	21c4a703          	lw	a4,540(s1)
    80004036:	2007879b          	addiw	a5,a5,512
    8000403a:	fcf704e3          	beq	a4,a5,80004002 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000403e:	4685                	li	a3,1
    80004040:	01590633          	add	a2,s2,s5
    80004044:	faf40593          	addi	a1,s0,-81
    80004048:	0509b503          	ld	a0,80(s3)
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	b34080e7          	jalr	-1228(ra) # 80000b80 <copyin>
    80004054:	03650263          	beq	a0,s6,80004078 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004058:	21c4a783          	lw	a5,540(s1)
    8000405c:	0017871b          	addiw	a4,a5,1
    80004060:	20e4ae23          	sw	a4,540(s1)
    80004064:	1ff7f793          	andi	a5,a5,511
    80004068:	97a6                	add	a5,a5,s1
    8000406a:	faf44703          	lbu	a4,-81(s0)
    8000406e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004072:	2905                	addiw	s2,s2,1
    80004074:	b755                	j	80004018 <pipewrite+0x80>
  int i = 0;
    80004076:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004078:	21848513          	addi	a0,s1,536
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	528080e7          	jalr	1320(ra) # 800015a4 <wakeup>
  release(&pi->lock);
    80004084:	8526                	mv	a0,s1
    80004086:	00002097          	auipc	ra,0x2
    8000408a:	568080e7          	jalr	1384(ra) # 800065ee <release>
  return i;
    8000408e:	bfa9                	j	80003fe8 <pipewrite+0x50>

0000000080004090 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004090:	715d                	addi	sp,sp,-80
    80004092:	e486                	sd	ra,72(sp)
    80004094:	e0a2                	sd	s0,64(sp)
    80004096:	fc26                	sd	s1,56(sp)
    80004098:	f84a                	sd	s2,48(sp)
    8000409a:	f44e                	sd	s3,40(sp)
    8000409c:	f052                	sd	s4,32(sp)
    8000409e:	ec56                	sd	s5,24(sp)
    800040a0:	e85a                	sd	s6,16(sp)
    800040a2:	0880                	addi	s0,sp,80
    800040a4:	84aa                	mv	s1,a0
    800040a6:	892e                	mv	s2,a1
    800040a8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	d8e080e7          	jalr	-626(ra) # 80000e38 <myproc>
    800040b2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040b4:	8526                	mv	a0,s1
    800040b6:	00002097          	auipc	ra,0x2
    800040ba:	484080e7          	jalr	1156(ra) # 8000653a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040be:	2184a703          	lw	a4,536(s1)
    800040c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ca:	02f71763          	bne	a4,a5,800040f8 <piperead+0x68>
    800040ce:	2244a783          	lw	a5,548(s1)
    800040d2:	c39d                	beqz	a5,800040f8 <piperead+0x68>
    if(killed(pr)){
    800040d4:	8552                	mv	a0,s4
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	712080e7          	jalr	1810(ra) # 800017e8 <killed>
    800040de:	e941                	bnez	a0,8000416e <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040e0:	85a6                	mv	a1,s1
    800040e2:	854e                	mv	a0,s3
    800040e4:	ffffd097          	auipc	ra,0xffffd
    800040e8:	45c080e7          	jalr	1116(ra) # 80001540 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ec:	2184a703          	lw	a4,536(s1)
    800040f0:	21c4a783          	lw	a5,540(s1)
    800040f4:	fcf70de3          	beq	a4,a5,800040ce <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fc:	05505363          	blez	s5,80004142 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004100:	2184a783          	lw	a5,536(s1)
    80004104:	21c4a703          	lw	a4,540(s1)
    80004108:	02f70d63          	beq	a4,a5,80004142 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410c:	0017871b          	addiw	a4,a5,1
    80004110:	20e4ac23          	sw	a4,536(s1)
    80004114:	1ff7f793          	andi	a5,a5,511
    80004118:	97a6                	add	a5,a5,s1
    8000411a:	0187c783          	lbu	a5,24(a5)
    8000411e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004122:	4685                	li	a3,1
    80004124:	fbf40613          	addi	a2,s0,-65
    80004128:	85ca                	mv	a1,s2
    8000412a:	050a3503          	ld	a0,80(s4)
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	9c6080e7          	jalr	-1594(ra) # 80000af4 <copyout>
    80004136:	01650663          	beq	a0,s6,80004142 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413a:	2985                	addiw	s3,s3,1
    8000413c:	0905                	addi	s2,s2,1
    8000413e:	fd3a91e3          	bne	s5,s3,80004100 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004142:	21c48513          	addi	a0,s1,540
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	45e080e7          	jalr	1118(ra) # 800015a4 <wakeup>
  release(&pi->lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	00002097          	auipc	ra,0x2
    80004154:	49e080e7          	jalr	1182(ra) # 800065ee <release>
  return i;
}
    80004158:	854e                	mv	a0,s3
    8000415a:	60a6                	ld	ra,72(sp)
    8000415c:	6406                	ld	s0,64(sp)
    8000415e:	74e2                	ld	s1,56(sp)
    80004160:	7942                	ld	s2,48(sp)
    80004162:	79a2                	ld	s3,40(sp)
    80004164:	7a02                	ld	s4,32(sp)
    80004166:	6ae2                	ld	s5,24(sp)
    80004168:	6b42                	ld	s6,16(sp)
    8000416a:	6161                	addi	sp,sp,80
    8000416c:	8082                	ret
      release(&pi->lock);
    8000416e:	8526                	mv	a0,s1
    80004170:	00002097          	auipc	ra,0x2
    80004174:	47e080e7          	jalr	1150(ra) # 800065ee <release>
      return -1;
    80004178:	59fd                	li	s3,-1
    8000417a:	bff9                	j	80004158 <piperead+0xc8>

000000008000417c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000417c:	1141                	addi	sp,sp,-16
    8000417e:	e422                	sd	s0,8(sp)
    80004180:	0800                	addi	s0,sp,16
    80004182:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004184:	8905                	andi	a0,a0,1
    80004186:	c111                	beqz	a0,8000418a <flags2perm+0xe>
      perm = PTE_X;
    80004188:	4521                	li	a0,8
    if(flags & 0x2)
    8000418a:	8b89                	andi	a5,a5,2
    8000418c:	c399                	beqz	a5,80004192 <flags2perm+0x16>
      perm |= PTE_W;
    8000418e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004192:	6422                	ld	s0,8(sp)
    80004194:	0141                	addi	sp,sp,16
    80004196:	8082                	ret

0000000080004198 <exec>:

int
exec(char *path, char **argv)
{
    80004198:	de010113          	addi	sp,sp,-544
    8000419c:	20113c23          	sd	ra,536(sp)
    800041a0:	20813823          	sd	s0,528(sp)
    800041a4:	20913423          	sd	s1,520(sp)
    800041a8:	21213023          	sd	s2,512(sp)
    800041ac:	ffce                	sd	s3,504(sp)
    800041ae:	fbd2                	sd	s4,496(sp)
    800041b0:	f7d6                	sd	s5,488(sp)
    800041b2:	f3da                	sd	s6,480(sp)
    800041b4:	efde                	sd	s7,472(sp)
    800041b6:	ebe2                	sd	s8,464(sp)
    800041b8:	e7e6                	sd	s9,456(sp)
    800041ba:	e3ea                	sd	s10,448(sp)
    800041bc:	ff6e                	sd	s11,440(sp)
    800041be:	1400                	addi	s0,sp,544
    800041c0:	892a                	mv	s2,a0
    800041c2:	dea43423          	sd	a0,-536(s0)
    800041c6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	c6e080e7          	jalr	-914(ra) # 80000e38 <myproc>
    800041d2:	84aa                	mv	s1,a0

  begin_op();
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	424080e7          	jalr	1060(ra) # 800035f8 <begin_op>

  if((ip = namei(path)) == 0){
    800041dc:	854a                	mv	a0,s2
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	1fa080e7          	jalr	506(ra) # 800033d8 <namei>
    800041e6:	c93d                	beqz	a0,8000425c <exec+0xc4>
    800041e8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	a48080e7          	jalr	-1464(ra) # 80002c32 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041f2:	04000713          	li	a4,64
    800041f6:	4681                	li	a3,0
    800041f8:	e5040613          	addi	a2,s0,-432
    800041fc:	4581                	li	a1,0
    800041fe:	8556                	mv	a0,s5
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	ce6080e7          	jalr	-794(ra) # 80002ee6 <readi>
    80004208:	04000793          	li	a5,64
    8000420c:	00f51a63          	bne	a0,a5,80004220 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004210:	e5042703          	lw	a4,-432(s0)
    80004214:	464c47b7          	lui	a5,0x464c4
    80004218:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000421c:	04f70663          	beq	a4,a5,80004268 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004220:	8556                	mv	a0,s5
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	c72080e7          	jalr	-910(ra) # 80002e94 <iunlockput>
    end_op();
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	44e080e7          	jalr	1102(ra) # 80003678 <end_op>
  }
  return -1;
    80004232:	557d                	li	a0,-1
}
    80004234:	21813083          	ld	ra,536(sp)
    80004238:	21013403          	ld	s0,528(sp)
    8000423c:	20813483          	ld	s1,520(sp)
    80004240:	20013903          	ld	s2,512(sp)
    80004244:	79fe                	ld	s3,504(sp)
    80004246:	7a5e                	ld	s4,496(sp)
    80004248:	7abe                	ld	s5,488(sp)
    8000424a:	7b1e                	ld	s6,480(sp)
    8000424c:	6bfe                	ld	s7,472(sp)
    8000424e:	6c5e                	ld	s8,464(sp)
    80004250:	6cbe                	ld	s9,456(sp)
    80004252:	6d1e                	ld	s10,448(sp)
    80004254:	7dfa                	ld	s11,440(sp)
    80004256:	22010113          	addi	sp,sp,544
    8000425a:	8082                	ret
    end_op();
    8000425c:	fffff097          	auipc	ra,0xfffff
    80004260:	41c080e7          	jalr	1052(ra) # 80003678 <end_op>
    return -1;
    80004264:	557d                	li	a0,-1
    80004266:	b7f9                	j	80004234 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004268:	8526                	mv	a0,s1
    8000426a:	ffffd097          	auipc	ra,0xffffd
    8000426e:	c92080e7          	jalr	-878(ra) # 80000efc <proc_pagetable>
    80004272:	8b2a                	mv	s6,a0
    80004274:	d555                	beqz	a0,80004220 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004276:	e7042783          	lw	a5,-400(s0)
    8000427a:	e8845703          	lhu	a4,-376(s0)
    8000427e:	c735                	beqz	a4,800042ea <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004280:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004282:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004286:	6a05                	lui	s4,0x1
    80004288:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000428c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004290:	6d85                	lui	s11,0x1
    80004292:	7d7d                	lui	s10,0xfffff
    80004294:	a481                	j	800044d4 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004296:	00004517          	auipc	a0,0x4
    8000429a:	40250513          	addi	a0,a0,1026 # 80008698 <syscalls+0x298>
    8000429e:	00002097          	auipc	ra,0x2
    800042a2:	d60080e7          	jalr	-672(ra) # 80005ffe <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042a6:	874a                	mv	a4,s2
    800042a8:	009c86bb          	addw	a3,s9,s1
    800042ac:	4581                	li	a1,0
    800042ae:	8556                	mv	a0,s5
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	c36080e7          	jalr	-970(ra) # 80002ee6 <readi>
    800042b8:	2501                	sext.w	a0,a0
    800042ba:	1aa91a63          	bne	s2,a0,8000446e <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800042be:	009d84bb          	addw	s1,s11,s1
    800042c2:	013d09bb          	addw	s3,s10,s3
    800042c6:	1f74f763          	bgeu	s1,s7,800044b4 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800042ca:	02049593          	slli	a1,s1,0x20
    800042ce:	9181                	srli	a1,a1,0x20
    800042d0:	95e2                	add	a1,a1,s8
    800042d2:	855a                	mv	a0,s6
    800042d4:	ffffc097          	auipc	ra,0xffffc
    800042d8:	22e080e7          	jalr	558(ra) # 80000502 <walkaddr>
    800042dc:	862a                	mv	a2,a0
    if(pa == 0)
    800042de:	dd45                	beqz	a0,80004296 <exec+0xfe>
      n = PGSIZE;
    800042e0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042e2:	fd49f2e3          	bgeu	s3,s4,800042a6 <exec+0x10e>
      n = sz - i;
    800042e6:	894e                	mv	s2,s3
    800042e8:	bf7d                	j	800042a6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ea:	4901                	li	s2,0
  iunlockput(ip);
    800042ec:	8556                	mv	a0,s5
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	ba6080e7          	jalr	-1114(ra) # 80002e94 <iunlockput>
  end_op();
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	382080e7          	jalr	898(ra) # 80003678 <end_op>
  p = myproc();
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	b3a080e7          	jalr	-1222(ra) # 80000e38 <myproc>
    80004306:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004308:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000430c:	6785                	lui	a5,0x1
    8000430e:	17fd                	addi	a5,a5,-1
    80004310:	993e                	add	s2,s2,a5
    80004312:	77fd                	lui	a5,0xfffff
    80004314:	00f977b3          	and	a5,s2,a5
    80004318:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000431c:	4691                	li	a3,4
    8000431e:	6609                	lui	a2,0x2
    80004320:	963e                	add	a2,a2,a5
    80004322:	85be                	mv	a1,a5
    80004324:	855a                	mv	a0,s6
    80004326:	ffffc097          	auipc	ra,0xffffc
    8000432a:	582080e7          	jalr	1410(ra) # 800008a8 <uvmalloc>
    8000432e:	8c2a                	mv	s8,a0
  ip = 0;
    80004330:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004332:	12050e63          	beqz	a0,8000446e <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004336:	75f9                	lui	a1,0xffffe
    80004338:	95aa                	add	a1,a1,a0
    8000433a:	855a                	mv	a0,s6
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	786080e7          	jalr	1926(ra) # 80000ac2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004344:	7afd                	lui	s5,0xfffff
    80004346:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004348:	df043783          	ld	a5,-528(s0)
    8000434c:	6388                	ld	a0,0(a5)
    8000434e:	c925                	beqz	a0,800043be <exec+0x226>
    80004350:	e9040993          	addi	s3,s0,-368
    80004354:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004358:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000435a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000435c:	ffffc097          	auipc	ra,0xffffc
    80004360:	f98080e7          	jalr	-104(ra) # 800002f4 <strlen>
    80004364:	0015079b          	addiw	a5,a0,1
    80004368:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000436c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004370:	13596663          	bltu	s2,s5,8000449c <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004374:	df043d83          	ld	s11,-528(s0)
    80004378:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000437c:	8552                	mv	a0,s4
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	f76080e7          	jalr	-138(ra) # 800002f4 <strlen>
    80004386:	0015069b          	addiw	a3,a0,1
    8000438a:	8652                	mv	a2,s4
    8000438c:	85ca                	mv	a1,s2
    8000438e:	855a                	mv	a0,s6
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	764080e7          	jalr	1892(ra) # 80000af4 <copyout>
    80004398:	10054663          	bltz	a0,800044a4 <exec+0x30c>
    ustack[argc] = sp;
    8000439c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043a0:	0485                	addi	s1,s1,1
    800043a2:	008d8793          	addi	a5,s11,8
    800043a6:	def43823          	sd	a5,-528(s0)
    800043aa:	008db503          	ld	a0,8(s11)
    800043ae:	c911                	beqz	a0,800043c2 <exec+0x22a>
    if(argc >= MAXARG)
    800043b0:	09a1                	addi	s3,s3,8
    800043b2:	fb3c95e3          	bne	s9,s3,8000435c <exec+0x1c4>
  sz = sz1;
    800043b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ba:	4a81                	li	s5,0
    800043bc:	a84d                	j	8000446e <exec+0x2d6>
  sp = sz;
    800043be:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043c0:	4481                	li	s1,0
  ustack[argc] = 0;
    800043c2:	00349793          	slli	a5,s1,0x3
    800043c6:	f9040713          	addi	a4,s0,-112
    800043ca:	97ba                	add	a5,a5,a4
    800043cc:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd1180>
  sp -= (argc+1) * sizeof(uint64);
    800043d0:	00148693          	addi	a3,s1,1
    800043d4:	068e                	slli	a3,a3,0x3
    800043d6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043da:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043de:	01597663          	bgeu	s2,s5,800043ea <exec+0x252>
  sz = sz1;
    800043e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e6:	4a81                	li	s5,0
    800043e8:	a059                	j	8000446e <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ea:	e9040613          	addi	a2,s0,-368
    800043ee:	85ca                	mv	a1,s2
    800043f0:	855a                	mv	a0,s6
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	702080e7          	jalr	1794(ra) # 80000af4 <copyout>
    800043fa:	0a054963          	bltz	a0,800044ac <exec+0x314>
  p->trapframe->a1 = sp;
    800043fe:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004402:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004406:	de843783          	ld	a5,-536(s0)
    8000440a:	0007c703          	lbu	a4,0(a5)
    8000440e:	cf11                	beqz	a4,8000442a <exec+0x292>
    80004410:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004412:	02f00693          	li	a3,47
    80004416:	a039                	j	80004424 <exec+0x28c>
      last = s+1;
    80004418:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000441c:	0785                	addi	a5,a5,1
    8000441e:	fff7c703          	lbu	a4,-1(a5)
    80004422:	c701                	beqz	a4,8000442a <exec+0x292>
    if(*s == '/')
    80004424:	fed71ce3          	bne	a4,a3,8000441c <exec+0x284>
    80004428:	bfc5                	j	80004418 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000442a:	4641                	li	a2,16
    8000442c:	de843583          	ld	a1,-536(s0)
    80004430:	158b8513          	addi	a0,s7,344
    80004434:	ffffc097          	auipc	ra,0xffffc
    80004438:	e8e080e7          	jalr	-370(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000443c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004440:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004444:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004448:	058bb783          	ld	a5,88(s7)
    8000444c:	e6843703          	ld	a4,-408(s0)
    80004450:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004452:	058bb783          	ld	a5,88(s7)
    80004456:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000445a:	85ea                	mv	a1,s10
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	b3c080e7          	jalr	-1220(ra) # 80000f98 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004464:	0004851b          	sext.w	a0,s1
    80004468:	b3f1                	j	80004234 <exec+0x9c>
    8000446a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000446e:	df843583          	ld	a1,-520(s0)
    80004472:	855a                	mv	a0,s6
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	b24080e7          	jalr	-1244(ra) # 80000f98 <proc_freepagetable>
  if(ip){
    8000447c:	da0a92e3          	bnez	s5,80004220 <exec+0x88>
  return -1;
    80004480:	557d                	li	a0,-1
    80004482:	bb4d                	j	80004234 <exec+0x9c>
    80004484:	df243c23          	sd	s2,-520(s0)
    80004488:	b7dd                	j	8000446e <exec+0x2d6>
    8000448a:	df243c23          	sd	s2,-520(s0)
    8000448e:	b7c5                	j	8000446e <exec+0x2d6>
    80004490:	df243c23          	sd	s2,-520(s0)
    80004494:	bfe9                	j	8000446e <exec+0x2d6>
    80004496:	df243c23          	sd	s2,-520(s0)
    8000449a:	bfd1                	j	8000446e <exec+0x2d6>
  sz = sz1;
    8000449c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a0:	4a81                	li	s5,0
    800044a2:	b7f1                	j	8000446e <exec+0x2d6>
  sz = sz1;
    800044a4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a8:	4a81                	li	s5,0
    800044aa:	b7d1                	j	8000446e <exec+0x2d6>
  sz = sz1;
    800044ac:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044b0:	4a81                	li	s5,0
    800044b2:	bf75                	j	8000446e <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044b4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044b8:	e0843783          	ld	a5,-504(s0)
    800044bc:	0017869b          	addiw	a3,a5,1
    800044c0:	e0d43423          	sd	a3,-504(s0)
    800044c4:	e0043783          	ld	a5,-512(s0)
    800044c8:	0387879b          	addiw	a5,a5,56
    800044cc:	e8845703          	lhu	a4,-376(s0)
    800044d0:	e0e6dee3          	bge	a3,a4,800042ec <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044d4:	2781                	sext.w	a5,a5
    800044d6:	e0f43023          	sd	a5,-512(s0)
    800044da:	03800713          	li	a4,56
    800044de:	86be                	mv	a3,a5
    800044e0:	e1840613          	addi	a2,s0,-488
    800044e4:	4581                	li	a1,0
    800044e6:	8556                	mv	a0,s5
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	9fe080e7          	jalr	-1538(ra) # 80002ee6 <readi>
    800044f0:	03800793          	li	a5,56
    800044f4:	f6f51be3          	bne	a0,a5,8000446a <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800044f8:	e1842783          	lw	a5,-488(s0)
    800044fc:	4705                	li	a4,1
    800044fe:	fae79de3          	bne	a5,a4,800044b8 <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004502:	e4043483          	ld	s1,-448(s0)
    80004506:	e3843783          	ld	a5,-456(s0)
    8000450a:	f6f4ede3          	bltu	s1,a5,80004484 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000450e:	e2843783          	ld	a5,-472(s0)
    80004512:	94be                	add	s1,s1,a5
    80004514:	f6f4ebe3          	bltu	s1,a5,8000448a <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004518:	de043703          	ld	a4,-544(s0)
    8000451c:	8ff9                	and	a5,a5,a4
    8000451e:	fbad                	bnez	a5,80004490 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004520:	e1c42503          	lw	a0,-484(s0)
    80004524:	00000097          	auipc	ra,0x0
    80004528:	c58080e7          	jalr	-936(ra) # 8000417c <flags2perm>
    8000452c:	86aa                	mv	a3,a0
    8000452e:	8626                	mv	a2,s1
    80004530:	85ca                	mv	a1,s2
    80004532:	855a                	mv	a0,s6
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	374080e7          	jalr	884(ra) # 800008a8 <uvmalloc>
    8000453c:	dea43c23          	sd	a0,-520(s0)
    80004540:	d939                	beqz	a0,80004496 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004542:	e2843c03          	ld	s8,-472(s0)
    80004546:	e2042c83          	lw	s9,-480(s0)
    8000454a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000454e:	f60b83e3          	beqz	s7,800044b4 <exec+0x31c>
    80004552:	89de                	mv	s3,s7
    80004554:	4481                	li	s1,0
    80004556:	bb95                	j	800042ca <exec+0x132>

0000000080004558 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004558:	7179                	addi	sp,sp,-48
    8000455a:	f406                	sd	ra,40(sp)
    8000455c:	f022                	sd	s0,32(sp)
    8000455e:	ec26                	sd	s1,24(sp)
    80004560:	e84a                	sd	s2,16(sp)
    80004562:	1800                	addi	s0,sp,48
    80004564:	892e                	mv	s2,a1
    80004566:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004568:	fdc40593          	addi	a1,s0,-36
    8000456c:	ffffe097          	auipc	ra,0xffffe
    80004570:	b4a080e7          	jalr	-1206(ra) # 800020b6 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004574:	fdc42703          	lw	a4,-36(s0)
    80004578:	47bd                	li	a5,15
    8000457a:	02e7eb63          	bltu	a5,a4,800045b0 <argfd+0x58>
    8000457e:	ffffd097          	auipc	ra,0xffffd
    80004582:	8ba080e7          	jalr	-1862(ra) # 80000e38 <myproc>
    80004586:	fdc42703          	lw	a4,-36(s0)
    8000458a:	01a70793          	addi	a5,a4,26
    8000458e:	078e                	slli	a5,a5,0x3
    80004590:	953e                	add	a0,a0,a5
    80004592:	611c                	ld	a5,0(a0)
    80004594:	c385                	beqz	a5,800045b4 <argfd+0x5c>
    return -1;
  if (pfd)
    80004596:	00090463          	beqz	s2,8000459e <argfd+0x46>
    *pfd = fd;
    8000459a:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000459e:	4501                	li	a0,0
  if (pf)
    800045a0:	c091                	beqz	s1,800045a4 <argfd+0x4c>
    *pf = f;
    800045a2:	e09c                	sd	a5,0(s1)
}
    800045a4:	70a2                	ld	ra,40(sp)
    800045a6:	7402                	ld	s0,32(sp)
    800045a8:	64e2                	ld	s1,24(sp)
    800045aa:	6942                	ld	s2,16(sp)
    800045ac:	6145                	addi	sp,sp,48
    800045ae:	8082                	ret
    return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	bfcd                	j	800045a4 <argfd+0x4c>
    800045b4:	557d                	li	a0,-1
    800045b6:	b7fd                	j	800045a4 <argfd+0x4c>

00000000800045b8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045b8:	1101                	addi	sp,sp,-32
    800045ba:	ec06                	sd	ra,24(sp)
    800045bc:	e822                	sd	s0,16(sp)
    800045be:	e426                	sd	s1,8(sp)
    800045c0:	1000                	addi	s0,sp,32
    800045c2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045c4:	ffffd097          	auipc	ra,0xffffd
    800045c8:	874080e7          	jalr	-1932(ra) # 80000e38 <myproc>
    800045cc:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800045ce:	0d050793          	addi	a5,a0,208
    800045d2:	4501                	li	a0,0
    800045d4:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800045d6:	6398                	ld	a4,0(a5)
    800045d8:	cb19                	beqz	a4,800045ee <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800045da:	2505                	addiw	a0,a0,1
    800045dc:	07a1                	addi	a5,a5,8
    800045de:	fed51ce3          	bne	a0,a3,800045d6 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045e2:	557d                	li	a0,-1
}
    800045e4:	60e2                	ld	ra,24(sp)
    800045e6:	6442                	ld	s0,16(sp)
    800045e8:	64a2                	ld	s1,8(sp)
    800045ea:	6105                	addi	sp,sp,32
    800045ec:	8082                	ret
      p->ofile[fd] = f;
    800045ee:	01a50793          	addi	a5,a0,26
    800045f2:	078e                	slli	a5,a5,0x3
    800045f4:	963e                	add	a2,a2,a5
    800045f6:	e204                	sd	s1,0(a2)
      return fd;
    800045f8:	b7f5                	j	800045e4 <fdalloc+0x2c>

00000000800045fa <create>:
  return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045fa:	715d                	addi	sp,sp,-80
    800045fc:	e486                	sd	ra,72(sp)
    800045fe:	e0a2                	sd	s0,64(sp)
    80004600:	fc26                	sd	s1,56(sp)
    80004602:	f84a                	sd	s2,48(sp)
    80004604:	f44e                	sd	s3,40(sp)
    80004606:	f052                	sd	s4,32(sp)
    80004608:	ec56                	sd	s5,24(sp)
    8000460a:	e85a                	sd	s6,16(sp)
    8000460c:	0880                	addi	s0,sp,80
    8000460e:	8b2e                	mv	s6,a1
    80004610:	89b2                	mv	s3,a2
    80004612:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004614:	fb040593          	addi	a1,s0,-80
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	dde080e7          	jalr	-546(ra) # 800033f6 <nameiparent>
    80004620:	84aa                	mv	s1,a0
    80004622:	14050f63          	beqz	a0,80004780 <create+0x186>
    return 0;

  ilock(dp);
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	60c080e7          	jalr	1548(ra) # 80002c32 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    8000462e:	4601                	li	a2,0
    80004630:	fb040593          	addi	a1,s0,-80
    80004634:	8526                	mv	a0,s1
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	ae0080e7          	jalr	-1312(ra) # 80003116 <dirlookup>
    8000463e:	8aaa                	mv	s5,a0
    80004640:	c931                	beqz	a0,80004694 <create+0x9a>
  {
    iunlockput(dp);
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	850080e7          	jalr	-1968(ra) # 80002e94 <iunlockput>
    ilock(ip);
    8000464c:	8556                	mv	a0,s5
    8000464e:	ffffe097          	auipc	ra,0xffffe
    80004652:	5e4080e7          	jalr	1508(ra) # 80002c32 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004656:	000b059b          	sext.w	a1,s6
    8000465a:	4789                	li	a5,2
    8000465c:	02f59563          	bne	a1,a5,80004686 <create+0x8c>
    80004660:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd12c4>
    80004664:	37f9                	addiw	a5,a5,-2
    80004666:	17c2                	slli	a5,a5,0x30
    80004668:	93c1                	srli	a5,a5,0x30
    8000466a:	4705                	li	a4,1
    8000466c:	00f76d63          	bltu	a4,a5,80004686 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004670:	8556                	mv	a0,s5
    80004672:	60a6                	ld	ra,72(sp)
    80004674:	6406                	ld	s0,64(sp)
    80004676:	74e2                	ld	s1,56(sp)
    80004678:	7942                	ld	s2,48(sp)
    8000467a:	79a2                	ld	s3,40(sp)
    8000467c:	7a02                	ld	s4,32(sp)
    8000467e:	6ae2                	ld	s5,24(sp)
    80004680:	6b42                	ld	s6,16(sp)
    80004682:	6161                	addi	sp,sp,80
    80004684:	8082                	ret
    iunlockput(ip);
    80004686:	8556                	mv	a0,s5
    80004688:	fffff097          	auipc	ra,0xfffff
    8000468c:	80c080e7          	jalr	-2036(ra) # 80002e94 <iunlockput>
    return 0;
    80004690:	4a81                	li	s5,0
    80004692:	bff9                	j	80004670 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004694:	85da                	mv	a1,s6
    80004696:	4088                	lw	a0,0(s1)
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	3fe080e7          	jalr	1022(ra) # 80002a96 <ialloc>
    800046a0:	8a2a                	mv	s4,a0
    800046a2:	c539                	beqz	a0,800046f0 <create+0xf6>
  ilock(ip);
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	58e080e7          	jalr	1422(ra) # 80002c32 <ilock>
  ip->major = major;
    800046ac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046b0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046b4:	4905                	li	s2,1
    800046b6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046ba:	8552                	mv	a0,s4
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	4ac080e7          	jalr	1196(ra) # 80002b68 <iupdate>
  if (type == T_DIR)
    800046c4:	000b059b          	sext.w	a1,s6
    800046c8:	03258b63          	beq	a1,s2,800046fe <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    800046cc:	004a2603          	lw	a2,4(s4)
    800046d0:	fb040593          	addi	a1,s0,-80
    800046d4:	8526                	mv	a0,s1
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	c50080e7          	jalr	-944(ra) # 80003326 <dirlink>
    800046de:	06054f63          	bltz	a0,8000475c <create+0x162>
  iunlockput(dp);
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	7b0080e7          	jalr	1968(ra) # 80002e94 <iunlockput>
  return ip;
    800046ec:	8ad2                	mv	s5,s4
    800046ee:	b749                	j	80004670 <create+0x76>
    iunlockput(dp);
    800046f0:	8526                	mv	a0,s1
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	7a2080e7          	jalr	1954(ra) # 80002e94 <iunlockput>
    return 0;
    800046fa:	8ad2                	mv	s5,s4
    800046fc:	bf95                	j	80004670 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046fe:	004a2603          	lw	a2,4(s4)
    80004702:	00004597          	auipc	a1,0x4
    80004706:	fb658593          	addi	a1,a1,-74 # 800086b8 <syscalls+0x2b8>
    8000470a:	8552                	mv	a0,s4
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	c1a080e7          	jalr	-998(ra) # 80003326 <dirlink>
    80004714:	04054463          	bltz	a0,8000475c <create+0x162>
    80004718:	40d0                	lw	a2,4(s1)
    8000471a:	00004597          	auipc	a1,0x4
    8000471e:	fa658593          	addi	a1,a1,-90 # 800086c0 <syscalls+0x2c0>
    80004722:	8552                	mv	a0,s4
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	c02080e7          	jalr	-1022(ra) # 80003326 <dirlink>
    8000472c:	02054863          	bltz	a0,8000475c <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    80004730:	004a2603          	lw	a2,4(s4)
    80004734:	fb040593          	addi	a1,s0,-80
    80004738:	8526                	mv	a0,s1
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	bec080e7          	jalr	-1044(ra) # 80003326 <dirlink>
    80004742:	00054d63          	bltz	a0,8000475c <create+0x162>
    dp->nlink++; // for ".."
    80004746:	04a4d783          	lhu	a5,74(s1)
    8000474a:	2785                	addiw	a5,a5,1
    8000474c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004750:	8526                	mv	a0,s1
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	416080e7          	jalr	1046(ra) # 80002b68 <iupdate>
    8000475a:	b761                	j	800046e2 <create+0xe8>
  ip->nlink = 0;
    8000475c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004760:	8552                	mv	a0,s4
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	406080e7          	jalr	1030(ra) # 80002b68 <iupdate>
  iunlockput(ip);
    8000476a:	8552                	mv	a0,s4
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	728080e7          	jalr	1832(ra) # 80002e94 <iunlockput>
  iunlockput(dp);
    80004774:	8526                	mv	a0,s1
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	71e080e7          	jalr	1822(ra) # 80002e94 <iunlockput>
  return 0;
    8000477e:	bdcd                	j	80004670 <create+0x76>
    return 0;
    80004780:	8aaa                	mv	s5,a0
    80004782:	b5fd                	j	80004670 <create+0x76>

0000000080004784 <sys_dup>:
{
    80004784:	7179                	addi	sp,sp,-48
    80004786:	f406                	sd	ra,40(sp)
    80004788:	f022                	sd	s0,32(sp)
    8000478a:	ec26                	sd	s1,24(sp)
    8000478c:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000478e:	fd840613          	addi	a2,s0,-40
    80004792:	4581                	li	a1,0
    80004794:	4501                	li	a0,0
    80004796:	00000097          	auipc	ra,0x0
    8000479a:	dc2080e7          	jalr	-574(ra) # 80004558 <argfd>
    return -1;
    8000479e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    800047a0:	02054363          	bltz	a0,800047c6 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    800047a4:	fd843503          	ld	a0,-40(s0)
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	e10080e7          	jalr	-496(ra) # 800045b8 <fdalloc>
    800047b0:	84aa                	mv	s1,a0
    return -1;
    800047b2:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800047b4:	00054963          	bltz	a0,800047c6 <sys_dup+0x42>
  filedup(f);
    800047b8:	fd843503          	ld	a0,-40(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	2b6080e7          	jalr	694(ra) # 80003a72 <filedup>
  return fd;
    800047c4:	87a6                	mv	a5,s1
}
    800047c6:	853e                	mv	a0,a5
    800047c8:	70a2                	ld	ra,40(sp)
    800047ca:	7402                	ld	s0,32(sp)
    800047cc:	64e2                	ld	s1,24(sp)
    800047ce:	6145                	addi	sp,sp,48
    800047d0:	8082                	ret

00000000800047d2 <sys_read>:
{
    800047d2:	7179                	addi	sp,sp,-48
    800047d4:	f406                	sd	ra,40(sp)
    800047d6:	f022                	sd	s0,32(sp)
    800047d8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047da:	fd840593          	addi	a1,s0,-40
    800047de:	4505                	li	a0,1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	8f6080e7          	jalr	-1802(ra) # 800020d6 <argaddr>
  argint(2, &n);
    800047e8:	fe440593          	addi	a1,s0,-28
    800047ec:	4509                	li	a0,2
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	8c8080e7          	jalr	-1848(ra) # 800020b6 <argint>
  if (argfd(0, 0, &f) < 0)
    800047f6:	fe840613          	addi	a2,s0,-24
    800047fa:	4581                	li	a1,0
    800047fc:	4501                	li	a0,0
    800047fe:	00000097          	auipc	ra,0x0
    80004802:	d5a080e7          	jalr	-678(ra) # 80004558 <argfd>
    80004806:	87aa                	mv	a5,a0
    return -1;
    80004808:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000480a:	0007cc63          	bltz	a5,80004822 <sys_read+0x50>
  return fileread(f, p, n);
    8000480e:	fe442603          	lw	a2,-28(s0)
    80004812:	fd843583          	ld	a1,-40(s0)
    80004816:	fe843503          	ld	a0,-24(s0)
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	43e080e7          	jalr	1086(ra) # 80003c58 <fileread>
}
    80004822:	70a2                	ld	ra,40(sp)
    80004824:	7402                	ld	s0,32(sp)
    80004826:	6145                	addi	sp,sp,48
    80004828:	8082                	ret

000000008000482a <sys_write>:
{
    8000482a:	7179                	addi	sp,sp,-48
    8000482c:	f406                	sd	ra,40(sp)
    8000482e:	f022                	sd	s0,32(sp)
    80004830:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004832:	fd840593          	addi	a1,s0,-40
    80004836:	4505                	li	a0,1
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	89e080e7          	jalr	-1890(ra) # 800020d6 <argaddr>
  argint(2, &n);
    80004840:	fe440593          	addi	a1,s0,-28
    80004844:	4509                	li	a0,2
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	870080e7          	jalr	-1936(ra) # 800020b6 <argint>
  if (argfd(0, 0, &f) < 0)
    8000484e:	fe840613          	addi	a2,s0,-24
    80004852:	4581                	li	a1,0
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	d02080e7          	jalr	-766(ra) # 80004558 <argfd>
    8000485e:	87aa                	mv	a5,a0
    return -1;
    80004860:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004862:	0007cc63          	bltz	a5,8000487a <sys_write+0x50>
  return filewrite(f, p, n);
    80004866:	fe442603          	lw	a2,-28(s0)
    8000486a:	fd843583          	ld	a1,-40(s0)
    8000486e:	fe843503          	ld	a0,-24(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	4a8080e7          	jalr	1192(ra) # 80003d1a <filewrite>
}
    8000487a:	70a2                	ld	ra,40(sp)
    8000487c:	7402                	ld	s0,32(sp)
    8000487e:	6145                	addi	sp,sp,48
    80004880:	8082                	ret

0000000080004882 <sys_close>:
{
    80004882:	1101                	addi	sp,sp,-32
    80004884:	ec06                	sd	ra,24(sp)
    80004886:	e822                	sd	s0,16(sp)
    80004888:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000488a:	fe040613          	addi	a2,s0,-32
    8000488e:	fec40593          	addi	a1,s0,-20
    80004892:	4501                	li	a0,0
    80004894:	00000097          	auipc	ra,0x0
    80004898:	cc4080e7          	jalr	-828(ra) # 80004558 <argfd>
    return -1;
    8000489c:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000489e:	02054463          	bltz	a0,800048c6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	596080e7          	jalr	1430(ra) # 80000e38 <myproc>
    800048aa:	fec42783          	lw	a5,-20(s0)
    800048ae:	07e9                	addi	a5,a5,26
    800048b0:	078e                	slli	a5,a5,0x3
    800048b2:	97aa                	add	a5,a5,a0
    800048b4:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048b8:	fe043503          	ld	a0,-32(s0)
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	208080e7          	jalr	520(ra) # 80003ac4 <fileclose>
  return 0;
    800048c4:	4781                	li	a5,0
}
    800048c6:	853e                	mv	a0,a5
    800048c8:	60e2                	ld	ra,24(sp)
    800048ca:	6442                	ld	s0,16(sp)
    800048cc:	6105                	addi	sp,sp,32
    800048ce:	8082                	ret

00000000800048d0 <sys_fstat>:
{
    800048d0:	1101                	addi	sp,sp,-32
    800048d2:	ec06                	sd	ra,24(sp)
    800048d4:	e822                	sd	s0,16(sp)
    800048d6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048d8:	fe040593          	addi	a1,s0,-32
    800048dc:	4505                	li	a0,1
    800048de:	ffffd097          	auipc	ra,0xffffd
    800048e2:	7f8080e7          	jalr	2040(ra) # 800020d6 <argaddr>
  if (argfd(0, 0, &f) < 0)
    800048e6:	fe840613          	addi	a2,s0,-24
    800048ea:	4581                	li	a1,0
    800048ec:	4501                	li	a0,0
    800048ee:	00000097          	auipc	ra,0x0
    800048f2:	c6a080e7          	jalr	-918(ra) # 80004558 <argfd>
    800048f6:	87aa                	mv	a5,a0
    return -1;
    800048f8:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800048fa:	0007ca63          	bltz	a5,8000490e <sys_fstat+0x3e>
  return filestat(f, st);
    800048fe:	fe043583          	ld	a1,-32(s0)
    80004902:	fe843503          	ld	a0,-24(s0)
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	286080e7          	jalr	646(ra) # 80003b8c <filestat>
}
    8000490e:	60e2                	ld	ra,24(sp)
    80004910:	6442                	ld	s0,16(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret

0000000080004916 <sys_link>:
{
    80004916:	7169                	addi	sp,sp,-304
    80004918:	f606                	sd	ra,296(sp)
    8000491a:	f222                	sd	s0,288(sp)
    8000491c:	ee26                	sd	s1,280(sp)
    8000491e:	ea4a                	sd	s2,272(sp)
    80004920:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004922:	08000613          	li	a2,128
    80004926:	ed040593          	addi	a1,s0,-304
    8000492a:	4501                	li	a0,0
    8000492c:	ffffd097          	auipc	ra,0xffffd
    80004930:	7ca080e7          	jalr	1994(ra) # 800020f6 <argstr>
    return -1;
    80004934:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004936:	10054e63          	bltz	a0,80004a52 <sys_link+0x13c>
    8000493a:	08000613          	li	a2,128
    8000493e:	f5040593          	addi	a1,s0,-176
    80004942:	4505                	li	a0,1
    80004944:	ffffd097          	auipc	ra,0xffffd
    80004948:	7b2080e7          	jalr	1970(ra) # 800020f6 <argstr>
    return -1;
    8000494c:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494e:	10054263          	bltz	a0,80004a52 <sys_link+0x13c>
  begin_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	ca6080e7          	jalr	-858(ra) # 800035f8 <begin_op>
  if ((ip = namei(old)) == 0)
    8000495a:	ed040513          	addi	a0,s0,-304
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	a7a080e7          	jalr	-1414(ra) # 800033d8 <namei>
    80004966:	84aa                	mv	s1,a0
    80004968:	c551                	beqz	a0,800049f4 <sys_link+0xde>
  ilock(ip);
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	2c8080e7          	jalr	712(ra) # 80002c32 <ilock>
  if (ip->type == T_DIR)
    80004972:	04449703          	lh	a4,68(s1)
    80004976:	4785                	li	a5,1
    80004978:	08f70463          	beq	a4,a5,80004a00 <sys_link+0xea>
  ip->nlink++;
    8000497c:	04a4d783          	lhu	a5,74(s1)
    80004980:	2785                	addiw	a5,a5,1
    80004982:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004986:	8526                	mv	a0,s1
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	1e0080e7          	jalr	480(ra) # 80002b68 <iupdate>
  iunlock(ip);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	362080e7          	jalr	866(ra) # 80002cf4 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000499a:	fd040593          	addi	a1,s0,-48
    8000499e:	f5040513          	addi	a0,s0,-176
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	a54080e7          	jalr	-1452(ra) # 800033f6 <nameiparent>
    800049aa:	892a                	mv	s2,a0
    800049ac:	c935                	beqz	a0,80004a20 <sys_link+0x10a>
  ilock(dp);
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	284080e7          	jalr	644(ra) # 80002c32 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800049b6:	00092703          	lw	a4,0(s2)
    800049ba:	409c                	lw	a5,0(s1)
    800049bc:	04f71d63          	bne	a4,a5,80004a16 <sys_link+0x100>
    800049c0:	40d0                	lw	a2,4(s1)
    800049c2:	fd040593          	addi	a1,s0,-48
    800049c6:	854a                	mv	a0,s2
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	95e080e7          	jalr	-1698(ra) # 80003326 <dirlink>
    800049d0:	04054363          	bltz	a0,80004a16 <sys_link+0x100>
  iunlockput(dp);
    800049d4:	854a                	mv	a0,s2
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	4be080e7          	jalr	1214(ra) # 80002e94 <iunlockput>
  iput(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	40c080e7          	jalr	1036(ra) # 80002dec <iput>
  end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	c90080e7          	jalr	-880(ra) # 80003678 <end_op>
  return 0;
    800049f0:	4781                	li	a5,0
    800049f2:	a085                	j	80004a52 <sys_link+0x13c>
    end_op();
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	c84080e7          	jalr	-892(ra) # 80003678 <end_op>
    return -1;
    800049fc:	57fd                	li	a5,-1
    800049fe:	a891                	j	80004a52 <sys_link+0x13c>
    iunlockput(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	492080e7          	jalr	1170(ra) # 80002e94 <iunlockput>
    end_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	c6e080e7          	jalr	-914(ra) # 80003678 <end_op>
    return -1;
    80004a12:	57fd                	li	a5,-1
    80004a14:	a83d                	j	80004a52 <sys_link+0x13c>
    iunlockput(dp);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	47c080e7          	jalr	1148(ra) # 80002e94 <iunlockput>
  ilock(ip);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	210080e7          	jalr	528(ra) # 80002c32 <ilock>
  ip->nlink--;
    80004a2a:	04a4d783          	lhu	a5,74(s1)
    80004a2e:	37fd                	addiw	a5,a5,-1
    80004a30:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	132080e7          	jalr	306(ra) # 80002b68 <iupdate>
  iunlockput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	454080e7          	jalr	1108(ra) # 80002e94 <iunlockput>
  end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	c30080e7          	jalr	-976(ra) # 80003678 <end_op>
  return -1;
    80004a50:	57fd                	li	a5,-1
}
    80004a52:	853e                	mv	a0,a5
    80004a54:	70b2                	ld	ra,296(sp)
    80004a56:	7412                	ld	s0,288(sp)
    80004a58:	64f2                	ld	s1,280(sp)
    80004a5a:	6952                	ld	s2,272(sp)
    80004a5c:	6155                	addi	sp,sp,304
    80004a5e:	8082                	ret

0000000080004a60 <sys_unlink>:
{
    80004a60:	7151                	addi	sp,sp,-240
    80004a62:	f586                	sd	ra,232(sp)
    80004a64:	f1a2                	sd	s0,224(sp)
    80004a66:	eda6                	sd	s1,216(sp)
    80004a68:	e9ca                	sd	s2,208(sp)
    80004a6a:	e5ce                	sd	s3,200(sp)
    80004a6c:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004a6e:	08000613          	li	a2,128
    80004a72:	f3040593          	addi	a1,s0,-208
    80004a76:	4501                	li	a0,0
    80004a78:	ffffd097          	auipc	ra,0xffffd
    80004a7c:	67e080e7          	jalr	1662(ra) # 800020f6 <argstr>
    80004a80:	18054163          	bltz	a0,80004c02 <sys_unlink+0x1a2>
  begin_op();
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	b74080e7          	jalr	-1164(ra) # 800035f8 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004a8c:	fb040593          	addi	a1,s0,-80
    80004a90:	f3040513          	addi	a0,s0,-208
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	962080e7          	jalr	-1694(ra) # 800033f6 <nameiparent>
    80004a9c:	84aa                	mv	s1,a0
    80004a9e:	c979                	beqz	a0,80004b74 <sys_unlink+0x114>
  ilock(dp);
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	192080e7          	jalr	402(ra) # 80002c32 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004aa8:	00004597          	auipc	a1,0x4
    80004aac:	c1058593          	addi	a1,a1,-1008 # 800086b8 <syscalls+0x2b8>
    80004ab0:	fb040513          	addi	a0,s0,-80
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	648080e7          	jalr	1608(ra) # 800030fc <namecmp>
    80004abc:	14050a63          	beqz	a0,80004c10 <sys_unlink+0x1b0>
    80004ac0:	00004597          	auipc	a1,0x4
    80004ac4:	c0058593          	addi	a1,a1,-1024 # 800086c0 <syscalls+0x2c0>
    80004ac8:	fb040513          	addi	a0,s0,-80
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	630080e7          	jalr	1584(ra) # 800030fc <namecmp>
    80004ad4:	12050e63          	beqz	a0,80004c10 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004ad8:	f2c40613          	addi	a2,s0,-212
    80004adc:	fb040593          	addi	a1,s0,-80
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	634080e7          	jalr	1588(ra) # 80003116 <dirlookup>
    80004aea:	892a                	mv	s2,a0
    80004aec:	12050263          	beqz	a0,80004c10 <sys_unlink+0x1b0>
  ilock(ip);
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	142080e7          	jalr	322(ra) # 80002c32 <ilock>
  if (ip->nlink < 1)
    80004af8:	04a91783          	lh	a5,74(s2)
    80004afc:	08f05263          	blez	a5,80004b80 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004b00:	04491703          	lh	a4,68(s2)
    80004b04:	4785                	li	a5,1
    80004b06:	08f70563          	beq	a4,a5,80004b90 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b0a:	4641                	li	a2,16
    80004b0c:	4581                	li	a1,0
    80004b0e:	fc040513          	addi	a0,s0,-64
    80004b12:	ffffb097          	auipc	ra,0xffffb
    80004b16:	666080e7          	jalr	1638(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b1a:	4741                	li	a4,16
    80004b1c:	f2c42683          	lw	a3,-212(s0)
    80004b20:	fc040613          	addi	a2,s0,-64
    80004b24:	4581                	li	a1,0
    80004b26:	8526                	mv	a0,s1
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	4b6080e7          	jalr	1206(ra) # 80002fde <writei>
    80004b30:	47c1                	li	a5,16
    80004b32:	0af51563          	bne	a0,a5,80004bdc <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004b36:	04491703          	lh	a4,68(s2)
    80004b3a:	4785                	li	a5,1
    80004b3c:	0af70863          	beq	a4,a5,80004bec <sys_unlink+0x18c>
  iunlockput(dp);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	352080e7          	jalr	850(ra) # 80002e94 <iunlockput>
  ip->nlink--;
    80004b4a:	04a95783          	lhu	a5,74(s2)
    80004b4e:	37fd                	addiw	a5,a5,-1
    80004b50:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	012080e7          	jalr	18(ra) # 80002b68 <iupdate>
  iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	334080e7          	jalr	820(ra) # 80002e94 <iunlockput>
  end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	b10080e7          	jalr	-1264(ra) # 80003678 <end_op>
  return 0;
    80004b70:	4501                	li	a0,0
    80004b72:	a84d                	j	80004c24 <sys_unlink+0x1c4>
    end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	b04080e7          	jalr	-1276(ra) # 80003678 <end_op>
    return -1;
    80004b7c:	557d                	li	a0,-1
    80004b7e:	a05d                	j	80004c24 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b80:	00004517          	auipc	a0,0x4
    80004b84:	b4850513          	addi	a0,a0,-1208 # 800086c8 <syscalls+0x2c8>
    80004b88:	00001097          	auipc	ra,0x1
    80004b8c:	476080e7          	jalr	1142(ra) # 80005ffe <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b90:	04c92703          	lw	a4,76(s2)
    80004b94:	02000793          	li	a5,32
    80004b98:	f6e7f9e3          	bgeu	a5,a4,80004b0a <sys_unlink+0xaa>
    80004b9c:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	86ce                	mv	a3,s3
    80004ba4:	f1840613          	addi	a2,s0,-232
    80004ba8:	4581                	li	a1,0
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	33a080e7          	jalr	826(ra) # 80002ee6 <readi>
    80004bb4:	47c1                	li	a5,16
    80004bb6:	00f51b63          	bne	a0,a5,80004bcc <sys_unlink+0x16c>
    if (de.inum != 0)
    80004bba:	f1845783          	lhu	a5,-232(s0)
    80004bbe:	e7a1                	bnez	a5,80004c06 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004bc0:	29c1                	addiw	s3,s3,16
    80004bc2:	04c92783          	lw	a5,76(s2)
    80004bc6:	fcf9ede3          	bltu	s3,a5,80004ba0 <sys_unlink+0x140>
    80004bca:	b781                	j	80004b0a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	b1450513          	addi	a0,a0,-1260 # 800086e0 <syscalls+0x2e0>
    80004bd4:	00001097          	auipc	ra,0x1
    80004bd8:	42a080e7          	jalr	1066(ra) # 80005ffe <panic>
    panic("unlink: writei");
    80004bdc:	00004517          	auipc	a0,0x4
    80004be0:	b1c50513          	addi	a0,a0,-1252 # 800086f8 <syscalls+0x2f8>
    80004be4:	00001097          	auipc	ra,0x1
    80004be8:	41a080e7          	jalr	1050(ra) # 80005ffe <panic>
    dp->nlink--;
    80004bec:	04a4d783          	lhu	a5,74(s1)
    80004bf0:	37fd                	addiw	a5,a5,-1
    80004bf2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	f70080e7          	jalr	-144(ra) # 80002b68 <iupdate>
    80004c00:	b781                	j	80004b40 <sys_unlink+0xe0>
    return -1;
    80004c02:	557d                	li	a0,-1
    80004c04:	a005                	j	80004c24 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	28c080e7          	jalr	652(ra) # 80002e94 <iunlockput>
  iunlockput(dp);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	282080e7          	jalr	642(ra) # 80002e94 <iunlockput>
  end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	a5e080e7          	jalr	-1442(ra) # 80003678 <end_op>
  return -1;
    80004c22:	557d                	li	a0,-1
}
    80004c24:	70ae                	ld	ra,232(sp)
    80004c26:	740e                	ld	s0,224(sp)
    80004c28:	64ee                	ld	s1,216(sp)
    80004c2a:	694e                	ld	s2,208(sp)
    80004c2c:	69ae                	ld	s3,200(sp)
    80004c2e:	616d                	addi	sp,sp,240
    80004c30:	8082                	ret

0000000080004c32 <sys_mmap>:
{
    80004c32:	715d                	addi	sp,sp,-80
    80004c34:	e486                	sd	ra,72(sp)
    80004c36:	e0a2                	sd	s0,64(sp)
    80004c38:	fc26                	sd	s1,56(sp)
    80004c3a:	f84a                	sd	s2,48(sp)
    80004c3c:	f44e                	sd	s3,40(sp)
    80004c3e:	f052                	sd	s4,32(sp)
    80004c40:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004c42:	ffffc097          	auipc	ra,0xffffc
    80004c46:	1f6080e7          	jalr	502(ra) # 80000e38 <myproc>
    80004c4a:	892a                	mv	s2,a0
  argint(1, &length);
    80004c4c:	fcc40593          	addi	a1,s0,-52
    80004c50:	4505                	li	a0,1
    80004c52:	ffffd097          	auipc	ra,0xffffd
    80004c56:	464080e7          	jalr	1124(ra) # 800020b6 <argint>
  argint(2, &prot);
    80004c5a:	fc840593          	addi	a1,s0,-56
    80004c5e:	4509                	li	a0,2
    80004c60:	ffffd097          	auipc	ra,0xffffd
    80004c64:	456080e7          	jalr	1110(ra) # 800020b6 <argint>
  argint(3, &flags);
    80004c68:	fc440593          	addi	a1,s0,-60
    80004c6c:	450d                	li	a0,3
    80004c6e:	ffffd097          	auipc	ra,0xffffd
    80004c72:	448080e7          	jalr	1096(ra) # 800020b6 <argint>
  argfd(4, &fd, &mfile);
    80004c76:	fb040613          	addi	a2,s0,-80
    80004c7a:	fc040593          	addi	a1,s0,-64
    80004c7e:	4511                	li	a0,4
    80004c80:	00000097          	auipc	ra,0x0
    80004c84:	8d8080e7          	jalr	-1832(ra) # 80004558 <argfd>
  argint(5, &offset);
    80004c88:	fbc40593          	addi	a1,s0,-68
    80004c8c:	4515                	li	a0,5
    80004c8e:	ffffd097          	auipc	ra,0xffffd
    80004c92:	428080e7          	jalr	1064(ra) # 800020b6 <argint>
  if (length < 0 || prot < 0 || flags < 0 || fd < 0 || offset < 0)
    80004c96:	fcc42603          	lw	a2,-52(s0)
    80004c9a:	0c064363          	bltz	a2,80004d60 <sys_mmap+0x12e>
    80004c9e:	fc842583          	lw	a1,-56(s0)
    80004ca2:	0c05c163          	bltz	a1,80004d64 <sys_mmap+0x132>
    80004ca6:	fc442803          	lw	a6,-60(s0)
    80004caa:	0a084f63          	bltz	a6,80004d68 <sys_mmap+0x136>
    80004cae:	fc042883          	lw	a7,-64(s0)
    80004cb2:	0a08cd63          	bltz	a7,80004d6c <sys_mmap+0x13a>
    80004cb6:	fbc42303          	lw	t1,-68(s0)
    80004cba:	0a034b63          	bltz	t1,80004d70 <sys_mmap+0x13e>
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004cbe:	fb043e03          	ld	t3,-80(s0)
    80004cc2:	009e4783          	lbu	a5,9(t3)
    80004cc6:	e781                	bnez	a5,80004cce <sys_mmap+0x9c>
    80004cc8:	0025f793          	andi	a5,a1,2
    80004ccc:	e78d                	bnez	a5,80004cf6 <sys_mmap+0xc4>
  while (idx < VMASIZE)
    80004cce:	17090793          	addi	a5,s2,368
{
    80004cd2:	4481                	li	s1,0
  while (idx < VMASIZE)
    80004cd4:	46c1                	li	a3,16
    if (p->vma[idx].length == 0) // free vma
    80004cd6:	4398                	lw	a4,0(a5)
    80004cd8:	c705                	beqz	a4,80004d00 <sys_mmap+0xce>
    idx++;
    80004cda:	2485                	addiw	s1,s1,1
  while (idx < VMASIZE)
    80004cdc:	03078793          	addi	a5,a5,48
    80004ce0:	fed49be3          	bne	s1,a3,80004cd6 <sys_mmap+0xa4>
  return -1;
    80004ce4:	557d                	li	a0,-1
}
    80004ce6:	60a6                	ld	ra,72(sp)
    80004ce8:	6406                	ld	s0,64(sp)
    80004cea:	74e2                	ld	s1,56(sp)
    80004cec:	7942                	ld	s2,48(sp)
    80004cee:	79a2                	ld	s3,40(sp)
    80004cf0:	7a02                	ld	s4,32(sp)
    80004cf2:	6161                	addi	sp,sp,80
    80004cf4:	8082                	ret
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004cf6:	00187793          	andi	a5,a6,1
    return -1;
    80004cfa:	557d                	li	a0,-1
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004cfc:	dbe9                	beqz	a5,80004cce <sys_mmap+0x9c>
    80004cfe:	b7e5                	j	80004ce6 <sys_mmap+0xb4>
      p->vma[idx].addr = p->sz;
    80004d00:	00149a13          	slli	s4,s1,0x1
    80004d04:	009a09b3          	add	s3,s4,s1
    80004d08:	0992                	slli	s3,s3,0x4
    80004d0a:	99ca                	add	s3,s3,s2
    80004d0c:	04893783          	ld	a5,72(s2)
    80004d10:	16f9b423          	sd	a5,360(s3)
      p->vma[idx].length = length;
    80004d14:	16c9a823          	sw	a2,368(s3)
      p->vma[idx].prot = prot;
    80004d18:	16b9aa23          	sw	a1,372(s3)
      p->vma[idx].flags = flags;
    80004d1c:	1709ac23          	sw	a6,376(s3)
      p->vma[idx].fd = fd;
    80004d20:	1719ae23          	sw	a7,380(s3)
      p->vma[idx].offset = offset;
    80004d24:	1869a023          	sw	t1,384(s3)
      p->vma[idx].mfile = filedup(mfile); // increment the reference count
    80004d28:	8572                	mv	a0,t3
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	d48080e7          	jalr	-696(ra) # 80003a72 <filedup>
    80004d32:	18a9b423          	sd	a0,392(s3)
      p->vma[idx].ip = mfile->ip;
    80004d36:	fb043783          	ld	a5,-80(s0)
    80004d3a:	6f9c                	ld	a5,24(a5)
    80004d3c:	18f9b823          	sd	a5,400(s3)
      p->sz += PGROUNDUP(length);
    80004d40:	fcc42783          	lw	a5,-52(s0)
    80004d44:	6705                	lui	a4,0x1
    80004d46:	377d                	addiw	a4,a4,-1
    80004d48:	9fb9                	addw	a5,a5,a4
    80004d4a:	777d                	lui	a4,0xfffff
    80004d4c:	8ff9                	and	a5,a5,a4
    80004d4e:	2781                	sext.w	a5,a5
    80004d50:	04893703          	ld	a4,72(s2)
    80004d54:	97ba                	add	a5,a5,a4
    80004d56:	04f93423          	sd	a5,72(s2)
      return (uint64)p->vma[idx].addr;
    80004d5a:	1689b503          	ld	a0,360(s3)
    80004d5e:	b761                	j	80004ce6 <sys_mmap+0xb4>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b751                	j	80004ce6 <sys_mmap+0xb4>
    80004d64:	557d                	li	a0,-1
    80004d66:	b741                	j	80004ce6 <sys_mmap+0xb4>
    80004d68:	557d                	li	a0,-1
    80004d6a:	bfb5                	j	80004ce6 <sys_mmap+0xb4>
    80004d6c:	557d                	li	a0,-1
    80004d6e:	bfa5                	j	80004ce6 <sys_mmap+0xb4>
    80004d70:	557d                	li	a0,-1
    80004d72:	bf95                	j	80004ce6 <sys_mmap+0xb4>

0000000080004d74 <sys_munmap>:
{
    80004d74:	715d                	addi	sp,sp,-80
    80004d76:	e486                	sd	ra,72(sp)
    80004d78:	e0a2                	sd	s0,64(sp)
    80004d7a:	fc26                	sd	s1,56(sp)
    80004d7c:	f84a                	sd	s2,48(sp)
    80004d7e:	f44e                	sd	s3,40(sp)
    80004d80:	f052                	sd	s4,32(sp)
    80004d82:	ec56                	sd	s5,24(sp)
    80004d84:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004d86:	ffffc097          	auipc	ra,0xffffc
    80004d8a:	0b2080e7          	jalr	178(ra) # 80000e38 <myproc>
    80004d8e:	892a                	mv	s2,a0
  argaddr(0, &va);
    80004d90:	fb840593          	addi	a1,s0,-72
    80004d94:	4501                	li	a0,0
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	340080e7          	jalr	832(ra) # 800020d6 <argaddr>
  argint(1, &length);
    80004d9e:	fb440593          	addi	a1,s0,-76
    80004da2:	4505                	li	a0,1
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	312080e7          	jalr	786(ra) # 800020b6 <argint>
  if (va < 0 || length < 0)
    80004dac:	fb442783          	lw	a5,-76(s0)
    80004db0:	1407c463          	bltz	a5,80004ef8 <sys_munmap+0x184>
    if (va >= p->vma[i].addr && va < p->vma[i].addr + p->sz && p->vma[i].length != 0)
    80004db4:	fb843683          	ld	a3,-72(s0)
    80004db8:	16890793          	addi	a5,s2,360
  for (int i = 0; i < VMASIZE; i++)
    80004dbc:	4481                	li	s1,0
    80004dbe:	45c1                	li	a1,16
    80004dc0:	a031                	j	80004dcc <sys_munmap+0x58>
    80004dc2:	2485                	addiw	s1,s1,1
    80004dc4:	03078793          	addi	a5,a5,48
    80004dc8:	00b48d63          	beq	s1,a1,80004de2 <sys_munmap+0x6e>
    if (va >= p->vma[i].addr && va < p->vma[i].addr + p->sz && p->vma[i].length != 0)
    80004dcc:	6398                	ld	a4,0(a5)
    80004dce:	fee6eae3          	bltu	a3,a4,80004dc2 <sys_munmap+0x4e>
    80004dd2:	04893503          	ld	a0,72(s2)
    80004dd6:	972a                	add	a4,a4,a0
    80004dd8:	fee6f5e3          	bgeu	a3,a4,80004dc2 <sys_munmap+0x4e>
    80004ddc:	4798                	lw	a4,8(a5)
    80004dde:	d375                	beqz	a4,80004dc2 <sys_munmap+0x4e>
    80004de0:	a011                	j	80004de4 <sys_munmap+0x70>
  int idx = 0;
    80004de2:	4481                	li	s1,0
  struct vma v = p->vma[idx];
    80004de4:	00149793          	slli	a5,s1,0x1
    80004de8:	97a6                	add	a5,a5,s1
    80004dea:	0792                	slli	a5,a5,0x4
    80004dec:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004dee:	1747a783          	lw	a5,372(a5)
    80004df2:	8b89                	andi	a5,a5,2
    80004df4:	cb91                	beqz	a5,80004e08 <sys_munmap+0x94>
  struct vma v = p->vma[idx];
    80004df6:	00149793          	slli	a5,s1,0x1
    80004dfa:	97a6                	add	a5,a5,s1
    80004dfc:	0792                	slli	a5,a5,0x4
    80004dfe:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004e00:	1787a783          	lw	a5,376(a5)
    80004e04:	8b85                	andi	a5,a5,1
    80004e06:	ebad                	bnez	a5,80004e78 <sys_munmap+0x104>
  uint64 npages = PGROUNDUP(length) / PGSIZE;
    80004e08:	fb442603          	lw	a2,-76(s0)
    80004e0c:	6785                	lui	a5,0x1
    80004e0e:	37fd                	addiw	a5,a5,-1
    80004e10:	9e3d                	addw	a2,a2,a5
  uvmunmap(p->pagetable, va, npages, 1);
    80004e12:	4685                	li	a3,1
    80004e14:	40c6561b          	sraiw	a2,a2,0xc
    80004e18:	fb843583          	ld	a1,-72(s0)
    80004e1c:	05093503          	ld	a0,80(s2)
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	8ea080e7          	jalr	-1814(ra) # 8000070a <uvmunmap>
  v.length -= length;
    80004e28:	fb442683          	lw	a3,-76(s0)
  va += length;
    80004e2c:	fb843783          	ld	a5,-72(s0)
    80004e30:	97b6                	add	a5,a5,a3
    80004e32:	faf43c23          	sd	a5,-72(s0)
  p->vma[idx].addr += length;
    80004e36:	00149793          	slli	a5,s1,0x1
    80004e3a:	97a6                	add	a5,a5,s1
    80004e3c:	0792                	slli	a5,a5,0x4
    80004e3e:	97ca                	add	a5,a5,s2
    80004e40:	1687b703          	ld	a4,360(a5) # 1168 <_entry-0x7fffee98>
    80004e44:	9736                	add	a4,a4,a3
    80004e46:	16e7b423          	sd	a4,360(a5)
  p->vma[idx].offset += length;
    80004e4a:	1807a703          	lw	a4,384(a5)
    80004e4e:	9f35                	addw	a4,a4,a3
    80004e50:	18e7a023          	sw	a4,384(a5)
  p->vma[idx].length -= length;
    80004e54:	1707a703          	lw	a4,368(a5)
    80004e58:	9f15                	subw	a4,a4,a3
    80004e5a:	0007069b          	sext.w	a3,a4
    80004e5e:	16e7a823          	sw	a4,368(a5)
  return 0;
    80004e62:	4501                	li	a0,0
  if (p->vma[idx].length == 0)
    80004e64:	cead                	beqz	a3,80004ede <sys_munmap+0x16a>
}
    80004e66:	60a6                	ld	ra,72(sp)
    80004e68:	6406                	ld	s0,64(sp)
    80004e6a:	74e2                	ld	s1,56(sp)
    80004e6c:	7942                	ld	s2,48(sp)
    80004e6e:	79a2                	ld	s3,40(sp)
    80004e70:	7a02                	ld	s4,32(sp)
    80004e72:	6ae2                	ld	s5,24(sp)
    80004e74:	6161                	addi	sp,sp,80
    80004e76:	8082                	ret
  struct vma v = p->vma[idx];
    80004e78:	00149793          	slli	a5,s1,0x1
    80004e7c:	97a6                	add	a5,a5,s1
    80004e7e:	0792                	slli	a5,a5,0x4
    80004e80:	97ca                	add	a5,a5,s2
    80004e82:	1687ba03          	ld	s4,360(a5)
    80004e86:	1807aa83          	lw	s5,384(a5)
    80004e8a:	1907b983          	ld	s3,400(a5)
    begin_op();
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	76a080e7          	jalr	1898(ra) # 800035f8 <begin_op>
    ilock(v.ip);
    80004e96:	854e                	mv	a0,s3
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	d9a080e7          	jalr	-614(ra) # 80002c32 <ilock>
    writei(v.ip, 1, v.addr, va - v.addr + v.offset, PGROUNDUP(length)); // fix
    80004ea0:	fb442703          	lw	a4,-76(s0)
    80004ea4:	6785                	lui	a5,0x1
    80004ea6:	37fd                	addiw	a5,a5,-1
    80004ea8:	9f3d                	addw	a4,a4,a5
    80004eaa:	77fd                	lui	a5,0xfffff
    80004eac:	8f7d                	and	a4,a4,a5
    80004eae:	fb843683          	ld	a3,-72(s0)
    80004eb2:	015686bb          	addw	a3,a3,s5
    80004eb6:	2701                	sext.w	a4,a4
    80004eb8:	414686bb          	subw	a3,a3,s4
    80004ebc:	8652                	mv	a2,s4
    80004ebe:	4585                	li	a1,1
    80004ec0:	854e                	mv	a0,s3
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	11c080e7          	jalr	284(ra) # 80002fde <writei>
    iunlock(v.ip);
    80004eca:	854e                	mv	a0,s3
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	e28080e7          	jalr	-472(ra) # 80002cf4 <iunlock>
    end_op();
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	7a4080e7          	jalr	1956(ra) # 80003678 <end_op>
    80004edc:	b735                	j	80004e08 <sys_munmap+0x94>
    fileclose(p->vma[idx].mfile);
    80004ede:	00149793          	slli	a5,s1,0x1
    80004ee2:	94be                	add	s1,s1,a5
    80004ee4:	0492                	slli	s1,s1,0x4
    80004ee6:	9926                	add	s2,s2,s1
    80004ee8:	18893503          	ld	a0,392(s2)
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	bd8080e7          	jalr	-1064(ra) # 80003ac4 <fileclose>
  return 0;
    80004ef4:	4501                	li	a0,0
    80004ef6:	bf85                	j	80004e66 <sys_munmap+0xf2>
    return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	b7b5                	j	80004e66 <sys_munmap+0xf2>

0000000080004efc <sys_open>:

uint64
sys_open(void)
{
    80004efc:	7131                	addi	sp,sp,-192
    80004efe:	fd06                	sd	ra,184(sp)
    80004f00:	f922                	sd	s0,176(sp)
    80004f02:	f526                	sd	s1,168(sp)
    80004f04:	f14a                	sd	s2,160(sp)
    80004f06:	ed4e                	sd	s3,152(sp)
    80004f08:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f0a:	f4c40593          	addi	a1,s0,-180
    80004f0e:	4505                	li	a0,1
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	1a6080e7          	jalr	422(ra) # 800020b6 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f18:	08000613          	li	a2,128
    80004f1c:	f5040593          	addi	a1,s0,-176
    80004f20:	4501                	li	a0,0
    80004f22:	ffffd097          	auipc	ra,0xffffd
    80004f26:	1d4080e7          	jalr	468(ra) # 800020f6 <argstr>
    80004f2a:	87aa                	mv	a5,a0
    return -1;
    80004f2c:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f2e:	0a07c963          	bltz	a5,80004fe0 <sys_open+0xe4>

  begin_op();
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	6c6080e7          	jalr	1734(ra) # 800035f8 <begin_op>

  if (omode & O_CREATE)
    80004f3a:	f4c42783          	lw	a5,-180(s0)
    80004f3e:	2007f793          	andi	a5,a5,512
    80004f42:	cfc5                	beqz	a5,80004ffa <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004f44:	4681                	li	a3,0
    80004f46:	4601                	li	a2,0
    80004f48:	4589                	li	a1,2
    80004f4a:	f5040513          	addi	a0,s0,-176
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	6ac080e7          	jalr	1708(ra) # 800045fa <create>
    80004f56:	84aa                	mv	s1,a0
    if (ip == 0)
    80004f58:	c959                	beqz	a0,80004fee <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004f5a:	04449703          	lh	a4,68(s1)
    80004f5e:	478d                	li	a5,3
    80004f60:	00f71763          	bne	a4,a5,80004f6e <sys_open+0x72>
    80004f64:	0464d703          	lhu	a4,70(s1)
    80004f68:	47a5                	li	a5,9
    80004f6a:	0ce7ed63          	bltu	a5,a4,80005044 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f6e:	fffff097          	auipc	ra,0xfffff
    80004f72:	a9a080e7          	jalr	-1382(ra) # 80003a08 <filealloc>
    80004f76:	89aa                	mv	s3,a0
    80004f78:	10050363          	beqz	a0,8000507e <sys_open+0x182>
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	63c080e7          	jalr	1596(ra) # 800045b8 <fdalloc>
    80004f84:	892a                	mv	s2,a0
    80004f86:	0e054763          	bltz	a0,80005074 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004f8a:	04449703          	lh	a4,68(s1)
    80004f8e:	478d                	li	a5,3
    80004f90:	0cf70563          	beq	a4,a5,8000505a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004f94:	4789                	li	a5,2
    80004f96:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f9a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f9e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004fa2:	f4c42783          	lw	a5,-180(s0)
    80004fa6:	0017c713          	xori	a4,a5,1
    80004faa:	8b05                	andi	a4,a4,1
    80004fac:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fb0:	0037f713          	andi	a4,a5,3
    80004fb4:	00e03733          	snez	a4,a4
    80004fb8:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004fbc:	4007f793          	andi	a5,a5,1024
    80004fc0:	c791                	beqz	a5,80004fcc <sys_open+0xd0>
    80004fc2:	04449703          	lh	a4,68(s1)
    80004fc6:	4789                	li	a5,2
    80004fc8:	0af70063          	beq	a4,a5,80005068 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	d26080e7          	jalr	-730(ra) # 80002cf4 <iunlock>
  end_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	6a2080e7          	jalr	1698(ra) # 80003678 <end_op>

  return fd;
    80004fde:	854a                	mv	a0,s2
}
    80004fe0:	70ea                	ld	ra,184(sp)
    80004fe2:	744a                	ld	s0,176(sp)
    80004fe4:	74aa                	ld	s1,168(sp)
    80004fe6:	790a                	ld	s2,160(sp)
    80004fe8:	69ea                	ld	s3,152(sp)
    80004fea:	6129                	addi	sp,sp,192
    80004fec:	8082                	ret
      end_op();
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	68a080e7          	jalr	1674(ra) # 80003678 <end_op>
      return -1;
    80004ff6:	557d                	li	a0,-1
    80004ff8:	b7e5                	j	80004fe0 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004ffa:	f5040513          	addi	a0,s0,-176
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	3da080e7          	jalr	986(ra) # 800033d8 <namei>
    80005006:	84aa                	mv	s1,a0
    80005008:	c905                	beqz	a0,80005038 <sys_open+0x13c>
    ilock(ip);
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	c28080e7          	jalr	-984(ra) # 80002c32 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80005012:	04449703          	lh	a4,68(s1)
    80005016:	4785                	li	a5,1
    80005018:	f4f711e3          	bne	a4,a5,80004f5a <sys_open+0x5e>
    8000501c:	f4c42783          	lw	a5,-180(s0)
    80005020:	d7b9                	beqz	a5,80004f6e <sys_open+0x72>
      iunlockput(ip);
    80005022:	8526                	mv	a0,s1
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	e70080e7          	jalr	-400(ra) # 80002e94 <iunlockput>
      end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	64c080e7          	jalr	1612(ra) # 80003678 <end_op>
      return -1;
    80005034:	557d                	li	a0,-1
    80005036:	b76d                	j	80004fe0 <sys_open+0xe4>
      end_op();
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	640080e7          	jalr	1600(ra) # 80003678 <end_op>
      return -1;
    80005040:	557d                	li	a0,-1
    80005042:	bf79                	j	80004fe0 <sys_open+0xe4>
    iunlockput(ip);
    80005044:	8526                	mv	a0,s1
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	e4e080e7          	jalr	-434(ra) # 80002e94 <iunlockput>
    end_op();
    8000504e:	ffffe097          	auipc	ra,0xffffe
    80005052:	62a080e7          	jalr	1578(ra) # 80003678 <end_op>
    return -1;
    80005056:	557d                	li	a0,-1
    80005058:	b761                	j	80004fe0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000505a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000505e:	04649783          	lh	a5,70(s1)
    80005062:	02f99223          	sh	a5,36(s3)
    80005066:	bf25                	j	80004f9e <sys_open+0xa2>
    itrunc(ip);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffe097          	auipc	ra,0xffffe
    8000506e:	cd6080e7          	jalr	-810(ra) # 80002d40 <itrunc>
    80005072:	bfa9                	j	80004fcc <sys_open+0xd0>
      fileclose(f);
    80005074:	854e                	mv	a0,s3
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	a4e080e7          	jalr	-1458(ra) # 80003ac4 <fileclose>
    iunlockput(ip);
    8000507e:	8526                	mv	a0,s1
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	e14080e7          	jalr	-492(ra) # 80002e94 <iunlockput>
    end_op();
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	5f0080e7          	jalr	1520(ra) # 80003678 <end_op>
    return -1;
    80005090:	557d                	li	a0,-1
    80005092:	b7b9                	j	80004fe0 <sys_open+0xe4>

0000000080005094 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005094:	7175                	addi	sp,sp,-144
    80005096:	e506                	sd	ra,136(sp)
    80005098:	e122                	sd	s0,128(sp)
    8000509a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	55c080e7          	jalr	1372(ra) # 800035f8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    800050a4:	08000613          	li	a2,128
    800050a8:	f7040593          	addi	a1,s0,-144
    800050ac:	4501                	li	a0,0
    800050ae:	ffffd097          	auipc	ra,0xffffd
    800050b2:	048080e7          	jalr	72(ra) # 800020f6 <argstr>
    800050b6:	02054963          	bltz	a0,800050e8 <sys_mkdir+0x54>
    800050ba:	4681                	li	a3,0
    800050bc:	4601                	li	a2,0
    800050be:	4585                	li	a1,1
    800050c0:	f7040513          	addi	a0,s0,-144
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	536080e7          	jalr	1334(ra) # 800045fa <create>
    800050cc:	cd11                	beqz	a0,800050e8 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	dc6080e7          	jalr	-570(ra) # 80002e94 <iunlockput>
  end_op();
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	5a2080e7          	jalr	1442(ra) # 80003678 <end_op>
  return 0;
    800050de:	4501                	li	a0,0
}
    800050e0:	60aa                	ld	ra,136(sp)
    800050e2:	640a                	ld	s0,128(sp)
    800050e4:	6149                	addi	sp,sp,144
    800050e6:	8082                	ret
    end_op();
    800050e8:	ffffe097          	auipc	ra,0xffffe
    800050ec:	590080e7          	jalr	1424(ra) # 80003678 <end_op>
    return -1;
    800050f0:	557d                	li	a0,-1
    800050f2:	b7fd                	j	800050e0 <sys_mkdir+0x4c>

00000000800050f4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050f4:	7135                	addi	sp,sp,-160
    800050f6:	ed06                	sd	ra,152(sp)
    800050f8:	e922                	sd	s0,144(sp)
    800050fa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050fc:	ffffe097          	auipc	ra,0xffffe
    80005100:	4fc080e7          	jalr	1276(ra) # 800035f8 <begin_op>
  argint(1, &major);
    80005104:	f6c40593          	addi	a1,s0,-148
    80005108:	4505                	li	a0,1
    8000510a:	ffffd097          	auipc	ra,0xffffd
    8000510e:	fac080e7          	jalr	-84(ra) # 800020b6 <argint>
  argint(2, &minor);
    80005112:	f6840593          	addi	a1,s0,-152
    80005116:	4509                	li	a0,2
    80005118:	ffffd097          	auipc	ra,0xffffd
    8000511c:	f9e080e7          	jalr	-98(ra) # 800020b6 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005120:	08000613          	li	a2,128
    80005124:	f7040593          	addi	a1,s0,-144
    80005128:	4501                	li	a0,0
    8000512a:	ffffd097          	auipc	ra,0xffffd
    8000512e:	fcc080e7          	jalr	-52(ra) # 800020f6 <argstr>
    80005132:	02054b63          	bltz	a0,80005168 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005136:	f6841683          	lh	a3,-152(s0)
    8000513a:	f6c41603          	lh	a2,-148(s0)
    8000513e:	458d                	li	a1,3
    80005140:	f7040513          	addi	a0,s0,-144
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	4b6080e7          	jalr	1206(ra) # 800045fa <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000514c:	cd11                	beqz	a0,80005168 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	d46080e7          	jalr	-698(ra) # 80002e94 <iunlockput>
  end_op();
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	522080e7          	jalr	1314(ra) # 80003678 <end_op>
  return 0;
    8000515e:	4501                	li	a0,0
}
    80005160:	60ea                	ld	ra,152(sp)
    80005162:	644a                	ld	s0,144(sp)
    80005164:	610d                	addi	sp,sp,160
    80005166:	8082                	ret
    end_op();
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	510080e7          	jalr	1296(ra) # 80003678 <end_op>
    return -1;
    80005170:	557d                	li	a0,-1
    80005172:	b7fd                	j	80005160 <sys_mknod+0x6c>

0000000080005174 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005174:	7135                	addi	sp,sp,-160
    80005176:	ed06                	sd	ra,152(sp)
    80005178:	e922                	sd	s0,144(sp)
    8000517a:	e526                	sd	s1,136(sp)
    8000517c:	e14a                	sd	s2,128(sp)
    8000517e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	cb8080e7          	jalr	-840(ra) # 80000e38 <myproc>
    80005188:	892a                	mv	s2,a0

  begin_op();
    8000518a:	ffffe097          	auipc	ra,0xffffe
    8000518e:	46e080e7          	jalr	1134(ra) # 800035f8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005192:	08000613          	li	a2,128
    80005196:	f6040593          	addi	a1,s0,-160
    8000519a:	4501                	li	a0,0
    8000519c:	ffffd097          	auipc	ra,0xffffd
    800051a0:	f5a080e7          	jalr	-166(ra) # 800020f6 <argstr>
    800051a4:	04054b63          	bltz	a0,800051fa <sys_chdir+0x86>
    800051a8:	f6040513          	addi	a0,s0,-160
    800051ac:	ffffe097          	auipc	ra,0xffffe
    800051b0:	22c080e7          	jalr	556(ra) # 800033d8 <namei>
    800051b4:	84aa                	mv	s1,a0
    800051b6:	c131                	beqz	a0,800051fa <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800051b8:	ffffe097          	auipc	ra,0xffffe
    800051bc:	a7a080e7          	jalr	-1414(ra) # 80002c32 <ilock>
  if (ip->type != T_DIR)
    800051c0:	04449703          	lh	a4,68(s1)
    800051c4:	4785                	li	a5,1
    800051c6:	04f71063          	bne	a4,a5,80005206 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051ca:	8526                	mv	a0,s1
    800051cc:	ffffe097          	auipc	ra,0xffffe
    800051d0:	b28080e7          	jalr	-1240(ra) # 80002cf4 <iunlock>
  iput(p->cwd);
    800051d4:	15093503          	ld	a0,336(s2)
    800051d8:	ffffe097          	auipc	ra,0xffffe
    800051dc:	c14080e7          	jalr	-1004(ra) # 80002dec <iput>
  end_op();
    800051e0:	ffffe097          	auipc	ra,0xffffe
    800051e4:	498080e7          	jalr	1176(ra) # 80003678 <end_op>
  p->cwd = ip;
    800051e8:	14993823          	sd	s1,336(s2)
  return 0;
    800051ec:	4501                	li	a0,0
}
    800051ee:	60ea                	ld	ra,152(sp)
    800051f0:	644a                	ld	s0,144(sp)
    800051f2:	64aa                	ld	s1,136(sp)
    800051f4:	690a                	ld	s2,128(sp)
    800051f6:	610d                	addi	sp,sp,160
    800051f8:	8082                	ret
    end_op();
    800051fa:	ffffe097          	auipc	ra,0xffffe
    800051fe:	47e080e7          	jalr	1150(ra) # 80003678 <end_op>
    return -1;
    80005202:	557d                	li	a0,-1
    80005204:	b7ed                	j	800051ee <sys_chdir+0x7a>
    iunlockput(ip);
    80005206:	8526                	mv	a0,s1
    80005208:	ffffe097          	auipc	ra,0xffffe
    8000520c:	c8c080e7          	jalr	-884(ra) # 80002e94 <iunlockput>
    end_op();
    80005210:	ffffe097          	auipc	ra,0xffffe
    80005214:	468080e7          	jalr	1128(ra) # 80003678 <end_op>
    return -1;
    80005218:	557d                	li	a0,-1
    8000521a:	bfd1                	j	800051ee <sys_chdir+0x7a>

000000008000521c <sys_exec>:

uint64
sys_exec(void)
{
    8000521c:	7145                	addi	sp,sp,-464
    8000521e:	e786                	sd	ra,456(sp)
    80005220:	e3a2                	sd	s0,448(sp)
    80005222:	ff26                	sd	s1,440(sp)
    80005224:	fb4a                	sd	s2,432(sp)
    80005226:	f74e                	sd	s3,424(sp)
    80005228:	f352                	sd	s4,416(sp)
    8000522a:	ef56                	sd	s5,408(sp)
    8000522c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000522e:	e3840593          	addi	a1,s0,-456
    80005232:	4505                	li	a0,1
    80005234:	ffffd097          	auipc	ra,0xffffd
    80005238:	ea2080e7          	jalr	-350(ra) # 800020d6 <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    8000523c:	08000613          	li	a2,128
    80005240:	f4040593          	addi	a1,s0,-192
    80005244:	4501                	li	a0,0
    80005246:	ffffd097          	auipc	ra,0xffffd
    8000524a:	eb0080e7          	jalr	-336(ra) # 800020f6 <argstr>
    8000524e:	87aa                	mv	a5,a0
  {
    return -1;
    80005250:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80005252:	0c07c263          	bltz	a5,80005316 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005256:	10000613          	li	a2,256
    8000525a:	4581                	li	a1,0
    8000525c:	e4040513          	addi	a0,s0,-448
    80005260:	ffffb097          	auipc	ra,0xffffb
    80005264:	f18080e7          	jalr	-232(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80005268:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000526c:	89a6                	mv	s3,s1
    8000526e:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80005270:	02000a13          	li	s4,32
    80005274:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005278:	00391793          	slli	a5,s2,0x3
    8000527c:	e3040593          	addi	a1,s0,-464
    80005280:	e3843503          	ld	a0,-456(s0)
    80005284:	953e                	add	a0,a0,a5
    80005286:	ffffd097          	auipc	ra,0xffffd
    8000528a:	d92080e7          	jalr	-622(ra) # 80002018 <fetchaddr>
    8000528e:	02054a63          	bltz	a0,800052c2 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80005292:	e3043783          	ld	a5,-464(s0)
    80005296:	c3b9                	beqz	a5,800052dc <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005298:	ffffb097          	auipc	ra,0xffffb
    8000529c:	e80080e7          	jalr	-384(ra) # 80000118 <kalloc>
    800052a0:	85aa                	mv	a1,a0
    800052a2:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800052a6:	cd11                	beqz	a0,800052c2 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052a8:	6605                	lui	a2,0x1
    800052aa:	e3043503          	ld	a0,-464(s0)
    800052ae:	ffffd097          	auipc	ra,0xffffd
    800052b2:	dbc080e7          	jalr	-580(ra) # 8000206a <fetchstr>
    800052b6:	00054663          	bltz	a0,800052c2 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    800052ba:	0905                	addi	s2,s2,1
    800052bc:	09a1                	addi	s3,s3,8
    800052be:	fb491be3          	bne	s2,s4,80005274 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c2:	10048913          	addi	s2,s1,256
    800052c6:	6088                	ld	a0,0(s1)
    800052c8:	c531                	beqz	a0,80005314 <sys_exec+0xf8>
    kfree(argv[i]);
    800052ca:	ffffb097          	auipc	ra,0xffffb
    800052ce:	d52080e7          	jalr	-686(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d2:	04a1                	addi	s1,s1,8
    800052d4:	ff2499e3          	bne	s1,s2,800052c6 <sys_exec+0xaa>
  return -1;
    800052d8:	557d                	li	a0,-1
    800052da:	a835                	j	80005316 <sys_exec+0xfa>
      argv[i] = 0;
    800052dc:	0a8e                	slli	s5,s5,0x3
    800052de:	fc040793          	addi	a5,s0,-64
    800052e2:	9abe                	add	s5,s5,a5
    800052e4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800052e8:	e4040593          	addi	a1,s0,-448
    800052ec:	f4040513          	addi	a0,s0,-192
    800052f0:	fffff097          	auipc	ra,0xfffff
    800052f4:	ea8080e7          	jalr	-344(ra) # 80004198 <exec>
    800052f8:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052fa:	10048993          	addi	s3,s1,256
    800052fe:	6088                	ld	a0,0(s1)
    80005300:	c901                	beqz	a0,80005310 <sys_exec+0xf4>
    kfree(argv[i]);
    80005302:	ffffb097          	auipc	ra,0xffffb
    80005306:	d1a080e7          	jalr	-742(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000530a:	04a1                	addi	s1,s1,8
    8000530c:	ff3499e3          	bne	s1,s3,800052fe <sys_exec+0xe2>
  return ret;
    80005310:	854a                	mv	a0,s2
    80005312:	a011                	j	80005316 <sys_exec+0xfa>
  return -1;
    80005314:	557d                	li	a0,-1
}
    80005316:	60be                	ld	ra,456(sp)
    80005318:	641e                	ld	s0,448(sp)
    8000531a:	74fa                	ld	s1,440(sp)
    8000531c:	795a                	ld	s2,432(sp)
    8000531e:	79ba                	ld	s3,424(sp)
    80005320:	7a1a                	ld	s4,416(sp)
    80005322:	6afa                	ld	s5,408(sp)
    80005324:	6179                	addi	sp,sp,464
    80005326:	8082                	ret

0000000080005328 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005328:	7139                	addi	sp,sp,-64
    8000532a:	fc06                	sd	ra,56(sp)
    8000532c:	f822                	sd	s0,48(sp)
    8000532e:	f426                	sd	s1,40(sp)
    80005330:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	b06080e7          	jalr	-1274(ra) # 80000e38 <myproc>
    8000533a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000533c:	fd840593          	addi	a1,s0,-40
    80005340:	4501                	li	a0,0
    80005342:	ffffd097          	auipc	ra,0xffffd
    80005346:	d94080e7          	jalr	-620(ra) # 800020d6 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000534a:	fc840593          	addi	a1,s0,-56
    8000534e:	fd040513          	addi	a0,s0,-48
    80005352:	fffff097          	auipc	ra,0xfffff
    80005356:	afc080e7          	jalr	-1284(ra) # 80003e4e <pipealloc>
    return -1;
    8000535a:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    8000535c:	0c054463          	bltz	a0,80005424 <sys_pipe+0xfc>
  fd0 = -1;
    80005360:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005364:	fd043503          	ld	a0,-48(s0)
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	250080e7          	jalr	592(ra) # 800045b8 <fdalloc>
    80005370:	fca42223          	sw	a0,-60(s0)
    80005374:	08054b63          	bltz	a0,8000540a <sys_pipe+0xe2>
    80005378:	fc843503          	ld	a0,-56(s0)
    8000537c:	fffff097          	auipc	ra,0xfffff
    80005380:	23c080e7          	jalr	572(ra) # 800045b8 <fdalloc>
    80005384:	fca42023          	sw	a0,-64(s0)
    80005388:	06054863          	bltz	a0,800053f8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000538c:	4691                	li	a3,4
    8000538e:	fc440613          	addi	a2,s0,-60
    80005392:	fd843583          	ld	a1,-40(s0)
    80005396:	68a8                	ld	a0,80(s1)
    80005398:	ffffb097          	auipc	ra,0xffffb
    8000539c:	75c080e7          	jalr	1884(ra) # 80000af4 <copyout>
    800053a0:	02054063          	bltz	a0,800053c0 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800053a4:	4691                	li	a3,4
    800053a6:	fc040613          	addi	a2,s0,-64
    800053aa:	fd843583          	ld	a1,-40(s0)
    800053ae:	0591                	addi	a1,a1,4
    800053b0:	68a8                	ld	a0,80(s1)
    800053b2:	ffffb097          	auipc	ra,0xffffb
    800053b6:	742080e7          	jalr	1858(ra) # 80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053ba:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053bc:	06055463          	bgez	a0,80005424 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800053c0:	fc442783          	lw	a5,-60(s0)
    800053c4:	07e9                	addi	a5,a5,26
    800053c6:	078e                	slli	a5,a5,0x3
    800053c8:	97a6                	add	a5,a5,s1
    800053ca:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd1280>
    p->ofile[fd1] = 0;
    800053ce:	fc042503          	lw	a0,-64(s0)
    800053d2:	0569                	addi	a0,a0,26
    800053d4:	050e                	slli	a0,a0,0x3
    800053d6:	94aa                	add	s1,s1,a0
    800053d8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053dc:	fd043503          	ld	a0,-48(s0)
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	6e4080e7          	jalr	1764(ra) # 80003ac4 <fileclose>
    fileclose(wf);
    800053e8:	fc843503          	ld	a0,-56(s0)
    800053ec:	ffffe097          	auipc	ra,0xffffe
    800053f0:	6d8080e7          	jalr	1752(ra) # 80003ac4 <fileclose>
    return -1;
    800053f4:	57fd                	li	a5,-1
    800053f6:	a03d                	j	80005424 <sys_pipe+0xfc>
    if (fd0 >= 0)
    800053f8:	fc442783          	lw	a5,-60(s0)
    800053fc:	0007c763          	bltz	a5,8000540a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005400:	07e9                	addi	a5,a5,26
    80005402:	078e                	slli	a5,a5,0x3
    80005404:	94be                	add	s1,s1,a5
    80005406:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000540a:	fd043503          	ld	a0,-48(s0)
    8000540e:	ffffe097          	auipc	ra,0xffffe
    80005412:	6b6080e7          	jalr	1718(ra) # 80003ac4 <fileclose>
    fileclose(wf);
    80005416:	fc843503          	ld	a0,-56(s0)
    8000541a:	ffffe097          	auipc	ra,0xffffe
    8000541e:	6aa080e7          	jalr	1706(ra) # 80003ac4 <fileclose>
    return -1;
    80005422:	57fd                	li	a5,-1
}
    80005424:	853e                	mv	a0,a5
    80005426:	70e2                	ld	ra,56(sp)
    80005428:	7442                	ld	s0,48(sp)
    8000542a:	74a2                	ld	s1,40(sp)
    8000542c:	6121                	addi	sp,sp,64
    8000542e:	8082                	ret

0000000080005430 <kernelvec>:
    80005430:	7111                	addi	sp,sp,-256
    80005432:	e006                	sd	ra,0(sp)
    80005434:	e40a                	sd	sp,8(sp)
    80005436:	e80e                	sd	gp,16(sp)
    80005438:	ec12                	sd	tp,24(sp)
    8000543a:	f016                	sd	t0,32(sp)
    8000543c:	f41a                	sd	t1,40(sp)
    8000543e:	f81e                	sd	t2,48(sp)
    80005440:	fc22                	sd	s0,56(sp)
    80005442:	e0a6                	sd	s1,64(sp)
    80005444:	e4aa                	sd	a0,72(sp)
    80005446:	e8ae                	sd	a1,80(sp)
    80005448:	ecb2                	sd	a2,88(sp)
    8000544a:	f0b6                	sd	a3,96(sp)
    8000544c:	f4ba                	sd	a4,104(sp)
    8000544e:	f8be                	sd	a5,112(sp)
    80005450:	fcc2                	sd	a6,120(sp)
    80005452:	e146                	sd	a7,128(sp)
    80005454:	e54a                	sd	s2,136(sp)
    80005456:	e94e                	sd	s3,144(sp)
    80005458:	ed52                	sd	s4,152(sp)
    8000545a:	f156                	sd	s5,160(sp)
    8000545c:	f55a                	sd	s6,168(sp)
    8000545e:	f95e                	sd	s7,176(sp)
    80005460:	fd62                	sd	s8,184(sp)
    80005462:	e1e6                	sd	s9,192(sp)
    80005464:	e5ea                	sd	s10,200(sp)
    80005466:	e9ee                	sd	s11,208(sp)
    80005468:	edf2                	sd	t3,216(sp)
    8000546a:	f1f6                	sd	t4,224(sp)
    8000546c:	f5fa                	sd	t5,232(sp)
    8000546e:	f9fe                	sd	t6,240(sp)
    80005470:	a75fc0ef          	jal	ra,80001ee4 <kerneltrap>
    80005474:	6082                	ld	ra,0(sp)
    80005476:	6122                	ld	sp,8(sp)
    80005478:	61c2                	ld	gp,16(sp)
    8000547a:	7282                	ld	t0,32(sp)
    8000547c:	7322                	ld	t1,40(sp)
    8000547e:	73c2                	ld	t2,48(sp)
    80005480:	7462                	ld	s0,56(sp)
    80005482:	6486                	ld	s1,64(sp)
    80005484:	6526                	ld	a0,72(sp)
    80005486:	65c6                	ld	a1,80(sp)
    80005488:	6666                	ld	a2,88(sp)
    8000548a:	7686                	ld	a3,96(sp)
    8000548c:	7726                	ld	a4,104(sp)
    8000548e:	77c6                	ld	a5,112(sp)
    80005490:	7866                	ld	a6,120(sp)
    80005492:	688a                	ld	a7,128(sp)
    80005494:	692a                	ld	s2,136(sp)
    80005496:	69ca                	ld	s3,144(sp)
    80005498:	6a6a                	ld	s4,152(sp)
    8000549a:	7a8a                	ld	s5,160(sp)
    8000549c:	7b2a                	ld	s6,168(sp)
    8000549e:	7bca                	ld	s7,176(sp)
    800054a0:	7c6a                	ld	s8,184(sp)
    800054a2:	6c8e                	ld	s9,192(sp)
    800054a4:	6d2e                	ld	s10,200(sp)
    800054a6:	6dce                	ld	s11,208(sp)
    800054a8:	6e6e                	ld	t3,216(sp)
    800054aa:	7e8e                	ld	t4,224(sp)
    800054ac:	7f2e                	ld	t5,232(sp)
    800054ae:	7fce                	ld	t6,240(sp)
    800054b0:	6111                	addi	sp,sp,256
    800054b2:	10200073          	sret
    800054b6:	00000013          	nop
    800054ba:	00000013          	nop
    800054be:	0001                	nop

00000000800054c0 <timervec>:
    800054c0:	34051573          	csrrw	a0,mscratch,a0
    800054c4:	e10c                	sd	a1,0(a0)
    800054c6:	e510                	sd	a2,8(a0)
    800054c8:	e914                	sd	a3,16(a0)
    800054ca:	6d0c                	ld	a1,24(a0)
    800054cc:	7110                	ld	a2,32(a0)
    800054ce:	6194                	ld	a3,0(a1)
    800054d0:	96b2                	add	a3,a3,a2
    800054d2:	e194                	sd	a3,0(a1)
    800054d4:	4589                	li	a1,2
    800054d6:	14459073          	csrw	sip,a1
    800054da:	6914                	ld	a3,16(a0)
    800054dc:	6510                	ld	a2,8(a0)
    800054de:	610c                	ld	a1,0(a0)
    800054e0:	34051573          	csrrw	a0,mscratch,a0
    800054e4:	30200073          	mret
	...

00000000800054ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054ea:	1141                	addi	sp,sp,-16
    800054ec:	e422                	sd	s0,8(sp)
    800054ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054f0:	0c0007b7          	lui	a5,0xc000
    800054f4:	4705                	li	a4,1
    800054f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054f8:	c3d8                	sw	a4,4(a5)
}
    800054fa:	6422                	ld	s0,8(sp)
    800054fc:	0141                	addi	sp,sp,16
    800054fe:	8082                	ret

0000000080005500 <plicinithart>:

void
plicinithart(void)
{
    80005500:	1141                	addi	sp,sp,-16
    80005502:	e406                	sd	ra,8(sp)
    80005504:	e022                	sd	s0,0(sp)
    80005506:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005508:	ffffc097          	auipc	ra,0xffffc
    8000550c:	904080e7          	jalr	-1788(ra) # 80000e0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005510:	0085171b          	slliw	a4,a0,0x8
    80005514:	0c0027b7          	lui	a5,0xc002
    80005518:	97ba                	add	a5,a5,a4
    8000551a:	40200713          	li	a4,1026
    8000551e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005522:	00d5151b          	slliw	a0,a0,0xd
    80005526:	0c2017b7          	lui	a5,0xc201
    8000552a:	953e                	add	a0,a0,a5
    8000552c:	00052023          	sw	zero,0(a0)
}
    80005530:	60a2                	ld	ra,8(sp)
    80005532:	6402                	ld	s0,0(sp)
    80005534:	0141                	addi	sp,sp,16
    80005536:	8082                	ret

0000000080005538 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005538:	1141                	addi	sp,sp,-16
    8000553a:	e406                	sd	ra,8(sp)
    8000553c:	e022                	sd	s0,0(sp)
    8000553e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005540:	ffffc097          	auipc	ra,0xffffc
    80005544:	8cc080e7          	jalr	-1844(ra) # 80000e0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005548:	00d5179b          	slliw	a5,a0,0xd
    8000554c:	0c201537          	lui	a0,0xc201
    80005550:	953e                	add	a0,a0,a5
  return irq;
}
    80005552:	4148                	lw	a0,4(a0)
    80005554:	60a2                	ld	ra,8(sp)
    80005556:	6402                	ld	s0,0(sp)
    80005558:	0141                	addi	sp,sp,16
    8000555a:	8082                	ret

000000008000555c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000555c:	1101                	addi	sp,sp,-32
    8000555e:	ec06                	sd	ra,24(sp)
    80005560:	e822                	sd	s0,16(sp)
    80005562:	e426                	sd	s1,8(sp)
    80005564:	1000                	addi	s0,sp,32
    80005566:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005568:	ffffc097          	auipc	ra,0xffffc
    8000556c:	8a4080e7          	jalr	-1884(ra) # 80000e0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005570:	00d5151b          	slliw	a0,a0,0xd
    80005574:	0c2017b7          	lui	a5,0xc201
    80005578:	97aa                	add	a5,a5,a0
    8000557a:	c3c4                	sw	s1,4(a5)
}
    8000557c:	60e2                	ld	ra,24(sp)
    8000557e:	6442                	ld	s0,16(sp)
    80005580:	64a2                	ld	s1,8(sp)
    80005582:	6105                	addi	sp,sp,32
    80005584:	8082                	ret

0000000080005586 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005586:	1141                	addi	sp,sp,-16
    80005588:	e406                	sd	ra,8(sp)
    8000558a:	e022                	sd	s0,0(sp)
    8000558c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000558e:	479d                	li	a5,7
    80005590:	04a7cc63          	blt	a5,a0,800055e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005594:	00020797          	auipc	a5,0x20
    80005598:	46c78793          	addi	a5,a5,1132 # 80025a00 <disk>
    8000559c:	97aa                	add	a5,a5,a0
    8000559e:	0187c783          	lbu	a5,24(a5)
    800055a2:	ebb9                	bnez	a5,800055f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800055a4:	00451613          	slli	a2,a0,0x4
    800055a8:	00020797          	auipc	a5,0x20
    800055ac:	45878793          	addi	a5,a5,1112 # 80025a00 <disk>
    800055b0:	6394                	ld	a3,0(a5)
    800055b2:	96b2                	add	a3,a3,a2
    800055b4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055b8:	6398                	ld	a4,0(a5)
    800055ba:	9732                	add	a4,a4,a2
    800055bc:	00072423          	sw	zero,8(a4) # fffffffffffff008 <end+0xffffffff7ffd1288>
  disk.desc[i].flags = 0;
    800055c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055c8:	953e                	add	a0,a0,a5
    800055ca:	4785                	li	a5,1
    800055cc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800055d0:	00020517          	auipc	a0,0x20
    800055d4:	44850513          	addi	a0,a0,1096 # 80025a18 <disk+0x18>
    800055d8:	ffffc097          	auipc	ra,0xffffc
    800055dc:	fcc080e7          	jalr	-52(ra) # 800015a4 <wakeup>
}
    800055e0:	60a2                	ld	ra,8(sp)
    800055e2:	6402                	ld	s0,0(sp)
    800055e4:	0141                	addi	sp,sp,16
    800055e6:	8082                	ret
    panic("free_desc 1");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	12050513          	addi	a0,a0,288 # 80008708 <syscalls+0x308>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	a0e080e7          	jalr	-1522(ra) # 80005ffe <panic>
    panic("free_desc 2");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	12050513          	addi	a0,a0,288 # 80008718 <syscalls+0x318>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	9fe080e7          	jalr	-1538(ra) # 80005ffe <panic>

0000000080005608 <virtio_disk_init>:
{
    80005608:	1101                	addi	sp,sp,-32
    8000560a:	ec06                	sd	ra,24(sp)
    8000560c:	e822                	sd	s0,16(sp)
    8000560e:	e426                	sd	s1,8(sp)
    80005610:	e04a                	sd	s2,0(sp)
    80005612:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005614:	00003597          	auipc	a1,0x3
    80005618:	11458593          	addi	a1,a1,276 # 80008728 <syscalls+0x328>
    8000561c:	00020517          	auipc	a0,0x20
    80005620:	50c50513          	addi	a0,a0,1292 # 80025b28 <disk+0x128>
    80005624:	00001097          	auipc	ra,0x1
    80005628:	e86080e7          	jalr	-378(ra) # 800064aa <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000562c:	100017b7          	lui	a5,0x10001
    80005630:	4398                	lw	a4,0(a5)
    80005632:	2701                	sext.w	a4,a4
    80005634:	747277b7          	lui	a5,0x74727
    80005638:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000563c:	14f71c63          	bne	a4,a5,80005794 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005640:	100017b7          	lui	a5,0x10001
    80005644:	43dc                	lw	a5,4(a5)
    80005646:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005648:	4709                	li	a4,2
    8000564a:	14e79563          	bne	a5,a4,80005794 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000564e:	100017b7          	lui	a5,0x10001
    80005652:	479c                	lw	a5,8(a5)
    80005654:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005656:	12e79f63          	bne	a5,a4,80005794 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000565a:	100017b7          	lui	a5,0x10001
    8000565e:	47d8                	lw	a4,12(a5)
    80005660:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005662:	554d47b7          	lui	a5,0x554d4
    80005666:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000566a:	12f71563          	bne	a4,a5,80005794 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000566e:	100017b7          	lui	a5,0x10001
    80005672:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005676:	4705                	li	a4,1
    80005678:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000567a:	470d                	li	a4,3
    8000567c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000567e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005680:	c7ffe737          	lui	a4,0xc7ffe
    80005684:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd09df>
    80005688:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000568a:	2701                	sext.w	a4,a4
    8000568c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000568e:	472d                	li	a4,11
    80005690:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005692:	5bbc                	lw	a5,112(a5)
    80005694:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005698:	8ba1                	andi	a5,a5,8
    8000569a:	10078563          	beqz	a5,800057a4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000569e:	100017b7          	lui	a5,0x10001
    800056a2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800056a6:	43fc                	lw	a5,68(a5)
    800056a8:	2781                	sext.w	a5,a5
    800056aa:	10079563          	bnez	a5,800057b4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056ae:	100017b7          	lui	a5,0x10001
    800056b2:	5bdc                	lw	a5,52(a5)
    800056b4:	2781                	sext.w	a5,a5
  if(max == 0)
    800056b6:	10078763          	beqz	a5,800057c4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800056ba:	471d                	li	a4,7
    800056bc:	10f77c63          	bgeu	a4,a5,800057d4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800056c0:	ffffb097          	auipc	ra,0xffffb
    800056c4:	a58080e7          	jalr	-1448(ra) # 80000118 <kalloc>
    800056c8:	00020497          	auipc	s1,0x20
    800056cc:	33848493          	addi	s1,s1,824 # 80025a00 <disk>
    800056d0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056d2:	ffffb097          	auipc	ra,0xffffb
    800056d6:	a46080e7          	jalr	-1466(ra) # 80000118 <kalloc>
    800056da:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056dc:	ffffb097          	auipc	ra,0xffffb
    800056e0:	a3c080e7          	jalr	-1476(ra) # 80000118 <kalloc>
    800056e4:	87aa                	mv	a5,a0
    800056e6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056e8:	6088                	ld	a0,0(s1)
    800056ea:	cd6d                	beqz	a0,800057e4 <virtio_disk_init+0x1dc>
    800056ec:	00020717          	auipc	a4,0x20
    800056f0:	31c73703          	ld	a4,796(a4) # 80025a08 <disk+0x8>
    800056f4:	cb65                	beqz	a4,800057e4 <virtio_disk_init+0x1dc>
    800056f6:	c7fd                	beqz	a5,800057e4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800056f8:	6605                	lui	a2,0x1
    800056fa:	4581                	li	a1,0
    800056fc:	ffffb097          	auipc	ra,0xffffb
    80005700:	a7c080e7          	jalr	-1412(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005704:	00020497          	auipc	s1,0x20
    80005708:	2fc48493          	addi	s1,s1,764 # 80025a00 <disk>
    8000570c:	6605                	lui	a2,0x1
    8000570e:	4581                	li	a1,0
    80005710:	6488                	ld	a0,8(s1)
    80005712:	ffffb097          	auipc	ra,0xffffb
    80005716:	a66080e7          	jalr	-1434(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000571a:	6605                	lui	a2,0x1
    8000571c:	4581                	li	a1,0
    8000571e:	6888                	ld	a0,16(s1)
    80005720:	ffffb097          	auipc	ra,0xffffb
    80005724:	a58080e7          	jalr	-1448(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005728:	100017b7          	lui	a5,0x10001
    8000572c:	4721                	li	a4,8
    8000572e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005730:	4098                	lw	a4,0(s1)
    80005732:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005736:	40d8                	lw	a4,4(s1)
    80005738:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000573c:	6498                	ld	a4,8(s1)
    8000573e:	0007069b          	sext.w	a3,a4
    80005742:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005746:	9701                	srai	a4,a4,0x20
    80005748:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000574c:	6898                	ld	a4,16(s1)
    8000574e:	0007069b          	sext.w	a3,a4
    80005752:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005756:	9701                	srai	a4,a4,0x20
    80005758:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000575c:	4705                	li	a4,1
    8000575e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005760:	00e48c23          	sb	a4,24(s1)
    80005764:	00e48ca3          	sb	a4,25(s1)
    80005768:	00e48d23          	sb	a4,26(s1)
    8000576c:	00e48da3          	sb	a4,27(s1)
    80005770:	00e48e23          	sb	a4,28(s1)
    80005774:	00e48ea3          	sb	a4,29(s1)
    80005778:	00e48f23          	sb	a4,30(s1)
    8000577c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005780:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005784:	0727a823          	sw	s2,112(a5)
}
    80005788:	60e2                	ld	ra,24(sp)
    8000578a:	6442                	ld	s0,16(sp)
    8000578c:	64a2                	ld	s1,8(sp)
    8000578e:	6902                	ld	s2,0(sp)
    80005790:	6105                	addi	sp,sp,32
    80005792:	8082                	ret
    panic("could not find virtio disk");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	fa450513          	addi	a0,a0,-92 # 80008738 <syscalls+0x338>
    8000579c:	00001097          	auipc	ra,0x1
    800057a0:	862080e7          	jalr	-1950(ra) # 80005ffe <panic>
    panic("virtio disk FEATURES_OK unset");
    800057a4:	00003517          	auipc	a0,0x3
    800057a8:	fb450513          	addi	a0,a0,-76 # 80008758 <syscalls+0x358>
    800057ac:	00001097          	auipc	ra,0x1
    800057b0:	852080e7          	jalr	-1966(ra) # 80005ffe <panic>
    panic("virtio disk should not be ready");
    800057b4:	00003517          	auipc	a0,0x3
    800057b8:	fc450513          	addi	a0,a0,-60 # 80008778 <syscalls+0x378>
    800057bc:	00001097          	auipc	ra,0x1
    800057c0:	842080e7          	jalr	-1982(ra) # 80005ffe <panic>
    panic("virtio disk has no queue 0");
    800057c4:	00003517          	auipc	a0,0x3
    800057c8:	fd450513          	addi	a0,a0,-44 # 80008798 <syscalls+0x398>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	832080e7          	jalr	-1998(ra) # 80005ffe <panic>
    panic("virtio disk max queue too short");
    800057d4:	00003517          	auipc	a0,0x3
    800057d8:	fe450513          	addi	a0,a0,-28 # 800087b8 <syscalls+0x3b8>
    800057dc:	00001097          	auipc	ra,0x1
    800057e0:	822080e7          	jalr	-2014(ra) # 80005ffe <panic>
    panic("virtio disk kalloc");
    800057e4:	00003517          	auipc	a0,0x3
    800057e8:	ff450513          	addi	a0,a0,-12 # 800087d8 <syscalls+0x3d8>
    800057ec:	00001097          	auipc	ra,0x1
    800057f0:	812080e7          	jalr	-2030(ra) # 80005ffe <panic>

00000000800057f4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057f4:	7119                	addi	sp,sp,-128
    800057f6:	fc86                	sd	ra,120(sp)
    800057f8:	f8a2                	sd	s0,112(sp)
    800057fa:	f4a6                	sd	s1,104(sp)
    800057fc:	f0ca                	sd	s2,96(sp)
    800057fe:	ecce                	sd	s3,88(sp)
    80005800:	e8d2                	sd	s4,80(sp)
    80005802:	e4d6                	sd	s5,72(sp)
    80005804:	e0da                	sd	s6,64(sp)
    80005806:	fc5e                	sd	s7,56(sp)
    80005808:	f862                	sd	s8,48(sp)
    8000580a:	f466                	sd	s9,40(sp)
    8000580c:	f06a                	sd	s10,32(sp)
    8000580e:	ec6e                	sd	s11,24(sp)
    80005810:	0100                	addi	s0,sp,128
    80005812:	8aaa                	mv	s5,a0
    80005814:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005816:	00c52d03          	lw	s10,12(a0)
    8000581a:	001d1d1b          	slliw	s10,s10,0x1
    8000581e:	1d02                	slli	s10,s10,0x20
    80005820:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005824:	00020517          	auipc	a0,0x20
    80005828:	30450513          	addi	a0,a0,772 # 80025b28 <disk+0x128>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	d0e080e7          	jalr	-754(ra) # 8000653a <acquire>
  for(int i = 0; i < 3; i++){
    80005834:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005836:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005838:	00020b97          	auipc	s7,0x20
    8000583c:	1c8b8b93          	addi	s7,s7,456 # 80025a00 <disk>
  for(int i = 0; i < 3; i++){
    80005840:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005842:	00020c97          	auipc	s9,0x20
    80005846:	2e6c8c93          	addi	s9,s9,742 # 80025b28 <disk+0x128>
    8000584a:	a08d                	j	800058ac <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000584c:	00fb8733          	add	a4,s7,a5
    80005850:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005854:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005856:	0207c563          	bltz	a5,80005880 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000585a:	2905                	addiw	s2,s2,1
    8000585c:	0611                	addi	a2,a2,4
    8000585e:	05690c63          	beq	s2,s6,800058b6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005862:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005864:	00020717          	auipc	a4,0x20
    80005868:	19c70713          	addi	a4,a4,412 # 80025a00 <disk>
    8000586c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000586e:	01874683          	lbu	a3,24(a4)
    80005872:	fee9                	bnez	a3,8000584c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005874:	2785                	addiw	a5,a5,1
    80005876:	0705                	addi	a4,a4,1
    80005878:	fe979be3          	bne	a5,s1,8000586e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000587c:	57fd                	li	a5,-1
    8000587e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005880:	01205d63          	blez	s2,8000589a <virtio_disk_rw+0xa6>
    80005884:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005886:	000a2503          	lw	a0,0(s4)
    8000588a:	00000097          	auipc	ra,0x0
    8000588e:	cfc080e7          	jalr	-772(ra) # 80005586 <free_desc>
      for(int j = 0; j < i; j++)
    80005892:	2d85                	addiw	s11,s11,1
    80005894:	0a11                	addi	s4,s4,4
    80005896:	ffb918e3          	bne	s2,s11,80005886 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000589a:	85e6                	mv	a1,s9
    8000589c:	00020517          	auipc	a0,0x20
    800058a0:	17c50513          	addi	a0,a0,380 # 80025a18 <disk+0x18>
    800058a4:	ffffc097          	auipc	ra,0xffffc
    800058a8:	c9c080e7          	jalr	-868(ra) # 80001540 <sleep>
  for(int i = 0; i < 3; i++){
    800058ac:	f8040a13          	addi	s4,s0,-128
{
    800058b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800058b2:	894e                	mv	s2,s3
    800058b4:	b77d                	j	80005862 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058b6:	f8042583          	lw	a1,-128(s0)
    800058ba:	00a58793          	addi	a5,a1,10
    800058be:	0792                	slli	a5,a5,0x4

  if(write)
    800058c0:	00020617          	auipc	a2,0x20
    800058c4:	14060613          	addi	a2,a2,320 # 80025a00 <disk>
    800058c8:	00f60733          	add	a4,a2,a5
    800058cc:	018036b3          	snez	a3,s8
    800058d0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058d2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058d6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058da:	f6078693          	addi	a3,a5,-160
    800058de:	6218                	ld	a4,0(a2)
    800058e0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058e2:	00878513          	addi	a0,a5,8
    800058e6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058e8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058ea:	6208                	ld	a0,0(a2)
    800058ec:	96aa                	add	a3,a3,a0
    800058ee:	4741                	li	a4,16
    800058f0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058f2:	4705                	li	a4,1
    800058f4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800058f8:	f8442703          	lw	a4,-124(s0)
    800058fc:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005900:	0712                	slli	a4,a4,0x4
    80005902:	953a                	add	a0,a0,a4
    80005904:	058a8693          	addi	a3,s5,88
    80005908:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000590a:	6208                	ld	a0,0(a2)
    8000590c:	972a                	add	a4,a4,a0
    8000590e:	40000693          	li	a3,1024
    80005912:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005914:	001c3c13          	seqz	s8,s8
    80005918:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000591a:	001c6c13          	ori	s8,s8,1
    8000591e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005922:	f8842603          	lw	a2,-120(s0)
    80005926:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000592a:	00020697          	auipc	a3,0x20
    8000592e:	0d668693          	addi	a3,a3,214 # 80025a00 <disk>
    80005932:	00258713          	addi	a4,a1,2
    80005936:	0712                	slli	a4,a4,0x4
    80005938:	9736                	add	a4,a4,a3
    8000593a:	587d                	li	a6,-1
    8000593c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005940:	0612                	slli	a2,a2,0x4
    80005942:	9532                	add	a0,a0,a2
    80005944:	f9078793          	addi	a5,a5,-112
    80005948:	97b6                	add	a5,a5,a3
    8000594a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000594c:	629c                	ld	a5,0(a3)
    8000594e:	97b2                	add	a5,a5,a2
    80005950:	4605                	li	a2,1
    80005952:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005954:	4509                	li	a0,2
    80005956:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000595a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000595e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005962:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005966:	6698                	ld	a4,8(a3)
    80005968:	00275783          	lhu	a5,2(a4)
    8000596c:	8b9d                	andi	a5,a5,7
    8000596e:	0786                	slli	a5,a5,0x1
    80005970:	97ba                	add	a5,a5,a4
    80005972:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005976:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000597a:	6698                	ld	a4,8(a3)
    8000597c:	00275783          	lhu	a5,2(a4)
    80005980:	2785                	addiw	a5,a5,1
    80005982:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005986:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000598a:	100017b7          	lui	a5,0x10001
    8000598e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005992:	004aa783          	lw	a5,4(s5)
    80005996:	02c79163          	bne	a5,a2,800059b8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000599a:	00020917          	auipc	s2,0x20
    8000599e:	18e90913          	addi	s2,s2,398 # 80025b28 <disk+0x128>
  while(b->disk == 1) {
    800059a2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800059a4:	85ca                	mv	a1,s2
    800059a6:	8556                	mv	a0,s5
    800059a8:	ffffc097          	auipc	ra,0xffffc
    800059ac:	b98080e7          	jalr	-1128(ra) # 80001540 <sleep>
  while(b->disk == 1) {
    800059b0:	004aa783          	lw	a5,4(s5)
    800059b4:	fe9788e3          	beq	a5,s1,800059a4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800059b8:	f8042903          	lw	s2,-128(s0)
    800059bc:	00290793          	addi	a5,s2,2
    800059c0:	00479713          	slli	a4,a5,0x4
    800059c4:	00020797          	auipc	a5,0x20
    800059c8:	03c78793          	addi	a5,a5,60 # 80025a00 <disk>
    800059cc:	97ba                	add	a5,a5,a4
    800059ce:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059d2:	00020997          	auipc	s3,0x20
    800059d6:	02e98993          	addi	s3,s3,46 # 80025a00 <disk>
    800059da:	00491713          	slli	a4,s2,0x4
    800059de:	0009b783          	ld	a5,0(s3)
    800059e2:	97ba                	add	a5,a5,a4
    800059e4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059e8:	854a                	mv	a0,s2
    800059ea:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059ee:	00000097          	auipc	ra,0x0
    800059f2:	b98080e7          	jalr	-1128(ra) # 80005586 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059f6:	8885                	andi	s1,s1,1
    800059f8:	f0ed                	bnez	s1,800059da <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059fa:	00020517          	auipc	a0,0x20
    800059fe:	12e50513          	addi	a0,a0,302 # 80025b28 <disk+0x128>
    80005a02:	00001097          	auipc	ra,0x1
    80005a06:	bec080e7          	jalr	-1044(ra) # 800065ee <release>
}
    80005a0a:	70e6                	ld	ra,120(sp)
    80005a0c:	7446                	ld	s0,112(sp)
    80005a0e:	74a6                	ld	s1,104(sp)
    80005a10:	7906                	ld	s2,96(sp)
    80005a12:	69e6                	ld	s3,88(sp)
    80005a14:	6a46                	ld	s4,80(sp)
    80005a16:	6aa6                	ld	s5,72(sp)
    80005a18:	6b06                	ld	s6,64(sp)
    80005a1a:	7be2                	ld	s7,56(sp)
    80005a1c:	7c42                	ld	s8,48(sp)
    80005a1e:	7ca2                	ld	s9,40(sp)
    80005a20:	7d02                	ld	s10,32(sp)
    80005a22:	6de2                	ld	s11,24(sp)
    80005a24:	6109                	addi	sp,sp,128
    80005a26:	8082                	ret

0000000080005a28 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a28:	1101                	addi	sp,sp,-32
    80005a2a:	ec06                	sd	ra,24(sp)
    80005a2c:	e822                	sd	s0,16(sp)
    80005a2e:	e426                	sd	s1,8(sp)
    80005a30:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a32:	00020497          	auipc	s1,0x20
    80005a36:	fce48493          	addi	s1,s1,-50 # 80025a00 <disk>
    80005a3a:	00020517          	auipc	a0,0x20
    80005a3e:	0ee50513          	addi	a0,a0,238 # 80025b28 <disk+0x128>
    80005a42:	00001097          	auipc	ra,0x1
    80005a46:	af8080e7          	jalr	-1288(ra) # 8000653a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a4a:	10001737          	lui	a4,0x10001
    80005a4e:	533c                	lw	a5,96(a4)
    80005a50:	8b8d                	andi	a5,a5,3
    80005a52:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a54:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a58:	689c                	ld	a5,16(s1)
    80005a5a:	0204d703          	lhu	a4,32(s1)
    80005a5e:	0027d783          	lhu	a5,2(a5)
    80005a62:	04f70863          	beq	a4,a5,80005ab2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a66:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a6a:	6898                	ld	a4,16(s1)
    80005a6c:	0204d783          	lhu	a5,32(s1)
    80005a70:	8b9d                	andi	a5,a5,7
    80005a72:	078e                	slli	a5,a5,0x3
    80005a74:	97ba                	add	a5,a5,a4
    80005a76:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a78:	00278713          	addi	a4,a5,2
    80005a7c:	0712                	slli	a4,a4,0x4
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a84:	e721                	bnez	a4,80005acc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a86:	0789                	addi	a5,a5,2
    80005a88:	0792                	slli	a5,a5,0x4
    80005a8a:	97a6                	add	a5,a5,s1
    80005a8c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a8e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	b12080e7          	jalr	-1262(ra) # 800015a4 <wakeup>

    disk.used_idx += 1;
    80005a9a:	0204d783          	lhu	a5,32(s1)
    80005a9e:	2785                	addiw	a5,a5,1
    80005aa0:	17c2                	slli	a5,a5,0x30
    80005aa2:	93c1                	srli	a5,a5,0x30
    80005aa4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005aa8:	6898                	ld	a4,16(s1)
    80005aaa:	00275703          	lhu	a4,2(a4)
    80005aae:	faf71ce3          	bne	a4,a5,80005a66 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005ab2:	00020517          	auipc	a0,0x20
    80005ab6:	07650513          	addi	a0,a0,118 # 80025b28 <disk+0x128>
    80005aba:	00001097          	auipc	ra,0x1
    80005abe:	b34080e7          	jalr	-1228(ra) # 800065ee <release>
}
    80005ac2:	60e2                	ld	ra,24(sp)
    80005ac4:	6442                	ld	s0,16(sp)
    80005ac6:	64a2                	ld	s1,8(sp)
    80005ac8:	6105                	addi	sp,sp,32
    80005aca:	8082                	ret
      panic("virtio_disk_intr status");
    80005acc:	00003517          	auipc	a0,0x3
    80005ad0:	d2450513          	addi	a0,a0,-732 # 800087f0 <syscalls+0x3f0>
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	52a080e7          	jalr	1322(ra) # 80005ffe <panic>

0000000080005adc <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005adc:	1141                	addi	sp,sp,-16
    80005ade:	e422                	sd	s0,8(sp)
    80005ae0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ae2:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ae6:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005aea:	0037979b          	slliw	a5,a5,0x3
    80005aee:	02004737          	lui	a4,0x2004
    80005af2:	97ba                	add	a5,a5,a4
    80005af4:	0200c737          	lui	a4,0x200c
    80005af8:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005afc:	000f4637          	lui	a2,0xf4
    80005b00:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b04:	95b2                	add	a1,a1,a2
    80005b06:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b08:	00269713          	slli	a4,a3,0x2
    80005b0c:	9736                	add	a4,a4,a3
    80005b0e:	00371693          	slli	a3,a4,0x3
    80005b12:	00020717          	auipc	a4,0x20
    80005b16:	02e70713          	addi	a4,a4,46 # 80025b40 <timer_scratch>
    80005b1a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b1c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b1e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b20:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b24:	00000797          	auipc	a5,0x0
    80005b28:	99c78793          	addi	a5,a5,-1636 # 800054c0 <timervec>
    80005b2c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b30:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b34:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b38:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b3c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b40:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b44:	30479073          	csrw	mie,a5
}
    80005b48:	6422                	ld	s0,8(sp)
    80005b4a:	0141                	addi	sp,sp,16
    80005b4c:	8082                	ret

0000000080005b4e <start>:
{
    80005b4e:	1141                	addi	sp,sp,-16
    80005b50:	e406                	sd	ra,8(sp)
    80005b52:	e022                	sd	s0,0(sp)
    80005b54:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b56:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b5a:	7779                	lui	a4,0xffffe
    80005b5c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0a7f>
    80005b60:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b62:	6705                	lui	a4,0x1
    80005b64:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b68:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b6a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b6e:	ffffa797          	auipc	a5,0xffffa
    80005b72:	7b078793          	addi	a5,a5,1968 # 8000031e <main>
    80005b76:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b7a:	4781                	li	a5,0
    80005b7c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b80:	67c1                	lui	a5,0x10
    80005b82:	17fd                	addi	a5,a5,-1
    80005b84:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b88:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b8c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b90:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b94:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b98:	57fd                	li	a5,-1
    80005b9a:	83a9                	srli	a5,a5,0xa
    80005b9c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ba0:	47bd                	li	a5,15
    80005ba2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ba6:	00000097          	auipc	ra,0x0
    80005baa:	f36080e7          	jalr	-202(ra) # 80005adc <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bae:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bb2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bb4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bb6:	30200073          	mret
}
    80005bba:	60a2                	ld	ra,8(sp)
    80005bbc:	6402                	ld	s0,0(sp)
    80005bbe:	0141                	addi	sp,sp,16
    80005bc0:	8082                	ret

0000000080005bc2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bc2:	715d                	addi	sp,sp,-80
    80005bc4:	e486                	sd	ra,72(sp)
    80005bc6:	e0a2                	sd	s0,64(sp)
    80005bc8:	fc26                	sd	s1,56(sp)
    80005bca:	f84a                	sd	s2,48(sp)
    80005bcc:	f44e                	sd	s3,40(sp)
    80005bce:	f052                	sd	s4,32(sp)
    80005bd0:	ec56                	sd	s5,24(sp)
    80005bd2:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bd4:	04c05663          	blez	a2,80005c20 <consolewrite+0x5e>
    80005bd8:	8a2a                	mv	s4,a0
    80005bda:	84ae                	mv	s1,a1
    80005bdc:	89b2                	mv	s3,a2
    80005bde:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005be0:	5afd                	li	s5,-1
    80005be2:	4685                	li	a3,1
    80005be4:	8626                	mv	a2,s1
    80005be6:	85d2                	mv	a1,s4
    80005be8:	fbf40513          	addi	a0,s0,-65
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	db2080e7          	jalr	-590(ra) # 8000199e <either_copyin>
    80005bf4:	01550c63          	beq	a0,s5,80005c0c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005bf8:	fbf44503          	lbu	a0,-65(s0)
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	780080e7          	jalr	1920(ra) # 8000637c <uartputc>
  for(i = 0; i < n; i++){
    80005c04:	2905                	addiw	s2,s2,1
    80005c06:	0485                	addi	s1,s1,1
    80005c08:	fd299de3          	bne	s3,s2,80005be2 <consolewrite+0x20>
  }

  return i;
}
    80005c0c:	854a                	mv	a0,s2
    80005c0e:	60a6                	ld	ra,72(sp)
    80005c10:	6406                	ld	s0,64(sp)
    80005c12:	74e2                	ld	s1,56(sp)
    80005c14:	7942                	ld	s2,48(sp)
    80005c16:	79a2                	ld	s3,40(sp)
    80005c18:	7a02                	ld	s4,32(sp)
    80005c1a:	6ae2                	ld	s5,24(sp)
    80005c1c:	6161                	addi	sp,sp,80
    80005c1e:	8082                	ret
  for(i = 0; i < n; i++){
    80005c20:	4901                	li	s2,0
    80005c22:	b7ed                	j	80005c0c <consolewrite+0x4a>

0000000080005c24 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c24:	7159                	addi	sp,sp,-112
    80005c26:	f486                	sd	ra,104(sp)
    80005c28:	f0a2                	sd	s0,96(sp)
    80005c2a:	eca6                	sd	s1,88(sp)
    80005c2c:	e8ca                	sd	s2,80(sp)
    80005c2e:	e4ce                	sd	s3,72(sp)
    80005c30:	e0d2                	sd	s4,64(sp)
    80005c32:	fc56                	sd	s5,56(sp)
    80005c34:	f85a                	sd	s6,48(sp)
    80005c36:	f45e                	sd	s7,40(sp)
    80005c38:	f062                	sd	s8,32(sp)
    80005c3a:	ec66                	sd	s9,24(sp)
    80005c3c:	e86a                	sd	s10,16(sp)
    80005c3e:	1880                	addi	s0,sp,112
    80005c40:	8aaa                	mv	s5,a0
    80005c42:	8a2e                	mv	s4,a1
    80005c44:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c46:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c4a:	00028517          	auipc	a0,0x28
    80005c4e:	03650513          	addi	a0,a0,54 # 8002dc80 <cons>
    80005c52:	00001097          	auipc	ra,0x1
    80005c56:	8e8080e7          	jalr	-1816(ra) # 8000653a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c5a:	00028497          	auipc	s1,0x28
    80005c5e:	02648493          	addi	s1,s1,38 # 8002dc80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c62:	00028917          	auipc	s2,0x28
    80005c66:	0b690913          	addi	s2,s2,182 # 8002dd18 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c6a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c6c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c6e:	4ca9                	li	s9,10
  while(n > 0){
    80005c70:	07305b63          	blez	s3,80005ce6 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005c74:	0984a783          	lw	a5,152(s1)
    80005c78:	09c4a703          	lw	a4,156(s1)
    80005c7c:	02f71763          	bne	a4,a5,80005caa <consoleread+0x86>
      if(killed(myproc())){
    80005c80:	ffffb097          	auipc	ra,0xffffb
    80005c84:	1b8080e7          	jalr	440(ra) # 80000e38 <myproc>
    80005c88:	ffffc097          	auipc	ra,0xffffc
    80005c8c:	b60080e7          	jalr	-1184(ra) # 800017e8 <killed>
    80005c90:	e535                	bnez	a0,80005cfc <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005c92:	85a6                	mv	a1,s1
    80005c94:	854a                	mv	a0,s2
    80005c96:	ffffc097          	auipc	ra,0xffffc
    80005c9a:	8aa080e7          	jalr	-1878(ra) # 80001540 <sleep>
    while(cons.r == cons.w){
    80005c9e:	0984a783          	lw	a5,152(s1)
    80005ca2:	09c4a703          	lw	a4,156(s1)
    80005ca6:	fcf70de3          	beq	a4,a5,80005c80 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005caa:	0017871b          	addiw	a4,a5,1
    80005cae:	08e4ac23          	sw	a4,152(s1)
    80005cb2:	07f7f713          	andi	a4,a5,127
    80005cb6:	9726                	add	a4,a4,s1
    80005cb8:	01874703          	lbu	a4,24(a4)
    80005cbc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005cc0:	077d0563          	beq	s10,s7,80005d2a <consoleread+0x106>
    cbuf = c;
    80005cc4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cc8:	4685                	li	a3,1
    80005cca:	f9f40613          	addi	a2,s0,-97
    80005cce:	85d2                	mv	a1,s4
    80005cd0:	8556                	mv	a0,s5
    80005cd2:	ffffc097          	auipc	ra,0xffffc
    80005cd6:	c76080e7          	jalr	-906(ra) # 80001948 <either_copyout>
    80005cda:	01850663          	beq	a0,s8,80005ce6 <consoleread+0xc2>
    dst++;
    80005cde:	0a05                	addi	s4,s4,1
    --n;
    80005ce0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005ce2:	f99d17e3          	bne	s10,s9,80005c70 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ce6:	00028517          	auipc	a0,0x28
    80005cea:	f9a50513          	addi	a0,a0,-102 # 8002dc80 <cons>
    80005cee:	00001097          	auipc	ra,0x1
    80005cf2:	900080e7          	jalr	-1792(ra) # 800065ee <release>

  return target - n;
    80005cf6:	413b053b          	subw	a0,s6,s3
    80005cfa:	a811                	j	80005d0e <consoleread+0xea>
        release(&cons.lock);
    80005cfc:	00028517          	auipc	a0,0x28
    80005d00:	f8450513          	addi	a0,a0,-124 # 8002dc80 <cons>
    80005d04:	00001097          	auipc	ra,0x1
    80005d08:	8ea080e7          	jalr	-1814(ra) # 800065ee <release>
        return -1;
    80005d0c:	557d                	li	a0,-1
}
    80005d0e:	70a6                	ld	ra,104(sp)
    80005d10:	7406                	ld	s0,96(sp)
    80005d12:	64e6                	ld	s1,88(sp)
    80005d14:	6946                	ld	s2,80(sp)
    80005d16:	69a6                	ld	s3,72(sp)
    80005d18:	6a06                	ld	s4,64(sp)
    80005d1a:	7ae2                	ld	s5,56(sp)
    80005d1c:	7b42                	ld	s6,48(sp)
    80005d1e:	7ba2                	ld	s7,40(sp)
    80005d20:	7c02                	ld	s8,32(sp)
    80005d22:	6ce2                	ld	s9,24(sp)
    80005d24:	6d42                	ld	s10,16(sp)
    80005d26:	6165                	addi	sp,sp,112
    80005d28:	8082                	ret
      if(n < target){
    80005d2a:	0009871b          	sext.w	a4,s3
    80005d2e:	fb677ce3          	bgeu	a4,s6,80005ce6 <consoleread+0xc2>
        cons.r--;
    80005d32:	00028717          	auipc	a4,0x28
    80005d36:	fef72323          	sw	a5,-26(a4) # 8002dd18 <cons+0x98>
    80005d3a:	b775                	j	80005ce6 <consoleread+0xc2>

0000000080005d3c <consputc>:
{
    80005d3c:	1141                	addi	sp,sp,-16
    80005d3e:	e406                	sd	ra,8(sp)
    80005d40:	e022                	sd	s0,0(sp)
    80005d42:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d44:	10000793          	li	a5,256
    80005d48:	00f50a63          	beq	a0,a5,80005d5c <consputc+0x20>
    uartputc_sync(c);
    80005d4c:	00000097          	auipc	ra,0x0
    80005d50:	55e080e7          	jalr	1374(ra) # 800062aa <uartputc_sync>
}
    80005d54:	60a2                	ld	ra,8(sp)
    80005d56:	6402                	ld	s0,0(sp)
    80005d58:	0141                	addi	sp,sp,16
    80005d5a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d5c:	4521                	li	a0,8
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	54c080e7          	jalr	1356(ra) # 800062aa <uartputc_sync>
    80005d66:	02000513          	li	a0,32
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	540080e7          	jalr	1344(ra) # 800062aa <uartputc_sync>
    80005d72:	4521                	li	a0,8
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	536080e7          	jalr	1334(ra) # 800062aa <uartputc_sync>
    80005d7c:	bfe1                	j	80005d54 <consputc+0x18>

0000000080005d7e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d7e:	1101                	addi	sp,sp,-32
    80005d80:	ec06                	sd	ra,24(sp)
    80005d82:	e822                	sd	s0,16(sp)
    80005d84:	e426                	sd	s1,8(sp)
    80005d86:	e04a                	sd	s2,0(sp)
    80005d88:	1000                	addi	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d8c:	00028517          	auipc	a0,0x28
    80005d90:	ef450513          	addi	a0,a0,-268 # 8002dc80 <cons>
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	7a6080e7          	jalr	1958(ra) # 8000653a <acquire>

  switch(c){
    80005d9c:	47d5                	li	a5,21
    80005d9e:	0af48663          	beq	s1,a5,80005e4a <consoleintr+0xcc>
    80005da2:	0297ca63          	blt	a5,s1,80005dd6 <consoleintr+0x58>
    80005da6:	47a1                	li	a5,8
    80005da8:	0ef48763          	beq	s1,a5,80005e96 <consoleintr+0x118>
    80005dac:	47c1                	li	a5,16
    80005dae:	10f49a63          	bne	s1,a5,80005ec2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005db2:	ffffc097          	auipc	ra,0xffffc
    80005db6:	c42080e7          	jalr	-958(ra) # 800019f4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dba:	00028517          	auipc	a0,0x28
    80005dbe:	ec650513          	addi	a0,a0,-314 # 8002dc80 <cons>
    80005dc2:	00001097          	auipc	ra,0x1
    80005dc6:	82c080e7          	jalr	-2004(ra) # 800065ee <release>
}
    80005dca:	60e2                	ld	ra,24(sp)
    80005dcc:	6442                	ld	s0,16(sp)
    80005dce:	64a2                	ld	s1,8(sp)
    80005dd0:	6902                	ld	s2,0(sp)
    80005dd2:	6105                	addi	sp,sp,32
    80005dd4:	8082                	ret
  switch(c){
    80005dd6:	07f00793          	li	a5,127
    80005dda:	0af48e63          	beq	s1,a5,80005e96 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005dde:	00028717          	auipc	a4,0x28
    80005de2:	ea270713          	addi	a4,a4,-350 # 8002dc80 <cons>
    80005de6:	0a072783          	lw	a5,160(a4)
    80005dea:	09872703          	lw	a4,152(a4)
    80005dee:	9f99                	subw	a5,a5,a4
    80005df0:	07f00713          	li	a4,127
    80005df4:	fcf763e3          	bltu	a4,a5,80005dba <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005df8:	47b5                	li	a5,13
    80005dfa:	0cf48763          	beq	s1,a5,80005ec8 <consoleintr+0x14a>
      consputc(c);
    80005dfe:	8526                	mv	a0,s1
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	f3c080e7          	jalr	-196(ra) # 80005d3c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e08:	00028797          	auipc	a5,0x28
    80005e0c:	e7878793          	addi	a5,a5,-392 # 8002dc80 <cons>
    80005e10:	0a07a683          	lw	a3,160(a5)
    80005e14:	0016871b          	addiw	a4,a3,1
    80005e18:	0007061b          	sext.w	a2,a4
    80005e1c:	0ae7a023          	sw	a4,160(a5)
    80005e20:	07f6f693          	andi	a3,a3,127
    80005e24:	97b6                	add	a5,a5,a3
    80005e26:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e2a:	47a9                	li	a5,10
    80005e2c:	0cf48563          	beq	s1,a5,80005ef6 <consoleintr+0x178>
    80005e30:	4791                	li	a5,4
    80005e32:	0cf48263          	beq	s1,a5,80005ef6 <consoleintr+0x178>
    80005e36:	00028797          	auipc	a5,0x28
    80005e3a:	ee27a783          	lw	a5,-286(a5) # 8002dd18 <cons+0x98>
    80005e3e:	9f1d                	subw	a4,a4,a5
    80005e40:	08000793          	li	a5,128
    80005e44:	f6f71be3          	bne	a4,a5,80005dba <consoleintr+0x3c>
    80005e48:	a07d                	j	80005ef6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e4a:	00028717          	auipc	a4,0x28
    80005e4e:	e3670713          	addi	a4,a4,-458 # 8002dc80 <cons>
    80005e52:	0a072783          	lw	a5,160(a4)
    80005e56:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e5a:	00028497          	auipc	s1,0x28
    80005e5e:	e2648493          	addi	s1,s1,-474 # 8002dc80 <cons>
    while(cons.e != cons.w &&
    80005e62:	4929                	li	s2,10
    80005e64:	f4f70be3          	beq	a4,a5,80005dba <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e68:	37fd                	addiw	a5,a5,-1
    80005e6a:	07f7f713          	andi	a4,a5,127
    80005e6e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e70:	01874703          	lbu	a4,24(a4)
    80005e74:	f52703e3          	beq	a4,s2,80005dba <consoleintr+0x3c>
      cons.e--;
    80005e78:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e7c:	10000513          	li	a0,256
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	ebc080e7          	jalr	-324(ra) # 80005d3c <consputc>
    while(cons.e != cons.w &&
    80005e88:	0a04a783          	lw	a5,160(s1)
    80005e8c:	09c4a703          	lw	a4,156(s1)
    80005e90:	fcf71ce3          	bne	a4,a5,80005e68 <consoleintr+0xea>
    80005e94:	b71d                	j	80005dba <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e96:	00028717          	auipc	a4,0x28
    80005e9a:	dea70713          	addi	a4,a4,-534 # 8002dc80 <cons>
    80005e9e:	0a072783          	lw	a5,160(a4)
    80005ea2:	09c72703          	lw	a4,156(a4)
    80005ea6:	f0f70ae3          	beq	a4,a5,80005dba <consoleintr+0x3c>
      cons.e--;
    80005eaa:	37fd                	addiw	a5,a5,-1
    80005eac:	00028717          	auipc	a4,0x28
    80005eb0:	e6f72a23          	sw	a5,-396(a4) # 8002dd20 <cons+0xa0>
      consputc(BACKSPACE);
    80005eb4:	10000513          	li	a0,256
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	e84080e7          	jalr	-380(ra) # 80005d3c <consputc>
    80005ec0:	bded                	j	80005dba <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ec2:	ee048ce3          	beqz	s1,80005dba <consoleintr+0x3c>
    80005ec6:	bf21                	j	80005dde <consoleintr+0x60>
      consputc(c);
    80005ec8:	4529                	li	a0,10
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	e72080e7          	jalr	-398(ra) # 80005d3c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ed2:	00028797          	auipc	a5,0x28
    80005ed6:	dae78793          	addi	a5,a5,-594 # 8002dc80 <cons>
    80005eda:	0a07a703          	lw	a4,160(a5)
    80005ede:	0017069b          	addiw	a3,a4,1
    80005ee2:	0006861b          	sext.w	a2,a3
    80005ee6:	0ad7a023          	sw	a3,160(a5)
    80005eea:	07f77713          	andi	a4,a4,127
    80005eee:	97ba                	add	a5,a5,a4
    80005ef0:	4729                	li	a4,10
    80005ef2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ef6:	00028797          	auipc	a5,0x28
    80005efa:	e2c7a323          	sw	a2,-474(a5) # 8002dd1c <cons+0x9c>
        wakeup(&cons.r);
    80005efe:	00028517          	auipc	a0,0x28
    80005f02:	e1a50513          	addi	a0,a0,-486 # 8002dd18 <cons+0x98>
    80005f06:	ffffb097          	auipc	ra,0xffffb
    80005f0a:	69e080e7          	jalr	1694(ra) # 800015a4 <wakeup>
    80005f0e:	b575                	j	80005dba <consoleintr+0x3c>

0000000080005f10 <consoleinit>:

void
consoleinit(void)
{
    80005f10:	1141                	addi	sp,sp,-16
    80005f12:	e406                	sd	ra,8(sp)
    80005f14:	e022                	sd	s0,0(sp)
    80005f16:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f18:	00003597          	auipc	a1,0x3
    80005f1c:	8f058593          	addi	a1,a1,-1808 # 80008808 <syscalls+0x408>
    80005f20:	00028517          	auipc	a0,0x28
    80005f24:	d6050513          	addi	a0,a0,-672 # 8002dc80 <cons>
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	582080e7          	jalr	1410(ra) # 800064aa <initlock>

  uartinit();
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	32a080e7          	jalr	810(ra) # 8000625a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f38:	0001f797          	auipc	a5,0x1f
    80005f3c:	a7078793          	addi	a5,a5,-1424 # 800249a8 <devsw>
    80005f40:	00000717          	auipc	a4,0x0
    80005f44:	ce470713          	addi	a4,a4,-796 # 80005c24 <consoleread>
    80005f48:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f4a:	00000717          	auipc	a4,0x0
    80005f4e:	c7870713          	addi	a4,a4,-904 # 80005bc2 <consolewrite>
    80005f52:	ef98                	sd	a4,24(a5)
}
    80005f54:	60a2                	ld	ra,8(sp)
    80005f56:	6402                	ld	s0,0(sp)
    80005f58:	0141                	addi	sp,sp,16
    80005f5a:	8082                	ret

0000000080005f5c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f5c:	7179                	addi	sp,sp,-48
    80005f5e:	f406                	sd	ra,40(sp)
    80005f60:	f022                	sd	s0,32(sp)
    80005f62:	ec26                	sd	s1,24(sp)
    80005f64:	e84a                	sd	s2,16(sp)
    80005f66:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f68:	c219                	beqz	a2,80005f6e <printint+0x12>
    80005f6a:	08054663          	bltz	a0,80005ff6 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f6e:	2501                	sext.w	a0,a0
    80005f70:	4881                	li	a7,0
    80005f72:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f76:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f78:	2581                	sext.w	a1,a1
    80005f7a:	00003617          	auipc	a2,0x3
    80005f7e:	8be60613          	addi	a2,a2,-1858 # 80008838 <digits>
    80005f82:	883a                	mv	a6,a4
    80005f84:	2705                	addiw	a4,a4,1
    80005f86:	02b577bb          	remuw	a5,a0,a1
    80005f8a:	1782                	slli	a5,a5,0x20
    80005f8c:	9381                	srli	a5,a5,0x20
    80005f8e:	97b2                	add	a5,a5,a2
    80005f90:	0007c783          	lbu	a5,0(a5)
    80005f94:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f98:	0005079b          	sext.w	a5,a0
    80005f9c:	02b5553b          	divuw	a0,a0,a1
    80005fa0:	0685                	addi	a3,a3,1
    80005fa2:	feb7f0e3          	bgeu	a5,a1,80005f82 <printint+0x26>

  if(sign)
    80005fa6:	00088b63          	beqz	a7,80005fbc <printint+0x60>
    buf[i++] = '-';
    80005faa:	fe040793          	addi	a5,s0,-32
    80005fae:	973e                	add	a4,a4,a5
    80005fb0:	02d00793          	li	a5,45
    80005fb4:	fef70823          	sb	a5,-16(a4)
    80005fb8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fbc:	02e05763          	blez	a4,80005fea <printint+0x8e>
    80005fc0:	fd040793          	addi	a5,s0,-48
    80005fc4:	00e784b3          	add	s1,a5,a4
    80005fc8:	fff78913          	addi	s2,a5,-1
    80005fcc:	993a                	add	s2,s2,a4
    80005fce:	377d                	addiw	a4,a4,-1
    80005fd0:	1702                	slli	a4,a4,0x20
    80005fd2:	9301                	srli	a4,a4,0x20
    80005fd4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fd8:	fff4c503          	lbu	a0,-1(s1)
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	d60080e7          	jalr	-672(ra) # 80005d3c <consputc>
  while(--i >= 0)
    80005fe4:	14fd                	addi	s1,s1,-1
    80005fe6:	ff2499e3          	bne	s1,s2,80005fd8 <printint+0x7c>
}
    80005fea:	70a2                	ld	ra,40(sp)
    80005fec:	7402                	ld	s0,32(sp)
    80005fee:	64e2                	ld	s1,24(sp)
    80005ff0:	6942                	ld	s2,16(sp)
    80005ff2:	6145                	addi	sp,sp,48
    80005ff4:	8082                	ret
    x = -xx;
    80005ff6:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ffa:	4885                	li	a7,1
    x = -xx;
    80005ffc:	bf9d                	j	80005f72 <printint+0x16>

0000000080005ffe <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ffe:	1101                	addi	sp,sp,-32
    80006000:	ec06                	sd	ra,24(sp)
    80006002:	e822                	sd	s0,16(sp)
    80006004:	e426                	sd	s1,8(sp)
    80006006:	1000                	addi	s0,sp,32
    80006008:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000600a:	00028797          	auipc	a5,0x28
    8000600e:	d207ab23          	sw	zero,-714(a5) # 8002dd40 <pr+0x18>
  printf("panic: ");
    80006012:	00002517          	auipc	a0,0x2
    80006016:	7fe50513          	addi	a0,a0,2046 # 80008810 <syscalls+0x410>
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	02e080e7          	jalr	46(ra) # 80006048 <printf>
  printf(s);
    80006022:	8526                	mv	a0,s1
    80006024:	00000097          	auipc	ra,0x0
    80006028:	024080e7          	jalr	36(ra) # 80006048 <printf>
  printf("\n");
    8000602c:	00002517          	auipc	a0,0x2
    80006030:	01c50513          	addi	a0,a0,28 # 80008048 <etext+0x48>
    80006034:	00000097          	auipc	ra,0x0
    80006038:	014080e7          	jalr	20(ra) # 80006048 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000603c:	4785                	li	a5,1
    8000603e:	00003717          	auipc	a4,0x3
    80006042:	8af72f23          	sw	a5,-1858(a4) # 800088fc <panicked>
  for(;;)
    80006046:	a001                	j	80006046 <panic+0x48>

0000000080006048 <printf>:
{
    80006048:	7131                	addi	sp,sp,-192
    8000604a:	fc86                	sd	ra,120(sp)
    8000604c:	f8a2                	sd	s0,112(sp)
    8000604e:	f4a6                	sd	s1,104(sp)
    80006050:	f0ca                	sd	s2,96(sp)
    80006052:	ecce                	sd	s3,88(sp)
    80006054:	e8d2                	sd	s4,80(sp)
    80006056:	e4d6                	sd	s5,72(sp)
    80006058:	e0da                	sd	s6,64(sp)
    8000605a:	fc5e                	sd	s7,56(sp)
    8000605c:	f862                	sd	s8,48(sp)
    8000605e:	f466                	sd	s9,40(sp)
    80006060:	f06a                	sd	s10,32(sp)
    80006062:	ec6e                	sd	s11,24(sp)
    80006064:	0100                	addi	s0,sp,128
    80006066:	8a2a                	mv	s4,a0
    80006068:	e40c                	sd	a1,8(s0)
    8000606a:	e810                	sd	a2,16(s0)
    8000606c:	ec14                	sd	a3,24(s0)
    8000606e:	f018                	sd	a4,32(s0)
    80006070:	f41c                	sd	a5,40(s0)
    80006072:	03043823          	sd	a6,48(s0)
    80006076:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000607a:	00028d97          	auipc	s11,0x28
    8000607e:	cc6dad83          	lw	s11,-826(s11) # 8002dd40 <pr+0x18>
  if(locking)
    80006082:	020d9b63          	bnez	s11,800060b8 <printf+0x70>
  if (fmt == 0)
    80006086:	040a0263          	beqz	s4,800060ca <printf+0x82>
  va_start(ap, fmt);
    8000608a:	00840793          	addi	a5,s0,8
    8000608e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006092:	000a4503          	lbu	a0,0(s4)
    80006096:	14050f63          	beqz	a0,800061f4 <printf+0x1ac>
    8000609a:	4981                	li	s3,0
    if(c != '%'){
    8000609c:	02500a93          	li	s5,37
    switch(c){
    800060a0:	07000b93          	li	s7,112
  consputc('x');
    800060a4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060a6:	00002b17          	auipc	s6,0x2
    800060aa:	792b0b13          	addi	s6,s6,1938 # 80008838 <digits>
    switch(c){
    800060ae:	07300c93          	li	s9,115
    800060b2:	06400c13          	li	s8,100
    800060b6:	a82d                	j	800060f0 <printf+0xa8>
    acquire(&pr.lock);
    800060b8:	00028517          	auipc	a0,0x28
    800060bc:	c7050513          	addi	a0,a0,-912 # 8002dd28 <pr>
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	47a080e7          	jalr	1146(ra) # 8000653a <acquire>
    800060c8:	bf7d                	j	80006086 <printf+0x3e>
    panic("null fmt");
    800060ca:	00002517          	auipc	a0,0x2
    800060ce:	75650513          	addi	a0,a0,1878 # 80008820 <syscalls+0x420>
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	f2c080e7          	jalr	-212(ra) # 80005ffe <panic>
      consputc(c);
    800060da:	00000097          	auipc	ra,0x0
    800060de:	c62080e7          	jalr	-926(ra) # 80005d3c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060e2:	2985                	addiw	s3,s3,1
    800060e4:	013a07b3          	add	a5,s4,s3
    800060e8:	0007c503          	lbu	a0,0(a5)
    800060ec:	10050463          	beqz	a0,800061f4 <printf+0x1ac>
    if(c != '%'){
    800060f0:	ff5515e3          	bne	a0,s5,800060da <printf+0x92>
    c = fmt[++i] & 0xff;
    800060f4:	2985                	addiw	s3,s3,1
    800060f6:	013a07b3          	add	a5,s4,s3
    800060fa:	0007c783          	lbu	a5,0(a5)
    800060fe:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006102:	cbed                	beqz	a5,800061f4 <printf+0x1ac>
    switch(c){
    80006104:	05778a63          	beq	a5,s7,80006158 <printf+0x110>
    80006108:	02fbf663          	bgeu	s7,a5,80006134 <printf+0xec>
    8000610c:	09978863          	beq	a5,s9,8000619c <printf+0x154>
    80006110:	07800713          	li	a4,120
    80006114:	0ce79563          	bne	a5,a4,800061de <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006118:	f8843783          	ld	a5,-120(s0)
    8000611c:	00878713          	addi	a4,a5,8
    80006120:	f8e43423          	sd	a4,-120(s0)
    80006124:	4605                	li	a2,1
    80006126:	85ea                	mv	a1,s10
    80006128:	4388                	lw	a0,0(a5)
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	e32080e7          	jalr	-462(ra) # 80005f5c <printint>
      break;
    80006132:	bf45                	j	800060e2 <printf+0x9a>
    switch(c){
    80006134:	09578f63          	beq	a5,s5,800061d2 <printf+0x18a>
    80006138:	0b879363          	bne	a5,s8,800061de <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000613c:	f8843783          	ld	a5,-120(s0)
    80006140:	00878713          	addi	a4,a5,8
    80006144:	f8e43423          	sd	a4,-120(s0)
    80006148:	4605                	li	a2,1
    8000614a:	45a9                	li	a1,10
    8000614c:	4388                	lw	a0,0(a5)
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	e0e080e7          	jalr	-498(ra) # 80005f5c <printint>
      break;
    80006156:	b771                	j	800060e2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006158:	f8843783          	ld	a5,-120(s0)
    8000615c:	00878713          	addi	a4,a5,8
    80006160:	f8e43423          	sd	a4,-120(s0)
    80006164:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006168:	03000513          	li	a0,48
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	bd0080e7          	jalr	-1072(ra) # 80005d3c <consputc>
  consputc('x');
    80006174:	07800513          	li	a0,120
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	bc4080e7          	jalr	-1084(ra) # 80005d3c <consputc>
    80006180:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006182:	03c95793          	srli	a5,s2,0x3c
    80006186:	97da                	add	a5,a5,s6
    80006188:	0007c503          	lbu	a0,0(a5)
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	bb0080e7          	jalr	-1104(ra) # 80005d3c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006194:	0912                	slli	s2,s2,0x4
    80006196:	34fd                	addiw	s1,s1,-1
    80006198:	f4ed                	bnez	s1,80006182 <printf+0x13a>
    8000619a:	b7a1                	j	800060e2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000619c:	f8843783          	ld	a5,-120(s0)
    800061a0:	00878713          	addi	a4,a5,8
    800061a4:	f8e43423          	sd	a4,-120(s0)
    800061a8:	6384                	ld	s1,0(a5)
    800061aa:	cc89                	beqz	s1,800061c4 <printf+0x17c>
      for(; *s; s++)
    800061ac:	0004c503          	lbu	a0,0(s1)
    800061b0:	d90d                	beqz	a0,800060e2 <printf+0x9a>
        consputc(*s);
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	b8a080e7          	jalr	-1142(ra) # 80005d3c <consputc>
      for(; *s; s++)
    800061ba:	0485                	addi	s1,s1,1
    800061bc:	0004c503          	lbu	a0,0(s1)
    800061c0:	f96d                	bnez	a0,800061b2 <printf+0x16a>
    800061c2:	b705                	j	800060e2 <printf+0x9a>
        s = "(null)";
    800061c4:	00002497          	auipc	s1,0x2
    800061c8:	65448493          	addi	s1,s1,1620 # 80008818 <syscalls+0x418>
      for(; *s; s++)
    800061cc:	02800513          	li	a0,40
    800061d0:	b7cd                	j	800061b2 <printf+0x16a>
      consputc('%');
    800061d2:	8556                	mv	a0,s5
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	b68080e7          	jalr	-1176(ra) # 80005d3c <consputc>
      break;
    800061dc:	b719                	j	800060e2 <printf+0x9a>
      consputc('%');
    800061de:	8556                	mv	a0,s5
    800061e0:	00000097          	auipc	ra,0x0
    800061e4:	b5c080e7          	jalr	-1188(ra) # 80005d3c <consputc>
      consputc(c);
    800061e8:	8526                	mv	a0,s1
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	b52080e7          	jalr	-1198(ra) # 80005d3c <consputc>
      break;
    800061f2:	bdc5                	j	800060e2 <printf+0x9a>
  if(locking)
    800061f4:	020d9163          	bnez	s11,80006216 <printf+0x1ce>
}
    800061f8:	70e6                	ld	ra,120(sp)
    800061fa:	7446                	ld	s0,112(sp)
    800061fc:	74a6                	ld	s1,104(sp)
    800061fe:	7906                	ld	s2,96(sp)
    80006200:	69e6                	ld	s3,88(sp)
    80006202:	6a46                	ld	s4,80(sp)
    80006204:	6aa6                	ld	s5,72(sp)
    80006206:	6b06                	ld	s6,64(sp)
    80006208:	7be2                	ld	s7,56(sp)
    8000620a:	7c42                	ld	s8,48(sp)
    8000620c:	7ca2                	ld	s9,40(sp)
    8000620e:	7d02                	ld	s10,32(sp)
    80006210:	6de2                	ld	s11,24(sp)
    80006212:	6129                	addi	sp,sp,192
    80006214:	8082                	ret
    release(&pr.lock);
    80006216:	00028517          	auipc	a0,0x28
    8000621a:	b1250513          	addi	a0,a0,-1262 # 8002dd28 <pr>
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	3d0080e7          	jalr	976(ra) # 800065ee <release>
}
    80006226:	bfc9                	j	800061f8 <printf+0x1b0>

0000000080006228 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006228:	1101                	addi	sp,sp,-32
    8000622a:	ec06                	sd	ra,24(sp)
    8000622c:	e822                	sd	s0,16(sp)
    8000622e:	e426                	sd	s1,8(sp)
    80006230:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006232:	00028497          	auipc	s1,0x28
    80006236:	af648493          	addi	s1,s1,-1290 # 8002dd28 <pr>
    8000623a:	00002597          	auipc	a1,0x2
    8000623e:	5f658593          	addi	a1,a1,1526 # 80008830 <syscalls+0x430>
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	266080e7          	jalr	614(ra) # 800064aa <initlock>
  pr.locking = 1;
    8000624c:	4785                	li	a5,1
    8000624e:	cc9c                	sw	a5,24(s1)
}
    80006250:	60e2                	ld	ra,24(sp)
    80006252:	6442                	ld	s0,16(sp)
    80006254:	64a2                	ld	s1,8(sp)
    80006256:	6105                	addi	sp,sp,32
    80006258:	8082                	ret

000000008000625a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000625a:	1141                	addi	sp,sp,-16
    8000625c:	e406                	sd	ra,8(sp)
    8000625e:	e022                	sd	s0,0(sp)
    80006260:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006262:	100007b7          	lui	a5,0x10000
    80006266:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000626a:	f8000713          	li	a4,-128
    8000626e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006272:	470d                	li	a4,3
    80006274:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006278:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000627c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006280:	469d                	li	a3,7
    80006282:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006286:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000628a:	00002597          	auipc	a1,0x2
    8000628e:	5c658593          	addi	a1,a1,1478 # 80008850 <digits+0x18>
    80006292:	00028517          	auipc	a0,0x28
    80006296:	ab650513          	addi	a0,a0,-1354 # 8002dd48 <uart_tx_lock>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	210080e7          	jalr	528(ra) # 800064aa <initlock>
}
    800062a2:	60a2                	ld	ra,8(sp)
    800062a4:	6402                	ld	s0,0(sp)
    800062a6:	0141                	addi	sp,sp,16
    800062a8:	8082                	ret

00000000800062aa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062aa:	1101                	addi	sp,sp,-32
    800062ac:	ec06                	sd	ra,24(sp)
    800062ae:	e822                	sd	s0,16(sp)
    800062b0:	e426                	sd	s1,8(sp)
    800062b2:	1000                	addi	s0,sp,32
    800062b4:	84aa                	mv	s1,a0
  push_off();
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	238080e7          	jalr	568(ra) # 800064ee <push_off>

  if(panicked){
    800062be:	00002797          	auipc	a5,0x2
    800062c2:	63e7a783          	lw	a5,1598(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062c6:	10000737          	lui	a4,0x10000
  if(panicked){
    800062ca:	c391                	beqz	a5,800062ce <uartputc_sync+0x24>
    for(;;)
    800062cc:	a001                	j	800062cc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062ce:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062d2:	0207f793          	andi	a5,a5,32
    800062d6:	dfe5                	beqz	a5,800062ce <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062d8:	0ff4f513          	zext.b	a0,s1
    800062dc:	100007b7          	lui	a5,0x10000
    800062e0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	2aa080e7          	jalr	682(ra) # 8000658e <pop_off>
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	addi	sp,sp,32
    800062f4:	8082                	ret

00000000800062f6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062f6:	00002797          	auipc	a5,0x2
    800062fa:	60a7b783          	ld	a5,1546(a5) # 80008900 <uart_tx_r>
    800062fe:	00002717          	auipc	a4,0x2
    80006302:	60a73703          	ld	a4,1546(a4) # 80008908 <uart_tx_w>
    80006306:	06f70a63          	beq	a4,a5,8000637a <uartstart+0x84>
{
    8000630a:	7139                	addi	sp,sp,-64
    8000630c:	fc06                	sd	ra,56(sp)
    8000630e:	f822                	sd	s0,48(sp)
    80006310:	f426                	sd	s1,40(sp)
    80006312:	f04a                	sd	s2,32(sp)
    80006314:	ec4e                	sd	s3,24(sp)
    80006316:	e852                	sd	s4,16(sp)
    80006318:	e456                	sd	s5,8(sp)
    8000631a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000631c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006320:	00028a17          	auipc	s4,0x28
    80006324:	a28a0a13          	addi	s4,s4,-1496 # 8002dd48 <uart_tx_lock>
    uart_tx_r += 1;
    80006328:	00002497          	auipc	s1,0x2
    8000632c:	5d848493          	addi	s1,s1,1496 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006330:	00002997          	auipc	s3,0x2
    80006334:	5d898993          	addi	s3,s3,1496 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006338:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000633c:	02077713          	andi	a4,a4,32
    80006340:	c705                	beqz	a4,80006368 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006342:	01f7f713          	andi	a4,a5,31
    80006346:	9752                	add	a4,a4,s4
    80006348:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000634c:	0785                	addi	a5,a5,1
    8000634e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006350:	8526                	mv	a0,s1
    80006352:	ffffb097          	auipc	ra,0xffffb
    80006356:	252080e7          	jalr	594(ra) # 800015a4 <wakeup>
    
    WriteReg(THR, c);
    8000635a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000635e:	609c                	ld	a5,0(s1)
    80006360:	0009b703          	ld	a4,0(s3)
    80006364:	fcf71ae3          	bne	a4,a5,80006338 <uartstart+0x42>
  }
}
    80006368:	70e2                	ld	ra,56(sp)
    8000636a:	7442                	ld	s0,48(sp)
    8000636c:	74a2                	ld	s1,40(sp)
    8000636e:	7902                	ld	s2,32(sp)
    80006370:	69e2                	ld	s3,24(sp)
    80006372:	6a42                	ld	s4,16(sp)
    80006374:	6aa2                	ld	s5,8(sp)
    80006376:	6121                	addi	sp,sp,64
    80006378:	8082                	ret
    8000637a:	8082                	ret

000000008000637c <uartputc>:
{
    8000637c:	7179                	addi	sp,sp,-48
    8000637e:	f406                	sd	ra,40(sp)
    80006380:	f022                	sd	s0,32(sp)
    80006382:	ec26                	sd	s1,24(sp)
    80006384:	e84a                	sd	s2,16(sp)
    80006386:	e44e                	sd	s3,8(sp)
    80006388:	e052                	sd	s4,0(sp)
    8000638a:	1800                	addi	s0,sp,48
    8000638c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000638e:	00028517          	auipc	a0,0x28
    80006392:	9ba50513          	addi	a0,a0,-1606 # 8002dd48 <uart_tx_lock>
    80006396:	00000097          	auipc	ra,0x0
    8000639a:	1a4080e7          	jalr	420(ra) # 8000653a <acquire>
  if(panicked){
    8000639e:	00002797          	auipc	a5,0x2
    800063a2:	55e7a783          	lw	a5,1374(a5) # 800088fc <panicked>
    800063a6:	e7c9                	bnez	a5,80006430 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063a8:	00002717          	auipc	a4,0x2
    800063ac:	56073703          	ld	a4,1376(a4) # 80008908 <uart_tx_w>
    800063b0:	00002797          	auipc	a5,0x2
    800063b4:	5507b783          	ld	a5,1360(a5) # 80008900 <uart_tx_r>
    800063b8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063bc:	00028997          	auipc	s3,0x28
    800063c0:	98c98993          	addi	s3,s3,-1652 # 8002dd48 <uart_tx_lock>
    800063c4:	00002497          	auipc	s1,0x2
    800063c8:	53c48493          	addi	s1,s1,1340 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063cc:	00002917          	auipc	s2,0x2
    800063d0:	53c90913          	addi	s2,s2,1340 # 80008908 <uart_tx_w>
    800063d4:	00e79f63          	bne	a5,a4,800063f2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800063d8:	85ce                	mv	a1,s3
    800063da:	8526                	mv	a0,s1
    800063dc:	ffffb097          	auipc	ra,0xffffb
    800063e0:	164080e7          	jalr	356(ra) # 80001540 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063e4:	00093703          	ld	a4,0(s2)
    800063e8:	609c                	ld	a5,0(s1)
    800063ea:	02078793          	addi	a5,a5,32
    800063ee:	fee785e3          	beq	a5,a4,800063d8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063f2:	00028497          	auipc	s1,0x28
    800063f6:	95648493          	addi	s1,s1,-1706 # 8002dd48 <uart_tx_lock>
    800063fa:	01f77793          	andi	a5,a4,31
    800063fe:	97a6                	add	a5,a5,s1
    80006400:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006404:	0705                	addi	a4,a4,1
    80006406:	00002797          	auipc	a5,0x2
    8000640a:	50e7b123          	sd	a4,1282(a5) # 80008908 <uart_tx_w>
  uartstart();
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	ee8080e7          	jalr	-280(ra) # 800062f6 <uartstart>
  release(&uart_tx_lock);
    80006416:	8526                	mv	a0,s1
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	1d6080e7          	jalr	470(ra) # 800065ee <release>
}
    80006420:	70a2                	ld	ra,40(sp)
    80006422:	7402                	ld	s0,32(sp)
    80006424:	64e2                	ld	s1,24(sp)
    80006426:	6942                	ld	s2,16(sp)
    80006428:	69a2                	ld	s3,8(sp)
    8000642a:	6a02                	ld	s4,0(sp)
    8000642c:	6145                	addi	sp,sp,48
    8000642e:	8082                	ret
    for(;;)
    80006430:	a001                	j	80006430 <uartputc+0xb4>

0000000080006432 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006432:	1141                	addi	sp,sp,-16
    80006434:	e422                	sd	s0,8(sp)
    80006436:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006438:	100007b7          	lui	a5,0x10000
    8000643c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006440:	8b85                	andi	a5,a5,1
    80006442:	cb91                	beqz	a5,80006456 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006444:	100007b7          	lui	a5,0x10000
    80006448:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000644c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80006450:	6422                	ld	s0,8(sp)
    80006452:	0141                	addi	sp,sp,16
    80006454:	8082                	ret
    return -1;
    80006456:	557d                	li	a0,-1
    80006458:	bfe5                	j	80006450 <uartgetc+0x1e>

000000008000645a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000645a:	1101                	addi	sp,sp,-32
    8000645c:	ec06                	sd	ra,24(sp)
    8000645e:	e822                	sd	s0,16(sp)
    80006460:	e426                	sd	s1,8(sp)
    80006462:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006464:	54fd                	li	s1,-1
    80006466:	a029                	j	80006470 <uartintr+0x16>
      break;
    consoleintr(c);
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	916080e7          	jalr	-1770(ra) # 80005d7e <consoleintr>
    int c = uartgetc();
    80006470:	00000097          	auipc	ra,0x0
    80006474:	fc2080e7          	jalr	-62(ra) # 80006432 <uartgetc>
    if(c == -1)
    80006478:	fe9518e3          	bne	a0,s1,80006468 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000647c:	00028497          	auipc	s1,0x28
    80006480:	8cc48493          	addi	s1,s1,-1844 # 8002dd48 <uart_tx_lock>
    80006484:	8526                	mv	a0,s1
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	0b4080e7          	jalr	180(ra) # 8000653a <acquire>
  uartstart();
    8000648e:	00000097          	auipc	ra,0x0
    80006492:	e68080e7          	jalr	-408(ra) # 800062f6 <uartstart>
  release(&uart_tx_lock);
    80006496:	8526                	mv	a0,s1
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	156080e7          	jalr	342(ra) # 800065ee <release>
}
    800064a0:	60e2                	ld	ra,24(sp)
    800064a2:	6442                	ld	s0,16(sp)
    800064a4:	64a2                	ld	s1,8(sp)
    800064a6:	6105                	addi	sp,sp,32
    800064a8:	8082                	ret

00000000800064aa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064aa:	1141                	addi	sp,sp,-16
    800064ac:	e422                	sd	s0,8(sp)
    800064ae:	0800                	addi	s0,sp,16
  lk->name = name;
    800064b0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064b2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064b6:	00053823          	sd	zero,16(a0)
}
    800064ba:	6422                	ld	s0,8(sp)
    800064bc:	0141                	addi	sp,sp,16
    800064be:	8082                	ret

00000000800064c0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064c0:	411c                	lw	a5,0(a0)
    800064c2:	e399                	bnez	a5,800064c8 <holding+0x8>
    800064c4:	4501                	li	a0,0
  return r;
}
    800064c6:	8082                	ret
{
    800064c8:	1101                	addi	sp,sp,-32
    800064ca:	ec06                	sd	ra,24(sp)
    800064cc:	e822                	sd	s0,16(sp)
    800064ce:	e426                	sd	s1,8(sp)
    800064d0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064d2:	6904                	ld	s1,16(a0)
    800064d4:	ffffb097          	auipc	ra,0xffffb
    800064d8:	948080e7          	jalr	-1720(ra) # 80000e1c <mycpu>
    800064dc:	40a48533          	sub	a0,s1,a0
    800064e0:	00153513          	seqz	a0,a0
}
    800064e4:	60e2                	ld	ra,24(sp)
    800064e6:	6442                	ld	s0,16(sp)
    800064e8:	64a2                	ld	s1,8(sp)
    800064ea:	6105                	addi	sp,sp,32
    800064ec:	8082                	ret

00000000800064ee <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064ee:	1101                	addi	sp,sp,-32
    800064f0:	ec06                	sd	ra,24(sp)
    800064f2:	e822                	sd	s0,16(sp)
    800064f4:	e426                	sd	s1,8(sp)
    800064f6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064f8:	100024f3          	csrr	s1,sstatus
    800064fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006500:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006502:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	916080e7          	jalr	-1770(ra) # 80000e1c <mycpu>
    8000650e:	5d3c                	lw	a5,120(a0)
    80006510:	cf89                	beqz	a5,8000652a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006512:	ffffb097          	auipc	ra,0xffffb
    80006516:	90a080e7          	jalr	-1782(ra) # 80000e1c <mycpu>
    8000651a:	5d3c                	lw	a5,120(a0)
    8000651c:	2785                	addiw	a5,a5,1
    8000651e:	dd3c                	sw	a5,120(a0)
}
    80006520:	60e2                	ld	ra,24(sp)
    80006522:	6442                	ld	s0,16(sp)
    80006524:	64a2                	ld	s1,8(sp)
    80006526:	6105                	addi	sp,sp,32
    80006528:	8082                	ret
    mycpu()->intena = old;
    8000652a:	ffffb097          	auipc	ra,0xffffb
    8000652e:	8f2080e7          	jalr	-1806(ra) # 80000e1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006532:	8085                	srli	s1,s1,0x1
    80006534:	8885                	andi	s1,s1,1
    80006536:	dd64                	sw	s1,124(a0)
    80006538:	bfe9                	j	80006512 <push_off+0x24>

000000008000653a <acquire>:
{
    8000653a:	1101                	addi	sp,sp,-32
    8000653c:	ec06                	sd	ra,24(sp)
    8000653e:	e822                	sd	s0,16(sp)
    80006540:	e426                	sd	s1,8(sp)
    80006542:	1000                	addi	s0,sp,32
    80006544:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006546:	00000097          	auipc	ra,0x0
    8000654a:	fa8080e7          	jalr	-88(ra) # 800064ee <push_off>
  if(holding(lk))
    8000654e:	8526                	mv	a0,s1
    80006550:	00000097          	auipc	ra,0x0
    80006554:	f70080e7          	jalr	-144(ra) # 800064c0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006558:	4705                	li	a4,1
  if(holding(lk))
    8000655a:	e115                	bnez	a0,8000657e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000655c:	87ba                	mv	a5,a4
    8000655e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006562:	2781                	sext.w	a5,a5
    80006564:	ffe5                	bnez	a5,8000655c <acquire+0x22>
  __sync_synchronize();
    80006566:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000656a:	ffffb097          	auipc	ra,0xffffb
    8000656e:	8b2080e7          	jalr	-1870(ra) # 80000e1c <mycpu>
    80006572:	e888                	sd	a0,16(s1)
}
    80006574:	60e2                	ld	ra,24(sp)
    80006576:	6442                	ld	s0,16(sp)
    80006578:	64a2                	ld	s1,8(sp)
    8000657a:	6105                	addi	sp,sp,32
    8000657c:	8082                	ret
    panic("acquire");
    8000657e:	00002517          	auipc	a0,0x2
    80006582:	2da50513          	addi	a0,a0,730 # 80008858 <digits+0x20>
    80006586:	00000097          	auipc	ra,0x0
    8000658a:	a78080e7          	jalr	-1416(ra) # 80005ffe <panic>

000000008000658e <pop_off>:

void
pop_off(void)
{
    8000658e:	1141                	addi	sp,sp,-16
    80006590:	e406                	sd	ra,8(sp)
    80006592:	e022                	sd	s0,0(sp)
    80006594:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006596:	ffffb097          	auipc	ra,0xffffb
    8000659a:	886080e7          	jalr	-1914(ra) # 80000e1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000659e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065a2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065a4:	e78d                	bnez	a5,800065ce <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065a6:	5d3c                	lw	a5,120(a0)
    800065a8:	02f05b63          	blez	a5,800065de <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065ac:	37fd                	addiw	a5,a5,-1
    800065ae:	0007871b          	sext.w	a4,a5
    800065b2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065b4:	eb09                	bnez	a4,800065c6 <pop_off+0x38>
    800065b6:	5d7c                	lw	a5,124(a0)
    800065b8:	c799                	beqz	a5,800065c6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065c2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065c6:	60a2                	ld	ra,8(sp)
    800065c8:	6402                	ld	s0,0(sp)
    800065ca:	0141                	addi	sp,sp,16
    800065cc:	8082                	ret
    panic("pop_off - interruptible");
    800065ce:	00002517          	auipc	a0,0x2
    800065d2:	29250513          	addi	a0,a0,658 # 80008860 <digits+0x28>
    800065d6:	00000097          	auipc	ra,0x0
    800065da:	a28080e7          	jalr	-1496(ra) # 80005ffe <panic>
    panic("pop_off");
    800065de:	00002517          	auipc	a0,0x2
    800065e2:	29a50513          	addi	a0,a0,666 # 80008878 <digits+0x40>
    800065e6:	00000097          	auipc	ra,0x0
    800065ea:	a18080e7          	jalr	-1512(ra) # 80005ffe <panic>

00000000800065ee <release>:
{
    800065ee:	1101                	addi	sp,sp,-32
    800065f0:	ec06                	sd	ra,24(sp)
    800065f2:	e822                	sd	s0,16(sp)
    800065f4:	e426                	sd	s1,8(sp)
    800065f6:	1000                	addi	s0,sp,32
    800065f8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065fa:	00000097          	auipc	ra,0x0
    800065fe:	ec6080e7          	jalr	-314(ra) # 800064c0 <holding>
    80006602:	c115                	beqz	a0,80006626 <release+0x38>
  lk->cpu = 0;
    80006604:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006608:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000660c:	0f50000f          	fence	iorw,ow
    80006610:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006614:	00000097          	auipc	ra,0x0
    80006618:	f7a080e7          	jalr	-134(ra) # 8000658e <pop_off>
}
    8000661c:	60e2                	ld	ra,24(sp)
    8000661e:	6442                	ld	s0,16(sp)
    80006620:	64a2                	ld	s1,8(sp)
    80006622:	6105                	addi	sp,sp,32
    80006624:	8082                	ret
    panic("release");
    80006626:	00002517          	auipc	a0,0x2
    8000662a:	25a50513          	addi	a0,a0,602 # 80008880 <digits+0x48>
    8000662e:	00000097          	auipc	ra,0x0
    80006632:	9d0080e7          	jalr	-1584(ra) # 80005ffe <panic>
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
