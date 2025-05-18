
user/_getppid:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  int ppid = getppid();
   a:	33a000ef          	jal	344 <getppid>
   e:	84aa                	mv	s1,a0
  int pid = getpid();
  10:	304000ef          	jal	314 <getpid>
  14:	85aa                	mv	a1,a0
  printf("My PID: %d, My PPID: %d\n", pid, ppid);
  16:	8626                	mv	a2,s1
  18:	00001517          	auipc	a0,0x1
  1c:	88850513          	addi	a0,a0,-1912 # 8a0 <malloc+0xf8>
  20:	6d4000ef          	jal	6f4 <printf>
  exit(0);
  24:	4501                	li	a0,0
  26:	26e000ef          	jal	294 <exit>

000000000000002a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	fcfff0ef          	jal	0 <main>
  exit(0);
  36:	4501                	li	a0,0
  38:	25c000ef          	jal	294 <exit>

000000000000003c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  42:	87aa                	mv	a5,a0
  44:	0585                	addi	a1,a1,1
  46:	0785                	addi	a5,a5,1
  48:	fff5c703          	lbu	a4,-1(a1)
  4c:	fee78fa3          	sb	a4,-1(a5)
  50:	fb75                	bnez	a4,44 <strcpy+0x8>
    ;
  return os;
}
  52:	6422                	ld	s0,8(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret

0000000000000058 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  58:	1141                	addi	sp,sp,-16
  5a:	e422                	sd	s0,8(sp)
  5c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x1e>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x1e>
    p++, q++;
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  76:	0005c503          	lbu	a0,0(a1)
}
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cf91                	beqz	a5,aa <strlen+0x26>
  90:	0505                	addi	a0,a0,1
  92:	87aa                	mv	a5,a0
  94:	86be                	mv	a3,a5
  96:	0785                	addi	a5,a5,1
  98:	fff7c703          	lbu	a4,-1(a5)
  9c:	ff65                	bnez	a4,94 <strlen+0x10>
  9e:	40a6853b          	subw	a0,a3,a0
  a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfe5                	j	a4 <strlen+0x20>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1c>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x12>
  }
  return dst;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d6:	00054783          	lbu	a5,0(a0)
  da:	cb99                	beqz	a5,f0 <strchr+0x20>
    if(*s == c)
  dc:	00f58763          	beq	a1,a5,ea <strchr+0x1a>
  for(; *s; s++)
  e0:	0505                	addi	a0,a0,1
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbfd                	bnez	a5,dc <strchr+0xc>
      return (char*)s;
  return 0;
  e8:	4501                	li	a0,0
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  return 0;
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strchr+0x1a>

00000000000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4aa9                	li	s5,10
 114:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 116:	89a6                	mv	s3,s1
 118:	2485                	addiw	s1,s1,1
 11a:	0344d663          	bge	s1,s4,146 <gets+0x52>
    cc = read(0, &c, 1);
 11e:	4605                	li	a2,1
 120:	faf40593          	addi	a1,s0,-81
 124:	4501                	li	a0,0
 126:	186000ef          	jal	2ac <read>
    if(cc < 1)
 12a:	00a05e63          	blez	a0,146 <gets+0x52>
    buf[i++] = c;
 12e:	faf44783          	lbu	a5,-81(s0)
 132:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 136:	01578763          	beq	a5,s5,144 <gets+0x50>
 13a:	0905                	addi	s2,s2,1
 13c:	fd679de3          	bne	a5,s6,116 <gets+0x22>
    buf[i++] = c;
 140:	89a6                	mv	s3,s1
 142:	a011                	j	146 <gets+0x52>
 144:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 146:	99de                	add	s3,s3,s7
 148:	00098023          	sb	zero,0(s3)
  return buf;
}
 14c:	855e                	mv	a0,s7
 14e:	60e6                	ld	ra,88(sp)
 150:	6446                	ld	s0,80(sp)
 152:	64a6                	ld	s1,72(sp)
 154:	6906                	ld	s2,64(sp)
 156:	79e2                	ld	s3,56(sp)
 158:	7a42                	ld	s4,48(sp)
 15a:	7aa2                	ld	s5,40(sp)
 15c:	7b02                	ld	s6,32(sp)
 15e:	6be2                	ld	s7,24(sp)
 160:	6125                	addi	sp,sp,96
 162:	8082                	ret

