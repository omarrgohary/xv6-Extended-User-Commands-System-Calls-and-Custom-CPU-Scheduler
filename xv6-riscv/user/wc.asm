
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9a8a0a13          	addi	s4,s4,-1624 # 9e0 <malloc+0x106>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	366000ef          	jal	3de <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x126>
  a6:	780000ef          	jal	826 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	92850513          	addi	a0,a0,-1752 # 9f0 <malloc+0x116>
  d0:	756000ef          	jal	826 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	2f0000ef          	jal	3c6 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	2fe000ef          	jal	406 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	2d2000ef          	jal	3ee <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	29e000ef          	jal	3c6 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8b658593          	addi	a1,a1,-1866 # 9e8 <malloc+0x10e>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	284000ef          	jal	3c6 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8c650513          	addi	a0,a0,-1850 # a10 <malloc+0x136>
 152:	6d4000ef          	jal	826 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	26e000ef          	jal	3c6 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	25c000ef          	jal	3c6 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	186000ef          	jal	3de <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	162000ef          	jal	406 <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	16c000ef          	jal	41e <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	134000ef          	jal	3ee <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3be:	4885                	li	a7,1
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c6:	4889                	li	a7,2
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ce:	488d                	li	a7,3
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d6:	4891                	li	a7,4
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <read>:
.global read
read:
 li a7, SYS_read
 3de:	4895                	li	a7,5
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <write>:
.global write
write:
 li a7, SYS_write
 3e6:	48c1                	li	a7,16
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <close>:
.global close
close:
 li a7, SYS_close
 3ee:	48d5                	li	a7,21
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f6:	4899                	li	a7,6
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fe:	489d                	li	a7,7
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <open>:
.global open
open:
 li a7, SYS_open
 406:	48bd                	li	a7,15
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40e:	48c5                	li	a7,17
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 416:	48c9                	li	a7,18
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41e:	48a1                	li	a7,8
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <link>:
.global link
link:
 li a7, SYS_link
 426:	48cd                	li	a7,19
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42e:	48d1                	li	a7,20
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 436:	48a5                	li	a7,9
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <dup>:
.global dup
dup:
 li a7, SYS_dup
 43e:	48a9                	li	a7,10
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 446:	48ad                	li	a7,11
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44e:	48b1                	li	a7,12
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 456:	48b5                	li	a7,13
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45e:	48b9                	li	a7,14
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 466:	48d9                	li	a7,22
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 46e:	48dd                	li	a7,23
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 476:	48e1                	li	a7,24
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 47e:	48e5                	li	a7,25
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 486:	48e9                	li	a7,26
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 48e:	48ed                	li	a7,27
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 496:	48f1                	li	a7,28
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 49e:	48f5                	li	a7,29
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 4a6:	48f9                	li	a7,30
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ae:	1101                	addi	sp,sp,-32
 4b0:	ec06                	sd	ra,24(sp)
 4b2:	e822                	sd	s0,16(sp)
 4b4:	1000                	addi	s0,sp,32
 4b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ba:	4605                	li	a2,1
 4bc:	fef40593          	addi	a1,s0,-17
 4c0:	f27ff0ef          	jal	3e6 <write>
}
 4c4:	60e2                	ld	ra,24(sp)
 4c6:	6442                	ld	s0,16(sp)
 4c8:	6105                	addi	sp,sp,32
 4ca:	8082                	ret

