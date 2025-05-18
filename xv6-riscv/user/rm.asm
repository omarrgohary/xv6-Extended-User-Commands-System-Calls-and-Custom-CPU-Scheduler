
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d763          	bge	a5,a0,38 <main+0x38>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	2f8000ef          	jal	320 <unlink>
  2c:	02054263          	bltz	a0,50 <main+0x50>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a02d                	j	60 <main+0x60>
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	8a458593          	addi	a1,a1,-1884 # 8e0 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	6c0000ef          	jal	706 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	284000ef          	jal	2d0 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  50:	6090                	ld	a2,0(s1)
  52:	00001597          	auipc	a1,0x1
  56:	8a658593          	addi	a1,a1,-1882 # 8f8 <malloc+0x114>
  5a:	4509                	li	a0,2
  5c:	6aa000ef          	jal	706 <fprintf>
      break;
    }
  }

  exit(0);
  60:	4501                	li	a0,0
  62:	26e000ef          	jal	2d0 <exit>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	25c000ef          	jal	2d0 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	86be                	mv	a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	ff65                	bnez	a4,d0 <strlen+0x10>
  da:	40a6853b          	subw	a0,a3,a0
  de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d663          	bge	s1,s4,182 <gets+0x52>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	186000ef          	jal	2e8 <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x52>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x50>
 176:	0905                	addi	s2,s2,1
 178:	fd679de3          	bne	a5,s6,152 <gets+0x22>
    buf[i++] = c;
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x52>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e04a                	sd	s2,0(sp)
 1a8:	1000                	addi	s0,sp,32
 1aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ac:	4581                	li	a1,0
 1ae:	162000ef          	jal	310 <open>
  if(fd < 0)
 1b2:	02054263          	bltz	a0,1d6 <stat+0x36>
 1b6:	e426                	sd	s1,8(sp)
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	16c000ef          	jal	328 <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	134000ef          	jal	2f8 <close>
  return r;
 1c8:	64a2                	ld	s1,8(sp)
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfcd                	j	1ca <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054683          	lbu	a3,0(a0)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	4625                	li	a2,9
 1ee:	02f66863          	bltu	a2,a5,21e <atoi+0x44>
 1f2:	872a                	mv	a4,a0
  n = 0;
 1f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f6:	0705                	addi	a4,a4,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb5                	addw	a5,a5,a3
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	00074683          	lbu	a3,0(a4)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	fef671e3          	bgeu	a2,a5,1f6 <atoi+0x1c>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x3e>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
    while(n-- > 0)
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 238:	872a                	mv	a4,a0
      *dst++ = *src++;
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 246:	fef71ae3          	bne	a4,a5,23a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    dst += n;
 250:	00c50733          	add	a4,a0,a2
    src += n;
 254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	f67ff0ef          	jal	222 <memmove>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c8:	4885                	li	a7,1
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d0:	4889                	li	a7,2
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d8:	488d                	li	a7,3
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <close>:
.global close
close:
 li a7, SYS_close
 2f8:	48d5                	li	a7,21
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48bd                	li	a7,15
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 318:	48c5                	li	a7,17
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 320:	48c9                	li	a7,18
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 328:	48a1                	li	a7,8
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <link>:
.global link
link:
 li a7, SYS_link
 330:	48cd                	li	a7,19
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 338:	48d1                	li	a7,20
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 340:	48a5                	li	a7,9
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <dup>:
.global dup
dup:
 li a7, SYS_dup
 348:	48a9                	li	a7,10
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 350:	48ad                	li	a7,11
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 358:	48b1                	li	a7,12
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 360:	48b5                	li	a7,13
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 368:	48b9                	li	a7,14
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 370:	48d9                	li	a7,22
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 378:	48dd                	li	a7,23
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 380:	48e1                	li	a7,24
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 388:	48e5                	li	a7,25
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 390:	48e9                	li	a7,26
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 398:	48ed                	li	a7,27
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 3a0:	48f1                	li	a7,28
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 3a8:	48f5                	li	a7,29
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3b0:	48f9                	li	a7,30
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	fef40593          	addi	a1,s0,-17
 3ca:	f27ff0ef          	jal	2f0 <write>
}
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6105                	addi	sp,sp,32
 3d4:	8082                	ret

