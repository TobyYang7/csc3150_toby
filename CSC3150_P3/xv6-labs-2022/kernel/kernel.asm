
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00026117          	auipc	sp,0x26
    80000004:	c5010113          	addi	sp,sp,-944 # 80025c50 <stack0>
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
    80000034:	d2078793          	addi	a5,a5,-736 # 8002dd50 <end>
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
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
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
    800000ec:	00008517          	auipc	a0,0x8
    800000f0:	7f450513          	addi	a0,a0,2036 # 800088e0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3a6080e7          	jalr	934(ra) # 8000649a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	c5050513          	addi	a0,a0,-944 # 8002dd50 <end>
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
    80000126:	7be48493          	addi	s1,s1,1982 # 800088e0 <kmem>
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
    8000013e:	7a650513          	addi	a0,a0,1958 # 800088e0 <kmem>
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
    8000016a:	77a50513          	addi	a0,a0,1914 # 800088e0 <kmem>
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
    80000332:	58270713          	addi	a4,a4,1410 # 800088b0 <started>
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
    80000368:	7d2080e7          	jalr	2002(ra) # 80001b36 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	184080e7          	jalr	388(ra) # 800054f0 <plicinithart>
  }

  scheduler();
    80000374:	00001097          	auipc	ra,0x1
    80000378:	01a080e7          	jalr	26(ra) # 8000138e <scheduler>
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
    800003e0:	732080e7          	jalr	1842(ra) # 80001b0e <trapinit>
    trapinithart();     // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	752080e7          	jalr	1874(ra) # 80001b36 <trapinithart>
    plicinit();         // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	0ee080e7          	jalr	238(ra) # 800054da <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	0fc080e7          	jalr	252(ra) # 800054f0 <plicinithart>
    binit();            // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f7e080e7          	jalr	-130(ra) # 8000237a <binit>
    iinit();            // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	624080e7          	jalr	1572(ra) # 80002a28 <iinit>
    fileinit();         // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	5c6080e7          	jalr	1478(ra) # 800039d2 <fileinit>
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
    8000042e:	48f72323          	sw	a5,1158(a4) # 800088b0 <started>
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
    80000442:	47a7b783          	ld	a5,1146(a5) # 800088b8 <kernel_pagetable>
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
    800006fe:	1aa7bf23          	sd	a0,446(a5) # 800088b8 <kernel_pagetable>
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
    80000cdc:	05848493          	addi	s1,s1,88 # 80008d30 <proc>
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
    80000cf6:	a3ea0a13          	addi	s4,s4,-1474 # 8001a730 <tickslock>
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
    80000d54:	29e080e7          	jalr	670(ra) # 80005fee <panic>

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
    80000d78:	b8c50513          	addi	a0,a0,-1140 # 80008900 <pid_lock>
    80000d7c:	00005097          	auipc	ra,0x5
    80000d80:	71e080e7          	jalr	1822(ra) # 8000649a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3ac58593          	addi	a1,a1,940 # 80008130 <etext+0x130>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	b8c50513          	addi	a0,a0,-1140 # 80008918 <wait_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	706080e7          	jalr	1798(ra) # 8000649a <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d9c:	00008497          	auipc	s1,0x8
    80000da0:	f9448493          	addi	s1,s1,-108 # 80008d30 <proc>
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
    80000dc2:	97298993          	addi	s3,s3,-1678 # 8001a730 <tickslock>
    initlock(&p->lock, "proc");
    80000dc6:	85da                	mv	a1,s6
    80000dc8:	8526                	mv	a0,s1
    80000dca:	00005097          	auipc	ra,0x5
    80000dce:	6d0080e7          	jalr	1744(ra) # 8000649a <initlock>
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
    80000e2c:	b0850513          	addi	a0,a0,-1272 # 80008930 <cpus>
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
    80000e46:	69c080e7          	jalr	1692(ra) # 800064de <push_off>
    80000e4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4c:	2781                	sext.w	a5,a5
    80000e4e:	079e                	slli	a5,a5,0x7
    80000e50:	00008717          	auipc	a4,0x8
    80000e54:	ab070713          	addi	a4,a4,-1360 # 80008900 <pid_lock>
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
    80000e84:	75e080e7          	jalr	1886(ra) # 800065de <release>

  if (first)
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	9d87a783          	lw	a5,-1576(a5) # 80008860 <first.1>
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
    80000ea6:	9a07af23          	sw	zero,-1602(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80000eaa:	4505                	li	a0,1
    80000eac:	00002097          	auipc	ra,0x2
    80000eb0:	afc080e7          	jalr	-1284(ra) # 800029a8 <fsinit>
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
    80000ec6:	a3e90913          	addi	s2,s2,-1474 # 80008900 <pid_lock>
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	65e080e7          	jalr	1630(ra) # 8000652a <acquire>
  pid = nextpid;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	99078793          	addi	a5,a5,-1648 # 80008864 <nextpid>
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
    80001052:	ce248493          	addi	s1,s1,-798 # 80008d30 <proc>
    80001056:	00019917          	auipc	s2,0x19
    8000105a:	6da90913          	addi	s2,s2,1754 # 8001a730 <tickslock>
    acquire(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	4ca080e7          	jalr	1226(ra) # 8000652a <acquire>
    if (p->state == UNUSED)
    80001068:	4c9c                	lw	a5,24(s1)
    8000106a:	cf81                	beqz	a5,80001082 <allocproc+0x40>
      release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00005097          	auipc	ra,0x5
    80001072:	570080e7          	jalr	1392(ra) # 800065de <release>
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
    80001128:	78a7be23          	sd	a0,1948(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112c:	03400613          	li	a2,52
    80001130:	00007597          	auipc	a1,0x7
    80001134:	74058593          	addi	a1,a1,1856 # 80008870 <initcode>
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
    80001172:	25c080e7          	jalr	604(ra) # 800033ca <namei>
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
    80001254:	38e080e7          	jalr	910(ra) # 800065de <release>
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
    80001296:	7d2080e7          	jalr	2002(ra) # 80003a64 <filedup>
    8000129a:	02a93023          	sd	a0,32(s2)
      np->vma[idx].ip = idup(p->vma[idx].ip);          // increase inode reference count}
    8000129e:	7488                	ld	a0,40(s1)
    800012a0:	00002097          	auipc	ra,0x2
    800012a4:	946080e7          	jalr	-1722(ra) # 80002be6 <idup>
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
    80001302:	766080e7          	jalr	1894(ra) # 80003a64 <filedup>
    80001306:	00a93023          	sd	a0,0(s2)
    8000130a:	b7e5                	j	800012f2 <fork+0x104>
  np->cwd = idup(p->cwd);
    8000130c:	150a3503          	ld	a0,336(s4)
    80001310:	00002097          	auipc	ra,0x2
    80001314:	8d6080e7          	jalr	-1834(ra) # 80002be6 <idup>
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
    80001338:	2aa080e7          	jalr	682(ra) # 800065de <release>
  acquire(&wait_lock);
    8000133c:	00007497          	auipc	s1,0x7
    80001340:	5dc48493          	addi	s1,s1,1500 # 80008918 <wait_lock>
    80001344:	8526                	mv	a0,s1
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	1e4080e7          	jalr	484(ra) # 8000652a <acquire>
  np->parent = p;
    8000134e:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	28a080e7          	jalr	650(ra) # 800065de <release>
  acquire(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	1cc080e7          	jalr	460(ra) # 8000652a <acquire>
  np->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	270080e7          	jalr	624(ra) # 800065de <release>
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
    800013ae:	55670713          	addi	a4,a4,1366 # 80008900 <pid_lock>
    800013b2:	9756                	add	a4,a4,s5
    800013b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b8:	00007717          	auipc	a4,0x7
    800013bc:	58070713          	addi	a4,a4,1408 # 80008938 <cpus+0x8>
    800013c0:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800013c2:	498d                	li	s3,3
        p->state = RUNNING;
    800013c4:	4b11                	li	s6,4
        c->proc = p;
    800013c6:	079e                	slli	a5,a5,0x7
    800013c8:	00007a17          	auipc	s4,0x7
    800013cc:	538a0a13          	addi	s4,s4,1336 # 80008900 <pid_lock>
    800013d0:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800013d2:	00019917          	auipc	s2,0x19
    800013d6:	35e90913          	addi	s2,s2,862 # 8001a730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e2:	10079073          	csrw	sstatus,a5
    800013e6:	00008497          	auipc	s1,0x8
    800013ea:	94a48493          	addi	s1,s1,-1718 # 80008d30 <proc>
    800013ee:	a811                	j	80001402 <scheduler+0x74>
      release(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	1ec080e7          	jalr	492(ra) # 800065de <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800013fa:	46848493          	addi	s1,s1,1128
    800013fe:	fd248ee3          	beq	s1,s2,800013da <scheduler+0x4c>
      acquire(&p->lock);
    80001402:	8526                	mv	a0,s1
    80001404:	00005097          	auipc	ra,0x5
    80001408:	126080e7          	jalr	294(ra) # 8000652a <acquire>
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
    8000144a:	06a080e7          	jalr	106(ra) # 800064b0 <holding>
    8000144e:	c93d                	beqz	a0,800014c4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001450:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001452:	2781                	sext.w	a5,a5
    80001454:	079e                	slli	a5,a5,0x7
    80001456:	00007717          	auipc	a4,0x7
    8000145a:	4aa70713          	addi	a4,a4,1194 # 80008900 <pid_lock>
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
    80001480:	48490913          	addi	s2,s2,1156 # 80008900 <pid_lock>
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	97ca                	add	a5,a5,s2
    8000148a:	0ac7a983          	lw	s3,172(a5)
    8000148e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001490:	2781                	sext.w	a5,a5
    80001492:	079e                	slli	a5,a5,0x7
    80001494:	00007597          	auipc	a1,0x7
    80001498:	4a458593          	addi	a1,a1,1188 # 80008938 <cpus+0x8>
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
    800014d0:	b22080e7          	jalr	-1246(ra) # 80005fee <panic>
    panic("sched locks");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	c9c50513          	addi	a0,a0,-868 # 80008170 <etext+0x170>
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	b12080e7          	jalr	-1262(ra) # 80005fee <panic>
    panic("sched running");
    800014e4:	00007517          	auipc	a0,0x7
    800014e8:	c9c50513          	addi	a0,a0,-868 # 80008180 <etext+0x180>
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	b02080e7          	jalr	-1278(ra) # 80005fee <panic>
    panic("sched interruptible");
    800014f4:	00007517          	auipc	a0,0x7
    800014f8:	c9c50513          	addi	a0,a0,-868 # 80008190 <etext+0x190>
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	af2080e7          	jalr	-1294(ra) # 80005fee <panic>

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
    8000151c:	012080e7          	jalr	18(ra) # 8000652a <acquire>
  p->state = RUNNABLE;
    80001520:	478d                	li	a5,3
    80001522:	cc9c                	sw	a5,24(s1)
  sched();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	f0a080e7          	jalr	-246(ra) # 8000142e <sched>
  release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	0b0080e7          	jalr	176(ra) # 800065de <release>
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
    80001560:	fce080e7          	jalr	-50(ra) # 8000652a <acquire>
  release(lk);
    80001564:	854a                	mv	a0,s2
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	078080e7          	jalr	120(ra) # 800065de <release>

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
    80001588:	05a080e7          	jalr	90(ra) # 800065de <release>
  acquire(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	f9c080e7          	jalr	-100(ra) # 8000652a <acquire>
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
    800015bc:	77848493          	addi	s1,s1,1912 # 80008d30 <proc>
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
    800015c8:	16c90913          	addi	s2,s2,364 # 8001a730 <tickslock>
    800015cc:	a811                	j	800015e0 <wakeup+0x3c>
      }
      release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	00e080e7          	jalr	14(ra) # 800065de <release>
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
    800015f2:	f3c080e7          	jalr	-196(ra) # 8000652a <acquire>
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
    80001630:	70448493          	addi	s1,s1,1796 # 80008d30 <proc>
      pp->parent = initproc;
    80001634:	00007a17          	auipc	s4,0x7
    80001638:	28ca0a13          	addi	s4,s4,652 # 800088c0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000163c:	00019997          	auipc	s3,0x19
    80001640:	0f498993          	addi	s3,s3,244 # 8001a730 <tickslock>
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
    80001694:	2307b783          	ld	a5,560(a5) # 800088c0 <initproc>
    80001698:	0d050493          	addi	s1,a0,208
    8000169c:	15050913          	addi	s2,a0,336
    800016a0:	02a79363          	bne	a5,a0,800016c6 <exit+0x52>
    panic("init exiting");
    800016a4:	00007517          	auipc	a0,0x7
    800016a8:	b0450513          	addi	a0,a0,-1276 # 800081a8 <etext+0x1a8>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	942080e7          	jalr	-1726(ra) # 80005fee <panic>
      fileclose(f);
    800016b4:	00002097          	auipc	ra,0x2
    800016b8:	402080e7          	jalr	1026(ra) # 80003ab6 <fileclose>
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
    800016d0:	f1e080e7          	jalr	-226(ra) # 800035ea <begin_op>
  iput(p->cwd);
    800016d4:	1509b503          	ld	a0,336(s3)
    800016d8:	00001097          	auipc	ra,0x1
    800016dc:	706080e7          	jalr	1798(ra) # 80002dde <iput>
  end_op();
    800016e0:	00002097          	auipc	ra,0x2
    800016e4:	f8a080e7          	jalr	-118(ra) # 8000366a <end_op>
  p->cwd = 0;
    800016e8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016ec:	00007497          	auipc	s1,0x7
    800016f0:	22c48493          	addi	s1,s1,556 # 80008918 <wait_lock>
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	e34080e7          	jalr	-460(ra) # 8000652a <acquire>
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
    8000171a:	e14080e7          	jalr	-492(ra) # 8000652a <acquire>
  p->xstate = status;
    8000171e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001722:	4795                	li	a5,5
    80001724:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	eb4080e7          	jalr	-332(ra) # 800065de <release>
  sched();
    80001732:	00000097          	auipc	ra,0x0
    80001736:	cfc080e7          	jalr	-772(ra) # 8000142e <sched>
  panic("zombie exit");
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	a7e50513          	addi	a0,a0,-1410 # 800081b8 <etext+0x1b8>
    80001742:	00005097          	auipc	ra,0x5
    80001746:	8ac080e7          	jalr	-1876(ra) # 80005fee <panic>

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
    8000175e:	5d648493          	addi	s1,s1,1494 # 80008d30 <proc>
    80001762:	00019997          	auipc	s3,0x19
    80001766:	fce98993          	addi	s3,s3,-50 # 8001a730 <tickslock>
  {
    acquire(&p->lock);
    8000176a:	8526                	mv	a0,s1
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	dbe080e7          	jalr	-578(ra) # 8000652a <acquire>
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
    80001780:	e62080e7          	jalr	-414(ra) # 800065de <release>
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
    800017a2:	e40080e7          	jalr	-448(ra) # 800065de <release>
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
    800017cc:	d62080e7          	jalr	-670(ra) # 8000652a <acquire>
  p->killed = 1;
    800017d0:	4785                	li	a5,1
    800017d2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	e08080e7          	jalr	-504(ra) # 800065de <release>
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
    800017fa:	d34080e7          	jalr	-716(ra) # 8000652a <acquire>
  k = p->killed;
    800017fe:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001802:	8526                	mv	a0,s1
    80001804:	00005097          	auipc	ra,0x5
    80001808:	dda080e7          	jalr	-550(ra) # 800065de <release>
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
    80001842:	0da50513          	addi	a0,a0,218 # 80008918 <wait_lock>
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	ce4080e7          	jalr	-796(ra) # 8000652a <acquire>
    havekids = 0;
    8000184e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80001850:	4a15                	li	s4,5
        havekids = 1;
    80001852:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001854:	00019997          	auipc	s3,0x19
    80001858:	edc98993          	addi	s3,s3,-292 # 8001a730 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000185c:	00007c17          	auipc	s8,0x7
    80001860:	0bcc0c13          	addi	s8,s8,188 # 80008918 <wait_lock>
    havekids = 0;
    80001864:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001866:	00007497          	auipc	s1,0x7
    8000186a:	4ca48493          	addi	s1,s1,1226 # 80008d30 <proc>
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
    800018a0:	d42080e7          	jalr	-702(ra) # 800065de <release>
          release(&wait_lock);
    800018a4:	00007517          	auipc	a0,0x7
    800018a8:	07450513          	addi	a0,a0,116 # 80008918 <wait_lock>
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	d32080e7          	jalr	-718(ra) # 800065de <release>
          return pid;
    800018b4:	a0b5                	j	80001920 <wait+0x106>
            release(&pp->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	d26080e7          	jalr	-730(ra) # 800065de <release>
            release(&wait_lock);
    800018c0:	00007517          	auipc	a0,0x7
    800018c4:	05850513          	addi	a0,a0,88 # 80008918 <wait_lock>
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	d16080e7          	jalr	-746(ra) # 800065de <release>
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
    800018e8:	c46080e7          	jalr	-954(ra) # 8000652a <acquire>
        if (pp->state == ZOMBIE)
    800018ec:	4c9c                	lw	a5,24(s1)
    800018ee:	f94781e3          	beq	a5,s4,80001870 <wait+0x56>
        release(&pp->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	cea080e7          	jalr	-790(ra) # 800065de <release>
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
    80001912:	00a50513          	addi	a0,a0,10 # 80008918 <wait_lock>
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	cc8080e7          	jalr	-824(ra) # 800065de <release>
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
    80001a16:	626080e7          	jalr	1574(ra) # 80006038 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a1a:	00007497          	auipc	s1,0x7
    80001a1e:	46e48493          	addi	s1,s1,1134 # 80008e88 <proc+0x158>
    80001a22:	00019917          	auipc	s2,0x19
    80001a26:	e6690913          	addi	s2,s2,-410 # 8001a888 <bcache+0x140>
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
    80001a58:	5e4080e7          	jalr	1508(ra) # 80006038 <printf>
    printf("\n");
    80001a5c:	8552                	mv	a0,s4
    80001a5e:	00004097          	auipc	ra,0x4
    80001a62:	5da080e7          	jalr	1498(ra) # 80006038 <printf>
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
    80001b22:	c1250513          	addi	a0,a0,-1006 # 8001a730 <tickslock>
    80001b26:	00005097          	auipc	ra,0x5
    80001b2a:	974080e7          	jalr	-1676(ra) # 8000649a <initlock>
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
    80001b40:	8e478793          	addi	a5,a5,-1820 # 80005420 <kernelvec>
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
    80001bf2:	b4248493          	addi	s1,s1,-1214 # 8001a730 <tickslock>
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00005097          	auipc	ra,0x5
    80001bfc:	932080e7          	jalr	-1742(ra) # 8000652a <acquire>
  ticks++;
    80001c00:	00007517          	auipc	a0,0x7
    80001c04:	cc850513          	addi	a0,a0,-824 # 800088c8 <ticks>
    80001c08:	411c                	lw	a5,0(a0)
    80001c0a:	2785                	addiw	a5,a5,1
    80001c0c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	996080e7          	jalr	-1642(ra) # 800015a4 <wakeup>
  release(&tickslock);
    80001c16:	8526                	mv	a0,s1
    80001c18:	00005097          	auipc	ra,0x5
    80001c1c:	9c6080e7          	jalr	-1594(ra) # 800065de <release>
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
    80001c60:	8cc080e7          	jalr	-1844(ra) # 80005528 <plic_claim>
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
    80001c84:	3b8080e7          	jalr	952(ra) # 80006038 <printf>
      plic_complete(irq);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	8c2080e7          	jalr	-1854(ra) # 8000554c <plic_complete>
    return 1;
    80001c92:	4505                	li	a0,1
    80001c94:	bf55                	j	80001c48 <devintr+0x1e>
      uartintr();
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	7b4080e7          	jalr	1972(ra) # 8000644a <uartintr>
    80001c9e:	b7ed                	j	80001c88 <devintr+0x5e>
      virtio_disk_intr();
    80001ca0:	00004097          	auipc	ra,0x4
    80001ca4:	d78080e7          	jalr	-648(ra) # 80005a18 <virtio_disk_intr>
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
    80001cee:	73678793          	addi	a5,a5,1846 # 80005420 <kernelvec>
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
    80001d1c:	18051863          	bnez	a0,80001eac <usertrap+0x1e0>
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
    80001d40:	58450513          	addi	a0,a0,1412 # 800082c0 <states.0+0xb0>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	2f4080e7          	jalr	756(ra) # 80006038 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d50:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	59c50513          	addi	a0,a0,1436 # 800082f0 <states.0+0xe0>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	2dc080e7          	jalr	732(ra) # 80006038 <printf>
    setkilled(p);
    80001d64:	854a                	mv	a0,s2
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	a56080e7          	jalr	-1450(ra) # 800017bc <setkilled>
    80001d6e:	a82d                	j	80001da8 <usertrap+0xdc>
    panic("usertrap: not from user mode");
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	4f850513          	addi	a0,a0,1272 # 80008268 <states.0+0x58>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	276080e7          	jalr	630(ra) # 80005fee <panic>
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
    80001da4:	380080e7          	jalr	896(ra) # 80002120 <syscall>
  if (killed(p))
    80001da8:	854a                	mv	a0,s2
    80001daa:	00000097          	auipc	ra,0x0
    80001dae:	a3e080e7          	jalr	-1474(ra) # 800017e8 <killed>
    80001db2:	10051463          	bnez	a0,80001eba <usertrap+0x1ee>
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
    for (int i = 0; i < VMASIZE; i++)
    80001df2:	16890793          	addi	a5,s2,360
    80001df6:	4841                	li	a6,16
    80001df8:	a031                	j	80001e04 <usertrap+0x138>
    80001dfa:	2485                	addiw	s1,s1,1
    80001dfc:	03078793          	addi	a5,a5,48
    80001e00:	07048f63          	beq	s1,a6,80001e7e <usertrap+0x1b2>
      if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) // fix
    80001e04:	6398                	ld	a4,0(a5)
    80001e06:	fee9eae3          	bltu	s3,a4,80001dfa <usertrap+0x12e>
    80001e0a:	4790                	lw	a2,8(a5)
    80001e0c:	9732                	add	a4,a4,a2
    80001e0e:	fee9f6e3          	bgeu	s3,a4,80001dfa <usertrap+0x12e>
    if (idx == -1 || mem == 0)
    80001e12:	57fd                	li	a5,-1
    80001e14:	06f48563          	beq	s1,a5,80001e7e <usertrap+0x1b2>
    80001e18:	060a0363          	beqz	s4,80001e7e <usertrap+0x1b2>
      struct vma v = p->vma[idx];
    80001e1c:	00149793          	slli	a5,s1,0x1
    80001e20:	00978733          	add	a4,a5,s1
    80001e24:	0712                	slli	a4,a4,0x4
    80001e26:	974a                	add	a4,a4,s2
    80001e28:	16873a83          	ld	s5,360(a4)
    80001e2c:	18072b03          	lw	s6,384(a4)
    80001e30:	18873483          	ld	s1,392(a4)
      memset(mem, 0, PGSIZE); // zero out the memory
    80001e34:	6605                	lui	a2,0x1
    80001e36:	4581                	li	a1,0
    80001e38:	8552                	mv	a0,s4
    80001e3a:	ffffe097          	auipc	ra,0xffffe
    80001e3e:	33e080e7          	jalr	830(ra) # 80000178 <memset>
      if (mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80001e42:	4779                	li	a4,30
    80001e44:	86d2                	mv	a3,s4
    80001e46:	6605                	lui	a2,0x1
    80001e48:	85ce                	mv	a1,s3
    80001e4a:	05093503          	ld	a0,80(s2)
    80001e4e:	ffffe097          	auipc	ra,0xffffe
    80001e52:	6f6080e7          	jalr	1782(ra) # 80000544 <mappages>
    80001e56:	ed0d                	bnez	a0,80001e90 <usertrap+0x1c4>
      mapfile(v.mfile, mem, va - v.addr + v.offset);
    80001e58:	0169863b          	addw	a2,s3,s6
    80001e5c:	4156063b          	subw	a2,a2,s5
    80001e60:	85d2                	mv	a1,s4
    80001e62:	8526                	mv	a0,s1
    80001e64:	00002097          	auipc	ra,0x2
    80001e68:	d8c080e7          	jalr	-628(ra) # 80003bf0 <mapfile>
      if (p->killed)
    80001e6c:	02892783          	lw	a5,40(s2)
    80001e70:	df85                	beqz	a5,80001da8 <usertrap+0xdc>
        exit(-1);
    80001e72:	557d                	li	a0,-1
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	800080e7          	jalr	-2048(ra) # 80001674 <exit>
    80001e7c:	b735                	j	80001da8 <usertrap+0xdc>
      printf("usertrap(): page fault\n");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	40a50513          	addi	a0,a0,1034 # 80008288 <states.0+0x78>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	1b2080e7          	jalr	434(ra) # 80006038 <printf>
      goto err;
    80001e8e:	b55d                	j	80001d34 <usertrap+0x68>
        kfree(mem);
    80001e90:	8552                	mv	a0,s4
    80001e92:	ffffe097          	auipc	ra,0xffffe
    80001e96:	18a080e7          	jalr	394(ra) # 8000001c <kfree>
        printf("usertrap(): mappages error\n");
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	40650513          	addi	a0,a0,1030 # 800082a0 <states.0+0x90>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	196080e7          	jalr	406(ra) # 80006038 <printf>
        goto err;
    80001eaa:	b569                	j	80001d34 <usertrap+0x68>
  if (killed(p))
    80001eac:	854a                	mv	a0,s2
    80001eae:	00000097          	auipc	ra,0x0
    80001eb2:	93a080e7          	jalr	-1734(ra) # 800017e8 <killed>
    80001eb6:	c901                	beqz	a0,80001ec6 <usertrap+0x1fa>
    80001eb8:	a011                	j	80001ebc <usertrap+0x1f0>
    80001eba:	4481                	li	s1,0
    exit(-1);
    80001ebc:	557d                	li	a0,-1
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	7b6080e7          	jalr	1974(ra) # 80001674 <exit>
  if (which_dev == 2)
    80001ec6:	4789                	li	a5,2
    80001ec8:	eef497e3          	bne	s1,a5,80001db6 <usertrap+0xea>
    yield();
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	638080e7          	jalr	1592(ra) # 80001504 <yield>
    80001ed4:	b5cd                	j	80001db6 <usertrap+0xea>

0000000080001ed6 <kerneltrap>:
{
    80001ed6:	7179                	addi	sp,sp,-48
    80001ed8:	f406                	sd	ra,40(sp)
    80001eda:	f022                	sd	s0,32(sp)
    80001edc:	ec26                	sd	s1,24(sp)
    80001ede:	e84a                	sd	s2,16(sp)
    80001ee0:	e44e                	sd	s3,8(sp)
    80001ee2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eec:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001ef0:	1004f793          	andi	a5,s1,256
    80001ef4:	cb85                	beqz	a5,80001f24 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001efa:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001efc:	ef85                	bnez	a5,80001f34 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	d2c080e7          	jalr	-724(ra) # 80001c2a <devintr>
    80001f06:	cd1d                	beqz	a0,80001f44 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f08:	4789                	li	a5,2
    80001f0a:	06f50a63          	beq	a0,a5,80001f7e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f0e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f12:	10049073          	csrw	sstatus,s1
}
    80001f16:	70a2                	ld	ra,40(sp)
    80001f18:	7402                	ld	s0,32(sp)
    80001f1a:	64e2                	ld	s1,24(sp)
    80001f1c:	6942                	ld	s2,16(sp)
    80001f1e:	69a2                	ld	s3,8(sp)
    80001f20:	6145                	addi	sp,sp,48
    80001f22:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	3ec50513          	addi	a0,a0,1004 # 80008310 <states.0+0x100>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	0c2080e7          	jalr	194(ra) # 80005fee <panic>
    panic("kerneltrap: interrupts enabled");
    80001f34:	00006517          	auipc	a0,0x6
    80001f38:	40450513          	addi	a0,a0,1028 # 80008338 <states.0+0x128>
    80001f3c:	00004097          	auipc	ra,0x4
    80001f40:	0b2080e7          	jalr	178(ra) # 80005fee <panic>
    printf("scause %p\n", scause);
    80001f44:	85ce                	mv	a1,s3
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	41250513          	addi	a0,a0,1042 # 80008358 <states.0+0x148>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	0ea080e7          	jalr	234(ra) # 80006038 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f5a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	40a50513          	addi	a0,a0,1034 # 80008368 <states.0+0x158>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	0d2080e7          	jalr	210(ra) # 80006038 <printf>
    panic("kerneltrap");
    80001f6e:	00006517          	auipc	a0,0x6
    80001f72:	41250513          	addi	a0,a0,1042 # 80008380 <states.0+0x170>
    80001f76:	00004097          	auipc	ra,0x4
    80001f7a:	078080e7          	jalr	120(ra) # 80005fee <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	eba080e7          	jalr	-326(ra) # 80000e38 <myproc>
    80001f86:	d541                	beqz	a0,80001f0e <kerneltrap+0x38>
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	eb0080e7          	jalr	-336(ra) # 80000e38 <myproc>
    80001f90:	4d18                	lw	a4,24(a0)
    80001f92:	4791                	li	a5,4
    80001f94:	f6f71de3          	bne	a4,a5,80001f0e <kerneltrap+0x38>
    yield();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	56c080e7          	jalr	1388(ra) # 80001504 <yield>
    80001fa0:	b7bd                	j	80001f0e <kerneltrap+0x38>

0000000080001fa2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa2:	1101                	addi	sp,sp,-32
    80001fa4:	ec06                	sd	ra,24(sp)
    80001fa6:	e822                	sd	s0,16(sp)
    80001fa8:	e426                	sd	s1,8(sp)
    80001faa:	1000                	addi	s0,sp,32
    80001fac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	e8a080e7          	jalr	-374(ra) # 80000e38 <myproc>
  switch (n) {
    80001fb6:	4795                	li	a5,5
    80001fb8:	0497e163          	bltu	a5,s1,80001ffa <argraw+0x58>
    80001fbc:	048a                	slli	s1,s1,0x2
    80001fbe:	00006717          	auipc	a4,0x6
    80001fc2:	3fa70713          	addi	a4,a4,1018 # 800083b8 <states.0+0x1a8>
    80001fc6:	94ba                	add	s1,s1,a4
    80001fc8:	409c                	lw	a5,0(s1)
    80001fca:	97ba                	add	a5,a5,a4
    80001fcc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fce:	6d3c                	ld	a5,88(a0)
    80001fd0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fd2:	60e2                	ld	ra,24(sp)
    80001fd4:	6442                	ld	s0,16(sp)
    80001fd6:	64a2                	ld	s1,8(sp)
    80001fd8:	6105                	addi	sp,sp,32
    80001fda:	8082                	ret
    return p->trapframe->a1;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	7fa8                	ld	a0,120(a5)
    80001fe0:	bfcd                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a2;
    80001fe2:	6d3c                	ld	a5,88(a0)
    80001fe4:	63c8                	ld	a0,128(a5)
    80001fe6:	b7f5                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a3;
    80001fe8:	6d3c                	ld	a5,88(a0)
    80001fea:	67c8                	ld	a0,136(a5)
    80001fec:	b7dd                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a4;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	6bc8                	ld	a0,144(a5)
    80001ff2:	b7c5                	j	80001fd2 <argraw+0x30>
    return p->trapframe->a5;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	6fc8                	ld	a0,152(a5)
    80001ff8:	bfe9                	j	80001fd2 <argraw+0x30>
  panic("argraw");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	39650513          	addi	a0,a0,918 # 80008390 <states.0+0x180>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	fec080e7          	jalr	-20(ra) # 80005fee <panic>

000000008000200a <fetchaddr>:
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	e04a                	sd	s2,0(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84aa                	mv	s1,a0
    80002018:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	e1e080e7          	jalr	-482(ra) # 80000e38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002022:	653c                	ld	a5,72(a0)
    80002024:	02f4f863          	bgeu	s1,a5,80002054 <fetchaddr+0x4a>
    80002028:	00848713          	addi	a4,s1,8
    8000202c:	02e7e663          	bltu	a5,a4,80002058 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002030:	46a1                	li	a3,8
    80002032:	8626                	mv	a2,s1
    80002034:	85ca                	mv	a1,s2
    80002036:	6928                	ld	a0,80(a0)
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	b48080e7          	jalr	-1208(ra) # 80000b80 <copyin>
    80002040:	00a03533          	snez	a0,a0
    80002044:	40a00533          	neg	a0,a0
}
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	64a2                	ld	s1,8(sp)
    8000204e:	6902                	ld	s2,0(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret
    return -1;
    80002054:	557d                	li	a0,-1
    80002056:	bfcd                	j	80002048 <fetchaddr+0x3e>
    80002058:	557d                	li	a0,-1
    8000205a:	b7fd                	j	80002048 <fetchaddr+0x3e>

000000008000205c <fetchstr>:
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
    8000206a:	892a                	mv	s2,a0
    8000206c:	84ae                	mv	s1,a1
    8000206e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	dc8080e7          	jalr	-568(ra) # 80000e38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002078:	86ce                	mv	a3,s3
    8000207a:	864a                	mv	a2,s2
    8000207c:	85a6                	mv	a1,s1
    8000207e:	6928                	ld	a0,80(a0)
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	b8e080e7          	jalr	-1138(ra) # 80000c0e <copyinstr>
    80002088:	00054e63          	bltz	a0,800020a4 <fetchstr+0x48>
  return strlen(buf);
    8000208c:	8526                	mv	a0,s1
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	266080e7          	jalr	614(ra) # 800002f4 <strlen>
}
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	69a2                	ld	s3,8(sp)
    800020a0:	6145                	addi	sp,sp,48
    800020a2:	8082                	ret
    return -1;
    800020a4:	557d                	li	a0,-1
    800020a6:	bfc5                	j	80002096 <fetchstr+0x3a>

00000000800020a8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	e426                	sd	s1,8(sp)
    800020b0:	1000                	addi	s0,sp,32
    800020b2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	eee080e7          	jalr	-274(ra) # 80001fa2 <argraw>
    800020bc:	c088                	sw	a0,0(s1)
}
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	64a2                	ld	s1,8(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret

00000000800020c8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020c8:	1101                	addi	sp,sp,-32
    800020ca:	ec06                	sd	ra,24(sp)
    800020cc:	e822                	sd	s0,16(sp)
    800020ce:	e426                	sd	s1,8(sp)
    800020d0:	1000                	addi	s0,sp,32
    800020d2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	ece080e7          	jalr	-306(ra) # 80001fa2 <argraw>
    800020dc:	e088                	sd	a0,0(s1)
}
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	64a2                	ld	s1,8(sp)
    800020e4:	6105                	addi	sp,sp,32
    800020e6:	8082                	ret

00000000800020e8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020e8:	7179                	addi	sp,sp,-48
    800020ea:	f406                	sd	ra,40(sp)
    800020ec:	f022                	sd	s0,32(sp)
    800020ee:	ec26                	sd	s1,24(sp)
    800020f0:	e84a                	sd	s2,16(sp)
    800020f2:	1800                	addi	s0,sp,48
    800020f4:	84ae                	mv	s1,a1
    800020f6:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020f8:	fd840593          	addi	a1,s0,-40
    800020fc:	00000097          	auipc	ra,0x0
    80002100:	fcc080e7          	jalr	-52(ra) # 800020c8 <argaddr>
  return fetchstr(addr, buf, max);
    80002104:	864a                	mv	a2,s2
    80002106:	85a6                	mv	a1,s1
    80002108:	fd843503          	ld	a0,-40(s0)
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	f50080e7          	jalr	-176(ra) # 8000205c <fetchstr>
}
    80002114:	70a2                	ld	ra,40(sp)
    80002116:	7402                	ld	s0,32(sp)
    80002118:	64e2                	ld	s1,24(sp)
    8000211a:	6942                	ld	s2,16(sp)
    8000211c:	6145                	addi	sp,sp,48
    8000211e:	8082                	ret

0000000080002120 <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	e04a                	sd	s2,0(sp)
    8000212a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	d0c080e7          	jalr	-756(ra) # 80000e38 <myproc>
    80002134:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002136:	05853903          	ld	s2,88(a0)
    8000213a:	0a893783          	ld	a5,168(s2)
    8000213e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002142:	37fd                	addiw	a5,a5,-1
    80002144:	4759                	li	a4,22
    80002146:	00f76f63          	bltu	a4,a5,80002164 <syscall+0x44>
    8000214a:	00369713          	slli	a4,a3,0x3
    8000214e:	00006797          	auipc	a5,0x6
    80002152:	28278793          	addi	a5,a5,642 # 800083d0 <syscalls>
    80002156:	97ba                	add	a5,a5,a4
    80002158:	639c                	ld	a5,0(a5)
    8000215a:	c789                	beqz	a5,80002164 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000215c:	9782                	jalr	a5
    8000215e:	06a93823          	sd	a0,112(s2)
    80002162:	a839                	j	80002180 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002164:	15848613          	addi	a2,s1,344
    80002168:	588c                	lw	a1,48(s1)
    8000216a:	00006517          	auipc	a0,0x6
    8000216e:	22e50513          	addi	a0,a0,558 # 80008398 <states.0+0x188>
    80002172:	00004097          	auipc	ra,0x4
    80002176:	ec6080e7          	jalr	-314(ra) # 80006038 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000217a:	6cbc                	ld	a5,88(s1)
    8000217c:	577d                	li	a4,-1
    8000217e:	fbb8                	sd	a4,112(a5)
  }
}
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	64a2                	ld	s1,8(sp)
    80002186:	6902                	ld	s2,0(sp)
    80002188:	6105                	addi	sp,sp,32
    8000218a:	8082                	ret

000000008000218c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002194:	fec40593          	addi	a1,s0,-20
    80002198:	4501                	li	a0,0
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	f0e080e7          	jalr	-242(ra) # 800020a8 <argint>
  exit(n);
    800021a2:	fec42503          	lw	a0,-20(s0)
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	4ce080e7          	jalr	1230(ra) # 80001674 <exit>
  return 0;  // not reached
}
    800021ae:	4501                	li	a0,0
    800021b0:	60e2                	ld	ra,24(sp)
    800021b2:	6442                	ld	s0,16(sp)
    800021b4:	6105                	addi	sp,sp,32
    800021b6:	8082                	ret

00000000800021b8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b8:	1141                	addi	sp,sp,-16
    800021ba:	e406                	sd	ra,8(sp)
    800021bc:	e022                	sd	s0,0(sp)
    800021be:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	c78080e7          	jalr	-904(ra) # 80000e38 <myproc>
}
    800021c8:	5908                	lw	a0,48(a0)
    800021ca:	60a2                	ld	ra,8(sp)
    800021cc:	6402                	ld	s0,0(sp)
    800021ce:	0141                	addi	sp,sp,16
    800021d0:	8082                	ret

00000000800021d2 <sys_fork>:

uint64
sys_fork(void)
{
    800021d2:	1141                	addi	sp,sp,-16
    800021d4:	e406                	sd	ra,8(sp)
    800021d6:	e022                	sd	s0,0(sp)
    800021d8:	0800                	addi	s0,sp,16
  return fork();
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	014080e7          	jalr	20(ra) # 800011ee <fork>
}
    800021e2:	60a2                	ld	ra,8(sp)
    800021e4:	6402                	ld	s0,0(sp)
    800021e6:	0141                	addi	sp,sp,16
    800021e8:	8082                	ret

00000000800021ea <sys_wait>:

uint64
sys_wait(void)
{
    800021ea:	1101                	addi	sp,sp,-32
    800021ec:	ec06                	sd	ra,24(sp)
    800021ee:	e822                	sd	s0,16(sp)
    800021f0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021f2:	fe840593          	addi	a1,s0,-24
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	ed0080e7          	jalr	-304(ra) # 800020c8 <argaddr>
  return wait(p);
    80002200:	fe843503          	ld	a0,-24(s0)
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	616080e7          	jalr	1558(ra) # 8000181a <wait>
}
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002214:	7179                	addi	sp,sp,-48
    80002216:	f406                	sd	ra,40(sp)
    80002218:	f022                	sd	s0,32(sp)
    8000221a:	ec26                	sd	s1,24(sp)
    8000221c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000221e:	fdc40593          	addi	a1,s0,-36
    80002222:	4501                	li	a0,0
    80002224:	00000097          	auipc	ra,0x0
    80002228:	e84080e7          	jalr	-380(ra) # 800020a8 <argint>
  addr = myproc()->sz;
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	c0c080e7          	jalr	-1012(ra) # 80000e38 <myproc>
    80002234:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002236:	fdc42503          	lw	a0,-36(s0)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	f58080e7          	jalr	-168(ra) # 80001192 <growproc>
    80002242:	00054863          	bltz	a0,80002252 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002246:	8526                	mv	a0,s1
    80002248:	70a2                	ld	ra,40(sp)
    8000224a:	7402                	ld	s0,32(sp)
    8000224c:	64e2                	ld	s1,24(sp)
    8000224e:	6145                	addi	sp,sp,48
    80002250:	8082                	ret
    return -1;
    80002252:	54fd                	li	s1,-1
    80002254:	bfcd                	j	80002246 <sys_sbrk+0x32>

0000000080002256 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002256:	7139                	addi	sp,sp,-64
    80002258:	fc06                	sd	ra,56(sp)
    8000225a:	f822                	sd	s0,48(sp)
    8000225c:	f426                	sd	s1,40(sp)
    8000225e:	f04a                	sd	s2,32(sp)
    80002260:	ec4e                	sd	s3,24(sp)
    80002262:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002264:	fcc40593          	addi	a1,s0,-52
    80002268:	4501                	li	a0,0
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	e3e080e7          	jalr	-450(ra) # 800020a8 <argint>
  if(n < 0)
    80002272:	fcc42783          	lw	a5,-52(s0)
    80002276:	0607cf63          	bltz	a5,800022f4 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000227a:	00018517          	auipc	a0,0x18
    8000227e:	4b650513          	addi	a0,a0,1206 # 8001a730 <tickslock>
    80002282:	00004097          	auipc	ra,0x4
    80002286:	2a8080e7          	jalr	680(ra) # 8000652a <acquire>
  ticks0 = ticks;
    8000228a:	00006917          	auipc	s2,0x6
    8000228e:	63e92903          	lw	s2,1598(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002292:	fcc42783          	lw	a5,-52(s0)
    80002296:	cf9d                	beqz	a5,800022d4 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002298:	00018997          	auipc	s3,0x18
    8000229c:	49898993          	addi	s3,s3,1176 # 8001a730 <tickslock>
    800022a0:	00006497          	auipc	s1,0x6
    800022a4:	62848493          	addi	s1,s1,1576 # 800088c8 <ticks>
    if(killed(myproc())){
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	b90080e7          	jalr	-1136(ra) # 80000e38 <myproc>
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	538080e7          	jalr	1336(ra) # 800017e8 <killed>
    800022b8:	e129                	bnez	a0,800022fa <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022ba:	85ce                	mv	a1,s3
    800022bc:	8526                	mv	a0,s1
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	282080e7          	jalr	642(ra) # 80001540 <sleep>
  while(ticks - ticks0 < n){
    800022c6:	409c                	lw	a5,0(s1)
    800022c8:	412787bb          	subw	a5,a5,s2
    800022cc:	fcc42703          	lw	a4,-52(s0)
    800022d0:	fce7ece3          	bltu	a5,a4,800022a8 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022d4:	00018517          	auipc	a0,0x18
    800022d8:	45c50513          	addi	a0,a0,1116 # 8001a730 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	302080e7          	jalr	770(ra) # 800065de <release>
  return 0;
    800022e4:	4501                	li	a0,0
}
    800022e6:	70e2                	ld	ra,56(sp)
    800022e8:	7442                	ld	s0,48(sp)
    800022ea:	74a2                	ld	s1,40(sp)
    800022ec:	7902                	ld	s2,32(sp)
    800022ee:	69e2                	ld	s3,24(sp)
    800022f0:	6121                	addi	sp,sp,64
    800022f2:	8082                	ret
    n = 0;
    800022f4:	fc042623          	sw	zero,-52(s0)
    800022f8:	b749                	j	8000227a <sys_sleep+0x24>
      release(&tickslock);
    800022fa:	00018517          	auipc	a0,0x18
    800022fe:	43650513          	addi	a0,a0,1078 # 8001a730 <tickslock>
    80002302:	00004097          	auipc	ra,0x4
    80002306:	2dc080e7          	jalr	732(ra) # 800065de <release>
      return -1;
    8000230a:	557d                	li	a0,-1
    8000230c:	bfe9                	j	800022e6 <sys_sleep+0x90>

000000008000230e <sys_kill>:

uint64
sys_kill(void)
{
    8000230e:	1101                	addi	sp,sp,-32
    80002310:	ec06                	sd	ra,24(sp)
    80002312:	e822                	sd	s0,16(sp)
    80002314:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002316:	fec40593          	addi	a1,s0,-20
    8000231a:	4501                	li	a0,0
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	d8c080e7          	jalr	-628(ra) # 800020a8 <argint>
  return kill(pid);
    80002324:	fec42503          	lw	a0,-20(s0)
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	422080e7          	jalr	1058(ra) # 8000174a <kill>
}
    80002330:	60e2                	ld	ra,24(sp)
    80002332:	6442                	ld	s0,16(sp)
    80002334:	6105                	addi	sp,sp,32
    80002336:	8082                	ret

0000000080002338 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002338:	1101                	addi	sp,sp,-32
    8000233a:	ec06                	sd	ra,24(sp)
    8000233c:	e822                	sd	s0,16(sp)
    8000233e:	e426                	sd	s1,8(sp)
    80002340:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002342:	00018517          	auipc	a0,0x18
    80002346:	3ee50513          	addi	a0,a0,1006 # 8001a730 <tickslock>
    8000234a:	00004097          	auipc	ra,0x4
    8000234e:	1e0080e7          	jalr	480(ra) # 8000652a <acquire>
  xticks = ticks;
    80002352:	00006497          	auipc	s1,0x6
    80002356:	5764a483          	lw	s1,1398(s1) # 800088c8 <ticks>
  release(&tickslock);
    8000235a:	00018517          	auipc	a0,0x18
    8000235e:	3d650513          	addi	a0,a0,982 # 8001a730 <tickslock>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	27c080e7          	jalr	636(ra) # 800065de <release>
  return xticks;
}
    8000236a:	02049513          	slli	a0,s1,0x20
    8000236e:	9101                	srli	a0,a0,0x20
    80002370:	60e2                	ld	ra,24(sp)
    80002372:	6442                	ld	s0,16(sp)
    80002374:	64a2                	ld	s1,8(sp)
    80002376:	6105                	addi	sp,sp,32
    80002378:	8082                	ret

000000008000237a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000237a:	7179                	addi	sp,sp,-48
    8000237c:	f406                	sd	ra,40(sp)
    8000237e:	f022                	sd	s0,32(sp)
    80002380:	ec26                	sd	s1,24(sp)
    80002382:	e84a                	sd	s2,16(sp)
    80002384:	e44e                	sd	s3,8(sp)
    80002386:	e052                	sd	s4,0(sp)
    80002388:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000238a:	00006597          	auipc	a1,0x6
    8000238e:	10658593          	addi	a1,a1,262 # 80008490 <syscalls+0xc0>
    80002392:	00018517          	auipc	a0,0x18
    80002396:	3b650513          	addi	a0,a0,950 # 8001a748 <bcache>
    8000239a:	00004097          	auipc	ra,0x4
    8000239e:	100080e7          	jalr	256(ra) # 8000649a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023a2:	00020797          	auipc	a5,0x20
    800023a6:	3a678793          	addi	a5,a5,934 # 80022748 <bcache+0x8000>
    800023aa:	00020717          	auipc	a4,0x20
    800023ae:	60670713          	addi	a4,a4,1542 # 800229b0 <bcache+0x8268>
    800023b2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ba:	00018497          	auipc	s1,0x18
    800023be:	3a648493          	addi	s1,s1,934 # 8001a760 <bcache+0x18>
    b->next = bcache.head.next;
    800023c2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c6:	00006a17          	auipc	s4,0x6
    800023ca:	0d2a0a13          	addi	s4,s4,210 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023ce:	2b893783          	ld	a5,696(s2)
    800023d2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d8:	85d2                	mv	a1,s4
    800023da:	01048513          	addi	a0,s1,16
    800023de:	00001097          	auipc	ra,0x1
    800023e2:	4ca080e7          	jalr	1226(ra) # 800038a8 <initsleeplock>
    bcache.head.next->prev = b;
    800023e6:	2b893783          	ld	a5,696(s2)
    800023ea:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ec:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023f0:	45848493          	addi	s1,s1,1112
    800023f4:	fd349de3          	bne	s1,s3,800023ce <binit+0x54>
  }
}
    800023f8:	70a2                	ld	ra,40(sp)
    800023fa:	7402                	ld	s0,32(sp)
    800023fc:	64e2                	ld	s1,24(sp)
    800023fe:	6942                	ld	s2,16(sp)
    80002400:	69a2                	ld	s3,8(sp)
    80002402:	6a02                	ld	s4,0(sp)
    80002404:	6145                	addi	sp,sp,48
    80002406:	8082                	ret

0000000080002408 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002408:	7179                	addi	sp,sp,-48
    8000240a:	f406                	sd	ra,40(sp)
    8000240c:	f022                	sd	s0,32(sp)
    8000240e:	ec26                	sd	s1,24(sp)
    80002410:	e84a                	sd	s2,16(sp)
    80002412:	e44e                	sd	s3,8(sp)
    80002414:	1800                	addi	s0,sp,48
    80002416:	892a                	mv	s2,a0
    80002418:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000241a:	00018517          	auipc	a0,0x18
    8000241e:	32e50513          	addi	a0,a0,814 # 8001a748 <bcache>
    80002422:	00004097          	auipc	ra,0x4
    80002426:	108080e7          	jalr	264(ra) # 8000652a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000242a:	00020497          	auipc	s1,0x20
    8000242e:	5d64b483          	ld	s1,1494(s1) # 80022a00 <bcache+0x82b8>
    80002432:	00020797          	auipc	a5,0x20
    80002436:	57e78793          	addi	a5,a5,1406 # 800229b0 <bcache+0x8268>
    8000243a:	02f48f63          	beq	s1,a5,80002478 <bread+0x70>
    8000243e:	873e                	mv	a4,a5
    80002440:	a021                	j	80002448 <bread+0x40>
    80002442:	68a4                	ld	s1,80(s1)
    80002444:	02e48a63          	beq	s1,a4,80002478 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002448:	449c                	lw	a5,8(s1)
    8000244a:	ff279ce3          	bne	a5,s2,80002442 <bread+0x3a>
    8000244e:	44dc                	lw	a5,12(s1)
    80002450:	ff3799e3          	bne	a5,s3,80002442 <bread+0x3a>
      b->refcnt++;
    80002454:	40bc                	lw	a5,64(s1)
    80002456:	2785                	addiw	a5,a5,1
    80002458:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000245a:	00018517          	auipc	a0,0x18
    8000245e:	2ee50513          	addi	a0,a0,750 # 8001a748 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	17c080e7          	jalr	380(ra) # 800065de <release>
      acquiresleep(&b->lock);
    8000246a:	01048513          	addi	a0,s1,16
    8000246e:	00001097          	auipc	ra,0x1
    80002472:	474080e7          	jalr	1140(ra) # 800038e2 <acquiresleep>
      return b;
    80002476:	a8b9                	j	800024d4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002478:	00020497          	auipc	s1,0x20
    8000247c:	5804b483          	ld	s1,1408(s1) # 800229f8 <bcache+0x82b0>
    80002480:	00020797          	auipc	a5,0x20
    80002484:	53078793          	addi	a5,a5,1328 # 800229b0 <bcache+0x8268>
    80002488:	00f48863          	beq	s1,a5,80002498 <bread+0x90>
    8000248c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000248e:	40bc                	lw	a5,64(s1)
    80002490:	cf81                	beqz	a5,800024a8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002492:	64a4                	ld	s1,72(s1)
    80002494:	fee49de3          	bne	s1,a4,8000248e <bread+0x86>
  panic("bget: no buffers");
    80002498:	00006517          	auipc	a0,0x6
    8000249c:	00850513          	addi	a0,a0,8 # 800084a0 <syscalls+0xd0>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	b4e080e7          	jalr	-1202(ra) # 80005fee <panic>
      b->dev = dev;
    800024a8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024ac:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024b0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b4:	4785                	li	a5,1
    800024b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b8:	00018517          	auipc	a0,0x18
    800024bc:	29050513          	addi	a0,a0,656 # 8001a748 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	11e080e7          	jalr	286(ra) # 800065de <release>
      acquiresleep(&b->lock);
    800024c8:	01048513          	addi	a0,s1,16
    800024cc:	00001097          	auipc	ra,0x1
    800024d0:	416080e7          	jalr	1046(ra) # 800038e2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024d4:	409c                	lw	a5,0(s1)
    800024d6:	cb89                	beqz	a5,800024e8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d8:	8526                	mv	a0,s1
    800024da:	70a2                	ld	ra,40(sp)
    800024dc:	7402                	ld	s0,32(sp)
    800024de:	64e2                	ld	s1,24(sp)
    800024e0:	6942                	ld	s2,16(sp)
    800024e2:	69a2                	ld	s3,8(sp)
    800024e4:	6145                	addi	sp,sp,48
    800024e6:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e8:	4581                	li	a1,0
    800024ea:	8526                	mv	a0,s1
    800024ec:	00003097          	auipc	ra,0x3
    800024f0:	2f8080e7          	jalr	760(ra) # 800057e4 <virtio_disk_rw>
    b->valid = 1;
    800024f4:	4785                	li	a5,1
    800024f6:	c09c                	sw	a5,0(s1)
  return b;
    800024f8:	b7c5                	j	800024d8 <bread+0xd0>

00000000800024fa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024fa:	1101                	addi	sp,sp,-32
    800024fc:	ec06                	sd	ra,24(sp)
    800024fe:	e822                	sd	s0,16(sp)
    80002500:	e426                	sd	s1,8(sp)
    80002502:	1000                	addi	s0,sp,32
    80002504:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002506:	0541                	addi	a0,a0,16
    80002508:	00001097          	auipc	ra,0x1
    8000250c:	474080e7          	jalr	1140(ra) # 8000397c <holdingsleep>
    80002510:	cd01                	beqz	a0,80002528 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002512:	4585                	li	a1,1
    80002514:	8526                	mv	a0,s1
    80002516:	00003097          	auipc	ra,0x3
    8000251a:	2ce080e7          	jalr	718(ra) # 800057e4 <virtio_disk_rw>
}
    8000251e:	60e2                	ld	ra,24(sp)
    80002520:	6442                	ld	s0,16(sp)
    80002522:	64a2                	ld	s1,8(sp)
    80002524:	6105                	addi	sp,sp,32
    80002526:	8082                	ret
    panic("bwrite");
    80002528:	00006517          	auipc	a0,0x6
    8000252c:	f9050513          	addi	a0,a0,-112 # 800084b8 <syscalls+0xe8>
    80002530:	00004097          	auipc	ra,0x4
    80002534:	abe080e7          	jalr	-1346(ra) # 80005fee <panic>

0000000080002538 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002538:	1101                	addi	sp,sp,-32
    8000253a:	ec06                	sd	ra,24(sp)
    8000253c:	e822                	sd	s0,16(sp)
    8000253e:	e426                	sd	s1,8(sp)
    80002540:	e04a                	sd	s2,0(sp)
    80002542:	1000                	addi	s0,sp,32
    80002544:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002546:	01050913          	addi	s2,a0,16
    8000254a:	854a                	mv	a0,s2
    8000254c:	00001097          	auipc	ra,0x1
    80002550:	430080e7          	jalr	1072(ra) # 8000397c <holdingsleep>
    80002554:	c92d                	beqz	a0,800025c6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002556:	854a                	mv	a0,s2
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	3e0080e7          	jalr	992(ra) # 80003938 <releasesleep>

  acquire(&bcache.lock);
    80002560:	00018517          	auipc	a0,0x18
    80002564:	1e850513          	addi	a0,a0,488 # 8001a748 <bcache>
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	fc2080e7          	jalr	-62(ra) # 8000652a <acquire>
  b->refcnt--;
    80002570:	40bc                	lw	a5,64(s1)
    80002572:	37fd                	addiw	a5,a5,-1
    80002574:	0007871b          	sext.w	a4,a5
    80002578:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000257a:	eb05                	bnez	a4,800025aa <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000257c:	68bc                	ld	a5,80(s1)
    8000257e:	64b8                	ld	a4,72(s1)
    80002580:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002582:	64bc                	ld	a5,72(s1)
    80002584:	68b8                	ld	a4,80(s1)
    80002586:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002588:	00020797          	auipc	a5,0x20
    8000258c:	1c078793          	addi	a5,a5,448 # 80022748 <bcache+0x8000>
    80002590:	2b87b703          	ld	a4,696(a5)
    80002594:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002596:	00020717          	auipc	a4,0x20
    8000259a:	41a70713          	addi	a4,a4,1050 # 800229b0 <bcache+0x8268>
    8000259e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025a0:	2b87b703          	ld	a4,696(a5)
    800025a4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025aa:	00018517          	auipc	a0,0x18
    800025ae:	19e50513          	addi	a0,a0,414 # 8001a748 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	02c080e7          	jalr	44(ra) # 800065de <release>
}
    800025ba:	60e2                	ld	ra,24(sp)
    800025bc:	6442                	ld	s0,16(sp)
    800025be:	64a2                	ld	s1,8(sp)
    800025c0:	6902                	ld	s2,0(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret
    panic("brelse");
    800025c6:	00006517          	auipc	a0,0x6
    800025ca:	efa50513          	addi	a0,a0,-262 # 800084c0 <syscalls+0xf0>
    800025ce:	00004097          	auipc	ra,0x4
    800025d2:	a20080e7          	jalr	-1504(ra) # 80005fee <panic>

00000000800025d6 <bpin>:

void
bpin(struct buf *b) {
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	1000                	addi	s0,sp,32
    800025e0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025e2:	00018517          	auipc	a0,0x18
    800025e6:	16650513          	addi	a0,a0,358 # 8001a748 <bcache>
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	f40080e7          	jalr	-192(ra) # 8000652a <acquire>
  b->refcnt++;
    800025f2:	40bc                	lw	a5,64(s1)
    800025f4:	2785                	addiw	a5,a5,1
    800025f6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f8:	00018517          	auipc	a0,0x18
    800025fc:	15050513          	addi	a0,a0,336 # 8001a748 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	fde080e7          	jalr	-34(ra) # 800065de <release>
}
    80002608:	60e2                	ld	ra,24(sp)
    8000260a:	6442                	ld	s0,16(sp)
    8000260c:	64a2                	ld	s1,8(sp)
    8000260e:	6105                	addi	sp,sp,32
    80002610:	8082                	ret

0000000080002612 <bunpin>:

void
bunpin(struct buf *b) {
    80002612:	1101                	addi	sp,sp,-32
    80002614:	ec06                	sd	ra,24(sp)
    80002616:	e822                	sd	s0,16(sp)
    80002618:	e426                	sd	s1,8(sp)
    8000261a:	1000                	addi	s0,sp,32
    8000261c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000261e:	00018517          	auipc	a0,0x18
    80002622:	12a50513          	addi	a0,a0,298 # 8001a748 <bcache>
    80002626:	00004097          	auipc	ra,0x4
    8000262a:	f04080e7          	jalr	-252(ra) # 8000652a <acquire>
  b->refcnt--;
    8000262e:	40bc                	lw	a5,64(s1)
    80002630:	37fd                	addiw	a5,a5,-1
    80002632:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002634:	00018517          	auipc	a0,0x18
    80002638:	11450513          	addi	a0,a0,276 # 8001a748 <bcache>
    8000263c:	00004097          	auipc	ra,0x4
    80002640:	fa2080e7          	jalr	-94(ra) # 800065de <release>
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6105                	addi	sp,sp,32
    8000264c:	8082                	ret

000000008000264e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000264e:	1101                	addi	sp,sp,-32
    80002650:	ec06                	sd	ra,24(sp)
    80002652:	e822                	sd	s0,16(sp)
    80002654:	e426                	sd	s1,8(sp)
    80002656:	e04a                	sd	s2,0(sp)
    80002658:	1000                	addi	s0,sp,32
    8000265a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000265c:	00d5d59b          	srliw	a1,a1,0xd
    80002660:	00020797          	auipc	a5,0x20
    80002664:	7c47a783          	lw	a5,1988(a5) # 80022e24 <sb+0x1c>
    80002668:	9dbd                	addw	a1,a1,a5
    8000266a:	00000097          	auipc	ra,0x0
    8000266e:	d9e080e7          	jalr	-610(ra) # 80002408 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002672:	0074f713          	andi	a4,s1,7
    80002676:	4785                	li	a5,1
    80002678:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000267c:	14ce                	slli	s1,s1,0x33
    8000267e:	90d9                	srli	s1,s1,0x36
    80002680:	00950733          	add	a4,a0,s1
    80002684:	05874703          	lbu	a4,88(a4)
    80002688:	00e7f6b3          	and	a3,a5,a4
    8000268c:	c69d                	beqz	a3,800026ba <bfree+0x6c>
    8000268e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002690:	94aa                	add	s1,s1,a0
    80002692:	fff7c793          	not	a5,a5
    80002696:	8ff9                	and	a5,a5,a4
    80002698:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	126080e7          	jalr	294(ra) # 800037c2 <log_write>
  brelse(bp);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	e92080e7          	jalr	-366(ra) # 80002538 <brelse>
}
    800026ae:	60e2                	ld	ra,24(sp)
    800026b0:	6442                	ld	s0,16(sp)
    800026b2:	64a2                	ld	s1,8(sp)
    800026b4:	6902                	ld	s2,0(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret
    panic("freeing free block");
    800026ba:	00006517          	auipc	a0,0x6
    800026be:	e0e50513          	addi	a0,a0,-498 # 800084c8 <syscalls+0xf8>
    800026c2:	00004097          	auipc	ra,0x4
    800026c6:	92c080e7          	jalr	-1748(ra) # 80005fee <panic>

00000000800026ca <balloc>:
{
    800026ca:	711d                	addi	sp,sp,-96
    800026cc:	ec86                	sd	ra,88(sp)
    800026ce:	e8a2                	sd	s0,80(sp)
    800026d0:	e4a6                	sd	s1,72(sp)
    800026d2:	e0ca                	sd	s2,64(sp)
    800026d4:	fc4e                	sd	s3,56(sp)
    800026d6:	f852                	sd	s4,48(sp)
    800026d8:	f456                	sd	s5,40(sp)
    800026da:	f05a                	sd	s6,32(sp)
    800026dc:	ec5e                	sd	s7,24(sp)
    800026de:	e862                	sd	s8,16(sp)
    800026e0:	e466                	sd	s9,8(sp)
    800026e2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026e4:	00020797          	auipc	a5,0x20
    800026e8:	7287a783          	lw	a5,1832(a5) # 80022e0c <sb+0x4>
    800026ec:	10078163          	beqz	a5,800027ee <balloc+0x124>
    800026f0:	8baa                	mv	s7,a0
    800026f2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026f4:	00020b17          	auipc	s6,0x20
    800026f8:	714b0b13          	addi	s6,s6,1812 # 80022e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026fe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002700:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002702:	6c89                	lui	s9,0x2
    80002704:	a061                	j	8000278c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002706:	974a                	add	a4,a4,s2
    80002708:	8fd5                	or	a5,a5,a3
    8000270a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000270e:	854a                	mv	a0,s2
    80002710:	00001097          	auipc	ra,0x1
    80002714:	0b2080e7          	jalr	178(ra) # 800037c2 <log_write>
        brelse(bp);
    80002718:	854a                	mv	a0,s2
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	e1e080e7          	jalr	-482(ra) # 80002538 <brelse>
  bp = bread(dev, bno);
    80002722:	85a6                	mv	a1,s1
    80002724:	855e                	mv	a0,s7
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	ce2080e7          	jalr	-798(ra) # 80002408 <bread>
    8000272e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002730:	40000613          	li	a2,1024
    80002734:	4581                	li	a1,0
    80002736:	05850513          	addi	a0,a0,88
    8000273a:	ffffe097          	auipc	ra,0xffffe
    8000273e:	a3e080e7          	jalr	-1474(ra) # 80000178 <memset>
  log_write(bp);
    80002742:	854a                	mv	a0,s2
    80002744:	00001097          	auipc	ra,0x1
    80002748:	07e080e7          	jalr	126(ra) # 800037c2 <log_write>
  brelse(bp);
    8000274c:	854a                	mv	a0,s2
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	dea080e7          	jalr	-534(ra) # 80002538 <brelse>
}
    80002756:	8526                	mv	a0,s1
    80002758:	60e6                	ld	ra,88(sp)
    8000275a:	6446                	ld	s0,80(sp)
    8000275c:	64a6                	ld	s1,72(sp)
    8000275e:	6906                	ld	s2,64(sp)
    80002760:	79e2                	ld	s3,56(sp)
    80002762:	7a42                	ld	s4,48(sp)
    80002764:	7aa2                	ld	s5,40(sp)
    80002766:	7b02                	ld	s6,32(sp)
    80002768:	6be2                	ld	s7,24(sp)
    8000276a:	6c42                	ld	s8,16(sp)
    8000276c:	6ca2                	ld	s9,8(sp)
    8000276e:	6125                	addi	sp,sp,96
    80002770:	8082                	ret
    brelse(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00000097          	auipc	ra,0x0
    80002778:	dc4080e7          	jalr	-572(ra) # 80002538 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000277c:	015c87bb          	addw	a5,s9,s5
    80002780:	00078a9b          	sext.w	s5,a5
    80002784:	004b2703          	lw	a4,4(s6)
    80002788:	06eaf363          	bgeu	s5,a4,800027ee <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000278c:	41fad79b          	sraiw	a5,s5,0x1f
    80002790:	0137d79b          	srliw	a5,a5,0x13
    80002794:	015787bb          	addw	a5,a5,s5
    80002798:	40d7d79b          	sraiw	a5,a5,0xd
    8000279c:	01cb2583          	lw	a1,28(s6)
    800027a0:	9dbd                	addw	a1,a1,a5
    800027a2:	855e                	mv	a0,s7
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	c64080e7          	jalr	-924(ra) # 80002408 <bread>
    800027ac:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ae:	004b2503          	lw	a0,4(s6)
    800027b2:	000a849b          	sext.w	s1,s5
    800027b6:	8662                	mv	a2,s8
    800027b8:	faa4fde3          	bgeu	s1,a0,80002772 <balloc+0xa8>
      m = 1 << (bi % 8);
    800027bc:	41f6579b          	sraiw	a5,a2,0x1f
    800027c0:	01d7d69b          	srliw	a3,a5,0x1d
    800027c4:	00c6873b          	addw	a4,a3,a2
    800027c8:	00777793          	andi	a5,a4,7
    800027cc:	9f95                	subw	a5,a5,a3
    800027ce:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027d2:	4037571b          	sraiw	a4,a4,0x3
    800027d6:	00e906b3          	add	a3,s2,a4
    800027da:	0586c683          	lbu	a3,88(a3)
    800027de:	00d7f5b3          	and	a1,a5,a3
    800027e2:	d195                	beqz	a1,80002706 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e4:	2605                	addiw	a2,a2,1
    800027e6:	2485                	addiw	s1,s1,1
    800027e8:	fd4618e3          	bne	a2,s4,800027b8 <balloc+0xee>
    800027ec:	b759                	j	80002772 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	cf250513          	addi	a0,a0,-782 # 800084e0 <syscalls+0x110>
    800027f6:	00004097          	auipc	ra,0x4
    800027fa:	842080e7          	jalr	-1982(ra) # 80006038 <printf>
  return 0;
    800027fe:	4481                	li	s1,0
    80002800:	bf99                	j	80002756 <balloc+0x8c>

0000000080002802 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002802:	7179                	addi	sp,sp,-48
    80002804:	f406                	sd	ra,40(sp)
    80002806:	f022                	sd	s0,32(sp)
    80002808:	ec26                	sd	s1,24(sp)
    8000280a:	e84a                	sd	s2,16(sp)
    8000280c:	e44e                	sd	s3,8(sp)
    8000280e:	e052                	sd	s4,0(sp)
    80002810:	1800                	addi	s0,sp,48
    80002812:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002814:	47ad                	li	a5,11
    80002816:	02b7e863          	bltu	a5,a1,80002846 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000281a:	02059793          	slli	a5,a1,0x20
    8000281e:	01e7d593          	srli	a1,a5,0x1e
    80002822:	00b504b3          	add	s1,a0,a1
    80002826:	0504a903          	lw	s2,80(s1)
    8000282a:	06091e63          	bnez	s2,800028a6 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000282e:	4108                	lw	a0,0(a0)
    80002830:	00000097          	auipc	ra,0x0
    80002834:	e9a080e7          	jalr	-358(ra) # 800026ca <balloc>
    80002838:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000283c:	06090563          	beqz	s2,800028a6 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002840:	0524a823          	sw	s2,80(s1)
    80002844:	a08d                	j	800028a6 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002846:	ff45849b          	addiw	s1,a1,-12
    8000284a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000284e:	0ff00793          	li	a5,255
    80002852:	08e7e563          	bltu	a5,a4,800028dc <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002856:	08052903          	lw	s2,128(a0)
    8000285a:	00091d63          	bnez	s2,80002874 <bmap+0x72>
      addr = balloc(ip->dev);
    8000285e:	4108                	lw	a0,0(a0)
    80002860:	00000097          	auipc	ra,0x0
    80002864:	e6a080e7          	jalr	-406(ra) # 800026ca <balloc>
    80002868:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000286c:	02090d63          	beqz	s2,800028a6 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002870:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002874:	85ca                	mv	a1,s2
    80002876:	0009a503          	lw	a0,0(s3)
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	b8e080e7          	jalr	-1138(ra) # 80002408 <bread>
    80002882:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002884:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002888:	02049713          	slli	a4,s1,0x20
    8000288c:	01e75593          	srli	a1,a4,0x1e
    80002890:	00b784b3          	add	s1,a5,a1
    80002894:	0004a903          	lw	s2,0(s1)
    80002898:	02090063          	beqz	s2,800028b8 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000289c:	8552                	mv	a0,s4
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	c9a080e7          	jalr	-870(ra) # 80002538 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028a6:	854a                	mv	a0,s2
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	69a2                	ld	s3,8(sp)
    800028b2:	6a02                	ld	s4,0(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
      addr = balloc(ip->dev);
    800028b8:	0009a503          	lw	a0,0(s3)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	e0e080e7          	jalr	-498(ra) # 800026ca <balloc>
    800028c4:	0005091b          	sext.w	s2,a0
      if(addr){
    800028c8:	fc090ae3          	beqz	s2,8000289c <bmap+0x9a>
        a[bn] = addr;
    800028cc:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028d0:	8552                	mv	a0,s4
    800028d2:	00001097          	auipc	ra,0x1
    800028d6:	ef0080e7          	jalr	-272(ra) # 800037c2 <log_write>
    800028da:	b7c9                	j	8000289c <bmap+0x9a>
  panic("bmap: out of range");
    800028dc:	00006517          	auipc	a0,0x6
    800028e0:	c1c50513          	addi	a0,a0,-996 # 800084f8 <syscalls+0x128>
    800028e4:	00003097          	auipc	ra,0x3
    800028e8:	70a080e7          	jalr	1802(ra) # 80005fee <panic>

00000000800028ec <iget>:
{
    800028ec:	7179                	addi	sp,sp,-48
    800028ee:	f406                	sd	ra,40(sp)
    800028f0:	f022                	sd	s0,32(sp)
    800028f2:	ec26                	sd	s1,24(sp)
    800028f4:	e84a                	sd	s2,16(sp)
    800028f6:	e44e                	sd	s3,8(sp)
    800028f8:	e052                	sd	s4,0(sp)
    800028fa:	1800                	addi	s0,sp,48
    800028fc:	89aa                	mv	s3,a0
    800028fe:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002900:	00020517          	auipc	a0,0x20
    80002904:	52850513          	addi	a0,a0,1320 # 80022e28 <itable>
    80002908:	00004097          	auipc	ra,0x4
    8000290c:	c22080e7          	jalr	-990(ra) # 8000652a <acquire>
  empty = 0;
    80002910:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002912:	00020497          	auipc	s1,0x20
    80002916:	52e48493          	addi	s1,s1,1326 # 80022e40 <itable+0x18>
    8000291a:	00022697          	auipc	a3,0x22
    8000291e:	fb668693          	addi	a3,a3,-74 # 800248d0 <log>
    80002922:	a039                	j	80002930 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002924:	02090b63          	beqz	s2,8000295a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002928:	08848493          	addi	s1,s1,136
    8000292c:	02d48a63          	beq	s1,a3,80002960 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002930:	449c                	lw	a5,8(s1)
    80002932:	fef059e3          	blez	a5,80002924 <iget+0x38>
    80002936:	4098                	lw	a4,0(s1)
    80002938:	ff3716e3          	bne	a4,s3,80002924 <iget+0x38>
    8000293c:	40d8                	lw	a4,4(s1)
    8000293e:	ff4713e3          	bne	a4,s4,80002924 <iget+0x38>
      ip->ref++;
    80002942:	2785                	addiw	a5,a5,1
    80002944:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002946:	00020517          	auipc	a0,0x20
    8000294a:	4e250513          	addi	a0,a0,1250 # 80022e28 <itable>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	c90080e7          	jalr	-880(ra) # 800065de <release>
      return ip;
    80002956:	8926                	mv	s2,s1
    80002958:	a03d                	j	80002986 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000295a:	f7f9                	bnez	a5,80002928 <iget+0x3c>
    8000295c:	8926                	mv	s2,s1
    8000295e:	b7e9                	j	80002928 <iget+0x3c>
  if(empty == 0)
    80002960:	02090c63          	beqz	s2,80002998 <iget+0xac>
  ip->dev = dev;
    80002964:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002968:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000296c:	4785                	li	a5,1
    8000296e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002972:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002976:	00020517          	auipc	a0,0x20
    8000297a:	4b250513          	addi	a0,a0,1202 # 80022e28 <itable>
    8000297e:	00004097          	auipc	ra,0x4
    80002982:	c60080e7          	jalr	-928(ra) # 800065de <release>
}
    80002986:	854a                	mv	a0,s2
    80002988:	70a2                	ld	ra,40(sp)
    8000298a:	7402                	ld	s0,32(sp)
    8000298c:	64e2                	ld	s1,24(sp)
    8000298e:	6942                	ld	s2,16(sp)
    80002990:	69a2                	ld	s3,8(sp)
    80002992:	6a02                	ld	s4,0(sp)
    80002994:	6145                	addi	sp,sp,48
    80002996:	8082                	ret
    panic("iget: no inodes");
    80002998:	00006517          	auipc	a0,0x6
    8000299c:	b7850513          	addi	a0,a0,-1160 # 80008510 <syscalls+0x140>
    800029a0:	00003097          	auipc	ra,0x3
    800029a4:	64e080e7          	jalr	1614(ra) # 80005fee <panic>

00000000800029a8 <fsinit>:
fsinit(int dev) {
    800029a8:	7179                	addi	sp,sp,-48
    800029aa:	f406                	sd	ra,40(sp)
    800029ac:	f022                	sd	s0,32(sp)
    800029ae:	ec26                	sd	s1,24(sp)
    800029b0:	e84a                	sd	s2,16(sp)
    800029b2:	e44e                	sd	s3,8(sp)
    800029b4:	1800                	addi	s0,sp,48
    800029b6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029b8:	4585                	li	a1,1
    800029ba:	00000097          	auipc	ra,0x0
    800029be:	a4e080e7          	jalr	-1458(ra) # 80002408 <bread>
    800029c2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029c4:	00020997          	auipc	s3,0x20
    800029c8:	44498993          	addi	s3,s3,1092 # 80022e08 <sb>
    800029cc:	02000613          	li	a2,32
    800029d0:	05850593          	addi	a1,a0,88
    800029d4:	854e                	mv	a0,s3
    800029d6:	ffffd097          	auipc	ra,0xffffd
    800029da:	7fe080e7          	jalr	2046(ra) # 800001d4 <memmove>
  brelse(bp);
    800029de:	8526                	mv	a0,s1
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	b58080e7          	jalr	-1192(ra) # 80002538 <brelse>
  if(sb.magic != FSMAGIC)
    800029e8:	0009a703          	lw	a4,0(s3)
    800029ec:	102037b7          	lui	a5,0x10203
    800029f0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029f4:	02f71263          	bne	a4,a5,80002a18 <fsinit+0x70>
  initlog(dev, &sb);
    800029f8:	00020597          	auipc	a1,0x20
    800029fc:	41058593          	addi	a1,a1,1040 # 80022e08 <sb>
    80002a00:	854a                	mv	a0,s2
    80002a02:	00001097          	auipc	ra,0x1
    80002a06:	b42080e7          	jalr	-1214(ra) # 80003544 <initlog>
}
    80002a0a:	70a2                	ld	ra,40(sp)
    80002a0c:	7402                	ld	s0,32(sp)
    80002a0e:	64e2                	ld	s1,24(sp)
    80002a10:	6942                	ld	s2,16(sp)
    80002a12:	69a2                	ld	s3,8(sp)
    80002a14:	6145                	addi	sp,sp,48
    80002a16:	8082                	ret
    panic("invalid file system");
    80002a18:	00006517          	auipc	a0,0x6
    80002a1c:	b0850513          	addi	a0,a0,-1272 # 80008520 <syscalls+0x150>
    80002a20:	00003097          	auipc	ra,0x3
    80002a24:	5ce080e7          	jalr	1486(ra) # 80005fee <panic>

0000000080002a28 <iinit>:
{
    80002a28:	7179                	addi	sp,sp,-48
    80002a2a:	f406                	sd	ra,40(sp)
    80002a2c:	f022                	sd	s0,32(sp)
    80002a2e:	ec26                	sd	s1,24(sp)
    80002a30:	e84a                	sd	s2,16(sp)
    80002a32:	e44e                	sd	s3,8(sp)
    80002a34:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a36:	00006597          	auipc	a1,0x6
    80002a3a:	b0258593          	addi	a1,a1,-1278 # 80008538 <syscalls+0x168>
    80002a3e:	00020517          	auipc	a0,0x20
    80002a42:	3ea50513          	addi	a0,a0,1002 # 80022e28 <itable>
    80002a46:	00004097          	auipc	ra,0x4
    80002a4a:	a54080e7          	jalr	-1452(ra) # 8000649a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a4e:	00020497          	auipc	s1,0x20
    80002a52:	40248493          	addi	s1,s1,1026 # 80022e50 <itable+0x28>
    80002a56:	00022997          	auipc	s3,0x22
    80002a5a:	e8a98993          	addi	s3,s3,-374 # 800248e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a5e:	00006917          	auipc	s2,0x6
    80002a62:	ae290913          	addi	s2,s2,-1310 # 80008540 <syscalls+0x170>
    80002a66:	85ca                	mv	a1,s2
    80002a68:	8526                	mv	a0,s1
    80002a6a:	00001097          	auipc	ra,0x1
    80002a6e:	e3e080e7          	jalr	-450(ra) # 800038a8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a72:	08848493          	addi	s1,s1,136
    80002a76:	ff3498e3          	bne	s1,s3,80002a66 <iinit+0x3e>
}
    80002a7a:	70a2                	ld	ra,40(sp)
    80002a7c:	7402                	ld	s0,32(sp)
    80002a7e:	64e2                	ld	s1,24(sp)
    80002a80:	6942                	ld	s2,16(sp)
    80002a82:	69a2                	ld	s3,8(sp)
    80002a84:	6145                	addi	sp,sp,48
    80002a86:	8082                	ret

0000000080002a88 <ialloc>:
{
    80002a88:	715d                	addi	sp,sp,-80
    80002a8a:	e486                	sd	ra,72(sp)
    80002a8c:	e0a2                	sd	s0,64(sp)
    80002a8e:	fc26                	sd	s1,56(sp)
    80002a90:	f84a                	sd	s2,48(sp)
    80002a92:	f44e                	sd	s3,40(sp)
    80002a94:	f052                	sd	s4,32(sp)
    80002a96:	ec56                	sd	s5,24(sp)
    80002a98:	e85a                	sd	s6,16(sp)
    80002a9a:	e45e                	sd	s7,8(sp)
    80002a9c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a9e:	00020717          	auipc	a4,0x20
    80002aa2:	37672703          	lw	a4,886(a4) # 80022e14 <sb+0xc>
    80002aa6:	4785                	li	a5,1
    80002aa8:	04e7fa63          	bgeu	a5,a4,80002afc <ialloc+0x74>
    80002aac:	8aaa                	mv	s5,a0
    80002aae:	8bae                	mv	s7,a1
    80002ab0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ab2:	00020a17          	auipc	s4,0x20
    80002ab6:	356a0a13          	addi	s4,s4,854 # 80022e08 <sb>
    80002aba:	00048b1b          	sext.w	s6,s1
    80002abe:	0044d793          	srli	a5,s1,0x4
    80002ac2:	018a2583          	lw	a1,24(s4)
    80002ac6:	9dbd                	addw	a1,a1,a5
    80002ac8:	8556                	mv	a0,s5
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	93e080e7          	jalr	-1730(ra) # 80002408 <bread>
    80002ad2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ad4:	05850993          	addi	s3,a0,88
    80002ad8:	00f4f793          	andi	a5,s1,15
    80002adc:	079a                	slli	a5,a5,0x6
    80002ade:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ae0:	00099783          	lh	a5,0(s3)
    80002ae4:	c3a1                	beqz	a5,80002b24 <ialloc+0x9c>
    brelse(bp);
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	a52080e7          	jalr	-1454(ra) # 80002538 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aee:	0485                	addi	s1,s1,1
    80002af0:	00ca2703          	lw	a4,12(s4)
    80002af4:	0004879b          	sext.w	a5,s1
    80002af8:	fce7e1e3          	bltu	a5,a4,80002aba <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002afc:	00006517          	auipc	a0,0x6
    80002b00:	a4c50513          	addi	a0,a0,-1460 # 80008548 <syscalls+0x178>
    80002b04:	00003097          	auipc	ra,0x3
    80002b08:	534080e7          	jalr	1332(ra) # 80006038 <printf>
  return 0;
    80002b0c:	4501                	li	a0,0
}
    80002b0e:	60a6                	ld	ra,72(sp)
    80002b10:	6406                	ld	s0,64(sp)
    80002b12:	74e2                	ld	s1,56(sp)
    80002b14:	7942                	ld	s2,48(sp)
    80002b16:	79a2                	ld	s3,40(sp)
    80002b18:	7a02                	ld	s4,32(sp)
    80002b1a:	6ae2                	ld	s5,24(sp)
    80002b1c:	6b42                	ld	s6,16(sp)
    80002b1e:	6ba2                	ld	s7,8(sp)
    80002b20:	6161                	addi	sp,sp,80
    80002b22:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b24:	04000613          	li	a2,64
    80002b28:	4581                	li	a1,0
    80002b2a:	854e                	mv	a0,s3
    80002b2c:	ffffd097          	auipc	ra,0xffffd
    80002b30:	64c080e7          	jalr	1612(ra) # 80000178 <memset>
      dip->type = type;
    80002b34:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	c88080e7          	jalr	-888(ra) # 800037c2 <log_write>
      brelse(bp);
    80002b42:	854a                	mv	a0,s2
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	9f4080e7          	jalr	-1548(ra) # 80002538 <brelse>
      return iget(dev, inum);
    80002b4c:	85da                	mv	a1,s6
    80002b4e:	8556                	mv	a0,s5
    80002b50:	00000097          	auipc	ra,0x0
    80002b54:	d9c080e7          	jalr	-612(ra) # 800028ec <iget>
    80002b58:	bf5d                	j	80002b0e <ialloc+0x86>

0000000080002b5a <iupdate>:
{
    80002b5a:	1101                	addi	sp,sp,-32
    80002b5c:	ec06                	sd	ra,24(sp)
    80002b5e:	e822                	sd	s0,16(sp)
    80002b60:	e426                	sd	s1,8(sp)
    80002b62:	e04a                	sd	s2,0(sp)
    80002b64:	1000                	addi	s0,sp,32
    80002b66:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b68:	415c                	lw	a5,4(a0)
    80002b6a:	0047d79b          	srliw	a5,a5,0x4
    80002b6e:	00020597          	auipc	a1,0x20
    80002b72:	2b25a583          	lw	a1,690(a1) # 80022e20 <sb+0x18>
    80002b76:	9dbd                	addw	a1,a1,a5
    80002b78:	4108                	lw	a0,0(a0)
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	88e080e7          	jalr	-1906(ra) # 80002408 <bread>
    80002b82:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b84:	05850793          	addi	a5,a0,88
    80002b88:	40c8                	lw	a0,4(s1)
    80002b8a:	893d                	andi	a0,a0,15
    80002b8c:	051a                	slli	a0,a0,0x6
    80002b8e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b90:	04449703          	lh	a4,68(s1)
    80002b94:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b98:	04649703          	lh	a4,70(s1)
    80002b9c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ba0:	04849703          	lh	a4,72(s1)
    80002ba4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ba8:	04a49703          	lh	a4,74(s1)
    80002bac:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bb0:	44f8                	lw	a4,76(s1)
    80002bb2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bb4:	03400613          	li	a2,52
    80002bb8:	05048593          	addi	a1,s1,80
    80002bbc:	0531                	addi	a0,a0,12
    80002bbe:	ffffd097          	auipc	ra,0xffffd
    80002bc2:	616080e7          	jalr	1558(ra) # 800001d4 <memmove>
  log_write(bp);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	bfa080e7          	jalr	-1030(ra) # 800037c2 <log_write>
  brelse(bp);
    80002bd0:	854a                	mv	a0,s2
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	966080e7          	jalr	-1690(ra) # 80002538 <brelse>
}
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6902                	ld	s2,0(sp)
    80002be2:	6105                	addi	sp,sp,32
    80002be4:	8082                	ret

0000000080002be6 <idup>:
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	1000                	addi	s0,sp,32
    80002bf0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bf2:	00020517          	auipc	a0,0x20
    80002bf6:	23650513          	addi	a0,a0,566 # 80022e28 <itable>
    80002bfa:	00004097          	auipc	ra,0x4
    80002bfe:	930080e7          	jalr	-1744(ra) # 8000652a <acquire>
  ip->ref++;
    80002c02:	449c                	lw	a5,8(s1)
    80002c04:	2785                	addiw	a5,a5,1
    80002c06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c08:	00020517          	auipc	a0,0x20
    80002c0c:	22050513          	addi	a0,a0,544 # 80022e28 <itable>
    80002c10:	00004097          	auipc	ra,0x4
    80002c14:	9ce080e7          	jalr	-1586(ra) # 800065de <release>
}
    80002c18:	8526                	mv	a0,s1
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6105                	addi	sp,sp,32
    80002c22:	8082                	ret

0000000080002c24 <ilock>:
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	e04a                	sd	s2,0(sp)
    80002c2e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c30:	c115                	beqz	a0,80002c54 <ilock+0x30>
    80002c32:	84aa                	mv	s1,a0
    80002c34:	451c                	lw	a5,8(a0)
    80002c36:	00f05f63          	blez	a5,80002c54 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c3a:	0541                	addi	a0,a0,16
    80002c3c:	00001097          	auipc	ra,0x1
    80002c40:	ca6080e7          	jalr	-858(ra) # 800038e2 <acquiresleep>
  if(ip->valid == 0){
    80002c44:	40bc                	lw	a5,64(s1)
    80002c46:	cf99                	beqz	a5,80002c64 <ilock+0x40>
}
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	64a2                	ld	s1,8(sp)
    80002c4e:	6902                	ld	s2,0(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret
    panic("ilock");
    80002c54:	00006517          	auipc	a0,0x6
    80002c58:	90c50513          	addi	a0,a0,-1780 # 80008560 <syscalls+0x190>
    80002c5c:	00003097          	auipc	ra,0x3
    80002c60:	392080e7          	jalr	914(ra) # 80005fee <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c64:	40dc                	lw	a5,4(s1)
    80002c66:	0047d79b          	srliw	a5,a5,0x4
    80002c6a:	00020597          	auipc	a1,0x20
    80002c6e:	1b65a583          	lw	a1,438(a1) # 80022e20 <sb+0x18>
    80002c72:	9dbd                	addw	a1,a1,a5
    80002c74:	4088                	lw	a0,0(s1)
    80002c76:	fffff097          	auipc	ra,0xfffff
    80002c7a:	792080e7          	jalr	1938(ra) # 80002408 <bread>
    80002c7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c80:	05850593          	addi	a1,a0,88
    80002c84:	40dc                	lw	a5,4(s1)
    80002c86:	8bbd                	andi	a5,a5,15
    80002c88:	079a                	slli	a5,a5,0x6
    80002c8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c8c:	00059783          	lh	a5,0(a1)
    80002c90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c94:	00259783          	lh	a5,2(a1)
    80002c98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c9c:	00459783          	lh	a5,4(a1)
    80002ca0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ca4:	00659783          	lh	a5,6(a1)
    80002ca8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cac:	459c                	lw	a5,8(a1)
    80002cae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cb0:	03400613          	li	a2,52
    80002cb4:	05b1                	addi	a1,a1,12
    80002cb6:	05048513          	addi	a0,s1,80
    80002cba:	ffffd097          	auipc	ra,0xffffd
    80002cbe:	51a080e7          	jalr	1306(ra) # 800001d4 <memmove>
    brelse(bp);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	00000097          	auipc	ra,0x0
    80002cc8:	874080e7          	jalr	-1932(ra) # 80002538 <brelse>
    ip->valid = 1;
    80002ccc:	4785                	li	a5,1
    80002cce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cd0:	04449783          	lh	a5,68(s1)
    80002cd4:	fbb5                	bnez	a5,80002c48 <ilock+0x24>
      panic("ilock: no type");
    80002cd6:	00006517          	auipc	a0,0x6
    80002cda:	89250513          	addi	a0,a0,-1902 # 80008568 <syscalls+0x198>
    80002cde:	00003097          	auipc	ra,0x3
    80002ce2:	310080e7          	jalr	784(ra) # 80005fee <panic>

0000000080002ce6 <iunlock>:
{
    80002ce6:	1101                	addi	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	e426                	sd	s1,8(sp)
    80002cee:	e04a                	sd	s2,0(sp)
    80002cf0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cf2:	c905                	beqz	a0,80002d22 <iunlock+0x3c>
    80002cf4:	84aa                	mv	s1,a0
    80002cf6:	01050913          	addi	s2,a0,16
    80002cfa:	854a                	mv	a0,s2
    80002cfc:	00001097          	auipc	ra,0x1
    80002d00:	c80080e7          	jalr	-896(ra) # 8000397c <holdingsleep>
    80002d04:	cd19                	beqz	a0,80002d22 <iunlock+0x3c>
    80002d06:	449c                	lw	a5,8(s1)
    80002d08:	00f05d63          	blez	a5,80002d22 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d0c:	854a                	mv	a0,s2
    80002d0e:	00001097          	auipc	ra,0x1
    80002d12:	c2a080e7          	jalr	-982(ra) # 80003938 <releasesleep>
}
    80002d16:	60e2                	ld	ra,24(sp)
    80002d18:	6442                	ld	s0,16(sp)
    80002d1a:	64a2                	ld	s1,8(sp)
    80002d1c:	6902                	ld	s2,0(sp)
    80002d1e:	6105                	addi	sp,sp,32
    80002d20:	8082                	ret
    panic("iunlock");
    80002d22:	00006517          	auipc	a0,0x6
    80002d26:	85650513          	addi	a0,a0,-1962 # 80008578 <syscalls+0x1a8>
    80002d2a:	00003097          	auipc	ra,0x3
    80002d2e:	2c4080e7          	jalr	708(ra) # 80005fee <panic>

0000000080002d32 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d32:	7179                	addi	sp,sp,-48
    80002d34:	f406                	sd	ra,40(sp)
    80002d36:	f022                	sd	s0,32(sp)
    80002d38:	ec26                	sd	s1,24(sp)
    80002d3a:	e84a                	sd	s2,16(sp)
    80002d3c:	e44e                	sd	s3,8(sp)
    80002d3e:	e052                	sd	s4,0(sp)
    80002d40:	1800                	addi	s0,sp,48
    80002d42:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d44:	05050493          	addi	s1,a0,80
    80002d48:	08050913          	addi	s2,a0,128
    80002d4c:	a021                	j	80002d54 <itrunc+0x22>
    80002d4e:	0491                	addi	s1,s1,4
    80002d50:	01248d63          	beq	s1,s2,80002d6a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d54:	408c                	lw	a1,0(s1)
    80002d56:	dde5                	beqz	a1,80002d4e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	8f2080e7          	jalr	-1806(ra) # 8000264e <bfree>
      ip->addrs[i] = 0;
    80002d64:	0004a023          	sw	zero,0(s1)
    80002d68:	b7dd                	j	80002d4e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d6a:	0809a583          	lw	a1,128(s3)
    80002d6e:	e185                	bnez	a1,80002d8e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d70:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d74:	854e                	mv	a0,s3
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	de4080e7          	jalr	-540(ra) # 80002b5a <iupdate>
}
    80002d7e:	70a2                	ld	ra,40(sp)
    80002d80:	7402                	ld	s0,32(sp)
    80002d82:	64e2                	ld	s1,24(sp)
    80002d84:	6942                	ld	s2,16(sp)
    80002d86:	69a2                	ld	s3,8(sp)
    80002d88:	6a02                	ld	s4,0(sp)
    80002d8a:	6145                	addi	sp,sp,48
    80002d8c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d8e:	0009a503          	lw	a0,0(s3)
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	676080e7          	jalr	1654(ra) # 80002408 <bread>
    80002d9a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d9c:	05850493          	addi	s1,a0,88
    80002da0:	45850913          	addi	s2,a0,1112
    80002da4:	a021                	j	80002dac <itrunc+0x7a>
    80002da6:	0491                	addi	s1,s1,4
    80002da8:	01248b63          	beq	s1,s2,80002dbe <itrunc+0x8c>
      if(a[j])
    80002dac:	408c                	lw	a1,0(s1)
    80002dae:	dde5                	beqz	a1,80002da6 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002db0:	0009a503          	lw	a0,0(s3)
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	89a080e7          	jalr	-1894(ra) # 8000264e <bfree>
    80002dbc:	b7ed                	j	80002da6 <itrunc+0x74>
    brelse(bp);
    80002dbe:	8552                	mv	a0,s4
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	778080e7          	jalr	1912(ra) # 80002538 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc8:	0809a583          	lw	a1,128(s3)
    80002dcc:	0009a503          	lw	a0,0(s3)
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	87e080e7          	jalr	-1922(ra) # 8000264e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dd8:	0809a023          	sw	zero,128(s3)
    80002ddc:	bf51                	j	80002d70 <itrunc+0x3e>

0000000080002dde <iput>:
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	e04a                	sd	s2,0(sp)
    80002de8:	1000                	addi	s0,sp,32
    80002dea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dec:	00020517          	auipc	a0,0x20
    80002df0:	03c50513          	addi	a0,a0,60 # 80022e28 <itable>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	736080e7          	jalr	1846(ra) # 8000652a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfc:	4498                	lw	a4,8(s1)
    80002dfe:	4785                	li	a5,1
    80002e00:	02f70363          	beq	a4,a5,80002e26 <iput+0x48>
  ip->ref--;
    80002e04:	449c                	lw	a5,8(s1)
    80002e06:	37fd                	addiw	a5,a5,-1
    80002e08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e0a:	00020517          	auipc	a0,0x20
    80002e0e:	01e50513          	addi	a0,a0,30 # 80022e28 <itable>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	7cc080e7          	jalr	1996(ra) # 800065de <release>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6902                	ld	s2,0(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e26:	40bc                	lw	a5,64(s1)
    80002e28:	dff1                	beqz	a5,80002e04 <iput+0x26>
    80002e2a:	04a49783          	lh	a5,74(s1)
    80002e2e:	fbf9                	bnez	a5,80002e04 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e30:	01048913          	addi	s2,s1,16
    80002e34:	854a                	mv	a0,s2
    80002e36:	00001097          	auipc	ra,0x1
    80002e3a:	aac080e7          	jalr	-1364(ra) # 800038e2 <acquiresleep>
    release(&itable.lock);
    80002e3e:	00020517          	auipc	a0,0x20
    80002e42:	fea50513          	addi	a0,a0,-22 # 80022e28 <itable>
    80002e46:	00003097          	auipc	ra,0x3
    80002e4a:	798080e7          	jalr	1944(ra) # 800065de <release>
    itrunc(ip);
    80002e4e:	8526                	mv	a0,s1
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	ee2080e7          	jalr	-286(ra) # 80002d32 <itrunc>
    ip->type = 0;
    80002e58:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	cfc080e7          	jalr	-772(ra) # 80002b5a <iupdate>
    ip->valid = 0;
    80002e66:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	00001097          	auipc	ra,0x1
    80002e70:	acc080e7          	jalr	-1332(ra) # 80003938 <releasesleep>
    acquire(&itable.lock);
    80002e74:	00020517          	auipc	a0,0x20
    80002e78:	fb450513          	addi	a0,a0,-76 # 80022e28 <itable>
    80002e7c:	00003097          	auipc	ra,0x3
    80002e80:	6ae080e7          	jalr	1710(ra) # 8000652a <acquire>
    80002e84:	b741                	j	80002e04 <iput+0x26>

0000000080002e86 <iunlockput>:
{
    80002e86:	1101                	addi	sp,sp,-32
    80002e88:	ec06                	sd	ra,24(sp)
    80002e8a:	e822                	sd	s0,16(sp)
    80002e8c:	e426                	sd	s1,8(sp)
    80002e8e:	1000                	addi	s0,sp,32
    80002e90:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	e54080e7          	jalr	-428(ra) # 80002ce6 <iunlock>
  iput(ip);
    80002e9a:	8526                	mv	a0,s1
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	f42080e7          	jalr	-190(ra) # 80002dde <iput>
}
    80002ea4:	60e2                	ld	ra,24(sp)
    80002ea6:	6442                	ld	s0,16(sp)
    80002ea8:	64a2                	ld	s1,8(sp)
    80002eaa:	6105                	addi	sp,sp,32
    80002eac:	8082                	ret

0000000080002eae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eae:	1141                	addi	sp,sp,-16
    80002eb0:	e422                	sd	s0,8(sp)
    80002eb2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eb4:	411c                	lw	a5,0(a0)
    80002eb6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eb8:	415c                	lw	a5,4(a0)
    80002eba:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ebc:	04451783          	lh	a5,68(a0)
    80002ec0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ec4:	04a51783          	lh	a5,74(a0)
    80002ec8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ecc:	04c56783          	lwu	a5,76(a0)
    80002ed0:	e99c                	sd	a5,16(a1)
}
    80002ed2:	6422                	ld	s0,8(sp)
    80002ed4:	0141                	addi	sp,sp,16
    80002ed6:	8082                	ret

0000000080002ed8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ed8:	457c                	lw	a5,76(a0)
    80002eda:	0ed7e963          	bltu	a5,a3,80002fcc <readi+0xf4>
{
    80002ede:	7159                	addi	sp,sp,-112
    80002ee0:	f486                	sd	ra,104(sp)
    80002ee2:	f0a2                	sd	s0,96(sp)
    80002ee4:	eca6                	sd	s1,88(sp)
    80002ee6:	e8ca                	sd	s2,80(sp)
    80002ee8:	e4ce                	sd	s3,72(sp)
    80002eea:	e0d2                	sd	s4,64(sp)
    80002eec:	fc56                	sd	s5,56(sp)
    80002eee:	f85a                	sd	s6,48(sp)
    80002ef0:	f45e                	sd	s7,40(sp)
    80002ef2:	f062                	sd	s8,32(sp)
    80002ef4:	ec66                	sd	s9,24(sp)
    80002ef6:	e86a                	sd	s10,16(sp)
    80002ef8:	e46e                	sd	s11,8(sp)
    80002efa:	1880                	addi	s0,sp,112
    80002efc:	8b2a                	mv	s6,a0
    80002efe:	8bae                	mv	s7,a1
    80002f00:	8a32                	mv	s4,a2
    80002f02:	84b6                	mv	s1,a3
    80002f04:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f06:	9f35                	addw	a4,a4,a3
    return 0;
    80002f08:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f0a:	0ad76063          	bltu	a4,a3,80002faa <readi+0xd2>
  if(off + n > ip->size)
    80002f0e:	00e7f463          	bgeu	a5,a4,80002f16 <readi+0x3e>
    n = ip->size - off;
    80002f12:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f16:	0a0a8963          	beqz	s5,80002fc8 <readi+0xf0>
    80002f1a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f20:	5c7d                	li	s8,-1
    80002f22:	a82d                	j	80002f5c <readi+0x84>
    80002f24:	020d1d93          	slli	s11,s10,0x20
    80002f28:	020ddd93          	srli	s11,s11,0x20
    80002f2c:	05890793          	addi	a5,s2,88
    80002f30:	86ee                	mv	a3,s11
    80002f32:	963e                	add	a2,a2,a5
    80002f34:	85d2                	mv	a1,s4
    80002f36:	855e                	mv	a0,s7
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	a10080e7          	jalr	-1520(ra) # 80001948 <either_copyout>
    80002f40:	05850d63          	beq	a0,s8,80002f9a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f44:	854a                	mv	a0,s2
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	5f2080e7          	jalr	1522(ra) # 80002538 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f4e:	013d09bb          	addw	s3,s10,s3
    80002f52:	009d04bb          	addw	s1,s10,s1
    80002f56:	9a6e                	add	s4,s4,s11
    80002f58:	0559f763          	bgeu	s3,s5,80002fa6 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f5c:	00a4d59b          	srliw	a1,s1,0xa
    80002f60:	855a                	mv	a0,s6
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	8a0080e7          	jalr	-1888(ra) # 80002802 <bmap>
    80002f6a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f6e:	cd85                	beqz	a1,80002fa6 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f70:	000b2503          	lw	a0,0(s6)
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	494080e7          	jalr	1172(ra) # 80002408 <bread>
    80002f7c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7e:	3ff4f613          	andi	a2,s1,1023
    80002f82:	40cc87bb          	subw	a5,s9,a2
    80002f86:	413a873b          	subw	a4,s5,s3
    80002f8a:	8d3e                	mv	s10,a5
    80002f8c:	2781                	sext.w	a5,a5
    80002f8e:	0007069b          	sext.w	a3,a4
    80002f92:	f8f6f9e3          	bgeu	a3,a5,80002f24 <readi+0x4c>
    80002f96:	8d3a                	mv	s10,a4
    80002f98:	b771                	j	80002f24 <readi+0x4c>
      brelse(bp);
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	59c080e7          	jalr	1436(ra) # 80002538 <brelse>
      tot = -1;
    80002fa4:	59fd                	li	s3,-1
  }
  return tot;
    80002fa6:	0009851b          	sext.w	a0,s3
}
    80002faa:	70a6                	ld	ra,104(sp)
    80002fac:	7406                	ld	s0,96(sp)
    80002fae:	64e6                	ld	s1,88(sp)
    80002fb0:	6946                	ld	s2,80(sp)
    80002fb2:	69a6                	ld	s3,72(sp)
    80002fb4:	6a06                	ld	s4,64(sp)
    80002fb6:	7ae2                	ld	s5,56(sp)
    80002fb8:	7b42                	ld	s6,48(sp)
    80002fba:	7ba2                	ld	s7,40(sp)
    80002fbc:	7c02                	ld	s8,32(sp)
    80002fbe:	6ce2                	ld	s9,24(sp)
    80002fc0:	6d42                	ld	s10,16(sp)
    80002fc2:	6da2                	ld	s11,8(sp)
    80002fc4:	6165                	addi	sp,sp,112
    80002fc6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc8:	89d6                	mv	s3,s5
    80002fca:	bff1                	j	80002fa6 <readi+0xce>
    return 0;
    80002fcc:	4501                	li	a0,0
}
    80002fce:	8082                	ret

0000000080002fd0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd0:	457c                	lw	a5,76(a0)
    80002fd2:	10d7e863          	bltu	a5,a3,800030e2 <writei+0x112>
{
    80002fd6:	7159                	addi	sp,sp,-112
    80002fd8:	f486                	sd	ra,104(sp)
    80002fda:	f0a2                	sd	s0,96(sp)
    80002fdc:	eca6                	sd	s1,88(sp)
    80002fde:	e8ca                	sd	s2,80(sp)
    80002fe0:	e4ce                	sd	s3,72(sp)
    80002fe2:	e0d2                	sd	s4,64(sp)
    80002fe4:	fc56                	sd	s5,56(sp)
    80002fe6:	f85a                	sd	s6,48(sp)
    80002fe8:	f45e                	sd	s7,40(sp)
    80002fea:	f062                	sd	s8,32(sp)
    80002fec:	ec66                	sd	s9,24(sp)
    80002fee:	e86a                	sd	s10,16(sp)
    80002ff0:	e46e                	sd	s11,8(sp)
    80002ff2:	1880                	addi	s0,sp,112
    80002ff4:	8aaa                	mv	s5,a0
    80002ff6:	8bae                	mv	s7,a1
    80002ff8:	8a32                	mv	s4,a2
    80002ffa:	8936                	mv	s2,a3
    80002ffc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ffe:	00e687bb          	addw	a5,a3,a4
    80003002:	0ed7e263          	bltu	a5,a3,800030e6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003006:	00043737          	lui	a4,0x43
    8000300a:	0ef76063          	bltu	a4,a5,800030ea <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000300e:	0c0b0863          	beqz	s6,800030de <writei+0x10e>
    80003012:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003014:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003018:	5c7d                	li	s8,-1
    8000301a:	a091                	j	8000305e <writei+0x8e>
    8000301c:	020d1d93          	slli	s11,s10,0x20
    80003020:	020ddd93          	srli	s11,s11,0x20
    80003024:	05848793          	addi	a5,s1,88
    80003028:	86ee                	mv	a3,s11
    8000302a:	8652                	mv	a2,s4
    8000302c:	85de                	mv	a1,s7
    8000302e:	953e                	add	a0,a0,a5
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	96e080e7          	jalr	-1682(ra) # 8000199e <either_copyin>
    80003038:	07850263          	beq	a0,s8,8000309c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000303c:	8526                	mv	a0,s1
    8000303e:	00000097          	auipc	ra,0x0
    80003042:	784080e7          	jalr	1924(ra) # 800037c2 <log_write>
    brelse(bp);
    80003046:	8526                	mv	a0,s1
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	4f0080e7          	jalr	1264(ra) # 80002538 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003050:	013d09bb          	addw	s3,s10,s3
    80003054:	012d093b          	addw	s2,s10,s2
    80003058:	9a6e                	add	s4,s4,s11
    8000305a:	0569f663          	bgeu	s3,s6,800030a6 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000305e:	00a9559b          	srliw	a1,s2,0xa
    80003062:	8556                	mv	a0,s5
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	79e080e7          	jalr	1950(ra) # 80002802 <bmap>
    8000306c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003070:	c99d                	beqz	a1,800030a6 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003072:	000aa503          	lw	a0,0(s5)
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	392080e7          	jalr	914(ra) # 80002408 <bread>
    8000307e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003080:	3ff97513          	andi	a0,s2,1023
    80003084:	40ac87bb          	subw	a5,s9,a0
    80003088:	413b073b          	subw	a4,s6,s3
    8000308c:	8d3e                	mv	s10,a5
    8000308e:	2781                	sext.w	a5,a5
    80003090:	0007069b          	sext.w	a3,a4
    80003094:	f8f6f4e3          	bgeu	a3,a5,8000301c <writei+0x4c>
    80003098:	8d3a                	mv	s10,a4
    8000309a:	b749                	j	8000301c <writei+0x4c>
      brelse(bp);
    8000309c:	8526                	mv	a0,s1
    8000309e:	fffff097          	auipc	ra,0xfffff
    800030a2:	49a080e7          	jalr	1178(ra) # 80002538 <brelse>
  }

  if(off > ip->size)
    800030a6:	04caa783          	lw	a5,76(s5)
    800030aa:	0127f463          	bgeu	a5,s2,800030b2 <writei+0xe2>
    ip->size = off;
    800030ae:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030b2:	8556                	mv	a0,s5
    800030b4:	00000097          	auipc	ra,0x0
    800030b8:	aa6080e7          	jalr	-1370(ra) # 80002b5a <iupdate>

  return tot;
    800030bc:	0009851b          	sext.w	a0,s3
}
    800030c0:	70a6                	ld	ra,104(sp)
    800030c2:	7406                	ld	s0,96(sp)
    800030c4:	64e6                	ld	s1,88(sp)
    800030c6:	6946                	ld	s2,80(sp)
    800030c8:	69a6                	ld	s3,72(sp)
    800030ca:	6a06                	ld	s4,64(sp)
    800030cc:	7ae2                	ld	s5,56(sp)
    800030ce:	7b42                	ld	s6,48(sp)
    800030d0:	7ba2                	ld	s7,40(sp)
    800030d2:	7c02                	ld	s8,32(sp)
    800030d4:	6ce2                	ld	s9,24(sp)
    800030d6:	6d42                	ld	s10,16(sp)
    800030d8:	6da2                	ld	s11,8(sp)
    800030da:	6165                	addi	sp,sp,112
    800030dc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030de:	89da                	mv	s3,s6
    800030e0:	bfc9                	j	800030b2 <writei+0xe2>
    return -1;
    800030e2:	557d                	li	a0,-1
}
    800030e4:	8082                	ret
    return -1;
    800030e6:	557d                	li	a0,-1
    800030e8:	bfe1                	j	800030c0 <writei+0xf0>
    return -1;
    800030ea:	557d                	li	a0,-1
    800030ec:	bfd1                	j	800030c0 <writei+0xf0>