00000000000004cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cc:	7139                	addi	sp,sp,-64
 4ce:	fc06                	sd	ra,56(sp)
 4d0:	f822                	sd	s0,48(sp)
 4d2:	f426                	sd	s1,40(sp)
 4d4:	0080                	addi	s0,sp,64
 4d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d8:	c299                	beqz	a3,4de <printint+0x12>
 4da:	0805c963          	bltz	a1,56c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4de:	2581                	sext.w	a1,a1
  neg = 0;
 4e0:	4881                	li	a7,0
 4e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e8:	2601                	sext.w	a2,a2
 4ea:	00000517          	auipc	a0,0x0
 4ee:	54650513          	addi	a0,a0,1350 # a30 <digits>
 4f2:	883a                	mv	a6,a4
 4f4:	2705                	addiw	a4,a4,1
 4f6:	02c5f7bb          	remuw	a5,a1,a2
 4fa:	1782                	slli	a5,a5,0x20
 4fc:	9381                	srli	a5,a5,0x20
 4fe:	97aa                	add	a5,a5,a0
 500:	0007c783          	lbu	a5,0(a5)
 504:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 508:	0005879b          	sext.w	a5,a1
 50c:	02c5d5bb          	divuw	a1,a1,a2
 510:	0685                	addi	a3,a3,1
 512:	fec7f0e3          	bgeu	a5,a2,4f2 <printint+0x26>
  if(neg)
 516:	00088c63          	beqz	a7,52e <printint+0x62>
    buf[i++] = '-';
 51a:	fd070793          	addi	a5,a4,-48
 51e:	00878733          	add	a4,a5,s0
 522:	02d00793          	li	a5,45
 526:	fef70823          	sb	a5,-16(a4)
 52a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52e:	02e05a63          	blez	a4,562 <printint+0x96>
 532:	f04a                	sd	s2,32(sp)
 534:	ec4e                	sd	s3,24(sp)
 536:	fc040793          	addi	a5,s0,-64
 53a:	00e78933          	add	s2,a5,a4
 53e:	fff78993          	addi	s3,a5,-1
 542:	99ba                	add	s3,s3,a4
 544:	377d                	addiw	a4,a4,-1
 546:	1702                	slli	a4,a4,0x20
 548:	9301                	srli	a4,a4,0x20
 54a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 54e:	fff94583          	lbu	a1,-1(s2)
 552:	8526                	mv	a0,s1
 554:	f5bff0ef          	jal	4ae <putc>
  while(--i >= 0)
 558:	197d                	addi	s2,s2,-1
 55a:	ff391ae3          	bne	s2,s3,54e <printint+0x82>
 55e:	7902                	ld	s2,32(sp)
 560:	69e2                	ld	s3,24(sp)
}
 562:	70e2                	ld	ra,56(sp)
 564:	7442                	ld	s0,48(sp)
 566:	74a2                	ld	s1,40(sp)
 568:	6121                	addi	sp,sp,64
 56a:	8082                	ret
    x = -xx;
 56c:	40b005bb          	negw	a1,a1
    neg = 1;
 570:	4885                	li	a7,1
    x = -xx;
 572:	bf85                	j	4e2 <printint+0x16>