0000000000000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	1101                	addi	sp,sp,-32
 166:	ec06                	sd	ra,24(sp)
 168:	e822                	sd	s0,16(sp)
 16a:	e04a                	sd	s2,0(sp)
 16c:	1000                	addi	s0,sp,32
 16e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	4581                	li	a1,0
 172:	162000ef          	jal	2d4 <open>
  if(fd < 0)
 176:	02054263          	bltz	a0,19a <stat+0x36>
 17a:	e426                	sd	s1,8(sp)
 17c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17e:	85ca                	mv	a1,s2
 180:	16c000ef          	jal	2ec <fstat>
 184:	892a                	mv	s2,a0
  close(fd);
 186:	8526                	mv	a0,s1
 188:	134000ef          	jal	2bc <close>
  return r;
 18c:	64a2                	ld	s1,8(sp)
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	597d                	li	s2,-1
 19c:	bfcd                	j	18e <stat+0x2a>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a4:	00054683          	lbu	a3,0(a0)
 1a8:	fd06879b          	addiw	a5,a3,-48
 1ac:	0ff7f793          	zext.b	a5,a5
 1b0:	4625                	li	a2,9
 1b2:	02f66863          	bltu	a2,a5,1e2 <atoi+0x44>
 1b6:	872a                	mv	a4,a0
  n = 0;
 1b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ba:	0705                	addi	a4,a4,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb5                	addw	a5,a5,a3
 1c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1cc:	00074683          	lbu	a3,0(a4)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	fef671e3          	bgeu	a2,a5,1ba <atoi+0x1c>
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  n = 0;
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <atoi+0x3e>

00000000000001e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ec:	02b57463          	bgeu	a0,a1,214 <memmove+0x2e>
    while(n-- > 0)
 1f0:	00c05f63          	blez	a2,20e <memmove+0x28>
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fe:	0585                	addi	a1,a1,1
 200:	0705                	addi	a4,a4,1
 202:	fff5c683          	lbu	a3,-1(a1)
 206:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20a:	fef71ae3          	bne	a4,a5,1fe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
    dst += n;
 214:	00c50733          	add	a4,a0,a2
    src += n;
 218:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21a:	fec05ae3          	blez	a2,20e <memmove+0x28>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	fff7c793          	not	a5,a5
 22a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22c:	15fd                	addi	a1,a1,-1
 22e:	177d                	addi	a4,a4,-1
 230:	0005c683          	lbu	a3,0(a1)
 234:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x46>
 23c:	bfc9                	j	20e <memmove+0x28>

000000000000023e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 244:	ca05                	beqz	a2,274 <memcmp+0x36>
 246:	fff6069b          	addiw	a3,a2,-1
 24a:	1682                	slli	a3,a3,0x20
 24c:	9281                	srli	a3,a3,0x20
 24e:	0685                	addi	a3,a3,1
 250:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 252:	00054783          	lbu	a5,0(a0)
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00e79863          	bne	a5,a4,26a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25e:	0505                	addi	a0,a0,1
    p2++;
 260:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 262:	fed518e3          	bne	a0,a3,252 <memcmp+0x14>
  }
  return 0;
 266:	4501                	li	a0,0
 268:	a019                	j	26e <memcmp+0x30>
      return *p1 - *p2;
 26a:	40e7853b          	subw	a0,a5,a4
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  return 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <memcmp+0x30>

