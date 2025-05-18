
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	93250513          	addi	a0,a0,-1742 # 940 <malloc+0x106>
  16:	350000ef          	jal	366 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	37e000ef          	jal	39e <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	378000ef          	jal	39e <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	91e90913          	addi	s2,s2,-1762 # 948 <malloc+0x10e>
  32:	854a                	mv	a0,s2
  34:	752000ef          	jal	786 <printf>
    pid = fork();
  38:	2e6000ef          	jal	31e <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	2e8000ef          	jal	32e <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	94650513          	addi	a0,a0,-1722 # 998 <malloc+0x15e>
  5a:	72c000ef          	jal	786 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2c6000ef          	jal	326 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8d850513          	addi	a0,a0,-1832 # 940 <malloc+0x106>
  70:	2fe000ef          	jal	36e <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8ca50513          	addi	a0,a0,-1846 # 940 <malloc+0x106>
  7e:	2e8000ef          	jal	366 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8dc50513          	addi	a0,a0,-1828 # 960 <malloc+0x126>
  8c:	6fa000ef          	jal	786 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	294000ef          	jal	326 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8da50513          	addi	a0,a0,-1830 # 978 <malloc+0x13e>
  a6:	2b8000ef          	jal	35e <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8d650513          	addi	a0,a0,-1834 # 980 <malloc+0x146>
  b2:	6d4000ef          	jal	786 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	26e000ef          	jal	326 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	25c000ef          	jal	326 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0x8>
    ;
  return os;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cb91                	beqz	a5,108 <strcmp+0x1e>
  f6:	0005c703          	lbu	a4,0(a1)
  fa:	00f71763          	bne	a4,a5,108 <strcmp+0x1e>
    p++, q++;
  fe:	0505                	addi	a0,a0,1
 100:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	fbe5                	bnez	a5,f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 108:	0005c503          	lbu	a0,0(a1)
}
 10c:	40a7853b          	subw	a0,a5,a0
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strlen>:

uint
strlen(const char *s)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cf91                	beqz	a5,13c <strlen+0x26>
 122:	0505                	addi	a0,a0,1
 124:	87aa                	mv	a5,a0
 126:	86be                	mv	a3,a5
 128:	0785                	addi	a5,a5,1
 12a:	fff7c703          	lbu	a4,-1(a5)
 12e:	ff65                	bnez	a4,126 <strlen+0x10>
 130:	40a6853b          	subw	a0,a3,a0
 134:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  for(n = 0; s[n]; n++)
 13c:	4501                	li	a0,0
 13e:	bfe5                	j	136 <strlen+0x20>

0000000000000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 146:	ca19                	beqz	a2,15c <memset+0x1c>
 148:	87aa                	mv	a5,a0
 14a:	1602                	slli	a2,a2,0x20
 14c:	9201                	srli	a2,a2,0x20
 14e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 156:	0785                	addi	a5,a5,1
 158:	fee79de3          	bne	a5,a4,152 <memset+0x12>
  }
  return dst;
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strchr>:

char*
strchr(const char *s, char c)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  for(; *s; s++)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb99                	beqz	a5,182 <strchr+0x20>
    if(*s == c)
 16e:	00f58763          	beq	a1,a5,17c <strchr+0x1a>
  for(; *s; s++)
 172:	0505                	addi	a0,a0,1
 174:	00054783          	lbu	a5,0(a0)
 178:	fbfd                	bnez	a5,16e <strchr+0xc>
      return (char*)s;
  return 0;
 17a:	4501                	li	a0,0
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  return 0;
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strchr+0x1a>

0000000000000186 <gets>:

char*
gets(char *buf, int max)
{
 186:	711d                	addi	sp,sp,-96
 188:	ec86                	sd	ra,88(sp)
 18a:	e8a2                	sd	s0,80(sp)
 18c:	e4a6                	sd	s1,72(sp)
 18e:	e0ca                	sd	s2,64(sp)
 190:	fc4e                	sd	s3,56(sp)
 192:	f852                	sd	s4,48(sp)
 194:	f456                	sd	s5,40(sp)
 196:	f05a                	sd	s6,32(sp)
 198:	ec5e                	sd	s7,24(sp)
 19a:	1080                	addi	s0,sp,96
 19c:	8baa                	mv	s7,a0
 19e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	892a                	mv	s2,a0
 1a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a4:	4aa9                	li	s5,10
 1a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a8:	89a6                	mv	s3,s1
 1aa:	2485                	addiw	s1,s1,1
 1ac:	0344d663          	bge	s1,s4,1d8 <gets+0x52>
    cc = read(0, &c, 1);
 1b0:	4605                	li	a2,1
 1b2:	faf40593          	addi	a1,s0,-81
 1b6:	4501                	li	a0,0
 1b8:	186000ef          	jal	33e <read>
    if(cc < 1)
 1bc:	00a05e63          	blez	a0,1d8 <gets+0x52>
    buf[i++] = c;
 1c0:	faf44783          	lbu	a5,-81(s0)
 1c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c8:	01578763          	beq	a5,s5,1d6 <gets+0x50>
 1cc:	0905                	addi	s2,s2,1
 1ce:	fd679de3          	bne	a5,s6,1a8 <gets+0x22>
    buf[i++] = c;
 1d2:	89a6                	mv	s3,s1
 1d4:	a011                	j	1d8 <gets+0x52>
 1d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d8:	99de                	add	s3,s3,s7
 1da:	00098023          	sb	zero,0(s3)
  return buf;
}
 1de:	855e                	mv	a0,s7
 1e0:	60e6                	ld	ra,88(sp)
 1e2:	6446                	ld	s0,80(sp)
 1e4:	64a6                	ld	s1,72(sp)
 1e6:	6906                	ld	s2,64(sp)
 1e8:	79e2                	ld	s3,56(sp)
 1ea:	7a42                	ld	s4,48(sp)
 1ec:	7aa2                	ld	s5,40(sp)
 1ee:	7b02                	ld	s6,32(sp)
 1f0:	6be2                	ld	s7,24(sp)
 1f2:	6125                	addi	sp,sp,96
 1f4:	8082                	ret

00000000000001f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f6:	1101                	addi	sp,sp,-32
 1f8:	ec06                	sd	ra,24(sp)
 1fa:	e822                	sd	s0,16(sp)
 1fc:	e04a                	sd	s2,0(sp)
 1fe:	1000                	addi	s0,sp,32
 200:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 202:	4581                	li	a1,0
 204:	162000ef          	jal	366 <open>
  if(fd < 0)
 208:	02054263          	bltz	a0,22c <stat+0x36>
 20c:	e426                	sd	s1,8(sp)
 20e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 210:	85ca                	mv	a1,s2
 212:	16c000ef          	jal	37e <fstat>
 216:	892a                	mv	s2,a0
  close(fd);
 218:	8526                	mv	a0,s1
 21a:	134000ef          	jal	34e <close>
  return r;
 21e:	64a2                	ld	s1,8(sp)
}
 220:	854a                	mv	a0,s2
 222:	60e2                	ld	ra,24(sp)
 224:	6442                	ld	s0,16(sp)
 226:	6902                	ld	s2,0(sp)
 228:	6105                	addi	sp,sp,32
 22a:	8082                	ret
    return -1;
 22c:	597d                	li	s2,-1
 22e:	bfcd                	j	220 <stat+0x2a>

0000000000000230 <atoi>:

int
atoi(const char *s)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054683          	lbu	a3,0(a0)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	4625                	li	a2,9
 244:	02f66863          	bltu	a2,a5,274 <atoi+0x44>
 248:	872a                	mv	a4,a0
  n = 0;
 24a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24c:	0705                	addi	a4,a4,1
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	9fb5                	addw	a5,a5,a3
 25a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25e:	00074683          	lbu	a3,0(a4)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	fef671e3          	bgeu	a2,a5,24c <atoi+0x1c>
  return n;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  n = 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <atoi+0x3e>

