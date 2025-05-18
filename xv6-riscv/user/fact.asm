
user/_fact:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <is_positive_number>:
#include "kernel/types.h"
#include "user/user.h"

// Simple string-to-integer validation
int is_positive_number(char *s) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  for (int i = 0; s[i] != 0; i++) {
   6:	00054783          	lbu	a5,0(a0)
   a:	cf99                	beqz	a5,28 <is_positive_number+0x28>
   c:	0505                	addi	a0,a0,1
    if (s[i] < '0' || s[i] > '9')
   e:	4725                	li	a4,9
  10:	fd07879b          	addiw	a5,a5,-48
  14:	0ff7f793          	zext.b	a5,a5
  18:	00f76a63          	bltu	a4,a5,2c <is_positive_number+0x2c>
  for (int i = 0; s[i] != 0; i++) {
  1c:	0505                	addi	a0,a0,1
  1e:	fff54783          	lbu	a5,-1(a0)
  22:	f7fd                	bnez	a5,10 <is_positive_number+0x10>
      return 0;
  }
  return 1;
  24:	4505                	li	a0,1
  26:	a021                	j	2e <is_positive_number+0x2e>
  28:	4505                	li	a0,1
  2a:	a011                	j	2e <is_positive_number+0x2e>
      return 0;
  2c:	4501                	li	a0,0
}
  2e:	6422                	ld	s0,8(sp)
  30:	0141                	addi	sp,sp,16
  32:	8082                	ret

0000000000000034 <main>:

int main(int argc, char *argv[]) {
  34:	1101                	addi	sp,sp,-32
  36:	ec06                	sd	ra,24(sp)
  38:	e822                	sd	s0,16(sp)
  3a:	1000                	addi	s0,sp,32
  if (argc != 2) {
  3c:	4789                	li	a5,2
  3e:	02f51563          	bne	a0,a5,68 <main+0x34>
  42:	e426                	sd	s1,8(sp)
  44:	e04a                	sd	s2,0(sp)
  46:	84aa                	mv	s1,a0
    fprintf(2, "Usage: fact <non-negative integer>\n");
    exit(1);
  }

  if (!is_positive_number(argv[1])) {
  48:	0085b903          	ld	s2,8(a1)
  4c:	854a                	mv	a0,s2
  4e:	fb3ff0ef          	jal	0 <is_positive_number>
  52:	e51d                	bnez	a0,80 <main+0x4c>
    fprintf(2, "fact: please enter a non-negative integer\n");
  54:	00001597          	auipc	a1,0x1
  58:	90458593          	addi	a1,a1,-1788 # 958 <malloc+0x126>
  5c:	4509                	li	a0,2
  5e:	6f6000ef          	jal	754 <fprintf>
    exit(1);
  62:	4505                	li	a0,1
  64:	2ba000ef          	jal	31e <exit>
  68:	e426                	sd	s1,8(sp)
  6a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: fact <non-negative integer>\n");
  6c:	00001597          	auipc	a1,0x1
  70:	8c458593          	addi	a1,a1,-1852 # 930 <malloc+0xfe>
  74:	4509                	li	a0,2
  76:	6de000ef          	jal	754 <fprintf>
    exit(1);
  7a:	4505                	li	a0,1
  7c:	2a2000ef          	jal	31e <exit>
  }

  int n = atoi(argv[1]);
  80:	854a                	mv	a0,s2
  82:	1a6000ef          	jal	228 <atoi>
  86:	85aa                	mv	a1,a0
  int result = 1;
  for (int i = 2; i <= n; i++) {
  88:	4785                	li	a5,1
  8a:	02a7d363          	bge	a5,a0,b0 <main+0x7c>
  8e:	0015079b          	addiw	a5,a0,1
  int result = 1;
  92:	4605                	li	a2,1
    result *= i;
  94:	0296063b          	mulw	a2,a2,s1
  for (int i = 2; i <= n; i++) {
  98:	2485                	addiw	s1,s1,1
  9a:	fef49de3          	bne	s1,a5,94 <main+0x60>
  }

  printf("Factorial of %d is %d\n", n, result);
  9e:	00001517          	auipc	a0,0x1
  a2:	8ea50513          	addi	a0,a0,-1814 # 988 <malloc+0x156>
  a6:	6d8000ef          	jal	77e <printf>
  exit(0);
  aa:	4501                	li	a0,0
  ac:	272000ef          	jal	31e <exit>
  int result = 1;
  b0:	4605                	li	a2,1
  b2:	b7f5                	j	9e <main+0x6a>

00000000000000b4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  extern int main();
  main();
  bc:	f79ff0ef          	jal	34 <main>
  exit(0);
  c0:	4501                	li	a0,0
  c2:	25c000ef          	jal	31e <exit>

00000000000000c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  cc:	87aa                	mv	a5,a0
  ce:	0585                	addi	a1,a1,1
  d0:	0785                	addi	a5,a5,1
  d2:	fff5c703          	lbu	a4,-1(a1)
  d6:	fee78fa3          	sb	a4,-1(a5)
  da:	fb75                	bnez	a4,ce <strcpy+0x8>
    ;
  return os;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cb91                	beqz	a5,100 <strcmp+0x1e>
  ee:	0005c703          	lbu	a4,0(a1)
  f2:	00f71763          	bne	a4,a5,100 <strcmp+0x1e>
    p++, q++;
  f6:	0505                	addi	a0,a0,1
  f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	fbe5                	bnez	a5,ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 100:	0005c503          	lbu	a0,0(a1)
}
 104:	40a7853b          	subw	a0,a5,a0
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strlen>:

uint
strlen(const char *s)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cf91                	beqz	a5,134 <strlen+0x26>
 11a:	0505                	addi	a0,a0,1
 11c:	87aa                	mv	a5,a0
 11e:	86be                	mv	a3,a5
 120:	0785                	addi	a5,a5,1
 122:	fff7c703          	lbu	a4,-1(a5)
 126:	ff65                	bnez	a4,11e <strlen+0x10>
 128:	40a6853b          	subw	a0,a3,a0
 12c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret
  for(n = 0; s[n]; n++)
 134:	4501                	li	a0,0
 136:	bfe5                	j	12e <strlen+0x20>

0000000000000138 <memset>:

void*
memset(void *dst, int c, uint n)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 13e:	ca19                	beqz	a2,154 <memset+0x1c>
 140:	87aa                	mv	a5,a0
 142:	1602                	slli	a2,a2,0x20
 144:	9201                	srli	a2,a2,0x20
 146:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 14a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14e:	0785                	addi	a5,a5,1
 150:	fee79de3          	bne	a5,a4,14a <memset+0x12>
  }
  return dst;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strchr>:

