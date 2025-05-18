
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[]) {
   0:	d7010113          	addi	sp,sp,-656
   4:	28113423          	sd	ra,648(sp)
   8:	28813023          	sd	s0,640(sp)
   c:	0d00                	addi	s0,sp,656
  int fd;
  struct dirent de;
  struct stat st;
  int found = 0;  // Flag to stop searching once the file is found

  if (argc != 3) {
   e:	478d                	li	a5,3
  10:	02f50563          	beq	a0,a5,3a <main+0x3a>
  14:	26913c23          	sd	s1,632(sp)
  18:	27213823          	sd	s2,624(sp)
  1c:	27313423          	sd	s3,616(sp)
  20:	27413023          	sd	s4,608(sp)
  24:	25513c23          	sd	s5,600(sp)
  28:	25613823          	sd	s6,592(sp)
  2c:	25713423          	sd	s7,584(sp)
  30:	25813023          	sd	s8,576(sp)
    exit(1);  // Exit if incorrect number of arguments
  34:	4505                	li	a0,1
  36:	41c000ef          	jal	452 <exit>
  3a:	26913c23          	sd	s1,632(sp)
  3e:	27213823          	sd	s2,624(sp)
  42:	892e                	mv	s2,a1
  }

  fd = open(argv[1], 0);
  44:	4581                	li	a1,0
  46:	00893503          	ld	a0,8(s2)
  4a:	448000ef          	jal	492 <open>
  4e:	84aa                	mv	s1,a0
  if(fd < 0){
  50:	04054063          	bltz	a0,90 <main+0x90>
  54:	27313423          	sd	s3,616(sp)
  58:	27413023          	sd	s4,608(sp)
  5c:	25513c23          	sd	s5,600(sp)
  60:	25613823          	sd	s6,592(sp)
  64:	25713423          	sd	s7,584(sp)
  68:	25813023          	sd	s8,576(sp)
    exit(0);  // Exit if failed to open directory
  }

  fstat(fd, &st);
  6c:	d8840593          	addi	a1,s0,-632
  70:	43a000ef          	jal	4aa <fstat>

  if(st.type == T_FILE){
  74:	d9041783          	lh	a5,-624(s0)
  78:	4709                	li	a4,2
  7a:	02e78a63          	beq	a5,a4,ae <main+0xae>
      printf("%s\n", argv[1]);  // Print the file path if file is found
      found = 1;  // Set the flag when file is found
    }
  }

  if(st.type == T_DIR && !found) {  // Only search directories if file is not found
  7e:	4705                	li	a4,1
  80:	12e78463          	beq	a5,a4,1a8 <main+0x1a8>
        wait(0);
      }
    }
  }

  close(fd);
  84:	8526                	mv	a0,s1
  86:	3f4000ef          	jal	47a <close>
  if (!found) {
    exit(0);  // Exit if file is not found
  8a:	4501                	li	a0,0
  8c:	3c6000ef          	jal	452 <exit>
  90:	27313423          	sd	s3,616(sp)
  94:	27413023          	sd	s4,608(sp)
  98:	25513c23          	sd	s5,600(sp)
  9c:	25613823          	sd	s6,592(sp)
  a0:	25713423          	sd	s7,584(sp)
  a4:	25813023          	sd	s8,576(sp)
    exit(0);  // Exit if failed to open directory
  a8:	4501                	li	a0,0
  aa:	3a8000ef          	jal	452 <exit>
    if(strcmp(argv[1], argv[2]) == 0){
  ae:	00893983          	ld	s3,8(s2)
  b2:	01093583          	ld	a1,16(s2)
  b6:	854e                	mv	a0,s3
  b8:	15e000ef          	jal	216 <strcmp>
  bc:	c509                	beqz	a0,c6 <main+0xc6>
  close(fd);
  be:	8526                	mv	a0,s1
  c0:	3ba000ef          	jal	47a <close>
  if (!found) {
  c4:	b7d9                	j	8a <main+0x8a>
      printf("%s\n", argv[1]);  // Print the file path if file is found
  c6:	85ce                	mv	a1,s3
  c8:	00001517          	auipc	a0,0x1
  cc:	99850513          	addi	a0,a0,-1640 # a60 <malloc+0xfa>
  d0:	7e2000ef          	jal	8b2 <printf>
  if(st.type == T_DIR && !found) {  // Only search directories if file is not found
  d4:	d9041703          	lh	a4,-624(s0)
  d8:	4785                	li	a5,1
  da:	0af70d63          	beq	a4,a5,194 <main+0x194>
  close(fd);
  de:	8526                	mv	a0,s1
  e0:	39a000ef          	jal	47a <close>
  if (!found) {
  e4:	a85d                	j	19a <main+0x19a>
      char *argv_new[] = { argv[0], buf, argv[2] };
  e6:	00093783          	ld	a5,0(s2)
  ea:	d6f43823          	sd	a5,-656(s0)
  ee:	db040793          	addi	a5,s0,-592
  f2:	d6f43c23          	sd	a5,-648(s0)
  f6:	01093783          	ld	a5,16(s2)
  fa:	d8f43023          	sd	a5,-640(s0)
      if(fork() == 0){
  fe:	34c000ef          	jal	44a <fork>
 102:	ed59                	bnez	a0,1a0 <main+0x1a0>
        exec(argv[0], argv_new);
 104:	d7040593          	addi	a1,s0,-656
 108:	00093503          	ld	a0,0(s2)
 10c:	37e000ef          	jal	48a <exec>
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 110:	4641                	li	a2,16
 112:	da040593          	addi	a1,s0,-608
 116:	8526                	mv	a0,s1
 118:	352000ef          	jal	46a <read>
 11c:	47c1                	li	a5,16
 11e:	faf510e3          	bne	a0,a5,be <main+0xbe>
      if(de.inum == 0)
 122:	da045783          	lhu	a5,-608(s0)
 126:	d7ed                	beqz	a5,110 <main+0x110>
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 128:	85ce                	mv	a1,s3
 12a:	da240513          	addi	a0,s0,-606
 12e:	0e8000ef          	jal	216 <strcmp>
 132:	dd79                	beqz	a0,110 <main+0x110>
 134:	85d6                	mv	a1,s5
 136:	da240513          	addi	a0,s0,-606
 13a:	0dc000ef          	jal	216 <strcmp>
 13e:	d969                	beqz	a0,110 <main+0x110>
      memmove(p, de.name, DIRSIZ);
 140:	4639                	li	a2,14
 142:	da240593          	addi	a1,s0,-606
 146:	855a                	mv	a0,s6
 148:	25c000ef          	jal	3a4 <memmove>
      p[DIRSIZ] = 0;
 14c:	000a07a3          	sb	zero,15(s4)
      int fd2 = open(buf, 0);
 150:	4581                	li	a1,0
 152:	db040513          	addi	a0,s0,-592
 156:	33c000ef          	jal	492 <open>
 15a:	8c2a                	mv	s8,a0
      if(fd2 < 0) {
 15c:	fa054ae3          	bltz	a0,110 <main+0x110>
      fstat(fd2, &st);
 160:	d8840593          	addi	a1,s0,-632
 164:	346000ef          	jal	4aa <fstat>
      close(fd2);
 168:	8562                	mv	a0,s8
 16a:	310000ef          	jal	47a <close>
      if (st.type == T_FILE && strcmp(de.name, argv[2]) == 0) {
 16e:	d9041783          	lh	a5,-624(s0)
 172:	f7779ae3          	bne	a5,s7,e6 <main+0xe6>
 176:	01093583          	ld	a1,16(s2)
 17a:	da240513          	addi	a0,s0,-606
 17e:	098000ef          	jal	216 <strcmp>
 182:	f135                	bnez	a0,e6 <main+0xe6>
        printf("%s\n", buf);  // Print file path once found
 184:	db040593          	addi	a1,s0,-592
 188:	00001517          	auipc	a0,0x1
 18c:	8d850513          	addi	a0,a0,-1832 # a60 <malloc+0xfa>
 190:	722000ef          	jal	8b2 <printf>
  close(fd);
 194:	8526                	mv	a0,s1
 196:	2e4000ef          	jal	47a <close>
  }

  exit(0);
 19a:	4501                	li	a0,0
 19c:	2b6000ef          	jal	452 <exit>
        wait(0);
 1a0:	4501                	li	a0,0
 1a2:	2b8000ef          	jal	45a <wait>
 1a6:	b7ad                	j	110 <main+0x110>
    strcpy(buf, argv[1]);
 1a8:	00893583          	ld	a1,8(s2)
 1ac:	db040513          	addi	a0,s0,-592
 1b0:	04a000ef          	jal	1fa <strcpy>
    p = buf + strlen(buf);
 1b4:	db040513          	addi	a0,s0,-592
 1b8:	08a000ef          	jal	242 <strlen>
 1bc:	1502                	slli	a0,a0,0x20
 1be:	9101                	srli	a0,a0,0x20
 1c0:	db040793          	addi	a5,s0,-592
 1c4:	00a78a33          	add	s4,a5,a0
    *p++ = '/';
 1c8:	001a0b13          	addi	s6,s4,1
 1cc:	02f00793          	li	a5,47
 1d0:	00fa0023          	sb	a5,0(s4)
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 1d4:	00001997          	auipc	s3,0x1
 1d8:	89498993          	addi	s3,s3,-1900 # a68 <malloc+0x102>
 1dc:	00001a97          	auipc	s5,0x1
 1e0:	894a8a93          	addi	s5,s5,-1900 # a70 <malloc+0x10a>
      if (st.type == T_FILE && strcmp(de.name, argv[2]) == 0) {
 1e4:	4b89                	li	s7,2
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 1e6:	b72d                	j	110 <main+0x110>

00000000000001e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1f0:	e11ff0ef          	jal	0 <main>
  exit(0);
 1f4:	4501                	li	a0,0
 1f6:	25c000ef          	jal	452 <exit>

00000000000001fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 200:	87aa                	mv	a5,a0
 202:	0585                	addi	a1,a1,1
 204:	0785                	addi	a5,a5,1
 206:	fff5c703          	lbu	a4,-1(a1)
 20a:	fee78fa3          	sb	a4,-1(a5)
 20e:	fb75                	bnez	a4,202 <strcpy+0x8>
    ;
  return os;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	cb91                	beqz	a5,234 <strcmp+0x1e>
 222:	0005c703          	lbu	a4,0(a1)
 226:	00f71763          	bne	a4,a5,234 <strcmp+0x1e>
    p++, q++;
 22a:	0505                	addi	a0,a0,1
 22c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22e:	00054783          	lbu	a5,0(a0)
 232:	fbe5                	bnez	a5,222 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 234:	0005c503          	lbu	a0,0(a1)
}
 238:	40a7853b          	subw	a0,a5,a0
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strlen>:

uint
strlen(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf91                	beqz	a5,268 <strlen+0x26>
 24e:	0505                	addi	a0,a0,1
 250:	87aa                	mv	a5,a0
 252:	86be                	mv	a3,a5
 254:	0785                	addi	a5,a5,1
 256:	fff7c703          	lbu	a4,-1(a5)
 25a:	ff65                	bnez	a4,252 <strlen+0x10>
 25c:	40a6853b          	subw	a0,a3,a0
 260:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  for(n = 0; s[n]; n++)
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <strlen+0x20>

000000000000026c <memset>:

void*
memset(void *dst, int c, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 272:	ca19                	beqz	a2,288 <memset+0x1c>
 274:	87aa                	mv	a5,a0
 276:	1602                	slli	a2,a2,0x20
 278:	9201                	srli	a2,a2,0x20
 27a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 282:	0785                	addi	a5,a5,1
 284:	fee79de3          	bne	a5,a4,27e <memset+0x12>
  }
  return dst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strchr>:

char*
strchr(const char *s, char c)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  for(; *s; s++)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb99                	beqz	a5,2ae <strchr+0x20>
    if(*s == c)
 29a:	00f58763          	beq	a1,a5,2a8 <strchr+0x1a>
  for(; *s; s++)
 29e:	0505                	addi	a0,a0,1
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbfd                	bnez	a5,29a <strchr+0xc>
      return (char*)s;
  return 0;
 2a6:	4501                	li	a0,0
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <strchr+0x1a>

00000000000002b2 <gets>:

char*
gets(char *buf, int max)
{
 2b2:	711d                	addi	sp,sp,-96
 2b4:	ec86                	sd	ra,88(sp)
 2b6:	e8a2                	sd	s0,80(sp)
 2b8:	e4a6                	sd	s1,72(sp)
 2ba:	e0ca                	sd	s2,64(sp)
 2bc:	fc4e                	sd	s3,56(sp)
 2be:	f852                	sd	s4,48(sp)
 2c0:	f456                	sd	s5,40(sp)
 2c2:	f05a                	sd	s6,32(sp)
 2c4:	ec5e                	sd	s7,24(sp)
 2c6:	1080                	addi	s0,sp,96
 2c8:	8baa                	mv	s7,a0
 2ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	892a                	mv	s2,a0
 2ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d0:	4aa9                	li	s5,10
 2d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d4:	89a6                	mv	s3,s1
 2d6:	2485                	addiw	s1,s1,1
 2d8:	0344d663          	bge	s1,s4,304 <gets+0x52>
    cc = read(0, &c, 1);
 2dc:	4605                	li	a2,1
 2de:	faf40593          	addi	a1,s0,-81
 2e2:	4501                	li	a0,0
 2e4:	186000ef          	jal	46a <read>
    if(cc < 1)
 2e8:	00a05e63          	blez	a0,304 <gets+0x52>
    buf[i++] = c;
 2ec:	faf44783          	lbu	a5,-81(s0)
 2f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f4:	01578763          	beq	a5,s5,302 <gets+0x50>
 2f8:	0905                	addi	s2,s2,1
 2fa:	fd679de3          	bne	a5,s6,2d4 <gets+0x22>
    buf[i++] = c;
 2fe:	89a6                	mv	s3,s1
 300:	a011                	j	304 <gets+0x52>
 302:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 304:	99de                	add	s3,s3,s7
 306:	00098023          	sb	zero,0(s3)
  return buf;
}
 30a:	855e                	mv	a0,s7
 30c:	60e6                	ld	ra,88(sp)
 30e:	6446                	ld	s0,80(sp)
 310:	64a6                	ld	s1,72(sp)
 312:	6906                	ld	s2,64(sp)
 314:	79e2                	ld	s3,56(sp)
 316:	7a42                	ld	s4,48(sp)
 318:	7aa2                	ld	s5,40(sp)
 31a:	7b02                	ld	s6,32(sp)
 31c:	6be2                	ld	s7,24(sp)
 31e:	6125                	addi	sp,sp,96
 320:	8082                	ret

0000000000000322 <stat>:

int
stat(const char *n, struct stat *st)
{
 322:	1101                	addi	sp,sp,-32
 324:	ec06                	sd	ra,24(sp)
 326:	e822                	sd	s0,16(sp)
 328:	e04a                	sd	s2,0(sp)
 32a:	1000                	addi	s0,sp,32
 32c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32e:	4581                	li	a1,0
 330:	162000ef          	jal	492 <open>
  if(fd < 0)
 334:	02054263          	bltz	a0,358 <stat+0x36>
 338:	e426                	sd	s1,8(sp)
 33a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33c:	85ca                	mv	a1,s2
 33e:	16c000ef          	jal	4aa <fstat>
 342:	892a                	mv	s2,a0
  close(fd);
 344:	8526                	mv	a0,s1
 346:	134000ef          	jal	47a <close>
  return r;
 34a:	64a2                	ld	s1,8(sp)
}
 34c:	854a                	mv	a0,s2
 34e:	60e2                	ld	ra,24(sp)
 350:	6442                	ld	s0,16(sp)
 352:	6902                	ld	s2,0(sp)
 354:	6105                	addi	sp,sp,32
 356:	8082                	ret
    return -1;
 358:	597d                	li	s2,-1
 35a:	bfcd                	j	34c <stat+0x2a>

000000000000035c <atoi>:

int
atoi(const char *s)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 362:	00054683          	lbu	a3,0(a0)
 366:	fd06879b          	addiw	a5,a3,-48
 36a:	0ff7f793          	zext.b	a5,a5
 36e:	4625                	li	a2,9
 370:	02f66863          	bltu	a2,a5,3a0 <atoi+0x44>
 374:	872a                	mv	a4,a0
  n = 0;
 376:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 378:	0705                	addi	a4,a4,1
 37a:	0025179b          	slliw	a5,a0,0x2
 37e:	9fa9                	addw	a5,a5,a0
 380:	0017979b          	slliw	a5,a5,0x1
 384:	9fb5                	addw	a5,a5,a3
 386:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 38a:	00074683          	lbu	a3,0(a4)
 38e:	fd06879b          	addiw	a5,a3,-48
 392:	0ff7f793          	zext.b	a5,a5
 396:	fef671e3          	bgeu	a2,a5,378 <atoi+0x1c>
  return n;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  n = 0;
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <atoi+0x3e>

00000000000003a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3aa:	02b57463          	bgeu	a0,a1,3d2 <memmove+0x2e>
    while(n-- > 0)
 3ae:	00c05f63          	blez	a2,3cc <memmove+0x28>
 3b2:	1602                	slli	a2,a2,0x20
 3b4:	9201                	srli	a2,a2,0x20
 3b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 3bc:	0585                	addi	a1,a1,1
 3be:	0705                	addi	a4,a4,1
 3c0:	fff5c683          	lbu	a3,-1(a1)
 3c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3c8:	fef71ae3          	bne	a4,a5,3bc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret
    dst += n;
 3d2:	00c50733          	add	a4,a0,a2
    src += n;
 3d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3d8:	fec05ae3          	blez	a2,3cc <memmove+0x28>
 3dc:	fff6079b          	addiw	a5,a2,-1
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	fff7c793          	not	a5,a5
 3e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ea:	15fd                	addi	a1,a1,-1
 3ec:	177d                	addi	a4,a4,-1
 3ee:	0005c683          	lbu	a3,0(a1)
 3f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3f6:	fee79ae3          	bne	a5,a4,3ea <memmove+0x46>
 3fa:	bfc9                	j	3cc <memmove+0x28>

00000000000003fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e422                	sd	s0,8(sp)
 400:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 402:	ca05                	beqz	a2,432 <memcmp+0x36>
 404:	fff6069b          	addiw	a3,a2,-1
 408:	1682                	slli	a3,a3,0x20
 40a:	9281                	srli	a3,a3,0x20
 40c:	0685                	addi	a3,a3,1
 40e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 410:	00054783          	lbu	a5,0(a0)
 414:	0005c703          	lbu	a4,0(a1)
 418:	00e79863          	bne	a5,a4,428 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 41c:	0505                	addi	a0,a0,1
    p2++;
 41e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 420:	fed518e3          	bne	a0,a3,410 <memcmp+0x14>
  }
  return 0;
 424:	4501                	li	a0,0
 426:	a019                	j	42c <memcmp+0x30>
      return *p1 - *p2;
 428:	40e7853b          	subw	a0,a5,a4
}
 42c:	6422                	ld	s0,8(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
  return 0;
 432:	4501                	li	a0,0
 434:	bfe5                	j	42c <memcmp+0x30>

0000000000000436 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 436:	1141                	addi	sp,sp,-16
 438:	e406                	sd	ra,8(sp)
 43a:	e022                	sd	s0,0(sp)
 43c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 43e:	f67ff0ef          	jal	3a4 <memmove>
}
 442:	60a2                	ld	ra,8(sp)
 444:	6402                	ld	s0,0(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret

000000000000044a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 44a:	4885                	li	a7,1
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <exit>:
.global exit
exit:
 li a7, SYS_exit
 452:	4889                	li	a7,2
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <wait>:
.global wait
wait:
 li a7, SYS_wait
 45a:	488d                	li	a7,3
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 462:	4891                	li	a7,4
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <read>:
.global read
read:
 li a7, SYS_read
 46a:	4895                	li	a7,5
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <write>:
.global write
write:
 li a7, SYS_write
 472:	48c1                	li	a7,16
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <close>:
.global close
close:
 li a7, SYS_close
 47a:	48d5                	li	a7,21
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <kill>:
.global kill
kill:
 li a7, SYS_kill
 482:	4899                	li	a7,6
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <exec>:
.global exec
exec:
 li a7, SYS_exec
 48a:	489d                	li	a7,7
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <open>:
.global open
open:
 li a7, SYS_open
 492:	48bd                	li	a7,15
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 49a:	48c5                	li	a7,17
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a2:	48c9                	li	a7,18
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4aa:	48a1                	li	a7,8
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <link>:
.global link
link:
 li a7, SYS_link
 4b2:	48cd                	li	a7,19
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ba:	48d1                	li	a7,20
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c2:	48a5                	li	a7,9
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ca:	48a9                	li	a7,10
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d2:	48ad                	li	a7,11
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4da:	48b1                	li	a7,12
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4e2:	48b5                	li	a7,13
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ea:	48b9                	li	a7,14
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 4f2:	48d9                	li	a7,22
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 4fa:	48dd                	li	a7,23
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 502:	48e1                	li	a7,24
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 50a:	48e5                	li	a7,25
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 512:	48e9                	li	a7,26
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sysrand>:
.global sysrand
sysrand:
 li a7, SYS_sysrand
 51a:	48ed                	li	a7,27
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <schedstats>:
.global schedstats
schedstats:
 li a7, SYS_schedstats
 522:	48f1                	li	a7,28
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <wait_stat>:
.global wait_stat
wait_stat:
 li a7, SYS_wait_stat
 52a:	48f5                	li	a7,29
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 532:	48f9                	li	a7,30
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 53a:	1101                	addi	sp,sp,-32
 53c:	ec06                	sd	ra,24(sp)
 53e:	e822                	sd	s0,16(sp)
 540:	1000                	addi	s0,sp,32
 542:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 546:	4605                	li	a2,1
 548:	fef40593          	addi	a1,s0,-17
 54c:	f27ff0ef          	jal	472 <write>
}
 550:	60e2                	ld	ra,24(sp)
 552:	6442                	ld	s0,16(sp)
 554:	6105                	addi	sp,sp,32
 556:	8082                	ret

0000000000000558 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	7139                	addi	sp,sp,-64
 55a:	fc06                	sd	ra,56(sp)
 55c:	f822                	sd	s0,48(sp)
 55e:	f426                	sd	s1,40(sp)
 560:	0080                	addi	s0,sp,64
 562:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 564:	c299                	beqz	a3,56a <printint+0x12>
 566:	0805c963          	bltz	a1,5f8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56a:	2581                	sext.w	a1,a1
  neg = 0;
 56c:	4881                	li	a7,0
 56e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 572:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 574:	2601                	sext.w	a2,a2
 576:	00000517          	auipc	a0,0x0
 57a:	50a50513          	addi	a0,a0,1290 # a80 <digits>
 57e:	883a                	mv	a6,a4
 580:	2705                	addiw	a4,a4,1
 582:	02c5f7bb          	remuw	a5,a1,a2
 586:	1782                	slli	a5,a5,0x20
 588:	9381                	srli	a5,a5,0x20
 58a:	97aa                	add	a5,a5,a0
 58c:	0007c783          	lbu	a5,0(a5)
 590:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 594:	0005879b          	sext.w	a5,a1
 598:	02c5d5bb          	divuw	a1,a1,a2
 59c:	0685                	addi	a3,a3,1
 59e:	fec7f0e3          	bgeu	a5,a2,57e <printint+0x26>
  if(neg)
 5a2:	00088c63          	beqz	a7,5ba <printint+0x62>
    buf[i++] = '-';
 5a6:	fd070793          	addi	a5,a4,-48
 5aa:	00878733          	add	a4,a5,s0
 5ae:	02d00793          	li	a5,45
 5b2:	fef70823          	sb	a5,-16(a4)
 5b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ba:	02e05a63          	blez	a4,5ee <printint+0x96>
 5be:	f04a                	sd	s2,32(sp)
 5c0:	ec4e                	sd	s3,24(sp)
 5c2:	fc040793          	addi	a5,s0,-64
 5c6:	00e78933          	add	s2,a5,a4
 5ca:	fff78993          	addi	s3,a5,-1
 5ce:	99ba                	add	s3,s3,a4
 5d0:	377d                	addiw	a4,a4,-1
 5d2:	1702                	slli	a4,a4,0x20
 5d4:	9301                	srli	a4,a4,0x20
 5d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5da:	fff94583          	lbu	a1,-1(s2)
 5de:	8526                	mv	a0,s1
 5e0:	f5bff0ef          	jal	53a <putc>
  while(--i >= 0)
 5e4:	197d                	addi	s2,s2,-1
 5e6:	ff391ae3          	bne	s2,s3,5da <printint+0x82>
 5ea:	7902                	ld	s2,32(sp)
 5ec:	69e2                	ld	s3,24(sp)
}
 5ee:	70e2                	ld	ra,56(sp)
 5f0:	7442                	ld	s0,48(sp)
 5f2:	74a2                	ld	s1,40(sp)
 5f4:	6121                	addi	sp,sp,64
 5f6:	8082                	ret
    x = -xx;
 5f8:	40b005bb          	negw	a1,a1
    neg = 1;
 5fc:	4885                	li	a7,1
    x = -xx;
 5fe:	bf85                	j	56e <printint+0x16>

0000000000000600 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 600:	711d                	addi	sp,sp,-96
 602:	ec86                	sd	ra,88(sp)
 604:	e8a2                	sd	s0,80(sp)
 606:	e0ca                	sd	s2,64(sp)
 608:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60a:	0005c903          	lbu	s2,0(a1)
 60e:	26090863          	beqz	s2,87e <vprintf+0x27e>
 612:	e4a6                	sd	s1,72(sp)
 614:	fc4e                	sd	s3,56(sp)
 616:	f852                	sd	s4,48(sp)
 618:	f456                	sd	s5,40(sp)
 61a:	f05a                	sd	s6,32(sp)
 61c:	ec5e                	sd	s7,24(sp)
 61e:	e862                	sd	s8,16(sp)
 620:	e466                	sd	s9,8(sp)
 622:	8b2a                	mv	s6,a0
 624:	8a2e                	mv	s4,a1
 626:	8bb2                	mv	s7,a2
  state = 0;
 628:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 62a:	4481                	li	s1,0
 62c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 632:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 636:	06c00c93          	li	s9,108
 63a:	a005                	j	65a <vprintf+0x5a>
        putc(fd, c0);
 63c:	85ca                	mv	a1,s2
 63e:	855a                	mv	a0,s6
 640:	efbff0ef          	jal	53a <putc>
 644:	a019                	j	64a <vprintf+0x4a>
    } else if(state == '%'){
 646:	03598263          	beq	s3,s5,66a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 64a:	2485                	addiw	s1,s1,1
 64c:	8726                	mv	a4,s1
 64e:	009a07b3          	add	a5,s4,s1
 652:	0007c903          	lbu	s2,0(a5)
 656:	20090c63          	beqz	s2,86e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 65a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 65e:	fe0994e3          	bnez	s3,646 <vprintf+0x46>
      if(c0 == '%'){
 662:	fd579de3          	bne	a5,s5,63c <vprintf+0x3c>
        state = '%';
 666:	89be                	mv	s3,a5
 668:	b7cd                	j	64a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 66a:	00ea06b3          	add	a3,s4,a4
 66e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 672:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 674:	c681                	beqz	a3,67c <vprintf+0x7c>
 676:	9752                	add	a4,a4,s4
 678:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 67c:	03878f63          	beq	a5,s8,6ba <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 680:	05978963          	beq	a5,s9,6d2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 684:	07500713          	li	a4,117
 688:	0ee78363          	beq	a5,a4,76e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 68c:	07800713          	li	a4,120
 690:	12e78563          	beq	a5,a4,7ba <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 694:	07000713          	li	a4,112
 698:	14e78a63          	beq	a5,a4,7ec <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 69c:	07300713          	li	a4,115
 6a0:	18e78a63          	beq	a5,a4,834 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a4:	02500713          	li	a4,37
 6a8:	04e79563          	bne	a5,a4,6f2 <vprintf+0xf2>
        putc(fd, '%');
 6ac:	02500593          	li	a1,37
 6b0:	855a                	mv	a0,s6
 6b2:	e89ff0ef          	jal	53a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bf49                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4685                	li	a3,1
 6c0:	4629                	li	a2,10
 6c2:	000ba583          	lw	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	e91ff0ef          	jal	558 <printint>
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bfad                	j	64a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6d2:	06400793          	li	a5,100
 6d6:	02f68963          	beq	a3,a5,708 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6da:	06c00793          	li	a5,108
 6de:	04f68263          	beq	a3,a5,722 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6e2:	07500793          	li	a5,117
 6e6:	0af68063          	beq	a3,a5,786 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ea:	07800793          	li	a5,120
 6ee:	0ef68263          	beq	a3,a5,7d2 <vprintf+0x1d2>
        putc(fd, '%');
 6f2:	02500593          	li	a1,37
 6f6:	855a                	mv	a0,s6
 6f8:	e43ff0ef          	jal	53a <putc>
        putc(fd, c0);
 6fc:	85ca                	mv	a1,s2
 6fe:	855a                	mv	a0,s6
 700:	e3bff0ef          	jal	53a <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b791                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 708:	008b8913          	addi	s2,s7,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000ba583          	lw	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	e43ff0ef          	jal	558 <printint>
        i += 1;
 71a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
        i += 1;
 720:	b72d                	j	64a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 722:	06400793          	li	a5,100
 726:	02f60763          	beq	a2,a5,754 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 72a:	07500793          	li	a5,117
 72e:	06f60963          	beq	a2,a5,7a0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 732:	07800793          	li	a5,120
 736:	faf61ee3          	bne	a2,a5,6f2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	e11ff0ef          	jal	558 <printint>
        i += 2;
 74c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 2;
 752:	bde5                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 754:	008b8913          	addi	s2,s7,8
 758:	4685                	li	a3,1
 75a:	4629                	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	df7ff0ef          	jal	558 <printint>
        i += 2;
 766:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	8bca                	mv	s7,s2
      state = 0;
 76a:	4981                	li	s3,0
        i += 2;
 76c:	bdf9                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 76e:	008b8913          	addi	s2,s7,8
 772:	4681                	li	a3,0
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	dddff0ef          	jal	558 <printint>
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	b5d9                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 786:	008b8913          	addi	s2,s7,8
 78a:	4681                	li	a3,0
 78c:	4629                	li	a2,10
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	dc5ff0ef          	jal	558 <printint>
        i += 1;
 798:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
        i += 1;
 79e:	b575                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a0:	008b8913          	addi	s2,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4629                	li	a2,10
 7a8:	000ba583          	lw	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	dabff0ef          	jal	558 <printint>
        i += 2;
 7b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	8bca                	mv	s7,s2
      state = 0;
 7b6:	4981                	li	s3,0
        i += 2;
 7b8:	bd49                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ba:	008b8913          	addi	s2,s7,8
 7be:	4681                	li	a3,0
 7c0:	4641                	li	a2,16
 7c2:	000ba583          	lw	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	d91ff0ef          	jal	558 <printint>
 7cc:	8bca                	mv	s7,s2
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bdad                	j	64a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	4681                	li	a3,0
 7d8:	4641                	li	a2,16
 7da:	000ba583          	lw	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	d79ff0ef          	jal	558 <printint>
        i += 1;
 7e4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	8bca                	mv	s7,s2
      state = 0;
 7e8:	4981                	li	s3,0
        i += 1;
 7ea:	b585                	j	64a <vprintf+0x4a>
 7ec:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ee:	008b8d13          	addi	s10,s7,8
 7f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f6:	03000593          	li	a1,48
 7fa:	855a                	mv	a0,s6
 7fc:	d3fff0ef          	jal	53a <putc>
  putc(fd, 'x');
 800:	07800593          	li	a1,120
 804:	855a                	mv	a0,s6
 806:	d35ff0ef          	jal	53a <putc>
 80a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80c:	00000b97          	auipc	s7,0x0
 810:	274b8b93          	addi	s7,s7,628 # a80 <digits>
 814:	03c9d793          	srli	a5,s3,0x3c
 818:	97de                	add	a5,a5,s7
 81a:	0007c583          	lbu	a1,0(a5)
 81e:	855a                	mv	a0,s6
 820:	d1bff0ef          	jal	53a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 824:	0992                	slli	s3,s3,0x4
 826:	397d                	addiw	s2,s2,-1
 828:	fe0916e3          	bnez	s2,814 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 82c:	8bea                	mv	s7,s10
      state = 0;
 82e:	4981                	li	s3,0
 830:	6d02                	ld	s10,0(sp)
 832:	bd21                	j	64a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 834:	008b8993          	addi	s3,s7,8
 838:	000bb903          	ld	s2,0(s7)
 83c:	00090f63          	beqz	s2,85a <vprintf+0x25a>
        for(; *s; s++)
 840:	00094583          	lbu	a1,0(s2)
 844:	c195                	beqz	a1,868 <vprintf+0x268>
          putc(fd, *s);
 846:	855a                	mv	a0,s6
 848:	cf3ff0ef          	jal	53a <putc>
        for(; *s; s++)
 84c:	0905                	addi	s2,s2,1
 84e:	00094583          	lbu	a1,0(s2)
 852:	f9f5                	bnez	a1,846 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	bbcd                	j	64a <vprintf+0x4a>
          s = "(null)";
 85a:	00000917          	auipc	s2,0x0
 85e:	21e90913          	addi	s2,s2,542 # a78 <malloc+0x112>
        for(; *s; s++)
 862:	02800593          	li	a1,40
 866:	b7c5                	j	846 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 868:	8bce                	mv	s7,s3
      state = 0;
 86a:	4981                	li	s3,0
 86c:	bbf9                	j	64a <vprintf+0x4a>
 86e:	64a6                	ld	s1,72(sp)
 870:	79e2                	ld	s3,56(sp)
 872:	7a42                	ld	s4,48(sp)
 874:	7aa2                	ld	s5,40(sp)
 876:	7b02                	ld	s6,32(sp)
 878:	6be2                	ld	s7,24(sp)
 87a:	6c42                	ld	s8,16(sp)
 87c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 87e:	60e6                	ld	ra,88(sp)
 880:	6446                	ld	s0,80(sp)
 882:	6906                	ld	s2,64(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 888:	715d                	addi	sp,sp,-80
 88a:	ec06                	sd	ra,24(sp)
 88c:	e822                	sd	s0,16(sp)
 88e:	1000                	addi	s0,sp,32
 890:	e010                	sd	a2,0(s0)
 892:	e414                	sd	a3,8(s0)
 894:	e818                	sd	a4,16(s0)
 896:	ec1c                	sd	a5,24(s0)
 898:	03043023          	sd	a6,32(s0)
 89c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a4:	8622                	mv	a2,s0
 8a6:	d5bff0ef          	jal	600 <vprintf>
}
 8aa:	60e2                	ld	ra,24(sp)
 8ac:	6442                	ld	s0,16(sp)
 8ae:	6161                	addi	sp,sp,80
 8b0:	8082                	ret

00000000000008b2 <printf>:

void
printf(const char *fmt, ...)
{
 8b2:	711d                	addi	sp,sp,-96
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e40c                	sd	a1,8(s0)
 8bc:	e810                	sd	a2,16(s0)
 8be:	ec14                	sd	a3,24(s0)
 8c0:	f018                	sd	a4,32(s0)
 8c2:	f41c                	sd	a5,40(s0)
 8c4:	03043823          	sd	a6,48(s0)
 8c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	00840613          	addi	a2,s0,8
 8d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d4:	85aa                	mv	a1,a0
 8d6:	4505                	li	a0,1
 8d8:	d29ff0ef          	jal	600 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e4:	1141                	addi	sp,sp,-16
 8e6:	e422                	sd	s0,8(sp)
 8e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	00000797          	auipc	a5,0x0
 8f2:	7127b783          	ld	a5,1810(a5) # 1000 <freep>
 8f6:	a02d                	j	920 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9f2d                	addw	a4,a4,a1
 8fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6310                	ld	a2,0(a4)
 904:	a83d                	j	942 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 906:	ff852703          	lw	a4,-8(a0)
 90a:	9f31                	addw	a4,a4,a2
 90c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90e:	ff053683          	ld	a3,-16(a0)
 912:	a091                	j	956 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	6398                	ld	a4,0(a5)
 916:	00e7e463          	bltu	a5,a4,91e <free+0x3a>
 91a:	00e6ea63          	bltu	a3,a4,92e <free+0x4a>
{
 91e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	fed7fae3          	bgeu	a5,a3,914 <free+0x30>
 924:	6398                	ld	a4,0(a5)
 926:	00e6e463          	bltu	a3,a4,92e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	fee7eae3          	bltu	a5,a4,91e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 92e:	ff852583          	lw	a1,-8(a0)
 932:	6390                	ld	a2,0(a5)
 934:	02059813          	slli	a6,a1,0x20
 938:	01c85713          	srli	a4,a6,0x1c
 93c:	9736                	add	a4,a4,a3
 93e:	fae60de3          	beq	a2,a4,8f8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 946:	4790                	lw	a2,8(a5)
 948:	02061593          	slli	a1,a2,0x20
 94c:	01c5d713          	srli	a4,a1,0x1c
 950:	973e                	add	a4,a4,a5
 952:	fae68ae3          	beq	a3,a4,906 <free+0x22>
    p->s.ptr = bp->s.ptr;
 956:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
}
 960:	6422                	ld	s0,8(sp)
 962:	0141                	addi	sp,sp,16
 964:	8082                	ret

0000000000000966 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 966:	7139                	addi	sp,sp,-64
 968:	fc06                	sd	ra,56(sp)
 96a:	f822                	sd	s0,48(sp)
 96c:	f426                	sd	s1,40(sp)
 96e:	ec4e                	sd	s3,24(sp)
 970:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 972:	02051493          	slli	s1,a0,0x20
 976:	9081                	srli	s1,s1,0x20
 978:	04bd                	addi	s1,s1,15
 97a:	8091                	srli	s1,s1,0x4
 97c:	0014899b          	addiw	s3,s1,1
 980:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 982:	00000517          	auipc	a0,0x0
 986:	67e53503          	ld	a0,1662(a0) # 1000 <freep>
 98a:	c915                	beqz	a0,9be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98e:	4798                	lw	a4,8(a5)
 990:	08977a63          	bgeu	a4,s1,a24 <malloc+0xbe>
 994:	f04a                	sd	s2,32(sp)
 996:	e852                	sd	s4,16(sp)
 998:	e456                	sd	s5,8(sp)
 99a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 99c:	8a4e                	mv	s4,s3
 99e:	0009871b          	sext.w	a4,s3
 9a2:	6685                	lui	a3,0x1
 9a4:	00d77363          	bgeu	a4,a3,9aa <malloc+0x44>
 9a8:	6a05                	lui	s4,0x1
 9aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b2:	00000917          	auipc	s2,0x0
 9b6:	64e90913          	addi	s2,s2,1614 # 1000 <freep>
  if(p == (char*)-1)
 9ba:	5afd                	li	s5,-1
 9bc:	a081                	j	9fc <malloc+0x96>
 9be:	f04a                	sd	s2,32(sp)
 9c0:	e852                	sd	s4,16(sp)
 9c2:	e456                	sd	s5,8(sp)
 9c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c6:	00000797          	auipc	a5,0x0
 9ca:	64a78793          	addi	a5,a5,1610 # 1010 <base>
 9ce:	00000717          	auipc	a4,0x0
 9d2:	62f73923          	sd	a5,1586(a4) # 1000 <freep>
 9d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9dc:	b7c1                	j	99c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9de:	6398                	ld	a4,0(a5)
 9e0:	e118                	sd	a4,0(a0)
 9e2:	a8a9                	j	a3c <malloc+0xd6>
  hp->s.size = nu;
 9e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e8:	0541                	addi	a0,a0,16
 9ea:	efbff0ef          	jal	8e4 <free>
  return freep;
 9ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f2:	c12d                	beqz	a0,a54 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f6:	4798                	lw	a4,8(a5)
 9f8:	02977263          	bgeu	a4,s1,a1c <malloc+0xb6>
    if(p == freep)
 9fc:	00093703          	ld	a4,0(s2)
 a00:	853e                	mv	a0,a5
 a02:	fef719e3          	bne	a4,a5,9f4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a06:	8552                	mv	a0,s4
 a08:	ad3ff0ef          	jal	4da <sbrk>
  if(p == (char*)-1)
 a0c:	fd551ce3          	bne	a0,s5,9e4 <malloc+0x7e>
        return 0;
 a10:	4501                	li	a0,0
 a12:	7902                	ld	s2,32(sp)
 a14:	6a42                	ld	s4,16(sp)
 a16:	6aa2                	ld	s5,8(sp)
 a18:	6b02                	ld	s6,0(sp)
 a1a:	a03d                	j	a48 <malloc+0xe2>
 a1c:	7902                	ld	s2,32(sp)
 a1e:	6a42                	ld	s4,16(sp)
 a20:	6aa2                	ld	s5,8(sp)
 a22:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a24:	fae48de3          	beq	s1,a4,9de <malloc+0x78>
        p->s.size -= nunits;
 a28:	4137073b          	subw	a4,a4,s3
 a2c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a2e:	02071693          	slli	a3,a4,0x20
 a32:	01c6d713          	srli	a4,a3,0x1c
 a36:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a38:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3c:	00000717          	auipc	a4,0x0
 a40:	5ca73223          	sd	a0,1476(a4) # 1000 <freep>
      return (void*)(p + 1);
 a44:	01078513          	addi	a0,a5,16
  }
}
 a48:	70e2                	ld	ra,56(sp)
 a4a:	7442                	ld	s0,48(sp)
 a4c:	74a2                	ld	s1,40(sp)
 a4e:	69e2                	ld	s3,24(sp)
 a50:	6121                	addi	sp,sp,64
 a52:	8082                	ret
 a54:	7902                	ld	s2,32(sp)
 a56:	6a42                	ld	s4,16(sp)
 a58:	6aa2                	ld	s5,8(sp)
 a5a:	6b02                	ld	s6,0(sp)
 a5c:	b7f5                	j	a48 <malloc+0xe2>