0000000000000278 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 280:	f67ff0ef          	jal	1e6 <memmove>
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28c:	4885                	li	a7,1
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <exit>:
.global exit
exit:
 li a7, SYS_exit
 294:	4889                	li	a7,2
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <wait>:
.global wait
wait:
 li a7, SYS_wait
 29c:	488d                	li	a7,3
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a4:	4891                	li	a7,4
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <read>:
.global read
read:
 li a7, SYS_read
 2ac:	4895                	li	a7,5
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <write>:
.global write
write:
 li a7, SYS_write
 2b4:	48c1                	li	a7,16
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <close>:
.global close
close:
 li a7, SYS_close
 2bc:	48d5                	li	a7,21
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c4:	4899                	li	a7,6
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2cc:	489d                	li	a7,7
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <open>:
.global open
open:
 li a7, SYS_open
 2d4:	48bd                	li	a7,15
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2dc:	48c5                	li	a7,17
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e4:	48c9                	li	a7,18
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ec:	48a1                	li	a7,8
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <link>:
.global link
link:
 li a7, SYS_link
 2f4:	48cd                	li	a7,19
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2fc:	48d1                	li	a7,20
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 304:	48a5                	li	a7,9
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <dup>:
.global dup
dup:
 li a7, SYS_dup
 30c:	48a9                	li	a7,10
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 314:	48ad                	li	a7,11
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31c:	48b1                	li	a7,12
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 324:	48b5                	li	a7,13
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32c:	48b9                	li	a7,14
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 334:	48d9                	li	a7,22
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 33c:	48dd                	li	a7,23
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 344:	48e1                	li	a7,24
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 34c:	48e5                	li	a7,25
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 354:	48e9                	li	a7,26
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 35c:	48ed                	li	a7,27
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 364:	48f1                	li	a7,28
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 36c:	48f5                	li	a7,29
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 374:	48f9                	li	a7,30
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37c:	1101                	addi	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	1000                	addi	s0,sp,32
 384:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 388:	4605                	li	a2,1
 38a:	fef40593          	addi	a1,s0,-17
 38e:	f27ff0ef          	jal	2b4 <write>
}
 392:	60e2                	ld	ra,24(sp)
 394:	6442                	ld	s0,16(sp)
 396:	6105                	addi	sp,sp,32
 398:	8082                	ret

000000000000039a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39a:	7139                	addi	sp,sp,-64
 39c:	fc06                	sd	ra,56(sp)
 39e:	f822                	sd	s0,48(sp)
 3a0:	f426                	sd	s1,40(sp)
 3a2:	0080                	addi	s0,sp,64
 3a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a6:	c299                	beqz	a3,3ac <printint+0x12>
 3a8:	0805c963          	bltz	a1,43a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ac:	2581                	sext.w	a1,a1
  neg = 0;
 3ae:	4881                	li	a7,0
 3b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b6:	2601                	sext.w	a2,a2
 3b8:	00000517          	auipc	a0,0x0
 3bc:	51050513          	addi	a0,a0,1296 # 8c8 <digits>
 3c0:	883a                	mv	a6,a4
 3c2:	2705                	addiw	a4,a4,1
 3c4:	02c5f7bb          	remuw	a5,a1,a2
 3c8:	1782                	slli	a5,a5,0x20
 3ca:	9381                	srli	a5,a5,0x20
 3cc:	97aa                	add	a5,a5,a0
 3ce:	0007c783          	lbu	a5,0(a5)
 3d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d6:	0005879b          	sext.w	a5,a1
 3da:	02c5d5bb          	divuw	a1,a1,a2
 3de:	0685                	addi	a3,a3,1
 3e0:	fec7f0e3          	bgeu	a5,a2,3c0 <printint+0x26>
  if(neg)
 3e4:	00088c63          	beqz	a7,3fc <printint+0x62>
    buf[i++] = '-';
 3e8:	fd070793          	addi	a5,a4,-48
 3ec:	00878733          	add	a4,a5,s0
 3f0:	02d00793          	li	a5,45
 3f4:	fef70823          	sb	a5,-16(a4)
 3f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fc:	02e05a63          	blez	a4,430 <printint+0x96>
 400:	f04a                	sd	s2,32(sp)
 402:	ec4e                	sd	s3,24(sp)
 404:	fc040793          	addi	a5,s0,-64
 408:	00e78933          	add	s2,a5,a4
 40c:	fff78993          	addi	s3,a5,-1
 410:	99ba                	add	s3,s3,a4
 412:	377d                	addiw	a4,a4,-1
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41c:	fff94583          	lbu	a1,-1(s2)
 420:	8526                	mv	a0,s1
 422:	f5bff0ef          	jal	37c <putc>
  while(--i >= 0)
 426:	197d                	addi	s2,s2,-1
 428:	ff391ae3          	bne	s2,s3,41c <printint+0x82>
 42c:	7902                	ld	s2,32(sp)
 42e:	69e2                	ld	s3,24(sp)
}
 430:	70e2                	ld	ra,56(sp)
 432:	7442                	ld	s0,48(sp)
 434:	74a2                	ld	s1,40(sp)
 436:	6121                	addi	sp,sp,64
 438:	8082                	ret
    x = -xx;
 43a:	40b005bb          	negw	a1,a1
    neg = 1;
 43e:	4885                	li	a7,1
    x = -xx;
 440:	bf85                	j	3b0 <printint+0x16>