00000000800030ee <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030ee:	1141                	addi	sp,sp,-16
    800030f0:	e406                	sd	ra,8(sp)
    800030f2:	e022                	sd	s0,0(sp)
    800030f4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030f6:	4639                	li	a2,14
    800030f8:	ffffd097          	auipc	ra,0xffffd
    800030fc:	150080e7          	jalr	336(ra) # 80000248 <strncmp>
}
    80003100:	60a2                	ld	ra,8(sp)
    80003102:	6402                	ld	s0,0(sp)
    80003104:	0141                	addi	sp,sp,16
    80003106:	8082                	ret

0000000080003108 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003108:	7139                	addi	sp,sp,-64
    8000310a:	fc06                	sd	ra,56(sp)
    8000310c:	f822                	sd	s0,48(sp)
    8000310e:	f426                	sd	s1,40(sp)
    80003110:	f04a                	sd	s2,32(sp)
    80003112:	ec4e                	sd	s3,24(sp)
    80003114:	e852                	sd	s4,16(sp)
    80003116:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003118:	04451703          	lh	a4,68(a0)
    8000311c:	4785                	li	a5,1
    8000311e:	00f71a63          	bne	a4,a5,80003132 <dirlookup+0x2a>
    80003122:	892a                	mv	s2,a0
    80003124:	89ae                	mv	s3,a1
    80003126:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003128:	457c                	lw	a5,76(a0)
    8000312a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000312c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000312e:	e79d                	bnez	a5,8000315c <dirlookup+0x54>
    80003130:	a8a5                	j	800031a8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003132:	00005517          	auipc	a0,0x5
    80003136:	44e50513          	addi	a0,a0,1102 # 80008580 <syscalls+0x1b0>
    8000313a:	00003097          	auipc	ra,0x3
    8000313e:	eb4080e7          	jalr	-332(ra) # 80005fee <panic>
      panic("dirlookup read");
    80003142:	00005517          	auipc	a0,0x5
    80003146:	45650513          	addi	a0,a0,1110 # 80008598 <syscalls+0x1c8>
    8000314a:	00003097          	auipc	ra,0x3
    8000314e:	ea4080e7          	jalr	-348(ra) # 80005fee <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003152:	24c1                	addiw	s1,s1,16
    80003154:	04c92783          	lw	a5,76(s2)
    80003158:	04f4f763          	bgeu	s1,a5,800031a6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000315c:	4741                	li	a4,16
    8000315e:	86a6                	mv	a3,s1
    80003160:	fc040613          	addi	a2,s0,-64
    80003164:	4581                	li	a1,0
    80003166:	854a                	mv	a0,s2
    80003168:	00000097          	auipc	ra,0x0
    8000316c:	d70080e7          	jalr	-656(ra) # 80002ed8 <readi>
    80003170:	47c1                	li	a5,16
    80003172:	fcf518e3          	bne	a0,a5,80003142 <dirlookup+0x3a>
    if(de.inum == 0)
    80003176:	fc045783          	lhu	a5,-64(s0)
    8000317a:	dfe1                	beqz	a5,80003152 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000317c:	fc240593          	addi	a1,s0,-62
    80003180:	854e                	mv	a0,s3
    80003182:	00000097          	auipc	ra,0x0
    80003186:	f6c080e7          	jalr	-148(ra) # 800030ee <namecmp>
    8000318a:	f561                	bnez	a0,80003152 <dirlookup+0x4a>
      if(poff)
    8000318c:	000a0463          	beqz	s4,80003194 <dirlookup+0x8c>
        *poff = off;
    80003190:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003194:	fc045583          	lhu	a1,-64(s0)
    80003198:	00092503          	lw	a0,0(s2)
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	750080e7          	jalr	1872(ra) # 800028ec <iget>
    800031a4:	a011                	j	800031a8 <dirlookup+0xa0>
  return 0;
    800031a6:	4501                	li	a0,0
}
    800031a8:	70e2                	ld	ra,56(sp)
    800031aa:	7442                	ld	s0,48(sp)
    800031ac:	74a2                	ld	s1,40(sp)
    800031ae:	7902                	ld	s2,32(sp)
    800031b0:	69e2                	ld	s3,24(sp)
    800031b2:	6a42                	ld	s4,16(sp)
    800031b4:	6121                	addi	sp,sp,64
    800031b6:	8082                	ret