char*
strchr(const char *s, char c)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cb99                	beqz	a5,17a <strchr+0x20>
    if(*s == c)
 166:	00f58763          	beq	a1,a5,174 <strchr+0x1a>
  for(; *s; s++)
 16a:	0505                	addi	a0,a0,1
 16c:	00054783          	lbu	a5,0(a0)
 170:	fbfd                	bnez	a5,166 <strchr+0xc>
      return (char*)s;
  return 0;
 172:	4501                	li	a0,0
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  return 0;
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strchr+0x1a>

000000000000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	711d                	addi	sp,sp,-96
 180:	ec86                	sd	ra,88(sp)
 182:	e8a2                	sd	s0,80(sp)
 184:	e4a6                	sd	s1,72(sp)
 186:	e0ca                	sd	s2,64(sp)
 188:	fc4e                	sd	s3,56(sp)
 18a:	f852                	sd	s4,48(sp)
 18c:	f456                	sd	s5,40(sp)
 18e:	f05a                	sd	s6,32(sp)
 190:	ec5e                	sd	s7,24(sp)
 192:	1080                	addi	s0,sp,96
 194:	8baa                	mv	s7,a0
 196:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	892a                	mv	s2,a0
 19a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 19c:	4aa9                	li	s5,10
 19e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a0:	89a6                	mv	s3,s1
 1a2:	2485                	addiw	s1,s1,1
 1a4:	0344d663          	bge	s1,s4,1d0 <gets+0x52>
    cc = read(0, &c, 1);
 1a8:	4605                	li	a2,1
 1aa:	faf40593          	addi	a1,s0,-81
 1ae:	4501                	li	a0,0
 1b0:	186000ef          	jal	336 <read>
    if(cc < 1)
 1b4:	00a05e63          	blez	a0,1d0 <gets+0x52>
    buf[i++] = c;
 1b8:	faf44783          	lbu	a5,-81(s0)
 1bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c0:	01578763          	beq	a5,s5,1ce <gets+0x50>
 1c4:	0905                	addi	s2,s2,1
 1c6:	fd679de3          	bne	a5,s6,1a0 <gets+0x22>
    buf[i++] = c;
 1ca:	89a6                	mv	s3,s1
 1cc:	a011                	j	1d0 <gets+0x52>
 1ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d0:	99de                	add	s3,s3,s7
 1d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d6:	855e                	mv	a0,s7
 1d8:	60e6                	ld	ra,88(sp)
 1da:	6446                	ld	s0,80(sp)
 1dc:	64a6                	ld	s1,72(sp)
 1de:	6906                	ld	s2,64(sp)
 1e0:	79e2                	ld	s3,56(sp)
 1e2:	7a42                	ld	s4,48(sp)
 1e4:	7aa2                	ld	s5,40(sp)
 1e6:	7b02                	ld	s6,32(sp)
 1e8:	6be2                	ld	s7,24(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <stat>:

int
stat(const char *n, struct stat *st)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec06                	sd	ra,24(sp)
 1f2:	e822                	sd	s0,16(sp)
 1f4:	e04a                	sd	s2,0(sp)
 1f6:	1000                	addi	s0,sp,32
 1f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	4581                	li	a1,0
 1fc:	162000ef          	jal	35e <open>
  if(fd < 0)
 200:	02054263          	bltz	a0,224 <stat+0x36>
 204:	e426                	sd	s1,8(sp)
 206:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 208:	85ca                	mv	a1,s2
 20a:	16c000ef          	jal	376 <fstat>
 20e:	892a                	mv	s2,a0
  close(fd);
 210:	8526                	mv	a0,s1
 212:	134000ef          	jal	346 <close>
  return r;
 216:	64a2                	ld	s1,8(sp)
}
 218:	854a                	mv	a0,s2
 21a:	60e2                	ld	ra,24(sp)
 21c:	6442                	ld	s0,16(sp)
 21e:	6902                	ld	s2,0(sp)
 220:	6105                	addi	sp,sp,32
 222:	8082                	ret
    return -1;
 224:	597d                	li	s2,-1
 226:	bfcd                	j	218 <stat+0x2a>

