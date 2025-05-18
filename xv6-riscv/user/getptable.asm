
user/_getptable:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define MAX_PROC 64

int
main()
{
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7f010413          	addi	s0,sp,2032
  1c:	dc010113          	addi	sp,sp,-576
  struct proc_info ptable[MAX_PROC];

  if(getptable(MAX_PROC, (struct proc_info*) ptable)) {
  20:	75fd                	lui	a1,0xfffff
  22:	5d058793          	addi	a5,a1,1488 # fffffffffffff5d0 <base+0xffffffffffffe5c0>
  26:	008785b3          	add	a1,a5,s0
  2a:	04000513          	li	a0,64
  2e:	38a000ef          	jal	3b8 <getptable>
  32:	c529                	beqz	a0,7c <main+0x7c>
    printf("PID\tPPID\tSTATE\tNAME\t\tSIZE\n");
  34:	00001517          	auipc	a0,0x1
  38:	8dc50513          	addi	a0,a0,-1828 # 910 <malloc+0x104>
  3c:	71c000ef          	jal	758 <printf>
    for(int i = 0; i < MAX_PROC; i++) {
  40:	74fd                	lui	s1,0xfffff
  42:	5dc48793          	addi	a5,s1,1500 # fffffffffffff5dc <base+0xffffffffffffe5cc>
  46:	008784b3          	add	s1,a5,s0
  4a:	fdc40913          	addi	s2,s0,-36
      if(ptable[i].pid != 0) {
        printf("%d\t%d\t%d\t%s\t\t%lu\n",
  4e:	00001997          	auipc	s3,0x1
  52:	8e298993          	addi	s3,s3,-1822 # 930 <malloc+0x124>
  56:	a029                	j	60 <main+0x60>
    for(int i = 0; i < MAX_PROC; i++) {
  58:	02848493          	addi	s1,s1,40
  5c:	03248663          	beq	s1,s2,88 <main+0x88>
      if(ptable[i].pid != 0) {
  60:	ff44a583          	lw	a1,-12(s1)
  64:	d9f5                	beqz	a1,58 <main+0x58>
        printf("%d\t%d\t%d\t%s\t\t%lu\n",
  66:	0144b783          	ld	a5,20(s1)
  6a:	8726                	mv	a4,s1
  6c:	ffc4a683          	lw	a3,-4(s1)
  70:	ff84a603          	lw	a2,-8(s1)
  74:	854e                	mv	a0,s3
  76:	6e2000ef          	jal	758 <printf>
  7a:	bff9                	j	58 <main+0x58>
    }
  }

  else
  {
    printf("getptable system call failed.\n");
  7c:	00001517          	auipc	a0,0x1
  80:	8cc50513          	addi	a0,a0,-1844 # 948 <malloc+0x13c>
  84:	6d4000ef          	jal	758 <printf>
  }

  exit(0);
  88:	4501                	li	a0,0
  8a:	26e000ef          	jal	2f8 <exit>

000000000000008e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	f6bff0ef          	jal	0 <main>
  exit(0);
  9a:	4501                	li	a0,0
  9c:	25c000ef          	jal	2f8 <exit>

00000000000000a0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a6:	87aa                	mv	a5,a0
  a8:	0585                	addi	a1,a1,1
  aa:	0785                	addi	a5,a5,1
  ac:	fff5c703          	lbu	a4,-1(a1)
  b0:	fee78fa3          	sb	a4,-1(a5)
  b4:	fb75                	bnez	a4,a8 <strcpy+0x8>
    ;
  return os;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cb91                	beqz	a5,da <strcmp+0x1e>
  c8:	0005c703          	lbu	a4,0(a1)
  cc:	00f71763          	bne	a4,a5,da <strcmp+0x1e>
    p++, q++;
  d0:	0505                	addi	a0,a0,1
  d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbe5                	bnez	a5,c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  da:	0005c503          	lbu	a0,0(a1)
}
  de:	40a7853b          	subw	a0,a5,a0
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strlen>:

uint
strlen(const char *s)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cf91                	beqz	a5,10e <strlen+0x26>
  f4:	0505                	addi	a0,a0,1
  f6:	87aa                	mv	a5,a0
  f8:	86be                	mv	a3,a5
  fa:	0785                	addi	a5,a5,1
  fc:	fff7c703          	lbu	a4,-1(a5)
 100:	ff65                	bnez	a4,f8 <strlen+0x10>
 102:	40a6853b          	subw	a0,a3,a0
 106:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  for(n = 0; s[n]; n++)
 10e:	4501                	li	a0,0
 110:	bfe5                	j	108 <strlen+0x20>

0000000000000112 <memset>:

void*
memset(void *dst, int c, uint n)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 118:	ca19                	beqz	a2,12e <memset+0x1c>
 11a:	87aa                	mv	a5,a0
 11c:	1602                	slli	a2,a2,0x20
 11e:	9201                	srli	a2,a2,0x20
 120:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 124:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 128:	0785                	addi	a5,a5,1
 12a:	fee79de3          	bne	a5,a4,124 <memset+0x12>
  }
  return dst;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb99                	beqz	a5,154 <strchr+0x20>
    if(*s == c)
 140:	00f58763          	beq	a1,a5,14e <strchr+0x1a>
  for(; *s; s++)
 144:	0505                	addi	a0,a0,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbfd                	bnez	a5,140 <strchr+0xc>
      return (char*)s;
  return 0;
 14c:	4501                	li	a0,0
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfe5                	j	14e <strchr+0x1a>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 176:	4aa9                	li	s5,10
 178:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17a:	89a6                	mv	s3,s1
 17c:	2485                	addiw	s1,s1,1
 17e:	0344d663          	bge	s1,s4,1aa <gets+0x52>
    cc = read(0, &c, 1);
 182:	4605                	li	a2,1
 184:	faf40593          	addi	a1,s0,-81
 188:	4501                	li	a0,0
 18a:	186000ef          	jal	310 <read>
    if(cc < 1)
 18e:	00a05e63          	blez	a0,1aa <gets+0x52>
    buf[i++] = c;
 192:	faf44783          	lbu	a5,-81(s0)
 196:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19a:	01578763          	beq	a5,s5,1a8 <gets+0x50>
 19e:	0905                	addi	s2,s2,1
 1a0:	fd679de3          	bne	a5,s6,17a <gets+0x22>
    buf[i++] = c;
 1a4:	89a6                	mv	s3,s1
 1a6:	a011                	j	1aa <gets+0x52>
 1a8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1aa:	99de                	add	s3,s3,s7
 1ac:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b0:	855e                	mv	a0,s7
 1b2:	60e6                	ld	ra,88(sp)
 1b4:	6446                	ld	s0,80(sp)
 1b6:	64a6                	ld	s1,72(sp)
 1b8:	6906                	ld	s2,64(sp)
 1ba:	79e2                	ld	s3,56(sp)
 1bc:	7a42                	ld	s4,48(sp)
 1be:	7aa2                	ld	s5,40(sp)
 1c0:	7b02                	ld	s6,32(sp)
 1c2:	6be2                	ld	s7,24(sp)
 1c4:	6125                	addi	sp,sp,96
 1c6:	8082                	ret

00000000000001c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	e04a                	sd	s2,0(sp)
 1d0:	1000                	addi	s0,sp,32
 1d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	4581                	li	a1,0
 1d6:	162000ef          	jal	338 <open>
  if(fd < 0)
 1da:	02054263          	bltz	a0,1fe <stat+0x36>
 1de:	e426                	sd	s1,8(sp)
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	16c000ef          	jal	350 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	134000ef          	jal	320 <close>
  return r;
 1f0:	64a2                	ld	s1,8(sp)
}
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfcd                	j	1f2 <stat+0x2a>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66863          	bltu	a2,a5,246 <atoi+0x44>
 21a:	872a                	mv	a4,a0
  n = 0;
 21c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1c>
  return n;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  n = 0;
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <atoi+0x3e>

000000000000024a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 250:	02b57463          	bgeu	a0,a1,278 <memmove+0x2e>
    while(n-- > 0)
 254:	00c05f63          	blez	a2,272 <memmove+0x28>
 258:	1602                	slli	a2,a2,0x20
 25a:	9201                	srli	a2,a2,0x20
 25c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 260:	872a                	mv	a4,a0
      *dst++ = *src++;
 262:	0585                	addi	a1,a1,1
 264:	0705                	addi	a4,a4,1
 266:	fff5c683          	lbu	a3,-1(a1)
 26a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26e:	fef71ae3          	bne	a4,a5,262 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
    dst += n;
 278:	00c50733          	add	a4,a0,a2
    src += n;
 27c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27e:	fec05ae3          	blez	a2,272 <memmove+0x28>
 282:	fff6079b          	addiw	a5,a2,-1
 286:	1782                	slli	a5,a5,0x20
 288:	9381                	srli	a5,a5,0x20
 28a:	fff7c793          	not	a5,a5
 28e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 290:	15fd                	addi	a1,a1,-1
 292:	177d                	addi	a4,a4,-1
 294:	0005c683          	lbu	a3,0(a1)
 298:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29c:	fee79ae3          	bne	a5,a4,290 <memmove+0x46>
 2a0:	bfc9                	j	272 <memmove+0x28>

00000000000002a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a8:	ca05                	beqz	a2,2d8 <memcmp+0x36>
 2aa:	fff6069b          	addiw	a3,a2,-1
 2ae:	1682                	slli	a3,a3,0x20
 2b0:	9281                	srli	a3,a3,0x20
 2b2:	0685                	addi	a3,a3,1
 2b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00e79863          	bne	a5,a4,2ce <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c2:	0505                	addi	a0,a0,1
    p2++;
 2c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c6:	fed518e3          	bne	a0,a3,2b6 <memcmp+0x14>
  }
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	a019                	j	2d2 <memcmp+0x30>
      return *p1 - *p2;
 2ce:	40e7853b          	subw	a0,a5,a4
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  return 0;
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <memcmp+0x30>

00000000000002dc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e4:	f67ff0ef          	jal	24a <memmove>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f0:	4885                	li	a7,1
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f8:	4889                	li	a7,2
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <wait>:
.global wait
wait:
 li a7, SYS_wait
 300:	488d                	li	a7,3
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 308:	4891                	li	a7,4
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <read>:
.global read
read:
 li a7, SYS_read
 310:	4895                	li	a7,5
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <write>:
.global write
write:
 li a7, SYS_write
 318:	48c1                	li	a7,16
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <close>:
.global close
close:
 li a7, SYS_close
 320:	48d5                	li	a7,21
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <kill>:
.global kill
kill:
 li a7, SYS_kill
 328:	4899                	li	a7,6
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <exec>:
.global exec
exec:
 li a7, SYS_exec
 330:	489d                	li	a7,7
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <open>:
.global open
open:
 li a7, SYS_open
 338:	48bd                	li	a7,15
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 340:	48c5                	li	a7,17
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 348:	48c9                	li	a7,18
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 350:	48a1                	li	a7,8
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <link>:
.global link
link:
 li a7, SYS_link
 358:	48cd                	li	a7,19
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 360:	48d1                	li	a7,20
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 368:	48a5                	li	a7,9
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <dup>:
.global dup
dup:
 li a7, SYS_dup
 370:	48a9                	li	a7,10
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 378:	48ad                	li	a7,11
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 380:	48b1                	li	a7,12
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 388:	48b5                	li	a7,13
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 390:	48b9                	li	a7,14
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 398:	48d9                	li	a7,22
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3a0:	48dd                	li	a7,23
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3a8:	48e1                	li	a7,24
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3b0:	48e5                	li	a7,25
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3b8:	48e9                	li	a7,26
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 3c0:	48ed                	li	a7,27
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 3c8:	48f1                	li	a7,28
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 3d0:	48f5                	li	a7,29
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3d8:	48f9                	li	a7,30
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	f27ff0ef          	jal	318 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	addi	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	7139                	addi	sp,sp,-64
 400:	fc06                	sd	ra,56(sp)
 402:	f822                	sd	s0,48(sp)
 404:	f426                	sd	s1,40(sp)
 406:	0080                	addi	s0,sp,64
 408:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40a:	c299                	beqz	a3,410 <printint+0x12>
 40c:	0805c963          	bltz	a1,49e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 410:	2581                	sext.w	a1,a1
  neg = 0;
 412:	4881                	li	a7,0
 414:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 418:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41a:	2601                	sext.w	a2,a2
 41c:	00000517          	auipc	a0,0x0
 420:	55450513          	addi	a0,a0,1364 # 970 <digits>
 424:	883a                	mv	a6,a4
 426:	2705                	addiw	a4,a4,1
 428:	02c5f7bb          	remuw	a5,a1,a2
 42c:	1782                	slli	a5,a5,0x20
 42e:	9381                	srli	a5,a5,0x20
 430:	97aa                	add	a5,a5,a0
 432:	0007c783          	lbu	a5,0(a5)
 436:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43a:	0005879b          	sext.w	a5,a1
 43e:	02c5d5bb          	divuw	a1,a1,a2
 442:	0685                	addi	a3,a3,1
 444:	fec7f0e3          	bgeu	a5,a2,424 <printint+0x26>
  if(neg)
 448:	00088c63          	beqz	a7,460 <printint+0x62>
    buf[i++] = '-';
 44c:	fd070793          	addi	a5,a4,-48
 450:	00878733          	add	a4,a5,s0
 454:	02d00793          	li	a5,45
 458:	fef70823          	sb	a5,-16(a4)
 45c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 460:	02e05a63          	blez	a4,494 <printint+0x96>
 464:	f04a                	sd	s2,32(sp)
 466:	ec4e                	sd	s3,24(sp)
 468:	fc040793          	addi	a5,s0,-64
 46c:	00e78933          	add	s2,a5,a4
 470:	fff78993          	addi	s3,a5,-1
 474:	99ba                	add	s3,s3,a4
 476:	377d                	addiw	a4,a4,-1
 478:	1702                	slli	a4,a4,0x20
 47a:	9301                	srli	a4,a4,0x20
 47c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 480:	fff94583          	lbu	a1,-1(s2)
 484:	8526                	mv	a0,s1
 486:	f5bff0ef          	jal	3e0 <putc>
  while(--i >= 0)
 48a:	197d                	addi	s2,s2,-1
 48c:	ff391ae3          	bne	s2,s3,480 <printint+0x82>
 490:	7902                	ld	s2,32(sp)
 492:	69e2                	ld	s3,24(sp)
}
 494:	70e2                	ld	ra,56(sp)
 496:	7442                	ld	s0,48(sp)
 498:	74a2                	ld	s1,40(sp)
 49a:	6121                	addi	sp,sp,64
 49c:	8082                	ret
    x = -xx;
 49e:	40b005bb          	negw	a1,a1
    neg = 1;
 4a2:	4885                	li	a7,1
    x = -xx;
 4a4:	bf85                	j	414 <printint+0x16>

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	711d                	addi	sp,sp,-96
 4a8:	ec86                	sd	ra,88(sp)
 4aa:	e8a2                	sd	s0,80(sp)
 4ac:	e0ca                	sd	s2,64(sp)
 4ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b0:	0005c903          	lbu	s2,0(a1)
 4b4:	26090863          	beqz	s2,724 <vprintf+0x27e>
 4b8:	e4a6                	sd	s1,72(sp)
 4ba:	fc4e                	sd	s3,56(sp)
 4bc:	f852                	sd	s4,48(sp)
 4be:	f456                	sd	s5,40(sp)
 4c0:	f05a                	sd	s6,32(sp)
 4c2:	ec5e                	sd	s7,24(sp)
 4c4:	e862                	sd	s8,16(sp)
 4c6:	e466                	sd	s9,8(sp)
 4c8:	8b2a                	mv	s6,a0
 4ca:	8a2e                	mv	s4,a1
 4cc:	8bb2                	mv	s7,a2
  state = 0;
 4ce:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d0:	4481                	li	s1,0
 4d2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4dc:	06c00c93          	li	s9,108
 4e0:	a005                	j	500 <vprintf+0x5a>
        putc(fd, c0);
 4e2:	85ca                	mv	a1,s2
 4e4:	855a                	mv	a0,s6
 4e6:	efbff0ef          	jal	3e0 <putc>
 4ea:	a019                	j	4f0 <vprintf+0x4a>
    } else if(state == '%'){
 4ec:	03598263          	beq	s3,s5,510 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4f0:	2485                	addiw	s1,s1,1
 4f2:	8726                	mv	a4,s1
 4f4:	009a07b3          	add	a5,s4,s1
 4f8:	0007c903          	lbu	s2,0(a5)
 4fc:	20090c63          	beqz	s2,714 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 500:	0009079b          	sext.w	a5,s2
    if(state == 0){
 504:	fe0994e3          	bnez	s3,4ec <vprintf+0x46>
      if(c0 == '%'){
 508:	fd579de3          	bne	a5,s5,4e2 <vprintf+0x3c>
        state = '%';
 50c:	89be                	mv	s3,a5
 50e:	b7cd                	j	4f0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 510:	00ea06b3          	add	a3,s4,a4
 514:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 518:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 51a:	c681                	beqz	a3,522 <vprintf+0x7c>
 51c:	9752                	add	a4,a4,s4
 51e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 522:	03878f63          	beq	a5,s8,560 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 526:	05978963          	beq	a5,s9,578 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 52a:	07500713          	li	a4,117
 52e:	0ee78363          	beq	a5,a4,614 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 532:	07800713          	li	a4,120
 536:	12e78563          	beq	a5,a4,660 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 53a:	07000713          	li	a4,112
 53e:	14e78a63          	beq	a5,a4,692 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 542:	07300713          	li	a4,115
 546:	18e78a63          	beq	a5,a4,6da <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 54a:	02500713          	li	a4,37
 54e:	04e79563          	bne	a5,a4,598 <vprintf+0xf2>
        putc(fd, '%');
 552:	02500593          	li	a1,37
 556:	855a                	mv	a0,s6
 558:	e89ff0ef          	jal	3e0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 55c:	4981                	li	s3,0
 55e:	bf49                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8913          	addi	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e91ff0ef          	jal	3fe <printint>
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
 576:	bfad                	j	4f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 578:	06400793          	li	a5,100
 57c:	02f68963          	beq	a3,a5,5ae <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 580:	06c00793          	li	a5,108
 584:	04f68263          	beq	a3,a5,5c8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 588:	07500793          	li	a5,117
 58c:	0af68063          	beq	a3,a5,62c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 590:	07800793          	li	a5,120
 594:	0ef68263          	beq	a3,a5,678 <vprintf+0x1d2>
        putc(fd, '%');
 598:	02500593          	li	a1,37
 59c:	855a                	mv	a0,s6
 59e:	e43ff0ef          	jal	3e0 <putc>
        putc(fd, c0);
 5a2:	85ca                	mv	a1,s2
 5a4:	855a                	mv	a0,s6
 5a6:	e3bff0ef          	jal	3e0 <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b791                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e43ff0ef          	jal	3fe <printint>
        i += 1;
 5c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 1;
 5c6:	b72d                	j	4f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c8:	06400793          	li	a5,100
 5cc:	02f60763          	beq	a2,a5,5fa <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d0:	07500793          	li	a5,117
 5d4:	06f60963          	beq	a2,a5,646 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d8:	07800793          	li	a5,120
 5dc:	faf61ee3          	bne	a2,a5,598 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e11ff0ef          	jal	3fe <printint>
        i += 2;
 5f2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	bde5                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	df7ff0ef          	jal	3fe <printint>
        i += 2;
 60c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	bdf9                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 614:	008b8913          	addi	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dddff0ef          	jal	3fe <printint>
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	b5d9                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	dc5ff0ef          	jal	3fe <printint>
        i += 1;
 63e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
        i += 1;
 644:	b575                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 646:	008b8913          	addi	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	dabff0ef          	jal	3fe <printint>
        i += 2;
 658:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bd49                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 660:	008b8913          	addi	s2,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000ba583          	lw	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d91ff0ef          	jal	3fe <printint>
 672:	8bca                	mv	s7,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	bdad                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	008b8913          	addi	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d79ff0ef          	jal	3fe <printint>
        i += 1;
 68a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 1;
 690:	b585                	j	4f0 <vprintf+0x4a>
 692:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 694:	008b8d13          	addi	s10,s7,8
 698:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69c:	03000593          	li	a1,48
 6a0:	855a                	mv	a0,s6
 6a2:	d3fff0ef          	jal	3e0 <putc>
  putc(fd, 'x');
 6a6:	07800593          	li	a1,120
 6aa:	855a                	mv	a0,s6
 6ac:	d35ff0ef          	jal	3e0 <putc>
 6b0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b2:	00000b97          	auipc	s7,0x0
 6b6:	2beb8b93          	addi	s7,s7,702 # 970 <digits>
 6ba:	03c9d793          	srli	a5,s3,0x3c
 6be:	97de                	add	a5,a5,s7
 6c0:	0007c583          	lbu	a1,0(a5)
 6c4:	855a                	mv	a0,s6
 6c6:	d1bff0ef          	jal	3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ca:	0992                	slli	s3,s3,0x4
 6cc:	397d                	addiw	s2,s2,-1
 6ce:	fe0916e3          	bnez	s2,6ba <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6d2:	8bea                	mv	s7,s10
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	6d02                	ld	s10,0(sp)
 6d8:	bd21                	j	4f0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6da:	008b8993          	addi	s3,s7,8
 6de:	000bb903          	ld	s2,0(s7)
 6e2:	00090f63          	beqz	s2,700 <vprintf+0x25a>
        for(; *s; s++)
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	c195                	beqz	a1,70e <vprintf+0x268>
          putc(fd, *s);
 6ec:	855a                	mv	a0,s6
 6ee:	cf3ff0ef          	jal	3e0 <putc>
        for(; *s; s++)
 6f2:	0905                	addi	s2,s2,1
 6f4:	00094583          	lbu	a1,0(s2)
 6f8:	f9f5                	bnez	a1,6ec <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bbcd                	j	4f0 <vprintf+0x4a>
          s = "(null)";
 700:	00000917          	auipc	s2,0x0
 704:	26890913          	addi	s2,s2,616 # 968 <malloc+0x15c>
        for(; *s; s++)
 708:	02800593          	li	a1,40
 70c:	b7c5                	j	6ec <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 70e:	8bce                	mv	s7,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	bbf9                	j	4f0 <vprintf+0x4a>
 714:	64a6                	ld	s1,72(sp)
 716:	79e2                	ld	s3,56(sp)
 718:	7a42                	ld	s4,48(sp)
 71a:	7aa2                	ld	s5,40(sp)
 71c:	7b02                	ld	s6,32(sp)
 71e:	6be2                	ld	s7,24(sp)
 720:	6c42                	ld	s8,16(sp)
 722:	6ca2                	ld	s9,8(sp)
    }
  }
}
 724:	60e6                	ld	ra,88(sp)
 726:	6446                	ld	s0,80(sp)
 728:	6906                	ld	s2,64(sp)
 72a:	6125                	addi	sp,sp,96
 72c:	8082                	ret

