
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00024117          	auipc	sp,0x24
    80000004:	c4010113          	addi	sp,sp,-960 # 80023c40 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	069050ef          	jal	ra,8000587e <start>

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
    80000030:	0002c797          	auipc	a5,0x2c
    80000034:	d1078793          	addi	a5,a5,-752 # 8002bd40 <end>
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
    80000054:	88090913          	addi	s2,s2,-1920 # 800088d0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	210080e7          	jalr	528(ra) # 8000626a <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2b0080e7          	jalr	688(ra) # 8000631e <release>
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
    8000008e:	ca4080e7          	jalr	-860(ra) # 80005d2e <panic>

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
    800000f0:	7e450513          	addi	a0,a0,2020 # 800088d0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0e6080e7          	jalr	230(ra) # 800061da <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002c517          	auipc	a0,0x2c
    80000104:	c4050513          	addi	a0,a0,-960 # 8002bd40 <end>
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
    80000126:	7ae48493          	addi	s1,s1,1966 # 800088d0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	13e080e7          	jalr	318(ra) # 8000626a <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	79650513          	addi	a0,a0,1942 # 800088d0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1da080e7          	jalr	474(ra) # 8000631e <release>

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
    8000016a:	76a50513          	addi	a0,a0,1898 # 800088d0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1b0080e7          	jalr	432(ra) # 8000631e <release>
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
    80000332:	57270713          	addi	a4,a4,1394 # 800088a0 <started>
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
    80000358:	a24080e7          	jalr	-1500(ra) # 80005d78 <printf>
    kvminithart();  // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	772080e7          	jalr	1906(ra) # 80001ad6 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	ec4080e7          	jalr	-316(ra) # 80005230 <plicinithart>
  }

  scheduler();
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fba080e7          	jalr	-70(ra) # 8000132e <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	8c4080e7          	jalr	-1852(ra) # 80005c40 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	bd4080e7          	jalr	-1068(ra) # 80005f58 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	9e4080e7          	jalr	-1564(ra) # 80005d78 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	9d4080e7          	jalr	-1580(ra) # 80005d78 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	9c4080e7          	jalr	-1596(ra) # 80005d78 <printf>
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
    800003f0:	e2e080e7          	jalr	-466(ra) # 8000521a <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e3c080e7          	jalr	-452(ra) # 80005230 <plicinithart>
    binit();            // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e4a080e7          	jalr	-438(ra) # 80002246 <binit>
    iinit();            // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4f0080e7          	jalr	1264(ra) # 800028f4 <iinit>
    fileinit();         // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	492080e7          	jalr	1170(ra) # 8000389e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	f24080e7          	jalr	-220(ra) # 80005338 <virtio_disk_init>
    userinit();         // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	cf4080e7          	jalr	-780(ra) # 80001110 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72b23          	sw	a5,1142(a4) # 800088a0 <started>
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
    80000442:	46a7b783          	ld	a5,1130(a5) # 800088a8 <kernel_pagetable>
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
    8000048e:	8a4080e7          	jalr	-1884(ra) # 80005d2e <panic>
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
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	77e080e7          	jalr	1918(ra) # 80005d2e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	76e080e7          	jalr	1902(ra) # 80005d2e <panic>
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
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	722080e7          	jalr	1826(ra) # 80005d2e <panic>

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
    800006fe:	1aa7b723          	sd	a0,430(a5) # 800088a8 <kernel_pagetable>
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
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	5d6080e7          	jalr	1494(ra) # 80005d2e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	5c6080e7          	jalr	1478(ra) # 80005d2e <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	5b6080e7          	jalr	1462(ra) # 80005d2e <panic>
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
    8000085c:	4d6080e7          	jalr	1238(ra) # 80005d2e <panic>

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
    800009a6:	38c080e7          	jalr	908(ra) # 80005d2e <panic>
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
    80000a2a:	308080e7          	jalr	776(ra) # 80005d2e <panic>
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
    80000af0:	242080e7          	jalr	578(ra) # 80005d2e <panic>

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
    80000cdc:	04848493          	addi	s1,s1,72 # 80008d20 <proc>
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
    80000cf2:	00018a17          	auipc	s4,0x18
    80000cf6:	a2ea0a13          	addi	s4,s4,-1490 # 80018720 <tickslock>
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
    80000d2c:	3e848493          	addi	s1,s1,1000
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
    80000d54:	fde080e7          	jalr	-34(ra) # 80005d2e <panic>

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
    80000d78:	b7c50513          	addi	a0,a0,-1156 # 800088f0 <pid_lock>
    80000d7c:	00005097          	auipc	ra,0x5
    80000d80:	45e080e7          	jalr	1118(ra) # 800061da <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d84:	00007597          	auipc	a1,0x7
    80000d88:	3ac58593          	addi	a1,a1,940 # 80008130 <etext+0x130>
    80000d8c:	00008517          	auipc	a0,0x8
    80000d90:	b7c50513          	addi	a0,a0,-1156 # 80008908 <wait_lock>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	446080e7          	jalr	1094(ra) # 800061da <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9c:	00008497          	auipc	s1,0x8
    80000da0:	f8448493          	addi	s1,s1,-124 # 80008d20 <proc>
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
    80000dbe:	00018997          	auipc	s3,0x18
    80000dc2:	96298993          	addi	s3,s3,-1694 # 80018720 <tickslock>
      initlock(&p->lock, "proc");
    80000dc6:	85da                	mv	a1,s6
    80000dc8:	8526                	mv	a0,s1
    80000dca:	00005097          	auipc	ra,0x5
    80000dce:	410080e7          	jalr	1040(ra) # 800061da <initlock>
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
    80000df0:	3e848493          	addi	s1,s1,1000
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
    80000e2c:	af850513          	addi	a0,a0,-1288 # 80008920 <cpus>
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
    80000e46:	3dc080e7          	jalr	988(ra) # 8000621e <push_off>
    80000e4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e4c:	2781                	sext.w	a5,a5
    80000e4e:	079e                	slli	a5,a5,0x7
    80000e50:	00008717          	auipc	a4,0x8
    80000e54:	aa070713          	addi	a4,a4,-1376 # 800088f0 <pid_lock>
    80000e58:	97ba                	add	a5,a5,a4
    80000e5a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	462080e7          	jalr	1122(ra) # 800062be <pop_off>
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
    80000e84:	49e080e7          	jalr	1182(ra) # 8000631e <release>

  if (first) {
    80000e88:	00008797          	auipc	a5,0x8
    80000e8c:	9c87a783          	lw	a5,-1592(a5) # 80008850 <first.1>
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
    80000ea6:	9a07a723          	sw	zero,-1618(a5) # 80008850 <first.1>
    fsinit(ROOTDEV);
    80000eaa:	4505                	li	a0,1
    80000eac:	00002097          	auipc	ra,0x2
    80000eb0:	9c8080e7          	jalr	-1592(ra) # 80002874 <fsinit>
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
    80000ec6:	a2e90913          	addi	s2,s2,-1490 # 800088f0 <pid_lock>
    80000eca:	854a                	mv	a0,s2
    80000ecc:	00005097          	auipc	ra,0x5
    80000ed0:	39e080e7          	jalr	926(ra) # 8000626a <acquire>
  pid = nextpid;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	98078793          	addi	a5,a5,-1664 # 80008854 <nextpid>
    80000edc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ede:	0014871b          	addiw	a4,s1,1
    80000ee2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	438080e7          	jalr	1080(ra) # 8000631e <release>
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
    80001052:	cd248493          	addi	s1,s1,-814 # 80008d20 <proc>
    80001056:	00017917          	auipc	s2,0x17
    8000105a:	6ca90913          	addi	s2,s2,1738 # 80018720 <tickslock>
    acquire(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	20a080e7          	jalr	522(ra) # 8000626a <acquire>
    if(p->state == UNUSED) {
    80001068:	4c9c                	lw	a5,24(s1)
    8000106a:	cf81                	beqz	a5,80001082 <allocproc+0x40>
      release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	00005097          	auipc	ra,0x5
    80001072:	2b0080e7          	jalr	688(ra) # 8000631e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001076:	3e848493          	addi	s1,s1,1000
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
    800010f0:	232080e7          	jalr	562(ra) # 8000631e <release>
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
    80001108:	21a080e7          	jalr	538(ra) # 8000631e <release>
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
    80001128:	78a7b623          	sd	a0,1932(a5) # 800088b0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000112c:	03400613          	li	a2,52
    80001130:	00007597          	auipc	a1,0x7
    80001134:	73058593          	addi	a1,a1,1840 # 80008860 <initcode>
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
    80001172:	128080e7          	jalr	296(ra) # 80003296 <namei>
    80001176:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000117a:	478d                	li	a5,3
    8000117c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	19e080e7          	jalr	414(ra) # 8000631e <release>
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
    8000128a:	098080e7          	jalr	152(ra) # 8000631e <release>
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
    800012a2:	692080e7          	jalr	1682(ra) # 80003930 <filedup>
    800012a6:	00a93023          	sd	a0,0(s2)
    800012aa:	b7e5                	j	80001292 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012ac:	150ab503          	ld	a0,336(s5)
    800012b0:	00002097          	auipc	ra,0x2
    800012b4:	802080e7          	jalr	-2046(ra) # 80002ab2 <idup>
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
    800012d8:	04a080e7          	jalr	74(ra) # 8000631e <release>
  acquire(&wait_lock);
    800012dc:	00007497          	auipc	s1,0x7
    800012e0:	62c48493          	addi	s1,s1,1580 # 80008908 <wait_lock>
    800012e4:	8526                	mv	a0,s1
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	f84080e7          	jalr	-124(ra) # 8000626a <acquire>
  np->parent = p;
    800012ee:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800012f2:	8526                	mv	a0,s1
    800012f4:	00005097          	auipc	ra,0x5
    800012f8:	02a080e7          	jalr	42(ra) # 8000631e <release>
  acquire(&np->lock);
    800012fc:	8552                	mv	a0,s4
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	f6c080e7          	jalr	-148(ra) # 8000626a <acquire>
  np->state = RUNNABLE;
    80001306:	478d                	li	a5,3
    80001308:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000130c:	8552                	mv	a0,s4
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	010080e7          	jalr	16(ra) # 8000631e <release>
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
    8000134e:	5a670713          	addi	a4,a4,1446 # 800088f0 <pid_lock>
    80001352:	9756                	add	a4,a4,s5
    80001354:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001358:	00007717          	auipc	a4,0x7
    8000135c:	5d070713          	addi	a4,a4,1488 # 80008928 <cpus+0x8>
    80001360:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001362:	498d                	li	s3,3
        p->state = RUNNING;
    80001364:	4b11                	li	s6,4
        c->proc = p;
    80001366:	079e                	slli	a5,a5,0x7
    80001368:	00007a17          	auipc	s4,0x7
    8000136c:	588a0a13          	addi	s4,s4,1416 # 800088f0 <pid_lock>
    80001370:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001372:	00017917          	auipc	s2,0x17
    80001376:	3ae90913          	addi	s2,s2,942 # 80018720 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000137e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001382:	10079073          	csrw	sstatus,a5
    80001386:	00008497          	auipc	s1,0x8
    8000138a:	99a48493          	addi	s1,s1,-1638 # 80008d20 <proc>
    8000138e:	a811                	j	800013a2 <scheduler+0x74>
      release(&p->lock);
    80001390:	8526                	mv	a0,s1
    80001392:	00005097          	auipc	ra,0x5
    80001396:	f8c080e7          	jalr	-116(ra) # 8000631e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	3e848493          	addi	s1,s1,1000
    8000139e:	fd248ee3          	beq	s1,s2,8000137a <scheduler+0x4c>
      acquire(&p->lock);
    800013a2:	8526                	mv	a0,s1
    800013a4:	00005097          	auipc	ra,0x5
    800013a8:	ec6080e7          	jalr	-314(ra) # 8000626a <acquire>
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
    800013ea:	e0a080e7          	jalr	-502(ra) # 800061f0 <holding>
    800013ee:	c93d                	beqz	a0,80001464 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013f0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013f2:	2781                	sext.w	a5,a5
    800013f4:	079e                	slli	a5,a5,0x7
    800013f6:	00007717          	auipc	a4,0x7
    800013fa:	4fa70713          	addi	a4,a4,1274 # 800088f0 <pid_lock>
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
    80001420:	4d490913          	addi	s2,s2,1236 # 800088f0 <pid_lock>
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	97ca                	add	a5,a5,s2
    8000142a:	0ac7a983          	lw	s3,172(a5)
    8000142e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001430:	2781                	sext.w	a5,a5
    80001432:	079e                	slli	a5,a5,0x7
    80001434:	00007597          	auipc	a1,0x7
    80001438:	4f458593          	addi	a1,a1,1268 # 80008928 <cpus+0x8>
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
    80001470:	8c2080e7          	jalr	-1854(ra) # 80005d2e <panic>
    panic("sched locks");
    80001474:	00007517          	auipc	a0,0x7
    80001478:	cfc50513          	addi	a0,a0,-772 # 80008170 <etext+0x170>
    8000147c:	00005097          	auipc	ra,0x5
    80001480:	8b2080e7          	jalr	-1870(ra) # 80005d2e <panic>
    panic("sched running");
    80001484:	00007517          	auipc	a0,0x7
    80001488:	cfc50513          	addi	a0,a0,-772 # 80008180 <etext+0x180>
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	8a2080e7          	jalr	-1886(ra) # 80005d2e <panic>
    panic("sched interruptible");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	cfc50513          	addi	a0,a0,-772 # 80008190 <etext+0x190>
    8000149c:	00005097          	auipc	ra,0x5
    800014a0:	892080e7          	jalr	-1902(ra) # 80005d2e <panic>

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
    800014bc:	db2080e7          	jalr	-590(ra) # 8000626a <acquire>
  p->state = RUNNABLE;
    800014c0:	478d                	li	a5,3
    800014c2:	cc9c                	sw	a5,24(s1)
  sched();
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	f0a080e7          	jalr	-246(ra) # 800013ce <sched>
  release(&p->lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	e50080e7          	jalr	-432(ra) # 8000631e <release>
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
    80001500:	d6e080e7          	jalr	-658(ra) # 8000626a <acquire>
  release(lk);
    80001504:	854a                	mv	a0,s2
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	e18080e7          	jalr	-488(ra) # 8000631e <release>

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
    80001528:	dfa080e7          	jalr	-518(ra) # 8000631e <release>
  acquire(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	d3c080e7          	jalr	-708(ra) # 8000626a <acquire>
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
    8000155c:	7c848493          	addi	s1,s1,1992 # 80008d20 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001560:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001562:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001564:	00017917          	auipc	s2,0x17
    80001568:	1bc90913          	addi	s2,s2,444 # 80018720 <tickslock>
    8000156c:	a811                	j	80001580 <wakeup+0x3c>
      }
      release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	dae080e7          	jalr	-594(ra) # 8000631e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001578:	3e848493          	addi	s1,s1,1000
    8000157c:	03248663          	beq	s1,s2,800015a8 <wakeup+0x64>
    if(p != myproc()){
    80001580:	00000097          	auipc	ra,0x0
    80001584:	8b8080e7          	jalr	-1864(ra) # 80000e38 <myproc>
    80001588:	fea488e3          	beq	s1,a0,80001578 <wakeup+0x34>
      acquire(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	cdc080e7          	jalr	-804(ra) # 8000626a <acquire>
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
    800015d0:	75448493          	addi	s1,s1,1876 # 80008d20 <proc>
      pp->parent = initproc;
    800015d4:	00007a17          	auipc	s4,0x7
    800015d8:	2dca0a13          	addi	s4,s4,732 # 800088b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015dc:	00017997          	auipc	s3,0x17
    800015e0:	14498993          	addi	s3,s3,324 # 80018720 <tickslock>
    800015e4:	a029                	j	800015ee <reparent+0x34>
    800015e6:	3e848493          	addi	s1,s1,1000
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
    80001634:	2807b783          	ld	a5,640(a5) # 800088b0 <initproc>
    80001638:	0d050493          	addi	s1,a0,208
    8000163c:	15050913          	addi	s2,a0,336
    80001640:	02a79363          	bne	a5,a0,80001666 <exit+0x52>
    panic("init exiting");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b6450513          	addi	a0,a0,-1180 # 800081a8 <etext+0x1a8>
    8000164c:	00004097          	auipc	ra,0x4
    80001650:	6e2080e7          	jalr	1762(ra) # 80005d2e <panic>
      fileclose(f);
    80001654:	00002097          	auipc	ra,0x2
    80001658:	32e080e7          	jalr	814(ra) # 80003982 <fileclose>
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
    80001670:	e4a080e7          	jalr	-438(ra) # 800034b6 <begin_op>
  iput(p->cwd);
    80001674:	1509b503          	ld	a0,336(s3)
    80001678:	00001097          	auipc	ra,0x1
    8000167c:	632080e7          	jalr	1586(ra) # 80002caa <iput>
  end_op();
    80001680:	00002097          	auipc	ra,0x2
    80001684:	eb6080e7          	jalr	-330(ra) # 80003536 <end_op>
  p->cwd = 0;
    80001688:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000168c:	00007497          	auipc	s1,0x7
    80001690:	27c48493          	addi	s1,s1,636 # 80008908 <wait_lock>
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	bd4080e7          	jalr	-1068(ra) # 8000626a <acquire>
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
    800016ba:	bb4080e7          	jalr	-1100(ra) # 8000626a <acquire>
  p->xstate = status;
    800016be:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016c2:	4795                	li	a5,5
    800016c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016c8:	8526                	mv	a0,s1
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	c54080e7          	jalr	-940(ra) # 8000631e <release>
  sched();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	cfc080e7          	jalr	-772(ra) # 800013ce <sched>
  panic("zombie exit");
    800016da:	00007517          	auipc	a0,0x7
    800016de:	ade50513          	addi	a0,a0,-1314 # 800081b8 <etext+0x1b8>
    800016e2:	00004097          	auipc	ra,0x4
    800016e6:	64c080e7          	jalr	1612(ra) # 80005d2e <panic>

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
    800016fe:	62648493          	addi	s1,s1,1574 # 80008d20 <proc>
    80001702:	00017997          	auipc	s3,0x17
    80001706:	01e98993          	addi	s3,s3,30 # 80018720 <tickslock>
    acquire(&p->lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	b5e080e7          	jalr	-1186(ra) # 8000626a <acquire>
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
    80001720:	c02080e7          	jalr	-1022(ra) # 8000631e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001724:	3e848493          	addi	s1,s1,1000
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
    80001742:	be0080e7          	jalr	-1056(ra) # 8000631e <release>
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
    8000176c:	b02080e7          	jalr	-1278(ra) # 8000626a <acquire>
  p->killed = 1;
    80001770:	4785                	li	a5,1
    80001772:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	ba8080e7          	jalr	-1112(ra) # 8000631e <release>
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
    8000179a:	ad4080e7          	jalr	-1324(ra) # 8000626a <acquire>
  k = p->killed;
    8000179e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017a2:	8526                	mv	a0,s1
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	b7a080e7          	jalr	-1158(ra) # 8000631e <release>
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
    800017e2:	12a50513          	addi	a0,a0,298 # 80008908 <wait_lock>
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	a84080e7          	jalr	-1404(ra) # 8000626a <acquire>
    havekids = 0;
    800017ee:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800017f0:	4a15                	li	s4,5
        havekids = 1;
    800017f2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017f4:	00017997          	auipc	s3,0x17
    800017f8:	f2c98993          	addi	s3,s3,-212 # 80018720 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fc:	00007c17          	auipc	s8,0x7
    80001800:	10cc0c13          	addi	s8,s8,268 # 80008908 <wait_lock>
    havekids = 0;
    80001804:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001806:	00007497          	auipc	s1,0x7
    8000180a:	51a48493          	addi	s1,s1,1306 # 80008d20 <proc>
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
    80001840:	ae2080e7          	jalr	-1310(ra) # 8000631e <release>
          release(&wait_lock);
    80001844:	00007517          	auipc	a0,0x7
    80001848:	0c450513          	addi	a0,a0,196 # 80008908 <wait_lock>
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	ad2080e7          	jalr	-1326(ra) # 8000631e <release>
          return pid;
    80001854:	a0b5                	j	800018c0 <wait+0x106>
            release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	ac6080e7          	jalr	-1338(ra) # 8000631e <release>
            release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0a850513          	addi	a0,a0,168 # 80008908 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	ab6080e7          	jalr	-1354(ra) # 8000631e <release>
            return -1;
    80001870:	59fd                	li	s3,-1
    80001872:	a0b9                	j	800018c0 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001874:	3e848493          	addi	s1,s1,1000
    80001878:	03348463          	beq	s1,s3,800018a0 <wait+0xe6>
      if(pp->parent == p){
    8000187c:	7c9c                	ld	a5,56(s1)
    8000187e:	ff279be3          	bne	a5,s2,80001874 <wait+0xba>
        acquire(&pp->lock);
    80001882:	8526                	mv	a0,s1
    80001884:	00005097          	auipc	ra,0x5
    80001888:	9e6080e7          	jalr	-1562(ra) # 8000626a <acquire>
        if(pp->state == ZOMBIE){
    8000188c:	4c9c                	lw	a5,24(s1)
    8000188e:	f94781e3          	beq	a5,s4,80001810 <wait+0x56>
        release(&pp->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	a8a080e7          	jalr	-1398(ra) # 8000631e <release>
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
    800018b2:	05a50513          	addi	a0,a0,90 # 80008908 <wait_lock>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	a68080e7          	jalr	-1432(ra) # 8000631e <release>
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
    800019b6:	3c6080e7          	jalr	966(ra) # 80005d78 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ba:	00007497          	auipc	s1,0x7
    800019be:	4be48493          	addi	s1,s1,1214 # 80008e78 <proc+0x158>
    800019c2:	00017917          	auipc	s2,0x17
    800019c6:	eb690913          	addi	s2,s2,-330 # 80018878 <bcache+0x140>
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
    800019f8:	384080e7          	jalr	900(ra) # 80005d78 <printf>
    printf("\n");
    800019fc:	8552                	mv	a0,s4
    800019fe:	00004097          	auipc	ra,0x4
    80001a02:	37a080e7          	jalr	890(ra) # 80005d78 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a06:	3e848493          	addi	s1,s1,1000
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
    80001abe:	00017517          	auipc	a0,0x17
    80001ac2:	c6250513          	addi	a0,a0,-926 # 80018720 <tickslock>
    80001ac6:	00004097          	auipc	ra,0x4
    80001aca:	714080e7          	jalr	1812(ra) # 800061da <initlock>
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
    80001adc:	00003797          	auipc	a5,0x3
    80001ae0:	68478793          	addi	a5,a5,1668 # 80005160 <kernelvec>
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
    80001b8e:	00017497          	auipc	s1,0x17
    80001b92:	b9248493          	addi	s1,s1,-1134 # 80018720 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00004097          	auipc	ra,0x4
    80001b9c:	6d2080e7          	jalr	1746(ra) # 8000626a <acquire>
  ticks++;
    80001ba0:	00007517          	auipc	a0,0x7
    80001ba4:	d1850513          	addi	a0,a0,-744 # 800088b8 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	996080e7          	jalr	-1642(ra) # 80001544 <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00004097          	auipc	ra,0x4
    80001bbc:	766080e7          	jalr	1894(ra) # 8000631e <release>
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
    80001bfc:	00003097          	auipc	ra,0x3
    80001c00:	66c080e7          	jalr	1644(ra) # 80005268 <plic_claim>
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
    80001c24:	158080e7          	jalr	344(ra) # 80005d78 <printf>
      plic_complete(irq);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00003097          	auipc	ra,0x3
    80001c2e:	662080e7          	jalr	1634(ra) # 8000528c <plic_complete>
    return 1;
    80001c32:	4505                	li	a0,1
    80001c34:	bf55                	j	80001be8 <devintr+0x1e>
      uartintr();
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	554080e7          	jalr	1364(ra) # 8000618a <uartintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x5e>
      virtio_disk_intr();
    80001c40:	00004097          	auipc	ra,0x4
    80001c44:	b18080e7          	jalr	-1256(ra) # 80005758 <virtio_disk_intr>
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
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	e04a                	sd	s2,0(sp)
    80001c76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c78:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001c7c:	1007f793          	andi	a5,a5,256
    80001c80:	e3d1                	bnez	a5,80001d04 <usertrap+0x98>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c82:	00003797          	auipc	a5,0x3
    80001c86:	4de78793          	addi	a5,a5,1246 # 80005160 <kernelvec>
    80001c8a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	1aa080e7          	jalr	426(ra) # 80000e38 <myproc>
    80001c96:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c98:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c9a:	14102773          	csrr	a4,sepc
    80001c9e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca0:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001ca4:	47a1                	li	a5,8
    80001ca6:	06f70763          	beq	a4,a5,80001d14 <usertrap+0xa8>
  else if ((which_dev = devintr()) != 0)
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	f20080e7          	jalr	-224(ra) # 80001bca <devintr>
    80001cb2:	892a                	mv	s2,a0
    80001cb4:	e171                	bnez	a0,80001d78 <usertrap+0x10c>
    80001cb6:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001cba:	47b5                	li	a5,13
    80001cbc:	0af70563          	beq	a4,a5,80001d66 <usertrap+0xfa>
    80001cc0:	14202773          	csrr	a4,scause
    80001cc4:	47bd                	li	a5,15
    80001cc6:	0af70063          	beq	a4,a5,80001d66 <usertrap+0xfa>
    80001cca:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cce:	5890                	lw	a2,48(s1)
    80001cd0:	00006517          	auipc	a0,0x6
    80001cd4:	5e050513          	addi	a0,a0,1504 # 800082b0 <states.0+0xa0>
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	0a0080e7          	jalr	160(ra) # 80005d78 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ce4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ce8:	00006517          	auipc	a0,0x6
    80001cec:	5f850513          	addi	a0,a0,1528 # 800082e0 <states.0+0xd0>
    80001cf0:	00004097          	auipc	ra,0x4
    80001cf4:	088080e7          	jalr	136(ra) # 80005d78 <printf>
    setkilled(p);
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	a62080e7          	jalr	-1438(ra) # 8000175c <setkilled>
    80001d02:	a825                	j	80001d3a <usertrap+0xce>
    panic("usertrap: not from user mode");
    80001d04:	00006517          	auipc	a0,0x6
    80001d08:	56450513          	addi	a0,a0,1380 # 80008268 <states.0+0x58>
    80001d0c:	00004097          	auipc	ra,0x4
    80001d10:	022080e7          	jalr	34(ra) # 80005d2e <panic>
    if (killed(p))
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a74080e7          	jalr	-1420(ra) # 80001788 <killed>
    80001d1c:	ed1d                	bnez	a0,80001d5a <usertrap+0xee>
    p->trapframe->epc += 4;
    80001d1e:	6cb8                	ld	a4,88(s1)
    80001d20:	6f1c                	ld	a5,24(a4)
    80001d22:	0791                	addi	a5,a5,4
    80001d24:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2e:	10079073          	csrw	sstatus,a5
    syscall();
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	2ba080e7          	jalr	698(ra) # 80001fec <syscall>
  if (killed(p))
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	a4c080e7          	jalr	-1460(ra) # 80001788 <killed>
    80001d44:	e129                	bnez	a0,80001d86 <usertrap+0x11a>
  usertrapret();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	da8080e7          	jalr	-600(ra) # 80001aee <usertrapret>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	64a2                	ld	s1,8(sp)
    80001d54:	6902                	ld	s2,0(sp)
    80001d56:	6105                	addi	sp,sp,32
    80001d58:	8082                	ret
      exit(-1);
    80001d5a:	557d                	li	a0,-1
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	8b8080e7          	jalr	-1864(ra) # 80001614 <exit>
    80001d64:	bf6d                	j	80001d1e <usertrap+0xb2>
    printf("Now, after mmap, we get a page fault\n");
    80001d66:	00006517          	auipc	a0,0x6
    80001d6a:	52250513          	addi	a0,a0,1314 # 80008288 <states.0+0x78>
    80001d6e:	00004097          	auipc	ra,0x4
    80001d72:	00a080e7          	jalr	10(ra) # 80005d78 <printf>
    goto err;
    80001d76:	bf91                	j	80001cca <usertrap+0x5e>
  if (killed(p))
    80001d78:	8526                	mv	a0,s1
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	a0e080e7          	jalr	-1522(ra) # 80001788 <killed>
    80001d82:	c901                	beqz	a0,80001d92 <usertrap+0x126>
    80001d84:	a011                	j	80001d88 <usertrap+0x11c>
    80001d86:	4901                	li	s2,0
    exit(-1);
    80001d88:	557d                	li	a0,-1
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	88a080e7          	jalr	-1910(ra) # 80001614 <exit>
  if (which_dev == 2)
    80001d92:	4789                	li	a5,2
    80001d94:	faf919e3          	bne	s2,a5,80001d46 <usertrap+0xda>
    yield();
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	70c080e7          	jalr	1804(ra) # 800014a4 <yield>
    80001da0:	b75d                	j	80001d46 <usertrap+0xda>

0000000080001da2 <kerneltrap>:
{
    80001da2:	7179                	addi	sp,sp,-48
    80001da4:	f406                	sd	ra,40(sp)
    80001da6:	f022                	sd	s0,32(sp)
    80001da8:	ec26                	sd	s1,24(sp)
    80001daa:	e84a                	sd	s2,16(sp)
    80001dac:	e44e                	sd	s3,8(sp)
    80001dae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db8:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001dbc:	1004f793          	andi	a5,s1,256
    80001dc0:	cb85                	beqz	a5,80001df0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc6:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001dc8:	ef85                	bnez	a5,80001e00 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	e00080e7          	jalr	-512(ra) # 80001bca <devintr>
    80001dd2:	cd1d                	beqz	a0,80001e10 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd4:	4789                	li	a5,2
    80001dd6:	06f50a63          	beq	a0,a5,80001e4a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dda:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dde:	10049073          	csrw	sstatus,s1
}
    80001de2:	70a2                	ld	ra,40(sp)
    80001de4:	7402                	ld	s0,32(sp)
    80001de6:	64e2                	ld	s1,24(sp)
    80001de8:	6942                	ld	s2,16(sp)
    80001dea:	69a2                	ld	s3,8(sp)
    80001dec:	6145                	addi	sp,sp,48
    80001dee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	51050513          	addi	a0,a0,1296 # 80008300 <states.0+0xf0>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	f36080e7          	jalr	-202(ra) # 80005d2e <panic>
    panic("kerneltrap: interrupts enabled");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	52850513          	addi	a0,a0,1320 # 80008328 <states.0+0x118>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	f26080e7          	jalr	-218(ra) # 80005d2e <panic>
    printf("scause %p\n", scause);
    80001e10:	85ce                	mv	a1,s3
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	53650513          	addi	a0,a0,1334 # 80008348 <states.0+0x138>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	f5e080e7          	jalr	-162(ra) # 80005d78 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e26:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	52e50513          	addi	a0,a0,1326 # 80008358 <states.0+0x148>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	f46080e7          	jalr	-186(ra) # 80005d78 <printf>
    panic("kerneltrap");
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	53650513          	addi	a0,a0,1334 # 80008370 <states.0+0x160>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	eec080e7          	jalr	-276(ra) # 80005d2e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	fee080e7          	jalr	-18(ra) # 80000e38 <myproc>
    80001e52:	d541                	beqz	a0,80001dda <kerneltrap+0x38>
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	fe4080e7          	jalr	-28(ra) # 80000e38 <myproc>
    80001e5c:	4d18                	lw	a4,24(a0)
    80001e5e:	4791                	li	a5,4
    80001e60:	f6f71de3          	bne	a4,a5,80001dda <kerneltrap+0x38>
    yield();
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	640080e7          	jalr	1600(ra) # 800014a4 <yield>
    80001e6c:	b7bd                	j	80001dda <kerneltrap+0x38>

0000000080001e6e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e6e:	1101                	addi	sp,sp,-32
    80001e70:	ec06                	sd	ra,24(sp)
    80001e72:	e822                	sd	s0,16(sp)
    80001e74:	e426                	sd	s1,8(sp)
    80001e76:	1000                	addi	s0,sp,32
    80001e78:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	fbe080e7          	jalr	-66(ra) # 80000e38 <myproc>
  switch (n) {
    80001e82:	4795                	li	a5,5
    80001e84:	0497e163          	bltu	a5,s1,80001ec6 <argraw+0x58>
    80001e88:	048a                	slli	s1,s1,0x2
    80001e8a:	00006717          	auipc	a4,0x6
    80001e8e:	51e70713          	addi	a4,a4,1310 # 800083a8 <states.0+0x198>
    80001e92:	94ba                	add	s1,s1,a4
    80001e94:	409c                	lw	a5,0(s1)
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6105                	addi	sp,sp,32
    80001ea6:	8082                	ret
    return p->trapframe->a1;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	7fa8                	ld	a0,120(a5)
    80001eac:	bfcd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a2;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	63c8                	ld	a0,128(a5)
    80001eb2:	b7f5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a3;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	67c8                	ld	a0,136(a5)
    80001eb8:	b7dd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a4;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	6bc8                	ld	a0,144(a5)
    80001ebe:	b7c5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a5;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	6fc8                	ld	a0,152(a5)
    80001ec4:	bfe9                	j	80001e9e <argraw+0x30>
  panic("argraw");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	4ba50513          	addi	a0,a0,1210 # 80008380 <states.0+0x170>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	e60080e7          	jalr	-416(ra) # 80005d2e <panic>

0000000080001ed6 <fetchaddr>:
{
    80001ed6:	1101                	addi	sp,sp,-32
    80001ed8:	ec06                	sd	ra,24(sp)
    80001eda:	e822                	sd	s0,16(sp)
    80001edc:	e426                	sd	s1,8(sp)
    80001ede:	e04a                	sd	s2,0(sp)
    80001ee0:	1000                	addi	s0,sp,32
    80001ee2:	84aa                	mv	s1,a0
    80001ee4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	f52080e7          	jalr	-174(ra) # 80000e38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001eee:	653c                	ld	a5,72(a0)
    80001ef0:	02f4f863          	bgeu	s1,a5,80001f20 <fetchaddr+0x4a>
    80001ef4:	00848713          	addi	a4,s1,8
    80001ef8:	02e7e663          	bltu	a5,a4,80001f24 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001efc:	46a1                	li	a3,8
    80001efe:	8626                	mv	a2,s1
    80001f00:	85ca                	mv	a1,s2
    80001f02:	6928                	ld	a0,80(a0)
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	c7c080e7          	jalr	-900(ra) # 80000b80 <copyin>
    80001f0c:	00a03533          	snez	a0,a0
    80001f10:	40a00533          	neg	a0,a0
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6902                	ld	s2,0(sp)
    80001f1c:	6105                	addi	sp,sp,32
    80001f1e:	8082                	ret
    return -1;
    80001f20:	557d                	li	a0,-1
    80001f22:	bfcd                	j	80001f14 <fetchaddr+0x3e>
    80001f24:	557d                	li	a0,-1
    80001f26:	b7fd                	j	80001f14 <fetchaddr+0x3e>

0000000080001f28 <fetchstr>:
{
    80001f28:	7179                	addi	sp,sp,-48
    80001f2a:	f406                	sd	ra,40(sp)
    80001f2c:	f022                	sd	s0,32(sp)
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	1800                	addi	s0,sp,48
    80001f36:	892a                	mv	s2,a0
    80001f38:	84ae                	mv	s1,a1
    80001f3a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	efc080e7          	jalr	-260(ra) # 80000e38 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f44:	86ce                	mv	a3,s3
    80001f46:	864a                	mv	a2,s2
    80001f48:	85a6                	mv	a1,s1
    80001f4a:	6928                	ld	a0,80(a0)
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	cc2080e7          	jalr	-830(ra) # 80000c0e <copyinstr>
    80001f54:	00054e63          	bltz	a0,80001f70 <fetchstr+0x48>
  return strlen(buf);
    80001f58:	8526                	mv	a0,s1
    80001f5a:	ffffe097          	auipc	ra,0xffffe
    80001f5e:	39a080e7          	jalr	922(ra) # 800002f4 <strlen>
}
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6145                	addi	sp,sp,48
    80001f6e:	8082                	ret
    return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfc5                	j	80001f62 <fetchstr+0x3a>

0000000080001f74 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	eee080e7          	jalr	-274(ra) # 80001e6e <argraw>
    80001f88:	c088                	sw	a0,0(s1)
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6105                	addi	sp,sp,32
    80001f92:	8082                	ret

0000000080001f94 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f94:	1101                	addi	sp,sp,-32
    80001f96:	ec06                	sd	ra,24(sp)
    80001f98:	e822                	sd	s0,16(sp)
    80001f9a:	e426                	sd	s1,8(sp)
    80001f9c:	1000                	addi	s0,sp,32
    80001f9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	ece080e7          	jalr	-306(ra) # 80001e6e <argraw>
    80001fa8:	e088                	sd	a0,0(s1)
}
    80001faa:	60e2                	ld	ra,24(sp)
    80001fac:	6442                	ld	s0,16(sp)
    80001fae:	64a2                	ld	s1,8(sp)
    80001fb0:	6105                	addi	sp,sp,32
    80001fb2:	8082                	ret

0000000080001fb4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	1800                	addi	s0,sp,48
    80001fc0:	84ae                	mv	s1,a1
    80001fc2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fc4:	fd840593          	addi	a1,s0,-40
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	fcc080e7          	jalr	-52(ra) # 80001f94 <argaddr>
  return fetchstr(addr, buf, max);
    80001fd0:	864a                	mv	a2,s2
    80001fd2:	85a6                	mv	a1,s1
    80001fd4:	fd843503          	ld	a0,-40(s0)
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	f50080e7          	jalr	-176(ra) # 80001f28 <fetchstr>
}
    80001fe0:	70a2                	ld	ra,40(sp)
    80001fe2:	7402                	ld	s0,32(sp)
    80001fe4:	64e2                	ld	s1,24(sp)
    80001fe6:	6942                	ld	s2,16(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret

0000000080001fec <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	e04a                	sd	s2,0(sp)
    80001ff6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	e40080e7          	jalr	-448(ra) # 80000e38 <myproc>
    80002000:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002002:	05853903          	ld	s2,88(a0)
    80002006:	0a893783          	ld	a5,168(s2)
    8000200a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000200e:	37fd                	addiw	a5,a5,-1
    80002010:	4759                	li	a4,22
    80002012:	00f76f63          	bltu	a4,a5,80002030 <syscall+0x44>
    80002016:	00369713          	slli	a4,a3,0x3
    8000201a:	00006797          	auipc	a5,0x6
    8000201e:	3a678793          	addi	a5,a5,934 # 800083c0 <syscalls>
    80002022:	97ba                	add	a5,a5,a4
    80002024:	639c                	ld	a5,0(a5)
    80002026:	c789                	beqz	a5,80002030 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002028:	9782                	jalr	a5
    8000202a:	06a93823          	sd	a0,112(s2)
    8000202e:	a839                	j	8000204c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002030:	15848613          	addi	a2,s1,344
    80002034:	588c                	lw	a1,48(s1)
    80002036:	00006517          	auipc	a0,0x6
    8000203a:	35250513          	addi	a0,a0,850 # 80008388 <states.0+0x178>
    8000203e:	00004097          	auipc	ra,0x4
    80002042:	d3a080e7          	jalr	-710(ra) # 80005d78 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002046:	6cbc                	ld	a5,88(s1)
    80002048:	577d                	li	a4,-1
    8000204a:	fbb8                	sd	a4,112(a5)
  }
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6902                	ld	s2,0(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002060:	fec40593          	addi	a1,s0,-20
    80002064:	4501                	li	a0,0
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	f0e080e7          	jalr	-242(ra) # 80001f74 <argint>
  exit(n);
    8000206e:	fec42503          	lw	a0,-20(s0)
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	5a2080e7          	jalr	1442(ra) # 80001614 <exit>
  return 0;  // not reached
}
    8000207a:	4501                	li	a0,0
    8000207c:	60e2                	ld	ra,24(sp)
    8000207e:	6442                	ld	s0,16(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002084:	1141                	addi	sp,sp,-16
    80002086:	e406                	sd	ra,8(sp)
    80002088:	e022                	sd	s0,0(sp)
    8000208a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	dac080e7          	jalr	-596(ra) # 80000e38 <myproc>
}
    80002094:	5908                	lw	a0,48(a0)
    80002096:	60a2                	ld	ra,8(sp)
    80002098:	6402                	ld	s0,0(sp)
    8000209a:	0141                	addi	sp,sp,16
    8000209c:	8082                	ret

000000008000209e <sys_fork>:

uint64
sys_fork(void)
{
    8000209e:	1141                	addi	sp,sp,-16
    800020a0:	e406                	sd	ra,8(sp)
    800020a2:	e022                	sd	s0,0(sp)
    800020a4:	0800                	addi	s0,sp,16
  return fork();
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	148080e7          	jalr	328(ra) # 800011ee <fork>
}
    800020ae:	60a2                	ld	ra,8(sp)
    800020b0:	6402                	ld	s0,0(sp)
    800020b2:	0141                	addi	sp,sp,16
    800020b4:	8082                	ret

00000000800020b6 <sys_wait>:

uint64
sys_wait(void)
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020be:	fe840593          	addi	a1,s0,-24
    800020c2:	4501                	li	a0,0
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	ed0080e7          	jalr	-304(ra) # 80001f94 <argaddr>
  return wait(p);
    800020cc:	fe843503          	ld	a0,-24(s0)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	6ea080e7          	jalr	1770(ra) # 800017ba <wait>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e0:	7179                	addi	sp,sp,-48
    800020e2:	f406                	sd	ra,40(sp)
    800020e4:	f022                	sd	s0,32(sp)
    800020e6:	ec26                	sd	s1,24(sp)
    800020e8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020ea:	fdc40593          	addi	a1,s0,-36
    800020ee:	4501                	li	a0,0
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	e84080e7          	jalr	-380(ra) # 80001f74 <argint>
  addr = myproc()->sz;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d40080e7          	jalr	-704(ra) # 80000e38 <myproc>
    80002100:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002102:	fdc42503          	lw	a0,-36(s0)
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	08c080e7          	jalr	140(ra) # 80001192 <growproc>
    8000210e:	00054863          	bltz	a0,8000211e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002112:	8526                	mv	a0,s1
    80002114:	70a2                	ld	ra,40(sp)
    80002116:	7402                	ld	s0,32(sp)
    80002118:	64e2                	ld	s1,24(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    return -1;
    8000211e:	54fd                	li	s1,-1
    80002120:	bfcd                	j	80002112 <sys_sbrk+0x32>

0000000080002122 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002122:	7139                	addi	sp,sp,-64
    80002124:	fc06                	sd	ra,56(sp)
    80002126:	f822                	sd	s0,48(sp)
    80002128:	f426                	sd	s1,40(sp)
    8000212a:	f04a                	sd	s2,32(sp)
    8000212c:	ec4e                	sd	s3,24(sp)
    8000212e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002130:	fcc40593          	addi	a1,s0,-52
    80002134:	4501                	li	a0,0
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	e3e080e7          	jalr	-450(ra) # 80001f74 <argint>
  if(n < 0)
    8000213e:	fcc42783          	lw	a5,-52(s0)
    80002142:	0607cf63          	bltz	a5,800021c0 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002146:	00016517          	auipc	a0,0x16
    8000214a:	5da50513          	addi	a0,a0,1498 # 80018720 <tickslock>
    8000214e:	00004097          	auipc	ra,0x4
    80002152:	11c080e7          	jalr	284(ra) # 8000626a <acquire>
  ticks0 = ticks;
    80002156:	00006917          	auipc	s2,0x6
    8000215a:	76292903          	lw	s2,1890(s2) # 800088b8 <ticks>
  while(ticks - ticks0 < n){
    8000215e:	fcc42783          	lw	a5,-52(s0)
    80002162:	cf9d                	beqz	a5,800021a0 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002164:	00016997          	auipc	s3,0x16
    80002168:	5bc98993          	addi	s3,s3,1468 # 80018720 <tickslock>
    8000216c:	00006497          	auipc	s1,0x6
    80002170:	74c48493          	addi	s1,s1,1868 # 800088b8 <ticks>
    if(killed(myproc())){
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	cc4080e7          	jalr	-828(ra) # 80000e38 <myproc>
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	60c080e7          	jalr	1548(ra) # 80001788 <killed>
    80002184:	e129                	bnez	a0,800021c6 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002186:	85ce                	mv	a1,s3
    80002188:	8526                	mv	a0,s1
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	356080e7          	jalr	854(ra) # 800014e0 <sleep>
  while(ticks - ticks0 < n){
    80002192:	409c                	lw	a5,0(s1)
    80002194:	412787bb          	subw	a5,a5,s2
    80002198:	fcc42703          	lw	a4,-52(s0)
    8000219c:	fce7ece3          	bltu	a5,a4,80002174 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021a0:	00016517          	auipc	a0,0x16
    800021a4:	58050513          	addi	a0,a0,1408 # 80018720 <tickslock>
    800021a8:	00004097          	auipc	ra,0x4
    800021ac:	176080e7          	jalr	374(ra) # 8000631e <release>
  return 0;
    800021b0:	4501                	li	a0,0
}
    800021b2:	70e2                	ld	ra,56(sp)
    800021b4:	7442                	ld	s0,48(sp)
    800021b6:	74a2                	ld	s1,40(sp)
    800021b8:	7902                	ld	s2,32(sp)
    800021ba:	69e2                	ld	s3,24(sp)
    800021bc:	6121                	addi	sp,sp,64
    800021be:	8082                	ret
    n = 0;
    800021c0:	fc042623          	sw	zero,-52(s0)
    800021c4:	b749                	j	80002146 <sys_sleep+0x24>
      release(&tickslock);
    800021c6:	00016517          	auipc	a0,0x16
    800021ca:	55a50513          	addi	a0,a0,1370 # 80018720 <tickslock>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	150080e7          	jalr	336(ra) # 8000631e <release>
      return -1;
    800021d6:	557d                	li	a0,-1
    800021d8:	bfe9                	j	800021b2 <sys_sleep+0x90>

00000000800021da <sys_kill>:

uint64
sys_kill(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021e2:	fec40593          	addi	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	d8c080e7          	jalr	-628(ra) # 80001f74 <argint>
  return kill(pid);
    800021f0:	fec42503          	lw	a0,-20(s0)
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	4f6080e7          	jalr	1270(ra) # 800016ea <kill>
}
    800021fc:	60e2                	ld	ra,24(sp)
    800021fe:	6442                	ld	s0,16(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	e426                	sd	s1,8(sp)
    8000220c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000220e:	00016517          	auipc	a0,0x16
    80002212:	51250513          	addi	a0,a0,1298 # 80018720 <tickslock>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	054080e7          	jalr	84(ra) # 8000626a <acquire>
  xticks = ticks;
    8000221e:	00006497          	auipc	s1,0x6
    80002222:	69a4a483          	lw	s1,1690(s1) # 800088b8 <ticks>
  release(&tickslock);
    80002226:	00016517          	auipc	a0,0x16
    8000222a:	4fa50513          	addi	a0,a0,1274 # 80018720 <tickslock>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	0f0080e7          	jalr	240(ra) # 8000631e <release>
  return xticks;
}
    80002236:	02049513          	slli	a0,s1,0x20
    8000223a:	9101                	srli	a0,a0,0x20
    8000223c:	60e2                	ld	ra,24(sp)
    8000223e:	6442                	ld	s0,16(sp)
    80002240:	64a2                	ld	s1,8(sp)
    80002242:	6105                	addi	sp,sp,32
    80002244:	8082                	ret

0000000080002246 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002246:	7179                	addi	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002256:	00006597          	auipc	a1,0x6
    8000225a:	22a58593          	addi	a1,a1,554 # 80008480 <syscalls+0xc0>
    8000225e:	00016517          	auipc	a0,0x16
    80002262:	4da50513          	addi	a0,a0,1242 # 80018738 <bcache>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	f74080e7          	jalr	-140(ra) # 800061da <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000226e:	0001e797          	auipc	a5,0x1e
    80002272:	4ca78793          	addi	a5,a5,1226 # 80020738 <bcache+0x8000>
    80002276:	0001e717          	auipc	a4,0x1e
    8000227a:	72a70713          	addi	a4,a4,1834 # 800209a0 <bcache+0x8268>
    8000227e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002282:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002286:	00016497          	auipc	s1,0x16
    8000228a:	4ca48493          	addi	s1,s1,1226 # 80018750 <bcache+0x18>
    b->next = bcache.head.next;
    8000228e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002290:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002292:	00006a17          	auipc	s4,0x6
    80002296:	1f6a0a13          	addi	s4,s4,502 # 80008488 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000229a:	2b893783          	ld	a5,696(s2)
    8000229e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a4:	85d2                	mv	a1,s4
    800022a6:	01048513          	addi	a0,s1,16
    800022aa:	00001097          	auipc	ra,0x1
    800022ae:	4ca080e7          	jalr	1226(ra) # 80003774 <initsleeplock>
    bcache.head.next->prev = b;
    800022b2:	2b893783          	ld	a5,696(s2)
    800022b6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022b8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022bc:	45848493          	addi	s1,s1,1112
    800022c0:	fd349de3          	bne	s1,s3,8000229a <binit+0x54>
  }
}
    800022c4:	70a2                	ld	ra,40(sp)
    800022c6:	7402                	ld	s0,32(sp)
    800022c8:	64e2                	ld	s1,24(sp)
    800022ca:	6942                	ld	s2,16(sp)
    800022cc:	69a2                	ld	s3,8(sp)
    800022ce:	6a02                	ld	s4,0(sp)
    800022d0:	6145                	addi	sp,sp,48
    800022d2:	8082                	ret

00000000800022d4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	1800                	addi	s0,sp,48
    800022e2:	892a                	mv	s2,a0
    800022e4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022e6:	00016517          	auipc	a0,0x16
    800022ea:	45250513          	addi	a0,a0,1106 # 80018738 <bcache>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	f7c080e7          	jalr	-132(ra) # 8000626a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022f6:	0001e497          	auipc	s1,0x1e
    800022fa:	6fa4b483          	ld	s1,1786(s1) # 800209f0 <bcache+0x82b8>
    800022fe:	0001e797          	auipc	a5,0x1e
    80002302:	6a278793          	addi	a5,a5,1698 # 800209a0 <bcache+0x8268>
    80002306:	02f48f63          	beq	s1,a5,80002344 <bread+0x70>
    8000230a:	873e                	mv	a4,a5
    8000230c:	a021                	j	80002314 <bread+0x40>
    8000230e:	68a4                	ld	s1,80(s1)
    80002310:	02e48a63          	beq	s1,a4,80002344 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002314:	449c                	lw	a5,8(s1)
    80002316:	ff279ce3          	bne	a5,s2,8000230e <bread+0x3a>
    8000231a:	44dc                	lw	a5,12(s1)
    8000231c:	ff3799e3          	bne	a5,s3,8000230e <bread+0x3a>
      b->refcnt++;
    80002320:	40bc                	lw	a5,64(s1)
    80002322:	2785                	addiw	a5,a5,1
    80002324:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002326:	00016517          	auipc	a0,0x16
    8000232a:	41250513          	addi	a0,a0,1042 # 80018738 <bcache>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	ff0080e7          	jalr	-16(ra) # 8000631e <release>
      acquiresleep(&b->lock);
    80002336:	01048513          	addi	a0,s1,16
    8000233a:	00001097          	auipc	ra,0x1
    8000233e:	474080e7          	jalr	1140(ra) # 800037ae <acquiresleep>
      return b;
    80002342:	a8b9                	j	800023a0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002344:	0001e497          	auipc	s1,0x1e
    80002348:	6a44b483          	ld	s1,1700(s1) # 800209e8 <bcache+0x82b0>
    8000234c:	0001e797          	auipc	a5,0x1e
    80002350:	65478793          	addi	a5,a5,1620 # 800209a0 <bcache+0x8268>
    80002354:	00f48863          	beq	s1,a5,80002364 <bread+0x90>
    80002358:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235a:	40bc                	lw	a5,64(s1)
    8000235c:	cf81                	beqz	a5,80002374 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000235e:	64a4                	ld	s1,72(s1)
    80002360:	fee49de3          	bne	s1,a4,8000235a <bread+0x86>
  panic("bget: no buffers");
    80002364:	00006517          	auipc	a0,0x6
    80002368:	12c50513          	addi	a0,a0,300 # 80008490 <syscalls+0xd0>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	9c2080e7          	jalr	-1598(ra) # 80005d2e <panic>
      b->dev = dev;
    80002374:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002378:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000237c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002380:	4785                	li	a5,1
    80002382:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002384:	00016517          	auipc	a0,0x16
    80002388:	3b450513          	addi	a0,a0,948 # 80018738 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	f92080e7          	jalr	-110(ra) # 8000631e <release>
      acquiresleep(&b->lock);
    80002394:	01048513          	addi	a0,s1,16
    80002398:	00001097          	auipc	ra,0x1
    8000239c:	416080e7          	jalr	1046(ra) # 800037ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a0:	409c                	lw	a5,0(s1)
    800023a2:	cb89                	beqz	a5,800023b4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a4:	8526                	mv	a0,s1
    800023a6:	70a2                	ld	ra,40(sp)
    800023a8:	7402                	ld	s0,32(sp)
    800023aa:	64e2                	ld	s1,24(sp)
    800023ac:	6942                	ld	s2,16(sp)
    800023ae:	69a2                	ld	s3,8(sp)
    800023b0:	6145                	addi	sp,sp,48
    800023b2:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b4:	4581                	li	a1,0
    800023b6:	8526                	mv	a0,s1
    800023b8:	00003097          	auipc	ra,0x3
    800023bc:	16c080e7          	jalr	364(ra) # 80005524 <virtio_disk_rw>
    b->valid = 1;
    800023c0:	4785                	li	a5,1
    800023c2:	c09c                	sw	a5,0(s1)
  return b;
    800023c4:	b7c5                	j	800023a4 <bread+0xd0>

00000000800023c6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023c6:	1101                	addi	sp,sp,-32
    800023c8:	ec06                	sd	ra,24(sp)
    800023ca:	e822                	sd	s0,16(sp)
    800023cc:	e426                	sd	s1,8(sp)
    800023ce:	1000                	addi	s0,sp,32
    800023d0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d2:	0541                	addi	a0,a0,16
    800023d4:	00001097          	auipc	ra,0x1
    800023d8:	474080e7          	jalr	1140(ra) # 80003848 <holdingsleep>
    800023dc:	cd01                	beqz	a0,800023f4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023de:	4585                	li	a1,1
    800023e0:	8526                	mv	a0,s1
    800023e2:	00003097          	auipc	ra,0x3
    800023e6:	142080e7          	jalr	322(ra) # 80005524 <virtio_disk_rw>
}
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	addi	sp,sp,32
    800023f2:	8082                	ret
    panic("bwrite");
    800023f4:	00006517          	auipc	a0,0x6
    800023f8:	0b450513          	addi	a0,a0,180 # 800084a8 <syscalls+0xe8>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	932080e7          	jalr	-1742(ra) # 80005d2e <panic>

0000000080002404 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002404:	1101                	addi	sp,sp,-32
    80002406:	ec06                	sd	ra,24(sp)
    80002408:	e822                	sd	s0,16(sp)
    8000240a:	e426                	sd	s1,8(sp)
    8000240c:	e04a                	sd	s2,0(sp)
    8000240e:	1000                	addi	s0,sp,32
    80002410:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002412:	01050913          	addi	s2,a0,16
    80002416:	854a                	mv	a0,s2
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	430080e7          	jalr	1072(ra) # 80003848 <holdingsleep>
    80002420:	c92d                	beqz	a0,80002492 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002422:	854a                	mv	a0,s2
    80002424:	00001097          	auipc	ra,0x1
    80002428:	3e0080e7          	jalr	992(ra) # 80003804 <releasesleep>

  acquire(&bcache.lock);
    8000242c:	00016517          	auipc	a0,0x16
    80002430:	30c50513          	addi	a0,a0,780 # 80018738 <bcache>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	e36080e7          	jalr	-458(ra) # 8000626a <acquire>
  b->refcnt--;
    8000243c:	40bc                	lw	a5,64(s1)
    8000243e:	37fd                	addiw	a5,a5,-1
    80002440:	0007871b          	sext.w	a4,a5
    80002444:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002446:	eb05                	bnez	a4,80002476 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002448:	68bc                	ld	a5,80(s1)
    8000244a:	64b8                	ld	a4,72(s1)
    8000244c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000244e:	64bc                	ld	a5,72(s1)
    80002450:	68b8                	ld	a4,80(s1)
    80002452:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002454:	0001e797          	auipc	a5,0x1e
    80002458:	2e478793          	addi	a5,a5,740 # 80020738 <bcache+0x8000>
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002462:	0001e717          	auipc	a4,0x1e
    80002466:	53e70713          	addi	a4,a4,1342 # 800209a0 <bcache+0x8268>
    8000246a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246c:	2b87b703          	ld	a4,696(a5)
    80002470:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002472:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002476:	00016517          	auipc	a0,0x16
    8000247a:	2c250513          	addi	a0,a0,706 # 80018738 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	ea0080e7          	jalr	-352(ra) # 8000631e <release>
}
    80002486:	60e2                	ld	ra,24(sp)
    80002488:	6442                	ld	s0,16(sp)
    8000248a:	64a2                	ld	s1,8(sp)
    8000248c:	6902                	ld	s2,0(sp)
    8000248e:	6105                	addi	sp,sp,32
    80002490:	8082                	ret
    panic("brelse");
    80002492:	00006517          	auipc	a0,0x6
    80002496:	01e50513          	addi	a0,a0,30 # 800084b0 <syscalls+0xf0>
    8000249a:	00004097          	auipc	ra,0x4
    8000249e:	894080e7          	jalr	-1900(ra) # 80005d2e <panic>

00000000800024a2 <bpin>:

void
bpin(struct buf *b) {
    800024a2:	1101                	addi	sp,sp,-32
    800024a4:	ec06                	sd	ra,24(sp)
    800024a6:	e822                	sd	s0,16(sp)
    800024a8:	e426                	sd	s1,8(sp)
    800024aa:	1000                	addi	s0,sp,32
    800024ac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ae:	00016517          	auipc	a0,0x16
    800024b2:	28a50513          	addi	a0,a0,650 # 80018738 <bcache>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	db4080e7          	jalr	-588(ra) # 8000626a <acquire>
  b->refcnt++;
    800024be:	40bc                	lw	a5,64(s1)
    800024c0:	2785                	addiw	a5,a5,1
    800024c2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c4:	00016517          	auipc	a0,0x16
    800024c8:	27450513          	addi	a0,a0,628 # 80018738 <bcache>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	e52080e7          	jalr	-430(ra) # 8000631e <release>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret

00000000800024de <bunpin>:

void
bunpin(struct buf *b) {
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	addi	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ea:	00016517          	auipc	a0,0x16
    800024ee:	24e50513          	addi	a0,a0,590 # 80018738 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	d78080e7          	jalr	-648(ra) # 8000626a <acquire>
  b->refcnt--;
    800024fa:	40bc                	lw	a5,64(s1)
    800024fc:	37fd                	addiw	a5,a5,-1
    800024fe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002500:	00016517          	auipc	a0,0x16
    80002504:	23850513          	addi	a0,a0,568 # 80018738 <bcache>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	e16080e7          	jalr	-490(ra) # 8000631e <release>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret

000000008000251a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	e04a                	sd	s2,0(sp)
    80002524:	1000                	addi	s0,sp,32
    80002526:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002528:	00d5d59b          	srliw	a1,a1,0xd
    8000252c:	0001f797          	auipc	a5,0x1f
    80002530:	8e87a783          	lw	a5,-1816(a5) # 80020e14 <sb+0x1c>
    80002534:	9dbd                	addw	a1,a1,a5
    80002536:	00000097          	auipc	ra,0x0
    8000253a:	d9e080e7          	jalr	-610(ra) # 800022d4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000253e:	0074f713          	andi	a4,s1,7
    80002542:	4785                	li	a5,1
    80002544:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002548:	14ce                	slli	s1,s1,0x33
    8000254a:	90d9                	srli	s1,s1,0x36
    8000254c:	00950733          	add	a4,a0,s1
    80002550:	05874703          	lbu	a4,88(a4)
    80002554:	00e7f6b3          	and	a3,a5,a4
    80002558:	c69d                	beqz	a3,80002586 <bfree+0x6c>
    8000255a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255c:	94aa                	add	s1,s1,a0
    8000255e:	fff7c793          	not	a5,a5
    80002562:	8ff9                	and	a5,a5,a4
    80002564:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002568:	00001097          	auipc	ra,0x1
    8000256c:	126080e7          	jalr	294(ra) # 8000368e <log_write>
  brelse(bp);
    80002570:	854a                	mv	a0,s2
    80002572:	00000097          	auipc	ra,0x0
    80002576:	e92080e7          	jalr	-366(ra) # 80002404 <brelse>
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	6902                	ld	s2,0(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    panic("freeing free block");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	f3250513          	addi	a0,a0,-206 # 800084b8 <syscalls+0xf8>
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	7a0080e7          	jalr	1952(ra) # 80005d2e <panic>

0000000080002596 <balloc>:
{
    80002596:	711d                	addi	sp,sp,-96
    80002598:	ec86                	sd	ra,88(sp)
    8000259a:	e8a2                	sd	s0,80(sp)
    8000259c:	e4a6                	sd	s1,72(sp)
    8000259e:	e0ca                	sd	s2,64(sp)
    800025a0:	fc4e                	sd	s3,56(sp)
    800025a2:	f852                	sd	s4,48(sp)
    800025a4:	f456                	sd	s5,40(sp)
    800025a6:	f05a                	sd	s6,32(sp)
    800025a8:	ec5e                	sd	s7,24(sp)
    800025aa:	e862                	sd	s8,16(sp)
    800025ac:	e466                	sd	s9,8(sp)
    800025ae:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b0:	0001f797          	auipc	a5,0x1f
    800025b4:	84c7a783          	lw	a5,-1972(a5) # 80020dfc <sb+0x4>
    800025b8:	10078163          	beqz	a5,800026ba <balloc+0x124>
    800025bc:	8baa                	mv	s7,a0
    800025be:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c0:	0001fb17          	auipc	s6,0x1f
    800025c4:	838b0b13          	addi	s6,s6,-1992 # 80020df8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025ce:	6c89                	lui	s9,0x2
    800025d0:	a061                	j	80002658 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025d2:	974a                	add	a4,a4,s2
    800025d4:	8fd5                	or	a5,a5,a3
    800025d6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025da:	854a                	mv	a0,s2
    800025dc:	00001097          	auipc	ra,0x1
    800025e0:	0b2080e7          	jalr	178(ra) # 8000368e <log_write>
        brelse(bp);
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e1e080e7          	jalr	-482(ra) # 80002404 <brelse>
  bp = bread(dev, bno);
    800025ee:	85a6                	mv	a1,s1
    800025f0:	855e                	mv	a0,s7
    800025f2:	00000097          	auipc	ra,0x0
    800025f6:	ce2080e7          	jalr	-798(ra) # 800022d4 <bread>
    800025fa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025fc:	40000613          	li	a2,1024
    80002600:	4581                	li	a1,0
    80002602:	05850513          	addi	a0,a0,88
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	b72080e7          	jalr	-1166(ra) # 80000178 <memset>
  log_write(bp);
    8000260e:	854a                	mv	a0,s2
    80002610:	00001097          	auipc	ra,0x1
    80002614:	07e080e7          	jalr	126(ra) # 8000368e <log_write>
  brelse(bp);
    80002618:	854a                	mv	a0,s2
    8000261a:	00000097          	auipc	ra,0x0
    8000261e:	dea080e7          	jalr	-534(ra) # 80002404 <brelse>
}
    80002622:	8526                	mv	a0,s1
    80002624:	60e6                	ld	ra,88(sp)
    80002626:	6446                	ld	s0,80(sp)
    80002628:	64a6                	ld	s1,72(sp)
    8000262a:	6906                	ld	s2,64(sp)
    8000262c:	79e2                	ld	s3,56(sp)
    8000262e:	7a42                	ld	s4,48(sp)
    80002630:	7aa2                	ld	s5,40(sp)
    80002632:	7b02                	ld	s6,32(sp)
    80002634:	6be2                	ld	s7,24(sp)
    80002636:	6c42                	ld	s8,16(sp)
    80002638:	6ca2                	ld	s9,8(sp)
    8000263a:	6125                	addi	sp,sp,96
    8000263c:	8082                	ret
    brelse(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00000097          	auipc	ra,0x0
    80002644:	dc4080e7          	jalr	-572(ra) # 80002404 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002648:	015c87bb          	addw	a5,s9,s5
    8000264c:	00078a9b          	sext.w	s5,a5
    80002650:	004b2703          	lw	a4,4(s6)
    80002654:	06eaf363          	bgeu	s5,a4,800026ba <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002658:	41fad79b          	sraiw	a5,s5,0x1f
    8000265c:	0137d79b          	srliw	a5,a5,0x13
    80002660:	015787bb          	addw	a5,a5,s5
    80002664:	40d7d79b          	sraiw	a5,a5,0xd
    80002668:	01cb2583          	lw	a1,28(s6)
    8000266c:	9dbd                	addw	a1,a1,a5
    8000266e:	855e                	mv	a0,s7
    80002670:	00000097          	auipc	ra,0x0
    80002674:	c64080e7          	jalr	-924(ra) # 800022d4 <bread>
    80002678:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267a:	004b2503          	lw	a0,4(s6)
    8000267e:	000a849b          	sext.w	s1,s5
    80002682:	8662                	mv	a2,s8
    80002684:	faa4fde3          	bgeu	s1,a0,8000263e <balloc+0xa8>
      m = 1 << (bi % 8);
    80002688:	41f6579b          	sraiw	a5,a2,0x1f
    8000268c:	01d7d69b          	srliw	a3,a5,0x1d
    80002690:	00c6873b          	addw	a4,a3,a2
    80002694:	00777793          	andi	a5,a4,7
    80002698:	9f95                	subw	a5,a5,a3
    8000269a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000269e:	4037571b          	sraiw	a4,a4,0x3
    800026a2:	00e906b3          	add	a3,s2,a4
    800026a6:	0586c683          	lbu	a3,88(a3)
    800026aa:	00d7f5b3          	and	a1,a5,a3
    800026ae:	d195                	beqz	a1,800025d2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b0:	2605                	addiw	a2,a2,1
    800026b2:	2485                	addiw	s1,s1,1
    800026b4:	fd4618e3          	bne	a2,s4,80002684 <balloc+0xee>
    800026b8:	b759                	j	8000263e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026ba:	00006517          	auipc	a0,0x6
    800026be:	e1650513          	addi	a0,a0,-490 # 800084d0 <syscalls+0x110>
    800026c2:	00003097          	auipc	ra,0x3
    800026c6:	6b6080e7          	jalr	1718(ra) # 80005d78 <printf>
  return 0;
    800026ca:	4481                	li	s1,0
    800026cc:	bf99                	j	80002622 <balloc+0x8c>

00000000800026ce <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026ce:	7179                	addi	sp,sp,-48
    800026d0:	f406                	sd	ra,40(sp)
    800026d2:	f022                	sd	s0,32(sp)
    800026d4:	ec26                	sd	s1,24(sp)
    800026d6:	e84a                	sd	s2,16(sp)
    800026d8:	e44e                	sd	s3,8(sp)
    800026da:	e052                	sd	s4,0(sp)
    800026dc:	1800                	addi	s0,sp,48
    800026de:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026e0:	47ad                	li	a5,11
    800026e2:	02b7e863          	bltu	a5,a1,80002712 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026e6:	02059793          	slli	a5,a1,0x20
    800026ea:	01e7d593          	srli	a1,a5,0x1e
    800026ee:	00b504b3          	add	s1,a0,a1
    800026f2:	0504a903          	lw	s2,80(s1)
    800026f6:	06091e63          	bnez	s2,80002772 <bmap+0xa4>
      addr = balloc(ip->dev);
    800026fa:	4108                	lw	a0,0(a0)
    800026fc:	00000097          	auipc	ra,0x0
    80002700:	e9a080e7          	jalr	-358(ra) # 80002596 <balloc>
    80002704:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002708:	06090563          	beqz	s2,80002772 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000270c:	0524a823          	sw	s2,80(s1)
    80002710:	a08d                	j	80002772 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002712:	ff45849b          	addiw	s1,a1,-12
    80002716:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000271a:	0ff00793          	li	a5,255
    8000271e:	08e7e563          	bltu	a5,a4,800027a8 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002722:	08052903          	lw	s2,128(a0)
    80002726:	00091d63          	bnez	s2,80002740 <bmap+0x72>
      addr = balloc(ip->dev);
    8000272a:	4108                	lw	a0,0(a0)
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	e6a080e7          	jalr	-406(ra) # 80002596 <balloc>
    80002734:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002738:	02090d63          	beqz	s2,80002772 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000273c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002740:	85ca                	mv	a1,s2
    80002742:	0009a503          	lw	a0,0(s3)
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	b8e080e7          	jalr	-1138(ra) # 800022d4 <bread>
    8000274e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002750:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002754:	02049713          	slli	a4,s1,0x20
    80002758:	01e75593          	srli	a1,a4,0x1e
    8000275c:	00b784b3          	add	s1,a5,a1
    80002760:	0004a903          	lw	s2,0(s1)
    80002764:	02090063          	beqz	s2,80002784 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002768:	8552                	mv	a0,s4
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	c9a080e7          	jalr	-870(ra) # 80002404 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002772:	854a                	mv	a0,s2
    80002774:	70a2                	ld	ra,40(sp)
    80002776:	7402                	ld	s0,32(sp)
    80002778:	64e2                	ld	s1,24(sp)
    8000277a:	6942                	ld	s2,16(sp)
    8000277c:	69a2                	ld	s3,8(sp)
    8000277e:	6a02                	ld	s4,0(sp)
    80002780:	6145                	addi	sp,sp,48
    80002782:	8082                	ret
      addr = balloc(ip->dev);
    80002784:	0009a503          	lw	a0,0(s3)
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	e0e080e7          	jalr	-498(ra) # 80002596 <balloc>
    80002790:	0005091b          	sext.w	s2,a0
      if(addr){
    80002794:	fc090ae3          	beqz	s2,80002768 <bmap+0x9a>
        a[bn] = addr;
    80002798:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000279c:	8552                	mv	a0,s4
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	ef0080e7          	jalr	-272(ra) # 8000368e <log_write>
    800027a6:	b7c9                	j	80002768 <bmap+0x9a>
  panic("bmap: out of range");
    800027a8:	00006517          	auipc	a0,0x6
    800027ac:	d4050513          	addi	a0,a0,-704 # 800084e8 <syscalls+0x128>
    800027b0:	00003097          	auipc	ra,0x3
    800027b4:	57e080e7          	jalr	1406(ra) # 80005d2e <panic>

00000000800027b8 <iget>:
{
    800027b8:	7179                	addi	sp,sp,-48
    800027ba:	f406                	sd	ra,40(sp)
    800027bc:	f022                	sd	s0,32(sp)
    800027be:	ec26                	sd	s1,24(sp)
    800027c0:	e84a                	sd	s2,16(sp)
    800027c2:	e44e                	sd	s3,8(sp)
    800027c4:	e052                	sd	s4,0(sp)
    800027c6:	1800                	addi	s0,sp,48
    800027c8:	89aa                	mv	s3,a0
    800027ca:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027cc:	0001e517          	auipc	a0,0x1e
    800027d0:	64c50513          	addi	a0,a0,1612 # 80020e18 <itable>
    800027d4:	00004097          	auipc	ra,0x4
    800027d8:	a96080e7          	jalr	-1386(ra) # 8000626a <acquire>
  empty = 0;
    800027dc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027de:	0001e497          	auipc	s1,0x1e
    800027e2:	65248493          	addi	s1,s1,1618 # 80020e30 <itable+0x18>
    800027e6:	00020697          	auipc	a3,0x20
    800027ea:	0da68693          	addi	a3,a3,218 # 800228c0 <log>
    800027ee:	a039                	j	800027fc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027f0:	02090b63          	beqz	s2,80002826 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f4:	08848493          	addi	s1,s1,136
    800027f8:	02d48a63          	beq	s1,a3,8000282c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027fc:	449c                	lw	a5,8(s1)
    800027fe:	fef059e3          	blez	a5,800027f0 <iget+0x38>
    80002802:	4098                	lw	a4,0(s1)
    80002804:	ff3716e3          	bne	a4,s3,800027f0 <iget+0x38>
    80002808:	40d8                	lw	a4,4(s1)
    8000280a:	ff4713e3          	bne	a4,s4,800027f0 <iget+0x38>
      ip->ref++;
    8000280e:	2785                	addiw	a5,a5,1
    80002810:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002812:	0001e517          	auipc	a0,0x1e
    80002816:	60650513          	addi	a0,a0,1542 # 80020e18 <itable>
    8000281a:	00004097          	auipc	ra,0x4
    8000281e:	b04080e7          	jalr	-1276(ra) # 8000631e <release>
      return ip;
    80002822:	8926                	mv	s2,s1
    80002824:	a03d                	j	80002852 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002826:	f7f9                	bnez	a5,800027f4 <iget+0x3c>
    80002828:	8926                	mv	s2,s1
    8000282a:	b7e9                	j	800027f4 <iget+0x3c>
  if(empty == 0)
    8000282c:	02090c63          	beqz	s2,80002864 <iget+0xac>
  ip->dev = dev;
    80002830:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002834:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002838:	4785                	li	a5,1
    8000283a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002842:	0001e517          	auipc	a0,0x1e
    80002846:	5d650513          	addi	a0,a0,1494 # 80020e18 <itable>
    8000284a:	00004097          	auipc	ra,0x4
    8000284e:	ad4080e7          	jalr	-1324(ra) # 8000631e <release>
}
    80002852:	854a                	mv	a0,s2
    80002854:	70a2                	ld	ra,40(sp)
    80002856:	7402                	ld	s0,32(sp)
    80002858:	64e2                	ld	s1,24(sp)
    8000285a:	6942                	ld	s2,16(sp)
    8000285c:	69a2                	ld	s3,8(sp)
    8000285e:	6a02                	ld	s4,0(sp)
    80002860:	6145                	addi	sp,sp,48
    80002862:	8082                	ret
    panic("iget: no inodes");
    80002864:	00006517          	auipc	a0,0x6
    80002868:	c9c50513          	addi	a0,a0,-868 # 80008500 <syscalls+0x140>
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	4c2080e7          	jalr	1218(ra) # 80005d2e <panic>

0000000080002874 <fsinit>:
fsinit(int dev) {
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	1800                	addi	s0,sp,48
    80002882:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002884:	4585                	li	a1,1
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	a4e080e7          	jalr	-1458(ra) # 800022d4 <bread>
    8000288e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002890:	0001e997          	auipc	s3,0x1e
    80002894:	56898993          	addi	s3,s3,1384 # 80020df8 <sb>
    80002898:	02000613          	li	a2,32
    8000289c:	05850593          	addi	a1,a0,88
    800028a0:	854e                	mv	a0,s3
    800028a2:	ffffe097          	auipc	ra,0xffffe
    800028a6:	932080e7          	jalr	-1742(ra) # 800001d4 <memmove>
  brelse(bp);
    800028aa:	8526                	mv	a0,s1
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	b58080e7          	jalr	-1192(ra) # 80002404 <brelse>
  if(sb.magic != FSMAGIC)
    800028b4:	0009a703          	lw	a4,0(s3)
    800028b8:	102037b7          	lui	a5,0x10203
    800028bc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028c0:	02f71263          	bne	a4,a5,800028e4 <fsinit+0x70>
  initlog(dev, &sb);
    800028c4:	0001e597          	auipc	a1,0x1e
    800028c8:	53458593          	addi	a1,a1,1332 # 80020df8 <sb>
    800028cc:	854a                	mv	a0,s2
    800028ce:	00001097          	auipc	ra,0x1
    800028d2:	b42080e7          	jalr	-1214(ra) # 80003410 <initlog>
}
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6145                	addi	sp,sp,48
    800028e2:	8082                	ret
    panic("invalid file system");
    800028e4:	00006517          	auipc	a0,0x6
    800028e8:	c2c50513          	addi	a0,a0,-980 # 80008510 <syscalls+0x150>
    800028ec:	00003097          	auipc	ra,0x3
    800028f0:	442080e7          	jalr	1090(ra) # 80005d2e <panic>

00000000800028f4 <iinit>:
{
    800028f4:	7179                	addi	sp,sp,-48
    800028f6:	f406                	sd	ra,40(sp)
    800028f8:	f022                	sd	s0,32(sp)
    800028fa:	ec26                	sd	s1,24(sp)
    800028fc:	e84a                	sd	s2,16(sp)
    800028fe:	e44e                	sd	s3,8(sp)
    80002900:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002902:	00006597          	auipc	a1,0x6
    80002906:	c2658593          	addi	a1,a1,-986 # 80008528 <syscalls+0x168>
    8000290a:	0001e517          	auipc	a0,0x1e
    8000290e:	50e50513          	addi	a0,a0,1294 # 80020e18 <itable>
    80002912:	00004097          	auipc	ra,0x4
    80002916:	8c8080e7          	jalr	-1848(ra) # 800061da <initlock>
  for(i = 0; i < NINODE; i++) {
    8000291a:	0001e497          	auipc	s1,0x1e
    8000291e:	52648493          	addi	s1,s1,1318 # 80020e40 <itable+0x28>
    80002922:	00020997          	auipc	s3,0x20
    80002926:	fae98993          	addi	s3,s3,-82 # 800228d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000292a:	00006917          	auipc	s2,0x6
    8000292e:	c0690913          	addi	s2,s2,-1018 # 80008530 <syscalls+0x170>
    80002932:	85ca                	mv	a1,s2
    80002934:	8526                	mv	a0,s1
    80002936:	00001097          	auipc	ra,0x1
    8000293a:	e3e080e7          	jalr	-450(ra) # 80003774 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293e:	08848493          	addi	s1,s1,136
    80002942:	ff3498e3          	bne	s1,s3,80002932 <iinit+0x3e>
}
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6145                	addi	sp,sp,48
    80002952:	8082                	ret

0000000080002954 <ialloc>:
{
    80002954:	715d                	addi	sp,sp,-80
    80002956:	e486                	sd	ra,72(sp)
    80002958:	e0a2                	sd	s0,64(sp)
    8000295a:	fc26                	sd	s1,56(sp)
    8000295c:	f84a                	sd	s2,48(sp)
    8000295e:	f44e                	sd	s3,40(sp)
    80002960:	f052                	sd	s4,32(sp)
    80002962:	ec56                	sd	s5,24(sp)
    80002964:	e85a                	sd	s6,16(sp)
    80002966:	e45e                	sd	s7,8(sp)
    80002968:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000296a:	0001e717          	auipc	a4,0x1e
    8000296e:	49a72703          	lw	a4,1178(a4) # 80020e04 <sb+0xc>
    80002972:	4785                	li	a5,1
    80002974:	04e7fa63          	bgeu	a5,a4,800029c8 <ialloc+0x74>
    80002978:	8aaa                	mv	s5,a0
    8000297a:	8bae                	mv	s7,a1
    8000297c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297e:	0001ea17          	auipc	s4,0x1e
    80002982:	47aa0a13          	addi	s4,s4,1146 # 80020df8 <sb>
    80002986:	00048b1b          	sext.w	s6,s1
    8000298a:	0044d793          	srli	a5,s1,0x4
    8000298e:	018a2583          	lw	a1,24(s4)
    80002992:	9dbd                	addw	a1,a1,a5
    80002994:	8556                	mv	a0,s5
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	93e080e7          	jalr	-1730(ra) # 800022d4 <bread>
    8000299e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029a0:	05850993          	addi	s3,a0,88
    800029a4:	00f4f793          	andi	a5,s1,15
    800029a8:	079a                	slli	a5,a5,0x6
    800029aa:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029ac:	00099783          	lh	a5,0(s3)
    800029b0:	c3a1                	beqz	a5,800029f0 <ialloc+0x9c>
    brelse(bp);
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	a52080e7          	jalr	-1454(ra) # 80002404 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029ba:	0485                	addi	s1,s1,1
    800029bc:	00ca2703          	lw	a4,12(s4)
    800029c0:	0004879b          	sext.w	a5,s1
    800029c4:	fce7e1e3          	bltu	a5,a4,80002986 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029c8:	00006517          	auipc	a0,0x6
    800029cc:	b7050513          	addi	a0,a0,-1168 # 80008538 <syscalls+0x178>
    800029d0:	00003097          	auipc	ra,0x3
    800029d4:	3a8080e7          	jalr	936(ra) # 80005d78 <printf>
  return 0;
    800029d8:	4501                	li	a0,0
}
    800029da:	60a6                	ld	ra,72(sp)
    800029dc:	6406                	ld	s0,64(sp)
    800029de:	74e2                	ld	s1,56(sp)
    800029e0:	7942                	ld	s2,48(sp)
    800029e2:	79a2                	ld	s3,40(sp)
    800029e4:	7a02                	ld	s4,32(sp)
    800029e6:	6ae2                	ld	s5,24(sp)
    800029e8:	6b42                	ld	s6,16(sp)
    800029ea:	6ba2                	ld	s7,8(sp)
    800029ec:	6161                	addi	sp,sp,80
    800029ee:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029f0:	04000613          	li	a2,64
    800029f4:	4581                	li	a1,0
    800029f6:	854e                	mv	a0,s3
    800029f8:	ffffd097          	auipc	ra,0xffffd
    800029fc:	780080e7          	jalr	1920(ra) # 80000178 <memset>
      dip->type = type;
    80002a00:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a04:	854a                	mv	a0,s2
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	c88080e7          	jalr	-888(ra) # 8000368e <log_write>
      brelse(bp);
    80002a0e:	854a                	mv	a0,s2
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	9f4080e7          	jalr	-1548(ra) # 80002404 <brelse>
      return iget(dev, inum);
    80002a18:	85da                	mv	a1,s6
    80002a1a:	8556                	mv	a0,s5
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	d9c080e7          	jalr	-612(ra) # 800027b8 <iget>
    80002a24:	bf5d                	j	800029da <ialloc+0x86>

0000000080002a26 <iupdate>:
{
    80002a26:	1101                	addi	sp,sp,-32
    80002a28:	ec06                	sd	ra,24(sp)
    80002a2a:	e822                	sd	s0,16(sp)
    80002a2c:	e426                	sd	s1,8(sp)
    80002a2e:	e04a                	sd	s2,0(sp)
    80002a30:	1000                	addi	s0,sp,32
    80002a32:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a34:	415c                	lw	a5,4(a0)
    80002a36:	0047d79b          	srliw	a5,a5,0x4
    80002a3a:	0001e597          	auipc	a1,0x1e
    80002a3e:	3d65a583          	lw	a1,982(a1) # 80020e10 <sb+0x18>
    80002a42:	9dbd                	addw	a1,a1,a5
    80002a44:	4108                	lw	a0,0(a0)
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	88e080e7          	jalr	-1906(ra) # 800022d4 <bread>
    80002a4e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a50:	05850793          	addi	a5,a0,88
    80002a54:	40c8                	lw	a0,4(s1)
    80002a56:	893d                	andi	a0,a0,15
    80002a58:	051a                	slli	a0,a0,0x6
    80002a5a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a5c:	04449703          	lh	a4,68(s1)
    80002a60:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a64:	04649703          	lh	a4,70(s1)
    80002a68:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a6c:	04849703          	lh	a4,72(s1)
    80002a70:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a74:	04a49703          	lh	a4,74(s1)
    80002a78:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a7c:	44f8                	lw	a4,76(s1)
    80002a7e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a80:	03400613          	li	a2,52
    80002a84:	05048593          	addi	a1,s1,80
    80002a88:	0531                	addi	a0,a0,12
    80002a8a:	ffffd097          	auipc	ra,0xffffd
    80002a8e:	74a080e7          	jalr	1866(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a92:	854a                	mv	a0,s2
    80002a94:	00001097          	auipc	ra,0x1
    80002a98:	bfa080e7          	jalr	-1030(ra) # 8000368e <log_write>
  brelse(bp);
    80002a9c:	854a                	mv	a0,s2
    80002a9e:	00000097          	auipc	ra,0x0
    80002aa2:	966080e7          	jalr	-1690(ra) # 80002404 <brelse>
}
    80002aa6:	60e2                	ld	ra,24(sp)
    80002aa8:	6442                	ld	s0,16(sp)
    80002aaa:	64a2                	ld	s1,8(sp)
    80002aac:	6902                	ld	s2,0(sp)
    80002aae:	6105                	addi	sp,sp,32
    80002ab0:	8082                	ret

0000000080002ab2 <idup>:
{
    80002ab2:	1101                	addi	sp,sp,-32
    80002ab4:	ec06                	sd	ra,24(sp)
    80002ab6:	e822                	sd	s0,16(sp)
    80002ab8:	e426                	sd	s1,8(sp)
    80002aba:	1000                	addi	s0,sp,32
    80002abc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002abe:	0001e517          	auipc	a0,0x1e
    80002ac2:	35a50513          	addi	a0,a0,858 # 80020e18 <itable>
    80002ac6:	00003097          	auipc	ra,0x3
    80002aca:	7a4080e7          	jalr	1956(ra) # 8000626a <acquire>
  ip->ref++;
    80002ace:	449c                	lw	a5,8(s1)
    80002ad0:	2785                	addiw	a5,a5,1
    80002ad2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad4:	0001e517          	auipc	a0,0x1e
    80002ad8:	34450513          	addi	a0,a0,836 # 80020e18 <itable>
    80002adc:	00004097          	auipc	ra,0x4
    80002ae0:	842080e7          	jalr	-1982(ra) # 8000631e <release>
}
    80002ae4:	8526                	mv	a0,s1
    80002ae6:	60e2                	ld	ra,24(sp)
    80002ae8:	6442                	ld	s0,16(sp)
    80002aea:	64a2                	ld	s1,8(sp)
    80002aec:	6105                	addi	sp,sp,32
    80002aee:	8082                	ret

0000000080002af0 <ilock>:
{
    80002af0:	1101                	addi	sp,sp,-32
    80002af2:	ec06                	sd	ra,24(sp)
    80002af4:	e822                	sd	s0,16(sp)
    80002af6:	e426                	sd	s1,8(sp)
    80002af8:	e04a                	sd	s2,0(sp)
    80002afa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002afc:	c115                	beqz	a0,80002b20 <ilock+0x30>
    80002afe:	84aa                	mv	s1,a0
    80002b00:	451c                	lw	a5,8(a0)
    80002b02:	00f05f63          	blez	a5,80002b20 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b06:	0541                	addi	a0,a0,16
    80002b08:	00001097          	auipc	ra,0x1
    80002b0c:	ca6080e7          	jalr	-858(ra) # 800037ae <acquiresleep>
  if(ip->valid == 0){
    80002b10:	40bc                	lw	a5,64(s1)
    80002b12:	cf99                	beqz	a5,80002b30 <ilock+0x40>
}
    80002b14:	60e2                	ld	ra,24(sp)
    80002b16:	6442                	ld	s0,16(sp)
    80002b18:	64a2                	ld	s1,8(sp)
    80002b1a:	6902                	ld	s2,0(sp)
    80002b1c:	6105                	addi	sp,sp,32
    80002b1e:	8082                	ret
    panic("ilock");
    80002b20:	00006517          	auipc	a0,0x6
    80002b24:	a3050513          	addi	a0,a0,-1488 # 80008550 <syscalls+0x190>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	206080e7          	jalr	518(ra) # 80005d2e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b30:	40dc                	lw	a5,4(s1)
    80002b32:	0047d79b          	srliw	a5,a5,0x4
    80002b36:	0001e597          	auipc	a1,0x1e
    80002b3a:	2da5a583          	lw	a1,730(a1) # 80020e10 <sb+0x18>
    80002b3e:	9dbd                	addw	a1,a1,a5
    80002b40:	4088                	lw	a0,0(s1)
    80002b42:	fffff097          	auipc	ra,0xfffff
    80002b46:	792080e7          	jalr	1938(ra) # 800022d4 <bread>
    80002b4a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4c:	05850593          	addi	a1,a0,88
    80002b50:	40dc                	lw	a5,4(s1)
    80002b52:	8bbd                	andi	a5,a5,15
    80002b54:	079a                	slli	a5,a5,0x6
    80002b56:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b58:	00059783          	lh	a5,0(a1)
    80002b5c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b60:	00259783          	lh	a5,2(a1)
    80002b64:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b68:	00459783          	lh	a5,4(a1)
    80002b6c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b70:	00659783          	lh	a5,6(a1)
    80002b74:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b78:	459c                	lw	a5,8(a1)
    80002b7a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b7c:	03400613          	li	a2,52
    80002b80:	05b1                	addi	a1,a1,12
    80002b82:	05048513          	addi	a0,s1,80
    80002b86:	ffffd097          	auipc	ra,0xffffd
    80002b8a:	64e080e7          	jalr	1614(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	874080e7          	jalr	-1932(ra) # 80002404 <brelse>
    ip->valid = 1;
    80002b98:	4785                	li	a5,1
    80002b9a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b9c:	04449783          	lh	a5,68(s1)
    80002ba0:	fbb5                	bnez	a5,80002b14 <ilock+0x24>
      panic("ilock: no type");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	9b650513          	addi	a0,a0,-1610 # 80008558 <syscalls+0x198>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	184080e7          	jalr	388(ra) # 80005d2e <panic>

0000000080002bb2 <iunlock>:
{
    80002bb2:	1101                	addi	sp,sp,-32
    80002bb4:	ec06                	sd	ra,24(sp)
    80002bb6:	e822                	sd	s0,16(sp)
    80002bb8:	e426                	sd	s1,8(sp)
    80002bba:	e04a                	sd	s2,0(sp)
    80002bbc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bbe:	c905                	beqz	a0,80002bee <iunlock+0x3c>
    80002bc0:	84aa                	mv	s1,a0
    80002bc2:	01050913          	addi	s2,a0,16
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	c80080e7          	jalr	-896(ra) # 80003848 <holdingsleep>
    80002bd0:	cd19                	beqz	a0,80002bee <iunlock+0x3c>
    80002bd2:	449c                	lw	a5,8(s1)
    80002bd4:	00f05d63          	blez	a5,80002bee <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd8:	854a                	mv	a0,s2
    80002bda:	00001097          	auipc	ra,0x1
    80002bde:	c2a080e7          	jalr	-982(ra) # 80003804 <releasesleep>
}
    80002be2:	60e2                	ld	ra,24(sp)
    80002be4:	6442                	ld	s0,16(sp)
    80002be6:	64a2                	ld	s1,8(sp)
    80002be8:	6902                	ld	s2,0(sp)
    80002bea:	6105                	addi	sp,sp,32
    80002bec:	8082                	ret
    panic("iunlock");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	97a50513          	addi	a0,a0,-1670 # 80008568 <syscalls+0x1a8>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	138080e7          	jalr	312(ra) # 80005d2e <panic>

0000000080002bfe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bfe:	7179                	addi	sp,sp,-48
    80002c00:	f406                	sd	ra,40(sp)
    80002c02:	f022                	sd	s0,32(sp)
    80002c04:	ec26                	sd	s1,24(sp)
    80002c06:	e84a                	sd	s2,16(sp)
    80002c08:	e44e                	sd	s3,8(sp)
    80002c0a:	e052                	sd	s4,0(sp)
    80002c0c:	1800                	addi	s0,sp,48
    80002c0e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c10:	05050493          	addi	s1,a0,80
    80002c14:	08050913          	addi	s2,a0,128
    80002c18:	a021                	j	80002c20 <itrunc+0x22>
    80002c1a:	0491                	addi	s1,s1,4
    80002c1c:	01248d63          	beq	s1,s2,80002c36 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c20:	408c                	lw	a1,0(s1)
    80002c22:	dde5                	beqz	a1,80002c1a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c24:	0009a503          	lw	a0,0(s3)
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	8f2080e7          	jalr	-1806(ra) # 8000251a <bfree>
      ip->addrs[i] = 0;
    80002c30:	0004a023          	sw	zero,0(s1)
    80002c34:	b7dd                	j	80002c1a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c36:	0809a583          	lw	a1,128(s3)
    80002c3a:	e185                	bnez	a1,80002c5a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c3c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c40:	854e                	mv	a0,s3
    80002c42:	00000097          	auipc	ra,0x0
    80002c46:	de4080e7          	jalr	-540(ra) # 80002a26 <iupdate>
}
    80002c4a:	70a2                	ld	ra,40(sp)
    80002c4c:	7402                	ld	s0,32(sp)
    80002c4e:	64e2                	ld	s1,24(sp)
    80002c50:	6942                	ld	s2,16(sp)
    80002c52:	69a2                	ld	s3,8(sp)
    80002c54:	6a02                	ld	s4,0(sp)
    80002c56:	6145                	addi	sp,sp,48
    80002c58:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c5a:	0009a503          	lw	a0,0(s3)
    80002c5e:	fffff097          	auipc	ra,0xfffff
    80002c62:	676080e7          	jalr	1654(ra) # 800022d4 <bread>
    80002c66:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c68:	05850493          	addi	s1,a0,88
    80002c6c:	45850913          	addi	s2,a0,1112
    80002c70:	a021                	j	80002c78 <itrunc+0x7a>
    80002c72:	0491                	addi	s1,s1,4
    80002c74:	01248b63          	beq	s1,s2,80002c8a <itrunc+0x8c>
      if(a[j])
    80002c78:	408c                	lw	a1,0(s1)
    80002c7a:	dde5                	beqz	a1,80002c72 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c7c:	0009a503          	lw	a0,0(s3)
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	89a080e7          	jalr	-1894(ra) # 8000251a <bfree>
    80002c88:	b7ed                	j	80002c72 <itrunc+0x74>
    brelse(bp);
    80002c8a:	8552                	mv	a0,s4
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	778080e7          	jalr	1912(ra) # 80002404 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c94:	0809a583          	lw	a1,128(s3)
    80002c98:	0009a503          	lw	a0,0(s3)
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	87e080e7          	jalr	-1922(ra) # 8000251a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca4:	0809a023          	sw	zero,128(s3)
    80002ca8:	bf51                	j	80002c3c <itrunc+0x3e>

0000000080002caa <iput>:
{
    80002caa:	1101                	addi	sp,sp,-32
    80002cac:	ec06                	sd	ra,24(sp)
    80002cae:	e822                	sd	s0,16(sp)
    80002cb0:	e426                	sd	s1,8(sp)
    80002cb2:	e04a                	sd	s2,0(sp)
    80002cb4:	1000                	addi	s0,sp,32
    80002cb6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb8:	0001e517          	auipc	a0,0x1e
    80002cbc:	16050513          	addi	a0,a0,352 # 80020e18 <itable>
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	5aa080e7          	jalr	1450(ra) # 8000626a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc8:	4498                	lw	a4,8(s1)
    80002cca:	4785                	li	a5,1
    80002ccc:	02f70363          	beq	a4,a5,80002cf2 <iput+0x48>
  ip->ref--;
    80002cd0:	449c                	lw	a5,8(s1)
    80002cd2:	37fd                	addiw	a5,a5,-1
    80002cd4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd6:	0001e517          	auipc	a0,0x1e
    80002cda:	14250513          	addi	a0,a0,322 # 80020e18 <itable>
    80002cde:	00003097          	auipc	ra,0x3
    80002ce2:	640080e7          	jalr	1600(ra) # 8000631e <release>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6902                	ld	s2,0(sp)
    80002cee:	6105                	addi	sp,sp,32
    80002cf0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cf2:	40bc                	lw	a5,64(s1)
    80002cf4:	dff1                	beqz	a5,80002cd0 <iput+0x26>
    80002cf6:	04a49783          	lh	a5,74(s1)
    80002cfa:	fbf9                	bnez	a5,80002cd0 <iput+0x26>
    acquiresleep(&ip->lock);
    80002cfc:	01048913          	addi	s2,s1,16
    80002d00:	854a                	mv	a0,s2
    80002d02:	00001097          	auipc	ra,0x1
    80002d06:	aac080e7          	jalr	-1364(ra) # 800037ae <acquiresleep>
    release(&itable.lock);
    80002d0a:	0001e517          	auipc	a0,0x1e
    80002d0e:	10e50513          	addi	a0,a0,270 # 80020e18 <itable>
    80002d12:	00003097          	auipc	ra,0x3
    80002d16:	60c080e7          	jalr	1548(ra) # 8000631e <release>
    itrunc(ip);
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	ee2080e7          	jalr	-286(ra) # 80002bfe <itrunc>
    ip->type = 0;
    80002d24:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d28:	8526                	mv	a0,s1
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	cfc080e7          	jalr	-772(ra) # 80002a26 <iupdate>
    ip->valid = 0;
    80002d32:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d36:	854a                	mv	a0,s2
    80002d38:	00001097          	auipc	ra,0x1
    80002d3c:	acc080e7          	jalr	-1332(ra) # 80003804 <releasesleep>
    acquire(&itable.lock);
    80002d40:	0001e517          	auipc	a0,0x1e
    80002d44:	0d850513          	addi	a0,a0,216 # 80020e18 <itable>
    80002d48:	00003097          	auipc	ra,0x3
    80002d4c:	522080e7          	jalr	1314(ra) # 8000626a <acquire>
    80002d50:	b741                	j	80002cd0 <iput+0x26>

0000000080002d52 <iunlockput>:
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	1000                	addi	s0,sp,32
    80002d5c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	e54080e7          	jalr	-428(ra) # 80002bb2 <iunlock>
  iput(ip);
    80002d66:	8526                	mv	a0,s1
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	f42080e7          	jalr	-190(ra) # 80002caa <iput>
}
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	64a2                	ld	s1,8(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret

0000000080002d7a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d7a:	1141                	addi	sp,sp,-16
    80002d7c:	e422                	sd	s0,8(sp)
    80002d7e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d80:	411c                	lw	a5,0(a0)
    80002d82:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d84:	415c                	lw	a5,4(a0)
    80002d86:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d88:	04451783          	lh	a5,68(a0)
    80002d8c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d90:	04a51783          	lh	a5,74(a0)
    80002d94:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d98:	04c56783          	lwu	a5,76(a0)
    80002d9c:	e99c                	sd	a5,16(a1)
}
    80002d9e:	6422                	ld	s0,8(sp)
    80002da0:	0141                	addi	sp,sp,16
    80002da2:	8082                	ret

0000000080002da4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da4:	457c                	lw	a5,76(a0)
    80002da6:	0ed7e963          	bltu	a5,a3,80002e98 <readi+0xf4>
{
    80002daa:	7159                	addi	sp,sp,-112
    80002dac:	f486                	sd	ra,104(sp)
    80002dae:	f0a2                	sd	s0,96(sp)
    80002db0:	eca6                	sd	s1,88(sp)
    80002db2:	e8ca                	sd	s2,80(sp)
    80002db4:	e4ce                	sd	s3,72(sp)
    80002db6:	e0d2                	sd	s4,64(sp)
    80002db8:	fc56                	sd	s5,56(sp)
    80002dba:	f85a                	sd	s6,48(sp)
    80002dbc:	f45e                	sd	s7,40(sp)
    80002dbe:	f062                	sd	s8,32(sp)
    80002dc0:	ec66                	sd	s9,24(sp)
    80002dc2:	e86a                	sd	s10,16(sp)
    80002dc4:	e46e                	sd	s11,8(sp)
    80002dc6:	1880                	addi	s0,sp,112
    80002dc8:	8b2a                	mv	s6,a0
    80002dca:	8bae                	mv	s7,a1
    80002dcc:	8a32                	mv	s4,a2
    80002dce:	84b6                	mv	s1,a3
    80002dd0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dd2:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd6:	0ad76063          	bltu	a4,a3,80002e76 <readi+0xd2>
  if(off + n > ip->size)
    80002dda:	00e7f463          	bgeu	a5,a4,80002de2 <readi+0x3e>
    n = ip->size - off;
    80002dde:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de2:	0a0a8963          	beqz	s5,80002e94 <readi+0xf0>
    80002de6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dec:	5c7d                	li	s8,-1
    80002dee:	a82d                	j	80002e28 <readi+0x84>
    80002df0:	020d1d93          	slli	s11,s10,0x20
    80002df4:	020ddd93          	srli	s11,s11,0x20
    80002df8:	05890793          	addi	a5,s2,88
    80002dfc:	86ee                	mv	a3,s11
    80002dfe:	963e                	add	a2,a2,a5
    80002e00:	85d2                	mv	a1,s4
    80002e02:	855e                	mv	a0,s7
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	ae4080e7          	jalr	-1308(ra) # 800018e8 <either_copyout>
    80002e0c:	05850d63          	beq	a0,s8,80002e66 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e10:	854a                	mv	a0,s2
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	5f2080e7          	jalr	1522(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e1a:	013d09bb          	addw	s3,s10,s3
    80002e1e:	009d04bb          	addw	s1,s10,s1
    80002e22:	9a6e                	add	s4,s4,s11
    80002e24:	0559f763          	bgeu	s3,s5,80002e72 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e28:	00a4d59b          	srliw	a1,s1,0xa
    80002e2c:	855a                	mv	a0,s6
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	8a0080e7          	jalr	-1888(ra) # 800026ce <bmap>
    80002e36:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e3a:	cd85                	beqz	a1,80002e72 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e3c:	000b2503          	lw	a0,0(s6)
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	494080e7          	jalr	1172(ra) # 800022d4 <bread>
    80002e48:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e4a:	3ff4f613          	andi	a2,s1,1023
    80002e4e:	40cc87bb          	subw	a5,s9,a2
    80002e52:	413a873b          	subw	a4,s5,s3
    80002e56:	8d3e                	mv	s10,a5
    80002e58:	2781                	sext.w	a5,a5
    80002e5a:	0007069b          	sext.w	a3,a4
    80002e5e:	f8f6f9e3          	bgeu	a3,a5,80002df0 <readi+0x4c>
    80002e62:	8d3a                	mv	s10,a4
    80002e64:	b771                	j	80002df0 <readi+0x4c>
      brelse(bp);
    80002e66:	854a                	mv	a0,s2
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	59c080e7          	jalr	1436(ra) # 80002404 <brelse>
      tot = -1;
    80002e70:	59fd                	li	s3,-1
  }
  return tot;
    80002e72:	0009851b          	sext.w	a0,s3
}
    80002e76:	70a6                	ld	ra,104(sp)
    80002e78:	7406                	ld	s0,96(sp)
    80002e7a:	64e6                	ld	s1,88(sp)
    80002e7c:	6946                	ld	s2,80(sp)
    80002e7e:	69a6                	ld	s3,72(sp)
    80002e80:	6a06                	ld	s4,64(sp)
    80002e82:	7ae2                	ld	s5,56(sp)
    80002e84:	7b42                	ld	s6,48(sp)
    80002e86:	7ba2                	ld	s7,40(sp)
    80002e88:	7c02                	ld	s8,32(sp)
    80002e8a:	6ce2                	ld	s9,24(sp)
    80002e8c:	6d42                	ld	s10,16(sp)
    80002e8e:	6da2                	ld	s11,8(sp)
    80002e90:	6165                	addi	sp,sp,112
    80002e92:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e94:	89d6                	mv	s3,s5
    80002e96:	bff1                	j	80002e72 <readi+0xce>
    return 0;
    80002e98:	4501                	li	a0,0
}
    80002e9a:	8082                	ret

0000000080002e9c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9c:	457c                	lw	a5,76(a0)
    80002e9e:	10d7e863          	bltu	a5,a3,80002fae <writei+0x112>
{
    80002ea2:	7159                	addi	sp,sp,-112
    80002ea4:	f486                	sd	ra,104(sp)
    80002ea6:	f0a2                	sd	s0,96(sp)
    80002ea8:	eca6                	sd	s1,88(sp)
    80002eaa:	e8ca                	sd	s2,80(sp)
    80002eac:	e4ce                	sd	s3,72(sp)
    80002eae:	e0d2                	sd	s4,64(sp)
    80002eb0:	fc56                	sd	s5,56(sp)
    80002eb2:	f85a                	sd	s6,48(sp)
    80002eb4:	f45e                	sd	s7,40(sp)
    80002eb6:	f062                	sd	s8,32(sp)
    80002eb8:	ec66                	sd	s9,24(sp)
    80002eba:	e86a                	sd	s10,16(sp)
    80002ebc:	e46e                	sd	s11,8(sp)
    80002ebe:	1880                	addi	s0,sp,112
    80002ec0:	8aaa                	mv	s5,a0
    80002ec2:	8bae                	mv	s7,a1
    80002ec4:	8a32                	mv	s4,a2
    80002ec6:	8936                	mv	s2,a3
    80002ec8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eca:	00e687bb          	addw	a5,a3,a4
    80002ece:	0ed7e263          	bltu	a5,a3,80002fb2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ed2:	00043737          	lui	a4,0x43
    80002ed6:	0ef76063          	bltu	a4,a5,80002fb6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002eda:	0c0b0863          	beqz	s6,80002faa <writei+0x10e>
    80002ede:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee4:	5c7d                	li	s8,-1
    80002ee6:	a091                	j	80002f2a <writei+0x8e>
    80002ee8:	020d1d93          	slli	s11,s10,0x20
    80002eec:	020ddd93          	srli	s11,s11,0x20
    80002ef0:	05848793          	addi	a5,s1,88
    80002ef4:	86ee                	mv	a3,s11
    80002ef6:	8652                	mv	a2,s4
    80002ef8:	85de                	mv	a1,s7
    80002efa:	953e                	add	a0,a0,a5
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	a42080e7          	jalr	-1470(ra) # 8000193e <either_copyin>
    80002f04:	07850263          	beq	a0,s8,80002f68 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	00000097          	auipc	ra,0x0
    80002f0e:	784080e7          	jalr	1924(ra) # 8000368e <log_write>
    brelse(bp);
    80002f12:	8526                	mv	a0,s1
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	4f0080e7          	jalr	1264(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f1c:	013d09bb          	addw	s3,s10,s3
    80002f20:	012d093b          	addw	s2,s10,s2
    80002f24:	9a6e                	add	s4,s4,s11
    80002f26:	0569f663          	bgeu	s3,s6,80002f72 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f2a:	00a9559b          	srliw	a1,s2,0xa
    80002f2e:	8556                	mv	a0,s5
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	79e080e7          	jalr	1950(ra) # 800026ce <bmap>
    80002f38:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f3c:	c99d                	beqz	a1,80002f72 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f3e:	000aa503          	lw	a0,0(s5)
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	392080e7          	jalr	914(ra) # 800022d4 <bread>
    80002f4a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f4c:	3ff97513          	andi	a0,s2,1023
    80002f50:	40ac87bb          	subw	a5,s9,a0
    80002f54:	413b073b          	subw	a4,s6,s3
    80002f58:	8d3e                	mv	s10,a5
    80002f5a:	2781                	sext.w	a5,a5
    80002f5c:	0007069b          	sext.w	a3,a4
    80002f60:	f8f6f4e3          	bgeu	a3,a5,80002ee8 <writei+0x4c>
    80002f64:	8d3a                	mv	s10,a4
    80002f66:	b749                	j	80002ee8 <writei+0x4c>
      brelse(bp);
    80002f68:	8526                	mv	a0,s1
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	49a080e7          	jalr	1178(ra) # 80002404 <brelse>
  }

  if(off > ip->size)
    80002f72:	04caa783          	lw	a5,76(s5)
    80002f76:	0127f463          	bgeu	a5,s2,80002f7e <writei+0xe2>
    ip->size = off;
    80002f7a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f7e:	8556                	mv	a0,s5
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	aa6080e7          	jalr	-1370(ra) # 80002a26 <iupdate>

  return tot;
    80002f88:	0009851b          	sext.w	a0,s3
}
    80002f8c:	70a6                	ld	ra,104(sp)
    80002f8e:	7406                	ld	s0,96(sp)
    80002f90:	64e6                	ld	s1,88(sp)
    80002f92:	6946                	ld	s2,80(sp)
    80002f94:	69a6                	ld	s3,72(sp)
    80002f96:	6a06                	ld	s4,64(sp)
    80002f98:	7ae2                	ld	s5,56(sp)
    80002f9a:	7b42                	ld	s6,48(sp)
    80002f9c:	7ba2                	ld	s7,40(sp)
    80002f9e:	7c02                	ld	s8,32(sp)
    80002fa0:	6ce2                	ld	s9,24(sp)
    80002fa2:	6d42                	ld	s10,16(sp)
    80002fa4:	6da2                	ld	s11,8(sp)
    80002fa6:	6165                	addi	sp,sp,112
    80002fa8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002faa:	89da                	mv	s3,s6
    80002fac:	bfc9                	j	80002f7e <writei+0xe2>
    return -1;
    80002fae:	557d                	li	a0,-1
}
    80002fb0:	8082                	ret
    return -1;
    80002fb2:	557d                	li	a0,-1
    80002fb4:	bfe1                	j	80002f8c <writei+0xf0>
    return -1;
    80002fb6:	557d                	li	a0,-1
    80002fb8:	bfd1                	j	80002f8c <writei+0xf0>

0000000080002fba <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fba:	1141                	addi	sp,sp,-16
    80002fbc:	e406                	sd	ra,8(sp)
    80002fbe:	e022                	sd	s0,0(sp)
    80002fc0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fc2:	4639                	li	a2,14
    80002fc4:	ffffd097          	auipc	ra,0xffffd
    80002fc8:	284080e7          	jalr	644(ra) # 80000248 <strncmp>
}
    80002fcc:	60a2                	ld	ra,8(sp)
    80002fce:	6402                	ld	s0,0(sp)
    80002fd0:	0141                	addi	sp,sp,16
    80002fd2:	8082                	ret

0000000080002fd4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd4:	7139                	addi	sp,sp,-64
    80002fd6:	fc06                	sd	ra,56(sp)
    80002fd8:	f822                	sd	s0,48(sp)
    80002fda:	f426                	sd	s1,40(sp)
    80002fdc:	f04a                	sd	s2,32(sp)
    80002fde:	ec4e                	sd	s3,24(sp)
    80002fe0:	e852                	sd	s4,16(sp)
    80002fe2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe4:	04451703          	lh	a4,68(a0)
    80002fe8:	4785                	li	a5,1
    80002fea:	00f71a63          	bne	a4,a5,80002ffe <dirlookup+0x2a>
    80002fee:	892a                	mv	s2,a0
    80002ff0:	89ae                	mv	s3,a1
    80002ff2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff4:	457c                	lw	a5,76(a0)
    80002ff6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ffa:	e79d                	bnez	a5,80003028 <dirlookup+0x54>
    80002ffc:	a8a5                	j	80003074 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ffe:	00005517          	auipc	a0,0x5
    80003002:	57250513          	addi	a0,a0,1394 # 80008570 <syscalls+0x1b0>
    80003006:	00003097          	auipc	ra,0x3
    8000300a:	d28080e7          	jalr	-728(ra) # 80005d2e <panic>
      panic("dirlookup read");
    8000300e:	00005517          	auipc	a0,0x5
    80003012:	57a50513          	addi	a0,a0,1402 # 80008588 <syscalls+0x1c8>
    80003016:	00003097          	auipc	ra,0x3
    8000301a:	d18080e7          	jalr	-744(ra) # 80005d2e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301e:	24c1                	addiw	s1,s1,16
    80003020:	04c92783          	lw	a5,76(s2)
    80003024:	04f4f763          	bgeu	s1,a5,80003072 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003028:	4741                	li	a4,16
    8000302a:	86a6                	mv	a3,s1
    8000302c:	fc040613          	addi	a2,s0,-64
    80003030:	4581                	li	a1,0
    80003032:	854a                	mv	a0,s2
    80003034:	00000097          	auipc	ra,0x0
    80003038:	d70080e7          	jalr	-656(ra) # 80002da4 <readi>
    8000303c:	47c1                	li	a5,16
    8000303e:	fcf518e3          	bne	a0,a5,8000300e <dirlookup+0x3a>
    if(de.inum == 0)
    80003042:	fc045783          	lhu	a5,-64(s0)
    80003046:	dfe1                	beqz	a5,8000301e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003048:	fc240593          	addi	a1,s0,-62
    8000304c:	854e                	mv	a0,s3
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	f6c080e7          	jalr	-148(ra) # 80002fba <namecmp>
    80003056:	f561                	bnez	a0,8000301e <dirlookup+0x4a>
      if(poff)
    80003058:	000a0463          	beqz	s4,80003060 <dirlookup+0x8c>
        *poff = off;
    8000305c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003060:	fc045583          	lhu	a1,-64(s0)
    80003064:	00092503          	lw	a0,0(s2)
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	750080e7          	jalr	1872(ra) # 800027b8 <iget>
    80003070:	a011                	j	80003074 <dirlookup+0xa0>
  return 0;
    80003072:	4501                	li	a0,0
}
    80003074:	70e2                	ld	ra,56(sp)
    80003076:	7442                	ld	s0,48(sp)
    80003078:	74a2                	ld	s1,40(sp)
    8000307a:	7902                	ld	s2,32(sp)
    8000307c:	69e2                	ld	s3,24(sp)
    8000307e:	6a42                	ld	s4,16(sp)
    80003080:	6121                	addi	sp,sp,64
    80003082:	8082                	ret

0000000080003084 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003084:	711d                	addi	sp,sp,-96
    80003086:	ec86                	sd	ra,88(sp)
    80003088:	e8a2                	sd	s0,80(sp)
    8000308a:	e4a6                	sd	s1,72(sp)
    8000308c:	e0ca                	sd	s2,64(sp)
    8000308e:	fc4e                	sd	s3,56(sp)
    80003090:	f852                	sd	s4,48(sp)
    80003092:	f456                	sd	s5,40(sp)
    80003094:	f05a                	sd	s6,32(sp)
    80003096:	ec5e                	sd	s7,24(sp)
    80003098:	e862                	sd	s8,16(sp)
    8000309a:	e466                	sd	s9,8(sp)
    8000309c:	1080                	addi	s0,sp,96
    8000309e:	84aa                	mv	s1,a0
    800030a0:	8aae                	mv	s5,a1
    800030a2:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030a4:	00054703          	lbu	a4,0(a0)
    800030a8:	02f00793          	li	a5,47
    800030ac:	02f70363          	beq	a4,a5,800030d2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030b0:	ffffe097          	auipc	ra,0xffffe
    800030b4:	d88080e7          	jalr	-632(ra) # 80000e38 <myproc>
    800030b8:	15053503          	ld	a0,336(a0)
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	9f6080e7          	jalr	-1546(ra) # 80002ab2 <idup>
    800030c4:	89aa                	mv	s3,a0
  while(*path == '/')
    800030c6:	02f00913          	li	s2,47
  len = path - s;
    800030ca:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800030cc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030ce:	4b85                	li	s7,1
    800030d0:	a865                	j	80003188 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030d2:	4585                	li	a1,1
    800030d4:	4505                	li	a0,1
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	6e2080e7          	jalr	1762(ra) # 800027b8 <iget>
    800030de:	89aa                	mv	s3,a0
    800030e0:	b7dd                	j	800030c6 <namex+0x42>
      iunlockput(ip);
    800030e2:	854e                	mv	a0,s3
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	c6e080e7          	jalr	-914(ra) # 80002d52 <iunlockput>
      return 0;
    800030ec:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ee:	854e                	mv	a0,s3
    800030f0:	60e6                	ld	ra,88(sp)
    800030f2:	6446                	ld	s0,80(sp)
    800030f4:	64a6                	ld	s1,72(sp)
    800030f6:	6906                	ld	s2,64(sp)
    800030f8:	79e2                	ld	s3,56(sp)
    800030fa:	7a42                	ld	s4,48(sp)
    800030fc:	7aa2                	ld	s5,40(sp)
    800030fe:	7b02                	ld	s6,32(sp)
    80003100:	6be2                	ld	s7,24(sp)
    80003102:	6c42                	ld	s8,16(sp)
    80003104:	6ca2                	ld	s9,8(sp)
    80003106:	6125                	addi	sp,sp,96
    80003108:	8082                	ret
      iunlock(ip);
    8000310a:	854e                	mv	a0,s3
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	aa6080e7          	jalr	-1370(ra) # 80002bb2 <iunlock>
      return ip;
    80003114:	bfe9                	j	800030ee <namex+0x6a>
      iunlockput(ip);
    80003116:	854e                	mv	a0,s3
    80003118:	00000097          	auipc	ra,0x0
    8000311c:	c3a080e7          	jalr	-966(ra) # 80002d52 <iunlockput>
      return 0;
    80003120:	89e6                	mv	s3,s9
    80003122:	b7f1                	j	800030ee <namex+0x6a>
  len = path - s;
    80003124:	40b48633          	sub	a2,s1,a1
    80003128:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000312c:	099c5463          	bge	s8,s9,800031b4 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003130:	4639                	li	a2,14
    80003132:	8552                	mv	a0,s4
    80003134:	ffffd097          	auipc	ra,0xffffd
    80003138:	0a0080e7          	jalr	160(ra) # 800001d4 <memmove>
  while(*path == '/')
    8000313c:	0004c783          	lbu	a5,0(s1)
    80003140:	01279763          	bne	a5,s2,8000314e <namex+0xca>
    path++;
    80003144:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003146:	0004c783          	lbu	a5,0(s1)
    8000314a:	ff278de3          	beq	a5,s2,80003144 <namex+0xc0>
    ilock(ip);
    8000314e:	854e                	mv	a0,s3
    80003150:	00000097          	auipc	ra,0x0
    80003154:	9a0080e7          	jalr	-1632(ra) # 80002af0 <ilock>
    if(ip->type != T_DIR){
    80003158:	04499783          	lh	a5,68(s3)
    8000315c:	f97793e3          	bne	a5,s7,800030e2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003160:	000a8563          	beqz	s5,8000316a <namex+0xe6>
    80003164:	0004c783          	lbu	a5,0(s1)
    80003168:	d3cd                	beqz	a5,8000310a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000316a:	865a                	mv	a2,s6
    8000316c:	85d2                	mv	a1,s4
    8000316e:	854e                	mv	a0,s3
    80003170:	00000097          	auipc	ra,0x0
    80003174:	e64080e7          	jalr	-412(ra) # 80002fd4 <dirlookup>
    80003178:	8caa                	mv	s9,a0
    8000317a:	dd51                	beqz	a0,80003116 <namex+0x92>
    iunlockput(ip);
    8000317c:	854e                	mv	a0,s3
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	bd4080e7          	jalr	-1068(ra) # 80002d52 <iunlockput>
    ip = next;
    80003186:	89e6                	mv	s3,s9
  while(*path == '/')
    80003188:	0004c783          	lbu	a5,0(s1)
    8000318c:	05279763          	bne	a5,s2,800031da <namex+0x156>
    path++;
    80003190:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003192:	0004c783          	lbu	a5,0(s1)
    80003196:	ff278de3          	beq	a5,s2,80003190 <namex+0x10c>
  if(*path == 0)
    8000319a:	c79d                	beqz	a5,800031c8 <namex+0x144>
    path++;
    8000319c:	85a6                	mv	a1,s1
  len = path - s;
    8000319e:	8cda                	mv	s9,s6
    800031a0:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800031a2:	01278963          	beq	a5,s2,800031b4 <namex+0x130>
    800031a6:	dfbd                	beqz	a5,80003124 <namex+0xa0>
    path++;
    800031a8:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031aa:	0004c783          	lbu	a5,0(s1)
    800031ae:	ff279ce3          	bne	a5,s2,800031a6 <namex+0x122>
    800031b2:	bf8d                	j	80003124 <namex+0xa0>
    memmove(name, s, len);
    800031b4:	2601                	sext.w	a2,a2
    800031b6:	8552                	mv	a0,s4
    800031b8:	ffffd097          	auipc	ra,0xffffd
    800031bc:	01c080e7          	jalr	28(ra) # 800001d4 <memmove>
    name[len] = 0;
    800031c0:	9cd2                	add	s9,s9,s4
    800031c2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031c6:	bf9d                	j	8000313c <namex+0xb8>
  if(nameiparent){
    800031c8:	f20a83e3          	beqz	s5,800030ee <namex+0x6a>
    iput(ip);
    800031cc:	854e                	mv	a0,s3
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	adc080e7          	jalr	-1316(ra) # 80002caa <iput>
    return 0;
    800031d6:	4981                	li	s3,0
    800031d8:	bf19                	j	800030ee <namex+0x6a>
  if(*path == 0)
    800031da:	d7fd                	beqz	a5,800031c8 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031dc:	0004c783          	lbu	a5,0(s1)
    800031e0:	85a6                	mv	a1,s1
    800031e2:	b7d1                	j	800031a6 <namex+0x122>

00000000800031e4 <dirlink>:
{
    800031e4:	7139                	addi	sp,sp,-64
    800031e6:	fc06                	sd	ra,56(sp)
    800031e8:	f822                	sd	s0,48(sp)
    800031ea:	f426                	sd	s1,40(sp)
    800031ec:	f04a                	sd	s2,32(sp)
    800031ee:	ec4e                	sd	s3,24(sp)
    800031f0:	e852                	sd	s4,16(sp)
    800031f2:	0080                	addi	s0,sp,64
    800031f4:	892a                	mv	s2,a0
    800031f6:	8a2e                	mv	s4,a1
    800031f8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031fa:	4601                	li	a2,0
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	dd8080e7          	jalr	-552(ra) # 80002fd4 <dirlookup>
    80003204:	e93d                	bnez	a0,8000327a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003206:	04c92483          	lw	s1,76(s2)
    8000320a:	c49d                	beqz	s1,80003238 <dirlink+0x54>
    8000320c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320e:	4741                	li	a4,16
    80003210:	86a6                	mv	a3,s1
    80003212:	fc040613          	addi	a2,s0,-64
    80003216:	4581                	li	a1,0
    80003218:	854a                	mv	a0,s2
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	b8a080e7          	jalr	-1142(ra) # 80002da4 <readi>
    80003222:	47c1                	li	a5,16
    80003224:	06f51163          	bne	a0,a5,80003286 <dirlink+0xa2>
    if(de.inum == 0)
    80003228:	fc045783          	lhu	a5,-64(s0)
    8000322c:	c791                	beqz	a5,80003238 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322e:	24c1                	addiw	s1,s1,16
    80003230:	04c92783          	lw	a5,76(s2)
    80003234:	fcf4ede3          	bltu	s1,a5,8000320e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003238:	4639                	li	a2,14
    8000323a:	85d2                	mv	a1,s4
    8000323c:	fc240513          	addi	a0,s0,-62
    80003240:	ffffd097          	auipc	ra,0xffffd
    80003244:	044080e7          	jalr	68(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003248:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324c:	4741                	li	a4,16
    8000324e:	86a6                	mv	a3,s1
    80003250:	fc040613          	addi	a2,s0,-64
    80003254:	4581                	li	a1,0
    80003256:	854a                	mv	a0,s2
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	c44080e7          	jalr	-956(ra) # 80002e9c <writei>
    80003260:	1541                	addi	a0,a0,-16
    80003262:	00a03533          	snez	a0,a0
    80003266:	40a00533          	neg	a0,a0
}
    8000326a:	70e2                	ld	ra,56(sp)
    8000326c:	7442                	ld	s0,48(sp)
    8000326e:	74a2                	ld	s1,40(sp)
    80003270:	7902                	ld	s2,32(sp)
    80003272:	69e2                	ld	s3,24(sp)
    80003274:	6a42                	ld	s4,16(sp)
    80003276:	6121                	addi	sp,sp,64
    80003278:	8082                	ret
    iput(ip);
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	a30080e7          	jalr	-1488(ra) # 80002caa <iput>
    return -1;
    80003282:	557d                	li	a0,-1
    80003284:	b7dd                	j	8000326a <dirlink+0x86>
      panic("dirlink read");
    80003286:	00005517          	auipc	a0,0x5
    8000328a:	31250513          	addi	a0,a0,786 # 80008598 <syscalls+0x1d8>
    8000328e:	00003097          	auipc	ra,0x3
    80003292:	aa0080e7          	jalr	-1376(ra) # 80005d2e <panic>

0000000080003296 <namei>:

struct inode*
namei(char *path)
{
    80003296:	1101                	addi	sp,sp,-32
    80003298:	ec06                	sd	ra,24(sp)
    8000329a:	e822                	sd	s0,16(sp)
    8000329c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000329e:	fe040613          	addi	a2,s0,-32
    800032a2:	4581                	li	a1,0
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	de0080e7          	jalr	-544(ra) # 80003084 <namex>
}
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	6105                	addi	sp,sp,32
    800032b2:	8082                	ret

00000000800032b4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b4:	1141                	addi	sp,sp,-16
    800032b6:	e406                	sd	ra,8(sp)
    800032b8:	e022                	sd	s0,0(sp)
    800032ba:	0800                	addi	s0,sp,16
    800032bc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032be:	4585                	li	a1,1
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	dc4080e7          	jalr	-572(ra) # 80003084 <namex>
}
    800032c8:	60a2                	ld	ra,8(sp)
    800032ca:	6402                	ld	s0,0(sp)
    800032cc:	0141                	addi	sp,sp,16
    800032ce:	8082                	ret

00000000800032d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032d0:	1101                	addi	sp,sp,-32
    800032d2:	ec06                	sd	ra,24(sp)
    800032d4:	e822                	sd	s0,16(sp)
    800032d6:	e426                	sd	s1,8(sp)
    800032d8:	e04a                	sd	s2,0(sp)
    800032da:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032dc:	0001f917          	auipc	s2,0x1f
    800032e0:	5e490913          	addi	s2,s2,1508 # 800228c0 <log>
    800032e4:	01892583          	lw	a1,24(s2)
    800032e8:	02892503          	lw	a0,40(s2)
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	fe8080e7          	jalr	-24(ra) # 800022d4 <bread>
    800032f4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032f6:	02c92683          	lw	a3,44(s2)
    800032fa:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032fc:	02d05863          	blez	a3,8000332c <write_head+0x5c>
    80003300:	0001f797          	auipc	a5,0x1f
    80003304:	5f078793          	addi	a5,a5,1520 # 800228f0 <log+0x30>
    80003308:	05c50713          	addi	a4,a0,92
    8000330c:	36fd                	addiw	a3,a3,-1
    8000330e:	02069613          	slli	a2,a3,0x20
    80003312:	01e65693          	srli	a3,a2,0x1e
    80003316:	0001f617          	auipc	a2,0x1f
    8000331a:	5de60613          	addi	a2,a2,1502 # 800228f4 <log+0x34>
    8000331e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003320:	4390                	lw	a2,0(a5)
    80003322:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003324:	0791                	addi	a5,a5,4
    80003326:	0711                	addi	a4,a4,4
    80003328:	fed79ce3          	bne	a5,a3,80003320 <write_head+0x50>
  }
  bwrite(buf);
    8000332c:	8526                	mv	a0,s1
    8000332e:	fffff097          	auipc	ra,0xfffff
    80003332:	098080e7          	jalr	152(ra) # 800023c6 <bwrite>
  brelse(buf);
    80003336:	8526                	mv	a0,s1
    80003338:	fffff097          	auipc	ra,0xfffff
    8000333c:	0cc080e7          	jalr	204(ra) # 80002404 <brelse>
}
    80003340:	60e2                	ld	ra,24(sp)
    80003342:	6442                	ld	s0,16(sp)
    80003344:	64a2                	ld	s1,8(sp)
    80003346:	6902                	ld	s2,0(sp)
    80003348:	6105                	addi	sp,sp,32
    8000334a:	8082                	ret

000000008000334c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000334c:	0001f797          	auipc	a5,0x1f
    80003350:	5a07a783          	lw	a5,1440(a5) # 800228ec <log+0x2c>
    80003354:	0af05d63          	blez	a5,8000340e <install_trans+0xc2>
{
    80003358:	7139                	addi	sp,sp,-64
    8000335a:	fc06                	sd	ra,56(sp)
    8000335c:	f822                	sd	s0,48(sp)
    8000335e:	f426                	sd	s1,40(sp)
    80003360:	f04a                	sd	s2,32(sp)
    80003362:	ec4e                	sd	s3,24(sp)
    80003364:	e852                	sd	s4,16(sp)
    80003366:	e456                	sd	s5,8(sp)
    80003368:	e05a                	sd	s6,0(sp)
    8000336a:	0080                	addi	s0,sp,64
    8000336c:	8b2a                	mv	s6,a0
    8000336e:	0001fa97          	auipc	s5,0x1f
    80003372:	582a8a93          	addi	s5,s5,1410 # 800228f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003376:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003378:	0001f997          	auipc	s3,0x1f
    8000337c:	54898993          	addi	s3,s3,1352 # 800228c0 <log>
    80003380:	a00d                	j	800033a2 <install_trans+0x56>
    brelse(lbuf);
    80003382:	854a                	mv	a0,s2
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	080080e7          	jalr	128(ra) # 80002404 <brelse>
    brelse(dbuf);
    8000338c:	8526                	mv	a0,s1
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	076080e7          	jalr	118(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003396:	2a05                	addiw	s4,s4,1
    80003398:	0a91                	addi	s5,s5,4
    8000339a:	02c9a783          	lw	a5,44(s3)
    8000339e:	04fa5e63          	bge	s4,a5,800033fa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a2:	0189a583          	lw	a1,24(s3)
    800033a6:	014585bb          	addw	a1,a1,s4
    800033aa:	2585                	addiw	a1,a1,1
    800033ac:	0289a503          	lw	a0,40(s3)
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	f24080e7          	jalr	-220(ra) # 800022d4 <bread>
    800033b8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033ba:	000aa583          	lw	a1,0(s5)
    800033be:	0289a503          	lw	a0,40(s3)
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	f12080e7          	jalr	-238(ra) # 800022d4 <bread>
    800033ca:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033cc:	40000613          	li	a2,1024
    800033d0:	05890593          	addi	a1,s2,88
    800033d4:	05850513          	addi	a0,a0,88
    800033d8:	ffffd097          	auipc	ra,0xffffd
    800033dc:	dfc080e7          	jalr	-516(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e0:	8526                	mv	a0,s1
    800033e2:	fffff097          	auipc	ra,0xfffff
    800033e6:	fe4080e7          	jalr	-28(ra) # 800023c6 <bwrite>
    if(recovering == 0)
    800033ea:	f80b1ce3          	bnez	s6,80003382 <install_trans+0x36>
      bunpin(dbuf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	0ee080e7          	jalr	238(ra) # 800024de <bunpin>
    800033f8:	b769                	j	80003382 <install_trans+0x36>
}
    800033fa:	70e2                	ld	ra,56(sp)
    800033fc:	7442                	ld	s0,48(sp)
    800033fe:	74a2                	ld	s1,40(sp)
    80003400:	7902                	ld	s2,32(sp)
    80003402:	69e2                	ld	s3,24(sp)
    80003404:	6a42                	ld	s4,16(sp)
    80003406:	6aa2                	ld	s5,8(sp)
    80003408:	6b02                	ld	s6,0(sp)
    8000340a:	6121                	addi	sp,sp,64
    8000340c:	8082                	ret
    8000340e:	8082                	ret

0000000080003410 <initlog>:
{
    80003410:	7179                	addi	sp,sp,-48
    80003412:	f406                	sd	ra,40(sp)
    80003414:	f022                	sd	s0,32(sp)
    80003416:	ec26                	sd	s1,24(sp)
    80003418:	e84a                	sd	s2,16(sp)
    8000341a:	e44e                	sd	s3,8(sp)
    8000341c:	1800                	addi	s0,sp,48
    8000341e:	892a                	mv	s2,a0
    80003420:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003422:	0001f497          	auipc	s1,0x1f
    80003426:	49e48493          	addi	s1,s1,1182 # 800228c0 <log>
    8000342a:	00005597          	auipc	a1,0x5
    8000342e:	17e58593          	addi	a1,a1,382 # 800085a8 <syscalls+0x1e8>
    80003432:	8526                	mv	a0,s1
    80003434:	00003097          	auipc	ra,0x3
    80003438:	da6080e7          	jalr	-602(ra) # 800061da <initlock>
  log.start = sb->logstart;
    8000343c:	0149a583          	lw	a1,20(s3)
    80003440:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003442:	0109a783          	lw	a5,16(s3)
    80003446:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003448:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000344c:	854a                	mv	a0,s2
    8000344e:	fffff097          	auipc	ra,0xfffff
    80003452:	e86080e7          	jalr	-378(ra) # 800022d4 <bread>
  log.lh.n = lh->n;
    80003456:	4d34                	lw	a3,88(a0)
    80003458:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000345a:	02d05663          	blez	a3,80003486 <initlog+0x76>
    8000345e:	05c50793          	addi	a5,a0,92
    80003462:	0001f717          	auipc	a4,0x1f
    80003466:	48e70713          	addi	a4,a4,1166 # 800228f0 <log+0x30>
    8000346a:	36fd                	addiw	a3,a3,-1
    8000346c:	02069613          	slli	a2,a3,0x20
    80003470:	01e65693          	srli	a3,a2,0x1e
    80003474:	06050613          	addi	a2,a0,96
    80003478:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000347a:	4390                	lw	a2,0(a5)
    8000347c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000347e:	0791                	addi	a5,a5,4
    80003480:	0711                	addi	a4,a4,4
    80003482:	fed79ce3          	bne	a5,a3,8000347a <initlog+0x6a>
  brelse(buf);
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f7e080e7          	jalr	-130(ra) # 80002404 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000348e:	4505                	li	a0,1
    80003490:	00000097          	auipc	ra,0x0
    80003494:	ebc080e7          	jalr	-324(ra) # 8000334c <install_trans>
  log.lh.n = 0;
    80003498:	0001f797          	auipc	a5,0x1f
    8000349c:	4407aa23          	sw	zero,1108(a5) # 800228ec <log+0x2c>
  write_head(); // clear the log
    800034a0:	00000097          	auipc	ra,0x0
    800034a4:	e30080e7          	jalr	-464(ra) # 800032d0 <write_head>
}
    800034a8:	70a2                	ld	ra,40(sp)
    800034aa:	7402                	ld	s0,32(sp)
    800034ac:	64e2                	ld	s1,24(sp)
    800034ae:	6942                	ld	s2,16(sp)
    800034b0:	69a2                	ld	s3,8(sp)
    800034b2:	6145                	addi	sp,sp,48
    800034b4:	8082                	ret

00000000800034b6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034b6:	1101                	addi	sp,sp,-32
    800034b8:	ec06                	sd	ra,24(sp)
    800034ba:	e822                	sd	s0,16(sp)
    800034bc:	e426                	sd	s1,8(sp)
    800034be:	e04a                	sd	s2,0(sp)
    800034c0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034c2:	0001f517          	auipc	a0,0x1f
    800034c6:	3fe50513          	addi	a0,a0,1022 # 800228c0 <log>
    800034ca:	00003097          	auipc	ra,0x3
    800034ce:	da0080e7          	jalr	-608(ra) # 8000626a <acquire>
  while(1){
    if(log.committing){
    800034d2:	0001f497          	auipc	s1,0x1f
    800034d6:	3ee48493          	addi	s1,s1,1006 # 800228c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034da:	4979                	li	s2,30
    800034dc:	a039                	j	800034ea <begin_op+0x34>
      sleep(&log, &log.lock);
    800034de:	85a6                	mv	a1,s1
    800034e0:	8526                	mv	a0,s1
    800034e2:	ffffe097          	auipc	ra,0xffffe
    800034e6:	ffe080e7          	jalr	-2(ra) # 800014e0 <sleep>
    if(log.committing){
    800034ea:	50dc                	lw	a5,36(s1)
    800034ec:	fbed                	bnez	a5,800034de <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034ee:	509c                	lw	a5,32(s1)
    800034f0:	0017871b          	addiw	a4,a5,1
    800034f4:	0007069b          	sext.w	a3,a4
    800034f8:	0027179b          	slliw	a5,a4,0x2
    800034fc:	9fb9                	addw	a5,a5,a4
    800034fe:	0017979b          	slliw	a5,a5,0x1
    80003502:	54d8                	lw	a4,44(s1)
    80003504:	9fb9                	addw	a5,a5,a4
    80003506:	00f95963          	bge	s2,a5,80003518 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000350a:	85a6                	mv	a1,s1
    8000350c:	8526                	mv	a0,s1
    8000350e:	ffffe097          	auipc	ra,0xffffe
    80003512:	fd2080e7          	jalr	-46(ra) # 800014e0 <sleep>
    80003516:	bfd1                	j	800034ea <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003518:	0001f517          	auipc	a0,0x1f
    8000351c:	3a850513          	addi	a0,a0,936 # 800228c0 <log>
    80003520:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003522:	00003097          	auipc	ra,0x3
    80003526:	dfc080e7          	jalr	-516(ra) # 8000631e <release>
      break;
    }
  }
}
    8000352a:	60e2                	ld	ra,24(sp)
    8000352c:	6442                	ld	s0,16(sp)
    8000352e:	64a2                	ld	s1,8(sp)
    80003530:	6902                	ld	s2,0(sp)
    80003532:	6105                	addi	sp,sp,32
    80003534:	8082                	ret

0000000080003536 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003536:	7139                	addi	sp,sp,-64
    80003538:	fc06                	sd	ra,56(sp)
    8000353a:	f822                	sd	s0,48(sp)
    8000353c:	f426                	sd	s1,40(sp)
    8000353e:	f04a                	sd	s2,32(sp)
    80003540:	ec4e                	sd	s3,24(sp)
    80003542:	e852                	sd	s4,16(sp)
    80003544:	e456                	sd	s5,8(sp)
    80003546:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003548:	0001f497          	auipc	s1,0x1f
    8000354c:	37848493          	addi	s1,s1,888 # 800228c0 <log>
    80003550:	8526                	mv	a0,s1
    80003552:	00003097          	auipc	ra,0x3
    80003556:	d18080e7          	jalr	-744(ra) # 8000626a <acquire>
  log.outstanding -= 1;
    8000355a:	509c                	lw	a5,32(s1)
    8000355c:	37fd                	addiw	a5,a5,-1
    8000355e:	0007891b          	sext.w	s2,a5
    80003562:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003564:	50dc                	lw	a5,36(s1)
    80003566:	e7b9                	bnez	a5,800035b4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003568:	04091e63          	bnez	s2,800035c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000356c:	0001f497          	auipc	s1,0x1f
    80003570:	35448493          	addi	s1,s1,852 # 800228c0 <log>
    80003574:	4785                	li	a5,1
    80003576:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003578:	8526                	mv	a0,s1
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	da4080e7          	jalr	-604(ra) # 8000631e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003582:	54dc                	lw	a5,44(s1)
    80003584:	06f04763          	bgtz	a5,800035f2 <end_op+0xbc>
    acquire(&log.lock);
    80003588:	0001f497          	auipc	s1,0x1f
    8000358c:	33848493          	addi	s1,s1,824 # 800228c0 <log>
    80003590:	8526                	mv	a0,s1
    80003592:	00003097          	auipc	ra,0x3
    80003596:	cd8080e7          	jalr	-808(ra) # 8000626a <acquire>
    log.committing = 0;
    8000359a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000359e:	8526                	mv	a0,s1
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	fa4080e7          	jalr	-92(ra) # 80001544 <wakeup>
    release(&log.lock);
    800035a8:	8526                	mv	a0,s1
    800035aa:	00003097          	auipc	ra,0x3
    800035ae:	d74080e7          	jalr	-652(ra) # 8000631e <release>
}
    800035b2:	a03d                	j	800035e0 <end_op+0xaa>
    panic("log.committing");
    800035b4:	00005517          	auipc	a0,0x5
    800035b8:	ffc50513          	addi	a0,a0,-4 # 800085b0 <syscalls+0x1f0>
    800035bc:	00002097          	auipc	ra,0x2
    800035c0:	772080e7          	jalr	1906(ra) # 80005d2e <panic>
    wakeup(&log);
    800035c4:	0001f497          	auipc	s1,0x1f
    800035c8:	2fc48493          	addi	s1,s1,764 # 800228c0 <log>
    800035cc:	8526                	mv	a0,s1
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	f76080e7          	jalr	-138(ra) # 80001544 <wakeup>
  release(&log.lock);
    800035d6:	8526                	mv	a0,s1
    800035d8:	00003097          	auipc	ra,0x3
    800035dc:	d46080e7          	jalr	-698(ra) # 8000631e <release>
}
    800035e0:	70e2                	ld	ra,56(sp)
    800035e2:	7442                	ld	s0,48(sp)
    800035e4:	74a2                	ld	s1,40(sp)
    800035e6:	7902                	ld	s2,32(sp)
    800035e8:	69e2                	ld	s3,24(sp)
    800035ea:	6a42                	ld	s4,16(sp)
    800035ec:	6aa2                	ld	s5,8(sp)
    800035ee:	6121                	addi	sp,sp,64
    800035f0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f2:	0001fa97          	auipc	s5,0x1f
    800035f6:	2fea8a93          	addi	s5,s5,766 # 800228f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035fa:	0001fa17          	auipc	s4,0x1f
    800035fe:	2c6a0a13          	addi	s4,s4,710 # 800228c0 <log>
    80003602:	018a2583          	lw	a1,24(s4)
    80003606:	012585bb          	addw	a1,a1,s2
    8000360a:	2585                	addiw	a1,a1,1
    8000360c:	028a2503          	lw	a0,40(s4)
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	cc4080e7          	jalr	-828(ra) # 800022d4 <bread>
    80003618:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000361a:	000aa583          	lw	a1,0(s5)
    8000361e:	028a2503          	lw	a0,40(s4)
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	cb2080e7          	jalr	-846(ra) # 800022d4 <bread>
    8000362a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000362c:	40000613          	li	a2,1024
    80003630:	05850593          	addi	a1,a0,88
    80003634:	05848513          	addi	a0,s1,88
    80003638:	ffffd097          	auipc	ra,0xffffd
    8000363c:	b9c080e7          	jalr	-1124(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	d84080e7          	jalr	-636(ra) # 800023c6 <bwrite>
    brelse(from);
    8000364a:	854e                	mv	a0,s3
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	db8080e7          	jalr	-584(ra) # 80002404 <brelse>
    brelse(to);
    80003654:	8526                	mv	a0,s1
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	dae080e7          	jalr	-594(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365e:	2905                	addiw	s2,s2,1
    80003660:	0a91                	addi	s5,s5,4
    80003662:	02ca2783          	lw	a5,44(s4)
    80003666:	f8f94ee3          	blt	s2,a5,80003602 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	c66080e7          	jalr	-922(ra) # 800032d0 <write_head>
    install_trans(0); // Now install writes to home locations
    80003672:	4501                	li	a0,0
    80003674:	00000097          	auipc	ra,0x0
    80003678:	cd8080e7          	jalr	-808(ra) # 8000334c <install_trans>
    log.lh.n = 0;
    8000367c:	0001f797          	auipc	a5,0x1f
    80003680:	2607a823          	sw	zero,624(a5) # 800228ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003684:	00000097          	auipc	ra,0x0
    80003688:	c4c080e7          	jalr	-948(ra) # 800032d0 <write_head>
    8000368c:	bdf5                	j	80003588 <end_op+0x52>

000000008000368e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	e04a                	sd	s2,0(sp)
    80003698:	1000                	addi	s0,sp,32
    8000369a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000369c:	0001f917          	auipc	s2,0x1f
    800036a0:	22490913          	addi	s2,s2,548 # 800228c0 <log>
    800036a4:	854a                	mv	a0,s2
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	bc4080e7          	jalr	-1084(ra) # 8000626a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036ae:	02c92603          	lw	a2,44(s2)
    800036b2:	47f5                	li	a5,29
    800036b4:	06c7c563          	blt	a5,a2,8000371e <log_write+0x90>
    800036b8:	0001f797          	auipc	a5,0x1f
    800036bc:	2247a783          	lw	a5,548(a5) # 800228dc <log+0x1c>
    800036c0:	37fd                	addiw	a5,a5,-1
    800036c2:	04f65e63          	bge	a2,a5,8000371e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036c6:	0001f797          	auipc	a5,0x1f
    800036ca:	21a7a783          	lw	a5,538(a5) # 800228e0 <log+0x20>
    800036ce:	06f05063          	blez	a5,8000372e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036d2:	4781                	li	a5,0
    800036d4:	06c05563          	blez	a2,8000373e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d8:	44cc                	lw	a1,12(s1)
    800036da:	0001f717          	auipc	a4,0x1f
    800036de:	21670713          	addi	a4,a4,534 # 800228f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036e4:	4314                	lw	a3,0(a4)
    800036e6:	04b68c63          	beq	a3,a1,8000373e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036ea:	2785                	addiw	a5,a5,1
    800036ec:	0711                	addi	a4,a4,4
    800036ee:	fef61be3          	bne	a2,a5,800036e4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036f2:	0621                	addi	a2,a2,8
    800036f4:	060a                	slli	a2,a2,0x2
    800036f6:	0001f797          	auipc	a5,0x1f
    800036fa:	1ca78793          	addi	a5,a5,458 # 800228c0 <log>
    800036fe:	963e                	add	a2,a2,a5
    80003700:	44dc                	lw	a5,12(s1)
    80003702:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003704:	8526                	mv	a0,s1
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	d9c080e7          	jalr	-612(ra) # 800024a2 <bpin>
    log.lh.n++;
    8000370e:	0001f717          	auipc	a4,0x1f
    80003712:	1b270713          	addi	a4,a4,434 # 800228c0 <log>
    80003716:	575c                	lw	a5,44(a4)
    80003718:	2785                	addiw	a5,a5,1
    8000371a:	d75c                	sw	a5,44(a4)
    8000371c:	a835                	j	80003758 <log_write+0xca>
    panic("too big a transaction");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	ea250513          	addi	a0,a0,-350 # 800085c0 <syscalls+0x200>
    80003726:	00002097          	auipc	ra,0x2
    8000372a:	608080e7          	jalr	1544(ra) # 80005d2e <panic>
    panic("log_write outside of trans");
    8000372e:	00005517          	auipc	a0,0x5
    80003732:	eaa50513          	addi	a0,a0,-342 # 800085d8 <syscalls+0x218>
    80003736:	00002097          	auipc	ra,0x2
    8000373a:	5f8080e7          	jalr	1528(ra) # 80005d2e <panic>
  log.lh.block[i] = b->blockno;
    8000373e:	00878713          	addi	a4,a5,8
    80003742:	00271693          	slli	a3,a4,0x2
    80003746:	0001f717          	auipc	a4,0x1f
    8000374a:	17a70713          	addi	a4,a4,378 # 800228c0 <log>
    8000374e:	9736                	add	a4,a4,a3
    80003750:	44d4                	lw	a3,12(s1)
    80003752:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003754:	faf608e3          	beq	a2,a5,80003704 <log_write+0x76>
  }
  release(&log.lock);
    80003758:	0001f517          	auipc	a0,0x1f
    8000375c:	16850513          	addi	a0,a0,360 # 800228c0 <log>
    80003760:	00003097          	auipc	ra,0x3
    80003764:	bbe080e7          	jalr	-1090(ra) # 8000631e <release>
}
    80003768:	60e2                	ld	ra,24(sp)
    8000376a:	6442                	ld	s0,16(sp)
    8000376c:	64a2                	ld	s1,8(sp)
    8000376e:	6902                	ld	s2,0(sp)
    80003770:	6105                	addi	sp,sp,32
    80003772:	8082                	ret

0000000080003774 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
    80003782:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003784:	00005597          	auipc	a1,0x5
    80003788:	e7458593          	addi	a1,a1,-396 # 800085f8 <syscalls+0x238>
    8000378c:	0521                	addi	a0,a0,8
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	a4c080e7          	jalr	-1460(ra) # 800061da <initlock>
  lk->name = name;
    80003796:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000379a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000379e:	0204a423          	sw	zero,40(s1)
}
    800037a2:	60e2                	ld	ra,24(sp)
    800037a4:	6442                	ld	s0,16(sp)
    800037a6:	64a2                	ld	s1,8(sp)
    800037a8:	6902                	ld	s2,0(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret

00000000800037ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037bc:	00850913          	addi	s2,a0,8
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	aa8080e7          	jalr	-1368(ra) # 8000626a <acquire>
  while (lk->locked) {
    800037ca:	409c                	lw	a5,0(s1)
    800037cc:	cb89                	beqz	a5,800037de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ce:	85ca                	mv	a1,s2
    800037d0:	8526                	mv	a0,s1
    800037d2:	ffffe097          	auipc	ra,0xffffe
    800037d6:	d0e080e7          	jalr	-754(ra) # 800014e0 <sleep>
  while (lk->locked) {
    800037da:	409c                	lw	a5,0(s1)
    800037dc:	fbed                	bnez	a5,800037ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037de:	4785                	li	a5,1
    800037e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	656080e7          	jalr	1622(ra) # 80000e38 <myproc>
    800037ea:	591c                	lw	a5,48(a0)
    800037ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	b2e080e7          	jalr	-1234(ra) # 8000631e <release>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	addi	s0,sp,32
    80003810:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003812:	00850913          	addi	s2,a0,8
    80003816:	854a                	mv	a0,s2
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	a52080e7          	jalr	-1454(ra) # 8000626a <acquire>
  lk->locked = 0;
    80003820:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003824:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003828:	8526                	mv	a0,s1
    8000382a:	ffffe097          	auipc	ra,0xffffe
    8000382e:	d1a080e7          	jalr	-742(ra) # 80001544 <wakeup>
  release(&lk->lk);
    80003832:	854a                	mv	a0,s2
    80003834:	00003097          	auipc	ra,0x3
    80003838:	aea080e7          	jalr	-1302(ra) # 8000631e <release>
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003848:	7179                	addi	sp,sp,-48
    8000384a:	f406                	sd	ra,40(sp)
    8000384c:	f022                	sd	s0,32(sp)
    8000384e:	ec26                	sd	s1,24(sp)
    80003850:	e84a                	sd	s2,16(sp)
    80003852:	e44e                	sd	s3,8(sp)
    80003854:	1800                	addi	s0,sp,48
    80003856:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003858:	00850913          	addi	s2,a0,8
    8000385c:	854a                	mv	a0,s2
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	a0c080e7          	jalr	-1524(ra) # 8000626a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003866:	409c                	lw	a5,0(s1)
    80003868:	ef99                	bnez	a5,80003886 <holdingsleep+0x3e>
    8000386a:	4481                	li	s1,0
  release(&lk->lk);
    8000386c:	854a                	mv	a0,s2
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	ab0080e7          	jalr	-1360(ra) # 8000631e <release>
  return r;
}
    80003876:	8526                	mv	a0,s1
    80003878:	70a2                	ld	ra,40(sp)
    8000387a:	7402                	ld	s0,32(sp)
    8000387c:	64e2                	ld	s1,24(sp)
    8000387e:	6942                	ld	s2,16(sp)
    80003880:	69a2                	ld	s3,8(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003886:	0284a983          	lw	s3,40(s1)
    8000388a:	ffffd097          	auipc	ra,0xffffd
    8000388e:	5ae080e7          	jalr	1454(ra) # 80000e38 <myproc>
    80003892:	5904                	lw	s1,48(a0)
    80003894:	413484b3          	sub	s1,s1,s3
    80003898:	0014b493          	seqz	s1,s1
    8000389c:	bfc1                	j	8000386c <holdingsleep+0x24>

000000008000389e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000389e:	1141                	addi	sp,sp,-16
    800038a0:	e406                	sd	ra,8(sp)
    800038a2:	e022                	sd	s0,0(sp)
    800038a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038a6:	00005597          	auipc	a1,0x5
    800038aa:	d6258593          	addi	a1,a1,-670 # 80008608 <syscalls+0x248>
    800038ae:	0001f517          	auipc	a0,0x1f
    800038b2:	15a50513          	addi	a0,a0,346 # 80022a08 <ftable>
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	924080e7          	jalr	-1756(ra) # 800061da <initlock>
}
    800038be:	60a2                	ld	ra,8(sp)
    800038c0:	6402                	ld	s0,0(sp)
    800038c2:	0141                	addi	sp,sp,16
    800038c4:	8082                	ret

00000000800038c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038d0:	0001f517          	auipc	a0,0x1f
    800038d4:	13850513          	addi	a0,a0,312 # 80022a08 <ftable>
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	992080e7          	jalr	-1646(ra) # 8000626a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e0:	0001f497          	auipc	s1,0x1f
    800038e4:	14048493          	addi	s1,s1,320 # 80022a20 <ftable+0x18>
    800038e8:	00020717          	auipc	a4,0x20
    800038ec:	0d870713          	addi	a4,a4,216 # 800239c0 <disk>
    if(f->ref == 0){
    800038f0:	40dc                	lw	a5,4(s1)
    800038f2:	cf99                	beqz	a5,80003910 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038f4:	02848493          	addi	s1,s1,40
    800038f8:	fee49ce3          	bne	s1,a4,800038f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038fc:	0001f517          	auipc	a0,0x1f
    80003900:	10c50513          	addi	a0,a0,268 # 80022a08 <ftable>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	a1a080e7          	jalr	-1510(ra) # 8000631e <release>
  return 0;
    8000390c:	4481                	li	s1,0
    8000390e:	a819                	j	80003924 <filealloc+0x5e>
      f->ref = 1;
    80003910:	4785                	li	a5,1
    80003912:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003914:	0001f517          	auipc	a0,0x1f
    80003918:	0f450513          	addi	a0,a0,244 # 80022a08 <ftable>
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	a02080e7          	jalr	-1534(ra) # 8000631e <release>
}
    80003924:	8526                	mv	a0,s1
    80003926:	60e2                	ld	ra,24(sp)
    80003928:	6442                	ld	s0,16(sp)
    8000392a:	64a2                	ld	s1,8(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003930:	1101                	addi	sp,sp,-32
    80003932:	ec06                	sd	ra,24(sp)
    80003934:	e822                	sd	s0,16(sp)
    80003936:	e426                	sd	s1,8(sp)
    80003938:	1000                	addi	s0,sp,32
    8000393a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000393c:	0001f517          	auipc	a0,0x1f
    80003940:	0cc50513          	addi	a0,a0,204 # 80022a08 <ftable>
    80003944:	00003097          	auipc	ra,0x3
    80003948:	926080e7          	jalr	-1754(ra) # 8000626a <acquire>
  if(f->ref < 1)
    8000394c:	40dc                	lw	a5,4(s1)
    8000394e:	02f05263          	blez	a5,80003972 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003952:	2785                	addiw	a5,a5,1
    80003954:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003956:	0001f517          	auipc	a0,0x1f
    8000395a:	0b250513          	addi	a0,a0,178 # 80022a08 <ftable>
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	9c0080e7          	jalr	-1600(ra) # 8000631e <release>
  return f;
}
    80003966:	8526                	mv	a0,s1
    80003968:	60e2                	ld	ra,24(sp)
    8000396a:	6442                	ld	s0,16(sp)
    8000396c:	64a2                	ld	s1,8(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret
    panic("filedup");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	c9e50513          	addi	a0,a0,-866 # 80008610 <syscalls+0x250>
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	3b4080e7          	jalr	948(ra) # 80005d2e <panic>

0000000080003982 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003982:	7139                	addi	sp,sp,-64
    80003984:	fc06                	sd	ra,56(sp)
    80003986:	f822                	sd	s0,48(sp)
    80003988:	f426                	sd	s1,40(sp)
    8000398a:	f04a                	sd	s2,32(sp)
    8000398c:	ec4e                	sd	s3,24(sp)
    8000398e:	e852                	sd	s4,16(sp)
    80003990:	e456                	sd	s5,8(sp)
    80003992:	0080                	addi	s0,sp,64
    80003994:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003996:	0001f517          	auipc	a0,0x1f
    8000399a:	07250513          	addi	a0,a0,114 # 80022a08 <ftable>
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	8cc080e7          	jalr	-1844(ra) # 8000626a <acquire>
  if(f->ref < 1)
    800039a6:	40dc                	lw	a5,4(s1)
    800039a8:	06f05163          	blez	a5,80003a0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039ac:	37fd                	addiw	a5,a5,-1
    800039ae:	0007871b          	sext.w	a4,a5
    800039b2:	c0dc                	sw	a5,4(s1)
    800039b4:	06e04363          	bgtz	a4,80003a1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b8:	0004a903          	lw	s2,0(s1)
    800039bc:	0094ca83          	lbu	s5,9(s1)
    800039c0:	0104ba03          	ld	s4,16(s1)
    800039c4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039cc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039d0:	0001f517          	auipc	a0,0x1f
    800039d4:	03850513          	addi	a0,a0,56 # 80022a08 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	946080e7          	jalr	-1722(ra) # 8000631e <release>

  if(ff.type == FD_PIPE){
    800039e0:	4785                	li	a5,1
    800039e2:	04f90d63          	beq	s2,a5,80003a3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039e6:	3979                	addiw	s2,s2,-2
    800039e8:	4785                	li	a5,1
    800039ea:	0527e063          	bltu	a5,s2,80003a2a <fileclose+0xa8>
    begin_op();
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	ac8080e7          	jalr	-1336(ra) # 800034b6 <begin_op>
    iput(ff.ip);
    800039f6:	854e                	mv	a0,s3
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	2b2080e7          	jalr	690(ra) # 80002caa <iput>
    end_op();
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	b36080e7          	jalr	-1226(ra) # 80003536 <end_op>
    80003a08:	a00d                	j	80003a2a <fileclose+0xa8>
    panic("fileclose");
    80003a0a:	00005517          	auipc	a0,0x5
    80003a0e:	c0e50513          	addi	a0,a0,-1010 # 80008618 <syscalls+0x258>
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	31c080e7          	jalr	796(ra) # 80005d2e <panic>
    release(&ftable.lock);
    80003a1a:	0001f517          	auipc	a0,0x1f
    80003a1e:	fee50513          	addi	a0,a0,-18 # 80022a08 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	8fc080e7          	jalr	-1796(ra) # 8000631e <release>
  }
}
    80003a2a:	70e2                	ld	ra,56(sp)
    80003a2c:	7442                	ld	s0,48(sp)
    80003a2e:	74a2                	ld	s1,40(sp)
    80003a30:	7902                	ld	s2,32(sp)
    80003a32:	69e2                	ld	s3,24(sp)
    80003a34:	6a42                	ld	s4,16(sp)
    80003a36:	6aa2                	ld	s5,8(sp)
    80003a38:	6121                	addi	sp,sp,64
    80003a3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a3c:	85d6                	mv	a1,s5
    80003a3e:	8552                	mv	a0,s4
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	3a6080e7          	jalr	934(ra) # 80003de6 <pipeclose>
    80003a48:	b7cd                	j	80003a2a <fileclose+0xa8>

0000000080003a4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a4a:	715d                	addi	sp,sp,-80
    80003a4c:	e486                	sd	ra,72(sp)
    80003a4e:	e0a2                	sd	s0,64(sp)
    80003a50:	fc26                	sd	s1,56(sp)
    80003a52:	f84a                	sd	s2,48(sp)
    80003a54:	f44e                	sd	s3,40(sp)
    80003a56:	0880                	addi	s0,sp,80
    80003a58:	84aa                	mv	s1,a0
    80003a5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a5c:	ffffd097          	auipc	ra,0xffffd
    80003a60:	3dc080e7          	jalr	988(ra) # 80000e38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	37f9                	addiw	a5,a5,-2
    80003a68:	4705                	li	a4,1
    80003a6a:	04f76763          	bltu	a4,a5,80003ab8 <filestat+0x6e>
    80003a6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a70:	6c88                	ld	a0,24(s1)
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	07e080e7          	jalr	126(ra) # 80002af0 <ilock>
    stati(f->ip, &st);
    80003a7a:	fb840593          	addi	a1,s0,-72
    80003a7e:	6c88                	ld	a0,24(s1)
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	2fa080e7          	jalr	762(ra) # 80002d7a <stati>
    iunlock(f->ip);
    80003a88:	6c88                	ld	a0,24(s1)
    80003a8a:	fffff097          	auipc	ra,0xfffff
    80003a8e:	128080e7          	jalr	296(ra) # 80002bb2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a92:	46e1                	li	a3,24
    80003a94:	fb840613          	addi	a2,s0,-72
    80003a98:	85ce                	mv	a1,s3
    80003a9a:	05093503          	ld	a0,80(s2)
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	056080e7          	jalr	86(ra) # 80000af4 <copyout>
    80003aa6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aaa:	60a6                	ld	ra,72(sp)
    80003aac:	6406                	ld	s0,64(sp)
    80003aae:	74e2                	ld	s1,56(sp)
    80003ab0:	7942                	ld	s2,48(sp)
    80003ab2:	79a2                	ld	s3,40(sp)
    80003ab4:	6161                	addi	sp,sp,80
    80003ab6:	8082                	ret
  return -1;
    80003ab8:	557d                	li	a0,-1
    80003aba:	bfc5                	j	80003aaa <filestat+0x60>

0000000080003abc <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003abc:	7179                	addi	sp,sp,-48
    80003abe:	f406                	sd	ra,40(sp)
    80003ac0:	f022                	sd	s0,32(sp)
    80003ac2:	ec26                	sd	s1,24(sp)
    80003ac4:	e84a                	sd	s2,16(sp)
    80003ac6:	e44e                	sd	s3,8(sp)
    80003ac8:	1800                	addi	s0,sp,48
    80003aca:	84aa                	mv	s1,a0
    80003acc:	89ae                	mv	s3,a1
    80003ace:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003ad0:	85b2                	mv	a1,a2
    80003ad2:	00005517          	auipc	a0,0x5
    80003ad6:	b5650513          	addi	a0,a0,-1194 # 80008628 <syscalls+0x268>
    80003ada:	00002097          	auipc	ra,0x2
    80003ade:	29e080e7          	jalr	670(ra) # 80005d78 <printf>
  ilock(f->ip);
    80003ae2:	6c88                	ld	a0,24(s1)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	00c080e7          	jalr	12(ra) # 80002af0 <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003aec:	6705                	lui	a4,0x1
    80003aee:	86ca                	mv	a3,s2
    80003af0:	864e                	mv	a2,s3
    80003af2:	4581                	li	a1,0
    80003af4:	6c88                	ld	a0,24(s1)
    80003af6:	fffff097          	auipc	ra,0xfffff
    80003afa:	2ae080e7          	jalr	686(ra) # 80002da4 <readi>
  iunlock(f->ip);
    80003afe:	6c88                	ld	a0,24(s1)
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	0b2080e7          	jalr	178(ra) # 80002bb2 <iunlock>
}
    80003b08:	70a2                	ld	ra,40(sp)
    80003b0a:	7402                	ld	s0,32(sp)
    80003b0c:	64e2                	ld	s1,24(sp)
    80003b0e:	6942                	ld	s2,16(sp)
    80003b10:	69a2                	ld	s3,8(sp)
    80003b12:	6145                	addi	sp,sp,48
    80003b14:	8082                	ret

0000000080003b16 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b16:	7179                	addi	sp,sp,-48
    80003b18:	f406                	sd	ra,40(sp)
    80003b1a:	f022                	sd	s0,32(sp)
    80003b1c:	ec26                	sd	s1,24(sp)
    80003b1e:	e84a                	sd	s2,16(sp)
    80003b20:	e44e                	sd	s3,8(sp)
    80003b22:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b24:	00854783          	lbu	a5,8(a0)
    80003b28:	c3d5                	beqz	a5,80003bcc <fileread+0xb6>
    80003b2a:	84aa                	mv	s1,a0
    80003b2c:	89ae                	mv	s3,a1
    80003b2e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b30:	411c                	lw	a5,0(a0)
    80003b32:	4705                	li	a4,1
    80003b34:	04e78963          	beq	a5,a4,80003b86 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b38:	470d                	li	a4,3
    80003b3a:	04e78d63          	beq	a5,a4,80003b94 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b3e:	4709                	li	a4,2
    80003b40:	06e79e63          	bne	a5,a4,80003bbc <fileread+0xa6>
    ilock(f->ip);
    80003b44:	6d08                	ld	a0,24(a0)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	faa080e7          	jalr	-86(ra) # 80002af0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b4e:	874a                	mv	a4,s2
    80003b50:	5094                	lw	a3,32(s1)
    80003b52:	864e                	mv	a2,s3
    80003b54:	4585                	li	a1,1
    80003b56:	6c88                	ld	a0,24(s1)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	24c080e7          	jalr	588(ra) # 80002da4 <readi>
    80003b60:	892a                	mv	s2,a0
    80003b62:	00a05563          	blez	a0,80003b6c <fileread+0x56>
      f->off += r;
    80003b66:	509c                	lw	a5,32(s1)
    80003b68:	9fa9                	addw	a5,a5,a0
    80003b6a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b6c:	6c88                	ld	a0,24(s1)
    80003b6e:	fffff097          	auipc	ra,0xfffff
    80003b72:	044080e7          	jalr	68(ra) # 80002bb2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b76:	854a                	mv	a0,s2
    80003b78:	70a2                	ld	ra,40(sp)
    80003b7a:	7402                	ld	s0,32(sp)
    80003b7c:	64e2                	ld	s1,24(sp)
    80003b7e:	6942                	ld	s2,16(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	6145                	addi	sp,sp,48
    80003b84:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b86:	6908                	ld	a0,16(a0)
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	3c6080e7          	jalr	966(ra) # 80003f4e <piperead>
    80003b90:	892a                	mv	s2,a0
    80003b92:	b7d5                	j	80003b76 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b94:	02451783          	lh	a5,36(a0)
    80003b98:	03079693          	slli	a3,a5,0x30
    80003b9c:	92c1                	srli	a3,a3,0x30
    80003b9e:	4725                	li	a4,9
    80003ba0:	02d76863          	bltu	a4,a3,80003bd0 <fileread+0xba>
    80003ba4:	0792                	slli	a5,a5,0x4
    80003ba6:	0001f717          	auipc	a4,0x1f
    80003baa:	dc270713          	addi	a4,a4,-574 # 80022968 <devsw>
    80003bae:	97ba                	add	a5,a5,a4
    80003bb0:	639c                	ld	a5,0(a5)
    80003bb2:	c38d                	beqz	a5,80003bd4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bb4:	4505                	li	a0,1
    80003bb6:	9782                	jalr	a5
    80003bb8:	892a                	mv	s2,a0
    80003bba:	bf75                	j	80003b76 <fileread+0x60>
    panic("fileread");
    80003bbc:	00005517          	auipc	a0,0x5
    80003bc0:	a7450513          	addi	a0,a0,-1420 # 80008630 <syscalls+0x270>
    80003bc4:	00002097          	auipc	ra,0x2
    80003bc8:	16a080e7          	jalr	362(ra) # 80005d2e <panic>
    return -1;
    80003bcc:	597d                	li	s2,-1
    80003bce:	b765                	j	80003b76 <fileread+0x60>
      return -1;
    80003bd0:	597d                	li	s2,-1
    80003bd2:	b755                	j	80003b76 <fileread+0x60>
    80003bd4:	597d                	li	s2,-1
    80003bd6:	b745                	j	80003b76 <fileread+0x60>

0000000080003bd8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bd8:	715d                	addi	sp,sp,-80
    80003bda:	e486                	sd	ra,72(sp)
    80003bdc:	e0a2                	sd	s0,64(sp)
    80003bde:	fc26                	sd	s1,56(sp)
    80003be0:	f84a                	sd	s2,48(sp)
    80003be2:	f44e                	sd	s3,40(sp)
    80003be4:	f052                	sd	s4,32(sp)
    80003be6:	ec56                	sd	s5,24(sp)
    80003be8:	e85a                	sd	s6,16(sp)
    80003bea:	e45e                	sd	s7,8(sp)
    80003bec:	e062                	sd	s8,0(sp)
    80003bee:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003bf0:	00954783          	lbu	a5,9(a0)
    80003bf4:	10078663          	beqz	a5,80003d00 <filewrite+0x128>
    80003bf8:	892a                	mv	s2,a0
    80003bfa:	8aae                	mv	s5,a1
    80003bfc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bfe:	411c                	lw	a5,0(a0)
    80003c00:	4705                	li	a4,1
    80003c02:	02e78263          	beq	a5,a4,80003c26 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c06:	470d                	li	a4,3
    80003c08:	02e78663          	beq	a5,a4,80003c34 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c0c:	4709                	li	a4,2
    80003c0e:	0ee79163          	bne	a5,a4,80003cf0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c12:	0ac05d63          	blez	a2,80003ccc <filewrite+0xf4>
    int i = 0;
    80003c16:	4981                	li	s3,0
    80003c18:	6b05                	lui	s6,0x1
    80003c1a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c1e:	6b85                	lui	s7,0x1
    80003c20:	c00b8b9b          	addiw	s7,s7,-1024
    80003c24:	a861                	j	80003cbc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c26:	6908                	ld	a0,16(a0)
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	22e080e7          	jalr	558(ra) # 80003e56 <pipewrite>
    80003c30:	8a2a                	mv	s4,a0
    80003c32:	a045                	j	80003cd2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c34:	02451783          	lh	a5,36(a0)
    80003c38:	03079693          	slli	a3,a5,0x30
    80003c3c:	92c1                	srli	a3,a3,0x30
    80003c3e:	4725                	li	a4,9
    80003c40:	0cd76263          	bltu	a4,a3,80003d04 <filewrite+0x12c>
    80003c44:	0792                	slli	a5,a5,0x4
    80003c46:	0001f717          	auipc	a4,0x1f
    80003c4a:	d2270713          	addi	a4,a4,-734 # 80022968 <devsw>
    80003c4e:	97ba                	add	a5,a5,a4
    80003c50:	679c                	ld	a5,8(a5)
    80003c52:	cbdd                	beqz	a5,80003d08 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c54:	4505                	li	a0,1
    80003c56:	9782                	jalr	a5
    80003c58:	8a2a                	mv	s4,a0
    80003c5a:	a8a5                	j	80003cd2 <filewrite+0xfa>
    80003c5c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	856080e7          	jalr	-1962(ra) # 800034b6 <begin_op>
      ilock(f->ip);
    80003c68:	01893503          	ld	a0,24(s2)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	e84080e7          	jalr	-380(ra) # 80002af0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c74:	8762                	mv	a4,s8
    80003c76:	02092683          	lw	a3,32(s2)
    80003c7a:	01598633          	add	a2,s3,s5
    80003c7e:	4585                	li	a1,1
    80003c80:	01893503          	ld	a0,24(s2)
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	218080e7          	jalr	536(ra) # 80002e9c <writei>
    80003c8c:	84aa                	mv	s1,a0
    80003c8e:	00a05763          	blez	a0,80003c9c <filewrite+0xc4>
        f->off += r;
    80003c92:	02092783          	lw	a5,32(s2)
    80003c96:	9fa9                	addw	a5,a5,a0
    80003c98:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c9c:	01893503          	ld	a0,24(s2)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	f12080e7          	jalr	-238(ra) # 80002bb2 <iunlock>
      end_op();
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	88e080e7          	jalr	-1906(ra) # 80003536 <end_op>

      if(r != n1){
    80003cb0:	009c1f63          	bne	s8,s1,80003cce <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cb4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cb8:	0149db63          	bge	s3,s4,80003cce <filewrite+0xf6>
      int n1 = n - i;
    80003cbc:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cc0:	84be                	mv	s1,a5
    80003cc2:	2781                	sext.w	a5,a5
    80003cc4:	f8fb5ce3          	bge	s6,a5,80003c5c <filewrite+0x84>
    80003cc8:	84de                	mv	s1,s7
    80003cca:	bf49                	j	80003c5c <filewrite+0x84>
    int i = 0;
    80003ccc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cce:	013a1f63          	bne	s4,s3,80003cec <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cd2:	8552                	mv	a0,s4
    80003cd4:	60a6                	ld	ra,72(sp)
    80003cd6:	6406                	ld	s0,64(sp)
    80003cd8:	74e2                	ld	s1,56(sp)
    80003cda:	7942                	ld	s2,48(sp)
    80003cdc:	79a2                	ld	s3,40(sp)
    80003cde:	7a02                	ld	s4,32(sp)
    80003ce0:	6ae2                	ld	s5,24(sp)
    80003ce2:	6b42                	ld	s6,16(sp)
    80003ce4:	6ba2                	ld	s7,8(sp)
    80003ce6:	6c02                	ld	s8,0(sp)
    80003ce8:	6161                	addi	sp,sp,80
    80003cea:	8082                	ret
    ret = (i == n ? n : -1);
    80003cec:	5a7d                	li	s4,-1
    80003cee:	b7d5                	j	80003cd2 <filewrite+0xfa>
    panic("filewrite");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	95050513          	addi	a0,a0,-1712 # 80008640 <syscalls+0x280>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	036080e7          	jalr	54(ra) # 80005d2e <panic>
    return -1;
    80003d00:	5a7d                	li	s4,-1
    80003d02:	bfc1                	j	80003cd2 <filewrite+0xfa>
      return -1;
    80003d04:	5a7d                	li	s4,-1
    80003d06:	b7f1                	j	80003cd2 <filewrite+0xfa>
    80003d08:	5a7d                	li	s4,-1
    80003d0a:	b7e1                	j	80003cd2 <filewrite+0xfa>

0000000080003d0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d0c:	7179                	addi	sp,sp,-48
    80003d0e:	f406                	sd	ra,40(sp)
    80003d10:	f022                	sd	s0,32(sp)
    80003d12:	ec26                	sd	s1,24(sp)
    80003d14:	e84a                	sd	s2,16(sp)
    80003d16:	e44e                	sd	s3,8(sp)
    80003d18:	e052                	sd	s4,0(sp)
    80003d1a:	1800                	addi	s0,sp,48
    80003d1c:	84aa                	mv	s1,a0
    80003d1e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d20:	0005b023          	sd	zero,0(a1)
    80003d24:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	b9e080e7          	jalr	-1122(ra) # 800038c6 <filealloc>
    80003d30:	e088                	sd	a0,0(s1)
    80003d32:	c551                	beqz	a0,80003dbe <pipealloc+0xb2>
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	b92080e7          	jalr	-1134(ra) # 800038c6 <filealloc>
    80003d3c:	00aa3023          	sd	a0,0(s4)
    80003d40:	c92d                	beqz	a0,80003db2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d42:	ffffc097          	auipc	ra,0xffffc
    80003d46:	3d6080e7          	jalr	982(ra) # 80000118 <kalloc>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	c125                	beqz	a0,80003dac <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d4e:	4985                	li	s3,1
    80003d50:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d54:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d58:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d5c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d60:	00005597          	auipc	a1,0x5
    80003d64:	8f058593          	addi	a1,a1,-1808 # 80008650 <syscalls+0x290>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	472080e7          	jalr	1138(ra) # 800061da <initlock>
  (*f0)->type = FD_PIPE;
    80003d70:	609c                	ld	a5,0(s1)
    80003d72:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d76:	609c                	ld	a5,0(s1)
    80003d78:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d7c:	609c                	ld	a5,0(s1)
    80003d7e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d82:	609c                	ld	a5,0(s1)
    80003d84:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d88:	000a3783          	ld	a5,0(s4)
    80003d8c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d90:	000a3783          	ld	a5,0(s4)
    80003d94:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d98:	000a3783          	ld	a5,0(s4)
    80003d9c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003da0:	000a3783          	ld	a5,0(s4)
    80003da4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003da8:	4501                	li	a0,0
    80003daa:	a025                	j	80003dd2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dac:	6088                	ld	a0,0(s1)
    80003dae:	e501                	bnez	a0,80003db6 <pipealloc+0xaa>
    80003db0:	a039                	j	80003dbe <pipealloc+0xb2>
    80003db2:	6088                	ld	a0,0(s1)
    80003db4:	c51d                	beqz	a0,80003de2 <pipealloc+0xd6>
    fileclose(*f0);
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	bcc080e7          	jalr	-1076(ra) # 80003982 <fileclose>
  if(*f1)
    80003dbe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dc2:	557d                	li	a0,-1
  if(*f1)
    80003dc4:	c799                	beqz	a5,80003dd2 <pipealloc+0xc6>
    fileclose(*f1);
    80003dc6:	853e                	mv	a0,a5
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	bba080e7          	jalr	-1094(ra) # 80003982 <fileclose>
  return -1;
    80003dd0:	557d                	li	a0,-1
}
    80003dd2:	70a2                	ld	ra,40(sp)
    80003dd4:	7402                	ld	s0,32(sp)
    80003dd6:	64e2                	ld	s1,24(sp)
    80003dd8:	6942                	ld	s2,16(sp)
    80003dda:	69a2                	ld	s3,8(sp)
    80003ddc:	6a02                	ld	s4,0(sp)
    80003dde:	6145                	addi	sp,sp,48
    80003de0:	8082                	ret
  return -1;
    80003de2:	557d                	li	a0,-1
    80003de4:	b7fd                	j	80003dd2 <pipealloc+0xc6>

0000000080003de6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003de6:	1101                	addi	sp,sp,-32
    80003de8:	ec06                	sd	ra,24(sp)
    80003dea:	e822                	sd	s0,16(sp)
    80003dec:	e426                	sd	s1,8(sp)
    80003dee:	e04a                	sd	s2,0(sp)
    80003df0:	1000                	addi	s0,sp,32
    80003df2:	84aa                	mv	s1,a0
    80003df4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	474080e7          	jalr	1140(ra) # 8000626a <acquire>
  if(writable){
    80003dfe:	02090d63          	beqz	s2,80003e38 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e02:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e06:	21848513          	addi	a0,s1,536
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	73a080e7          	jalr	1850(ra) # 80001544 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e12:	2204b783          	ld	a5,544(s1)
    80003e16:	eb95                	bnez	a5,80003e4a <pipeclose+0x64>
    release(&pi->lock);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	504080e7          	jalr	1284(ra) # 8000631e <release>
    kfree((char*)pi);
    80003e22:	8526                	mv	a0,s1
    80003e24:	ffffc097          	auipc	ra,0xffffc
    80003e28:	1f8080e7          	jalr	504(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e2c:	60e2                	ld	ra,24(sp)
    80003e2e:	6442                	ld	s0,16(sp)
    80003e30:	64a2                	ld	s1,8(sp)
    80003e32:	6902                	ld	s2,0(sp)
    80003e34:	6105                	addi	sp,sp,32
    80003e36:	8082                	ret
    pi->readopen = 0;
    80003e38:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e3c:	21c48513          	addi	a0,s1,540
    80003e40:	ffffd097          	auipc	ra,0xffffd
    80003e44:	704080e7          	jalr	1796(ra) # 80001544 <wakeup>
    80003e48:	b7e9                	j	80003e12 <pipeclose+0x2c>
    release(&pi->lock);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	00002097          	auipc	ra,0x2
    80003e50:	4d2080e7          	jalr	1234(ra) # 8000631e <release>
}
    80003e54:	bfe1                	j	80003e2c <pipeclose+0x46>

0000000080003e56 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e56:	711d                	addi	sp,sp,-96
    80003e58:	ec86                	sd	ra,88(sp)
    80003e5a:	e8a2                	sd	s0,80(sp)
    80003e5c:	e4a6                	sd	s1,72(sp)
    80003e5e:	e0ca                	sd	s2,64(sp)
    80003e60:	fc4e                	sd	s3,56(sp)
    80003e62:	f852                	sd	s4,48(sp)
    80003e64:	f456                	sd	s5,40(sp)
    80003e66:	f05a                	sd	s6,32(sp)
    80003e68:	ec5e                	sd	s7,24(sp)
    80003e6a:	e862                	sd	s8,16(sp)
    80003e6c:	1080                	addi	s0,sp,96
    80003e6e:	84aa                	mv	s1,a0
    80003e70:	8aae                	mv	s5,a1
    80003e72:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	fc4080e7          	jalr	-60(ra) # 80000e38 <myproc>
    80003e7c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	3ea080e7          	jalr	1002(ra) # 8000626a <acquire>
  while(i < n){
    80003e88:	0b405663          	blez	s4,80003f34 <pipewrite+0xde>
  int i = 0;
    80003e8c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e8e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e90:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e94:	21c48b93          	addi	s7,s1,540
    80003e98:	a089                	j	80003eda <pipewrite+0x84>
      release(&pi->lock);
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	482080e7          	jalr	1154(ra) # 8000631e <release>
      return -1;
    80003ea4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ea6:	854a                	mv	a0,s2
    80003ea8:	60e6                	ld	ra,88(sp)
    80003eaa:	6446                	ld	s0,80(sp)
    80003eac:	64a6                	ld	s1,72(sp)
    80003eae:	6906                	ld	s2,64(sp)
    80003eb0:	79e2                	ld	s3,56(sp)
    80003eb2:	7a42                	ld	s4,48(sp)
    80003eb4:	7aa2                	ld	s5,40(sp)
    80003eb6:	7b02                	ld	s6,32(sp)
    80003eb8:	6be2                	ld	s7,24(sp)
    80003eba:	6c42                	ld	s8,16(sp)
    80003ebc:	6125                	addi	sp,sp,96
    80003ebe:	8082                	ret
      wakeup(&pi->nread);
    80003ec0:	8562                	mv	a0,s8
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	682080e7          	jalr	1666(ra) # 80001544 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eca:	85a6                	mv	a1,s1
    80003ecc:	855e                	mv	a0,s7
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	612080e7          	jalr	1554(ra) # 800014e0 <sleep>
  while(i < n){
    80003ed6:	07495063          	bge	s2,s4,80003f36 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003eda:	2204a783          	lw	a5,544(s1)
    80003ede:	dfd5                	beqz	a5,80003e9a <pipewrite+0x44>
    80003ee0:	854e                	mv	a0,s3
    80003ee2:	ffffe097          	auipc	ra,0xffffe
    80003ee6:	8a6080e7          	jalr	-1882(ra) # 80001788 <killed>
    80003eea:	f945                	bnez	a0,80003e9a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eec:	2184a783          	lw	a5,536(s1)
    80003ef0:	21c4a703          	lw	a4,540(s1)
    80003ef4:	2007879b          	addiw	a5,a5,512
    80003ef8:	fcf704e3          	beq	a4,a5,80003ec0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003efc:	4685                	li	a3,1
    80003efe:	01590633          	add	a2,s2,s5
    80003f02:	faf40593          	addi	a1,s0,-81
    80003f06:	0509b503          	ld	a0,80(s3)
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	c76080e7          	jalr	-906(ra) # 80000b80 <copyin>
    80003f12:	03650263          	beq	a0,s6,80003f36 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f16:	21c4a783          	lw	a5,540(s1)
    80003f1a:	0017871b          	addiw	a4,a5,1
    80003f1e:	20e4ae23          	sw	a4,540(s1)
    80003f22:	1ff7f793          	andi	a5,a5,511
    80003f26:	97a6                	add	a5,a5,s1
    80003f28:	faf44703          	lbu	a4,-81(s0)
    80003f2c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f30:	2905                	addiw	s2,s2,1
    80003f32:	b755                	j	80003ed6 <pipewrite+0x80>
  int i = 0;
    80003f34:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f36:	21848513          	addi	a0,s1,536
    80003f3a:	ffffd097          	auipc	ra,0xffffd
    80003f3e:	60a080e7          	jalr	1546(ra) # 80001544 <wakeup>
  release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	3da080e7          	jalr	986(ra) # 8000631e <release>
  return i;
    80003f4c:	bfa9                	j	80003ea6 <pipewrite+0x50>

0000000080003f4e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f4e:	715d                	addi	sp,sp,-80
    80003f50:	e486                	sd	ra,72(sp)
    80003f52:	e0a2                	sd	s0,64(sp)
    80003f54:	fc26                	sd	s1,56(sp)
    80003f56:	f84a                	sd	s2,48(sp)
    80003f58:	f44e                	sd	s3,40(sp)
    80003f5a:	f052                	sd	s4,32(sp)
    80003f5c:	ec56                	sd	s5,24(sp)
    80003f5e:	e85a                	sd	s6,16(sp)
    80003f60:	0880                	addi	s0,sp,80
    80003f62:	84aa                	mv	s1,a0
    80003f64:	892e                	mv	s2,a1
    80003f66:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	ed0080e7          	jalr	-304(ra) # 80000e38 <myproc>
    80003f70:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	2f6080e7          	jalr	758(ra) # 8000626a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f7c:	2184a703          	lw	a4,536(s1)
    80003f80:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f84:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f88:	02f71763          	bne	a4,a5,80003fb6 <piperead+0x68>
    80003f8c:	2244a783          	lw	a5,548(s1)
    80003f90:	c39d                	beqz	a5,80003fb6 <piperead+0x68>
    if(killed(pr)){
    80003f92:	8552                	mv	a0,s4
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	7f4080e7          	jalr	2036(ra) # 80001788 <killed>
    80003f9c:	e941                	bnez	a0,8000402c <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f9e:	85a6                	mv	a1,s1
    80003fa0:	854e                	mv	a0,s3
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	53e080e7          	jalr	1342(ra) # 800014e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003faa:	2184a703          	lw	a4,536(s1)
    80003fae:	21c4a783          	lw	a5,540(s1)
    80003fb2:	fcf70de3          	beq	a4,a5,80003f8c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fb6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fb8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fba:	05505363          	blez	s5,80004000 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003fbe:	2184a783          	lw	a5,536(s1)
    80003fc2:	21c4a703          	lw	a4,540(s1)
    80003fc6:	02f70d63          	beq	a4,a5,80004000 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fca:	0017871b          	addiw	a4,a5,1
    80003fce:	20e4ac23          	sw	a4,536(s1)
    80003fd2:	1ff7f793          	andi	a5,a5,511
    80003fd6:	97a6                	add	a5,a5,s1
    80003fd8:	0187c783          	lbu	a5,24(a5)
    80003fdc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fe0:	4685                	li	a3,1
    80003fe2:	fbf40613          	addi	a2,s0,-65
    80003fe6:	85ca                	mv	a1,s2
    80003fe8:	050a3503          	ld	a0,80(s4)
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	b08080e7          	jalr	-1272(ra) # 80000af4 <copyout>
    80003ff4:	01650663          	beq	a0,s6,80004000 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ff8:	2985                	addiw	s3,s3,1
    80003ffa:	0905                	addi	s2,s2,1
    80003ffc:	fd3a91e3          	bne	s5,s3,80003fbe <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004000:	21c48513          	addi	a0,s1,540
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	540080e7          	jalr	1344(ra) # 80001544 <wakeup>
  release(&pi->lock);
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	310080e7          	jalr	784(ra) # 8000631e <release>
  return i;
}
    80004016:	854e                	mv	a0,s3
    80004018:	60a6                	ld	ra,72(sp)
    8000401a:	6406                	ld	s0,64(sp)
    8000401c:	74e2                	ld	s1,56(sp)
    8000401e:	7942                	ld	s2,48(sp)
    80004020:	79a2                	ld	s3,40(sp)
    80004022:	7a02                	ld	s4,32(sp)
    80004024:	6ae2                	ld	s5,24(sp)
    80004026:	6b42                	ld	s6,16(sp)
    80004028:	6161                	addi	sp,sp,80
    8000402a:	8082                	ret
      release(&pi->lock);
    8000402c:	8526                	mv	a0,s1
    8000402e:	00002097          	auipc	ra,0x2
    80004032:	2f0080e7          	jalr	752(ra) # 8000631e <release>
      return -1;
    80004036:	59fd                	li	s3,-1
    80004038:	bff9                	j	80004016 <piperead+0xc8>

000000008000403a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000403a:	1141                	addi	sp,sp,-16
    8000403c:	e422                	sd	s0,8(sp)
    8000403e:	0800                	addi	s0,sp,16
    80004040:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004042:	8905                	andi	a0,a0,1
    80004044:	c111                	beqz	a0,80004048 <flags2perm+0xe>
      perm = PTE_X;
    80004046:	4521                	li	a0,8
    if(flags & 0x2)
    80004048:	8b89                	andi	a5,a5,2
    8000404a:	c399                	beqz	a5,80004050 <flags2perm+0x16>
      perm |= PTE_W;
    8000404c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004050:	6422                	ld	s0,8(sp)
    80004052:	0141                	addi	sp,sp,16
    80004054:	8082                	ret

0000000080004056 <exec>:

int
exec(char *path, char **argv)
{
    80004056:	de010113          	addi	sp,sp,-544
    8000405a:	20113c23          	sd	ra,536(sp)
    8000405e:	20813823          	sd	s0,528(sp)
    80004062:	20913423          	sd	s1,520(sp)
    80004066:	21213023          	sd	s2,512(sp)
    8000406a:	ffce                	sd	s3,504(sp)
    8000406c:	fbd2                	sd	s4,496(sp)
    8000406e:	f7d6                	sd	s5,488(sp)
    80004070:	f3da                	sd	s6,480(sp)
    80004072:	efde                	sd	s7,472(sp)
    80004074:	ebe2                	sd	s8,464(sp)
    80004076:	e7e6                	sd	s9,456(sp)
    80004078:	e3ea                	sd	s10,448(sp)
    8000407a:	ff6e                	sd	s11,440(sp)
    8000407c:	1400                	addi	s0,sp,544
    8000407e:	892a                	mv	s2,a0
    80004080:	dea43423          	sd	a0,-536(s0)
    80004084:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	db0080e7          	jalr	-592(ra) # 80000e38 <myproc>
    80004090:	84aa                	mv	s1,a0

  begin_op();
    80004092:	fffff097          	auipc	ra,0xfffff
    80004096:	424080e7          	jalr	1060(ra) # 800034b6 <begin_op>

  if((ip = namei(path)) == 0){
    8000409a:	854a                	mv	a0,s2
    8000409c:	fffff097          	auipc	ra,0xfffff
    800040a0:	1fa080e7          	jalr	506(ra) # 80003296 <namei>
    800040a4:	c93d                	beqz	a0,8000411a <exec+0xc4>
    800040a6:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	a48080e7          	jalr	-1464(ra) # 80002af0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040b0:	04000713          	li	a4,64
    800040b4:	4681                	li	a3,0
    800040b6:	e5040613          	addi	a2,s0,-432
    800040ba:	4581                	li	a1,0
    800040bc:	8556                	mv	a0,s5
    800040be:	fffff097          	auipc	ra,0xfffff
    800040c2:	ce6080e7          	jalr	-794(ra) # 80002da4 <readi>
    800040c6:	04000793          	li	a5,64
    800040ca:	00f51a63          	bne	a0,a5,800040de <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040ce:	e5042703          	lw	a4,-432(s0)
    800040d2:	464c47b7          	lui	a5,0x464c4
    800040d6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040da:	04f70663          	beq	a4,a5,80004126 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040de:	8556                	mv	a0,s5
    800040e0:	fffff097          	auipc	ra,0xfffff
    800040e4:	c72080e7          	jalr	-910(ra) # 80002d52 <iunlockput>
    end_op();
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	44e080e7          	jalr	1102(ra) # 80003536 <end_op>
  }
  return -1;
    800040f0:	557d                	li	a0,-1
}
    800040f2:	21813083          	ld	ra,536(sp)
    800040f6:	21013403          	ld	s0,528(sp)
    800040fa:	20813483          	ld	s1,520(sp)
    800040fe:	20013903          	ld	s2,512(sp)
    80004102:	79fe                	ld	s3,504(sp)
    80004104:	7a5e                	ld	s4,496(sp)
    80004106:	7abe                	ld	s5,488(sp)
    80004108:	7b1e                	ld	s6,480(sp)
    8000410a:	6bfe                	ld	s7,472(sp)
    8000410c:	6c5e                	ld	s8,464(sp)
    8000410e:	6cbe                	ld	s9,456(sp)
    80004110:	6d1e                	ld	s10,448(sp)
    80004112:	7dfa                	ld	s11,440(sp)
    80004114:	22010113          	addi	sp,sp,544
    80004118:	8082                	ret
    end_op();
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	41c080e7          	jalr	1052(ra) # 80003536 <end_op>
    return -1;
    80004122:	557d                	li	a0,-1
    80004124:	b7f9                	j	800040f2 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004126:	8526                	mv	a0,s1
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	dd4080e7          	jalr	-556(ra) # 80000efc <proc_pagetable>
    80004130:	8b2a                	mv	s6,a0
    80004132:	d555                	beqz	a0,800040de <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004134:	e7042783          	lw	a5,-400(s0)
    80004138:	e8845703          	lhu	a4,-376(s0)
    8000413c:	c735                	beqz	a4,800041a8 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000413e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004140:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004144:	6a05                	lui	s4,0x1
    80004146:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000414a:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000414e:	6d85                	lui	s11,0x1
    80004150:	7d7d                	lui	s10,0xfffff
    80004152:	a481                	j	80004392 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004154:	00004517          	auipc	a0,0x4
    80004158:	50450513          	addi	a0,a0,1284 # 80008658 <syscalls+0x298>
    8000415c:	00002097          	auipc	ra,0x2
    80004160:	bd2080e7          	jalr	-1070(ra) # 80005d2e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004164:	874a                	mv	a4,s2
    80004166:	009c86bb          	addw	a3,s9,s1
    8000416a:	4581                	li	a1,0
    8000416c:	8556                	mv	a0,s5
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	c36080e7          	jalr	-970(ra) # 80002da4 <readi>
    80004176:	2501                	sext.w	a0,a0
    80004178:	1aa91a63          	bne	s2,a0,8000432c <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000417c:	009d84bb          	addw	s1,s11,s1
    80004180:	013d09bb          	addw	s3,s10,s3
    80004184:	1f74f763          	bgeu	s1,s7,80004372 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004188:	02049593          	slli	a1,s1,0x20
    8000418c:	9181                	srli	a1,a1,0x20
    8000418e:	95e2                	add	a1,a1,s8
    80004190:	855a                	mv	a0,s6
    80004192:	ffffc097          	auipc	ra,0xffffc
    80004196:	370080e7          	jalr	880(ra) # 80000502 <walkaddr>
    8000419a:	862a                	mv	a2,a0
    if(pa == 0)
    8000419c:	dd45                	beqz	a0,80004154 <exec+0xfe>
      n = PGSIZE;
    8000419e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800041a0:	fd49f2e3          	bgeu	s3,s4,80004164 <exec+0x10e>
      n = sz - i;
    800041a4:	894e                	mv	s2,s3
    800041a6:	bf7d                	j	80004164 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a8:	4901                	li	s2,0
  iunlockput(ip);
    800041aa:	8556                	mv	a0,s5
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	ba6080e7          	jalr	-1114(ra) # 80002d52 <iunlockput>
  end_op();
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	382080e7          	jalr	898(ra) # 80003536 <end_op>
  p = myproc();
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	c7c080e7          	jalr	-900(ra) # 80000e38 <myproc>
    800041c4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041c6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041ca:	6785                	lui	a5,0x1
    800041cc:	17fd                	addi	a5,a5,-1
    800041ce:	993e                	add	s2,s2,a5
    800041d0:	77fd                	lui	a5,0xfffff
    800041d2:	00f977b3          	and	a5,s2,a5
    800041d6:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041da:	4691                	li	a3,4
    800041dc:	6609                	lui	a2,0x2
    800041de:	963e                	add	a2,a2,a5
    800041e0:	85be                	mv	a1,a5
    800041e2:	855a                	mv	a0,s6
    800041e4:	ffffc097          	auipc	ra,0xffffc
    800041e8:	6c4080e7          	jalr	1732(ra) # 800008a8 <uvmalloc>
    800041ec:	8c2a                	mv	s8,a0
  ip = 0;
    800041ee:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041f0:	12050e63          	beqz	a0,8000432c <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041f4:	75f9                	lui	a1,0xffffe
    800041f6:	95aa                	add	a1,a1,a0
    800041f8:	855a                	mv	a0,s6
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	8c8080e7          	jalr	-1848(ra) # 80000ac2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004202:	7afd                	lui	s5,0xfffff
    80004204:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004206:	df043783          	ld	a5,-528(s0)
    8000420a:	6388                	ld	a0,0(a5)
    8000420c:	c925                	beqz	a0,8000427c <exec+0x226>
    8000420e:	e9040993          	addi	s3,s0,-368
    80004212:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004216:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004218:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000421a:	ffffc097          	auipc	ra,0xffffc
    8000421e:	0da080e7          	jalr	218(ra) # 800002f4 <strlen>
    80004222:	0015079b          	addiw	a5,a0,1
    80004226:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000422a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000422e:	13596663          	bltu	s2,s5,8000435a <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004232:	df043d83          	ld	s11,-528(s0)
    80004236:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000423a:	8552                	mv	a0,s4
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	0b8080e7          	jalr	184(ra) # 800002f4 <strlen>
    80004244:	0015069b          	addiw	a3,a0,1
    80004248:	8652                	mv	a2,s4
    8000424a:	85ca                	mv	a1,s2
    8000424c:	855a                	mv	a0,s6
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	8a6080e7          	jalr	-1882(ra) # 80000af4 <copyout>
    80004256:	10054663          	bltz	a0,80004362 <exec+0x30c>
    ustack[argc] = sp;
    8000425a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000425e:	0485                	addi	s1,s1,1
    80004260:	008d8793          	addi	a5,s11,8
    80004264:	def43823          	sd	a5,-528(s0)
    80004268:	008db503          	ld	a0,8(s11)
    8000426c:	c911                	beqz	a0,80004280 <exec+0x22a>
    if(argc >= MAXARG)
    8000426e:	09a1                	addi	s3,s3,8
    80004270:	fb3c95e3          	bne	s9,s3,8000421a <exec+0x1c4>
  sz = sz1;
    80004274:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004278:	4a81                	li	s5,0
    8000427a:	a84d                	j	8000432c <exec+0x2d6>
  sp = sz;
    8000427c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000427e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004280:	00349793          	slli	a5,s1,0x3
    80004284:	f9040713          	addi	a4,s0,-112
    80004288:	97ba                	add	a5,a5,a4
    8000428a:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd31c0>
  sp -= (argc+1) * sizeof(uint64);
    8000428e:	00148693          	addi	a3,s1,1
    80004292:	068e                	slli	a3,a3,0x3
    80004294:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004298:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000429c:	01597663          	bgeu	s2,s5,800042a8 <exec+0x252>
  sz = sz1;
    800042a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042a4:	4a81                	li	s5,0
    800042a6:	a059                	j	8000432c <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042a8:	e9040613          	addi	a2,s0,-368
    800042ac:	85ca                	mv	a1,s2
    800042ae:	855a                	mv	a0,s6
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	844080e7          	jalr	-1980(ra) # 80000af4 <copyout>
    800042b8:	0a054963          	bltz	a0,8000436a <exec+0x314>
  p->trapframe->a1 = sp;
    800042bc:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800042c0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042c4:	de843783          	ld	a5,-536(s0)
    800042c8:	0007c703          	lbu	a4,0(a5)
    800042cc:	cf11                	beqz	a4,800042e8 <exec+0x292>
    800042ce:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042d0:	02f00693          	li	a3,47
    800042d4:	a039                	j	800042e2 <exec+0x28c>
      last = s+1;
    800042d6:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800042da:	0785                	addi	a5,a5,1
    800042dc:	fff7c703          	lbu	a4,-1(a5)
    800042e0:	c701                	beqz	a4,800042e8 <exec+0x292>
    if(*s == '/')
    800042e2:	fed71ce3          	bne	a4,a3,800042da <exec+0x284>
    800042e6:	bfc5                	j	800042d6 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800042e8:	4641                	li	a2,16
    800042ea:	de843583          	ld	a1,-536(s0)
    800042ee:	158b8513          	addi	a0,s7,344
    800042f2:	ffffc097          	auipc	ra,0xffffc
    800042f6:	fd0080e7          	jalr	-48(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800042fa:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042fe:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004302:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004306:	058bb783          	ld	a5,88(s7)
    8000430a:	e6843703          	ld	a4,-408(s0)
    8000430e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004310:	058bb783          	ld	a5,88(s7)
    80004314:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004318:	85ea                	mv	a1,s10
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	c7e080e7          	jalr	-898(ra) # 80000f98 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004322:	0004851b          	sext.w	a0,s1
    80004326:	b3f1                	j	800040f2 <exec+0x9c>
    80004328:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000432c:	df843583          	ld	a1,-520(s0)
    80004330:	855a                	mv	a0,s6
    80004332:	ffffd097          	auipc	ra,0xffffd
    80004336:	c66080e7          	jalr	-922(ra) # 80000f98 <proc_freepagetable>
  if(ip){
    8000433a:	da0a92e3          	bnez	s5,800040de <exec+0x88>
  return -1;
    8000433e:	557d                	li	a0,-1
    80004340:	bb4d                	j	800040f2 <exec+0x9c>
    80004342:	df243c23          	sd	s2,-520(s0)
    80004346:	b7dd                	j	8000432c <exec+0x2d6>
    80004348:	df243c23          	sd	s2,-520(s0)
    8000434c:	b7c5                	j	8000432c <exec+0x2d6>
    8000434e:	df243c23          	sd	s2,-520(s0)
    80004352:	bfe9                	j	8000432c <exec+0x2d6>
    80004354:	df243c23          	sd	s2,-520(s0)
    80004358:	bfd1                	j	8000432c <exec+0x2d6>
  sz = sz1;
    8000435a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000435e:	4a81                	li	s5,0
    80004360:	b7f1                	j	8000432c <exec+0x2d6>
  sz = sz1;
    80004362:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004366:	4a81                	li	s5,0
    80004368:	b7d1                	j	8000432c <exec+0x2d6>
  sz = sz1;
    8000436a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000436e:	4a81                	li	s5,0
    80004370:	bf75                	j	8000432c <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004372:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004376:	e0843783          	ld	a5,-504(s0)
    8000437a:	0017869b          	addiw	a3,a5,1
    8000437e:	e0d43423          	sd	a3,-504(s0)
    80004382:	e0043783          	ld	a5,-512(s0)
    80004386:	0387879b          	addiw	a5,a5,56
    8000438a:	e8845703          	lhu	a4,-376(s0)
    8000438e:	e0e6dee3          	bge	a3,a4,800041aa <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004392:	2781                	sext.w	a5,a5
    80004394:	e0f43023          	sd	a5,-512(s0)
    80004398:	03800713          	li	a4,56
    8000439c:	86be                	mv	a3,a5
    8000439e:	e1840613          	addi	a2,s0,-488
    800043a2:	4581                	li	a1,0
    800043a4:	8556                	mv	a0,s5
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	9fe080e7          	jalr	-1538(ra) # 80002da4 <readi>
    800043ae:	03800793          	li	a5,56
    800043b2:	f6f51be3          	bne	a0,a5,80004328 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800043b6:	e1842783          	lw	a5,-488(s0)
    800043ba:	4705                	li	a4,1
    800043bc:	fae79de3          	bne	a5,a4,80004376 <exec+0x320>
    if(ph.memsz < ph.filesz)
    800043c0:	e4043483          	ld	s1,-448(s0)
    800043c4:	e3843783          	ld	a5,-456(s0)
    800043c8:	f6f4ede3          	bltu	s1,a5,80004342 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043cc:	e2843783          	ld	a5,-472(s0)
    800043d0:	94be                	add	s1,s1,a5
    800043d2:	f6f4ebe3          	bltu	s1,a5,80004348 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800043d6:	de043703          	ld	a4,-544(s0)
    800043da:	8ff9                	and	a5,a5,a4
    800043dc:	fbad                	bnez	a5,8000434e <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043de:	e1c42503          	lw	a0,-484(s0)
    800043e2:	00000097          	auipc	ra,0x0
    800043e6:	c58080e7          	jalr	-936(ra) # 8000403a <flags2perm>
    800043ea:	86aa                	mv	a3,a0
    800043ec:	8626                	mv	a2,s1
    800043ee:	85ca                	mv	a1,s2
    800043f0:	855a                	mv	a0,s6
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	4b6080e7          	jalr	1206(ra) # 800008a8 <uvmalloc>
    800043fa:	dea43c23          	sd	a0,-520(s0)
    800043fe:	d939                	beqz	a0,80004354 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004400:	e2843c03          	ld	s8,-472(s0)
    80004404:	e2042c83          	lw	s9,-480(s0)
    80004408:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000440c:	f60b83e3          	beqz	s7,80004372 <exec+0x31c>
    80004410:	89de                	mv	s3,s7
    80004412:	4481                	li	s1,0
    80004414:	bb95                	j	80004188 <exec+0x132>

0000000080004416 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004416:	7179                	addi	sp,sp,-48
    80004418:	f406                	sd	ra,40(sp)
    8000441a:	f022                	sd	s0,32(sp)
    8000441c:	ec26                	sd	s1,24(sp)
    8000441e:	e84a                	sd	s2,16(sp)
    80004420:	1800                	addi	s0,sp,48
    80004422:	892e                	mv	s2,a1
    80004424:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004426:	fdc40593          	addi	a1,s0,-36
    8000442a:	ffffe097          	auipc	ra,0xffffe
    8000442e:	b4a080e7          	jalr	-1206(ra) # 80001f74 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004432:	fdc42703          	lw	a4,-36(s0)
    80004436:	47bd                	li	a5,15
    80004438:	02e7eb63          	bltu	a5,a4,8000446e <argfd+0x58>
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	9fc080e7          	jalr	-1540(ra) # 80000e38 <myproc>
    80004444:	fdc42703          	lw	a4,-36(s0)
    80004448:	01a70793          	addi	a5,a4,26
    8000444c:	078e                	slli	a5,a5,0x3
    8000444e:	953e                	add	a0,a0,a5
    80004450:	611c                	ld	a5,0(a0)
    80004452:	c385                	beqz	a5,80004472 <argfd+0x5c>
    return -1;
  if (pfd)
    80004454:	00090463          	beqz	s2,8000445c <argfd+0x46>
    *pfd = fd;
    80004458:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    8000445c:	4501                	li	a0,0
  if (pf)
    8000445e:	c091                	beqz	s1,80004462 <argfd+0x4c>
    *pf = f;
    80004460:	e09c                	sd	a5,0(s1)
}
    80004462:	70a2                	ld	ra,40(sp)
    80004464:	7402                	ld	s0,32(sp)
    80004466:	64e2                	ld	s1,24(sp)
    80004468:	6942                	ld	s2,16(sp)
    8000446a:	6145                	addi	sp,sp,48
    8000446c:	8082                	ret
    return -1;
    8000446e:	557d                	li	a0,-1
    80004470:	bfcd                	j	80004462 <argfd+0x4c>
    80004472:	557d                	li	a0,-1
    80004474:	b7fd                	j	80004462 <argfd+0x4c>

0000000080004476 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004476:	1101                	addi	sp,sp,-32
    80004478:	ec06                	sd	ra,24(sp)
    8000447a:	e822                	sd	s0,16(sp)
    8000447c:	e426                	sd	s1,8(sp)
    8000447e:	1000                	addi	s0,sp,32
    80004480:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	9b6080e7          	jalr	-1610(ra) # 80000e38 <myproc>
    8000448a:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    8000448c:	0d050793          	addi	a5,a0,208
    80004490:	4501                	li	a0,0
    80004492:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80004494:	6398                	ld	a4,0(a5)
    80004496:	cb19                	beqz	a4,800044ac <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    80004498:	2505                	addiw	a0,a0,1
    8000449a:	07a1                	addi	a5,a5,8
    8000449c:	fed51ce3          	bne	a0,a3,80004494 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044a0:	557d                	li	a0,-1
}
    800044a2:	60e2                	ld	ra,24(sp)
    800044a4:	6442                	ld	s0,16(sp)
    800044a6:	64a2                	ld	s1,8(sp)
    800044a8:	6105                	addi	sp,sp,32
    800044aa:	8082                	ret
      p->ofile[fd] = f;
    800044ac:	01a50793          	addi	a5,a0,26
    800044b0:	078e                	slli	a5,a5,0x3
    800044b2:	963e                	add	a2,a2,a5
    800044b4:	e204                	sd	s1,0(a2)
      return fd;
    800044b6:	b7f5                	j	800044a2 <fdalloc+0x2c>

00000000800044b8 <create>:
  return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800044b8:	715d                	addi	sp,sp,-80
    800044ba:	e486                	sd	ra,72(sp)
    800044bc:	e0a2                	sd	s0,64(sp)
    800044be:	fc26                	sd	s1,56(sp)
    800044c0:	f84a                	sd	s2,48(sp)
    800044c2:	f44e                	sd	s3,40(sp)
    800044c4:	f052                	sd	s4,32(sp)
    800044c6:	ec56                	sd	s5,24(sp)
    800044c8:	e85a                	sd	s6,16(sp)
    800044ca:	0880                	addi	s0,sp,80
    800044cc:	8b2e                	mv	s6,a1
    800044ce:	89b2                	mv	s3,a2
    800044d0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800044d2:	fb040593          	addi	a1,s0,-80
    800044d6:	fffff097          	auipc	ra,0xfffff
    800044da:	dde080e7          	jalr	-546(ra) # 800032b4 <nameiparent>
    800044de:	84aa                	mv	s1,a0
    800044e0:	14050f63          	beqz	a0,8000463e <create+0x186>
    return 0;

  ilock(dp);
    800044e4:	ffffe097          	auipc	ra,0xffffe
    800044e8:	60c080e7          	jalr	1548(ra) # 80002af0 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    800044ec:	4601                	li	a2,0
    800044ee:	fb040593          	addi	a1,s0,-80
    800044f2:	8526                	mv	a0,s1
    800044f4:	fffff097          	auipc	ra,0xfffff
    800044f8:	ae0080e7          	jalr	-1312(ra) # 80002fd4 <dirlookup>
    800044fc:	8aaa                	mv	s5,a0
    800044fe:	c931                	beqz	a0,80004552 <create+0x9a>
  {
    iunlockput(dp);
    80004500:	8526                	mv	a0,s1
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	850080e7          	jalr	-1968(ra) # 80002d52 <iunlockput>
    ilock(ip);
    8000450a:	8556                	mv	a0,s5
    8000450c:	ffffe097          	auipc	ra,0xffffe
    80004510:	5e4080e7          	jalr	1508(ra) # 80002af0 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004514:	000b059b          	sext.w	a1,s6
    80004518:	4789                	li	a5,2
    8000451a:	02f59563          	bne	a1,a5,80004544 <create+0x8c>
    8000451e:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd3304>
    80004522:	37f9                	addiw	a5,a5,-2
    80004524:	17c2                	slli	a5,a5,0x30
    80004526:	93c1                	srli	a5,a5,0x30
    80004528:	4705                	li	a4,1
    8000452a:	00f76d63          	bltu	a4,a5,80004544 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000452e:	8556                	mv	a0,s5
    80004530:	60a6                	ld	ra,72(sp)
    80004532:	6406                	ld	s0,64(sp)
    80004534:	74e2                	ld	s1,56(sp)
    80004536:	7942                	ld	s2,48(sp)
    80004538:	79a2                	ld	s3,40(sp)
    8000453a:	7a02                	ld	s4,32(sp)
    8000453c:	6ae2                	ld	s5,24(sp)
    8000453e:	6b42                	ld	s6,16(sp)
    80004540:	6161                	addi	sp,sp,80
    80004542:	8082                	ret
    iunlockput(ip);
    80004544:	8556                	mv	a0,s5
    80004546:	fffff097          	auipc	ra,0xfffff
    8000454a:	80c080e7          	jalr	-2036(ra) # 80002d52 <iunlockput>
    return 0;
    8000454e:	4a81                	li	s5,0
    80004550:	bff9                	j	8000452e <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80004552:	85da                	mv	a1,s6
    80004554:	4088                	lw	a0,0(s1)
    80004556:	ffffe097          	auipc	ra,0xffffe
    8000455a:	3fe080e7          	jalr	1022(ra) # 80002954 <ialloc>
    8000455e:	8a2a                	mv	s4,a0
    80004560:	c539                	beqz	a0,800045ae <create+0xf6>
  ilock(ip);
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	58e080e7          	jalr	1422(ra) # 80002af0 <ilock>
  ip->major = major;
    8000456a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000456e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004572:	4905                	li	s2,1
    80004574:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004578:	8552                	mv	a0,s4
    8000457a:	ffffe097          	auipc	ra,0xffffe
    8000457e:	4ac080e7          	jalr	1196(ra) # 80002a26 <iupdate>
  if (type == T_DIR)
    80004582:	000b059b          	sext.w	a1,s6
    80004586:	03258b63          	beq	a1,s2,800045bc <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    8000458a:	004a2603          	lw	a2,4(s4)
    8000458e:	fb040593          	addi	a1,s0,-80
    80004592:	8526                	mv	a0,s1
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	c50080e7          	jalr	-944(ra) # 800031e4 <dirlink>
    8000459c:	06054f63          	bltz	a0,8000461a <create+0x162>
  iunlockput(dp);
    800045a0:	8526                	mv	a0,s1
    800045a2:	ffffe097          	auipc	ra,0xffffe
    800045a6:	7b0080e7          	jalr	1968(ra) # 80002d52 <iunlockput>
  return ip;
    800045aa:	8ad2                	mv	s5,s4
    800045ac:	b749                	j	8000452e <create+0x76>
    iunlockput(dp);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	7a2080e7          	jalr	1954(ra) # 80002d52 <iunlockput>
    return 0;
    800045b8:	8ad2                	mv	s5,s4
    800045ba:	bf95                	j	8000452e <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045bc:	004a2603          	lw	a2,4(s4)
    800045c0:	00004597          	auipc	a1,0x4
    800045c4:	0b858593          	addi	a1,a1,184 # 80008678 <syscalls+0x2b8>
    800045c8:	8552                	mv	a0,s4
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	c1a080e7          	jalr	-998(ra) # 800031e4 <dirlink>
    800045d2:	04054463          	bltz	a0,8000461a <create+0x162>
    800045d6:	40d0                	lw	a2,4(s1)
    800045d8:	00004597          	auipc	a1,0x4
    800045dc:	0a858593          	addi	a1,a1,168 # 80008680 <syscalls+0x2c0>
    800045e0:	8552                	mv	a0,s4
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	c02080e7          	jalr	-1022(ra) # 800031e4 <dirlink>
    800045ea:	02054863          	bltz	a0,8000461a <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    800045ee:	004a2603          	lw	a2,4(s4)
    800045f2:	fb040593          	addi	a1,s0,-80
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	bec080e7          	jalr	-1044(ra) # 800031e4 <dirlink>
    80004600:	00054d63          	bltz	a0,8000461a <create+0x162>
    dp->nlink++; // for ".."
    80004604:	04a4d783          	lhu	a5,74(s1)
    80004608:	2785                	addiw	a5,a5,1
    8000460a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000460e:	8526                	mv	a0,s1
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	416080e7          	jalr	1046(ra) # 80002a26 <iupdate>
    80004618:	b761                	j	800045a0 <create+0xe8>
  ip->nlink = 0;
    8000461a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000461e:	8552                	mv	a0,s4
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	406080e7          	jalr	1030(ra) # 80002a26 <iupdate>
  iunlockput(ip);
    80004628:	8552                	mv	a0,s4
    8000462a:	ffffe097          	auipc	ra,0xffffe
    8000462e:	728080e7          	jalr	1832(ra) # 80002d52 <iunlockput>
  iunlockput(dp);
    80004632:	8526                	mv	a0,s1
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	71e080e7          	jalr	1822(ra) # 80002d52 <iunlockput>
  return 0;
    8000463c:	bdcd                	j	8000452e <create+0x76>
    return 0;
    8000463e:	8aaa                	mv	s5,a0
    80004640:	b5fd                	j	8000452e <create+0x76>

0000000080004642 <sys_dup>:
{
    80004642:	7179                	addi	sp,sp,-48
    80004644:	f406                	sd	ra,40(sp)
    80004646:	f022                	sd	s0,32(sp)
    80004648:	ec26                	sd	s1,24(sp)
    8000464a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000464c:	fd840613          	addi	a2,s0,-40
    80004650:	4581                	li	a1,0
    80004652:	4501                	li	a0,0
    80004654:	00000097          	auipc	ra,0x0
    80004658:	dc2080e7          	jalr	-574(ra) # 80004416 <argfd>
    return -1;
    8000465c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    8000465e:	02054363          	bltz	a0,80004684 <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80004662:	fd843503          	ld	a0,-40(s0)
    80004666:	00000097          	auipc	ra,0x0
    8000466a:	e10080e7          	jalr	-496(ra) # 80004476 <fdalloc>
    8000466e:	84aa                	mv	s1,a0
    return -1;
    80004670:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004672:	00054963          	bltz	a0,80004684 <sys_dup+0x42>
  filedup(f);
    80004676:	fd843503          	ld	a0,-40(s0)
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	2b6080e7          	jalr	694(ra) # 80003930 <filedup>
  return fd;
    80004682:	87a6                	mv	a5,s1
}
    80004684:	853e                	mv	a0,a5
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	64e2                	ld	s1,24(sp)
    8000468c:	6145                	addi	sp,sp,48
    8000468e:	8082                	ret

0000000080004690 <sys_read>:
{
    80004690:	7179                	addi	sp,sp,-48
    80004692:	f406                	sd	ra,40(sp)
    80004694:	f022                	sd	s0,32(sp)
    80004696:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004698:	fd840593          	addi	a1,s0,-40
    8000469c:	4505                	li	a0,1
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	8f6080e7          	jalr	-1802(ra) # 80001f94 <argaddr>
  argint(2, &n);
    800046a6:	fe440593          	addi	a1,s0,-28
    800046aa:	4509                	li	a0,2
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	8c8080e7          	jalr	-1848(ra) # 80001f74 <argint>
  if (argfd(0, 0, &f) < 0)
    800046b4:	fe840613          	addi	a2,s0,-24
    800046b8:	4581                	li	a1,0
    800046ba:	4501                	li	a0,0
    800046bc:	00000097          	auipc	ra,0x0
    800046c0:	d5a080e7          	jalr	-678(ra) # 80004416 <argfd>
    800046c4:	87aa                	mv	a5,a0
    return -1;
    800046c6:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800046c8:	0007cc63          	bltz	a5,800046e0 <sys_read+0x50>
  return fileread(f, p, n);
    800046cc:	fe442603          	lw	a2,-28(s0)
    800046d0:	fd843583          	ld	a1,-40(s0)
    800046d4:	fe843503          	ld	a0,-24(s0)
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	43e080e7          	jalr	1086(ra) # 80003b16 <fileread>
}
    800046e0:	70a2                	ld	ra,40(sp)
    800046e2:	7402                	ld	s0,32(sp)
    800046e4:	6145                	addi	sp,sp,48
    800046e6:	8082                	ret

00000000800046e8 <sys_write>:
{
    800046e8:	7179                	addi	sp,sp,-48
    800046ea:	f406                	sd	ra,40(sp)
    800046ec:	f022                	sd	s0,32(sp)
    800046ee:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046f0:	fd840593          	addi	a1,s0,-40
    800046f4:	4505                	li	a0,1
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	89e080e7          	jalr	-1890(ra) # 80001f94 <argaddr>
  argint(2, &n);
    800046fe:	fe440593          	addi	a1,s0,-28
    80004702:	4509                	li	a0,2
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	870080e7          	jalr	-1936(ra) # 80001f74 <argint>
  if (argfd(0, 0, &f) < 0)
    8000470c:	fe840613          	addi	a2,s0,-24
    80004710:	4581                	li	a1,0
    80004712:	4501                	li	a0,0
    80004714:	00000097          	auipc	ra,0x0
    80004718:	d02080e7          	jalr	-766(ra) # 80004416 <argfd>
    8000471c:	87aa                	mv	a5,a0
    return -1;
    8000471e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004720:	0007cc63          	bltz	a5,80004738 <sys_write+0x50>
  return filewrite(f, p, n);
    80004724:	fe442603          	lw	a2,-28(s0)
    80004728:	fd843583          	ld	a1,-40(s0)
    8000472c:	fe843503          	ld	a0,-24(s0)
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	4a8080e7          	jalr	1192(ra) # 80003bd8 <filewrite>
}
    80004738:	70a2                	ld	ra,40(sp)
    8000473a:	7402                	ld	s0,32(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret

0000000080004740 <sys_close>:
{
    80004740:	1101                	addi	sp,sp,-32
    80004742:	ec06                	sd	ra,24(sp)
    80004744:	e822                	sd	s0,16(sp)
    80004746:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004748:	fe040613          	addi	a2,s0,-32
    8000474c:	fec40593          	addi	a1,s0,-20
    80004750:	4501                	li	a0,0
    80004752:	00000097          	auipc	ra,0x0
    80004756:	cc4080e7          	jalr	-828(ra) # 80004416 <argfd>
    return -1;
    8000475a:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000475c:	02054463          	bltz	a0,80004784 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	6d8080e7          	jalr	1752(ra) # 80000e38 <myproc>
    80004768:	fec42783          	lw	a5,-20(s0)
    8000476c:	07e9                	addi	a5,a5,26
    8000476e:	078e                	slli	a5,a5,0x3
    80004770:	97aa                	add	a5,a5,a0
    80004772:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004776:	fe043503          	ld	a0,-32(s0)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	208080e7          	jalr	520(ra) # 80003982 <fileclose>
  return 0;
    80004782:	4781                	li	a5,0
}
    80004784:	853e                	mv	a0,a5
    80004786:	60e2                	ld	ra,24(sp)
    80004788:	6442                	ld	s0,16(sp)
    8000478a:	6105                	addi	sp,sp,32
    8000478c:	8082                	ret

000000008000478e <sys_fstat>:
{
    8000478e:	1101                	addi	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004796:	fe040593          	addi	a1,s0,-32
    8000479a:	4505                	li	a0,1
    8000479c:	ffffd097          	auipc	ra,0xffffd
    800047a0:	7f8080e7          	jalr	2040(ra) # 80001f94 <argaddr>
  if (argfd(0, 0, &f) < 0)
    800047a4:	fe840613          	addi	a2,s0,-24
    800047a8:	4581                	li	a1,0
    800047aa:	4501                	li	a0,0
    800047ac:	00000097          	auipc	ra,0x0
    800047b0:	c6a080e7          	jalr	-918(ra) # 80004416 <argfd>
    800047b4:	87aa                	mv	a5,a0
    return -1;
    800047b6:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800047b8:	0007ca63          	bltz	a5,800047cc <sys_fstat+0x3e>
  return filestat(f, st);
    800047bc:	fe043583          	ld	a1,-32(s0)
    800047c0:	fe843503          	ld	a0,-24(s0)
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	286080e7          	jalr	646(ra) # 80003a4a <filestat>
}
    800047cc:	60e2                	ld	ra,24(sp)
    800047ce:	6442                	ld	s0,16(sp)
    800047d0:	6105                	addi	sp,sp,32
    800047d2:	8082                	ret

00000000800047d4 <sys_link>:
{
    800047d4:	7169                	addi	sp,sp,-304
    800047d6:	f606                	sd	ra,296(sp)
    800047d8:	f222                	sd	s0,288(sp)
    800047da:	ee26                	sd	s1,280(sp)
    800047dc:	ea4a                	sd	s2,272(sp)
    800047de:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e0:	08000613          	li	a2,128
    800047e4:	ed040593          	addi	a1,s0,-304
    800047e8:	4501                	li	a0,0
    800047ea:	ffffd097          	auipc	ra,0xffffd
    800047ee:	7ca080e7          	jalr	1994(ra) # 80001fb4 <argstr>
    return -1;
    800047f2:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f4:	10054e63          	bltz	a0,80004910 <sys_link+0x13c>
    800047f8:	08000613          	li	a2,128
    800047fc:	f5040593          	addi	a1,s0,-176
    80004800:	4505                	li	a0,1
    80004802:	ffffd097          	auipc	ra,0xffffd
    80004806:	7b2080e7          	jalr	1970(ra) # 80001fb4 <argstr>
    return -1;
    8000480a:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000480c:	10054263          	bltz	a0,80004910 <sys_link+0x13c>
  begin_op();
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	ca6080e7          	jalr	-858(ra) # 800034b6 <begin_op>
  if ((ip = namei(old)) == 0)
    80004818:	ed040513          	addi	a0,s0,-304
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	a7a080e7          	jalr	-1414(ra) # 80003296 <namei>
    80004824:	84aa                	mv	s1,a0
    80004826:	c551                	beqz	a0,800048b2 <sys_link+0xde>
  ilock(ip);
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	2c8080e7          	jalr	712(ra) # 80002af0 <ilock>
  if (ip->type == T_DIR)
    80004830:	04449703          	lh	a4,68(s1)
    80004834:	4785                	li	a5,1
    80004836:	08f70463          	beq	a4,a5,800048be <sys_link+0xea>
  ip->nlink++;
    8000483a:	04a4d783          	lhu	a5,74(s1)
    8000483e:	2785                	addiw	a5,a5,1
    80004840:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004844:	8526                	mv	a0,s1
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	1e0080e7          	jalr	480(ra) # 80002a26 <iupdate>
  iunlock(ip);
    8000484e:	8526                	mv	a0,s1
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	362080e7          	jalr	866(ra) # 80002bb2 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004858:	fd040593          	addi	a1,s0,-48
    8000485c:	f5040513          	addi	a0,s0,-176
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	a54080e7          	jalr	-1452(ra) # 800032b4 <nameiparent>
    80004868:	892a                	mv	s2,a0
    8000486a:	c935                	beqz	a0,800048de <sys_link+0x10a>
  ilock(dp);
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	284080e7          	jalr	644(ra) # 80002af0 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004874:	00092703          	lw	a4,0(s2)
    80004878:	409c                	lw	a5,0(s1)
    8000487a:	04f71d63          	bne	a4,a5,800048d4 <sys_link+0x100>
    8000487e:	40d0                	lw	a2,4(s1)
    80004880:	fd040593          	addi	a1,s0,-48
    80004884:	854a                	mv	a0,s2
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	95e080e7          	jalr	-1698(ra) # 800031e4 <dirlink>
    8000488e:	04054363          	bltz	a0,800048d4 <sys_link+0x100>
  iunlockput(dp);
    80004892:	854a                	mv	a0,s2
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	4be080e7          	jalr	1214(ra) # 80002d52 <iunlockput>
  iput(ip);
    8000489c:	8526                	mv	a0,s1
    8000489e:	ffffe097          	auipc	ra,0xffffe
    800048a2:	40c080e7          	jalr	1036(ra) # 80002caa <iput>
  end_op();
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	c90080e7          	jalr	-880(ra) # 80003536 <end_op>
  return 0;
    800048ae:	4781                	li	a5,0
    800048b0:	a085                	j	80004910 <sys_link+0x13c>
    end_op();
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	c84080e7          	jalr	-892(ra) # 80003536 <end_op>
    return -1;
    800048ba:	57fd                	li	a5,-1
    800048bc:	a891                	j	80004910 <sys_link+0x13c>
    iunlockput(ip);
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	492080e7          	jalr	1170(ra) # 80002d52 <iunlockput>
    end_op();
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	c6e080e7          	jalr	-914(ra) # 80003536 <end_op>
    return -1;
    800048d0:	57fd                	li	a5,-1
    800048d2:	a83d                	j	80004910 <sys_link+0x13c>
    iunlockput(dp);
    800048d4:	854a                	mv	a0,s2
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	47c080e7          	jalr	1148(ra) # 80002d52 <iunlockput>
  ilock(ip);
    800048de:	8526                	mv	a0,s1
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	210080e7          	jalr	528(ra) # 80002af0 <ilock>
  ip->nlink--;
    800048e8:	04a4d783          	lhu	a5,74(s1)
    800048ec:	37fd                	addiw	a5,a5,-1
    800048ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f2:	8526                	mv	a0,s1
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	132080e7          	jalr	306(ra) # 80002a26 <iupdate>
  iunlockput(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	454080e7          	jalr	1108(ra) # 80002d52 <iunlockput>
  end_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	c30080e7          	jalr	-976(ra) # 80003536 <end_op>
  return -1;
    8000490e:	57fd                	li	a5,-1
}
    80004910:	853e                	mv	a0,a5
    80004912:	70b2                	ld	ra,296(sp)
    80004914:	7412                	ld	s0,288(sp)
    80004916:	64f2                	ld	s1,280(sp)
    80004918:	6952                	ld	s2,272(sp)
    8000491a:	6155                	addi	sp,sp,304
    8000491c:	8082                	ret

000000008000491e <sys_unlink>:
{
    8000491e:	7151                	addi	sp,sp,-240
    80004920:	f586                	sd	ra,232(sp)
    80004922:	f1a2                	sd	s0,224(sp)
    80004924:	eda6                	sd	s1,216(sp)
    80004926:	e9ca                	sd	s2,208(sp)
    80004928:	e5ce                	sd	s3,200(sp)
    8000492a:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    8000492c:	08000613          	li	a2,128
    80004930:	f3040593          	addi	a1,s0,-208
    80004934:	4501                	li	a0,0
    80004936:	ffffd097          	auipc	ra,0xffffd
    8000493a:	67e080e7          	jalr	1662(ra) # 80001fb4 <argstr>
    8000493e:	18054163          	bltz	a0,80004ac0 <sys_unlink+0x1a2>
  begin_op();
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	b74080e7          	jalr	-1164(ra) # 800034b6 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    8000494a:	fb040593          	addi	a1,s0,-80
    8000494e:	f3040513          	addi	a0,s0,-208
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	962080e7          	jalr	-1694(ra) # 800032b4 <nameiparent>
    8000495a:	84aa                	mv	s1,a0
    8000495c:	c979                	beqz	a0,80004a32 <sys_unlink+0x114>
  ilock(dp);
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	192080e7          	jalr	402(ra) # 80002af0 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004966:	00004597          	auipc	a1,0x4
    8000496a:	d1258593          	addi	a1,a1,-750 # 80008678 <syscalls+0x2b8>
    8000496e:	fb040513          	addi	a0,s0,-80
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	648080e7          	jalr	1608(ra) # 80002fba <namecmp>
    8000497a:	14050a63          	beqz	a0,80004ace <sys_unlink+0x1b0>
    8000497e:	00004597          	auipc	a1,0x4
    80004982:	d0258593          	addi	a1,a1,-766 # 80008680 <syscalls+0x2c0>
    80004986:	fb040513          	addi	a0,s0,-80
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	630080e7          	jalr	1584(ra) # 80002fba <namecmp>
    80004992:	12050e63          	beqz	a0,80004ace <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004996:	f2c40613          	addi	a2,s0,-212
    8000499a:	fb040593          	addi	a1,s0,-80
    8000499e:	8526                	mv	a0,s1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	634080e7          	jalr	1588(ra) # 80002fd4 <dirlookup>
    800049a8:	892a                	mv	s2,a0
    800049aa:	12050263          	beqz	a0,80004ace <sys_unlink+0x1b0>
  ilock(ip);
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	142080e7          	jalr	322(ra) # 80002af0 <ilock>
  if (ip->nlink < 1)
    800049b6:	04a91783          	lh	a5,74(s2)
    800049ba:	08f05263          	blez	a5,80004a3e <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    800049be:	04491703          	lh	a4,68(s2)
    800049c2:	4785                	li	a5,1
    800049c4:	08f70563          	beq	a4,a5,80004a4e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049c8:	4641                	li	a2,16
    800049ca:	4581                	li	a1,0
    800049cc:	fc040513          	addi	a0,s0,-64
    800049d0:	ffffb097          	auipc	ra,0xffffb
    800049d4:	7a8080e7          	jalr	1960(ra) # 80000178 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049d8:	4741                	li	a4,16
    800049da:	f2c42683          	lw	a3,-212(s0)
    800049de:	fc040613          	addi	a2,s0,-64
    800049e2:	4581                	li	a1,0
    800049e4:	8526                	mv	a0,s1
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	4b6080e7          	jalr	1206(ra) # 80002e9c <writei>
    800049ee:	47c1                	li	a5,16
    800049f0:	0af51563          	bne	a0,a5,80004a9a <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    800049f4:	04491703          	lh	a4,68(s2)
    800049f8:	4785                	li	a5,1
    800049fa:	0af70863          	beq	a4,a5,80004aaa <sys_unlink+0x18c>
  iunlockput(dp);
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	352080e7          	jalr	850(ra) # 80002d52 <iunlockput>
  ip->nlink--;
    80004a08:	04a95783          	lhu	a5,74(s2)
    80004a0c:	37fd                	addiw	a5,a5,-1
    80004a0e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a12:	854a                	mv	a0,s2
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	012080e7          	jalr	18(ra) # 80002a26 <iupdate>
  iunlockput(ip);
    80004a1c:	854a                	mv	a0,s2
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	334080e7          	jalr	820(ra) # 80002d52 <iunlockput>
  end_op();
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	b10080e7          	jalr	-1264(ra) # 80003536 <end_op>
  return 0;
    80004a2e:	4501                	li	a0,0
    80004a30:	a84d                	j	80004ae2 <sys_unlink+0x1c4>
    end_op();
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	b04080e7          	jalr	-1276(ra) # 80003536 <end_op>
    return -1;
    80004a3a:	557d                	li	a0,-1
    80004a3c:	a05d                	j	80004ae2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a3e:	00004517          	auipc	a0,0x4
    80004a42:	c4a50513          	addi	a0,a0,-950 # 80008688 <syscalls+0x2c8>
    80004a46:	00001097          	auipc	ra,0x1
    80004a4a:	2e8080e7          	jalr	744(ra) # 80005d2e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a4e:	04c92703          	lw	a4,76(s2)
    80004a52:	02000793          	li	a5,32
    80004a56:	f6e7f9e3          	bgeu	a5,a4,800049c8 <sys_unlink+0xaa>
    80004a5a:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a5e:	4741                	li	a4,16
    80004a60:	86ce                	mv	a3,s3
    80004a62:	f1840613          	addi	a2,s0,-232
    80004a66:	4581                	li	a1,0
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	33a080e7          	jalr	826(ra) # 80002da4 <readi>
    80004a72:	47c1                	li	a5,16
    80004a74:	00f51b63          	bne	a0,a5,80004a8a <sys_unlink+0x16c>
    if (de.inum != 0)
    80004a78:	f1845783          	lhu	a5,-232(s0)
    80004a7c:	e7a1                	bnez	a5,80004ac4 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004a7e:	29c1                	addiw	s3,s3,16
    80004a80:	04c92783          	lw	a5,76(s2)
    80004a84:	fcf9ede3          	bltu	s3,a5,80004a5e <sys_unlink+0x140>
    80004a88:	b781                	j	800049c8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a8a:	00004517          	auipc	a0,0x4
    80004a8e:	c1650513          	addi	a0,a0,-1002 # 800086a0 <syscalls+0x2e0>
    80004a92:	00001097          	auipc	ra,0x1
    80004a96:	29c080e7          	jalr	668(ra) # 80005d2e <panic>
    panic("unlink: writei");
    80004a9a:	00004517          	auipc	a0,0x4
    80004a9e:	c1e50513          	addi	a0,a0,-994 # 800086b8 <syscalls+0x2f8>
    80004aa2:	00001097          	auipc	ra,0x1
    80004aa6:	28c080e7          	jalr	652(ra) # 80005d2e <panic>
    dp->nlink--;
    80004aaa:	04a4d783          	lhu	a5,74(s1)
    80004aae:	37fd                	addiw	a5,a5,-1
    80004ab0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	f70080e7          	jalr	-144(ra) # 80002a26 <iupdate>
    80004abe:	b781                	j	800049fe <sys_unlink+0xe0>
    return -1;
    80004ac0:	557d                	li	a0,-1
    80004ac2:	a005                	j	80004ae2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ac4:	854a                	mv	a0,s2
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	28c080e7          	jalr	652(ra) # 80002d52 <iunlockput>
  iunlockput(dp);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	282080e7          	jalr	642(ra) # 80002d52 <iunlockput>
  end_op();
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	a5e080e7          	jalr	-1442(ra) # 80003536 <end_op>
  return -1;
    80004ae0:	557d                	li	a0,-1
}
    80004ae2:	70ae                	ld	ra,232(sp)
    80004ae4:	740e                	ld	s0,224(sp)
    80004ae6:	64ee                	ld	s1,216(sp)
    80004ae8:	694e                	ld	s2,208(sp)
    80004aea:	69ae                	ld	s3,200(sp)
    80004aec:	616d                	addi	sp,sp,240
    80004aee:	8082                	ret

0000000080004af0 <sys_mmap>:
{
    80004af0:	715d                	addi	sp,sp,-80
    80004af2:	e486                	sd	ra,72(sp)
    80004af4:	e0a2                	sd	s0,64(sp)
    80004af6:	fc26                	sd	s1,56(sp)
    80004af8:	f84a                	sd	s2,48(sp)
    80004afa:	f44e                	sd	s3,40(sp)
    80004afc:	f052                	sd	s4,32(sp)
    80004afe:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80004b00:	ffffc097          	auipc	ra,0xffffc
    80004b04:	338080e7          	jalr	824(ra) # 80000e38 <myproc>
    80004b08:	892a                	mv	s2,a0
  argint(1, &length);
    80004b0a:	fcc40593          	addi	a1,s0,-52
    80004b0e:	4505                	li	a0,1
    80004b10:	ffffd097          	auipc	ra,0xffffd
    80004b14:	464080e7          	jalr	1124(ra) # 80001f74 <argint>
  argint(2, &prot);
    80004b18:	fc840593          	addi	a1,s0,-56
    80004b1c:	4509                	li	a0,2
    80004b1e:	ffffd097          	auipc	ra,0xffffd
    80004b22:	456080e7          	jalr	1110(ra) # 80001f74 <argint>
  argint(3, &flags);
    80004b26:	fc440593          	addi	a1,s0,-60
    80004b2a:	450d                	li	a0,3
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	448080e7          	jalr	1096(ra) # 80001f74 <argint>
  argfd(4, &fd, &mfile);
    80004b34:	fb040613          	addi	a2,s0,-80
    80004b38:	fc040593          	addi	a1,s0,-64
    80004b3c:	4511                	li	a0,4
    80004b3e:	00000097          	auipc	ra,0x0
    80004b42:	8d8080e7          	jalr	-1832(ra) # 80004416 <argfd>
  argint(5, &offset);
    80004b46:	fbc40593          	addi	a1,s0,-68
    80004b4a:	4515                	li	a0,5
    80004b4c:	ffffd097          	auipc	ra,0xffffd
    80004b50:	428080e7          	jalr	1064(ra) # 80001f74 <argint>
  if (length < 0 || prot < 0 || flags < 0 || fd < 0 || offset < 0)
    80004b54:	fcc42603          	lw	a2,-52(s0)
    80004b58:	0a064863          	bltz	a2,80004c08 <sys_mmap+0x118>
    80004b5c:	fc842583          	lw	a1,-56(s0)
    80004b60:	0a05c663          	bltz	a1,80004c0c <sys_mmap+0x11c>
    80004b64:	fc442803          	lw	a6,-60(s0)
    80004b68:	0a084463          	bltz	a6,80004c10 <sys_mmap+0x120>
    80004b6c:	fc042883          	lw	a7,-64(s0)
    80004b70:	0a08c263          	bltz	a7,80004c14 <sys_mmap+0x124>
    80004b74:	fbc42303          	lw	t1,-68(s0)
    80004b78:	0a034063          	bltz	t1,80004c18 <sys_mmap+0x128>
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004b7c:	fb043e03          	ld	t3,-80(s0)
    80004b80:	009e4783          	lbu	a5,9(t3)
    80004b84:	e781                	bnez	a5,80004b8c <sys_mmap+0x9c>
    80004b86:	0025f793          	andi	a5,a1,2
    80004b8a:	e78d                	bnez	a5,80004bb4 <sys_mmap+0xc4>
  while (idx < VMASIZE)
    80004b8c:	17090793          	addi	a5,s2,368
{
    80004b90:	4481                	li	s1,0
  while (idx < VMASIZE)
    80004b92:	46c1                	li	a3,16
    if (p->vma[idx].length == 0) // free vma
    80004b94:	4398                	lw	a4,0(a5)
    80004b96:	c705                	beqz	a4,80004bbe <sys_mmap+0xce>
    idx++;
    80004b98:	2485                	addiw	s1,s1,1
  while (idx < VMASIZE)
    80004b9a:	02878793          	addi	a5,a5,40
    80004b9e:	fed49be3          	bne	s1,a3,80004b94 <sys_mmap+0xa4>
  return -1;
    80004ba2:	557d                	li	a0,-1
}
    80004ba4:	60a6                	ld	ra,72(sp)
    80004ba6:	6406                	ld	s0,64(sp)
    80004ba8:	74e2                	ld	s1,56(sp)
    80004baa:	7942                	ld	s2,48(sp)
    80004bac:	79a2                	ld	s3,40(sp)
    80004bae:	7a02                	ld	s4,32(sp)
    80004bb0:	6161                	addi	sp,sp,80
    80004bb2:	8082                	ret
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004bb4:	00187793          	andi	a5,a6,1
    return -1;
    80004bb8:	557d                	li	a0,-1
  if (!mfile->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80004bba:	dbe9                	beqz	a5,80004b8c <sys_mmap+0x9c>
    80004bbc:	b7e5                	j	80004ba4 <sys_mmap+0xb4>
      p->vma[idx].addr = (void *)p->sz;
    80004bbe:	00249a13          	slli	s4,s1,0x2
    80004bc2:	009a09b3          	add	s3,s4,s1
    80004bc6:	098e                	slli	s3,s3,0x3
    80004bc8:	99ca                	add	s3,s3,s2
    80004bca:	04893783          	ld	a5,72(s2)
    80004bce:	16f9b423          	sd	a5,360(s3)
      p->vma[idx].length = length;
    80004bd2:	16c9a823          	sw	a2,368(s3)
      p->vma[idx].prot = prot;
    80004bd6:	16b9aa23          	sw	a1,372(s3)
      p->vma[idx].flags = flags;
    80004bda:	1709ac23          	sw	a6,376(s3)
      p->vma[idx].fd = fd;
    80004bde:	1719ae23          	sw	a7,380(s3)
      p->vma[idx].offset = offset;
    80004be2:	1869a023          	sw	t1,384(s3)
      p->vma[idx].mfile = filedup(mfile);
    80004be6:	8572                	mv	a0,t3
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	d48080e7          	jalr	-696(ra) # 80003930 <filedup>
    80004bf0:	18a9b423          	sd	a0,392(s3)
      p->sz += length;
    80004bf4:	fcc42703          	lw	a4,-52(s0)
    80004bf8:	04893783          	ld	a5,72(s2)
    80004bfc:	97ba                	add	a5,a5,a4
    80004bfe:	04f93423          	sd	a5,72(s2)
      return (uint64)p->vma[idx].addr;
    80004c02:	1689b503          	ld	a0,360(s3)
    80004c06:	bf79                	j	80004ba4 <sys_mmap+0xb4>
    return -1;
    80004c08:	557d                	li	a0,-1
    80004c0a:	bf69                	j	80004ba4 <sys_mmap+0xb4>
    80004c0c:	557d                	li	a0,-1
    80004c0e:	bf59                	j	80004ba4 <sys_mmap+0xb4>
    80004c10:	557d                	li	a0,-1
    80004c12:	bf49                	j	80004ba4 <sys_mmap+0xb4>
    80004c14:	557d                	li	a0,-1
    80004c16:	b779                	j	80004ba4 <sys_mmap+0xb4>
    80004c18:	557d                	li	a0,-1
    80004c1a:	b769                	j	80004ba4 <sys_mmap+0xb4>

0000000080004c1c <sys_munmap>:
{
    80004c1c:	1141                	addi	sp,sp,-16
    80004c1e:	e422                	sd	s0,8(sp)
    80004c20:	0800                	addi	s0,sp,16
}
    80004c22:	4501                	li	a0,0
    80004c24:	6422                	ld	s0,8(sp)
    80004c26:	0141                	addi	sp,sp,16
    80004c28:	8082                	ret

0000000080004c2a <sys_open>:

uint64
sys_open(void)
{
    80004c2a:	7131                	addi	sp,sp,-192
    80004c2c:	fd06                	sd	ra,184(sp)
    80004c2e:	f922                	sd	s0,176(sp)
    80004c30:	f526                	sd	s1,168(sp)
    80004c32:	f14a                	sd	s2,160(sp)
    80004c34:	ed4e                	sd	s3,152(sp)
    80004c36:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c38:	f4c40593          	addi	a1,s0,-180
    80004c3c:	4505                	li	a0,1
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	336080e7          	jalr	822(ra) # 80001f74 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c46:	08000613          	li	a2,128
    80004c4a:	f5040593          	addi	a1,s0,-176
    80004c4e:	4501                	li	a0,0
    80004c50:	ffffd097          	auipc	ra,0xffffd
    80004c54:	364080e7          	jalr	868(ra) # 80001fb4 <argstr>
    80004c58:	87aa                	mv	a5,a0
    return -1;
    80004c5a:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004c5c:	0a07c963          	bltz	a5,80004d0e <sys_open+0xe4>

  begin_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	856080e7          	jalr	-1962(ra) # 800034b6 <begin_op>

  if (omode & O_CREATE)
    80004c68:	f4c42783          	lw	a5,-180(s0)
    80004c6c:	2007f793          	andi	a5,a5,512
    80004c70:	cfc5                	beqz	a5,80004d28 <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004c72:	4681                	li	a3,0
    80004c74:	4601                	li	a2,0
    80004c76:	4589                	li	a1,2
    80004c78:	f5040513          	addi	a0,s0,-176
    80004c7c:	00000097          	auipc	ra,0x0
    80004c80:	83c080e7          	jalr	-1988(ra) # 800044b8 <create>
    80004c84:	84aa                	mv	s1,a0
    if (ip == 0)
    80004c86:	c959                	beqz	a0,80004d1c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004c88:	04449703          	lh	a4,68(s1)
    80004c8c:	478d                	li	a5,3
    80004c8e:	00f71763          	bne	a4,a5,80004c9c <sys_open+0x72>
    80004c92:	0464d703          	lhu	a4,70(s1)
    80004c96:	47a5                	li	a5,9
    80004c98:	0ce7ed63          	bltu	a5,a4,80004d72 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	c2a080e7          	jalr	-982(ra) # 800038c6 <filealloc>
    80004ca4:	89aa                	mv	s3,a0
    80004ca6:	10050363          	beqz	a0,80004dac <sys_open+0x182>
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	7cc080e7          	jalr	1996(ra) # 80004476 <fdalloc>
    80004cb2:	892a                	mv	s2,a0
    80004cb4:	0e054763          	bltz	a0,80004da2 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004cb8:	04449703          	lh	a4,68(s1)
    80004cbc:	478d                	li	a5,3
    80004cbe:	0cf70563          	beq	a4,a5,80004d88 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004cc2:	4789                	li	a5,2
    80004cc4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cc8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ccc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cd0:	f4c42783          	lw	a5,-180(s0)
    80004cd4:	0017c713          	xori	a4,a5,1
    80004cd8:	8b05                	andi	a4,a4,1
    80004cda:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cde:	0037f713          	andi	a4,a5,3
    80004ce2:	00e03733          	snez	a4,a4
    80004ce6:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004cea:	4007f793          	andi	a5,a5,1024
    80004cee:	c791                	beqz	a5,80004cfa <sys_open+0xd0>
    80004cf0:	04449703          	lh	a4,68(s1)
    80004cf4:	4789                	li	a5,2
    80004cf6:	0af70063          	beq	a4,a5,80004d96 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004cfa:	8526                	mv	a0,s1
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	eb6080e7          	jalr	-330(ra) # 80002bb2 <iunlock>
  end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	832080e7          	jalr	-1998(ra) # 80003536 <end_op>

  return fd;
    80004d0c:	854a                	mv	a0,s2
}
    80004d0e:	70ea                	ld	ra,184(sp)
    80004d10:	744a                	ld	s0,176(sp)
    80004d12:	74aa                	ld	s1,168(sp)
    80004d14:	790a                	ld	s2,160(sp)
    80004d16:	69ea                	ld	s3,152(sp)
    80004d18:	6129                	addi	sp,sp,192
    80004d1a:	8082                	ret
      end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	81a080e7          	jalr	-2022(ra) # 80003536 <end_op>
      return -1;
    80004d24:	557d                	li	a0,-1
    80004d26:	b7e5                	j	80004d0e <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004d28:	f5040513          	addi	a0,s0,-176
    80004d2c:	ffffe097          	auipc	ra,0xffffe
    80004d30:	56a080e7          	jalr	1386(ra) # 80003296 <namei>
    80004d34:	84aa                	mv	s1,a0
    80004d36:	c905                	beqz	a0,80004d66 <sys_open+0x13c>
    ilock(ip);
    80004d38:	ffffe097          	auipc	ra,0xffffe
    80004d3c:	db8080e7          	jalr	-584(ra) # 80002af0 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004d40:	04449703          	lh	a4,68(s1)
    80004d44:	4785                	li	a5,1
    80004d46:	f4f711e3          	bne	a4,a5,80004c88 <sys_open+0x5e>
    80004d4a:	f4c42783          	lw	a5,-180(s0)
    80004d4e:	d7b9                	beqz	a5,80004c9c <sys_open+0x72>
      iunlockput(ip);
    80004d50:	8526                	mv	a0,s1
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	000080e7          	jalr	ra # 80002d52 <iunlockput>
      end_op();
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	7dc080e7          	jalr	2012(ra) # 80003536 <end_op>
      return -1;
    80004d62:	557d                	li	a0,-1
    80004d64:	b76d                	j	80004d0e <sys_open+0xe4>
      end_op();
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	7d0080e7          	jalr	2000(ra) # 80003536 <end_op>
      return -1;
    80004d6e:	557d                	li	a0,-1
    80004d70:	bf79                	j	80004d0e <sys_open+0xe4>
    iunlockput(ip);
    80004d72:	8526                	mv	a0,s1
    80004d74:	ffffe097          	auipc	ra,0xffffe
    80004d78:	fde080e7          	jalr	-34(ra) # 80002d52 <iunlockput>
    end_op();
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	7ba080e7          	jalr	1978(ra) # 80003536 <end_op>
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	b761                	j	80004d0e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d88:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d8c:	04649783          	lh	a5,70(s1)
    80004d90:	02f99223          	sh	a5,36(s3)
    80004d94:	bf25                	j	80004ccc <sys_open+0xa2>
    itrunc(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	e66080e7          	jalr	-410(ra) # 80002bfe <itrunc>
    80004da0:	bfa9                	j	80004cfa <sys_open+0xd0>
      fileclose(f);
    80004da2:	854e                	mv	a0,s3
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	bde080e7          	jalr	-1058(ra) # 80003982 <fileclose>
    iunlockput(ip);
    80004dac:	8526                	mv	a0,s1
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	fa4080e7          	jalr	-92(ra) # 80002d52 <iunlockput>
    end_op();
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	780080e7          	jalr	1920(ra) # 80003536 <end_op>
    return -1;
    80004dbe:	557d                	li	a0,-1
    80004dc0:	b7b9                	j	80004d0e <sys_open+0xe4>

0000000080004dc2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dc2:	7175                	addi	sp,sp,-144
    80004dc4:	e506                	sd	ra,136(sp)
    80004dc6:	e122                	sd	s0,128(sp)
    80004dc8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	6ec080e7          	jalr	1772(ra) # 800034b6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004dd2:	08000613          	li	a2,128
    80004dd6:	f7040593          	addi	a1,s0,-144
    80004dda:	4501                	li	a0,0
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	1d8080e7          	jalr	472(ra) # 80001fb4 <argstr>
    80004de4:	02054963          	bltz	a0,80004e16 <sys_mkdir+0x54>
    80004de8:	4681                	li	a3,0
    80004dea:	4601                	li	a2,0
    80004dec:	4585                	li	a1,1
    80004dee:	f7040513          	addi	a0,s0,-144
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	6c6080e7          	jalr	1734(ra) # 800044b8 <create>
    80004dfa:	cd11                	beqz	a0,80004e16 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	f56080e7          	jalr	-170(ra) # 80002d52 <iunlockput>
  end_op();
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	732080e7          	jalr	1842(ra) # 80003536 <end_op>
  return 0;
    80004e0c:	4501                	li	a0,0
}
    80004e0e:	60aa                	ld	ra,136(sp)
    80004e10:	640a                	ld	s0,128(sp)
    80004e12:	6149                	addi	sp,sp,144
    80004e14:	8082                	ret
    end_op();
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	720080e7          	jalr	1824(ra) # 80003536 <end_op>
    return -1;
    80004e1e:	557d                	li	a0,-1
    80004e20:	b7fd                	j	80004e0e <sys_mkdir+0x4c>

0000000080004e22 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e22:	7135                	addi	sp,sp,-160
    80004e24:	ed06                	sd	ra,152(sp)
    80004e26:	e922                	sd	s0,144(sp)
    80004e28:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	68c080e7          	jalr	1676(ra) # 800034b6 <begin_op>
  argint(1, &major);
    80004e32:	f6c40593          	addi	a1,s0,-148
    80004e36:	4505                	li	a0,1
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	13c080e7          	jalr	316(ra) # 80001f74 <argint>
  argint(2, &minor);
    80004e40:	f6840593          	addi	a1,s0,-152
    80004e44:	4509                	li	a0,2
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	12e080e7          	jalr	302(ra) # 80001f74 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e4e:	08000613          	li	a2,128
    80004e52:	f7040593          	addi	a1,s0,-144
    80004e56:	4501                	li	a0,0
    80004e58:	ffffd097          	auipc	ra,0xffffd
    80004e5c:	15c080e7          	jalr	348(ra) # 80001fb4 <argstr>
    80004e60:	02054b63          	bltz	a0,80004e96 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004e64:	f6841683          	lh	a3,-152(s0)
    80004e68:	f6c41603          	lh	a2,-148(s0)
    80004e6c:	458d                	li	a1,3
    80004e6e:	f7040513          	addi	a0,s0,-144
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	646080e7          	jalr	1606(ra) # 800044b8 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e7a:	cd11                	beqz	a0,80004e96 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	ed6080e7          	jalr	-298(ra) # 80002d52 <iunlockput>
  end_op();
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	6b2080e7          	jalr	1714(ra) # 80003536 <end_op>
  return 0;
    80004e8c:	4501                	li	a0,0
}
    80004e8e:	60ea                	ld	ra,152(sp)
    80004e90:	644a                	ld	s0,144(sp)
    80004e92:	610d                	addi	sp,sp,160
    80004e94:	8082                	ret
    end_op();
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	6a0080e7          	jalr	1696(ra) # 80003536 <end_op>
    return -1;
    80004e9e:	557d                	li	a0,-1
    80004ea0:	b7fd                	j	80004e8e <sys_mknod+0x6c>

0000000080004ea2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ea2:	7135                	addi	sp,sp,-160
    80004ea4:	ed06                	sd	ra,152(sp)
    80004ea6:	e922                	sd	s0,144(sp)
    80004ea8:	e526                	sd	s1,136(sp)
    80004eaa:	e14a                	sd	s2,128(sp)
    80004eac:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eae:	ffffc097          	auipc	ra,0xffffc
    80004eb2:	f8a080e7          	jalr	-118(ra) # 80000e38 <myproc>
    80004eb6:	892a                	mv	s2,a0

  begin_op();
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	5fe080e7          	jalr	1534(ra) # 800034b6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004ec0:	08000613          	li	a2,128
    80004ec4:	f6040593          	addi	a1,s0,-160
    80004ec8:	4501                	li	a0,0
    80004eca:	ffffd097          	auipc	ra,0xffffd
    80004ece:	0ea080e7          	jalr	234(ra) # 80001fb4 <argstr>
    80004ed2:	04054b63          	bltz	a0,80004f28 <sys_chdir+0x86>
    80004ed6:	f6040513          	addi	a0,s0,-160
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	3bc080e7          	jalr	956(ra) # 80003296 <namei>
    80004ee2:	84aa                	mv	s1,a0
    80004ee4:	c131                	beqz	a0,80004f28 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	c0a080e7          	jalr	-1014(ra) # 80002af0 <ilock>
  if (ip->type != T_DIR)
    80004eee:	04449703          	lh	a4,68(s1)
    80004ef2:	4785                	li	a5,1
    80004ef4:	04f71063          	bne	a4,a5,80004f34 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ef8:	8526                	mv	a0,s1
    80004efa:	ffffe097          	auipc	ra,0xffffe
    80004efe:	cb8080e7          	jalr	-840(ra) # 80002bb2 <iunlock>
  iput(p->cwd);
    80004f02:	15093503          	ld	a0,336(s2)
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	da4080e7          	jalr	-604(ra) # 80002caa <iput>
  end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	628080e7          	jalr	1576(ra) # 80003536 <end_op>
  p->cwd = ip;
    80004f16:	14993823          	sd	s1,336(s2)
  return 0;
    80004f1a:	4501                	li	a0,0
}
    80004f1c:	60ea                	ld	ra,152(sp)
    80004f1e:	644a                	ld	s0,144(sp)
    80004f20:	64aa                	ld	s1,136(sp)
    80004f22:	690a                	ld	s2,128(sp)
    80004f24:	610d                	addi	sp,sp,160
    80004f26:	8082                	ret
    end_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	60e080e7          	jalr	1550(ra) # 80003536 <end_op>
    return -1;
    80004f30:	557d                	li	a0,-1
    80004f32:	b7ed                	j	80004f1c <sys_chdir+0x7a>
    iunlockput(ip);
    80004f34:	8526                	mv	a0,s1
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	e1c080e7          	jalr	-484(ra) # 80002d52 <iunlockput>
    end_op();
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	5f8080e7          	jalr	1528(ra) # 80003536 <end_op>
    return -1;
    80004f46:	557d                	li	a0,-1
    80004f48:	bfd1                	j	80004f1c <sys_chdir+0x7a>

0000000080004f4a <sys_exec>:

uint64
sys_exec(void)
{
    80004f4a:	7145                	addi	sp,sp,-464
    80004f4c:	e786                	sd	ra,456(sp)
    80004f4e:	e3a2                	sd	s0,448(sp)
    80004f50:	ff26                	sd	s1,440(sp)
    80004f52:	fb4a                	sd	s2,432(sp)
    80004f54:	f74e                	sd	s3,424(sp)
    80004f56:	f352                	sd	s4,416(sp)
    80004f58:	ef56                	sd	s5,408(sp)
    80004f5a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f5c:	e3840593          	addi	a1,s0,-456
    80004f60:	4505                	li	a0,1
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	032080e7          	jalr	50(ra) # 80001f94 <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    80004f6a:	08000613          	li	a2,128
    80004f6e:	f4040593          	addi	a1,s0,-192
    80004f72:	4501                	li	a0,0
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	040080e7          	jalr	64(ra) # 80001fb4 <argstr>
    80004f7c:	87aa                	mv	a5,a0
  {
    return -1;
    80004f7e:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    80004f80:	0c07c263          	bltz	a5,80005044 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f84:	10000613          	li	a2,256
    80004f88:	4581                	li	a1,0
    80004f8a:	e4040513          	addi	a0,s0,-448
    80004f8e:	ffffb097          	auipc	ra,0xffffb
    80004f92:	1ea080e7          	jalr	490(ra) # 80000178 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004f96:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f9a:	89a6                	mv	s3,s1
    80004f9c:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004f9e:	02000a13          	li	s4,32
    80004fa2:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004fa6:	00391793          	slli	a5,s2,0x3
    80004faa:	e3040593          	addi	a1,s0,-464
    80004fae:	e3843503          	ld	a0,-456(s0)
    80004fb2:	953e                	add	a0,a0,a5
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	f22080e7          	jalr	-222(ra) # 80001ed6 <fetchaddr>
    80004fbc:	02054a63          	bltz	a0,80004ff0 <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    80004fc0:	e3043783          	ld	a5,-464(s0)
    80004fc4:	c3b9                	beqz	a5,8000500a <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fc6:	ffffb097          	auipc	ra,0xffffb
    80004fca:	152080e7          	jalr	338(ra) # 80000118 <kalloc>
    80004fce:	85aa                	mv	a1,a0
    80004fd0:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004fd4:	cd11                	beqz	a0,80004ff0 <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd6:	6605                	lui	a2,0x1
    80004fd8:	e3043503          	ld	a0,-464(s0)
    80004fdc:	ffffd097          	auipc	ra,0xffffd
    80004fe0:	f4c080e7          	jalr	-180(ra) # 80001f28 <fetchstr>
    80004fe4:	00054663          	bltz	a0,80004ff0 <sys_exec+0xa6>
    if (i >= NELEM(argv))
    80004fe8:	0905                	addi	s2,s2,1
    80004fea:	09a1                	addi	s3,s3,8
    80004fec:	fb491be3          	bne	s2,s4,80004fa2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff0:	10048913          	addi	s2,s1,256
    80004ff4:	6088                	ld	a0,0(s1)
    80004ff6:	c531                	beqz	a0,80005042 <sys_exec+0xf8>
    kfree(argv[i]);
    80004ff8:	ffffb097          	auipc	ra,0xffffb
    80004ffc:	024080e7          	jalr	36(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005000:	04a1                	addi	s1,s1,8
    80005002:	ff2499e3          	bne	s1,s2,80004ff4 <sys_exec+0xaa>
  return -1;
    80005006:	557d                	li	a0,-1
    80005008:	a835                	j	80005044 <sys_exec+0xfa>
      argv[i] = 0;
    8000500a:	0a8e                	slli	s5,s5,0x3
    8000500c:	fc040793          	addi	a5,s0,-64
    80005010:	9abe                	add	s5,s5,a5
    80005012:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005016:	e4040593          	addi	a1,s0,-448
    8000501a:	f4040513          	addi	a0,s0,-192
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	038080e7          	jalr	56(ra) # 80004056 <exec>
    80005026:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005028:	10048993          	addi	s3,s1,256
    8000502c:	6088                	ld	a0,0(s1)
    8000502e:	c901                	beqz	a0,8000503e <sys_exec+0xf4>
    kfree(argv[i]);
    80005030:	ffffb097          	auipc	ra,0xffffb
    80005034:	fec080e7          	jalr	-20(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005038:	04a1                	addi	s1,s1,8
    8000503a:	ff3499e3          	bne	s1,s3,8000502c <sys_exec+0xe2>
  return ret;
    8000503e:	854a                	mv	a0,s2
    80005040:	a011                	j	80005044 <sys_exec+0xfa>
  return -1;
    80005042:	557d                	li	a0,-1
}
    80005044:	60be                	ld	ra,456(sp)
    80005046:	641e                	ld	s0,448(sp)
    80005048:	74fa                	ld	s1,440(sp)
    8000504a:	795a                	ld	s2,432(sp)
    8000504c:	79ba                	ld	s3,424(sp)
    8000504e:	7a1a                	ld	s4,416(sp)
    80005050:	6afa                	ld	s5,408(sp)
    80005052:	6179                	addi	sp,sp,464
    80005054:	8082                	ret

0000000080005056 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005056:	7139                	addi	sp,sp,-64
    80005058:	fc06                	sd	ra,56(sp)
    8000505a:	f822                	sd	s0,48(sp)
    8000505c:	f426                	sd	s1,40(sp)
    8000505e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005060:	ffffc097          	auipc	ra,0xffffc
    80005064:	dd8080e7          	jalr	-552(ra) # 80000e38 <myproc>
    80005068:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000506a:	fd840593          	addi	a1,s0,-40
    8000506e:	4501                	li	a0,0
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	f24080e7          	jalr	-220(ra) # 80001f94 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80005078:	fc840593          	addi	a1,s0,-56
    8000507c:	fd040513          	addi	a0,s0,-48
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	c8c080e7          	jalr	-884(ra) # 80003d0c <pipealloc>
    return -1;
    80005088:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    8000508a:	0c054463          	bltz	a0,80005152 <sys_pipe+0xfc>
  fd0 = -1;
    8000508e:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005092:	fd043503          	ld	a0,-48(s0)
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	3e0080e7          	jalr	992(ra) # 80004476 <fdalloc>
    8000509e:	fca42223          	sw	a0,-60(s0)
    800050a2:	08054b63          	bltz	a0,80005138 <sys_pipe+0xe2>
    800050a6:	fc843503          	ld	a0,-56(s0)
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	3cc080e7          	jalr	972(ra) # 80004476 <fdalloc>
    800050b2:	fca42023          	sw	a0,-64(s0)
    800050b6:	06054863          	bltz	a0,80005126 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800050ba:	4691                	li	a3,4
    800050bc:	fc440613          	addi	a2,s0,-60
    800050c0:	fd843583          	ld	a1,-40(s0)
    800050c4:	68a8                	ld	a0,80(s1)
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	a2e080e7          	jalr	-1490(ra) # 80000af4 <copyout>
    800050ce:	02054063          	bltz	a0,800050ee <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800050d2:	4691                	li	a3,4
    800050d4:	fc040613          	addi	a2,s0,-64
    800050d8:	fd843583          	ld	a1,-40(s0)
    800050dc:	0591                	addi	a1,a1,4
    800050de:	68a8                	ld	a0,80(s1)
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	a14080e7          	jalr	-1516(ra) # 80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050e8:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800050ea:	06055463          	bgez	a0,80005152 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050ee:	fc442783          	lw	a5,-60(s0)
    800050f2:	07e9                	addi	a5,a5,26
    800050f4:	078e                	slli	a5,a5,0x3
    800050f6:	97a6                	add	a5,a5,s1
    800050f8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050fc:	fc042503          	lw	a0,-64(s0)
    80005100:	0569                	addi	a0,a0,26
    80005102:	050e                	slli	a0,a0,0x3
    80005104:	94aa                	add	s1,s1,a0
    80005106:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000510a:	fd043503          	ld	a0,-48(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	874080e7          	jalr	-1932(ra) # 80003982 <fileclose>
    fileclose(wf);
    80005116:	fc843503          	ld	a0,-56(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	868080e7          	jalr	-1944(ra) # 80003982 <fileclose>
    return -1;
    80005122:	57fd                	li	a5,-1
    80005124:	a03d                	j	80005152 <sys_pipe+0xfc>
    if (fd0 >= 0)
    80005126:	fc442783          	lw	a5,-60(s0)
    8000512a:	0007c763          	bltz	a5,80005138 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000512e:	07e9                	addi	a5,a5,26
    80005130:	078e                	slli	a5,a5,0x3
    80005132:	94be                	add	s1,s1,a5
    80005134:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005138:	fd043503          	ld	a0,-48(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	846080e7          	jalr	-1978(ra) # 80003982 <fileclose>
    fileclose(wf);
    80005144:	fc843503          	ld	a0,-56(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	83a080e7          	jalr	-1990(ra) # 80003982 <fileclose>
    return -1;
    80005150:	57fd                	li	a5,-1
}
    80005152:	853e                	mv	a0,a5
    80005154:	70e2                	ld	ra,56(sp)
    80005156:	7442                	ld	s0,48(sp)
    80005158:	74a2                	ld	s1,40(sp)
    8000515a:	6121                	addi	sp,sp,64
    8000515c:	8082                	ret
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	addi	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	c03fc0ef          	jal	ra,80001da2 <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	addi	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	c3d8                	sw	a4,4(a5)
}
    8000522a:	6422                	ld	s0,8(sp)
    8000522c:	0141                	addi	sp,sp,16
    8000522e:	8082                	ret

0000000080005230 <plicinithart>:

void
plicinithart(void)
{
    80005230:	1141                	addi	sp,sp,-16
    80005232:	e406                	sd	ra,8(sp)
    80005234:	e022                	sd	s0,0(sp)
    80005236:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	bd4080e7          	jalr	-1068(ra) # 80000e0c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005240:	0085171b          	slliw	a4,a0,0x8
    80005244:	0c0027b7          	lui	a5,0xc002
    80005248:	97ba                	add	a5,a5,a4
    8000524a:	40200713          	li	a4,1026
    8000524e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005252:	00d5151b          	slliw	a0,a0,0xd
    80005256:	0c2017b7          	lui	a5,0xc201
    8000525a:	953e                	add	a0,a0,a5
    8000525c:	00052023          	sw	zero,0(a0)
}
    80005260:	60a2                	ld	ra,8(sp)
    80005262:	6402                	ld	s0,0(sp)
    80005264:	0141                	addi	sp,sp,16
    80005266:	8082                	ret

0000000080005268 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	b9c080e7          	jalr	-1124(ra) # 80000e0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005278:	00d5179b          	slliw	a5,a0,0xd
    8000527c:	0c201537          	lui	a0,0xc201
    80005280:	953e                	add	a0,a0,a5
  return irq;
}
    80005282:	4148                	lw	a0,4(a0)
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000528c:	1101                	addi	sp,sp,-32
    8000528e:	ec06                	sd	ra,24(sp)
    80005290:	e822                	sd	s0,16(sp)
    80005292:	e426                	sd	s1,8(sp)
    80005294:	1000                	addi	s0,sp,32
    80005296:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	b74080e7          	jalr	-1164(ra) # 80000e0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a0:	00d5151b          	slliw	a0,a0,0xd
    800052a4:	0c2017b7          	lui	a5,0xc201
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	c3c4                	sw	s1,4(a5)
}
    800052ac:	60e2                	ld	ra,24(sp)
    800052ae:	6442                	ld	s0,16(sp)
    800052b0:	64a2                	ld	s1,8(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052b6:	1141                	addi	sp,sp,-16
    800052b8:	e406                	sd	ra,8(sp)
    800052ba:	e022                	sd	s0,0(sp)
    800052bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052be:	479d                	li	a5,7
    800052c0:	04a7cc63          	blt	a5,a0,80005318 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052c4:	0001e797          	auipc	a5,0x1e
    800052c8:	6fc78793          	addi	a5,a5,1788 # 800239c0 <disk>
    800052cc:	97aa                	add	a5,a5,a0
    800052ce:	0187c783          	lbu	a5,24(a5)
    800052d2:	ebb9                	bnez	a5,80005328 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052d4:	00451613          	slli	a2,a0,0x4
    800052d8:	0001e797          	auipc	a5,0x1e
    800052dc:	6e878793          	addi	a5,a5,1768 # 800239c0 <disk>
    800052e0:	6394                	ld	a3,0(a5)
    800052e2:	96b2                	add	a3,a3,a2
    800052e4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052e8:	6398                	ld	a4,0(a5)
    800052ea:	9732                	add	a4,a4,a2
    800052ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052f8:	953e                	add	a0,a0,a5
    800052fa:	4785                	li	a5,1
    800052fc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005300:	0001e517          	auipc	a0,0x1e
    80005304:	6d850513          	addi	a0,a0,1752 # 800239d8 <disk+0x18>
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	23c080e7          	jalr	572(ra) # 80001544 <wakeup>
}
    80005310:	60a2                	ld	ra,8(sp)
    80005312:	6402                	ld	s0,0(sp)
    80005314:	0141                	addi	sp,sp,16
    80005316:	8082                	ret
    panic("free_desc 1");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	3b050513          	addi	a0,a0,944 # 800086c8 <syscalls+0x308>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	a0e080e7          	jalr	-1522(ra) # 80005d2e <panic>
    panic("free_desc 2");
    80005328:	00003517          	auipc	a0,0x3
    8000532c:	3b050513          	addi	a0,a0,944 # 800086d8 <syscalls+0x318>
    80005330:	00001097          	auipc	ra,0x1
    80005334:	9fe080e7          	jalr	-1538(ra) # 80005d2e <panic>

0000000080005338 <virtio_disk_init>:
{
    80005338:	1101                	addi	sp,sp,-32
    8000533a:	ec06                	sd	ra,24(sp)
    8000533c:	e822                	sd	s0,16(sp)
    8000533e:	e426                	sd	s1,8(sp)
    80005340:	e04a                	sd	s2,0(sp)
    80005342:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005344:	00003597          	auipc	a1,0x3
    80005348:	3a458593          	addi	a1,a1,932 # 800086e8 <syscalls+0x328>
    8000534c:	0001e517          	auipc	a0,0x1e
    80005350:	79c50513          	addi	a0,a0,1948 # 80023ae8 <disk+0x128>
    80005354:	00001097          	auipc	ra,0x1
    80005358:	e86080e7          	jalr	-378(ra) # 800061da <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000535c:	100017b7          	lui	a5,0x10001
    80005360:	4398                	lw	a4,0(a5)
    80005362:	2701                	sext.w	a4,a4
    80005364:	747277b7          	lui	a5,0x74727
    80005368:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000536c:	14f71c63          	bne	a4,a5,800054c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005370:	100017b7          	lui	a5,0x10001
    80005374:	43dc                	lw	a5,4(a5)
    80005376:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005378:	4709                	li	a4,2
    8000537a:	14e79563          	bne	a5,a4,800054c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000537e:	100017b7          	lui	a5,0x10001
    80005382:	479c                	lw	a5,8(a5)
    80005384:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005386:	12e79f63          	bne	a5,a4,800054c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000538a:	100017b7          	lui	a5,0x10001
    8000538e:	47d8                	lw	a4,12(a5)
    80005390:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005392:	554d47b7          	lui	a5,0x554d4
    80005396:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000539a:	12f71563          	bne	a4,a5,800054c4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539e:	100017b7          	lui	a5,0x10001
    800053a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a6:	4705                	li	a4,1
    800053a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053aa:	470d                	li	a4,3
    800053ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053ae:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053b0:	c7ffe737          	lui	a4,0xc7ffe
    800053b4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd2a1f>
    800053b8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053ba:	2701                	sext.w	a4,a4
    800053bc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053be:	472d                	li	a4,11
    800053c0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053c2:	5bbc                	lw	a5,112(a5)
    800053c4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053c8:	8ba1                	andi	a5,a5,8
    800053ca:	10078563          	beqz	a5,800054d4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053ce:	100017b7          	lui	a5,0x10001
    800053d2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053d6:	43fc                	lw	a5,68(a5)
    800053d8:	2781                	sext.w	a5,a5
    800053da:	10079563          	bnez	a5,800054e4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053de:	100017b7          	lui	a5,0x10001
    800053e2:	5bdc                	lw	a5,52(a5)
    800053e4:	2781                	sext.w	a5,a5
  if(max == 0)
    800053e6:	10078763          	beqz	a5,800054f4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800053ea:	471d                	li	a4,7
    800053ec:	10f77c63          	bgeu	a4,a5,80005504 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800053f0:	ffffb097          	auipc	ra,0xffffb
    800053f4:	d28080e7          	jalr	-728(ra) # 80000118 <kalloc>
    800053f8:	0001e497          	auipc	s1,0x1e
    800053fc:	5c848493          	addi	s1,s1,1480 # 800239c0 <disk>
    80005400:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005402:	ffffb097          	auipc	ra,0xffffb
    80005406:	d16080e7          	jalr	-746(ra) # 80000118 <kalloc>
    8000540a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000540c:	ffffb097          	auipc	ra,0xffffb
    80005410:	d0c080e7          	jalr	-756(ra) # 80000118 <kalloc>
    80005414:	87aa                	mv	a5,a0
    80005416:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005418:	6088                	ld	a0,0(s1)
    8000541a:	cd6d                	beqz	a0,80005514 <virtio_disk_init+0x1dc>
    8000541c:	0001e717          	auipc	a4,0x1e
    80005420:	5ac73703          	ld	a4,1452(a4) # 800239c8 <disk+0x8>
    80005424:	cb65                	beqz	a4,80005514 <virtio_disk_init+0x1dc>
    80005426:	c7fd                	beqz	a5,80005514 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005428:	6605                	lui	a2,0x1
    8000542a:	4581                	li	a1,0
    8000542c:	ffffb097          	auipc	ra,0xffffb
    80005430:	d4c080e7          	jalr	-692(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005434:	0001e497          	auipc	s1,0x1e
    80005438:	58c48493          	addi	s1,s1,1420 # 800239c0 <disk>
    8000543c:	6605                	lui	a2,0x1
    8000543e:	4581                	li	a1,0
    80005440:	6488                	ld	a0,8(s1)
    80005442:	ffffb097          	auipc	ra,0xffffb
    80005446:	d36080e7          	jalr	-714(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000544a:	6605                	lui	a2,0x1
    8000544c:	4581                	li	a1,0
    8000544e:	6888                	ld	a0,16(s1)
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	d28080e7          	jalr	-728(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005458:	100017b7          	lui	a5,0x10001
    8000545c:	4721                	li	a4,8
    8000545e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005460:	4098                	lw	a4,0(s1)
    80005462:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005466:	40d8                	lw	a4,4(s1)
    80005468:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000546c:	6498                	ld	a4,8(s1)
    8000546e:	0007069b          	sext.w	a3,a4
    80005472:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005476:	9701                	srai	a4,a4,0x20
    80005478:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000547c:	6898                	ld	a4,16(s1)
    8000547e:	0007069b          	sext.w	a3,a4
    80005482:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005486:	9701                	srai	a4,a4,0x20
    80005488:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000548c:	4705                	li	a4,1
    8000548e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005490:	00e48c23          	sb	a4,24(s1)
    80005494:	00e48ca3          	sb	a4,25(s1)
    80005498:	00e48d23          	sb	a4,26(s1)
    8000549c:	00e48da3          	sb	a4,27(s1)
    800054a0:	00e48e23          	sb	a4,28(s1)
    800054a4:	00e48ea3          	sb	a4,29(s1)
    800054a8:	00e48f23          	sb	a4,30(s1)
    800054ac:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b4:	0727a823          	sw	s2,112(a5)
}
    800054b8:	60e2                	ld	ra,24(sp)
    800054ba:	6442                	ld	s0,16(sp)
    800054bc:	64a2                	ld	s1,8(sp)
    800054be:	6902                	ld	s2,0(sp)
    800054c0:	6105                	addi	sp,sp,32
    800054c2:	8082                	ret
    panic("could not find virtio disk");
    800054c4:	00003517          	auipc	a0,0x3
    800054c8:	23450513          	addi	a0,a0,564 # 800086f8 <syscalls+0x338>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	862080e7          	jalr	-1950(ra) # 80005d2e <panic>
    panic("virtio disk FEATURES_OK unset");
    800054d4:	00003517          	auipc	a0,0x3
    800054d8:	24450513          	addi	a0,a0,580 # 80008718 <syscalls+0x358>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	852080e7          	jalr	-1966(ra) # 80005d2e <panic>
    panic("virtio disk should not be ready");
    800054e4:	00003517          	auipc	a0,0x3
    800054e8:	25450513          	addi	a0,a0,596 # 80008738 <syscalls+0x378>
    800054ec:	00001097          	auipc	ra,0x1
    800054f0:	842080e7          	jalr	-1982(ra) # 80005d2e <panic>
    panic("virtio disk has no queue 0");
    800054f4:	00003517          	auipc	a0,0x3
    800054f8:	26450513          	addi	a0,a0,612 # 80008758 <syscalls+0x398>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	832080e7          	jalr	-1998(ra) # 80005d2e <panic>
    panic("virtio disk max queue too short");
    80005504:	00003517          	auipc	a0,0x3
    80005508:	27450513          	addi	a0,a0,628 # 80008778 <syscalls+0x3b8>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	822080e7          	jalr	-2014(ra) # 80005d2e <panic>
    panic("virtio disk kalloc");
    80005514:	00003517          	auipc	a0,0x3
    80005518:	28450513          	addi	a0,a0,644 # 80008798 <syscalls+0x3d8>
    8000551c:	00001097          	auipc	ra,0x1
    80005520:	812080e7          	jalr	-2030(ra) # 80005d2e <panic>

0000000080005524 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005524:	7119                	addi	sp,sp,-128
    80005526:	fc86                	sd	ra,120(sp)
    80005528:	f8a2                	sd	s0,112(sp)
    8000552a:	f4a6                	sd	s1,104(sp)
    8000552c:	f0ca                	sd	s2,96(sp)
    8000552e:	ecce                	sd	s3,88(sp)
    80005530:	e8d2                	sd	s4,80(sp)
    80005532:	e4d6                	sd	s5,72(sp)
    80005534:	e0da                	sd	s6,64(sp)
    80005536:	fc5e                	sd	s7,56(sp)
    80005538:	f862                	sd	s8,48(sp)
    8000553a:	f466                	sd	s9,40(sp)
    8000553c:	f06a                	sd	s10,32(sp)
    8000553e:	ec6e                	sd	s11,24(sp)
    80005540:	0100                	addi	s0,sp,128
    80005542:	8aaa                	mv	s5,a0
    80005544:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005546:	00c52d03          	lw	s10,12(a0)
    8000554a:	001d1d1b          	slliw	s10,s10,0x1
    8000554e:	1d02                	slli	s10,s10,0x20
    80005550:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005554:	0001e517          	auipc	a0,0x1e
    80005558:	59450513          	addi	a0,a0,1428 # 80023ae8 <disk+0x128>
    8000555c:	00001097          	auipc	ra,0x1
    80005560:	d0e080e7          	jalr	-754(ra) # 8000626a <acquire>
  for(int i = 0; i < 3; i++){
    80005564:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005566:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005568:	0001eb97          	auipc	s7,0x1e
    8000556c:	458b8b93          	addi	s7,s7,1112 # 800239c0 <disk>
  for(int i = 0; i < 3; i++){
    80005570:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005572:	0001ec97          	auipc	s9,0x1e
    80005576:	576c8c93          	addi	s9,s9,1398 # 80023ae8 <disk+0x128>
    8000557a:	a08d                	j	800055dc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000557c:	00fb8733          	add	a4,s7,a5
    80005580:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005584:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005586:	0207c563          	bltz	a5,800055b0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000558a:	2905                	addiw	s2,s2,1
    8000558c:	0611                	addi	a2,a2,4
    8000558e:	05690c63          	beq	s2,s6,800055e6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005592:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005594:	0001e717          	auipc	a4,0x1e
    80005598:	42c70713          	addi	a4,a4,1068 # 800239c0 <disk>
    8000559c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000559e:	01874683          	lbu	a3,24(a4)
    800055a2:	fee9                	bnez	a3,8000557c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800055a4:	2785                	addiw	a5,a5,1
    800055a6:	0705                	addi	a4,a4,1
    800055a8:	fe979be3          	bne	a5,s1,8000559e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055ac:	57fd                	li	a5,-1
    800055ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055b0:	01205d63          	blez	s2,800055ca <virtio_disk_rw+0xa6>
    800055b4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055b6:	000a2503          	lw	a0,0(s4)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	cfc080e7          	jalr	-772(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    800055c2:	2d85                	addiw	s11,s11,1
    800055c4:	0a11                	addi	s4,s4,4
    800055c6:	ffb918e3          	bne	s2,s11,800055b6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055ca:	85e6                	mv	a1,s9
    800055cc:	0001e517          	auipc	a0,0x1e
    800055d0:	40c50513          	addi	a0,a0,1036 # 800239d8 <disk+0x18>
    800055d4:	ffffc097          	auipc	ra,0xffffc
    800055d8:	f0c080e7          	jalr	-244(ra) # 800014e0 <sleep>
  for(int i = 0; i < 3; i++){
    800055dc:	f8040a13          	addi	s4,s0,-128
{
    800055e0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055e2:	894e                	mv	s2,s3
    800055e4:	b77d                	j	80005592 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e6:	f8042583          	lw	a1,-128(s0)
    800055ea:	00a58793          	addi	a5,a1,10
    800055ee:	0792                	slli	a5,a5,0x4

  if(write)
    800055f0:	0001e617          	auipc	a2,0x1e
    800055f4:	3d060613          	addi	a2,a2,976 # 800239c0 <disk>
    800055f8:	00f60733          	add	a4,a2,a5
    800055fc:	018036b3          	snez	a3,s8
    80005600:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005602:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005606:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000560a:	f6078693          	addi	a3,a5,-160
    8000560e:	6218                	ld	a4,0(a2)
    80005610:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005612:	00878513          	addi	a0,a5,8
    80005616:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005618:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000561a:	6208                	ld	a0,0(a2)
    8000561c:	96aa                	add	a3,a3,a0
    8000561e:	4741                	li	a4,16
    80005620:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005622:	4705                	li	a4,1
    80005624:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005628:	f8442703          	lw	a4,-124(s0)
    8000562c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005630:	0712                	slli	a4,a4,0x4
    80005632:	953a                	add	a0,a0,a4
    80005634:	058a8693          	addi	a3,s5,88
    80005638:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000563a:	6208                	ld	a0,0(a2)
    8000563c:	972a                	add	a4,a4,a0
    8000563e:	40000693          	li	a3,1024
    80005642:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005644:	001c3c13          	seqz	s8,s8
    80005648:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000564a:	001c6c13          	ori	s8,s8,1
    8000564e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005652:	f8842603          	lw	a2,-120(s0)
    80005656:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000565a:	0001e697          	auipc	a3,0x1e
    8000565e:	36668693          	addi	a3,a3,870 # 800239c0 <disk>
    80005662:	00258713          	addi	a4,a1,2
    80005666:	0712                	slli	a4,a4,0x4
    80005668:	9736                	add	a4,a4,a3
    8000566a:	587d                	li	a6,-1
    8000566c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005670:	0612                	slli	a2,a2,0x4
    80005672:	9532                	add	a0,a0,a2
    80005674:	f9078793          	addi	a5,a5,-112
    80005678:	97b6                	add	a5,a5,a3
    8000567a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000567c:	629c                	ld	a5,0(a3)
    8000567e:	97b2                	add	a5,a5,a2
    80005680:	4605                	li	a2,1
    80005682:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005684:	4509                	li	a0,2
    80005686:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000568a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000568e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005692:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005696:	6698                	ld	a4,8(a3)
    80005698:	00275783          	lhu	a5,2(a4)
    8000569c:	8b9d                	andi	a5,a5,7
    8000569e:	0786                	slli	a5,a5,0x1
    800056a0:	97ba                	add	a5,a5,a4
    800056a2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056a6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056aa:	6698                	ld	a4,8(a3)
    800056ac:	00275783          	lhu	a5,2(a4)
    800056b0:	2785                	addiw	a5,a5,1
    800056b2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056b6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056ba:	100017b7          	lui	a5,0x10001
    800056be:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056c2:	004aa783          	lw	a5,4(s5)
    800056c6:	02c79163          	bne	a5,a2,800056e8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056ca:	0001e917          	auipc	s2,0x1e
    800056ce:	41e90913          	addi	s2,s2,1054 # 80023ae8 <disk+0x128>
  while(b->disk == 1) {
    800056d2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056d4:	85ca                	mv	a1,s2
    800056d6:	8556                	mv	a0,s5
    800056d8:	ffffc097          	auipc	ra,0xffffc
    800056dc:	e08080e7          	jalr	-504(ra) # 800014e0 <sleep>
  while(b->disk == 1) {
    800056e0:	004aa783          	lw	a5,4(s5)
    800056e4:	fe9788e3          	beq	a5,s1,800056d4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056e8:	f8042903          	lw	s2,-128(s0)
    800056ec:	00290793          	addi	a5,s2,2
    800056f0:	00479713          	slli	a4,a5,0x4
    800056f4:	0001e797          	auipc	a5,0x1e
    800056f8:	2cc78793          	addi	a5,a5,716 # 800239c0 <disk>
    800056fc:	97ba                	add	a5,a5,a4
    800056fe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005702:	0001e997          	auipc	s3,0x1e
    80005706:	2be98993          	addi	s3,s3,702 # 800239c0 <disk>
    8000570a:	00491713          	slli	a4,s2,0x4
    8000570e:	0009b783          	ld	a5,0(s3)
    80005712:	97ba                	add	a5,a5,a4
    80005714:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005718:	854a                	mv	a0,s2
    8000571a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	b98080e7          	jalr	-1128(ra) # 800052b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005726:	8885                	andi	s1,s1,1
    80005728:	f0ed                	bnez	s1,8000570a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000572a:	0001e517          	auipc	a0,0x1e
    8000572e:	3be50513          	addi	a0,a0,958 # 80023ae8 <disk+0x128>
    80005732:	00001097          	auipc	ra,0x1
    80005736:	bec080e7          	jalr	-1044(ra) # 8000631e <release>
}
    8000573a:	70e6                	ld	ra,120(sp)
    8000573c:	7446                	ld	s0,112(sp)
    8000573e:	74a6                	ld	s1,104(sp)
    80005740:	7906                	ld	s2,96(sp)
    80005742:	69e6                	ld	s3,88(sp)
    80005744:	6a46                	ld	s4,80(sp)
    80005746:	6aa6                	ld	s5,72(sp)
    80005748:	6b06                	ld	s6,64(sp)
    8000574a:	7be2                	ld	s7,56(sp)
    8000574c:	7c42                	ld	s8,48(sp)
    8000574e:	7ca2                	ld	s9,40(sp)
    80005750:	7d02                	ld	s10,32(sp)
    80005752:	6de2                	ld	s11,24(sp)
    80005754:	6109                	addi	sp,sp,128
    80005756:	8082                	ret

0000000080005758 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005758:	1101                	addi	sp,sp,-32
    8000575a:	ec06                	sd	ra,24(sp)
    8000575c:	e822                	sd	s0,16(sp)
    8000575e:	e426                	sd	s1,8(sp)
    80005760:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005762:	0001e497          	auipc	s1,0x1e
    80005766:	25e48493          	addi	s1,s1,606 # 800239c0 <disk>
    8000576a:	0001e517          	auipc	a0,0x1e
    8000576e:	37e50513          	addi	a0,a0,894 # 80023ae8 <disk+0x128>
    80005772:	00001097          	auipc	ra,0x1
    80005776:	af8080e7          	jalr	-1288(ra) # 8000626a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000577a:	10001737          	lui	a4,0x10001
    8000577e:	533c                	lw	a5,96(a4)
    80005780:	8b8d                	andi	a5,a5,3
    80005782:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005784:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005788:	689c                	ld	a5,16(s1)
    8000578a:	0204d703          	lhu	a4,32(s1)
    8000578e:	0027d783          	lhu	a5,2(a5)
    80005792:	04f70863          	beq	a4,a5,800057e2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005796:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000579a:	6898                	ld	a4,16(s1)
    8000579c:	0204d783          	lhu	a5,32(s1)
    800057a0:	8b9d                	andi	a5,a5,7
    800057a2:	078e                	slli	a5,a5,0x3
    800057a4:	97ba                	add	a5,a5,a4
    800057a6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057a8:	00278713          	addi	a4,a5,2
    800057ac:	0712                	slli	a4,a4,0x4
    800057ae:	9726                	add	a4,a4,s1
    800057b0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057b4:	e721                	bnez	a4,800057fc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057b6:	0789                	addi	a5,a5,2
    800057b8:	0792                	slli	a5,a5,0x4
    800057ba:	97a6                	add	a5,a5,s1
    800057bc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057be:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057c2:	ffffc097          	auipc	ra,0xffffc
    800057c6:	d82080e7          	jalr	-638(ra) # 80001544 <wakeup>

    disk.used_idx += 1;
    800057ca:	0204d783          	lhu	a5,32(s1)
    800057ce:	2785                	addiw	a5,a5,1
    800057d0:	17c2                	slli	a5,a5,0x30
    800057d2:	93c1                	srli	a5,a5,0x30
    800057d4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057d8:	6898                	ld	a4,16(s1)
    800057da:	00275703          	lhu	a4,2(a4)
    800057de:	faf71ce3          	bne	a4,a5,80005796 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057e2:	0001e517          	auipc	a0,0x1e
    800057e6:	30650513          	addi	a0,a0,774 # 80023ae8 <disk+0x128>
    800057ea:	00001097          	auipc	ra,0x1
    800057ee:	b34080e7          	jalr	-1228(ra) # 8000631e <release>
}
    800057f2:	60e2                	ld	ra,24(sp)
    800057f4:	6442                	ld	s0,16(sp)
    800057f6:	64a2                	ld	s1,8(sp)
    800057f8:	6105                	addi	sp,sp,32
    800057fa:	8082                	ret
      panic("virtio_disk_intr status");
    800057fc:	00003517          	auipc	a0,0x3
    80005800:	fb450513          	addi	a0,a0,-76 # 800087b0 <syscalls+0x3f0>
    80005804:	00000097          	auipc	ra,0x0
    80005808:	52a080e7          	jalr	1322(ra) # 80005d2e <panic>

000000008000580c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000580c:	1141                	addi	sp,sp,-16
    8000580e:	e422                	sd	s0,8(sp)
    80005810:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005812:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005816:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000581a:	0037979b          	slliw	a5,a5,0x3
    8000581e:	02004737          	lui	a4,0x2004
    80005822:	97ba                	add	a5,a5,a4
    80005824:	0200c737          	lui	a4,0x200c
    80005828:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000582c:	000f4637          	lui	a2,0xf4
    80005830:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005834:	95b2                	add	a1,a1,a2
    80005836:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005838:	00269713          	slli	a4,a3,0x2
    8000583c:	9736                	add	a4,a4,a3
    8000583e:	00371693          	slli	a3,a4,0x3
    80005842:	0001e717          	auipc	a4,0x1e
    80005846:	2be70713          	addi	a4,a4,702 # 80023b00 <timer_scratch>
    8000584a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000584c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000584e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005850:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005854:	00000797          	auipc	a5,0x0
    80005858:	99c78793          	addi	a5,a5,-1636 # 800051f0 <timervec>
    8000585c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005860:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005864:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005868:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000586c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005870:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005874:	30479073          	csrw	mie,a5
}
    80005878:	6422                	ld	s0,8(sp)
    8000587a:	0141                	addi	sp,sp,16
    8000587c:	8082                	ret

000000008000587e <start>:
{
    8000587e:	1141                	addi	sp,sp,-16
    80005880:	e406                	sd	ra,8(sp)
    80005882:	e022                	sd	s0,0(sp)
    80005884:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005886:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000588a:	7779                	lui	a4,0xffffe
    8000588c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd2abf>
    80005890:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005892:	6705                	lui	a4,0x1
    80005894:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005898:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000589a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000589e:	ffffb797          	auipc	a5,0xffffb
    800058a2:	a8078793          	addi	a5,a5,-1408 # 8000031e <main>
    800058a6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058aa:	4781                	li	a5,0
    800058ac:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058b0:	67c1                	lui	a5,0x10
    800058b2:	17fd                	addi	a5,a5,-1
    800058b4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058b8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058bc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058c0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058c4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058c8:	57fd                	li	a5,-1
    800058ca:	83a9                	srli	a5,a5,0xa
    800058cc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058d0:	47bd                	li	a5,15
    800058d2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058d6:	00000097          	auipc	ra,0x0
    800058da:	f36080e7          	jalr	-202(ra) # 8000580c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058de:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058e2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058e4:	823e                	mv	tp,a5
  asm volatile("mret");
    800058e6:	30200073          	mret
}
    800058ea:	60a2                	ld	ra,8(sp)
    800058ec:	6402                	ld	s0,0(sp)
    800058ee:	0141                	addi	sp,sp,16
    800058f0:	8082                	ret

00000000800058f2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058f2:	715d                	addi	sp,sp,-80
    800058f4:	e486                	sd	ra,72(sp)
    800058f6:	e0a2                	sd	s0,64(sp)
    800058f8:	fc26                	sd	s1,56(sp)
    800058fa:	f84a                	sd	s2,48(sp)
    800058fc:	f44e                	sd	s3,40(sp)
    800058fe:	f052                	sd	s4,32(sp)
    80005900:	ec56                	sd	s5,24(sp)
    80005902:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005904:	04c05663          	blez	a2,80005950 <consolewrite+0x5e>
    80005908:	8a2a                	mv	s4,a0
    8000590a:	84ae                	mv	s1,a1
    8000590c:	89b2                	mv	s3,a2
    8000590e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005910:	5afd                	li	s5,-1
    80005912:	4685                	li	a3,1
    80005914:	8626                	mv	a2,s1
    80005916:	85d2                	mv	a1,s4
    80005918:	fbf40513          	addi	a0,s0,-65
    8000591c:	ffffc097          	auipc	ra,0xffffc
    80005920:	022080e7          	jalr	34(ra) # 8000193e <either_copyin>
    80005924:	01550c63          	beq	a0,s5,8000593c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005928:	fbf44503          	lbu	a0,-65(s0)
    8000592c:	00000097          	auipc	ra,0x0
    80005930:	780080e7          	jalr	1920(ra) # 800060ac <uartputc>
  for(i = 0; i < n; i++){
    80005934:	2905                	addiw	s2,s2,1
    80005936:	0485                	addi	s1,s1,1
    80005938:	fd299de3          	bne	s3,s2,80005912 <consolewrite+0x20>
  }

  return i;
}
    8000593c:	854a                	mv	a0,s2
    8000593e:	60a6                	ld	ra,72(sp)
    80005940:	6406                	ld	s0,64(sp)
    80005942:	74e2                	ld	s1,56(sp)
    80005944:	7942                	ld	s2,48(sp)
    80005946:	79a2                	ld	s3,40(sp)
    80005948:	7a02                	ld	s4,32(sp)
    8000594a:	6ae2                	ld	s5,24(sp)
    8000594c:	6161                	addi	sp,sp,80
    8000594e:	8082                	ret
  for(i = 0; i < n; i++){
    80005950:	4901                	li	s2,0
    80005952:	b7ed                	j	8000593c <consolewrite+0x4a>

0000000080005954 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005954:	7159                	addi	sp,sp,-112
    80005956:	f486                	sd	ra,104(sp)
    80005958:	f0a2                	sd	s0,96(sp)
    8000595a:	eca6                	sd	s1,88(sp)
    8000595c:	e8ca                	sd	s2,80(sp)
    8000595e:	e4ce                	sd	s3,72(sp)
    80005960:	e0d2                	sd	s4,64(sp)
    80005962:	fc56                	sd	s5,56(sp)
    80005964:	f85a                	sd	s6,48(sp)
    80005966:	f45e                	sd	s7,40(sp)
    80005968:	f062                	sd	s8,32(sp)
    8000596a:	ec66                	sd	s9,24(sp)
    8000596c:	e86a                	sd	s10,16(sp)
    8000596e:	1880                	addi	s0,sp,112
    80005970:	8aaa                	mv	s5,a0
    80005972:	8a2e                	mv	s4,a1
    80005974:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005976:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000597a:	00026517          	auipc	a0,0x26
    8000597e:	2c650513          	addi	a0,a0,710 # 8002bc40 <cons>
    80005982:	00001097          	auipc	ra,0x1
    80005986:	8e8080e7          	jalr	-1816(ra) # 8000626a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000598a:	00026497          	auipc	s1,0x26
    8000598e:	2b648493          	addi	s1,s1,694 # 8002bc40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005992:	00026917          	auipc	s2,0x26
    80005996:	34690913          	addi	s2,s2,838 # 8002bcd8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000599a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000599c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000599e:	4ca9                	li	s9,10
  while(n > 0){
    800059a0:	07305b63          	blez	s3,80005a16 <consoleread+0xc2>
    while(cons.r == cons.w){
    800059a4:	0984a783          	lw	a5,152(s1)
    800059a8:	09c4a703          	lw	a4,156(s1)
    800059ac:	02f71763          	bne	a4,a5,800059da <consoleread+0x86>
      if(killed(myproc())){
    800059b0:	ffffb097          	auipc	ra,0xffffb
    800059b4:	488080e7          	jalr	1160(ra) # 80000e38 <myproc>
    800059b8:	ffffc097          	auipc	ra,0xffffc
    800059bc:	dd0080e7          	jalr	-560(ra) # 80001788 <killed>
    800059c0:	e535                	bnez	a0,80005a2c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059c2:	85a6                	mv	a1,s1
    800059c4:	854a                	mv	a0,s2
    800059c6:	ffffc097          	auipc	ra,0xffffc
    800059ca:	b1a080e7          	jalr	-1254(ra) # 800014e0 <sleep>
    while(cons.r == cons.w){
    800059ce:	0984a783          	lw	a5,152(s1)
    800059d2:	09c4a703          	lw	a4,156(s1)
    800059d6:	fcf70de3          	beq	a4,a5,800059b0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059da:	0017871b          	addiw	a4,a5,1
    800059de:	08e4ac23          	sw	a4,152(s1)
    800059e2:	07f7f713          	andi	a4,a5,127
    800059e6:	9726                	add	a4,a4,s1
    800059e8:	01874703          	lbu	a4,24(a4)
    800059ec:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800059f0:	077d0563          	beq	s10,s7,80005a5a <consoleread+0x106>
    cbuf = c;
    800059f4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059f8:	4685                	li	a3,1
    800059fa:	f9f40613          	addi	a2,s0,-97
    800059fe:	85d2                	mv	a1,s4
    80005a00:	8556                	mv	a0,s5
    80005a02:	ffffc097          	auipc	ra,0xffffc
    80005a06:	ee6080e7          	jalr	-282(ra) # 800018e8 <either_copyout>
    80005a0a:	01850663          	beq	a0,s8,80005a16 <consoleread+0xc2>
    dst++;
    80005a0e:	0a05                	addi	s4,s4,1
    --n;
    80005a10:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a12:	f99d17e3          	bne	s10,s9,800059a0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a16:	00026517          	auipc	a0,0x26
    80005a1a:	22a50513          	addi	a0,a0,554 # 8002bc40 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	900080e7          	jalr	-1792(ra) # 8000631e <release>

  return target - n;
    80005a26:	413b053b          	subw	a0,s6,s3
    80005a2a:	a811                	j	80005a3e <consoleread+0xea>
        release(&cons.lock);
    80005a2c:	00026517          	auipc	a0,0x26
    80005a30:	21450513          	addi	a0,a0,532 # 8002bc40 <cons>
    80005a34:	00001097          	auipc	ra,0x1
    80005a38:	8ea080e7          	jalr	-1814(ra) # 8000631e <release>
        return -1;
    80005a3c:	557d                	li	a0,-1
}
    80005a3e:	70a6                	ld	ra,104(sp)
    80005a40:	7406                	ld	s0,96(sp)
    80005a42:	64e6                	ld	s1,88(sp)
    80005a44:	6946                	ld	s2,80(sp)
    80005a46:	69a6                	ld	s3,72(sp)
    80005a48:	6a06                	ld	s4,64(sp)
    80005a4a:	7ae2                	ld	s5,56(sp)
    80005a4c:	7b42                	ld	s6,48(sp)
    80005a4e:	7ba2                	ld	s7,40(sp)
    80005a50:	7c02                	ld	s8,32(sp)
    80005a52:	6ce2                	ld	s9,24(sp)
    80005a54:	6d42                	ld	s10,16(sp)
    80005a56:	6165                	addi	sp,sp,112
    80005a58:	8082                	ret
      if(n < target){
    80005a5a:	0009871b          	sext.w	a4,s3
    80005a5e:	fb677ce3          	bgeu	a4,s6,80005a16 <consoleread+0xc2>
        cons.r--;
    80005a62:	00026717          	auipc	a4,0x26
    80005a66:	26f72b23          	sw	a5,630(a4) # 8002bcd8 <cons+0x98>
    80005a6a:	b775                	j	80005a16 <consoleread+0xc2>

0000000080005a6c <consputc>:
{
    80005a6c:	1141                	addi	sp,sp,-16
    80005a6e:	e406                	sd	ra,8(sp)
    80005a70:	e022                	sd	s0,0(sp)
    80005a72:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a74:	10000793          	li	a5,256
    80005a78:	00f50a63          	beq	a0,a5,80005a8c <consputc+0x20>
    uartputc_sync(c);
    80005a7c:	00000097          	auipc	ra,0x0
    80005a80:	55e080e7          	jalr	1374(ra) # 80005fda <uartputc_sync>
}
    80005a84:	60a2                	ld	ra,8(sp)
    80005a86:	6402                	ld	s0,0(sp)
    80005a88:	0141                	addi	sp,sp,16
    80005a8a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a8c:	4521                	li	a0,8
    80005a8e:	00000097          	auipc	ra,0x0
    80005a92:	54c080e7          	jalr	1356(ra) # 80005fda <uartputc_sync>
    80005a96:	02000513          	li	a0,32
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	540080e7          	jalr	1344(ra) # 80005fda <uartputc_sync>
    80005aa2:	4521                	li	a0,8
    80005aa4:	00000097          	auipc	ra,0x0
    80005aa8:	536080e7          	jalr	1334(ra) # 80005fda <uartputc_sync>
    80005aac:	bfe1                	j	80005a84 <consputc+0x18>

0000000080005aae <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005aae:	1101                	addi	sp,sp,-32
    80005ab0:	ec06                	sd	ra,24(sp)
    80005ab2:	e822                	sd	s0,16(sp)
    80005ab4:	e426                	sd	s1,8(sp)
    80005ab6:	e04a                	sd	s2,0(sp)
    80005ab8:	1000                	addi	s0,sp,32
    80005aba:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005abc:	00026517          	auipc	a0,0x26
    80005ac0:	18450513          	addi	a0,a0,388 # 8002bc40 <cons>
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	7a6080e7          	jalr	1958(ra) # 8000626a <acquire>

  switch(c){
    80005acc:	47d5                	li	a5,21
    80005ace:	0af48663          	beq	s1,a5,80005b7a <consoleintr+0xcc>
    80005ad2:	0297ca63          	blt	a5,s1,80005b06 <consoleintr+0x58>
    80005ad6:	47a1                	li	a5,8
    80005ad8:	0ef48763          	beq	s1,a5,80005bc6 <consoleintr+0x118>
    80005adc:	47c1                	li	a5,16
    80005ade:	10f49a63          	bne	s1,a5,80005bf2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	eb2080e7          	jalr	-334(ra) # 80001994 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005aea:	00026517          	auipc	a0,0x26
    80005aee:	15650513          	addi	a0,a0,342 # 8002bc40 <cons>
    80005af2:	00001097          	auipc	ra,0x1
    80005af6:	82c080e7          	jalr	-2004(ra) # 8000631e <release>
}
    80005afa:	60e2                	ld	ra,24(sp)
    80005afc:	6442                	ld	s0,16(sp)
    80005afe:	64a2                	ld	s1,8(sp)
    80005b00:	6902                	ld	s2,0(sp)
    80005b02:	6105                	addi	sp,sp,32
    80005b04:	8082                	ret
  switch(c){
    80005b06:	07f00793          	li	a5,127
    80005b0a:	0af48e63          	beq	s1,a5,80005bc6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b0e:	00026717          	auipc	a4,0x26
    80005b12:	13270713          	addi	a4,a4,306 # 8002bc40 <cons>
    80005b16:	0a072783          	lw	a5,160(a4)
    80005b1a:	09872703          	lw	a4,152(a4)
    80005b1e:	9f99                	subw	a5,a5,a4
    80005b20:	07f00713          	li	a4,127
    80005b24:	fcf763e3          	bltu	a4,a5,80005aea <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b28:	47b5                	li	a5,13
    80005b2a:	0cf48763          	beq	s1,a5,80005bf8 <consoleintr+0x14a>
      consputc(c);
    80005b2e:	8526                	mv	a0,s1
    80005b30:	00000097          	auipc	ra,0x0
    80005b34:	f3c080e7          	jalr	-196(ra) # 80005a6c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b38:	00026797          	auipc	a5,0x26
    80005b3c:	10878793          	addi	a5,a5,264 # 8002bc40 <cons>
    80005b40:	0a07a683          	lw	a3,160(a5)
    80005b44:	0016871b          	addiw	a4,a3,1
    80005b48:	0007061b          	sext.w	a2,a4
    80005b4c:	0ae7a023          	sw	a4,160(a5)
    80005b50:	07f6f693          	andi	a3,a3,127
    80005b54:	97b6                	add	a5,a5,a3
    80005b56:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b5a:	47a9                	li	a5,10
    80005b5c:	0cf48563          	beq	s1,a5,80005c26 <consoleintr+0x178>
    80005b60:	4791                	li	a5,4
    80005b62:	0cf48263          	beq	s1,a5,80005c26 <consoleintr+0x178>
    80005b66:	00026797          	auipc	a5,0x26
    80005b6a:	1727a783          	lw	a5,370(a5) # 8002bcd8 <cons+0x98>
    80005b6e:	9f1d                	subw	a4,a4,a5
    80005b70:	08000793          	li	a5,128
    80005b74:	f6f71be3          	bne	a4,a5,80005aea <consoleintr+0x3c>
    80005b78:	a07d                	j	80005c26 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b7a:	00026717          	auipc	a4,0x26
    80005b7e:	0c670713          	addi	a4,a4,198 # 8002bc40 <cons>
    80005b82:	0a072783          	lw	a5,160(a4)
    80005b86:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b8a:	00026497          	auipc	s1,0x26
    80005b8e:	0b648493          	addi	s1,s1,182 # 8002bc40 <cons>
    while(cons.e != cons.w &&
    80005b92:	4929                	li	s2,10
    80005b94:	f4f70be3          	beq	a4,a5,80005aea <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b98:	37fd                	addiw	a5,a5,-1
    80005b9a:	07f7f713          	andi	a4,a5,127
    80005b9e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ba0:	01874703          	lbu	a4,24(a4)
    80005ba4:	f52703e3          	beq	a4,s2,80005aea <consoleintr+0x3c>
      cons.e--;
    80005ba8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bac:	10000513          	li	a0,256
    80005bb0:	00000097          	auipc	ra,0x0
    80005bb4:	ebc080e7          	jalr	-324(ra) # 80005a6c <consputc>
    while(cons.e != cons.w &&
    80005bb8:	0a04a783          	lw	a5,160(s1)
    80005bbc:	09c4a703          	lw	a4,156(s1)
    80005bc0:	fcf71ce3          	bne	a4,a5,80005b98 <consoleintr+0xea>
    80005bc4:	b71d                	j	80005aea <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bc6:	00026717          	auipc	a4,0x26
    80005bca:	07a70713          	addi	a4,a4,122 # 8002bc40 <cons>
    80005bce:	0a072783          	lw	a5,160(a4)
    80005bd2:	09c72703          	lw	a4,156(a4)
    80005bd6:	f0f70ae3          	beq	a4,a5,80005aea <consoleintr+0x3c>
      cons.e--;
    80005bda:	37fd                	addiw	a5,a5,-1
    80005bdc:	00026717          	auipc	a4,0x26
    80005be0:	10f72223          	sw	a5,260(a4) # 8002bce0 <cons+0xa0>
      consputc(BACKSPACE);
    80005be4:	10000513          	li	a0,256
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	e84080e7          	jalr	-380(ra) # 80005a6c <consputc>
    80005bf0:	bded                	j	80005aea <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bf2:	ee048ce3          	beqz	s1,80005aea <consoleintr+0x3c>
    80005bf6:	bf21                	j	80005b0e <consoleintr+0x60>
      consputc(c);
    80005bf8:	4529                	li	a0,10
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	e72080e7          	jalr	-398(ra) # 80005a6c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c02:	00026797          	auipc	a5,0x26
    80005c06:	03e78793          	addi	a5,a5,62 # 8002bc40 <cons>
    80005c0a:	0a07a703          	lw	a4,160(a5)
    80005c0e:	0017069b          	addiw	a3,a4,1
    80005c12:	0006861b          	sext.w	a2,a3
    80005c16:	0ad7a023          	sw	a3,160(a5)
    80005c1a:	07f77713          	andi	a4,a4,127
    80005c1e:	97ba                	add	a5,a5,a4
    80005c20:	4729                	li	a4,10
    80005c22:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c26:	00026797          	auipc	a5,0x26
    80005c2a:	0ac7ab23          	sw	a2,182(a5) # 8002bcdc <cons+0x9c>
        wakeup(&cons.r);
    80005c2e:	00026517          	auipc	a0,0x26
    80005c32:	0aa50513          	addi	a0,a0,170 # 8002bcd8 <cons+0x98>
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	90e080e7          	jalr	-1778(ra) # 80001544 <wakeup>
    80005c3e:	b575                	j	80005aea <consoleintr+0x3c>

0000000080005c40 <consoleinit>:

void
consoleinit(void)
{
    80005c40:	1141                	addi	sp,sp,-16
    80005c42:	e406                	sd	ra,8(sp)
    80005c44:	e022                	sd	s0,0(sp)
    80005c46:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c48:	00003597          	auipc	a1,0x3
    80005c4c:	b8058593          	addi	a1,a1,-1152 # 800087c8 <syscalls+0x408>
    80005c50:	00026517          	auipc	a0,0x26
    80005c54:	ff050513          	addi	a0,a0,-16 # 8002bc40 <cons>
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	582080e7          	jalr	1410(ra) # 800061da <initlock>

  uartinit();
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	32a080e7          	jalr	810(ra) # 80005f8a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c68:	0001d797          	auipc	a5,0x1d
    80005c6c:	d0078793          	addi	a5,a5,-768 # 80022968 <devsw>
    80005c70:	00000717          	auipc	a4,0x0
    80005c74:	ce470713          	addi	a4,a4,-796 # 80005954 <consoleread>
    80005c78:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c7a:	00000717          	auipc	a4,0x0
    80005c7e:	c7870713          	addi	a4,a4,-904 # 800058f2 <consolewrite>
    80005c82:	ef98                	sd	a4,24(a5)
}
    80005c84:	60a2                	ld	ra,8(sp)
    80005c86:	6402                	ld	s0,0(sp)
    80005c88:	0141                	addi	sp,sp,16
    80005c8a:	8082                	ret

0000000080005c8c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c8c:	7179                	addi	sp,sp,-48
    80005c8e:	f406                	sd	ra,40(sp)
    80005c90:	f022                	sd	s0,32(sp)
    80005c92:	ec26                	sd	s1,24(sp)
    80005c94:	e84a                	sd	s2,16(sp)
    80005c96:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c98:	c219                	beqz	a2,80005c9e <printint+0x12>
    80005c9a:	08054663          	bltz	a0,80005d26 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c9e:	2501                	sext.w	a0,a0
    80005ca0:	4881                	li	a7,0
    80005ca2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ca6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ca8:	2581                	sext.w	a1,a1
    80005caa:	00003617          	auipc	a2,0x3
    80005cae:	b4e60613          	addi	a2,a2,-1202 # 800087f8 <digits>
    80005cb2:	883a                	mv	a6,a4
    80005cb4:	2705                	addiw	a4,a4,1
    80005cb6:	02b577bb          	remuw	a5,a0,a1
    80005cba:	1782                	slli	a5,a5,0x20
    80005cbc:	9381                	srli	a5,a5,0x20
    80005cbe:	97b2                	add	a5,a5,a2
    80005cc0:	0007c783          	lbu	a5,0(a5)
    80005cc4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cc8:	0005079b          	sext.w	a5,a0
    80005ccc:	02b5553b          	divuw	a0,a0,a1
    80005cd0:	0685                	addi	a3,a3,1
    80005cd2:	feb7f0e3          	bgeu	a5,a1,80005cb2 <printint+0x26>

  if(sign)
    80005cd6:	00088b63          	beqz	a7,80005cec <printint+0x60>
    buf[i++] = '-';
    80005cda:	fe040793          	addi	a5,s0,-32
    80005cde:	973e                	add	a4,a4,a5
    80005ce0:	02d00793          	li	a5,45
    80005ce4:	fef70823          	sb	a5,-16(a4)
    80005ce8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cec:	02e05763          	blez	a4,80005d1a <printint+0x8e>
    80005cf0:	fd040793          	addi	a5,s0,-48
    80005cf4:	00e784b3          	add	s1,a5,a4
    80005cf8:	fff78913          	addi	s2,a5,-1
    80005cfc:	993a                	add	s2,s2,a4
    80005cfe:	377d                	addiw	a4,a4,-1
    80005d00:	1702                	slli	a4,a4,0x20
    80005d02:	9301                	srli	a4,a4,0x20
    80005d04:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d08:	fff4c503          	lbu	a0,-1(s1)
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	d60080e7          	jalr	-672(ra) # 80005a6c <consputc>
  while(--i >= 0)
    80005d14:	14fd                	addi	s1,s1,-1
    80005d16:	ff2499e3          	bne	s1,s2,80005d08 <printint+0x7c>
}
    80005d1a:	70a2                	ld	ra,40(sp)
    80005d1c:	7402                	ld	s0,32(sp)
    80005d1e:	64e2                	ld	s1,24(sp)
    80005d20:	6942                	ld	s2,16(sp)
    80005d22:	6145                	addi	sp,sp,48
    80005d24:	8082                	ret
    x = -xx;
    80005d26:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d2a:	4885                	li	a7,1
    x = -xx;
    80005d2c:	bf9d                	j	80005ca2 <printint+0x16>

0000000080005d2e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d2e:	1101                	addi	sp,sp,-32
    80005d30:	ec06                	sd	ra,24(sp)
    80005d32:	e822                	sd	s0,16(sp)
    80005d34:	e426                	sd	s1,8(sp)
    80005d36:	1000                	addi	s0,sp,32
    80005d38:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d3a:	00026797          	auipc	a5,0x26
    80005d3e:	fc07a323          	sw	zero,-58(a5) # 8002bd00 <pr+0x18>
  printf("panic: ");
    80005d42:	00003517          	auipc	a0,0x3
    80005d46:	a8e50513          	addi	a0,a0,-1394 # 800087d0 <syscalls+0x410>
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	02e080e7          	jalr	46(ra) # 80005d78 <printf>
  printf(s);
    80005d52:	8526                	mv	a0,s1
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	024080e7          	jalr	36(ra) # 80005d78 <printf>
  printf("\n");
    80005d5c:	00002517          	auipc	a0,0x2
    80005d60:	2ec50513          	addi	a0,a0,748 # 80008048 <etext+0x48>
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	014080e7          	jalr	20(ra) # 80005d78 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d6c:	4785                	li	a5,1
    80005d6e:	00003717          	auipc	a4,0x3
    80005d72:	b4f72723          	sw	a5,-1202(a4) # 800088bc <panicked>
  for(;;)
    80005d76:	a001                	j	80005d76 <panic+0x48>

0000000080005d78 <printf>:
{
    80005d78:	7131                	addi	sp,sp,-192
    80005d7a:	fc86                	sd	ra,120(sp)
    80005d7c:	f8a2                	sd	s0,112(sp)
    80005d7e:	f4a6                	sd	s1,104(sp)
    80005d80:	f0ca                	sd	s2,96(sp)
    80005d82:	ecce                	sd	s3,88(sp)
    80005d84:	e8d2                	sd	s4,80(sp)
    80005d86:	e4d6                	sd	s5,72(sp)
    80005d88:	e0da                	sd	s6,64(sp)
    80005d8a:	fc5e                	sd	s7,56(sp)
    80005d8c:	f862                	sd	s8,48(sp)
    80005d8e:	f466                	sd	s9,40(sp)
    80005d90:	f06a                	sd	s10,32(sp)
    80005d92:	ec6e                	sd	s11,24(sp)
    80005d94:	0100                	addi	s0,sp,128
    80005d96:	8a2a                	mv	s4,a0
    80005d98:	e40c                	sd	a1,8(s0)
    80005d9a:	e810                	sd	a2,16(s0)
    80005d9c:	ec14                	sd	a3,24(s0)
    80005d9e:	f018                	sd	a4,32(s0)
    80005da0:	f41c                	sd	a5,40(s0)
    80005da2:	03043823          	sd	a6,48(s0)
    80005da6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005daa:	00026d97          	auipc	s11,0x26
    80005dae:	f56dad83          	lw	s11,-170(s11) # 8002bd00 <pr+0x18>
  if(locking)
    80005db2:	020d9b63          	bnez	s11,80005de8 <printf+0x70>
  if (fmt == 0)
    80005db6:	040a0263          	beqz	s4,80005dfa <printf+0x82>
  va_start(ap, fmt);
    80005dba:	00840793          	addi	a5,s0,8
    80005dbe:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dc2:	000a4503          	lbu	a0,0(s4)
    80005dc6:	14050f63          	beqz	a0,80005f24 <printf+0x1ac>
    80005dca:	4981                	li	s3,0
    if(c != '%'){
    80005dcc:	02500a93          	li	s5,37
    switch(c){
    80005dd0:	07000b93          	li	s7,112
  consputc('x');
    80005dd4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dd6:	00003b17          	auipc	s6,0x3
    80005dda:	a22b0b13          	addi	s6,s6,-1502 # 800087f8 <digits>
    switch(c){
    80005dde:	07300c93          	li	s9,115
    80005de2:	06400c13          	li	s8,100
    80005de6:	a82d                	j	80005e20 <printf+0xa8>
    acquire(&pr.lock);
    80005de8:	00026517          	auipc	a0,0x26
    80005dec:	f0050513          	addi	a0,a0,-256 # 8002bce8 <pr>
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	47a080e7          	jalr	1146(ra) # 8000626a <acquire>
    80005df8:	bf7d                	j	80005db6 <printf+0x3e>
    panic("null fmt");
    80005dfa:	00003517          	auipc	a0,0x3
    80005dfe:	9e650513          	addi	a0,a0,-1562 # 800087e0 <syscalls+0x420>
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	f2c080e7          	jalr	-212(ra) # 80005d2e <panic>
      consputc(c);
    80005e0a:	00000097          	auipc	ra,0x0
    80005e0e:	c62080e7          	jalr	-926(ra) # 80005a6c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e12:	2985                	addiw	s3,s3,1
    80005e14:	013a07b3          	add	a5,s4,s3
    80005e18:	0007c503          	lbu	a0,0(a5)
    80005e1c:	10050463          	beqz	a0,80005f24 <printf+0x1ac>
    if(c != '%'){
    80005e20:	ff5515e3          	bne	a0,s5,80005e0a <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e24:	2985                	addiw	s3,s3,1
    80005e26:	013a07b3          	add	a5,s4,s3
    80005e2a:	0007c783          	lbu	a5,0(a5)
    80005e2e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e32:	cbed                	beqz	a5,80005f24 <printf+0x1ac>
    switch(c){
    80005e34:	05778a63          	beq	a5,s7,80005e88 <printf+0x110>
    80005e38:	02fbf663          	bgeu	s7,a5,80005e64 <printf+0xec>
    80005e3c:	09978863          	beq	a5,s9,80005ecc <printf+0x154>
    80005e40:	07800713          	li	a4,120
    80005e44:	0ce79563          	bne	a5,a4,80005f0e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e48:	f8843783          	ld	a5,-120(s0)
    80005e4c:	00878713          	addi	a4,a5,8
    80005e50:	f8e43423          	sd	a4,-120(s0)
    80005e54:	4605                	li	a2,1
    80005e56:	85ea                	mv	a1,s10
    80005e58:	4388                	lw	a0,0(a5)
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	e32080e7          	jalr	-462(ra) # 80005c8c <printint>
      break;
    80005e62:	bf45                	j	80005e12 <printf+0x9a>
    switch(c){
    80005e64:	09578f63          	beq	a5,s5,80005f02 <printf+0x18a>
    80005e68:	0b879363          	bne	a5,s8,80005f0e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e6c:	f8843783          	ld	a5,-120(s0)
    80005e70:	00878713          	addi	a4,a5,8
    80005e74:	f8e43423          	sd	a4,-120(s0)
    80005e78:	4605                	li	a2,1
    80005e7a:	45a9                	li	a1,10
    80005e7c:	4388                	lw	a0,0(a5)
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	e0e080e7          	jalr	-498(ra) # 80005c8c <printint>
      break;
    80005e86:	b771                	j	80005e12 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e88:	f8843783          	ld	a5,-120(s0)
    80005e8c:	00878713          	addi	a4,a5,8
    80005e90:	f8e43423          	sd	a4,-120(s0)
    80005e94:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e98:	03000513          	li	a0,48
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	bd0080e7          	jalr	-1072(ra) # 80005a6c <consputc>
  consputc('x');
    80005ea4:	07800513          	li	a0,120
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	bc4080e7          	jalr	-1084(ra) # 80005a6c <consputc>
    80005eb0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eb2:	03c95793          	srli	a5,s2,0x3c
    80005eb6:	97da                	add	a5,a5,s6
    80005eb8:	0007c503          	lbu	a0,0(a5)
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	bb0080e7          	jalr	-1104(ra) # 80005a6c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ec4:	0912                	slli	s2,s2,0x4
    80005ec6:	34fd                	addiw	s1,s1,-1
    80005ec8:	f4ed                	bnez	s1,80005eb2 <printf+0x13a>
    80005eca:	b7a1                	j	80005e12 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ecc:	f8843783          	ld	a5,-120(s0)
    80005ed0:	00878713          	addi	a4,a5,8
    80005ed4:	f8e43423          	sd	a4,-120(s0)
    80005ed8:	6384                	ld	s1,0(a5)
    80005eda:	cc89                	beqz	s1,80005ef4 <printf+0x17c>
      for(; *s; s++)
    80005edc:	0004c503          	lbu	a0,0(s1)
    80005ee0:	d90d                	beqz	a0,80005e12 <printf+0x9a>
        consputc(*s);
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	b8a080e7          	jalr	-1142(ra) # 80005a6c <consputc>
      for(; *s; s++)
    80005eea:	0485                	addi	s1,s1,1
    80005eec:	0004c503          	lbu	a0,0(s1)
    80005ef0:	f96d                	bnez	a0,80005ee2 <printf+0x16a>
    80005ef2:	b705                	j	80005e12 <printf+0x9a>
        s = "(null)";
    80005ef4:	00003497          	auipc	s1,0x3
    80005ef8:	8e448493          	addi	s1,s1,-1820 # 800087d8 <syscalls+0x418>
      for(; *s; s++)
    80005efc:	02800513          	li	a0,40
    80005f00:	b7cd                	j	80005ee2 <printf+0x16a>
      consputc('%');
    80005f02:	8556                	mv	a0,s5
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	b68080e7          	jalr	-1176(ra) # 80005a6c <consputc>
      break;
    80005f0c:	b719                	j	80005e12 <printf+0x9a>
      consputc('%');
    80005f0e:	8556                	mv	a0,s5
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	b5c080e7          	jalr	-1188(ra) # 80005a6c <consputc>
      consputc(c);
    80005f18:	8526                	mv	a0,s1
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	b52080e7          	jalr	-1198(ra) # 80005a6c <consputc>
      break;
    80005f22:	bdc5                	j	80005e12 <printf+0x9a>
  if(locking)
    80005f24:	020d9163          	bnez	s11,80005f46 <printf+0x1ce>
}
    80005f28:	70e6                	ld	ra,120(sp)
    80005f2a:	7446                	ld	s0,112(sp)
    80005f2c:	74a6                	ld	s1,104(sp)
    80005f2e:	7906                	ld	s2,96(sp)
    80005f30:	69e6                	ld	s3,88(sp)
    80005f32:	6a46                	ld	s4,80(sp)
    80005f34:	6aa6                	ld	s5,72(sp)
    80005f36:	6b06                	ld	s6,64(sp)
    80005f38:	7be2                	ld	s7,56(sp)
    80005f3a:	7c42                	ld	s8,48(sp)
    80005f3c:	7ca2                	ld	s9,40(sp)
    80005f3e:	7d02                	ld	s10,32(sp)
    80005f40:	6de2                	ld	s11,24(sp)
    80005f42:	6129                	addi	sp,sp,192
    80005f44:	8082                	ret
    release(&pr.lock);
    80005f46:	00026517          	auipc	a0,0x26
    80005f4a:	da250513          	addi	a0,a0,-606 # 8002bce8 <pr>
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	3d0080e7          	jalr	976(ra) # 8000631e <release>
}
    80005f56:	bfc9                	j	80005f28 <printf+0x1b0>

0000000080005f58 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f58:	1101                	addi	sp,sp,-32
    80005f5a:	ec06                	sd	ra,24(sp)
    80005f5c:	e822                	sd	s0,16(sp)
    80005f5e:	e426                	sd	s1,8(sp)
    80005f60:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f62:	00026497          	auipc	s1,0x26
    80005f66:	d8648493          	addi	s1,s1,-634 # 8002bce8 <pr>
    80005f6a:	00003597          	auipc	a1,0x3
    80005f6e:	88658593          	addi	a1,a1,-1914 # 800087f0 <syscalls+0x430>
    80005f72:	8526                	mv	a0,s1
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	266080e7          	jalr	614(ra) # 800061da <initlock>
  pr.locking = 1;
    80005f7c:	4785                	li	a5,1
    80005f7e:	cc9c                	sw	a5,24(s1)
}
    80005f80:	60e2                	ld	ra,24(sp)
    80005f82:	6442                	ld	s0,16(sp)
    80005f84:	64a2                	ld	s1,8(sp)
    80005f86:	6105                	addi	sp,sp,32
    80005f88:	8082                	ret

0000000080005f8a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f8a:	1141                	addi	sp,sp,-16
    80005f8c:	e406                	sd	ra,8(sp)
    80005f8e:	e022                	sd	s0,0(sp)
    80005f90:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f92:	100007b7          	lui	a5,0x10000
    80005f96:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f9a:	f8000713          	li	a4,-128
    80005f9e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fa2:	470d                	li	a4,3
    80005fa4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fa8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fac:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fb0:	469d                	li	a3,7
    80005fb2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fb6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fba:	00003597          	auipc	a1,0x3
    80005fbe:	85658593          	addi	a1,a1,-1962 # 80008810 <digits+0x18>
    80005fc2:	00026517          	auipc	a0,0x26
    80005fc6:	d4650513          	addi	a0,a0,-698 # 8002bd08 <uart_tx_lock>
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	210080e7          	jalr	528(ra) # 800061da <initlock>
}
    80005fd2:	60a2                	ld	ra,8(sp)
    80005fd4:	6402                	ld	s0,0(sp)
    80005fd6:	0141                	addi	sp,sp,16
    80005fd8:	8082                	ret

0000000080005fda <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fda:	1101                	addi	sp,sp,-32
    80005fdc:	ec06                	sd	ra,24(sp)
    80005fde:	e822                	sd	s0,16(sp)
    80005fe0:	e426                	sd	s1,8(sp)
    80005fe2:	1000                	addi	s0,sp,32
    80005fe4:	84aa                	mv	s1,a0
  push_off();
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	238080e7          	jalr	568(ra) # 8000621e <push_off>

  if(panicked){
    80005fee:	00003797          	auipc	a5,0x3
    80005ff2:	8ce7a783          	lw	a5,-1842(a5) # 800088bc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ff6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005ffa:	c391                	beqz	a5,80005ffe <uartputc_sync+0x24>
    for(;;)
    80005ffc:	a001                	j	80005ffc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ffe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006002:	0207f793          	andi	a5,a5,32
    80006006:	dfe5                	beqz	a5,80005ffe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006008:	0ff4f513          	zext.b	a0,s1
    8000600c:	100007b7          	lui	a5,0x10000
    80006010:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006014:	00000097          	auipc	ra,0x0
    80006018:	2aa080e7          	jalr	682(ra) # 800062be <pop_off>
}
    8000601c:	60e2                	ld	ra,24(sp)
    8000601e:	6442                	ld	s0,16(sp)
    80006020:	64a2                	ld	s1,8(sp)
    80006022:	6105                	addi	sp,sp,32
    80006024:	8082                	ret

0000000080006026 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006026:	00003797          	auipc	a5,0x3
    8000602a:	89a7b783          	ld	a5,-1894(a5) # 800088c0 <uart_tx_r>
    8000602e:	00003717          	auipc	a4,0x3
    80006032:	89a73703          	ld	a4,-1894(a4) # 800088c8 <uart_tx_w>
    80006036:	06f70a63          	beq	a4,a5,800060aa <uartstart+0x84>
{
    8000603a:	7139                	addi	sp,sp,-64
    8000603c:	fc06                	sd	ra,56(sp)
    8000603e:	f822                	sd	s0,48(sp)
    80006040:	f426                	sd	s1,40(sp)
    80006042:	f04a                	sd	s2,32(sp)
    80006044:	ec4e                	sd	s3,24(sp)
    80006046:	e852                	sd	s4,16(sp)
    80006048:	e456                	sd	s5,8(sp)
    8000604a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000604c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006050:	00026a17          	auipc	s4,0x26
    80006054:	cb8a0a13          	addi	s4,s4,-840 # 8002bd08 <uart_tx_lock>
    uart_tx_r += 1;
    80006058:	00003497          	auipc	s1,0x3
    8000605c:	86848493          	addi	s1,s1,-1944 # 800088c0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006060:	00003997          	auipc	s3,0x3
    80006064:	86898993          	addi	s3,s3,-1944 # 800088c8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006068:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000606c:	02077713          	andi	a4,a4,32
    80006070:	c705                	beqz	a4,80006098 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006072:	01f7f713          	andi	a4,a5,31
    80006076:	9752                	add	a4,a4,s4
    80006078:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000607c:	0785                	addi	a5,a5,1
    8000607e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006080:	8526                	mv	a0,s1
    80006082:	ffffb097          	auipc	ra,0xffffb
    80006086:	4c2080e7          	jalr	1218(ra) # 80001544 <wakeup>
    
    WriteReg(THR, c);
    8000608a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000608e:	609c                	ld	a5,0(s1)
    80006090:	0009b703          	ld	a4,0(s3)
    80006094:	fcf71ae3          	bne	a4,a5,80006068 <uartstart+0x42>
  }
}
    80006098:	70e2                	ld	ra,56(sp)
    8000609a:	7442                	ld	s0,48(sp)
    8000609c:	74a2                	ld	s1,40(sp)
    8000609e:	7902                	ld	s2,32(sp)
    800060a0:	69e2                	ld	s3,24(sp)
    800060a2:	6a42                	ld	s4,16(sp)
    800060a4:	6aa2                	ld	s5,8(sp)
    800060a6:	6121                	addi	sp,sp,64
    800060a8:	8082                	ret
    800060aa:	8082                	ret

00000000800060ac <uartputc>:
{
    800060ac:	7179                	addi	sp,sp,-48
    800060ae:	f406                	sd	ra,40(sp)
    800060b0:	f022                	sd	s0,32(sp)
    800060b2:	ec26                	sd	s1,24(sp)
    800060b4:	e84a                	sd	s2,16(sp)
    800060b6:	e44e                	sd	s3,8(sp)
    800060b8:	e052                	sd	s4,0(sp)
    800060ba:	1800                	addi	s0,sp,48
    800060bc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060be:	00026517          	auipc	a0,0x26
    800060c2:	c4a50513          	addi	a0,a0,-950 # 8002bd08 <uart_tx_lock>
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	1a4080e7          	jalr	420(ra) # 8000626a <acquire>
  if(panicked){
    800060ce:	00002797          	auipc	a5,0x2
    800060d2:	7ee7a783          	lw	a5,2030(a5) # 800088bc <panicked>
    800060d6:	e7c9                	bnez	a5,80006160 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d8:	00002717          	auipc	a4,0x2
    800060dc:	7f073703          	ld	a4,2032(a4) # 800088c8 <uart_tx_w>
    800060e0:	00002797          	auipc	a5,0x2
    800060e4:	7e07b783          	ld	a5,2016(a5) # 800088c0 <uart_tx_r>
    800060e8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060ec:	00026997          	auipc	s3,0x26
    800060f0:	c1c98993          	addi	s3,s3,-996 # 8002bd08 <uart_tx_lock>
    800060f4:	00002497          	auipc	s1,0x2
    800060f8:	7cc48493          	addi	s1,s1,1996 # 800088c0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060fc:	00002917          	auipc	s2,0x2
    80006100:	7cc90913          	addi	s2,s2,1996 # 800088c8 <uart_tx_w>
    80006104:	00e79f63          	bne	a5,a4,80006122 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006108:	85ce                	mv	a1,s3
    8000610a:	8526                	mv	a0,s1
    8000610c:	ffffb097          	auipc	ra,0xffffb
    80006110:	3d4080e7          	jalr	980(ra) # 800014e0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006114:	00093703          	ld	a4,0(s2)
    80006118:	609c                	ld	a5,0(s1)
    8000611a:	02078793          	addi	a5,a5,32
    8000611e:	fee785e3          	beq	a5,a4,80006108 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006122:	00026497          	auipc	s1,0x26
    80006126:	be648493          	addi	s1,s1,-1050 # 8002bd08 <uart_tx_lock>
    8000612a:	01f77793          	andi	a5,a4,31
    8000612e:	97a6                	add	a5,a5,s1
    80006130:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006134:	0705                	addi	a4,a4,1
    80006136:	00002797          	auipc	a5,0x2
    8000613a:	78e7b923          	sd	a4,1938(a5) # 800088c8 <uart_tx_w>
  uartstart();
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	ee8080e7          	jalr	-280(ra) # 80006026 <uartstart>
  release(&uart_tx_lock);
    80006146:	8526                	mv	a0,s1
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	1d6080e7          	jalr	470(ra) # 8000631e <release>
}
    80006150:	70a2                	ld	ra,40(sp)
    80006152:	7402                	ld	s0,32(sp)
    80006154:	64e2                	ld	s1,24(sp)
    80006156:	6942                	ld	s2,16(sp)
    80006158:	69a2                	ld	s3,8(sp)
    8000615a:	6a02                	ld	s4,0(sp)
    8000615c:	6145                	addi	sp,sp,48
    8000615e:	8082                	ret
    for(;;)
    80006160:	a001                	j	80006160 <uartputc+0xb4>

0000000080006162 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006162:	1141                	addi	sp,sp,-16
    80006164:	e422                	sd	s0,8(sp)
    80006166:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006168:	100007b7          	lui	a5,0x10000
    8000616c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006170:	8b85                	andi	a5,a5,1
    80006172:	cb91                	beqz	a5,80006186 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006174:	100007b7          	lui	a5,0x10000
    80006178:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000617c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80006180:	6422                	ld	s0,8(sp)
    80006182:	0141                	addi	sp,sp,16
    80006184:	8082                	ret
    return -1;
    80006186:	557d                	li	a0,-1
    80006188:	bfe5                	j	80006180 <uartgetc+0x1e>

000000008000618a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000618a:	1101                	addi	sp,sp,-32
    8000618c:	ec06                	sd	ra,24(sp)
    8000618e:	e822                	sd	s0,16(sp)
    80006190:	e426                	sd	s1,8(sp)
    80006192:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006194:	54fd                	li	s1,-1
    80006196:	a029                	j	800061a0 <uartintr+0x16>
      break;
    consoleintr(c);
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	916080e7          	jalr	-1770(ra) # 80005aae <consoleintr>
    int c = uartgetc();
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	fc2080e7          	jalr	-62(ra) # 80006162 <uartgetc>
    if(c == -1)
    800061a8:	fe9518e3          	bne	a0,s1,80006198 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061ac:	00026497          	auipc	s1,0x26
    800061b0:	b5c48493          	addi	s1,s1,-1188 # 8002bd08 <uart_tx_lock>
    800061b4:	8526                	mv	a0,s1
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	0b4080e7          	jalr	180(ra) # 8000626a <acquire>
  uartstart();
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	e68080e7          	jalr	-408(ra) # 80006026 <uartstart>
  release(&uart_tx_lock);
    800061c6:	8526                	mv	a0,s1
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	156080e7          	jalr	342(ra) # 8000631e <release>
}
    800061d0:	60e2                	ld	ra,24(sp)
    800061d2:	6442                	ld	s0,16(sp)
    800061d4:	64a2                	ld	s1,8(sp)
    800061d6:	6105                	addi	sp,sp,32
    800061d8:	8082                	ret

00000000800061da <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061da:	1141                	addi	sp,sp,-16
    800061dc:	e422                	sd	s0,8(sp)
    800061de:	0800                	addi	s0,sp,16
  lk->name = name;
    800061e0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061e2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061e6:	00053823          	sd	zero,16(a0)
}
    800061ea:	6422                	ld	s0,8(sp)
    800061ec:	0141                	addi	sp,sp,16
    800061ee:	8082                	ret

00000000800061f0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061f0:	411c                	lw	a5,0(a0)
    800061f2:	e399                	bnez	a5,800061f8 <holding+0x8>
    800061f4:	4501                	li	a0,0
  return r;
}
    800061f6:	8082                	ret
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006202:	6904                	ld	s1,16(a0)
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	c18080e7          	jalr	-1000(ra) # 80000e1c <mycpu>
    8000620c:	40a48533          	sub	a0,s1,a0
    80006210:	00153513          	seqz	a0,a0
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	addi	sp,sp,32
    8000621c:	8082                	ret

000000008000621e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000621e:	1101                	addi	sp,sp,-32
    80006220:	ec06                	sd	ra,24(sp)
    80006222:	e822                	sd	s0,16(sp)
    80006224:	e426                	sd	s1,8(sp)
    80006226:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006228:	100024f3          	csrr	s1,sstatus
    8000622c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006230:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006232:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006236:	ffffb097          	auipc	ra,0xffffb
    8000623a:	be6080e7          	jalr	-1050(ra) # 80000e1c <mycpu>
    8000623e:	5d3c                	lw	a5,120(a0)
    80006240:	cf89                	beqz	a5,8000625a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	bda080e7          	jalr	-1062(ra) # 80000e1c <mycpu>
    8000624a:	5d3c                	lw	a5,120(a0)
    8000624c:	2785                	addiw	a5,a5,1
    8000624e:	dd3c                	sw	a5,120(a0)
}
    80006250:	60e2                	ld	ra,24(sp)
    80006252:	6442                	ld	s0,16(sp)
    80006254:	64a2                	ld	s1,8(sp)
    80006256:	6105                	addi	sp,sp,32
    80006258:	8082                	ret
    mycpu()->intena = old;
    8000625a:	ffffb097          	auipc	ra,0xffffb
    8000625e:	bc2080e7          	jalr	-1086(ra) # 80000e1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006262:	8085                	srli	s1,s1,0x1
    80006264:	8885                	andi	s1,s1,1
    80006266:	dd64                	sw	s1,124(a0)
    80006268:	bfe9                	j	80006242 <push_off+0x24>

000000008000626a <acquire>:
{
    8000626a:	1101                	addi	sp,sp,-32
    8000626c:	ec06                	sd	ra,24(sp)
    8000626e:	e822                	sd	s0,16(sp)
    80006270:	e426                	sd	s1,8(sp)
    80006272:	1000                	addi	s0,sp,32
    80006274:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	fa8080e7          	jalr	-88(ra) # 8000621e <push_off>
  if(holding(lk))
    8000627e:	8526                	mv	a0,s1
    80006280:	00000097          	auipc	ra,0x0
    80006284:	f70080e7          	jalr	-144(ra) # 800061f0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006288:	4705                	li	a4,1
  if(holding(lk))
    8000628a:	e115                	bnez	a0,800062ae <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000628c:	87ba                	mv	a5,a4
    8000628e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006292:	2781                	sext.w	a5,a5
    80006294:	ffe5                	bnez	a5,8000628c <acquire+0x22>
  __sync_synchronize();
    80006296:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000629a:	ffffb097          	auipc	ra,0xffffb
    8000629e:	b82080e7          	jalr	-1150(ra) # 80000e1c <mycpu>
    800062a2:	e888                	sd	a0,16(s1)
}
    800062a4:	60e2                	ld	ra,24(sp)
    800062a6:	6442                	ld	s0,16(sp)
    800062a8:	64a2                	ld	s1,8(sp)
    800062aa:	6105                	addi	sp,sp,32
    800062ac:	8082                	ret
    panic("acquire");
    800062ae:	00002517          	auipc	a0,0x2
    800062b2:	56a50513          	addi	a0,a0,1386 # 80008818 <digits+0x20>
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	a78080e7          	jalr	-1416(ra) # 80005d2e <panic>

00000000800062be <pop_off>:

void
pop_off(void)
{
    800062be:	1141                	addi	sp,sp,-16
    800062c0:	e406                	sd	ra,8(sp)
    800062c2:	e022                	sd	s0,0(sp)
    800062c4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062c6:	ffffb097          	auipc	ra,0xffffb
    800062ca:	b56080e7          	jalr	-1194(ra) # 80000e1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062d4:	e78d                	bnez	a5,800062fe <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062d6:	5d3c                	lw	a5,120(a0)
    800062d8:	02f05b63          	blez	a5,8000630e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062dc:	37fd                	addiw	a5,a5,-1
    800062de:	0007871b          	sext.w	a4,a5
    800062e2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062e4:	eb09                	bnez	a4,800062f6 <pop_off+0x38>
    800062e6:	5d7c                	lw	a5,124(a0)
    800062e8:	c799                	beqz	a5,800062f6 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ea:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062ee:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062f2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062f6:	60a2                	ld	ra,8(sp)
    800062f8:	6402                	ld	s0,0(sp)
    800062fa:	0141                	addi	sp,sp,16
    800062fc:	8082                	ret
    panic("pop_off - interruptible");
    800062fe:	00002517          	auipc	a0,0x2
    80006302:	52250513          	addi	a0,a0,1314 # 80008820 <digits+0x28>
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	a28080e7          	jalr	-1496(ra) # 80005d2e <panic>
    panic("pop_off");
    8000630e:	00002517          	auipc	a0,0x2
    80006312:	52a50513          	addi	a0,a0,1322 # 80008838 <digits+0x40>
    80006316:	00000097          	auipc	ra,0x0
    8000631a:	a18080e7          	jalr	-1512(ra) # 80005d2e <panic>

000000008000631e <release>:
{
    8000631e:	1101                	addi	sp,sp,-32
    80006320:	ec06                	sd	ra,24(sp)
    80006322:	e822                	sd	s0,16(sp)
    80006324:	e426                	sd	s1,8(sp)
    80006326:	1000                	addi	s0,sp,32
    80006328:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	ec6080e7          	jalr	-314(ra) # 800061f0 <holding>
    80006332:	c115                	beqz	a0,80006356 <release+0x38>
  lk->cpu = 0;
    80006334:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006338:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000633c:	0f50000f          	fence	iorw,ow
    80006340:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006344:	00000097          	auipc	ra,0x0
    80006348:	f7a080e7          	jalr	-134(ra) # 800062be <pop_off>
}
    8000634c:	60e2                	ld	ra,24(sp)
    8000634e:	6442                	ld	s0,16(sp)
    80006350:	64a2                	ld	s1,8(sp)
    80006352:	6105                	addi	sp,sp,32
    80006354:	8082                	ret
    panic("release");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	4ea50513          	addi	a0,a0,1258 # 80008840 <digits+0x48>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	9d0080e7          	jalr	-1584(ra) # 80005d2e <panic>
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
