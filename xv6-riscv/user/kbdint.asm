
user/_kbdint:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  int count = kbdint();
   8:	322000ef          	jal	32a <kbdint>
   c:	85aa                	mv	a1,a0
  printf("Keyboard interrupts since boot: %d\n", count);
   e:	00001517          	auipc	a0,0x1
  12:	89250513          	addi	a0,a0,-1902 # 8a0 <malloc+0x102>
  16:	6d4000ef          	jal	6ea <printf>

  exit(0);
  1a:	4501                	li	a0,0
  1c:	26e000ef          	jal	28a <exit>

0000000000000020 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  20:	1141                	addi	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	addi	s0,sp,16
  extern int main();
  main();
  28:	fd9ff0ef          	jal	0 <main>
  exit(0);
  2c:	4501                	li	a0,0
  2e:	25c000ef          	jal	28a <exit>

0000000000000032 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  32:	1141                	addi	sp,sp,-16
  34:	e422                	sd	s0,8(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0x8>
    ;
  return os;
}
  48:	6422                	ld	s0,8(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e422                	sd	s0,8(sp)
  52:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  54:	00054783          	lbu	a5,0(a0)
  58:	cb91                	beqz	a5,6c <strcmp+0x1e>
  5a:	0005c703          	lbu	a4,0(a1)
  5e:	00f71763          	bne	a4,a5,6c <strcmp+0x1e>
    p++, q++;
  62:	0505                	addi	a0,a0,1
  64:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	fbe5                	bnez	a5,5a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6c:	0005c503          	lbu	a0,0(a1)
}
  70:	40a7853b          	subw	a0,a5,a0
  74:	6422                	ld	s0,8(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strlen>:

uint
strlen(const char *s)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  80:	00054783          	lbu	a5,0(a0)
  84:	cf91                	beqz	a5,a0 <strlen+0x26>
  86:	0505                	addi	a0,a0,1
  88:	87aa                	mv	a5,a0
  8a:	86be                	mv	a3,a5
  8c:	0785                	addi	a5,a5,1
  8e:	fff7c703          	lbu	a4,-1(a5)
  92:	ff65                	bnez	a4,8a <strlen+0x10>
  94:	40a6853b          	subw	a0,a3,a0
  98:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret
  for(n = 0; s[n]; n++)
  a0:	4501                	li	a0,0
  a2:	bfe5                	j	9a <strlen+0x20>

00000000000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e422                	sd	s0,8(sp)
  a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  aa:	ca19                	beqz	a2,c0 <memset+0x1c>
  ac:	87aa                	mv	a5,a0
  ae:	1602                	slli	a2,a2,0x20
  b0:	9201                	srli	a2,a2,0x20
  b2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ba:	0785                	addi	a5,a5,1
  bc:	fee79de3          	bne	a5,a4,b6 <memset+0x12>
  }
  return dst;
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strchr>:

char*
strchr(const char *s, char c)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb99                	beqz	a5,e6 <strchr+0x20>
    if(*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1a>
  for(; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xc>
      return (char*)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  return 0;
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strchr+0x1a>

00000000000000ea <gets>:

char*
gets(char *buf, int max)
{
  ea:	711d                	addi	sp,sp,-96
  ec:	ec86                	sd	ra,88(sp)
  ee:	e8a2                	sd	s0,80(sp)
  f0:	e4a6                	sd	s1,72(sp)
  f2:	e0ca                	sd	s2,64(sp)
  f4:	fc4e                	sd	s3,56(sp)
  f6:	f852                	sd	s4,48(sp)
  f8:	f456                	sd	s5,40(sp)
  fa:	f05a                	sd	s6,32(sp)
  fc:	ec5e                	sd	s7,24(sp)
  fe:	1080                	addi	s0,sp,96
 100:	8baa                	mv	s7,a0
 102:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 104:	892a                	mv	s2,a0
 106:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 108:	4aa9                	li	s5,10
 10a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10c:	89a6                	mv	s3,s1
 10e:	2485                	addiw	s1,s1,1
 110:	0344d663          	bge	s1,s4,13c <gets+0x52>
    cc = read(0, &c, 1);
 114:	4605                	li	a2,1
 116:	faf40593          	addi	a1,s0,-81
 11a:	4501                	li	a0,0
 11c:	186000ef          	jal	2a2 <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x52>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x50>
 130:	0905                	addi	s2,s2,1
 132:	fd679de3          	bne	a5,s6,10c <gets+0x22>
    buf[i++] = c;
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x52>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	162000ef          	jal	2ca <open>
  if(fd < 0)
 16c:	02054263          	bltz	a0,190 <stat+0x36>
 170:	e426                	sd	s1,8(sp)
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	16c000ef          	jal	2e2 <fstat>
 17a:	892a                	mv	s2,a0
  close(fd);
 17c:	8526                	mv	a0,s1
 17e:	134000ef          	jal	2b2 <close>
  return r;
 182:	64a2                	ld	s1,8(sp)
}
 184:	854a                	mv	a0,s2
 186:	60e2                	ld	ra,24(sp)
 188:	6442                	ld	s0,16(sp)
 18a:	6902                	ld	s2,0(sp)
 18c:	6105                	addi	sp,sp,32
 18e:	8082                	ret
    return -1;
 190:	597d                	li	s2,-1
 192:	bfcd                	j	184 <stat+0x2a>

0000000000000194 <atoi>:

int
atoi(const char *s)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19a:	00054683          	lbu	a3,0(a0)
 19e:	fd06879b          	addiw	a5,a3,-48
 1a2:	0ff7f793          	zext.b	a5,a5
 1a6:	4625                	li	a2,9
 1a8:	02f66863          	bltu	a2,a5,1d8 <atoi+0x44>
 1ac:	872a                	mv	a4,a0
  n = 0;
 1ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b0:	0705                	addi	a4,a4,1
 1b2:	0025179b          	slliw	a5,a0,0x2
 1b6:	9fa9                	addw	a5,a5,a0
 1b8:	0017979b          	slliw	a5,a5,0x1
 1bc:	9fb5                	addw	a5,a5,a3
 1be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c2:	00074683          	lbu	a3,0(a4)
 1c6:	fd06879b          	addiw	a5,a3,-48
 1ca:	0ff7f793          	zext.b	a5,a5
 1ce:	fef671e3          	bgeu	a2,a5,1b0 <atoi+0x1c>
  return n;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  n = 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <atoi+0x3e>

00000000000001dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e2:	02b57463          	bgeu	a0,a1,20a <memmove+0x2e>
    while(n-- > 0)
 1e6:	00c05f63          	blez	a2,204 <memmove+0x28>
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f4:	0585                	addi	a1,a1,1
 1f6:	0705                	addi	a4,a4,1
 1f8:	fff5c683          	lbu	a3,-1(a1)
 1fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 200:	fef71ae3          	bne	a4,a5,1f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
    dst += n;
 20a:	00c50733          	add	a4,a0,a2
    src += n;
 20e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 210:	fec05ae3          	blez	a2,204 <memmove+0x28>
 214:	fff6079b          	addiw	a5,a2,-1
 218:	1782                	slli	a5,a5,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	fff7c793          	not	a5,a5
 220:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 222:	15fd                	addi	a1,a1,-1
 224:	177d                	addi	a4,a4,-1
 226:	0005c683          	lbu	a3,0(a1)
 22a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x46>
 232:	bfc9                	j	204 <memmove+0x28>

0000000000000234 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 23a:	ca05                	beqz	a2,26a <memcmp+0x36>
 23c:	fff6069b          	addiw	a3,a2,-1
 240:	1682                	slli	a3,a3,0x20
 242:	9281                	srli	a3,a3,0x20
 244:	0685                	addi	a3,a3,1
 246:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 248:	00054783          	lbu	a5,0(a0)
 24c:	0005c703          	lbu	a4,0(a1)
 250:	00e79863          	bne	a5,a4,260 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 254:	0505                	addi	a0,a0,1
    p2++;
 256:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 258:	fed518e3          	bne	a0,a3,248 <memcmp+0x14>
  }
  return 0;
 25c:	4501                	li	a0,0
 25e:	a019                	j	264 <memcmp+0x30>
      return *p1 - *p2;
 260:	40e7853b          	subw	a0,a5,a4
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  return 0;
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <memcmp+0x30>

000000000000026e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 276:	f67ff0ef          	jal	1dc <memmove>
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 282:	4885                	li	a7,1
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <exit>:
.global exit
exit:
 li a7, SYS_exit
 28a:	4889                	li	a7,2
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <wait>:
.global wait
wait:
 li a7, SYS_wait
 292:	488d                	li	a7,3
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29a:	4891                	li	a7,4
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <read>:
.global read
read:
 li a7, SYS_read
 2a2:	4895                	li	a7,5
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <write>:
.global write
write:
 li a7, SYS_write
 2aa:	48c1                	li	a7,16
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <close>:
.global close
close:
 li a7, SYS_close
 2b2:	48d5                	li	a7,21
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ba:	4899                	li	a7,6
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c2:	489d                	li	a7,7
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <open>:
.global open
open:
 li a7, SYS_open
 2ca:	48bd                	li	a7,15
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d2:	48c5                	li	a7,17
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2da:	48c9                	li	a7,18
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e2:	48a1                	li	a7,8
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <link>:
.global link
link:
 li a7, SYS_link
 2ea:	48cd                	li	a7,19
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f2:	48d1                	li	a7,20
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fa:	48a5                	li	a7,9
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <dup>:
.global dup
dup:
 li a7, SYS_dup
 302:	48a9                	li	a7,10
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30a:	48ad                	li	a7,11
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 312:	48b1                	li	a7,12
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31a:	48b5                	li	a7,13
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 322:	48b9                	li	a7,14
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 32a:	48d9                	li	a7,22
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 332:	48dd                	li	a7,23
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 33a:	48e1                	li	a7,24
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 342:	48e5                	li	a7,25
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 34a:	48e9                	li	a7,26
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 352:	48ed                	li	a7,27
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 35a:	48f1                	li	a7,28
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 362:	48f5                	li	a7,29
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 36a:	48f9                	li	a7,30
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 372:	1101                	addi	sp,sp,-32
 374:	ec06                	sd	ra,24(sp)
 376:	e822                	sd	s0,16(sp)
 378:	1000                	addi	s0,sp,32
 37a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37e:	4605                	li	a2,1
 380:	fef40593          	addi	a1,s0,-17
 384:	f27ff0ef          	jal	2aa <write>
}
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	6105                	addi	sp,sp,32
 38e:	8082                	ret