0000000000000278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27e:	02b57463          	bgeu	a0,a1,2a6 <memmove+0x2e>
    while(n-- > 0)
 282:	00c05f63          	blez	a2,2a0 <memmove+0x28>
 286:	1602                	slli	a2,a2,0x20
 288:	9201                	srli	a2,a2,0x20
 28a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28e:	872a                	mv	a4,a0
      *dst++ = *src++;
 290:	0585                	addi	a1,a1,1
 292:	0705                	addi	a4,a4,1
 294:	fff5c683          	lbu	a3,-1(a1)
 298:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29c:	fef71ae3          	bne	a4,a5,290 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
    dst += n;
 2a6:	00c50733          	add	a4,a0,a2
    src += n;
 2aa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ac:	fec05ae3          	blez	a2,2a0 <memmove+0x28>
 2b0:	fff6079b          	addiw	a5,a2,-1
 2b4:	1782                	slli	a5,a5,0x20
 2b6:	9381                	srli	a5,a5,0x20
 2b8:	fff7c793          	not	a5,a5
 2bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2be:	15fd                	addi	a1,a1,-1
 2c0:	177d                	addi	a4,a4,-1
 2c2:	0005c683          	lbu	a3,0(a1)
 2c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x46>
 2ce:	bfc9                	j	2a0 <memmove+0x28>

00000000000002d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	ca05                	beqz	a2,306 <memcmp+0x36>
 2d8:	fff6069b          	addiw	a3,a2,-1
 2dc:	1682                	slli	a3,a3,0x20
 2de:	9281                	srli	a3,a3,0x20
 2e0:	0685                	addi	a3,a3,1
 2e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00e79863          	bne	a5,a4,2fc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f0:	0505                	addi	a0,a0,1
    p2++;
 2f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f4:	fed518e3          	bne	a0,a3,2e4 <memcmp+0x14>
  }
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	a019                	j	300 <memcmp+0x30>
      return *p1 - *p2;
 2fc:	40e7853b          	subw	a0,a5,a4
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  return 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <memcmp+0x30>

000000000000030a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 312:	f67ff0ef          	jal	278 <memmove>
}
 316:	60a2                	ld	ra,8(sp)
 318:	6402                	ld	s0,0(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret

000000000000031e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31e:	4885                	li	a7,1
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exit>:
.global exit
exit:
 li a7, SYS_exit
 326:	4889                	li	a7,2
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <wait>:
.global wait
wait:
 li a7, SYS_wait
 32e:	488d                	li	a7,3
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 336:	4891                	li	a7,4
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <read>:
.global read
read:
 li a7, SYS_read
 33e:	4895                	li	a7,5
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <write>:
.global write
write:
 li a7, SYS_write
 346:	48c1                	li	a7,16
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <close>:
.global close
close:
 li a7, SYS_close
 34e:	48d5                	li	a7,21
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <kill>:
.global kill
kill:
 li a7, SYS_kill
 356:	4899                	li	a7,6
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <exec>:
.global exec
exec:
 li a7, SYS_exec
 35e:	489d                	li	a7,7
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <open>:
.global open
open:
 li a7, SYS_open
 366:	48bd                	li	a7,15
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36e:	48c5                	li	a7,17
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 376:	48c9                	li	a7,18
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37e:	48a1                	li	a7,8
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <link>:
.global link
link:
 li a7, SYS_link
 386:	48cd                	li	a7,19
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38e:	48d1                	li	a7,20
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 396:	48a5                	li	a7,9
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <dup>:
.global dup
dup:
 li a7, SYS_dup
 39e:	48a9                	li	a7,10
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a6:	48ad                	li	a7,11
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ae:	48b1                	li	a7,12
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b6:	48b5                	li	a7,13
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3be:	48b9                	li	a7,14
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3c6:	48d9                	li	a7,22
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3ce:	48dd                	li	a7,23
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3d6:	48e1                	li	a7,24
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3de:	48e5                	li	a7,25
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3e6:	48e9                	li	a7,26
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 3ee:	48ed                	li	a7,27
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 3f6:	48f1                	li	a7,28
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 3fe:	48f5                	li	a7,29
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 406:	48f9                	li	a7,30
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	f27ff0ef          	jal	346 <write>
}
 424:	60e2                	ld	ra,24(sp)
 426:	6442                	ld	s0,16(sp)
 428:	6105                	addi	sp,sp,32
 42a:	8082                	ret

