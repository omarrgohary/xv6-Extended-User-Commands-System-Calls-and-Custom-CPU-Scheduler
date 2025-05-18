
user/_schedbench:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  uint64 rtime;
  uint64 turnaround_time;
  uint64 waiting_time;
};

int main() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	0880                	addi	s0,sp,80
  int n = 5;
  char buf[BUF_SIZE];
  int mode = 1;  // Default to FCFS


  printf("Select scheduler mode:\n");
   e:	00001517          	auipc	a0,0x1
  12:	9b250513          	addi	a0,a0,-1614 # 9c0 <malloc+0xfe>
  16:	7f8000ef          	jal	80e <printf>
  printf("0 - Round Robin\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	9be50513          	addi	a0,a0,-1602 # 9d8 <malloc+0x116>
  22:	7ec000ef          	jal	80e <printf>
  printf("1 - FCFS (First Come First Serve)\n");
  26:	00001517          	auipc	a0,0x1
  2a:	9ca50513          	addi	a0,a0,-1590 # 9f0 <malloc+0x12e>
  2e:	7e0000ef          	jal	80e <printf>
  printf("2 - Priority-based\n");
  32:	00001517          	auipc	a0,0x1
  36:	9e650513          	addi	a0,a0,-1562 # a18 <malloc+0x156>
  3a:	7d4000ef          	jal	80e <printf>

  if (read(0, buf, BUF_SIZE) > 0) {
  3e:	4629                	li	a2,10
  40:	fc040593          	addi	a1,s0,-64
  44:	4501                	li	a0,0
  46:	380000ef          	jal	3c6 <read>
  int mode = 1;  // Default to FCFS
  4a:	4985                	li	s3,1
  if (read(0, buf, BUF_SIZE) > 0) {
  4c:	00a05e63          	blez	a0,68 <main+0x68>
    mode = buf[0] - '0';
  50:	fc044783          	lbu	a5,-64(s0)
  54:	fd07879b          	addiw	a5,a5,-48
  58:	0007899b          	sext.w	s3,a5
    if (mode >= 0 && mode <= 2) {
  5c:	4709                	li	a4,2
  5e:	03376063          	bltu	a4,s3,7e <main+0x7e>
      schedstats(mode);
  62:	854e                	mv	a0,s3
  64:	41a000ef          	jal	47e <schedstats>
      printf("Invalid scheduler mode selected. Using default FCFS.\n");
      schedstats(mode);  // mode already = 1
    }
  }

  for (i = 0; i < n; i++) {
  68:	4481                	li	s1,0
  6a:	4915                	li	s2,5
    pid = fork();
  6c:	33a000ef          	jal	3a6 <fork>
    if (pid == 0) {
  70:	c10d                	beqz	a0,92 <main+0x92>
  for (i = 0; i < n; i++) {
  72:	2485                	addiw	s1,s1,1
  74:	ff249ce3          	bne	s1,s2,6c <main+0x6c>
   // total_turnaround += p.turnaround_time;
 // }

//  printf("Average turnaround time: %lu ticks\n", total_turnaround / n);

  exit(0);
  78:	4501                	li	a0,0
  7a:	334000ef          	jal	3ae <exit>
      printf("Invalid scheduler mode selected. Using default FCFS.\n");
  7e:	00001517          	auipc	a0,0x1
  82:	9b250513          	addi	a0,a0,-1614 # a30 <malloc+0x16e>
  86:	788000ef          	jal	80e <printf>
      schedstats(mode);  // mode already = 1
  8a:	854e                	mv	a0,s3
  8c:	3f2000ef          	jal	47e <schedstats>
  90:	bfe1                	j	68 <main+0x68>
      if (mode == 2) { // Only for Priority scheduling
  92:	4789                	li	a5,2
  94:	04f98e63          	beq	s3,a5,f0 <main+0xf0>
        printf("Child %d started\n", getpid());
  98:	396000ef          	jal	42e <getpid>
  9c:	85aa                	mv	a1,a0
  9e:	00001517          	auipc	a0,0x1
  a2:	9f250513          	addi	a0,a0,-1550 # a90 <malloc+0x1ce>
  a6:	768000ef          	jal	80e <printf>
      if (i == 0)
  aa:	e4b5                	bnez	s1,116 <main+0x116>
        for (volatile int j = 0; j < 800000000; j++);
  ac:	fa042c23          	sw	zero,-72(s0)
  b0:	fb842703          	lw	a4,-72(s0)
  b4:	2701                	sext.w	a4,a4
  b6:	2faf07b7          	lui	a5,0x2faf0
  ba:	7ff78793          	addi	a5,a5,2047 # 2faf07ff <base+0x2faef7ef>
  be:	00e7cd63          	blt	a5,a4,d8 <main+0xd8>
  c2:	873e                	mv	a4,a5
  c4:	fb842783          	lw	a5,-72(s0)
  c8:	2785                	addiw	a5,a5,1
  ca:	faf42c23          	sw	a5,-72(s0)
  ce:	fb842783          	lw	a5,-72(s0)
  d2:	2781                	sext.w	a5,a5
  d4:	fef758e3          	bge	a4,a5,c4 <main+0xc4>
      printf("Child %d done\n", getpid());
  d8:	356000ef          	jal	42e <getpid>
  dc:	85aa                	mv	a1,a0
  de:	00001517          	auipc	a0,0x1
  e2:	9ca50513          	addi	a0,a0,-1590 # aa8 <malloc+0x1e6>
  e6:	728000ef          	jal	80e <printf>
      exit(0);
  ea:	4501                	li	a0,0
  ec:	2c2000ef          	jal	3ae <exit>
        int prio = 20 - i;
  f0:	4951                	li	s2,20
  f2:	4099093b          	subw	s2,s2,s1
        setpriority(getpid(), prio);
  f6:	338000ef          	jal	42e <getpid>
  fa:	85ca                	mv	a1,s2
  fc:	392000ef          	jal	48e <setpriority>
        printf("Child %d started with priority %d\n", getpid(), prio);
 100:	32e000ef          	jal	42e <getpid>
 104:	85aa                	mv	a1,a0
 106:	864a                	mv	a2,s2
 108:	00001517          	auipc	a0,0x1
 10c:	96050513          	addi	a0,a0,-1696 # a68 <malloc+0x1a6>
 110:	6fe000ef          	jal	80e <printf>
 114:	bf59                	j	aa <main+0xaa>
        for (volatile int j = 0; j < 200000000; j++);
 116:	fa042e23          	sw	zero,-68(s0)
 11a:	fbc42703          	lw	a4,-68(s0)
 11e:	2701                	sext.w	a4,a4
 120:	0bebc7b7          	lui	a5,0xbebc
 124:	1ff78793          	addi	a5,a5,511 # bebc1ff <base+0xbebb1ef>
 128:	fae7c8e3          	blt	a5,a4,d8 <main+0xd8>
 12c:	873e                	mv	a4,a5
 12e:	fbc42783          	lw	a5,-68(s0)
 132:	2785                	addiw	a5,a5,1
 134:	faf42e23          	sw	a5,-68(s0)
 138:	fbc42783          	lw	a5,-68(s0)
 13c:	2781                	sext.w	a5,a5
 13e:	fef758e3          	bge	a4,a5,12e <main+0x12e>
 142:	bf59                	j	d8 <main+0xd8>

0000000000000144 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 144:	1141                	addi	sp,sp,-16
 146:	e406                	sd	ra,8(sp)
 148:	e022                	sd	s0,0(sp)
 14a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 14c:	eb5ff0ef          	jal	0 <main>
  exit(0);
 150:	4501                	li	a0,0
 152:	25c000ef          	jal	3ae <exit>

0000000000000156 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15c:	87aa                	mv	a5,a0
 15e:	0585                	addi	a1,a1,1
 160:	0785                	addi	a5,a5,1
 162:	fff5c703          	lbu	a4,-1(a1)
 166:	fee78fa3          	sb	a4,-1(a5)
 16a:	fb75                	bnez	a4,15e <strcpy+0x8>
    ;
  return os;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cb91                	beqz	a5,190 <strcmp+0x1e>
 17e:	0005c703          	lbu	a4,0(a1)
 182:	00f71763          	bne	a4,a5,190 <strcmp+0x1e>
    p++, q++;
 186:	0505                	addi	a0,a0,1
 188:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbe5                	bnez	a5,17e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 190:	0005c503          	lbu	a0,0(a1)
}
 194:	40a7853b          	subw	a0,a5,a0
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strlen>:

uint
strlen(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf91                	beqz	a5,1c4 <strlen+0x26>
 1aa:	0505                	addi	a0,a0,1
 1ac:	87aa                	mv	a5,a0
 1ae:	86be                	mv	a3,a5
 1b0:	0785                	addi	a5,a5,1
 1b2:	fff7c703          	lbu	a4,-1(a5)
 1b6:	ff65                	bnez	a4,1ae <strlen+0x10>
 1b8:	40a6853b          	subw	a0,a3,a0
 1bc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  for(n = 0; s[n]; n++)
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strlen+0x20>

00000000000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ce:	ca19                	beqz	a2,1e4 <memset+0x1c>
 1d0:	87aa                	mv	a5,a0
 1d2:	1602                	slli	a2,a2,0x20
 1d4:	9201                	srli	a2,a2,0x20
 1d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1de:	0785                	addi	a5,a5,1
 1e0:	fee79de3          	bne	a5,a4,1da <memset+0x12>
  }
  return dst;
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	cb99                	beqz	a5,20a <strchr+0x20>
    if(*s == c)
 1f6:	00f58763          	beq	a1,a5,204 <strchr+0x1a>
  for(; *s; s++)
 1fa:	0505                	addi	a0,a0,1
 1fc:	00054783          	lbu	a5,0(a0)
 200:	fbfd                	bnez	a5,1f6 <strchr+0xc>
      return (char*)s;
  return 0;
 202:	4501                	li	a0,0
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  return 0;
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <strchr+0x1a>

000000000000020e <gets>:

char*
gets(char *buf, int max)
{
 20e:	711d                	addi	sp,sp,-96
 210:	ec86                	sd	ra,88(sp)
 212:	e8a2                	sd	s0,80(sp)
 214:	e4a6                	sd	s1,72(sp)
 216:	e0ca                	sd	s2,64(sp)
 218:	fc4e                	sd	s3,56(sp)
 21a:	f852                	sd	s4,48(sp)
 21c:	f456                	sd	s5,40(sp)
 21e:	f05a                	sd	s6,32(sp)
 220:	ec5e                	sd	s7,24(sp)
 222:	1080                	addi	s0,sp,96
 224:	8baa                	mv	s7,a0
 226:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	892a                	mv	s2,a0
 22a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22c:	4aa9                	li	s5,10
 22e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 230:	89a6                	mv	s3,s1
 232:	2485                	addiw	s1,s1,1
 234:	0344d663          	bge	s1,s4,260 <gets+0x52>
    cc = read(0, &c, 1);
 238:	4605                	li	a2,1
 23a:	faf40593          	addi	a1,s0,-81
 23e:	4501                	li	a0,0
 240:	186000ef          	jal	3c6 <read>
    if(cc < 1)
 244:	00a05e63          	blez	a0,260 <gets+0x52>
    buf[i++] = c;
 248:	faf44783          	lbu	a5,-81(s0)
 24c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 250:	01578763          	beq	a5,s5,25e <gets+0x50>
 254:	0905                	addi	s2,s2,1
 256:	fd679de3          	bne	a5,s6,230 <gets+0x22>
    buf[i++] = c;
 25a:	89a6                	mv	s3,s1
 25c:	a011                	j	260 <gets+0x52>
 25e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 260:	99de                	add	s3,s3,s7
 262:	00098023          	sb	zero,0(s3)
  return buf;
}
 266:	855e                	mv	a0,s7
 268:	60e6                	ld	ra,88(sp)
 26a:	6446                	ld	s0,80(sp)
 26c:	64a6                	ld	s1,72(sp)
 26e:	6906                	ld	s2,64(sp)
 270:	79e2                	ld	s3,56(sp)
 272:	7a42                	ld	s4,48(sp)
 274:	7aa2                	ld	s5,40(sp)
 276:	7b02                	ld	s6,32(sp)
 278:	6be2                	ld	s7,24(sp)
 27a:	6125                	addi	sp,sp,96
 27c:	8082                	ret

000000000000027e <stat>:

int
stat(const char *n, struct stat *st)
{
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	e04a                	sd	s2,0(sp)
 286:	1000                	addi	s0,sp,32
 288:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28a:	4581                	li	a1,0
 28c:	162000ef          	jal	3ee <open>
  if(fd < 0)
 290:	02054263          	bltz	a0,2b4 <stat+0x36>
 294:	e426                	sd	s1,8(sp)
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	16c000ef          	jal	406 <fstat>
 29e:	892a                	mv	s2,a0
  close(fd);
 2a0:	8526                	mv	a0,s1
 2a2:	134000ef          	jal	3d6 <close>
  return r;
 2a6:	64a2                	ld	s1,8(sp)
}
 2a8:	854a                	mv	a0,s2
 2aa:	60e2                	ld	ra,24(sp)
 2ac:	6442                	ld	s0,16(sp)
 2ae:	6902                	ld	s2,0(sp)
 2b0:	6105                	addi	sp,sp,32
 2b2:	8082                	ret
    return -1;
 2b4:	597d                	li	s2,-1
 2b6:	bfcd                	j	2a8 <stat+0x2a>

00000000000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2be:	00054683          	lbu	a3,0(a0)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	4625                	li	a2,9
 2cc:	02f66863          	bltu	a2,a5,2fc <atoi+0x44>
 2d0:	872a                	mv	a4,a0
  n = 0;
 2d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d4:	0705                	addi	a4,a4,1
 2d6:	0025179b          	slliw	a5,a0,0x2
 2da:	9fa9                	addw	a5,a5,a0
 2dc:	0017979b          	slliw	a5,a5,0x1
 2e0:	9fb5                	addw	a5,a5,a3
 2e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e6:	00074683          	lbu	a3,0(a4)
 2ea:	fd06879b          	addiw	a5,a3,-48
 2ee:	0ff7f793          	zext.b	a5,a5
 2f2:	fef671e3          	bgeu	a2,a5,2d4 <atoi+0x1c>
  return n;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  n = 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <atoi+0x3e>

0000000000000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 306:	02b57463          	bgeu	a0,a1,32e <memmove+0x2e>
    while(n-- > 0)
 30a:	00c05f63          	blez	a2,328 <memmove+0x28>
 30e:	1602                	slli	a2,a2,0x20
 310:	9201                	srli	a2,a2,0x20
 312:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 316:	872a                	mv	a4,a0
      *dst++ = *src++;
 318:	0585                	addi	a1,a1,1
 31a:	0705                	addi	a4,a4,1
 31c:	fff5c683          	lbu	a3,-1(a1)
 320:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
    dst += n;
 32e:	00c50733          	add	a4,a0,a2
    src += n;
 332:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 334:	fec05ae3          	blez	a2,328 <memmove+0x28>
 338:	fff6079b          	addiw	a5,a2,-1
 33c:	1782                	slli	a5,a5,0x20
 33e:	9381                	srli	a5,a5,0x20
 340:	fff7c793          	not	a5,a5
 344:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 346:	15fd                	addi	a1,a1,-1
 348:	177d                	addi	a4,a4,-1
 34a:	0005c683          	lbu	a3,0(a1)
 34e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 352:	fee79ae3          	bne	a5,a4,346 <memmove+0x46>
 356:	bfc9                	j	328 <memmove+0x28>

0000000000000358 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35e:	ca05                	beqz	a2,38e <memcmp+0x36>
 360:	fff6069b          	addiw	a3,a2,-1
 364:	1682                	slli	a3,a3,0x20
 366:	9281                	srli	a3,a3,0x20
 368:	0685                	addi	a3,a3,1
 36a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36c:	00054783          	lbu	a5,0(a0)
 370:	0005c703          	lbu	a4,0(a1)
 374:	00e79863          	bne	a5,a4,384 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 378:	0505                	addi	a0,a0,1
    p2++;
 37a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37c:	fed518e3          	bne	a0,a3,36c <memcmp+0x14>
  }
  return 0;
 380:	4501                	li	a0,0
 382:	a019                	j	388 <memcmp+0x30>
      return *p1 - *p2;
 384:	40e7853b          	subw	a0,a5,a4
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <memcmp+0x30>

0000000000000392 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39a:	f67ff0ef          	jal	300 <memmove>
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a6:	4885                	li	a7,1
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ae:	4889                	li	a7,2
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b6:	488d                	li	a7,3
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3be:	4891                	li	a7,4
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <read>:
.global read
read:
 li a7, SYS_read
 3c6:	4895                	li	a7,5
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <write>:
.global write
write:
 li a7, SYS_write
 3ce:	48c1                	li	a7,16
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <close>:
.global close
close:
 li a7, SYS_close
 3d6:	48d5                	li	a7,21
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <kill>:
.global kill
kill:
 li a7, SYS_kill
 3de:	4899                	li	a7,6
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e6:	489d                	li	a7,7
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <open>:
.global open
open:
 li a7, SYS_open
 3ee:	48bd                	li	a7,15
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f6:	48c5                	li	a7,17
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fe:	48c9                	li	a7,18
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 406:	48a1                	li	a7,8
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <link>:
.global link
link:
 li a7, SYS_link
 40e:	48cd                	li	a7,19
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 416:	48d1                	li	a7,20
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41e:	48a5                	li	a7,9
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <dup>:
.global dup
dup:
 li a7, SYS_dup
 426:	48a9                	li	a7,10
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42e:	48ad                	li	a7,11
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 436:	48b1                	li	a7,12
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43e:	48b5                	li	a7,13
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 446:	48b9                	li	a7,14
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 44e:	48d9                	li	a7,22
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 456:	48dd                	li	a7,23
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 45e:	48e1                	li	a7,24
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 466:	48e5                	li	a7,25
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 46e:	48e9                	li	a7,26
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 476:	48ed                	li	a7,27
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 47e:	48f1                	li	a7,28
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 486:	48f5                	li	a7,29
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 48e:	48f9                	li	a7,30
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 496:	1101                	addi	sp,sp,-32
 498:	ec06                	sd	ra,24(sp)
 49a:	e822                	sd	s0,16(sp)
 49c:	1000                	addi	s0,sp,32
 49e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a2:	4605                	li	a2,1
 4a4:	fef40593          	addi	a1,s0,-17
 4a8:	f27ff0ef          	jal	3ce <write>
}
 4ac:	60e2                	ld	ra,24(sp)
 4ae:	6442                	ld	s0,16(sp)
 4b0:	6105                	addi	sp,sp,32
 4b2:	8082                	ret

00000000000004b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b4:	7139                	addi	sp,sp,-64
 4b6:	fc06                	sd	ra,56(sp)
 4b8:	f822                	sd	s0,48(sp)
 4ba:	f426                	sd	s1,40(sp)
 4bc:	0080                	addi	s0,sp,64
 4be:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c0:	c299                	beqz	a3,4c6 <printint+0x12>
 4c2:	0805c963          	bltz	a1,554 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c6:	2581                	sext.w	a1,a1
  neg = 0;
 4c8:	4881                	li	a7,0
 4ca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d0:	2601                	sext.w	a2,a2
 4d2:	00000517          	auipc	a0,0x0
 4d6:	5ee50513          	addi	a0,a0,1518 # ac0 <digits>
 4da:	883a                	mv	a6,a4
 4dc:	2705                	addiw	a4,a4,1
 4de:	02c5f7bb          	remuw	a5,a1,a2
 4e2:	1782                	slli	a5,a5,0x20
 4e4:	9381                	srli	a5,a5,0x20
 4e6:	97aa                	add	a5,a5,a0
 4e8:	0007c783          	lbu	a5,0(a5)
 4ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f0:	0005879b          	sext.w	a5,a1
 4f4:	02c5d5bb          	divuw	a1,a1,a2
 4f8:	0685                	addi	a3,a3,1
 4fa:	fec7f0e3          	bgeu	a5,a2,4da <printint+0x26>
  if(neg)
 4fe:	00088c63          	beqz	a7,516 <printint+0x62>
    buf[i++] = '-';
 502:	fd070793          	addi	a5,a4,-48
 506:	00878733          	add	a4,a5,s0
 50a:	02d00793          	li	a5,45
 50e:	fef70823          	sb	a5,-16(a4)
 512:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 516:	02e05a63          	blez	a4,54a <printint+0x96>
 51a:	f04a                	sd	s2,32(sp)
 51c:	ec4e                	sd	s3,24(sp)
 51e:	fc040793          	addi	a5,s0,-64
 522:	00e78933          	add	s2,a5,a4
 526:	fff78993          	addi	s3,a5,-1
 52a:	99ba                	add	s3,s3,a4
 52c:	377d                	addiw	a4,a4,-1
 52e:	1702                	slli	a4,a4,0x20
 530:	9301                	srli	a4,a4,0x20
 532:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 536:	fff94583          	lbu	a1,-1(s2)
 53a:	8526                	mv	a0,s1
 53c:	f5bff0ef          	jal	496 <putc>
  while(--i >= 0)
 540:	197d                	addi	s2,s2,-1
 542:	ff391ae3          	bne	s2,s3,536 <printint+0x82>
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
}
 54a:	70e2                	ld	ra,56(sp)
 54c:	7442                	ld	s0,48(sp)
 54e:	74a2                	ld	s1,40(sp)
 550:	6121                	addi	sp,sp,64
 552:	8082                	ret
    x = -xx;
 554:	40b005bb          	negw	a1,a1
    neg = 1;
 558:	4885                	li	a7,1
    x = -xx;
 55a:	bf85                	j	4ca <printint+0x16>

000000000000055c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55c:	711d                	addi	sp,sp,-96
 55e:	ec86                	sd	ra,88(sp)
 560:	e8a2                	sd	s0,80(sp)
 562:	e0ca                	sd	s2,64(sp)
 564:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 566:	0005c903          	lbu	s2,0(a1)
 56a:	26090863          	beqz	s2,7da <vprintf+0x27e>
 56e:	e4a6                	sd	s1,72(sp)
 570:	fc4e                	sd	s3,56(sp)
 572:	f852                	sd	s4,48(sp)
 574:	f456                	sd	s5,40(sp)
 576:	f05a                	sd	s6,32(sp)
 578:	ec5e                	sd	s7,24(sp)
 57a:	e862                	sd	s8,16(sp)
 57c:	e466                	sd	s9,8(sp)
 57e:	8b2a                	mv	s6,a0
 580:	8a2e                	mv	s4,a1
 582:	8bb2                	mv	s7,a2
  state = 0;
 584:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 586:	4481                	li	s1,0
 588:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 592:	06c00c93          	li	s9,108
 596:	a005                	j	5b6 <vprintf+0x5a>
        putc(fd, c0);
 598:	85ca                	mv	a1,s2
 59a:	855a                	mv	a0,s6
 59c:	efbff0ef          	jal	496 <putc>
 5a0:	a019                	j	5a6 <vprintf+0x4a>
    } else if(state == '%'){
 5a2:	03598263          	beq	s3,s5,5c6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5a6:	2485                	addiw	s1,s1,1
 5a8:	8726                	mv	a4,s1
 5aa:	009a07b3          	add	a5,s4,s1
 5ae:	0007c903          	lbu	s2,0(a5)
 5b2:	20090c63          	beqz	s2,7ca <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ba:	fe0994e3          	bnez	s3,5a2 <vprintf+0x46>
      if(c0 == '%'){
 5be:	fd579de3          	bne	a5,s5,598 <vprintf+0x3c>
        state = '%';
 5c2:	89be                	mv	s3,a5
 5c4:	b7cd                	j	5a6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c6:	00ea06b3          	add	a3,s4,a4
 5ca:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ce:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5d0:	c681                	beqz	a3,5d8 <vprintf+0x7c>
 5d2:	9752                	add	a4,a4,s4
 5d4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5d8:	03878f63          	beq	a5,s8,616 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5dc:	05978963          	beq	a5,s9,62e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5e0:	07500713          	li	a4,117
 5e4:	0ee78363          	beq	a5,a4,6ca <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5e8:	07800713          	li	a4,120
 5ec:	12e78563          	beq	a5,a4,716 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5f0:	07000713          	li	a4,112
 5f4:	14e78a63          	beq	a5,a4,748 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5f8:	07300713          	li	a4,115
 5fc:	18e78a63          	beq	a5,a4,790 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 600:	02500713          	li	a4,37
 604:	04e79563          	bne	a5,a4,64e <vprintf+0xf2>
        putc(fd, '%');
 608:	02500593          	li	a1,37
 60c:	855a                	mv	a0,s6
 60e:	e89ff0ef          	jal	496 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 612:	4981                	li	s3,0
 614:	bf49                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 616:	008b8913          	addi	s2,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e91ff0ef          	jal	4b4 <printint>
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bfad                	j	5a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 62e:	06400793          	li	a5,100
 632:	02f68963          	beq	a3,a5,664 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 636:	06c00793          	li	a5,108
 63a:	04f68263          	beq	a3,a5,67e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 63e:	07500793          	li	a5,117
 642:	0af68063          	beq	a3,a5,6e2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 646:	07800793          	li	a5,120
 64a:	0ef68263          	beq	a3,a5,72e <vprintf+0x1d2>
        putc(fd, '%');
 64e:	02500593          	li	a1,37
 652:	855a                	mv	a0,s6
 654:	e43ff0ef          	jal	496 <putc>
        putc(fd, c0);
 658:	85ca                	mv	a1,s2
 65a:	855a                	mv	a0,s6
 65c:	e3bff0ef          	jal	496 <putc>
      state = 0;
 660:	4981                	li	s3,0
 662:	b791                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	008b8913          	addi	s2,s7,8
 668:	4685                	li	a3,1
 66a:	4629                	li	a2,10
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e43ff0ef          	jal	4b4 <printint>
        i += 1;
 676:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 1;
 67c:	b72d                	j	5a6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 67e:	06400793          	li	a5,100
 682:	02f60763          	beq	a2,a5,6b0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 686:	07500793          	li	a5,117
 68a:	06f60963          	beq	a2,a5,6fc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 68e:	07800793          	li	a5,120
 692:	faf61ee3          	bne	a2,a5,64e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e11ff0ef          	jal	4b4 <printint>
        i += 2;
 6a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	bde5                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4685                	li	a3,1
 6b6:	4629                	li	a2,10
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	df7ff0ef          	jal	4b4 <printint>
        i += 2;
 6c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	bdf9                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4629                	li	a2,10
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	dddff0ef          	jal	4b4 <printint>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b5d9                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	dc5ff0ef          	jal	4b4 <printint>
        i += 1;
 6f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
        i += 1;
 6fa:	b575                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4629                	li	a2,10
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	dabff0ef          	jal	4b4 <printint>
        i += 2;
 70e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
        i += 2;
 714:	bd49                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 716:	008b8913          	addi	s2,s7,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	d91ff0ef          	jal	4b4 <printint>
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bdad                	j	5a6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4641                	li	a2,16
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	d79ff0ef          	jal	4b4 <printint>
        i += 1;
 740:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
        i += 1;
 746:	b585                	j	5a6 <vprintf+0x4a>
 748:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 74a:	008b8d13          	addi	s10,s7,8
 74e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 752:	03000593          	li	a1,48
 756:	855a                	mv	a0,s6
 758:	d3fff0ef          	jal	496 <putc>
  putc(fd, 'x');
 75c:	07800593          	li	a1,120
 760:	855a                	mv	a0,s6
 762:	d35ff0ef          	jal	496 <putc>
 766:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 768:	00000b97          	auipc	s7,0x0
 76c:	358b8b93          	addi	s7,s7,856 # ac0 <digits>
 770:	03c9d793          	srli	a5,s3,0x3c
 774:	97de                	add	a5,a5,s7
 776:	0007c583          	lbu	a1,0(a5)
 77a:	855a                	mv	a0,s6
 77c:	d1bff0ef          	jal	496 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 780:	0992                	slli	s3,s3,0x4
 782:	397d                	addiw	s2,s2,-1
 784:	fe0916e3          	bnez	s2,770 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 788:	8bea                	mv	s7,s10
      state = 0;
 78a:	4981                	li	s3,0
 78c:	6d02                	ld	s10,0(sp)
 78e:	bd21                	j	5a6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 790:	008b8993          	addi	s3,s7,8
 794:	000bb903          	ld	s2,0(s7)
 798:	00090f63          	beqz	s2,7b6 <vprintf+0x25a>
        for(; *s; s++)
 79c:	00094583          	lbu	a1,0(s2)
 7a0:	c195                	beqz	a1,7c4 <vprintf+0x268>
          putc(fd, *s);
 7a2:	855a                	mv	a0,s6
 7a4:	cf3ff0ef          	jal	496 <putc>
        for(; *s; s++)
 7a8:	0905                	addi	s2,s2,1
 7aa:	00094583          	lbu	a1,0(s2)
 7ae:	f9f5                	bnez	a1,7a2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7b0:	8bce                	mv	s7,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bbcd                	j	5a6 <vprintf+0x4a>
          s = "(null)";
 7b6:	00000917          	auipc	s2,0x0
 7ba:	30290913          	addi	s2,s2,770 # ab8 <malloc+0x1f6>
        for(; *s; s++)
 7be:	02800593          	li	a1,40
 7c2:	b7c5                	j	7a2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7c4:	8bce                	mv	s7,s3
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bbf9                	j	5a6 <vprintf+0x4a>
 7ca:	64a6                	ld	s1,72(sp)
 7cc:	79e2                	ld	s3,56(sp)
 7ce:	7a42                	ld	s4,48(sp)
 7d0:	7aa2                	ld	s5,40(sp)
 7d2:	7b02                	ld	s6,32(sp)
 7d4:	6be2                	ld	s7,24(sp)
 7d6:	6c42                	ld	s8,16(sp)
 7d8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7da:	60e6                	ld	ra,88(sp)
 7dc:	6446                	ld	s0,80(sp)
 7de:	6906                	ld	s2,64(sp)
 7e0:	6125                	addi	sp,sp,96
 7e2:	8082                	ret

00000000000007e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e4:	715d                	addi	sp,sp,-80
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e010                	sd	a2,0(s0)
 7ee:	e414                	sd	a3,8(s0)
 7f0:	e818                	sd	a4,16(s0)
 7f2:	ec1c                	sd	a5,24(s0)
 7f4:	03043023          	sd	a6,32(s0)
 7f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 800:	8622                	mv	a2,s0
 802:	d5bff0ef          	jal	55c <vprintf>
}
 806:	60e2                	ld	ra,24(sp)
 808:	6442                	ld	s0,16(sp)
 80a:	6161                	addi	sp,sp,80
 80c:	8082                	ret

000000000000080e <printf>:

void
printf(const char *fmt, ...)
{
 80e:	711d                	addi	sp,sp,-96
 810:	ec06                	sd	ra,24(sp)
 812:	e822                	sd	s0,16(sp)
 814:	1000                	addi	s0,sp,32
 816:	e40c                	sd	a1,8(s0)
 818:	e810                	sd	a2,16(s0)
 81a:	ec14                	sd	a3,24(s0)
 81c:	f018                	sd	a4,32(s0)
 81e:	f41c                	sd	a5,40(s0)
 820:	03043823          	sd	a6,48(s0)
 824:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 828:	00840613          	addi	a2,s0,8
 82c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 830:	85aa                	mv	a1,a0
 832:	4505                	li	a0,1
 834:	d29ff0ef          	jal	55c <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6125                	addi	sp,sp,96
 83e:	8082                	ret

0000000000000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	1141                	addi	sp,sp,-16
 842:	e422                	sd	s0,8(sp)
 844:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 846:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	00000797          	auipc	a5,0x0
 84e:	7b67b783          	ld	a5,1974(a5) # 1000 <freep>
 852:	a02d                	j	87c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 854:	4618                	lw	a4,8(a2)
 856:	9f2d                	addw	a4,a4,a1
 858:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	6310                	ld	a2,0(a4)
 860:	a83d                	j	89e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9f31                	addw	a4,a4,a2
 868:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 86a:	ff053683          	ld	a3,-16(a0)
 86e:	a091                	j	8b2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	6398                	ld	a4,0(a5)
 872:	00e7e463          	bltu	a5,a4,87a <free+0x3a>
 876:	00e6ea63          	bltu	a3,a4,88a <free+0x4a>
{
 87a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	fed7fae3          	bgeu	a5,a3,870 <free+0x30>
 880:	6398                	ld	a4,0(a5)
 882:	00e6e463          	bltu	a3,a4,88a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	fee7eae3          	bltu	a5,a4,87a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 88a:	ff852583          	lw	a1,-8(a0)
 88e:	6390                	ld	a2,0(a5)
 890:	02059813          	slli	a6,a1,0x20
 894:	01c85713          	srli	a4,a6,0x1c
 898:	9736                	add	a4,a4,a3
 89a:	fae60de3          	beq	a2,a4,854 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a2:	4790                	lw	a2,8(a5)
 8a4:	02061593          	slli	a1,a2,0x20
 8a8:	01c5d713          	srli	a4,a1,0x1c
 8ac:	973e                	add	a4,a4,a5
 8ae:	fae68ae3          	beq	a3,a4,862 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
}
 8bc:	6422                	ld	s0,8(sp)
 8be:	0141                	addi	sp,sp,16
 8c0:	8082                	ret

00000000000008c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c2:	7139                	addi	sp,sp,-64
 8c4:	fc06                	sd	ra,56(sp)
 8c6:	f822                	sd	s0,48(sp)
 8c8:	f426                	sd	s1,40(sp)
 8ca:	ec4e                	sd	s3,24(sp)
 8cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ce:	02051493          	slli	s1,a0,0x20
 8d2:	9081                	srli	s1,s1,0x20
 8d4:	04bd                	addi	s1,s1,15
 8d6:	8091                	srli	s1,s1,0x4
 8d8:	0014899b          	addiw	s3,s1,1
 8dc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8de:	00000517          	auipc	a0,0x0
 8e2:	72253503          	ld	a0,1826(a0) # 1000 <freep>
 8e6:	c915                	beqz	a0,91a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ea:	4798                	lw	a4,8(a5)
 8ec:	08977a63          	bgeu	a4,s1,980 <malloc+0xbe>
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f8:	8a4e                	mv	s4,s3
 8fa:	0009871b          	sext.w	a4,s3
 8fe:	6685                	lui	a3,0x1
 900:	00d77363          	bgeu	a4,a3,906 <malloc+0x44>
 904:	6a05                	lui	s4,0x1
 906:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90e:	00000917          	auipc	s2,0x0
 912:	6f290913          	addi	s2,s2,1778 # 1000 <freep>
  if(p == (char*)-1)
 916:	5afd                	li	s5,-1
 918:	a081                	j	958 <malloc+0x96>
 91a:	f04a                	sd	s2,32(sp)
 91c:	e852                	sd	s4,16(sp)
 91e:	e456                	sd	s5,8(sp)
 920:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 922:	00000797          	auipc	a5,0x0
 926:	6ee78793          	addi	a5,a5,1774 # 1010 <base>
 92a:	00000717          	auipc	a4,0x0
 92e:	6cf73b23          	sd	a5,1750(a4) # 1000 <freep>
 932:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 934:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 938:	b7c1                	j	8f8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	a8a9                	j	998 <malloc+0xd6>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	efbff0ef          	jal	840 <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	c12d                	beqz	a0,9b0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	02977263          	bgeu	a4,s1,978 <malloc+0xb6>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	ad3ff0ef          	jal	436 <sbrk>
  if(p == (char*)-1)
 968:	fd551ce3          	bne	a0,s5,940 <malloc+0x7e>
        return 0;
 96c:	4501                	li	a0,0
 96e:	7902                	ld	s2,32(sp)
 970:	6a42                	ld	s4,16(sp)
 972:	6aa2                	ld	s5,8(sp)
 974:	6b02                	ld	s6,0(sp)
 976:	a03d                	j	9a4 <malloc+0xe2>
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 980:	fae48de3          	beq	s1,a4,93a <malloc+0x78>
        p->s.size -= nunits;
 984:	4137073b          	subw	a4,a4,s3
 988:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98a:	02071693          	slli	a3,a4,0x20
 98e:	01c6d713          	srli	a4,a3,0x1c
 992:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 994:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 998:	00000717          	auipc	a4,0x0
 99c:	66a73423          	sd	a0,1640(a4) # 1000 <freep>
      return (void*)(p + 1);
 9a0:	01078513          	addi	a0,a5,16
  }
}
 9a4:	70e2                	ld	ra,56(sp)
 9a6:	7442                	ld	s0,48(sp)
 9a8:	74a2                	ld	s1,40(sp)
 9aa:	69e2                	ld	s3,24(sp)
 9ac:	6121                	addi	sp,sp,64
 9ae:	8082                	ret
 9b0:	7902                	ld	s2,32(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
 9b8:	b7f5                	j	9a4 <malloc+0xe2>