0000000000000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	7139                	addi	sp,sp,-64
 392:	fc06                	sd	ra,56(sp)
 394:	f822                	sd	s0,48(sp)
 396:	f426                	sd	s1,40(sp)
 398:	0080                	addi	s0,sp,64
 39a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39c:	c299                	beqz	a3,3a2 <printint+0x12>
 39e:	0805c963          	bltz	a1,430 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a2:	2581                	sext.w	a1,a1
  neg = 0;
 3a4:	4881                	li	a7,0
 3a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ac:	2601                	sext.w	a2,a2
 3ae:	00000517          	auipc	a0,0x0
 3b2:	52250513          	addi	a0,a0,1314 # 8d0 <digits>
 3b6:	883a                	mv	a6,a4
 3b8:	2705                	addiw	a4,a4,1
 3ba:	02c5f7bb          	remuw	a5,a1,a2
 3be:	1782                	slli	a5,a5,0x20
 3c0:	9381                	srli	a5,a5,0x20
 3c2:	97aa                	add	a5,a5,a0
 3c4:	0007c783          	lbu	a5,0(a5)
 3c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3cc:	0005879b          	sext.w	a5,a1
 3d0:	02c5d5bb          	divuw	a1,a1,a2
 3d4:	0685                	addi	a3,a3,1
 3d6:	fec7f0e3          	bgeu	a5,a2,3b6 <printint+0x26>
  if(neg)
 3da:	00088c63          	beqz	a7,3f2 <printint+0x62>
    buf[i++] = '-';
 3de:	fd070793          	addi	a5,a4,-48
 3e2:	00878733          	add	a4,a5,s0
 3e6:	02d00793          	li	a5,45
 3ea:	fef70823          	sb	a5,-16(a4)
 3ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f2:	02e05a63          	blez	a4,426 <printint+0x96>
 3f6:	f04a                	sd	s2,32(sp)
 3f8:	ec4e                	sd	s3,24(sp)
 3fa:	fc040793          	addi	a5,s0,-64
 3fe:	00e78933          	add	s2,a5,a4
 402:	fff78993          	addi	s3,a5,-1
 406:	99ba                	add	s3,s3,a4
 408:	377d                	addiw	a4,a4,-1
 40a:	1702                	slli	a4,a4,0x20
 40c:	9301                	srli	a4,a4,0x20
 40e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 412:	fff94583          	lbu	a1,-1(s2)
 416:	8526                	mv	a0,s1
 418:	f5bff0ef          	jal	372 <putc>
  while(--i >= 0)
 41c:	197d                	addi	s2,s2,-1
 41e:	ff391ae3          	bne	s2,s3,412 <printint+0x82>
 422:	7902                	ld	s2,32(sp)
 424:	69e2                	ld	s3,24(sp)
}
 426:	70e2                	ld	ra,56(sp)
 428:	7442                	ld	s0,48(sp)
 42a:	74a2                	ld	s1,40(sp)
 42c:	6121                	addi	sp,sp,64
 42e:	8082                	ret
    x = -xx;
 430:	40b005bb          	negw	a1,a1
    neg = 1;
 434:	4885                	li	a7,1
    x = -xx;
 436:	bf85                	j	3a6 <printint+0x16>