000000000000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	7139                	addi	sp,sp,-64
 42e:	fc06                	sd	ra,56(sp)
 430:	f822                	sd	s0,48(sp)
 432:	f426                	sd	s1,40(sp)
 434:	0080                	addi	s0,sp,64
 436:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	c299                	beqz	a3,43e <printint+0x12>
 43a:	0805c963          	bltz	a1,4cc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43e:	2581                	sext.w	a1,a1
  neg = 0;
 440:	4881                	li	a7,0
 442:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	2601                	sext.w	a2,a2
 44a:	00000517          	auipc	a0,0x0
 44e:	57650513          	addi	a0,a0,1398 # 9c0 <digits>
 452:	883a                	mv	a6,a4
 454:	2705                	addiw	a4,a4,1
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97aa                	add	a5,a5,a0
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	0005879b          	sext.w	a5,a1
 46c:	02c5d5bb          	divuw	a1,a1,a2
 470:	0685                	addi	a3,a3,1
 472:	fec7f0e3          	bgeu	a5,a2,452 <printint+0x26>
  if(neg)
 476:	00088c63          	beqz	a7,48e <printint+0x62>
    buf[i++] = '-';
 47a:	fd070793          	addi	a5,a4,-48
 47e:	00878733          	add	a4,a5,s0
 482:	02d00793          	li	a5,45
 486:	fef70823          	sb	a5,-16(a4)
 48a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48e:	02e05a63          	blez	a4,4c2 <printint+0x96>
 492:	f04a                	sd	s2,32(sp)
 494:	ec4e                	sd	s3,24(sp)
 496:	fc040793          	addi	a5,s0,-64
 49a:	00e78933          	add	s2,a5,a4
 49e:	fff78993          	addi	s3,a5,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	377d                	addiw	a4,a4,-1
 4a6:	1702                	slli	a4,a4,0x20
 4a8:	9301                	srli	a4,a4,0x20
 4aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ae:	fff94583          	lbu	a1,-1(s2)
 4b2:	8526                	mv	a0,s1
 4b4:	f5bff0ef          	jal	40e <putc>
  while(--i >= 0)
 4b8:	197d                	addi	s2,s2,-1
 4ba:	ff391ae3          	bne	s2,s3,4ae <printint+0x82>
 4be:	7902                	ld	s2,32(sp)
 4c0:	69e2                	ld	s3,24(sp)
}
 4c2:	70e2                	ld	ra,56(sp)
 4c4:	7442                	ld	s0,48(sp)
 4c6:	74a2                	ld	s1,40(sp)
 4c8:	6121                	addi	sp,sp,64
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4885                	li	a7,1
    x = -xx;
 4d2:	bf85                	j	442 <printint+0x16>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	711d                	addi	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e0ca                	sd	s2,64(sp)
 4dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c903          	lbu	s2,0(a1)
 4e2:	26090863          	beqz	s2,752 <vprintf+0x27e>
 4e6:	e4a6                	sd	s1,72(sp)
 4e8:	fc4e                	sd	s3,56(sp)
 4ea:	f852                	sd	s4,48(sp)
 4ec:	f456                	sd	s5,40(sp)
 4ee:	f05a                	sd	s6,32(sp)
 4f0:	ec5e                	sd	s7,24(sp)
 4f2:	e862                	sd	s8,16(sp)
 4f4:	e466                	sd	s9,8(sp)
 4f6:	8b2a                	mv	s6,a0
 4f8:	8a2e                	mv	s4,a1
 4fa:	8bb2                	mv	s7,a2
  state = 0;
 4fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fe:	4481                	li	s1,0
 500:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	06c00c93          	li	s9,108
 50e:	a005                	j	52e <vprintf+0x5a>
        putc(fd, c0);
 510:	85ca                	mv	a1,s2
 512:	855a                	mv	a0,s6
 514:	efbff0ef          	jal	40e <putc>
 518:	a019                	j	51e <vprintf+0x4a>
    } else if(state == '%'){
 51a:	03598263          	beq	s3,s5,53e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 51e:	2485                	addiw	s1,s1,1
 520:	8726                	mv	a4,s1
 522:	009a07b3          	add	a5,s4,s1
 526:	0007c903          	lbu	s2,0(a5)
 52a:	20090c63          	beqz	s2,742 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 52e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 532:	fe0994e3          	bnez	s3,51a <vprintf+0x46>
      if(c0 == '%'){
 536:	fd579de3          	bne	a5,s5,510 <vprintf+0x3c>
        state = '%';
 53a:	89be                	mv	s3,a5
 53c:	b7cd                	j	51e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 53e:	00ea06b3          	add	a3,s4,a4
 542:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 546:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 548:	c681                	beqz	a3,550 <vprintf+0x7c>
 54a:	9752                	add	a4,a4,s4
 54c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 550:	03878f63          	beq	a5,s8,58e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 554:	05978963          	beq	a5,s9,5a6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 558:	07500713          	li	a4,117
 55c:	0ee78363          	beq	a5,a4,642 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 560:	07800713          	li	a4,120
 564:	12e78563          	beq	a5,a4,68e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 568:	07000713          	li	a4,112
 56c:	14e78a63          	beq	a5,a4,6c0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 570:	07300713          	li	a4,115
 574:	18e78a63          	beq	a5,a4,708 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 578:	02500713          	li	a4,37
 57c:	04e79563          	bne	a5,a4,5c6 <vprintf+0xf2>
        putc(fd, '%');
 580:	02500593          	li	a1,37
 584:	855a                	mv	a0,s6
 586:	e89ff0ef          	jal	40e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 58a:	4981                	li	s3,0
 58c:	bf49                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 58e:	008b8913          	addi	s2,s7,8
 592:	4685                	li	a3,1
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e91ff0ef          	jal	42c <printint>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bfad                	j	51e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5a6:	06400793          	li	a5,100
 5aa:	02f68963          	beq	a3,a5,5dc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ae:	06c00793          	li	a5,108
 5b2:	04f68263          	beq	a3,a5,5f6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5b6:	07500793          	li	a5,117
 5ba:	0af68063          	beq	a3,a5,65a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5be:	07800793          	li	a5,120
 5c2:	0ef68263          	beq	a3,a5,6a6 <vprintf+0x1d2>
        putc(fd, '%');
 5c6:	02500593          	li	a1,37
 5ca:	855a                	mv	a0,s6
 5cc:	e43ff0ef          	jal	40e <putc>
        putc(fd, c0);
 5d0:	85ca                	mv	a1,s2
 5d2:	855a                	mv	a0,s6
 5d4:	e3bff0ef          	jal	40e <putc>
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b791                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e43ff0ef          	jal	42c <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b72d                	j	51e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f6:	06400793          	li	a5,100
 5fa:	02f60763          	beq	a2,a5,628 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5fe:	07500793          	li	a5,117
 602:	06f60963          	beq	a2,a5,674 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 606:	07800793          	li	a5,120
 60a:	faf61ee3          	bne	a2,a5,5c6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	008b8913          	addi	s2,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e11ff0ef          	jal	42c <printint>
        i += 2;
 620:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bde5                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	df7ff0ef          	jal	42c <printint>
        i += 2;
 63a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bdf9                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000ba583          	lw	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	dddff0ef          	jal	42c <printint>
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	b5d9                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	dc5ff0ef          	jal	42c <printint>
        i += 1;
 66c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 1;
 672:	b575                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dabff0ef          	jal	42c <printint>
        i += 2;
 686:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	bd49                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4641                	li	a2,16
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d91ff0ef          	jal	42c <printint>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bdad                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	d79ff0ef          	jal	42c <printint>
        i += 1;
 6b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	b585                	j	51e <vprintf+0x4a>
 6c0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c2:	008b8d13          	addi	s10,s7,8
 6c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ca:	03000593          	li	a1,48
 6ce:	855a                	mv	a0,s6
 6d0:	d3fff0ef          	jal	40e <putc>
  putc(fd, 'x');
 6d4:	07800593          	li	a1,120
 6d8:	855a                	mv	a0,s6
 6da:	d35ff0ef          	jal	40e <putc>
 6de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e0:	00000b97          	auipc	s7,0x0
 6e4:	2e0b8b93          	addi	s7,s7,736 # 9c0 <digits>
 6e8:	03c9d793          	srli	a5,s3,0x3c
 6ec:	97de                	add	a5,a5,s7
 6ee:	0007c583          	lbu	a1,0(a5)
 6f2:	855a                	mv	a0,s6
 6f4:	d1bff0ef          	jal	40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f8:	0992                	slli	s3,s3,0x4
 6fa:	397d                	addiw	s2,s2,-1
 6fc:	fe0916e3          	bnez	s2,6e8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 700:	8bea                	mv	s7,s10
      state = 0;
 702:	4981                	li	s3,0
 704:	6d02                	ld	s10,0(sp)
 706:	bd21                	j	51e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 708:	008b8993          	addi	s3,s7,8
 70c:	000bb903          	ld	s2,0(s7)
 710:	00090f63          	beqz	s2,72e <vprintf+0x25a>
        for(; *s; s++)
 714:	00094583          	lbu	a1,0(s2)
 718:	c195                	beqz	a1,73c <vprintf+0x268>
          putc(fd, *s);
 71a:	855a                	mv	a0,s6
 71c:	cf3ff0ef          	jal	40e <putc>
        for(; *s; s++)
 720:	0905                	addi	s2,s2,1
 722:	00094583          	lbu	a1,0(s2)
 726:	f9f5                	bnez	a1,71a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bbcd                	j	51e <vprintf+0x4a>
          s = "(null)";
 72e:	00000917          	auipc	s2,0x0
 732:	28a90913          	addi	s2,s2,650 # 9b8 <malloc+0x17e>
        for(; *s; s++)
 736:	02800593          	li	a1,40
 73a:	b7c5                	j	71a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	bbf9                	j	51e <vprintf+0x4a>
 742:	64a6                	ld	s1,72(sp)
 744:	79e2                	ld	s3,56(sp)
 746:	7a42                	ld	s4,48(sp)
 748:	7aa2                	ld	s5,40(sp)
 74a:	7b02                	ld	s6,32(sp)
 74c:	6be2                	ld	s7,24(sp)
 74e:	6c42                	ld	s8,16(sp)
 750:	6ca2                	ld	s9,8(sp)
    }
  }
}
 752:	60e6                	ld	ra,88(sp)
 754:	6446                	ld	s0,80(sp)
 756:	6906                	ld	s2,64(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75c:	715d                	addi	sp,sp,-80
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e010                	sd	a2,0(s0)
 766:	e414                	sd	a3,8(s0)
 768:	e818                	sd	a4,16(s0)
 76a:	ec1c                	sd	a5,24(s0)
 76c:	03043023          	sd	a6,32(s0)
 770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 778:	8622                	mv	a2,s0
 77a:	d5bff0ef          	jal	4d4 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6161                	addi	sp,sp,80
 784:	8082                	ret

0000000000000786 <printf>:

void
printf(const char *fmt, ...)
{
 786:	711d                	addi	sp,sp,-96
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e40c                	sd	a1,8(s0)
 790:	e810                	sd	a2,16(s0)
 792:	ec14                	sd	a3,24(s0)
 794:	f018                	sd	a4,32(s0)
 796:	f41c                	sd	a5,40(s0)
 798:	03043823          	sd	a6,48(s0)
 79c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	00840613          	addi	a2,s0,8
 7a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a8:	85aa                	mv	a1,a0
 7aa:	4505                	li	a0,1
 7ac:	d29ff0ef          	jal	4d4 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6125                	addi	sp,sp,96
 7b6:	8082                	ret

00000000000007b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b8:	1141                	addi	sp,sp,-16
 7ba:	e422                	sd	s0,8(sp)
 7bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	00001797          	auipc	a5,0x1
 7c6:	84e7b783          	ld	a5,-1970(a5) # 1010 <freep>
 7ca:	a02d                	j	7f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7cc:	4618                	lw	a4,8(a2)
 7ce:	9f2d                	addw	a4,a4,a1
 7d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	6398                	ld	a4,0(a5)
 7d6:	6310                	ld	a2,0(a4)
 7d8:	a83d                	j	816 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9f31                	addw	a4,a4,a2
 7e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e2:	ff053683          	ld	a3,-16(a0)
 7e6:	a091                	j	82a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e7e463          	bltu	a5,a4,7f2 <free+0x3a>
 7ee:	00e6ea63          	bltu	a3,a4,802 <free+0x4a>
{
 7f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fed7fae3          	bgeu	a5,a3,7e8 <free+0x30>
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e6e463          	bltu	a3,a4,802 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	fee7eae3          	bltu	a5,a4,7f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 802:	ff852583          	lw	a1,-8(a0)
 806:	6390                	ld	a2,0(a5)
 808:	02059813          	slli	a6,a1,0x20
 80c:	01c85713          	srli	a4,a6,0x1c
 810:	9736                	add	a4,a4,a3
 812:	fae60de3          	beq	a2,a4,7cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81a:	4790                	lw	a2,8(a5)
 81c:	02061593          	slli	a1,a2,0x20
 820:	01c5d713          	srli	a4,a1,0x1c
 824:	973e                	add	a4,a4,a5
 826:	fae68ae3          	beq	a3,a4,7da <free+0x22>
    p->s.ptr = bp->s.ptr;
 82a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82c:	00000717          	auipc	a4,0x0
 830:	7ef73223          	sd	a5,2020(a4) # 1010 <freep>
}
 834:	6422                	ld	s0,8(sp)
 836:	0141                	addi	sp,sp,16
 838:	8082                	ret

000000000000083a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83a:	7139                	addi	sp,sp,-64
 83c:	fc06                	sd	ra,56(sp)
 83e:	f822                	sd	s0,48(sp)
 840:	f426                	sd	s1,40(sp)
 842:	ec4e                	sd	s3,24(sp)
 844:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 846:	02051493          	slli	s1,a0,0x20
 84a:	9081                	srli	s1,s1,0x20
 84c:	04bd                	addi	s1,s1,15
 84e:	8091                	srli	s1,s1,0x4
 850:	0014899b          	addiw	s3,s1,1
 854:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 856:	00000517          	auipc	a0,0x0
 85a:	7ba53503          	ld	a0,1978(a0) # 1010 <freep>
 85e:	c915                	beqz	a0,892 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	08977a63          	bgeu	a4,s1,8f8 <malloc+0xbe>
 868:	f04a                	sd	s2,32(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 870:	8a4e                	mv	s4,s3
 872:	0009871b          	sext.w	a4,s3
 876:	6685                	lui	a3,0x1
 878:	00d77363          	bgeu	a4,a3,87e <malloc+0x44>
 87c:	6a05                	lui	s4,0x1
 87e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 882:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 886:	00000917          	auipc	s2,0x0
 88a:	78a90913          	addi	s2,s2,1930 # 1010 <freep>
  if(p == (char*)-1)
 88e:	5afd                	li	s5,-1
 890:	a081                	j	8d0 <malloc+0x96>
 892:	f04a                	sd	s2,32(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89a:	00000797          	auipc	a5,0x0
 89e:	78678793          	addi	a5,a5,1926 # 1020 <base>
 8a2:	00000717          	auipc	a4,0x0
 8a6:	76f73723          	sd	a5,1902(a4) # 1010 <freep>
 8aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b0:	b7c1                	j	870 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	e118                	sd	a4,0(a0)
 8b6:	a8a9                	j	910 <malloc+0xd6>
  hp->s.size = nu;
 8b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8bc:	0541                	addi	a0,a0,16
 8be:	efbff0ef          	jal	7b8 <free>
  return freep;
 8c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c6:	c12d                	beqz	a0,928 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	02977263          	bgeu	a4,s1,8f0 <malloc+0xb6>
    if(p == freep)
 8d0:	00093703          	ld	a4,0(s2)
 8d4:	853e                	mv	a0,a5
 8d6:	fef719e3          	bne	a4,a5,8c8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	ad3ff0ef          	jal	3ae <sbrk>
  if(p == (char*)-1)
 8e0:	fd551ce3          	bne	a0,s5,8b8 <malloc+0x7e>
        return 0;
 8e4:	4501                	li	a0,0
 8e6:	7902                	ld	s2,32(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	a03d                	j	91c <malloc+0xe2>
 8f0:	7902                	ld	s2,32(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f8:	fae48de3          	beq	s1,a4,8b2 <malloc+0x78>
        p->s.size -= nunits;
 8fc:	4137073b          	subw	a4,a4,s3
 900:	c798                	sw	a4,8(a5)
        p += p->s.size;
 902:	02071693          	slli	a3,a4,0x20
 906:	01c6d713          	srli	a4,a3,0x1c
 90a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 910:	00000717          	auipc	a4,0x0
 914:	70a73023          	sd	a0,1792(a4) # 1010 <freep>
      return (void*)(p + 1);
 918:	01078513          	addi	a0,a5,16
  }
}
 91c:	70e2                	ld	ra,56(sp)
 91e:	7442                	ld	s0,48(sp)
 920:	74a2                	ld	s1,40(sp)
 922:	69e2                	ld	s3,24(sp)
 924:	6121                	addi	sp,sp,64
 926:	8082                	ret
 928:	7902                	ld	s2,32(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	b7f5                	j	91c <malloc+0xe2>