0000000000000228 <atoi>:

int
atoi(const char *s)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22e:	00054683          	lbu	a3,0(a0)
 232:	fd06879b          	addiw	a5,a3,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	4625                	li	a2,9
 23c:	02f66863          	bltu	a2,a5,26c <atoi+0x44>
 240:	872a                	mv	a4,a0
  n = 0;
 242:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 244:	0705                	addi	a4,a4,1
 246:	0025179b          	slliw	a5,a0,0x2
 24a:	9fa9                	addw	a5,a5,a0
 24c:	0017979b          	slliw	a5,a5,0x1
 250:	9fb5                	addw	a5,a5,a3
 252:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 256:	00074683          	lbu	a3,0(a4)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	fef671e3          	bgeu	a2,a5,244 <atoi+0x1c>
  return n;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
  n = 0;
 26c:	4501                	li	a0,0
 26e:	bfe5                	j	266 <atoi+0x3e>

0000000000000270 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 276:	02b57463          	bgeu	a0,a1,29e <memmove+0x2e>
    while(n-- > 0)
 27a:	00c05f63          	blez	a2,298 <memmove+0x28>
 27e:	1602                	slli	a2,a2,0x20
 280:	9201                	srli	a2,a2,0x20
 282:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 286:	872a                	mv	a4,a0
      *dst++ = *src++;
 288:	0585                	addi	a1,a1,1
 28a:	0705                	addi	a4,a4,1
 28c:	fff5c683          	lbu	a3,-1(a1)
 290:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 294:	fef71ae3          	bne	a4,a5,288 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
    dst += n;
 29e:	00c50733          	add	a4,a0,a2
    src += n;
 2a2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a4:	fec05ae3          	blez	a2,298 <memmove+0x28>
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	fff7c793          	not	a5,a5
 2b4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b6:	15fd                	addi	a1,a1,-1
 2b8:	177d                	addi	a4,a4,-1
 2ba:	0005c683          	lbu	a3,0(a1)
 2be:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c2:	fee79ae3          	bne	a5,a4,2b6 <memmove+0x46>
 2c6:	bfc9                	j	298 <memmove+0x28>

