
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00026117          	auipc	sp,0x26
    80000004:	c3010113          	addi	sp,sp,-976 # 80025c30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2d9050ef          	jal	ra,80005aee <start>

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
    80000034:	d0078793          	addi	a5,a5,-768 # 8002dd30 <end>
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
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	480080e7          	jalr	1152(ra) # 800064da <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	520080e7          	jalr	1312(ra) # 8000658e <release>
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
    8000008e:	f14080e7          	jalr	-236(ra) # 80005f9e <panic>

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
    800000f0:	7d450513          	addi	a0,a0,2004 # 800088c0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	356080e7          	jalr	854(ra) # 8000644a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002e517          	auipc	a0,0x2e
    80000104:	c3050513          	addi	a0,a0,-976 # 8002dd30 <end>
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
    80000126:	79e48493          	addi	s1,s1,1950 # 800088c0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	3ae080e7          	jalr	942(ra) # 800064da <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	78650513          	addi	a0,a0,1926 # 800088c0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	44a080e7          	jalr	1098(ra) # 8000658e <release>

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
    8000016a:	75a50513          	addi	a0,a0,1882 # 800088c0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	420080e7          	jalr	1056(ra) # 8000658e <release>
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
    80000332:	56270713          	addi	a4,a4,1378 # 80008890 <started>
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
    80000358:	c94080e7          	jalr	-876(ra) # 80005fe8 <printf>
    kvminithart();  // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	772080e7          	jalr	1906(ra) # 80001ad6 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	134080e7          	jalr	308(ra) # 800054a0 <plicinithart>
  }

  scheduler();
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fba080e7          	jalr	-70(ra) # 8000132e <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	b34080e7          	jalr	-1228(ra) # 80005eb0 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	e44080e7          	jalr	-444(ra) # 800061c8 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	c54080e7          	jalr	-940(ra) # 80005fe8 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	c44080e7          	jalr	-956(ra) # 80005fe8 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	c34080e7          	jalr	-972(ra) # 80005fe8 <printf>
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
    800003f0:	09e080e7          	jalr	158(ra) # 8000548a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	0ac080e7          	jalr	172(ra) # 800054a0 <plicinithart>
    binit();            // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	ef8080e7          	jalr	-264(ra) # 800022f4 <binit>
    iinit();            // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	59e080e7          	jalr	1438(ra) # 800029a2 <iinit>
    fileinit();         // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	540080e7          	jalr	1344(ra) # 8000394c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	194080e7          	jalr	404(ra) # 800055a8 <virtio_disk_init>
    userinit();         // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cf4080e7          	jalr	-780(ra) # 80001110 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72323          	sw	a5,1126(a4) # 80008890 <started>
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
    80000442:	45a7b783          	ld	a5,1114(a5) # 80008898 <kernel_pagetable>
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
    8000048e:	b14080e7          	jalr	-1260(ra) # 80005f9e <panic>
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
    800005b4:	9ee080e7          	jalr	-1554(ra) # 80005f9e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	9de080e7          	jalr	-1570(ra) # 80005f9e <panic>
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
    80000610:	992080e7          	jalr	-1646(ra) # 80005f9e <panic>

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
    800006fe:	18a7bf23          	sd	a0,414(a5) # 80008898 <kernel_pagetable>
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
    8000075c:	846080e7          	jalr	-1978(ra) # 80005f9e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00006097          	auipc	ra,0x6
    8000076c:	836080e7          	jalr	-1994(ra) # 80005f9e <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00006097          	auipc	ra,0x6
    8000077c:	826080e7          	jalr	-2010(ra) # 80005f9e <panic>
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
    8000085c:	746080e7          	jalr	1862(ra) # 80005f9e <panic>

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
    800009a6:	5fc080e7          	jalr	1532(ra) # 80005f9e <panic>
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
    80000a2a:	578080e7          	jalr	1400(ra) # 80005f9e <panic>
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
    80000af0:	4b2080e7          	jalr	1202(ra) # 80005f9e <panic>

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
    80000cdc:	03848493          	addi	s1,s1,56 # 80008d10 <proc>
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
    80000cf6:	a1ea0a13          	addi	s4,s4,-1506 # 8001a710 <tickslock>
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
    80000d54:	24e080e7          	jalr	590(ra) # 80005f9e <panic>

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
    80000d78:	b6c50513          	addi	a0,a0,-1172 # 800088e0 <pid_lock>
    80000d7c:	00005097          	auipc	ra,0x5
    80000d80:	6ce080e7          	jalr	1742(ra) # 8000644a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3ac58593          	addi	a1,a1,940 # 80008130 <etext+0x130>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	b6c50513          	addi	a0,a0,-1172 # 800088f8 <wait_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	6b6080e7          	jalr	1718(ra) # 8000644a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9c:	00008497          	auipc	s1,0x8
    80000da0:	f7448493          	addi	s1,s1,-140 # 80008d10 <proc>
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
    80000dc2:	95298993          	addi	s3,s3,-1710 # 8001a710 <tickslock>
      initlock(&p->lock, "proc");
    80000dc6:	85da                	mv	a1,s6
    80000dc8:	8526                	mv	a0,s1
    80000dca:	00005097          	auipc	ra,0x5
    80000dce:	680080e7          	jalr	1664(ra) # 8000644a <initlock>
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
    80000e2c:	ae850513          	addi	a0,a0,-1304 # 80008910 <cpus>
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
    80000e46:	64c080e7          	jalr	1612(ra) # 8000648e <push_off>
    80000e4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4c:	2781                	sext.w	a5,a5
    80000e4e:	079e                	slli	a5,a5,0x7
    80000e50:	00008717          	auipc	a4,0x8
    80000e54:	a9070713          	addi	a4,a4,-1392 # 800088e0 <pid_lock>
    80000e58:	97ba                	add	a5,a5,a4
    80000e5a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	6d2080e7          	jalr	1746(ra) # 8000652e <pop_off>
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
    80000e84:	70e080e7          	jalr	1806(ra) # 8000658e <release>

  if (first) {
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	9b87a783          	lw	a5,-1608(a5) # 80008840 <first.1>
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
    80000ea6:	9807af23          	sw	zero,-1634(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000eaa:	4505                	li	a0,1
    80000eac:	00002097          	auipc	ra,0x2
    80000eb0:	a76080e7          	jalr	-1418(ra) # 80002922 <fsinit>
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
    80000ec6:	a1e90913          	addi	s2,s2,-1506 # 800088e0 <pid_lock>
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	60e080e7          	jalr	1550(ra) # 800064da <acquire>
  pid = nextpid;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	97078793          	addi	a5,a5,-1680 # 80008844 <nextpid>
    80000edc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ede:	0014871b          	addiw	a4,s1,1
    80000ee2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	6a8080e7          	jalr	1704(ra) # 8000658e <release>
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
    80001052:	cc248493          	addi	s1,s1,-830 # 80008d10 <proc>
    80001056:	00019917          	auipc	s2,0x19
    8000105a:	6ba90913          	addi	s2,s2,1722 # 8001a710 <tickslock>
    acquire(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	47a080e7          	jalr	1146(ra) # 800064da <acquire>
    if(p->state == UNUSED) {
    80001068:	4c9c                	lw	a5,24(s1)
    8000106a:	cf81                	beqz	a5,80001082 <allocproc+0x40>
      release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00005097          	auipc	ra,0x5
    80001072:	520080e7          	jalr	1312(ra) # 8000658e <release>
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
    800010f0:	4a2080e7          	jalr	1186(ra) # 8000658e <release>
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
    80001108:	48a080e7          	jalr	1162(ra) # 8000658e <release>
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
    80001128:	76a7be23          	sd	a0,1916(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112c:	03400613          	li	a2,52
    80001130:	00007597          	auipc	a1,0x7
    80001134:	72058593          	addi	a1,a1,1824 # 80008850 <initcode>
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
    80001172:	1d6080e7          	jalr	470(ra) # 80003344 <namei>
    80001176:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000117a:	478d                	li	a5,3
    8000117c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	40e080e7          	jalr	1038(ra) # 8000658e <release>
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
    8000128a:	308080e7          	jalr	776(ra) # 8000658e <release>
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
    800012a2:	740080e7          	jalr	1856(ra) # 800039de <filedup>
    800012a6:	00a93023          	sd	a0,0(s2)
    800012aa:	b7e5                	j	80001292 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ac:	150ab503          	ld	a0,336(s5)
    800012b0:	00002097          	auipc	ra,0x2
    800012b4:	8b0080e7          	jalr	-1872(ra) # 80002b60 <idup>
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
    800012d8:	2ba080e7          	jalr	698(ra) # 8000658e <release>
  acquire(&wait_lock);
    800012dc:	00007497          	auipc	s1,0x7
    800012e0:	61c48493          	addi	s1,s1,1564 # 800088f8 <wait_lock>
    800012e4:	8526                	mv	a0,s1
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	1f4080e7          	jalr	500(ra) # 800064da <acquire>
  np->parent = p;
    800012ee:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800012f2:	8526                	mv	a0,s1
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	29a080e7          	jalr	666(ra) # 8000658e <release>
  acquire(&np->lock);
    800012fc:	8552                	mv	a0,s4
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	1dc080e7          	jalr	476(ra) # 800064da <acquire>
  np->state = RUNNABLE;
    80001306:	478d                	li	a5,3
    80001308:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000130c:	8552                	mv	a0,s4
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	280080e7          	jalr	640(ra) # 8000658e <release>
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
    8000134e:	59670713          	addi	a4,a4,1430 # 800088e0 <pid_lock>
    80001352:	9756                	add	a4,a4,s5
    80001354:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001358:	00007717          	auipc	a4,0x7
    8000135c:	5c070713          	addi	a4,a4,1472 # 80008918 <cpus+0x8>
    80001360:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001362:	498d                	li	s3,3
        p->state = RUNNING;
    80001364:	4b11                	li	s6,4
        c->proc = p;
    80001366:	079e                	slli	a5,a5,0x7
    80001368:	00007a17          	auipc	s4,0x7
    8000136c:	578a0a13          	addi	s4,s4,1400 # 800088e0 <pid_lock>
    80001370:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001372:	00019917          	auipc	s2,0x19
    80001376:	39e90913          	addi	s2,s2,926 # 8001a710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000137e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001382:	10079073          	csrw	sstatus,a5
    80001386:	00008497          	auipc	s1,0x8
    8000138a:	98a48493          	addi	s1,s1,-1654 # 80008d10 <proc>
    8000138e:	a811                	j	800013a2 <scheduler+0x74>
      release(&p->lock);
    80001390:	8526                	mv	a0,s1
    80001392:	00005097          	auipc	ra,0x5
    80001396:	1fc080e7          	jalr	508(ra) # 8000658e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	46848493          	addi	s1,s1,1128
    8000139e:	fd248ee3          	beq	s1,s2,8000137a <scheduler+0x4c>
      acquire(&p->lock);
    800013a2:	8526                	mv	a0,s1
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	136080e7          	jalr	310(ra) # 800064da <acquire>
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
    800013ea:	07a080e7          	jalr	122(ra) # 80006460 <holding>
    800013ee:	c93d                	beqz	a0,80001464 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013f0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013f2:	2781                	sext.w	a5,a5
    800013f4:	079e                	slli	a5,a5,0x7
    800013f6:	00007717          	auipc	a4,0x7
    800013fa:	4ea70713          	addi	a4,a4,1258 # 800088e0 <pid_lock>
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
    80001420:	4c490913          	addi	s2,s2,1220 # 800088e0 <pid_lock>
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	97ca                	add	a5,a5,s2
    8000142a:	0ac7a983          	lw	s3,172(a5)
    8000142e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001430:	2781                	sext.w	a5,a5
    80001432:	079e                	slli	a5,a5,0x7
    80001434:	00007597          	auipc	a1,0x7
    80001438:	4e458593          	addi	a1,a1,1252 # 80008918 <cpus+0x8>
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
    80001470:	b32080e7          	jalr	-1230(ra) # 80005f9e <panic>
    panic("sched locks");
    80001474:	00007517          	auipc	a0,0x7
    80001478:	cfc50513          	addi	a0,a0,-772 # 80008170 <etext+0x170>
    8000147c:	00005097          	auipc	ra,0x5
    80001480:	b22080e7          	jalr	-1246(ra) # 80005f9e <panic>
    panic("sched running");
    80001484:	00007517          	auipc	a0,0x7
    80001488:	cfc50513          	addi	a0,a0,-772 # 80008180 <etext+0x180>
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	b12080e7          	jalr	-1262(ra) # 80005f9e <panic>
    panic("sched interruptible");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	cfc50513          	addi	a0,a0,-772 # 80008190 <etext+0x190>
    8000149c:	00005097          	auipc	ra,0x5
    800014a0:	b02080e7          	jalr	-1278(ra) # 80005f9e <panic>

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
    800014bc:	022080e7          	jalr	34(ra) # 800064da <acquire>
  p->state = RUNNABLE;
    800014c0:	478d                	li	a5,3
    800014c2:	cc9c                	sw	a5,24(s1)
  sched();
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	f0a080e7          	jalr	-246(ra) # 800013ce <sched>
  release(&p->lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	0c0080e7          	jalr	192(ra) # 8000658e <release>
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
    80001500:	fde080e7          	jalr	-34(ra) # 800064da <acquire>
  release(lk);
    80001504:	854a                	mv	a0,s2
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	088080e7          	jalr	136(ra) # 8000658e <release>

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
    80001528:	06a080e7          	jalr	106(ra) # 8000658e <release>
  acquire(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	fac080e7          	jalr	-84(ra) # 800064da <acquire>
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
    80001558:	00007497          	auipc	s1,0x7
    8000155c:	7b848493          	addi	s1,s1,1976 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001560:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001562:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001564:	00019917          	auipc	s2,0x19
    80001568:	1ac90913          	addi	s2,s2,428 # 8001a710 <tickslock>
    8000156c:	a811                	j	80001580 <wakeup+0x3c>
      }
      release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	01e080e7          	jalr	30(ra) # 8000658e <release>
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
    80001592:	f4c080e7          	jalr	-180(ra) # 800064da <acquire>
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
    800015d0:	74448493          	addi	s1,s1,1860 # 80008d10 <proc>
      pp->parent = initproc;
    800015d4:	00007a17          	auipc	s4,0x7
    800015d8:	2cca0a13          	addi	s4,s4,716 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015dc:	00019997          	auipc	s3,0x19
    800015e0:	13498993          	addi	s3,s3,308 # 8001a710 <tickslock>
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
    80001634:	2707b783          	ld	a5,624(a5) # 800088a0 <initproc>
    80001638:	0d050493          	addi	s1,a0,208
    8000163c:	15050913          	addi	s2,a0,336
    80001640:	02a79363          	bne	a5,a0,80001666 <exit+0x52>
    panic("init exiting");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b6450513          	addi	a0,a0,-1180 # 800081a8 <etext+0x1a8>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	952080e7          	jalr	-1710(ra) # 80005f9e <panic>
      fileclose(f);
    80001654:	00002097          	auipc	ra,0x2
    80001658:	3dc080e7          	jalr	988(ra) # 80003a30 <fileclose>
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
    80001670:	ef8080e7          	jalr	-264(ra) # 80003564 <begin_op>
  iput(p->cwd);
    80001674:	1509b503          	ld	a0,336(s3)
    80001678:	00001097          	auipc	ra,0x1
    8000167c:	6e0080e7          	jalr	1760(ra) # 80002d58 <iput>
  end_op();
    80001680:	00002097          	auipc	ra,0x2
    80001684:	f64080e7          	jalr	-156(ra) # 800035e4 <end_op>
  p->cwd = 0;
    80001688:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000168c:	00007497          	auipc	s1,0x7
    80001690:	26c48493          	addi	s1,s1,620 # 800088f8 <wait_lock>
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	e44080e7          	jalr	-444(ra) # 800064da <acquire>
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
    800016ba:	e24080e7          	jalr	-476(ra) # 800064da <acquire>
  p->xstate = status;
    800016be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016c2:	4795                	li	a5,5
    800016c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016c8:	8526                	mv	a0,s1
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	ec4080e7          	jalr	-316(ra) # 8000658e <release>
  sched();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	cfc080e7          	jalr	-772(ra) # 800013ce <sched>
  panic("zombie exit");
    800016da:	00007517          	auipc	a0,0x7
    800016de:	ade50513          	addi	a0,a0,-1314 # 800081b8 <etext+0x1b8>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	8bc080e7          	jalr	-1860(ra) # 80005f9e <panic>

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
    800016fe:	61648493          	addi	s1,s1,1558 # 80008d10 <proc>
    80001702:	00019997          	auipc	s3,0x19
    80001706:	00e98993          	addi	s3,s3,14 # 8001a710 <tickslock>
    acquire(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	dce080e7          	jalr	-562(ra) # 800064da <acquire>
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
    80001720:	e72080e7          	jalr	-398(ra) # 8000658e <release>
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
    80001742:	e50080e7          	jalr	-432(ra) # 8000658e <release>
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
    8000176c:	d72080e7          	jalr	-654(ra) # 800064da <acquire>
  p->killed = 1;
    80001770:	4785                	li	a5,1
    80001772:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	e18080e7          	jalr	-488(ra) # 8000658e <release>
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
    8000179a:	d44080e7          	jalr	-700(ra) # 800064da <acquire>
  k = p->killed;
    8000179e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017a2:	8526                	mv	a0,s1
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	dea080e7          	jalr	-534(ra) # 8000658e <release>
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
    800017e2:	11a50513          	addi	a0,a0,282 # 800088f8 <wait_lock>
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	cf4080e7          	jalr	-780(ra) # 800064da <acquire>
    havekids = 0;
    800017ee:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800017f0:	4a15                	li	s4,5
        havekids = 1;
    800017f2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f4:	00019997          	auipc	s3,0x19
    800017f8:	f1c98993          	addi	s3,s3,-228 # 8001a710 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fc:	00007c17          	auipc	s8,0x7
    80001800:	0fcc0c13          	addi	s8,s8,252 # 800088f8 <wait_lock>
    havekids = 0;
    80001804:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001806:	00007497          	auipc	s1,0x7
    8000180a:	50a48493          	addi	s1,s1,1290 # 80008d10 <proc>
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
    80001840:	d52080e7          	jalr	-686(ra) # 8000658e <release>
          release(&wait_lock);
    80001844:	00007517          	auipc	a0,0x7
    80001848:	0b450513          	addi	a0,a0,180 # 800088f8 <wait_lock>
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	d42080e7          	jalr	-702(ra) # 8000658e <release>
          return pid;
    80001854:	a0b5                	j	800018c0 <wait+0x106>
            release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	d36080e7          	jalr	-714(ra) # 8000658e <release>
            release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	09850513          	addi	a0,a0,152 # 800088f8 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	d26080e7          	jalr	-730(ra) # 8000658e <release>
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
    80001888:	c56080e7          	jalr	-938(ra) # 800064da <acquire>
        if(pp->state == ZOMBIE){
    8000188c:	4c9c                	lw	a5,24(s1)
    8000188e:	f94781e3          	beq	a5,s4,80001810 <wait+0x56>
        release(&pp->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	cfa080e7          	jalr	-774(ra) # 8000658e <release>
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
    800018b2:	04a50513          	addi	a0,a0,74 # 800088f8 <wait_lock>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	cd8080e7          	jalr	-808(ra) # 8000658e <release>
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
    800019b6:	636080e7          	jalr	1590(ra) # 80005fe8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ba:	00007497          	auipc	s1,0x7
    800019be:	4ae48493          	addi	s1,s1,1198 # 80008e68 <proc+0x158>
    800019c2:	00019917          	auipc	s2,0x19
    800019c6:	ea690913          	addi	s2,s2,-346 # 8001a868 <bcache+0x140>
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
    800019f8:	5f4080e7          	jalr	1524(ra) # 80005fe8 <printf>
    printf("\n");
    800019fc:	8552                	mv	a0,s4
    800019fe:	00004097          	auipc	ra,0x4
    80001a02:	5ea080e7          	jalr	1514(ra) # 80005fe8 <printf>
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
    80001ac2:	c5250513          	addi	a0,a0,-942 # 8001a710 <tickslock>
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	984080e7          	jalr	-1660(ra) # 8000644a <initlock>
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
    80001ae0:	8f478793          	addi	a5,a5,-1804 # 800053d0 <kernelvec>
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
    80001b92:	b8248493          	addi	s1,s1,-1150 # 8001a710 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00005097          	auipc	ra,0x5
    80001b9c:	942080e7          	jalr	-1726(ra) # 800064da <acquire>
  ticks++;
    80001ba0:	00007517          	auipc	a0,0x7
    80001ba4:	d0850513          	addi	a0,a0,-760 # 800088a8 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	996080e7          	jalr	-1642(ra) # 80001544 <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00005097          	auipc	ra,0x5
    80001bbc:	9d6080e7          	jalr	-1578(ra) # 8000658e <release>
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
    80001c00:	8dc080e7          	jalr	-1828(ra) # 800054d8 <plic_claim>
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
    80001c24:	3c8080e7          	jalr	968(ra) # 80005fe8 <printf>
      plic_complete(irq);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	8d2080e7          	jalr	-1838(ra) # 800054fc <plic_complete>
    return 1;
    80001c32:	4505                	li	a0,1
    80001c34:	bf55                	j	80001be8 <devintr+0x1e>
      uartintr();
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	7c4080e7          	jalr	1988(ra) # 800063fa <uartintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x5e>
      virtio_disk_intr();
    80001c40:	00004097          	auipc	ra,0x4
    80001c44:	d88080e7          	jalr	-632(ra) # 800059c8 <virtio_disk_intr>
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
    80001c8e:	74678793          	addi	a5,a5,1862 # 800053d0 <kernelvec>
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
    80001cbc:	16051563          	bnez	a0,80001e26 <usertrap+0x1ba>
    80001cc0:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001cc4:	47b5                	li	a5,13
    80001cc6:	0af70b63          	beq	a4,a5,80001d7c <usertrap+0x110>
    80001cca:	14202773          	csrr	a4,scause
    80001cce:	47bd                	li	a5,15
    80001cd0:	0af70663          	beq	a4,a5,80001d7c <usertrap+0x110>
    80001cd4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cd8:	03092603          	lw	a2,48(s2)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5ac50513          	addi	a0,a0,1452 # 80008288 <states.0+0x78>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	304080e7          	jalr	772(ra) # 80005fe8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5c450513          	addi	a0,a0,1476 # 800082b8 <states.0+0xa8>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	2ec080e7          	jalr	748(ra) # 80005fe8 <printf>
    setkilled(p);
    80001d04:	854a                	mv	a0,s2
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	a56080e7          	jalr	-1450(ra) # 8000175c <setkilled>
    80001d0e:	a82d                	j	80001d48 <usertrap+0xdc>
    panic("usertrap: not from user mode");
    80001d10:	00006517          	auipc	a0,0x6
    80001d14:	55850513          	addi	a0,a0,1368 # 80008268 <states.0+0x58>
    80001d18:	00004097          	auipc	ra,0x4
    80001d1c:	286080e7          	jalr	646(ra) # 80005f9e <panic>
    if (killed(p))
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	a68080e7          	jalr	-1432(ra) # 80001788 <killed>
    80001d28:	e521                	bnez	a0,80001d70 <usertrap+0x104>
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
    80001d44:	35a080e7          	jalr	858(ra) # 8000209a <syscall>
  if (killed(p))
    80001d48:	854a                	mv	a0,s2
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a3e080e7          	jalr	-1474(ra) # 80001788 <killed>
    80001d52:	e16d                	bnez	a0,80001e34 <usertrap+0x1c8>
  usertrapret();
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	d9a080e7          	jalr	-614(ra) # 80001aee <usertrapret>
}
    80001d5c:	70e2                	ld	ra,56(sp)
    80001d5e:	7442                	ld	s0,48(sp)
    80001d60:	74a2                	ld	s1,40(sp)
    80001d62:	7902                	ld	s2,32(sp)
    80001d64:	69e2                	ld	s3,24(sp)
    80001d66:	6a42                	ld	s4,16(sp)
    80001d68:	6aa2                	ld	s5,8(sp)
    80001d6a:	6b02                	ld	s6,0(sp)
    80001d6c:	6121                	addi	sp,sp,64
    80001d6e:	8082                	ret
      exit(-1);
    80001d70:	557d                	li	a0,-1
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	8a2080e7          	jalr	-1886(ra) # 80001614 <exit>
    80001d7a:	bf45                	j	80001d2a <usertrap+0xbe>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7c:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001d80:	767d                	lui	a2,0xfffff
    80001d82:	00c9f9b3          	and	s3,s3,a2
    char *mem = kalloc();
    80001d86:	ffffe097          	auipc	ra,0xffffe
    80001d8a:	392080e7          	jalr	914(ra) # 80000118 <kalloc>
    80001d8e:	8a2a                	mv	s4,a0
    if (mem == 0)
    80001d90:	d131                	beqz	a0,80001cd4 <usertrap+0x68>
    80001d92:	16890793          	addi	a5,s2,360
    for (int i = 0; i < VMASIZE; i++)
    80001d96:	4841                	li	a6,16
    80001d98:	a031                	j	80001da4 <usertrap+0x138>
    80001d9a:	2485                	addiw	s1,s1,1
    80001d9c:	03078793          	addi	a5,a5,48
    80001da0:	f3048ae3          	beq	s1,a6,80001cd4 <usertrap+0x68>
      if (va >= p->vma[i].addr && va < p->vma[i].addr + p->vma[i].length) // fix
    80001da4:	6398                	ld	a4,0(a5)
    80001da6:	fee9eae3          	bltu	s3,a4,80001d9a <usertrap+0x12e>
    80001daa:	4790                	lw	a2,8(a5)
    80001dac:	9732                	add	a4,a4,a2
    80001dae:	fee9f6e3          	bgeu	s3,a4,80001d9a <usertrap+0x12e>
    if (idx == -1)
    80001db2:	57fd                	li	a5,-1
    80001db4:	f2f480e3          	beq	s1,a5,80001cd4 <usertrap+0x68>
      struct vma v = p->vma[idx];
    80001db8:	00149793          	slli	a5,s1,0x1
    80001dbc:	00978733          	add	a4,a5,s1
    80001dc0:	0712                	slli	a4,a4,0x4
    80001dc2:	974a                	add	a4,a4,s2
    80001dc4:	16873a83          	ld	s5,360(a4)
    80001dc8:	18072b03          	lw	s6,384(a4)
    80001dcc:	18873483          	ld	s1,392(a4)
      memset(mem, 0, PGSIZE); // zero out the memory
    80001dd0:	6605                	lui	a2,0x1
    80001dd2:	4581                	li	a1,0
    80001dd4:	8552                	mv	a0,s4
    80001dd6:	ffffe097          	auipc	ra,0xffffe
    80001dda:	3a2080e7          	jalr	930(ra) # 80000178 <memset>
      if (mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80001dde:	4779                	li	a4,30
    80001de0:	86d2                	mv	a3,s4
    80001de2:	6605                	lui	a2,0x1
    80001de4:	85ce                	mv	a1,s3
    80001de6:	05093503          	ld	a0,80(s2)
    80001dea:	ffffe097          	auipc	ra,0xffffe
    80001dee:	75a080e7          	jalr	1882(ra) # 80000544 <mappages>
    80001df2:	e505                	bnez	a0,80001e1a <usertrap+0x1ae>
      mapfile(v.mfile, mem, va - (uint64)v.addr + v.offset);
    80001df4:	0169863b          	addw	a2,s3,s6
    80001df8:	4156063b          	subw	a2,a2,s5
    80001dfc:	85d2                	mv	a1,s4
    80001dfe:	8526                	mv	a0,s1
    80001e00:	00002097          	auipc	ra,0x2
    80001e04:	d6a080e7          	jalr	-662(ra) # 80003b6a <mapfile>
      if (p->killed)
    80001e08:	02892783          	lw	a5,40(s2)
    80001e0c:	df95                	beqz	a5,80001d48 <usertrap+0xdc>
        exit(-1);
    80001e0e:	557d                	li	a0,-1
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	804080e7          	jalr	-2044(ra) # 80001614 <exit>
    80001e18:	bf05                	j	80001d48 <usertrap+0xdc>
        kfree(mem);
    80001e1a:	8552                	mv	a0,s4
    80001e1c:	ffffe097          	auipc	ra,0xffffe
    80001e20:	200080e7          	jalr	512(ra) # 8000001c <kfree>
        goto err;
    80001e24:	bd45                	j	80001cd4 <usertrap+0x68>
  if (killed(p))
    80001e26:	854a                	mv	a0,s2
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	960080e7          	jalr	-1696(ra) # 80001788 <killed>
    80001e30:	c901                	beqz	a0,80001e40 <usertrap+0x1d4>
    80001e32:	a011                	j	80001e36 <usertrap+0x1ca>
    80001e34:	4481                	li	s1,0
    exit(-1);
    80001e36:	557d                	li	a0,-1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	7dc080e7          	jalr	2012(ra) # 80001614 <exit>
  if (which_dev == 2)
    80001e40:	4789                	li	a5,2
    80001e42:	f0f499e3          	bne	s1,a5,80001d54 <usertrap+0xe8>
    yield();
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	65e080e7          	jalr	1630(ra) # 800014a4 <yield>
    80001e4e:	b719                	j	80001d54 <usertrap+0xe8>

0000000080001e50 <kerneltrap>:
{
    80001e50:	7179                	addi	sp,sp,-48
    80001e52:	f406                	sd	ra,40(sp)
    80001e54:	f022                	sd	s0,32(sp)
    80001e56:	ec26                	sd	s1,24(sp)
    80001e58:	e84a                	sd	s2,16(sp)
    80001e5a:	e44e                	sd	s3,8(sp)
    80001e5c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e62:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e66:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e6a:	1004f793          	andi	a5,s1,256
    80001e6e:	cb85                	beqz	a5,80001e9e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e74:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001e76:	ef85                	bnez	a5,80001eae <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	d52080e7          	jalr	-686(ra) # 80001bca <devintr>
    80001e80:	cd1d                	beqz	a0,80001ebe <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e82:	4789                	li	a5,2
    80001e84:	06f50a63          	beq	a0,a5,80001ef8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e88:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e8c:	10049073          	csrw	sstatus,s1
}
    80001e90:	70a2                	ld	ra,40(sp)
    80001e92:	7402                	ld	s0,32(sp)
    80001e94:	64e2                	ld	s1,24(sp)
    80001e96:	6942                	ld	s2,16(sp)
    80001e98:	69a2                	ld	s3,8(sp)
    80001e9a:	6145                	addi	sp,sp,48
    80001e9c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	43a50513          	addi	a0,a0,1082 # 800082d8 <states.0+0xc8>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	0f8080e7          	jalr	248(ra) # 80005f9e <panic>
    panic("kerneltrap: interrupts enabled");
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	45250513          	addi	a0,a0,1106 # 80008300 <states.0+0xf0>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	0e8080e7          	jalr	232(ra) # 80005f9e <panic>
    printf("scause %p\n", scause);
    80001ebe:	85ce                	mv	a1,s3
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	46050513          	addi	a0,a0,1120 # 80008320 <states.0+0x110>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	120080e7          	jalr	288(ra) # 80005fe8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	45850513          	addi	a0,a0,1112 # 80008330 <states.0+0x120>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	108080e7          	jalr	264(ra) # 80005fe8 <printf>
    panic("kerneltrap");
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	46050513          	addi	a0,a0,1120 # 80008348 <states.0+0x138>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	0ae080e7          	jalr	174(ra) # 80005f9e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	f40080e7          	jalr	-192(ra) # 80000e38 <myproc>
    80001f00:	d541                	beqz	a0,80001e88 <kerneltrap+0x38>
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f36080e7          	jalr	-202(ra) # 80000e38 <myproc>
    80001f0a:	4d18                	lw	a4,24(a0)
    80001f0c:	4791                	li	a5,4
    80001f0e:	f6f71de3          	bne	a4,a5,80001e88 <kerneltrap+0x38>
    yield();
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	592080e7          	jalr	1426(ra) # 800014a4 <yield>
    80001f1a:	b7bd                	j	80001e88 <kerneltrap+0x38>

0000000080001f1c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	f10080e7          	jalr	-240(ra) # 80000e38 <myproc>
  switch (n) {
    80001f30:	4795                	li	a5,5
    80001f32:	0497e163          	bltu	a5,s1,80001f74 <argraw+0x58>
    80001f36:	048a                	slli	s1,s1,0x2
    80001f38:	00006717          	auipc	a4,0x6
    80001f3c:	44870713          	addi	a4,a4,1096 # 80008380 <states.0+0x170>
    80001f40:	94ba                	add	s1,s1,a4
    80001f42:	409c                	lw	a5,0(s1)
    80001f44:	97ba                	add	a5,a5,a4
    80001f46:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f48:	6d3c                	ld	a5,88(a0)
    80001f4a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret
    return p->trapframe->a1;
    80001f56:	6d3c                	ld	a5,88(a0)
    80001f58:	7fa8                	ld	a0,120(a5)
    80001f5a:	bfcd                	j	80001f4c <argraw+0x30>
    return p->trapframe->a2;
    80001f5c:	6d3c                	ld	a5,88(a0)
    80001f5e:	63c8                	ld	a0,128(a5)
    80001f60:	b7f5                	j	80001f4c <argraw+0x30>
    return p->trapframe->a3;
    80001f62:	6d3c                	ld	a5,88(a0)
    80001f64:	67c8                	ld	a0,136(a5)
    80001f66:	b7dd                	j	80001f4c <argraw+0x30>
    return p->trapframe->a4;
    80001f68:	6d3c                	ld	a5,88(a0)
    80001f6a:	6bc8                	ld	a0,144(a5)
    80001f6c:	b7c5                	j	80001f4c <argraw+0x30>
    return p->trapframe->a5;
    80001f6e:	6d3c                	ld	a5,88(a0)
    80001f70:	6fc8                	ld	a0,152(a5)
    80001f72:	bfe9                	j	80001f4c <argraw+0x30>
  panic("argraw");
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	3e450513          	addi	a0,a0,996 # 80008358 <states.0+0x148>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	022080e7          	jalr	34(ra) # 80005f9e <panic>

0000000080001f84 <fetchaddr>:
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	e04a                	sd	s2,0(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84aa                	mv	s1,a0
    80001f92:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	ea4080e7          	jalr	-348(ra) # 80000e38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f9c:	653c                	ld	a5,72(a0)
    80001f9e:	02f4f863          	bgeu	s1,a5,80001fce <fetchaddr+0x4a>
    80001fa2:	00848713          	addi	a4,s1,8
    80001fa6:	02e7e663          	bltu	a5,a4,80001fd2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001faa:	46a1                	li	a3,8
    80001fac:	8626                	mv	a2,s1
    80001fae:	85ca                	mv	a1,s2
    80001fb0:	6928                	ld	a0,80(a0)
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	bce080e7          	jalr	-1074(ra) # 80000b80 <copyin>
    80001fba:	00a03533          	snez	a0,a0
    80001fbe:	40a00533          	neg	a0,a0
}
    80001fc2:	60e2                	ld	ra,24(sp)
    80001fc4:	6442                	ld	s0,16(sp)
    80001fc6:	64a2                	ld	s1,8(sp)
    80001fc8:	6902                	ld	s2,0(sp)
    80001fca:	6105                	addi	sp,sp,32
    80001fcc:	8082                	ret
    return -1;
    80001fce:	557d                	li	a0,-1
    80001fd0:	bfcd                	j	80001fc2 <fetchaddr+0x3e>
    80001fd2:	557d                	li	a0,-1
    80001fd4:	b7fd                	j	80001fc2 <fetchaddr+0x3e>

0000000080001fd6 <fetchstr>:
{
    80001fd6:	7179                	addi	sp,sp,-48
    80001fd8:	f406                	sd	ra,40(sp)
    80001fda:	f022                	sd	s0,32(sp)
    80001fdc:	ec26                	sd	s1,24(sp)
    80001fde:	e84a                	sd	s2,16(sp)
    80001fe0:	e44e                	sd	s3,8(sp)
    80001fe2:	1800                	addi	s0,sp,48
    80001fe4:	892a                	mv	s2,a0
    80001fe6:	84ae                	mv	s1,a1
    80001fe8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e4e080e7          	jalr	-434(ra) # 80000e38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ff2:	86ce                	mv	a3,s3
    80001ff4:	864a                	mv	a2,s2
    80001ff6:	85a6                	mv	a1,s1
    80001ff8:	6928                	ld	a0,80(a0)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	c14080e7          	jalr	-1004(ra) # 80000c0e <copyinstr>
    80002002:	00054e63          	bltz	a0,8000201e <fetchstr+0x48>
  return strlen(buf);
    80002006:	8526                	mv	a0,s1
    80002008:	ffffe097          	auipc	ra,0xffffe
    8000200c:	2ec080e7          	jalr	748(ra) # 800002f4 <strlen>
}
    80002010:	70a2                	ld	ra,40(sp)
    80002012:	7402                	ld	s0,32(sp)
    80002014:	64e2                	ld	s1,24(sp)
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6145                	addi	sp,sp,48
    8000201c:	8082                	ret
    return -1;
    8000201e:	557d                	li	a0,-1
    80002020:	bfc5                	j	80002010 <fetchstr+0x3a>

0000000080002022 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002022:	1101                	addi	sp,sp,-32
    80002024:	ec06                	sd	ra,24(sp)
    80002026:	e822                	sd	s0,16(sp)
    80002028:	e426                	sd	s1,8(sp)
    8000202a:	1000                	addi	s0,sp,32
    8000202c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	eee080e7          	jalr	-274(ra) # 80001f1c <argraw>
    80002036:	c088                	sw	a0,0(s1)
}
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	64a2                	ld	s1,8(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret

0000000080002042 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002042:	1101                	addi	sp,sp,-32
    80002044:	ec06                	sd	ra,24(sp)
    80002046:	e822                	sd	s0,16(sp)
    80002048:	e426                	sd	s1,8(sp)
    8000204a:	1000                	addi	s0,sp,32
    8000204c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	ece080e7          	jalr	-306(ra) # 80001f1c <argraw>
    80002056:	e088                	sd	a0,0(s1)
}
    80002058:	60e2                	ld	ra,24(sp)
    8000205a:	6442                	ld	s0,16(sp)
    8000205c:	64a2                	ld	s1,8(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret

0000000080002062 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	1800                	addi	s0,sp,48
    8000206e:	84ae                	mv	s1,a1
    80002070:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002072:	fd840593          	addi	a1,s0,-40
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	fcc080e7          	jalr	-52(ra) # 80002042 <argaddr>
  return fetchstr(addr, buf, max);
    8000207e:	864a                	mv	a2,s2
    80002080:	85a6                	mv	a1,s1
    80002082:	fd843503          	ld	a0,-40(s0)
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	f50080e7          	jalr	-176(ra) # 80001fd6 <fetchstr>
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	6145                	addi	sp,sp,48
    80002098:	8082                	ret

000000008000209a <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	e426                	sd	s1,8(sp)
    800020a2:	e04a                	sd	s2,0(sp)
    800020a4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	d92080e7          	jalr	-622(ra) # 80000e38 <myproc>
    800020ae:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020b0:	05853903          	ld	s2,88(a0)
    800020b4:	0a893783          	ld	a5,168(s2)
    800020b8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020bc:	37fd                	addiw	a5,a5,-1
    800020be:	4759                	li	a4,22
    800020c0:	00f76f63          	bltu	a4,a5,800020de <syscall+0x44>
    800020c4:	00369713          	slli	a4,a3,0x3
    800020c8:	00006797          	auipc	a5,0x6
    800020cc:	2d078793          	addi	a5,a5,720 # 80008398 <syscalls>
    800020d0:	97ba                	add	a5,a5,a4
    800020d2:	639c                	ld	a5,0(a5)
    800020d4:	c789                	beqz	a5,800020de <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020d6:	9782                	jalr	a5
    800020d8:	06a93823          	sd	a0,112(s2)
    800020dc:	a839                	j	800020fa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020de:	15848613          	addi	a2,s1,344
    800020e2:	588c                	lw	a1,48(s1)
    800020e4:	00006517          	auipc	a0,0x6
    800020e8:	27c50513          	addi	a0,a0,636 # 80008360 <states.0+0x150>
    800020ec:	00004097          	auipc	ra,0x4
    800020f0:	efc080e7          	jalr	-260(ra) # 80005fe8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020f4:	6cbc                	ld	a5,88(s1)
    800020f6:	577d                	li	a4,-1
    800020f8:	fbb8                	sd	a4,112(a5)
  }
}
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	64a2                	ld	s1,8(sp)
    80002100:	6902                	ld	s2,0(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret

0000000080002106 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000210e:	fec40593          	addi	a1,s0,-20
    80002112:	4501                	li	a0,0
    80002114:	00000097          	auipc	ra,0x0
    80002118:	f0e080e7          	jalr	-242(ra) # 80002022 <argint>
  exit(n);
    8000211c:	fec42503          	lw	a0,-20(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	4f4080e7          	jalr	1268(ra) # 80001614 <exit>
  return 0;  // not reached
}
    80002128:	4501                	li	a0,0
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret

0000000080002132 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002132:	1141                	addi	sp,sp,-16
    80002134:	e406                	sd	ra,8(sp)
    80002136:	e022                	sd	s0,0(sp)
    80002138:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	cfe080e7          	jalr	-770(ra) # 80000e38 <myproc>
}
    80002142:	5908                	lw	a0,48(a0)
    80002144:	60a2                	ld	ra,8(sp)
    80002146:	6402                	ld	s0,0(sp)
    80002148:	0141                	addi	sp,sp,16
    8000214a:	8082                	ret

000000008000214c <sys_fork>:

uint64
sys_fork(void)
{
    8000214c:	1141                	addi	sp,sp,-16
    8000214e:	e406                	sd	ra,8(sp)
    80002150:	e022                	sd	s0,0(sp)
    80002152:	0800                	addi	s0,sp,16
  return fork();
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	09a080e7          	jalr	154(ra) # 800011ee <fork>
}
    8000215c:	60a2                	ld	ra,8(sp)
    8000215e:	6402                	ld	s0,0(sp)
    80002160:	0141                	addi	sp,sp,16
    80002162:	8082                	ret

0000000080002164 <sys_wait>:

uint64
sys_wait(void)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000216c:	fe840593          	addi	a1,s0,-24
    80002170:	4501                	li	a0,0
    80002172:	00000097          	auipc	ra,0x0
    80002176:	ed0080e7          	jalr	-304(ra) # 80002042 <argaddr>
  return wait(p);
    8000217a:	fe843503          	ld	a0,-24(s0)
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	63c080e7          	jalr	1596(ra) # 800017ba <wait>
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000218e:	7179                	addi	sp,sp,-48
    80002190:	f406                	sd	ra,40(sp)
    80002192:	f022                	sd	s0,32(sp)
    80002194:	ec26                	sd	s1,24(sp)
    80002196:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002198:	fdc40593          	addi	a1,s0,-36
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e84080e7          	jalr	-380(ra) # 80002022 <argint>
  addr = myproc()->sz;
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	c92080e7          	jalr	-878(ra) # 80000e38 <myproc>
    800021ae:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021b0:	fdc42503          	lw	a0,-36(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	fde080e7          	jalr	-34(ra) # 80001192 <growproc>
    800021bc:	00054863          	bltz	a0,800021cc <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021c0:	8526                	mv	a0,s1
    800021c2:	70a2                	ld	ra,40(sp)
    800021c4:	7402                	ld	s0,32(sp)
    800021c6:	64e2                	ld	s1,24(sp)
    800021c8:	6145                	addi	sp,sp,48
    800021ca:	8082                	ret
    return -1;
    800021cc:	54fd                	li	s1,-1
    800021ce:	bfcd                	j	800021c0 <sys_sbrk+0x32>

00000000800021d0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d0:	7139                	addi	sp,sp,-64
    800021d2:	fc06                	sd	ra,56(sp)
    800021d4:	f822                	sd	s0,48(sp)
    800021d6:	f426                	sd	s1,40(sp)
    800021d8:	f04a                	sd	s2,32(sp)
    800021da:	ec4e                	sd	s3,24(sp)
    800021dc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021de:	fcc40593          	addi	a1,s0,-52
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	e3e080e7          	jalr	-450(ra) # 80002022 <argint>
  if(n < 0)
    800021ec:	fcc42783          	lw	a5,-52(s0)
    800021f0:	0607cf63          	bltz	a5,8000226e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021f4:	00018517          	auipc	a0,0x18
    800021f8:	51c50513          	addi	a0,a0,1308 # 8001a710 <tickslock>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	2de080e7          	jalr	734(ra) # 800064da <acquire>
  ticks0 = ticks;
    80002204:	00006917          	auipc	s2,0x6
    80002208:	6a492903          	lw	s2,1700(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    8000220c:	fcc42783          	lw	a5,-52(s0)
    80002210:	cf9d                	beqz	a5,8000224e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002212:	00018997          	auipc	s3,0x18
    80002216:	4fe98993          	addi	s3,s3,1278 # 8001a710 <tickslock>
    8000221a:	00006497          	auipc	s1,0x6
    8000221e:	68e48493          	addi	s1,s1,1678 # 800088a8 <ticks>
    if(killed(myproc())){
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	c16080e7          	jalr	-1002(ra) # 80000e38 <myproc>
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	55e080e7          	jalr	1374(ra) # 80001788 <killed>
    80002232:	e129                	bnez	a0,80002274 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002234:	85ce                	mv	a1,s3
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	2a8080e7          	jalr	680(ra) # 800014e0 <sleep>
  while(ticks - ticks0 < n){
    80002240:	409c                	lw	a5,0(s1)
    80002242:	412787bb          	subw	a5,a5,s2
    80002246:	fcc42703          	lw	a4,-52(s0)
    8000224a:	fce7ece3          	bltu	a5,a4,80002222 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000224e:	00018517          	auipc	a0,0x18
    80002252:	4c250513          	addi	a0,a0,1218 # 8001a710 <tickslock>
    80002256:	00004097          	auipc	ra,0x4
    8000225a:	338080e7          	jalr	824(ra) # 8000658e <release>
  return 0;
    8000225e:	4501                	li	a0,0
}
    80002260:	70e2                	ld	ra,56(sp)
    80002262:	7442                	ld	s0,48(sp)
    80002264:	74a2                	ld	s1,40(sp)
    80002266:	7902                	ld	s2,32(sp)
    80002268:	69e2                	ld	s3,24(sp)
    8000226a:	6121                	addi	sp,sp,64
    8000226c:	8082                	ret
    n = 0;
    8000226e:	fc042623          	sw	zero,-52(s0)
    80002272:	b749                	j	800021f4 <sys_sleep+0x24>
      release(&tickslock);
    80002274:	00018517          	auipc	a0,0x18
    80002278:	49c50513          	addi	a0,a0,1180 # 8001a710 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	312080e7          	jalr	786(ra) # 8000658e <release>
      return -1;
    80002284:	557d                	li	a0,-1
    80002286:	bfe9                	j	80002260 <sys_sleep+0x90>

0000000080002288 <sys_kill>:

uint64
sys_kill(void)
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002290:	fec40593          	addi	a1,s0,-20
    80002294:	4501                	li	a0,0
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	d8c080e7          	jalr	-628(ra) # 80002022 <argint>
  return kill(pid);
    8000229e:	fec42503          	lw	a0,-20(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	448080e7          	jalr	1096(ra) # 800016ea <kill>
}
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	e426                	sd	s1,8(sp)
    800022ba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022bc:	00018517          	auipc	a0,0x18
    800022c0:	45450513          	addi	a0,a0,1108 # 8001a710 <tickslock>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	216080e7          	jalr	534(ra) # 800064da <acquire>
  xticks = ticks;
    800022cc:	00006497          	auipc	s1,0x6
    800022d0:	5dc4a483          	lw	s1,1500(s1) # 800088a8 <ticks>
  release(&tickslock);
    800022d4:	00018517          	auipc	a0,0x18
    800022d8:	43c50513          	addi	a0,a0,1084 # 8001a710 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	2b2080e7          	jalr	690(ra) # 8000658e <release>
  return xticks;
}
    800022e4:	02049513          	slli	a0,s1,0x20
    800022e8:	9101                	srli	a0,a0,0x20
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022f4:	7179                	addi	sp,sp,-48
    800022f6:	f406                	sd	ra,40(sp)
    800022f8:	f022                	sd	s0,32(sp)
    800022fa:	ec26                	sd	s1,24(sp)
    800022fc:	e84a                	sd	s2,16(sp)
    800022fe:	e44e                	sd	s3,8(sp)
    80002300:	e052                	sd	s4,0(sp)
    80002302:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002304:	00006597          	auipc	a1,0x6
    80002308:	15458593          	addi	a1,a1,340 # 80008458 <syscalls+0xc0>
    8000230c:	00018517          	auipc	a0,0x18
    80002310:	41c50513          	addi	a0,a0,1052 # 8001a728 <bcache>
    80002314:	00004097          	auipc	ra,0x4
    80002318:	136080e7          	jalr	310(ra) # 8000644a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000231c:	00020797          	auipc	a5,0x20
    80002320:	40c78793          	addi	a5,a5,1036 # 80022728 <bcache+0x8000>
    80002324:	00020717          	auipc	a4,0x20
    80002328:	66c70713          	addi	a4,a4,1644 # 80022990 <bcache+0x8268>
    8000232c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002330:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002334:	00018497          	auipc	s1,0x18
    80002338:	40c48493          	addi	s1,s1,1036 # 8001a740 <bcache+0x18>
    b->next = bcache.head.next;
    8000233c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000233e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002340:	00006a17          	auipc	s4,0x6
    80002344:	120a0a13          	addi	s4,s4,288 # 80008460 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002348:	2b893783          	ld	a5,696(s2)
    8000234c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000234e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002352:	85d2                	mv	a1,s4
    80002354:	01048513          	addi	a0,s1,16
    80002358:	00001097          	auipc	ra,0x1
    8000235c:	4ca080e7          	jalr	1226(ra) # 80003822 <initsleeplock>
    bcache.head.next->prev = b;
    80002360:	2b893783          	ld	a5,696(s2)
    80002364:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002366:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236a:	45848493          	addi	s1,s1,1112
    8000236e:	fd349de3          	bne	s1,s3,80002348 <binit+0x54>
  }
}
    80002372:	70a2                	ld	ra,40(sp)
    80002374:	7402                	ld	s0,32(sp)
    80002376:	64e2                	ld	s1,24(sp)
    80002378:	6942                	ld	s2,16(sp)
    8000237a:	69a2                	ld	s3,8(sp)
    8000237c:	6a02                	ld	s4,0(sp)
    8000237e:	6145                	addi	sp,sp,48
    80002380:	8082                	ret

0000000080002382 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002382:	7179                	addi	sp,sp,-48
    80002384:	f406                	sd	ra,40(sp)
    80002386:	f022                	sd	s0,32(sp)
    80002388:	ec26                	sd	s1,24(sp)
    8000238a:	e84a                	sd	s2,16(sp)
    8000238c:	e44e                	sd	s3,8(sp)
    8000238e:	1800                	addi	s0,sp,48
    80002390:	892a                	mv	s2,a0
    80002392:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002394:	00018517          	auipc	a0,0x18
    80002398:	39450513          	addi	a0,a0,916 # 8001a728 <bcache>
    8000239c:	00004097          	auipc	ra,0x4
    800023a0:	13e080e7          	jalr	318(ra) # 800064da <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023a4:	00020497          	auipc	s1,0x20
    800023a8:	63c4b483          	ld	s1,1596(s1) # 800229e0 <bcache+0x82b8>
    800023ac:	00020797          	auipc	a5,0x20
    800023b0:	5e478793          	addi	a5,a5,1508 # 80022990 <bcache+0x8268>
    800023b4:	02f48f63          	beq	s1,a5,800023f2 <bread+0x70>
    800023b8:	873e                	mv	a4,a5
    800023ba:	a021                	j	800023c2 <bread+0x40>
    800023bc:	68a4                	ld	s1,80(s1)
    800023be:	02e48a63          	beq	s1,a4,800023f2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023c2:	449c                	lw	a5,8(s1)
    800023c4:	ff279ce3          	bne	a5,s2,800023bc <bread+0x3a>
    800023c8:	44dc                	lw	a5,12(s1)
    800023ca:	ff3799e3          	bne	a5,s3,800023bc <bread+0x3a>
      b->refcnt++;
    800023ce:	40bc                	lw	a5,64(s1)
    800023d0:	2785                	addiw	a5,a5,1
    800023d2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023d4:	00018517          	auipc	a0,0x18
    800023d8:	35450513          	addi	a0,a0,852 # 8001a728 <bcache>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	1b2080e7          	jalr	434(ra) # 8000658e <release>
      acquiresleep(&b->lock);
    800023e4:	01048513          	addi	a0,s1,16
    800023e8:	00001097          	auipc	ra,0x1
    800023ec:	474080e7          	jalr	1140(ra) # 8000385c <acquiresleep>
      return b;
    800023f0:	a8b9                	j	8000244e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023f2:	00020497          	auipc	s1,0x20
    800023f6:	5e64b483          	ld	s1,1510(s1) # 800229d8 <bcache+0x82b0>
    800023fa:	00020797          	auipc	a5,0x20
    800023fe:	59678793          	addi	a5,a5,1430 # 80022990 <bcache+0x8268>
    80002402:	00f48863          	beq	s1,a5,80002412 <bread+0x90>
    80002406:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002408:	40bc                	lw	a5,64(s1)
    8000240a:	cf81                	beqz	a5,80002422 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000240c:	64a4                	ld	s1,72(s1)
    8000240e:	fee49de3          	bne	s1,a4,80002408 <bread+0x86>
  panic("bget: no buffers");
    80002412:	00006517          	auipc	a0,0x6
    80002416:	05650513          	addi	a0,a0,86 # 80008468 <syscalls+0xd0>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	b84080e7          	jalr	-1148(ra) # 80005f9e <panic>
      b->dev = dev;
    80002422:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002426:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000242a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000242e:	4785                	li	a5,1
    80002430:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002432:	00018517          	auipc	a0,0x18
    80002436:	2f650513          	addi	a0,a0,758 # 8001a728 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	154080e7          	jalr	340(ra) # 8000658e <release>
      acquiresleep(&b->lock);
    80002442:	01048513          	addi	a0,s1,16
    80002446:	00001097          	auipc	ra,0x1
    8000244a:	416080e7          	jalr	1046(ra) # 8000385c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000244e:	409c                	lw	a5,0(s1)
    80002450:	cb89                	beqz	a5,80002462 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002452:	8526                	mv	a0,s1
    80002454:	70a2                	ld	ra,40(sp)
    80002456:	7402                	ld	s0,32(sp)
    80002458:	64e2                	ld	s1,24(sp)
    8000245a:	6942                	ld	s2,16(sp)
    8000245c:	69a2                	ld	s3,8(sp)
    8000245e:	6145                	addi	sp,sp,48
    80002460:	8082                	ret
    virtio_disk_rw(b, 0);
    80002462:	4581                	li	a1,0
    80002464:	8526                	mv	a0,s1
    80002466:	00003097          	auipc	ra,0x3
    8000246a:	32e080e7          	jalr	814(ra) # 80005794 <virtio_disk_rw>
    b->valid = 1;
    8000246e:	4785                	li	a5,1
    80002470:	c09c                	sw	a5,0(s1)
  return b;
    80002472:	b7c5                	j	80002452 <bread+0xd0>

0000000080002474 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002474:	1101                	addi	sp,sp,-32
    80002476:	ec06                	sd	ra,24(sp)
    80002478:	e822                	sd	s0,16(sp)
    8000247a:	e426                	sd	s1,8(sp)
    8000247c:	1000                	addi	s0,sp,32
    8000247e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002480:	0541                	addi	a0,a0,16
    80002482:	00001097          	auipc	ra,0x1
    80002486:	474080e7          	jalr	1140(ra) # 800038f6 <holdingsleep>
    8000248a:	cd01                	beqz	a0,800024a2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000248c:	4585                	li	a1,1
    8000248e:	8526                	mv	a0,s1
    80002490:	00003097          	auipc	ra,0x3
    80002494:	304080e7          	jalr	772(ra) # 80005794 <virtio_disk_rw>
}
    80002498:	60e2                	ld	ra,24(sp)
    8000249a:	6442                	ld	s0,16(sp)
    8000249c:	64a2                	ld	s1,8(sp)
    8000249e:	6105                	addi	sp,sp,32
    800024a0:	8082                	ret
    panic("bwrite");
    800024a2:	00006517          	auipc	a0,0x6
    800024a6:	fde50513          	addi	a0,a0,-34 # 80008480 <syscalls+0xe8>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	af4080e7          	jalr	-1292(ra) # 80005f9e <panic>

00000000800024b2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	e426                	sd	s1,8(sp)
    800024ba:	e04a                	sd	s2,0(sp)
    800024bc:	1000                	addi	s0,sp,32
    800024be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024c0:	01050913          	addi	s2,a0,16
    800024c4:	854a                	mv	a0,s2
    800024c6:	00001097          	auipc	ra,0x1
    800024ca:	430080e7          	jalr	1072(ra) # 800038f6 <holdingsleep>
    800024ce:	c92d                	beqz	a0,80002540 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024d0:	854a                	mv	a0,s2
    800024d2:	00001097          	auipc	ra,0x1
    800024d6:	3e0080e7          	jalr	992(ra) # 800038b2 <releasesleep>

  acquire(&bcache.lock);
    800024da:	00018517          	auipc	a0,0x18
    800024de:	24e50513          	addi	a0,a0,590 # 8001a728 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	ff8080e7          	jalr	-8(ra) # 800064da <acquire>
  b->refcnt--;
    800024ea:	40bc                	lw	a5,64(s1)
    800024ec:	37fd                	addiw	a5,a5,-1
    800024ee:	0007871b          	sext.w	a4,a5
    800024f2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024f4:	eb05                	bnez	a4,80002524 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024f6:	68bc                	ld	a5,80(s1)
    800024f8:	64b8                	ld	a4,72(s1)
    800024fa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024fc:	64bc                	ld	a5,72(s1)
    800024fe:	68b8                	ld	a4,80(s1)
    80002500:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002502:	00020797          	auipc	a5,0x20
    80002506:	22678793          	addi	a5,a5,550 # 80022728 <bcache+0x8000>
    8000250a:	2b87b703          	ld	a4,696(a5)
    8000250e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002510:	00020717          	auipc	a4,0x20
    80002514:	48070713          	addi	a4,a4,1152 # 80022990 <bcache+0x8268>
    80002518:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000251a:	2b87b703          	ld	a4,696(a5)
    8000251e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002520:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002524:	00018517          	auipc	a0,0x18
    80002528:	20450513          	addi	a0,a0,516 # 8001a728 <bcache>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	062080e7          	jalr	98(ra) # 8000658e <release>
}
    80002534:	60e2                	ld	ra,24(sp)
    80002536:	6442                	ld	s0,16(sp)
    80002538:	64a2                	ld	s1,8(sp)
    8000253a:	6902                	ld	s2,0(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret
    panic("brelse");
    80002540:	00006517          	auipc	a0,0x6
    80002544:	f4850513          	addi	a0,a0,-184 # 80008488 <syscalls+0xf0>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	a56080e7          	jalr	-1450(ra) # 80005f9e <panic>

0000000080002550 <bpin>:

void
bpin(struct buf *b) {
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	1000                	addi	s0,sp,32
    8000255a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000255c:	00018517          	auipc	a0,0x18
    80002560:	1cc50513          	addi	a0,a0,460 # 8001a728 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	f76080e7          	jalr	-138(ra) # 800064da <acquire>
  b->refcnt++;
    8000256c:	40bc                	lw	a5,64(s1)
    8000256e:	2785                	addiw	a5,a5,1
    80002570:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002572:	00018517          	auipc	a0,0x18
    80002576:	1b650513          	addi	a0,a0,438 # 8001a728 <bcache>
    8000257a:	00004097          	auipc	ra,0x4
    8000257e:	014080e7          	jalr	20(ra) # 8000658e <release>
}
    80002582:	60e2                	ld	ra,24(sp)
    80002584:	6442                	ld	s0,16(sp)
    80002586:	64a2                	ld	s1,8(sp)
    80002588:	6105                	addi	sp,sp,32
    8000258a:	8082                	ret

000000008000258c <bunpin>:

void
bunpin(struct buf *b) {
    8000258c:	1101                	addi	sp,sp,-32
    8000258e:	ec06                	sd	ra,24(sp)
    80002590:	e822                	sd	s0,16(sp)
    80002592:	e426                	sd	s1,8(sp)
    80002594:	1000                	addi	s0,sp,32
    80002596:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002598:	00018517          	auipc	a0,0x18
    8000259c:	19050513          	addi	a0,a0,400 # 8001a728 <bcache>
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	f3a080e7          	jalr	-198(ra) # 800064da <acquire>
  b->refcnt--;
    800025a8:	40bc                	lw	a5,64(s1)
    800025aa:	37fd                	addiw	a5,a5,-1
    800025ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ae:	00018517          	auipc	a0,0x18
    800025b2:	17a50513          	addi	a0,a0,378 # 8001a728 <bcache>
    800025b6:	00004097          	auipc	ra,0x4
    800025ba:	fd8080e7          	jalr	-40(ra) # 8000658e <release>
}
    800025be:	60e2                	ld	ra,24(sp)
    800025c0:	6442                	ld	s0,16(sp)
    800025c2:	64a2                	ld	s1,8(sp)
    800025c4:	6105                	addi	sp,sp,32
    800025c6:	8082                	ret

00000000800025c8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025c8:	1101                	addi	sp,sp,-32
    800025ca:	ec06                	sd	ra,24(sp)
    800025cc:	e822                	sd	s0,16(sp)
    800025ce:	e426                	sd	s1,8(sp)
    800025d0:	e04a                	sd	s2,0(sp)
    800025d2:	1000                	addi	s0,sp,32
    800025d4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025d6:	00d5d59b          	srliw	a1,a1,0xd
    800025da:	00021797          	auipc	a5,0x21
    800025de:	82a7a783          	lw	a5,-2006(a5) # 80022e04 <sb+0x1c>
    800025e2:	9dbd                	addw	a1,a1,a5
    800025e4:	00000097          	auipc	ra,0x0
    800025e8:	d9e080e7          	jalr	-610(ra) # 80002382 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025ec:	0074f713          	andi	a4,s1,7
    800025f0:	4785                	li	a5,1
    800025f2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025f6:	14ce                	slli	s1,s1,0x33
    800025f8:	90d9                	srli	s1,s1,0x36
    800025fa:	00950733          	add	a4,a0,s1
    800025fe:	05874703          	lbu	a4,88(a4)
    80002602:	00e7f6b3          	and	a3,a5,a4
    80002606:	c69d                	beqz	a3,80002634 <bfree+0x6c>
    80002608:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000260a:	94aa                	add	s1,s1,a0
    8000260c:	fff7c793          	not	a5,a5
    80002610:	8ff9                	and	a5,a5,a4
    80002612:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002616:	00001097          	auipc	ra,0x1
    8000261a:	126080e7          	jalr	294(ra) # 8000373c <log_write>
  brelse(bp);
    8000261e:	854a                	mv	a0,s2
    80002620:	00000097          	auipc	ra,0x0
    80002624:	e92080e7          	jalr	-366(ra) # 800024b2 <brelse>
}
    80002628:	60e2                	ld	ra,24(sp)
    8000262a:	6442                	ld	s0,16(sp)
    8000262c:	64a2                	ld	s1,8(sp)
    8000262e:	6902                	ld	s2,0(sp)
    80002630:	6105                	addi	sp,sp,32
    80002632:	8082                	ret
    panic("freeing free block");
    80002634:	00006517          	auipc	a0,0x6
    80002638:	e5c50513          	addi	a0,a0,-420 # 80008490 <syscalls+0xf8>
    8000263c:	00004097          	auipc	ra,0x4
    80002640:	962080e7          	jalr	-1694(ra) # 80005f9e <panic>

0000000080002644 <balloc>:
{
    80002644:	711d                	addi	sp,sp,-96
    80002646:	ec86                	sd	ra,88(sp)
    80002648:	e8a2                	sd	s0,80(sp)
    8000264a:	e4a6                	sd	s1,72(sp)
    8000264c:	e0ca                	sd	s2,64(sp)
    8000264e:	fc4e                	sd	s3,56(sp)
    80002650:	f852                	sd	s4,48(sp)
    80002652:	f456                	sd	s5,40(sp)
    80002654:	f05a                	sd	s6,32(sp)
    80002656:	ec5e                	sd	s7,24(sp)
    80002658:	e862                	sd	s8,16(sp)
    8000265a:	e466                	sd	s9,8(sp)
    8000265c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000265e:	00020797          	auipc	a5,0x20
    80002662:	78e7a783          	lw	a5,1934(a5) # 80022dec <sb+0x4>
    80002666:	10078163          	beqz	a5,80002768 <balloc+0x124>
    8000266a:	8baa                	mv	s7,a0
    8000266c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000266e:	00020b17          	auipc	s6,0x20
    80002672:	77ab0b13          	addi	s6,s6,1914 # 80022de8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002676:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002678:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000267c:	6c89                	lui	s9,0x2
    8000267e:	a061                	j	80002706 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002680:	974a                	add	a4,a4,s2
    80002682:	8fd5                	or	a5,a5,a3
    80002684:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	00001097          	auipc	ra,0x1
    8000268e:	0b2080e7          	jalr	178(ra) # 8000373c <log_write>
        brelse(bp);
    80002692:	854a                	mv	a0,s2
    80002694:	00000097          	auipc	ra,0x0
    80002698:	e1e080e7          	jalr	-482(ra) # 800024b2 <brelse>
  bp = bread(dev, bno);
    8000269c:	85a6                	mv	a1,s1
    8000269e:	855e                	mv	a0,s7
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	ce2080e7          	jalr	-798(ra) # 80002382 <bread>
    800026a8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026aa:	40000613          	li	a2,1024
    800026ae:	4581                	li	a1,0
    800026b0:	05850513          	addi	a0,a0,88
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	ac4080e7          	jalr	-1340(ra) # 80000178 <memset>
  log_write(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00001097          	auipc	ra,0x1
    800026c2:	07e080e7          	jalr	126(ra) # 8000373c <log_write>
  brelse(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	dea080e7          	jalr	-534(ra) # 800024b2 <brelse>
}
    800026d0:	8526                	mv	a0,s1
    800026d2:	60e6                	ld	ra,88(sp)
    800026d4:	6446                	ld	s0,80(sp)
    800026d6:	64a6                	ld	s1,72(sp)
    800026d8:	6906                	ld	s2,64(sp)
    800026da:	79e2                	ld	s3,56(sp)
    800026dc:	7a42                	ld	s4,48(sp)
    800026de:	7aa2                	ld	s5,40(sp)
    800026e0:	7b02                	ld	s6,32(sp)
    800026e2:	6be2                	ld	s7,24(sp)
    800026e4:	6c42                	ld	s8,16(sp)
    800026e6:	6ca2                	ld	s9,8(sp)
    800026e8:	6125                	addi	sp,sp,96
    800026ea:	8082                	ret
    brelse(bp);
    800026ec:	854a                	mv	a0,s2
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	dc4080e7          	jalr	-572(ra) # 800024b2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026f6:	015c87bb          	addw	a5,s9,s5
    800026fa:	00078a9b          	sext.w	s5,a5
    800026fe:	004b2703          	lw	a4,4(s6)
    80002702:	06eaf363          	bgeu	s5,a4,80002768 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002706:	41fad79b          	sraiw	a5,s5,0x1f
    8000270a:	0137d79b          	srliw	a5,a5,0x13
    8000270e:	015787bb          	addw	a5,a5,s5
    80002712:	40d7d79b          	sraiw	a5,a5,0xd
    80002716:	01cb2583          	lw	a1,28(s6)
    8000271a:	9dbd                	addw	a1,a1,a5
    8000271c:	855e                	mv	a0,s7
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	c64080e7          	jalr	-924(ra) # 80002382 <bread>
    80002726:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002728:	004b2503          	lw	a0,4(s6)
    8000272c:	000a849b          	sext.w	s1,s5
    80002730:	8662                	mv	a2,s8
    80002732:	faa4fde3          	bgeu	s1,a0,800026ec <balloc+0xa8>
      m = 1 << (bi % 8);
    80002736:	41f6579b          	sraiw	a5,a2,0x1f
    8000273a:	01d7d69b          	srliw	a3,a5,0x1d
    8000273e:	00c6873b          	addw	a4,a3,a2
    80002742:	00777793          	andi	a5,a4,7
    80002746:	9f95                	subw	a5,a5,a3
    80002748:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000274c:	4037571b          	sraiw	a4,a4,0x3
    80002750:	00e906b3          	add	a3,s2,a4
    80002754:	0586c683          	lbu	a3,88(a3)
    80002758:	00d7f5b3          	and	a1,a5,a3
    8000275c:	d195                	beqz	a1,80002680 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275e:	2605                	addiw	a2,a2,1
    80002760:	2485                	addiw	s1,s1,1
    80002762:	fd4618e3          	bne	a2,s4,80002732 <balloc+0xee>
    80002766:	b759                	j	800026ec <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002768:	00006517          	auipc	a0,0x6
    8000276c:	d4050513          	addi	a0,a0,-704 # 800084a8 <syscalls+0x110>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	878080e7          	jalr	-1928(ra) # 80005fe8 <printf>
  return 0;
    80002778:	4481                	li	s1,0
    8000277a:	bf99                	j	800026d0 <balloc+0x8c>

000000008000277c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000277c:	7179                	addi	sp,sp,-48
    8000277e:	f406                	sd	ra,40(sp)
    80002780:	f022                	sd	s0,32(sp)
    80002782:	ec26                	sd	s1,24(sp)
    80002784:	e84a                	sd	s2,16(sp)
    80002786:	e44e                	sd	s3,8(sp)
    80002788:	e052                	sd	s4,0(sp)
    8000278a:	1800                	addi	s0,sp,48
    8000278c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000278e:	47ad                	li	a5,11
    80002790:	02b7e863          	bltu	a5,a1,800027c0 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002794:	02059793          	slli	a5,a1,0x20
    80002798:	01e7d593          	srli	a1,a5,0x1e
    8000279c:	00b504b3          	add	s1,a0,a1
    800027a0:	0504a903          	lw	s2,80(s1)
    800027a4:	06091e63          	bnez	s2,80002820 <bmap+0xa4>
      addr = balloc(ip->dev);
    800027a8:	4108                	lw	a0,0(a0)
    800027aa:	00000097          	auipc	ra,0x0
    800027ae:	e9a080e7          	jalr	-358(ra) # 80002644 <balloc>
    800027b2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027b6:	06090563          	beqz	s2,80002820 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800027ba:	0524a823          	sw	s2,80(s1)
    800027be:	a08d                	j	80002820 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027c0:	ff45849b          	addiw	s1,a1,-12
    800027c4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027c8:	0ff00793          	li	a5,255
    800027cc:	08e7e563          	bltu	a5,a4,80002856 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027d0:	08052903          	lw	s2,128(a0)
    800027d4:	00091d63          	bnez	s2,800027ee <bmap+0x72>
      addr = balloc(ip->dev);
    800027d8:	4108                	lw	a0,0(a0)
    800027da:	00000097          	auipc	ra,0x0
    800027de:	e6a080e7          	jalr	-406(ra) # 80002644 <balloc>
    800027e2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027e6:	02090d63          	beqz	s2,80002820 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027ea:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027ee:	85ca                	mv	a1,s2
    800027f0:	0009a503          	lw	a0,0(s3)
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	b8e080e7          	jalr	-1138(ra) # 80002382 <bread>
    800027fc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027fe:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002802:	02049713          	slli	a4,s1,0x20
    80002806:	01e75593          	srli	a1,a4,0x1e
    8000280a:	00b784b3          	add	s1,a5,a1
    8000280e:	0004a903          	lw	s2,0(s1)
    80002812:	02090063          	beqz	s2,80002832 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002816:	8552                	mv	a0,s4
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	c9a080e7          	jalr	-870(ra) # 800024b2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002820:	854a                	mv	a0,s2
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6a02                	ld	s4,0(sp)
    8000282e:	6145                	addi	sp,sp,48
    80002830:	8082                	ret
      addr = balloc(ip->dev);
    80002832:	0009a503          	lw	a0,0(s3)
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	e0e080e7          	jalr	-498(ra) # 80002644 <balloc>
    8000283e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002842:	fc090ae3          	beqz	s2,80002816 <bmap+0x9a>
        a[bn] = addr;
    80002846:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000284a:	8552                	mv	a0,s4
    8000284c:	00001097          	auipc	ra,0x1
    80002850:	ef0080e7          	jalr	-272(ra) # 8000373c <log_write>
    80002854:	b7c9                	j	80002816 <bmap+0x9a>
  panic("bmap: out of range");
    80002856:	00006517          	auipc	a0,0x6
    8000285a:	c6a50513          	addi	a0,a0,-918 # 800084c0 <syscalls+0x128>
    8000285e:	00003097          	auipc	ra,0x3
    80002862:	740080e7          	jalr	1856(ra) # 80005f9e <panic>

0000000080002866 <iget>:
{
    80002866:	7179                	addi	sp,sp,-48
    80002868:	f406                	sd	ra,40(sp)
    8000286a:	f022                	sd	s0,32(sp)
    8000286c:	ec26                	sd	s1,24(sp)
    8000286e:	e84a                	sd	s2,16(sp)
    80002870:	e44e                	sd	s3,8(sp)
    80002872:	e052                	sd	s4,0(sp)
    80002874:	1800                	addi	s0,sp,48
    80002876:	89aa                	mv	s3,a0
    80002878:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000287a:	00020517          	auipc	a0,0x20
    8000287e:	58e50513          	addi	a0,a0,1422 # 80022e08 <itable>
    80002882:	00004097          	auipc	ra,0x4
    80002886:	c58080e7          	jalr	-936(ra) # 800064da <acquire>
  empty = 0;
    8000288a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000288c:	00020497          	auipc	s1,0x20
    80002890:	59448493          	addi	s1,s1,1428 # 80022e20 <itable+0x18>
    80002894:	00022697          	auipc	a3,0x22
    80002898:	01c68693          	addi	a3,a3,28 # 800248b0 <log>
    8000289c:	a039                	j	800028aa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000289e:	02090b63          	beqz	s2,800028d4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a2:	08848493          	addi	s1,s1,136
    800028a6:	02d48a63          	beq	s1,a3,800028da <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028aa:	449c                	lw	a5,8(s1)
    800028ac:	fef059e3          	blez	a5,8000289e <iget+0x38>
    800028b0:	4098                	lw	a4,0(s1)
    800028b2:	ff3716e3          	bne	a4,s3,8000289e <iget+0x38>
    800028b6:	40d8                	lw	a4,4(s1)
    800028b8:	ff4713e3          	bne	a4,s4,8000289e <iget+0x38>
      ip->ref++;
    800028bc:	2785                	addiw	a5,a5,1
    800028be:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028c0:	00020517          	auipc	a0,0x20
    800028c4:	54850513          	addi	a0,a0,1352 # 80022e08 <itable>
    800028c8:	00004097          	auipc	ra,0x4
    800028cc:	cc6080e7          	jalr	-826(ra) # 8000658e <release>
      return ip;
    800028d0:	8926                	mv	s2,s1
    800028d2:	a03d                	j	80002900 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d4:	f7f9                	bnez	a5,800028a2 <iget+0x3c>
    800028d6:	8926                	mv	s2,s1
    800028d8:	b7e9                	j	800028a2 <iget+0x3c>
  if(empty == 0)
    800028da:	02090c63          	beqz	s2,80002912 <iget+0xac>
  ip->dev = dev;
    800028de:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028e2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028e6:	4785                	li	a5,1
    800028e8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028ec:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028f0:	00020517          	auipc	a0,0x20
    800028f4:	51850513          	addi	a0,a0,1304 # 80022e08 <itable>
    800028f8:	00004097          	auipc	ra,0x4
    800028fc:	c96080e7          	jalr	-874(ra) # 8000658e <release>
}
    80002900:	854a                	mv	a0,s2
    80002902:	70a2                	ld	ra,40(sp)
    80002904:	7402                	ld	s0,32(sp)
    80002906:	64e2                	ld	s1,24(sp)
    80002908:	6942                	ld	s2,16(sp)
    8000290a:	69a2                	ld	s3,8(sp)
    8000290c:	6a02                	ld	s4,0(sp)
    8000290e:	6145                	addi	sp,sp,48
    80002910:	8082                	ret
    panic("iget: no inodes");
    80002912:	00006517          	auipc	a0,0x6
    80002916:	bc650513          	addi	a0,a0,-1082 # 800084d8 <syscalls+0x140>
    8000291a:	00003097          	auipc	ra,0x3
    8000291e:	684080e7          	jalr	1668(ra) # 80005f9e <panic>

0000000080002922 <fsinit>:
fsinit(int dev) {
    80002922:	7179                	addi	sp,sp,-48
    80002924:	f406                	sd	ra,40(sp)
    80002926:	f022                	sd	s0,32(sp)
    80002928:	ec26                	sd	s1,24(sp)
    8000292a:	e84a                	sd	s2,16(sp)
    8000292c:	e44e                	sd	s3,8(sp)
    8000292e:	1800                	addi	s0,sp,48
    80002930:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002932:	4585                	li	a1,1
    80002934:	00000097          	auipc	ra,0x0
    80002938:	a4e080e7          	jalr	-1458(ra) # 80002382 <bread>
    8000293c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000293e:	00020997          	auipc	s3,0x20
    80002942:	4aa98993          	addi	s3,s3,1194 # 80022de8 <sb>
    80002946:	02000613          	li	a2,32
    8000294a:	05850593          	addi	a1,a0,88
    8000294e:	854e                	mv	a0,s3
    80002950:	ffffe097          	auipc	ra,0xffffe
    80002954:	884080e7          	jalr	-1916(ra) # 800001d4 <memmove>
  brelse(bp);
    80002958:	8526                	mv	a0,s1
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	b58080e7          	jalr	-1192(ra) # 800024b2 <brelse>
  if(sb.magic != FSMAGIC)
    80002962:	0009a703          	lw	a4,0(s3)
    80002966:	102037b7          	lui	a5,0x10203
    8000296a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000296e:	02f71263          	bne	a4,a5,80002992 <fsinit+0x70>
  initlog(dev, &sb);
    80002972:	00020597          	auipc	a1,0x20
    80002976:	47658593          	addi	a1,a1,1142 # 80022de8 <sb>
    8000297a:	854a                	mv	a0,s2
    8000297c:	00001097          	auipc	ra,0x1
    80002980:	b42080e7          	jalr	-1214(ra) # 800034be <initlog>
}
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6145                	addi	sp,sp,48
    80002990:	8082                	ret
    panic("invalid file system");
    80002992:	00006517          	auipc	a0,0x6
    80002996:	b5650513          	addi	a0,a0,-1194 # 800084e8 <syscalls+0x150>
    8000299a:	00003097          	auipc	ra,0x3
    8000299e:	604080e7          	jalr	1540(ra) # 80005f9e <panic>

00000000800029a2 <iinit>:
{
    800029a2:	7179                	addi	sp,sp,-48
    800029a4:	f406                	sd	ra,40(sp)
    800029a6:	f022                	sd	s0,32(sp)
    800029a8:	ec26                	sd	s1,24(sp)
    800029aa:	e84a                	sd	s2,16(sp)
    800029ac:	e44e                	sd	s3,8(sp)
    800029ae:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029b0:	00006597          	auipc	a1,0x6
    800029b4:	b5058593          	addi	a1,a1,-1200 # 80008500 <syscalls+0x168>
    800029b8:	00020517          	auipc	a0,0x20
    800029bc:	45050513          	addi	a0,a0,1104 # 80022e08 <itable>
    800029c0:	00004097          	auipc	ra,0x4
    800029c4:	a8a080e7          	jalr	-1398(ra) # 8000644a <initlock>
  for(i = 0; i < NINODE; i++) {
    800029c8:	00020497          	auipc	s1,0x20
    800029cc:	46848493          	addi	s1,s1,1128 # 80022e30 <itable+0x28>
    800029d0:	00022997          	auipc	s3,0x22
    800029d4:	ef098993          	addi	s3,s3,-272 # 800248c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029d8:	00006917          	auipc	s2,0x6
    800029dc:	b3090913          	addi	s2,s2,-1232 # 80008508 <syscalls+0x170>
    800029e0:	85ca                	mv	a1,s2
    800029e2:	8526                	mv	a0,s1
    800029e4:	00001097          	auipc	ra,0x1
    800029e8:	e3e080e7          	jalr	-450(ra) # 80003822 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029ec:	08848493          	addi	s1,s1,136
    800029f0:	ff3498e3          	bne	s1,s3,800029e0 <iinit+0x3e>
}
    800029f4:	70a2                	ld	ra,40(sp)
    800029f6:	7402                	ld	s0,32(sp)
    800029f8:	64e2                	ld	s1,24(sp)
    800029fa:	6942                	ld	s2,16(sp)
    800029fc:	69a2                	ld	s3,8(sp)
    800029fe:	6145                	addi	sp,sp,48
    80002a00:	8082                	ret

0000000080002a02 <ialloc>:
{
    80002a02:	715d                	addi	sp,sp,-80
    80002a04:	e486                	sd	ra,72(sp)
    80002a06:	e0a2                	sd	s0,64(sp)
    80002a08:	fc26                	sd	s1,56(sp)
    80002a0a:	f84a                	sd	s2,48(sp)
    80002a0c:	f44e                	sd	s3,40(sp)
    80002a0e:	f052                	sd	s4,32(sp)
    80002a10:	ec56                	sd	s5,24(sp)
    80002a12:	e85a                	sd	s6,16(sp)
    80002a14:	e45e                	sd	s7,8(sp)
    80002a16:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a18:	00020717          	auipc	a4,0x20
    80002a1c:	3dc72703          	lw	a4,988(a4) # 80022df4 <sb+0xc>
    80002a20:	4785                	li	a5,1
    80002a22:	04e7fa63          	bgeu	a5,a4,80002a76 <ialloc+0x74>
    80002a26:	8aaa                	mv	s5,a0
    80002a28:	8bae                	mv	s7,a1
    80002a2a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a2c:	00020a17          	auipc	s4,0x20
    80002a30:	3bca0a13          	addi	s4,s4,956 # 80022de8 <sb>
    80002a34:	00048b1b          	sext.w	s6,s1
    80002a38:	0044d793          	srli	a5,s1,0x4
    80002a3c:	018a2583          	lw	a1,24(s4)
    80002a40:	9dbd                	addw	a1,a1,a5
    80002a42:	8556                	mv	a0,s5
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	93e080e7          	jalr	-1730(ra) # 80002382 <bread>
    80002a4c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a4e:	05850993          	addi	s3,a0,88
    80002a52:	00f4f793          	andi	a5,s1,15
    80002a56:	079a                	slli	a5,a5,0x6
    80002a58:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a5a:	00099783          	lh	a5,0(s3)
    80002a5e:	c3a1                	beqz	a5,80002a9e <ialloc+0x9c>
    brelse(bp);
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	a52080e7          	jalr	-1454(ra) # 800024b2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a68:	0485                	addi	s1,s1,1
    80002a6a:	00ca2703          	lw	a4,12(s4)
    80002a6e:	0004879b          	sext.w	a5,s1
    80002a72:	fce7e1e3          	bltu	a5,a4,80002a34 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a76:	00006517          	auipc	a0,0x6
    80002a7a:	a9a50513          	addi	a0,a0,-1382 # 80008510 <syscalls+0x178>
    80002a7e:	00003097          	auipc	ra,0x3
    80002a82:	56a080e7          	jalr	1386(ra) # 80005fe8 <printf>
  return 0;
    80002a86:	4501                	li	a0,0
}
    80002a88:	60a6                	ld	ra,72(sp)
    80002a8a:	6406                	ld	s0,64(sp)
    80002a8c:	74e2                	ld	s1,56(sp)
    80002a8e:	7942                	ld	s2,48(sp)
    80002a90:	79a2                	ld	s3,40(sp)
    80002a92:	7a02                	ld	s4,32(sp)
    80002a94:	6ae2                	ld	s5,24(sp)
    80002a96:	6b42                	ld	s6,16(sp)
    80002a98:	6ba2                	ld	s7,8(sp)
    80002a9a:	6161                	addi	sp,sp,80
    80002a9c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a9e:	04000613          	li	a2,64
    80002aa2:	4581                	li	a1,0
    80002aa4:	854e                	mv	a0,s3
    80002aa6:	ffffd097          	auipc	ra,0xffffd
    80002aaa:	6d2080e7          	jalr	1746(ra) # 80000178 <memset>
      dip->type = type;
    80002aae:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	00001097          	auipc	ra,0x1
    80002ab8:	c88080e7          	jalr	-888(ra) # 8000373c <log_write>
      brelse(bp);
    80002abc:	854a                	mv	a0,s2
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	9f4080e7          	jalr	-1548(ra) # 800024b2 <brelse>
      return iget(dev, inum);
    80002ac6:	85da                	mv	a1,s6
    80002ac8:	8556                	mv	a0,s5
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	d9c080e7          	jalr	-612(ra) # 80002866 <iget>
    80002ad2:	bf5d                	j	80002a88 <ialloc+0x86>

0000000080002ad4 <iupdate>:
{
    80002ad4:	1101                	addi	sp,sp,-32
    80002ad6:	ec06                	sd	ra,24(sp)
    80002ad8:	e822                	sd	s0,16(sp)
    80002ada:	e426                	sd	s1,8(sp)
    80002adc:	e04a                	sd	s2,0(sp)
    80002ade:	1000                	addi	s0,sp,32
    80002ae0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ae2:	415c                	lw	a5,4(a0)
    80002ae4:	0047d79b          	srliw	a5,a5,0x4
    80002ae8:	00020597          	auipc	a1,0x20
    80002aec:	3185a583          	lw	a1,792(a1) # 80022e00 <sb+0x18>
    80002af0:	9dbd                	addw	a1,a1,a5
    80002af2:	4108                	lw	a0,0(a0)
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	88e080e7          	jalr	-1906(ra) # 80002382 <bread>
    80002afc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002afe:	05850793          	addi	a5,a0,88
    80002b02:	40c8                	lw	a0,4(s1)
    80002b04:	893d                	andi	a0,a0,15
    80002b06:	051a                	slli	a0,a0,0x6
    80002b08:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b0a:	04449703          	lh	a4,68(s1)
    80002b0e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b12:	04649703          	lh	a4,70(s1)
    80002b16:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b1a:	04849703          	lh	a4,72(s1)
    80002b1e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b22:	04a49703          	lh	a4,74(s1)
    80002b26:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b2a:	44f8                	lw	a4,76(s1)
    80002b2c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b2e:	03400613          	li	a2,52
    80002b32:	05048593          	addi	a1,s1,80
    80002b36:	0531                	addi	a0,a0,12
    80002b38:	ffffd097          	auipc	ra,0xffffd
    80002b3c:	69c080e7          	jalr	1692(ra) # 800001d4 <memmove>
  log_write(bp);
    80002b40:	854a                	mv	a0,s2
    80002b42:	00001097          	auipc	ra,0x1
    80002b46:	bfa080e7          	jalr	-1030(ra) # 8000373c <log_write>
  brelse(bp);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	966080e7          	jalr	-1690(ra) # 800024b2 <brelse>
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret

0000000080002b60 <idup>:
{
    80002b60:	1101                	addi	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	e426                	sd	s1,8(sp)
    80002b68:	1000                	addi	s0,sp,32
    80002b6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b6c:	00020517          	auipc	a0,0x20
    80002b70:	29c50513          	addi	a0,a0,668 # 80022e08 <itable>
    80002b74:	00004097          	auipc	ra,0x4
    80002b78:	966080e7          	jalr	-1690(ra) # 800064da <acquire>
  ip->ref++;
    80002b7c:	449c                	lw	a5,8(s1)
    80002b7e:	2785                	addiw	a5,a5,1
    80002b80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b82:	00020517          	auipc	a0,0x20
    80002b86:	28650513          	addi	a0,a0,646 # 80022e08 <itable>
    80002b8a:	00004097          	auipc	ra,0x4
    80002b8e:	a04080e7          	jalr	-1532(ra) # 8000658e <release>
}
    80002b92:	8526                	mv	a0,s1
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	64a2                	ld	s1,8(sp)
    80002b9a:	6105                	addi	sp,sp,32
    80002b9c:	8082                	ret

0000000080002b9e <ilock>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002baa:	c115                	beqz	a0,80002bce <ilock+0x30>
    80002bac:	84aa                	mv	s1,a0
    80002bae:	451c                	lw	a5,8(a0)
    80002bb0:	00f05f63          	blez	a5,80002bce <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bb4:	0541                	addi	a0,a0,16
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	ca6080e7          	jalr	-858(ra) # 8000385c <acquiresleep>
  if(ip->valid == 0){
    80002bbe:	40bc                	lw	a5,64(s1)
    80002bc0:	cf99                	beqz	a5,80002bde <ilock+0x40>
}
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6902                	ld	s2,0(sp)
    80002bca:	6105                	addi	sp,sp,32
    80002bcc:	8082                	ret
    panic("ilock");
    80002bce:	00006517          	auipc	a0,0x6
    80002bd2:	95a50513          	addi	a0,a0,-1702 # 80008528 <syscalls+0x190>
    80002bd6:	00003097          	auipc	ra,0x3
    80002bda:	3c8080e7          	jalr	968(ra) # 80005f9e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bde:	40dc                	lw	a5,4(s1)
    80002be0:	0047d79b          	srliw	a5,a5,0x4
    80002be4:	00020597          	auipc	a1,0x20
    80002be8:	21c5a583          	lw	a1,540(a1) # 80022e00 <sb+0x18>
    80002bec:	9dbd                	addw	a1,a1,a5
    80002bee:	4088                	lw	a0,0(s1)
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	792080e7          	jalr	1938(ra) # 80002382 <bread>
    80002bf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bfa:	05850593          	addi	a1,a0,88
    80002bfe:	40dc                	lw	a5,4(s1)
    80002c00:	8bbd                	andi	a5,a5,15
    80002c02:	079a                	slli	a5,a5,0x6
    80002c04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c06:	00059783          	lh	a5,0(a1)
    80002c0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c0e:	00259783          	lh	a5,2(a1)
    80002c12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c16:	00459783          	lh	a5,4(a1)
    80002c1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c1e:	00659783          	lh	a5,6(a1)
    80002c22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c26:	459c                	lw	a5,8(a1)
    80002c28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c2a:	03400613          	li	a2,52
    80002c2e:	05b1                	addi	a1,a1,12
    80002c30:	05048513          	addi	a0,s1,80
    80002c34:	ffffd097          	auipc	ra,0xffffd
    80002c38:	5a0080e7          	jalr	1440(ra) # 800001d4 <memmove>
    brelse(bp);
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	00000097          	auipc	ra,0x0
    80002c42:	874080e7          	jalr	-1932(ra) # 800024b2 <brelse>
    ip->valid = 1;
    80002c46:	4785                	li	a5,1
    80002c48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c4a:	04449783          	lh	a5,68(s1)
    80002c4e:	fbb5                	bnez	a5,80002bc2 <ilock+0x24>
      panic("ilock: no type");
    80002c50:	00006517          	auipc	a0,0x6
    80002c54:	8e050513          	addi	a0,a0,-1824 # 80008530 <syscalls+0x198>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	346080e7          	jalr	838(ra) # 80005f9e <panic>

0000000080002c60 <iunlock>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c6c:	c905                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c6e:	84aa                	mv	s1,a0
    80002c70:	01050913          	addi	s2,a0,16
    80002c74:	854a                	mv	a0,s2
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	c80080e7          	jalr	-896(ra) # 800038f6 <holdingsleep>
    80002c7e:	cd19                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c80:	449c                	lw	a5,8(s1)
    80002c82:	00f05d63          	blez	a5,80002c9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c86:	854a                	mv	a0,s2
    80002c88:	00001097          	auipc	ra,0x1
    80002c8c:	c2a080e7          	jalr	-982(ra) # 800038b2 <releasesleep>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    panic("iunlock");
    80002c9c:	00006517          	auipc	a0,0x6
    80002ca0:	8a450513          	addi	a0,a0,-1884 # 80008540 <syscalls+0x1a8>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	2fa080e7          	jalr	762(ra) # 80005f9e <panic>

0000000080002cac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cac:	7179                	addi	sp,sp,-48
    80002cae:	f406                	sd	ra,40(sp)
    80002cb0:	f022                	sd	s0,32(sp)
    80002cb2:	ec26                	sd	s1,24(sp)
    80002cb4:	e84a                	sd	s2,16(sp)
    80002cb6:	e44e                	sd	s3,8(sp)
    80002cb8:	e052                	sd	s4,0(sp)
    80002cba:	1800                	addi	s0,sp,48
    80002cbc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cbe:	05050493          	addi	s1,a0,80
    80002cc2:	08050913          	addi	s2,a0,128
    80002cc6:	a021                	j	80002cce <itrunc+0x22>
    80002cc8:	0491                	addi	s1,s1,4
    80002cca:	01248d63          	beq	s1,s2,80002ce4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cce:	408c                	lw	a1,0(s1)
    80002cd0:	dde5                	beqz	a1,80002cc8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cd2:	0009a503          	lw	a0,0(s3)
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	8f2080e7          	jalr	-1806(ra) # 800025c8 <bfree>
      ip->addrs[i] = 0;
    80002cde:	0004a023          	sw	zero,0(s1)
    80002ce2:	b7dd                	j	80002cc8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ce4:	0809a583          	lw	a1,128(s3)
    80002ce8:	e185                	bnez	a1,80002d08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cee:	854e                	mv	a0,s3
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	de4080e7          	jalr	-540(ra) # 80002ad4 <iupdate>
}
    80002cf8:	70a2                	ld	ra,40(sp)
    80002cfa:	7402                	ld	s0,32(sp)
    80002cfc:	64e2                	ld	s1,24(sp)
    80002cfe:	6942                	ld	s2,16(sp)
    80002d00:	69a2                	ld	s3,8(sp)
    80002d02:	6a02                	ld	s4,0(sp)
    80002d04:	6145                	addi	sp,sp,48
    80002d06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d08:	0009a503          	lw	a0,0(s3)
    80002d0c:	fffff097          	auipc	ra,0xfffff
    80002d10:	676080e7          	jalr	1654(ra) # 80002382 <bread>
    80002d14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d16:	05850493          	addi	s1,a0,88
    80002d1a:	45850913          	addi	s2,a0,1112
    80002d1e:	a021                	j	80002d26 <itrunc+0x7a>
    80002d20:	0491                	addi	s1,s1,4
    80002d22:	01248b63          	beq	s1,s2,80002d38 <itrunc+0x8c>
      if(a[j])
    80002d26:	408c                	lw	a1,0(s1)
    80002d28:	dde5                	beqz	a1,80002d20 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d2a:	0009a503          	lw	a0,0(s3)
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	89a080e7          	jalr	-1894(ra) # 800025c8 <bfree>
    80002d36:	b7ed                	j	80002d20 <itrunc+0x74>
    brelse(bp);
    80002d38:	8552                	mv	a0,s4
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	778080e7          	jalr	1912(ra) # 800024b2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d42:	0809a583          	lw	a1,128(s3)
    80002d46:	0009a503          	lw	a0,0(s3)
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	87e080e7          	jalr	-1922(ra) # 800025c8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d52:	0809a023          	sw	zero,128(s3)
    80002d56:	bf51                	j	80002cea <itrunc+0x3e>

0000000080002d58 <iput>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	e04a                	sd	s2,0(sp)
    80002d62:	1000                	addi	s0,sp,32
    80002d64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d66:	00020517          	auipc	a0,0x20
    80002d6a:	0a250513          	addi	a0,a0,162 # 80022e08 <itable>
    80002d6e:	00003097          	auipc	ra,0x3
    80002d72:	76c080e7          	jalr	1900(ra) # 800064da <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d76:	4498                	lw	a4,8(s1)
    80002d78:	4785                	li	a5,1
    80002d7a:	02f70363          	beq	a4,a5,80002da0 <iput+0x48>
  ip->ref--;
    80002d7e:	449c                	lw	a5,8(s1)
    80002d80:	37fd                	addiw	a5,a5,-1
    80002d82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d84:	00020517          	auipc	a0,0x20
    80002d88:	08450513          	addi	a0,a0,132 # 80022e08 <itable>
    80002d8c:	00004097          	auipc	ra,0x4
    80002d90:	802080e7          	jalr	-2046(ra) # 8000658e <release>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da0:	40bc                	lw	a5,64(s1)
    80002da2:	dff1                	beqz	a5,80002d7e <iput+0x26>
    80002da4:	04a49783          	lh	a5,74(s1)
    80002da8:	fbf9                	bnez	a5,80002d7e <iput+0x26>
    acquiresleep(&ip->lock);
    80002daa:	01048913          	addi	s2,s1,16
    80002dae:	854a                	mv	a0,s2
    80002db0:	00001097          	auipc	ra,0x1
    80002db4:	aac080e7          	jalr	-1364(ra) # 8000385c <acquiresleep>
    release(&itable.lock);
    80002db8:	00020517          	auipc	a0,0x20
    80002dbc:	05050513          	addi	a0,a0,80 # 80022e08 <itable>
    80002dc0:	00003097          	auipc	ra,0x3
    80002dc4:	7ce080e7          	jalr	1998(ra) # 8000658e <release>
    itrunc(ip);
    80002dc8:	8526                	mv	a0,s1
    80002dca:	00000097          	auipc	ra,0x0
    80002dce:	ee2080e7          	jalr	-286(ra) # 80002cac <itrunc>
    ip->type = 0;
    80002dd2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dd6:	8526                	mv	a0,s1
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	cfc080e7          	jalr	-772(ra) # 80002ad4 <iupdate>
    ip->valid = 0;
    80002de0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002de4:	854a                	mv	a0,s2
    80002de6:	00001097          	auipc	ra,0x1
    80002dea:	acc080e7          	jalr	-1332(ra) # 800038b2 <releasesleep>
    acquire(&itable.lock);
    80002dee:	00020517          	auipc	a0,0x20
    80002df2:	01a50513          	addi	a0,a0,26 # 80022e08 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	6e4080e7          	jalr	1764(ra) # 800064da <acquire>
    80002dfe:	b741                	j	80002d7e <iput+0x26>

0000000080002e00 <iunlockput>:
{
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	e426                	sd	s1,8(sp)
    80002e08:	1000                	addi	s0,sp,32
    80002e0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	e54080e7          	jalr	-428(ra) # 80002c60 <iunlock>
  iput(ip);
    80002e14:	8526                	mv	a0,s1
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	f42080e7          	jalr	-190(ra) # 80002d58 <iput>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e28:	1141                	addi	sp,sp,-16
    80002e2a:	e422                	sd	s0,8(sp)
    80002e2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e2e:	411c                	lw	a5,0(a0)
    80002e30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e32:	415c                	lw	a5,4(a0)
    80002e34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e36:	04451783          	lh	a5,68(a0)
    80002e3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e3e:	04a51783          	lh	a5,74(a0)
    80002e42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e46:	04c56783          	lwu	a5,76(a0)
    80002e4a:	e99c                	sd	a5,16(a1)
}
    80002e4c:	6422                	ld	s0,8(sp)
    80002e4e:	0141                	addi	sp,sp,16
    80002e50:	8082                	ret

0000000080002e52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e52:	457c                	lw	a5,76(a0)
    80002e54:	0ed7e963          	bltu	a5,a3,80002f46 <readi+0xf4>
{
    80002e58:	7159                	addi	sp,sp,-112
    80002e5a:	f486                	sd	ra,104(sp)
    80002e5c:	f0a2                	sd	s0,96(sp)
    80002e5e:	eca6                	sd	s1,88(sp)
    80002e60:	e8ca                	sd	s2,80(sp)
    80002e62:	e4ce                	sd	s3,72(sp)
    80002e64:	e0d2                	sd	s4,64(sp)
    80002e66:	fc56                	sd	s5,56(sp)
    80002e68:	f85a                	sd	s6,48(sp)
    80002e6a:	f45e                	sd	s7,40(sp)
    80002e6c:	f062                	sd	s8,32(sp)
    80002e6e:	ec66                	sd	s9,24(sp)
    80002e70:	e86a                	sd	s10,16(sp)
    80002e72:	e46e                	sd	s11,8(sp)
    80002e74:	1880                	addi	s0,sp,112
    80002e76:	8b2a                	mv	s6,a0
    80002e78:	8bae                	mv	s7,a1
    80002e7a:	8a32                	mv	s4,a2
    80002e7c:	84b6                	mv	s1,a3
    80002e7e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e80:	9f35                	addw	a4,a4,a3
    return 0;
    80002e82:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e84:	0ad76063          	bltu	a4,a3,80002f24 <readi+0xd2>
  if(off + n > ip->size)
    80002e88:	00e7f463          	bgeu	a5,a4,80002e90 <readi+0x3e>
    n = ip->size - off;
    80002e8c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e90:	0a0a8963          	beqz	s5,80002f42 <readi+0xf0>
    80002e94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e96:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e9a:	5c7d                	li	s8,-1
    80002e9c:	a82d                	j	80002ed6 <readi+0x84>
    80002e9e:	020d1d93          	slli	s11,s10,0x20
    80002ea2:	020ddd93          	srli	s11,s11,0x20
    80002ea6:	05890793          	addi	a5,s2,88
    80002eaa:	86ee                	mv	a3,s11
    80002eac:	963e                	add	a2,a2,a5
    80002eae:	85d2                	mv	a1,s4
    80002eb0:	855e                	mv	a0,s7
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	a36080e7          	jalr	-1482(ra) # 800018e8 <either_copyout>
    80002eba:	05850d63          	beq	a0,s8,80002f14 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	fffff097          	auipc	ra,0xfffff
    80002ec4:	5f2080e7          	jalr	1522(ra) # 800024b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec8:	013d09bb          	addw	s3,s10,s3
    80002ecc:	009d04bb          	addw	s1,s10,s1
    80002ed0:	9a6e                	add	s4,s4,s11
    80002ed2:	0559f763          	bgeu	s3,s5,80002f20 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ed6:	00a4d59b          	srliw	a1,s1,0xa
    80002eda:	855a                	mv	a0,s6
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	8a0080e7          	jalr	-1888(ra) # 8000277c <bmap>
    80002ee4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ee8:	cd85                	beqz	a1,80002f20 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002eea:	000b2503          	lw	a0,0(s6)
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	494080e7          	jalr	1172(ra) # 80002382 <bread>
    80002ef6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef8:	3ff4f613          	andi	a2,s1,1023
    80002efc:	40cc87bb          	subw	a5,s9,a2
    80002f00:	413a873b          	subw	a4,s5,s3
    80002f04:	8d3e                	mv	s10,a5
    80002f06:	2781                	sext.w	a5,a5
    80002f08:	0007069b          	sext.w	a3,a4
    80002f0c:	f8f6f9e3          	bgeu	a3,a5,80002e9e <readi+0x4c>
    80002f10:	8d3a                	mv	s10,a4
    80002f12:	b771                	j	80002e9e <readi+0x4c>
      brelse(bp);
    80002f14:	854a                	mv	a0,s2
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	59c080e7          	jalr	1436(ra) # 800024b2 <brelse>
      tot = -1;
    80002f1e:	59fd                	li	s3,-1
  }
  return tot;
    80002f20:	0009851b          	sext.w	a0,s3
}
    80002f24:	70a6                	ld	ra,104(sp)
    80002f26:	7406                	ld	s0,96(sp)
    80002f28:	64e6                	ld	s1,88(sp)
    80002f2a:	6946                	ld	s2,80(sp)
    80002f2c:	69a6                	ld	s3,72(sp)
    80002f2e:	6a06                	ld	s4,64(sp)
    80002f30:	7ae2                	ld	s5,56(sp)
    80002f32:	7b42                	ld	s6,48(sp)
    80002f34:	7ba2                	ld	s7,40(sp)
    80002f36:	7c02                	ld	s8,32(sp)
    80002f38:	6ce2                	ld	s9,24(sp)
    80002f3a:	6d42                	ld	s10,16(sp)
    80002f3c:	6da2                	ld	s11,8(sp)
    80002f3e:	6165                	addi	sp,sp,112
    80002f40:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f42:	89d6                	mv	s3,s5
    80002f44:	bff1                	j	80002f20 <readi+0xce>
    return 0;
    80002f46:	4501                	li	a0,0
}
    80002f48:	8082                	ret

0000000080002f4a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4a:	457c                	lw	a5,76(a0)
    80002f4c:	10d7e863          	bltu	a5,a3,8000305c <writei+0x112>
{
    80002f50:	7159                	addi	sp,sp,-112
    80002f52:	f486                	sd	ra,104(sp)
    80002f54:	f0a2                	sd	s0,96(sp)
    80002f56:	eca6                	sd	s1,88(sp)
    80002f58:	e8ca                	sd	s2,80(sp)
    80002f5a:	e4ce                	sd	s3,72(sp)
    80002f5c:	e0d2                	sd	s4,64(sp)
    80002f5e:	fc56                	sd	s5,56(sp)
    80002f60:	f85a                	sd	s6,48(sp)
    80002f62:	f45e                	sd	s7,40(sp)
    80002f64:	f062                	sd	s8,32(sp)
    80002f66:	ec66                	sd	s9,24(sp)
    80002f68:	e86a                	sd	s10,16(sp)
    80002f6a:	e46e                	sd	s11,8(sp)
    80002f6c:	1880                	addi	s0,sp,112
    80002f6e:	8aaa                	mv	s5,a0
    80002f70:	8bae                	mv	s7,a1
    80002f72:	8a32                	mv	s4,a2
    80002f74:	8936                	mv	s2,a3
    80002f76:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f78:	00e687bb          	addw	a5,a3,a4
    80002f7c:	0ed7e263          	bltu	a5,a3,80003060 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f80:	00043737          	lui	a4,0x43
    80002f84:	0ef76063          	bltu	a4,a5,80003064 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f88:	0c0b0863          	beqz	s6,80003058 <writei+0x10e>
    80002f8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f92:	5c7d                	li	s8,-1
    80002f94:	a091                	j	80002fd8 <writei+0x8e>
    80002f96:	020d1d93          	slli	s11,s10,0x20
    80002f9a:	020ddd93          	srli	s11,s11,0x20
    80002f9e:	05848793          	addi	a5,s1,88
    80002fa2:	86ee                	mv	a3,s11
    80002fa4:	8652                	mv	a2,s4
    80002fa6:	85de                	mv	a1,s7
    80002fa8:	953e                	add	a0,a0,a5
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	994080e7          	jalr	-1644(ra) # 8000193e <either_copyin>
    80002fb2:	07850263          	beq	a0,s8,80003016 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	00000097          	auipc	ra,0x0
    80002fbc:	784080e7          	jalr	1924(ra) # 8000373c <log_write>
    brelse(bp);
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	4f0080e7          	jalr	1264(ra) # 800024b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fca:	013d09bb          	addw	s3,s10,s3
    80002fce:	012d093b          	addw	s2,s10,s2
    80002fd2:	9a6e                	add	s4,s4,s11
    80002fd4:	0569f663          	bgeu	s3,s6,80003020 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002fd8:	00a9559b          	srliw	a1,s2,0xa
    80002fdc:	8556                	mv	a0,s5
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	79e080e7          	jalr	1950(ra) # 8000277c <bmap>
    80002fe6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fea:	c99d                	beqz	a1,80003020 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002fec:	000aa503          	lw	a0,0(s5)
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	392080e7          	jalr	914(ra) # 80002382 <bread>
    80002ff8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffa:	3ff97513          	andi	a0,s2,1023
    80002ffe:	40ac87bb          	subw	a5,s9,a0
    80003002:	413b073b          	subw	a4,s6,s3
    80003006:	8d3e                	mv	s10,a5
    80003008:	2781                	sext.w	a5,a5
    8000300a:	0007069b          	sext.w	a3,a4
    8000300e:	f8f6f4e3          	bgeu	a3,a5,80002f96 <writei+0x4c>
    80003012:	8d3a                	mv	s10,a4
    80003014:	b749                	j	80002f96 <writei+0x4c>
      brelse(bp);
    80003016:	8526                	mv	a0,s1
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	49a080e7          	jalr	1178(ra) # 800024b2 <brelse>
  }

  if(off > ip->size)
    80003020:	04caa783          	lw	a5,76(s5)
    80003024:	0127f463          	bgeu	a5,s2,8000302c <writei+0xe2>
    ip->size = off;
    80003028:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000302c:	8556                	mv	a0,s5
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	aa6080e7          	jalr	-1370(ra) # 80002ad4 <iupdate>

  return tot;
    80003036:	0009851b          	sext.w	a0,s3
}
    8000303a:	70a6                	ld	ra,104(sp)
    8000303c:	7406                	ld	s0,96(sp)
    8000303e:	64e6                	ld	s1,88(sp)
    80003040:	6946                	ld	s2,80(sp)
    80003042:	69a6                	ld	s3,72(sp)
    80003044:	6a06                	ld	s4,64(sp)
    80003046:	7ae2                	ld	s5,56(sp)
    80003048:	7b42                	ld	s6,48(sp)
    8000304a:	7ba2                	ld	s7,40(sp)
    8000304c:	7c02                	ld	s8,32(sp)
    8000304e:	6ce2                	ld	s9,24(sp)
    80003050:	6d42                	ld	s10,16(sp)
    80003052:	6da2                	ld	s11,8(sp)
    80003054:	6165                	addi	sp,sp,112
    80003056:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003058:	89da                	mv	s3,s6
    8000305a:	bfc9                	j	8000302c <writei+0xe2>
    return -1;
    8000305c:	557d                	li	a0,-1
}
    8000305e:	8082                	ret
    return -1;
    80003060:	557d                	li	a0,-1
    80003062:	bfe1                	j	8000303a <writei+0xf0>
    return -1;
    80003064:	557d                	li	a0,-1
    80003066:	bfd1                	j	8000303a <writei+0xf0>

0000000080003068 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003068:	1141                	addi	sp,sp,-16
    8000306a:	e406                	sd	ra,8(sp)
    8000306c:	e022                	sd	s0,0(sp)
    8000306e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003070:	4639                	li	a2,14
    80003072:	ffffd097          	auipc	ra,0xffffd
    80003076:	1d6080e7          	jalr	470(ra) # 80000248 <strncmp>
}
    8000307a:	60a2                	ld	ra,8(sp)
    8000307c:	6402                	ld	s0,0(sp)
    8000307e:	0141                	addi	sp,sp,16
    80003080:	8082                	ret

0000000080003082 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003082:	7139                	addi	sp,sp,-64
    80003084:	fc06                	sd	ra,56(sp)
    80003086:	f822                	sd	s0,48(sp)
    80003088:	f426                	sd	s1,40(sp)
    8000308a:	f04a                	sd	s2,32(sp)
    8000308c:	ec4e                	sd	s3,24(sp)
    8000308e:	e852                	sd	s4,16(sp)
    80003090:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003092:	04451703          	lh	a4,68(a0)
    80003096:	4785                	li	a5,1
    80003098:	00f71a63          	bne	a4,a5,800030ac <dirlookup+0x2a>
    8000309c:	892a                	mv	s2,a0
    8000309e:	89ae                	mv	s3,a1
    800030a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a2:	457c                	lw	a5,76(a0)
    800030a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a8:	e79d                	bnez	a5,800030d6 <dirlookup+0x54>
    800030aa:	a8a5                	j	80003122 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ac:	00005517          	auipc	a0,0x5
    800030b0:	49c50513          	addi	a0,a0,1180 # 80008548 <syscalls+0x1b0>
    800030b4:	00003097          	auipc	ra,0x3
    800030b8:	eea080e7          	jalr	-278(ra) # 80005f9e <panic>
      panic("dirlookup read");
    800030bc:	00005517          	auipc	a0,0x5
    800030c0:	4a450513          	addi	a0,a0,1188 # 80008560 <syscalls+0x1c8>
    800030c4:	00003097          	auipc	ra,0x3
    800030c8:	eda080e7          	jalr	-294(ra) # 80005f9e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030cc:	24c1                	addiw	s1,s1,16
    800030ce:	04c92783          	lw	a5,76(s2)
    800030d2:	04f4f763          	bgeu	s1,a5,80003120 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030d6:	4741                	li	a4,16
    800030d8:	86a6                	mv	a3,s1
    800030da:	fc040613          	addi	a2,s0,-64
    800030de:	4581                	li	a1,0
    800030e0:	854a                	mv	a0,s2
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	d70080e7          	jalr	-656(ra) # 80002e52 <readi>
    800030ea:	47c1                	li	a5,16
    800030ec:	fcf518e3          	bne	a0,a5,800030bc <dirlookup+0x3a>
    if(de.inum == 0)
    800030f0:	fc045783          	lhu	a5,-64(s0)
    800030f4:	dfe1                	beqz	a5,800030cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030f6:	fc240593          	addi	a1,s0,-62
    800030fa:	854e                	mv	a0,s3
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	f6c080e7          	jalr	-148(ra) # 80003068 <namecmp>
    80003104:	f561                	bnez	a0,800030cc <dirlookup+0x4a>
      if(poff)
    80003106:	000a0463          	beqz	s4,8000310e <dirlookup+0x8c>
        *poff = off;
    8000310a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000310e:	fc045583          	lhu	a1,-64(s0)
    80003112:	00092503          	lw	a0,0(s2)
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	750080e7          	jalr	1872(ra) # 80002866 <iget>
    8000311e:	a011                	j	80003122 <dirlookup+0xa0>
  return 0;
    80003120:	4501                	li	a0,0
}
    80003122:	70e2                	ld	ra,56(sp)
    80003124:	7442                	ld	s0,48(sp)
    80003126:	74a2                	ld	s1,40(sp)
    80003128:	7902                	ld	s2,32(sp)
    8000312a:	69e2                	ld	s3,24(sp)
    8000312c:	6a42                	ld	s4,16(sp)
    8000312e:	6121                	addi	sp,sp,64
    80003130:	8082                	ret

0000000080003132 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003132:	711d                	addi	sp,sp,-96
    80003134:	ec86                	sd	ra,88(sp)
    80003136:	e8a2                	sd	s0,80(sp)
    80003138:	e4a6                	sd	s1,72(sp)
    8000313a:	e0ca                	sd	s2,64(sp)
    8000313c:	fc4e                	sd	s3,56(sp)
    8000313e:	f852                	sd	s4,48(sp)
    80003140:	f456                	sd	s5,40(sp)
    80003142:	f05a                	sd	s6,32(sp)
    80003144:	ec5e                	sd	s7,24(sp)
    80003146:	e862                	sd	s8,16(sp)
    80003148:	e466                	sd	s9,8(sp)
    8000314a:	1080                	addi	s0,sp,96
    8000314c:	84aa                	mv	s1,a0
    8000314e:	8aae                	mv	s5,a1
    80003150:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003152:	00054703          	lbu	a4,0(a0)
    80003156:	02f00793          	li	a5,47
    8000315a:	02f70363          	beq	a4,a5,80003180 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000315e:	ffffe097          	auipc	ra,0xffffe
    80003162:	cda080e7          	jalr	-806(ra) # 80000e38 <myproc>
    80003166:	15053503          	ld	a0,336(a0)
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	9f6080e7          	jalr	-1546(ra) # 80002b60 <idup>
    80003172:	89aa                	mv	s3,a0
  while(*path == '/')
    80003174:	02f00913          	li	s2,47
  len = path - s;
    80003178:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000317a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000317c:	4b85                	li	s7,1
    8000317e:	a865                	j	80003236 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003180:	4585                	li	a1,1
    80003182:	4505                	li	a0,1
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	6e2080e7          	jalr	1762(ra) # 80002866 <iget>
    8000318c:	89aa                	mv	s3,a0
    8000318e:	b7dd                	j	80003174 <namex+0x42>
      iunlockput(ip);
    80003190:	854e                	mv	a0,s3
    80003192:	00000097          	auipc	ra,0x0
    80003196:	c6e080e7          	jalr	-914(ra) # 80002e00 <iunlockput>
      return 0;
    8000319a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000319c:	854e                	mv	a0,s3
    8000319e:	60e6                	ld	ra,88(sp)
    800031a0:	6446                	ld	s0,80(sp)
    800031a2:	64a6                	ld	s1,72(sp)
    800031a4:	6906                	ld	s2,64(sp)
    800031a6:	79e2                	ld	s3,56(sp)
    800031a8:	7a42                	ld	s4,48(sp)
    800031aa:	7aa2                	ld	s5,40(sp)
    800031ac:	7b02                	ld	s6,32(sp)
    800031ae:	6be2                	ld	s7,24(sp)
    800031b0:	6c42                	ld	s8,16(sp)
    800031b2:	6ca2                	ld	s9,8(sp)
    800031b4:	6125                	addi	sp,sp,96
    800031b6:	8082                	ret
      iunlock(ip);
    800031b8:	854e                	mv	a0,s3
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	aa6080e7          	jalr	-1370(ra) # 80002c60 <iunlock>
      return ip;
    800031c2:	bfe9                	j	8000319c <namex+0x6a>
      iunlockput(ip);
    800031c4:	854e                	mv	a0,s3
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	c3a080e7          	jalr	-966(ra) # 80002e00 <iunlockput>
      return 0;
    800031ce:	89e6                	mv	s3,s9
    800031d0:	b7f1                	j	8000319c <namex+0x6a>
  len = path - s;
    800031d2:	40b48633          	sub	a2,s1,a1
    800031d6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031da:	099c5463          	bge	s8,s9,80003262 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031de:	4639                	li	a2,14
    800031e0:	8552                	mv	a0,s4
    800031e2:	ffffd097          	auipc	ra,0xffffd
    800031e6:	ff2080e7          	jalr	-14(ra) # 800001d4 <memmove>
  while(*path == '/')
    800031ea:	0004c783          	lbu	a5,0(s1)
    800031ee:	01279763          	bne	a5,s2,800031fc <namex+0xca>
    path++;
    800031f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	ff278de3          	beq	a5,s2,800031f2 <namex+0xc0>
    ilock(ip);
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	9a0080e7          	jalr	-1632(ra) # 80002b9e <ilock>
    if(ip->type != T_DIR){
    80003206:	04499783          	lh	a5,68(s3)
    8000320a:	f97793e3          	bne	a5,s7,80003190 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000320e:	000a8563          	beqz	s5,80003218 <namex+0xe6>
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	d3cd                	beqz	a5,800031b8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003218:	865a                	mv	a2,s6
    8000321a:	85d2                	mv	a1,s4
    8000321c:	854e                	mv	a0,s3
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	e64080e7          	jalr	-412(ra) # 80003082 <dirlookup>
    80003226:	8caa                	mv	s9,a0
    80003228:	dd51                	beqz	a0,800031c4 <namex+0x92>
    iunlockput(ip);
    8000322a:	854e                	mv	a0,s3
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	bd4080e7          	jalr	-1068(ra) # 80002e00 <iunlockput>
    ip = next;
    80003234:	89e6                	mv	s3,s9
  while(*path == '/')
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	05279763          	bne	a5,s2,80003288 <namex+0x156>
    path++;
    8000323e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	ff278de3          	beq	a5,s2,8000323e <namex+0x10c>
  if(*path == 0)
    80003248:	c79d                	beqz	a5,80003276 <namex+0x144>
    path++;
    8000324a:	85a6                	mv	a1,s1
  len = path - s;
    8000324c:	8cda                	mv	s9,s6
    8000324e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003250:	01278963          	beq	a5,s2,80003262 <namex+0x130>
    80003254:	dfbd                	beqz	a5,800031d2 <namex+0xa0>
    path++;
    80003256:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003258:	0004c783          	lbu	a5,0(s1)
    8000325c:	ff279ce3          	bne	a5,s2,80003254 <namex+0x122>
    80003260:	bf8d                	j	800031d2 <namex+0xa0>
    memmove(name, s, len);
    80003262:	2601                	sext.w	a2,a2
    80003264:	8552                	mv	a0,s4
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	f6e080e7          	jalr	-146(ra) # 800001d4 <memmove>
    name[len] = 0;
    8000326e:	9cd2                	add	s9,s9,s4
    80003270:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003274:	bf9d                	j	800031ea <namex+0xb8>
  if(nameiparent){
    80003276:	f20a83e3          	beqz	s5,8000319c <namex+0x6a>
    iput(ip);
    8000327a:	854e                	mv	a0,s3
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	adc080e7          	jalr	-1316(ra) # 80002d58 <iput>
    return 0;
    80003284:	4981                	li	s3,0
    80003286:	bf19                	j	8000319c <namex+0x6a>
  if(*path == 0)
    80003288:	d7fd                	beqz	a5,80003276 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	85a6                	mv	a1,s1
    80003290:	b7d1                	j	80003254 <namex+0x122>

0000000080003292 <dirlink>:
{
    80003292:	7139                	addi	sp,sp,-64
    80003294:	fc06                	sd	ra,56(sp)
    80003296:	f822                	sd	s0,48(sp)
    80003298:	f426                	sd	s1,40(sp)
    8000329a:	f04a                	sd	s2,32(sp)
    8000329c:	ec4e                	sd	s3,24(sp)
    8000329e:	e852                	sd	s4,16(sp)
    800032a0:	0080                	addi	s0,sp,64
    800032a2:	892a                	mv	s2,a0
    800032a4:	8a2e                	mv	s4,a1
    800032a6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032a8:	4601                	li	a2,0
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	dd8080e7          	jalr	-552(ra) # 80003082 <dirlookup>
    800032b2:	e93d                	bnez	a0,80003328 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b4:	04c92483          	lw	s1,76(s2)
    800032b8:	c49d                	beqz	s1,800032e6 <dirlink+0x54>
    800032ba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032bc:	4741                	li	a4,16
    800032be:	86a6                	mv	a3,s1
    800032c0:	fc040613          	addi	a2,s0,-64
    800032c4:	4581                	li	a1,0
    800032c6:	854a                	mv	a0,s2
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	b8a080e7          	jalr	-1142(ra) # 80002e52 <readi>
    800032d0:	47c1                	li	a5,16
    800032d2:	06f51163          	bne	a0,a5,80003334 <dirlink+0xa2>
    if(de.inum == 0)
    800032d6:	fc045783          	lhu	a5,-64(s0)
    800032da:	c791                	beqz	a5,800032e6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032dc:	24c1                	addiw	s1,s1,16
    800032de:	04c92783          	lw	a5,76(s2)
    800032e2:	fcf4ede3          	bltu	s1,a5,800032bc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032e6:	4639                	li	a2,14
    800032e8:	85d2                	mv	a1,s4
    800032ea:	fc240513          	addi	a0,s0,-62
    800032ee:	ffffd097          	auipc	ra,0xffffd
    800032f2:	f96080e7          	jalr	-106(ra) # 80000284 <strncpy>
  de.inum = inum;
    800032f6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032fa:	4741                	li	a4,16
    800032fc:	86a6                	mv	a3,s1
    800032fe:	fc040613          	addi	a2,s0,-64
    80003302:	4581                	li	a1,0
    80003304:	854a                	mv	a0,s2
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	c44080e7          	jalr	-956(ra) # 80002f4a <writei>
    8000330e:	1541                	addi	a0,a0,-16
    80003310:	00a03533          	snez	a0,a0
    80003314:	40a00533          	neg	a0,a0
}
    80003318:	70e2                	ld	ra,56(sp)
    8000331a:	7442                	ld	s0,48(sp)
    8000331c:	74a2                	ld	s1,40(sp)
    8000331e:	7902                	ld	s2,32(sp)
    80003320:	69e2                	ld	s3,24(sp)
    80003322:	6a42                	ld	s4,16(sp)
    80003324:	6121                	addi	sp,sp,64
    80003326:	8082                	ret
    iput(ip);
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	a30080e7          	jalr	-1488(ra) # 80002d58 <iput>
    return -1;
    80003330:	557d                	li	a0,-1
    80003332:	b7dd                	j	80003318 <dirlink+0x86>
      panic("dirlink read");
    80003334:	00005517          	auipc	a0,0x5
    80003338:	23c50513          	addi	a0,a0,572 # 80008570 <syscalls+0x1d8>
    8000333c:	00003097          	auipc	ra,0x3
    80003340:	c62080e7          	jalr	-926(ra) # 80005f9e <panic>

0000000080003344 <namei>:

struct inode*
namei(char *path)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000334c:	fe040613          	addi	a2,s0,-32
    80003350:	4581                	li	a1,0
    80003352:	00000097          	auipc	ra,0x0
    80003356:	de0080e7          	jalr	-544(ra) # 80003132 <namex>
}
    8000335a:	60e2                	ld	ra,24(sp)
    8000335c:	6442                	ld	s0,16(sp)
    8000335e:	6105                	addi	sp,sp,32
    80003360:	8082                	ret

0000000080003362 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003362:	1141                	addi	sp,sp,-16
    80003364:	e406                	sd	ra,8(sp)
    80003366:	e022                	sd	s0,0(sp)
    80003368:	0800                	addi	s0,sp,16
    8000336a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000336c:	4585                	li	a1,1
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	dc4080e7          	jalr	-572(ra) # 80003132 <namex>
}
    80003376:	60a2                	ld	ra,8(sp)
    80003378:	6402                	ld	s0,0(sp)
    8000337a:	0141                	addi	sp,sp,16
    8000337c:	8082                	ret

000000008000337e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	e04a                	sd	s2,0(sp)
    80003388:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000338a:	00021917          	auipc	s2,0x21
    8000338e:	52690913          	addi	s2,s2,1318 # 800248b0 <log>
    80003392:	01892583          	lw	a1,24(s2)
    80003396:	02892503          	lw	a0,40(s2)
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	fe8080e7          	jalr	-24(ra) # 80002382 <bread>
    800033a2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033a4:	02c92683          	lw	a3,44(s2)
    800033a8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033aa:	02d05863          	blez	a3,800033da <write_head+0x5c>
    800033ae:	00021797          	auipc	a5,0x21
    800033b2:	53278793          	addi	a5,a5,1330 # 800248e0 <log+0x30>
    800033b6:	05c50713          	addi	a4,a0,92
    800033ba:	36fd                	addiw	a3,a3,-1
    800033bc:	02069613          	slli	a2,a3,0x20
    800033c0:	01e65693          	srli	a3,a2,0x1e
    800033c4:	00021617          	auipc	a2,0x21
    800033c8:	52060613          	addi	a2,a2,1312 # 800248e4 <log+0x34>
    800033cc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033ce:	4390                	lw	a2,0(a5)
    800033d0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033d2:	0791                	addi	a5,a5,4
    800033d4:	0711                	addi	a4,a4,4
    800033d6:	fed79ce3          	bne	a5,a3,800033ce <write_head+0x50>
  }
  bwrite(buf);
    800033da:	8526                	mv	a0,s1
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	098080e7          	jalr	152(ra) # 80002474 <bwrite>
  brelse(buf);
    800033e4:	8526                	mv	a0,s1
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	0cc080e7          	jalr	204(ra) # 800024b2 <brelse>
}
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	64a2                	ld	s1,8(sp)
    800033f4:	6902                	ld	s2,0(sp)
    800033f6:	6105                	addi	sp,sp,32
    800033f8:	8082                	ret

00000000800033fa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033fa:	00021797          	auipc	a5,0x21
    800033fe:	4e27a783          	lw	a5,1250(a5) # 800248dc <log+0x2c>
    80003402:	0af05d63          	blez	a5,800034bc <install_trans+0xc2>
{
    80003406:	7139                	addi	sp,sp,-64
    80003408:	fc06                	sd	ra,56(sp)
    8000340a:	f822                	sd	s0,48(sp)
    8000340c:	f426                	sd	s1,40(sp)
    8000340e:	f04a                	sd	s2,32(sp)
    80003410:	ec4e                	sd	s3,24(sp)
    80003412:	e852                	sd	s4,16(sp)
    80003414:	e456                	sd	s5,8(sp)
    80003416:	e05a                	sd	s6,0(sp)
    80003418:	0080                	addi	s0,sp,64
    8000341a:	8b2a                	mv	s6,a0
    8000341c:	00021a97          	auipc	s5,0x21
    80003420:	4c4a8a93          	addi	s5,s5,1220 # 800248e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003424:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003426:	00021997          	auipc	s3,0x21
    8000342a:	48a98993          	addi	s3,s3,1162 # 800248b0 <log>
    8000342e:	a00d                	j	80003450 <install_trans+0x56>
    brelse(lbuf);
    80003430:	854a                	mv	a0,s2
    80003432:	fffff097          	auipc	ra,0xfffff
    80003436:	080080e7          	jalr	128(ra) # 800024b2 <brelse>
    brelse(dbuf);
    8000343a:	8526                	mv	a0,s1
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	076080e7          	jalr	118(ra) # 800024b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003444:	2a05                	addiw	s4,s4,1
    80003446:	0a91                	addi	s5,s5,4
    80003448:	02c9a783          	lw	a5,44(s3)
    8000344c:	04fa5e63          	bge	s4,a5,800034a8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003450:	0189a583          	lw	a1,24(s3)
    80003454:	014585bb          	addw	a1,a1,s4
    80003458:	2585                	addiw	a1,a1,1
    8000345a:	0289a503          	lw	a0,40(s3)
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	f24080e7          	jalr	-220(ra) # 80002382 <bread>
    80003466:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003468:	000aa583          	lw	a1,0(s5)
    8000346c:	0289a503          	lw	a0,40(s3)
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	f12080e7          	jalr	-238(ra) # 80002382 <bread>
    80003478:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000347a:	40000613          	li	a2,1024
    8000347e:	05890593          	addi	a1,s2,88
    80003482:	05850513          	addi	a0,a0,88
    80003486:	ffffd097          	auipc	ra,0xffffd
    8000348a:	d4e080e7          	jalr	-690(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000348e:	8526                	mv	a0,s1
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	fe4080e7          	jalr	-28(ra) # 80002474 <bwrite>
    if(recovering == 0)
    80003498:	f80b1ce3          	bnez	s6,80003430 <install_trans+0x36>
      bunpin(dbuf);
    8000349c:	8526                	mv	a0,s1
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	0ee080e7          	jalr	238(ra) # 8000258c <bunpin>
    800034a6:	b769                	j	80003430 <install_trans+0x36>
}
    800034a8:	70e2                	ld	ra,56(sp)
    800034aa:	7442                	ld	s0,48(sp)
    800034ac:	74a2                	ld	s1,40(sp)
    800034ae:	7902                	ld	s2,32(sp)
    800034b0:	69e2                	ld	s3,24(sp)
    800034b2:	6a42                	ld	s4,16(sp)
    800034b4:	6aa2                	ld	s5,8(sp)
    800034b6:	6b02                	ld	s6,0(sp)
    800034b8:	6121                	addi	sp,sp,64
    800034ba:	8082                	ret
    800034bc:	8082                	ret

00000000800034be <initlog>:
{
    800034be:	7179                	addi	sp,sp,-48
    800034c0:	f406                	sd	ra,40(sp)
    800034c2:	f022                	sd	s0,32(sp)
    800034c4:	ec26                	sd	s1,24(sp)
    800034c6:	e84a                	sd	s2,16(sp)
    800034c8:	e44e                	sd	s3,8(sp)
    800034ca:	1800                	addi	s0,sp,48
    800034cc:	892a                	mv	s2,a0
    800034ce:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034d0:	00021497          	auipc	s1,0x21
    800034d4:	3e048493          	addi	s1,s1,992 # 800248b0 <log>
    800034d8:	00005597          	auipc	a1,0x5
    800034dc:	0a858593          	addi	a1,a1,168 # 80008580 <syscalls+0x1e8>
    800034e0:	8526                	mv	a0,s1
    800034e2:	00003097          	auipc	ra,0x3
    800034e6:	f68080e7          	jalr	-152(ra) # 8000644a <initlock>
  log.start = sb->logstart;
    800034ea:	0149a583          	lw	a1,20(s3)
    800034ee:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034f0:	0109a783          	lw	a5,16(s3)
    800034f4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034f6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034fa:	854a                	mv	a0,s2
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	e86080e7          	jalr	-378(ra) # 80002382 <bread>
  log.lh.n = lh->n;
    80003504:	4d34                	lw	a3,88(a0)
    80003506:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003508:	02d05663          	blez	a3,80003534 <initlog+0x76>
    8000350c:	05c50793          	addi	a5,a0,92
    80003510:	00021717          	auipc	a4,0x21
    80003514:	3d070713          	addi	a4,a4,976 # 800248e0 <log+0x30>
    80003518:	36fd                	addiw	a3,a3,-1
    8000351a:	02069613          	slli	a2,a3,0x20
    8000351e:	01e65693          	srli	a3,a2,0x1e
    80003522:	06050613          	addi	a2,a0,96
    80003526:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003528:	4390                	lw	a2,0(a5)
    8000352a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000352c:	0791                	addi	a5,a5,4
    8000352e:	0711                	addi	a4,a4,4
    80003530:	fed79ce3          	bne	a5,a3,80003528 <initlog+0x6a>
  brelse(buf);
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	f7e080e7          	jalr	-130(ra) # 800024b2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000353c:	4505                	li	a0,1
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	ebc080e7          	jalr	-324(ra) # 800033fa <install_trans>
  log.lh.n = 0;
    80003546:	00021797          	auipc	a5,0x21
    8000354a:	3807ab23          	sw	zero,918(a5) # 800248dc <log+0x2c>
  write_head(); // clear the log
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	e30080e7          	jalr	-464(ra) # 8000337e <write_head>
}
    80003556:	70a2                	ld	ra,40(sp)
    80003558:	7402                	ld	s0,32(sp)
    8000355a:	64e2                	ld	s1,24(sp)
    8000355c:	6942                	ld	s2,16(sp)
    8000355e:	69a2                	ld	s3,8(sp)
    80003560:	6145                	addi	sp,sp,48
    80003562:	8082                	ret

0000000080003564 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003564:	1101                	addi	sp,sp,-32
    80003566:	ec06                	sd	ra,24(sp)
    80003568:	e822                	sd	s0,16(sp)
    8000356a:	e426                	sd	s1,8(sp)
    8000356c:	e04a                	sd	s2,0(sp)
    8000356e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003570:	00021517          	auipc	a0,0x21
    80003574:	34050513          	addi	a0,a0,832 # 800248b0 <log>
    80003578:	00003097          	auipc	ra,0x3
    8000357c:	f62080e7          	jalr	-158(ra) # 800064da <acquire>
  while(1){
    if(log.committing){
    80003580:	00021497          	auipc	s1,0x21
    80003584:	33048493          	addi	s1,s1,816 # 800248b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003588:	4979                	li	s2,30
    8000358a:	a039                	j	80003598 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000358c:	85a6                	mv	a1,s1
    8000358e:	8526                	mv	a0,s1
    80003590:	ffffe097          	auipc	ra,0xffffe
    80003594:	f50080e7          	jalr	-176(ra) # 800014e0 <sleep>
    if(log.committing){
    80003598:	50dc                	lw	a5,36(s1)
    8000359a:	fbed                	bnez	a5,8000358c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359c:	509c                	lw	a5,32(s1)
    8000359e:	0017871b          	addiw	a4,a5,1
    800035a2:	0007069b          	sext.w	a3,a4
    800035a6:	0027179b          	slliw	a5,a4,0x2
    800035aa:	9fb9                	addw	a5,a5,a4
    800035ac:	0017979b          	slliw	a5,a5,0x1
    800035b0:	54d8                	lw	a4,44(s1)
    800035b2:	9fb9                	addw	a5,a5,a4
    800035b4:	00f95963          	bge	s2,a5,800035c6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035b8:	85a6                	mv	a1,s1
    800035ba:	8526                	mv	a0,s1
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	f24080e7          	jalr	-220(ra) # 800014e0 <sleep>
    800035c4:	bfd1                	j	80003598 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035c6:	00021517          	auipc	a0,0x21
    800035ca:	2ea50513          	addi	a0,a0,746 # 800248b0 <log>
    800035ce:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	fbe080e7          	jalr	-66(ra) # 8000658e <release>
      break;
    }
  }
}
    800035d8:	60e2                	ld	ra,24(sp)
    800035da:	6442                	ld	s0,16(sp)
    800035dc:	64a2                	ld	s1,8(sp)
    800035de:	6902                	ld	s2,0(sp)
    800035e0:	6105                	addi	sp,sp,32
    800035e2:	8082                	ret

00000000800035e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e4:	7139                	addi	sp,sp,-64
    800035e6:	fc06                	sd	ra,56(sp)
    800035e8:	f822                	sd	s0,48(sp)
    800035ea:	f426                	sd	s1,40(sp)
    800035ec:	f04a                	sd	s2,32(sp)
    800035ee:	ec4e                	sd	s3,24(sp)
    800035f0:	e852                	sd	s4,16(sp)
    800035f2:	e456                	sd	s5,8(sp)
    800035f4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035f6:	00021497          	auipc	s1,0x21
    800035fa:	2ba48493          	addi	s1,s1,698 # 800248b0 <log>
    800035fe:	8526                	mv	a0,s1
    80003600:	00003097          	auipc	ra,0x3
    80003604:	eda080e7          	jalr	-294(ra) # 800064da <acquire>
  log.outstanding -= 1;
    80003608:	509c                	lw	a5,32(s1)
    8000360a:	37fd                	addiw	a5,a5,-1
    8000360c:	0007891b          	sext.w	s2,a5
    80003610:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003612:	50dc                	lw	a5,36(s1)
    80003614:	e7b9                	bnez	a5,80003662 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003616:	04091e63          	bnez	s2,80003672 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000361a:	00021497          	auipc	s1,0x21
    8000361e:	29648493          	addi	s1,s1,662 # 800248b0 <log>
    80003622:	4785                	li	a5,1
    80003624:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	f66080e7          	jalr	-154(ra) # 8000658e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003630:	54dc                	lw	a5,44(s1)
    80003632:	06f04763          	bgtz	a5,800036a0 <end_op+0xbc>
    acquire(&log.lock);
    80003636:	00021497          	auipc	s1,0x21
    8000363a:	27a48493          	addi	s1,s1,634 # 800248b0 <log>
    8000363e:	8526                	mv	a0,s1
    80003640:	00003097          	auipc	ra,0x3
    80003644:	e9a080e7          	jalr	-358(ra) # 800064da <acquire>
    log.committing = 0;
    80003648:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000364c:	8526                	mv	a0,s1
    8000364e:	ffffe097          	auipc	ra,0xffffe
    80003652:	ef6080e7          	jalr	-266(ra) # 80001544 <wakeup>
    release(&log.lock);
    80003656:	8526                	mv	a0,s1
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	f36080e7          	jalr	-202(ra) # 8000658e <release>
}
    80003660:	a03d                	j	8000368e <end_op+0xaa>
    panic("log.committing");
    80003662:	00005517          	auipc	a0,0x5
    80003666:	f2650513          	addi	a0,a0,-218 # 80008588 <syscalls+0x1f0>
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	934080e7          	jalr	-1740(ra) # 80005f9e <panic>
    wakeup(&log);
    80003672:	00021497          	auipc	s1,0x21
    80003676:	23e48493          	addi	s1,s1,574 # 800248b0 <log>
    8000367a:	8526                	mv	a0,s1
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	ec8080e7          	jalr	-312(ra) # 80001544 <wakeup>
  release(&log.lock);
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	f08080e7          	jalr	-248(ra) # 8000658e <release>
}
    8000368e:	70e2                	ld	ra,56(sp)
    80003690:	7442                	ld	s0,48(sp)
    80003692:	74a2                	ld	s1,40(sp)
    80003694:	7902                	ld	s2,32(sp)
    80003696:	69e2                	ld	s3,24(sp)
    80003698:	6a42                	ld	s4,16(sp)
    8000369a:	6aa2                	ld	s5,8(sp)
    8000369c:	6121                	addi	sp,sp,64
    8000369e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a0:	00021a97          	auipc	s5,0x21
    800036a4:	240a8a93          	addi	s5,s5,576 # 800248e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036a8:	00021a17          	auipc	s4,0x21
    800036ac:	208a0a13          	addi	s4,s4,520 # 800248b0 <log>
    800036b0:	018a2583          	lw	a1,24(s4)
    800036b4:	012585bb          	addw	a1,a1,s2
    800036b8:	2585                	addiw	a1,a1,1
    800036ba:	028a2503          	lw	a0,40(s4)
    800036be:	fffff097          	auipc	ra,0xfffff
    800036c2:	cc4080e7          	jalr	-828(ra) # 80002382 <bread>
    800036c6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036c8:	000aa583          	lw	a1,0(s5)
    800036cc:	028a2503          	lw	a0,40(s4)
    800036d0:	fffff097          	auipc	ra,0xfffff
    800036d4:	cb2080e7          	jalr	-846(ra) # 80002382 <bread>
    800036d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036da:	40000613          	li	a2,1024
    800036de:	05850593          	addi	a1,a0,88
    800036e2:	05848513          	addi	a0,s1,88
    800036e6:	ffffd097          	auipc	ra,0xffffd
    800036ea:	aee080e7          	jalr	-1298(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    800036ee:	8526                	mv	a0,s1
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	d84080e7          	jalr	-636(ra) # 80002474 <bwrite>
    brelse(from);
    800036f8:	854e                	mv	a0,s3
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	db8080e7          	jalr	-584(ra) # 800024b2 <brelse>
    brelse(to);
    80003702:	8526                	mv	a0,s1
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	dae080e7          	jalr	-594(ra) # 800024b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	2905                	addiw	s2,s2,1
    8000370e:	0a91                	addi	s5,s5,4
    80003710:	02ca2783          	lw	a5,44(s4)
    80003714:	f8f94ee3          	blt	s2,a5,800036b0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	c66080e7          	jalr	-922(ra) # 8000337e <write_head>
    install_trans(0); // Now install writes to home locations
    80003720:	4501                	li	a0,0
    80003722:	00000097          	auipc	ra,0x0
    80003726:	cd8080e7          	jalr	-808(ra) # 800033fa <install_trans>
    log.lh.n = 0;
    8000372a:	00021797          	auipc	a5,0x21
    8000372e:	1a07a923          	sw	zero,434(a5) # 800248dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003732:	00000097          	auipc	ra,0x0
    80003736:	c4c080e7          	jalr	-948(ra) # 8000337e <write_head>
    8000373a:	bdf5                	j	80003636 <end_op+0x52>

000000008000373c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
    80003748:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000374a:	00021917          	auipc	s2,0x21
    8000374e:	16690913          	addi	s2,s2,358 # 800248b0 <log>
    80003752:	854a                	mv	a0,s2
    80003754:	00003097          	auipc	ra,0x3
    80003758:	d86080e7          	jalr	-634(ra) # 800064da <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000375c:	02c92603          	lw	a2,44(s2)
    80003760:	47f5                	li	a5,29
    80003762:	06c7c563          	blt	a5,a2,800037cc <log_write+0x90>
    80003766:	00021797          	auipc	a5,0x21
    8000376a:	1667a783          	lw	a5,358(a5) # 800248cc <log+0x1c>
    8000376e:	37fd                	addiw	a5,a5,-1
    80003770:	04f65e63          	bge	a2,a5,800037cc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003774:	00021797          	auipc	a5,0x21
    80003778:	15c7a783          	lw	a5,348(a5) # 800248d0 <log+0x20>
    8000377c:	06f05063          	blez	a5,800037dc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003780:	4781                	li	a5,0
    80003782:	06c05563          	blez	a2,800037ec <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003786:	44cc                	lw	a1,12(s1)
    80003788:	00021717          	auipc	a4,0x21
    8000378c:	15870713          	addi	a4,a4,344 # 800248e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003790:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003792:	4314                	lw	a3,0(a4)
    80003794:	04b68c63          	beq	a3,a1,800037ec <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003798:	2785                	addiw	a5,a5,1
    8000379a:	0711                	addi	a4,a4,4
    8000379c:	fef61be3          	bne	a2,a5,80003792 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037a0:	0621                	addi	a2,a2,8
    800037a2:	060a                	slli	a2,a2,0x2
    800037a4:	00021797          	auipc	a5,0x21
    800037a8:	10c78793          	addi	a5,a5,268 # 800248b0 <log>
    800037ac:	963e                	add	a2,a2,a5
    800037ae:	44dc                	lw	a5,12(s1)
    800037b0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037b2:	8526                	mv	a0,s1
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	d9c080e7          	jalr	-612(ra) # 80002550 <bpin>
    log.lh.n++;
    800037bc:	00021717          	auipc	a4,0x21
    800037c0:	0f470713          	addi	a4,a4,244 # 800248b0 <log>
    800037c4:	575c                	lw	a5,44(a4)
    800037c6:	2785                	addiw	a5,a5,1
    800037c8:	d75c                	sw	a5,44(a4)
    800037ca:	a835                	j	80003806 <log_write+0xca>
    panic("too big a transaction");
    800037cc:	00005517          	auipc	a0,0x5
    800037d0:	dcc50513          	addi	a0,a0,-564 # 80008598 <syscalls+0x200>
    800037d4:	00002097          	auipc	ra,0x2
    800037d8:	7ca080e7          	jalr	1994(ra) # 80005f9e <panic>
    panic("log_write outside of trans");
    800037dc:	00005517          	auipc	a0,0x5
    800037e0:	dd450513          	addi	a0,a0,-556 # 800085b0 <syscalls+0x218>
    800037e4:	00002097          	auipc	ra,0x2
    800037e8:	7ba080e7          	jalr	1978(ra) # 80005f9e <panic>
  log.lh.block[i] = b->blockno;
    800037ec:	00878713          	addi	a4,a5,8
    800037f0:	00271693          	slli	a3,a4,0x2
    800037f4:	00021717          	auipc	a4,0x21
    800037f8:	0bc70713          	addi	a4,a4,188 # 800248b0 <log>
    800037fc:	9736                	add	a4,a4,a3
    800037fe:	44d4                	lw	a3,12(s1)
    80003800:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003802:	faf608e3          	beq	a2,a5,800037b2 <log_write+0x76>
  }
  release(&log.lock);
    80003806:	00021517          	auipc	a0,0x21
    8000380a:	0aa50513          	addi	a0,a0,170 # 800248b0 <log>
    8000380e:	00003097          	auipc	ra,0x3
    80003812:	d80080e7          	jalr	-640(ra) # 8000658e <release>
}
    80003816:	60e2                	ld	ra,24(sp)
    80003818:	6442                	ld	s0,16(sp)
    8000381a:	64a2                	ld	s1,8(sp)
    8000381c:	6902                	ld	s2,0(sp)
    8000381e:	6105                	addi	sp,sp,32
    80003820:	8082                	ret

0000000080003822 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003822:	1101                	addi	sp,sp,-32
    80003824:	ec06                	sd	ra,24(sp)
    80003826:	e822                	sd	s0,16(sp)
    80003828:	e426                	sd	s1,8(sp)
    8000382a:	e04a                	sd	s2,0(sp)
    8000382c:	1000                	addi	s0,sp,32
    8000382e:	84aa                	mv	s1,a0
    80003830:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003832:	00005597          	auipc	a1,0x5
    80003836:	d9e58593          	addi	a1,a1,-610 # 800085d0 <syscalls+0x238>
    8000383a:	0521                	addi	a0,a0,8
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	c0e080e7          	jalr	-1010(ra) # 8000644a <initlock>
  lk->name = name;
    80003844:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003848:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000384c:	0204a423          	sw	zero,40(s1)
}
    80003850:	60e2                	ld	ra,24(sp)
    80003852:	6442                	ld	s0,16(sp)
    80003854:	64a2                	ld	s1,8(sp)
    80003856:	6902                	ld	s2,0(sp)
    80003858:	6105                	addi	sp,sp,32
    8000385a:	8082                	ret

000000008000385c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000385c:	1101                	addi	sp,sp,-32
    8000385e:	ec06                	sd	ra,24(sp)
    80003860:	e822                	sd	s0,16(sp)
    80003862:	e426                	sd	s1,8(sp)
    80003864:	e04a                	sd	s2,0(sp)
    80003866:	1000                	addi	s0,sp,32
    80003868:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000386a:	00850913          	addi	s2,a0,8
    8000386e:	854a                	mv	a0,s2
    80003870:	00003097          	auipc	ra,0x3
    80003874:	c6a080e7          	jalr	-918(ra) # 800064da <acquire>
  while (lk->locked) {
    80003878:	409c                	lw	a5,0(s1)
    8000387a:	cb89                	beqz	a5,8000388c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000387c:	85ca                	mv	a1,s2
    8000387e:	8526                	mv	a0,s1
    80003880:	ffffe097          	auipc	ra,0xffffe
    80003884:	c60080e7          	jalr	-928(ra) # 800014e0 <sleep>
  while (lk->locked) {
    80003888:	409c                	lw	a5,0(s1)
    8000388a:	fbed                	bnez	a5,8000387c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000388c:	4785                	li	a5,1
    8000388e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	5a8080e7          	jalr	1448(ra) # 80000e38 <myproc>
    80003898:	591c                	lw	a5,48(a0)
    8000389a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000389c:	854a                	mv	a0,s2
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	cf0080e7          	jalr	-784(ra) # 8000658e <release>
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038b2:	1101                	addi	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	e04a                	sd	s2,0(sp)
    800038bc:	1000                	addi	s0,sp,32
    800038be:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c0:	00850913          	addi	s2,a0,8
    800038c4:	854a                	mv	a0,s2
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	c14080e7          	jalr	-1004(ra) # 800064da <acquire>
  lk->locked = 0;
    800038ce:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038d6:	8526                	mv	a0,s1
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	c6c080e7          	jalr	-916(ra) # 80001544 <wakeup>
  release(&lk->lk);
    800038e0:	854a                	mv	a0,s2
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	cac080e7          	jalr	-852(ra) # 8000658e <release>
}
    800038ea:	60e2                	ld	ra,24(sp)
    800038ec:	6442                	ld	s0,16(sp)
    800038ee:	64a2                	ld	s1,8(sp)
    800038f0:	6902                	ld	s2,0(sp)
    800038f2:	6105                	addi	sp,sp,32
    800038f4:	8082                	ret

00000000800038f6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038f6:	7179                	addi	sp,sp,-48
    800038f8:	f406                	sd	ra,40(sp)
    800038fa:	f022                	sd	s0,32(sp)
    800038fc:	ec26                	sd	s1,24(sp)
    800038fe:	e84a                	sd	s2,16(sp)
    80003900:	e44e                	sd	s3,8(sp)
    80003902:	1800                	addi	s0,sp,48
    80003904:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003906:	00850913          	addi	s2,a0,8
    8000390a:	854a                	mv	a0,s2
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	bce080e7          	jalr	-1074(ra) # 800064da <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003914:	409c                	lw	a5,0(s1)
    80003916:	ef99                	bnez	a5,80003934 <holdingsleep+0x3e>
    80003918:	4481                	li	s1,0
  release(&lk->lk);
    8000391a:	854a                	mv	a0,s2
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	c72080e7          	jalr	-910(ra) # 8000658e <release>
  return r;
}
    80003924:	8526                	mv	a0,s1
    80003926:	70a2                	ld	ra,40(sp)
    80003928:	7402                	ld	s0,32(sp)
    8000392a:	64e2                	ld	s1,24(sp)
    8000392c:	6942                	ld	s2,16(sp)
    8000392e:	69a2                	ld	s3,8(sp)
    80003930:	6145                	addi	sp,sp,48
    80003932:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003934:	0284a983          	lw	s3,40(s1)
    80003938:	ffffd097          	auipc	ra,0xffffd
    8000393c:	500080e7          	jalr	1280(ra) # 80000e38 <myproc>
    80003940:	5904                	lw	s1,48(a0)
    80003942:	413484b3          	sub	s1,s1,s3
    80003946:	0014b493          	seqz	s1,s1
    8000394a:	bfc1                	j	8000391a <holdingsleep+0x24>

000000008000394c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000394c:	1141                	addi	sp,sp,-16
    8000394e:	e406                	sd	ra,8(sp)
    80003950:	e022                	sd	s0,0(sp)
    80003952:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003954:	00005597          	auipc	a1,0x5
    80003958:	c8c58593          	addi	a1,a1,-884 # 800085e0 <syscalls+0x248>
    8000395c:	00021517          	auipc	a0,0x21
    80003960:	09c50513          	addi	a0,a0,156 # 800249f8 <ftable>
    80003964:	00003097          	auipc	ra,0x3
    80003968:	ae6080e7          	jalr	-1306(ra) # 8000644a <initlock>
}
    8000396c:	60a2                	ld	ra,8(sp)
    8000396e:	6402                	ld	s0,0(sp)
    80003970:	0141                	addi	sp,sp,16
    80003972:	8082                	ret

0000000080003974 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003974:	1101                	addi	sp,sp,-32
    80003976:	ec06                	sd	ra,24(sp)
    80003978:	e822                	sd	s0,16(sp)
    8000397a:	e426                	sd	s1,8(sp)
    8000397c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000397e:	00021517          	auipc	a0,0x21
    80003982:	07a50513          	addi	a0,a0,122 # 800249f8 <ftable>
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	b54080e7          	jalr	-1196(ra) # 800064da <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000398e:	00021497          	auipc	s1,0x21
    80003992:	08248493          	addi	s1,s1,130 # 80024a10 <ftable+0x18>
    80003996:	00022717          	auipc	a4,0x22
    8000399a:	01a70713          	addi	a4,a4,26 # 800259b0 <disk>
    if(f->ref == 0){
    8000399e:	40dc                	lw	a5,4(s1)
    800039a0:	cf99                	beqz	a5,800039be <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a2:	02848493          	addi	s1,s1,40
    800039a6:	fee49ce3          	bne	s1,a4,8000399e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039aa:	00021517          	auipc	a0,0x21
    800039ae:	04e50513          	addi	a0,a0,78 # 800249f8 <ftable>
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	bdc080e7          	jalr	-1060(ra) # 8000658e <release>
  return 0;
    800039ba:	4481                	li	s1,0
    800039bc:	a819                	j	800039d2 <filealloc+0x5e>
      f->ref = 1;
    800039be:	4785                	li	a5,1
    800039c0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039c2:	00021517          	auipc	a0,0x21
    800039c6:	03650513          	addi	a0,a0,54 # 800249f8 <ftable>
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	bc4080e7          	jalr	-1084(ra) # 8000658e <release>
}
    800039d2:	8526                	mv	a0,s1
    800039d4:	60e2                	ld	ra,24(sp)
    800039d6:	6442                	ld	s0,16(sp)
    800039d8:	64a2                	ld	s1,8(sp)
    800039da:	6105                	addi	sp,sp,32
    800039dc:	8082                	ret

00000000800039de <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039ea:	00021517          	auipc	a0,0x21
    800039ee:	00e50513          	addi	a0,a0,14 # 800249f8 <ftable>
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	ae8080e7          	jalr	-1304(ra) # 800064da <acquire>
  if(f->ref < 1)
    800039fa:	40dc                	lw	a5,4(s1)
    800039fc:	02f05263          	blez	a5,80003a20 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a00:	2785                	addiw	a5,a5,1
    80003a02:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a04:	00021517          	auipc	a0,0x21
    80003a08:	ff450513          	addi	a0,a0,-12 # 800249f8 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	b82080e7          	jalr	-1150(ra) # 8000658e <release>
  return f;
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret
    panic("filedup");
    80003a20:	00005517          	auipc	a0,0x5
    80003a24:	bc850513          	addi	a0,a0,-1080 # 800085e8 <syscalls+0x250>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	576080e7          	jalr	1398(ra) # 80005f9e <panic>

0000000080003a30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a30:	7139                	addi	sp,sp,-64
    80003a32:	fc06                	sd	ra,56(sp)
    80003a34:	f822                	sd	s0,48(sp)
    80003a36:	f426                	sd	s1,40(sp)
    80003a38:	f04a                	sd	s2,32(sp)
    80003a3a:	ec4e                	sd	s3,24(sp)
    80003a3c:	e852                	sd	s4,16(sp)
    80003a3e:	e456                	sd	s5,8(sp)
    80003a40:	0080                	addi	s0,sp,64
    80003a42:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a44:	00021517          	auipc	a0,0x21
    80003a48:	fb450513          	addi	a0,a0,-76 # 800249f8 <ftable>
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	a8e080e7          	jalr	-1394(ra) # 800064da <acquire>
  if(f->ref < 1)
    80003a54:	40dc                	lw	a5,4(s1)
    80003a56:	06f05163          	blez	a5,80003ab8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a5a:	37fd                	addiw	a5,a5,-1
    80003a5c:	0007871b          	sext.w	a4,a5
    80003a60:	c0dc                	sw	a5,4(s1)
    80003a62:	06e04363          	bgtz	a4,80003ac8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a66:	0004a903          	lw	s2,0(s1)
    80003a6a:	0094ca83          	lbu	s5,9(s1)
    80003a6e:	0104ba03          	ld	s4,16(s1)
    80003a72:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a76:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a7a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a7e:	00021517          	auipc	a0,0x21
    80003a82:	f7a50513          	addi	a0,a0,-134 # 800249f8 <ftable>
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	b08080e7          	jalr	-1272(ra) # 8000658e <release>

  if(ff.type == FD_PIPE){
    80003a8e:	4785                	li	a5,1
    80003a90:	04f90d63          	beq	s2,a5,80003aea <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a94:	3979                	addiw	s2,s2,-2
    80003a96:	4785                	li	a5,1
    80003a98:	0527e063          	bltu	a5,s2,80003ad8 <fileclose+0xa8>
    begin_op();
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	ac8080e7          	jalr	-1336(ra) # 80003564 <begin_op>
    iput(ff.ip);
    80003aa4:	854e                	mv	a0,s3
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	2b2080e7          	jalr	690(ra) # 80002d58 <iput>
    end_op();
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	b36080e7          	jalr	-1226(ra) # 800035e4 <end_op>
    80003ab6:	a00d                	j	80003ad8 <fileclose+0xa8>
    panic("fileclose");
    80003ab8:	00005517          	auipc	a0,0x5
    80003abc:	b3850513          	addi	a0,a0,-1224 # 800085f0 <syscalls+0x258>
    80003ac0:	00002097          	auipc	ra,0x2
    80003ac4:	4de080e7          	jalr	1246(ra) # 80005f9e <panic>
    release(&ftable.lock);
    80003ac8:	00021517          	auipc	a0,0x21
    80003acc:	f3050513          	addi	a0,a0,-208 # 800249f8 <ftable>
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	abe080e7          	jalr	-1346(ra) # 8000658e <release>
  }
}
    80003ad8:	70e2                	ld	ra,56(sp)
    80003ada:	7442                	ld	s0,48(sp)
    80003adc:	74a2                	ld	s1,40(sp)
    80003ade:	7902                	ld	s2,32(sp)
    80003ae0:	69e2                	ld	s3,24(sp)
    80003ae2:	6a42                	ld	s4,16(sp)
    80003ae4:	6aa2                	ld	s5,8(sp)
    80003ae6:	6121                	addi	sp,sp,64
    80003ae8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003aea:	85d6                	mv	a1,s5
    80003aec:	8552                	mv	a0,s4
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	3a6080e7          	jalr	934(ra) # 80003e94 <pipeclose>
    80003af6:	b7cd                	j	80003ad8 <fileclose+0xa8>

0000000080003af8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003af8:	715d                	addi	sp,sp,-80
    80003afa:	e486                	sd	ra,72(sp)
    80003afc:	e0a2                	sd	s0,64(sp)
    80003afe:	fc26                	sd	s1,56(sp)
    80003b00:	f84a                	sd	s2,48(sp)
    80003b02:	f44e                	sd	s3,40(sp)
    80003b04:	0880                	addi	s0,sp,80
    80003b06:	84aa                	mv	s1,a0
    80003b08:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	32e080e7          	jalr	814(ra) # 80000e38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b12:	409c                	lw	a5,0(s1)
    80003b14:	37f9                	addiw	a5,a5,-2
    80003b16:	4705                	li	a4,1
    80003b18:	04f76763          	bltu	a4,a5,80003b66 <filestat+0x6e>
    80003b1c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b1e:	6c88                	ld	a0,24(s1)
    80003b20:	fffff097          	auipc	ra,0xfffff
    80003b24:	07e080e7          	jalr	126(ra) # 80002b9e <ilock>
    stati(f->ip, &st);
    80003b28:	fb840593          	addi	a1,s0,-72
    80003b2c:	6c88                	ld	a0,24(s1)
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	2fa080e7          	jalr	762(ra) # 80002e28 <stati>
    iunlock(f->ip);
    80003b36:	6c88                	ld	a0,24(s1)
    80003b38:	fffff097          	auipc	ra,0xfffff
    80003b3c:	128080e7          	jalr	296(ra) # 80002c60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b40:	46e1                	li	a3,24
    80003b42:	fb840613          	addi	a2,s0,-72
    80003b46:	85ce                	mv	a1,s3
    80003b48:	05093503          	ld	a0,80(s2)
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	fa8080e7          	jalr	-88(ra) # 80000af4 <copyout>
    80003b54:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b58:	60a6                	ld	ra,72(sp)
    80003b5a:	6406                	ld	s0,64(sp)
    80003b5c:	74e2                	ld	s1,56(sp)
    80003b5e:	7942                	ld	s2,48(sp)
    80003b60:	79a2                	ld	s3,40(sp)
    80003b62:	6161                	addi	sp,sp,80
    80003b64:	8082                	ret
  return -1;
    80003b66:	557d                	li	a0,-1
    80003b68:	bfc5                	j	80003b58 <filestat+0x60>

0000000080003b6a <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003b6a:	7179                	addi	sp,sp,-48
    80003b6c:	f406                	sd	ra,40(sp)
    80003b6e:	f022                	sd	s0,32(sp)
    80003b70:	ec26                	sd	s1,24(sp)
    80003b72:	e84a                	sd	s2,16(sp)
    80003b74:	e44e                	sd	s3,8(sp)
    80003b76:	1800                	addi	s0,sp,48
    80003b78:	84aa                	mv	s1,a0
    80003b7a:	89ae                	mv	s3,a1
    80003b7c:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003b7e:	85b2                	mv	a1,a2
    80003b80:	00005517          	auipc	a0,0x5
    80003b84:	a8050513          	addi	a0,a0,-1408 # 80008600 <syscalls+0x268>
    80003b88:	00002097          	auipc	ra,0x2
    80003b8c:	460080e7          	jalr	1120(ra) # 80005fe8 <printf>
  ilock(f->ip);
    80003b90:	6c88                	ld	a0,24(s1)
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	00c080e7          	jalr	12(ra) # 80002b9e <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003b9a:	6705                	lui	a4,0x1
    80003b9c:	86ca                	mv	a3,s2
    80003b9e:	864e                	mv	a2,s3
    80003ba0:	4581                	li	a1,0
    80003ba2:	6c88                	ld	a0,24(s1)
    80003ba4:	fffff097          	auipc	ra,0xfffff
    80003ba8:	2ae080e7          	jalr	686(ra) # 80002e52 <readi>
  iunlock(f->ip);
    80003bac:	6c88                	ld	a0,24(s1)
    80003bae:	fffff097          	auipc	ra,0xfffff
    80003bb2:	0b2080e7          	jalr	178(ra) # 80002c60 <iunlock>
}
    80003bb6:	70a2                	ld	ra,40(sp)
    80003bb8:	7402                	ld	s0,32(sp)
    80003bba:	64e2                	ld	s1,24(sp)
    80003bbc:	6942                	ld	s2,16(sp)
    80003bbe:	69a2                	ld	s3,8(sp)
    80003bc0:	6145                	addi	sp,sp,48
    80003bc2:	8082                	ret

0000000080003bc4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bc4:	7179                	addi	sp,sp,-48
    80003bc6:	f406                	sd	ra,40(sp)
    80003bc8:	f022                	sd	s0,32(sp)
    80003bca:	ec26                	sd	s1,24(sp)
    80003bcc:	e84a                	sd	s2,16(sp)
    80003bce:	e44e                	sd	s3,8(sp)
    80003bd0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd2:	00854783          	lbu	a5,8(a0)
    80003bd6:	c3d5                	beqz	a5,80003c7a <fileread+0xb6>
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	89ae                	mv	s3,a1
    80003bdc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bde:	411c                	lw	a5,0(a0)
    80003be0:	4705                	li	a4,1
    80003be2:	04e78963          	beq	a5,a4,80003c34 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be6:	470d                	li	a4,3
    80003be8:	04e78d63          	beq	a5,a4,80003c42 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bec:	4709                	li	a4,2
    80003bee:	06e79e63          	bne	a5,a4,80003c6a <fileread+0xa6>
    ilock(f->ip);
    80003bf2:	6d08                	ld	a0,24(a0)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	faa080e7          	jalr	-86(ra) # 80002b9e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfc:	874a                	mv	a4,s2
    80003bfe:	5094                	lw	a3,32(s1)
    80003c00:	864e                	mv	a2,s3
    80003c02:	4585                	li	a1,1
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	24c080e7          	jalr	588(ra) # 80002e52 <readi>
    80003c0e:	892a                	mv	s2,a0
    80003c10:	00a05563          	blez	a0,80003c1a <fileread+0x56>
      f->off += r;
    80003c14:	509c                	lw	a5,32(s1)
    80003c16:	9fa9                	addw	a5,a5,a0
    80003c18:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	044080e7          	jalr	68(ra) # 80002c60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c24:	854a                	mv	a0,s2
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c34:	6908                	ld	a0,16(a0)
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	3c6080e7          	jalr	966(ra) # 80003ffc <piperead>
    80003c3e:	892a                	mv	s2,a0
    80003c40:	b7d5                	j	80003c24 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c42:	02451783          	lh	a5,36(a0)
    80003c46:	03079693          	slli	a3,a5,0x30
    80003c4a:	92c1                	srli	a3,a3,0x30
    80003c4c:	4725                	li	a4,9
    80003c4e:	02d76863          	bltu	a4,a3,80003c7e <fileread+0xba>
    80003c52:	0792                	slli	a5,a5,0x4
    80003c54:	00021717          	auipc	a4,0x21
    80003c58:	d0470713          	addi	a4,a4,-764 # 80024958 <devsw>
    80003c5c:	97ba                	add	a5,a5,a4
    80003c5e:	639c                	ld	a5,0(a5)
    80003c60:	c38d                	beqz	a5,80003c82 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c62:	4505                	li	a0,1
    80003c64:	9782                	jalr	a5
    80003c66:	892a                	mv	s2,a0
    80003c68:	bf75                	j	80003c24 <fileread+0x60>
    panic("fileread");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	99e50513          	addi	a0,a0,-1634 # 80008608 <syscalls+0x270>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	32c080e7          	jalr	812(ra) # 80005f9e <panic>
    return -1;
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b765                	j	80003c24 <fileread+0x60>
      return -1;
    80003c7e:	597d                	li	s2,-1
    80003c80:	b755                	j	80003c24 <fileread+0x60>
    80003c82:	597d                	li	s2,-1
    80003c84:	b745                	j	80003c24 <fileread+0x60>

0000000080003c86 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c86:	715d                	addi	sp,sp,-80
    80003c88:	e486                	sd	ra,72(sp)
    80003c8a:	e0a2                	sd	s0,64(sp)
    80003c8c:	fc26                	sd	s1,56(sp)
    80003c8e:	f84a                	sd	s2,48(sp)
    80003c90:	f44e                	sd	s3,40(sp)
    80003c92:	f052                	sd	s4,32(sp)
    80003c94:	ec56                	sd	s5,24(sp)
    80003c96:	e85a                	sd	s6,16(sp)
    80003c98:	e45e                	sd	s7,8(sp)
    80003c9a:	e062                	sd	s8,0(sp)
    80003c9c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c9e:	00954783          	lbu	a5,9(a0)
    80003ca2:	10078663          	beqz	a5,80003dae <filewrite+0x128>
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	8aae                	mv	s5,a1
    80003caa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cac:	411c                	lw	a5,0(a0)
    80003cae:	4705                	li	a4,1
    80003cb0:	02e78263          	beq	a5,a4,80003cd4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb4:	470d                	li	a4,3
    80003cb6:	02e78663          	beq	a5,a4,80003ce2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cba:	4709                	li	a4,2
    80003cbc:	0ee79163          	bne	a5,a4,80003d9e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cc0:	0ac05d63          	blez	a2,80003d7a <filewrite+0xf4>
    int i = 0;
    80003cc4:	4981                	li	s3,0
    80003cc6:	6b05                	lui	s6,0x1
    80003cc8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ccc:	6b85                	lui	s7,0x1
    80003cce:	c00b8b9b          	addiw	s7,s7,-1024
    80003cd2:	a861                	j	80003d6a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cd4:	6908                	ld	a0,16(a0)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	22e080e7          	jalr	558(ra) # 80003f04 <pipewrite>
    80003cde:	8a2a                	mv	s4,a0
    80003ce0:	a045                	j	80003d80 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce2:	02451783          	lh	a5,36(a0)
    80003ce6:	03079693          	slli	a3,a5,0x30
    80003cea:	92c1                	srli	a3,a3,0x30
    80003cec:	4725                	li	a4,9
    80003cee:	0cd76263          	bltu	a4,a3,80003db2 <filewrite+0x12c>
    80003cf2:	0792                	slli	a5,a5,0x4
    80003cf4:	00021717          	auipc	a4,0x21
    80003cf8:	c6470713          	addi	a4,a4,-924 # 80024958 <devsw>
    80003cfc:	97ba                	add	a5,a5,a4
    80003cfe:	679c                	ld	a5,8(a5)
    80003d00:	cbdd                	beqz	a5,80003db6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d02:	4505                	li	a0,1
    80003d04:	9782                	jalr	a5
    80003d06:	8a2a                	mv	s4,a0
    80003d08:	a8a5                	j	80003d80 <filewrite+0xfa>
    80003d0a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	856080e7          	jalr	-1962(ra) # 80003564 <begin_op>
      ilock(f->ip);
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	e84080e7          	jalr	-380(ra) # 80002b9e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d22:	8762                	mv	a4,s8
    80003d24:	02092683          	lw	a3,32(s2)
    80003d28:	01598633          	add	a2,s3,s5
    80003d2c:	4585                	li	a1,1
    80003d2e:	01893503          	ld	a0,24(s2)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	218080e7          	jalr	536(ra) # 80002f4a <writei>
    80003d3a:	84aa                	mv	s1,a0
    80003d3c:	00a05763          	blez	a0,80003d4a <filewrite+0xc4>
        f->off += r;
    80003d40:	02092783          	lw	a5,32(s2)
    80003d44:	9fa9                	addw	a5,a5,a0
    80003d46:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d4a:	01893503          	ld	a0,24(s2)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	f12080e7          	jalr	-238(ra) # 80002c60 <iunlock>
      end_op();
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	88e080e7          	jalr	-1906(ra) # 800035e4 <end_op>

      if(r != n1){
    80003d5e:	009c1f63          	bne	s8,s1,80003d7c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d62:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d66:	0149db63          	bge	s3,s4,80003d7c <filewrite+0xf6>
      int n1 = n - i;
    80003d6a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d6e:	84be                	mv	s1,a5
    80003d70:	2781                	sext.w	a5,a5
    80003d72:	f8fb5ce3          	bge	s6,a5,80003d0a <filewrite+0x84>
    80003d76:	84de                	mv	s1,s7
    80003d78:	bf49                	j	80003d0a <filewrite+0x84>
    int i = 0;
    80003d7a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d7c:	013a1f63          	bne	s4,s3,80003d9a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d80:	8552                	mv	a0,s4
    80003d82:	60a6                	ld	ra,72(sp)
    80003d84:	6406                	ld	s0,64(sp)
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	7942                	ld	s2,48(sp)
    80003d8a:	79a2                	ld	s3,40(sp)
    80003d8c:	7a02                	ld	s4,32(sp)
    80003d8e:	6ae2                	ld	s5,24(sp)
    80003d90:	6b42                	ld	s6,16(sp)
    80003d92:	6ba2                	ld	s7,8(sp)
    80003d94:	6c02                	ld	s8,0(sp)
    80003d96:	6161                	addi	sp,sp,80
    80003d98:	8082                	ret
    ret = (i == n ? n : -1);
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7d5                	j	80003d80 <filewrite+0xfa>
    panic("filewrite");
    80003d9e:	00005517          	auipc	a0,0x5
    80003da2:	87a50513          	addi	a0,a0,-1926 # 80008618 <syscalls+0x280>
    80003da6:	00002097          	auipc	ra,0x2
    80003daa:	1f8080e7          	jalr	504(ra) # 80005f9e <panic>
    return -1;
    80003dae:	5a7d                	li	s4,-1
    80003db0:	bfc1                	j	80003d80 <filewrite+0xfa>
      return -1;
    80003db2:	5a7d                	li	s4,-1
    80003db4:	b7f1                	j	80003d80 <filewrite+0xfa>
    80003db6:	5a7d                	li	s4,-1
    80003db8:	b7e1                	j	80003d80 <filewrite+0xfa>

0000000080003dba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dba:	7179                	addi	sp,sp,-48
    80003dbc:	f406                	sd	ra,40(sp)
    80003dbe:	f022                	sd	s0,32(sp)
    80003dc0:	ec26                	sd	s1,24(sp)
    80003dc2:	e84a                	sd	s2,16(sp)
    80003dc4:	e44e                	sd	s3,8(sp)
    80003dc6:	e052                	sd	s4,0(sp)
    80003dc8:	1800                	addi	s0,sp,48
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dce:	0005b023          	sd	zero,0(a1)
    80003dd2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	b9e080e7          	jalr	-1122(ra) # 80003974 <filealloc>
    80003dde:	e088                	sd	a0,0(s1)
    80003de0:	c551                	beqz	a0,80003e6c <pipealloc+0xb2>
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	b92080e7          	jalr	-1134(ra) # 80003974 <filealloc>
    80003dea:	00aa3023          	sd	a0,0(s4)
    80003dee:	c92d                	beqz	a0,80003e60 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df0:	ffffc097          	auipc	ra,0xffffc
    80003df4:	328080e7          	jalr	808(ra) # 80000118 <kalloc>
    80003df8:	892a                	mv	s2,a0
    80003dfa:	c125                	beqz	a0,80003e5a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dfc:	4985                	li	s3,1
    80003dfe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e02:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e06:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e0a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e0e:	00005597          	auipc	a1,0x5
    80003e12:	81a58593          	addi	a1,a1,-2022 # 80008628 <syscalls+0x290>
    80003e16:	00002097          	auipc	ra,0x2
    80003e1a:	634080e7          	jalr	1588(ra) # 8000644a <initlock>
  (*f0)->type = FD_PIPE;
    80003e1e:	609c                	ld	a5,0(s1)
    80003e20:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e56:	4501                	li	a0,0
    80003e58:	a025                	j	80003e80 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e5a:	6088                	ld	a0,0(s1)
    80003e5c:	e501                	bnez	a0,80003e64 <pipealloc+0xaa>
    80003e5e:	a039                	j	80003e6c <pipealloc+0xb2>
    80003e60:	6088                	ld	a0,0(s1)
    80003e62:	c51d                	beqz	a0,80003e90 <pipealloc+0xd6>
    fileclose(*f0);
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	bcc080e7          	jalr	-1076(ra) # 80003a30 <fileclose>
  if(*f1)
    80003e6c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e70:	557d                	li	a0,-1
  if(*f1)
    80003e72:	c799                	beqz	a5,80003e80 <pipealloc+0xc6>
    fileclose(*f1);
    80003e74:	853e                	mv	a0,a5
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	bba080e7          	jalr	-1094(ra) # 80003a30 <fileclose>
  return -1;
    80003e7e:	557d                	li	a0,-1
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	6a02                	ld	s4,0(sp)
    80003e8c:	6145                	addi	sp,sp,48
    80003e8e:	8082                	ret
  return -1;
    80003e90:	557d                	li	a0,-1
    80003e92:	b7fd                	j	80003e80 <pipealloc+0xc6>

0000000080003e94 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e94:	1101                	addi	sp,sp,-32
    80003e96:	ec06                	sd	ra,24(sp)
    80003e98:	e822                	sd	s0,16(sp)
    80003e9a:	e426                	sd	s1,8(sp)
    80003e9c:	e04a                	sd	s2,0(sp)
    80003e9e:	1000                	addi	s0,sp,32
    80003ea0:	84aa                	mv	s1,a0
    80003ea2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	636080e7          	jalr	1590(ra) # 800064da <acquire>
  if(writable){
    80003eac:	02090d63          	beqz	s2,80003ee6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb4:	21848513          	addi	a0,s1,536
    80003eb8:	ffffd097          	auipc	ra,0xffffd
    80003ebc:	68c080e7          	jalr	1676(ra) # 80001544 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec0:	2204b783          	ld	a5,544(s1)
    80003ec4:	eb95                	bnez	a5,80003ef8 <pipeclose+0x64>
    release(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	6c6080e7          	jalr	1734(ra) # 8000658e <release>
    kfree((char*)pi);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	ffffc097          	auipc	ra,0xffffc
    80003ed6:	14a080e7          	jalr	330(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eda:	60e2                	ld	ra,24(sp)
    80003edc:	6442                	ld	s0,16(sp)
    80003ede:	64a2                	ld	s1,8(sp)
    80003ee0:	6902                	ld	s2,0(sp)
    80003ee2:	6105                	addi	sp,sp,32
    80003ee4:	8082                	ret
    pi->readopen = 0;
    80003ee6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eea:	21c48513          	addi	a0,s1,540
    80003eee:	ffffd097          	auipc	ra,0xffffd
    80003ef2:	656080e7          	jalr	1622(ra) # 80001544 <wakeup>
    80003ef6:	b7e9                	j	80003ec0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	694080e7          	jalr	1684(ra) # 8000658e <release>
}
    80003f02:	bfe1                	j	80003eda <pipeclose+0x46>

0000000080003f04 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f04:	711d                	addi	sp,sp,-96
    80003f06:	ec86                	sd	ra,88(sp)
    80003f08:	e8a2                	sd	s0,80(sp)
    80003f0a:	e4a6                	sd	s1,72(sp)
    80003f0c:	e0ca                	sd	s2,64(sp)
    80003f0e:	fc4e                	sd	s3,56(sp)
    80003f10:	f852                	sd	s4,48(sp)
    80003f12:	f456                	sd	s5,40(sp)
    80003f14:	f05a                	sd	s6,32(sp)
    80003f16:	ec5e                	sd	s7,24(sp)
    80003f18:	e862                	sd	s8,16(sp)
    80003f1a:	1080                	addi	s0,sp,96
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	8aae                	mv	s5,a1
    80003f20:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	f16080e7          	jalr	-234(ra) # 80000e38 <myproc>
    80003f2a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	5ac080e7          	jalr	1452(ra) # 800064da <acquire>
  while(i < n){
    80003f36:	0b405663          	blez	s4,80003fe2 <pipewrite+0xde>
  int i = 0;
    80003f3a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f3c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f3e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f42:	21c48b93          	addi	s7,s1,540
    80003f46:	a089                	j	80003f88 <pipewrite+0x84>
      release(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00002097          	auipc	ra,0x2
    80003f4e:	644080e7          	jalr	1604(ra) # 8000658e <release>
      return -1;
    80003f52:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f54:	854a                	mv	a0,s2
    80003f56:	60e6                	ld	ra,88(sp)
    80003f58:	6446                	ld	s0,80(sp)
    80003f5a:	64a6                	ld	s1,72(sp)
    80003f5c:	6906                	ld	s2,64(sp)
    80003f5e:	79e2                	ld	s3,56(sp)
    80003f60:	7a42                	ld	s4,48(sp)
    80003f62:	7aa2                	ld	s5,40(sp)
    80003f64:	7b02                	ld	s6,32(sp)
    80003f66:	6be2                	ld	s7,24(sp)
    80003f68:	6c42                	ld	s8,16(sp)
    80003f6a:	6125                	addi	sp,sp,96
    80003f6c:	8082                	ret
      wakeup(&pi->nread);
    80003f6e:	8562                	mv	a0,s8
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	5d4080e7          	jalr	1492(ra) # 80001544 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f78:	85a6                	mv	a1,s1
    80003f7a:	855e                	mv	a0,s7
    80003f7c:	ffffd097          	auipc	ra,0xffffd
    80003f80:	564080e7          	jalr	1380(ra) # 800014e0 <sleep>
  while(i < n){
    80003f84:	07495063          	bge	s2,s4,80003fe4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f88:	2204a783          	lw	a5,544(s1)
    80003f8c:	dfd5                	beqz	a5,80003f48 <pipewrite+0x44>
    80003f8e:	854e                	mv	a0,s3
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	7f8080e7          	jalr	2040(ra) # 80001788 <killed>
    80003f98:	f945                	bnez	a0,80003f48 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f9a:	2184a783          	lw	a5,536(s1)
    80003f9e:	21c4a703          	lw	a4,540(s1)
    80003fa2:	2007879b          	addiw	a5,a5,512
    80003fa6:	fcf704e3          	beq	a4,a5,80003f6e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003faa:	4685                	li	a3,1
    80003fac:	01590633          	add	a2,s2,s5
    80003fb0:	faf40593          	addi	a1,s0,-81
    80003fb4:	0509b503          	ld	a0,80(s3)
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	bc8080e7          	jalr	-1080(ra) # 80000b80 <copyin>
    80003fc0:	03650263          	beq	a0,s6,80003fe4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fc4:	21c4a783          	lw	a5,540(s1)
    80003fc8:	0017871b          	addiw	a4,a5,1
    80003fcc:	20e4ae23          	sw	a4,540(s1)
    80003fd0:	1ff7f793          	andi	a5,a5,511
    80003fd4:	97a6                	add	a5,a5,s1
    80003fd6:	faf44703          	lbu	a4,-81(s0)
    80003fda:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fde:	2905                	addiw	s2,s2,1
    80003fe0:	b755                	j	80003f84 <pipewrite+0x80>
  int i = 0;
    80003fe2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fe4:	21848513          	addi	a0,s1,536
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	55c080e7          	jalr	1372(ra) # 80001544 <wakeup>
  release(&pi->lock);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	00002097          	auipc	ra,0x2
    80003ff6:	59c080e7          	jalr	1436(ra) # 8000658e <release>
  return i;
    80003ffa:	bfa9                	j	80003f54 <pipewrite+0x50>

0000000080003ffc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ffc:	715d                	addi	sp,sp,-80
    80003ffe:	e486                	sd	ra,72(sp)
    80004000:	e0a2                	sd	s0,64(sp)
    80004002:	fc26                	sd	s1,56(sp)
    80004004:	f84a                	sd	s2,48(sp)
    80004006:	f44e                	sd	s3,40(sp)
    80004008:	f052                	sd	s4,32(sp)
    8000400a:	ec56                	sd	s5,24(sp)
    8000400c:	e85a                	sd	s6,16(sp)
    8000400e:	0880                	addi	s0,sp,80
    80004010:	84aa                	mv	s1,a0
    80004012:	892e                	mv	s2,a1
    80004014:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	e22080e7          	jalr	-478(ra) # 80000e38 <myproc>
    8000401e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	4b8080e7          	jalr	1208(ra) # 800064da <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402a:	2184a703          	lw	a4,536(s1)
    8000402e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004032:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004036:	02f71763          	bne	a4,a5,80004064 <piperead+0x68>
    8000403a:	2244a783          	lw	a5,548(s1)
    8000403e:	c39d                	beqz	a5,80004064 <piperead+0x68>
    if(killed(pr)){
    80004040:	8552                	mv	a0,s4
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	746080e7          	jalr	1862(ra) # 80001788 <killed>
    8000404a:	e941                	bnez	a0,800040da <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000404c:	85a6                	mv	a1,s1
    8000404e:	854e                	mv	a0,s3
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	490080e7          	jalr	1168(ra) # 800014e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004058:	2184a703          	lw	a4,536(s1)
    8000405c:	21c4a783          	lw	a5,540(s1)
    80004060:	fcf70de3          	beq	a4,a5,8000403a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004064:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004066:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004068:	05505363          	blez	s5,800040ae <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000406c:	2184a783          	lw	a5,536(s1)
    80004070:	21c4a703          	lw	a4,540(s1)
    80004074:	02f70d63          	beq	a4,a5,800040ae <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004078:	0017871b          	addiw	a4,a5,1
    8000407c:	20e4ac23          	sw	a4,536(s1)
    80004080:	1ff7f793          	andi	a5,a5,511
    80004084:	97a6                	add	a5,a5,s1
    80004086:	0187c783          	lbu	a5,24(a5)
    8000408a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000408e:	4685                	li	a3,1
    80004090:	fbf40613          	addi	a2,s0,-65
    80004094:	85ca                	mv	a1,s2
    80004096:	050a3503          	ld	a0,80(s4)
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	a5a080e7          	jalr	-1446(ra) # 80000af4 <copyout>
    800040a2:	01650663          	beq	a0,s6,800040ae <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a6:	2985                	addiw	s3,s3,1
    800040a8:	0905                	addi	s2,s2,1
    800040aa:	fd3a91e3          	bne	s5,s3,8000406c <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ae:	21c48513          	addi	a0,s1,540
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	492080e7          	jalr	1170(ra) # 80001544 <wakeup>
  release(&pi->lock);
    800040ba:	8526                	mv	a0,s1
    800040bc:	00002097          	auipc	ra,0x2
    800040c0:	4d2080e7          	jalr	1234(ra) # 8000658e <release>
  return i;
}
    800040c4:	854e                	mv	a0,s3
    800040c6:	60a6                	ld	ra,72(sp)
    800040c8:	6406                	ld	s0,64(sp)
    800040ca:	74e2                	ld	s1,56(sp)
    800040cc:	7942                	ld	s2,48(sp)
    800040ce:	79a2                	ld	s3,40(sp)
    800040d0:	7a02                	ld	s4,32(sp)
    800040d2:	6ae2                	ld	s5,24(sp)
    800040d4:	6b42                	ld	s6,16(sp)
    800040d6:	6161                	addi	sp,sp,80
    800040d8:	8082                	ret
      release(&pi->lock);
    800040da:	8526                	mv	a0,s1
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	4b2080e7          	jalr	1202(ra) # 8000658e <release>
      return -1;
    800040e4:	59fd                	li	s3,-1
    800040e6:	bff9                	j	800040c4 <piperead+0xc8>

00000000800040e8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040e8:	1141                	addi	sp,sp,-16
    800040ea:	e422                	sd	s0,8(sp)
    800040ec:	0800                	addi	s0,sp,16
    800040ee:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040f0:	8905                	andi	a0,a0,1
    800040f2:	c111                	beqz	a0,800040f6 <flags2perm+0xe>
      perm = PTE_X;
    800040f4:	4521                	li	a0,8
    if(flags & 0x2)
    800040f6:	8b89                	andi	a5,a5,2
    800040f8:	c399                	beqz	a5,800040fe <flags2perm+0x16>
      perm |= PTE_W;
    800040fa:	00456513          	ori	a0,a0,4
    return perm;
}
    800040fe:	6422                	ld	s0,8(sp)
    80004100:	0141                	addi	sp,sp,16
    80004102:	8082                	ret

0000000080004104 <exec>:

int
exec(char *path, char **argv)
{
    80004104:	de010113          	addi	sp,sp,-544
    80004108:	20113c23          	sd	ra,536(sp)
    8000410c:	20813823          	sd	s0,528(sp)
    80004110:	20913423          	sd	s1,520(sp)
    80004114:	21213023          	sd	s2,512(sp)
    80004118:	ffce                	sd	s3,504(sp)
    8000411a:	fbd2                	sd	s4,496(sp)
    8000411c:	f7d6                	sd	s5,488(sp)
    8000411e:	f3da                	sd	s6,480(sp)
    80004120:	efde                	sd	s7,472(sp)
    80004122:	ebe2                	sd	s8,464(sp)
    80004124:	e7e6                	sd	s9,456(sp)
    80004126:	e3ea                	sd	s10,448(sp)
    80004128:	ff6e                	sd	s11,440(sp)
    8000412a:	1400                	addi	s0,sp,544
    8000412c:	892a                	mv	s2,a0
    8000412e:	dea43423          	sd	a0,-536(s0)
    80004132:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	d02080e7          	jalr	-766(ra) # 80000e38 <myproc>
    8000413e:	84aa                	mv	s1,a0

  begin_op();
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	424080e7          	jalr	1060(ra) # 80003564 <begin_op>

  if((ip = namei(path)) == 0){
    80004148:	854a                	mv	a0,s2
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	1fa080e7          	jalr	506(ra) # 80003344 <namei>
    80004152:	c93d                	beqz	a0,800041c8 <exec+0xc4>
    80004154:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	a48080e7          	jalr	-1464(ra) # 80002b9e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000415e:	04000713          	li	a4,64
    80004162:	4681                	li	a3,0
    80004164:	e5040613          	addi	a2,s0,-432
    80004168:	4581                	li	a1,0
    8000416a:	8556                	mv	a0,s5
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	ce6080e7          	jalr	-794(ra) # 80002e52 <readi>
    80004174:	04000793          	li	a5,64
    80004178:	00f51a63          	bne	a0,a5,8000418c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000417c:	e5042703          	lw	a4,-432(s0)
    80004180:	464c47b7          	lui	a5,0x464c4
    80004184:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004188:	04f70663          	beq	a4,a5,800041d4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000418c:	8556                	mv	a0,s5
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	c72080e7          	jalr	-910(ra) # 80002e00 <iunlockput>
    end_op();
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	44e080e7          	jalr	1102(ra) # 800035e4 <end_op>
  }
  return -1;
    8000419e:	557d                	li	a0,-1
}
    800041a0:	21813083          	ld	ra,536(sp)
    800041a4:	21013403          	ld	s0,528(sp)
    800041a8:	20813483          	ld	s1,520(sp)
    800041ac:	20013903          	ld	s2,512(sp)
    800041b0:	79fe                	ld	s3,504(sp)
    800041b2:	7a5e                	ld	s4,496(sp)
    800041b4:	7abe                	ld	s5,488(sp)
    800041b6:	7b1e                	ld	s6,480(sp)
    800041b8:	6bfe                	ld	s7,472(sp)
    800041ba:	6c5e                	ld	s8,464(sp)
    800041bc:	6cbe                	ld	s9,456(sp)
    800041be:	6d1e                	ld	s10,448(sp)
    800041c0:	7dfa                	ld	s11,440(sp)
    800041c2:	22010113          	addi	sp,sp,544
    800041c6:	8082                	ret
    end_op();
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	41c080e7          	jalr	1052(ra) # 800035e4 <end_op>
    return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	b7f9                	j	800041a0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041d4:	8526                	mv	a0,s1
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	d26080e7          	jalr	-730(ra) # 80000efc <proc_pagetable>
    800041de:	8b2a                	mv	s6,a0
    800041e0:	d555                	beqz	a0,8000418c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e2:	e7042783          	lw	a5,-400(s0)
    800041e6:	e8845703          	lhu	a4,-376(s0)
    800041ea:	c735                	beqz	a4,80004256 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ec:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ee:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800041f2:	6a05                	lui	s4,0x1
    800041f4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041f8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041fc:	6d85                	lui	s11,0x1
    800041fe:	7d7d                	lui	s10,0xfffff
    80004200:	a481                	j	80004440 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004202:	00004517          	auipc	a0,0x4
    80004206:	42e50513          	addi	a0,a0,1070 # 80008630 <syscalls+0x298>
    8000420a:	00002097          	auipc	ra,0x2
    8000420e:	d94080e7          	jalr	-620(ra) # 80005f9e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004212:	874a                	mv	a4,s2
    80004214:	009c86bb          	addw	a3,s9,s1
    80004218:	4581                	li	a1,0
    8000421a:	8556                	mv	a0,s5
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	c36080e7          	jalr	-970(ra) # 80002e52 <readi>
    80004224:	2501                	sext.w	a0,a0
    80004226:	1aa91a63          	bne	s2,a0,800043da <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000422a:	009d84bb          	addw	s1,s11,s1
    8000422e:	013d09bb          	addw	s3,s10,s3
    80004232:	1f74f763          	bgeu	s1,s7,80004420 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004236:	02049593          	slli	a1,s1,0x20
    8000423a:	9181                	srli	a1,a1,0x20
    8000423c:	95e2                	add	a1,a1,s8
    8000423e:	855a                	mv	a0,s6
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	2c2080e7          	jalr	706(ra) # 80000502 <walkaddr>
    80004248:	862a                	mv	a2,a0
    if(pa == 0)
    8000424a:	dd45                	beqz	a0,80004202 <exec+0xfe>
      n = PGSIZE;
    8000424c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000424e:	fd49f2e3          	bgeu	s3,s4,80004212 <exec+0x10e>
      n = sz - i;
    80004252:	894e                	mv	s2,s3
    80004254:	bf7d                	j	80004212 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004256:	4901                	li	s2,0
  iunlockput(ip);
    80004258:	8556                	mv	a0,s5
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	ba6080e7          	jalr	-1114(ra) # 80002e00 <iunlockput>
  end_op();
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	382080e7          	jalr	898(ra) # 800035e4 <end_op>
  p = myproc();
    8000426a:	ffffd097          	auipc	ra,0xffffd
    8000426e:	bce080e7          	jalr	-1074(ra) # 80000e38 <myproc>
    80004272:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004274:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004278:	6785                	lui	a5,0x1
    8000427a:	17fd                	addi	a5,a5,-1
    8000427c:	993e                	add	s2,s2,a5
    8000427e:	77fd                	lui	a5,0xfffff
    80004280:	00f977b3          	and	a5,s2,a5
    80004284:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004288:	4691                	li	a3,4
    8000428a:	6609                	lui	a2,0x2
    8000428c:	963e                	add	a2,a2,a5
    8000428e:	85be                	mv	a1,a5
    80004290:	855a                	mv	a0,s6
    80004292:	ffffc097          	auipc	ra,0xffffc
    80004296:	616080e7          	jalr	1558(ra) # 800008a8 <uvmalloc>
    8000429a:	8c2a                	mv	s8,a0
  ip = 0;
    8000429c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000429e:	12050e63          	beqz	a0,800043da <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042a2:	75f9                	lui	a1,0xffffe
    800042a4:	95aa                	add	a1,a1,a0
    800042a6:	855a                	mv	a0,s6
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	81a080e7          	jalr	-2022(ra) # 80000ac2 <uvmclear>
  stackbase = sp - PGSIZE;
    800042b0:	7afd                	lui	s5,0xfffff
    800042b2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b4:	df043783          	ld	a5,-528(s0)
    800042b8:	6388                	ld	a0,0(a5)
    800042ba:	c925                	beqz	a0,8000432a <exec+0x226>
    800042bc:	e9040993          	addi	s3,s0,-368
    800042c0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042c4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042c6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	02c080e7          	jalr	44(ra) # 800002f4 <strlen>
    800042d0:	0015079b          	addiw	a5,a0,1
    800042d4:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042d8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042dc:	13596663          	bltu	s2,s5,80004408 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042e0:	df043d83          	ld	s11,-528(s0)
    800042e4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042e8:	8552                	mv	a0,s4
    800042ea:	ffffc097          	auipc	ra,0xffffc
    800042ee:	00a080e7          	jalr	10(ra) # 800002f4 <strlen>
    800042f2:	0015069b          	addiw	a3,a0,1
    800042f6:	8652                	mv	a2,s4
    800042f8:	85ca                	mv	a1,s2
    800042fa:	855a                	mv	a0,s6
    800042fc:	ffffc097          	auipc	ra,0xffffc
    80004300:	7f8080e7          	jalr	2040(ra) # 80000af4 <copyout>
    80004304:	10054663          	bltz	a0,80004410 <exec+0x30c>
    ustack[argc] = sp;
    80004308:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000430c:	0485                	addi	s1,s1,1
    8000430e:	008d8793          	addi	a5,s11,8
    80004312:	def43823          	sd	a5,-528(s0)
    80004316:	008db503          	ld	a0,8(s11)
    8000431a:	c911                	beqz	a0,8000432e <exec+0x22a>
    if(argc >= MAXARG)
    8000431c:	09a1                	addi	s3,s3,8
    8000431e:	fb3c95e3          	bne	s9,s3,800042c8 <exec+0x1c4>
  sz = sz1;
    80004322:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004326:	4a81                	li	s5,0
    80004328:	a84d                	j	800043da <exec+0x2d6>
  sp = sz;
    8000432a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000432c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000432e:	00349793          	slli	a5,s1,0x3
    80004332:	f9040713          	addi	a4,s0,-112
    80004336:	97ba                	add	a5,a5,a4
    80004338:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd11d0>
  sp -= (argc+1) * sizeof(uint64);
    8000433c:	00148693          	addi	a3,s1,1
    80004340:	068e                	slli	a3,a3,0x3
    80004342:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004346:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000434a:	01597663          	bgeu	s2,s5,80004356 <exec+0x252>
  sz = sz1;
    8000434e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004352:	4a81                	li	s5,0
    80004354:	a059                	j	800043da <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004356:	e9040613          	addi	a2,s0,-368
    8000435a:	85ca                	mv	a1,s2
    8000435c:	855a                	mv	a0,s6
    8000435e:	ffffc097          	auipc	ra,0xffffc
    80004362:	796080e7          	jalr	1942(ra) # 80000af4 <copyout>
    80004366:	0a054963          	bltz	a0,80004418 <exec+0x314>
  p->trapframe->a1 = sp;
    8000436a:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    8000436e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004372:	de843783          	ld	a5,-536(s0)
    80004376:	0007c703          	lbu	a4,0(a5)
    8000437a:	cf11                	beqz	a4,80004396 <exec+0x292>
    8000437c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000437e:	02f00693          	li	a3,47
    80004382:	a039                	j	80004390 <exec+0x28c>
      last = s+1;
    80004384:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004388:	0785                	addi	a5,a5,1
    8000438a:	fff7c703          	lbu	a4,-1(a5)
    8000438e:	c701                	beqz	a4,80004396 <exec+0x292>
    if(*s == '/')
    80004390:	fed71ce3          	bne	a4,a3,80004388 <exec+0x284>
    80004394:	bfc5                	j	80004384 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004396:	4641                	li	a2,16
    80004398:	de843583          	ld	a1,-536(s0)
    8000439c:	158b8513          	addi	a0,s7,344
    800043a0:	ffffc097          	auipc	ra,0xffffc
    800043a4:	f22080e7          	jalr	-222(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043a8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043ac:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043b0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043b4:	058bb783          	ld	a5,88(s7)
    800043b8:	e6843703          	ld	a4,-408(s0)
    800043bc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043be:	058bb783          	ld	a5,88(s7)
    800043c2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043c6:	85ea                	mv	a1,s10
    800043c8:	ffffd097          	auipc	ra,0xffffd
    800043cc:	bd0080e7          	jalr	-1072(ra) # 80000f98 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043d0:	0004851b          	sext.w	a0,s1
    800043d4:	b3f1                	j	800041a0 <exec+0x9c>
    800043d6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043da:	df843583          	ld	a1,-520(s0)
    800043de:	855a                	mv	a0,s6
    800043e0:	ffffd097          	auipc	ra,0xffffd
    800043e4:	bb8080e7          	jalr	-1096(ra) # 80000f98 <proc_freepagetable>
  if(ip){
    800043e8:	da0a92e3          	bnez	s5,8000418c <exec+0x88>
  return -1;
    800043ec:	557d                	li	a0,-1
    800043ee:	bb4d                	j	800041a0 <exec+0x9c>
    800043f0:	df243c23          	sd	s2,-520(s0)
    800043f4:	b7dd                	j	800043da <exec+0x2d6>
    800043f6:	df243c23          	sd	s2,-520(s0)
    800043fa:	b7c5                	j	800043da <exec+0x2d6>
    800043fc:	df243c23          	sd	s2,-520(s0)
    80004400:	bfe9                	j	800043da <exec+0x2d6>
    80004402:	df243c23          	sd	s2,-520(s0)
    80004406:	bfd1                	j	800043da <exec+0x2d6>
  sz = sz1;
    80004408:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000440c:	4a81                	li	s5,0
    8000440e:	b7f1                	j	800043da <exec+0x2d6>
  sz = sz1;
    80004410:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004414:	4a81                	li	s5,0
    80004416:	b7d1                	j	800043da <exec+0x2d6>
  sz = sz1;
    80004418:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000441c:	4a81                	li	s5,0
    8000441e:	bf75                	j	800043da <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004420:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004424:	e0843783          	ld	a5,-504(s0)
    80004428:	0017869b          	addiw	a3,a5,1
    8000442c:	e0d43423          	sd	a3,-504(s0)
    80004430:	e0043783          	ld	a5,-512(s0)
    80004434:	0387879b          	addiw	a5,a5,56
    80004438:	e8845703          	lhu	a4,-376(s0)
    8000443c:	e0e6dee3          	bge	a3,a4,80004258 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004440:	2781                	sext.w	a5,a5
    80004442:	e0f43023          	sd	a5,-512(s0)
    80004446:	03800713          	li	a4,56
    8000444a:	86be                	mv	a3,a5
    8000444c:	e1840613          	addi	a2,s0,-488
    80004450:	4581                	li	a1,0
    80004452:	8556                	mv	a0,s5
    80004454:	fffff097          	auipc	ra,0xfffff
    80004458:	9fe080e7          	jalr	-1538(ra) # 80002e52 <readi>
    8000445c:	03800793          	li	a5,56
    80004460:	f6f51be3          	bne	a0,a5,800043d6 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004464:	e1842783          	lw	a5,-488(s0)
    80004468:	4705                	li	a4,1
    8000446a:	fae79de3          	bne	a5,a4,80004424 <exec+0x320>
    if(ph.memsz < ph.filesz)
    8000446e:	e4043483          	ld	s1,-448(s0)
    80004472:	e3843783          	ld	a5,-456(s0)
    80004476:	f6f4ede3          	bltu	s1,a5,800043f0 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000447a:	e2843783          	ld	a5,-472(s0)
    8000447e:	94be                	add	s1,s1,a5
    80004480:	f6f4ebe3          	bltu	s1,a5,800043f6 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004484:	de043703          	ld	a4,-544(s0)
    80004488:	8ff9                	and	a5,a5,a4
    8000448a:	fbad                	bnez	a5,800043fc <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448c:	e1c42503          	lw	a0,-484(s0)
    80004490:	00000097          	auipc	ra,0x0
    80004494:	c58080e7          	jalr	-936(ra) # 800040e8 <flags2perm>
    80004498:	86aa                	mv	a3,a0
    8000449a:	8626                	mv	a2,s1
    8000449c:	85ca                	mv	a1,s2
    8000449e:	855a                	mv	a0,s6
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	408080e7          	jalr	1032(ra) # 800008a8 <uvmalloc>
    800044a8:	dea43c23          	sd	a0,-520(s0)
    800044ac:	d939                	beqz	a0,80004402 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044ae:	e2843c03          	ld	s8,-472(s0)
    800044b2:	e2042c83          	lw	s9,-480(s0)
    800044b6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044ba:	f60b83e3          	beqz	s7,80004420 <exec+0x31c>
    800044be:	89de                	mv	s3,s7
    800044c0:	4481                	li	s1,0
    800044c2:	bb95                	j	80004236 <exec+0x132>

00000000800044c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044c4:	7179                	addi	sp,sp,-48
    800044c6:	f406                	sd	ra,40(sp)
    800044c8:	f022                	sd	s0,32(sp)
    800044ca:	ec26                	sd	s1,24(sp)
    800044cc:	e84a                	sd	s2,16(sp)
    800044ce:	1800                	addi	s0,sp,48
    800044d0:	892e                	mv	s2,a1
    800044d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044d4:	fdc40593          	addi	a1,s0,-36
    800044d8:	ffffe097          	auipc	ra,0xffffe
    800044dc:	b4a080e7          	jalr	-1206(ra) # 80002022 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800044e0:	fdc42703          	lw	a4,-36(s0)
    800044e4:	47bd                	li	a5,15
    800044e6:	02e7eb63          	bltu	a5,a4,8000451c <argfd+0x58>
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	94e080e7          	jalr	-1714(ra) # 80000e38 <myproc>
    800044f2:	fdc42703          	lw	a4,-36(s0)
    800044f6:	01a70793          	addi	a5,a4,26
    800044fa:	078e                	slli	a5,a5,0x3
    800044fc:	953e                	add	a0,a0,a5
    800044fe:	611c                	ld	a5,0(a0)
    80004500:	c385                	beqz	a5,80004520 <argfd+0x5c>
    return -1;
  if (pfd)
    80004502:	00090463          	beqz	s2,8000450a <argfd+0x46>
    *pfd = fd;
    80004506:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000450a:	4501                	li	a0,0
  if (pf)
    8000450c:	c091                	beqz	s1,80004510 <argfd+0x4c>
    *pf = f;
    8000450e:	e09c                	sd	a5,0(s1)
}
    80004510:	70a2                	ld	ra,40(sp)
    80004512:	7402                	ld	s0,32(sp)
    80004514:	64e2                	ld	s1,24(sp)
    80004516:	6942                	ld	s2,16(sp)
    80004518:	6145                	addi	sp,sp,48
    8000451a:	8082                	ret
    return -1;
    8000451c:	557d                	li	a0,-1
    8000451e:	bfcd                	j	80004510 <argfd+0x4c>
    80004520:	557d                	li	a0,-1
    80004522:	b7fd                	j	80004510 <argfd+0x4c>

0000000080004524 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004524:	1101                	addi	sp,sp,-32
    80004526:	ec06                	sd	ra,24(sp)
    80004528:	e822                	sd	s0,16(sp)
    8000452a:	e426                	sd	s1,8(sp)
    8000452c:	1000                	addi	s0,sp,32
    8000452e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	908080e7          	jalr	-1784(ra) # 80000e38 <myproc>
    80004538:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    8000453a:	0d050793          	addi	a5,a0,208
    8000453e:	4501                	li	a0,0
    80004540:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80004542:	6398                	ld	a4,0(a5)
    80004544:	cb19                	beqz	a4,8000455a <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    80004546:	2505                	addiw	a0,a0,1
    80004548:	07a1                	addi	a5,a5,8
    8000454a:	fed51ce3          	bne	a0,a3,80004542 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000454e:	557d                	li	a0,-1
}
    80004550:	60e2                	ld	ra,24(sp)
    80004552:	6442                	ld	s0,16(sp)
    80004554:	64a2                	ld	s1,8(sp)
    80004556:	6105                	addi	sp,sp,32
    80004558:	8082                	ret
      p->ofile[fd] = f;
    8000455a:	01a50793          	addi	a5,a0,26
    8000455e:	078e                	slli	a5,a5,0x3
    80004560:	963e                	add	a2,a2,a5
    80004562:	e204                	sd	s1,0(a2)
      return fd;
    80004564:	b7f5                	j	80004550 <fdalloc+0x2c>

0000000080004566 <create>:
  return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004566:	715d                	addi	sp,sp,-80
    80004568:	e486                	sd	ra,72(sp)
    8000456a:	e0a2                	sd	s0,64(sp)
    8000456c:	fc26                	sd	s1,56(sp)
    8000456e:	f84a                	sd	s2,48(sp)
    80004570:	f44e                	sd	s3,40(sp)
    80004572:	f052                	sd	s4,32(sp)
    80004574:	ec56                	sd	s5,24(sp)
    80004576:	e85a                	sd	s6,16(sp)
    80004578:	0880                	addi	s0,sp,80
    8000457a:	8b2e                	mv	s6,a1
    8000457c:	89b2                	mv	s3,a2
    8000457e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004580:	fb040593          	addi	a1,s0,-80
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	dde080e7          	jalr	-546(ra) # 80003362 <nameiparent>
    8000458c:	84aa                	mv	s1,a0
    8000458e:	14050f63          	beqz	a0,800046ec <create+0x186>
    return 0;

  ilock(dp);
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	60c080e7          	jalr	1548(ra) # 80002b9e <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    8000459a:	4601                	li	a2,0
    8000459c:	fb040593          	addi	a1,s0,-80
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	ae0080e7          	jalr	-1312(ra) # 80003082 <dirlookup>
    800045aa:	8aaa                	mv	s5,a0
    800045ac:	c931                	beqz	a0,80004600 <create+0x9a>
  {
    iunlockput(dp);
    800045ae:	8526                	mv	a0,s1
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	850080e7          	jalr	-1968(ra) # 80002e00 <iunlockput>
    ilock(ip);
    800045b8:	8556                	mv	a0,s5
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	5e4080e7          	jalr	1508(ra) # 80002b9e <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045c2:	000b059b          	sext.w	a1,s6
    800045c6:	4789                	li	a5,2
    800045c8:	02f59563          	bne	a1,a5,800045f2 <create+0x8c>
    800045cc:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd1314>
    800045d0:	37f9                	addiw	a5,a5,-2
    800045d2:	17c2                	slli	a5,a5,0x30
    800045d4:	93c1                	srli	a5,a5,0x30
    800045d6:	4705                	li	a4,1
    800045d8:	00f76d63          	bltu	a4,a5,800045f2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045dc:	8556                	mv	a0,s5
    800045de:	60a6                	ld	ra,72(sp)
    800045e0:	6406                	ld	s0,64(sp)
    800045e2:	74e2                	ld	s1,56(sp)
    800045e4:	7942                	ld	s2,48(sp)
    800045e6:	79a2                	ld	s3,40(sp)
    800045e8:	7a02                	ld	s4,32(sp)
    800045ea:	6ae2                	ld	s5,24(sp)
    800045ec:	6b42                	ld	s6,16(sp)
    800045ee:	6161                	addi	sp,sp,80
    800045f0:	8082                	ret
    iunlockput(ip);
    800045f2:	8556                	mv	a0,s5
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	80c080e7          	jalr	-2036(ra) # 80002e00 <iunlockput>
    return 0;
    800045fc:	4a81                	li	s5,0
    800045fe:	bff9                	j	800045dc <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004600:	85da                	mv	a1,s6
    80004602:	4088                	lw	a0,0(s1)
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	3fe080e7          	jalr	1022(ra) # 80002a02 <ialloc>
    8000460c:	8a2a                	mv	s4,a0
    8000460e:	c539                	beqz	a0,8000465c <create+0xf6>
  ilock(ip);
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	58e080e7          	jalr	1422(ra) # 80002b9e <ilock>
  ip->major = major;
    80004618:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000461c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004620:	4905                	li	s2,1
    80004622:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004626:	8552                	mv	a0,s4
    80004628:	ffffe097          	auipc	ra,0xffffe
    8000462c:	4ac080e7          	jalr	1196(ra) # 80002ad4 <iupdate>
  if (type == T_DIR)
    80004630:	000b059b          	sext.w	a1,s6
    80004634:	03258b63          	beq	a1,s2,8000466a <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    80004638:	004a2603          	lw	a2,4(s4)
    8000463c:	fb040593          	addi	a1,s0,-80
    80004640:	8526                	mv	a0,s1
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	c50080e7          	jalr	-944(ra) # 80003292 <dirlink>
    8000464a:	06054f63          	bltz	a0,800046c8 <create+0x162>
  iunlockput(dp);
    8000464e:	8526                	mv	a0,s1
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	7b0080e7          	jalr	1968(ra) # 80002e00 <iunlockput>
  return ip;
    80004658:	8ad2                	mv	s5,s4
    8000465a:	b749                	j	800045dc <create+0x76>
    iunlockput(dp);
    8000465c:	8526                	mv	a0,s1
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	7a2080e7          	jalr	1954(ra) # 80002e00 <iunlockput>
    return 0;
    80004666:	8ad2                	mv	s5,s4
    80004668:	bf95                	j	800045dc <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000466a:	004a2603          	lw	a2,4(s4)
    8000466e:	00004597          	auipc	a1,0x4
    80004672:	fe258593          	addi	a1,a1,-30 # 80008650 <syscalls+0x2b8>
    80004676:	8552                	mv	a0,s4
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	c1a080e7          	jalr	-998(ra) # 80003292 <dirlink>
    80004680:	04054463          	bltz	a0,800046c8 <create+0x162>
    80004684:	40d0                	lw	a2,4(s1)
    80004686:	00004597          	auipc	a1,0x4
    8000468a:	fd258593          	addi	a1,a1,-46 # 80008658 <syscalls+0x2c0>
    8000468e:	8552                	mv	a0,s4
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	c02080e7          	jalr	-1022(ra) # 80003292 <dirlink>
    80004698:	02054863          	bltz	a0,800046c8 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    8000469c:	004a2603          	lw	a2,4(s4)
    800046a0:	fb040593          	addi	a1,s0,-80
    800046a4:	8526                	mv	a0,s1
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	bec080e7          	jalr	-1044(ra) # 80003292 <dirlink>
    800046ae:	00054d63          	bltz	a0,800046c8 <create+0x162>
    dp->nlink++; // for ".."
    800046b2:	04a4d783          	lhu	a5,74(s1)
    800046b6:	2785                	addiw	a5,a5,1
    800046b8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046bc:	8526                	mv	a0,s1
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	416080e7          	jalr	1046(ra) # 80002ad4 <iupdate>
    800046c6:	b761                	j	8000464e <create+0xe8>
  ip->nlink = 0;
    800046c8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046cc:	8552                	mv	a0,s4
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	406080e7          	jalr	1030(ra) # 80002ad4 <iupdate>
  iunlockput(ip);
    800046d6:	8552                	mv	a0,s4
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	728080e7          	jalr	1832(ra) # 80002e00 <iunlockput>
  iunlockput(dp);
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	71e080e7          	jalr	1822(ra) # 80002e00 <iunlockput>
  return 0;
    800046ea:	bdcd                	j	800045dc <create+0x76>
    return 0;
    800046ec:	8aaa                	mv	s5,a0
    800046ee:	b5fd                	j	800045dc <create+0x76>

00000000800046f0 <sys_dup>:
{
    800046f0:	7179                	addi	sp,sp,-48
    800046f2:	f406                	sd	ra,40(sp)
    800046f4:	f022                	sd	s0,32(sp)
    800046f6:	ec26                	sd	s1,24(sp)
    800046f8:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    800046fa:	fd840613          	addi	a2,s0,-40
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	dc2080e7          	jalr	-574(ra) # 800044c4 <argfd>
    return -1;
    8000470a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    8000470c:	02054363          	bltz	a0,80004732 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80004710:	fd843503          	ld	a0,-40(s0)
    80004714:	00000097          	auipc	ra,0x0
    80004718:	e10080e7          	jalr	-496(ra) # 80004524 <fdalloc>
    8000471c:	84aa                	mv	s1,a0
    return -1;
    8000471e:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004720:	00054963          	bltz	a0,80004732 <sys_dup+0x42>
  filedup(f);
    80004724:	fd843503          	ld	a0,-40(s0)
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	2b6080e7          	jalr	694(ra) # 800039de <filedup>
  return fd;
    80004730:	87a6                	mv	a5,s1
}
    80004732:	853e                	mv	a0,a5
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	64e2                	ld	s1,24(sp)
    8000473a:	6145                	addi	sp,sp,48
    8000473c:	8082                	ret

000000008000473e <sys_read>:
{
    8000473e:	7179                	addi	sp,sp,-48
    80004740:	f406                	sd	ra,40(sp)
    80004742:	f022                	sd	s0,32(sp)
    80004744:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004746:	fd840593          	addi	a1,s0,-40
    8000474a:	4505                	li	a0,1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	8f6080e7          	jalr	-1802(ra) # 80002042 <argaddr>
  argint(2, &n);
    80004754:	fe440593          	addi	a1,s0,-28
    80004758:	4509                	li	a0,2
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	8c8080e7          	jalr	-1848(ra) # 80002022 <argint>
  if (argfd(0, 0, &f) < 0)
    80004762:	fe840613          	addi	a2,s0,-24
    80004766:	4581                	li	a1,0
    80004768:	4501                	li	a0,0
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	d5a080e7          	jalr	-678(ra) # 800044c4 <argfd>
    80004772:	87aa                	mv	a5,a0
    return -1;
    80004774:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004776:	0007cc63          	bltz	a5,8000478e <sys_read+0x50>
  return fileread(f, p, n);
    8000477a:	fe442603          	lw	a2,-28(s0)
    8000477e:	fd843583          	ld	a1,-40(s0)
    80004782:	fe843503          	ld	a0,-24(s0)
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	43e080e7          	jalr	1086(ra) # 80003bc4 <fileread>
}
    8000478e:	70a2                	ld	ra,40(sp)
    80004790:	7402                	ld	s0,32(sp)
    80004792:	6145                	addi	sp,sp,48
    80004794:	8082                	ret

0000000080004796 <sys_write>:
{
    80004796:	7179                	addi	sp,sp,-48
    80004798:	f406                	sd	ra,40(sp)
    8000479a:	f022                	sd	s0,32(sp)
    8000479c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000479e:	fd840593          	addi	a1,s0,-40
    800047a2:	4505                	li	a0,1
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	89e080e7          	jalr	-1890(ra) # 80002042 <argaddr>
  argint(2, &n);
    800047ac:	fe440593          	addi	a1,s0,-28
    800047b0:	4509                	li	a0,2
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	870080e7          	jalr	-1936(ra) # 80002022 <argint>
  if (argfd(0, 0, &f) < 0)
    800047ba:	fe840613          	addi	a2,s0,-24
    800047be:	4581                	li	a1,0
    800047c0:	4501                	li	a0,0
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	d02080e7          	jalr	-766(ra) # 800044c4 <argfd>
    800047ca:	87aa                	mv	a5,a0
    return -1;
    800047cc:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047ce:	0007cc63          	bltz	a5,800047e6 <sys_write+0x50>
  return filewrite(f, p, n);
    800047d2:	fe442603          	lw	a2,-28(s0)
    800047d6:	fd843583          	ld	a1,-40(s0)
    800047da:	fe843503          	ld	a0,-24(s0)
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	4a8080e7          	jalr	1192(ra) # 80003c86 <filewrite>
}
    800047e6:	70a2                	ld	ra,40(sp)
    800047e8:	7402                	ld	s0,32(sp)
    800047ea:	6145                	addi	sp,sp,48
    800047ec:	8082                	ret

00000000800047ee <sys_close>:
{
    800047ee:	1101                	addi	sp,sp,-32
    800047f0:	ec06                	sd	ra,24(sp)
    800047f2:	e822                	sd	s0,16(sp)
    800047f4:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800047f6:	fe040613          	addi	a2,s0,-32
    800047fa:	fec40593          	addi	a1,s0,-20
    800047fe:	4501                	li	a0,0
    80004800:	00000097          	auipc	ra,0x0
    80004804:	cc4080e7          	jalr	-828(ra) # 800044c4 <argfd>
    return -1;
    80004808:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000480a:	02054463          	bltz	a0,80004832 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000480e:	ffffc097          	auipc	ra,0xffffc
    80004812:	62a080e7          	jalr	1578(ra) # 80000e38 <myproc>
    80004816:	fec42783          	lw	a5,-20(s0)
    8000481a:	07e9                	addi	a5,a5,26
    8000481c:	078e                	slli	a5,a5,0x3
    8000481e:	97aa                	add	a5,a5,a0
    80004820:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004824:	fe043503          	ld	a0,-32(s0)
    80004828:	fffff097          	auipc	ra,0xfffff
    8000482c:	208080e7          	jalr	520(ra) # 80003a30 <fileclose>
  return 0;
    80004830:	4781                	li	a5,0
}
    80004832:	853e                	mv	a0,a5
    80004834:	60e2                	ld	ra,24(sp)
    80004836:	6442                	ld	s0,16(sp)
    80004838:	6105                	addi	sp,sp,32
    8000483a:	8082                	ret

000000008000483c <sys_fstat>:
{
    8000483c:	1101                	addi	sp,sp,-32
    8000483e:	ec06                	sd	ra,24(sp)
    80004840:	e822                	sd	s0,16(sp)
    80004842:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004844:	fe040593          	addi	a1,s0,-32
    80004848:	4505                	li	a0,1
    8000484a:	ffffd097          	auipc	ra,0xffffd
    8000484e:	7f8080e7          	jalr	2040(ra) # 80002042 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004852:	fe840613          	addi	a2,s0,-24
    80004856:	4581                	li	a1,0
    80004858:	4501                	li	a0,0
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	c6a080e7          	jalr	-918(ra) # 800044c4 <argfd>
    80004862:	87aa                	mv	a5,a0
    return -1;
    80004864:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004866:	0007ca63          	bltz	a5,8000487a <sys_fstat+0x3e>
  return filestat(f, st);
    8000486a:	fe043583          	ld	a1,-32(s0)
    8000486e:	fe843503          	ld	a0,-24(s0)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	286080e7          	jalr	646(ra) # 80003af8 <filestat>
}
    8000487a:	60e2                	ld	ra,24(sp)
    8000487c:	6442                	ld	s0,16(sp)
    8000487e:	6105                	addi	sp,sp,32
    80004880:	8082                	ret

0000000080004882 <sys_link>:
{
    80004882:	7169                	addi	sp,sp,-304
    80004884:	f606                	sd	ra,296(sp)
    80004886:	f222                	sd	s0,288(sp)
    80004888:	ee26                	sd	s1,280(sp)
    8000488a:	ea4a                	sd	s2,272(sp)
    8000488c:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488e:	08000613          	li	a2,128
    80004892:	ed040593          	addi	a1,s0,-304
    80004896:	4501                	li	a0,0
    80004898:	ffffd097          	auipc	ra,0xffffd
    8000489c:	7ca080e7          	jalr	1994(ra) # 80002062 <argstr>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a2:	10054e63          	bltz	a0,800049be <sys_link+0x13c>
    800048a6:	08000613          	li	a2,128
    800048aa:	f5040593          	addi	a1,s0,-176
    800048ae:	4505                	li	a0,1
    800048b0:	ffffd097          	auipc	ra,0xffffd
    800048b4:	7b2080e7          	jalr	1970(ra) # 80002062 <argstr>
    return -1;
    800048b8:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ba:	10054263          	bltz	a0,800049be <sys_link+0x13c>
  begin_op();
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	ca6080e7          	jalr	-858(ra) # 80003564 <begin_op>
  if ((ip = namei(old)) == 0)
    800048c6:	ed040513          	addi	a0,s0,-304
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	a7a080e7          	jalr	-1414(ra) # 80003344 <namei>
    800048d2:	84aa                	mv	s1,a0
    800048d4:	c551                	beqz	a0,80004960 <sys_link+0xde>
  ilock(ip);
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	2c8080e7          	jalr	712(ra) # 80002b9e <ilock>
  if (ip->type == T_DIR)
    800048de:	04449703          	lh	a4,68(s1)
    800048e2:	4785                	li	a5,1
    800048e4:	08f70463          	beq	a4,a5,8000496c <sys_link+0xea>
  ip->nlink++;
    800048e8:	04a4d783          	lhu	a5,74(s1)
    800048ec:	2785                	addiw	a5,a5,1
    800048ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f2:	8526                	mv	a0,s1
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	1e0080e7          	jalr	480(ra) # 80002ad4 <iupdate>
  iunlock(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	362080e7          	jalr	866(ra) # 80002c60 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004906:	fd040593          	addi	a1,s0,-48
    8000490a:	f5040513          	addi	a0,s0,-176
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	a54080e7          	jalr	-1452(ra) # 80003362 <nameiparent>
    80004916:	892a                	mv	s2,a0
    80004918:	c935                	beqz	a0,8000498c <sys_link+0x10a>
  ilock(dp);
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	284080e7          	jalr	644(ra) # 80002b9e <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004922:	00092703          	lw	a4,0(s2)
    80004926:	409c                	lw	a5,0(s1)
    80004928:	04f71d63          	bne	a4,a5,80004982 <sys_link+0x100>
    8000492c:	40d0                	lw	a2,4(s1)
    8000492e:	fd040593          	addi	a1,s0,-48
    80004932:	854a                	mv	a0,s2
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	95e080e7          	jalr	-1698(ra) # 80003292 <dirlink>
    8000493c:	04054363          	bltz	a0,80004982 <sys_link+0x100>
  iunlockput(dp);
    80004940:	854a                	mv	a0,s2
    80004942:	ffffe097          	auipc	ra,0xffffe
    80004946:	4be080e7          	jalr	1214(ra) # 80002e00 <iunlockput>
  iput(ip);
    8000494a:	8526                	mv	a0,s1
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	40c080e7          	jalr	1036(ra) # 80002d58 <iput>
  end_op();
    80004954:	fffff097          	auipc	ra,0xfffff
    80004958:	c90080e7          	jalr	-880(ra) # 800035e4 <end_op>
  return 0;
    8000495c:	4781                	li	a5,0
    8000495e:	a085                	j	800049be <sys_link+0x13c>
    end_op();
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	c84080e7          	jalr	-892(ra) # 800035e4 <end_op>
    return -1;
    80004968:	57fd                	li	a5,-1
    8000496a:	a891                	j	800049be <sys_link+0x13c>
    iunlockput(ip);
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	492080e7          	jalr	1170(ra) # 80002e00 <iunlockput>
    end_op();
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	c6e080e7          	jalr	-914(ra) # 800035e4 <end_op>
    return -1;
    8000497e:	57fd                	li	a5,-1
    80004980:	a83d                	j	800049be <sys_link+0x13c>
    iunlockput(dp);
    80004982:	854a                	mv	a0,s2
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	47c080e7          	jalr	1148(ra) # 80002e00 <iunlockput>
  ilock(ip);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	210080e7          	jalr	528(ra) # 80002b9e <ilock>
  ip->nlink--;
    80004996:	04a4d783          	lhu	a5,74(s1)
    8000499a:	37fd                	addiw	a5,a5,-1
    8000499c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	132080e7          	jalr	306(ra) # 80002ad4 <iupdate>
  iunlockput(ip);
    800049aa:	8526                	mv	a0,s1
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	454080e7          	jalr	1108(ra) # 80002e00 <iunlockput>
  end_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	c30080e7          	jalr	-976(ra) # 800035e4 <end_op>
  return -1;
    800049bc:	57fd                	li	a5,-1
}
    800049be:	853e                	mv	a0,a5
    800049c0:	70b2                	ld	ra,296(sp)
    800049c2:	7412                	ld	s0,288(sp)
    800049c4:	64f2                	ld	s1,280(sp)
    800049c6:	6952                	ld	s2,272(sp)
    800049c8:	6155                	addi	sp,sp,304
    800049ca:	8082                	ret

00000000800049cc <sys_unlink>:
{
    800049cc:	7151                	addi	sp,sp,-240
    800049ce:	f586                	sd	ra,232(sp)
    800049d0:	f1a2                	sd	s0,224(sp)
    800049d2:	eda6                	sd	s1,216(sp)
    800049d4:	e9ca                	sd	s2,208(sp)
    800049d6:	e5ce                	sd	s3,200(sp)
    800049d8:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800049da:	08000613          	li	a2,128
    800049de:	f3040593          	addi	a1,s0,-208
    800049e2:	4501                	li	a0,0
    800049e4:	ffffd097          	auipc	ra,0xffffd
    800049e8:	67e080e7          	jalr	1662(ra) # 80002062 <argstr>
    800049ec:	18054163          	bltz	a0,80004b6e <sys_unlink+0x1a2>
  begin_op();
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	b74080e7          	jalr	-1164(ra) # 80003564 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    800049f8:	fb040593          	addi	a1,s0,-80
    800049fc:	f3040513          	addi	a0,s0,-208
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	962080e7          	jalr	-1694(ra) # 80003362 <nameiparent>
    80004a08:	84aa                	mv	s1,a0
    80004a0a:	c979                	beqz	a0,80004ae0 <sys_unlink+0x114>
  ilock(dp);
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	192080e7          	jalr	402(ra) # 80002b9e <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a14:	00004597          	auipc	a1,0x4
    80004a18:	c3c58593          	addi	a1,a1,-964 # 80008650 <syscalls+0x2b8>
    80004a1c:	fb040513          	addi	a0,s0,-80
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	648080e7          	jalr	1608(ra) # 80003068 <namecmp>
    80004a28:	14050a63          	beqz	a0,80004b7c <sys_unlink+0x1b0>
    80004a2c:	00004597          	auipc	a1,0x4
    80004a30:	c2c58593          	addi	a1,a1,-980 # 80008658 <syscalls+0x2c0>
    80004a34:	fb040513          	addi	a0,s0,-80
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	630080e7          	jalr	1584(ra) # 80003068 <namecmp>
    80004a40:	12050e63          	beqz	a0,80004b7c <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a44:	f2c40613          	addi	a2,s0,-212
    80004a48:	fb040593          	addi	a1,s0,-80
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	634080e7          	jalr	1588(ra) # 80003082 <dirlookup>
    80004a56:	892a                	mv	s2,a0
    80004a58:	12050263          	beqz	a0,80004b7c <sys_unlink+0x1b0>
  ilock(ip);
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	142080e7          	jalr	322(ra) # 80002b9e <ilock>
  if (ip->nlink < 1)
    80004a64:	04a91783          	lh	a5,74(s2)
    80004a68:	08f05263          	blez	a5,80004aec <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004a6c:	04491703          	lh	a4,68(s2)
    80004a70:	4785                	li	a5,1
    80004a72:	08f70563          	beq	a4,a5,80004afc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a76:	4641                	li	a2,16
    80004a78:	4581                	li	a1,0
    80004a7a:	fc040513          	addi	a0,s0,-64
    80004a7e:	ffffb097          	auipc	ra,0xffffb
    80004a82:	6fa080e7          	jalr	1786(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a86:	4741                	li	a4,16
    80004a88:	f2c42683          	lw	a3,-212(s0)
    80004a8c:	fc040613          	addi	a2,s0,-64
    80004a90:	4581                	li	a1,0
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	4b6080e7          	jalr	1206(ra) # 80002f4a <writei>
    80004a9c:	47c1                	li	a5,16
    80004a9e:	0af51563          	bne	a0,a5,80004b48 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004aa2:	04491703          	lh	a4,68(s2)
    80004aa6:	4785                	li	a5,1
    80004aa8:	0af70863          	beq	a4,a5,80004b58 <sys_unlink+0x18c>
  iunlockput(dp);
    80004aac:	8526                	mv	a0,s1
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	352080e7          	jalr	850(ra) # 80002e00 <iunlockput>
  ip->nlink--;
    80004ab6:	04a95783          	lhu	a5,74(s2)
    80004aba:	37fd                	addiw	a5,a5,-1
    80004abc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	012080e7          	jalr	18(ra) # 80002ad4 <iupdate>
  iunlockput(ip);
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	334080e7          	jalr	820(ra) # 80002e00 <iunlockput>
  end_op();
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	b10080e7          	jalr	-1264(ra) # 800035e4 <end_op>
  return 0;
    80004adc:	4501                	li	a0,0
    80004ade:	a84d                	j	80004b90 <sys_unlink+0x1c4>
    end_op();
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	b04080e7          	jalr	-1276(ra) # 800035e4 <end_op>
    return -1;
    80004ae8:	557d                	li	a0,-1
    80004aea:	a05d                	j	80004b90 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aec:	00004517          	auipc	a0,0x4
    80004af0:	b7450513          	addi	a0,a0,-1164 # 80008660 <syscalls+0x2c8>
    80004af4:	00001097          	auipc	ra,0x1
    80004af8:	4aa080e7          	jalr	1194(ra) # 80005f9e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004afc:	04c92703          	lw	a4,76(s2)
    80004b00:	02000793          	li	a5,32
    80004b04:	f6e7f9e3          	bgeu	a5,a4,80004a76 <sys_unlink+0xaa>
    80004b08:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b0c:	4741                	li	a4,16
    80004b0e:	86ce                	mv	a3,s3
    80004b10:	f1840613          	addi	a2,s0,-232
    80004b14:	4581                	li	a1,0
    80004b16:	854a                	mv	a0,s2
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	33a080e7          	jalr	826(ra) # 80002e52 <readi>
    80004b20:	47c1                	li	a5,16
    80004b22:	00f51b63          	bne	a0,a5,80004b38 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004b26:	f1845783          	lhu	a5,-232(s0)
    80004b2a:	e7a1                	bnez	a5,80004b72 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b2c:	29c1                	addiw	s3,s3,16
    80004b2e:	04c92783          	lw	a5,76(s2)
    80004b32:	fcf9ede3          	bltu	s3,a5,80004b0c <sys_unlink+0x140>
    80004b36:	b781                	j	80004a76 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b38:	00004517          	auipc	a0,0x4
    80004b3c:	b4050513          	addi	a0,a0,-1216 # 80008678 <syscalls+0x2e0>
    80004b40:	00001097          	auipc	ra,0x1
    80004b44:	45e080e7          	jalr	1118(ra) # 80005f9e <panic>
    panic("unlink: writei");
    80004b48:	00004517          	auipc	a0,0x4
    80004b4c:	b4850513          	addi	a0,a0,-1208 # 80008690 <syscalls+0x2f8>
    80004b50:	00001097          	auipc	ra,0x1
    80004b54:	44e080e7          	jalr	1102(ra) # 80005f9e <panic>
    dp->nlink--;
    80004b58:	04a4d783          	lhu	a5,74(s1)
    80004b5c:	37fd                	addiw	a5,a5,-1
    80004b5e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b62:	8526                	mv	a0,s1
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	f70080e7          	jalr	-144(ra) # 80002ad4 <iupdate>
    80004b6c:	b781                	j	80004aac <sys_unlink+0xe0>
    return -1;
    80004b6e:	557d                	li	a0,-1
    80004b70:	a005                	j	80004b90 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b72:	854a                	mv	a0,s2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	28c080e7          	jalr	652(ra) # 80002e00 <iunlockput>
  iunlockput(dp);
    80004b7c:	8526                	mv	a0,s1
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	282080e7          	jalr	642(ra) # 80002e00 <iunlockput>
  end_op();
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	a5e080e7          	jalr	-1442(ra) # 800035e4 <end_op>
  return -1;
    80004b8e:	557d                	li	a0,-1
}
    80004b90:	70ae                	ld	ra,232(sp)
    80004b92:	740e                	ld	s0,224(sp)
    80004b94:	64ee                	ld	s1,216(sp)
    80004b96:	694e                	ld	s2,208(sp)
    80004b98:	69ae                	ld	s3,200(sp)
    80004b9a:	616d                	addi	sp,sp,240
    80004b9c:	8082                	ret

0000000080004b9e <sys_mmap>:
{
    80004b9e:	715d                	addi	sp,sp,-80
    80004ba0:	e486                	sd	ra,72(sp)
    80004ba2:	e0a2                	sd	s0,64(sp)
    80004ba4:	fc26                	sd	s1,56(sp)
    80004ba6:	f84a                	sd	s2,48(sp)
    80004ba8:	f44e                	sd	s3,40(sp)
    80004baa:	f052                	sd	s4,32(sp)
    80004bac:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	28a080e7          	jalr	650(ra) # 80000e38 <myproc>
    80004bb6:	892a                	mv	s2,a0
  argint(1, &length);
    80004bb8:	fcc40593          	addi	a1,s0,-52
    80004bbc:	4505                	li	a0,1
    80004bbe:	ffffd097          	auipc	ra,0xffffd
    80004bc2:	464080e7          	jalr	1124(ra) # 80002022 <argint>
  argint(2, &prot);
    80004bc6:	fc840593          	addi	a1,s0,-56
    80004bca:	4509                	li	a0,2
    80004bcc:	ffffd097          	auipc	ra,0xffffd
    80004bd0:	456080e7          	jalr	1110(ra) # 80002022 <argint>
  argint(3, &flags);
    80004bd4:	fc440593          	addi	a1,s0,-60
    80004bd8:	450d                	li	a0,3
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	448080e7          	jalr	1096(ra) # 80002022 <argint>
  argfd(4, &fd, &mfile);
    80004be2:	fb040613          	addi	a2,s0,-80
    80004be6:	fc040593          	addi	a1,s0,-64
    80004bea:	4511                	li	a0,4
    80004bec:	00000097          	auipc	ra,0x0
    80004bf0:	8d8080e7          	jalr	-1832(ra) # 800044c4 <argfd>
  argint(5, &offset);
    80004bf4:	fbc40593          	addi	a1,s0,-68
    80004bf8:	4515                	li	a0,5
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	428080e7          	jalr	1064(ra) # 80002022 <argint>
  if (length < 0 || prot < 0 || flags < 0 || fd < 0 || offset < 0)
    80004c02:	fcc42603          	lw	a2,-52(s0)
    80004c06:	0c064363          	bltz	a2,80004ccc <sys_mmap+0x12e>
    80004c0a:	fc842583          	lw	a1,-56(s0)
    80004c0e:	0c05c163          	bltz	a1,80004cd0 <sys_mmap+0x132>
    80004c12:	fc442803          	lw	a6,-60(s0)
    80004c16:	0a084f63          	bltz	a6,80004cd4 <sys_mmap+0x136>
    80004c1a:	fc042883          	lw	a7,-64(s0)
    80004c1e:	0a08cd63          	bltz	a7,80004cd8 <sys_mmap+0x13a>
    80004c22:	fbc42303          	lw	t1,-68(s0)
    80004c26:	0a034b63          	bltz	t1,80004cdc <sys_mmap+0x13e>
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004c2a:	fb043e03          	ld	t3,-80(s0)
    80004c2e:	009e4783          	lbu	a5,9(t3)
    80004c32:	e781                	bnez	a5,80004c3a <sys_mmap+0x9c>
    80004c34:	0025f793          	andi	a5,a1,2
    80004c38:	e78d                	bnez	a5,80004c62 <sys_mmap+0xc4>
  while (idx < VMASIZE)
    80004c3a:	17090793          	addi	a5,s2,368
{
    80004c3e:	4481                	li	s1,0
  while (idx < VMASIZE)
    80004c40:	46c1                	li	a3,16
    if (p->vma[idx].length == 0) // free vma
    80004c42:	4398                	lw	a4,0(a5)
    80004c44:	c705                	beqz	a4,80004c6c <sys_mmap+0xce>
    idx++;
    80004c46:	2485                	addiw	s1,s1,1
  while (idx < VMASIZE)
    80004c48:	03078793          	addi	a5,a5,48
    80004c4c:	fed49be3          	bne	s1,a3,80004c42 <sys_mmap+0xa4>
  return -1;
    80004c50:	557d                	li	a0,-1
}
    80004c52:	60a6                	ld	ra,72(sp)
    80004c54:	6406                	ld	s0,64(sp)
    80004c56:	74e2                	ld	s1,56(sp)
    80004c58:	7942                	ld	s2,48(sp)
    80004c5a:	79a2                	ld	s3,40(sp)
    80004c5c:	7a02                	ld	s4,32(sp)
    80004c5e:	6161                	addi	sp,sp,80
    80004c60:	8082                	ret
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004c62:	00187793          	andi	a5,a6,1
    return -1;
    80004c66:	557d                	li	a0,-1
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004c68:	dbe9                	beqz	a5,80004c3a <sys_mmap+0x9c>
    80004c6a:	b7e5                	j	80004c52 <sys_mmap+0xb4>
      p->vma[idx].addr = p->sz;
    80004c6c:	00149a13          	slli	s4,s1,0x1
    80004c70:	009a09b3          	add	s3,s4,s1
    80004c74:	0992                	slli	s3,s3,0x4
    80004c76:	99ca                	add	s3,s3,s2
    80004c78:	04893783          	ld	a5,72(s2)
    80004c7c:	16f9b423          	sd	a5,360(s3)
      p->vma[idx].length = length;
    80004c80:	16c9a823          	sw	a2,368(s3)
      p->vma[idx].prot = prot;
    80004c84:	16b9aa23          	sw	a1,372(s3)
      p->vma[idx].flags = flags;
    80004c88:	1709ac23          	sw	a6,376(s3)
      p->vma[idx].fd = fd;
    80004c8c:	1719ae23          	sw	a7,380(s3)
      p->vma[idx].offset = offset;
    80004c90:	1869a023          	sw	t1,384(s3)
      p->vma[idx].mfile = filedup(mfile); // increment the reference count
    80004c94:	8572                	mv	a0,t3
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	d48080e7          	jalr	-696(ra) # 800039de <filedup>
    80004c9e:	18a9b423          	sd	a0,392(s3)
      p->vma[idx].ip = mfile->ip;
    80004ca2:	fb043783          	ld	a5,-80(s0)
    80004ca6:	6f9c                	ld	a5,24(a5)
    80004ca8:	18f9b823          	sd	a5,400(s3)
      p->sz += PGROUNDUP(length);
    80004cac:	fcc42783          	lw	a5,-52(s0)
    80004cb0:	6705                	lui	a4,0x1
    80004cb2:	377d                	addiw	a4,a4,-1
    80004cb4:	9fb9                	addw	a5,a5,a4
    80004cb6:	777d                	lui	a4,0xfffff
    80004cb8:	8ff9                	and	a5,a5,a4
    80004cba:	2781                	sext.w	a5,a5
    80004cbc:	04893703          	ld	a4,72(s2)
    80004cc0:	97ba                	add	a5,a5,a4
    80004cc2:	04f93423          	sd	a5,72(s2)
      return (uint64)p->vma[idx].addr;
    80004cc6:	1689b503          	ld	a0,360(s3)
    80004cca:	b761                	j	80004c52 <sys_mmap+0xb4>
    return -1;
    80004ccc:	557d                	li	a0,-1
    80004cce:	b751                	j	80004c52 <sys_mmap+0xb4>
    80004cd0:	557d                	li	a0,-1
    80004cd2:	b741                	j	80004c52 <sys_mmap+0xb4>
    80004cd4:	557d                	li	a0,-1
    80004cd6:	bfb5                	j	80004c52 <sys_mmap+0xb4>
    80004cd8:	557d                	li	a0,-1
    80004cda:	bfa5                	j	80004c52 <sys_mmap+0xb4>
    80004cdc:	557d                	li	a0,-1
    80004cde:	bf95                	j	80004c52 <sys_mmap+0xb4>

0000000080004ce0 <sys_munmap>:
{
    80004ce0:	715d                	addi	sp,sp,-80
    80004ce2:	e486                	sd	ra,72(sp)
    80004ce4:	e0a2                	sd	s0,64(sp)
    80004ce6:	fc26                	sd	s1,56(sp)
    80004ce8:	f84a                	sd	s2,48(sp)
    80004cea:	f44e                	sd	s3,40(sp)
    80004cec:	f052                	sd	s4,32(sp)
    80004cee:	ec56                	sd	s5,24(sp)
    80004cf0:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004cf2:	ffffc097          	auipc	ra,0xffffc
    80004cf6:	146080e7          	jalr	326(ra) # 80000e38 <myproc>
    80004cfa:	892a                	mv	s2,a0
  argaddr(0, &va);
    80004cfc:	fb840593          	addi	a1,s0,-72
    80004d00:	4501                	li	a0,0
    80004d02:	ffffd097          	auipc	ra,0xffffd
    80004d06:	340080e7          	jalr	832(ra) # 80002042 <argaddr>
  argint(1, &length);
    80004d0a:	fb440593          	addi	a1,s0,-76
    80004d0e:	4505                	li	a0,1
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	312080e7          	jalr	786(ra) # 80002022 <argint>
  if (va < 0 || length < 0)
    80004d18:	fb442783          	lw	a5,-76(s0)
    80004d1c:	1607cd63          	bltz	a5,80004e96 <sys_munmap+0x1b6>
    if (va >= (uint64)p->vma[i].addr && va < (uint64)p->vma[i].addr + p->sz && p->vma[i].length != 0)
    80004d20:	fb843683          	ld	a3,-72(s0)
    80004d24:	16890793          	addi	a5,s2,360
  for (int i = 0; i < VMASIZE; i++)
    80004d28:	4481                	li	s1,0
    80004d2a:	45c1                	li	a1,16
    80004d2c:	a031                	j	80004d38 <sys_munmap+0x58>
    80004d2e:	2485                	addiw	s1,s1,1
    80004d30:	03078793          	addi	a5,a5,48
    80004d34:	00b48d63          	beq	s1,a1,80004d4e <sys_munmap+0x6e>
    if (va >= (uint64)p->vma[i].addr && va < (uint64)p->vma[i].addr + p->sz && p->vma[i].length != 0)
    80004d38:	6398                	ld	a4,0(a5)
    80004d3a:	fee6eae3          	bltu	a3,a4,80004d2e <sys_munmap+0x4e>
    80004d3e:	04893503          	ld	a0,72(s2)
    80004d42:	972a                	add	a4,a4,a0
    80004d44:	fee6f5e3          	bgeu	a3,a4,80004d2e <sys_munmap+0x4e>
    80004d48:	4798                	lw	a4,8(a5)
    80004d4a:	d375                	beqz	a4,80004d2e <sys_munmap+0x4e>
    80004d4c:	a011                	j	80004d50 <sys_munmap+0x70>
  int idx = 0;
    80004d4e:	4481                	li	s1,0
  struct vma v = p->vma[idx];
    80004d50:	00149793          	slli	a5,s1,0x1
    80004d54:	97a6                	add	a5,a5,s1
    80004d56:	0792                	slli	a5,a5,0x4
    80004d58:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004d5a:	1747a783          	lw	a5,372(a5)
    80004d5e:	8b89                	andi	a5,a5,2
    80004d60:	cb91                	beqz	a5,80004d74 <sys_munmap+0x94>
  struct vma v = p->vma[idx];
    80004d62:	00149793          	slli	a5,s1,0x1
    80004d66:	97a6                	add	a5,a5,s1
    80004d68:	0792                	slli	a5,a5,0x4
    80004d6a:	97ca                	add	a5,a5,s2
  if (v.prot & PROT_WRITE && v.flags & MAP_SHARED)
    80004d6c:	1787a783          	lw	a5,376(a5)
    80004d70:	8b85                	andi	a5,a5,1
    80004d72:	e3c1                	bnez	a5,80004df2 <sys_munmap+0x112>
  uint64 npages = min(p->sz, PGROUNDUP(length)) / PGSIZE;
    80004d74:	fb442603          	lw	a2,-76(s0)
    80004d78:	6785                	lui	a5,0x1
    80004d7a:	37fd                	addiw	a5,a5,-1
    80004d7c:	9e3d                	addw	a2,a2,a5
    80004d7e:	77fd                	lui	a5,0xfffff
    80004d80:	8e7d                	and	a2,a2,a5
    80004d82:	04893783          	ld	a5,72(s2)
    80004d86:	2601                	sext.w	a2,a2
    80004d88:	00c7f363          	bgeu	a5,a2,80004d8e <sys_munmap+0xae>
    80004d8c:	863e                	mv	a2,a5
  uvmunmap(p->pagetable, va, npages, 1);
    80004d8e:	4685                	li	a3,1
    80004d90:	8231                	srli	a2,a2,0xc
    80004d92:	fb843583          	ld	a1,-72(s0)
    80004d96:	05093503          	ld	a0,80(s2)
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	970080e7          	jalr	-1680(ra) # 8000070a <uvmunmap>
  v.length -= length;
    80004da2:	fb442683          	lw	a3,-76(s0)
  va += length;
    80004da6:	fb843783          	ld	a5,-72(s0)
    80004daa:	97b6                	add	a5,a5,a3
    80004dac:	faf43c23          	sd	a5,-72(s0)
  p->vma[idx].addr += length;
    80004db0:	00149793          	slli	a5,s1,0x1
    80004db4:	97a6                	add	a5,a5,s1
    80004db6:	0792                	slli	a5,a5,0x4
    80004db8:	97ca                	add	a5,a5,s2
    80004dba:	1687b703          	ld	a4,360(a5) # fffffffffffff168 <end+0xffffffff7ffd1438>
    80004dbe:	9736                	add	a4,a4,a3
    80004dc0:	16e7b423          	sd	a4,360(a5)
  p->vma[idx].offset += length;
    80004dc4:	1807a703          	lw	a4,384(a5)
    80004dc8:	9f35                	addw	a4,a4,a3
    80004dca:	18e7a023          	sw	a4,384(a5)
  p->vma[idx].length -= length;
    80004dce:	1707a703          	lw	a4,368(a5)
    80004dd2:	9f15                	subw	a4,a4,a3
    80004dd4:	0007069b          	sext.w	a3,a4
    80004dd8:	16e7a823          	sw	a4,368(a5)
  return 0;
    80004ddc:	4501                	li	a0,0
  if (p->vma[idx].length == 0)
    80004dde:	ced9                	beqz	a3,80004e7c <sys_munmap+0x19c>
}
    80004de0:	60a6                	ld	ra,72(sp)
    80004de2:	6406                	ld	s0,64(sp)
    80004de4:	74e2                	ld	s1,56(sp)
    80004de6:	7942                	ld	s2,48(sp)
    80004de8:	79a2                	ld	s3,40(sp)
    80004dea:	7a02                	ld	s4,32(sp)
    80004dec:	6ae2                	ld	s5,24(sp)
    80004dee:	6161                	addi	sp,sp,80
    80004df0:	8082                	ret
  struct vma v = p->vma[idx];
    80004df2:	00149793          	slli	a5,s1,0x1
    80004df6:	97a6                	add	a5,a5,s1
    80004df8:	0792                	slli	a5,a5,0x4
    80004dfa:	97ca                	add	a5,a5,s2
    80004dfc:	1687ba03          	ld	s4,360(a5)
    80004e00:	1807aa83          	lw	s5,384(a5)
    80004e04:	1907b983          	ld	s3,400(a5)
    begin_op();
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	75c080e7          	jalr	1884(ra) # 80003564 <begin_op>
    ilock(v.ip);
    80004e10:	854e                	mv	a0,s3
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	d8c080e7          	jalr	-628(ra) # 80002b9e <ilock>
    printf("sys_munmap(): off %d\n", va - (uint64)v.addr);
    80004e1a:	fb843583          	ld	a1,-72(s0)
    80004e1e:	414585b3          	sub	a1,a1,s4
    80004e22:	00004517          	auipc	a0,0x4
    80004e26:	87e50513          	addi	a0,a0,-1922 # 800086a0 <syscalls+0x308>
    80004e2a:	00001097          	auipc	ra,0x1
    80004e2e:	1be080e7          	jalr	446(ra) # 80005fe8 <printf>
    writei(v.ip, 1, (uint64)v.addr, va - (uint64)v.addr + v.offset, min(p->sz, PGROUNDUP(length))); // fix
    80004e32:	fb442703          	lw	a4,-76(s0)
    80004e36:	6785                	lui	a5,0x1
    80004e38:	37fd                	addiw	a5,a5,-1
    80004e3a:	9f3d                	addw	a4,a4,a5
    80004e3c:	77fd                	lui	a5,0xfffff
    80004e3e:	8f7d                	and	a4,a4,a5
    80004e40:	04893783          	ld	a5,72(s2)
    80004e44:	2701                	sext.w	a4,a4
    80004e46:	00e7f363          	bgeu	a5,a4,80004e4c <sys_munmap+0x16c>
    80004e4a:	873e                	mv	a4,a5
    80004e4c:	fb843683          	ld	a3,-72(s0)
    80004e50:	015686bb          	addw	a3,a3,s5
    80004e54:	2701                	sext.w	a4,a4
    80004e56:	414686bb          	subw	a3,a3,s4
    80004e5a:	8652                	mv	a2,s4
    80004e5c:	4585                	li	a1,1
    80004e5e:	854e                	mv	a0,s3
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	0ea080e7          	jalr	234(ra) # 80002f4a <writei>
    iunlock(v.ip);
    80004e68:	854e                	mv	a0,s3
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	df6080e7          	jalr	-522(ra) # 80002c60 <iunlock>
    end_op();
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	772080e7          	jalr	1906(ra) # 800035e4 <end_op>
    80004e7a:	bded                	j	80004d74 <sys_munmap+0x94>
    fileclose(p->vma[idx].mfile);
    80004e7c:	00149793          	slli	a5,s1,0x1
    80004e80:	94be                	add	s1,s1,a5
    80004e82:	0492                	slli	s1,s1,0x4
    80004e84:	9926                	add	s2,s2,s1
    80004e86:	18893503          	ld	a0,392(s2)
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	ba6080e7          	jalr	-1114(ra) # 80003a30 <fileclose>
  return 0;
    80004e92:	4501                	li	a0,0
    80004e94:	b7b1                	j	80004de0 <sys_munmap+0x100>
    return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	b7a1                	j	80004de0 <sys_munmap+0x100>

0000000080004e9a <sys_open>:

uint64
sys_open(void)
{
    80004e9a:	7131                	addi	sp,sp,-192
    80004e9c:	fd06                	sd	ra,184(sp)
    80004e9e:	f922                	sd	s0,176(sp)
    80004ea0:	f526                	sd	s1,168(sp)
    80004ea2:	f14a                	sd	s2,160(sp)
    80004ea4:	ed4e                	sd	s3,152(sp)
    80004ea6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ea8:	f4c40593          	addi	a1,s0,-180
    80004eac:	4505                	li	a0,1
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	174080e7          	jalr	372(ra) # 80002022 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004eb6:	08000613          	li	a2,128
    80004eba:	f5040593          	addi	a1,s0,-176
    80004ebe:	4501                	li	a0,0
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	1a2080e7          	jalr	418(ra) # 80002062 <argstr>
    80004ec8:	87aa                	mv	a5,a0
    return -1;
    80004eca:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004ecc:	0a07c963          	bltz	a5,80004f7e <sys_open+0xe4>

  begin_op();
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	694080e7          	jalr	1684(ra) # 80003564 <begin_op>

  if (omode & O_CREATE)
    80004ed8:	f4c42783          	lw	a5,-180(s0)
    80004edc:	2007f793          	andi	a5,a5,512
    80004ee0:	cfc5                	beqz	a5,80004f98 <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004ee2:	4681                	li	a3,0
    80004ee4:	4601                	li	a2,0
    80004ee6:	4589                	li	a1,2
    80004ee8:	f5040513          	addi	a0,s0,-176
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	67a080e7          	jalr	1658(ra) # 80004566 <create>
    80004ef4:	84aa                	mv	s1,a0
    if (ip == 0)
    80004ef6:	c959                	beqz	a0,80004f8c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004ef8:	04449703          	lh	a4,68(s1)
    80004efc:	478d                	li	a5,3
    80004efe:	00f71763          	bne	a4,a5,80004f0c <sys_open+0x72>
    80004f02:	0464d703          	lhu	a4,70(s1)
    80004f06:	47a5                	li	a5,9
    80004f08:	0ce7ed63          	bltu	a5,a4,80004fe2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	a68080e7          	jalr	-1432(ra) # 80003974 <filealloc>
    80004f14:	89aa                	mv	s3,a0
    80004f16:	10050363          	beqz	a0,8000501c <sys_open+0x182>
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	60a080e7          	jalr	1546(ra) # 80004524 <fdalloc>
    80004f22:	892a                	mv	s2,a0
    80004f24:	0e054763          	bltz	a0,80005012 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004f28:	04449703          	lh	a4,68(s1)
    80004f2c:	478d                	li	a5,3
    80004f2e:	0cf70563          	beq	a4,a5,80004ff8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004f32:	4789                	li	a5,2
    80004f34:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f38:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f3c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f40:	f4c42783          	lw	a5,-180(s0)
    80004f44:	0017c713          	xori	a4,a5,1
    80004f48:	8b05                	andi	a4,a4,1
    80004f4a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f4e:	0037f713          	andi	a4,a5,3
    80004f52:	00e03733          	snez	a4,a4
    80004f56:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004f5a:	4007f793          	andi	a5,a5,1024
    80004f5e:	c791                	beqz	a5,80004f6a <sys_open+0xd0>
    80004f60:	04449703          	lh	a4,68(s1)
    80004f64:	4789                	li	a5,2
    80004f66:	0af70063          	beq	a4,a5,80005006 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004f6a:	8526                	mv	a0,s1
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	cf4080e7          	jalr	-780(ra) # 80002c60 <iunlock>
  end_op();
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	670080e7          	jalr	1648(ra) # 800035e4 <end_op>

  return fd;
    80004f7c:	854a                	mv	a0,s2
}
    80004f7e:	70ea                	ld	ra,184(sp)
    80004f80:	744a                	ld	s0,176(sp)
    80004f82:	74aa                	ld	s1,168(sp)
    80004f84:	790a                	ld	s2,160(sp)
    80004f86:	69ea                	ld	s3,152(sp)
    80004f88:	6129                	addi	sp,sp,192
    80004f8a:	8082                	ret
      end_op();
    80004f8c:	ffffe097          	auipc	ra,0xffffe
    80004f90:	658080e7          	jalr	1624(ra) # 800035e4 <end_op>
      return -1;
    80004f94:	557d                	li	a0,-1
    80004f96:	b7e5                	j	80004f7e <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004f98:	f5040513          	addi	a0,s0,-176
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	3a8080e7          	jalr	936(ra) # 80003344 <namei>
    80004fa4:	84aa                	mv	s1,a0
    80004fa6:	c905                	beqz	a0,80004fd6 <sys_open+0x13c>
    ilock(ip);
    80004fa8:	ffffe097          	auipc	ra,0xffffe
    80004fac:	bf6080e7          	jalr	-1034(ra) # 80002b9e <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004fb0:	04449703          	lh	a4,68(s1)
    80004fb4:	4785                	li	a5,1
    80004fb6:	f4f711e3          	bne	a4,a5,80004ef8 <sys_open+0x5e>
    80004fba:	f4c42783          	lw	a5,-180(s0)
    80004fbe:	d7b9                	beqz	a5,80004f0c <sys_open+0x72>
      iunlockput(ip);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	e3e080e7          	jalr	-450(ra) # 80002e00 <iunlockput>
      end_op();
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	61a080e7          	jalr	1562(ra) # 800035e4 <end_op>
      return -1;
    80004fd2:	557d                	li	a0,-1
    80004fd4:	b76d                	j	80004f7e <sys_open+0xe4>
      end_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	60e080e7          	jalr	1550(ra) # 800035e4 <end_op>
      return -1;
    80004fde:	557d                	li	a0,-1
    80004fe0:	bf79                	j	80004f7e <sys_open+0xe4>
    iunlockput(ip);
    80004fe2:	8526                	mv	a0,s1
    80004fe4:	ffffe097          	auipc	ra,0xffffe
    80004fe8:	e1c080e7          	jalr	-484(ra) # 80002e00 <iunlockput>
    end_op();
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	5f8080e7          	jalr	1528(ra) # 800035e4 <end_op>
    return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	b761                	j	80004f7e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ff8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ffc:	04649783          	lh	a5,70(s1)
    80005000:	02f99223          	sh	a5,36(s3)
    80005004:	bf25                	j	80004f3c <sys_open+0xa2>
    itrunc(ip);
    80005006:	8526                	mv	a0,s1
    80005008:	ffffe097          	auipc	ra,0xffffe
    8000500c:	ca4080e7          	jalr	-860(ra) # 80002cac <itrunc>
    80005010:	bfa9                	j	80004f6a <sys_open+0xd0>
      fileclose(f);
    80005012:	854e                	mv	a0,s3
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	a1c080e7          	jalr	-1508(ra) # 80003a30 <fileclose>
    iunlockput(ip);
    8000501c:	8526                	mv	a0,s1
    8000501e:	ffffe097          	auipc	ra,0xffffe
    80005022:	de2080e7          	jalr	-542(ra) # 80002e00 <iunlockput>
    end_op();
    80005026:	ffffe097          	auipc	ra,0xffffe
    8000502a:	5be080e7          	jalr	1470(ra) # 800035e4 <end_op>
    return -1;
    8000502e:	557d                	li	a0,-1
    80005030:	b7b9                	j	80004f7e <sys_open+0xe4>

0000000080005032 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005032:	7175                	addi	sp,sp,-144
    80005034:	e506                	sd	ra,136(sp)
    80005036:	e122                	sd	s0,128(sp)
    80005038:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	52a080e7          	jalr	1322(ra) # 80003564 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005042:	08000613          	li	a2,128
    80005046:	f7040593          	addi	a1,s0,-144
    8000504a:	4501                	li	a0,0
    8000504c:	ffffd097          	auipc	ra,0xffffd
    80005050:	016080e7          	jalr	22(ra) # 80002062 <argstr>
    80005054:	02054963          	bltz	a0,80005086 <sys_mkdir+0x54>
    80005058:	4681                	li	a3,0
    8000505a:	4601                	li	a2,0
    8000505c:	4585                	li	a1,1
    8000505e:	f7040513          	addi	a0,s0,-144
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	504080e7          	jalr	1284(ra) # 80004566 <create>
    8000506a:	cd11                	beqz	a0,80005086 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	d94080e7          	jalr	-620(ra) # 80002e00 <iunlockput>
  end_op();
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	570080e7          	jalr	1392(ra) # 800035e4 <end_op>
  return 0;
    8000507c:	4501                	li	a0,0
}
    8000507e:	60aa                	ld	ra,136(sp)
    80005080:	640a                	ld	s0,128(sp)
    80005082:	6149                	addi	sp,sp,144
    80005084:	8082                	ret
    end_op();
    80005086:	ffffe097          	auipc	ra,0xffffe
    8000508a:	55e080e7          	jalr	1374(ra) # 800035e4 <end_op>
    return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	b7fd                	j	8000507e <sys_mkdir+0x4c>

0000000080005092 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005092:	7135                	addi	sp,sp,-160
    80005094:	ed06                	sd	ra,152(sp)
    80005096:	e922                	sd	s0,144(sp)
    80005098:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	4ca080e7          	jalr	1226(ra) # 80003564 <begin_op>
  argint(1, &major);
    800050a2:	f6c40593          	addi	a1,s0,-148
    800050a6:	4505                	li	a0,1
    800050a8:	ffffd097          	auipc	ra,0xffffd
    800050ac:	f7a080e7          	jalr	-134(ra) # 80002022 <argint>
  argint(2, &minor);
    800050b0:	f6840593          	addi	a1,s0,-152
    800050b4:	4509                	li	a0,2
    800050b6:	ffffd097          	auipc	ra,0xffffd
    800050ba:	f6c080e7          	jalr	-148(ra) # 80002022 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800050be:	08000613          	li	a2,128
    800050c2:	f7040593          	addi	a1,s0,-144
    800050c6:	4501                	li	a0,0
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	f9a080e7          	jalr	-102(ra) # 80002062 <argstr>
    800050d0:	02054b63          	bltz	a0,80005106 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    800050d4:	f6841683          	lh	a3,-152(s0)
    800050d8:	f6c41603          	lh	a2,-148(s0)
    800050dc:	458d                	li	a1,3
    800050de:	f7040513          	addi	a0,s0,-144
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	484080e7          	jalr	1156(ra) # 80004566 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800050ea:	cd11                	beqz	a0,80005106 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	d14080e7          	jalr	-748(ra) # 80002e00 <iunlockput>
  end_op();
    800050f4:	ffffe097          	auipc	ra,0xffffe
    800050f8:	4f0080e7          	jalr	1264(ra) # 800035e4 <end_op>
  return 0;
    800050fc:	4501                	li	a0,0
}
    800050fe:	60ea                	ld	ra,152(sp)
    80005100:	644a                	ld	s0,144(sp)
    80005102:	610d                	addi	sp,sp,160
    80005104:	8082                	ret
    end_op();
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	4de080e7          	jalr	1246(ra) # 800035e4 <end_op>
    return -1;
    8000510e:	557d                	li	a0,-1
    80005110:	b7fd                	j	800050fe <sys_mknod+0x6c>

0000000080005112 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005112:	7135                	addi	sp,sp,-160
    80005114:	ed06                	sd	ra,152(sp)
    80005116:	e922                	sd	s0,144(sp)
    80005118:	e526                	sd	s1,136(sp)
    8000511a:	e14a                	sd	s2,128(sp)
    8000511c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	d1a080e7          	jalr	-742(ra) # 80000e38 <myproc>
    80005126:	892a                	mv	s2,a0

  begin_op();
    80005128:	ffffe097          	auipc	ra,0xffffe
    8000512c:	43c080e7          	jalr	1084(ra) # 80003564 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005130:	08000613          	li	a2,128
    80005134:	f6040593          	addi	a1,s0,-160
    80005138:	4501                	li	a0,0
    8000513a:	ffffd097          	auipc	ra,0xffffd
    8000513e:	f28080e7          	jalr	-216(ra) # 80002062 <argstr>
    80005142:	04054b63          	bltz	a0,80005198 <sys_chdir+0x86>
    80005146:	f6040513          	addi	a0,s0,-160
    8000514a:	ffffe097          	auipc	ra,0xffffe
    8000514e:	1fa080e7          	jalr	506(ra) # 80003344 <namei>
    80005152:	84aa                	mv	s1,a0
    80005154:	c131                	beqz	a0,80005198 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	a48080e7          	jalr	-1464(ra) # 80002b9e <ilock>
  if (ip->type != T_DIR)
    8000515e:	04449703          	lh	a4,68(s1)
    80005162:	4785                	li	a5,1
    80005164:	04f71063          	bne	a4,a5,800051a4 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005168:	8526                	mv	a0,s1
    8000516a:	ffffe097          	auipc	ra,0xffffe
    8000516e:	af6080e7          	jalr	-1290(ra) # 80002c60 <iunlock>
  iput(p->cwd);
    80005172:	15093503          	ld	a0,336(s2)
    80005176:	ffffe097          	auipc	ra,0xffffe
    8000517a:	be2080e7          	jalr	-1054(ra) # 80002d58 <iput>
  end_op();
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	466080e7          	jalr	1126(ra) # 800035e4 <end_op>
  p->cwd = ip;
    80005186:	14993823          	sd	s1,336(s2)
  return 0;
    8000518a:	4501                	li	a0,0
}
    8000518c:	60ea                	ld	ra,152(sp)
    8000518e:	644a                	ld	s0,144(sp)
    80005190:	64aa                	ld	s1,136(sp)
    80005192:	690a                	ld	s2,128(sp)
    80005194:	610d                	addi	sp,sp,160
    80005196:	8082                	ret
    end_op();
    80005198:	ffffe097          	auipc	ra,0xffffe
    8000519c:	44c080e7          	jalr	1100(ra) # 800035e4 <end_op>
    return -1;
    800051a0:	557d                	li	a0,-1
    800051a2:	b7ed                	j	8000518c <sys_chdir+0x7a>
    iunlockput(ip);
    800051a4:	8526                	mv	a0,s1
    800051a6:	ffffe097          	auipc	ra,0xffffe
    800051aa:	c5a080e7          	jalr	-934(ra) # 80002e00 <iunlockput>
    end_op();
    800051ae:	ffffe097          	auipc	ra,0xffffe
    800051b2:	436080e7          	jalr	1078(ra) # 800035e4 <end_op>
    return -1;
    800051b6:	557d                	li	a0,-1
    800051b8:	bfd1                	j	8000518c <sys_chdir+0x7a>

00000000800051ba <sys_exec>:

uint64
sys_exec(void)
{
    800051ba:	7145                	addi	sp,sp,-464
    800051bc:	e786                	sd	ra,456(sp)
    800051be:	e3a2                	sd	s0,448(sp)
    800051c0:	ff26                	sd	s1,440(sp)
    800051c2:	fb4a                	sd	s2,432(sp)
    800051c4:	f74e                	sd	s3,424(sp)
    800051c6:	f352                	sd	s4,416(sp)
    800051c8:	ef56                	sd	s5,408(sp)
    800051ca:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051cc:	e3840593          	addi	a1,s0,-456
    800051d0:	4505                	li	a0,1
    800051d2:	ffffd097          	auipc	ra,0xffffd
    800051d6:	e70080e7          	jalr	-400(ra) # 80002042 <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    800051da:	08000613          	li	a2,128
    800051de:	f4040593          	addi	a1,s0,-192
    800051e2:	4501                	li	a0,0
    800051e4:	ffffd097          	auipc	ra,0xffffd
    800051e8:	e7e080e7          	jalr	-386(ra) # 80002062 <argstr>
    800051ec:	87aa                	mv	a5,a0
  {
    return -1;
    800051ee:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    800051f0:	0c07c263          	bltz	a5,800052b4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800051f4:	10000613          	li	a2,256
    800051f8:	4581                	li	a1,0
    800051fa:	e4040513          	addi	a0,s0,-448
    800051fe:	ffffb097          	auipc	ra,0xffffb
    80005202:	f7a080e7          	jalr	-134(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80005206:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000520a:	89a6                	mv	s3,s1
    8000520c:	4901                	li	s2,0
    if (i >= NELEM(argv))
    8000520e:	02000a13          	li	s4,32
    80005212:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005216:	00391793          	slli	a5,s2,0x3
    8000521a:	e3040593          	addi	a1,s0,-464
    8000521e:	e3843503          	ld	a0,-456(s0)
    80005222:	953e                	add	a0,a0,a5
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	d60080e7          	jalr	-672(ra) # 80001f84 <fetchaddr>
    8000522c:	02054a63          	bltz	a0,80005260 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80005230:	e3043783          	ld	a5,-464(s0)
    80005234:	c3b9                	beqz	a5,8000527a <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005236:	ffffb097          	auipc	ra,0xffffb
    8000523a:	ee2080e7          	jalr	-286(ra) # 80000118 <kalloc>
    8000523e:	85aa                	mv	a1,a0
    80005240:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005244:	cd11                	beqz	a0,80005260 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005246:	6605                	lui	a2,0x1
    80005248:	e3043503          	ld	a0,-464(s0)
    8000524c:	ffffd097          	auipc	ra,0xffffd
    80005250:	d8a080e7          	jalr	-630(ra) # 80001fd6 <fetchstr>
    80005254:	00054663          	bltz	a0,80005260 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    80005258:	0905                	addi	s2,s2,1
    8000525a:	09a1                	addi	s3,s3,8
    8000525c:	fb491be3          	bne	s2,s4,80005212 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005260:	10048913          	addi	s2,s1,256
    80005264:	6088                	ld	a0,0(s1)
    80005266:	c531                	beqz	a0,800052b2 <sys_exec+0xf8>
    kfree(argv[i]);
    80005268:	ffffb097          	auipc	ra,0xffffb
    8000526c:	db4080e7          	jalr	-588(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005270:	04a1                	addi	s1,s1,8
    80005272:	ff2499e3          	bne	s1,s2,80005264 <sys_exec+0xaa>
  return -1;
    80005276:	557d                	li	a0,-1
    80005278:	a835                	j	800052b4 <sys_exec+0xfa>
      argv[i] = 0;
    8000527a:	0a8e                	slli	s5,s5,0x3
    8000527c:	fc040793          	addi	a5,s0,-64
    80005280:	9abe                	add	s5,s5,a5
    80005282:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005286:	e4040593          	addi	a1,s0,-448
    8000528a:	f4040513          	addi	a0,s0,-192
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	e76080e7          	jalr	-394(ra) # 80004104 <exec>
    80005296:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005298:	10048993          	addi	s3,s1,256
    8000529c:	6088                	ld	a0,0(s1)
    8000529e:	c901                	beqz	a0,800052ae <sys_exec+0xf4>
    kfree(argv[i]);
    800052a0:	ffffb097          	auipc	ra,0xffffb
    800052a4:	d7c080e7          	jalr	-644(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052a8:	04a1                	addi	s1,s1,8
    800052aa:	ff3499e3          	bne	s1,s3,8000529c <sys_exec+0xe2>
  return ret;
    800052ae:	854a                	mv	a0,s2
    800052b0:	a011                	j	800052b4 <sys_exec+0xfa>
  return -1;
    800052b2:	557d                	li	a0,-1
}
    800052b4:	60be                	ld	ra,456(sp)
    800052b6:	641e                	ld	s0,448(sp)
    800052b8:	74fa                	ld	s1,440(sp)
    800052ba:	795a                	ld	s2,432(sp)
    800052bc:	79ba                	ld	s3,424(sp)
    800052be:	7a1a                	ld	s4,416(sp)
    800052c0:	6afa                	ld	s5,408(sp)
    800052c2:	6179                	addi	sp,sp,464
    800052c4:	8082                	ret

00000000800052c6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052c6:	7139                	addi	sp,sp,-64
    800052c8:	fc06                	sd	ra,56(sp)
    800052ca:	f822                	sd	s0,48(sp)
    800052cc:	f426                	sd	s1,40(sp)
    800052ce:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052d0:	ffffc097          	auipc	ra,0xffffc
    800052d4:	b68080e7          	jalr	-1176(ra) # 80000e38 <myproc>
    800052d8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052da:	fd840593          	addi	a1,s0,-40
    800052de:	4501                	li	a0,0
    800052e0:	ffffd097          	auipc	ra,0xffffd
    800052e4:	d62080e7          	jalr	-670(ra) # 80002042 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800052e8:	fc840593          	addi	a1,s0,-56
    800052ec:	fd040513          	addi	a0,s0,-48
    800052f0:	fffff097          	auipc	ra,0xfffff
    800052f4:	aca080e7          	jalr	-1334(ra) # 80003dba <pipealloc>
    return -1;
    800052f8:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    800052fa:	0c054463          	bltz	a0,800053c2 <sys_pipe+0xfc>
  fd0 = -1;
    800052fe:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005302:	fd043503          	ld	a0,-48(s0)
    80005306:	fffff097          	auipc	ra,0xfffff
    8000530a:	21e080e7          	jalr	542(ra) # 80004524 <fdalloc>
    8000530e:	fca42223          	sw	a0,-60(s0)
    80005312:	08054b63          	bltz	a0,800053a8 <sys_pipe+0xe2>
    80005316:	fc843503          	ld	a0,-56(s0)
    8000531a:	fffff097          	auipc	ra,0xfffff
    8000531e:	20a080e7          	jalr	522(ra) # 80004524 <fdalloc>
    80005322:	fca42023          	sw	a0,-64(s0)
    80005326:	06054863          	bltz	a0,80005396 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000532a:	4691                	li	a3,4
    8000532c:	fc440613          	addi	a2,s0,-60
    80005330:	fd843583          	ld	a1,-40(s0)
    80005334:	68a8                	ld	a0,80(s1)
    80005336:	ffffb097          	auipc	ra,0xffffb
    8000533a:	7be080e7          	jalr	1982(ra) # 80000af4 <copyout>
    8000533e:	02054063          	bltz	a0,8000535e <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80005342:	4691                	li	a3,4
    80005344:	fc040613          	addi	a2,s0,-64
    80005348:	fd843583          	ld	a1,-40(s0)
    8000534c:	0591                	addi	a1,a1,4
    8000534e:	68a8                	ld	a0,80(s1)
    80005350:	ffffb097          	auipc	ra,0xffffb
    80005354:	7a4080e7          	jalr	1956(ra) # 80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005358:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000535a:	06055463          	bgez	a0,800053c2 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000535e:	fc442783          	lw	a5,-60(s0)
    80005362:	07e9                	addi	a5,a5,26
    80005364:	078e                	slli	a5,a5,0x3
    80005366:	97a6                	add	a5,a5,s1
    80005368:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd12d0>
    p->ofile[fd1] = 0;
    8000536c:	fc042503          	lw	a0,-64(s0)
    80005370:	0569                	addi	a0,a0,26
    80005372:	050e                	slli	a0,a0,0x3
    80005374:	94aa                	add	s1,s1,a0
    80005376:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000537a:	fd043503          	ld	a0,-48(s0)
    8000537e:	ffffe097          	auipc	ra,0xffffe
    80005382:	6b2080e7          	jalr	1714(ra) # 80003a30 <fileclose>
    fileclose(wf);
    80005386:	fc843503          	ld	a0,-56(s0)
    8000538a:	ffffe097          	auipc	ra,0xffffe
    8000538e:	6a6080e7          	jalr	1702(ra) # 80003a30 <fileclose>
    return -1;
    80005392:	57fd                	li	a5,-1
    80005394:	a03d                	j	800053c2 <sys_pipe+0xfc>
    if (fd0 >= 0)
    80005396:	fc442783          	lw	a5,-60(s0)
    8000539a:	0007c763          	bltz	a5,800053a8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000539e:	07e9                	addi	a5,a5,26
    800053a0:	078e                	slli	a5,a5,0x3
    800053a2:	94be                	add	s1,s1,a5
    800053a4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800053a8:	fd043503          	ld	a0,-48(s0)
    800053ac:	ffffe097          	auipc	ra,0xffffe
    800053b0:	684080e7          	jalr	1668(ra) # 80003a30 <fileclose>
    fileclose(wf);
    800053b4:	fc843503          	ld	a0,-56(s0)
    800053b8:	ffffe097          	auipc	ra,0xffffe
    800053bc:	678080e7          	jalr	1656(ra) # 80003a30 <fileclose>
    return -1;
    800053c0:	57fd                	li	a5,-1
}
    800053c2:	853e                	mv	a0,a5
    800053c4:	70e2                	ld	ra,56(sp)
    800053c6:	7442                	ld	s0,48(sp)
    800053c8:	74a2                	ld	s1,40(sp)
    800053ca:	6121                	addi	sp,sp,64
    800053cc:	8082                	ret
	...

00000000800053d0 <kernelvec>:
    800053d0:	7111                	addi	sp,sp,-256
    800053d2:	e006                	sd	ra,0(sp)
    800053d4:	e40a                	sd	sp,8(sp)
    800053d6:	e80e                	sd	gp,16(sp)
    800053d8:	ec12                	sd	tp,24(sp)
    800053da:	f016                	sd	t0,32(sp)
    800053dc:	f41a                	sd	t1,40(sp)
    800053de:	f81e                	sd	t2,48(sp)
    800053e0:	fc22                	sd	s0,56(sp)
    800053e2:	e0a6                	sd	s1,64(sp)
    800053e4:	e4aa                	sd	a0,72(sp)
    800053e6:	e8ae                	sd	a1,80(sp)
    800053e8:	ecb2                	sd	a2,88(sp)
    800053ea:	f0b6                	sd	a3,96(sp)
    800053ec:	f4ba                	sd	a4,104(sp)
    800053ee:	f8be                	sd	a5,112(sp)
    800053f0:	fcc2                	sd	a6,120(sp)
    800053f2:	e146                	sd	a7,128(sp)
    800053f4:	e54a                	sd	s2,136(sp)
    800053f6:	e94e                	sd	s3,144(sp)
    800053f8:	ed52                	sd	s4,152(sp)
    800053fa:	f156                	sd	s5,160(sp)
    800053fc:	f55a                	sd	s6,168(sp)
    800053fe:	f95e                	sd	s7,176(sp)
    80005400:	fd62                	sd	s8,184(sp)
    80005402:	e1e6                	sd	s9,192(sp)
    80005404:	e5ea                	sd	s10,200(sp)
    80005406:	e9ee                	sd	s11,208(sp)
    80005408:	edf2                	sd	t3,216(sp)
    8000540a:	f1f6                	sd	t4,224(sp)
    8000540c:	f5fa                	sd	t5,232(sp)
    8000540e:	f9fe                	sd	t6,240(sp)
    80005410:	a41fc0ef          	jal	ra,80001e50 <kerneltrap>
    80005414:	6082                	ld	ra,0(sp)
    80005416:	6122                	ld	sp,8(sp)
    80005418:	61c2                	ld	gp,16(sp)
    8000541a:	7282                	ld	t0,32(sp)
    8000541c:	7322                	ld	t1,40(sp)
    8000541e:	73c2                	ld	t2,48(sp)
    80005420:	7462                	ld	s0,56(sp)
    80005422:	6486                	ld	s1,64(sp)
    80005424:	6526                	ld	a0,72(sp)
    80005426:	65c6                	ld	a1,80(sp)
    80005428:	6666                	ld	a2,88(sp)
    8000542a:	7686                	ld	a3,96(sp)
    8000542c:	7726                	ld	a4,104(sp)
    8000542e:	77c6                	ld	a5,112(sp)
    80005430:	7866                	ld	a6,120(sp)
    80005432:	688a                	ld	a7,128(sp)
    80005434:	692a                	ld	s2,136(sp)
    80005436:	69ca                	ld	s3,144(sp)
    80005438:	6a6a                	ld	s4,152(sp)
    8000543a:	7a8a                	ld	s5,160(sp)
    8000543c:	7b2a                	ld	s6,168(sp)
    8000543e:	7bca                	ld	s7,176(sp)
    80005440:	7c6a                	ld	s8,184(sp)
    80005442:	6c8e                	ld	s9,192(sp)
    80005444:	6d2e                	ld	s10,200(sp)
    80005446:	6dce                	ld	s11,208(sp)
    80005448:	6e6e                	ld	t3,216(sp)
    8000544a:	7e8e                	ld	t4,224(sp)
    8000544c:	7f2e                	ld	t5,232(sp)
    8000544e:	7fce                	ld	t6,240(sp)
    80005450:	6111                	addi	sp,sp,256
    80005452:	10200073          	sret
    80005456:	00000013          	nop
    8000545a:	00000013          	nop
    8000545e:	0001                	nop

0000000080005460 <timervec>:
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	e10c                	sd	a1,0(a0)
    80005466:	e510                	sd	a2,8(a0)
    80005468:	e914                	sd	a3,16(a0)
    8000546a:	6d0c                	ld	a1,24(a0)
    8000546c:	7110                	ld	a2,32(a0)
    8000546e:	6194                	ld	a3,0(a1)
    80005470:	96b2                	add	a3,a3,a2
    80005472:	e194                	sd	a3,0(a1)
    80005474:	4589                	li	a1,2
    80005476:	14459073          	csrw	sip,a1
    8000547a:	6914                	ld	a3,16(a0)
    8000547c:	6510                	ld	a2,8(a0)
    8000547e:	610c                	ld	a1,0(a0)
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	30200073          	mret
	...

000000008000548a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000548a:	1141                	addi	sp,sp,-16
    8000548c:	e422                	sd	s0,8(sp)
    8000548e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005490:	0c0007b7          	lui	a5,0xc000
    80005494:	4705                	li	a4,1
    80005496:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005498:	c3d8                	sw	a4,4(a5)
}
    8000549a:	6422                	ld	s0,8(sp)
    8000549c:	0141                	addi	sp,sp,16
    8000549e:	8082                	ret

00000000800054a0 <plicinithart>:

void
plicinithart(void)
{
    800054a0:	1141                	addi	sp,sp,-16
    800054a2:	e406                	sd	ra,8(sp)
    800054a4:	e022                	sd	s0,0(sp)
    800054a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a8:	ffffc097          	auipc	ra,0xffffc
    800054ac:	964080e7          	jalr	-1692(ra) # 80000e0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054b0:	0085171b          	slliw	a4,a0,0x8
    800054b4:	0c0027b7          	lui	a5,0xc002
    800054b8:	97ba                	add	a5,a5,a4
    800054ba:	40200713          	li	a4,1026
    800054be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054c2:	00d5151b          	slliw	a0,a0,0xd
    800054c6:	0c2017b7          	lui	a5,0xc201
    800054ca:	953e                	add	a0,a0,a5
    800054cc:	00052023          	sw	zero,0(a0)
}
    800054d0:	60a2                	ld	ra,8(sp)
    800054d2:	6402                	ld	s0,0(sp)
    800054d4:	0141                	addi	sp,sp,16
    800054d6:	8082                	ret

00000000800054d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054d8:	1141                	addi	sp,sp,-16
    800054da:	e406                	sd	ra,8(sp)
    800054dc:	e022                	sd	s0,0(sp)
    800054de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054e0:	ffffc097          	auipc	ra,0xffffc
    800054e4:	92c080e7          	jalr	-1748(ra) # 80000e0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054e8:	00d5179b          	slliw	a5,a0,0xd
    800054ec:	0c201537          	lui	a0,0xc201
    800054f0:	953e                	add	a0,a0,a5
  return irq;
}
    800054f2:	4148                	lw	a0,4(a0)
    800054f4:	60a2                	ld	ra,8(sp)
    800054f6:	6402                	ld	s0,0(sp)
    800054f8:	0141                	addi	sp,sp,16
    800054fa:	8082                	ret

00000000800054fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054fc:	1101                	addi	sp,sp,-32
    800054fe:	ec06                	sd	ra,24(sp)
    80005500:	e822                	sd	s0,16(sp)
    80005502:	e426                	sd	s1,8(sp)
    80005504:	1000                	addi	s0,sp,32
    80005506:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005508:	ffffc097          	auipc	ra,0xffffc
    8000550c:	904080e7          	jalr	-1788(ra) # 80000e0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005510:	00d5151b          	slliw	a0,a0,0xd
    80005514:	0c2017b7          	lui	a5,0xc201
    80005518:	97aa                	add	a5,a5,a0
    8000551a:	c3c4                	sw	s1,4(a5)
}
    8000551c:	60e2                	ld	ra,24(sp)
    8000551e:	6442                	ld	s0,16(sp)
    80005520:	64a2                	ld	s1,8(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret

0000000080005526 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005526:	1141                	addi	sp,sp,-16
    80005528:	e406                	sd	ra,8(sp)
    8000552a:	e022                	sd	s0,0(sp)
    8000552c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000552e:	479d                	li	a5,7
    80005530:	04a7cc63          	blt	a5,a0,80005588 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005534:	00020797          	auipc	a5,0x20
    80005538:	47c78793          	addi	a5,a5,1148 # 800259b0 <disk>
    8000553c:	97aa                	add	a5,a5,a0
    8000553e:	0187c783          	lbu	a5,24(a5)
    80005542:	ebb9                	bnez	a5,80005598 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005544:	00451613          	slli	a2,a0,0x4
    80005548:	00020797          	auipc	a5,0x20
    8000554c:	46878793          	addi	a5,a5,1128 # 800259b0 <disk>
    80005550:	6394                	ld	a3,0(a5)
    80005552:	96b2                	add	a3,a3,a2
    80005554:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005558:	6398                	ld	a4,0(a5)
    8000555a:	9732                	add	a4,a4,a2
    8000555c:	00072423          	sw	zero,8(a4) # fffffffffffff008 <end+0xffffffff7ffd12d8>
  disk.desc[i].flags = 0;
    80005560:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005564:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005568:	953e                	add	a0,a0,a5
    8000556a:	4785                	li	a5,1
    8000556c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005570:	00020517          	auipc	a0,0x20
    80005574:	45850513          	addi	a0,a0,1112 # 800259c8 <disk+0x18>
    80005578:	ffffc097          	auipc	ra,0xffffc
    8000557c:	fcc080e7          	jalr	-52(ra) # 80001544 <wakeup>
}
    80005580:	60a2                	ld	ra,8(sp)
    80005582:	6402                	ld	s0,0(sp)
    80005584:	0141                	addi	sp,sp,16
    80005586:	8082                	ret
    panic("free_desc 1");
    80005588:	00003517          	auipc	a0,0x3
    8000558c:	13050513          	addi	a0,a0,304 # 800086b8 <syscalls+0x320>
    80005590:	00001097          	auipc	ra,0x1
    80005594:	a0e080e7          	jalr	-1522(ra) # 80005f9e <panic>
    panic("free_desc 2");
    80005598:	00003517          	auipc	a0,0x3
    8000559c:	13050513          	addi	a0,a0,304 # 800086c8 <syscalls+0x330>
    800055a0:	00001097          	auipc	ra,0x1
    800055a4:	9fe080e7          	jalr	-1538(ra) # 80005f9e <panic>

00000000800055a8 <virtio_disk_init>:
{
    800055a8:	1101                	addi	sp,sp,-32
    800055aa:	ec06                	sd	ra,24(sp)
    800055ac:	e822                	sd	s0,16(sp)
    800055ae:	e426                	sd	s1,8(sp)
    800055b0:	e04a                	sd	s2,0(sp)
    800055b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055b4:	00003597          	auipc	a1,0x3
    800055b8:	12458593          	addi	a1,a1,292 # 800086d8 <syscalls+0x340>
    800055bc:	00020517          	auipc	a0,0x20
    800055c0:	51c50513          	addi	a0,a0,1308 # 80025ad8 <disk+0x128>
    800055c4:	00001097          	auipc	ra,0x1
    800055c8:	e86080e7          	jalr	-378(ra) # 8000644a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055cc:	100017b7          	lui	a5,0x10001
    800055d0:	4398                	lw	a4,0(a5)
    800055d2:	2701                	sext.w	a4,a4
    800055d4:	747277b7          	lui	a5,0x74727
    800055d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055dc:	14f71c63          	bne	a4,a5,80005734 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055e0:	100017b7          	lui	a5,0x10001
    800055e4:	43dc                	lw	a5,4(a5)
    800055e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e8:	4709                	li	a4,2
    800055ea:	14e79563          	bne	a5,a4,80005734 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ee:	100017b7          	lui	a5,0x10001
    800055f2:	479c                	lw	a5,8(a5)
    800055f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055f6:	12e79f63          	bne	a5,a4,80005734 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055fa:	100017b7          	lui	a5,0x10001
    800055fe:	47d8                	lw	a4,12(a5)
    80005600:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005602:	554d47b7          	lui	a5,0x554d4
    80005606:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000560a:	12f71563          	bne	a4,a5,80005734 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000560e:	100017b7          	lui	a5,0x10001
    80005612:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005616:	4705                	li	a4,1
    80005618:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000561a:	470d                	li	a4,3
    8000561c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000561e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005620:	c7ffe737          	lui	a4,0xc7ffe
    80005624:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0a2f>
    80005628:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000562a:	2701                	sext.w	a4,a4
    8000562c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000562e:	472d                	li	a4,11
    80005630:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005632:	5bbc                	lw	a5,112(a5)
    80005634:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005638:	8ba1                	andi	a5,a5,8
    8000563a:	10078563          	beqz	a5,80005744 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005646:	43fc                	lw	a5,68(a5)
    80005648:	2781                	sext.w	a5,a5
    8000564a:	10079563          	bnez	a5,80005754 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000564e:	100017b7          	lui	a5,0x10001
    80005652:	5bdc                	lw	a5,52(a5)
    80005654:	2781                	sext.w	a5,a5
  if(max == 0)
    80005656:	10078763          	beqz	a5,80005764 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000565a:	471d                	li	a4,7
    8000565c:	10f77c63          	bgeu	a4,a5,80005774 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005660:	ffffb097          	auipc	ra,0xffffb
    80005664:	ab8080e7          	jalr	-1352(ra) # 80000118 <kalloc>
    80005668:	00020497          	auipc	s1,0x20
    8000566c:	34848493          	addi	s1,s1,840 # 800259b0 <disk>
    80005670:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005672:	ffffb097          	auipc	ra,0xffffb
    80005676:	aa6080e7          	jalr	-1370(ra) # 80000118 <kalloc>
    8000567a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000567c:	ffffb097          	auipc	ra,0xffffb
    80005680:	a9c080e7          	jalr	-1380(ra) # 80000118 <kalloc>
    80005684:	87aa                	mv	a5,a0
    80005686:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005688:	6088                	ld	a0,0(s1)
    8000568a:	cd6d                	beqz	a0,80005784 <virtio_disk_init+0x1dc>
    8000568c:	00020717          	auipc	a4,0x20
    80005690:	32c73703          	ld	a4,812(a4) # 800259b8 <disk+0x8>
    80005694:	cb65                	beqz	a4,80005784 <virtio_disk_init+0x1dc>
    80005696:	c7fd                	beqz	a5,80005784 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005698:	6605                	lui	a2,0x1
    8000569a:	4581                	li	a1,0
    8000569c:	ffffb097          	auipc	ra,0xffffb
    800056a0:	adc080e7          	jalr	-1316(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056a4:	00020497          	auipc	s1,0x20
    800056a8:	30c48493          	addi	s1,s1,780 # 800259b0 <disk>
    800056ac:	6605                	lui	a2,0x1
    800056ae:	4581                	li	a1,0
    800056b0:	6488                	ld	a0,8(s1)
    800056b2:	ffffb097          	auipc	ra,0xffffb
    800056b6:	ac6080e7          	jalr	-1338(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800056ba:	6605                	lui	a2,0x1
    800056bc:	4581                	li	a1,0
    800056be:	6888                	ld	a0,16(s1)
    800056c0:	ffffb097          	auipc	ra,0xffffb
    800056c4:	ab8080e7          	jalr	-1352(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056c8:	100017b7          	lui	a5,0x10001
    800056cc:	4721                	li	a4,8
    800056ce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056d0:	4098                	lw	a4,0(s1)
    800056d2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056d6:	40d8                	lw	a4,4(s1)
    800056d8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056dc:	6498                	ld	a4,8(s1)
    800056de:	0007069b          	sext.w	a3,a4
    800056e2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056e6:	9701                	srai	a4,a4,0x20
    800056e8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056ec:	6898                	ld	a4,16(s1)
    800056ee:	0007069b          	sext.w	a3,a4
    800056f2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056f6:	9701                	srai	a4,a4,0x20
    800056f8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056fc:	4705                	li	a4,1
    800056fe:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005700:	00e48c23          	sb	a4,24(s1)
    80005704:	00e48ca3          	sb	a4,25(s1)
    80005708:	00e48d23          	sb	a4,26(s1)
    8000570c:	00e48da3          	sb	a4,27(s1)
    80005710:	00e48e23          	sb	a4,28(s1)
    80005714:	00e48ea3          	sb	a4,29(s1)
    80005718:	00e48f23          	sb	a4,30(s1)
    8000571c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005720:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005724:	0727a823          	sw	s2,112(a5)
}
    80005728:	60e2                	ld	ra,24(sp)
    8000572a:	6442                	ld	s0,16(sp)
    8000572c:	64a2                	ld	s1,8(sp)
    8000572e:	6902                	ld	s2,0(sp)
    80005730:	6105                	addi	sp,sp,32
    80005732:	8082                	ret
    panic("could not find virtio disk");
    80005734:	00003517          	auipc	a0,0x3
    80005738:	fb450513          	addi	a0,a0,-76 # 800086e8 <syscalls+0x350>
    8000573c:	00001097          	auipc	ra,0x1
    80005740:	862080e7          	jalr	-1950(ra) # 80005f9e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005744:	00003517          	auipc	a0,0x3
    80005748:	fc450513          	addi	a0,a0,-60 # 80008708 <syscalls+0x370>
    8000574c:	00001097          	auipc	ra,0x1
    80005750:	852080e7          	jalr	-1966(ra) # 80005f9e <panic>
    panic("virtio disk should not be ready");
    80005754:	00003517          	auipc	a0,0x3
    80005758:	fd450513          	addi	a0,a0,-44 # 80008728 <syscalls+0x390>
    8000575c:	00001097          	auipc	ra,0x1
    80005760:	842080e7          	jalr	-1982(ra) # 80005f9e <panic>
    panic("virtio disk has no queue 0");
    80005764:	00003517          	auipc	a0,0x3
    80005768:	fe450513          	addi	a0,a0,-28 # 80008748 <syscalls+0x3b0>
    8000576c:	00001097          	auipc	ra,0x1
    80005770:	832080e7          	jalr	-1998(ra) # 80005f9e <panic>
    panic("virtio disk max queue too short");
    80005774:	00003517          	auipc	a0,0x3
    80005778:	ff450513          	addi	a0,a0,-12 # 80008768 <syscalls+0x3d0>
    8000577c:	00001097          	auipc	ra,0x1
    80005780:	822080e7          	jalr	-2014(ra) # 80005f9e <panic>
    panic("virtio disk kalloc");
    80005784:	00003517          	auipc	a0,0x3
    80005788:	00450513          	addi	a0,a0,4 # 80008788 <syscalls+0x3f0>
    8000578c:	00001097          	auipc	ra,0x1
    80005790:	812080e7          	jalr	-2030(ra) # 80005f9e <panic>

0000000080005794 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005794:	7119                	addi	sp,sp,-128
    80005796:	fc86                	sd	ra,120(sp)
    80005798:	f8a2                	sd	s0,112(sp)
    8000579a:	f4a6                	sd	s1,104(sp)
    8000579c:	f0ca                	sd	s2,96(sp)
    8000579e:	ecce                	sd	s3,88(sp)
    800057a0:	e8d2                	sd	s4,80(sp)
    800057a2:	e4d6                	sd	s5,72(sp)
    800057a4:	e0da                	sd	s6,64(sp)
    800057a6:	fc5e                	sd	s7,56(sp)
    800057a8:	f862                	sd	s8,48(sp)
    800057aa:	f466                	sd	s9,40(sp)
    800057ac:	f06a                	sd	s10,32(sp)
    800057ae:	ec6e                	sd	s11,24(sp)
    800057b0:	0100                	addi	s0,sp,128
    800057b2:	8aaa                	mv	s5,a0
    800057b4:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057b6:	00c52d03          	lw	s10,12(a0)
    800057ba:	001d1d1b          	slliw	s10,s10,0x1
    800057be:	1d02                	slli	s10,s10,0x20
    800057c0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800057c4:	00020517          	auipc	a0,0x20
    800057c8:	31450513          	addi	a0,a0,788 # 80025ad8 <disk+0x128>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	d0e080e7          	jalr	-754(ra) # 800064da <acquire>
  for(int i = 0; i < 3; i++){
    800057d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057d8:	00020b97          	auipc	s7,0x20
    800057dc:	1d8b8b93          	addi	s7,s7,472 # 800259b0 <disk>
  for(int i = 0; i < 3; i++){
    800057e0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057e2:	00020c97          	auipc	s9,0x20
    800057e6:	2f6c8c93          	addi	s9,s9,758 # 80025ad8 <disk+0x128>
    800057ea:	a08d                	j	8000584c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800057ec:	00fb8733          	add	a4,s7,a5
    800057f0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057f4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057f6:	0207c563          	bltz	a5,80005820 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800057fa:	2905                	addiw	s2,s2,1
    800057fc:	0611                	addi	a2,a2,4
    800057fe:	05690c63          	beq	s2,s6,80005856 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005802:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005804:	00020717          	auipc	a4,0x20
    80005808:	1ac70713          	addi	a4,a4,428 # 800259b0 <disk>
    8000580c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000580e:	01874683          	lbu	a3,24(a4)
    80005812:	fee9                	bnez	a3,800057ec <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005814:	2785                	addiw	a5,a5,1
    80005816:	0705                	addi	a4,a4,1
    80005818:	fe979be3          	bne	a5,s1,8000580e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000581c:	57fd                	li	a5,-1
    8000581e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005820:	01205d63          	blez	s2,8000583a <virtio_disk_rw+0xa6>
    80005824:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005826:	000a2503          	lw	a0,0(s4)
    8000582a:	00000097          	auipc	ra,0x0
    8000582e:	cfc080e7          	jalr	-772(ra) # 80005526 <free_desc>
      for(int j = 0; j < i; j++)
    80005832:	2d85                	addiw	s11,s11,1
    80005834:	0a11                	addi	s4,s4,4
    80005836:	ffb918e3          	bne	s2,s11,80005826 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000583a:	85e6                	mv	a1,s9
    8000583c:	00020517          	auipc	a0,0x20
    80005840:	18c50513          	addi	a0,a0,396 # 800259c8 <disk+0x18>
    80005844:	ffffc097          	auipc	ra,0xffffc
    80005848:	c9c080e7          	jalr	-868(ra) # 800014e0 <sleep>
  for(int i = 0; i < 3; i++){
    8000584c:	f8040a13          	addi	s4,s0,-128
{
    80005850:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005852:	894e                	mv	s2,s3
    80005854:	b77d                	j	80005802 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005856:	f8042583          	lw	a1,-128(s0)
    8000585a:	00a58793          	addi	a5,a1,10
    8000585e:	0792                	slli	a5,a5,0x4

  if(write)
    80005860:	00020617          	auipc	a2,0x20
    80005864:	15060613          	addi	a2,a2,336 # 800259b0 <disk>
    80005868:	00f60733          	add	a4,a2,a5
    8000586c:	018036b3          	snez	a3,s8
    80005870:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005872:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005876:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000587a:	f6078693          	addi	a3,a5,-160
    8000587e:	6218                	ld	a4,0(a2)
    80005880:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005882:	00878513          	addi	a0,a5,8
    80005886:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005888:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000588a:	6208                	ld	a0,0(a2)
    8000588c:	96aa                	add	a3,a3,a0
    8000588e:	4741                	li	a4,16
    80005890:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005892:	4705                	li	a4,1
    80005894:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005898:	f8442703          	lw	a4,-124(s0)
    8000589c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058a0:	0712                	slli	a4,a4,0x4
    800058a2:	953a                	add	a0,a0,a4
    800058a4:	058a8693          	addi	a3,s5,88
    800058a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800058aa:	6208                	ld	a0,0(a2)
    800058ac:	972a                	add	a4,a4,a0
    800058ae:	40000693          	li	a3,1024
    800058b2:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058b4:	001c3c13          	seqz	s8,s8
    800058b8:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058ba:	001c6c13          	ori	s8,s8,1
    800058be:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800058c2:	f8842603          	lw	a2,-120(s0)
    800058c6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058ca:	00020697          	auipc	a3,0x20
    800058ce:	0e668693          	addi	a3,a3,230 # 800259b0 <disk>
    800058d2:	00258713          	addi	a4,a1,2
    800058d6:	0712                	slli	a4,a4,0x4
    800058d8:	9736                	add	a4,a4,a3
    800058da:	587d                	li	a6,-1
    800058dc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058e0:	0612                	slli	a2,a2,0x4
    800058e2:	9532                	add	a0,a0,a2
    800058e4:	f9078793          	addi	a5,a5,-112
    800058e8:	97b6                	add	a5,a5,a3
    800058ea:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800058ec:	629c                	ld	a5,0(a3)
    800058ee:	97b2                	add	a5,a5,a2
    800058f0:	4605                	li	a2,1
    800058f2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058f4:	4509                	li	a0,2
    800058f6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800058fa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058fe:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005902:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005906:	6698                	ld	a4,8(a3)
    80005908:	00275783          	lhu	a5,2(a4)
    8000590c:	8b9d                	andi	a5,a5,7
    8000590e:	0786                	slli	a5,a5,0x1
    80005910:	97ba                	add	a5,a5,a4
    80005912:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005916:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000591a:	6698                	ld	a4,8(a3)
    8000591c:	00275783          	lhu	a5,2(a4)
    80005920:	2785                	addiw	a5,a5,1
    80005922:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005926:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000592a:	100017b7          	lui	a5,0x10001
    8000592e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005932:	004aa783          	lw	a5,4(s5)
    80005936:	02c79163          	bne	a5,a2,80005958 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000593a:	00020917          	auipc	s2,0x20
    8000593e:	19e90913          	addi	s2,s2,414 # 80025ad8 <disk+0x128>
  while(b->disk == 1) {
    80005942:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005944:	85ca                	mv	a1,s2
    80005946:	8556                	mv	a0,s5
    80005948:	ffffc097          	auipc	ra,0xffffc
    8000594c:	b98080e7          	jalr	-1128(ra) # 800014e0 <sleep>
  while(b->disk == 1) {
    80005950:	004aa783          	lw	a5,4(s5)
    80005954:	fe9788e3          	beq	a5,s1,80005944 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005958:	f8042903          	lw	s2,-128(s0)
    8000595c:	00290793          	addi	a5,s2,2
    80005960:	00479713          	slli	a4,a5,0x4
    80005964:	00020797          	auipc	a5,0x20
    80005968:	04c78793          	addi	a5,a5,76 # 800259b0 <disk>
    8000596c:	97ba                	add	a5,a5,a4
    8000596e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005972:	00020997          	auipc	s3,0x20
    80005976:	03e98993          	addi	s3,s3,62 # 800259b0 <disk>
    8000597a:	00491713          	slli	a4,s2,0x4
    8000597e:	0009b783          	ld	a5,0(s3)
    80005982:	97ba                	add	a5,a5,a4
    80005984:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005988:	854a                	mv	a0,s2
    8000598a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000598e:	00000097          	auipc	ra,0x0
    80005992:	b98080e7          	jalr	-1128(ra) # 80005526 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005996:	8885                	andi	s1,s1,1
    80005998:	f0ed                	bnez	s1,8000597a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000599a:	00020517          	auipc	a0,0x20
    8000599e:	13e50513          	addi	a0,a0,318 # 80025ad8 <disk+0x128>
    800059a2:	00001097          	auipc	ra,0x1
    800059a6:	bec080e7          	jalr	-1044(ra) # 8000658e <release>
}
    800059aa:	70e6                	ld	ra,120(sp)
    800059ac:	7446                	ld	s0,112(sp)
    800059ae:	74a6                	ld	s1,104(sp)
    800059b0:	7906                	ld	s2,96(sp)
    800059b2:	69e6                	ld	s3,88(sp)
    800059b4:	6a46                	ld	s4,80(sp)
    800059b6:	6aa6                	ld	s5,72(sp)
    800059b8:	6b06                	ld	s6,64(sp)
    800059ba:	7be2                	ld	s7,56(sp)
    800059bc:	7c42                	ld	s8,48(sp)
    800059be:	7ca2                	ld	s9,40(sp)
    800059c0:	7d02                	ld	s10,32(sp)
    800059c2:	6de2                	ld	s11,24(sp)
    800059c4:	6109                	addi	sp,sp,128
    800059c6:	8082                	ret

00000000800059c8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059c8:	1101                	addi	sp,sp,-32
    800059ca:	ec06                	sd	ra,24(sp)
    800059cc:	e822                	sd	s0,16(sp)
    800059ce:	e426                	sd	s1,8(sp)
    800059d0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059d2:	00020497          	auipc	s1,0x20
    800059d6:	fde48493          	addi	s1,s1,-34 # 800259b0 <disk>
    800059da:	00020517          	auipc	a0,0x20
    800059de:	0fe50513          	addi	a0,a0,254 # 80025ad8 <disk+0x128>
    800059e2:	00001097          	auipc	ra,0x1
    800059e6:	af8080e7          	jalr	-1288(ra) # 800064da <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059ea:	10001737          	lui	a4,0x10001
    800059ee:	533c                	lw	a5,96(a4)
    800059f0:	8b8d                	andi	a5,a5,3
    800059f2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059f4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059f8:	689c                	ld	a5,16(s1)
    800059fa:	0204d703          	lhu	a4,32(s1)
    800059fe:	0027d783          	lhu	a5,2(a5)
    80005a02:	04f70863          	beq	a4,a5,80005a52 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a06:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a0a:	6898                	ld	a4,16(s1)
    80005a0c:	0204d783          	lhu	a5,32(s1)
    80005a10:	8b9d                	andi	a5,a5,7
    80005a12:	078e                	slli	a5,a5,0x3
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a18:	00278713          	addi	a4,a5,2
    80005a1c:	0712                	slli	a4,a4,0x4
    80005a1e:	9726                	add	a4,a4,s1
    80005a20:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a24:	e721                	bnez	a4,80005a6c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a26:	0789                	addi	a5,a5,2
    80005a28:	0792                	slli	a5,a5,0x4
    80005a2a:	97a6                	add	a5,a5,s1
    80005a2c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a2e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a32:	ffffc097          	auipc	ra,0xffffc
    80005a36:	b12080e7          	jalr	-1262(ra) # 80001544 <wakeup>

    disk.used_idx += 1;
    80005a3a:	0204d783          	lhu	a5,32(s1)
    80005a3e:	2785                	addiw	a5,a5,1
    80005a40:	17c2                	slli	a5,a5,0x30
    80005a42:	93c1                	srli	a5,a5,0x30
    80005a44:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a48:	6898                	ld	a4,16(s1)
    80005a4a:	00275703          	lhu	a4,2(a4)
    80005a4e:	faf71ce3          	bne	a4,a5,80005a06 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a52:	00020517          	auipc	a0,0x20
    80005a56:	08650513          	addi	a0,a0,134 # 80025ad8 <disk+0x128>
    80005a5a:	00001097          	auipc	ra,0x1
    80005a5e:	b34080e7          	jalr	-1228(ra) # 8000658e <release>
}
    80005a62:	60e2                	ld	ra,24(sp)
    80005a64:	6442                	ld	s0,16(sp)
    80005a66:	64a2                	ld	s1,8(sp)
    80005a68:	6105                	addi	sp,sp,32
    80005a6a:	8082                	ret
      panic("virtio_disk_intr status");
    80005a6c:	00003517          	auipc	a0,0x3
    80005a70:	d3450513          	addi	a0,a0,-716 # 800087a0 <syscalls+0x408>
    80005a74:	00000097          	auipc	ra,0x0
    80005a78:	52a080e7          	jalr	1322(ra) # 80005f9e <panic>

0000000080005a7c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a7c:	1141                	addi	sp,sp,-16
    80005a7e:	e422                	sd	s0,8(sp)
    80005a80:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a82:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a86:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a8a:	0037979b          	slliw	a5,a5,0x3
    80005a8e:	02004737          	lui	a4,0x2004
    80005a92:	97ba                	add	a5,a5,a4
    80005a94:	0200c737          	lui	a4,0x200c
    80005a98:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a9c:	000f4637          	lui	a2,0xf4
    80005aa0:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005aa4:	95b2                	add	a1,a1,a2
    80005aa6:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005aa8:	00269713          	slli	a4,a3,0x2
    80005aac:	9736                	add	a4,a4,a3
    80005aae:	00371693          	slli	a3,a4,0x3
    80005ab2:	00020717          	auipc	a4,0x20
    80005ab6:	03e70713          	addi	a4,a4,62 # 80025af0 <timer_scratch>
    80005aba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005abc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005abe:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005ac0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ac4:	00000797          	auipc	a5,0x0
    80005ac8:	99c78793          	addi	a5,a5,-1636 # 80005460 <timervec>
    80005acc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ad0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ad4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ad8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005adc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ae0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ae4:	30479073          	csrw	mie,a5
}
    80005ae8:	6422                	ld	s0,8(sp)
    80005aea:	0141                	addi	sp,sp,16
    80005aec:	8082                	ret

0000000080005aee <start>:
{
    80005aee:	1141                	addi	sp,sp,-16
    80005af0:	e406                	sd	ra,8(sp)
    80005af2:	e022                	sd	s0,0(sp)
    80005af4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005af6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005afa:	7779                	lui	a4,0xffffe
    80005afc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd0acf>
    80005b00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b02:	6705                	lui	a4,0x1
    80005b04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b0e:	ffffb797          	auipc	a5,0xffffb
    80005b12:	81078793          	addi	a5,a5,-2032 # 8000031e <main>
    80005b16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b1a:	4781                	li	a5,0
    80005b1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b20:	67c1                	lui	a5,0x10
    80005b22:	17fd                	addi	a5,a5,-1
    80005b24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b38:	57fd                	li	a5,-1
    80005b3a:	83a9                	srli	a5,a5,0xa
    80005b3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b40:	47bd                	li	a5,15
    80005b42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	f36080e7          	jalr	-202(ra) # 80005a7c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b4e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b52:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b54:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b56:	30200073          	mret
}
    80005b5a:	60a2                	ld	ra,8(sp)
    80005b5c:	6402                	ld	s0,0(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret

0000000080005b62 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b62:	715d                	addi	sp,sp,-80
    80005b64:	e486                	sd	ra,72(sp)
    80005b66:	e0a2                	sd	s0,64(sp)
    80005b68:	fc26                	sd	s1,56(sp)
    80005b6a:	f84a                	sd	s2,48(sp)
    80005b6c:	f44e                	sd	s3,40(sp)
    80005b6e:	f052                	sd	s4,32(sp)
    80005b70:	ec56                	sd	s5,24(sp)
    80005b72:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b74:	04c05663          	blez	a2,80005bc0 <consolewrite+0x5e>
    80005b78:	8a2a                	mv	s4,a0
    80005b7a:	84ae                	mv	s1,a1
    80005b7c:	89b2                	mv	s3,a2
    80005b7e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b80:	5afd                	li	s5,-1
    80005b82:	4685                	li	a3,1
    80005b84:	8626                	mv	a2,s1
    80005b86:	85d2                	mv	a1,s4
    80005b88:	fbf40513          	addi	a0,s0,-65
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	db2080e7          	jalr	-590(ra) # 8000193e <either_copyin>
    80005b94:	01550c63          	beq	a0,s5,80005bac <consolewrite+0x4a>
      break;
    uartputc(c);
    80005b98:	fbf44503          	lbu	a0,-65(s0)
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	780080e7          	jalr	1920(ra) # 8000631c <uartputc>
  for(i = 0; i < n; i++){
    80005ba4:	2905                	addiw	s2,s2,1
    80005ba6:	0485                	addi	s1,s1,1
    80005ba8:	fd299de3          	bne	s3,s2,80005b82 <consolewrite+0x20>
  }

  return i;
}
    80005bac:	854a                	mv	a0,s2
    80005bae:	60a6                	ld	ra,72(sp)
    80005bb0:	6406                	ld	s0,64(sp)
    80005bb2:	74e2                	ld	s1,56(sp)
    80005bb4:	7942                	ld	s2,48(sp)
    80005bb6:	79a2                	ld	s3,40(sp)
    80005bb8:	7a02                	ld	s4,32(sp)
    80005bba:	6ae2                	ld	s5,24(sp)
    80005bbc:	6161                	addi	sp,sp,80
    80005bbe:	8082                	ret
  for(i = 0; i < n; i++){
    80005bc0:	4901                	li	s2,0
    80005bc2:	b7ed                	j	80005bac <consolewrite+0x4a>

0000000080005bc4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bc4:	7159                	addi	sp,sp,-112
    80005bc6:	f486                	sd	ra,104(sp)
    80005bc8:	f0a2                	sd	s0,96(sp)
    80005bca:	eca6                	sd	s1,88(sp)
    80005bcc:	e8ca                	sd	s2,80(sp)
    80005bce:	e4ce                	sd	s3,72(sp)
    80005bd0:	e0d2                	sd	s4,64(sp)
    80005bd2:	fc56                	sd	s5,56(sp)
    80005bd4:	f85a                	sd	s6,48(sp)
    80005bd6:	f45e                	sd	s7,40(sp)
    80005bd8:	f062                	sd	s8,32(sp)
    80005bda:	ec66                	sd	s9,24(sp)
    80005bdc:	e86a                	sd	s10,16(sp)
    80005bde:	1880                	addi	s0,sp,112
    80005be0:	8aaa                	mv	s5,a0
    80005be2:	8a2e                	mv	s4,a1
    80005be4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005be6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005bea:	00028517          	auipc	a0,0x28
    80005bee:	04650513          	addi	a0,a0,70 # 8002dc30 <cons>
    80005bf2:	00001097          	auipc	ra,0x1
    80005bf6:	8e8080e7          	jalr	-1816(ra) # 800064da <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bfa:	00028497          	auipc	s1,0x28
    80005bfe:	03648493          	addi	s1,s1,54 # 8002dc30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c02:	00028917          	auipc	s2,0x28
    80005c06:	0c690913          	addi	s2,s2,198 # 8002dcc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c0a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c0c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c0e:	4ca9                	li	s9,10
  while(n > 0){
    80005c10:	07305b63          	blez	s3,80005c86 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005c14:	0984a783          	lw	a5,152(s1)
    80005c18:	09c4a703          	lw	a4,156(s1)
    80005c1c:	02f71763          	bne	a4,a5,80005c4a <consoleread+0x86>
      if(killed(myproc())){
    80005c20:	ffffb097          	auipc	ra,0xffffb
    80005c24:	218080e7          	jalr	536(ra) # 80000e38 <myproc>
    80005c28:	ffffc097          	auipc	ra,0xffffc
    80005c2c:	b60080e7          	jalr	-1184(ra) # 80001788 <killed>
    80005c30:	e535                	bnez	a0,80005c9c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005c32:	85a6                	mv	a1,s1
    80005c34:	854a                	mv	a0,s2
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	8aa080e7          	jalr	-1878(ra) # 800014e0 <sleep>
    while(cons.r == cons.w){
    80005c3e:	0984a783          	lw	a5,152(s1)
    80005c42:	09c4a703          	lw	a4,156(s1)
    80005c46:	fcf70de3          	beq	a4,a5,80005c20 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c4a:	0017871b          	addiw	a4,a5,1
    80005c4e:	08e4ac23          	sw	a4,152(s1)
    80005c52:	07f7f713          	andi	a4,a5,127
    80005c56:	9726                	add	a4,a4,s1
    80005c58:	01874703          	lbu	a4,24(a4)
    80005c5c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005c60:	077d0563          	beq	s10,s7,80005cca <consoleread+0x106>
    cbuf = c;
    80005c64:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c68:	4685                	li	a3,1
    80005c6a:	f9f40613          	addi	a2,s0,-97
    80005c6e:	85d2                	mv	a1,s4
    80005c70:	8556                	mv	a0,s5
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	c76080e7          	jalr	-906(ra) # 800018e8 <either_copyout>
    80005c7a:	01850663          	beq	a0,s8,80005c86 <consoleread+0xc2>
    dst++;
    80005c7e:	0a05                	addi	s4,s4,1
    --n;
    80005c80:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005c82:	f99d17e3          	bne	s10,s9,80005c10 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c86:	00028517          	auipc	a0,0x28
    80005c8a:	faa50513          	addi	a0,a0,-86 # 8002dc30 <cons>
    80005c8e:	00001097          	auipc	ra,0x1
    80005c92:	900080e7          	jalr	-1792(ra) # 8000658e <release>

  return target - n;
    80005c96:	413b053b          	subw	a0,s6,s3
    80005c9a:	a811                	j	80005cae <consoleread+0xea>
        release(&cons.lock);
    80005c9c:	00028517          	auipc	a0,0x28
    80005ca0:	f9450513          	addi	a0,a0,-108 # 8002dc30 <cons>
    80005ca4:	00001097          	auipc	ra,0x1
    80005ca8:	8ea080e7          	jalr	-1814(ra) # 8000658e <release>
        return -1;
    80005cac:	557d                	li	a0,-1
}
    80005cae:	70a6                	ld	ra,104(sp)
    80005cb0:	7406                	ld	s0,96(sp)
    80005cb2:	64e6                	ld	s1,88(sp)
    80005cb4:	6946                	ld	s2,80(sp)
    80005cb6:	69a6                	ld	s3,72(sp)
    80005cb8:	6a06                	ld	s4,64(sp)
    80005cba:	7ae2                	ld	s5,56(sp)
    80005cbc:	7b42                	ld	s6,48(sp)
    80005cbe:	7ba2                	ld	s7,40(sp)
    80005cc0:	7c02                	ld	s8,32(sp)
    80005cc2:	6ce2                	ld	s9,24(sp)
    80005cc4:	6d42                	ld	s10,16(sp)
    80005cc6:	6165                	addi	sp,sp,112
    80005cc8:	8082                	ret
      if(n < target){
    80005cca:	0009871b          	sext.w	a4,s3
    80005cce:	fb677ce3          	bgeu	a4,s6,80005c86 <consoleread+0xc2>
        cons.r--;
    80005cd2:	00028717          	auipc	a4,0x28
    80005cd6:	fef72b23          	sw	a5,-10(a4) # 8002dcc8 <cons+0x98>
    80005cda:	b775                	j	80005c86 <consoleread+0xc2>

0000000080005cdc <consputc>:
{
    80005cdc:	1141                	addi	sp,sp,-16
    80005cde:	e406                	sd	ra,8(sp)
    80005ce0:	e022                	sd	s0,0(sp)
    80005ce2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ce4:	10000793          	li	a5,256
    80005ce8:	00f50a63          	beq	a0,a5,80005cfc <consputc+0x20>
    uartputc_sync(c);
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	55e080e7          	jalr	1374(ra) # 8000624a <uartputc_sync>
}
    80005cf4:	60a2                	ld	ra,8(sp)
    80005cf6:	6402                	ld	s0,0(sp)
    80005cf8:	0141                	addi	sp,sp,16
    80005cfa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005cfc:	4521                	li	a0,8
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	54c080e7          	jalr	1356(ra) # 8000624a <uartputc_sync>
    80005d06:	02000513          	li	a0,32
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	540080e7          	jalr	1344(ra) # 8000624a <uartputc_sync>
    80005d12:	4521                	li	a0,8
    80005d14:	00000097          	auipc	ra,0x0
    80005d18:	536080e7          	jalr	1334(ra) # 8000624a <uartputc_sync>
    80005d1c:	bfe1                	j	80005cf4 <consputc+0x18>

0000000080005d1e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d1e:	1101                	addi	sp,sp,-32
    80005d20:	ec06                	sd	ra,24(sp)
    80005d22:	e822                	sd	s0,16(sp)
    80005d24:	e426                	sd	s1,8(sp)
    80005d26:	e04a                	sd	s2,0(sp)
    80005d28:	1000                	addi	s0,sp,32
    80005d2a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d2c:	00028517          	auipc	a0,0x28
    80005d30:	f0450513          	addi	a0,a0,-252 # 8002dc30 <cons>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	7a6080e7          	jalr	1958(ra) # 800064da <acquire>

  switch(c){
    80005d3c:	47d5                	li	a5,21
    80005d3e:	0af48663          	beq	s1,a5,80005dea <consoleintr+0xcc>
    80005d42:	0297ca63          	blt	a5,s1,80005d76 <consoleintr+0x58>
    80005d46:	47a1                	li	a5,8
    80005d48:	0ef48763          	beq	s1,a5,80005e36 <consoleintr+0x118>
    80005d4c:	47c1                	li	a5,16
    80005d4e:	10f49a63          	bne	s1,a5,80005e62 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d52:	ffffc097          	auipc	ra,0xffffc
    80005d56:	c42080e7          	jalr	-958(ra) # 80001994 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d5a:	00028517          	auipc	a0,0x28
    80005d5e:	ed650513          	addi	a0,a0,-298 # 8002dc30 <cons>
    80005d62:	00001097          	auipc	ra,0x1
    80005d66:	82c080e7          	jalr	-2004(ra) # 8000658e <release>
}
    80005d6a:	60e2                	ld	ra,24(sp)
    80005d6c:	6442                	ld	s0,16(sp)
    80005d6e:	64a2                	ld	s1,8(sp)
    80005d70:	6902                	ld	s2,0(sp)
    80005d72:	6105                	addi	sp,sp,32
    80005d74:	8082                	ret
  switch(c){
    80005d76:	07f00793          	li	a5,127
    80005d7a:	0af48e63          	beq	s1,a5,80005e36 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d7e:	00028717          	auipc	a4,0x28
    80005d82:	eb270713          	addi	a4,a4,-334 # 8002dc30 <cons>
    80005d86:	0a072783          	lw	a5,160(a4)
    80005d8a:	09872703          	lw	a4,152(a4)
    80005d8e:	9f99                	subw	a5,a5,a4
    80005d90:	07f00713          	li	a4,127
    80005d94:	fcf763e3          	bltu	a4,a5,80005d5a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005d98:	47b5                	li	a5,13
    80005d9a:	0cf48763          	beq	s1,a5,80005e68 <consoleintr+0x14a>
      consputc(c);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	f3c080e7          	jalr	-196(ra) # 80005cdc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005da8:	00028797          	auipc	a5,0x28
    80005dac:	e8878793          	addi	a5,a5,-376 # 8002dc30 <cons>
    80005db0:	0a07a683          	lw	a3,160(a5)
    80005db4:	0016871b          	addiw	a4,a3,1
    80005db8:	0007061b          	sext.w	a2,a4
    80005dbc:	0ae7a023          	sw	a4,160(a5)
    80005dc0:	07f6f693          	andi	a3,a3,127
    80005dc4:	97b6                	add	a5,a5,a3
    80005dc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005dca:	47a9                	li	a5,10
    80005dcc:	0cf48563          	beq	s1,a5,80005e96 <consoleintr+0x178>
    80005dd0:	4791                	li	a5,4
    80005dd2:	0cf48263          	beq	s1,a5,80005e96 <consoleintr+0x178>
    80005dd6:	00028797          	auipc	a5,0x28
    80005dda:	ef27a783          	lw	a5,-270(a5) # 8002dcc8 <cons+0x98>
    80005dde:	9f1d                	subw	a4,a4,a5
    80005de0:	08000793          	li	a5,128
    80005de4:	f6f71be3          	bne	a4,a5,80005d5a <consoleintr+0x3c>
    80005de8:	a07d                	j	80005e96 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005dea:	00028717          	auipc	a4,0x28
    80005dee:	e4670713          	addi	a4,a4,-442 # 8002dc30 <cons>
    80005df2:	0a072783          	lw	a5,160(a4)
    80005df6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005dfa:	00028497          	auipc	s1,0x28
    80005dfe:	e3648493          	addi	s1,s1,-458 # 8002dc30 <cons>
    while(cons.e != cons.w &&
    80005e02:	4929                	li	s2,10
    80005e04:	f4f70be3          	beq	a4,a5,80005d5a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e08:	37fd                	addiw	a5,a5,-1
    80005e0a:	07f7f713          	andi	a4,a5,127
    80005e0e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e10:	01874703          	lbu	a4,24(a4)
    80005e14:	f52703e3          	beq	a4,s2,80005d5a <consoleintr+0x3c>
      cons.e--;
    80005e18:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e1c:	10000513          	li	a0,256
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	ebc080e7          	jalr	-324(ra) # 80005cdc <consputc>
    while(cons.e != cons.w &&
    80005e28:	0a04a783          	lw	a5,160(s1)
    80005e2c:	09c4a703          	lw	a4,156(s1)
    80005e30:	fcf71ce3          	bne	a4,a5,80005e08 <consoleintr+0xea>
    80005e34:	b71d                	j	80005d5a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e36:	00028717          	auipc	a4,0x28
    80005e3a:	dfa70713          	addi	a4,a4,-518 # 8002dc30 <cons>
    80005e3e:	0a072783          	lw	a5,160(a4)
    80005e42:	09c72703          	lw	a4,156(a4)
    80005e46:	f0f70ae3          	beq	a4,a5,80005d5a <consoleintr+0x3c>
      cons.e--;
    80005e4a:	37fd                	addiw	a5,a5,-1
    80005e4c:	00028717          	auipc	a4,0x28
    80005e50:	e8f72223          	sw	a5,-380(a4) # 8002dcd0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e54:	10000513          	li	a0,256
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	e84080e7          	jalr	-380(ra) # 80005cdc <consputc>
    80005e60:	bded                	j	80005d5a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e62:	ee048ce3          	beqz	s1,80005d5a <consoleintr+0x3c>
    80005e66:	bf21                	j	80005d7e <consoleintr+0x60>
      consputc(c);
    80005e68:	4529                	li	a0,10
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	e72080e7          	jalr	-398(ra) # 80005cdc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e72:	00028797          	auipc	a5,0x28
    80005e76:	dbe78793          	addi	a5,a5,-578 # 8002dc30 <cons>
    80005e7a:	0a07a703          	lw	a4,160(a5)
    80005e7e:	0017069b          	addiw	a3,a4,1
    80005e82:	0006861b          	sext.w	a2,a3
    80005e86:	0ad7a023          	sw	a3,160(a5)
    80005e8a:	07f77713          	andi	a4,a4,127
    80005e8e:	97ba                	add	a5,a5,a4
    80005e90:	4729                	li	a4,10
    80005e92:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e96:	00028797          	auipc	a5,0x28
    80005e9a:	e2c7ab23          	sw	a2,-458(a5) # 8002dccc <cons+0x9c>
        wakeup(&cons.r);
    80005e9e:	00028517          	auipc	a0,0x28
    80005ea2:	e2a50513          	addi	a0,a0,-470 # 8002dcc8 <cons+0x98>
    80005ea6:	ffffb097          	auipc	ra,0xffffb
    80005eaa:	69e080e7          	jalr	1694(ra) # 80001544 <wakeup>
    80005eae:	b575                	j	80005d5a <consoleintr+0x3c>

0000000080005eb0 <consoleinit>:

void
consoleinit(void)
{
    80005eb0:	1141                	addi	sp,sp,-16
    80005eb2:	e406                	sd	ra,8(sp)
    80005eb4:	e022                	sd	s0,0(sp)
    80005eb6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005eb8:	00003597          	auipc	a1,0x3
    80005ebc:	90058593          	addi	a1,a1,-1792 # 800087b8 <syscalls+0x420>
    80005ec0:	00028517          	auipc	a0,0x28
    80005ec4:	d7050513          	addi	a0,a0,-656 # 8002dc30 <cons>
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	582080e7          	jalr	1410(ra) # 8000644a <initlock>

  uartinit();
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	32a080e7          	jalr	810(ra) # 800061fa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ed8:	0001f797          	auipc	a5,0x1f
    80005edc:	a8078793          	addi	a5,a5,-1408 # 80024958 <devsw>
    80005ee0:	00000717          	auipc	a4,0x0
    80005ee4:	ce470713          	addi	a4,a4,-796 # 80005bc4 <consoleread>
    80005ee8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005eea:	00000717          	auipc	a4,0x0
    80005eee:	c7870713          	addi	a4,a4,-904 # 80005b62 <consolewrite>
    80005ef2:	ef98                	sd	a4,24(a5)
}
    80005ef4:	60a2                	ld	ra,8(sp)
    80005ef6:	6402                	ld	s0,0(sp)
    80005ef8:	0141                	addi	sp,sp,16
    80005efa:	8082                	ret

0000000080005efc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005efc:	7179                	addi	sp,sp,-48
    80005efe:	f406                	sd	ra,40(sp)
    80005f00:	f022                	sd	s0,32(sp)
    80005f02:	ec26                	sd	s1,24(sp)
    80005f04:	e84a                	sd	s2,16(sp)
    80005f06:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f08:	c219                	beqz	a2,80005f0e <printint+0x12>
    80005f0a:	08054663          	bltz	a0,80005f96 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f0e:	2501                	sext.w	a0,a0
    80005f10:	4881                	li	a7,0
    80005f12:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f16:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f18:	2581                	sext.w	a1,a1
    80005f1a:	00003617          	auipc	a2,0x3
    80005f1e:	8ce60613          	addi	a2,a2,-1842 # 800087e8 <digits>
    80005f22:	883a                	mv	a6,a4
    80005f24:	2705                	addiw	a4,a4,1
    80005f26:	02b577bb          	remuw	a5,a0,a1
    80005f2a:	1782                	slli	a5,a5,0x20
    80005f2c:	9381                	srli	a5,a5,0x20
    80005f2e:	97b2                	add	a5,a5,a2
    80005f30:	0007c783          	lbu	a5,0(a5)
    80005f34:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f38:	0005079b          	sext.w	a5,a0
    80005f3c:	02b5553b          	divuw	a0,a0,a1
    80005f40:	0685                	addi	a3,a3,1
    80005f42:	feb7f0e3          	bgeu	a5,a1,80005f22 <printint+0x26>

  if(sign)
    80005f46:	00088b63          	beqz	a7,80005f5c <printint+0x60>
    buf[i++] = '-';
    80005f4a:	fe040793          	addi	a5,s0,-32
    80005f4e:	973e                	add	a4,a4,a5
    80005f50:	02d00793          	li	a5,45
    80005f54:	fef70823          	sb	a5,-16(a4)
    80005f58:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f5c:	02e05763          	blez	a4,80005f8a <printint+0x8e>
    80005f60:	fd040793          	addi	a5,s0,-48
    80005f64:	00e784b3          	add	s1,a5,a4
    80005f68:	fff78913          	addi	s2,a5,-1
    80005f6c:	993a                	add	s2,s2,a4
    80005f6e:	377d                	addiw	a4,a4,-1
    80005f70:	1702                	slli	a4,a4,0x20
    80005f72:	9301                	srli	a4,a4,0x20
    80005f74:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f78:	fff4c503          	lbu	a0,-1(s1)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	d60080e7          	jalr	-672(ra) # 80005cdc <consputc>
  while(--i >= 0)
    80005f84:	14fd                	addi	s1,s1,-1
    80005f86:	ff2499e3          	bne	s1,s2,80005f78 <printint+0x7c>
}
    80005f8a:	70a2                	ld	ra,40(sp)
    80005f8c:	7402                	ld	s0,32(sp)
    80005f8e:	64e2                	ld	s1,24(sp)
    80005f90:	6942                	ld	s2,16(sp)
    80005f92:	6145                	addi	sp,sp,48
    80005f94:	8082                	ret
    x = -xx;
    80005f96:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f9a:	4885                	li	a7,1
    x = -xx;
    80005f9c:	bf9d                	j	80005f12 <printint+0x16>

0000000080005f9e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f9e:	1101                	addi	sp,sp,-32
    80005fa0:	ec06                	sd	ra,24(sp)
    80005fa2:	e822                	sd	s0,16(sp)
    80005fa4:	e426                	sd	s1,8(sp)
    80005fa6:	1000                	addi	s0,sp,32
    80005fa8:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005faa:	00028797          	auipc	a5,0x28
    80005fae:	d407a323          	sw	zero,-698(a5) # 8002dcf0 <pr+0x18>
  printf("panic: ");
    80005fb2:	00003517          	auipc	a0,0x3
    80005fb6:	80e50513          	addi	a0,a0,-2034 # 800087c0 <syscalls+0x428>
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	02e080e7          	jalr	46(ra) # 80005fe8 <printf>
  printf(s);
    80005fc2:	8526                	mv	a0,s1
    80005fc4:	00000097          	auipc	ra,0x0
    80005fc8:	024080e7          	jalr	36(ra) # 80005fe8 <printf>
  printf("\n");
    80005fcc:	00002517          	auipc	a0,0x2
    80005fd0:	07c50513          	addi	a0,a0,124 # 80008048 <etext+0x48>
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	014080e7          	jalr	20(ra) # 80005fe8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005fdc:	4785                	li	a5,1
    80005fde:	00003717          	auipc	a4,0x3
    80005fe2:	8cf72723          	sw	a5,-1842(a4) # 800088ac <panicked>
  for(;;)
    80005fe6:	a001                	j	80005fe6 <panic+0x48>

0000000080005fe8 <printf>:
{
    80005fe8:	7131                	addi	sp,sp,-192
    80005fea:	fc86                	sd	ra,120(sp)
    80005fec:	f8a2                	sd	s0,112(sp)
    80005fee:	f4a6                	sd	s1,104(sp)
    80005ff0:	f0ca                	sd	s2,96(sp)
    80005ff2:	ecce                	sd	s3,88(sp)
    80005ff4:	e8d2                	sd	s4,80(sp)
    80005ff6:	e4d6                	sd	s5,72(sp)
    80005ff8:	e0da                	sd	s6,64(sp)
    80005ffa:	fc5e                	sd	s7,56(sp)
    80005ffc:	f862                	sd	s8,48(sp)
    80005ffe:	f466                	sd	s9,40(sp)
    80006000:	f06a                	sd	s10,32(sp)
    80006002:	ec6e                	sd	s11,24(sp)
    80006004:	0100                	addi	s0,sp,128
    80006006:	8a2a                	mv	s4,a0
    80006008:	e40c                	sd	a1,8(s0)
    8000600a:	e810                	sd	a2,16(s0)
    8000600c:	ec14                	sd	a3,24(s0)
    8000600e:	f018                	sd	a4,32(s0)
    80006010:	f41c                	sd	a5,40(s0)
    80006012:	03043823          	sd	a6,48(s0)
    80006016:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000601a:	00028d97          	auipc	s11,0x28
    8000601e:	cd6dad83          	lw	s11,-810(s11) # 8002dcf0 <pr+0x18>
  if(locking)
    80006022:	020d9b63          	bnez	s11,80006058 <printf+0x70>
  if (fmt == 0)
    80006026:	040a0263          	beqz	s4,8000606a <printf+0x82>
  va_start(ap, fmt);
    8000602a:	00840793          	addi	a5,s0,8
    8000602e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006032:	000a4503          	lbu	a0,0(s4)
    80006036:	14050f63          	beqz	a0,80006194 <printf+0x1ac>
    8000603a:	4981                	li	s3,0
    if(c != '%'){
    8000603c:	02500a93          	li	s5,37
    switch(c){
    80006040:	07000b93          	li	s7,112
  consputc('x');
    80006044:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006046:	00002b17          	auipc	s6,0x2
    8000604a:	7a2b0b13          	addi	s6,s6,1954 # 800087e8 <digits>
    switch(c){
    8000604e:	07300c93          	li	s9,115
    80006052:	06400c13          	li	s8,100
    80006056:	a82d                	j	80006090 <printf+0xa8>
    acquire(&pr.lock);
    80006058:	00028517          	auipc	a0,0x28
    8000605c:	c8050513          	addi	a0,a0,-896 # 8002dcd8 <pr>
    80006060:	00000097          	auipc	ra,0x0
    80006064:	47a080e7          	jalr	1146(ra) # 800064da <acquire>
    80006068:	bf7d                	j	80006026 <printf+0x3e>
    panic("null fmt");
    8000606a:	00002517          	auipc	a0,0x2
    8000606e:	76650513          	addi	a0,a0,1894 # 800087d0 <syscalls+0x438>
    80006072:	00000097          	auipc	ra,0x0
    80006076:	f2c080e7          	jalr	-212(ra) # 80005f9e <panic>
      consputc(c);
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	c62080e7          	jalr	-926(ra) # 80005cdc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006082:	2985                	addiw	s3,s3,1
    80006084:	013a07b3          	add	a5,s4,s3
    80006088:	0007c503          	lbu	a0,0(a5)
    8000608c:	10050463          	beqz	a0,80006194 <printf+0x1ac>
    if(c != '%'){
    80006090:	ff5515e3          	bne	a0,s5,8000607a <printf+0x92>
    c = fmt[++i] & 0xff;
    80006094:	2985                	addiw	s3,s3,1
    80006096:	013a07b3          	add	a5,s4,s3
    8000609a:	0007c783          	lbu	a5,0(a5)
    8000609e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800060a2:	cbed                	beqz	a5,80006194 <printf+0x1ac>
    switch(c){
    800060a4:	05778a63          	beq	a5,s7,800060f8 <printf+0x110>
    800060a8:	02fbf663          	bgeu	s7,a5,800060d4 <printf+0xec>
    800060ac:	09978863          	beq	a5,s9,8000613c <printf+0x154>
    800060b0:	07800713          	li	a4,120
    800060b4:	0ce79563          	bne	a5,a4,8000617e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800060b8:	f8843783          	ld	a5,-120(s0)
    800060bc:	00878713          	addi	a4,a5,8
    800060c0:	f8e43423          	sd	a4,-120(s0)
    800060c4:	4605                	li	a2,1
    800060c6:	85ea                	mv	a1,s10
    800060c8:	4388                	lw	a0,0(a5)
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	e32080e7          	jalr	-462(ra) # 80005efc <printint>
      break;
    800060d2:	bf45                	j	80006082 <printf+0x9a>
    switch(c){
    800060d4:	09578f63          	beq	a5,s5,80006172 <printf+0x18a>
    800060d8:	0b879363          	bne	a5,s8,8000617e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800060dc:	f8843783          	ld	a5,-120(s0)
    800060e0:	00878713          	addi	a4,a5,8
    800060e4:	f8e43423          	sd	a4,-120(s0)
    800060e8:	4605                	li	a2,1
    800060ea:	45a9                	li	a1,10
    800060ec:	4388                	lw	a0,0(a5)
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	e0e080e7          	jalr	-498(ra) # 80005efc <printint>
      break;
    800060f6:	b771                	j	80006082 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800060f8:	f8843783          	ld	a5,-120(s0)
    800060fc:	00878713          	addi	a4,a5,8
    80006100:	f8e43423          	sd	a4,-120(s0)
    80006104:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006108:	03000513          	li	a0,48
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	bd0080e7          	jalr	-1072(ra) # 80005cdc <consputc>
  consputc('x');
    80006114:	07800513          	li	a0,120
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	bc4080e7          	jalr	-1084(ra) # 80005cdc <consputc>
    80006120:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006122:	03c95793          	srli	a5,s2,0x3c
    80006126:	97da                	add	a5,a5,s6
    80006128:	0007c503          	lbu	a0,0(a5)
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	bb0080e7          	jalr	-1104(ra) # 80005cdc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006134:	0912                	slli	s2,s2,0x4
    80006136:	34fd                	addiw	s1,s1,-1
    80006138:	f4ed                	bnez	s1,80006122 <printf+0x13a>
    8000613a:	b7a1                	j	80006082 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000613c:	f8843783          	ld	a5,-120(s0)
    80006140:	00878713          	addi	a4,a5,8
    80006144:	f8e43423          	sd	a4,-120(s0)
    80006148:	6384                	ld	s1,0(a5)
    8000614a:	cc89                	beqz	s1,80006164 <printf+0x17c>
      for(; *s; s++)
    8000614c:	0004c503          	lbu	a0,0(s1)
    80006150:	d90d                	beqz	a0,80006082 <printf+0x9a>
        consputc(*s);
    80006152:	00000097          	auipc	ra,0x0
    80006156:	b8a080e7          	jalr	-1142(ra) # 80005cdc <consputc>
      for(; *s; s++)
    8000615a:	0485                	addi	s1,s1,1
    8000615c:	0004c503          	lbu	a0,0(s1)
    80006160:	f96d                	bnez	a0,80006152 <printf+0x16a>
    80006162:	b705                	j	80006082 <printf+0x9a>
        s = "(null)";
    80006164:	00002497          	auipc	s1,0x2
    80006168:	66448493          	addi	s1,s1,1636 # 800087c8 <syscalls+0x430>
      for(; *s; s++)
    8000616c:	02800513          	li	a0,40
    80006170:	b7cd                	j	80006152 <printf+0x16a>
      consputc('%');
    80006172:	8556                	mv	a0,s5
    80006174:	00000097          	auipc	ra,0x0
    80006178:	b68080e7          	jalr	-1176(ra) # 80005cdc <consputc>
      break;
    8000617c:	b719                	j	80006082 <printf+0x9a>
      consputc('%');
    8000617e:	8556                	mv	a0,s5
    80006180:	00000097          	auipc	ra,0x0
    80006184:	b5c080e7          	jalr	-1188(ra) # 80005cdc <consputc>
      consputc(c);
    80006188:	8526                	mv	a0,s1
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	b52080e7          	jalr	-1198(ra) # 80005cdc <consputc>
      break;
    80006192:	bdc5                	j	80006082 <printf+0x9a>
  if(locking)
    80006194:	020d9163          	bnez	s11,800061b6 <printf+0x1ce>
}
    80006198:	70e6                	ld	ra,120(sp)
    8000619a:	7446                	ld	s0,112(sp)
    8000619c:	74a6                	ld	s1,104(sp)
    8000619e:	7906                	ld	s2,96(sp)
    800061a0:	69e6                	ld	s3,88(sp)
    800061a2:	6a46                	ld	s4,80(sp)
    800061a4:	6aa6                	ld	s5,72(sp)
    800061a6:	6b06                	ld	s6,64(sp)
    800061a8:	7be2                	ld	s7,56(sp)
    800061aa:	7c42                	ld	s8,48(sp)
    800061ac:	7ca2                	ld	s9,40(sp)
    800061ae:	7d02                	ld	s10,32(sp)
    800061b0:	6de2                	ld	s11,24(sp)
    800061b2:	6129                	addi	sp,sp,192
    800061b4:	8082                	ret
    release(&pr.lock);
    800061b6:	00028517          	auipc	a0,0x28
    800061ba:	b2250513          	addi	a0,a0,-1246 # 8002dcd8 <pr>
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	3d0080e7          	jalr	976(ra) # 8000658e <release>
}
    800061c6:	bfc9                	j	80006198 <printf+0x1b0>

00000000800061c8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800061c8:	1101                	addi	sp,sp,-32
    800061ca:	ec06                	sd	ra,24(sp)
    800061cc:	e822                	sd	s0,16(sp)
    800061ce:	e426                	sd	s1,8(sp)
    800061d0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800061d2:	00028497          	auipc	s1,0x28
    800061d6:	b0648493          	addi	s1,s1,-1274 # 8002dcd8 <pr>
    800061da:	00002597          	auipc	a1,0x2
    800061de:	60658593          	addi	a1,a1,1542 # 800087e0 <syscalls+0x448>
    800061e2:	8526                	mv	a0,s1
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	266080e7          	jalr	614(ra) # 8000644a <initlock>
  pr.locking = 1;
    800061ec:	4785                	li	a5,1
    800061ee:	cc9c                	sw	a5,24(s1)
}
    800061f0:	60e2                	ld	ra,24(sp)
    800061f2:	6442                	ld	s0,16(sp)
    800061f4:	64a2                	ld	s1,8(sp)
    800061f6:	6105                	addi	sp,sp,32
    800061f8:	8082                	ret

00000000800061fa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061fa:	1141                	addi	sp,sp,-16
    800061fc:	e406                	sd	ra,8(sp)
    800061fe:	e022                	sd	s0,0(sp)
    80006200:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006202:	100007b7          	lui	a5,0x10000
    80006206:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000620a:	f8000713          	li	a4,-128
    8000620e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006212:	470d                	li	a4,3
    80006214:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006218:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000621c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006220:	469d                	li	a3,7
    80006222:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006226:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000622a:	00002597          	auipc	a1,0x2
    8000622e:	5d658593          	addi	a1,a1,1494 # 80008800 <digits+0x18>
    80006232:	00028517          	auipc	a0,0x28
    80006236:	ac650513          	addi	a0,a0,-1338 # 8002dcf8 <uart_tx_lock>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	210080e7          	jalr	528(ra) # 8000644a <initlock>
}
    80006242:	60a2                	ld	ra,8(sp)
    80006244:	6402                	ld	s0,0(sp)
    80006246:	0141                	addi	sp,sp,16
    80006248:	8082                	ret

000000008000624a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000624a:	1101                	addi	sp,sp,-32
    8000624c:	ec06                	sd	ra,24(sp)
    8000624e:	e822                	sd	s0,16(sp)
    80006250:	e426                	sd	s1,8(sp)
    80006252:	1000                	addi	s0,sp,32
    80006254:	84aa                	mv	s1,a0
  push_off();
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	238080e7          	jalr	568(ra) # 8000648e <push_off>

  if(panicked){
    8000625e:	00002797          	auipc	a5,0x2
    80006262:	64e7a783          	lw	a5,1614(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006266:	10000737          	lui	a4,0x10000
  if(panicked){
    8000626a:	c391                	beqz	a5,8000626e <uartputc_sync+0x24>
    for(;;)
    8000626c:	a001                	j	8000626c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000626e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006272:	0207f793          	andi	a5,a5,32
    80006276:	dfe5                	beqz	a5,8000626e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006278:	0ff4f513          	zext.b	a0,s1
    8000627c:	100007b7          	lui	a5,0x10000
    80006280:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006284:	00000097          	auipc	ra,0x0
    80006288:	2aa080e7          	jalr	682(ra) # 8000652e <pop_off>
}
    8000628c:	60e2                	ld	ra,24(sp)
    8000628e:	6442                	ld	s0,16(sp)
    80006290:	64a2                	ld	s1,8(sp)
    80006292:	6105                	addi	sp,sp,32
    80006294:	8082                	ret

0000000080006296 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006296:	00002797          	auipc	a5,0x2
    8000629a:	61a7b783          	ld	a5,1562(a5) # 800088b0 <uart_tx_r>
    8000629e:	00002717          	auipc	a4,0x2
    800062a2:	61a73703          	ld	a4,1562(a4) # 800088b8 <uart_tx_w>
    800062a6:	06f70a63          	beq	a4,a5,8000631a <uartstart+0x84>
{
    800062aa:	7139                	addi	sp,sp,-64
    800062ac:	fc06                	sd	ra,56(sp)
    800062ae:	f822                	sd	s0,48(sp)
    800062b0:	f426                	sd	s1,40(sp)
    800062b2:	f04a                	sd	s2,32(sp)
    800062b4:	ec4e                	sd	s3,24(sp)
    800062b6:	e852                	sd	s4,16(sp)
    800062b8:	e456                	sd	s5,8(sp)
    800062ba:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062bc:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062c0:	00028a17          	auipc	s4,0x28
    800062c4:	a38a0a13          	addi	s4,s4,-1480 # 8002dcf8 <uart_tx_lock>
    uart_tx_r += 1;
    800062c8:	00002497          	auipc	s1,0x2
    800062cc:	5e848493          	addi	s1,s1,1512 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800062d0:	00002997          	auipc	s3,0x2
    800062d4:	5e898993          	addi	s3,s3,1512 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062d8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800062dc:	02077713          	andi	a4,a4,32
    800062e0:	c705                	beqz	a4,80006308 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062e2:	01f7f713          	andi	a4,a5,31
    800062e6:	9752                	add	a4,a4,s4
    800062e8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800062ec:	0785                	addi	a5,a5,1
    800062ee:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800062f0:	8526                	mv	a0,s1
    800062f2:	ffffb097          	auipc	ra,0xffffb
    800062f6:	252080e7          	jalr	594(ra) # 80001544 <wakeup>
    
    WriteReg(THR, c);
    800062fa:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800062fe:	609c                	ld	a5,0(s1)
    80006300:	0009b703          	ld	a4,0(s3)
    80006304:	fcf71ae3          	bne	a4,a5,800062d8 <uartstart+0x42>
  }
}
    80006308:	70e2                	ld	ra,56(sp)
    8000630a:	7442                	ld	s0,48(sp)
    8000630c:	74a2                	ld	s1,40(sp)
    8000630e:	7902                	ld	s2,32(sp)
    80006310:	69e2                	ld	s3,24(sp)
    80006312:	6a42                	ld	s4,16(sp)
    80006314:	6aa2                	ld	s5,8(sp)
    80006316:	6121                	addi	sp,sp,64
    80006318:	8082                	ret
    8000631a:	8082                	ret

000000008000631c <uartputc>:
{
    8000631c:	7179                	addi	sp,sp,-48
    8000631e:	f406                	sd	ra,40(sp)
    80006320:	f022                	sd	s0,32(sp)
    80006322:	ec26                	sd	s1,24(sp)
    80006324:	e84a                	sd	s2,16(sp)
    80006326:	e44e                	sd	s3,8(sp)
    80006328:	e052                	sd	s4,0(sp)
    8000632a:	1800                	addi	s0,sp,48
    8000632c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000632e:	00028517          	auipc	a0,0x28
    80006332:	9ca50513          	addi	a0,a0,-1590 # 8002dcf8 <uart_tx_lock>
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	1a4080e7          	jalr	420(ra) # 800064da <acquire>
  if(panicked){
    8000633e:	00002797          	auipc	a5,0x2
    80006342:	56e7a783          	lw	a5,1390(a5) # 800088ac <panicked>
    80006346:	e7c9                	bnez	a5,800063d0 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006348:	00002717          	auipc	a4,0x2
    8000634c:	57073703          	ld	a4,1392(a4) # 800088b8 <uart_tx_w>
    80006350:	00002797          	auipc	a5,0x2
    80006354:	5607b783          	ld	a5,1376(a5) # 800088b0 <uart_tx_r>
    80006358:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000635c:	00028997          	auipc	s3,0x28
    80006360:	99c98993          	addi	s3,s3,-1636 # 8002dcf8 <uart_tx_lock>
    80006364:	00002497          	auipc	s1,0x2
    80006368:	54c48493          	addi	s1,s1,1356 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000636c:	00002917          	auipc	s2,0x2
    80006370:	54c90913          	addi	s2,s2,1356 # 800088b8 <uart_tx_w>
    80006374:	00e79f63          	bne	a5,a4,80006392 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006378:	85ce                	mv	a1,s3
    8000637a:	8526                	mv	a0,s1
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	164080e7          	jalr	356(ra) # 800014e0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006384:	00093703          	ld	a4,0(s2)
    80006388:	609c                	ld	a5,0(s1)
    8000638a:	02078793          	addi	a5,a5,32
    8000638e:	fee785e3          	beq	a5,a4,80006378 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006392:	00028497          	auipc	s1,0x28
    80006396:	96648493          	addi	s1,s1,-1690 # 8002dcf8 <uart_tx_lock>
    8000639a:	01f77793          	andi	a5,a4,31
    8000639e:	97a6                	add	a5,a5,s1
    800063a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800063a4:	0705                	addi	a4,a4,1
    800063a6:	00002797          	auipc	a5,0x2
    800063aa:	50e7b923          	sd	a4,1298(a5) # 800088b8 <uart_tx_w>
  uartstart();
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	ee8080e7          	jalr	-280(ra) # 80006296 <uartstart>
  release(&uart_tx_lock);
    800063b6:	8526                	mv	a0,s1
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	1d6080e7          	jalr	470(ra) # 8000658e <release>
}
    800063c0:	70a2                	ld	ra,40(sp)
    800063c2:	7402                	ld	s0,32(sp)
    800063c4:	64e2                	ld	s1,24(sp)
    800063c6:	6942                	ld	s2,16(sp)
    800063c8:	69a2                	ld	s3,8(sp)
    800063ca:	6a02                	ld	s4,0(sp)
    800063cc:	6145                	addi	sp,sp,48
    800063ce:	8082                	ret
    for(;;)
    800063d0:	a001                	j	800063d0 <uartputc+0xb4>

00000000800063d2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063d2:	1141                	addi	sp,sp,-16
    800063d4:	e422                	sd	s0,8(sp)
    800063d6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063d8:	100007b7          	lui	a5,0x10000
    800063dc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800063e0:	8b85                	andi	a5,a5,1
    800063e2:	cb91                	beqz	a5,800063f6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800063e4:	100007b7          	lui	a5,0x10000
    800063e8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800063ec:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    800063f0:	6422                	ld	s0,8(sp)
    800063f2:	0141                	addi	sp,sp,16
    800063f4:	8082                	ret
    return -1;
    800063f6:	557d                	li	a0,-1
    800063f8:	bfe5                	j	800063f0 <uartgetc+0x1e>

00000000800063fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800063fa:	1101                	addi	sp,sp,-32
    800063fc:	ec06                	sd	ra,24(sp)
    800063fe:	e822                	sd	s0,16(sp)
    80006400:	e426                	sd	s1,8(sp)
    80006402:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006404:	54fd                	li	s1,-1
    80006406:	a029                	j	80006410 <uartintr+0x16>
      break;
    consoleintr(c);
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	916080e7          	jalr	-1770(ra) # 80005d1e <consoleintr>
    int c = uartgetc();
    80006410:	00000097          	auipc	ra,0x0
    80006414:	fc2080e7          	jalr	-62(ra) # 800063d2 <uartgetc>
    if(c == -1)
    80006418:	fe9518e3          	bne	a0,s1,80006408 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000641c:	00028497          	auipc	s1,0x28
    80006420:	8dc48493          	addi	s1,s1,-1828 # 8002dcf8 <uart_tx_lock>
    80006424:	8526                	mv	a0,s1
    80006426:	00000097          	auipc	ra,0x0
    8000642a:	0b4080e7          	jalr	180(ra) # 800064da <acquire>
  uartstart();
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	e68080e7          	jalr	-408(ra) # 80006296 <uartstart>
  release(&uart_tx_lock);
    80006436:	8526                	mv	a0,s1
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	156080e7          	jalr	342(ra) # 8000658e <release>
}
    80006440:	60e2                	ld	ra,24(sp)
    80006442:	6442                	ld	s0,16(sp)
    80006444:	64a2                	ld	s1,8(sp)
    80006446:	6105                	addi	sp,sp,32
    80006448:	8082                	ret

000000008000644a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000644a:	1141                	addi	sp,sp,-16
    8000644c:	e422                	sd	s0,8(sp)
    8000644e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006450:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006452:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006456:	00053823          	sd	zero,16(a0)
}
    8000645a:	6422                	ld	s0,8(sp)
    8000645c:	0141                	addi	sp,sp,16
    8000645e:	8082                	ret

0000000080006460 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006460:	411c                	lw	a5,0(a0)
    80006462:	e399                	bnez	a5,80006468 <holding+0x8>
    80006464:	4501                	li	a0,0
  return r;
}
    80006466:	8082                	ret
{
    80006468:	1101                	addi	sp,sp,-32
    8000646a:	ec06                	sd	ra,24(sp)
    8000646c:	e822                	sd	s0,16(sp)
    8000646e:	e426                	sd	s1,8(sp)
    80006470:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006472:	6904                	ld	s1,16(a0)
    80006474:	ffffb097          	auipc	ra,0xffffb
    80006478:	9a8080e7          	jalr	-1624(ra) # 80000e1c <mycpu>
    8000647c:	40a48533          	sub	a0,s1,a0
    80006480:	00153513          	seqz	a0,a0
}
    80006484:	60e2                	ld	ra,24(sp)
    80006486:	6442                	ld	s0,16(sp)
    80006488:	64a2                	ld	s1,8(sp)
    8000648a:	6105                	addi	sp,sp,32
    8000648c:	8082                	ret

000000008000648e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000648e:	1101                	addi	sp,sp,-32
    80006490:	ec06                	sd	ra,24(sp)
    80006492:	e822                	sd	s0,16(sp)
    80006494:	e426                	sd	s1,8(sp)
    80006496:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006498:	100024f3          	csrr	s1,sstatus
    8000649c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064a0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064a2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064a6:	ffffb097          	auipc	ra,0xffffb
    800064aa:	976080e7          	jalr	-1674(ra) # 80000e1c <mycpu>
    800064ae:	5d3c                	lw	a5,120(a0)
    800064b0:	cf89                	beqz	a5,800064ca <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064b2:	ffffb097          	auipc	ra,0xffffb
    800064b6:	96a080e7          	jalr	-1686(ra) # 80000e1c <mycpu>
    800064ba:	5d3c                	lw	a5,120(a0)
    800064bc:	2785                	addiw	a5,a5,1
    800064be:	dd3c                	sw	a5,120(a0)
}
    800064c0:	60e2                	ld	ra,24(sp)
    800064c2:	6442                	ld	s0,16(sp)
    800064c4:	64a2                	ld	s1,8(sp)
    800064c6:	6105                	addi	sp,sp,32
    800064c8:	8082                	ret
    mycpu()->intena = old;
    800064ca:	ffffb097          	auipc	ra,0xffffb
    800064ce:	952080e7          	jalr	-1710(ra) # 80000e1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800064d2:	8085                	srli	s1,s1,0x1
    800064d4:	8885                	andi	s1,s1,1
    800064d6:	dd64                	sw	s1,124(a0)
    800064d8:	bfe9                	j	800064b2 <push_off+0x24>

00000000800064da <acquire>:
{
    800064da:	1101                	addi	sp,sp,-32
    800064dc:	ec06                	sd	ra,24(sp)
    800064de:	e822                	sd	s0,16(sp)
    800064e0:	e426                	sd	s1,8(sp)
    800064e2:	1000                	addi	s0,sp,32
    800064e4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064e6:	00000097          	auipc	ra,0x0
    800064ea:	fa8080e7          	jalr	-88(ra) # 8000648e <push_off>
  if(holding(lk))
    800064ee:	8526                	mv	a0,s1
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	f70080e7          	jalr	-144(ra) # 80006460 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064f8:	4705                	li	a4,1
  if(holding(lk))
    800064fa:	e115                	bnez	a0,8000651e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064fc:	87ba                	mv	a5,a4
    800064fe:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006502:	2781                	sext.w	a5,a5
    80006504:	ffe5                	bnez	a5,800064fc <acquire+0x22>
  __sync_synchronize();
    80006506:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000650a:	ffffb097          	auipc	ra,0xffffb
    8000650e:	912080e7          	jalr	-1774(ra) # 80000e1c <mycpu>
    80006512:	e888                	sd	a0,16(s1)
}
    80006514:	60e2                	ld	ra,24(sp)
    80006516:	6442                	ld	s0,16(sp)
    80006518:	64a2                	ld	s1,8(sp)
    8000651a:	6105                	addi	sp,sp,32
    8000651c:	8082                	ret
    panic("acquire");
    8000651e:	00002517          	auipc	a0,0x2
    80006522:	2ea50513          	addi	a0,a0,746 # 80008808 <digits+0x20>
    80006526:	00000097          	auipc	ra,0x0
    8000652a:	a78080e7          	jalr	-1416(ra) # 80005f9e <panic>

000000008000652e <pop_off>:

void
pop_off(void)
{
    8000652e:	1141                	addi	sp,sp,-16
    80006530:	e406                	sd	ra,8(sp)
    80006532:	e022                	sd	s0,0(sp)
    80006534:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006536:	ffffb097          	auipc	ra,0xffffb
    8000653a:	8e6080e7          	jalr	-1818(ra) # 80000e1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000653e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006542:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006544:	e78d                	bnez	a5,8000656e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006546:	5d3c                	lw	a5,120(a0)
    80006548:	02f05b63          	blez	a5,8000657e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000654c:	37fd                	addiw	a5,a5,-1
    8000654e:	0007871b          	sext.w	a4,a5
    80006552:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006554:	eb09                	bnez	a4,80006566 <pop_off+0x38>
    80006556:	5d7c                	lw	a5,124(a0)
    80006558:	c799                	beqz	a5,80006566 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000655a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000655e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006562:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006566:	60a2                	ld	ra,8(sp)
    80006568:	6402                	ld	s0,0(sp)
    8000656a:	0141                	addi	sp,sp,16
    8000656c:	8082                	ret
    panic("pop_off - interruptible");
    8000656e:	00002517          	auipc	a0,0x2
    80006572:	2a250513          	addi	a0,a0,674 # 80008810 <digits+0x28>
    80006576:	00000097          	auipc	ra,0x0
    8000657a:	a28080e7          	jalr	-1496(ra) # 80005f9e <panic>
    panic("pop_off");
    8000657e:	00002517          	auipc	a0,0x2
    80006582:	2aa50513          	addi	a0,a0,682 # 80008828 <digits+0x40>
    80006586:	00000097          	auipc	ra,0x0
    8000658a:	a18080e7          	jalr	-1512(ra) # 80005f9e <panic>

000000008000658e <release>:
{
    8000658e:	1101                	addi	sp,sp,-32
    80006590:	ec06                	sd	ra,24(sp)
    80006592:	e822                	sd	s0,16(sp)
    80006594:	e426                	sd	s1,8(sp)
    80006596:	1000                	addi	s0,sp,32
    80006598:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	ec6080e7          	jalr	-314(ra) # 80006460 <holding>
    800065a2:	c115                	beqz	a0,800065c6 <release+0x38>
  lk->cpu = 0;
    800065a4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065a8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800065ac:	0f50000f          	fence	iorw,ow
    800065b0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800065b4:	00000097          	auipc	ra,0x0
    800065b8:	f7a080e7          	jalr	-134(ra) # 8000652e <pop_off>
}
    800065bc:	60e2                	ld	ra,24(sp)
    800065be:	6442                	ld	s0,16(sp)
    800065c0:	64a2                	ld	s1,8(sp)
    800065c2:	6105                	addi	sp,sp,32
    800065c4:	8082                	ret
    panic("release");
    800065c6:	00002517          	auipc	a0,0x2
    800065ca:	26a50513          	addi	a0,a0,618 # 80008830 <digits+0x48>
    800065ce:	00000097          	auipc	ra,0x0
    800065d2:	9d0080e7          	jalr	-1584(ra) # 80005f9e <panic>
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