00000000800031b8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031b8:	711d                	addi	sp,sp,-96
    800031ba:	ec86                	sd	ra,88(sp)
    800031bc:	e8a2                	sd	s0,80(sp)
    800031be:	e4a6                	sd	s1,72(sp)
    800031c0:	e0ca                	sd	s2,64(sp)
    800031c2:	fc4e                	sd	s3,56(sp)
    800031c4:	f852                	sd	s4,48(sp)
    800031c6:	f456                	sd	s5,40(sp)
    800031c8:	f05a                	sd	s6,32(sp)
    800031ca:	ec5e                	sd	s7,24(sp)
    800031cc:	e862                	sd	s8,16(sp)
    800031ce:	e466                	sd	s9,8(sp)
    800031d0:	1080                	addi	s0,sp,96
    800031d2:	84aa                	mv	s1,a0
    800031d4:	8aae                	mv	s5,a1
    800031d6:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031d8:	00054703          	lbu	a4,0(a0)
    800031dc:	02f00793          	li	a5,47
    800031e0:	02f70363          	beq	a4,a5,80003206 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	c54080e7          	jalr	-940(ra) # 80000e38 <myproc>
    800031ec:	15053503          	ld	a0,336(a0)
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	9f6080e7          	jalr	-1546(ra) # 80002be6 <idup>
    800031f8:	89aa                	mv	s3,a0
  while(*path == '/')
    800031fa:	02f00913          	li	s2,47
  len = path - s;
    800031fe:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003200:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003202:	4b85                	li	s7,1
    80003204:	a865                	j	800032bc <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003206:	4585                	li	a1,1
    80003208:	4505                	li	a0,1
    8000320a:	fffff097          	auipc	ra,0xfffff
    8000320e:	6e2080e7          	jalr	1762(ra) # 800028ec <iget>
    80003212:	89aa                	mv	s3,a0
    80003214:	b7dd                	j	800031fa <namex+0x42>
      iunlockput(ip);
    80003216:	854e                	mv	a0,s3
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	c6e080e7          	jalr	-914(ra) # 80002e86 <iunlockput>
      return 0;
    80003220:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003222:	854e                	mv	a0,s3
    80003224:	60e6                	ld	ra,88(sp)
    80003226:	6446                	ld	s0,80(sp)
    80003228:	64a6                	ld	s1,72(sp)
    8000322a:	6906                	ld	s2,64(sp)
    8000322c:	79e2                	ld	s3,56(sp)
    8000322e:	7a42                	ld	s4,48(sp)
    80003230:	7aa2                	ld	s5,40(sp)
    80003232:	7b02                	ld	s6,32(sp)
    80003234:	6be2                	ld	s7,24(sp)
    80003236:	6c42                	ld	s8,16(sp)
    80003238:	6ca2                	ld	s9,8(sp)
    8000323a:	6125                	addi	sp,sp,96
    8000323c:	8082                	ret
      iunlock(ip);
    8000323e:	854e                	mv	a0,s3
    80003240:	00000097          	auipc	ra,0x0
    80003244:	aa6080e7          	jalr	-1370(ra) # 80002ce6 <iunlock>
      return ip;
    80003248:	bfe9                	j	80003222 <namex+0x6a>
      iunlockput(ip);
    8000324a:	854e                	mv	a0,s3
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	c3a080e7          	jalr	-966(ra) # 80002e86 <iunlockput>
      return 0;
    80003254:	89e6                	mv	s3,s9
    80003256:	b7f1                	j	80003222 <namex+0x6a>
  len = path - s;
    80003258:	40b48633          	sub	a2,s1,a1
    8000325c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003260:	099c5463          	bge	s8,s9,800032e8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003264:	4639                	li	a2,14
    80003266:	8552                	mv	a0,s4
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	f6c080e7          	jalr	-148(ra) # 800001d4 <memmove>
  while(*path == '/')
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	01279763          	bne	a5,s2,80003282 <namex+0xca>
    path++;
    80003278:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	ff278de3          	beq	a5,s2,80003278 <namex+0xc0>
    ilock(ip);
    80003282:	854e                	mv	a0,s3
    80003284:	00000097          	auipc	ra,0x0
    80003288:	9a0080e7          	jalr	-1632(ra) # 80002c24 <ilock>
    if(ip->type != T_DIR){
    8000328c:	04499783          	lh	a5,68(s3)
    80003290:	f97793e3          	bne	a5,s7,80003216 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003294:	000a8563          	beqz	s5,8000329e <namex+0xe6>
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	d3cd                	beqz	a5,8000323e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000329e:	865a                	mv	a2,s6
    800032a0:	85d2                	mv	a1,s4
    800032a2:	854e                	mv	a0,s3
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	e64080e7          	jalr	-412(ra) # 80003108 <dirlookup>
    800032ac:	8caa                	mv	s9,a0
    800032ae:	dd51                	beqz	a0,8000324a <namex+0x92>
    iunlockput(ip);
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	bd4080e7          	jalr	-1068(ra) # 80002e86 <iunlockput>
    ip = next;
    800032ba:	89e6                	mv	s3,s9
  while(*path == '/')
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	05279763          	bne	a5,s2,8000330e <namex+0x156>
    path++;
    800032c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	ff278de3          	beq	a5,s2,800032c4 <namex+0x10c>
  if(*path == 0)
    800032ce:	c79d                	beqz	a5,800032fc <namex+0x144>
    path++;
    800032d0:	85a6                	mv	a1,s1
  len = path - s;
    800032d2:	8cda                	mv	s9,s6
    800032d4:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800032d6:	01278963          	beq	a5,s2,800032e8 <namex+0x130>
    800032da:	dfbd                	beqz	a5,80003258 <namex+0xa0>
    path++;
    800032dc:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032de:	0004c783          	lbu	a5,0(s1)
    800032e2:	ff279ce3          	bne	a5,s2,800032da <namex+0x122>
    800032e6:	bf8d                	j	80003258 <namex+0xa0>
    memmove(name, s, len);
    800032e8:	2601                	sext.w	a2,a2
    800032ea:	8552                	mv	a0,s4
    800032ec:	ffffd097          	auipc	ra,0xffffd
    800032f0:	ee8080e7          	jalr	-280(ra) # 800001d4 <memmove>
    name[len] = 0;
    800032f4:	9cd2                	add	s9,s9,s4
    800032f6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032fa:	bf9d                	j	80003270 <namex+0xb8>
  if(nameiparent){
    800032fc:	f20a83e3          	beqz	s5,80003222 <namex+0x6a>
    iput(ip);
    80003300:	854e                	mv	a0,s3
    80003302:	00000097          	auipc	ra,0x0
    80003306:	adc080e7          	jalr	-1316(ra) # 80002dde <iput>
    return 0;
    8000330a:	4981                	li	s3,0
    8000330c:	bf19                	j	80003222 <namex+0x6a>
  if(*path == 0)
    8000330e:	d7fd                	beqz	a5,800032fc <namex+0x144>
  while(*path != '/' && *path != 0)
    80003310:	0004c783          	lbu	a5,0(s1)
    80003314:	85a6                	mv	a1,s1
    80003316:	b7d1                	j	800032da <namex+0x122>

0000000080003318 <dirlink>:
{
    80003318:	7139                	addi	sp,sp,-64
    8000331a:	fc06                	sd	ra,56(sp)
    8000331c:	f822                	sd	s0,48(sp)
    8000331e:	f426                	sd	s1,40(sp)
    80003320:	f04a                	sd	s2,32(sp)
    80003322:	ec4e                	sd	s3,24(sp)
    80003324:	e852                	sd	s4,16(sp)
    80003326:	0080                	addi	s0,sp,64
    80003328:	892a                	mv	s2,a0
    8000332a:	8a2e                	mv	s4,a1
    8000332c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000332e:	4601                	li	a2,0
    80003330:	00000097          	auipc	ra,0x0
    80003334:	dd8080e7          	jalr	-552(ra) # 80003108 <dirlookup>
    80003338:	e93d                	bnez	a0,800033ae <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000333a:	04c92483          	lw	s1,76(s2)
    8000333e:	c49d                	beqz	s1,8000336c <dirlink+0x54>
    80003340:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003342:	4741                	li	a4,16
    80003344:	86a6                	mv	a3,s1
    80003346:	fc040613          	addi	a2,s0,-64
    8000334a:	4581                	li	a1,0
    8000334c:	854a                	mv	a0,s2
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	b8a080e7          	jalr	-1142(ra) # 80002ed8 <readi>
    80003356:	47c1                	li	a5,16
    80003358:	06f51163          	bne	a0,a5,800033ba <dirlink+0xa2>
    if(de.inum == 0)
    8000335c:	fc045783          	lhu	a5,-64(s0)
    80003360:	c791                	beqz	a5,8000336c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003362:	24c1                	addiw	s1,s1,16
    80003364:	04c92783          	lw	a5,76(s2)
    80003368:	fcf4ede3          	bltu	s1,a5,80003342 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000336c:	4639                	li	a2,14
    8000336e:	85d2                	mv	a1,s4
    80003370:	fc240513          	addi	a0,s0,-62
    80003374:	ffffd097          	auipc	ra,0xffffd
    80003378:	f10080e7          	jalr	-240(ra) # 80000284 <strncpy>
  de.inum = inum;
    8000337c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003380:	4741                	li	a4,16
    80003382:	86a6                	mv	a3,s1
    80003384:	fc040613          	addi	a2,s0,-64
    80003388:	4581                	li	a1,0
    8000338a:	854a                	mv	a0,s2
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	c44080e7          	jalr	-956(ra) # 80002fd0 <writei>
    80003394:	1541                	addi	a0,a0,-16
    80003396:	00a03533          	snez	a0,a0
    8000339a:	40a00533          	neg	a0,a0
}
    8000339e:	70e2                	ld	ra,56(sp)
    800033a0:	7442                	ld	s0,48(sp)
    800033a2:	74a2                	ld	s1,40(sp)
    800033a4:	7902                	ld	s2,32(sp)
    800033a6:	69e2                	ld	s3,24(sp)
    800033a8:	6a42                	ld	s4,16(sp)
    800033aa:	6121                	addi	sp,sp,64
    800033ac:	8082                	ret
    iput(ip);
    800033ae:	00000097          	auipc	ra,0x0
    800033b2:	a30080e7          	jalr	-1488(ra) # 80002dde <iput>
    return -1;
    800033b6:	557d                	li	a0,-1
    800033b8:	b7dd                	j	8000339e <dirlink+0x86>
      panic("dirlink read");
    800033ba:	00005517          	auipc	a0,0x5
    800033be:	1ee50513          	addi	a0,a0,494 # 800085a8 <syscalls+0x1d8>
    800033c2:	00003097          	auipc	ra,0x3
    800033c6:	c2c080e7          	jalr	-980(ra) # 80005fee <panic>

00000000800033ca <namei>:

struct inode*
namei(char *path)
{
    800033ca:	1101                	addi	sp,sp,-32
    800033cc:	ec06                	sd	ra,24(sp)
    800033ce:	e822                	sd	s0,16(sp)
    800033d0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033d2:	fe040613          	addi	a2,s0,-32
    800033d6:	4581                	li	a1,0
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	de0080e7          	jalr	-544(ra) # 800031b8 <namex>
}
    800033e0:	60e2                	ld	ra,24(sp)
    800033e2:	6442                	ld	s0,16(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033e8:	1141                	addi	sp,sp,-16
    800033ea:	e406                	sd	ra,8(sp)
    800033ec:	e022                	sd	s0,0(sp)
    800033ee:	0800                	addi	s0,sp,16
    800033f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033f2:	4585                	li	a1,1
    800033f4:	00000097          	auipc	ra,0x0
    800033f8:	dc4080e7          	jalr	-572(ra) # 800031b8 <namex>
}
    800033fc:	60a2                	ld	ra,8(sp)
    800033fe:	6402                	ld	s0,0(sp)
    80003400:	0141                	addi	sp,sp,16
    80003402:	8082                	ret

0000000080003404 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003404:	1101                	addi	sp,sp,-32
    80003406:	ec06                	sd	ra,24(sp)
    80003408:	e822                	sd	s0,16(sp)
    8000340a:	e426                	sd	s1,8(sp)
    8000340c:	e04a                	sd	s2,0(sp)
    8000340e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003410:	00021917          	auipc	s2,0x21
    80003414:	4c090913          	addi	s2,s2,1216 # 800248d0 <log>
    80003418:	01892583          	lw	a1,24(s2)
    8000341c:	02892503          	lw	a0,40(s2)
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	fe8080e7          	jalr	-24(ra) # 80002408 <bread>
    80003428:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000342a:	02c92683          	lw	a3,44(s2)
    8000342e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003430:	02d05863          	blez	a3,80003460 <write_head+0x5c>
    80003434:	00021797          	auipc	a5,0x21
    80003438:	4cc78793          	addi	a5,a5,1228 # 80024900 <log+0x30>
    8000343c:	05c50713          	addi	a4,a0,92
    80003440:	36fd                	addiw	a3,a3,-1
    80003442:	02069613          	slli	a2,a3,0x20
    80003446:	01e65693          	srli	a3,a2,0x1e
    8000344a:	00021617          	auipc	a2,0x21
    8000344e:	4ba60613          	addi	a2,a2,1210 # 80024904 <log+0x34>
    80003452:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003454:	4390                	lw	a2,0(a5)
    80003456:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003458:	0791                	addi	a5,a5,4
    8000345a:	0711                	addi	a4,a4,4
    8000345c:	fed79ce3          	bne	a5,a3,80003454 <write_head+0x50>
  }
  bwrite(buf);
    80003460:	8526                	mv	a0,s1
    80003462:	fffff097          	auipc	ra,0xfffff
    80003466:	098080e7          	jalr	152(ra) # 800024fa <bwrite>
  brelse(buf);
    8000346a:	8526                	mv	a0,s1
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	0cc080e7          	jalr	204(ra) # 80002538 <brelse>
}
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	64a2                	ld	s1,8(sp)
    8000347a:	6902                	ld	s2,0(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003480:	00021797          	auipc	a5,0x21
    80003484:	47c7a783          	lw	a5,1148(a5) # 800248fc <log+0x2c>
    80003488:	0af05d63          	blez	a5,80003542 <install_trans+0xc2>
{
    8000348c:	7139                	addi	sp,sp,-64
    8000348e:	fc06                	sd	ra,56(sp)
    80003490:	f822                	sd	s0,48(sp)
    80003492:	f426                	sd	s1,40(sp)
    80003494:	f04a                	sd	s2,32(sp)
    80003496:	ec4e                	sd	s3,24(sp)
    80003498:	e852                	sd	s4,16(sp)
    8000349a:	e456                	sd	s5,8(sp)
    8000349c:	e05a                	sd	s6,0(sp)
    8000349e:	0080                	addi	s0,sp,64
    800034a0:	8b2a                	mv	s6,a0
    800034a2:	00021a97          	auipc	s5,0x21
    800034a6:	45ea8a93          	addi	s5,s5,1118 # 80024900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034aa:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ac:	00021997          	auipc	s3,0x21
    800034b0:	42498993          	addi	s3,s3,1060 # 800248d0 <log>
    800034b4:	a00d                	j	800034d6 <install_trans+0x56>
    brelse(lbuf);
    800034b6:	854a                	mv	a0,s2
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	080080e7          	jalr	128(ra) # 80002538 <brelse>
    brelse(dbuf);
    800034c0:	8526                	mv	a0,s1
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	076080e7          	jalr	118(ra) # 80002538 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ca:	2a05                	addiw	s4,s4,1
    800034cc:	0a91                	addi	s5,s5,4
    800034ce:	02c9a783          	lw	a5,44(s3)
    800034d2:	04fa5e63          	bge	s4,a5,8000352e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034d6:	0189a583          	lw	a1,24(s3)
    800034da:	014585bb          	addw	a1,a1,s4
    800034de:	2585                	addiw	a1,a1,1
    800034e0:	0289a503          	lw	a0,40(s3)
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	f24080e7          	jalr	-220(ra) # 80002408 <bread>
    800034ec:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ee:	000aa583          	lw	a1,0(s5)
    800034f2:	0289a503          	lw	a0,40(s3)
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	f12080e7          	jalr	-238(ra) # 80002408 <bread>
    800034fe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003500:	40000613          	li	a2,1024
    80003504:	05890593          	addi	a1,s2,88
    80003508:	05850513          	addi	a0,a0,88
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	cc8080e7          	jalr	-824(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003514:	8526                	mv	a0,s1
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	fe4080e7          	jalr	-28(ra) # 800024fa <bwrite>
    if(recovering == 0)
    8000351e:	f80b1ce3          	bnez	s6,800034b6 <install_trans+0x36>
      bunpin(dbuf);
    80003522:	8526                	mv	a0,s1
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	0ee080e7          	jalr	238(ra) # 80002612 <bunpin>
    8000352c:	b769                	j	800034b6 <install_trans+0x36>
}
    8000352e:	70e2                	ld	ra,56(sp)
    80003530:	7442                	ld	s0,48(sp)
    80003532:	74a2                	ld	s1,40(sp)
    80003534:	7902                	ld	s2,32(sp)
    80003536:	69e2                	ld	s3,24(sp)
    80003538:	6a42                	ld	s4,16(sp)
    8000353a:	6aa2                	ld	s5,8(sp)
    8000353c:	6b02                	ld	s6,0(sp)
    8000353e:	6121                	addi	sp,sp,64
    80003540:	8082                	ret
    80003542:	8082                	ret

0000000080003544 <initlog>:
{
    80003544:	7179                	addi	sp,sp,-48
    80003546:	f406                	sd	ra,40(sp)
    80003548:	f022                	sd	s0,32(sp)
    8000354a:	ec26                	sd	s1,24(sp)
    8000354c:	e84a                	sd	s2,16(sp)
    8000354e:	e44e                	sd	s3,8(sp)
    80003550:	1800                	addi	s0,sp,48
    80003552:	892a                	mv	s2,a0
    80003554:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003556:	00021497          	auipc	s1,0x21
    8000355a:	37a48493          	addi	s1,s1,890 # 800248d0 <log>
    8000355e:	00005597          	auipc	a1,0x5
    80003562:	05a58593          	addi	a1,a1,90 # 800085b8 <syscalls+0x1e8>
    80003566:	8526                	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	f32080e7          	jalr	-206(ra) # 8000649a <initlock>
  log.start = sb->logstart;
    80003570:	0149a583          	lw	a1,20(s3)
    80003574:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003576:	0109a783          	lw	a5,16(s3)
    8000357a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000357c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003580:	854a                	mv	a0,s2
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	e86080e7          	jalr	-378(ra) # 80002408 <bread>
  log.lh.n = lh->n;
    8000358a:	4d34                	lw	a3,88(a0)
    8000358c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000358e:	02d05663          	blez	a3,800035ba <initlog+0x76>
    80003592:	05c50793          	addi	a5,a0,92
    80003596:	00021717          	auipc	a4,0x21
    8000359a:	36a70713          	addi	a4,a4,874 # 80024900 <log+0x30>
    8000359e:	36fd                	addiw	a3,a3,-1
    800035a0:	02069613          	slli	a2,a3,0x20
    800035a4:	01e65693          	srli	a3,a2,0x1e
    800035a8:	06050613          	addi	a2,a0,96
    800035ac:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035ae:	4390                	lw	a2,0(a5)
    800035b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b2:	0791                	addi	a5,a5,4
    800035b4:	0711                	addi	a4,a4,4
    800035b6:	fed79ce3          	bne	a5,a3,800035ae <initlog+0x6a>
  brelse(buf);
    800035ba:	fffff097          	auipc	ra,0xfffff
    800035be:	f7e080e7          	jalr	-130(ra) # 80002538 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035c2:	4505                	li	a0,1
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	ebc080e7          	jalr	-324(ra) # 80003480 <install_trans>
  log.lh.n = 0;
    800035cc:	00021797          	auipc	a5,0x21
    800035d0:	3207a823          	sw	zero,816(a5) # 800248fc <log+0x2c>
  write_head(); // clear the log
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	e30080e7          	jalr	-464(ra) # 80003404 <write_head>
}
    800035dc:	70a2                	ld	ra,40(sp)
    800035de:	7402                	ld	s0,32(sp)
    800035e0:	64e2                	ld	s1,24(sp)
    800035e2:	6942                	ld	s2,16(sp)
    800035e4:	69a2                	ld	s3,8(sp)
    800035e6:	6145                	addi	sp,sp,48
    800035e8:	8082                	ret

00000000800035ea <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ea:	1101                	addi	sp,sp,-32
    800035ec:	ec06                	sd	ra,24(sp)
    800035ee:	e822                	sd	s0,16(sp)
    800035f0:	e426                	sd	s1,8(sp)
    800035f2:	e04a                	sd	s2,0(sp)
    800035f4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035f6:	00021517          	auipc	a0,0x21
    800035fa:	2da50513          	addi	a0,a0,730 # 800248d0 <log>
    800035fe:	00003097          	auipc	ra,0x3
    80003602:	f2c080e7          	jalr	-212(ra) # 8000652a <acquire>
  while(1){
    if(log.committing){
    80003606:	00021497          	auipc	s1,0x21
    8000360a:	2ca48493          	addi	s1,s1,714 # 800248d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000360e:	4979                	li	s2,30
    80003610:	a039                	j	8000361e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003612:	85a6                	mv	a1,s1
    80003614:	8526                	mv	a0,s1
    80003616:	ffffe097          	auipc	ra,0xffffe
    8000361a:	f2a080e7          	jalr	-214(ra) # 80001540 <sleep>
    if(log.committing){
    8000361e:	50dc                	lw	a5,36(s1)
    80003620:	fbed                	bnez	a5,80003612 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003622:	509c                	lw	a5,32(s1)
    80003624:	0017871b          	addiw	a4,a5,1
    80003628:	0007069b          	sext.w	a3,a4
    8000362c:	0027179b          	slliw	a5,a4,0x2
    80003630:	9fb9                	addw	a5,a5,a4
    80003632:	0017979b          	slliw	a5,a5,0x1
    80003636:	54d8                	lw	a4,44(s1)
    80003638:	9fb9                	addw	a5,a5,a4
    8000363a:	00f95963          	bge	s2,a5,8000364c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000363e:	85a6                	mv	a1,s1
    80003640:	8526                	mv	a0,s1
    80003642:	ffffe097          	auipc	ra,0xffffe
    80003646:	efe080e7          	jalr	-258(ra) # 80001540 <sleep>
    8000364a:	bfd1                	j	8000361e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000364c:	00021517          	auipc	a0,0x21
    80003650:	28450513          	addi	a0,a0,644 # 800248d0 <log>
    80003654:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	f88080e7          	jalr	-120(ra) # 800065de <release>
      break;
    }
  }
}
    8000365e:	60e2                	ld	ra,24(sp)
    80003660:	6442                	ld	s0,16(sp)
    80003662:	64a2                	ld	s1,8(sp)
    80003664:	6902                	ld	s2,0(sp)
    80003666:	6105                	addi	sp,sp,32
    80003668:	8082                	ret

000000008000366a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000366a:	7139                	addi	sp,sp,-64
    8000366c:	fc06                	sd	ra,56(sp)
    8000366e:	f822                	sd	s0,48(sp)
    80003670:	f426                	sd	s1,40(sp)
    80003672:	f04a                	sd	s2,32(sp)
    80003674:	ec4e                	sd	s3,24(sp)
    80003676:	e852                	sd	s4,16(sp)
    80003678:	e456                	sd	s5,8(sp)
    8000367a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367c:	00021497          	auipc	s1,0x21
    80003680:	25448493          	addi	s1,s1,596 # 800248d0 <log>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	ea4080e7          	jalr	-348(ra) # 8000652a <acquire>
  log.outstanding -= 1;
    8000368e:	509c                	lw	a5,32(s1)
    80003690:	37fd                	addiw	a5,a5,-1
    80003692:	0007891b          	sext.w	s2,a5
    80003696:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003698:	50dc                	lw	a5,36(s1)
    8000369a:	e7b9                	bnez	a5,800036e8 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000369c:	04091e63          	bnez	s2,800036f8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a0:	00021497          	auipc	s1,0x21
    800036a4:	23048493          	addi	s1,s1,560 # 800248d0 <log>
    800036a8:	4785                	li	a5,1
    800036aa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	f30080e7          	jalr	-208(ra) # 800065de <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036b6:	54dc                	lw	a5,44(s1)
    800036b8:	06f04763          	bgtz	a5,80003726 <end_op+0xbc>
    acquire(&log.lock);
    800036bc:	00021497          	auipc	s1,0x21
    800036c0:	21448493          	addi	s1,s1,532 # 800248d0 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	e64080e7          	jalr	-412(ra) # 8000652a <acquire>
    log.committing = 0;
    800036ce:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d2:	8526                	mv	a0,s1
    800036d4:	ffffe097          	auipc	ra,0xffffe
    800036d8:	ed0080e7          	jalr	-304(ra) # 800015a4 <wakeup>
    release(&log.lock);
    800036dc:	8526                	mv	a0,s1
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	f00080e7          	jalr	-256(ra) # 800065de <release>
}
    800036e6:	a03d                	j	80003714 <end_op+0xaa>
    panic("log.committing");
    800036e8:	00005517          	auipc	a0,0x5
    800036ec:	ed850513          	addi	a0,a0,-296 # 800085c0 <syscalls+0x1f0>
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	8fe080e7          	jalr	-1794(ra) # 80005fee <panic>
    wakeup(&log);
    800036f8:	00021497          	auipc	s1,0x21
    800036fc:	1d848493          	addi	s1,s1,472 # 800248d0 <log>
    80003700:	8526                	mv	a0,s1
    80003702:	ffffe097          	auipc	ra,0xffffe
    80003706:	ea2080e7          	jalr	-350(ra) # 800015a4 <wakeup>
  release(&log.lock);
    8000370a:	8526                	mv	a0,s1
    8000370c:	00003097          	auipc	ra,0x3
    80003710:	ed2080e7          	jalr	-302(ra) # 800065de <release>
}
    80003714:	70e2                	ld	ra,56(sp)
    80003716:	7442                	ld	s0,48(sp)
    80003718:	74a2                	ld	s1,40(sp)
    8000371a:	7902                	ld	s2,32(sp)
    8000371c:	69e2                	ld	s3,24(sp)
    8000371e:	6a42                	ld	s4,16(sp)
    80003720:	6aa2                	ld	s5,8(sp)
    80003722:	6121                	addi	sp,sp,64
    80003724:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003726:	00021a97          	auipc	s5,0x21
    8000372a:	1daa8a93          	addi	s5,s5,474 # 80024900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000372e:	00021a17          	auipc	s4,0x21
    80003732:	1a2a0a13          	addi	s4,s4,418 # 800248d0 <log>
    80003736:	018a2583          	lw	a1,24(s4)
    8000373a:	012585bb          	addw	a1,a1,s2
    8000373e:	2585                	addiw	a1,a1,1
    80003740:	028a2503          	lw	a0,40(s4)
    80003744:	fffff097          	auipc	ra,0xfffff
    80003748:	cc4080e7          	jalr	-828(ra) # 80002408 <bread>
    8000374c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000374e:	000aa583          	lw	a1,0(s5)
    80003752:	028a2503          	lw	a0,40(s4)
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	cb2080e7          	jalr	-846(ra) # 80002408 <bread>
    8000375e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003760:	40000613          	li	a2,1024
    80003764:	05850593          	addi	a1,a0,88
    80003768:	05848513          	addi	a0,s1,88
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	a68080e7          	jalr	-1432(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003774:	8526                	mv	a0,s1
    80003776:	fffff097          	auipc	ra,0xfffff
    8000377a:	d84080e7          	jalr	-636(ra) # 800024fa <bwrite>
    brelse(from);
    8000377e:	854e                	mv	a0,s3
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	db8080e7          	jalr	-584(ra) # 80002538 <brelse>
    brelse(to);
    80003788:	8526                	mv	a0,s1
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	dae080e7          	jalr	-594(ra) # 80002538 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003792:	2905                	addiw	s2,s2,1
    80003794:	0a91                	addi	s5,s5,4
    80003796:	02ca2783          	lw	a5,44(s4)
    8000379a:	f8f94ee3          	blt	s2,a5,80003736 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	c66080e7          	jalr	-922(ra) # 80003404 <write_head>
    install_trans(0); // Now install writes to home locations
    800037a6:	4501                	li	a0,0
    800037a8:	00000097          	auipc	ra,0x0
    800037ac:	cd8080e7          	jalr	-808(ra) # 80003480 <install_trans>
    log.lh.n = 0;
    800037b0:	00021797          	auipc	a5,0x21
    800037b4:	1407a623          	sw	zero,332(a5) # 800248fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037b8:	00000097          	auipc	ra,0x0
    800037bc:	c4c080e7          	jalr	-948(ra) # 80003404 <write_head>
    800037c0:	bdf5                	j	800036bc <end_op+0x52>

00000000800037c2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c2:	1101                	addi	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	e04a                	sd	s2,0(sp)
    800037cc:	1000                	addi	s0,sp,32
    800037ce:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d0:	00021917          	auipc	s2,0x21
    800037d4:	10090913          	addi	s2,s2,256 # 800248d0 <log>
    800037d8:	854a                	mv	a0,s2
    800037da:	00003097          	auipc	ra,0x3
    800037de:	d50080e7          	jalr	-688(ra) # 8000652a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e2:	02c92603          	lw	a2,44(s2)
    800037e6:	47f5                	li	a5,29
    800037e8:	06c7c563          	blt	a5,a2,80003852 <log_write+0x90>
    800037ec:	00021797          	auipc	a5,0x21
    800037f0:	1007a783          	lw	a5,256(a5) # 800248ec <log+0x1c>
    800037f4:	37fd                	addiw	a5,a5,-1
    800037f6:	04f65e63          	bge	a2,a5,80003852 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037fa:	00021797          	auipc	a5,0x21
    800037fe:	0f67a783          	lw	a5,246(a5) # 800248f0 <log+0x20>
    80003802:	06f05063          	blez	a5,80003862 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003806:	4781                	li	a5,0
    80003808:	06c05563          	blez	a2,80003872 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000380c:	44cc                	lw	a1,12(s1)
    8000380e:	00021717          	auipc	a4,0x21
    80003812:	0f270713          	addi	a4,a4,242 # 80024900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003816:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003818:	4314                	lw	a3,0(a4)
    8000381a:	04b68c63          	beq	a3,a1,80003872 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000381e:	2785                	addiw	a5,a5,1
    80003820:	0711                	addi	a4,a4,4
    80003822:	fef61be3          	bne	a2,a5,80003818 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003826:	0621                	addi	a2,a2,8
    80003828:	060a                	slli	a2,a2,0x2
    8000382a:	00021797          	auipc	a5,0x21
    8000382e:	0a678793          	addi	a5,a5,166 # 800248d0 <log>
    80003832:	963e                	add	a2,a2,a5
    80003834:	44dc                	lw	a5,12(s1)
    80003836:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003838:	8526                	mv	a0,s1
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	d9c080e7          	jalr	-612(ra) # 800025d6 <bpin>
    log.lh.n++;
    80003842:	00021717          	auipc	a4,0x21
    80003846:	08e70713          	addi	a4,a4,142 # 800248d0 <log>
    8000384a:	575c                	lw	a5,44(a4)
    8000384c:	2785                	addiw	a5,a5,1
    8000384e:	d75c                	sw	a5,44(a4)
    80003850:	a835                	j	8000388c <log_write+0xca>
    panic("too big a transaction");
    80003852:	00005517          	auipc	a0,0x5
    80003856:	d7e50513          	addi	a0,a0,-642 # 800085d0 <syscalls+0x200>
    8000385a:	00002097          	auipc	ra,0x2
    8000385e:	794080e7          	jalr	1940(ra) # 80005fee <panic>
    panic("log_write outside of trans");
    80003862:	00005517          	auipc	a0,0x5
    80003866:	d8650513          	addi	a0,a0,-634 # 800085e8 <syscalls+0x218>
    8000386a:	00002097          	auipc	ra,0x2
    8000386e:	784080e7          	jalr	1924(ra) # 80005fee <panic>
  log.lh.block[i] = b->blockno;
    80003872:	00878713          	addi	a4,a5,8
    80003876:	00271693          	slli	a3,a4,0x2
    8000387a:	00021717          	auipc	a4,0x21
    8000387e:	05670713          	addi	a4,a4,86 # 800248d0 <log>
    80003882:	9736                	add	a4,a4,a3
    80003884:	44d4                	lw	a3,12(s1)
    80003886:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003888:	faf608e3          	beq	a2,a5,80003838 <log_write+0x76>
  }
  release(&log.lock);
    8000388c:	00021517          	auipc	a0,0x21
    80003890:	04450513          	addi	a0,a0,68 # 800248d0 <log>
    80003894:	00003097          	auipc	ra,0x3
    80003898:	d4a080e7          	jalr	-694(ra) # 800065de <release>
}
    8000389c:	60e2                	ld	ra,24(sp)
    8000389e:	6442                	ld	s0,16(sp)
    800038a0:	64a2                	ld	s1,8(sp)
    800038a2:	6902                	ld	s2,0(sp)
    800038a4:	6105                	addi	sp,sp,32
    800038a6:	8082                	ret