0000000000000438 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 438:	711d                	addi	sp,sp,-96
 43a:	ec86                	sd	ra,88(sp)
 43c:	e8a2                	sd	s0,80(sp)
 43e:	e0ca                	sd	s2,64(sp)
 440:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 442:	0005c903          	lbu	s2,0(a1)
 446:	26090863          	beqz	s2,6b6 <vprintf+0x27e>
 44a:	e4a6                	sd	s1,72(sp)
 44c:	fc4e                	sd	s3,56(sp)
 44e:	f852                	sd	s4,48(sp)
 450:	f456                	sd	s5,40(sp)
 452:	f05a                	sd	s6,32(sp)
 454:	ec5e                	sd	s7,24(sp)
 456:	e862                	sd	s8,16(sp)
 458:	e466                	sd	s9,8(sp)
 45a:	8b2a                	mv	s6,a0
 45c:	8a2e                	mv	s4,a1
 45e:	8bb2                	mv	s7,a2
  state = 0;
 460:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 462:	4481                	li	s1,0
 464:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 466:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 46a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 46e:	06c00c93          	li	s9,108
 472:	a005                	j	492 <vprintf+0x5a>
        putc(fd, c0);
 474:	85ca                	mv	a1,s2
 476:	855a                	mv	a0,s6
 478:	efbff0ef          	jal	372 <putc>
 47c:	a019                	j	482 <vprintf+0x4a>
    } else if(state == '%'){
 47e:	03598263          	beq	s3,s5,4a2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 482:	2485                	addiw	s1,s1,1
 484:	8726                	mv	a4,s1
 486:	009a07b3          	add	a5,s4,s1
 48a:	0007c903          	lbu	s2,0(a5)
 48e:	20090c63          	beqz	s2,6a6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 492:	0009079b          	sext.w	a5,s2
    if(state == 0){
 496:	fe0994e3          	bnez	s3,47e <vprintf+0x46>
      if(c0 == '%'){
 49a:	fd579de3          	bne	a5,s5,474 <vprintf+0x3c>
        state = '%';
 49e:	89be                	mv	s3,a5
 4a0:	b7cd                	j	482 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a2:	00ea06b3          	add	a3,s4,a4
 4a6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4aa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ac:	c681                	beqz	a3,4b4 <vprintf+0x7c>
 4ae:	9752                	add	a4,a4,s4
 4b0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b4:	03878f63          	beq	a5,s8,4f2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4b8:	05978963          	beq	a5,s9,50a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4bc:	07500713          	li	a4,117
 4c0:	0ee78363          	beq	a5,a4,5a6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c4:	07800713          	li	a4,120
 4c8:	12e78563          	beq	a5,a4,5f2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4cc:	07000713          	li	a4,112
 4d0:	14e78a63          	beq	a5,a4,624 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4d4:	07300713          	li	a4,115
 4d8:	18e78a63          	beq	a5,a4,66c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4dc:	02500713          	li	a4,37
 4e0:	04e79563          	bne	a5,a4,52a <vprintf+0xf2>
        putc(fd, '%');
 4e4:	02500593          	li	a1,37
 4e8:	855a                	mv	a0,s6
 4ea:	e89ff0ef          	jal	372 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	bf49                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f2:	008b8913          	addi	s2,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	e91ff0ef          	jal	390 <printint>
 504:	8bca                	mv	s7,s2
      state = 0;
 506:	4981                	li	s3,0
 508:	bfad                	j	482 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	06400793          	li	a5,100
 50e:	02f68963          	beq	a3,a5,540 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 512:	06c00793          	li	a5,108
 516:	04f68263          	beq	a3,a5,55a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 51a:	07500793          	li	a5,117
 51e:	0af68063          	beq	a3,a5,5be <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 522:	07800793          	li	a5,120
 526:	0ef68263          	beq	a3,a5,60a <vprintf+0x1d2>
        putc(fd, '%');
 52a:	02500593          	li	a1,37
 52e:	855a                	mv	a0,s6
 530:	e43ff0ef          	jal	372 <putc>
        putc(fd, c0);
 534:	85ca                	mv	a1,s2
 536:	855a                	mv	a0,s6
 538:	e3bff0ef          	jal	372 <putc>
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b791                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 540:	008b8913          	addi	s2,s7,8
 544:	4685                	li	a3,1
 546:	4629                	li	a2,10
 548:	000ba583          	lw	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e43ff0ef          	jal	390 <printint>
        i += 1;
 552:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	8bca                	mv	s7,s2
      state = 0;
 556:	4981                	li	s3,0
        i += 1;
 558:	b72d                	j	482 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	06400793          	li	a5,100
 55e:	02f60763          	beq	a2,a5,58c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 562:	07500793          	li	a5,117
 566:	06f60963          	beq	a2,a5,5d8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 56a:	07800793          	li	a5,120
 56e:	faf61ee3          	bne	a2,a5,52a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 572:	008b8913          	addi	s2,s7,8
 576:	4681                	li	a3,0
 578:	4641                	li	a2,16
 57a:	000ba583          	lw	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e11ff0ef          	jal	390 <printint>
        i += 2;
 584:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 586:	8bca                	mv	s7,s2
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	bde5                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58c:	008b8913          	addi	s2,s7,8
 590:	4685                	li	a3,1
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	df7ff0ef          	jal	390 <printint>
        i += 2;
 59e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	bdf9                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4629                	li	a2,10
 5ae:	000ba583          	lw	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	dddff0ef          	jal	390 <printint>
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b5d9                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	dc5ff0ef          	jal	390 <printint>
        i += 1;
 5d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
        i += 1;
 5d6:	b575                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4629                	li	a2,10
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	dabff0ef          	jal	390 <printint>
        i += 2;
 5ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	bd49                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	d91ff0ef          	jal	390 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bdad                	j	482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4641                	li	a2,16
 612:	000ba583          	lw	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	d79ff0ef          	jal	390 <printint>
        i += 1;
 61c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
        i += 1;
 622:	b585                	j	482 <vprintf+0x4a>
 624:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 626:	008b8d13          	addi	s10,s7,8
 62a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62e:	03000593          	li	a1,48
 632:	855a                	mv	a0,s6
 634:	d3fff0ef          	jal	372 <putc>
  putc(fd, 'x');
 638:	07800593          	li	a1,120
 63c:	855a                	mv	a0,s6
 63e:	d35ff0ef          	jal	372 <putc>
 642:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 644:	00000b97          	auipc	s7,0x0
 648:	28cb8b93          	addi	s7,s7,652 # 8d0 <digits>
 64c:	03c9d793          	srli	a5,s3,0x3c
 650:	97de                	add	a5,a5,s7
 652:	0007c583          	lbu	a1,0(a5)
 656:	855a                	mv	a0,s6
 658:	d1bff0ef          	jal	372 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65c:	0992                	slli	s3,s3,0x4
 65e:	397d                	addiw	s2,s2,-1
 660:	fe0916e3          	bnez	s2,64c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 664:	8bea                	mv	s7,s10
      state = 0;
 666:	4981                	li	s3,0
 668:	6d02                	ld	s10,0(sp)
 66a:	bd21                	j	482 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 66c:	008b8993          	addi	s3,s7,8
 670:	000bb903          	ld	s2,0(s7)
 674:	00090f63          	beqz	s2,692 <vprintf+0x25a>
        for(; *s; s++)
 678:	00094583          	lbu	a1,0(s2)
 67c:	c195                	beqz	a1,6a0 <vprintf+0x268>
          putc(fd, *s);
 67e:	855a                	mv	a0,s6
 680:	cf3ff0ef          	jal	372 <putc>
        for(; *s; s++)
 684:	0905                	addi	s2,s2,1
 686:	00094583          	lbu	a1,0(s2)
 68a:	f9f5                	bnez	a1,67e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	bbcd                	j	482 <vprintf+0x4a>
          s = "(null)";
 692:	00000917          	auipc	s2,0x0
 696:	23690913          	addi	s2,s2,566 # 8c8 <malloc+0x12a>
        for(; *s; s++)
 69a:	02800593          	li	a1,40
 69e:	b7c5                	j	67e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a0:	8bce                	mv	s7,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bbf9                	j	482 <vprintf+0x4a>
 6a6:	64a6                	ld	s1,72(sp)
 6a8:	79e2                	ld	s3,56(sp)
 6aa:	7a42                	ld	s4,48(sp)
 6ac:	7aa2                	ld	s5,40(sp)
 6ae:	7b02                	ld	s6,32(sp)
 6b0:	6be2                	ld	s7,24(sp)
 6b2:	6c42                	ld	s8,16(sp)
 6b4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6b6:	60e6                	ld	ra,88(sp)
 6b8:	6446                	ld	s0,80(sp)
 6ba:	6906                	ld	s2,64(sp)
 6bc:	6125                	addi	sp,sp,96
 6be:	8082                	ret

00000000000006c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c0:	715d                	addi	sp,sp,-80
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e010                	sd	a2,0(s0)
 6ca:	e414                	sd	a3,8(s0)
 6cc:	e818                	sd	a4,16(s0)
 6ce:	ec1c                	sd	a5,24(s0)
 6d0:	03043023          	sd	a6,32(s0)
 6d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6dc:	8622                	mv	a2,s0
 6de:	d5bff0ef          	jal	438 <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6161                	addi	sp,sp,80
 6e8:	8082                	ret

00000000000006ea <printf>:

void
printf(const char *fmt, ...)
{
 6ea:	711d                	addi	sp,sp,-96
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e40c                	sd	a1,8(s0)
 6f4:	e810                	sd	a2,16(s0)
 6f6:	ec14                	sd	a3,24(s0)
 6f8:	f018                	sd	a4,32(s0)
 6fa:	f41c                	sd	a5,40(s0)
 6fc:	03043823          	sd	a6,48(s0)
 700:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 704:	00840613          	addi	a2,s0,8
 708:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70c:	85aa                	mv	a1,a0
 70e:	4505                	li	a0,1
 710:	d29ff0ef          	jal	438 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 722:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	00001797          	auipc	a5,0x1
 72a:	8da7b783          	ld	a5,-1830(a5) # 1000 <freep>
 72e:	a02d                	j	758 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 730:	4618                	lw	a4,8(a2)
 732:	9f2d                	addw	a4,a4,a1
 734:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	6398                	ld	a4,0(a5)
 73a:	6310                	ld	a2,0(a4)
 73c:	a83d                	j	77a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73e:	ff852703          	lw	a4,-8(a0)
 742:	9f31                	addw	a4,a4,a2
 744:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 746:	ff053683          	ld	a3,-16(a0)
 74a:	a091                	j	78e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	6398                	ld	a4,0(a5)
 74e:	00e7e463          	bltu	a5,a4,756 <free+0x3a>
 752:	00e6ea63          	bltu	a3,a4,766 <free+0x4a>
{
 756:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	fed7fae3          	bgeu	a5,a3,74c <free+0x30>
 75c:	6398                	ld	a4,0(a5)
 75e:	00e6e463          	bltu	a3,a4,766 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	fee7eae3          	bltu	a5,a4,756 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 766:	ff852583          	lw	a1,-8(a0)
 76a:	6390                	ld	a2,0(a5)
 76c:	02059813          	slli	a6,a1,0x20
 770:	01c85713          	srli	a4,a6,0x1c
 774:	9736                	add	a4,a4,a3
 776:	fae60de3          	beq	a2,a4,730 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77e:	4790                	lw	a2,8(a5)
 780:	02061593          	slli	a1,a2,0x20
 784:	01c5d713          	srli	a4,a1,0x1c
 788:	973e                	add	a4,a4,a5
 78a:	fae68ae3          	beq	a3,a4,73e <free+0x22>
    p->s.ptr = bp->s.ptr;
 78e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 790:	00001717          	auipc	a4,0x1
 794:	86f73823          	sd	a5,-1936(a4) # 1000 <freep>
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret

000000000000079e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	ec4e                	sd	s3,24(sp)
 7a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7aa:	02051493          	slli	s1,a0,0x20
 7ae:	9081                	srli	s1,s1,0x20
 7b0:	04bd                	addi	s1,s1,15
 7b2:	8091                	srli	s1,s1,0x4
 7b4:	0014899b          	addiw	s3,s1,1
 7b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ba:	00001517          	auipc	a0,0x1
 7be:	84653503          	ld	a0,-1978(a0) # 1000 <freep>
 7c2:	c915                	beqz	a0,7f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	08977a63          	bgeu	a4,s1,85c <malloc+0xbe>
 7cc:	f04a                	sd	s2,32(sp)
 7ce:	e852                	sd	s4,16(sp)
 7d0:	e456                	sd	s5,8(sp)
 7d2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d4:	8a4e                	mv	s4,s3
 7d6:	0009871b          	sext.w	a4,s3
 7da:	6685                	lui	a3,0x1
 7dc:	00d77363          	bgeu	a4,a3,7e2 <malloc+0x44>
 7e0:	6a05                	lui	s4,0x1
 7e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ea:	00001917          	auipc	s2,0x1
 7ee:	81690913          	addi	s2,s2,-2026 # 1000 <freep>
  if(p == (char*)-1)
 7f2:	5afd                	li	s5,-1
 7f4:	a081                	j	834 <malloc+0x96>
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fe:	00001797          	auipc	a5,0x1
 802:	81278793          	addi	a5,a5,-2030 # 1010 <base>
 806:	00000717          	auipc	a4,0x0
 80a:	7ef73d23          	sd	a5,2042(a4) # 1000 <freep>
 80e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 810:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 814:	b7c1                	j	7d4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	e118                	sd	a4,0(a0)
 81a:	a8a9                	j	874 <malloc+0xd6>
  hp->s.size = nu;
 81c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 820:	0541                	addi	a0,a0,16
 822:	efbff0ef          	jal	71c <free>
  return freep;
 826:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 82a:	c12d                	beqz	a0,88c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82e:	4798                	lw	a4,8(a5)
 830:	02977263          	bgeu	a4,s1,854 <malloc+0xb6>
    if(p == freep)
 834:	00093703          	ld	a4,0(s2)
 838:	853e                	mv	a0,a5
 83a:	fef719e3          	bne	a4,a5,82c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83e:	8552                	mv	a0,s4
 840:	ad3ff0ef          	jal	312 <sbrk>
  if(p == (char*)-1)
 844:	fd551ce3          	bne	a0,s5,81c <malloc+0x7e>
        return 0;
 848:	4501                	li	a0,0
 84a:	7902                	ld	s2,32(sp)
 84c:	6a42                	ld	s4,16(sp)
 84e:	6aa2                	ld	s5,8(sp)
 850:	6b02                	ld	s6,0(sp)
 852:	a03d                	j	880 <malloc+0xe2>
 854:	7902                	ld	s2,32(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85c:	fae48de3          	beq	s1,a4,816 <malloc+0x78>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	02071693          	slli	a3,a4,0x20
 86a:	01c6d713          	srli	a4,a3,0x1c
 86e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 874:	00000717          	auipc	a4,0x0
 878:	78a73623          	sd	a0,1932(a4) # 1000 <freep>
      return (void*)(p + 1);
 87c:	01078513          	addi	a0,a5,16
  }
}
 880:	70e2                	ld	ra,56(sp)
 882:	7442                	ld	s0,48(sp)
 884:	74a2                	ld	s1,40(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6121                	addi	sp,sp,64
 88a:	8082                	ret
 88c:	7902                	ld	s2,32(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	b7f5                	j	880 <malloc+0xe2>