0000000000000574 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 574:	711d                	addi	sp,sp,-96
 576:	ec86                	sd	ra,88(sp)
 578:	e8a2                	sd	s0,80(sp)
 57a:	e0ca                	sd	s2,64(sp)
 57c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57e:	0005c903          	lbu	s2,0(a1)
 582:	26090863          	beqz	s2,7f2 <vprintf+0x27e>
 586:	e4a6                	sd	s1,72(sp)
 588:	fc4e                	sd	s3,56(sp)
 58a:	f852                	sd	s4,48(sp)
 58c:	f456                	sd	s5,40(sp)
 58e:	f05a                	sd	s6,32(sp)
 590:	ec5e                	sd	s7,24(sp)
 592:	e862                	sd	s8,16(sp)
 594:	e466                	sd	s9,8(sp)
 596:	8b2a                	mv	s6,a0
 598:	8a2e                	mv	s4,a1
 59a:	8bb2                	mv	s7,a2
  state = 0;
 59c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 59e:	4481                	li	s1,0
 5a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5aa:	06c00c93          	li	s9,108
 5ae:	a005                	j	5ce <vprintf+0x5a>
        putc(fd, c0);
 5b0:	85ca                	mv	a1,s2
 5b2:	855a                	mv	a0,s6
 5b4:	efbff0ef          	jal	4ae <putc>
 5b8:	a019                	j	5be <vprintf+0x4a>
    } else if(state == '%'){
 5ba:	03598263          	beq	s3,s5,5de <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5be:	2485                	addiw	s1,s1,1
 5c0:	8726                	mv	a4,s1
 5c2:	009a07b3          	add	a5,s4,s1
 5c6:	0007c903          	lbu	s2,0(a5)
 5ca:	20090c63          	beqz	s2,7e2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5ce:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d2:	fe0994e3          	bnez	s3,5ba <vprintf+0x46>
      if(c0 == '%'){
 5d6:	fd579de3          	bne	a5,s5,5b0 <vprintf+0x3c>
        state = '%';
 5da:	89be                	mv	s3,a5
 5dc:	b7cd                	j	5be <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5de:	00ea06b3          	add	a3,s4,a4
 5e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5e8:	c681                	beqz	a3,5f0 <vprintf+0x7c>
 5ea:	9752                	add	a4,a4,s4
 5ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f0:	03878f63          	beq	a5,s8,62e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	05978963          	beq	a5,s9,646 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5f8:	07500713          	li	a4,117
 5fc:	0ee78363          	beq	a5,a4,6e2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 600:	07800713          	li	a4,120
 604:	12e78563          	beq	a5,a4,72e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 608:	07000713          	li	a4,112
 60c:	14e78a63          	beq	a5,a4,760 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 610:	07300713          	li	a4,115
 614:	18e78a63          	beq	a5,a4,7a8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 618:	02500713          	li	a4,37
 61c:	04e79563          	bne	a5,a4,666 <vprintf+0xf2>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	855a                	mv	a0,s6
 626:	e89ff0ef          	jal	4ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bf49                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 62e:	008b8913          	addi	s2,s7,8
 632:	4685                	li	a3,1
 634:	4629                	li	a2,10
 636:	000ba583          	lw	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	e91ff0ef          	jal	4cc <printint>
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bfad                	j	5be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 646:	06400793          	li	a5,100
 64a:	02f68963          	beq	a3,a5,67c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 64e:	06c00793          	li	a5,108
 652:	04f68263          	beq	a3,a5,696 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 656:	07500793          	li	a5,117
 65a:	0af68063          	beq	a3,a5,6fa <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 65e:	07800793          	li	a5,120
 662:	0ef68263          	beq	a3,a5,746 <vprintf+0x1d2>
        putc(fd, '%');
 666:	02500593          	li	a1,37
 66a:	855a                	mv	a0,s6
 66c:	e43ff0ef          	jal	4ae <putc>
        putc(fd, c0);
 670:	85ca                	mv	a1,s2
 672:	855a                	mv	a0,s6
 674:	e3bff0ef          	jal	4ae <putc>
      state = 0;
 678:	4981                	li	s3,0
 67a:	b791                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	008b8913          	addi	s2,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e43ff0ef          	jal	4cc <printint>
        i += 1;
 68e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	b72d                	j	5be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 696:	06400793          	li	a5,100
 69a:	02f60763          	beq	a2,a5,6c8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69e:	07500793          	li	a5,117
 6a2:	06f60963          	beq	a2,a5,714 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6a6:	07800793          	li	a5,120
 6aa:	faf61ee3          	bne	a2,a5,666 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	e11ff0ef          	jal	4cc <printint>
        i += 2;
 6c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	bde5                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4685                	li	a3,1
 6ce:	4629                	li	a2,10
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	df7ff0ef          	jal	4cc <printint>
        i += 2;
 6da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	bdf9                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	dddff0ef          	jal	4cc <printint>
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b5d9                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000ba583          	lw	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	dc5ff0ef          	jal	4cc <printint>
        i += 1;
 70c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	8bca                	mv	s7,s2
      state = 0;
 710:	4981                	li	s3,0
        i += 1;
 712:	b575                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 714:	008b8913          	addi	s2,s7,8
 718:	4681                	li	a3,0
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	dabff0ef          	jal	4cc <printint>
        i += 2;
 726:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 2;
 72c:	bd49                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4641                	li	a2,16
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	d91ff0ef          	jal	4cc <printint>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	bdad                	j	5be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	008b8913          	addi	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	d79ff0ef          	jal	4cc <printint>
        i += 1;
 758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 1;
 75e:	b585                	j	5be <vprintf+0x4a>
 760:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 762:	008b8d13          	addi	s10,s7,8
 766:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76a:	03000593          	li	a1,48
 76e:	855a                	mv	a0,s6
 770:	d3fff0ef          	jal	4ae <putc>
  putc(fd, 'x');
 774:	07800593          	li	a1,120
 778:	855a                	mv	a0,s6
 77a:	d35ff0ef          	jal	4ae <putc>
 77e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	00000b97          	auipc	s7,0x0
 784:	2b0b8b93          	addi	s7,s7,688 # a30 <digits>
 788:	03c9d793          	srli	a5,s3,0x3c
 78c:	97de                	add	a5,a5,s7
 78e:	0007c583          	lbu	a1,0(a5)
 792:	855a                	mv	a0,s6
 794:	d1bff0ef          	jal	4ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 798:	0992                	slli	s3,s3,0x4
 79a:	397d                	addiw	s2,s2,-1
 79c:	fe0916e3          	bnez	s2,788 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7a0:	8bea                	mv	s7,s10
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	6d02                	ld	s10,0(sp)
 7a6:	bd21                	j	5be <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7a8:	008b8993          	addi	s3,s7,8
 7ac:	000bb903          	ld	s2,0(s7)
 7b0:	00090f63          	beqz	s2,7ce <vprintf+0x25a>
        for(; *s; s++)
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	c195                	beqz	a1,7dc <vprintf+0x268>
          putc(fd, *s);
 7ba:	855a                	mv	a0,s6
 7bc:	cf3ff0ef          	jal	4ae <putc>
        for(; *s; s++)
 7c0:	0905                	addi	s2,s2,1
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	f9f5                	bnez	a1,7ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	8bce                	mv	s7,s3
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bbcd                	j	5be <vprintf+0x4a>
          s = "(null)";
 7ce:	00000917          	auipc	s2,0x0
 7d2:	25a90913          	addi	s2,s2,602 # a28 <malloc+0x14e>
        for(; *s; s++)
 7d6:	02800593          	li	a1,40
 7da:	b7c5                	j	7ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7dc:	8bce                	mv	s7,s3
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bbf9                	j	5be <vprintf+0x4a>
 7e2:	64a6                	ld	s1,72(sp)
 7e4:	79e2                	ld	s3,56(sp)
 7e6:	7a42                	ld	s4,48(sp)
 7e8:	7aa2                	ld	s5,40(sp)
 7ea:	7b02                	ld	s6,32(sp)
 7ec:	6be2                	ld	s7,24(sp)
 7ee:	6c42                	ld	s8,16(sp)
 7f0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f2:	60e6                	ld	ra,88(sp)
 7f4:	6446                	ld	s0,80(sp)
 7f6:	6906                	ld	s2,64(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fc:	715d                	addi	sp,sp,-80
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	addi	s0,sp,32
 804:	e010                	sd	a2,0(s0)
 806:	e414                	sd	a3,8(s0)
 808:	e818                	sd	a4,16(s0)
 80a:	ec1c                	sd	a5,24(s0)
 80c:	03043023          	sd	a6,32(s0)
 810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 818:	8622                	mv	a2,s0
 81a:	d5bff0ef          	jal	574 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6161                	addi	sp,sp,80
 824:	8082                	ret

0000000000000826 <printf>:

void
printf(const char *fmt, ...)
{
 826:	711d                	addi	sp,sp,-96
 828:	ec06                	sd	ra,24(sp)
 82a:	e822                	sd	s0,16(sp)
 82c:	1000                	addi	s0,sp,32
 82e:	e40c                	sd	a1,8(s0)
 830:	e810                	sd	a2,16(s0)
 832:	ec14                	sd	a3,24(s0)
 834:	f018                	sd	a4,32(s0)
 836:	f41c                	sd	a5,40(s0)
 838:	03043823          	sd	a6,48(s0)
 83c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	00840613          	addi	a2,s0,8
 844:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 848:	85aa                	mv	a1,a0
 84a:	4505                	li	a0,1
 84c:	d29ff0ef          	jal	574 <vprintf>
}
 850:	60e2                	ld	ra,24(sp)
 852:	6442                	ld	s0,16(sp)
 854:	6125                	addi	sp,sp,96
 856:	8082                	ret

0000000000000858 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 858:	1141                	addi	sp,sp,-16
 85a:	e422                	sd	s0,8(sp)
 85c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	00000797          	auipc	a5,0x0
 866:	79e7b783          	ld	a5,1950(a5) # 1000 <freep>
 86a:	a02d                	j	894 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86c:	4618                	lw	a4,8(a2)
 86e:	9f2d                	addw	a4,a4,a1
 870:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	6398                	ld	a4,0(a5)
 876:	6310                	ld	a2,0(a4)
 878:	a83d                	j	8b6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87a:	ff852703          	lw	a4,-8(a0)
 87e:	9f31                	addw	a4,a4,a2
 880:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 882:	ff053683          	ld	a3,-16(a0)
 886:	a091                	j	8ca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	6398                	ld	a4,0(a5)
 88a:	00e7e463          	bltu	a5,a4,892 <free+0x3a>
 88e:	00e6ea63          	bltu	a3,a4,8a2 <free+0x4a>
{
 892:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	fed7fae3          	bgeu	a5,a3,888 <free+0x30>
 898:	6398                	ld	a4,0(a5)
 89a:	00e6e463          	bltu	a3,a4,8a2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	fee7eae3          	bltu	a5,a4,892 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a2:	ff852583          	lw	a1,-8(a0)
 8a6:	6390                	ld	a2,0(a5)
 8a8:	02059813          	slli	a6,a1,0x20
 8ac:	01c85713          	srli	a4,a6,0x1c
 8b0:	9736                	add	a4,a4,a3
 8b2:	fae60de3          	beq	a2,a4,86c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ba:	4790                	lw	a2,8(a5)
 8bc:	02061593          	slli	a1,a2,0x20
 8c0:	01c5d713          	srli	a4,a1,0x1c
 8c4:	973e                	add	a4,a4,a5
 8c6:	fae68ae3          	beq	a3,a4,87a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
}
 8d4:	6422                	ld	s0,8(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret

00000000000008da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8da:	7139                	addi	sp,sp,-64
 8dc:	fc06                	sd	ra,56(sp)
 8de:	f822                	sd	s0,48(sp)
 8e0:	f426                	sd	s1,40(sp)
 8e2:	ec4e                	sd	s3,24(sp)
 8e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e6:	02051493          	slli	s1,a0,0x20
 8ea:	9081                	srli	s1,s1,0x20
 8ec:	04bd                	addi	s1,s1,15
 8ee:	8091                	srli	s1,s1,0x4
 8f0:	0014899b          	addiw	s3,s1,1
 8f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f6:	00000517          	auipc	a0,0x0
 8fa:	70a53503          	ld	a0,1802(a0) # 1000 <freep>
 8fe:	c915                	beqz	a0,932 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	08977a63          	bgeu	a4,s1,998 <malloc+0xbe>
 908:	f04a                	sd	s2,32(sp)
 90a:	e852                	sd	s4,16(sp)
 90c:	e456                	sd	s5,8(sp)
 90e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 910:	8a4e                	mv	s4,s3
 912:	0009871b          	sext.w	a4,s3
 916:	6685                	lui	a3,0x1
 918:	00d77363          	bgeu	a4,a3,91e <malloc+0x44>
 91c:	6a05                	lui	s4,0x1
 91e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 926:	00000917          	auipc	s2,0x0
 92a:	6da90913          	addi	s2,s2,1754 # 1000 <freep>
  if(p == (char*)-1)
 92e:	5afd                	li	s5,-1
 930:	a081                	j	970 <malloc+0x96>
 932:	f04a                	sd	s2,32(sp)
 934:	e852                	sd	s4,16(sp)
 936:	e456                	sd	s5,8(sp)
 938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93a:	00001797          	auipc	a5,0x1
 93e:	8d678793          	addi	a5,a5,-1834 # 1210 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 950:	b7c1                	j	910 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	e118                	sd	a4,0(a0)
 956:	a8a9                	j	9b0 <malloc+0xd6>
  hp->s.size = nu;
 958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95c:	0541                	addi	a0,a0,16
 95e:	efbff0ef          	jal	858 <free>
  return freep;
 962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 966:	c12d                	beqz	a0,9c8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	02977263          	bgeu	a4,s1,990 <malloc+0xb6>
    if(p == freep)
 970:	00093703          	ld	a4,0(s2)
 974:	853e                	mv	a0,a5
 976:	fef719e3          	bne	a4,a5,968 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 97a:	8552                	mv	a0,s4
 97c:	ad3ff0ef          	jal	44e <sbrk>
  if(p == (char*)-1)
 980:	fd551ce3          	bne	a0,s5,958 <malloc+0x7e>
        return 0;
 984:	4501                	li	a0,0
 986:	7902                	ld	s2,32(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	a03d                	j	9bc <malloc+0xe2>
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 998:	fae48de3          	beq	s1,a4,952 <malloc+0x78>
        p->s.size -= nunits;
 99c:	4137073b          	subw	a4,a4,s3
 9a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a2:	02071693          	slli	a3,a4,0x20
 9a6:	01c6d713          	srli	a4,a3,0x1c
 9aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b0:	00000717          	auipc	a4,0x0
 9b4:	64a73823          	sd	a0,1616(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b8:	01078513          	addi	a0,a5,16
  }
}
 9bc:	70e2                	ld	ra,56(sp)
 9be:	7442                	ld	s0,48(sp)
 9c0:	74a2                	ld	s1,40(sp)
 9c2:	69e2                	ld	s3,24(sp)
 9c4:	6121                	addi	sp,sp,64
 9c6:	8082                	ret
 9c8:	7902                	ld	s2,32(sp)
 9ca:	6a42                	ld	s4,16(sp)
 9cc:	6aa2                	ld	s5,8(sp)
 9ce:	6b02                	ld	s6,0(sp)
 9d0:	b7f5                	j	9bc <malloc+0xe2>