00000000000002c8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ce:	ca05                	beqz	a2,2fe <memcmp+0x36>
 2d0:	fff6069b          	addiw	a3,a2,-1
 2d4:	1682                	slli	a3,a3,0x20
 2d6:	9281                	srli	a3,a3,0x20
 2d8:	0685                	addi	a3,a3,1
 2da:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00e79863          	bne	a5,a4,2f4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e8:	0505                	addi	a0,a0,1
    p2++;
 2ea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ec:	fed518e3          	bne	a0,a3,2dc <memcmp+0x14>
  }
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	a019                	j	2f8 <memcmp+0x30>
      return *p1 - *p2;
 2f4:	40e7853b          	subw	a0,a5,a4
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <memcmp+0x30>

0000000000000302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30a:	f67ff0ef          	jal	270 <memmove>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3c6:	48dd                	li	a7,23
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3d6:	48e5                	li	a7,25
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3de:	48e9                	li	a7,26
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 3e6:	48ed                	li	a7,27
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 3ee:	48f1                	li	a7,28
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 3f6:	48f5                	li	a7,29
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3fe:	48f9                	li	a7,30
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	f27ff0ef          	jal	33e <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	7139                	addi	sp,sp,-64
 426:	fc06                	sd	ra,56(sp)
 428:	f822                	sd	s0,48(sp)
 42a:	f426                	sd	s1,40(sp)
 42c:	0080                	addi	s0,sp,64
 42e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 430:	c299                	beqz	a3,436 <printint+0x12>
 432:	0805c963          	bltz	a1,4c4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 436:	2581                	sext.w	a1,a1
  neg = 0;
 438:	4881                	li	a7,0
 43a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 43e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 440:	2601                	sext.w	a2,a2
 442:	00000517          	auipc	a0,0x0
 446:	56650513          	addi	a0,a0,1382 # 9a8 <digits>
 44a:	883a                	mv	a6,a4
 44c:	2705                	addiw	a4,a4,1
 44e:	02c5f7bb          	remuw	a5,a1,a2
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	97aa                	add	a5,a5,a0
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 460:	0005879b          	sext.w	a5,a1
 464:	02c5d5bb          	divuw	a1,a1,a2
 468:	0685                	addi	a3,a3,1
 46a:	fec7f0e3          	bgeu	a5,a2,44a <printint+0x26>
  if(neg)
 46e:	00088c63          	beqz	a7,486 <printint+0x62>
    buf[i++] = '-';
 472:	fd070793          	addi	a5,a4,-48
 476:	00878733          	add	a4,a5,s0
 47a:	02d00793          	li	a5,45
 47e:	fef70823          	sb	a5,-16(a4)
 482:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 486:	02e05a63          	blez	a4,4ba <printint+0x96>
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	fc040793          	addi	a5,s0,-64
 492:	00e78933          	add	s2,a5,a4
 496:	fff78993          	addi	s3,a5,-1
 49a:	99ba                	add	s3,s3,a4
 49c:	377d                	addiw	a4,a4,-1
 49e:	1702                	slli	a4,a4,0x20
 4a0:	9301                	srli	a4,a4,0x20
 4a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a6:	fff94583          	lbu	a1,-1(s2)
 4aa:	8526                	mv	a0,s1
 4ac:	f5bff0ef          	jal	406 <putc>
  while(--i >= 0)
 4b0:	197d                	addi	s2,s2,-1
 4b2:	ff391ae3          	bne	s2,s3,4a6 <printint+0x82>
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
}
 4ba:	70e2                	ld	ra,56(sp)
 4bc:	7442                	ld	s0,48(sp)
 4be:	74a2                	ld	s1,40(sp)
 4c0:	6121                	addi	sp,sp,64
 4c2:	8082                	ret
    x = -xx;
 4c4:	40b005bb          	negw	a1,a1
    neg = 1;
 4c8:	4885                	li	a7,1
    x = -xx;
 4ca:	bf85                	j	43a <printint+0x16>