00000000000003d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d6:	7139                	addi	sp,sp,-64
 3d8:	fc06                	sd	ra,56(sp)
 3da:	f822                	sd	s0,48(sp)
 3dc:	f426                	sd	s1,40(sp)
 3de:	0080                	addi	s0,sp,64
 3e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e2:	c299                	beqz	a3,3e8 <printint+0x12>
 3e4:	0805c963          	bltz	a1,476 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e8:	2581                	sext.w	a1,a1
  neg = 0;
 3ea:	4881                	li	a7,0
 3ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f2:	2601                	sext.w	a2,a2
 3f4:	00000517          	auipc	a0,0x0
 3f8:	52c50513          	addi	a0,a0,1324 # 920 <digits>
 3fc:	883a                	mv	a6,a4
 3fe:	2705                	addiw	a4,a4,1
 400:	02c5f7bb          	remuw	a5,a1,a2
 404:	1782                	slli	a5,a5,0x20
 406:	9381                	srli	a5,a5,0x20
 408:	97aa                	add	a5,a5,a0
 40a:	0007c783          	lbu	a5,0(a5)
 40e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 412:	0005879b          	sext.w	a5,a1
 416:	02c5d5bb          	divuw	a1,a1,a2
 41a:	0685                	addi	a3,a3,1
 41c:	fec7f0e3          	bgeu	a5,a2,3fc <printint+0x26>
  if(neg)
 420:	00088c63          	beqz	a7,438 <printint+0x62>
    buf[i++] = '-';
 424:	fd070793          	addi	a5,a4,-48
 428:	00878733          	add	a4,a5,s0
 42c:	02d00793          	li	a5,45
 430:	fef70823          	sb	a5,-16(a4)
 434:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 438:	02e05a63          	blez	a4,46c <printint+0x96>
 43c:	f04a                	sd	s2,32(sp)
 43e:	ec4e                	sd	s3,24(sp)
 440:	fc040793          	addi	a5,s0,-64
 444:	00e78933          	add	s2,a5,a4
 448:	fff78993          	addi	s3,a5,-1
 44c:	99ba                	add	s3,s3,a4
 44e:	377d                	addiw	a4,a4,-1
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 458:	fff94583          	lbu	a1,-1(s2)
 45c:	8526                	mv	a0,s1
 45e:	f5bff0ef          	jal	3b8 <putc>
  while(--i >= 0)
 462:	197d                	addi	s2,s2,-1
 464:	ff391ae3          	bne	s2,s3,458 <printint+0x82>
 468:	7902                	ld	s2,32(sp)
 46a:	69e2                	ld	s3,24(sp)
}
 46c:	70e2                	ld	ra,56(sp)
 46e:	7442                	ld	s0,48(sp)
 470:	74a2                	ld	s1,40(sp)
 472:	6121                	addi	sp,sp,64
 474:	8082                	ret
    x = -xx;
 476:	40b005bb          	negw	a1,a1
    neg = 1;
 47a:	4885                	li	a7,1
    x = -xx;
 47c:	bf85                	j	3ec <printint+0x16>