000000000000072e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72e:	715d                	addi	sp,sp,-80
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e010                	sd	a2,0(s0)
 738:	e414                	sd	a3,8(s0)
 73a:	e818                	sd	a4,16(s0)
 73c:	ec1c                	sd	a5,24(s0)
 73e:	03043023          	sd	a6,32(s0)
 742:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74a:	8622                	mv	a2,s0
 74c:	d5bff0ef          	jal	4a6 <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6161                	addi	sp,sp,80
 756:	8082                	ret

0000000000000758 <printf>:

void
printf(const char *fmt, ...)
{
 758:	711d                	addi	sp,sp,-96
 75a:	ec06                	sd	ra,24(sp)
 75c:	e822                	sd	s0,16(sp)
 75e:	1000                	addi	s0,sp,32
 760:	e40c                	sd	a1,8(s0)
 762:	e810                	sd	a2,16(s0)
 764:	ec14                	sd	a3,24(s0)
 766:	f018                	sd	a4,32(s0)
 768:	f41c                	sd	a5,40(s0)
 76a:	03043823          	sd	a6,48(s0)
 76e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	00840613          	addi	a2,s0,8
 776:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77a:	85aa                	mv	a1,a0
 77c:	4505                	li	a0,1
 77e:	d29ff0ef          	jal	4a6 <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78a:	1141                	addi	sp,sp,-16
 78c:	e422                	sd	s0,8(sp)
 78e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 790:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	00001797          	auipc	a5,0x1
 798:	86c7b783          	ld	a5,-1940(a5) # 1000 <freep>
 79c:	a02d                	j	7c6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79e:	4618                	lw	a4,8(a2)
 7a0:	9f2d                	addw	a4,a4,a1
 7a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	6310                	ld	a2,0(a4)
 7aa:	a83d                	j	7e8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ac:	ff852703          	lw	a4,-8(a0)
 7b0:	9f31                	addw	a4,a4,a2
 7b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b4:	ff053683          	ld	a3,-16(a0)
 7b8:	a091                	j	7fc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x3a>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x4a>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x30>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60de3          	beq	a2,a4,79e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae68ae3          	beq	a3,a4,7ac <free+0x22>
    p->s.ptr = bp->s.ptr;
 7fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	ec4e                	sd	s3,24(sp)
 816:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	02051493          	slli	s1,a0,0x20
 81c:	9081                	srli	s1,s1,0x20
 81e:	04bd                	addi	s1,s1,15
 820:	8091                	srli	s1,s1,0x4
 822:	0014899b          	addiw	s3,s1,1
 826:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 828:	00000517          	auipc	a0,0x0
 82c:	7d853503          	ld	a0,2008(a0) # 1000 <freep>
 830:	c915                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	08977a63          	bgeu	a4,s1,8ca <malloc+0xbe>
 83a:	f04a                	sd	s2,32(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00000917          	auipc	s2,0x0
 85c:	7a890913          	addi	s2,s2,1960 # 1000 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a081                	j	8a2 <malloc+0x96>
 864:	f04a                	sd	s2,32(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86c:	00000797          	auipc	a5,0x0
 870:	7a478793          	addi	a5,a5,1956 # 1010 <base>
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
 87c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 882:	b7c1                	j	842 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	a8a9                	j	8e2 <malloc+0xd6>
  hp->s.size = nu;
 88a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	efbff0ef          	jal	78a <free>
  return freep;
 894:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 898:	c12d                	beqz	a0,8fa <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	02977263          	bgeu	a4,s1,8c2 <malloc+0xb6>
    if(p == freep)
 8a2:	00093703          	ld	a4,0(s2)
 8a6:	853e                	mv	a0,a5
 8a8:	fef719e3          	bne	a4,a5,89a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8ac:	8552                	mv	a0,s4
 8ae:	ad3ff0ef          	jal	380 <sbrk>
  if(p == (char*)-1)
 8b2:	fd551ce3          	bne	a0,s5,88a <malloc+0x7e>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	7902                	ld	s2,32(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	a03d                	j	8ee <malloc+0xe2>
 8c2:	7902                	ld	s2,32(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ca:	fae48de3          	beq	s1,a4,884 <malloc+0x78>
        p->s.size -= nunits;
 8ce:	4137073b          	subw	a4,a4,s3
 8d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d4:	02071693          	slli	a3,a4,0x20
 8d8:	01c6d713          	srli	a4,a3,0x1c
 8dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70a73f23          	sd	a0,1822(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ea:	01078513          	addi	a0,a5,16
  }
}
 8ee:	70e2                	ld	ra,56(sp)
 8f0:	7442                	ld	s0,48(sp)
 8f2:	74a2                	ld	s1,40(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6121                	addi	sp,sp,64
 8f8:	8082                	ret
 8fa:	7902                	ld	s2,32(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	b7f5                	j	8ee <malloc+0xe2>