00000000800038a8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038a8:	1101                	addi	sp,sp,-32
    800038aa:	ec06                	sd	ra,24(sp)
    800038ac:	e822                	sd	s0,16(sp)
    800038ae:	e426                	sd	s1,8(sp)
    800038b0:	e04a                	sd	s2,0(sp)
    800038b2:	1000                	addi	s0,sp,32
    800038b4:	84aa                	mv	s1,a0
    800038b6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038b8:	00005597          	auipc	a1,0x5
    800038bc:	d5058593          	addi	a1,a1,-688 # 80008608 <syscalls+0x238>
    800038c0:	0521                	addi	a0,a0,8
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	bd8080e7          	jalr	-1064(ra) # 8000649a <initlock>
  lk->name = name;
    800038ca:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d2:	0204a423          	sw	zero,40(s1)
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    800038ec:	1000                	addi	s0,sp,32
    800038ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f0:	00850913          	addi	s2,a0,8
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	c34080e7          	jalr	-972(ra) # 8000652a <acquire>
  while (lk->locked) {
    800038fe:	409c                	lw	a5,0(s1)
    80003900:	cb89                	beqz	a5,80003912 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003902:	85ca                	mv	a1,s2
    80003904:	8526                	mv	a0,s1
    80003906:	ffffe097          	auipc	ra,0xffffe
    8000390a:	c3a080e7          	jalr	-966(ra) # 80001540 <sleep>
  while (lk->locked) {
    8000390e:	409c                	lw	a5,0(s1)
    80003910:	fbed                	bnez	a5,80003902 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003912:	4785                	li	a5,1
    80003914:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003916:	ffffd097          	auipc	ra,0xffffd
    8000391a:	522080e7          	jalr	1314(ra) # 80000e38 <myproc>
    8000391e:	591c                	lw	a5,48(a0)
    80003920:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	cba080e7          	jalr	-838(ra) # 800065de <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003938:	1101                	addi	sp,sp,-32
    8000393a:	ec06                	sd	ra,24(sp)
    8000393c:	e822                	sd	s0,16(sp)
    8000393e:	e426                	sd	s1,8(sp)
    80003940:	e04a                	sd	s2,0(sp)
    80003942:	1000                	addi	s0,sp,32
    80003944:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003946:	00850913          	addi	s2,a0,8
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	bde080e7          	jalr	-1058(ra) # 8000652a <acquire>
  lk->locked = 0;
    80003954:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003958:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000395c:	8526                	mv	a0,s1
    8000395e:	ffffe097          	auipc	ra,0xffffe
    80003962:	c46080e7          	jalr	-954(ra) # 800015a4 <wakeup>
  release(&lk->lk);
    80003966:	854a                	mv	a0,s2
    80003968:	00003097          	auipc	ra,0x3
    8000396c:	c76080e7          	jalr	-906(ra) # 800065de <release>
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret

000000008000397c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000397c:	7179                	addi	sp,sp,-48
    8000397e:	f406                	sd	ra,40(sp)
    80003980:	f022                	sd	s0,32(sp)
    80003982:	ec26                	sd	s1,24(sp)
    80003984:	e84a                	sd	s2,16(sp)
    80003986:	e44e                	sd	s3,8(sp)
    80003988:	1800                	addi	s0,sp,48
    8000398a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000398c:	00850913          	addi	s2,a0,8
    80003990:	854a                	mv	a0,s2
    80003992:	00003097          	auipc	ra,0x3
    80003996:	b98080e7          	jalr	-1128(ra) # 8000652a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399a:	409c                	lw	a5,0(s1)
    8000399c:	ef99                	bnez	a5,800039ba <holdingsleep+0x3e>
    8000399e:	4481                	li	s1,0
  release(&lk->lk);
    800039a0:	854a                	mv	a0,s2
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	c3c080e7          	jalr	-964(ra) # 800065de <release>
  return r;
}
    800039aa:	8526                	mv	a0,s1
    800039ac:	70a2                	ld	ra,40(sp)
    800039ae:	7402                	ld	s0,32(sp)
    800039b0:	64e2                	ld	s1,24(sp)
    800039b2:	6942                	ld	s2,16(sp)
    800039b4:	69a2                	ld	s3,8(sp)
    800039b6:	6145                	addi	sp,sp,48
    800039b8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ba:	0284a983          	lw	s3,40(s1)
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	47a080e7          	jalr	1146(ra) # 80000e38 <myproc>
    800039c6:	5904                	lw	s1,48(a0)
    800039c8:	413484b3          	sub	s1,s1,s3
    800039cc:	0014b493          	seqz	s1,s1
    800039d0:	bfc1                	j	800039a0 <holdingsleep+0x24>

00000000800039d2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039d2:	1141                	addi	sp,sp,-16
    800039d4:	e406                	sd	ra,8(sp)
    800039d6:	e022                	sd	s0,0(sp)
    800039d8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039da:	00005597          	auipc	a1,0x5
    800039de:	c3e58593          	addi	a1,a1,-962 # 80008618 <syscalls+0x248>
    800039e2:	00021517          	auipc	a0,0x21
    800039e6:	03650513          	addi	a0,a0,54 # 80024a18 <ftable>
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	ab0080e7          	jalr	-1360(ra) # 8000649a <initlock>
}
    800039f2:	60a2                	ld	ra,8(sp)
    800039f4:	6402                	ld	s0,0(sp)
    800039f6:	0141                	addi	sp,sp,16
    800039f8:	8082                	ret