00000000000004cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4cc:	711d                	addi	sp,sp,-96
 4ce:	ec86                	sd	ra,88(sp)
 4d0:	e8a2                	sd	s0,80(sp)
 4d2:	e0ca                	sd	s2,64(sp)
 4d4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d6:	0005c903          	lbu	s2,0(a1)
 4da:	26090863          	beqz	s2,74a <vprintf+0x27e>
 4de:	e4a6                	sd	s1,72(sp)
 4e0:	fc4e                	sd	s3,56(sp)
 4e2:	f852                	sd	s4,48(sp)
 4e4:	f456                	sd	s5,40(sp)
 4e6:	f05a                	sd	s6,32(sp)
 4e8:	ec5e                	sd	s7,24(sp)
 4ea:	e862                	sd	s8,16(sp)
 4ec:	e466                	sd	s9,8(sp)
 4ee:	8b2a                	mv	s6,a0
 4f0:	8a2e                	mv	s4,a1
 4f2:	8bb2                	mv	s7,a2
  state = 0;
 4f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f6:	4481                	li	s1,0
 4f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 502:	06c00c93          	li	s9,108
 506:	a005                	j	526 <vprintf+0x5a>
        putc(fd, c0);
 508:	85ca                	mv	a1,s2
 50a:	855a                	mv	a0,s6
 50c:	efbff0ef          	jal	406 <putc>
 510:	a019                	j	516 <vprintf+0x4a>
    } else if(state == '%'){
 512:	03598263          	beq	s3,s5,536 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 516:	2485                	addiw	s1,s1,1
 518:	8726                	mv	a4,s1
 51a:	009a07b3          	add	a5,s4,s1
 51e:	0007c903          	lbu	s2,0(a5)
 522:	20090c63          	beqz	s2,73a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 526:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52a:	fe0994e3          	bnez	s3,512 <vprintf+0x46>
      if(c0 == '%'){
 52e:	fd579de3          	bne	a5,s5,508 <vprintf+0x3c>
        state = '%';
 532:	89be                	mv	s3,a5
 534:	b7cd                	j	516 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 536:	00ea06b3          	add	a3,s4,a4
 53a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 53e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 540:	c681                	beqz	a3,548 <vprintf+0x7c>
 542:	9752                	add	a4,a4,s4
 544:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 548:	03878f63          	beq	a5,s8,586 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 54c:	05978963          	beq	a5,s9,59e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 550:	07500713          	li	a4,117
 554:	0ee78363          	beq	a5,a4,63a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 558:	07800713          	li	a4,120
 55c:	12e78563          	beq	a5,a4,686 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 560:	07000713          	li	a4,112
 564:	14e78a63          	beq	a5,a4,6b8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 568:	07300713          	li	a4,115
 56c:	18e78a63          	beq	a5,a4,700 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 570:	02500713          	li	a4,37
 574:	04e79563          	bne	a5,a4,5be <vprintf+0xf2>
        putc(fd, '%');
 578:	02500593          	li	a1,37
 57c:	855a                	mv	a0,s6
 57e:	e89ff0ef          	jal	406 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 582:	4981                	li	s3,0
 584:	bf49                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e91ff0ef          	jal	424 <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bfad                	j	516 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 59e:	06400793          	li	a5,100
 5a2:	02f68963          	beq	a3,a5,5d4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a6:	06c00793          	li	a5,108
 5aa:	04f68263          	beq	a3,a5,5ee <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5ae:	07500793          	li	a5,117
 5b2:	0af68063          	beq	a3,a5,652 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5b6:	07800793          	li	a5,120
 5ba:	0ef68263          	beq	a3,a5,69e <vprintf+0x1d2>
        putc(fd, '%');
 5be:	02500593          	li	a1,37
 5c2:	855a                	mv	a0,s6
 5c4:	e43ff0ef          	jal	406 <putc>
        putc(fd, c0);
 5c8:	85ca                	mv	a1,s2
 5ca:	855a                	mv	a0,s6
 5cc:	e3bff0ef          	jal	406 <putc>
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b791                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e43ff0ef          	jal	424 <printint>
        i += 1;
 5e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 1;
 5ec:	b72d                	j	516 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ee:	06400793          	li	a5,100
 5f2:	02f60763          	beq	a2,a5,620 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f6:	07500793          	li	a5,117
 5fa:	06f60963          	beq	a2,a5,66c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5fe:	07800793          	li	a5,120
 602:	faf61ee3          	bne	a2,a5,5be <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e11ff0ef          	jal	424 <printint>
        i += 2;
 618:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bde5                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	df7ff0ef          	jal	424 <printint>
        i += 2;
 632:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bdf9                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4681                	li	a3,0
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	dddff0ef          	jal	424 <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	b5d9                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	dc5ff0ef          	jal	424 <printint>
        i += 1;
 664:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 1;
 66a:	b575                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66c:	008b8913          	addi	s2,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	dabff0ef          	jal	424 <printint>
        i += 2;
 67e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	bd49                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4641                	li	a2,16
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d91ff0ef          	jal	424 <printint>
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bdad                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	d79ff0ef          	jal	424 <printint>
        i += 1;
 6b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	b585                	j	516 <vprintf+0x4a>
 6b8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ba:	008b8d13          	addi	s10,s7,8
 6be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c2:	03000593          	li	a1,48
 6c6:	855a                	mv	a0,s6
 6c8:	d3fff0ef          	jal	406 <putc>
  putc(fd, 'x');
 6cc:	07800593          	li	a1,120
 6d0:	855a                	mv	a0,s6
 6d2:	d35ff0ef          	jal	406 <putc>
 6d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	00000b97          	auipc	s7,0x0
 6dc:	2d0b8b93          	addi	s7,s7,720 # 9a8 <digits>
 6e0:	03c9d793          	srli	a5,s3,0x3c
 6e4:	97de                	add	a5,a5,s7
 6e6:	0007c583          	lbu	a1,0(a5)
 6ea:	855a                	mv	a0,s6
 6ec:	d1bff0ef          	jal	406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f0:	0992                	slli	s3,s3,0x4
 6f2:	397d                	addiw	s2,s2,-1
 6f4:	fe0916e3          	bnez	s2,6e0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6f8:	8bea                	mv	s7,s10
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	6d02                	ld	s10,0(sp)
 6fe:	bd21                	j	516 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 700:	008b8993          	addi	s3,s7,8
 704:	000bb903          	ld	s2,0(s7)
 708:	00090f63          	beqz	s2,726 <vprintf+0x25a>
        for(; *s; s++)
 70c:	00094583          	lbu	a1,0(s2)
 710:	c195                	beqz	a1,734 <vprintf+0x268>
          putc(fd, *s);
 712:	855a                	mv	a0,s6
 714:	cf3ff0ef          	jal	406 <putc>
        for(; *s; s++)
 718:	0905                	addi	s2,s2,1
 71a:	00094583          	lbu	a1,0(s2)
 71e:	f9f5                	bnez	a1,712 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	bbcd                	j	516 <vprintf+0x4a>
          s = "(null)";
 726:	00000917          	auipc	s2,0x0
 72a:	27a90913          	addi	s2,s2,634 # 9a0 <malloc+0x16e>
        for(; *s; s++)
 72e:	02800593          	li	a1,40
 732:	b7c5                	j	712 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 734:	8bce                	mv	s7,s3
      state = 0;
 736:	4981                	li	s3,0
 738:	bbf9                	j	516 <vprintf+0x4a>
 73a:	64a6                	ld	s1,72(sp)
 73c:	79e2                	ld	s3,56(sp)
 73e:	7a42                	ld	s4,48(sp)
 740:	7aa2                	ld	s5,40(sp)
 742:	7b02                	ld	s6,32(sp)
 744:	6be2                	ld	s7,24(sp)
 746:	6c42                	ld	s8,16(sp)
 748:	6ca2                	ld	s9,8(sp)
    }
  }
}
 74a:	60e6                	ld	ra,88(sp)
 74c:	6446                	ld	s0,80(sp)
 74e:	6906                	ld	s2,64(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 754:	715d                	addi	sp,sp,-80
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e010                	sd	a2,0(s0)
 75e:	e414                	sd	a3,8(s0)
 760:	e818                	sd	a4,16(s0)
 762:	ec1c                	sd	a5,24(s0)
 764:	03043023          	sd	a6,32(s0)
 768:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 770:	8622                	mv	a2,s0
 772:	d5bff0ef          	jal	4cc <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	d29ff0ef          	jal	4cc <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	1141                	addi	sp,sp,-16
 7b2:	e422                	sd	s0,8(sp)
 7b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	00001797          	auipc	a5,0x1
 7be:	8467b783          	ld	a5,-1978(a5) # 1000 <freep>
 7c2:	a02d                	j	7ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c4:	4618                	lw	a4,8(a2)
 7c6:	9f2d                	addw	a4,a4,a1
 7c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	6398                	ld	a4,0(a5)
 7ce:	6310                	ld	a2,0(a4)
 7d0:	a83d                	j	80e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9f31                	addw	a4,a4,a2
 7d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053683          	ld	a3,-16(a0)
 7de:	a091                	j	822 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e7e463          	bltu	a5,a4,7ea <free+0x3a>
 7e6:	00e6ea63          	bltu	a3,a4,7fa <free+0x4a>
{
 7ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	fed7fae3          	bgeu	a5,a3,7e0 <free+0x30>
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e6e463          	bltu	a3,a4,7fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	fee7eae3          	bltu	a5,a4,7ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fa:	ff852583          	lw	a1,-8(a0)
 7fe:	6390                	ld	a2,0(a5)
 800:	02059813          	slli	a6,a1,0x20
 804:	01c85713          	srli	a4,a6,0x1c
 808:	9736                	add	a4,a4,a3
 80a:	fae60de3          	beq	a2,a4,7c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 812:	4790                	lw	a2,8(a5)
 814:	02061593          	slli	a1,a2,0x20
 818:	01c5d713          	srli	a4,a1,0x1c
 81c:	973e                	add	a4,a4,a5
 81e:	fae68ae3          	beq	a3,a4,7d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 822:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 824:	00000717          	auipc	a4,0x0
 828:	7cf73e23          	sd	a5,2012(a4) # 1000 <freep>
}
 82c:	6422                	ld	s0,8(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret

0000000000000832 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 832:	7139                	addi	sp,sp,-64
 834:	fc06                	sd	ra,56(sp)
 836:	f822                	sd	s0,48(sp)
 838:	f426                	sd	s1,40(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83e:	02051493          	slli	s1,a0,0x20
 842:	9081                	srli	s1,s1,0x20
 844:	04bd                	addi	s1,s1,15
 846:	8091                	srli	s1,s1,0x4
 848:	0014899b          	addiw	s3,s1,1
 84c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 84e:	00000517          	auipc	a0,0x0
 852:	7b253503          	ld	a0,1970(a0) # 1000 <freep>
 856:	c915                	beqz	a0,88a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	08977a63          	bgeu	a4,s1,8f0 <malloc+0xbe>
 860:	f04a                	sd	s2,32(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 868:	8a4e                	mv	s4,s3
 86a:	0009871b          	sext.w	a4,s3
 86e:	6685                	lui	a3,0x1
 870:	00d77363          	bgeu	a4,a3,876 <malloc+0x44>
 874:	6a05                	lui	s4,0x1
 876:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87e:	00000917          	auipc	s2,0x0
 882:	78290913          	addi	s2,s2,1922 # 1000 <freep>
  if(p == (char*)-1)
 886:	5afd                	li	s5,-1
 888:	a081                	j	8c8 <malloc+0x96>
 88a:	f04a                	sd	s2,32(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 892:	00000797          	auipc	a5,0x0
 896:	77e78793          	addi	a5,a5,1918 # 1010 <base>
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
 8a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a8:	b7c1                	j	868 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	e118                	sd	a4,0(a0)
 8ae:	a8a9                	j	908 <malloc+0xd6>
  hp->s.size = nu;
 8b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b4:	0541                	addi	a0,a0,16
 8b6:	efbff0ef          	jal	7b0 <free>
  return freep;
 8ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8be:	c12d                	beqz	a0,920 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	02977263          	bgeu	a4,s1,8e8 <malloc+0xb6>
    if(p == freep)
 8c8:	00093703          	ld	a4,0(s2)
 8cc:	853e                	mv	a0,a5
 8ce:	fef719e3          	bne	a4,a5,8c0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	ad3ff0ef          	jal	3a6 <sbrk>
  if(p == (char*)-1)
 8d8:	fd551ce3          	bne	a0,s5,8b0 <malloc+0x7e>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xe2>
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f0:	fae48de3          	beq	s1,a4,8aa <malloc+0x78>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	74a2                	ld	s1,40(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	7902                	ld	s2,32(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xe2>