000000000000047e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47e:	711d                	addi	sp,sp,-96
 480:	ec86                	sd	ra,88(sp)
 482:	e8a2                	sd	s0,80(sp)
 484:	e0ca                	sd	s2,64(sp)
 486:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 488:	0005c903          	lbu	s2,0(a1)
 48c:	26090863          	beqz	s2,6fc <vprintf+0x27e>
 490:	e4a6                	sd	s1,72(sp)
 492:	fc4e                	sd	s3,56(sp)
 494:	f852                	sd	s4,48(sp)
 496:	f456                	sd	s5,40(sp)
 498:	f05a                	sd	s6,32(sp)
 49a:	ec5e                	sd	s7,24(sp)
 49c:	e862                	sd	s8,16(sp)
 49e:	e466                	sd	s9,8(sp)
 4a0:	8b2a                	mv	s6,a0
 4a2:	8a2e                	mv	s4,a1
 4a4:	8bb2                	mv	s7,a2
  state = 0;
 4a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a8:	4481                	li	s1,0
 4aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b4:	06c00c93          	li	s9,108
 4b8:	a005                	j	4d8 <vprintf+0x5a>
        putc(fd, c0);
 4ba:	85ca                	mv	a1,s2
 4bc:	855a                	mv	a0,s6
 4be:	efbff0ef          	jal	3b8 <putc>
 4c2:	a019                	j	4c8 <vprintf+0x4a>
    } else if(state == '%'){
 4c4:	03598263          	beq	s3,s5,4e8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4c8:	2485                	addiw	s1,s1,1
 4ca:	8726                	mv	a4,s1
 4cc:	009a07b3          	add	a5,s4,s1
 4d0:	0007c903          	lbu	s2,0(a5)
 4d4:	20090c63          	beqz	s2,6ec <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4dc:	fe0994e3          	bnez	s3,4c4 <vprintf+0x46>
      if(c0 == '%'){
 4e0:	fd579de3          	bne	a5,s5,4ba <vprintf+0x3c>
        state = '%';
 4e4:	89be                	mv	s3,a5
 4e6:	b7cd                	j	4c8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e8:	00ea06b3          	add	a3,s4,a4
 4ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f2:	c681                	beqz	a3,4fa <vprintf+0x7c>
 4f4:	9752                	add	a4,a4,s4
 4f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fa:	03878f63          	beq	a5,s8,538 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	05978963          	beq	a5,s9,550 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 502:	07500713          	li	a4,117
 506:	0ee78363          	beq	a5,a4,5ec <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50a:	07800713          	li	a4,120
 50e:	12e78563          	beq	a5,a4,638 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 512:	07000713          	li	a4,112
 516:	14e78a63          	beq	a5,a4,66a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 51a:	07300713          	li	a4,115
 51e:	18e78a63          	beq	a5,a4,6b2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 522:	02500713          	li	a4,37
 526:	04e79563          	bne	a5,a4,570 <vprintf+0xf2>
        putc(fd, '%');
 52a:	02500593          	li	a1,37
 52e:	855a                	mv	a0,s6
 530:	e89ff0ef          	jal	3b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 534:	4981                	li	s3,0
 536:	bf49                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e91ff0ef          	jal	3d6 <printint>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bfad                	j	4c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	06400793          	li	a5,100
 554:	02f68963          	beq	a3,a5,586 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06c00793          	li	a5,108
 55c:	04f68263          	beq	a3,a5,5a0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 560:	07500793          	li	a5,117
 564:	0af68063          	beq	a3,a5,604 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 568:	07800793          	li	a5,120
 56c:	0ef68263          	beq	a3,a5,650 <vprintf+0x1d2>
        putc(fd, '%');
 570:	02500593          	li	a1,37
 574:	855a                	mv	a0,s6
 576:	e43ff0ef          	jal	3b8 <putc>
        putc(fd, c0);
 57a:	85ca                	mv	a1,s2
 57c:	855a                	mv	a0,s6
 57e:	e3bff0ef          	jal	3b8 <putc>
      state = 0;
 582:	4981                	li	s3,0
 584:	b791                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e43ff0ef          	jal	3d6 <printint>
        i += 1;
 598:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 1;
 59e:	b72d                	j	4c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f60763          	beq	a2,a5,5d2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a8:	07500793          	li	a5,117
 5ac:	06f60963          	beq	a2,a5,61e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b0:	07800793          	li	a5,120
 5b4:	faf61ee3          	bne	a2,a5,570 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e11ff0ef          	jal	3d6 <printint>
        i += 2;
 5ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bde5                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	df7ff0ef          	jal	3d6 <printint>
        i += 2;
 5e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	bdf9                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000ba583          	lw	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dddff0ef          	jal	3d6 <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b5d9                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dc5ff0ef          	jal	3d6 <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b575                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	dabff0ef          	jal	3d6 <printint>
        i += 2;
 630:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	bd49                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 638:	008b8913          	addi	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d91ff0ef          	jal	3d6 <printint>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bdad                	j	4c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d79ff0ef          	jal	3d6 <printint>
        i += 1;
 662:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	b585                	j	4c8 <vprintf+0x4a>
 66a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66c:	008b8d13          	addi	s10,s7,8
 670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	855a                	mv	a0,s6
 67a:	d3fff0ef          	jal	3b8 <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	855a                	mv	a0,s6
 684:	d35ff0ef          	jal	3b8 <putc>
 688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	296b8b93          	addi	s7,s7,662 # 920 <digits>
 692:	03c9d793          	srli	a5,s3,0x3c
 696:	97de                	add	a5,a5,s7
 698:	0007c583          	lbu	a1,0(a5)
 69c:	855a                	mv	a0,s6
 69e:	d1bff0ef          	jal	3b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0916e3          	bnez	s2,692 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8bea                	mv	s7,s10
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6d02                	ld	s10,0(sp)
 6b0:	bd21                	j	4c8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	008b8993          	addi	s3,s7,8
 6b6:	000bb903          	ld	s2,0(s7)
 6ba:	00090f63          	beqz	s2,6d8 <vprintf+0x25a>
        for(; *s; s++)
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c195                	beqz	a1,6e6 <vprintf+0x268>
          putc(fd, *s);
 6c4:	855a                	mv	a0,s6
 6c6:	cf3ff0ef          	jal	3b8 <putc>
        for(; *s; s++)
 6ca:	0905                	addi	s2,s2,1
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	f9f5                	bnez	a1,6c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6d2:	8bce                	mv	s7,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bbcd                	j	4c8 <vprintf+0x4a>
          s = "(null)";
 6d8:	00000917          	auipc	s2,0x0
 6dc:	24090913          	addi	s2,s2,576 # 918 <malloc+0x134>
        for(; *s; s++)
 6e0:	02800593          	li	a1,40
 6e4:	b7c5                	j	6c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	8bce                	mv	s7,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bbf9                	j	4c8 <vprintf+0x4a>
 6ec:	64a6                	ld	s1,72(sp)
 6ee:	79e2                	ld	s3,56(sp)
 6f0:	7a42                	ld	s4,48(sp)
 6f2:	7aa2                	ld	s5,40(sp)
 6f4:	7b02                	ld	s6,32(sp)
 6f6:	6be2                	ld	s7,24(sp)
 6f8:	6c42                	ld	s8,16(sp)
 6fa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6fc:	60e6                	ld	ra,88(sp)
 6fe:	6446                	ld	s0,80(sp)
 700:	6906                	ld	s2,64(sp)
 702:	6125                	addi	sp,sp,96
 704:	8082                	ret

0000000000000706 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 706:	715d                	addi	sp,sp,-80
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e010                	sd	a2,0(s0)
 710:	e414                	sd	a3,8(s0)
 712:	e818                	sd	a4,16(s0)
 714:	ec1c                	sd	a5,24(s0)
 716:	03043023          	sd	a6,32(s0)
 71a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 722:	8622                	mv	a2,s0
 724:	d5bff0ef          	jal	47e <vprintf>
}
 728:	60e2                	ld	ra,24(sp)
 72a:	6442                	ld	s0,16(sp)
 72c:	6161                	addi	sp,sp,80
 72e:	8082                	ret

0000000000000730 <printf>:

void
printf(const char *fmt, ...)
{
 730:	711d                	addi	sp,sp,-96
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e40c                	sd	a1,8(s0)
 73a:	e810                	sd	a2,16(s0)
 73c:	ec14                	sd	a3,24(s0)
 73e:	f018                	sd	a4,32(s0)
 740:	f41c                	sd	a5,40(s0)
 742:	03043823          	sd	a6,48(s0)
 746:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	00840613          	addi	a2,s0,8
 74e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 752:	85aa                	mv	a1,a0
 754:	4505                	li	a0,1
 756:	d29ff0ef          	jal	47e <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6125                	addi	sp,sp,96
 760:	8082                	ret

0000000000000762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 762:	1141                	addi	sp,sp,-16
 764:	e422                	sd	s0,8(sp)
 766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	00001797          	auipc	a5,0x1
 770:	8947b783          	ld	a5,-1900(a5) # 1000 <freep>
 774:	a02d                	j	79e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 776:	4618                	lw	a4,8(a2)
 778:	9f2d                	addw	a4,a4,a1
 77a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	6398                	ld	a4,0(a5)
 780:	6310                	ld	a2,0(a4)
 782:	a83d                	j	7c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 784:	ff852703          	lw	a4,-8(a0)
 788:	9f31                	addw	a4,a4,a2
 78a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78c:	ff053683          	ld	a3,-16(a0)
 790:	a091                	j	7d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	6398                	ld	a4,0(a5)
 794:	00e7e463          	bltu	a5,a4,79c <free+0x3a>
 798:	00e6ea63          	bltu	a3,a4,7ac <free+0x4a>
{
 79c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	fed7fae3          	bgeu	a5,a3,792 <free+0x30>
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e6e463          	bltu	a3,a4,7ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	fee7eae3          	bltu	a5,a4,79c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7ac:	ff852583          	lw	a1,-8(a0)
 7b0:	6390                	ld	a2,0(a5)
 7b2:	02059813          	slli	a6,a1,0x20
 7b6:	01c85713          	srli	a4,a6,0x1c
 7ba:	9736                	add	a4,a4,a3
 7bc:	fae60de3          	beq	a2,a4,776 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c4:	4790                	lw	a2,8(a5)
 7c6:	02061593          	slli	a1,a2,0x20
 7ca:	01c5d713          	srli	a4,a1,0x1c
 7ce:	973e                	add	a4,a4,a5
 7d0:	fae68ae3          	beq	a3,a4,784 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d6:	00001717          	auipc	a4,0x1
 7da:	82f73523          	sd	a5,-2006(a4) # 1000 <freep>
}
 7de:	6422                	ld	s0,8(sp)
 7e0:	0141                	addi	sp,sp,16
 7e2:	8082                	ret

00000000000007e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e4:	7139                	addi	sp,sp,-64
 7e6:	fc06                	sd	ra,56(sp)
 7e8:	f822                	sd	s0,48(sp)
 7ea:	f426                	sd	s1,40(sp)
 7ec:	ec4e                	sd	s3,24(sp)
 7ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	02051493          	slli	s1,a0,0x20
 7f4:	9081                	srli	s1,s1,0x20
 7f6:	04bd                	addi	s1,s1,15
 7f8:	8091                	srli	s1,s1,0x4
 7fa:	0014899b          	addiw	s3,s1,1
 7fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 800:	00001517          	auipc	a0,0x1
 804:	80053503          	ld	a0,-2048(a0) # 1000 <freep>
 808:	c915                	beqz	a0,83c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	08977a63          	bgeu	a4,s1,8a2 <malloc+0xbe>
 812:	f04a                	sd	s2,32(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81a:	8a4e                	mv	s4,s3
 81c:	0009871b          	sext.w	a4,s3
 820:	6685                	lui	a3,0x1
 822:	00d77363          	bgeu	a4,a3,828 <malloc+0x44>
 826:	6a05                	lui	s4,0x1
 828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 830:	00000917          	auipc	s2,0x0
 834:	7d090913          	addi	s2,s2,2000 # 1000 <freep>
  if(p == (char*)-1)
 838:	5afd                	li	s5,-1
 83a:	a081                	j	87a <malloc+0x96>
 83c:	f04a                	sd	s2,32(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	7cc78793          	addi	a5,a5,1996 # 1010 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	7af73a23          	sd	a5,1972(a4) # 1000 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7c1                	j	81a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	e118                	sd	a4,0(a0)
 860:	a8a9                	j	8ba <malloc+0xd6>
  hp->s.size = nu;
 862:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 866:	0541                	addi	a0,a0,16
 868:	efbff0ef          	jal	762 <free>
  return freep;
 86c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 870:	c12d                	beqz	a0,8d2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 874:	4798                	lw	a4,8(a5)
 876:	02977263          	bgeu	a4,s1,89a <malloc+0xb6>
    if(p == freep)
 87a:	00093703          	ld	a4,0(s2)
 87e:	853e                	mv	a0,a5
 880:	fef719e3          	bne	a4,a5,872 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 884:	8552                	mv	a0,s4
 886:	ad3ff0ef          	jal	358 <sbrk>
  if(p == (char*)-1)
 88a:	fd551ce3          	bne	a0,s5,862 <malloc+0x7e>
        return 0;
 88e:	4501                	li	a0,0
 890:	7902                	ld	s2,32(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	a03d                	j	8c6 <malloc+0xe2>
 89a:	7902                	ld	s2,32(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8a2:	fae48de3          	beq	s1,a4,85c <malloc+0x78>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	02071693          	slli	a3,a4,0x20
 8b0:	01c6d713          	srli	a4,a3,0x1c
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	74a73323          	sd	a0,1862(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6121                	addi	sp,sp,64
 8d0:	8082                	ret
 8d2:	7902                	ld	s2,32(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	b7f5                	j	8c6 <malloc+0xe2>