00000000800039fa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039fa:	1101                	addi	sp,sp,-32
    800039fc:	ec06                	sd	ra,24(sp)
    800039fe:	e822                	sd	s0,16(sp)
    80003a00:	e426                	sd	s1,8(sp)
    80003a02:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a04:	00021517          	auipc	a0,0x21
    80003a08:	01450513          	addi	a0,a0,20 # 80024a18 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	b1e080e7          	jalr	-1250(ra) # 8000652a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a14:	00021497          	auipc	s1,0x21
    80003a18:	01c48493          	addi	s1,s1,28 # 80024a30 <ftable+0x18>
    80003a1c:	00022717          	auipc	a4,0x22
    80003a20:	fb470713          	addi	a4,a4,-76 # 800259d0 <disk>
    if(f->ref == 0){
    80003a24:	40dc                	lw	a5,4(s1)
    80003a26:	cf99                	beqz	a5,80003a44 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a28:	02848493          	addi	s1,s1,40
    80003a2c:	fee49ce3          	bne	s1,a4,80003a24 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a30:	00021517          	auipc	a0,0x21
    80003a34:	fe850513          	addi	a0,a0,-24 # 80024a18 <ftable>
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	ba6080e7          	jalr	-1114(ra) # 800065de <release>
  return 0;
    80003a40:	4481                	li	s1,0
    80003a42:	a819                	j	80003a58 <filealloc+0x5e>
      f->ref = 1;
    80003a44:	4785                	li	a5,1
    80003a46:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a48:	00021517          	auipc	a0,0x21
    80003a4c:	fd050513          	addi	a0,a0,-48 # 80024a18 <ftable>
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	b8e080e7          	jalr	-1138(ra) # 800065de <release>
}
    80003a58:	8526                	mv	a0,s1
    80003a5a:	60e2                	ld	ra,24(sp)
    80003a5c:	6442                	ld	s0,16(sp)
    80003a5e:	64a2                	ld	s1,8(sp)
    80003a60:	6105                	addi	sp,sp,32
    80003a62:	8082                	ret

0000000080003a64 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a70:	00021517          	auipc	a0,0x21
    80003a74:	fa850513          	addi	a0,a0,-88 # 80024a18 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	ab2080e7          	jalr	-1358(ra) # 8000652a <acquire>
  if(f->ref < 1)
    80003a80:	40dc                	lw	a5,4(s1)
    80003a82:	02f05263          	blez	a5,80003aa6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a86:	2785                	addiw	a5,a5,1
    80003a88:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a8a:	00021517          	auipc	a0,0x21
    80003a8e:	f8e50513          	addi	a0,a0,-114 # 80024a18 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	b4c080e7          	jalr	-1204(ra) # 800065de <release>
  return f;
}
    80003a9a:	8526                	mv	a0,s1
    80003a9c:	60e2                	ld	ra,24(sp)
    80003a9e:	6442                	ld	s0,16(sp)
    80003aa0:	64a2                	ld	s1,8(sp)
    80003aa2:	6105                	addi	sp,sp,32
    80003aa4:	8082                	ret
    panic("filedup");
    80003aa6:	00005517          	auipc	a0,0x5
    80003aaa:	b7a50513          	addi	a0,a0,-1158 # 80008620 <syscalls+0x250>
    80003aae:	00002097          	auipc	ra,0x2
    80003ab2:	540080e7          	jalr	1344(ra) # 80005fee <panic>

0000000080003ab6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ab6:	7139                	addi	sp,sp,-64
    80003ab8:	fc06                	sd	ra,56(sp)
    80003aba:	f822                	sd	s0,48(sp)
    80003abc:	f426                	sd	s1,40(sp)
    80003abe:	f04a                	sd	s2,32(sp)
    80003ac0:	ec4e                	sd	s3,24(sp)
    80003ac2:	e852                	sd	s4,16(sp)
    80003ac4:	e456                	sd	s5,8(sp)
    80003ac6:	0080                	addi	s0,sp,64
    80003ac8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aca:	00021517          	auipc	a0,0x21
    80003ace:	f4e50513          	addi	a0,a0,-178 # 80024a18 <ftable>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	a58080e7          	jalr	-1448(ra) # 8000652a <acquire>
  if(f->ref < 1)
    80003ada:	40dc                	lw	a5,4(s1)
    80003adc:	06f05163          	blez	a5,80003b3e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae0:	37fd                	addiw	a5,a5,-1
    80003ae2:	0007871b          	sext.w	a4,a5
    80003ae6:	c0dc                	sw	a5,4(s1)
    80003ae8:	06e04363          	bgtz	a4,80003b4e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aec:	0004a903          	lw	s2,0(s1)
    80003af0:	0094ca83          	lbu	s5,9(s1)
    80003af4:	0104ba03          	ld	s4,16(s1)
    80003af8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003afc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b00:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b04:	00021517          	auipc	a0,0x21
    80003b08:	f1450513          	addi	a0,a0,-236 # 80024a18 <ftable>
    80003b0c:	00003097          	auipc	ra,0x3
    80003b10:	ad2080e7          	jalr	-1326(ra) # 800065de <release>

  if(ff.type == FD_PIPE){
    80003b14:	4785                	li	a5,1
    80003b16:	04f90d63          	beq	s2,a5,80003b70 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b1a:	3979                	addiw	s2,s2,-2
    80003b1c:	4785                	li	a5,1
    80003b1e:	0527e063          	bltu	a5,s2,80003b5e <fileclose+0xa8>
    begin_op();
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	ac8080e7          	jalr	-1336(ra) # 800035ea <begin_op>
    iput(ff.ip);
    80003b2a:	854e                	mv	a0,s3
    80003b2c:	fffff097          	auipc	ra,0xfffff
    80003b30:	2b2080e7          	jalr	690(ra) # 80002dde <iput>
    end_op();
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	b36080e7          	jalr	-1226(ra) # 8000366a <end_op>
    80003b3c:	a00d                	j	80003b5e <fileclose+0xa8>
    panic("fileclose");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	aea50513          	addi	a0,a0,-1302 # 80008628 <syscalls+0x258>
    80003b46:	00002097          	auipc	ra,0x2
    80003b4a:	4a8080e7          	jalr	1192(ra) # 80005fee <panic>
    release(&ftable.lock);
    80003b4e:	00021517          	auipc	a0,0x21
    80003b52:	eca50513          	addi	a0,a0,-310 # 80024a18 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	a88080e7          	jalr	-1400(ra) # 800065de <release>
  }
}
    80003b5e:	70e2                	ld	ra,56(sp)
    80003b60:	7442                	ld	s0,48(sp)
    80003b62:	74a2                	ld	s1,40(sp)
    80003b64:	7902                	ld	s2,32(sp)
    80003b66:	69e2                	ld	s3,24(sp)
    80003b68:	6a42                	ld	s4,16(sp)
    80003b6a:	6aa2                	ld	s5,8(sp)
    80003b6c:	6121                	addi	sp,sp,64
    80003b6e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b70:	85d6                	mv	a1,s5
    80003b72:	8552                	mv	a0,s4
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	3a6080e7          	jalr	934(ra) # 80003f1a <pipeclose>
    80003b7c:	b7cd                	j	80003b5e <fileclose+0xa8>

0000000080003b7e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f44e                	sd	s3,40(sp)
    80003b8a:	0880                	addi	s0,sp,80
    80003b8c:	84aa                	mv	s1,a0
    80003b8e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b90:	ffffd097          	auipc	ra,0xffffd
    80003b94:	2a8080e7          	jalr	680(ra) # 80000e38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b98:	409c                	lw	a5,0(s1)
    80003b9a:	37f9                	addiw	a5,a5,-2
    80003b9c:	4705                	li	a4,1
    80003b9e:	04f76763          	bltu	a4,a5,80003bec <filestat+0x6e>
    80003ba2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	07e080e7          	jalr	126(ra) # 80002c24 <ilock>
    stati(f->ip, &st);
    80003bae:	fb840593          	addi	a1,s0,-72
    80003bb2:	6c88                	ld	a0,24(s1)
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	2fa080e7          	jalr	762(ra) # 80002eae <stati>
    iunlock(f->ip);
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	128080e7          	jalr	296(ra) # 80002ce6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bc6:	46e1                	li	a3,24
    80003bc8:	fb840613          	addi	a2,s0,-72
    80003bcc:	85ce                	mv	a1,s3
    80003bce:	05093503          	ld	a0,80(s2)
    80003bd2:	ffffd097          	auipc	ra,0xffffd
    80003bd6:	f22080e7          	jalr	-222(ra) # 80000af4 <copyout>
    80003bda:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bde:	60a6                	ld	ra,72(sp)
    80003be0:	6406                	ld	s0,64(sp)
    80003be2:	74e2                	ld	s1,56(sp)
    80003be4:	7942                	ld	s2,48(sp)
    80003be6:	79a2                	ld	s3,40(sp)
    80003be8:	6161                	addi	sp,sp,80
    80003bea:	8082                	ret
  return -1;
    80003bec:	557d                	li	a0,-1
    80003bee:	bfc5                	j	80003bde <filestat+0x60>

0000000080003bf0 <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003bf0:	7179                	addi	sp,sp,-48
    80003bf2:	f406                	sd	ra,40(sp)
    80003bf4:	f022                	sd	s0,32(sp)
    80003bf6:	ec26                	sd	s1,24(sp)
    80003bf8:	e84a                	sd	s2,16(sp)
    80003bfa:	e44e                	sd	s3,8(sp)
    80003bfc:	1800                	addi	s0,sp,48
    80003bfe:	84aa                	mv	s1,a0
    80003c00:	89ae                	mv	s3,a1
    80003c02:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003c04:	85b2                	mv	a1,a2
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	a3250513          	addi	a0,a0,-1486 # 80008638 <syscalls+0x268>
    80003c0e:	00002097          	auipc	ra,0x2
    80003c12:	42a080e7          	jalr	1066(ra) # 80006038 <printf>
  ilock(f->ip);
    80003c16:	6c88                	ld	a0,24(s1)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	00c080e7          	jalr	12(ra) # 80002c24 <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003c20:	6705                	lui	a4,0x1
    80003c22:	86ca                	mv	a3,s2
    80003c24:	864e                	mv	a2,s3
    80003c26:	4581                	li	a1,0
    80003c28:	6c88                	ld	a0,24(s1)
    80003c2a:	fffff097          	auipc	ra,0xfffff
    80003c2e:	2ae080e7          	jalr	686(ra) # 80002ed8 <readi>
  iunlock(f->ip);
    80003c32:	6c88                	ld	a0,24(s1)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	0b2080e7          	jalr	178(ra) # 80002ce6 <iunlock>
}
    80003c3c:	70a2                	ld	ra,40(sp)
    80003c3e:	7402                	ld	s0,32(sp)
    80003c40:	64e2                	ld	s1,24(sp)
    80003c42:	6942                	ld	s2,16(sp)
    80003c44:	69a2                	ld	s3,8(sp)
    80003c46:	6145                	addi	sp,sp,48
    80003c48:	8082                	ret

0000000080003c4a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c4a:	7179                	addi	sp,sp,-48
    80003c4c:	f406                	sd	ra,40(sp)
    80003c4e:	f022                	sd	s0,32(sp)
    80003c50:	ec26                	sd	s1,24(sp)
    80003c52:	e84a                	sd	s2,16(sp)
    80003c54:	e44e                	sd	s3,8(sp)
    80003c56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c58:	00854783          	lbu	a5,8(a0)
    80003c5c:	c3d5                	beqz	a5,80003d00 <fileread+0xb6>
    80003c5e:	84aa                	mv	s1,a0
    80003c60:	89ae                	mv	s3,a1
    80003c62:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c64:	411c                	lw	a5,0(a0)
    80003c66:	4705                	li	a4,1
    80003c68:	04e78963          	beq	a5,a4,80003cba <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c6c:	470d                	li	a4,3
    80003c6e:	04e78d63          	beq	a5,a4,80003cc8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c72:	4709                	li	a4,2
    80003c74:	06e79e63          	bne	a5,a4,80003cf0 <fileread+0xa6>
    ilock(f->ip);
    80003c78:	6d08                	ld	a0,24(a0)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	faa080e7          	jalr	-86(ra) # 80002c24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c82:	874a                	mv	a4,s2
    80003c84:	5094                	lw	a3,32(s1)
    80003c86:	864e                	mv	a2,s3
    80003c88:	4585                	li	a1,1
    80003c8a:	6c88                	ld	a0,24(s1)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	24c080e7          	jalr	588(ra) # 80002ed8 <readi>
    80003c94:	892a                	mv	s2,a0
    80003c96:	00a05563          	blez	a0,80003ca0 <fileread+0x56>
      f->off += r;
    80003c9a:	509c                	lw	a5,32(s1)
    80003c9c:	9fa9                	addw	a5,a5,a0
    80003c9e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ca0:	6c88                	ld	a0,24(s1)
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	044080e7          	jalr	68(ra) # 80002ce6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003caa:	854a                	mv	a0,s2
    80003cac:	70a2                	ld	ra,40(sp)
    80003cae:	7402                	ld	s0,32(sp)
    80003cb0:	64e2                	ld	s1,24(sp)
    80003cb2:	6942                	ld	s2,16(sp)
    80003cb4:	69a2                	ld	s3,8(sp)
    80003cb6:	6145                	addi	sp,sp,48
    80003cb8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cba:	6908                	ld	a0,16(a0)
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	3c6080e7          	jalr	966(ra) # 80004082 <piperead>
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	b7d5                	j	80003caa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc8:	02451783          	lh	a5,36(a0)
    80003ccc:	03079693          	slli	a3,a5,0x30
    80003cd0:	92c1                	srli	a3,a3,0x30
    80003cd2:	4725                	li	a4,9
    80003cd4:	02d76863          	bltu	a4,a3,80003d04 <fileread+0xba>
    80003cd8:	0792                	slli	a5,a5,0x4
    80003cda:	00021717          	auipc	a4,0x21
    80003cde:	c9e70713          	addi	a4,a4,-866 # 80024978 <devsw>
    80003ce2:	97ba                	add	a5,a5,a4
    80003ce4:	639c                	ld	a5,0(a5)
    80003ce6:	c38d                	beqz	a5,80003d08 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ce8:	4505                	li	a0,1
    80003cea:	9782                	jalr	a5
    80003cec:	892a                	mv	s2,a0
    80003cee:	bf75                	j	80003caa <fileread+0x60>
    panic("fileread");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	95050513          	addi	a0,a0,-1712 # 80008640 <syscalls+0x270>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	2f6080e7          	jalr	758(ra) # 80005fee <panic>
    return -1;
    80003d00:	597d                	li	s2,-1
    80003d02:	b765                	j	80003caa <fileread+0x60>
      return -1;
    80003d04:	597d                	li	s2,-1
    80003d06:	b755                	j	80003caa <fileread+0x60>
    80003d08:	597d                	li	s2,-1
    80003d0a:	b745                	j	80003caa <fileread+0x60>