0000000000000442 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 442:	711d                	addi	sp,sp,-96
 444:	ec86                	sd	ra,88(sp)
 446:	e8a2                	sd	s0,80(sp)
 448:	e0ca                	sd	s2,64(sp)
 44a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44c:	0005c903          	lbu	s2,0(a1)
 450:	26090863          	beqz	s2,6c0 <vprintf+0x27e>
 454:	e4a6                	sd	s1,72(sp)
 456:	fc4e                	sd	s3,56(sp)
 458:	f852                	sd	s4,48(sp)
 45a:	f456                	sd	s5,40(sp)
 45c:	f05a                	sd	s6,32(sp)
 45e:	ec5e                	sd	s7,24(sp)
 460:	e862                	sd	s8,16(sp)
 462:	e466                	sd	s9,8(sp)
 464:	8b2a                	mv	s6,a0
 466:	8a2e                	mv	s4,a1
 468:	8bb2                	mv	s7,a2
  state = 0;
 46a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46c:	4481                	li	s1,0
 46e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 470:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 474:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 478:	06c00c93          	li	s9,108
 47c:	a005                	j	49c <vprintf+0x5a>
        putc(fd, c0);
 47e:	85ca                	mv	a1,s2
 480:	855a                	mv	a0,s6
 482:	efbff0ef          	jal	37c <putc>
 486:	a019                	j	48c <vprintf+0x4a>
    } else if(state == '%'){
 488:	03598263          	beq	s3,s5,4ac <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 48c:	2485                	addiw	s1,s1,1
 48e:	8726                	mv	a4,s1
 490:	009a07b3          	add	a5,s4,s1
 494:	0007c903          	lbu	s2,0(a5)
 498:	20090c63          	beqz	s2,6b0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 49c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a0:	fe0994e3          	bnez	s3,488 <vprintf+0x46>
      if(c0 == '%'){
 4a4:	fd579de3          	bne	a5,s5,47e <vprintf+0x3c>
        state = '%';
 4a8:	89be                	mv	s3,a5
 4aa:	b7cd                	j	48c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ac:	00ea06b3          	add	a3,s4,a4
 4b0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b6:	c681                	beqz	a3,4be <vprintf+0x7c>
 4b8:	9752                	add	a4,a4,s4
 4ba:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4be:	03878f63          	beq	a5,s8,4fc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4c2:	05978963          	beq	a5,s9,514 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c6:	07500713          	li	a4,117
 4ca:	0ee78363          	beq	a5,a4,5b0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ce:	07800713          	li	a4,120
 4d2:	12e78563          	beq	a5,a4,5fc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d6:	07000713          	li	a4,112
 4da:	14e78a63          	beq	a5,a4,62e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4de:	07300713          	li	a4,115
 4e2:	18e78a63          	beq	a5,a4,676 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e6:	02500713          	li	a4,37
 4ea:	04e79563          	bne	a5,a4,534 <vprintf+0xf2>
        putc(fd, '%');
 4ee:	02500593          	li	a1,37
 4f2:	855a                	mv	a0,s6
 4f4:	e89ff0ef          	jal	37c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	bf49                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	855a                	mv	a0,s6
 50a:	e91ff0ef          	jal	39a <printint>
 50e:	8bca                	mv	s7,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	bfad                	j	48c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 514:	06400793          	li	a5,100
 518:	02f68963          	beq	a3,a5,54a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51c:	06c00793          	li	a5,108
 520:	04f68263          	beq	a3,a5,564 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 524:	07500793          	li	a5,117
 528:	0af68063          	beq	a3,a5,5c8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 52c:	07800793          	li	a5,120
 530:	0ef68263          	beq	a3,a5,614 <vprintf+0x1d2>
        putc(fd, '%');
 534:	02500593          	li	a1,37
 538:	855a                	mv	a0,s6
 53a:	e43ff0ef          	jal	37c <putc>
        putc(fd, c0);
 53e:	85ca                	mv	a1,s2
 540:	855a                	mv	a0,s6
 542:	e3bff0ef          	jal	37c <putc>
      state = 0;
 546:	4981                	li	s3,0
 548:	b791                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000ba583          	lw	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	e43ff0ef          	jal	39a <printint>
        i += 1;
 55c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
        i += 1;
 562:	b72d                	j	48c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06400793          	li	a5,100
 568:	02f60763          	beq	a2,a5,596 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56c:	07500793          	li	a5,117
 570:	06f60963          	beq	a2,a5,5e2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 574:	07800793          	li	a5,120
 578:	faf61ee3          	bne	a2,a5,534 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4641                	li	a2,16
 584:	000ba583          	lw	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e11ff0ef          	jal	39a <printint>
        i += 2;
 58e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	bde5                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	df7ff0ef          	jal	39a <printint>
        i += 2;
 5a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	bdf9                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	dddff0ef          	jal	39a <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5d9                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	dc5ff0ef          	jal	39a <printint>
        i += 1;
 5da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 1;
 5e0:	b575                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	dabff0ef          	jal	39a <printint>
        i += 2;
 5f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	bd49                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	d91ff0ef          	jal	39a <printint>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	bdad                	j	48c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	008b8913          	addi	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	d79ff0ef          	jal	39a <printint>
        i += 1;
 626:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 1;
 62c:	b585                	j	48c <vprintf+0x4a>
 62e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 630:	008b8d13          	addi	s10,s7,8
 634:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 638:	03000593          	li	a1,48
 63c:	855a                	mv	a0,s6
 63e:	d3fff0ef          	jal	37c <putc>
  putc(fd, 'x');
 642:	07800593          	li	a1,120
 646:	855a                	mv	a0,s6
 648:	d35ff0ef          	jal	37c <putc>
 64c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64e:	00000b97          	auipc	s7,0x0
 652:	27ab8b93          	addi	s7,s7,634 # 8c8 <digits>
 656:	03c9d793          	srli	a5,s3,0x3c
 65a:	97de                	add	a5,a5,s7
 65c:	0007c583          	lbu	a1,0(a5)
 660:	855a                	mv	a0,s6
 662:	d1bff0ef          	jal	37c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 666:	0992                	slli	s3,s3,0x4
 668:	397d                	addiw	s2,s2,-1
 66a:	fe0916e3          	bnez	s2,656 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 66e:	8bea                	mv	s7,s10
      state = 0;
 670:	4981                	li	s3,0
 672:	6d02                	ld	s10,0(sp)
 674:	bd21                	j	48c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 676:	008b8993          	addi	s3,s7,8
 67a:	000bb903          	ld	s2,0(s7)
 67e:	00090f63          	beqz	s2,69c <vprintf+0x25a>
        for(; *s; s++)
 682:	00094583          	lbu	a1,0(s2)
 686:	c195                	beqz	a1,6aa <vprintf+0x268>
          putc(fd, *s);
 688:	855a                	mv	a0,s6
 68a:	cf3ff0ef          	jal	37c <putc>
        for(; *s; s++)
 68e:	0905                	addi	s2,s2,1
 690:	00094583          	lbu	a1,0(s2)
 694:	f9f5                	bnez	a1,688 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 696:	8bce                	mv	s7,s3
      state = 0;
 698:	4981                	li	s3,0
 69a:	bbcd                	j	48c <vprintf+0x4a>
          s = "(null)";
 69c:	00000917          	auipc	s2,0x0
 6a0:	22490913          	addi	s2,s2,548 # 8c0 <malloc+0x118>
        for(; *s; s++)
 6a4:	02800593          	li	a1,40
 6a8:	b7c5                	j	688 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6aa:	8bce                	mv	s7,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bbf9                	j	48c <vprintf+0x4a>
 6b0:	64a6                	ld	s1,72(sp)
 6b2:	79e2                	ld	s3,56(sp)
 6b4:	7a42                	ld	s4,48(sp)
 6b6:	7aa2                	ld	s5,40(sp)
 6b8:	7b02                	ld	s6,32(sp)
 6ba:	6be2                	ld	s7,24(sp)
 6bc:	6c42                	ld	s8,16(sp)
 6be:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c0:	60e6                	ld	ra,88(sp)
 6c2:	6446                	ld	s0,80(sp)
 6c4:	6906                	ld	s2,64(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ca:	715d                	addi	sp,sp,-80
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	e010                	sd	a2,0(s0)
 6d4:	e414                	sd	a3,8(s0)
 6d6:	e818                	sd	a4,16(s0)
 6d8:	ec1c                	sd	a5,24(s0)
 6da:	03043023          	sd	a6,32(s0)
 6de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	8622                	mv	a2,s0
 6e8:	d5bff0ef          	jal	442 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6161                	addi	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <printf>:

void
printf(const char *fmt, ...)
{
 6f4:	711d                	addi	sp,sp,-96
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e40c                	sd	a1,8(s0)
 6fe:	e810                	sd	a2,16(s0)
 700:	ec14                	sd	a3,24(s0)
 702:	f018                	sd	a4,32(s0)
 704:	f41c                	sd	a5,40(s0)
 706:	03043823          	sd	a6,48(s0)
 70a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	00840613          	addi	a2,s0,8
 712:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 716:	85aa                	mv	a1,a0
 718:	4505                	li	a0,1
 71a:	d29ff0ef          	jal	442 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret

0000000000000726 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	1141                	addi	sp,sp,-16
 728:	e422                	sd	s0,8(sp)
 72a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00001797          	auipc	a5,0x1
 734:	8d07b783          	ld	a5,-1840(a5) # 1000 <freep>
 738:	a02d                	j	762 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73a:	4618                	lw	a4,8(a2)
 73c:	9f2d                	addw	a4,a4,a1
 73e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	6398                	ld	a4,0(a5)
 744:	6310                	ld	a2,0(a4)
 746:	a83d                	j	784 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 748:	ff852703          	lw	a4,-8(a0)
 74c:	9f31                	addw	a4,a4,a2
 74e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 750:	ff053683          	ld	a3,-16(a0)
 754:	a091                	j	798 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	6398                	ld	a4,0(a5)
 758:	00e7e463          	bltu	a5,a4,760 <free+0x3a>
 75c:	00e6ea63          	bltu	a3,a4,770 <free+0x4a>
{
 760:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	fed7fae3          	bgeu	a5,a3,756 <free+0x30>
 766:	6398                	ld	a4,0(a5)
 768:	00e6e463          	bltu	a3,a4,770 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	fee7eae3          	bltu	a5,a4,760 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 770:	ff852583          	lw	a1,-8(a0)
 774:	6390                	ld	a2,0(a5)
 776:	02059813          	slli	a6,a1,0x20
 77a:	01c85713          	srli	a4,a6,0x1c
 77e:	9736                	add	a4,a4,a3
 780:	fae60de3          	beq	a2,a4,73a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 788:	4790                	lw	a2,8(a5)
 78a:	02061593          	slli	a1,a2,0x20
 78e:	01c5d713          	srli	a4,a1,0x1c
 792:	973e                	add	a4,a4,a5
 794:	fae68ae3          	beq	a3,a4,748 <free+0x22>
    p->s.ptr = bp->s.ptr;
 798:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79a:	00001717          	auipc	a4,0x1
 79e:	86f73323          	sd	a5,-1946(a4) # 1000 <freep>
}
 7a2:	6422                	ld	s0,8(sp)
 7a4:	0141                	addi	sp,sp,16
 7a6:	8082                	ret

00000000000007a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a8:	7139                	addi	sp,sp,-64
 7aa:	fc06                	sd	ra,56(sp)
 7ac:	f822                	sd	s0,48(sp)
 7ae:	f426                	sd	s1,40(sp)
 7b0:	ec4e                	sd	s3,24(sp)
 7b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b4:	02051493          	slli	s1,a0,0x20
 7b8:	9081                	srli	s1,s1,0x20
 7ba:	04bd                	addi	s1,s1,15
 7bc:	8091                	srli	s1,s1,0x4
 7be:	0014899b          	addiw	s3,s1,1
 7c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c4:	00001517          	auipc	a0,0x1
 7c8:	83c53503          	ld	a0,-1988(a0) # 1000 <freep>
 7cc:	c915                	beqz	a0,800 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	08977a63          	bgeu	a4,s1,866 <malloc+0xbe>
 7d6:	f04a                	sd	s2,32(sp)
 7d8:	e852                	sd	s4,16(sp)
 7da:	e456                	sd	s5,8(sp)
 7dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7de:	8a4e                	mv	s4,s3
 7e0:	0009871b          	sext.w	a4,s3
 7e4:	6685                	lui	a3,0x1
 7e6:	00d77363          	bgeu	a4,a3,7ec <malloc+0x44>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00001917          	auipc	s2,0x1
 7f8:	80c90913          	addi	s2,s2,-2036 # 1000 <freep>
  if(p == (char*)-1)
 7fc:	5afd                	li	s5,-1
 7fe:	a081                	j	83e <malloc+0x96>
 800:	f04a                	sd	s2,32(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 808:	00001797          	auipc	a5,0x1
 80c:	80878793          	addi	a5,a5,-2040 # 1010 <base>
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
 818:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81e:	b7c1                	j	7de <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	e118                	sd	a4,0(a0)
 824:	a8a9                	j	87e <malloc+0xd6>
  hp->s.size = nu;
 826:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82a:	0541                	addi	a0,a0,16
 82c:	efbff0ef          	jal	726 <free>
  return freep;
 830:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 834:	c12d                	beqz	a0,896 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	02977263          	bgeu	a4,s1,85e <malloc+0xb6>
    if(p == freep)
 83e:	00093703          	ld	a4,0(s2)
 842:	853e                	mv	a0,a5
 844:	fef719e3          	bne	a4,a5,836 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 848:	8552                	mv	a0,s4
 84a:	ad3ff0ef          	jal	31c <sbrk>
  if(p == (char*)-1)
 84e:	fd551ce3          	bne	a0,s5,826 <malloc+0x7e>
        return 0;
 852:	4501                	li	a0,0
 854:	7902                	ld	s2,32(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
 85c:	a03d                	j	88a <malloc+0xe2>
 85e:	7902                	ld	s2,32(sp)
 860:	6a42                	ld	s4,16(sp)
 862:	6aa2                	ld	s5,8(sp)
 864:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 866:	fae48de3          	beq	s1,a4,820 <malloc+0x78>
        p->s.size -= nunits;
 86a:	4137073b          	subw	a4,a4,s3
 86e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 870:	02071693          	slli	a3,a4,0x20
 874:	01c6d713          	srli	a4,a3,0x1c
 878:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87e:	00000717          	auipc	a4,0x0
 882:	78a73123          	sd	a0,1922(a4) # 1000 <freep>
      return (void*)(p + 1);
 886:	01078513          	addi	a0,a5,16
  }
}
 88a:	70e2                	ld	ra,56(sp)
 88c:	7442                	ld	s0,48(sp)
 88e:	74a2                	ld	s1,40(sp)
 890:	69e2                	ld	s3,24(sp)
 892:	6121                	addi	sp,sp,64
 894:	8082                	ret
 896:	7902                	ld	s2,32(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
 89e:	b7f5                	j	88a <malloc+0xe2>