0000000080003d0c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d0c:	715d                	addi	sp,sp,-80
    80003d0e:	e486                	sd	ra,72(sp)
    80003d10:	e0a2                	sd	s0,64(sp)
    80003d12:	fc26                	sd	s1,56(sp)
    80003d14:	f84a                	sd	s2,48(sp)
    80003d16:	f44e                	sd	s3,40(sp)
    80003d18:	f052                	sd	s4,32(sp)
    80003d1a:	ec56                	sd	s5,24(sp)
    80003d1c:	e85a                	sd	s6,16(sp)
    80003d1e:	e45e                	sd	s7,8(sp)
    80003d20:	e062                	sd	s8,0(sp)
    80003d22:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d24:	00954783          	lbu	a5,9(a0)
    80003d28:	10078663          	beqz	a5,80003e34 <filewrite+0x128>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	8aae                	mv	s5,a1
    80003d30:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d32:	411c                	lw	a5,0(a0)
    80003d34:	4705                	li	a4,1
    80003d36:	02e78263          	beq	a5,a4,80003d5a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d3a:	470d                	li	a4,3
    80003d3c:	02e78663          	beq	a5,a4,80003d68 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d40:	4709                	li	a4,2
    80003d42:	0ee79163          	bne	a5,a4,80003e24 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d46:	0ac05d63          	blez	a2,80003e00 <filewrite+0xf4>
    int i = 0;
    80003d4a:	4981                	li	s3,0
    80003d4c:	6b05                	lui	s6,0x1
    80003d4e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d52:	6b85                	lui	s7,0x1
    80003d54:	c00b8b9b          	addiw	s7,s7,-1024
    80003d58:	a861                	j	80003df0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d5a:	6908                	ld	a0,16(a0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	22e080e7          	jalr	558(ra) # 80003f8a <pipewrite>
    80003d64:	8a2a                	mv	s4,a0
    80003d66:	a045                	j	80003e06 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d68:	02451783          	lh	a5,36(a0)
    80003d6c:	03079693          	slli	a3,a5,0x30
    80003d70:	92c1                	srli	a3,a3,0x30
    80003d72:	4725                	li	a4,9
    80003d74:	0cd76263          	bltu	a4,a3,80003e38 <filewrite+0x12c>
    80003d78:	0792                	slli	a5,a5,0x4
    80003d7a:	00021717          	auipc	a4,0x21
    80003d7e:	bfe70713          	addi	a4,a4,-1026 # 80024978 <devsw>
    80003d82:	97ba                	add	a5,a5,a4
    80003d84:	679c                	ld	a5,8(a5)
    80003d86:	cbdd                	beqz	a5,80003e3c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d88:	4505                	li	a0,1
    80003d8a:	9782                	jalr	a5
    80003d8c:	8a2a                	mv	s4,a0
    80003d8e:	a8a5                	j	80003e06 <filewrite+0xfa>
    80003d90:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	856080e7          	jalr	-1962(ra) # 800035ea <begin_op>
      ilock(f->ip);
    80003d9c:	01893503          	ld	a0,24(s2)
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	e84080e7          	jalr	-380(ra) # 80002c24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da8:	8762                	mv	a4,s8
    80003daa:	02092683          	lw	a3,32(s2)
    80003dae:	01598633          	add	a2,s3,s5
    80003db2:	4585                	li	a1,1
    80003db4:	01893503          	ld	a0,24(s2)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	218080e7          	jalr	536(ra) # 80002fd0 <writei>
    80003dc0:	84aa                	mv	s1,a0
    80003dc2:	00a05763          	blez	a0,80003dd0 <filewrite+0xc4>
        f->off += r;
    80003dc6:	02092783          	lw	a5,32(s2)
    80003dca:	9fa9                	addw	a5,a5,a0
    80003dcc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dd0:	01893503          	ld	a0,24(s2)
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	f12080e7          	jalr	-238(ra) # 80002ce6 <iunlock>
      end_op();
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	88e080e7          	jalr	-1906(ra) # 8000366a <end_op>

      if(r != n1){
    80003de4:	009c1f63          	bne	s8,s1,80003e02 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003de8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dec:	0149db63          	bge	s3,s4,80003e02 <filewrite+0xf6>
      int n1 = n - i;
    80003df0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003df4:	84be                	mv	s1,a5
    80003df6:	2781                	sext.w	a5,a5
    80003df8:	f8fb5ce3          	bge	s6,a5,80003d90 <filewrite+0x84>
    80003dfc:	84de                	mv	s1,s7
    80003dfe:	bf49                	j	80003d90 <filewrite+0x84>
    int i = 0;
    80003e00:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e02:	013a1f63          	bne	s4,s3,80003e20 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e06:	8552                	mv	a0,s4
    80003e08:	60a6                	ld	ra,72(sp)
    80003e0a:	6406                	ld	s0,64(sp)
    80003e0c:	74e2                	ld	s1,56(sp)
    80003e0e:	7942                	ld	s2,48(sp)
    80003e10:	79a2                	ld	s3,40(sp)
    80003e12:	7a02                	ld	s4,32(sp)
    80003e14:	6ae2                	ld	s5,24(sp)
    80003e16:	6b42                	ld	s6,16(sp)
    80003e18:	6ba2                	ld	s7,8(sp)
    80003e1a:	6c02                	ld	s8,0(sp)
    80003e1c:	6161                	addi	sp,sp,80
    80003e1e:	8082                	ret
    ret = (i == n ? n : -1);
    80003e20:	5a7d                	li	s4,-1
    80003e22:	b7d5                	j	80003e06 <filewrite+0xfa>
    panic("filewrite");
    80003e24:	00005517          	auipc	a0,0x5
    80003e28:	82c50513          	addi	a0,a0,-2004 # 80008650 <syscalls+0x280>
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	1c2080e7          	jalr	450(ra) # 80005fee <panic>
    return -1;
    80003e34:	5a7d                	li	s4,-1
    80003e36:	bfc1                	j	80003e06 <filewrite+0xfa>
      return -1;
    80003e38:	5a7d                	li	s4,-1
    80003e3a:	b7f1                	j	80003e06 <filewrite+0xfa>
    80003e3c:	5a7d                	li	s4,-1
    80003e3e:	b7e1                	j	80003e06 <filewrite+0xfa>

0000000080003e40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e40:	7179                	addi	sp,sp,-48
    80003e42:	f406                	sd	ra,40(sp)
    80003e44:	f022                	sd	s0,32(sp)
    80003e46:	ec26                	sd	s1,24(sp)
    80003e48:	e84a                	sd	s2,16(sp)
    80003e4a:	e44e                	sd	s3,8(sp)
    80003e4c:	e052                	sd	s4,0(sp)
    80003e4e:	1800                	addi	s0,sp,48
    80003e50:	84aa                	mv	s1,a0
    80003e52:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e54:	0005b023          	sd	zero,0(a1)
    80003e58:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	b9e080e7          	jalr	-1122(ra) # 800039fa <filealloc>
    80003e64:	e088                	sd	a0,0(s1)
    80003e66:	c551                	beqz	a0,80003ef2 <pipealloc+0xb2>
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	b92080e7          	jalr	-1134(ra) # 800039fa <filealloc>
    80003e70:	00aa3023          	sd	a0,0(s4)
    80003e74:	c92d                	beqz	a0,80003ee6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e76:	ffffc097          	auipc	ra,0xffffc
    80003e7a:	2a2080e7          	jalr	674(ra) # 80000118 <kalloc>
    80003e7e:	892a                	mv	s2,a0
    80003e80:	c125                	beqz	a0,80003ee0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e82:	4985                	li	s3,1
    80003e84:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e88:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e8c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e90:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e94:	00004597          	auipc	a1,0x4
    80003e98:	7cc58593          	addi	a1,a1,1996 # 80008660 <syscalls+0x290>
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	5fe080e7          	jalr	1534(ra) # 8000649a <initlock>
  (*f0)->type = FD_PIPE;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ebc:	000a3783          	ld	a5,0(s4)
    80003ec0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ec4:	000a3783          	ld	a5,0(s4)
    80003ec8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ecc:	000a3783          	ld	a5,0(s4)
    80003ed0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ed4:	000a3783          	ld	a5,0(s4)
    80003ed8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003edc:	4501                	li	a0,0
    80003ede:	a025                	j	80003f06 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ee0:	6088                	ld	a0,0(s1)
    80003ee2:	e501                	bnez	a0,80003eea <pipealloc+0xaa>
    80003ee4:	a039                	j	80003ef2 <pipealloc+0xb2>
    80003ee6:	6088                	ld	a0,0(s1)
    80003ee8:	c51d                	beqz	a0,80003f16 <pipealloc+0xd6>
    fileclose(*f0);
    80003eea:	00000097          	auipc	ra,0x0
    80003eee:	bcc080e7          	jalr	-1076(ra) # 80003ab6 <fileclose>
  if(*f1)
    80003ef2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef6:	557d                	li	a0,-1
  if(*f1)
    80003ef8:	c799                	beqz	a5,80003f06 <pipealloc+0xc6>
    fileclose(*f1);
    80003efa:	853e                	mv	a0,a5
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	bba080e7          	jalr	-1094(ra) # 80003ab6 <fileclose>
  return -1;
    80003f04:	557d                	li	a0,-1
}
    80003f06:	70a2                	ld	ra,40(sp)
    80003f08:	7402                	ld	s0,32(sp)
    80003f0a:	64e2                	ld	s1,24(sp)
    80003f0c:	6942                	ld	s2,16(sp)
    80003f0e:	69a2                	ld	s3,8(sp)
    80003f10:	6a02                	ld	s4,0(sp)
    80003f12:	6145                	addi	sp,sp,48
    80003f14:	8082                	ret
  return -1;
    80003f16:	557d                	li	a0,-1
    80003f18:	b7fd                	j	80003f06 <pipealloc+0xc6>

0000000080003f1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f1a:	1101                	addi	sp,sp,-32
    80003f1c:	ec06                	sd	ra,24(sp)
    80003f1e:	e822                	sd	s0,16(sp)
    80003f20:	e426                	sd	s1,8(sp)
    80003f22:	e04a                	sd	s2,0(sp)
    80003f24:	1000                	addi	s0,sp,32
    80003f26:	84aa                	mv	s1,a0
    80003f28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f2a:	00002097          	auipc	ra,0x2
    80003f2e:	600080e7          	jalr	1536(ra) # 8000652a <acquire>
  if(writable){
    80003f32:	02090d63          	beqz	s2,80003f6c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f36:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f3a:	21848513          	addi	a0,s1,536
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	666080e7          	jalr	1638(ra) # 800015a4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f46:	2204b783          	ld	a5,544(s1)
    80003f4a:	eb95                	bnez	a5,80003f7e <pipeclose+0x64>
    release(&pi->lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	690080e7          	jalr	1680(ra) # 800065de <release>
    kfree((char*)pi);
    80003f56:	8526                	mv	a0,s1
    80003f58:	ffffc097          	auipc	ra,0xffffc
    80003f5c:	0c4080e7          	jalr	196(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f60:	60e2                	ld	ra,24(sp)
    80003f62:	6442                	ld	s0,16(sp)
    80003f64:	64a2                	ld	s1,8(sp)
    80003f66:	6902                	ld	s2,0(sp)
    80003f68:	6105                	addi	sp,sp,32
    80003f6a:	8082                	ret
    pi->readopen = 0;
    80003f6c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f70:	21c48513          	addi	a0,s1,540
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	630080e7          	jalr	1584(ra) # 800015a4 <wakeup>
    80003f7c:	b7e9                	j	80003f46 <pipeclose+0x2c>
    release(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	65e080e7          	jalr	1630(ra) # 800065de <release>
}
    80003f88:	bfe1                	j	80003f60 <pipeclose+0x46>

0000000080003f8a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f8a:	711d                	addi	sp,sp,-96
    80003f8c:	ec86                	sd	ra,88(sp)
    80003f8e:	e8a2                	sd	s0,80(sp)
    80003f90:	e4a6                	sd	s1,72(sp)
    80003f92:	e0ca                	sd	s2,64(sp)
    80003f94:	fc4e                	sd	s3,56(sp)
    80003f96:	f852                	sd	s4,48(sp)
    80003f98:	f456                	sd	s5,40(sp)
    80003f9a:	f05a                	sd	s6,32(sp)
    80003f9c:	ec5e                	sd	s7,24(sp)
    80003f9e:	e862                	sd	s8,16(sp)
    80003fa0:	1080                	addi	s0,sp,96
    80003fa2:	84aa                	mv	s1,a0
    80003fa4:	8aae                	mv	s5,a1
    80003fa6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	e90080e7          	jalr	-368(ra) # 80000e38 <myproc>
    80003fb0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb2:	8526                	mv	a0,s1
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	576080e7          	jalr	1398(ra) # 8000652a <acquire>
  while(i < n){
    80003fbc:	0b405663          	blez	s4,80004068 <pipewrite+0xde>
  int i = 0;
    80003fc0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc8:	21c48b93          	addi	s7,s1,540
    80003fcc:	a089                	j	8000400e <pipewrite+0x84>
      release(&pi->lock);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	60e080e7          	jalr	1550(ra) # 800065de <release>
      return -1;
    80003fd8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fda:	854a                	mv	a0,s2
    80003fdc:	60e6                	ld	ra,88(sp)
    80003fde:	6446                	ld	s0,80(sp)
    80003fe0:	64a6                	ld	s1,72(sp)
    80003fe2:	6906                	ld	s2,64(sp)
    80003fe4:	79e2                	ld	s3,56(sp)
    80003fe6:	7a42                	ld	s4,48(sp)
    80003fe8:	7aa2                	ld	s5,40(sp)
    80003fea:	7b02                	ld	s6,32(sp)
    80003fec:	6be2                	ld	s7,24(sp)
    80003fee:	6c42                	ld	s8,16(sp)
    80003ff0:	6125                	addi	sp,sp,96
    80003ff2:	8082                	ret
      wakeup(&pi->nread);
    80003ff4:	8562                	mv	a0,s8
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	5ae080e7          	jalr	1454(ra) # 800015a4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	85a6                	mv	a1,s1
    80004000:	855e                	mv	a0,s7
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	53e080e7          	jalr	1342(ra) # 80001540 <sleep>
  while(i < n){
    8000400a:	07495063          	bge	s2,s4,8000406a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000400e:	2204a783          	lw	a5,544(s1)
    80004012:	dfd5                	beqz	a5,80003fce <pipewrite+0x44>
    80004014:	854e                	mv	a0,s3
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	7d2080e7          	jalr	2002(ra) # 800017e8 <killed>
    8000401e:	f945                	bnez	a0,80003fce <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004020:	2184a783          	lw	a5,536(s1)
    80004024:	21c4a703          	lw	a4,540(s1)
    80004028:	2007879b          	addiw	a5,a5,512
    8000402c:	fcf704e3          	beq	a4,a5,80003ff4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004030:	4685                	li	a3,1
    80004032:	01590633          	add	a2,s2,s5
    80004036:	faf40593          	addi	a1,s0,-81
    8000403a:	0509b503          	ld	a0,80(s3)
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	b42080e7          	jalr	-1214(ra) # 80000b80 <copyin>
    80004046:	03650263          	beq	a0,s6,8000406a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000404a:	21c4a783          	lw	a5,540(s1)
    8000404e:	0017871b          	addiw	a4,a5,1
    80004052:	20e4ae23          	sw	a4,540(s1)
    80004056:	1ff7f793          	andi	a5,a5,511
    8000405a:	97a6                	add	a5,a5,s1
    8000405c:	faf44703          	lbu	a4,-81(s0)
    80004060:	00e78c23          	sb	a4,24(a5)
      i++;
    80004064:	2905                	addiw	s2,s2,1
    80004066:	b755                	j	8000400a <pipewrite+0x80>
  int i = 0;
    80004068:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000406a:	21848513          	addi	a0,s1,536
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	536080e7          	jalr	1334(ra) # 800015a4 <wakeup>
  release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	566080e7          	jalr	1382(ra) # 800065de <release>
  return i;
    80004080:	bfa9                	j	80003fda <pipewrite+0x50>

0000000080004082 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004082:	715d                	addi	sp,sp,-80
    80004084:	e486                	sd	ra,72(sp)
    80004086:	e0a2                	sd	s0,64(sp)
    80004088:	fc26                	sd	s1,56(sp)
    8000408a:	f84a                	sd	s2,48(sp)
    8000408c:	f44e                	sd	s3,40(sp)
    8000408e:	f052                	sd	s4,32(sp)
    80004090:	ec56                	sd	s5,24(sp)
    80004092:	e85a                	sd	s6,16(sp)
    80004094:	0880                	addi	s0,sp,80
    80004096:	84aa                	mv	s1,a0
    80004098:	892e                	mv	s2,a1
    8000409a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	d9c080e7          	jalr	-612(ra) # 80000e38 <myproc>
    800040a4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a6:	8526                	mv	a0,s1
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	482080e7          	jalr	1154(ra) # 8000652a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b0:	2184a703          	lw	a4,536(s1)
    800040b4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040bc:	02f71763          	bne	a4,a5,800040ea <piperead+0x68>
    800040c0:	2244a783          	lw	a5,548(s1)
    800040c4:	c39d                	beqz	a5,800040ea <piperead+0x68>
    if(killed(pr)){
    800040c6:	8552                	mv	a0,s4
    800040c8:	ffffd097          	auipc	ra,0xffffd
    800040cc:	720080e7          	jalr	1824(ra) # 800017e8 <killed>
    800040d0:	e941                	bnez	a0,80004160 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d2:	85a6                	mv	a1,s1
    800040d4:	854e                	mv	a0,s3
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	46a080e7          	jalr	1130(ra) # 80001540 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040de:	2184a703          	lw	a4,536(s1)
    800040e2:	21c4a783          	lw	a5,540(s1)
    800040e6:	fcf70de3          	beq	a4,a5,800040c0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	05505363          	blez	s5,80004134 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800040f2:	2184a783          	lw	a5,536(s1)
    800040f6:	21c4a703          	lw	a4,540(s1)
    800040fa:	02f70d63          	beq	a4,a5,80004134 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040fe:	0017871b          	addiw	a4,a5,1
    80004102:	20e4ac23          	sw	a4,536(s1)
    80004106:	1ff7f793          	andi	a5,a5,511
    8000410a:	97a6                	add	a5,a5,s1
    8000410c:	0187c783          	lbu	a5,24(a5)
    80004110:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004114:	4685                	li	a3,1
    80004116:	fbf40613          	addi	a2,s0,-65
    8000411a:	85ca                	mv	a1,s2
    8000411c:	050a3503          	ld	a0,80(s4)
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	9d4080e7          	jalr	-1580(ra) # 80000af4 <copyout>
    80004128:	01650663          	beq	a0,s6,80004134 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000412c:	2985                	addiw	s3,s3,1
    8000412e:	0905                	addi	s2,s2,1
    80004130:	fd3a91e3          	bne	s5,s3,800040f2 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004134:	21c48513          	addi	a0,s1,540
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	46c080e7          	jalr	1132(ra) # 800015a4 <wakeup>
  release(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	49c080e7          	jalr	1180(ra) # 800065de <release>
  return i;
}
    8000414a:	854e                	mv	a0,s3
    8000414c:	60a6                	ld	ra,72(sp)
    8000414e:	6406                	ld	s0,64(sp)
    80004150:	74e2                	ld	s1,56(sp)
    80004152:	7942                	ld	s2,48(sp)
    80004154:	79a2                	ld	s3,40(sp)
    80004156:	7a02                	ld	s4,32(sp)
    80004158:	6ae2                	ld	s5,24(sp)
    8000415a:	6b42                	ld	s6,16(sp)
    8000415c:	6161                	addi	sp,sp,80
    8000415e:	8082                	ret
      release(&pi->lock);
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	47c080e7          	jalr	1148(ra) # 800065de <release>
      return -1;
    8000416a:	59fd                	li	s3,-1
    8000416c:	bff9                	j	8000414a <piperead+0xc8>

000000008000416e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000416e:	1141                	addi	sp,sp,-16
    80004170:	e422                	sd	s0,8(sp)
    80004172:	0800                	addi	s0,sp,16
    80004174:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004176:	8905                	andi	a0,a0,1
    80004178:	c111                	beqz	a0,8000417c <flags2perm+0xe>
      perm = PTE_X;
    8000417a:	4521                	li	a0,8
    if(flags & 0x2)
    8000417c:	8b89                	andi	a5,a5,2
    8000417e:	c399                	beqz	a5,80004184 <flags2perm+0x16>
      perm |= PTE_W;
    80004180:	00456513          	ori	a0,a0,4
    return perm;
}
    80004184:	6422                	ld	s0,8(sp)
    80004186:	0141                	addi	sp,sp,16
    80004188:	8082                	ret

000000008000418a <exec>:

int
exec(char *path, char **argv)
{
    8000418a:	de010113          	addi	sp,sp,-544
    8000418e:	20113c23          	sd	ra,536(sp)
    80004192:	20813823          	sd	s0,528(sp)
    80004196:	20913423          	sd	s1,520(sp)
    8000419a:	21213023          	sd	s2,512(sp)
    8000419e:	ffce                	sd	s3,504(sp)
    800041a0:	fbd2                	sd	s4,496(sp)
    800041a2:	f7d6                	sd	s5,488(sp)
    800041a4:	f3da                	sd	s6,480(sp)
    800041a6:	efde                	sd	s7,472(sp)
    800041a8:	ebe2                	sd	s8,464(sp)
    800041aa:	e7e6                	sd	s9,456(sp)
    800041ac:	e3ea                	sd	s10,448(sp)
    800041ae:	ff6e                	sd	s11,440(sp)
    800041b0:	1400                	addi	s0,sp,544
    800041b2:	892a                	mv	s2,a0
    800041b4:	dea43423          	sd	a0,-536(s0)
    800041b8:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	c7c080e7          	jalr	-900(ra) # 80000e38 <myproc>
    800041c4:	84aa                	mv	s1,a0

  begin_op();
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	424080e7          	jalr	1060(ra) # 800035ea <begin_op>

  if((ip = namei(path)) == 0){
    800041ce:	854a                	mv	a0,s2
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	1fa080e7          	jalr	506(ra) # 800033ca <namei>
    800041d8:	c93d                	beqz	a0,8000424e <exec+0xc4>
    800041da:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	a48080e7          	jalr	-1464(ra) # 80002c24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041e4:	04000713          	li	a4,64
    800041e8:	4681                	li	a3,0
    800041ea:	e5040613          	addi	a2,s0,-432
    800041ee:	4581                	li	a1,0
    800041f0:	8556                	mv	a0,s5
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	ce6080e7          	jalr	-794(ra) # 80002ed8 <readi>
    800041fa:	04000793          	li	a5,64
    800041fe:	00f51a63          	bne	a0,a5,80004212 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004202:	e5042703          	lw	a4,-432(s0)
    80004206:	464c47b7          	lui	a5,0x464c4
    8000420a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000420e:	04f70663          	beq	a4,a5,8000425a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004212:	8556                	mv	a0,s5
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	c72080e7          	jalr	-910(ra) # 80002e86 <iunlockput>
    end_op();
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	44e080e7          	jalr	1102(ra) # 8000366a <end_op>
  }
  return -1;
    80004224:	557d                	li	a0,-1
}
    80004226:	21813083          	ld	ra,536(sp)
    8000422a:	21013403          	ld	s0,528(sp)
    8000422e:	20813483          	ld	s1,520(sp)
    80004232:	20013903          	ld	s2,512(sp)
    80004236:	79fe                	ld	s3,504(sp)
    80004238:	7a5e                	ld	s4,496(sp)
    8000423a:	7abe                	ld	s5,488(sp)
    8000423c:	7b1e                	ld	s6,480(sp)
    8000423e:	6bfe                	ld	s7,472(sp)
    80004240:	6c5e                	ld	s8,464(sp)
    80004242:	6cbe                	ld	s9,456(sp)
    80004244:	6d1e                	ld	s10,448(sp)
    80004246:	7dfa                	ld	s11,440(sp)
    80004248:	22010113          	addi	sp,sp,544
    8000424c:	8082                	ret
    end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	41c080e7          	jalr	1052(ra) # 8000366a <end_op>
    return -1;
    80004256:	557d                	li	a0,-1
    80004258:	b7f9                	j	80004226 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000425a:	8526                	mv	a0,s1
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	ca0080e7          	jalr	-864(ra) # 80000efc <proc_pagetable>
    80004264:	8b2a                	mv	s6,a0
    80004266:	d555                	beqz	a0,80004212 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004268:	e7042783          	lw	a5,-400(s0)
    8000426c:	e8845703          	lhu	a4,-376(s0)
    80004270:	c735                	beqz	a4,800042dc <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004272:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004274:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004278:	6a05                	lui	s4,0x1
    8000427a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000427e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004282:	6d85                	lui	s11,0x1
    80004284:	7d7d                	lui	s10,0xfffff
    80004286:	a481                	j	800044c6 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004288:	00004517          	auipc	a0,0x4
    8000428c:	3e050513          	addi	a0,a0,992 # 80008668 <syscalls+0x298>
    80004290:	00002097          	auipc	ra,0x2
    80004294:	d5e080e7          	jalr	-674(ra) # 80005fee <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004298:	874a                	mv	a4,s2
    8000429a:	009c86bb          	addw	a3,s9,s1
    8000429e:	4581                	li	a1,0
    800042a0:	8556                	mv	a0,s5
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	c36080e7          	jalr	-970(ra) # 80002ed8 <readi>
    800042aa:	2501                	sext.w	a0,a0
    800042ac:	1aa91a63          	bne	s2,a0,80004460 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800042b0:	009d84bb          	addw	s1,s11,s1
    800042b4:	013d09bb          	addw	s3,s10,s3
    800042b8:	1f74f763          	bgeu	s1,s7,800044a6 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800042bc:	02049593          	slli	a1,s1,0x20
    800042c0:	9181                	srli	a1,a1,0x20
    800042c2:	95e2                	add	a1,a1,s8
    800042c4:	855a                	mv	a0,s6
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	23c080e7          	jalr	572(ra) # 80000502 <walkaddr>
    800042ce:	862a                	mv	a2,a0
    if(pa == 0)
    800042d0:	dd45                	beqz	a0,80004288 <exec+0xfe>
      n = PGSIZE;
    800042d2:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042d4:	fd49f2e3          	bgeu	s3,s4,80004298 <exec+0x10e>
      n = sz - i;
    800042d8:	894e                	mv	s2,s3
    800042da:	bf7d                	j	80004298 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042dc:	4901                	li	s2,0
  iunlockput(ip);
    800042de:	8556                	mv	a0,s5
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	ba6080e7          	jalr	-1114(ra) # 80002e86 <iunlockput>
  end_op();
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	382080e7          	jalr	898(ra) # 8000366a <end_op>
  p = myproc();
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	b48080e7          	jalr	-1208(ra) # 80000e38 <myproc>
    800042f8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fe:	6785                	lui	a5,0x1
    80004300:	17fd                	addi	a5,a5,-1
    80004302:	993e                	add	s2,s2,a5
    80004304:	77fd                	lui	a5,0xfffff
    80004306:	00f977b3          	and	a5,s2,a5
    8000430a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430e:	4691                	li	a3,4
    80004310:	6609                	lui	a2,0x2
    80004312:	963e                	add	a2,a2,a5
    80004314:	85be                	mv	a1,a5
    80004316:	855a                	mv	a0,s6
    80004318:	ffffc097          	auipc	ra,0xffffc
    8000431c:	590080e7          	jalr	1424(ra) # 800008a8 <uvmalloc>
    80004320:	8c2a                	mv	s8,a0
  ip = 0;
    80004322:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004324:	12050e63          	beqz	a0,80004460 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004328:	75f9                	lui	a1,0xffffe
    8000432a:	95aa                	add	a1,a1,a0
    8000432c:	855a                	mv	a0,s6
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	794080e7          	jalr	1940(ra) # 80000ac2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004336:	7afd                	lui	s5,0xfffff
    80004338:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000433a:	df043783          	ld	a5,-528(s0)
    8000433e:	6388                	ld	a0,0(a5)
    80004340:	c925                	beqz	a0,800043b0 <exec+0x226>
    80004342:	e9040993          	addi	s3,s0,-368
    80004346:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000434a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000434c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	fa6080e7          	jalr	-90(ra) # 800002f4 <strlen>
    80004356:	0015079b          	addiw	a5,a0,1
    8000435a:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000435e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004362:	13596663          	bltu	s2,s5,8000448e <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004366:	df043d83          	ld	s11,-528(s0)
    8000436a:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000436e:	8552                	mv	a0,s4
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	f84080e7          	jalr	-124(ra) # 800002f4 <strlen>
    80004378:	0015069b          	addiw	a3,a0,1
    8000437c:	8652                	mv	a2,s4
    8000437e:	85ca                	mv	a1,s2
    80004380:	855a                	mv	a0,s6
    80004382:	ffffc097          	auipc	ra,0xffffc
    80004386:	772080e7          	jalr	1906(ra) # 80000af4 <copyout>
    8000438a:	10054663          	bltz	a0,80004496 <exec+0x30c>
    ustack[argc] = sp;
    8000438e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004392:	0485                	addi	s1,s1,1
    80004394:	008d8793          	addi	a5,s11,8
    80004398:	def43823          	sd	a5,-528(s0)
    8000439c:	008db503          	ld	a0,8(s11)
    800043a0:	c911                	beqz	a0,800043b4 <exec+0x22a>
    if(argc >= MAXARG)
    800043a2:	09a1                	addi	s3,s3,8
    800043a4:	fb3c95e3          	bne	s9,s3,8000434e <exec+0x1c4>
  sz = sz1;
    800043a8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ac:	4a81                	li	s5,0
    800043ae:	a84d                	j	80004460 <exec+0x2d6>
  sp = sz;
    800043b0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b2:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b4:	00349793          	slli	a5,s1,0x3
    800043b8:	f9040713          	addi	a4,s0,-112
    800043bc:	97ba                	add	a5,a5,a4
    800043be:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd11b0>
  sp -= (argc+1) * sizeof(uint64);
    800043c2:	00148693          	addi	a3,s1,1
    800043c6:	068e                	slli	a3,a3,0x3
    800043c8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043cc:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043d0:	01597663          	bgeu	s2,s5,800043dc <exec+0x252>
  sz = sz1;
    800043d4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d8:	4a81                	li	s5,0
    800043da:	a059                	j	80004460 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043dc:	e9040613          	addi	a2,s0,-368
    800043e0:	85ca                	mv	a1,s2
    800043e2:	855a                	mv	a0,s6
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	710080e7          	jalr	1808(ra) # 80000af4 <copyout>
    800043ec:	0a054963          	bltz	a0,8000449e <exec+0x314>
  p->trapframe->a1 = sp;
    800043f0:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800043f4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f8:	de843783          	ld	a5,-536(s0)
    800043fc:	0007c703          	lbu	a4,0(a5)
    80004400:	cf11                	beqz	a4,8000441c <exec+0x292>
    80004402:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004404:	02f00693          	li	a3,47
    80004408:	a039                	j	80004416 <exec+0x28c>
      last = s+1;
    8000440a:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000440e:	0785                	addi	a5,a5,1
    80004410:	fff7c703          	lbu	a4,-1(a5)
    80004414:	c701                	beqz	a4,8000441c <exec+0x292>
    if(*s == '/')
    80004416:	fed71ce3          	bne	a4,a3,8000440e <exec+0x284>
    8000441a:	bfc5                	j	8000440a <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000441c:	4641                	li	a2,16
    8000441e:	de843583          	ld	a1,-536(s0)
    80004422:	158b8513          	addi	a0,s7,344
    80004426:	ffffc097          	auipc	ra,0xffffc
    8000442a:	e9c080e7          	jalr	-356(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000442e:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004432:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004436:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000443a:	058bb783          	ld	a5,88(s7)
    8000443e:	e6843703          	ld	a4,-408(s0)
    80004442:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004444:	058bb783          	ld	a5,88(s7)
    80004448:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000444c:	85ea                	mv	a1,s10
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	b4a080e7          	jalr	-1206(ra) # 80000f98 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004456:	0004851b          	sext.w	a0,s1
    8000445a:	b3f1                	j	80004226 <exec+0x9c>
    8000445c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004460:	df843583          	ld	a1,-520(s0)
    80004464:	855a                	mv	a0,s6
    80004466:	ffffd097          	auipc	ra,0xffffd
    8000446a:	b32080e7          	jalr	-1230(ra) # 80000f98 <proc_freepagetable>
  if(ip){
    8000446e:	da0a92e3          	bnez	s5,80004212 <exec+0x88>
  return -1;
    80004472:	557d                	li	a0,-1
    80004474:	bb4d                	j	80004226 <exec+0x9c>
    80004476:	df243c23          	sd	s2,-520(s0)
    8000447a:	b7dd                	j	80004460 <exec+0x2d6>
    8000447c:	df243c23          	sd	s2,-520(s0)
    80004480:	b7c5                	j	80004460 <exec+0x2d6>
    80004482:	df243c23          	sd	s2,-520(s0)
    80004486:	bfe9                	j	80004460 <exec+0x2d6>
    80004488:	df243c23          	sd	s2,-520(s0)
    8000448c:	bfd1                	j	80004460 <exec+0x2d6>
  sz = sz1;
    8000448e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004492:	4a81                	li	s5,0
    80004494:	b7f1                	j	80004460 <exec+0x2d6>
  sz = sz1;
    80004496:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000449a:	4a81                	li	s5,0
    8000449c:	b7d1                	j	80004460 <exec+0x2d6>
  sz = sz1;
    8000449e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a2:	4a81                	li	s5,0
    800044a4:	bf75                	j	80004460 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a6:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044aa:	e0843783          	ld	a5,-504(s0)
    800044ae:	0017869b          	addiw	a3,a5,1
    800044b2:	e0d43423          	sd	a3,-504(s0)
    800044b6:	e0043783          	ld	a5,-512(s0)
    800044ba:	0387879b          	addiw	a5,a5,56
    800044be:	e8845703          	lhu	a4,-376(s0)
    800044c2:	e0e6dee3          	bge	a3,a4,800042de <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044c6:	2781                	sext.w	a5,a5
    800044c8:	e0f43023          	sd	a5,-512(s0)
    800044cc:	03800713          	li	a4,56
    800044d0:	86be                	mv	a3,a5
    800044d2:	e1840613          	addi	a2,s0,-488
    800044d6:	4581                	li	a1,0
    800044d8:	8556                	mv	a0,s5
    800044da:	fffff097          	auipc	ra,0xfffff
    800044de:	9fe080e7          	jalr	-1538(ra) # 80002ed8 <readi>
    800044e2:	03800793          	li	a5,56
    800044e6:	f6f51be3          	bne	a0,a5,8000445c <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800044ea:	e1842783          	lw	a5,-488(s0)
    800044ee:	4705                	li	a4,1
    800044f0:	fae79de3          	bne	a5,a4,800044aa <exec+0x320>
    if(ph.memsz < ph.filesz)
    800044f4:	e4043483          	ld	s1,-448(s0)
    800044f8:	e3843783          	ld	a5,-456(s0)
    800044fc:	f6f4ede3          	bltu	s1,a5,80004476 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004500:	e2843783          	ld	a5,-472(s0)
    80004504:	94be                	add	s1,s1,a5
    80004506:	f6f4ebe3          	bltu	s1,a5,8000447c <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    8000450a:	de043703          	ld	a4,-544(s0)
    8000450e:	8ff9                	and	a5,a5,a4
    80004510:	fbad                	bnez	a5,80004482 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004512:	e1c42503          	lw	a0,-484(s0)
    80004516:	00000097          	auipc	ra,0x0
    8000451a:	c58080e7          	jalr	-936(ra) # 8000416e <flags2perm>
    8000451e:	86aa                	mv	a3,a0
    80004520:	8626                	mv	a2,s1
    80004522:	85ca                	mv	a1,s2
    80004524:	855a                	mv	a0,s6
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	382080e7          	jalr	898(ra) # 800008a8 <uvmalloc>
    8000452e:	dea43c23          	sd	a0,-520(s0)
    80004532:	d939                	beqz	a0,80004488 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004534:	e2843c03          	ld	s8,-472(s0)
    80004538:	e2042c83          	lw	s9,-480(s0)
    8000453c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004540:	f60b83e3          	beqz	s7,800044a6 <exec+0x31c>
    80004544:	89de                	mv	s3,s7
    80004546:	4481                	li	s1,0
    80004548:	bb95                	j	800042bc <exec+0x132>

000000008000454a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000454a:	7179                	addi	sp,sp,-48
    8000454c:	f406                	sd	ra,40(sp)
    8000454e:	f022                	sd	s0,32(sp)
    80004550:	ec26                	sd	s1,24(sp)
    80004552:	e84a                	sd	s2,16(sp)
    80004554:	1800                	addi	s0,sp,48
    80004556:	892e                	mv	s2,a1
    80004558:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000455a:	fdc40593          	addi	a1,s0,-36
    8000455e:	ffffe097          	auipc	ra,0xffffe
    80004562:	b4a080e7          	jalr	-1206(ra) # 800020a8 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004566:	fdc42703          	lw	a4,-36(s0)
    8000456a:	47bd                	li	a5,15
    8000456c:	02e7eb63          	bltu	a5,a4,800045a2 <argfd+0x58>
    80004570:	ffffd097          	auipc	ra,0xffffd
    80004574:	8c8080e7          	jalr	-1848(ra) # 80000e38 <myproc>
    80004578:	fdc42703          	lw	a4,-36(s0)
    8000457c:	01a70793          	addi	a5,a4,26
    80004580:	078e                	slli	a5,a5,0x3
    80004582:	953e                	add	a0,a0,a5
    80004584:	611c                	ld	a5,0(a0)
    80004586:	c385                	beqz	a5,800045a6 <argfd+0x5c>
    return -1;
  if (pfd)
    80004588:	00090463          	beqz	s2,80004590 <argfd+0x46>
    *pfd = fd;
    8000458c:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004590:	4501                	li	a0,0
  if (pf)
    80004592:	c091                	beqz	s1,80004596 <argfd+0x4c>
    *pf = f;
    80004594:	e09c                	sd	a5,0(s1)
}
    80004596:	70a2                	ld	ra,40(sp)
    80004598:	7402                	ld	s0,32(sp)
    8000459a:	64e2                	ld	s1,24(sp)
    8000459c:	6942                	ld	s2,16(sp)
    8000459e:	6145                	addi	sp,sp,48
    800045a0:	8082                	ret
    return -1;
    800045a2:	557d                	li	a0,-1
    800045a4:	bfcd                	j	80004596 <argfd+0x4c>
    800045a6:	557d                	li	a0,-1
    800045a8:	b7fd                	j	80004596 <argfd+0x4c>

00000000800045aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045aa:	1101                	addi	sp,sp,-32
    800045ac:	ec06                	sd	ra,24(sp)
    800045ae:	e822                	sd	s0,16(sp)
    800045b0:	e426                	sd	s1,8(sp)
    800045b2:	1000                	addi	s0,sp,32
    800045b4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	882080e7          	jalr	-1918(ra) # 80000e38 <myproc>
    800045be:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800045c0:	0d050793          	addi	a5,a0,208
    800045c4:	4501                	li	a0,0
    800045c6:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800045c8:	6398                	ld	a4,0(a5)
    800045ca:	cb19                	beqz	a4,800045e0 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800045cc:	2505                	addiw	a0,a0,1
    800045ce:	07a1                	addi	a5,a5,8
    800045d0:	fed51ce3          	bne	a0,a3,800045c8 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045d4:	557d                	li	a0,-1
}
    800045d6:	60e2                	ld	ra,24(sp)
    800045d8:	6442                	ld	s0,16(sp)
    800045da:	64a2                	ld	s1,8(sp)
    800045dc:	6105                	addi	sp,sp,32
    800045de:	8082                	ret
      p->ofile[fd] = f;
    800045e0:	01a50793          	addi	a5,a0,26
    800045e4:	078e                	slli	a5,a5,0x3
    800045e6:	963e                	add	a2,a2,a5
    800045e8:	e204                	sd	s1,0(a2)
      return fd;
    800045ea:	b7f5                	j	800045d6 <fdalloc+0x2c>

00000000800045ec <create>:
  return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045ec:	715d                	addi	sp,sp,-80
    800045ee:	e486                	sd	ra,72(sp)
    800045f0:	e0a2                	sd	s0,64(sp)
    800045f2:	fc26                	sd	s1,56(sp)
    800045f4:	f84a                	sd	s2,48(sp)
    800045f6:	f44e                	sd	s3,40(sp)
    800045f8:	f052                	sd	s4,32(sp)
    800045fa:	ec56                	sd	s5,24(sp)
    800045fc:	e85a                	sd	s6,16(sp)
    800045fe:	0880                	addi	s0,sp,80
    80004600:	8b2e                	mv	s6,a1
    80004602:	89b2                	mv	s3,a2
    80004604:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	dde080e7          	jalr	-546(ra) # 800033e8 <nameiparent>
    80004612:	84aa                	mv	s1,a0
    80004614:	14050f63          	beqz	a0,80004772 <create+0x186>
    return 0;

  ilock(dp);
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	60c080e7          	jalr	1548(ra) # 80002c24 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004620:	4601                	li	a2,0
    80004622:	fb040593          	addi	a1,s0,-80
    80004626:	8526                	mv	a0,s1
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	ae0080e7          	jalr	-1312(ra) # 80003108 <dirlookup>
    80004630:	8aaa                	mv	s5,a0
    80004632:	c931                	beqz	a0,80004686 <create+0x9a>
  {
    iunlockput(dp);
    80004634:	8526                	mv	a0,s1
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	850080e7          	jalr	-1968(ra) # 80002e86 <iunlockput>
    ilock(ip);
    8000463e:	8556                	mv	a0,s5
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	5e4080e7          	jalr	1508(ra) # 80002c24 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004648:	000b059b          	sext.w	a1,s6
    8000464c:	4789                	li	a5,2
    8000464e:	02f59563          	bne	a1,a5,80004678 <create+0x8c>
    80004652:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd12f4>
    80004656:	37f9                	addiw	a5,a5,-2
    80004658:	17c2                	slli	a5,a5,0x30
    8000465a:	93c1                	srli	a5,a5,0x30
    8000465c:	4705                	li	a4,1
    8000465e:	00f76d63          	bltu	a4,a5,80004678 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004662:	8556                	mv	a0,s5
    80004664:	60a6                	ld	ra,72(sp)
    80004666:	6406                	ld	s0,64(sp)
    80004668:	74e2                	ld	s1,56(sp)
    8000466a:	7942                	ld	s2,48(sp)
    8000466c:	79a2                	ld	s3,40(sp)
    8000466e:	7a02                	ld	s4,32(sp)
    80004670:	6ae2                	ld	s5,24(sp)
    80004672:	6b42                	ld	s6,16(sp)
    80004674:	6161                	addi	sp,sp,80
    80004676:	8082                	ret
    iunlockput(ip);
    80004678:	8556                	mv	a0,s5
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	80c080e7          	jalr	-2036(ra) # 80002e86 <iunlockput>
    return 0;
    80004682:	4a81                	li	s5,0
    80004684:	bff9                	j	80004662 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004686:	85da                	mv	a1,s6
    80004688:	4088                	lw	a0,0(s1)
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	3fe080e7          	jalr	1022(ra) # 80002a88 <ialloc>
    80004692:	8a2a                	mv	s4,a0
    80004694:	c539                	beqz	a0,800046e2 <create+0xf6>
  ilock(ip);
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	58e080e7          	jalr	1422(ra) # 80002c24 <ilock>
  ip->major = major;
    8000469e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046a2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046a6:	4905                	li	s2,1
    800046a8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046ac:	8552                	mv	a0,s4
    800046ae:	ffffe097          	auipc	ra,0xffffe
    800046b2:	4ac080e7          	jalr	1196(ra) # 80002b5a <iupdate>
  if (type == T_DIR)
    800046b6:	000b059b          	sext.w	a1,s6
    800046ba:	03258b63          	beq	a1,s2,800046f0 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    800046be:	004a2603          	lw	a2,4(s4)
    800046c2:	fb040593          	addi	a1,s0,-80
    800046c6:	8526                	mv	a0,s1
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	c50080e7          	jalr	-944(ra) # 80003318 <dirlink>
    800046d0:	06054f63          	bltz	a0,8000474e <create+0x162>
  iunlockput(dp);
    800046d4:	8526                	mv	a0,s1
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	7b0080e7          	jalr	1968(ra) # 80002e86 <iunlockput>
  return ip;
    800046de:	8ad2                	mv	s5,s4
    800046e0:	b749                	j	80004662 <create+0x76>
    iunlockput(dp);
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	7a2080e7          	jalr	1954(ra) # 80002e86 <iunlockput>
    return 0;
    800046ec:	8ad2                	mv	s5,s4
    800046ee:	bf95                	j	80004662 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046f0:	004a2603          	lw	a2,4(s4)
    800046f4:	00004597          	auipc	a1,0x4
    800046f8:	f9458593          	addi	a1,a1,-108 # 80008688 <syscalls+0x2b8>
    800046fc:	8552                	mv	a0,s4
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	c1a080e7          	jalr	-998(ra) # 80003318 <dirlink>
    80004706:	04054463          	bltz	a0,8000474e <create+0x162>
    8000470a:	40d0                	lw	a2,4(s1)
    8000470c:	00004597          	auipc	a1,0x4
    80004710:	f8458593          	addi	a1,a1,-124 # 80008690 <syscalls+0x2c0>
    80004714:	8552                	mv	a0,s4
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c02080e7          	jalr	-1022(ra) # 80003318 <dirlink>
    8000471e:	02054863          	bltz	a0,8000474e <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    80004722:	004a2603          	lw	a2,4(s4)
    80004726:	fb040593          	addi	a1,s0,-80
    8000472a:	8526                	mv	a0,s1
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	bec080e7          	jalr	-1044(ra) # 80003318 <dirlink>
    80004734:	00054d63          	bltz	a0,8000474e <create+0x162>
    dp->nlink++; // for ".."
    80004738:	04a4d783          	lhu	a5,74(s1)
    8000473c:	2785                	addiw	a5,a5,1
    8000473e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004742:	8526                	mv	a0,s1
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	416080e7          	jalr	1046(ra) # 80002b5a <iupdate>
    8000474c:	b761                	j	800046d4 <create+0xe8>
  ip->nlink = 0;
    8000474e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004752:	8552                	mv	a0,s4
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	406080e7          	jalr	1030(ra) # 80002b5a <iupdate>
  iunlockput(ip);
    8000475c:	8552                	mv	a0,s4
    8000475e:	ffffe097          	auipc	ra,0xffffe
    80004762:	728080e7          	jalr	1832(ra) # 80002e86 <iunlockput>
  iunlockput(dp);
    80004766:	8526                	mv	a0,s1
    80004768:	ffffe097          	auipc	ra,0xffffe
    8000476c:	71e080e7          	jalr	1822(ra) # 80002e86 <iunlockput>
  return 0;
    80004770:	bdcd                	j	80004662 <create+0x76>
    return 0;
    80004772:	8aaa                	mv	s5,a0
    80004774:	b5fd                	j	80004662 <create+0x76>

0000000080004776 <sys_dup>:
{
    80004776:	7179                	addi	sp,sp,-48
    80004778:	f406                	sd	ra,40(sp)
    8000477a:	f022                	sd	s0,32(sp)
    8000477c:	ec26                	sd	s1,24(sp)
    8000477e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004780:	fd840613          	addi	a2,s0,-40
    80004784:	4581                	li	a1,0
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	dc2080e7          	jalr	-574(ra) # 8000454a <argfd>
    return -1;
    80004790:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004792:	02054363          	bltz	a0,800047b8 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80004796:	fd843503          	ld	a0,-40(s0)
    8000479a:	00000097          	auipc	ra,0x0
    8000479e:	e10080e7          	jalr	-496(ra) # 800045aa <fdalloc>
    800047a2:	84aa                	mv	s1,a0
    return -1;
    800047a4:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800047a6:	00054963          	bltz	a0,800047b8 <sys_dup+0x42>
  filedup(f);
    800047aa:	fd843503          	ld	a0,-40(s0)
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	2b6080e7          	jalr	694(ra) # 80003a64 <filedup>
  return fd;
    800047b6:	87a6                	mv	a5,s1
}
    800047b8:	853e                	mv	a0,a5
    800047ba:	70a2                	ld	ra,40(sp)
    800047bc:	7402                	ld	s0,32(sp)
    800047be:	64e2                	ld	s1,24(sp)
    800047c0:	6145                	addi	sp,sp,48
    800047c2:	8082                	ret

00000000800047c4 <sys_read>:
{
    800047c4:	7179                	addi	sp,sp,-48
    800047c6:	f406                	sd	ra,40(sp)
    800047c8:	f022                	sd	s0,32(sp)
    800047ca:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047cc:	fd840593          	addi	a1,s0,-40
    800047d0:	4505                	li	a0,1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	8f6080e7          	jalr	-1802(ra) # 800020c8 <argaddr>
  argint(2, &n);
    800047da:	fe440593          	addi	a1,s0,-28
    800047de:	4509                	li	a0,2
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	8c8080e7          	jalr	-1848(ra) # 800020a8 <argint>
  if (argfd(0, 0, &f) < 0)
    800047e8:	fe840613          	addi	a2,s0,-24
    800047ec:	4581                	li	a1,0
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	d5a080e7          	jalr	-678(ra) # 8000454a <argfd>
    800047f8:	87aa                	mv	a5,a0
    return -1;
    800047fa:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047fc:	0007cc63          	bltz	a5,80004814 <sys_read+0x50>
  return fileread(f, p, n);
    80004800:	fe442603          	lw	a2,-28(s0)
    80004804:	fd843583          	ld	a1,-40(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	43e080e7          	jalr	1086(ra) # 80003c4a <fileread>
}
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	6145                	addi	sp,sp,48
    8000481a:	8082                	ret

000000008000481c <sys_write>:
{
    8000481c:	7179                	addi	sp,sp,-48
    8000481e:	f406                	sd	ra,40(sp)
    80004820:	f022                	sd	s0,32(sp)
    80004822:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004824:	fd840593          	addi	a1,s0,-40
    80004828:	4505                	li	a0,1
    8000482a:	ffffe097          	auipc	ra,0xffffe
    8000482e:	89e080e7          	jalr	-1890(ra) # 800020c8 <argaddr>
  argint(2, &n);
    80004832:	fe440593          	addi	a1,s0,-28
    80004836:	4509                	li	a0,2
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	870080e7          	jalr	-1936(ra) # 800020a8 <argint>
  if (argfd(0, 0, &f) < 0)
    80004840:	fe840613          	addi	a2,s0,-24
    80004844:	4581                	li	a1,0
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	d02080e7          	jalr	-766(ra) # 8000454a <argfd>
    80004850:	87aa                	mv	a5,a0
    return -1;
    80004852:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004854:	0007cc63          	bltz	a5,8000486c <sys_write+0x50>
  return filewrite(f, p, n);
    80004858:	fe442603          	lw	a2,-28(s0)
    8000485c:	fd843583          	ld	a1,-40(s0)
    80004860:	fe843503          	ld	a0,-24(s0)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	4a8080e7          	jalr	1192(ra) # 80003d0c <filewrite>
}
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	6145                	addi	sp,sp,48
    80004872:	8082                	ret

0000000080004874 <sys_close>:
{
    80004874:	1101                	addi	sp,sp,-32
    80004876:	ec06                	sd	ra,24(sp)
    80004878:	e822                	sd	s0,16(sp)
    8000487a:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000487c:	fe040613          	addi	a2,s0,-32
    80004880:	fec40593          	addi	a1,s0,-20
    80004884:	4501                	li	a0,0
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	cc4080e7          	jalr	-828(ra) # 8000454a <argfd>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004890:	02054463          	bltz	a0,800048b8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	5a4080e7          	jalr	1444(ra) # 80000e38 <myproc>
    8000489c:	fec42783          	lw	a5,-20(s0)
    800048a0:	07e9                	addi	a5,a5,26
    800048a2:	078e                	slli	a5,a5,0x3
    800048a4:	97aa                	add	a5,a5,a0
    800048a6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048aa:	fe043503          	ld	a0,-32(s0)
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	208080e7          	jalr	520(ra) # 80003ab6 <fileclose>
  return 0;
    800048b6:	4781                	li	a5,0
}
    800048b8:	853e                	mv	a0,a5
    800048ba:	60e2                	ld	ra,24(sp)
    800048bc:	6442                	ld	s0,16(sp)
    800048be:	6105                	addi	sp,sp,32
    800048c0:	8082                	ret

00000000800048c2 <sys_fstat>:
{
    800048c2:	1101                	addi	sp,sp,-32
    800048c4:	ec06                	sd	ra,24(sp)
    800048c6:	e822                	sd	s0,16(sp)
    800048c8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048ca:	fe040593          	addi	a1,s0,-32
    800048ce:	4505                	li	a0,1
    800048d0:	ffffd097          	auipc	ra,0xffffd
    800048d4:	7f8080e7          	jalr	2040(ra) # 800020c8 <argaddr>
  if (argfd(0, 0, &f) < 0)
    800048d8:	fe840613          	addi	a2,s0,-24
    800048dc:	4581                	li	a1,0
    800048de:	4501                	li	a0,0
    800048e0:	00000097          	auipc	ra,0x0
    800048e4:	c6a080e7          	jalr	-918(ra) # 8000454a <argfd>
    800048e8:	87aa                	mv	a5,a0
    return -1;
    800048ea:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800048ec:	0007ca63          	bltz	a5,80004900 <sys_fstat+0x3e>
  return filestat(f, st);
    800048f0:	fe043583          	ld	a1,-32(s0)
    800048f4:	fe843503          	ld	a0,-24(s0)
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	286080e7          	jalr	646(ra) # 80003b7e <filestat>
}
    80004900:	60e2                	ld	ra,24(sp)
    80004902:	6442                	ld	s0,16(sp)
    80004904:	6105                	addi	sp,sp,32
    80004906:	8082                	ret

0000000080004908 <sys_link>:
{
    80004908:	7169                	addi	sp,sp,-304
    8000490a:	f606                	sd	ra,296(sp)
    8000490c:	f222                	sd	s0,288(sp)
    8000490e:	ee26                	sd	s1,280(sp)
    80004910:	ea4a                	sd	s2,272(sp)
    80004912:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004914:	08000613          	li	a2,128
    80004918:	ed040593          	addi	a1,s0,-304
    8000491c:	4501                	li	a0,0
    8000491e:	ffffd097          	auipc	ra,0xffffd
    80004922:	7ca080e7          	jalr	1994(ra) # 800020e8 <argstr>
    return -1;
    80004926:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004928:	10054e63          	bltz	a0,80004a44 <sys_link+0x13c>
    8000492c:	08000613          	li	a2,128
    80004930:	f5040593          	addi	a1,s0,-176
    80004934:	4505                	li	a0,1
    80004936:	ffffd097          	auipc	ra,0xffffd
    8000493a:	7b2080e7          	jalr	1970(ra) # 800020e8 <argstr>
    return -1;
    8000493e:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004940:	10054263          	bltz	a0,80004a44 <sys_link+0x13c>
  begin_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	ca6080e7          	jalr	-858(ra) # 800035ea <begin_op>
  if ((ip = namei(old)) == 0)
    8000494c:	ed040513          	addi	a0,s0,-304
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	a7a080e7          	jalr	-1414(ra) # 800033ca <namei>
    80004958:	84aa                	mv	s1,a0
    8000495a:	c551                	beqz	a0,800049e6 <sys_link+0xde>
  ilock(ip);
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	2c8080e7          	jalr	712(ra) # 80002c24 <ilock>
  if (ip->type == T_DIR)
    80004964:	04449703          	lh	a4,68(s1)
    80004968:	4785                	li	a5,1
    8000496a:	08f70463          	beq	a4,a5,800049f2 <sys_link+0xea>
  ip->nlink++;
    8000496e:	04a4d783          	lhu	a5,74(s1)
    80004972:	2785                	addiw	a5,a5,1
    80004974:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	1e0080e7          	jalr	480(ra) # 80002b5a <iupdate>
  iunlock(ip);
    80004982:	8526                	mv	a0,s1
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	362080e7          	jalr	866(ra) # 80002ce6 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000498c:	fd040593          	addi	a1,s0,-48
    80004990:	f5040513          	addi	a0,s0,-176
    80004994:	fffff097          	auipc	ra,0xfffff
    80004998:	a54080e7          	jalr	-1452(ra) # 800033e8 <nameiparent>
    8000499c:	892a                	mv	s2,a0
    8000499e:	c935                	beqz	a0,80004a12 <sys_link+0x10a>
  ilock(dp);
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	284080e7          	jalr	644(ra) # 80002c24 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800049a8:	00092703          	lw	a4,0(s2)
    800049ac:	409c                	lw	a5,0(s1)
    800049ae:	04f71d63          	bne	a4,a5,80004a08 <sys_link+0x100>
    800049b2:	40d0                	lw	a2,4(s1)
    800049b4:	fd040593          	addi	a1,s0,-48
    800049b8:	854a                	mv	a0,s2
    800049ba:	fffff097          	auipc	ra,0xfffff
    800049be:	95e080e7          	jalr	-1698(ra) # 80003318 <dirlink>
    800049c2:	04054363          	bltz	a0,80004a08 <sys_link+0x100>
  iunlockput(dp);
    800049c6:	854a                	mv	a0,s2
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	4be080e7          	jalr	1214(ra) # 80002e86 <iunlockput>
  iput(ip);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	40c080e7          	jalr	1036(ra) # 80002dde <iput>
  end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	c90080e7          	jalr	-880(ra) # 8000366a <end_op>
  return 0;
    800049e2:	4781                	li	a5,0
    800049e4:	a085                	j	80004a44 <sys_link+0x13c>
    end_op();
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	c84080e7          	jalr	-892(ra) # 8000366a <end_op>
    return -1;
    800049ee:	57fd                	li	a5,-1
    800049f0:	a891                	j	80004a44 <sys_link+0x13c>
    iunlockput(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	492080e7          	jalr	1170(ra) # 80002e86 <iunlockput>
    end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	c6e080e7          	jalr	-914(ra) # 8000366a <end_op>
    return -1;
    80004a04:	57fd                	li	a5,-1
    80004a06:	a83d                	j	80004a44 <sys_link+0x13c>
    iunlockput(dp);
    80004a08:	854a                	mv	a0,s2
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	47c080e7          	jalr	1148(ra) # 80002e86 <iunlockput>
  ilock(ip);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	210080e7          	jalr	528(ra) # 80002c24 <ilock>
  ip->nlink--;
    80004a1c:	04a4d783          	lhu	a5,74(s1)
    80004a20:	37fd                	addiw	a5,a5,-1
    80004a22:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a26:	8526                	mv	a0,s1
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	132080e7          	jalr	306(ra) # 80002b5a <iupdate>
  iunlockput(ip);
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	454080e7          	jalr	1108(ra) # 80002e86 <iunlockput>
  end_op();
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	c30080e7          	jalr	-976(ra) # 8000366a <end_op>
  return -1;
    80004a42:	57fd                	li	a5,-1
}
    80004a44:	853e                	mv	a0,a5
    80004a46:	70b2                	ld	ra,296(sp)
    80004a48:	7412                	ld	s0,288(sp)
    80004a4a:	64f2                	ld	s1,280(sp)
    80004a4c:	6952                	ld	s2,272(sp)
    80004a4e:	6155                	addi	sp,sp,304
    80004a50:	8082                	ret

0000000080004a52 <sys_unlink>:
{
    80004a52:	7151                	addi	sp,sp,-240
    80004a54:	f586                	sd	ra,232(sp)
    80004a56:	f1a2                	sd	s0,224(sp)
    80004a58:	eda6                	sd	s1,216(sp)
    80004a5a:	e9ca                	sd	s2,208(sp)
    80004a5c:	e5ce                	sd	s3,200(sp)
    80004a5e:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004a60:	08000613          	li	a2,128
    80004a64:	f3040593          	addi	a1,s0,-208
    80004a68:	4501                	li	a0,0
    80004a6a:	ffffd097          	auipc	ra,0xffffd
    80004a6e:	67e080e7          	jalr	1662(ra) # 800020e8 <argstr>
    80004a72:	18054163          	bltz	a0,80004bf4 <sys_unlink+0x1a2>
  begin_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	b74080e7          	jalr	-1164(ra) # 800035ea <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80004a7e:	fb040593          	addi	a1,s0,-80
    80004a82:	f3040513          	addi	a0,s0,-208
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	962080e7          	jalr	-1694(ra) # 800033e8 <nameiparent>
    80004a8e:	84aa                	mv	s1,a0
    80004a90:	c979                	beqz	a0,80004b66 <sys_unlink+0x114>
  ilock(dp);
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	192080e7          	jalr	402(ra) # 80002c24 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9a:	00004597          	auipc	a1,0x4
    80004a9e:	bee58593          	addi	a1,a1,-1042 # 80008688 <syscalls+0x2b8>
    80004aa2:	fb040513          	addi	a0,s0,-80
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	648080e7          	jalr	1608(ra) # 800030ee <namecmp>
    80004aae:	14050a63          	beqz	a0,80004c02 <sys_unlink+0x1b0>
    80004ab2:	00004597          	auipc	a1,0x4
    80004ab6:	bde58593          	addi	a1,a1,-1058 # 80008690 <syscalls+0x2c0>
    80004aba:	fb040513          	addi	a0,s0,-80
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	630080e7          	jalr	1584(ra) # 800030ee <namecmp>
    80004ac6:	12050e63          	beqz	a0,80004c02 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004aca:	f2c40613          	addi	a2,s0,-212
    80004ace:	fb040593          	addi	a1,s0,-80
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	634080e7          	jalr	1588(ra) # 80003108 <dirlookup>
    80004adc:	892a                	mv	s2,a0
    80004ade:	12050263          	beqz	a0,80004c02 <sys_unlink+0x1b0>
  ilock(ip);
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	142080e7          	jalr	322(ra) # 80002c24 <ilock>
  if (ip->nlink < 1)
    80004aea:	04a91783          	lh	a5,74(s2)
    80004aee:	08f05263          	blez	a5,80004b72 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004af2:	04491703          	lh	a4,68(s2)
    80004af6:	4785                	li	a5,1
    80004af8:	08f70563          	beq	a4,a5,80004b82 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004afc:	4641                	li	a2,16
    80004afe:	4581                	li	a1,0
    80004b00:	fc040513          	addi	a0,s0,-64
    80004b04:	ffffb097          	auipc	ra,0xffffb
    80004b08:	674080e7          	jalr	1652(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b0c:	4741                	li	a4,16
    80004b0e:	f2c42683          	lw	a3,-212(s0)
    80004b12:	fc040613          	addi	a2,s0,-64
    80004b16:	4581                	li	a1,0
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	4b6080e7          	jalr	1206(ra) # 80002fd0 <writei>
    80004b22:	47c1                	li	a5,16
    80004b24:	0af51563          	bne	a0,a5,80004bce <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004b28:	04491703          	lh	a4,68(s2)
    80004b2c:	4785                	li	a5,1
    80004b2e:	0af70863          	beq	a4,a5,80004bde <sys_unlink+0x18c>
  iunlockput(dp);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	352080e7          	jalr	850(ra) # 80002e86 <iunlockput>
  ip->nlink--;
    80004b3c:	04a95783          	lhu	a5,74(s2)
    80004b40:	37fd                	addiw	a5,a5,-1
    80004b42:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b46:	854a                	mv	a0,s2
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	012080e7          	jalr	18(ra) # 80002b5a <iupdate>
  iunlockput(ip);
    80004b50:	854a                	mv	a0,s2
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	334080e7          	jalr	820(ra) # 80002e86 <iunlockput>
  end_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	b10080e7          	jalr	-1264(ra) # 8000366a <end_op>
  return 0;
    80004b62:	4501                	li	a0,0
    80004b64:	a84d                	j	80004c16 <sys_unlink+0x1c4>
    end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	b04080e7          	jalr	-1276(ra) # 8000366a <end_op>
    return -1;
    80004b6e:	557d                	li	a0,-1
    80004b70:	a05d                	j	80004c16 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b72:	00004517          	auipc	a0,0x4
    80004b76:	b2650513          	addi	a0,a0,-1242 # 80008698 <syscalls+0x2c8>
    80004b7a:	00001097          	auipc	ra,0x1
    80004b7e:	474080e7          	jalr	1140(ra) # 80005fee <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b82:	04c92703          	lw	a4,76(s2)
    80004b86:	02000793          	li	a5,32
    80004b8a:	f6e7f9e3          	bgeu	a5,a4,80004afc <sys_unlink+0xaa>
    80004b8e:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b92:	4741                	li	a4,16
    80004b94:	86ce                	mv	a3,s3
    80004b96:	f1840613          	addi	a2,s0,-232
    80004b9a:	4581                	li	a1,0
    80004b9c:	854a                	mv	a0,s2
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	33a080e7          	jalr	826(ra) # 80002ed8 <readi>
    80004ba6:	47c1                	li	a5,16
    80004ba8:	00f51b63          	bne	a0,a5,80004bbe <sys_unlink+0x16c>
    if (de.inum != 0)
    80004bac:	f1845783          	lhu	a5,-232(s0)
    80004bb0:	e7a1                	bnez	a5,80004bf8 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004bb2:	29c1                	addiw	s3,s3,16
    80004bb4:	04c92783          	lw	a5,76(s2)
    80004bb8:	fcf9ede3          	bltu	s3,a5,80004b92 <sys_unlink+0x140>
    80004bbc:	b781                	j	80004afc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bbe:	00004517          	auipc	a0,0x4
    80004bc2:	af250513          	addi	a0,a0,-1294 # 800086b0 <syscalls+0x2e0>
    80004bc6:	00001097          	auipc	ra,0x1
    80004bca:	428080e7          	jalr	1064(ra) # 80005fee <panic>
    panic("unlink: writei");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	afa50513          	addi	a0,a0,-1286 # 800086c8 <syscalls+0x2f8>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	418080e7          	jalr	1048(ra) # 80005fee <panic>
    dp->nlink--;
    80004bde:	04a4d783          	lhu	a5,74(s1)
    80004be2:	37fd                	addiw	a5,a5,-1
    80004be4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	f70080e7          	jalr	-144(ra) # 80002b5a <iupdate>
    80004bf2:	b781                	j	80004b32 <sys_unlink+0xe0>
    return -1;
    80004bf4:	557d                	li	a0,-1
    80004bf6:	a005                	j	80004c16 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	28c080e7          	jalr	652(ra) # 80002e86 <iunlockput>
  iunlockput(dp);
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	282080e7          	jalr	642(ra) # 80002e86 <iunlockput>
  end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	a5e080e7          	jalr	-1442(ra) # 8000366a <end_op>
  return -1;
    80004c14:	557d                	li	a0,-1
}
    80004c16:	70ae                	ld	ra,232(sp)
    80004c18:	740e                	ld	s0,224(sp)
    80004c1a:	64ee                	ld	s1,216(sp)
    80004c1c:	694e                	ld	s2,208(sp)
    80004c1e:	69ae                	ld	s3,200(sp)
    80004c20:	616d                	addi	sp,sp,240
    80004c22:	8082                	ret

0000000080004c24 <sys_mmap>:
{
    80004c24:	715d                	addi	sp,sp,-80
    80004c26:	e486                	sd	ra,72(sp)
    80004c28:	e0a2                	sd	s0,64(sp)
    80004c2a:	fc26                	sd	s1,56(sp)
    80004c2c:	f84a                	sd	s2,48(sp)
    80004c2e:	f44e                	sd	s3,40(sp)
    80004c30:	f052                	sd	s4,32(sp)
    80004c32:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004c34:	ffffc097          	auipc	ra,0xffffc
    80004c38:	204080e7          	jalr	516(ra) # 80000e38 <myproc>
    80004c3c:	892a                	mv	s2,a0
  argint(1, &length);
    80004c3e:	fcc40593          	addi	a1,s0,-52
    80004c42:	4505                	li	a0,1
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	464080e7          	jalr	1124(ra) # 800020a8 <argint>
  argint(2, &prot);
    80004c4c:	fc840593          	addi	a1,s0,-56
    80004c50:	4509                	li	a0,2
    80004c52:	ffffd097          	auipc	ra,0xffffd
    80004c56:	456080e7          	jalr	1110(ra) # 800020a8 <argint>
  argint(3, &flags);
    80004c5a:	fc440593          	addi	a1,s0,-60
    80004c5e:	450d                	li	a0,3
    80004c60:	ffffd097          	auipc	ra,0xffffd
    80004c64:	448080e7          	jalr	1096(ra) # 800020a8 <argint>
  argfd(4, &fd, &mfile);
    80004c68:	fb040613          	addi	a2,s0,-80
    80004c6c:	fc040593          	addi	a1,s0,-64
    80004c70:	4511                	li	a0,4
    80004c72:	00000097          	auipc	ra,0x0
    80004c76:	8d8080e7          	jalr	-1832(ra) # 8000454a <argfd>
  argint(5, &offset);
    80004c7a:	fbc40593          	addi	a1,s0,-68
    80004c7e:	4515                	li	a0,5
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	428080e7          	jalr	1064(ra) # 800020a8 <argint>
  if (length < 0 || prot < 0 || flags < 0 || fd < 0 || offset < 0)
    80004c88:	fcc42603          	lw	a2,-52(s0)
    80004c8c:	0c064363          	bltz	a2,80004d52 <sys_mmap+0x12e>
    80004c90:	fc842583          	lw	a1,-56(s0)
    80004c94:	0c05c163          	bltz	a1,80004d56 <sys_mmap+0x132>
    80004c98:	fc442803          	lw	a6,-60(s0)
    80004c9c:	0a084f63          	bltz	a6,80004d5a <sys_mmap+0x136>
    80004ca0:	fc042883          	lw	a7,-64(s0)
    80004ca4:	0a08cd63          	bltz	a7,80004d5e <sys_mmap+0x13a>
    80004ca8:	fbc42303          	lw	t1,-68(s0)
    80004cac:	0a034b63          	bltz	t1,80004d62 <sys_mmap+0x13e>
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004cb0:	fb043e03          	ld	t3,-80(s0)
    80004cb4:	009e4783          	lbu	a5,9(t3)
    80004cb8:	e781                	bnez	a5,80004cc0 <sys_mmap+0x9c>
    80004cba:	0025f793          	andi	a5,a1,2
    80004cbe:	e78d                	bnez	a5,80004ce8 <sys_mmap+0xc4>
  while (idx < VMASIZE)
    80004cc0:	17090793          	addi	a5,s2,368
{
    80004cc4:	4481                	li	s1,0
  while (idx < VMASIZE)
    80004cc6:	46c1                	li	a3,16
    if (p->vma[idx].length == 0) // free vma
    80004cc8:	4398                	lw	a4,0(a5)
    80004cca:	c705                	beqz	a4,80004cf2 <sys_mmap+0xce>
    idx++;
    80004ccc:	2485                	addiw	s1,s1,1
  while (idx < VMASIZE)
    80004cce:	03078793          	addi	a5,a5,48
    80004cd2:	fed49be3          	bne	s1,a3,80004cc8 <sys_mmap+0xa4>
  return -1;
    80004cd6:	557d                	li	a0,-1
}
    80004cd8:	60a6                	ld	ra,72(sp)
    80004cda:	6406                	ld	s0,64(sp)
    80004cdc:	74e2                	ld	s1,56(sp)
    80004cde:	7942                	ld	s2,48(sp)
    80004ce0:	79a2                	ld	s3,40(sp)
    80004ce2:	7a02                	ld	s4,32(sp)
    80004ce4:	6161                	addi	sp,sp,80
    80004ce6:	8082                	ret
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004ce8:	00187793          	andi	a5,a6,1
    return -1;
    80004cec:	557d                	li	a0,-1
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004cee:	dbe9                	beqz	a5,80004cc0 <sys_mmap+0x9c>
    80004cf0:	b7e5                	j	80004cd8 <sys_mmap+0xb4>
      p->vma[idx].addr = p->sz;
    80004cf2:	00149a13          	slli	s4,s1,0x1
    80004cf6:	009a09b3          	add	s3,s4,s1
    80004cfa:	0992                	slli	s3,s3,0x4
    80004cfc:	99ca                	add	s3,s3,s2
    80004cfe:	04893783          	ld	a5,72(s2)
    80004d02:	16f9b423          	sd	a5,360(s3)
      p->vma[idx].length = length;
    80004d06:	16c9a823          	sw	a2,368(s3)
      p->vma[idx].prot = prot;
    80004d0a:	16b9aa23          	sw	a1,372(s3)
      p->vma[idx].flags = flags;
    80004d0e:	1709ac23          	sw	a6,376(s3)
      p->vma[idx].fd = fd;
    80004d12:	1719ae23          	sw	a7,380(s3)
      p->vma[idx].offset = offset;
    80004d16:	1869a023          	sw	t1,384(s3)
      p->vma[idx].mfile = filedup(mfile); // increment the reference count
    80004d1a:	8572                	mv	a0,t3
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	d48080e7          	jalr	-696(ra) # 80003a64 <filedup>
    80004d24:	18a9b423          	sd	a0,392(s3)
      p->vma[idx].ip = mfile->ip;
    80004d28:	fb043783          	ld	a5,-80(s0)
    80004d2c:	6f9c                	ld	a5,24(a5)
    80004d2e:	18f9b823          	sd	a5,400(s3)
      p->sz += PGROUNDUP(length);
    80004d32:	fcc42783          	lw	a5,-52(s0)
    80004d36:	6705                	lui	a4,0x1
    80004d38:	377d                	addiw	a4,a4,-1
    80004d3a:	9fb9                	addw	a5,a5,a4
    80004d3c:	777d                	lui	a4,0xfffff
    80004d3e:	8ff9                	and	a5,a5,a4
    80004d40:	2781                	sext.w	a5,a5
    80004d42:	04893703          	ld	a4,72(s2)
    80004d46:	97ba                	add	a5,a5,a4
    80004d48:	04f93423          	sd	a5,72(s2)
      return (uint64)p->vma[idx].addr;
    80004d4c:	1689b503          	ld	a0,360(s3)
    80004d50:	b761                	j	80004cd8 <sys_mmap+0xb4>
    return -1;
    80004d52:	557d                	li	a0,-1
    80004d54:	b751                	j	80004cd8 <sys_mmap+0xb4>
    80004d56:	557d                	li	a0,-1
    80004d58:	b741                	j	80004cd8 <sys_mmap+0xb4>
    80004d5a:	557d                	li	a0,-1
    80004d5c:	bfb5                	j	80004cd8 <sys_mmap+0xb4>
    80004d5e:	557d                	li	a0,-1
    80004d60:	bfa5                	j	80004cd8 <sys_mmap+0xb4>
    80004d62:	557d                	li	a0,-1
    80004d64:	bf95                	j	80004cd8 <sys_mmap+0xb4>

0000000080004d66 <sys_munmap>:
{
    80004d66:	715d                	addi	sp,sp,-80
    80004d68:	e486                	sd	ra,72(sp)
    80004d6a:	e0a2                	sd	s0,64(sp)
    80004d6c:	fc26                	sd	s1,56(sp)
    80004d6e:	f84a                	sd	s2,48(sp)
    80004d70:	f44e                	sd	s3,40(sp)
    80004d72:	f052                	sd	s4,32(sp)
    80004d74:	ec56                	sd	s5,24(sp)
    80004d76:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004d78:	ffffc097          	auipc	ra,0xffffc
    80004d7c:	0c0080e7          	jalr	192(ra) # 80000e38 <myproc>
    80004d80:	892a                	mv	s2,a0
  argaddr(0, &va);
    80004d82:	fb840593          	addi	a1,s0,-72
    80004d86:	4501                	li	a0,0
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	340080e7          	jalr	832(ra) # 800020c8 <argaddr>
  argint(1, &length);
    80004d90:	fb440593          	addi	a1,s0,-76
    80004d94:	4505                	li	a0,1
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	312080e7          	jalr	786(ra) # 800020a8 <argint>
  if (va < 0 || length < 0)
    80004d9e:	fb442783          	lw	a5,-76(s0)
    80004da2:	1407c263          	bltz	a5,80004ee6 <sys_munmap+0x180>
    if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length && p->vma[i].length != 0)
    80004da6:	fb843683          	ld	a3,-72(s0)
    80004daa:	16890793          	addi	a5,s2,360
  for (int i = 0; i < VMASIZE; i++)
    80004dae:	4481                	li	s1,0
    80004db0:	45c1                	li	a1,16
    80004db2:	a031                	j	80004dbe <sys_munmap+0x58>
    80004db4:	2485                	addiw	s1,s1,1
    80004db6:	03078793          	addi	a5,a5,48
    80004dba:	00b48b63          	beq	s1,a1,80004dd0 <sys_munmap+0x6a>
    if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length && p->vma[i].length != 0)
    80004dbe:	6398                	ld	a4,0(a5)
    80004dc0:	fee6eae3          	bltu	a3,a4,80004db4 <sys_munmap+0x4e>
    80004dc4:	4790                	lw	a2,8(a5)
    80004dc6:	9732                	add	a4,a4,a2
    80004dc8:	fee6f6e3          	bgeu	a3,a4,80004db4 <sys_munmap+0x4e>
    80004dcc:	d665                	beqz	a2,80004db4 <sys_munmap+0x4e>
    80004dce:	a011                	j	80004dd2 <sys_munmap+0x6c>
  int idx = 0;
    80004dd0:	4481                	li	s1,0
  struct vma v = p->vma[idx];
    80004dd2:	00149793          	slli	a5,s1,0x1
    80004dd6:	97a6                	add	a5,a5,s1
    80004dd8:	0792                	slli	a5,a5,0x4
    80004dda:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004ddc:	1747a783          	lw	a5,372(a5)
    80004de0:	8b89                	andi	a5,a5,2
    80004de2:	cb91                	beqz	a5,80004df6 <sys_munmap+0x90>
  struct vma v = p->vma[idx];
    80004de4:	00149793          	slli	a5,s1,0x1
    80004de8:	97a6                	add	a5,a5,s1
    80004dea:	0792                	slli	a5,a5,0x4
    80004dec:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004dee:	1787a783          	lw	a5,376(a5)
    80004df2:	8b85                	andi	a5,a5,1
    80004df4:	ebad                	bnez	a5,80004e66 <sys_munmap+0x100>
  uint64 npages = PGROUNDUP(length) / PGSIZE;
    80004df6:	fb442603          	lw	a2,-76(s0)
    80004dfa:	6785                	lui	a5,0x1
    80004dfc:	37fd                	addiw	a5,a5,-1
    80004dfe:	9e3d                	addw	a2,a2,a5
  uvmunmap(p->pagetable, va, npages, 1);
    80004e00:	4685                	li	a3,1
    80004e02:	40c6561b          	sraiw	a2,a2,0xc
    80004e06:	fb843583          	ld	a1,-72(s0)
    80004e0a:	05093503          	ld	a0,80(s2)
    80004e0e:	ffffc097          	auipc	ra,0xffffc
    80004e12:	8fc080e7          	jalr	-1796(ra) # 8000070a <uvmunmap>
  v.length -= length;
    80004e16:	fb442683          	lw	a3,-76(s0)
  va += length;
    80004e1a:	fb843783          	ld	a5,-72(s0)
    80004e1e:	97b6                	add	a5,a5,a3
    80004e20:	faf43c23          	sd	a5,-72(s0)
  p->vma[idx].addr += length;
    80004e24:	00149793          	slli	a5,s1,0x1
    80004e28:	97a6                	add	a5,a5,s1
    80004e2a:	0792                	slli	a5,a5,0x4
    80004e2c:	97ca                	add	a5,a5,s2
    80004e2e:	1687b703          	ld	a4,360(a5) # 1168 <_entry-0x7fffee98>
    80004e32:	9736                	add	a4,a4,a3
    80004e34:	16e7b423          	sd	a4,360(a5)
  p->vma[idx].offset += length;
    80004e38:	1807a703          	lw	a4,384(a5)
    80004e3c:	9f35                	addw	a4,a4,a3
    80004e3e:	18e7a023          	sw	a4,384(a5)
  p->vma[idx].length -= length;
    80004e42:	1707a703          	lw	a4,368(a5)
    80004e46:	9f15                	subw	a4,a4,a3
    80004e48:	0007069b          	sext.w	a3,a4
    80004e4c:	16e7a823          	sw	a4,368(a5)
  return 0;
    80004e50:	4501                	li	a0,0
  if (p->vma[idx].length == 0)
    80004e52:	cead                	beqz	a3,80004ecc <sys_munmap+0x166>
}
    80004e54:	60a6                	ld	ra,72(sp)
    80004e56:	6406                	ld	s0,64(sp)
    80004e58:	74e2                	ld	s1,56(sp)
    80004e5a:	7942                	ld	s2,48(sp)
    80004e5c:	79a2                	ld	s3,40(sp)
    80004e5e:	7a02                	ld	s4,32(sp)
    80004e60:	6ae2                	ld	s5,24(sp)
    80004e62:	6161                	addi	sp,sp,80
    80004e64:	8082                	ret
  struct vma v = p->vma[idx];
    80004e66:	00149793          	slli	a5,s1,0x1
    80004e6a:	97a6                	add	a5,a5,s1
    80004e6c:	0792                	slli	a5,a5,0x4
    80004e6e:	97ca                	add	a5,a5,s2
    80004e70:	1687ba03          	ld	s4,360(a5)
    80004e74:	1807aa83          	lw	s5,384(a5)
    80004e78:	1907b983          	ld	s3,400(a5)
    begin_op();
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	76e080e7          	jalr	1902(ra) # 800035ea <begin_op>
    ilock(v.ip);
    80004e84:	854e                	mv	a0,s3
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	d9e080e7          	jalr	-610(ra) # 80002c24 <ilock>
    writei(v.ip, 1, v.addr, va - v.addr + v.offset, PGROUNDUP(length)); // fix
    80004e8e:	fb442703          	lw	a4,-76(s0)
    80004e92:	6785                	lui	a5,0x1
    80004e94:	37fd                	addiw	a5,a5,-1
    80004e96:	9f3d                	addw	a4,a4,a5
    80004e98:	77fd                	lui	a5,0xfffff
    80004e9a:	8f7d                	and	a4,a4,a5
    80004e9c:	fb843683          	ld	a3,-72(s0)
    80004ea0:	015686bb          	addw	a3,a3,s5
    80004ea4:	2701                	sext.w	a4,a4
    80004ea6:	414686bb          	subw	a3,a3,s4
    80004eaa:	8652                	mv	a2,s4
    80004eac:	4585                	li	a1,1
    80004eae:	854e                	mv	a0,s3
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	120080e7          	jalr	288(ra) # 80002fd0 <writei>
    iunlock(v.ip);
    80004eb8:	854e                	mv	a0,s3
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	e2c080e7          	jalr	-468(ra) # 80002ce6 <iunlock>
    end_op();
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	7a8080e7          	jalr	1960(ra) # 8000366a <end_op>
    80004eca:	b735                	j	80004df6 <sys_munmap+0x90>
    fileclose(p->vma[idx].mfile);
    80004ecc:	00149793          	slli	a5,s1,0x1
    80004ed0:	94be                	add	s1,s1,a5
    80004ed2:	0492                	slli	s1,s1,0x4
    80004ed4:	9926                	add	s2,s2,s1
    80004ed6:	18893503          	ld	a0,392(s2)
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	bdc080e7          	jalr	-1060(ra) # 80003ab6 <fileclose>
  return 0;
    80004ee2:	4501                	li	a0,0
    80004ee4:	bf85                	j	80004e54 <sys_munmap+0xee>
    return -1;
    80004ee6:	557d                	li	a0,-1
    80004ee8:	b7b5                	j	80004e54 <sys_munmap+0xee>

0000000080004eea <sys_open>:

uint64
sys_open(void)
{
    80004eea:	7131                	addi	sp,sp,-192
    80004eec:	fd06                	sd	ra,184(sp)
    80004eee:	f922                	sd	s0,176(sp)
    80004ef0:	f526                	sd	s1,168(sp)
    80004ef2:	f14a                	sd	s2,160(sp)
    80004ef4:	ed4e                	sd	s3,152(sp)
    80004ef6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ef8:	f4c40593          	addi	a1,s0,-180
    80004efc:	4505                	li	a0,1
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	1aa080e7          	jalr	426(ra) # 800020a8 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f06:	08000613          	li	a2,128
    80004f0a:	f5040593          	addi	a1,s0,-176
    80004f0e:	4501                	li	a0,0
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	1d8080e7          	jalr	472(ra) # 800020e8 <argstr>
    80004f18:	87aa                	mv	a5,a0
    return -1;
    80004f1a:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f1c:	0a07c963          	bltz	a5,80004fce <sys_open+0xe4>

  begin_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	6ca080e7          	jalr	1738(ra) # 800035ea <begin_op>

  if (omode & O_CREATE)
    80004f28:	f4c42783          	lw	a5,-180(s0)
    80004f2c:	2007f793          	andi	a5,a5,512
    80004f30:	cfc5                	beqz	a5,80004fe8 <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004f32:	4681                	li	a3,0
    80004f34:	4601                	li	a2,0
    80004f36:	4589                	li	a1,2
    80004f38:	f5040513          	addi	a0,s0,-176
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	6b0080e7          	jalr	1712(ra) # 800045ec <create>
    80004f44:	84aa                	mv	s1,a0
    if (ip == 0)
    80004f46:	c959                	beqz	a0,80004fdc <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004f48:	04449703          	lh	a4,68(s1)
    80004f4c:	478d                	li	a5,3
    80004f4e:	00f71763          	bne	a4,a5,80004f5c <sys_open+0x72>
    80004f52:	0464d703          	lhu	a4,70(s1)
    80004f56:	47a5                	li	a5,9
    80004f58:	0ce7ed63          	bltu	a5,a4,80005032 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f5c:	fffff097          	auipc	ra,0xfffff
    80004f60:	a9e080e7          	jalr	-1378(ra) # 800039fa <filealloc>
    80004f64:	89aa                	mv	s3,a0
    80004f66:	10050363          	beqz	a0,8000506c <sys_open+0x182>
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	640080e7          	jalr	1600(ra) # 800045aa <fdalloc>
    80004f72:	892a                	mv	s2,a0
    80004f74:	0e054763          	bltz	a0,80005062 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004f78:	04449703          	lh	a4,68(s1)
    80004f7c:	478d                	li	a5,3
    80004f7e:	0cf70563          	beq	a4,a5,80005048 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004f82:	4789                	li	a5,2
    80004f84:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f88:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f8c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f90:	f4c42783          	lw	a5,-180(s0)
    80004f94:	0017c713          	xori	a4,a5,1
    80004f98:	8b05                	andi	a4,a4,1
    80004f9a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f9e:	0037f713          	andi	a4,a5,3
    80004fa2:	00e03733          	snez	a4,a4
    80004fa6:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004faa:	4007f793          	andi	a5,a5,1024
    80004fae:	c791                	beqz	a5,80004fba <sys_open+0xd0>
    80004fb0:	04449703          	lh	a4,68(s1)
    80004fb4:	4789                	li	a5,2
    80004fb6:	0af70063          	beq	a4,a5,80005056 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004fba:	8526                	mv	a0,s1
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	d2a080e7          	jalr	-726(ra) # 80002ce6 <iunlock>
  end_op();
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	6a6080e7          	jalr	1702(ra) # 8000366a <end_op>

  return fd;
    80004fcc:	854a                	mv	a0,s2
}
    80004fce:	70ea                	ld	ra,184(sp)
    80004fd0:	744a                	ld	s0,176(sp)
    80004fd2:	74aa                	ld	s1,168(sp)
    80004fd4:	790a                	ld	s2,160(sp)
    80004fd6:	69ea                	ld	s3,152(sp)
    80004fd8:	6129                	addi	sp,sp,192
    80004fda:	8082                	ret
      end_op();
    80004fdc:	ffffe097          	auipc	ra,0xffffe
    80004fe0:	68e080e7          	jalr	1678(ra) # 8000366a <end_op>
      return -1;
    80004fe4:	557d                	li	a0,-1
    80004fe6:	b7e5                	j	80004fce <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004fe8:	f5040513          	addi	a0,s0,-176
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	3de080e7          	jalr	990(ra) # 800033ca <namei>
    80004ff4:	84aa                	mv	s1,a0
    80004ff6:	c905                	beqz	a0,80005026 <sys_open+0x13c>
    ilock(ip);
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	c2c080e7          	jalr	-980(ra) # 80002c24 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80005000:	04449703          	lh	a4,68(s1)
    80005004:	4785                	li	a5,1
    80005006:	f4f711e3          	bne	a4,a5,80004f48 <sys_open+0x5e>
    8000500a:	f4c42783          	lw	a5,-180(s0)
    8000500e:	d7b9                	beqz	a5,80004f5c <sys_open+0x72>
      iunlockput(ip);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	e74080e7          	jalr	-396(ra) # 80002e86 <iunlockput>
      end_op();
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	650080e7          	jalr	1616(ra) # 8000366a <end_op>
      return -1;
    80005022:	557d                	li	a0,-1
    80005024:	b76d                	j	80004fce <sys_open+0xe4>
      end_op();
    80005026:	ffffe097          	auipc	ra,0xffffe
    8000502a:	644080e7          	jalr	1604(ra) # 8000366a <end_op>
      return -1;
    8000502e:	557d                	li	a0,-1
    80005030:	bf79                	j	80004fce <sys_open+0xe4>
    iunlockput(ip);
    80005032:	8526                	mv	a0,s1
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	e52080e7          	jalr	-430(ra) # 80002e86 <iunlockput>
    end_op();
    8000503c:	ffffe097          	auipc	ra,0xffffe
    80005040:	62e080e7          	jalr	1582(ra) # 8000366a <end_op>
    return -1;
    80005044:	557d                	li	a0,-1
    80005046:	b761                	j	80004fce <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005048:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000504c:	04649783          	lh	a5,70(s1)
    80005050:	02f99223          	sh	a5,36(s3)
    80005054:	bf25                	j	80004f8c <sys_open+0xa2>
    itrunc(ip);
    80005056:	8526                	mv	a0,s1
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	cda080e7          	jalr	-806(ra) # 80002d32 <itrunc>
    80005060:	bfa9                	j	80004fba <sys_open+0xd0>
      fileclose(f);
    80005062:	854e                	mv	a0,s3
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	a52080e7          	jalr	-1454(ra) # 80003ab6 <fileclose>
    iunlockput(ip);
    8000506c:	8526                	mv	a0,s1
    8000506e:	ffffe097          	auipc	ra,0xffffe
    80005072:	e18080e7          	jalr	-488(ra) # 80002e86 <iunlockput>
    end_op();
    80005076:	ffffe097          	auipc	ra,0xffffe
    8000507a:	5f4080e7          	jalr	1524(ra) # 8000366a <end_op>
    return -1;
    8000507e:	557d                	li	a0,-1
    80005080:	b7b9                	j	80004fce <sys_open+0xe4>

0000000080005082 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005082:	7175                	addi	sp,sp,-144
    80005084:	e506                	sd	ra,136(sp)
    80005086:	e122                	sd	s0,128(sp)
    80005088:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	560080e7          	jalr	1376(ra) # 800035ea <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005092:	08000613          	li	a2,128
    80005096:	f7040593          	addi	a1,s0,-144
    8000509a:	4501                	li	a0,0
    8000509c:	ffffd097          	auipc	ra,0xffffd
    800050a0:	04c080e7          	jalr	76(ra) # 800020e8 <argstr>
    800050a4:	02054963          	bltz	a0,800050d6 <sys_mkdir+0x54>
    800050a8:	4681                	li	a3,0
    800050aa:	4601                	li	a2,0
    800050ac:	4585                	li	a1,1
    800050ae:	f7040513          	addi	a0,s0,-144
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	53a080e7          	jalr	1338(ra) # 800045ec <create>
    800050ba:	cd11                	beqz	a0,800050d6 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050bc:	ffffe097          	auipc	ra,0xffffe
    800050c0:	dca080e7          	jalr	-566(ra) # 80002e86 <iunlockput>
  end_op();
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	5a6080e7          	jalr	1446(ra) # 8000366a <end_op>
  return 0;
    800050cc:	4501                	li	a0,0
}
    800050ce:	60aa                	ld	ra,136(sp)
    800050d0:	640a                	ld	s0,128(sp)
    800050d2:	6149                	addi	sp,sp,144
    800050d4:	8082                	ret
    end_op();
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	594080e7          	jalr	1428(ra) # 8000366a <end_op>
    return -1;
    800050de:	557d                	li	a0,-1
    800050e0:	b7fd                	j	800050ce <sys_mkdir+0x4c>

00000000800050e2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050e2:	7135                	addi	sp,sp,-160
    800050e4:	ed06                	sd	ra,152(sp)
    800050e6:	e922                	sd	s0,144(sp)
    800050e8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050ea:	ffffe097          	auipc	ra,0xffffe
    800050ee:	500080e7          	jalr	1280(ra) # 800035ea <begin_op>
  argint(1, &major);
    800050f2:	f6c40593          	addi	a1,s0,-148
    800050f6:	4505                	li	a0,1
    800050f8:	ffffd097          	auipc	ra,0xffffd
    800050fc:	fb0080e7          	jalr	-80(ra) # 800020a8 <argint>
  argint(2, &minor);
    80005100:	f6840593          	addi	a1,s0,-152
    80005104:	4509                	li	a0,2
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	fa2080e7          	jalr	-94(ra) # 800020a8 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000510e:	08000613          	li	a2,128
    80005112:	f7040593          	addi	a1,s0,-144
    80005116:	4501                	li	a0,0
    80005118:	ffffd097          	auipc	ra,0xffffd
    8000511c:	fd0080e7          	jalr	-48(ra) # 800020e8 <argstr>
    80005120:	02054b63          	bltz	a0,80005156 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005124:	f6841683          	lh	a3,-152(s0)
    80005128:	f6c41603          	lh	a2,-148(s0)
    8000512c:	458d                	li	a1,3
    8000512e:	f7040513          	addi	a0,s0,-144
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	4ba080e7          	jalr	1210(ra) # 800045ec <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000513a:	cd11                	beqz	a0,80005156 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000513c:	ffffe097          	auipc	ra,0xffffe
    80005140:	d4a080e7          	jalr	-694(ra) # 80002e86 <iunlockput>
  end_op();
    80005144:	ffffe097          	auipc	ra,0xffffe
    80005148:	526080e7          	jalr	1318(ra) # 8000366a <end_op>
  return 0;
    8000514c:	4501                	li	a0,0
}
    8000514e:	60ea                	ld	ra,152(sp)
    80005150:	644a                	ld	s0,144(sp)
    80005152:	610d                	addi	sp,sp,160
    80005154:	8082                	ret
    end_op();
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	514080e7          	jalr	1300(ra) # 8000366a <end_op>
    return -1;
    8000515e:	557d                	li	a0,-1
    80005160:	b7fd                	j	8000514e <sys_mknod+0x6c>

0000000080005162 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005162:	7135                	addi	sp,sp,-160
    80005164:	ed06                	sd	ra,152(sp)
    80005166:	e922                	sd	s0,144(sp)
    80005168:	e526                	sd	s1,136(sp)
    8000516a:	e14a                	sd	s2,128(sp)
    8000516c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000516e:	ffffc097          	auipc	ra,0xffffc
    80005172:	cca080e7          	jalr	-822(ra) # 80000e38 <myproc>
    80005176:	892a                	mv	s2,a0

  begin_op();
    80005178:	ffffe097          	auipc	ra,0xffffe
    8000517c:	472080e7          	jalr	1138(ra) # 800035ea <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005180:	08000613          	li	a2,128
    80005184:	f6040593          	addi	a1,s0,-160
    80005188:	4501                	li	a0,0
    8000518a:	ffffd097          	auipc	ra,0xffffd
    8000518e:	f5e080e7          	jalr	-162(ra) # 800020e8 <argstr>
    80005192:	04054b63          	bltz	a0,800051e8 <sys_chdir+0x86>
    80005196:	f6040513          	addi	a0,s0,-160
    8000519a:	ffffe097          	auipc	ra,0xffffe
    8000519e:	230080e7          	jalr	560(ra) # 800033ca <namei>
    800051a2:	84aa                	mv	s1,a0
    800051a4:	c131                	beqz	a0,800051e8 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800051a6:	ffffe097          	auipc	ra,0xffffe
    800051aa:	a7e080e7          	jalr	-1410(ra) # 80002c24 <ilock>
  if (ip->type != T_DIR)
    800051ae:	04449703          	lh	a4,68(s1)
    800051b2:	4785                	li	a5,1
    800051b4:	04f71063          	bne	a4,a5,800051f4 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051b8:	8526                	mv	a0,s1
    800051ba:	ffffe097          	auipc	ra,0xffffe
    800051be:	b2c080e7          	jalr	-1236(ra) # 80002ce6 <iunlock>
  iput(p->cwd);
    800051c2:	15093503          	ld	a0,336(s2)
    800051c6:	ffffe097          	auipc	ra,0xffffe
    800051ca:	c18080e7          	jalr	-1000(ra) # 80002dde <iput>
  end_op();
    800051ce:	ffffe097          	auipc	ra,0xffffe
    800051d2:	49c080e7          	jalr	1180(ra) # 8000366a <end_op>
  p->cwd = ip;
    800051d6:	14993823          	sd	s1,336(s2)
  return 0;
    800051da:	4501                	li	a0,0
}
    800051dc:	60ea                	ld	ra,152(sp)
    800051de:	644a                	ld	s0,144(sp)
    800051e0:	64aa                	ld	s1,136(sp)
    800051e2:	690a                	ld	s2,128(sp)
    800051e4:	610d                	addi	sp,sp,160
    800051e6:	8082                	ret
    end_op();
    800051e8:	ffffe097          	auipc	ra,0xffffe
    800051ec:	482080e7          	jalr	1154(ra) # 8000366a <end_op>
    return -1;
    800051f0:	557d                	li	a0,-1
    800051f2:	b7ed                	j	800051dc <sys_chdir+0x7a>
    iunlockput(ip);
    800051f4:	8526                	mv	a0,s1
    800051f6:	ffffe097          	auipc	ra,0xffffe
    800051fa:	c90080e7          	jalr	-880(ra) # 80002e86 <iunlockput>
    end_op();
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	46c080e7          	jalr	1132(ra) # 8000366a <end_op>
    return -1;
    80005206:	557d                	li	a0,-1
    80005208:	bfd1                	j	800051dc <sys_chdir+0x7a>

000000008000520a <sys_exec>:

uint64
sys_exec(void)
{
    8000520a:	7145                	addi	sp,sp,-464
    8000520c:	e786                	sd	ra,456(sp)
    8000520e:	e3a2                	sd	s0,448(sp)
    80005210:	ff26                	sd	s1,440(sp)
    80005212:	fb4a                	sd	s2,432(sp)
    80005214:	f74e                	sd	s3,424(sp)
    80005216:	f352                	sd	s4,416(sp)
    80005218:	ef56                	sd	s5,408(sp)
    8000521a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000521c:	e3840593          	addi	a1,s0,-456
    80005220:	4505                	li	a0,1
    80005222:	ffffd097          	auipc	ra,0xffffd
    80005226:	ea6080e7          	jalr	-346(ra) # 800020c8 <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    8000522a:	08000613          	li	a2,128
    8000522e:	f4040593          	addi	a1,s0,-192
    80005232:	4501                	li	a0,0
    80005234:	ffffd097          	auipc	ra,0xffffd
    80005238:	eb4080e7          	jalr	-332(ra) # 800020e8 <argstr>
    8000523c:	87aa                	mv	a5,a0
  {
    return -1;
    8000523e:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80005240:	0c07c263          	bltz	a5,80005304 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005244:	10000613          	li	a2,256
    80005248:	4581                	li	a1,0
    8000524a:	e4040513          	addi	a0,s0,-448
    8000524e:	ffffb097          	auipc	ra,0xffffb
    80005252:	f2a080e7          	jalr	-214(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80005256:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000525a:	89a6                	mv	s3,s1
    8000525c:	4901                	li	s2,0
    if (i >= NELEM(argv))
    8000525e:	02000a13          	li	s4,32
    80005262:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005266:	00391793          	slli	a5,s2,0x3
    8000526a:	e3040593          	addi	a1,s0,-464
    8000526e:	e3843503          	ld	a0,-456(s0)
    80005272:	953e                	add	a0,a0,a5
    80005274:	ffffd097          	auipc	ra,0xffffd
    80005278:	d96080e7          	jalr	-618(ra) # 8000200a <fetchaddr>
    8000527c:	02054a63          	bltz	a0,800052b0 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80005280:	e3043783          	ld	a5,-464(s0)
    80005284:	c3b9                	beqz	a5,800052ca <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005286:	ffffb097          	auipc	ra,0xffffb
    8000528a:	e92080e7          	jalr	-366(ra) # 80000118 <kalloc>
    8000528e:	85aa                	mv	a1,a0
    80005290:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005294:	cd11                	beqz	a0,800052b0 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005296:	6605                	lui	a2,0x1
    80005298:	e3043503          	ld	a0,-464(s0)
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	dc0080e7          	jalr	-576(ra) # 8000205c <fetchstr>
    800052a4:	00054663          	bltz	a0,800052b0 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    800052a8:	0905                	addi	s2,s2,1
    800052aa:	09a1                	addi	s3,s3,8
    800052ac:	fb491be3          	bne	s2,s4,80005262 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052b0:	10048913          	addi	s2,s1,256
    800052b4:	6088                	ld	a0,0(s1)
    800052b6:	c531                	beqz	a0,80005302 <sys_exec+0xf8>
    kfree(argv[i]);
    800052b8:	ffffb097          	auipc	ra,0xffffb
    800052bc:	d64080e7          	jalr	-668(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c0:	04a1                	addi	s1,s1,8
    800052c2:	ff2499e3          	bne	s1,s2,800052b4 <sys_exec+0xaa>
  return -1;
    800052c6:	557d                	li	a0,-1
    800052c8:	a835                	j	80005304 <sys_exec+0xfa>
      argv[i] = 0;
    800052ca:	0a8e                	slli	s5,s5,0x3
    800052cc:	fc040793          	addi	a5,s0,-64
    800052d0:	9abe                	add	s5,s5,a5
    800052d2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800052d6:	e4040593          	addi	a1,s0,-448
    800052da:	f4040513          	addi	a0,s0,-192
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	eac080e7          	jalr	-340(ra) # 8000418a <exec>
    800052e6:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052e8:	10048993          	addi	s3,s1,256
    800052ec:	6088                	ld	a0,0(s1)
    800052ee:	c901                	beqz	a0,800052fe <sys_exec+0xf4>
    kfree(argv[i]);
    800052f0:	ffffb097          	auipc	ra,0xffffb
    800052f4:	d2c080e7          	jalr	-724(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052f8:	04a1                	addi	s1,s1,8
    800052fa:	ff3499e3          	bne	s1,s3,800052ec <sys_exec+0xe2>
  return ret;
    800052fe:	854a                	mv	a0,s2
    80005300:	a011                	j	80005304 <sys_exec+0xfa>
  return -1;
    80005302:	557d                	li	a0,-1
}
    80005304:	60be                	ld	ra,456(sp)
    80005306:	641e                	ld	s0,448(sp)
    80005308:	74fa                	ld	s1,440(sp)
    8000530a:	795a                	ld	s2,432(sp)
    8000530c:	79ba                	ld	s3,424(sp)
    8000530e:	7a1a                	ld	s4,416(sp)
    80005310:	6afa                	ld	s5,408(sp)
    80005312:	6179                	addi	sp,sp,464
    80005314:	8082                	ret

0000000080005316 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005316:	7139                	addi	sp,sp,-64
    80005318:	fc06                	sd	ra,56(sp)
    8000531a:	f822                	sd	s0,48(sp)
    8000531c:	f426                	sd	s1,40(sp)
    8000531e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005320:	ffffc097          	auipc	ra,0xffffc
    80005324:	b18080e7          	jalr	-1256(ra) # 80000e38 <myproc>
    80005328:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000532a:	fd840593          	addi	a1,s0,-40
    8000532e:	4501                	li	a0,0
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	d98080e7          	jalr	-616(ra) # 800020c8 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80005338:	fc840593          	addi	a1,s0,-56
    8000533c:	fd040513          	addi	a0,s0,-48
    80005340:	fffff097          	auipc	ra,0xfffff
    80005344:	b00080e7          	jalr	-1280(ra) # 80003e40 <pipealloc>
    return -1;
    80005348:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    8000534a:	0c054463          	bltz	a0,80005412 <sys_pipe+0xfc>
  fd0 = -1;
    8000534e:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005352:	fd043503          	ld	a0,-48(s0)
    80005356:	fffff097          	auipc	ra,0xfffff
    8000535a:	254080e7          	jalr	596(ra) # 800045aa <fdalloc>
    8000535e:	fca42223          	sw	a0,-60(s0)
    80005362:	08054b63          	bltz	a0,800053f8 <sys_pipe+0xe2>
    80005366:	fc843503          	ld	a0,-56(s0)
    8000536a:	fffff097          	auipc	ra,0xfffff
    8000536e:	240080e7          	jalr	576(ra) # 800045aa <fdalloc>
    80005372:	fca42023          	sw	a0,-64(s0)
    80005376:	06054863          	bltz	a0,800053e6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000537a:	4691                	li	a3,4
    8000537c:	fc440613          	addi	a2,s0,-60
    80005380:	fd843583          	ld	a1,-40(s0)
    80005384:	68a8                	ld	a0,80(s1)
    80005386:	ffffb097          	auipc	ra,0xffffb
    8000538a:	76e080e7          	jalr	1902(ra) # 80000af4 <copyout>
    8000538e:	02054063          	bltz	a0,800053ae <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80005392:	4691                	li	a3,4
    80005394:	fc040613          	addi	a2,s0,-64
    80005398:	fd843583          	ld	a1,-40(s0)
    8000539c:	0591                	addi	a1,a1,4
    8000539e:	68a8                	ld	a0,80(s1)
    800053a0:	ffffb097          	auipc	ra,0xffffb
    800053a4:	754080e7          	jalr	1876(ra) # 80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053a8:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053aa:	06055463          	bgez	a0,80005412 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800053ae:	fc442783          	lw	a5,-60(s0)
    800053b2:	07e9                	addi	a5,a5,26
    800053b4:	078e                	slli	a5,a5,0x3
    800053b6:	97a6                	add	a5,a5,s1
    800053b8:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd12b0>
    p->ofile[fd1] = 0;
    800053bc:	fc042503          	lw	a0,-64(s0)
    800053c0:	0569                	addi	a0,a0,26
    800053c2:	050e                	slli	a0,a0,0x3
    800053c4:	94aa                	add	s1,s1,a0
    800053c6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053ca:	fd043503          	ld	a0,-48(s0)
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	6e8080e7          	jalr	1768(ra) # 80003ab6 <fileclose>
    fileclose(wf);
    800053d6:	fc843503          	ld	a0,-56(s0)
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	6dc080e7          	jalr	1756(ra) # 80003ab6 <fileclose>
    return -1;
    800053e2:	57fd                	li	a5,-1
    800053e4:	a03d                	j	80005412 <sys_pipe+0xfc>
    if (fd0 >= 0)
    800053e6:	fc442783          	lw	a5,-60(s0)
    800053ea:	0007c763          	bltz	a5,800053f8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800053ee:	07e9                	addi	a5,a5,26
    800053f0:	078e                	slli	a5,a5,0x3
    800053f2:	94be                	add	s1,s1,a5
    800053f4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053f8:	fd043503          	ld	a0,-48(s0)
    800053fc:	ffffe097          	auipc	ra,0xffffe
    80005400:	6ba080e7          	jalr	1722(ra) # 80003ab6 <fileclose>
    fileclose(wf);
    80005404:	fc843503          	ld	a0,-56(s0)
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	6ae080e7          	jalr	1710(ra) # 80003ab6 <fileclose>
    return -1;
    80005410:	57fd                	li	a5,-1
}
    80005412:	853e                	mv	a0,a5
    80005414:	70e2                	ld	ra,56(sp)
    80005416:	7442                	ld	s0,48(sp)
    80005418:	74a2                	ld	s1,40(sp)
    8000541a:	6121                	addi	sp,sp,64
    8000541c:	8082                	ret
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
    80005460:	a77fc0ef          	jal	ra,80001ed6 <kerneltrap>
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
    80005588:	44c78793          	addi	a5,a5,1100 # 800259d0 <disk>
    8000558c:	97aa                	add	a5,a5,a0
    8000558e:	0187c783          	lbu	a5,24(a5)
    80005592:	ebb9                	bnez	a5,800055e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005594:	00451613          	slli	a2,a0,0x4
    80005598:	00020797          	auipc	a5,0x20
    8000559c:	43878793          	addi	a5,a5,1080 # 800259d0 <disk>
    800055a0:	6394                	ld	a3,0(a5)
    800055a2:	96b2                	add	a3,a3,a2
    800055a4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055a8:	6398                	ld	a4,0(a5)
    800055aa:	9732                	add	a4,a4,a2
    800055ac:	00072423          	sw	zero,8(a4) # fffffffffffff008 <end+0xffffffff7ffd12b8>
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
    800055c4:	42850513          	addi	a0,a0,1064 # 800259e8 <disk+0x18>
    800055c8:	ffffc097          	auipc	ra,0xffffc
    800055cc:	fdc080e7          	jalr	-36(ra) # 800015a4 <wakeup>
}
    800055d0:	60a2                	ld	ra,8(sp)
    800055d2:	6402                	ld	s0,0(sp)
    800055d4:	0141                	addi	sp,sp,16
    800055d6:	8082                	ret
    panic("free_desc 1");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	10050513          	addi	a0,a0,256 # 800086d8 <syscalls+0x308>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	a0e080e7          	jalr	-1522(ra) # 80005fee <panic>
    panic("free_desc 2");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	10050513          	addi	a0,a0,256 # 800086e8 <syscalls+0x318>
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
    80005608:	0f458593          	addi	a1,a1,244 # 800086f8 <syscalls+0x328>
    8000560c:	00020517          	auipc	a0,0x20
    80005610:	4ec50513          	addi	a0,a0,1260 # 80025af8 <disk+0x128>
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
    80005674:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0a0f>
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
    800056bc:	31848493          	addi	s1,s1,792 # 800259d0 <disk>
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
    800056e0:	2fc73703          	ld	a4,764(a4) # 800259d8 <disk+0x8>
    800056e4:	cb65                	beqz	a4,800057d4 <virtio_disk_init+0x1dc>
    800056e6:	c7fd                	beqz	a5,800057d4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800056e8:	6605                	lui	a2,0x1
    800056ea:	4581                	li	a1,0
    800056ec:	ffffb097          	auipc	ra,0xffffb
    800056f0:	a8c080e7          	jalr	-1396(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056f4:	00020497          	auipc	s1,0x20
    800056f8:	2dc48493          	addi	s1,s1,732 # 800259d0 <disk>
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
    80005788:	f8450513          	addi	a0,a0,-124 # 80008708 <syscalls+0x338>
    8000578c:	00001097          	auipc	ra,0x1
    80005790:	862080e7          	jalr	-1950(ra) # 80005fee <panic>
    panic("virtio disk FEATURES_OK unset");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	f9450513          	addi	a0,a0,-108 # 80008728 <syscalls+0x358>
    8000579c:	00001097          	auipc	ra,0x1
    800057a0:	852080e7          	jalr	-1966(ra) # 80005fee <panic>
    panic("virtio disk should not be ready");
    800057a4:	00003517          	auipc	a0,0x3
    800057a8:	fa450513          	addi	a0,a0,-92 # 80008748 <syscalls+0x378>
    800057ac:	00001097          	auipc	ra,0x1
    800057b0:	842080e7          	jalr	-1982(ra) # 80005fee <panic>
    panic("virtio disk has no queue 0");
    800057b4:	00003517          	auipc	a0,0x3
    800057b8:	fb450513          	addi	a0,a0,-76 # 80008768 <syscalls+0x398>
    800057bc:	00001097          	auipc	ra,0x1
    800057c0:	832080e7          	jalr	-1998(ra) # 80005fee <panic>
    panic("virtio disk max queue too short");
    800057c4:	00003517          	auipc	a0,0x3
    800057c8:	fc450513          	addi	a0,a0,-60 # 80008788 <syscalls+0x3b8>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	822080e7          	jalr	-2014(ra) # 80005fee <panic>
    panic("virtio disk kalloc");
    800057d4:	00003517          	auipc	a0,0x3
    800057d8:	fd450513          	addi	a0,a0,-44 # 800087a8 <syscalls+0x3d8>
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
    80005818:	2e450513          	addi	a0,a0,740 # 80025af8 <disk+0x128>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	d0e080e7          	jalr	-754(ra) # 8000652a <acquire>
  for(int i = 0; i < 3; i++){
    80005824:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005826:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005828:	00020b97          	auipc	s7,0x20
    8000582c:	1a8b8b93          	addi	s7,s7,424 # 800259d0 <disk>
  for(int i = 0; i < 3; i++){
    80005830:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005832:	00020c97          	auipc	s9,0x20
    80005836:	2c6c8c93          	addi	s9,s9,710 # 80025af8 <disk+0x128>
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
    80005858:	17c70713          	addi	a4,a4,380 # 800259d0 <disk>
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
    80005890:	15c50513          	addi	a0,a0,348 # 800259e8 <disk+0x18>
    80005894:	ffffc097          	auipc	ra,0xffffc
    80005898:	cac080e7          	jalr	-852(ra) # 80001540 <sleep>
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
    800058b4:	12060613          	addi	a2,a2,288 # 800259d0 <disk>
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
    8000591e:	0b668693          	addi	a3,a3,182 # 800259d0 <disk>
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
    8000598e:	16e90913          	addi	s2,s2,366 # 80025af8 <disk+0x128>
  while(b->disk == 1) {
    80005992:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005994:	85ca                	mv	a1,s2
    80005996:	8556                	mv	a0,s5
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	ba8080e7          	jalr	-1112(ra) # 80001540 <sleep>
  while(b->disk == 1) {
    800059a0:	004aa783          	lw	a5,4(s5)
    800059a4:	fe9788e3          	beq	a5,s1,80005994 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800059a8:	f8042903          	lw	s2,-128(s0)
    800059ac:	00290793          	addi	a5,s2,2
    800059b0:	00479713          	slli	a4,a5,0x4
    800059b4:	00020797          	auipc	a5,0x20
    800059b8:	01c78793          	addi	a5,a5,28 # 800259d0 <disk>
    800059bc:	97ba                	add	a5,a5,a4
    800059be:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059c2:	00020997          	auipc	s3,0x20
    800059c6:	00e98993          	addi	s3,s3,14 # 800259d0 <disk>
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
    800059ee:	10e50513          	addi	a0,a0,270 # 80025af8 <disk+0x128>
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
    80005a26:	fae48493          	addi	s1,s1,-82 # 800259d0 <disk>
    80005a2a:	00020517          	auipc	a0,0x20
    80005a2e:	0ce50513          	addi	a0,a0,206 # 80025af8 <disk+0x128>
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
    80005a86:	b22080e7          	jalr	-1246(ra) # 800015a4 <wakeup>

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
    80005aa6:	05650513          	addi	a0,a0,86 # 80025af8 <disk+0x128>
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
    80005ac0:	d0450513          	addi	a0,a0,-764 # 800087c0 <syscalls+0x3f0>
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
    80005b06:	00e70713          	addi	a4,a4,14 # 80025b10 <timer_scratch>
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
    80005b4c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0aaf>
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
    80005be0:	dc2080e7          	jalr	-574(ra) # 8000199e <either_copyin>
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
    80005c3e:	01650513          	addi	a0,a0,22 # 8002dc50 <cons>
    80005c42:	00001097          	auipc	ra,0x1
    80005c46:	8e8080e7          	jalr	-1816(ra) # 8000652a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c4a:	00028497          	auipc	s1,0x28
    80005c4e:	00648493          	addi	s1,s1,6 # 8002dc50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c52:	00028917          	auipc	s2,0x28
    80005c56:	09690913          	addi	s2,s2,150 # 8002dce8 <cons+0x98>
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
    80005c7c:	b70080e7          	jalr	-1168(ra) # 800017e8 <killed>
    80005c80:	e535                	bnez	a0,80005cec <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005c82:	85a6                	mv	a1,s1
    80005c84:	854a                	mv	a0,s2
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	8ba080e7          	jalr	-1862(ra) # 80001540 <sleep>
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
    80005cc6:	c86080e7          	jalr	-890(ra) # 80001948 <either_copyout>
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
    80005cda:	f7a50513          	addi	a0,a0,-134 # 8002dc50 <cons>
    80005cde:	00001097          	auipc	ra,0x1
    80005ce2:	900080e7          	jalr	-1792(ra) # 800065de <release>

  return target - n;
    80005ce6:	413b053b          	subw	a0,s6,s3
    80005cea:	a811                	j	80005cfe <consoleread+0xea>
        release(&cons.lock);
    80005cec:	00028517          	auipc	a0,0x28
    80005cf0:	f6450513          	addi	a0,a0,-156 # 8002dc50 <cons>
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
    80005d26:	fcf72323          	sw	a5,-58(a4) # 8002dce8 <cons+0x98>
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
    80005d80:	ed450513          	addi	a0,a0,-300 # 8002dc50 <cons>
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
    80005da6:	c52080e7          	jalr	-942(ra) # 800019f4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005daa:	00028517          	auipc	a0,0x28
    80005dae:	ea650513          	addi	a0,a0,-346 # 8002dc50 <cons>
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
    80005dd2:	e8270713          	addi	a4,a4,-382 # 8002dc50 <cons>
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
    80005dfc:	e5878793          	addi	a5,a5,-424 # 8002dc50 <cons>
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
    80005e2a:	ec27a783          	lw	a5,-318(a5) # 8002dce8 <cons+0x98>
    80005e2e:	9f1d                	subw	a4,a4,a5
    80005e30:	08000793          	li	a5,128
    80005e34:	f6f71be3          	bne	a4,a5,80005daa <consoleintr+0x3c>
    80005e38:	a07d                	j	80005ee6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e3a:	00028717          	auipc	a4,0x28
    80005e3e:	e1670713          	addi	a4,a4,-490 # 8002dc50 <cons>
    80005e42:	0a072783          	lw	a5,160(a4)
    80005e46:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e4a:	00028497          	auipc	s1,0x28
    80005e4e:	e0648493          	addi	s1,s1,-506 # 8002dc50 <cons>
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
    80005e8a:	dca70713          	addi	a4,a4,-566 # 8002dc50 <cons>
    80005e8e:	0a072783          	lw	a5,160(a4)
    80005e92:	09c72703          	lw	a4,156(a4)
    80005e96:	f0f70ae3          	beq	a4,a5,80005daa <consoleintr+0x3c>
      cons.e--;
    80005e9a:	37fd                	addiw	a5,a5,-1
    80005e9c:	00028717          	auipc	a4,0x28
    80005ea0:	e4f72a23          	sw	a5,-428(a4) # 8002dcf0 <cons+0xa0>
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
    80005ec6:	d8e78793          	addi	a5,a5,-626 # 8002dc50 <cons>
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
    80005eea:	e0c7a323          	sw	a2,-506(a5) # 8002dcec <cons+0x9c>
        wakeup(&cons.r);
    80005eee:	00028517          	auipc	a0,0x28
    80005ef2:	dfa50513          	addi	a0,a0,-518 # 8002dce8 <cons+0x98>
    80005ef6:	ffffb097          	auipc	ra,0xffffb
    80005efa:	6ae080e7          	jalr	1710(ra) # 800015a4 <wakeup>
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
    80005f0c:	8d058593          	addi	a1,a1,-1840 # 800087d8 <syscalls+0x408>
    80005f10:	00028517          	auipc	a0,0x28
    80005f14:	d4050513          	addi	a0,a0,-704 # 8002dc50 <cons>
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	582080e7          	jalr	1410(ra) # 8000649a <initlock>

  uartinit();
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	32a080e7          	jalr	810(ra) # 8000624a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f28:	0001f797          	auipc	a5,0x1f
    80005f2c:	a5078793          	addi	a5,a5,-1456 # 80024978 <devsw>
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
    80005f6e:	89e60613          	addi	a2,a2,-1890 # 80008808 <digits>
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
    80005ffe:	d007ab23          	sw	zero,-746(a5) # 8002dd10 <pr+0x18>
  printf("panic: ");
    80006002:	00002517          	auipc	a0,0x2
    80006006:	7de50513          	addi	a0,a0,2014 # 800087e0 <syscalls+0x410>
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
    80006032:	88f72f23          	sw	a5,-1890(a4) # 800088cc <panicked>
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
    8000606e:	ca6dad83          	lw	s11,-858(s11) # 8002dd10 <pr+0x18>
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
    8000609a:	772b0b13          	addi	s6,s6,1906 # 80008808 <digits>
    switch(c){
    8000609e:	07300c93          	li	s9,115
    800060a2:	06400c13          	li	s8,100
    800060a6:	a82d                	j	800060e0 <printf+0xa8>
    acquire(&pr.lock);
    800060a8:	00028517          	auipc	a0,0x28
    800060ac:	c5050513          	addi	a0,a0,-944 # 8002dcf8 <pr>
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	47a080e7          	jalr	1146(ra) # 8000652a <acquire>
    800060b8:	bf7d                	j	80006076 <printf+0x3e>
    panic("null fmt");
    800060ba:	00002517          	auipc	a0,0x2
    800060be:	73650513          	addi	a0,a0,1846 # 800087f0 <syscalls+0x420>
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
    800061b8:	63448493          	addi	s1,s1,1588 # 800087e8 <syscalls+0x418>
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
    8000620a:	af250513          	addi	a0,a0,-1294 # 8002dcf8 <pr>
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
    80006226:	ad648493          	addi	s1,s1,-1322 # 8002dcf8 <pr>
    8000622a:	00002597          	auipc	a1,0x2
    8000622e:	5d658593          	addi	a1,a1,1494 # 80008800 <syscalls+0x430>
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
    8000627e:	5a658593          	addi	a1,a1,1446 # 80008820 <digits+0x18>
    80006282:	00028517          	auipc	a0,0x28
    80006286:	a9650513          	addi	a0,a0,-1386 # 8002dd18 <uart_tx_lock>
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
    800062b2:	61e7a783          	lw	a5,1566(a5) # 800088cc <panicked>
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
    800062ea:	5ea7b783          	ld	a5,1514(a5) # 800088d0 <uart_tx_r>
    800062ee:	00002717          	auipc	a4,0x2
    800062f2:	5ea73703          	ld	a4,1514(a4) # 800088d8 <uart_tx_w>
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
    80006314:	a08a0a13          	addi	s4,s4,-1528 # 8002dd18 <uart_tx_lock>
    uart_tx_r += 1;
    80006318:	00002497          	auipc	s1,0x2
    8000631c:	5b848493          	addi	s1,s1,1464 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006320:	00002997          	auipc	s3,0x2
    80006324:	5b898993          	addi	s3,s3,1464 # 800088d8 <uart_tx_w>
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
    80006346:	262080e7          	jalr	610(ra) # 800015a4 <wakeup>
    
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
    80006382:	99a50513          	addi	a0,a0,-1638 # 8002dd18 <uart_tx_lock>
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	1a4080e7          	jalr	420(ra) # 8000652a <acquire>
  if(panicked){
    8000638e:	00002797          	auipc	a5,0x2
    80006392:	53e7a783          	lw	a5,1342(a5) # 800088cc <panicked>
    80006396:	e7c9                	bnez	a5,80006420 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006398:	00002717          	auipc	a4,0x2
    8000639c:	54073703          	ld	a4,1344(a4) # 800088d8 <uart_tx_w>
    800063a0:	00002797          	auipc	a5,0x2
    800063a4:	5307b783          	ld	a5,1328(a5) # 800088d0 <uart_tx_r>
    800063a8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063ac:	00028997          	auipc	s3,0x28
    800063b0:	96c98993          	addi	s3,s3,-1684 # 8002dd18 <uart_tx_lock>
    800063b4:	00002497          	auipc	s1,0x2
    800063b8:	51c48493          	addi	s1,s1,1308 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063bc:	00002917          	auipc	s2,0x2
    800063c0:	51c90913          	addi	s2,s2,1308 # 800088d8 <uart_tx_w>
    800063c4:	00e79f63          	bne	a5,a4,800063e2 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800063c8:	85ce                	mv	a1,s3
    800063ca:	8526                	mv	a0,s1
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	174080e7          	jalr	372(ra) # 80001540 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d4:	00093703          	ld	a4,0(s2)
    800063d8:	609c                	ld	a5,0(s1)
    800063da:	02078793          	addi	a5,a5,32
    800063de:	fee785e3          	beq	a5,a4,800063c8 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063e2:	00028497          	auipc	s1,0x28
    800063e6:	93648493          	addi	s1,s1,-1738 # 8002dd18 <uart_tx_lock>
    800063ea:	01f77793          	andi	a5,a4,31
    800063ee:	97a6                	add	a5,a5,s1
    800063f0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800063f4:	0705                	addi	a4,a4,1
    800063f6:	00002797          	auipc	a5,0x2
    800063fa:	4ee7b123          	sd	a4,1250(a5) # 800088d8 <uart_tx_w>
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
    80006470:	8ac48493          	addi	s1,s1,-1876 # 8002dd18 <uart_tx_lock>
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
    80006572:	2ba50513          	addi	a0,a0,698 # 80008828 <digits+0x20>
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
    800065c2:	27250513          	addi	a0,a0,626 # 80008830 <digits+0x28>
    800065c6:	00000097          	auipc	ra,0x0
    800065ca:	a28080e7          	jalr	-1496(ra) # 80005fee <panic>
    panic("pop_off");
    800065ce:	00002517          	auipc	a0,0x2
    800065d2:	27a50513          	addi	a0,a0,634 # 80008848 <digits+0x40>
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
    8000661a:	23a50513          	addi	a0,a0,570 # 80008850 <digits+0x48>
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
