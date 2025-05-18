
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	62013103          	ld	sp,1568(sp) # 8000b620 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd2407>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	df078793          	addi	a5,a5,-528 # 80000e70 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	5ae020ef          	jal	800026a8 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	043000ef          	jal	80000948 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00013517          	auipc	a0,0x13
    80000158:	55c50513          	addi	a0,a0,1372 # 800136b0 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00013497          	auipc	s1,0x13
    80000164:	55048493          	addi	s1,s1,1360 # 800136b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00013917          	auipc	s2,0x13
    8000016c:	5e090913          	addi	s2,s2,1504 # 80013748 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	780010ef          	jal	80001900 <myproc>
    80000184:	3b6020ef          	jal	8000253a <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	791010ef          	jal	8000211e <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00013717          	auipc	a4,0x13
    800001a4:	51070713          	addi	a4,a4,1296 # 800136b0 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	48c020ef          	jal	8000265e <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00013517          	auipc	a0,0x13
    800001ee:	4c650513          	addi	a0,a0,1222 # 800136b0 <cons>
    800001f2:	2a9000ef          	jal	80000c9a <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00013717          	auipc	a4,0x13
    80000218:	52f72a23          	sw	a5,1332(a4) # 80013748 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00013517          	auipc	a0,0x13
    8000022e:	48650513          	addi	a0,a0,1158 # 800136b0 <cons>
    80000232:	269000ef          	jal	80000c9a <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	612000ef          	jal	80000862 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	604000ef          	jal	80000862 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5fc000ef          	jal	80000862 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5f6000ef          	jal	80000862 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
//


void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  ++kbd_intr_count;
    8000027e:	0000b717          	auipc	a4,0xb
    80000282:	3c270713          	addi	a4,a4,962 # 8000b640 <kbd_intr_count>
    80000286:	431c                	lw	a5,0(a4)
    80000288:	2785                	addiw	a5,a5,1
    8000028a:	c31c                	sw	a5,0(a4)
  acquire(&cons.lock);
    8000028c:	00013517          	auipc	a0,0x13
    80000290:	42450513          	addi	a0,a0,1060 # 800136b0 <cons>
    80000294:	16f000ef          	jal	80000c02 <acquire>
  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48f63          	beq	s1,a5,80000338 <consoleintr+0xc6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x56>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48463          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49563          	bne	s1,a5,800003b4 <consoleintr+0x142>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	444020ef          	jal	800026f2 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00013517          	auipc	a0,0x13
    800002b6:	3fe50513          	addi	a0,a0,1022 # 800136b0 <cons>
    800002ba:	1e1000ef          	jal	80000c9a <release>
}
    800002be:	60e2                	ld	ra,24(sp)
    800002c0:	6442                	ld	s0,16(sp)
    800002c2:	64a2                	ld	s1,8(sp)
    800002c4:	6105                	addi	sp,sp,32
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48063          	beq	s1,a5,8000038c <consoleintr+0x11a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00013717          	auipc	a4,0x13
    800002d4:	3e070713          	addi	a4,a4,992 # 800136b0 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x40>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48763          	beq	s1,a5,800003ba <consoleintr+0x148>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f4fff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00013797          	auipc	a5,0x13
    800002fa:	3ba78793          	addi	a5,a5,954 # 800136b0 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	0007061b          	sext.w	a2,a4
    8000030a:	0ae7a023          	sw	a4,160(a5)
    8000030e:	07f6f693          	andi	a3,a3,127
    80000312:	97b6                	add	a5,a5,a3
    80000314:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000318:	47a9                	li	a5,10
    8000031a:	0cf48563          	beq	s1,a5,800003e4 <consoleintr+0x172>
    8000031e:	4791                	li	a5,4
    80000320:	0cf48263          	beq	s1,a5,800003e4 <consoleintr+0x172>
    80000324:	00013797          	auipc	a5,0x13
    80000328:	4247a783          	lw	a5,1060(a5) # 80013748 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00013717          	auipc	a4,0x13
    8000033e:	37670713          	addi	a4,a4,886 # 800136b0 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00013497          	auipc	s1,0x13
    8000034e:	36648493          	addi	s1,s1,870 # 800136b0 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
    80000354:	02f70863          	beq	a4,a5,80000384 <consoleintr+0x112>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000358:	37fd                	addiw	a5,a5,-1
    8000035a:	07f7f713          	andi	a4,a5,127
    8000035e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000360:	01874703          	lbu	a4,24(a4)
    80000364:	03270263          	beq	a4,s2,80000388 <consoleintr+0x116>
      cons.e--;
    80000368:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000036c:	10000513          	li	a0,256
    80000370:	ed1ff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000374:	0a04a783          	lw	a5,160(s1)
    80000378:	09c4a703          	lw	a4,156(s1)
    8000037c:	fcf71ee3          	bne	a4,a5,80000358 <consoleintr+0xe6>
    80000380:	6902                	ld	s2,0(sp)
    80000382:	bf05                	j	800002b2 <consoleintr+0x40>
    80000384:	6902                	ld	s2,0(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x40>
    80000388:	6902                	ld	s2,0(sp)
    8000038a:	b725                	j	800002b2 <consoleintr+0x40>
    if(cons.e != cons.w){
    8000038c:	00013717          	auipc	a4,0x13
    80000390:	32470713          	addi	a4,a4,804 # 800136b0 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00013717          	auipc	a4,0x13
    800003a6:	3af72723          	sw	a5,942(a4) # 80013750 <cons+0xa0>
      consputc(BACKSPACE);
    800003aa:	10000513          	li	a0,256
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
    800003b2:	b701                	j	800002b2 <consoleintr+0x40>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003b4:	ee048fe3          	beqz	s1,800002b2 <consoleintr+0x40>
    800003b8:	bf21                	j	800002d0 <consoleintr+0x5e>
      consputc(c);
    800003ba:	4529                	li	a0,10
    800003bc:	e85ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c0:	00013797          	auipc	a5,0x13
    800003c4:	2f078793          	addi	a5,a5,752 # 800136b0 <cons>
    800003c8:	0a07a703          	lw	a4,160(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0006861b          	sext.w	a2,a3
    800003d4:	0ad7a023          	sw	a3,160(a5)
    800003d8:	07f77713          	andi	a4,a4,127
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	4729                	li	a4,10
    800003e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003e4:	00013797          	auipc	a5,0x13
    800003e8:	36c7a423          	sw	a2,872(a5) # 8001374c <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00013517          	auipc	a0,0x13
    800003f0:	35c50513          	addi	a0,a0,860 # 80013748 <cons+0x98>
    800003f4:	677010ef          	jal	8000226a <wakeup>
    800003f8:	bd6d                	j	800002b2 <consoleintr+0x40>

00000000800003fa <consoleinit>:

void
consoleinit(void)
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000402:	00008597          	auipc	a1,0x8
    80000406:	bfe58593          	addi	a1,a1,-1026 # 80008000 <etext>
    8000040a:	00013517          	auipc	a0,0x13
    8000040e:	2a650513          	addi	a0,a0,678 # 800136b0 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	0002b797          	auipc	a5,0x2b
    8000041e:	e4678793          	addi	a5,a5,-442 # 8002b260 <devsw>
    80000422:	00000717          	auipc	a4,0x0
    80000426:	d1470713          	addi	a4,a4,-748 # 80000136 <consoleread>
    8000042a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000042c:	00000717          	auipc	a4,0x0
    80000430:	ca470713          	addi	a4,a4,-860 # 800000d0 <consolewrite>
    80000434:	ef98                	sd	a4,24(a5)
}
    80000436:	60a2                	ld	ra,8(sp)
    80000438:	6402                	ld	s0,0(sp)
    8000043a:	0141                	addi	sp,sp,16
    8000043c:	8082                	ret

000000008000043e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000043e:	7179                	addi	sp,sp,-48
    80000440:	f406                	sd	ra,40(sp)
    80000442:	f022                	sd	s0,32(sp)
    80000444:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000446:	c219                	beqz	a2,8000044c <printint+0xe>
    80000448:	08054063          	bltz	a0,800004c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000044c:	4881                	li	a7,0
    8000044e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000452:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000454:	00008617          	auipc	a2,0x8
    80000458:	46460613          	addi	a2,a2,1124 # 800088b8 <digits>
    8000045c:	883e                	mv	a6,a5
    8000045e:	2785                	addiw	a5,a5,1
    80000460:	02b57733          	remu	a4,a0,a1
    80000464:	9732                	add	a4,a4,a2
    80000466:	00074703          	lbu	a4,0(a4)
    8000046a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000046e:	872a                	mv	a4,a0
    80000470:	02b55533          	divu	a0,a0,a1
    80000474:	0685                	addi	a3,a3,1
    80000476:	feb773e3          	bgeu	a4,a1,8000045c <printint+0x1e>

  if(sign)
    8000047a:	00088a63          	beqz	a7,8000048e <printint+0x50>
    buf[i++] = '-';
    8000047e:	1781                	addi	a5,a5,-32
    80000480:	97a2                	add	a5,a5,s0
    80000482:	02d00713          	li	a4,45
    80000486:	fee78823          	sb	a4,-16(a5)
    8000048a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000048e:	02f05963          	blez	a5,800004c0 <printint+0x82>
    80000492:	ec26                	sd	s1,24(sp)
    80000494:	e84a                	sd	s2,16(sp)
    80000496:	fd040713          	addi	a4,s0,-48
    8000049a:	00f704b3          	add	s1,a4,a5
    8000049e:	fff70913          	addi	s2,a4,-1
    800004a2:	993e                	add	s2,s2,a5
    800004a4:	37fd                	addiw	a5,a5,-1
    800004a6:	1782                	slli	a5,a5,0x20
    800004a8:	9381                	srli	a5,a5,0x20
    800004aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004ae:	fff4c503          	lbu	a0,-1(s1)
    800004b2:	d8fff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004b6:	14fd                	addi	s1,s1,-1
    800004b8:	ff249be3          	bne	s1,s2,800004ae <printint+0x70>
    800004bc:	64e2                	ld	s1,24(sp)
    800004be:	6942                	ld	s2,16(sp)
}
    800004c0:	70a2                	ld	ra,40(sp)
    800004c2:	7402                	ld	s0,32(sp)
    800004c4:	6145                	addi	sp,sp,48
    800004c6:	8082                	ret
    x = -xx;
    800004c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004cc:	4885                	li	a7,1
    x = -xx;
    800004ce:	b741                	j	8000044e <printint+0x10>

00000000800004d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004d0:	7155                	addi	sp,sp,-208
    800004d2:	e506                	sd	ra,136(sp)
    800004d4:	e122                	sd	s0,128(sp)
    800004d6:	f0d2                	sd	s4,96(sp)
    800004d8:	0900                	addi	s0,sp,144
    800004da:	8a2a                	mv	s4,a0
    800004dc:	e40c                	sd	a1,8(s0)
    800004de:	e810                	sd	a2,16(s0)
    800004e0:	ec14                	sd	a3,24(s0)
    800004e2:	f018                	sd	a4,32(s0)
    800004e4:	f41c                	sd	a5,40(s0)
    800004e6:	03043823          	sd	a6,48(s0)
    800004ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ee:	00013797          	auipc	a5,0x13
    800004f2:	2827a783          	lw	a5,642(a5) # 80013770 <pr+0x18>
    800004f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004fa:	e3a1                	bnez	a5,8000053a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fc:	00840793          	addi	a5,s0,8
    80000500:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000504:	00054503          	lbu	a0,0(a0)
    80000508:	26050763          	beqz	a0,80000776 <printf+0x2a6>
    8000050c:	fca6                	sd	s1,120(sp)
    8000050e:	f8ca                	sd	s2,112(sp)
    80000510:	f4ce                	sd	s3,104(sp)
    80000512:	ecd6                	sd	s5,88(sp)
    80000514:	e8da                	sd	s6,80(sp)
    80000516:	e0e2                	sd	s8,64(sp)
    80000518:	fc66                	sd	s9,56(sp)
    8000051a:	f86a                	sd	s10,48(sp)
    8000051c:	f46e                	sd	s11,40(sp)
    8000051e:	4981                	li	s3,0
    if(cx != '%'){
    80000520:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000524:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000528:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000530:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000534:	07000d93          	li	s11,112
    80000538:	a815                	j	8000056c <printf+0x9c>
    acquire(&pr.lock);
    8000053a:	00013517          	auipc	a0,0x13
    8000053e:	21e50513          	addi	a0,a0,542 # 80013758 <pr>
    80000542:	6c0000ef          	jal	80000c02 <acquire>
  va_start(ap, fmt);
    80000546:	00840793          	addi	a5,s0,8
    8000054a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	000a4503          	lbu	a0,0(s4)
    80000552:	fd4d                	bnez	a0,8000050c <printf+0x3c>
    80000554:	a481                	j	80000794 <printf+0x2c4>
      consputc(cx);
    80000556:	cebff0ef          	jal	80000240 <consputc>
      continue;
    8000055a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055c:	0014899b          	addiw	s3,s1,1
    80000560:	013a07b3          	add	a5,s4,s3
    80000564:	0007c503          	lbu	a0,0(a5)
    80000568:	1e050b63          	beqz	a0,8000075e <printf+0x28e>
    if(cx != '%'){
    8000056c:	ff5515e3          	bne	a0,s5,80000556 <printf+0x86>
    i++;
    80000570:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000574:	009a07b3          	add	a5,s4,s1
    80000578:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057c:	1e090163          	beqz	s2,8000075e <printf+0x28e>
    80000580:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000584:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000586:	c789                	beqz	a5,80000590 <printf+0xc0>
    80000588:	009a0733          	add	a4,s4,s1
    8000058c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000590:	03690763          	beq	s2,s6,800005be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000594:	05890163          	beq	s2,s8,800005d6 <printf+0x106>
    } else if(c0 == 'u'){
    80000598:	0d990b63          	beq	s2,s9,8000066e <printf+0x19e>
    } else if(c0 == 'x'){
    8000059c:	13a90163          	beq	s2,s10,800006be <printf+0x1ee>
    } else if(c0 == 'p'){
    800005a0:	13b90b63          	beq	s2,s11,800006d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a4:	07300793          	li	a5,115
    800005a8:	16f90a63          	beq	s2,a5,8000071c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005ac:	1b590463          	beq	s2,s5,80000754 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005b0:	8556                	mv	a0,s5
    800005b2:	c8fff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005b6:	854a                	mv	a0,s2
    800005b8:	c89ff0ef          	jal	80000240 <consputc>
    800005bc:	b745                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005be:	f8843783          	ld	a5,-120(s0)
    800005c2:	00878713          	addi	a4,a5,8
    800005c6:	f8e43423          	sd	a4,-120(s0)
    800005ca:	4605                	li	a2,1
    800005cc:	45a9                	li	a1,10
    800005ce:	4388                	lw	a0,0(a5)
    800005d0:	e6fff0ef          	jal	8000043e <printint>
    800005d4:	b761                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d6:	03678663          	beq	a5,s6,80000602 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005da:	05878263          	beq	a5,s8,8000061e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005de:	0b978463          	beq	a5,s9,80000686 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005e2:	fda797e3          	bne	a5,s10,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005e6:	f8843783          	ld	a5,-120(s0)
    800005ea:	00878713          	addi	a4,a5,8
    800005ee:	f8e43423          	sd	a4,-120(s0)
    800005f2:	4601                	li	a2,0
    800005f4:	45c1                	li	a1,16
    800005f6:	6388                	ld	a0,0(a5)
    800005f8:	e47ff0ef          	jal	8000043e <printint>
      i += 1;
    800005fc:	0029849b          	addiw	s1,s3,2
    80000600:	bfb1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4605                	li	a2,1
    80000610:	45a9                	li	a1,10
    80000612:	6388                	ld	a0,0(a5)
    80000614:	e2bff0ef          	jal	8000043e <printint>
      i += 1;
    80000618:	0029849b          	addiw	s1,s3,2
    8000061c:	b781                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061e:	06400793          	li	a5,100
    80000622:	02f68863          	beq	a3,a5,80000652 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000626:	07500793          	li	a5,117
    8000062a:	06f68c63          	beq	a3,a5,800006a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062e:	07800793          	li	a5,120
    80000632:	f6f69fe3          	bne	a3,a5,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	45c1                	li	a1,16
    80000646:	6388                	ld	a0,0(a5)
    80000648:	df7ff0ef          	jal	8000043e <printint>
      i += 2;
    8000064c:	0039849b          	addiw	s1,s3,3
    80000650:	b731                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4605                	li	a2,1
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	ddbff0ef          	jal	8000043e <printint>
      i += 2;
    80000668:	0039849b          	addiw	s1,s3,3
    8000066c:	bdc5                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	dbfff0ef          	jal	8000043e <printint>
    80000684:	bde1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45a9                	li	a1,10
    80000696:	6388                	ld	a0,0(a5)
    80000698:	da7ff0ef          	jal	8000043e <printint>
      i += 1;
    8000069c:	0029849b          	addiw	s1,s3,2
    800006a0:	bd75                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45a9                	li	a1,10
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d8bff0ef          	jal	8000043e <printint>
      i += 2;
    800006b8:	0039849b          	addiw	s1,s3,3
    800006bc:	b545                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	4601                	li	a2,0
    800006cc:	45c1                	li	a1,16
    800006ce:	4388                	lw	a0,0(a5)
    800006d0:	d6fff0ef          	jal	8000043e <printint>
    800006d4:	b561                	j	8000055c <printf+0x8c>
    800006d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e8:	03000513          	li	a0,48
    800006ec:	b55ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006f0:	07800513          	li	a0,120
    800006f4:	b4dff0ef          	jal	80000240 <consputc>
    800006f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	00008b97          	auipc	s7,0x8
    800006fe:	1beb8b93          	addi	s7,s7,446 # 800088b8 <digits>
    80000702:	03c9d793          	srli	a5,s3,0x3c
    80000706:	97de                	add	a5,a5,s7
    80000708:	0007c503          	lbu	a0,0(a5)
    8000070c:	b35ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000710:	0992                	slli	s3,s3,0x4
    80000712:	397d                	addiw	s2,s2,-1
    80000714:	fe0917e3          	bnez	s2,80000702 <printf+0x232>
    80000718:	6ba6                	ld	s7,72(sp)
    8000071a:	b589                	j	8000055c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000071c:	f8843783          	ld	a5,-120(s0)
    80000720:	00878713          	addi	a4,a5,8
    80000724:	f8e43423          	sd	a4,-120(s0)
    80000728:	0007b903          	ld	s2,0(a5)
    8000072c:	00090d63          	beqz	s2,80000746 <printf+0x276>
      for(; *s; s++)
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	e20504e3          	beqz	a0,8000055c <printf+0x8c>
        consputc(*s);
    80000738:	b09ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000073c:	0905                	addi	s2,s2,1
    8000073e:	00094503          	lbu	a0,0(s2)
    80000742:	f97d                	bnez	a0,80000738 <printf+0x268>
    80000744:	bd21                	j	8000055c <printf+0x8c>
        s = "(null)";
    80000746:	00008917          	auipc	s2,0x8
    8000074a:	8c290913          	addi	s2,s2,-1854 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000074e:	02800513          	li	a0,40
    80000752:	b7dd                	j	80000738 <printf+0x268>
      consputc('%');
    80000754:	02500513          	li	a0,37
    80000758:	ae9ff0ef          	jal	80000240 <consputc>
    8000075c:	b501                	j	8000055c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075e:	f7843783          	ld	a5,-136(s0)
    80000762:	e385                	bnez	a5,80000782 <printf+0x2b2>
    80000764:	74e6                	ld	s1,120(sp)
    80000766:	7946                	ld	s2,112(sp)
    80000768:	79a6                	ld	s3,104(sp)
    8000076a:	6ae6                	ld	s5,88(sp)
    8000076c:	6b46                	ld	s6,80(sp)
    8000076e:	6c06                	ld	s8,64(sp)
    80000770:	7ce2                	ld	s9,56(sp)
    80000772:	7d42                	ld	s10,48(sp)
    80000774:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000776:	4501                	li	a0,0
    80000778:	60aa                	ld	ra,136(sp)
    8000077a:	640a                	ld	s0,128(sp)
    8000077c:	7a06                	ld	s4,96(sp)
    8000077e:	6169                	addi	sp,sp,208
    80000780:	8082                	ret
    80000782:	74e6                	ld	s1,120(sp)
    80000784:	7946                	ld	s2,112(sp)
    80000786:	79a6                	ld	s3,104(sp)
    80000788:	6ae6                	ld	s5,88(sp)
    8000078a:	6b46                	ld	s6,80(sp)
    8000078c:	6c06                	ld	s8,64(sp)
    8000078e:	7ce2                	ld	s9,56(sp)
    80000790:	7d42                	ld	s10,48(sp)
    80000792:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000794:	00013517          	auipc	a0,0x13
    80000798:	fc450513          	addi	a0,a0,-60 # 80013758 <pr>
    8000079c:	4fe000ef          	jal	80000c9a <release>
    800007a0:	bfd9                	j	80000776 <printf+0x2a6>

00000000800007a2 <panic>:

void
panic(char *s)
{
    800007a2:	1101                	addi	sp,sp,-32
    800007a4:	ec06                	sd	ra,24(sp)
    800007a6:	e822                	sd	s0,16(sp)
    800007a8:	e426                	sd	s1,8(sp)
    800007aa:	1000                	addi	s0,sp,32
    800007ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007ae:	00013797          	auipc	a5,0x13
    800007b2:	fc07a123          	sw	zero,-62(a5) # 80013770 <pr+0x18>
  printf("panic: ");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	86250513          	addi	a0,a0,-1950 # 80008018 <etext+0x18>
    800007be:	d13ff0ef          	jal	800004d0 <printf>
  printf("%s\n", s);
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00008517          	auipc	a0,0x8
    800007c8:	85c50513          	addi	a0,a0,-1956 # 80008020 <etext+0x20>
    800007cc:	d05ff0ef          	jal	800004d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007d0:	4785                	li	a5,1
    800007d2:	0000b717          	auipc	a4,0xb
    800007d6:	e6f72923          	sw	a5,-398(a4) # 8000b644 <panicked>
  for(;;)
    800007da:	a001                	j	800007da <panic+0x38>

00000000800007dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800007dc:	1101                	addi	sp,sp,-32
    800007de:	ec06                	sd	ra,24(sp)
    800007e0:	e822                	sd	s0,16(sp)
    800007e2:	e426                	sd	s1,8(sp)
    800007e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e6:	00013497          	auipc	s1,0x13
    800007ea:	f7248493          	addi	s1,s1,-142 # 80013758 <pr>
    800007ee:	00008597          	auipc	a1,0x8
    800007f2:	83a58593          	addi	a1,a1,-1990 # 80008028 <etext+0x28>
    800007f6:	8526                	mv	a0,s1
    800007f8:	38a000ef          	jal	80000b82 <initlock>
  pr.locking = 1;
    800007fc:	4785                	li	a5,1
    800007fe:	cc9c                	sw	a5,24(s1)
}
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000081a:	10000737          	lui	a4,0x10000
    8000081e:	f8000693          	li	a3,-128
    80000822:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000826:	468d                	li	a3,3
    80000828:	10000637          	lui	a2,0x10000
    8000082c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000830:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000834:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000838:	10000737          	lui	a4,0x10000
    8000083c:	461d                	li	a2,7
    8000083e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000842:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000846:	00007597          	auipc	a1,0x7
    8000084a:	7ea58593          	addi	a1,a1,2026 # 80008030 <etext+0x30>
    8000084e:	00013517          	auipc	a0,0x13
    80000852:	f2a50513          	addi	a0,a0,-214 # 80013778 <uart_tx_lock>
    80000856:	32c000ef          	jal	80000b82 <initlock>
}
    8000085a:	60a2                	ld	ra,8(sp)
    8000085c:	6402                	ld	s0,0(sp)
    8000085e:	0141                	addi	sp,sp,16
    80000860:	8082                	ret

0000000080000862 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
    8000086c:	84aa                	mv	s1,a0
  push_off();
    8000086e:	354000ef          	jal	80000bc2 <push_off>

  if(panicked){
    80000872:	0000b797          	auipc	a5,0xb
    80000876:	dd27a783          	lw	a5,-558(a5) # 8000b644 <panicked>
    8000087a:	e795                	bnez	a5,800008a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000087c:	10000737          	lui	a4,0x10000
    80000880:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000882:	00074783          	lbu	a5,0(a4)
    80000886:	0207f793          	andi	a5,a5,32
    8000088a:	dfe5                	beqz	a5,80000882 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000088c:	0ff4f513          	zext.b	a0,s1
    80000890:	100007b7          	lui	a5,0x10000
    80000894:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000898:	3ae000ef          	jal	80000c46 <pop_off>
}
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    for(;;)
    800008a6:	a001                	j	800008a6 <uartputc_sync+0x44>

00000000800008a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a8:	0000b797          	auipc	a5,0xb
    800008ac:	da07b783          	ld	a5,-608(a5) # 8000b648 <uart_tx_r>
    800008b0:	0000b717          	auipc	a4,0xb
    800008b4:	da073703          	ld	a4,-608(a4) # 8000b650 <uart_tx_w>
    800008b8:	08f70263          	beq	a4,a5,8000093c <uartstart+0x94>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d0:	10000937          	lui	s2,0x10000
    800008d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d6:	00013a97          	auipc	s5,0x13
    800008da:	ea2a8a93          	addi	s5,s5,-350 # 80013778 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000b497          	auipc	s1,0xb
    800008e2:	d6a48493          	addi	s1,s1,-662 # 8000b648 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000b997          	auipc	s3,0xb
    800008ee:	d6698993          	addi	s3,s3,-666 # 8000b650 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f2:	00094703          	lbu	a4,0(s2)
    800008f6:	02077713          	andi	a4,a4,32
    800008fa:	c71d                	beqz	a4,80000928 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008fc:	01f7f713          	andi	a4,a5,31
    80000900:	9756                	add	a4,a4,s5
    80000902:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000906:	0785                	addi	a5,a5,1
    80000908:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000090a:	8526                	mv	a0,s1
    8000090c:	15f010ef          	jal	8000226a <wakeup>
    WriteReg(THR, c);
    80000910:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000914:	609c                	ld	a5,0(s1)
    80000916:	0009b703          	ld	a4,0(s3)
    8000091a:	fcf71ce3          	bne	a4,a5,800008f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000091e:	100007b7          	lui	a5,0x10000
    80000922:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000924:	0007c783          	lbu	a5,0(a5)
  }
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6b02                	ld	s6,0(sp)
    80000938:	6121                	addi	sp,sp,64
    8000093a:	8082                	ret
      ReadReg(ISR);
    8000093c:	100007b7          	lui	a5,0x10000
    80000940:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000942:	0007c783          	lbu	a5,0(a5)
      return;
    80000946:	8082                	ret

0000000080000948 <uartputc>:
{
    80000948:	7179                	addi	sp,sp,-48
    8000094a:	f406                	sd	ra,40(sp)
    8000094c:	f022                	sd	s0,32(sp)
    8000094e:	ec26                	sd	s1,24(sp)
    80000950:	e84a                	sd	s2,16(sp)
    80000952:	e44e                	sd	s3,8(sp)
    80000954:	e052                	sd	s4,0(sp)
    80000956:	1800                	addi	s0,sp,48
    80000958:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000095a:	00013517          	auipc	a0,0x13
    8000095e:	e1e50513          	addi	a0,a0,-482 # 80013778 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000b797          	auipc	a5,0xb
    8000096a:	cde7a783          	lw	a5,-802(a5) # 8000b644 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000b717          	auipc	a4,0xb
    80000974:	ce073703          	ld	a4,-800(a4) # 8000b650 <uart_tx_w>
    80000978:	0000b797          	auipc	a5,0xb
    8000097c:	cd07b783          	ld	a5,-816(a5) # 8000b648 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00013997          	auipc	s3,0x13
    80000988:	df498993          	addi	s3,s3,-524 # 80013778 <uart_tx_lock>
    8000098c:	0000b497          	auipc	s1,0xb
    80000990:	cbc48493          	addi	s1,s1,-836 # 8000b648 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000b917          	auipc	s2,0xb
    80000998:	cbc90913          	addi	s2,s2,-836 # 8000b650 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	77a010ef          	jal	8000211e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00013497          	auipc	s1,0x13
    800009ba:	dc248493          	addi	s1,s1,-574 # 80013778 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000b797          	auipc	a5,0xb
    800009ce:	c8e7b323          	sd	a4,-890(a5) # 8000b650 <uart_tx_w>
  uartstart();
    800009d2:	ed7ff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	2c2000ef          	jal	80000c9a <release>
}
    800009dc:	70a2                	ld	ra,40(sp)
    800009de:	7402                	ld	s0,32(sp)
    800009e0:	64e2                	ld	s1,24(sp)
    800009e2:	6942                	ld	s2,16(sp)
    800009e4:	69a2                	ld	s3,8(sp)
    800009e6:	6a02                	ld	s4,0(sp)
    800009e8:	6145                	addi	sp,sp,48
    800009ea:	8082                	ret
    for(;;)
    800009ec:	a001                	j	800009ec <uartputc+0xa4>

00000000800009ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ee:	1141                	addi	sp,sp,-16
    800009f0:	e422                	sd	s0,8(sp)
    800009f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009fa:	0007c783          	lbu	a5,0(a5)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cb81                	beqz	a5,80000a10 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a02:	100007b7          	lui	a5,0x10000
    80000a06:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a0a:	6422                	ld	s0,8(sp)
    80000a0c:	0141                	addi	sp,sp,16
    80000a0e:	8082                	ret
    return -1;
    80000a10:	557d                	li	a0,-1
    80000a12:	bfe5                	j	80000a0a <uartgetc+0x1c>

0000000080000a14 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a1e:	54fd                	li	s1,-1
    80000a20:	a019                	j	80000a26 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a22:	851ff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a26:	fc9ff0ef          	jal	800009ee <uartgetc>
    if(c == -1)
    80000a2a:	fe951ce3          	bne	a0,s1,80000a22 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a2e:	00013497          	auipc	s1,0x13
    80000a32:	d4a48493          	addi	s1,s1,-694 # 80013778 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	1ca000ef          	jal	80000c02 <acquire>
  uartstart();
    80000a3c:	e6dff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    80000a40:	8526                	mv	a0,s1
    80000a42:	258000ef          	jal	80000c9a <release>
}
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret

0000000080000a50 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	e04a                	sd	s2,0(sp)
    80000a5a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a5c:	03451793          	slli	a5,a0,0x34
    80000a60:	e7a9                	bnez	a5,80000aaa <kfree+0x5a>
    80000a62:	84aa                	mv	s1,a0
    80000a64:	0002c797          	auipc	a5,0x2c
    80000a68:	99478793          	addi	a5,a5,-1644 # 8002c3f8 <end>
    80000a6c:	02f56f63          	bltu	a0,a5,80000aaa <kfree+0x5a>
    80000a70:	47c5                	li	a5,17
    80000a72:	07ee                	slli	a5,a5,0x1b
    80000a74:	02f57b63          	bgeu	a0,a5,80000aaa <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	4585                	li	a1,1
    80000a7c:	25a000ef          	jal	80000cd6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a80:	00013917          	auipc	s2,0x13
    80000a84:	d3090913          	addi	s2,s2,-720 # 800137b0 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	178000ef          	jal	80000c02 <acquire>
  r->next = kmem.freelist;
    80000a8e:	01893783          	ld	a5,24(s2)
    80000a92:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a94:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	200000ef          	jal	80000c9a <release>
}
    80000a9e:	60e2                	ld	ra,24(sp)
    80000aa0:	6442                	ld	s0,16(sp)
    80000aa2:	64a2                	ld	s1,8(sp)
    80000aa4:	6902                	ld	s2,0(sp)
    80000aa6:	6105                	addi	sp,sp,32
    80000aa8:	8082                	ret
    panic("kfree");
    80000aaa:	00007517          	auipc	a0,0x7
    80000aae:	58e50513          	addi	a0,a0,1422 # 80008038 <etext+0x38>
    80000ab2:	cf1ff0ef          	jal	800007a2 <panic>

0000000080000ab6 <freerange>:
{
    80000ab6:	7179                	addi	sp,sp,-48
    80000ab8:	f406                	sd	ra,40(sp)
    80000aba:	f022                	sd	s0,32(sp)
    80000abc:	ec26                	sd	s1,24(sp)
    80000abe:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ac6:	00e504b3          	add	s1,a0,a4
    80000aca:	777d                	lui	a4,0xfffff
    80000acc:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94be                	add	s1,s1,a5
    80000ad0:	0295e263          	bltu	a1,s1,80000af4 <freerange+0x3e>
    80000ad4:	e84a                	sd	s2,16(sp)
    80000ad6:	e44e                	sd	s3,8(sp)
    80000ad8:	e052                	sd	s4,0(sp)
    80000ada:	892e                	mv	s2,a1
    kfree(p);
    80000adc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ade:	6985                	lui	s3,0x1
    kfree(p);
    80000ae0:	01448533          	add	a0,s1,s4
    80000ae4:	f6dff0ef          	jal	80000a50 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	94ce                	add	s1,s1,s3
    80000aea:	fe997be3          	bgeu	s2,s1,80000ae0 <freerange+0x2a>
    80000aee:	6942                	ld	s2,16(sp)
    80000af0:	69a2                	ld	s3,8(sp)
    80000af2:	6a02                	ld	s4,0(sp)
}
    80000af4:	70a2                	ld	ra,40(sp)
    80000af6:	7402                	ld	s0,32(sp)
    80000af8:	64e2                	ld	s1,24(sp)
    80000afa:	6145                	addi	sp,sp,48
    80000afc:	8082                	ret

0000000080000afe <kinit>:
{
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b06:	00007597          	auipc	a1,0x7
    80000b0a:	53a58593          	addi	a1,a1,1338 # 80008040 <etext+0x40>
    80000b0e:	00013517          	auipc	a0,0x13
    80000b12:	ca250513          	addi	a0,a0,-862 # 800137b0 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	0002c517          	auipc	a0,0x2c
    80000b22:	8da50513          	addi	a0,a0,-1830 # 8002c3f8 <end>
    80000b26:	f91ff0ef          	jal	80000ab6 <freerange>
}
    80000b2a:	60a2                	ld	ra,8(sp)
    80000b2c:	6402                	ld	s0,0(sp)
    80000b2e:	0141                	addi	sp,sp,16
    80000b30:	8082                	ret

0000000080000b32 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b3c:	00013497          	auipc	s1,0x13
    80000b40:	c7448493          	addi	s1,s1,-908 # 800137b0 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00013517          	auipc	a0,0x13
    80000b54:	c6050513          	addi	a0,a0,-928 # 800137b0 <kmem>
    80000b58:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5a:	140000ef          	jal	80000c9a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b5e:	6605                	lui	a2,0x1
    80000b60:	4595                	li	a1,5
    80000b62:	8526                	mv	a0,s1
    80000b64:	172000ef          	jal	80000cd6 <memset>
  return (void*)r;
}
    80000b68:	8526                	mv	a0,s1
    80000b6a:	60e2                	ld	ra,24(sp)
    80000b6c:	6442                	ld	s0,16(sp)
    80000b6e:	64a2                	ld	s1,8(sp)
    80000b70:	6105                	addi	sp,sp,32
    80000b72:	8082                	ret
  release(&kmem.lock);
    80000b74:	00013517          	auipc	a0,0x13
    80000b78:	c3c50513          	addi	a0,a0,-964 # 800137b0 <kmem>
    80000b7c:	11e000ef          	jal	80000c9a <release>
  if(r)
    80000b80:	b7e5                	j	80000b68 <kalloc+0x36>

0000000080000b82 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b88:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b8a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8e:	00053823          	sd	zero,16(a0)
}
    80000b92:	6422                	ld	s0,8(sp)
    80000b94:	0141                	addi	sp,sp,16
    80000b96:	8082                	ret

0000000080000b98 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b98:	411c                	lw	a5,0(a0)
    80000b9a:	e399                	bnez	a5,80000ba0 <holding+0x8>
    80000b9c:	4501                	li	a0,0
  return r;
}
    80000b9e:	8082                	ret
{
    80000ba0:	1101                	addi	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000baa:	6904                	ld	s1,16(a0)
    80000bac:	539000ef          	jal	800018e4 <mycpu>
    80000bb0:	40a48533          	sub	a0,s1,a0
    80000bb4:	00153513          	seqz	a0,a0
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret

0000000080000bc2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bcc:	100024f3          	csrr	s1,sstatus
    80000bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bda:	50b000ef          	jal	800018e4 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	503000ef          	jal	800018e4 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
}
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    mycpu()->intena = old;
    80000bf6:	4ef000ef          	jal	800018e4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	8085                	srli	s1,s1,0x1
    80000bfc:	8885                	andi	s1,s1,1
    80000bfe:	dd64                	sw	s1,124(a0)
    80000c00:	b7cd                	j	80000be2 <push_off+0x20>

0000000080000c02 <acquire>:
{
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    80000c0c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0e:	fb5ff0ef          	jal	80000bc2 <push_off>
  if(holding(lk))
    80000c12:	8526                	mv	a0,s1
    80000c14:	f85ff0ef          	jal	80000b98 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	4705                	li	a4,1
  if(holding(lk))
    80000c1a:	e105                	bnez	a0,80000c3a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1c:	87ba                	mv	a5,a4
    80000c1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c22:	2781                	sext.w	a5,a5
    80000c24:	ffe5                	bnez	a5,80000c1c <acquire+0x1a>
  __sync_synchronize();
    80000c26:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c2a:	4bb000ef          	jal	800018e4 <mycpu>
    80000c2e:	e888                	sd	a0,16(s1)
}
    80000c30:	60e2                	ld	ra,24(sp)
    80000c32:	6442                	ld	s0,16(sp)
    80000c34:	64a2                	ld	s1,8(sp)
    80000c36:	6105                	addi	sp,sp,32
    80000c38:	8082                	ret
    panic("acquire");
    80000c3a:	00007517          	auipc	a0,0x7
    80000c3e:	40e50513          	addi	a0,a0,1038 # 80008048 <etext+0x48>
    80000c42:	b61ff0ef          	jal	800007a2 <panic>

0000000080000c46 <pop_off>:

void
pop_off(void)
{
    80000c46:	1141                	addi	sp,sp,-16
    80000c48:	e406                	sd	ra,8(sp)
    80000c4a:	e022                	sd	s0,0(sp)
    80000c4c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4e:	497000ef          	jal	800018e4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c56:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c58:	e78d                	bnez	a5,80000c82 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c5a:	5d3c                	lw	a5,120(a0)
    80000c5c:	02f05963          	blez	a5,80000c8e <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c60:	37fd                	addiw	a5,a5,-1
    80000c62:	0007871b          	sext.w	a4,a5
    80000c66:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c68:	eb09                	bnez	a4,80000c7a <pop_off+0x34>
    80000c6a:	5d7c                	lw	a5,124(a0)
    80000c6c:	c799                	beqz	a5,80000c7a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c76:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c7a:	60a2                	ld	ra,8(sp)
    80000c7c:	6402                	ld	s0,0(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    panic("pop_off - interruptible");
    80000c82:	00007517          	auipc	a0,0x7
    80000c86:	3ce50513          	addi	a0,a0,974 # 80008050 <etext+0x50>
    80000c8a:	b19ff0ef          	jal	800007a2 <panic>
    panic("pop_off");
    80000c8e:	00007517          	auipc	a0,0x7
    80000c92:	3da50513          	addi	a0,a0,986 # 80008068 <etext+0x68>
    80000c96:	b0dff0ef          	jal	800007a2 <panic>

0000000080000c9a <release>:
{
    80000c9a:	1101                	addi	sp,sp,-32
    80000c9c:	ec06                	sd	ra,24(sp)
    80000c9e:	e822                	sd	s0,16(sp)
    80000ca0:	e426                	sd	s1,8(sp)
    80000ca2:	1000                	addi	s0,sp,32
    80000ca4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ca6:	ef3ff0ef          	jal	80000b98 <holding>
    80000caa:	c105                	beqz	a0,80000cca <release+0x30>
  lk->cpu = 0;
    80000cac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cb4:	0310000f          	fence	rw,w
    80000cb8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cbc:	f8bff0ef          	jal	80000c46 <pop_off>
}
    80000cc0:	60e2                	ld	ra,24(sp)
    80000cc2:	6442                	ld	s0,16(sp)
    80000cc4:	64a2                	ld	s1,8(sp)
    80000cc6:	6105                	addi	sp,sp,32
    80000cc8:	8082                	ret
    panic("release");
    80000cca:	00007517          	auipc	a0,0x7
    80000cce:	3a650513          	addi	a0,a0,934 # 80008070 <etext+0x70>
    80000cd2:	ad1ff0ef          	jal	800007a2 <panic>

0000000080000cd6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd6:	1141                	addi	sp,sp,-16
    80000cd8:	e422                	sd	s0,8(sp)
    80000cda:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cdc:	ca19                	beqz	a2,80000cf2 <memset+0x1c>
    80000cde:	87aa                	mv	a5,a0
    80000ce0:	1602                	slli	a2,a2,0x20
    80000ce2:	9201                	srli	a2,a2,0x20
    80000ce4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x12>
  }
  return dst;
}
    80000cf2:	6422                	ld	s0,8(sp)
    80000cf4:	0141                	addi	sp,sp,16
    80000cf6:	8082                	ret

0000000080000cf8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfe:	ca05                	beqz	a2,80000d2e <memcmp+0x36>
    80000d00:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d04:	1682                	slli	a3,a3,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	0685                	addi	a3,a3,1
    80000d0a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79863          	bne	a5,a4,80000d24 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x14>
  }

  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	a019                	j	80000d28 <memcmp+0x30>
      return *s1 - *s2;
    80000d24:	40e7853b          	subw	a0,a5,a4
}
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfe5                	j	80000d28 <memcmp+0x30>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d38:	c205                	beqz	a2,80000d58 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3a:	02a5e263          	bltu	a1,a0,80000d5e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00c587b3          	add	a5,a1,a2
{
    80000d46:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d48:	0585                	addi	a1,a1,1
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd2c09>
    80000d4c:	fff5c683          	lbu	a3,-1(a1)
    80000d50:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d54:	feb79ae3          	bne	a5,a1,80000d48 <memmove+0x16>

  return dst;
}
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret
  if(s < d && s + n > d){
    80000d5e:	02061693          	slli	a3,a2,0x20
    80000d62:	9281                	srli	a3,a3,0x20
    80000d64:	00d58733          	add	a4,a1,a3
    80000d68:	fce57be3          	bgeu	a0,a4,80000d3e <memmove+0xc>
    d += n;
    80000d6c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6e:	fff6079b          	addiw	a5,a2,-1
    80000d72:	1782                	slli	a5,a5,0x20
    80000d74:	9381                	srli	a5,a5,0x20
    80000d76:	fff7c793          	not	a5,a5
    80000d7a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	16fd                	addi	a3,a3,-1
    80000d80:	00074603          	lbu	a2,0(a4)
    80000d84:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d88:	fef71ae3          	bne	a4,a5,80000d7c <memmove+0x4a>
    80000d8c:	b7f1                	j	80000d58 <memmove+0x26>

0000000080000d8e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8e:	1141                	addi	sp,sp,-16
    80000d90:	e406                	sd	ra,8(sp)
    80000d92:	e022                	sd	s0,0(sp)
    80000d94:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d96:	f9dff0ef          	jal	80000d32 <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a801                	j	80000dd2 <strncmp+0x30>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dde:	87aa                	mv	a5,a0
    80000de0:	86b2                	mv	a3,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	02d05563          	blez	a3,80000e0e <strncpy+0x36>
    80000de8:	0785                	addi	a5,a5,1
    80000dea:	0005c703          	lbu	a4,0(a1)
    80000dee:	fee78fa3          	sb	a4,-1(a5)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f775                	bnez	a4,80000de0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df6:	873e                	mv	a4,a5
    80000df8:	9fb5                	addw	a5,a5,a3
    80000dfa:	37fd                	addiw	a5,a5,-1
    80000dfc:	00c05963          	blez	a2,80000e0e <strncpy+0x36>
    *s++ = 0;
    80000e00:	0705                	addi	a4,a4,1
    80000e02:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e06:	40e786bb          	subw	a3,a5,a4
    80000e0a:	fed04be3          	bgtz	a3,80000e00 <strncpy+0x28>
  return os;
}
    80000e0e:	6422                	ld	s0,8(sp)
    80000e10:	0141                	addi	sp,sp,16
    80000e12:	8082                	ret

0000000080000e14 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e422                	sd	s0,8(sp)
    80000e18:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1a:	02c05363          	blez	a2,80000e40 <safestrcpy+0x2c>
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	1682                	slli	a3,a3,0x20
    80000e24:	9281                	srli	a3,a3,0x20
    80000e26:	96ae                	add	a3,a3,a1
    80000e28:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2a:	00d58963          	beq	a1,a3,80000e3c <safestrcpy+0x28>
    80000e2e:	0585                	addi	a1,a1,1
    80000e30:	0785                	addi	a5,a5,1
    80000e32:	fff5c703          	lbu	a4,-1(a1)
    80000e36:	fee78fa3          	sb	a4,-1(a5)
    80000e3a:	fb65                	bnez	a4,80000e2a <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strlen>:

int
strlen(const char *s)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4c:	00054783          	lbu	a5,0(a0)
    80000e50:	cf91                	beqz	a5,80000e6c <strlen+0x26>
    80000e52:	0505                	addi	a0,a0,1
    80000e54:	87aa                	mv	a5,a0
    80000e56:	86be                	mv	a3,a5
    80000e58:	0785                	addi	a5,a5,1
    80000e5a:	fff7c703          	lbu	a4,-1(a5)
    80000e5e:	ff65                	bnez	a4,80000e56 <strlen+0x10>
    80000e60:	40a6853b          	subw	a0,a3,a0
    80000e64:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6c:	4501                	li	a0,0
    80000e6e:	bfe5                	j	80000e66 <strlen+0x20>

0000000080000e70 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e406                	sd	ra,8(sp)
    80000e74:	e022                	sd	s0,0(sp)
    80000e76:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e78:	25d000ef          	jal	800018d4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	0000a717          	auipc	a4,0xa
    80000e80:	7dc70713          	addi	a4,a4,2012 # 8000b658 <started>
  if(cpuid() == 0){
    80000e84:	c51d                	beqz	a0,80000eb2 <main+0x42>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x16>
      ;
    __sync_synchronize();
    80000e8c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e90:	245000ef          	jal	800018d4 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00007517          	auipc	a0,0x7
    80000e9a:	20250513          	addi	a0,a0,514 # 80008098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    kvminithart();    // turn on paging
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ea6:	17f010ef          	jal	80002824 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	21f040ef          	jal	800058c8 <plicinithart>
  }

  scheduler();
    80000eae:	018010ef          	jal	80001ec6 <scheduler>
    consoleinit();
    80000eb2:	d48ff0ef          	jal	800003fa <consoleinit>
    printfinit();
    80000eb6:	927ff0ef          	jal	800007dc <printfinit>
    printf("\n");
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	1be50513          	addi	a0,a0,446 # 80008078 <etext+0x78>
    80000ec2:	e0eff0ef          	jal	800004d0 <printf>
    printf("xv6 kernel is booting\n");
    80000ec6:	00007517          	auipc	a0,0x7
    80000eca:	1ba50513          	addi	a0,a0,442 # 80008080 <etext+0x80>
    80000ece:	e02ff0ef          	jal	800004d0 <printf>
    printf("\n");
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1a650513          	addi	a0,a0,422 # 80008078 <etext+0x78>
    80000eda:	df6ff0ef          	jal	800004d0 <printf>
    kinit();         // physical page allocator
    80000ede:	c21ff0ef          	jal	80000afe <kinit>
    kvminit();       // create kernel page table
    80000ee2:	2dc000ef          	jal	800011be <kvminit>
    kvminithart();   // turn on paging
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    procinit();      // process table
    80000eea:	135000ef          	jal	8000181e <procinit>
    trapinit();      // trap vectors
    80000eee:	113010ef          	jal	80002800 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	133010ef          	jal	80002824 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	1b9040ef          	jal	800058ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	1cf040ef          	jal	800058c8 <plicinithart>
    binit();         // buffer cache
    80000efe:	16a020ef          	jal	80003068 <binit>
    iinit();         // inode table
    80000f02:	75c020ef          	jal	8000365e <iinit>
    fileinit();      // file table
    80000f06:	508030ef          	jal	8000440e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	2af040ef          	jal	800059b8 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	5c5000ef          	jal	80001cd2 <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	0000a717          	auipc	a4,0xa
    80000f1c:	74f72023          	sw	a5,1856(a4) # 8000b658 <started>
    80000f20:	b779                	j	80000eae <main+0x3e>

0000000080000f22 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f28:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f2c:	0000a797          	auipc	a5,0xa
    80000f30:	7347b783          	ld	a5,1844(a5) # 8000b660 <kernel_pagetable>
    80000f34:	83b1                	srli	a5,a5,0xc
    80000f36:	577d                	li	a4,-1
    80000f38:	177e                	slli	a4,a4,0x3f
    80000f3a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f3c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f40:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f4a:	7139                	addi	sp,sp,-64
    80000f4c:	fc06                	sd	ra,56(sp)
    80000f4e:	f822                	sd	s0,48(sp)
    80000f50:	f426                	sd	s1,40(sp)
    80000f52:	f04a                	sd	s2,32(sp)
    80000f54:	ec4e                	sd	s3,24(sp)
    80000f56:	e852                	sd	s4,16(sp)
    80000f58:	e456                	sd	s5,8(sp)
    80000f5a:	e05a                	sd	s6,0(sp)
    80000f5c:	0080                	addi	s0,sp,64
    80000f5e:	84aa                	mv	s1,a0
    80000f60:	89ae                	mv	s3,a1
    80000f62:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f64:	57fd                	li	a5,-1
    80000f66:	83e9                	srli	a5,a5,0x1a
    80000f68:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f6a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f6c:	02b7fc63          	bgeu	a5,a1,80000fa4 <walk+0x5a>
    panic("walk");
    80000f70:	00007517          	auipc	a0,0x7
    80000f74:	14050513          	addi	a0,a0,320 # 800080b0 <etext+0xb0>
    80000f78:	82bff0ef          	jal	800007a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f7c:	060a8263          	beqz	s5,80000fe0 <walk+0x96>
    80000f80:	bb3ff0ef          	jal	80000b32 <kalloc>
    80000f84:	84aa                	mv	s1,a0
    80000f86:	c139                	beqz	a0,80000fcc <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f88:	6605                	lui	a2,0x1
    80000f8a:	4581                	li	a1,0
    80000f8c:	d4bff0ef          	jal	80000cd6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f90:	00c4d793          	srli	a5,s1,0xc
    80000f94:	07aa                	slli	a5,a5,0xa
    80000f96:	0017e793          	ori	a5,a5,1
    80000f9a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd2bff>
    80000fa0:	036a0063          	beq	s4,s6,80000fc0 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fa4:	0149d933          	srl	s2,s3,s4
    80000fa8:	1ff97913          	andi	s2,s2,511
    80000fac:	090e                	slli	s2,s2,0x3
    80000fae:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fb0:	00093483          	ld	s1,0(s2)
    80000fb4:	0014f793          	andi	a5,s1,1
    80000fb8:	d3f1                	beqz	a5,80000f7c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fba:	80a9                	srli	s1,s1,0xa
    80000fbc:	04b2                	slli	s1,s1,0xc
    80000fbe:	b7c5                	j	80000f9e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fc0:	00c9d513          	srli	a0,s3,0xc
    80000fc4:	1ff57513          	andi	a0,a0,511
    80000fc8:	050e                	slli	a0,a0,0x3
    80000fca:	9526                	add	a0,a0,s1
}
    80000fcc:	70e2                	ld	ra,56(sp)
    80000fce:	7442                	ld	s0,48(sp)
    80000fd0:	74a2                	ld	s1,40(sp)
    80000fd2:	7902                	ld	s2,32(sp)
    80000fd4:	69e2                	ld	s3,24(sp)
    80000fd6:	6a42                	ld	s4,16(sp)
    80000fd8:	6aa2                	ld	s5,8(sp)
    80000fda:	6b02                	ld	s6,0(sp)
    80000fdc:	6121                	addi	sp,sp,64
    80000fde:	8082                	ret
        return 0;
    80000fe0:	4501                	li	a0,0
    80000fe2:	b7ed                	j	80000fcc <walk+0x82>

0000000080000fe4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fe4:	57fd                	li	a5,-1
    80000fe6:	83e9                	srli	a5,a5,0x1a
    80000fe8:	00b7f463          	bgeu	a5,a1,80000ff0 <walkaddr+0xc>
    return 0;
    80000fec:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fee:	8082                	ret
{
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e406                	sd	ra,8(sp)
    80000ff4:	e022                	sd	s0,0(sp)
    80000ff6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000ff8:	4601                	li	a2,0
    80000ffa:	f51ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80000ffe:	c105                	beqz	a0,8000101e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001000:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001002:	0117f693          	andi	a3,a5,17
    80001006:	4745                	li	a4,17
    return 0;
    80001008:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000100a:	00e68663          	beq	a3,a4,80001016 <walkaddr+0x32>
}
    8000100e:	60a2                	ld	ra,8(sp)
    80001010:	6402                	ld	s0,0(sp)
    80001012:	0141                	addi	sp,sp,16
    80001014:	8082                	ret
  pa = PTE2PA(*pte);
    80001016:	83a9                	srli	a5,a5,0xa
    80001018:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000101c:	bfcd                	j	8000100e <walkaddr+0x2a>
    return 0;
    8000101e:	4501                	li	a0,0
    80001020:	b7fd                	j	8000100e <walkaddr+0x2a>

0000000080001022 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001022:	715d                	addi	sp,sp,-80
    80001024:	e486                	sd	ra,72(sp)
    80001026:	e0a2                	sd	s0,64(sp)
    80001028:	fc26                	sd	s1,56(sp)
    8000102a:	f84a                	sd	s2,48(sp)
    8000102c:	f44e                	sd	s3,40(sp)
    8000102e:	f052                	sd	s4,32(sp)
    80001030:	ec56                	sd	s5,24(sp)
    80001032:	e85a                	sd	s6,16(sp)
    80001034:	e45e                	sd	s7,8(sp)
    80001036:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001038:	03459793          	slli	a5,a1,0x34
    8000103c:	e7a9                	bnez	a5,80001086 <mappages+0x64>
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001042:	03461793          	slli	a5,a2,0x34
    80001046:	e7b1                	bnez	a5,80001092 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001048:	ca39                	beqz	a2,8000109e <mappages+0x7c>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000104a:	77fd                	lui	a5,0xfffff
    8000104c:	963e                	add	a2,a2,a5
    8000104e:	00b609b3          	add	s3,a2,a1
  a = va;
    80001052:	892e                	mv	s2,a1
    80001054:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001058:	6b85                	lui	s7,0x1
    8000105a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	ee7ff0ef          	jal	80000f4a <walk>
    80001068:	c539                	beqz	a0,800010b6 <mappages+0x94>
    if(*pte & PTE_V)
    8000106a:	611c                	ld	a5,0(a0)
    8000106c:	8b85                	andi	a5,a5,1
    8000106e:	ef95                	bnez	a5,800010aa <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001070:	80b1                	srli	s1,s1,0xc
    80001072:	04aa                	slli	s1,s1,0xa
    80001074:	0164e4b3          	or	s1,s1,s6
    80001078:	0014e493          	ori	s1,s1,1
    8000107c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000107e:	05390863          	beq	s2,s3,800010ce <mappages+0xac>
    a += PGSIZE;
    80001082:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001084:	bfd9                	j	8000105a <mappages+0x38>
    panic("mappages: va not aligned");
    80001086:	00007517          	auipc	a0,0x7
    8000108a:	03250513          	addi	a0,a0,50 # 800080b8 <etext+0xb8>
    8000108e:	f14ff0ef          	jal	800007a2 <panic>
    panic("mappages: size not aligned");
    80001092:	00007517          	auipc	a0,0x7
    80001096:	04650513          	addi	a0,a0,70 # 800080d8 <etext+0xd8>
    8000109a:	f08ff0ef          	jal	800007a2 <panic>
    panic("mappages: size");
    8000109e:	00007517          	auipc	a0,0x7
    800010a2:	05a50513          	addi	a0,a0,90 # 800080f8 <etext+0xf8>
    800010a6:	efcff0ef          	jal	800007a2 <panic>
      panic("mappages: remap");
    800010aa:	00007517          	auipc	a0,0x7
    800010ae:	05e50513          	addi	a0,a0,94 # 80008108 <etext+0x108>
    800010b2:	ef0ff0ef          	jal	800007a2 <panic>
      return -1;
    800010b6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010b8:	60a6                	ld	ra,72(sp)
    800010ba:	6406                	ld	s0,64(sp)
    800010bc:	74e2                	ld	s1,56(sp)
    800010be:	7942                	ld	s2,48(sp)
    800010c0:	79a2                	ld	s3,40(sp)
    800010c2:	7a02                	ld	s4,32(sp)
    800010c4:	6ae2                	ld	s5,24(sp)
    800010c6:	6b42                	ld	s6,16(sp)
    800010c8:	6ba2                	ld	s7,8(sp)
    800010ca:	6161                	addi	sp,sp,80
    800010cc:	8082                	ret
  return 0;
    800010ce:	4501                	li	a0,0
    800010d0:	b7e5                	j	800010b8 <mappages+0x96>

00000000800010d2 <kvmmap>:
{
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e406                	sd	ra,8(sp)
    800010d6:	e022                	sd	s0,0(sp)
    800010d8:	0800                	addi	s0,sp,16
    800010da:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010dc:	86b2                	mv	a3,a2
    800010de:	863e                	mv	a2,a5
    800010e0:	f43ff0ef          	jal	80001022 <mappages>
    800010e4:	e509                	bnez	a0,800010ee <kvmmap+0x1c>
}
    800010e6:	60a2                	ld	ra,8(sp)
    800010e8:	6402                	ld	s0,0(sp)
    800010ea:	0141                	addi	sp,sp,16
    800010ec:	8082                	ret
    panic("kvmmap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	02a50513          	addi	a0,a0,42 # 80008118 <etext+0x118>
    800010f6:	eacff0ef          	jal	800007a2 <panic>

00000000800010fa <kvmmake>:
{
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001106:	a2dff0ef          	jal	80000b32 <kalloc>
    8000110a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000110c:	6605                	lui	a2,0x1
    8000110e:	4581                	li	a1,0
    80001110:	bc7ff0ef          	jal	80000cd6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10000637          	lui	a2,0x10000
    8000111c:	100005b7          	lui	a1,0x10000
    80001120:	8526                	mv	a0,s1
    80001122:	fb1ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001126:	4719                	li	a4,6
    80001128:	6685                	lui	a3,0x1
    8000112a:	10001637          	lui	a2,0x10001
    8000112e:	100015b7          	lui	a1,0x10001
    80001132:	8526                	mv	a0,s1
    80001134:	f9fff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001138:	4719                	li	a4,6
    8000113a:	66c1                	lui	a3,0x10
    8000113c:	02000637          	lui	a2,0x2000
    80001140:	020005b7          	lui	a1,0x2000
    80001144:	8526                	mv	a0,s1
    80001146:	f8dff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	040006b7          	lui	a3,0x4000
    80001150:	0c000637          	lui	a2,0xc000
    80001154:	0c0005b7          	lui	a1,0xc000
    80001158:	8526                	mv	a0,s1
    8000115a:	f79ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000115e:	00007917          	auipc	s2,0x7
    80001162:	ea290913          	addi	s2,s2,-350 # 80008000 <etext>
    80001166:	4729                	li	a4,10
    80001168:	80007697          	auipc	a3,0x80007
    8000116c:	e9868693          	addi	a3,a3,-360 # 8000 <_entry-0x7fff8000>
    80001170:	4605                	li	a2,1
    80001172:	067e                	slli	a2,a2,0x1f
    80001174:	85b2                	mv	a1,a2
    80001176:	8526                	mv	a0,s1
    80001178:	f5bff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000117c:	46c5                	li	a3,17
    8000117e:	06ee                	slli	a3,a3,0x1b
    80001180:	4719                	li	a4,6
    80001182:	412686b3          	sub	a3,a3,s2
    80001186:	864a                	mv	a2,s2
    80001188:	85ca                	mv	a1,s2
    8000118a:	8526                	mv	a0,s1
    8000118c:	f47ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001190:	4729                	li	a4,10
    80001192:	6685                	lui	a3,0x1
    80001194:	00006617          	auipc	a2,0x6
    80001198:	e6c60613          	addi	a2,a2,-404 # 80007000 <_trampoline>
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a2:	05b2                	slli	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	f2dff0ef          	jal	800010d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011aa:	8526                	mv	a0,s1
    800011ac:	5da000ef          	jal	80001786 <proc_mapstacks>
}
    800011b0:	8526                	mv	a0,s1
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6902                	ld	s2,0(sp)
    800011ba:	6105                	addi	sp,sp,32
    800011bc:	8082                	ret

00000000800011be <kvminit>:
{
    800011be:	1141                	addi	sp,sp,-16
    800011c0:	e406                	sd	ra,8(sp)
    800011c2:	e022                	sd	s0,0(sp)
    800011c4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011c6:	f35ff0ef          	jal	800010fa <kvmmake>
    800011ca:	0000a797          	auipc	a5,0xa
    800011ce:	48a7bb23          	sd	a0,1174(a5) # 8000b660 <kernel_pagetable>
}
    800011d2:	60a2                	ld	ra,8(sp)
    800011d4:	6402                	ld	s0,0(sp)
    800011d6:	0141                	addi	sp,sp,16
    800011d8:	8082                	ret

00000000800011da <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011da:	715d                	addi	sp,sp,-80
    800011dc:	e486                	sd	ra,72(sp)
    800011de:	e0a2                	sd	s0,64(sp)
    800011e0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e2:	03459793          	slli	a5,a1,0x34
    800011e6:	e39d                	bnez	a5,8000120c <uvmunmap+0x32>
    800011e8:	f84a                	sd	s2,48(sp)
    800011ea:	f44e                	sd	s3,40(sp)
    800011ec:	f052                	sd	s4,32(sp)
    800011ee:	ec56                	sd	s5,24(sp)
    800011f0:	e85a                	sd	s6,16(sp)
    800011f2:	e45e                	sd	s7,8(sp)
    800011f4:	8a2a                	mv	s4,a0
    800011f6:	892e                	mv	s2,a1
    800011f8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011fa:	0632                	slli	a2,a2,0xc
    800011fc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001200:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001202:	6b05                	lui	s6,0x1
    80001204:	0735ff63          	bgeu	a1,s3,80001282 <uvmunmap+0xa8>
    80001208:	fc26                	sd	s1,56(sp)
    8000120a:	a0a9                	j	80001254 <uvmunmap+0x7a>
    8000120c:	fc26                	sd	s1,56(sp)
    8000120e:	f84a                	sd	s2,48(sp)
    80001210:	f44e                	sd	s3,40(sp)
    80001212:	f052                	sd	s4,32(sp)
    80001214:	ec56                	sd	s5,24(sp)
    80001216:	e85a                	sd	s6,16(sp)
    80001218:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000121a:	00007517          	auipc	a0,0x7
    8000121e:	f0650513          	addi	a0,a0,-250 # 80008120 <etext+0x120>
    80001222:	d80ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: walk");
    80001226:	00007517          	auipc	a0,0x7
    8000122a:	f1250513          	addi	a0,a0,-238 # 80008138 <etext+0x138>
    8000122e:	d74ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not mapped");
    80001232:	00007517          	auipc	a0,0x7
    80001236:	f1650513          	addi	a0,a0,-234 # 80008148 <etext+0x148>
    8000123a:	d68ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not a leaf");
    8000123e:	00007517          	auipc	a0,0x7
    80001242:	f2250513          	addi	a0,a0,-222 # 80008160 <etext+0x160>
    80001246:	d5cff0ef          	jal	800007a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000124a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124e:	995a                	add	s2,s2,s6
    80001250:	03397863          	bgeu	s2,s3,80001280 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001254:	4601                	li	a2,0
    80001256:	85ca                	mv	a1,s2
    80001258:	8552                	mv	a0,s4
    8000125a:	cf1ff0ef          	jal	80000f4a <walk>
    8000125e:	84aa                	mv	s1,a0
    80001260:	d179                	beqz	a0,80001226 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001262:	6108                	ld	a0,0(a0)
    80001264:	00157793          	andi	a5,a0,1
    80001268:	d7e9                	beqz	a5,80001232 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	3ff57793          	andi	a5,a0,1023
    8000126e:	fd7788e3          	beq	a5,s7,8000123e <uvmunmap+0x64>
    if(do_free){
    80001272:	fc0a8ce3          	beqz	s5,8000124a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001276:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001278:	0532                	slli	a0,a0,0xc
    8000127a:	fd6ff0ef          	jal	80000a50 <kfree>
    8000127e:	b7f1                	j	8000124a <uvmunmap+0x70>
    80001280:	74e2                	ld	s1,56(sp)
    80001282:	7942                	ld	s2,48(sp)
    80001284:	79a2                	ld	s3,40(sp)
    80001286:	7a02                	ld	s4,32(sp)
    80001288:	6ae2                	ld	s5,24(sp)
    8000128a:	6b42                	ld	s6,16(sp)
    8000128c:	6ba2                	ld	s7,8(sp)
  }
}
    8000128e:	60a6                	ld	ra,72(sp)
    80001290:	6406                	ld	s0,64(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret

0000000080001296 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001296:	1101                	addi	sp,sp,-32
    80001298:	ec06                	sd	ra,24(sp)
    8000129a:	e822                	sd	s0,16(sp)
    8000129c:	e426                	sd	s1,8(sp)
    8000129e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a0:	893ff0ef          	jal	80000b32 <kalloc>
    800012a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012a6:	c509                	beqz	a0,800012b0 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012a8:	6605                	lui	a2,0x1
    800012aa:	4581                	li	a1,0
    800012ac:	a2bff0ef          	jal	80000cd6 <memset>
  return pagetable;
}
    800012b0:	8526                	mv	a0,s1
    800012b2:	60e2                	ld	ra,24(sp)
    800012b4:	6442                	ld	s0,16(sp)
    800012b6:	64a2                	ld	s1,8(sp)
    800012b8:	6105                	addi	sp,sp,32
    800012ba:	8082                	ret

00000000800012bc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012bc:	7179                	addi	sp,sp,-48
    800012be:	f406                	sd	ra,40(sp)
    800012c0:	f022                	sd	s0,32(sp)
    800012c2:	ec26                	sd	s1,24(sp)
    800012c4:	e84a                	sd	s2,16(sp)
    800012c6:	e44e                	sd	s3,8(sp)
    800012c8:	e052                	sd	s4,0(sp)
    800012ca:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012cc:	6785                	lui	a5,0x1
    800012ce:	04f67063          	bgeu	a2,a5,8000130e <uvmfirst+0x52>
    800012d2:	8a2a                	mv	s4,a0
    800012d4:	89ae                	mv	s3,a1
    800012d6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012d8:	85bff0ef          	jal	80000b32 <kalloc>
    800012dc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	9f5ff0ef          	jal	80000cd6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012e6:	4779                	li	a4,30
    800012e8:	86ca                	mv	a3,s2
    800012ea:	6605                	lui	a2,0x1
    800012ec:	4581                	li	a1,0
    800012ee:	8552                	mv	a0,s4
    800012f0:	d33ff0ef          	jal	80001022 <mappages>
  memmove(mem, src, sz);
    800012f4:	8626                	mv	a2,s1
    800012f6:	85ce                	mv	a1,s3
    800012f8:	854a                	mv	a0,s2
    800012fa:	a39ff0ef          	jal	80000d32 <memmove>
}
    800012fe:	70a2                	ld	ra,40(sp)
    80001300:	7402                	ld	s0,32(sp)
    80001302:	64e2                	ld	s1,24(sp)
    80001304:	6942                	ld	s2,16(sp)
    80001306:	69a2                	ld	s3,8(sp)
    80001308:	6a02                	ld	s4,0(sp)
    8000130a:	6145                	addi	sp,sp,48
    8000130c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	e6a50513          	addi	a0,a0,-406 # 80008178 <etext+0x178>
    80001316:	c8cff0ef          	jal	800007a2 <panic>

000000008000131a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000134c:	8f99                	sub	a5,a5,a4
    8000134e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001350:	4685                	li	a3,1
    80001352:	0007861b          	sext.w	a2,a5
    80001356:	85ba                	mv	a1,a4
    80001358:	e83ff0ef          	jal	800011da <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	08b66f63          	bltu	a2,a1,800013fc <uvmalloc+0x9e>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	0080                	addi	s0,sp,64
    80001370:	8aaa                	mv	s5,a0
    80001372:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001374:	6785                	lui	a5,0x1
    80001376:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001378:	95be                	add	a1,a1,a5
    8000137a:	77fd                	lui	a5,0xfffff
    8000137c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001380:	08c9f063          	bgeu	s3,a2,80001400 <uvmalloc+0xa2>
    80001384:	f426                	sd	s1,40(sp)
    80001386:	f04a                	sd	s2,32(sp)
    80001388:	e05a                	sd	s6,0(sp)
    8000138a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000138c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001390:	fa2ff0ef          	jal	80000b32 <kalloc>
    80001394:	84aa                	mv	s1,a0
    if(mem == 0){
    80001396:	c515                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001398:	6605                	lui	a2,0x1
    8000139a:	4581                	li	a1,0
    8000139c:	93bff0ef          	jal	80000cd6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013a0:	875a                	mv	a4,s6
    800013a2:	86a6                	mv	a3,s1
    800013a4:	6605                	lui	a2,0x1
    800013a6:	85ca                	mv	a1,s2
    800013a8:	8556                	mv	a0,s5
    800013aa:	c79ff0ef          	jal	80001022 <mappages>
    800013ae:	e915                	bnez	a0,800013e2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013b0:	6785                	lui	a5,0x1
    800013b2:	993e                	add	s2,s2,a5
    800013b4:	fd496ee3          	bltu	s2,s4,80001390 <uvmalloc+0x32>
  return newsz;
    800013b8:	8552                	mv	a0,s4
    800013ba:	74a2                	ld	s1,40(sp)
    800013bc:	7902                	ld	s2,32(sp)
    800013be:	6b02                	ld	s6,0(sp)
    800013c0:	a811                	j	800013d4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	f53ff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013cc:	4501                	li	a0,0
    800013ce:	74a2                	ld	s1,40(sp)
    800013d0:	7902                	ld	s2,32(sp)
    800013d2:	6b02                	ld	s6,0(sp)
}
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	69e2                	ld	s3,24(sp)
    800013da:	6a42                	ld	s4,16(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
      kfree(mem);
    800013e2:	8526                	mv	a0,s1
    800013e4:	e6cff0ef          	jal	80000a50 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013e8:	864e                	mv	a2,s3
    800013ea:	85ca                	mv	a1,s2
    800013ec:	8556                	mv	a0,s5
    800013ee:	f2dff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013f2:	4501                	li	a0,0
    800013f4:	74a2                	ld	s1,40(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6b02                	ld	s6,0(sp)
    800013fa:	bfe9                	j	800013d4 <uvmalloc+0x76>
    return oldsz;
    800013fc:	852e                	mv	a0,a1
}
    800013fe:	8082                	ret
  return newsz;
    80001400:	8532                	mv	a0,a2
    80001402:	bfc9                	j	800013d4 <uvmalloc+0x76>

0000000080001404 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001404:	7179                	addi	sp,sp,-48
    80001406:	f406                	sd	ra,40(sp)
    80001408:	f022                	sd	s0,32(sp)
    8000140a:	ec26                	sd	s1,24(sp)
    8000140c:	e84a                	sd	s2,16(sp)
    8000140e:	e44e                	sd	s3,8(sp)
    80001410:	e052                	sd	s4,0(sp)
    80001412:	1800                	addi	s0,sp,48
    80001414:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001416:	84aa                	mv	s1,a0
    80001418:	6905                	lui	s2,0x1
    8000141a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000141c:	4985                	li	s3,1
    8000141e:	a819                	j	80001434 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001420:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001422:	00c79513          	slli	a0,a5,0xc
    80001426:	fdfff0ef          	jal	80001404 <freewalk>
      pagetable[i] = 0;
    8000142a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000142e:	04a1                	addi	s1,s1,8
    80001430:	01248f63          	beq	s1,s2,8000144e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001434:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001436:	00f7f713          	andi	a4,a5,15
    8000143a:	ff3703e3          	beq	a4,s3,80001420 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000143e:	8b85                	andi	a5,a5,1
    80001440:	d7fd                	beqz	a5,8000142e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001442:	00007517          	auipc	a0,0x7
    80001446:	d5650513          	addi	a0,a0,-682 # 80008198 <etext+0x198>
    8000144a:	b58ff0ef          	jal	800007a2 <panic>
    }
  }
  kfree((void*)pagetable);
    8000144e:	8552                	mv	a0,s4
    80001450:	e00ff0ef          	jal	80000a50 <kfree>
}
    80001454:	70a2                	ld	ra,40(sp)
    80001456:	7402                	ld	s0,32(sp)
    80001458:	64e2                	ld	s1,24(sp)
    8000145a:	6942                	ld	s2,16(sp)
    8000145c:	69a2                	ld	s3,8(sp)
    8000145e:	6a02                	ld	s4,0(sp)
    80001460:	6145                	addi	sp,sp,48
    80001462:	8082                	ret

0000000080001464 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001464:	1101                	addi	sp,sp,-32
    80001466:	ec06                	sd	ra,24(sp)
    80001468:	e822                	sd	s0,16(sp)
    8000146a:	e426                	sd	s1,8(sp)
    8000146c:	1000                	addi	s0,sp,32
    8000146e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001470:	e989                	bnez	a1,80001482 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001472:	8526                	mv	a0,s1
    80001474:	f91ff0ef          	jal	80001404 <freewalk>
}
    80001478:	60e2                	ld	ra,24(sp)
    8000147a:	6442                	ld	s0,16(sp)
    8000147c:	64a2                	ld	s1,8(sp)
    8000147e:	6105                	addi	sp,sp,32
    80001480:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001482:	6785                	lui	a5,0x1
    80001484:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001486:	95be                	add	a1,a1,a5
    80001488:	4685                	li	a3,1
    8000148a:	00c5d613          	srli	a2,a1,0xc
    8000148e:	4581                	li	a1,0
    80001490:	d4bff0ef          	jal	800011da <uvmunmap>
    80001494:	bff9                	j	80001472 <uvmfree+0xe>

0000000080001496 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001496:	c65d                	beqz	a2,80001544 <uvmcopy+0xae>
{
    80001498:	715d                	addi	sp,sp,-80
    8000149a:	e486                	sd	ra,72(sp)
    8000149c:	e0a2                	sd	s0,64(sp)
    8000149e:	fc26                	sd	s1,56(sp)
    800014a0:	f84a                	sd	s2,48(sp)
    800014a2:	f44e                	sd	s3,40(sp)
    800014a4:	f052                	sd	s4,32(sp)
    800014a6:	ec56                	sd	s5,24(sp)
    800014a8:	e85a                	sd	s6,16(sp)
    800014aa:	e45e                	sd	s7,8(sp)
    800014ac:	0880                	addi	s0,sp,80
    800014ae:	8b2a                	mv	s6,a0
    800014b0:	8aae                	mv	s5,a1
    800014b2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014b4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014b6:	4601                	li	a2,0
    800014b8:	85ce                	mv	a1,s3
    800014ba:	855a                	mv	a0,s6
    800014bc:	a8fff0ef          	jal	80000f4a <walk>
    800014c0:	c121                	beqz	a0,80001500 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014c2:	6118                	ld	a4,0(a0)
    800014c4:	00177793          	andi	a5,a4,1
    800014c8:	c3b1                	beqz	a5,8000150c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014ca:	00a75593          	srli	a1,a4,0xa
    800014ce:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014d2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014d6:	e5cff0ef          	jal	80000b32 <kalloc>
    800014da:	892a                	mv	s2,a0
    800014dc:	c129                	beqz	a0,8000151e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014de:	6605                	lui	a2,0x1
    800014e0:	85de                	mv	a1,s7
    800014e2:	851ff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014e6:	8726                	mv	a4,s1
    800014e8:	86ca                	mv	a3,s2
    800014ea:	6605                	lui	a2,0x1
    800014ec:	85ce                	mv	a1,s3
    800014ee:	8556                	mv	a0,s5
    800014f0:	b33ff0ef          	jal	80001022 <mappages>
    800014f4:	e115                	bnez	a0,80001518 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014f6:	6785                	lui	a5,0x1
    800014f8:	99be                	add	s3,s3,a5
    800014fa:	fb49eee3          	bltu	s3,s4,800014b6 <uvmcopy+0x20>
    800014fe:	a805                	j	8000152e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	ca850513          	addi	a0,a0,-856 # 800081a8 <etext+0x1a8>
    80001508:	a9aff0ef          	jal	800007a2 <panic>
      panic("uvmcopy: page not present");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cbc50513          	addi	a0,a0,-836 # 800081c8 <etext+0x1c8>
    80001514:	a8eff0ef          	jal	800007a2 <panic>
      kfree(mem);
    80001518:	854a                	mv	a0,s2
    8000151a:	d36ff0ef          	jal	80000a50 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000151e:	4685                	li	a3,1
    80001520:	00c9d613          	srli	a2,s3,0xc
    80001524:	4581                	li	a1,0
    80001526:	8556                	mv	a0,s5
    80001528:	cb3ff0ef          	jal	800011da <uvmunmap>
  return -1;
    8000152c:	557d                	li	a0,-1
}
    8000152e:	60a6                	ld	ra,72(sp)
    80001530:	6406                	ld	s0,64(sp)
    80001532:	74e2                	ld	s1,56(sp)
    80001534:	7942                	ld	s2,48(sp)
    80001536:	79a2                	ld	s3,40(sp)
    80001538:	7a02                	ld	s4,32(sp)
    8000153a:	6ae2                	ld	s5,24(sp)
    8000153c:	6b42                	ld	s6,16(sp)
    8000153e:	6ba2                	ld	s7,8(sp)
    80001540:	6161                	addi	sp,sp,80
    80001542:	8082                	ret
  return 0;
    80001544:	4501                	li	a0,0
}
    80001546:	8082                	ret

0000000080001548 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001548:	1141                	addi	sp,sp,-16
    8000154a:	e406                	sd	ra,8(sp)
    8000154c:	e022                	sd	s0,0(sp)
    8000154e:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001550:	4601                	li	a2,0
    80001552:	9f9ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80001556:	c901                	beqz	a0,80001566 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001558:	611c                	ld	a5,0(a0)
    8000155a:	9bbd                	andi	a5,a5,-17
    8000155c:	e11c                	sd	a5,0(a0)
}
    8000155e:	60a2                	ld	ra,8(sp)
    80001560:	6402                	ld	s0,0(sp)
    80001562:	0141                	addi	sp,sp,16
    80001564:	8082                	ret
    panic("uvmclear");
    80001566:	00007517          	auipc	a0,0x7
    8000156a:	c8250513          	addi	a0,a0,-894 # 800081e8 <etext+0x1e8>
    8000156e:	a34ff0ef          	jal	800007a2 <panic>

0000000080001572 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001572:	cad1                	beqz	a3,80001606 <copyout+0x94>
{
    80001574:	711d                	addi	sp,sp,-96
    80001576:	ec86                	sd	ra,88(sp)
    80001578:	e8a2                	sd	s0,80(sp)
    8000157a:	e4a6                	sd	s1,72(sp)
    8000157c:	fc4e                	sd	s3,56(sp)
    8000157e:	f456                	sd	s5,40(sp)
    80001580:	f05a                	sd	s6,32(sp)
    80001582:	ec5e                	sd	s7,24(sp)
    80001584:	1080                	addi	s0,sp,96
    80001586:	8baa                	mv	s7,a0
    80001588:	8aae                	mv	s5,a1
    8000158a:	8b32                	mv	s6,a2
    8000158c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000158e:	74fd                	lui	s1,0xfffff
    80001590:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001592:	57fd                	li	a5,-1
    80001594:	83e9                	srli	a5,a5,0x1a
    80001596:	0697ea63          	bltu	a5,s1,8000160a <copyout+0x98>
    8000159a:	e0ca                	sd	s2,64(sp)
    8000159c:	f852                	sd	s4,48(sp)
    8000159e:	e862                	sd	s8,16(sp)
    800015a0:	e466                	sd	s9,8(sp)
    800015a2:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015a4:	4cd5                	li	s9,21
    800015a6:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015a8:	8c3e                	mv	s8,a5
    800015aa:	a025                	j	800015d2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015ac:	83a9                	srli	a5,a5,0xa
    800015ae:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015b0:	409a8533          	sub	a0,s5,s1
    800015b4:	0009061b          	sext.w	a2,s2
    800015b8:	85da                	mv	a1,s6
    800015ba:	953e                	add	a0,a0,a5
    800015bc:	f76ff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015c0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015c4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015c6:	02098963          	beqz	s3,800015f8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015ca:	054c6263          	bltu	s8,s4,8000160e <copyout+0x9c>
    800015ce:	84d2                	mv	s1,s4
    800015d0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015d2:	4601                	li	a2,0
    800015d4:	85a6                	mv	a1,s1
    800015d6:	855e                	mv	a0,s7
    800015d8:	973ff0ef          	jal	80000f4a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015dc:	c121                	beqz	a0,8000161c <copyout+0xaa>
    800015de:	611c                	ld	a5,0(a0)
    800015e0:	0157f713          	andi	a4,a5,21
    800015e4:	05971b63          	bne	a4,s9,8000163a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015e8:	01a48a33          	add	s4,s1,s10
    800015ec:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015f0:	fb29fee3          	bgeu	s3,s2,800015ac <copyout+0x3a>
    800015f4:	894e                	mv	s2,s3
    800015f6:	bf5d                	j	800015ac <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015f8:	4501                	li	a0,0
    800015fa:	6906                	ld	s2,64(sp)
    800015fc:	7a42                	ld	s4,48(sp)
    800015fe:	6c42                	ld	s8,16(sp)
    80001600:	6ca2                	ld	s9,8(sp)
    80001602:	6d02                	ld	s10,0(sp)
    80001604:	a015                	j	80001628 <copyout+0xb6>
    80001606:	4501                	li	a0,0
}
    80001608:	8082                	ret
      return -1;
    8000160a:	557d                	li	a0,-1
    8000160c:	a831                	j	80001628 <copyout+0xb6>
    8000160e:	557d                	li	a0,-1
    80001610:	6906                	ld	s2,64(sp)
    80001612:	7a42                	ld	s4,48(sp)
    80001614:	6c42                	ld	s8,16(sp)
    80001616:	6ca2                	ld	s9,8(sp)
    80001618:	6d02                	ld	s10,0(sp)
    8000161a:	a039                	j	80001628 <copyout+0xb6>
      return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	6906                	ld	s2,64(sp)
    80001620:	7a42                	ld	s4,48(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
}
    80001628:	60e6                	ld	ra,88(sp)
    8000162a:	6446                	ld	s0,80(sp)
    8000162c:	64a6                	ld	s1,72(sp)
    8000162e:	79e2                	ld	s3,56(sp)
    80001630:	7aa2                	ld	s5,40(sp)
    80001632:	7b02                	ld	s6,32(sp)
    80001634:	6be2                	ld	s7,24(sp)
    80001636:	6125                	addi	sp,sp,96
    80001638:	8082                	ret
      return -1;
    8000163a:	557d                	li	a0,-1
    8000163c:	6906                	ld	s2,64(sp)
    8000163e:	7a42                	ld	s4,48(sp)
    80001640:	6c42                	ld	s8,16(sp)
    80001642:	6ca2                	ld	s9,8(sp)
    80001644:	6d02                	ld	s10,0(sp)
    80001646:	b7cd                	j	80001628 <copyout+0xb6>

0000000080001648 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001648:	c6a5                	beqz	a3,800016b0 <copyin+0x68>
{
    8000164a:	715d                	addi	sp,sp,-80
    8000164c:	e486                	sd	ra,72(sp)
    8000164e:	e0a2                	sd	s0,64(sp)
    80001650:	fc26                	sd	s1,56(sp)
    80001652:	f84a                	sd	s2,48(sp)
    80001654:	f44e                	sd	s3,40(sp)
    80001656:	f052                	sd	s4,32(sp)
    80001658:	ec56                	sd	s5,24(sp)
    8000165a:	e85a                	sd	s6,16(sp)
    8000165c:	e45e                	sd	s7,8(sp)
    8000165e:	e062                	sd	s8,0(sp)
    80001660:	0880                	addi	s0,sp,80
    80001662:	8b2a                	mv	s6,a0
    80001664:	8a2e                	mv	s4,a1
    80001666:	8c32                	mv	s8,a2
    80001668:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000166a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000166c:	6a85                	lui	s5,0x1
    8000166e:	a00d                	j	80001690 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001670:	018505b3          	add	a1,a0,s8
    80001674:	0004861b          	sext.w	a2,s1
    80001678:	412585b3          	sub	a1,a1,s2
    8000167c:	8552                	mv	a0,s4
    8000167e:	eb4ff0ef          	jal	80000d32 <memmove>

    len -= n;
    80001682:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001686:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001688:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000168c:	02098063          	beqz	s3,800016ac <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001690:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001694:	85ca                	mv	a1,s2
    80001696:	855a                	mv	a0,s6
    80001698:	94dff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    8000169c:	cd01                	beqz	a0,800016b4 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000169e:	418904b3          	sub	s1,s2,s8
    800016a2:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a4:	fc99f6e3          	bgeu	s3,s1,80001670 <copyin+0x28>
    800016a8:	84ce                	mv	s1,s3
    800016aa:	b7d9                	j	80001670 <copyin+0x28>
  }
  return 0;
    800016ac:	4501                	li	a0,0
    800016ae:	a021                	j	800016b6 <copyin+0x6e>
    800016b0:	4501                	li	a0,0
}
    800016b2:	8082                	ret
      return -1;
    800016b4:	557d                	li	a0,-1
}
    800016b6:	60a6                	ld	ra,72(sp)
    800016b8:	6406                	ld	s0,64(sp)
    800016ba:	74e2                	ld	s1,56(sp)
    800016bc:	7942                	ld	s2,48(sp)
    800016be:	79a2                	ld	s3,40(sp)
    800016c0:	7a02                	ld	s4,32(sp)
    800016c2:	6ae2                	ld	s5,24(sp)
    800016c4:	6b42                	ld	s6,16(sp)
    800016c6:	6ba2                	ld	s7,8(sp)
    800016c8:	6c02                	ld	s8,0(sp)
    800016ca:	6161                	addi	sp,sp,80
    800016cc:	8082                	ret

00000000800016ce <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ce:	c6dd                	beqz	a3,8000177c <copyinstr+0xae>
{
    800016d0:	715d                	addi	sp,sp,-80
    800016d2:	e486                	sd	ra,72(sp)
    800016d4:	e0a2                	sd	s0,64(sp)
    800016d6:	fc26                	sd	s1,56(sp)
    800016d8:	f84a                	sd	s2,48(sp)
    800016da:	f44e                	sd	s3,40(sp)
    800016dc:	f052                	sd	s4,32(sp)
    800016de:	ec56                	sd	s5,24(sp)
    800016e0:	e85a                	sd	s6,16(sp)
    800016e2:	e45e                	sd	s7,8(sp)
    800016e4:	0880                	addi	s0,sp,80
    800016e6:	8a2a                	mv	s4,a0
    800016e8:	8b2e                	mv	s6,a1
    800016ea:	8bb2                	mv	s7,a2
    800016ec:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ee:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016f0:	6985                	lui	s3,0x1
    800016f2:	a825                	j	8000172a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016f4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016f8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016fa:	37fd                	addiw	a5,a5,-1
    800016fc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001700:	60a6                	ld	ra,72(sp)
    80001702:	6406                	ld	s0,64(sp)
    80001704:	74e2                	ld	s1,56(sp)
    80001706:	7942                	ld	s2,48(sp)
    80001708:	79a2                	ld	s3,40(sp)
    8000170a:	7a02                	ld	s4,32(sp)
    8000170c:	6ae2                	ld	s5,24(sp)
    8000170e:	6b42                	ld	s6,16(sp)
    80001710:	6ba2                	ld	s7,8(sp)
    80001712:	6161                	addi	sp,sp,80
    80001714:	8082                	ret
    80001716:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000171a:	9742                	add	a4,a4,a6
      --max;
    8000171c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001720:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001724:	04e58463          	beq	a1,a4,8000176c <copyinstr+0x9e>
{
    80001728:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000172a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000172e:	85a6                	mv	a1,s1
    80001730:	8552                	mv	a0,s4
    80001732:	8b3ff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    80001736:	cd0d                	beqz	a0,80001770 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001738:	417486b3          	sub	a3,s1,s7
    8000173c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000173e:	00d97363          	bgeu	s2,a3,80001744 <copyinstr+0x76>
    80001742:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001744:	955e                	add	a0,a0,s7
    80001746:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001748:	c695                	beqz	a3,80001774 <copyinstr+0xa6>
    8000174a:	87da                	mv	a5,s6
    8000174c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000174e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001752:	96da                	add	a3,a3,s6
    80001754:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001756:	00f60733          	add	a4,a2,a5
    8000175a:	00074703          	lbu	a4,0(a4)
    8000175e:	db59                	beqz	a4,800016f4 <copyinstr+0x26>
        *dst = *p;
    80001760:	00e78023          	sb	a4,0(a5)
      dst++;
    80001764:	0785                	addi	a5,a5,1
    while(n > 0){
    80001766:	fed797e3          	bne	a5,a3,80001754 <copyinstr+0x86>
    8000176a:	b775                	j	80001716 <copyinstr+0x48>
    8000176c:	4781                	li	a5,0
    8000176e:	b771                	j	800016fa <copyinstr+0x2c>
      return -1;
    80001770:	557d                	li	a0,-1
    80001772:	b779                	j	80001700 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001774:	6b85                	lui	s7,0x1
    80001776:	9ba6                	add	s7,s7,s1
    80001778:	87da                	mv	a5,s6
    8000177a:	b77d                	j	80001728 <copyinstr+0x5a>
  int got_null = 0;
    8000177c:	4781                	li	a5,0
  if(got_null){
    8000177e:	37fd                	addiw	a5,a5,-1
    80001780:	0007851b          	sext.w	a0,a5
}
    80001784:	8082                	ret

0000000080001786 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001786:	7139                	addi	sp,sp,-64
    80001788:	fc06                	sd	ra,56(sp)
    8000178a:	f822                	sd	s0,48(sp)
    8000178c:	f426                	sd	s1,40(sp)
    8000178e:	f04a                	sd	s2,32(sp)
    80001790:	ec4e                	sd	s3,24(sp)
    80001792:	e852                	sd	s4,16(sp)
    80001794:	e456                	sd	s5,8(sp)
    80001796:	e05a                	sd	s6,0(sp)
    80001798:	0080                	addi	s0,sp,64
    8000179a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000179c:	00012497          	auipc	s1,0x12
    800017a0:	46448493          	addi	s1,s1,1124 # 80013c00 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017a4:	8b26                	mv	s6,s1
    800017a6:	00874937          	lui	s2,0x874
    800017aa:	ecb90913          	addi	s2,s2,-309 # 873ecb <_entry-0x7f78c135>
    800017ae:	0932                	slli	s2,s2,0xc
    800017b0:	de390913          	addi	s2,s2,-541
    800017b4:	093a                	slli	s2,s2,0xe
    800017b6:	13590913          	addi	s2,s2,309
    800017ba:	0932                	slli	s2,s2,0xc
    800017bc:	21d90913          	addi	s2,s2,541
    800017c0:	040009b7          	lui	s3,0x4000
    800017c4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017c6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c8:	00019a97          	auipc	s5,0x19
    800017cc:	e38a8a93          	addi	s5,s5,-456 # 8001a600 <ptable>
    char *pa = kalloc();
    800017d0:	b62ff0ef          	jal	80000b32 <kalloc>
    800017d4:	862a                	mv	a2,a0
    if(pa == 0)
    800017d6:	cd15                	beqz	a0,80001812 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017d8:	416485b3          	sub	a1,s1,s6
    800017dc:	858d                	srai	a1,a1,0x3
    800017de:	032585b3          	mul	a1,a1,s2
    800017e2:	2585                	addiw	a1,a1,1
    800017e4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e8:	4719                	li	a4,6
    800017ea:	6685                	lui	a3,0x1
    800017ec:	40b985b3          	sub	a1,s3,a1
    800017f0:	8552                	mv	a0,s4
    800017f2:	8e1ff0ef          	jal	800010d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f6:	1a848493          	addi	s1,s1,424
    800017fa:	fd549be3          	bne	s1,s5,800017d0 <proc_mapstacks+0x4a>
  }
}
    800017fe:	70e2                	ld	ra,56(sp)
    80001800:	7442                	ld	s0,48(sp)
    80001802:	74a2                	ld	s1,40(sp)
    80001804:	7902                	ld	s2,32(sp)
    80001806:	69e2                	ld	s3,24(sp)
    80001808:	6a42                	ld	s4,16(sp)
    8000180a:	6aa2                	ld	s5,8(sp)
    8000180c:	6b02                	ld	s6,0(sp)
    8000180e:	6121                	addi	sp,sp,64
    80001810:	8082                	ret
      panic("kalloc");
    80001812:	00007517          	auipc	a0,0x7
    80001816:	9e650513          	addi	a0,a0,-1562 # 800081f8 <etext+0x1f8>
    8000181a:	f89fe0ef          	jal	800007a2 <panic>

000000008000181e <procinit>:
  return 1;
}
// initialize the proc table.
void
procinit(void)
{
    8000181e:	7139                	addi	sp,sp,-64
    80001820:	fc06                	sd	ra,56(sp)
    80001822:	f822                	sd	s0,48(sp)
    80001824:	f426                	sd	s1,40(sp)
    80001826:	f04a                	sd	s2,32(sp)
    80001828:	ec4e                	sd	s3,24(sp)
    8000182a:	e852                	sd	s4,16(sp)
    8000182c:	e456                	sd	s5,8(sp)
    8000182e:	e05a                	sd	s6,0(sp)
    80001830:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001832:	00007597          	auipc	a1,0x7
    80001836:	9ce58593          	addi	a1,a1,-1586 # 80008200 <etext+0x200>
    8000183a:	00012517          	auipc	a0,0x12
    8000183e:	f9650513          	addi	a0,a0,-106 # 800137d0 <pid_lock>
    80001842:	b40ff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001846:	00007597          	auipc	a1,0x7
    8000184a:	9c258593          	addi	a1,a1,-1598 # 80008208 <etext+0x208>
    8000184e:	00012517          	auipc	a0,0x12
    80001852:	f9a50513          	addi	a0,a0,-102 # 800137e8 <wait_lock>
    80001856:	b2cff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185a:	00012497          	auipc	s1,0x12
    8000185e:	3a648493          	addi	s1,s1,934 # 80013c00 <proc>
      initlock(&p->lock, "proc");
    80001862:	00007b17          	auipc	s6,0x7
    80001866:	9b6b0b13          	addi	s6,s6,-1610 # 80008218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000186a:	8aa6                	mv	s5,s1
    8000186c:	00874937          	lui	s2,0x874
    80001870:	ecb90913          	addi	s2,s2,-309 # 873ecb <_entry-0x7f78c135>
    80001874:	0932                	slli	s2,s2,0xc
    80001876:	de390913          	addi	s2,s2,-541
    8000187a:	093a                	slli	s2,s2,0xe
    8000187c:	13590913          	addi	s2,s2,309
    80001880:	0932                	slli	s2,s2,0xc
    80001882:	21d90913          	addi	s2,s2,541
    80001886:	040009b7          	lui	s3,0x4000
    8000188a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188e:	00019a17          	auipc	s4,0x19
    80001892:	d72a0a13          	addi	s4,s4,-654 # 8001a600 <ptable>
      initlock(&p->lock, "proc");
    80001896:	85da                	mv	a1,s6
    80001898:	8526                	mv	a0,s1
    8000189a:	ae8ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    8000189e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018a2:	415487b3          	sub	a5,s1,s5
    800018a6:	878d                	srai	a5,a5,0x3
    800018a8:	032787b3          	mul	a5,a5,s2
    800018ac:	2785                	addiw	a5,a5,1
    800018ae:	00d7979b          	slliw	a5,a5,0xd
    800018b2:	40f987b3          	sub	a5,s3,a5
    800018b6:	e0dc                	sd	a5,128(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	1a848493          	addi	s1,s1,424
    800018bc:	fd449de3          	bne	s1,s4,80001896 <procinit+0x78>
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6b02                	ld	s6,0(sp)
    800018d0:	6121                	addi	sp,sp,64
    800018d2:	8082                	ret

00000000800018d4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e422                	sd	s0,8(sp)
    800018d8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018da:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018dc:	2501                	sext.w	a0,a0
    800018de:	6422                	ld	s0,8(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e422                	sd	s0,8(sp)
    800018e8:	0800                	addi	s0,sp,16
    800018ea:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f0:	00012517          	auipc	a0,0x12
    800018f4:	f1050513          	addi	a0,a0,-240 # 80013800 <cpus>
    800018f8:	953e                	add	a0,a0,a5
    800018fa:	6422                	ld	s0,8(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	e426                	sd	s1,8(sp)
    80001908:	1000                	addi	s0,sp,32
  push_off();
    8000190a:	ab8ff0ef          	jal	80000bc2 <push_off>
    8000190e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001910:	2781                	sext.w	a5,a5
    80001912:	079e                	slli	a5,a5,0x7
    80001914:	00012717          	auipc	a4,0x12
    80001918:	ebc70713          	addi	a4,a4,-324 # 800137d0 <pid_lock>
    8000191c:	97ba                	add	a5,a5,a4
    8000191e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001920:	b26ff0ef          	jal	80000c46 <pop_off>
  return p;
}
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6105                	addi	sp,sp,32
    8000192e:	8082                	ret

0000000080001930 <getptable>:
{
    80001930:	715d                	addi	sp,sp,-80
    80001932:	e486                	sd	ra,72(sp)
    80001934:	e0a2                	sd	s0,64(sp)
    80001936:	fc26                	sd	s1,56(sp)
    80001938:	f84a                	sd	s2,48(sp)
    8000193a:	f44e                	sd	s3,40(sp)
    8000193c:	f052                	sd	s4,32(sp)
    8000193e:	ec56                	sd	s5,24(sp)
    80001940:	e85a                	sd	s6,16(sp)
    80001942:	e45e                	sd	s7,8(sp)
    80001944:	e062                	sd	s8,0(sp)
    80001946:	0880                	addi	s0,sp,80
  struct proc_info pi[n];
    80001948:	00251793          	slli	a5,a0,0x2
    8000194c:	97aa                	add	a5,a5,a0
    8000194e:	078e                	slli	a5,a5,0x3
    80001950:	07bd                	addi	a5,a5,15
    80001952:	9bc1                	andi	a5,a5,-16
    80001954:	40f10133          	sub	sp,sp,a5
  if (n < 1) return 0;
    80001958:	0ca05463          	blez	a0,80001a20 <getptable+0xf0>
    8000195c:	8aaa                	mv	s5,a0
    8000195e:	8c2e                	mv	s8,a1
    80001960:	8a0a                	mv	s4,sp
  acquire(&ptable.lock);
    80001962:	00019517          	auipc	a0,0x19
    80001966:	c9e50513          	addi	a0,a0,-866 # 8001a600 <ptable>
    8000196a:	a98ff0ef          	jal	80000c02 <acquire>
  for(p = proc; p < &proc[NPROC] && count < n; p++) {
    8000196e:	00012497          	auipc	s1,0x12
    80001972:	42a48493          	addi	s1,s1,1066 # 80013d98 <proc+0x198>
    80001976:	00019b17          	auipc	s6,0x19
    8000197a:	c7ab0b13          	addi	s6,s6,-902 # 8001a5f0 <proc+0x69f0>
  int count = 0;
    8000197e:	4901                	li	s2,0
      pi[count].ppid = p->parent ? p->parent->pid : -1;
    80001980:	5bfd                	li	s7,-1
    80001982:	a80d                	j	800019b4 <getptable+0x84>
    80001984:	c2d0                	sw	a2,4(a3)
      pi[count].state = p->state;
    80001986:	c698                	sw	a4,8(a3)
      safestrcpy(pi[count].name, p->name, sizeof(p->name));
    80001988:	07b1                	addi	a5,a5,12
    8000198a:	4641                	li	a2,16
    8000198c:	85ce                	mv	a1,s3
    8000198e:	00fa0533          	add	a0,s4,a5
    80001992:	c82ff0ef          	jal	80000e14 <safestrcpy>
      pi[count].sz = p->sz;
    80001996:	00291793          	slli	a5,s2,0x2
    8000199a:	97ca                	add	a5,a5,s2
    8000199c:	078e                	slli	a5,a5,0x3
    8000199e:	97d2                	add	a5,a5,s4
    800019a0:	ef09b703          	ld	a4,-272(s3)
    800019a4:	f398                	sd	a4,32(a5)
      count++;
    800019a6:	2905                	addiw	s2,s2,1
  for(p = proc; p < &proc[NPROC] && count < n; p++) {
    800019a8:	03648963          	beq	s1,s6,800019da <getptable+0xaa>
    800019ac:	1a848493          	addi	s1,s1,424
    800019b0:	03595563          	bge	s2,s5,800019da <getptable+0xaa>
    if(p->state != UNUSED) {
    800019b4:	89a6                	mv	s3,s1
    800019b6:	e804a703          	lw	a4,-384(s1)
    800019ba:	d77d                	beqz	a4,800019a8 <getptable+0x78>
      pi[count].pid = p->pid;
    800019bc:	00291793          	slli	a5,s2,0x2
    800019c0:	97ca                	add	a5,a5,s2
    800019c2:	078e                	slli	a5,a5,0x3
    800019c4:	00fa06b3          	add	a3,s4,a5
    800019c8:	e984a603          	lw	a2,-360(s1)
    800019cc:	c290                	sw	a2,0(a3)
      pi[count].ppid = p->parent ? p->parent->pid : -1;
    800019ce:	ee04b583          	ld	a1,-288(s1)
    800019d2:	865e                	mv	a2,s7
    800019d4:	d9c5                	beqz	a1,80001984 <getptable+0x54>
    800019d6:	5990                	lw	a2,48(a1)
    800019d8:	b775                	j	80001984 <getptable+0x54>
  release(&ptable.lock);
    800019da:	00019517          	auipc	a0,0x19
    800019de:	c2650513          	addi	a0,a0,-986 # 8001a600 <ptable>
    800019e2:	ab8ff0ef          	jal	80000c9a <release>
  if(copyout(myproc()->pagetable, addr, (char *)pi, count * sizeof(struct proc_info)) < 0)
    800019e6:	f1bff0ef          	jal	80001900 <myproc>
    800019ea:	00291693          	slli	a3,s2,0x2
    800019ee:	96ca                	add	a3,a3,s2
    800019f0:	068e                	slli	a3,a3,0x3
    800019f2:	8652                	mv	a2,s4
    800019f4:	85e2                	mv	a1,s8
    800019f6:	6948                	ld	a0,144(a0)
    800019f8:	b7bff0ef          	jal	80001572 <copyout>
    800019fc:	fff54513          	not	a0,a0
    80001a00:	01f5551b          	srliw	a0,a0,0x1f
}
    80001a04:	fb040113          	addi	sp,s0,-80
    80001a08:	60a6                	ld	ra,72(sp)
    80001a0a:	6406                	ld	s0,64(sp)
    80001a0c:	74e2                	ld	s1,56(sp)
    80001a0e:	7942                	ld	s2,48(sp)
    80001a10:	79a2                	ld	s3,40(sp)
    80001a12:	7a02                	ld	s4,32(sp)
    80001a14:	6ae2                	ld	s5,24(sp)
    80001a16:	6b42                	ld	s6,16(sp)
    80001a18:	6ba2                	ld	s7,8(sp)
    80001a1a:	6c02                	ld	s8,0(sp)
    80001a1c:	6161                	addi	sp,sp,80
    80001a1e:	8082                	ret
  if (n < 1) return 0;
    80001a20:	4501                	li	a0,0
    80001a22:	b7cd                	j	80001a04 <getptable+0xd4>

0000000080001a24 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a24:	1141                	addi	sp,sp,-16
    80001a26:	e406                	sd	ra,8(sp)
    80001a28:	e022                	sd	s0,0(sp)
    80001a2a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a2c:	ed5ff0ef          	jal	80001900 <myproc>
    80001a30:	a6aff0ef          	jal	80000c9a <release>

  if (first) {
    80001a34:	0000a797          	auipc	a5,0xa
    80001a38:	b9c7a783          	lw	a5,-1124(a5) # 8000b5d0 <first.1>
    80001a3c:	e799                	bnez	a5,80001a4a <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001a3e:	5ff000ef          	jal	8000283c <usertrapret>
}
    80001a42:	60a2                	ld	ra,8(sp)
    80001a44:	6402                	ld	s0,0(sp)
    80001a46:	0141                	addi	sp,sp,16
    80001a48:	8082                	ret
    fsinit(ROOTDEV);
    80001a4a:	4505                	li	a0,1
    80001a4c:	3a7010ef          	jal	800035f2 <fsinit>
    first = 0;
    80001a50:	0000a797          	auipc	a5,0xa
    80001a54:	b807a023          	sw	zero,-1152(a5) # 8000b5d0 <first.1>
    __sync_synchronize();
    80001a58:	0330000f          	fence	rw,rw
    80001a5c:	b7cd                	j	80001a3e <forkret+0x1a>

0000000080001a5e <allocpid>:
{
    80001a5e:	1101                	addi	sp,sp,-32
    80001a60:	ec06                	sd	ra,24(sp)
    80001a62:	e822                	sd	s0,16(sp)
    80001a64:	e426                	sd	s1,8(sp)
    80001a66:	e04a                	sd	s2,0(sp)
    80001a68:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a6a:	00012917          	auipc	s2,0x12
    80001a6e:	d6690913          	addi	s2,s2,-666 # 800137d0 <pid_lock>
    80001a72:	854a                	mv	a0,s2
    80001a74:	98eff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001a78:	0000a797          	auipc	a5,0xa
    80001a7c:	b5c78793          	addi	a5,a5,-1188 # 8000b5d4 <nextpid>
    80001a80:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a82:	0014871b          	addiw	a4,s1,1
    80001a86:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a88:	854a                	mv	a0,s2
    80001a8a:	a10ff0ef          	jal	80000c9a <release>
}
    80001a8e:	8526                	mv	a0,s1
    80001a90:	60e2                	ld	ra,24(sp)
    80001a92:	6442                	ld	s0,16(sp)
    80001a94:	64a2                	ld	s1,8(sp)
    80001a96:	6902                	ld	s2,0(sp)
    80001a98:	6105                	addi	sp,sp,32
    80001a9a:	8082                	ret

0000000080001a9c <update_time>:
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001aaa:	00012497          	auipc	s1,0x12
    80001aae:	15648493          	addi	s1,s1,342 # 80013c00 <proc>
    if (p->state == RUNNING) {
    80001ab2:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ab4:	00019917          	auipc	s2,0x19
    80001ab8:	b4c90913          	addi	s2,s2,-1204 # 8001a600 <ptable>
    80001abc:	a801                	j	80001acc <update_time+0x30>
    release(&p->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	9daff0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ac4:	1a848493          	addi	s1,s1,424
    80001ac8:	01248c63          	beq	s1,s2,80001ae0 <update_time+0x44>
    acquire(&p->lock);
    80001acc:	8526                	mv	a0,s1
    80001ace:	934ff0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001ad2:	4c9c                	lw	a5,24(s1)
    80001ad4:	ff3795e3          	bne	a5,s3,80001abe <update_time+0x22>
      p->rtime++;
    80001ad8:	60bc                	ld	a5,64(s1)
    80001ada:	0785                	addi	a5,a5,1
    80001adc:	e0bc                	sd	a5,64(s1)
    80001ade:	b7c5                	j	80001abe <update_time+0x22>
}
    80001ae0:	70a2                	ld	ra,40(sp)
    80001ae2:	7402                	ld	s0,32(sp)
    80001ae4:	64e2                	ld	s1,24(sp)
    80001ae6:	6942                	ld	s2,16(sp)
    80001ae8:	69a2                	ld	s3,8(sp)
    80001aea:	6145                	addi	sp,sp,48
    80001aec:	8082                	ret

0000000080001aee <proc_pagetable>:
{
    80001aee:	1101                	addi	sp,sp,-32
    80001af0:	ec06                	sd	ra,24(sp)
    80001af2:	e822                	sd	s0,16(sp)
    80001af4:	e426                	sd	s1,8(sp)
    80001af6:	e04a                	sd	s2,0(sp)
    80001af8:	1000                	addi	s0,sp,32
    80001afa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001afc:	f9aff0ef          	jal	80001296 <uvmcreate>
    80001b00:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b02:	cd05                	beqz	a0,80001b3a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b04:	4729                	li	a4,10
    80001b06:	00005697          	auipc	a3,0x5
    80001b0a:	4fa68693          	addi	a3,a3,1274 # 80007000 <_trampoline>
    80001b0e:	6605                	lui	a2,0x1
    80001b10:	040005b7          	lui	a1,0x4000
    80001b14:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b16:	05b2                	slli	a1,a1,0xc
    80001b18:	d0aff0ef          	jal	80001022 <mappages>
    80001b1c:	02054663          	bltz	a0,80001b48 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b20:	4719                	li	a4,6
    80001b22:	09893683          	ld	a3,152(s2)
    80001b26:	6605                	lui	a2,0x1
    80001b28:	020005b7          	lui	a1,0x2000
    80001b2c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b2e:	05b6                	slli	a1,a1,0xd
    80001b30:	8526                	mv	a0,s1
    80001b32:	cf0ff0ef          	jal	80001022 <mappages>
    80001b36:	00054f63          	bltz	a0,80001b54 <proc_pagetable+0x66>
}
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	60e2                	ld	ra,24(sp)
    80001b3e:	6442                	ld	s0,16(sp)
    80001b40:	64a2                	ld	s1,8(sp)
    80001b42:	6902                	ld	s2,0(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret
    uvmfree(pagetable, 0);
    80001b48:	4581                	li	a1,0
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	919ff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001b50:	4481                	li	s1,0
    80001b52:	b7e5                	j	80001b3a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b54:	4681                	li	a3,0
    80001b56:	4605                	li	a2,1
    80001b58:	040005b7          	lui	a1,0x4000
    80001b5c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b5e:	05b2                	slli	a1,a1,0xc
    80001b60:	8526                	mv	a0,s1
    80001b62:	e78ff0ef          	jal	800011da <uvmunmap>
    uvmfree(pagetable, 0);
    80001b66:	4581                	li	a1,0
    80001b68:	8526                	mv	a0,s1
    80001b6a:	8fbff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001b6e:	4481                	li	s1,0
    80001b70:	b7e9                	j	80001b3a <proc_pagetable+0x4c>

0000000080001b72 <proc_freepagetable>:
{
    80001b72:	1101                	addi	sp,sp,-32
    80001b74:	ec06                	sd	ra,24(sp)
    80001b76:	e822                	sd	s0,16(sp)
    80001b78:	e426                	sd	s1,8(sp)
    80001b7a:	e04a                	sd	s2,0(sp)
    80001b7c:	1000                	addi	s0,sp,32
    80001b7e:	84aa                	mv	s1,a0
    80001b80:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b82:	4681                	li	a3,0
    80001b84:	4605                	li	a2,1
    80001b86:	040005b7          	lui	a1,0x4000
    80001b8a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b8c:	05b2                	slli	a1,a1,0xc
    80001b8e:	e4cff0ef          	jal	800011da <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b92:	4681                	li	a3,0
    80001b94:	4605                	li	a2,1
    80001b96:	020005b7          	lui	a1,0x2000
    80001b9a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b9c:	05b6                	slli	a1,a1,0xd
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	e3aff0ef          	jal	800011da <uvmunmap>
  uvmfree(pagetable, sz);
    80001ba4:	85ca                	mv	a1,s2
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	8bdff0ef          	jal	80001464 <uvmfree>
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6902                	ld	s2,0(sp)
    80001bb4:	6105                	addi	sp,sp,32
    80001bb6:	8082                	ret

0000000080001bb8 <freeproc>:
{
    80001bb8:	1101                	addi	sp,sp,-32
    80001bba:	ec06                	sd	ra,24(sp)
    80001bbc:	e822                	sd	s0,16(sp)
    80001bbe:	e426                	sd	s1,8(sp)
    80001bc0:	1000                	addi	s0,sp,32
    80001bc2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bc4:	6d48                	ld	a0,152(a0)
    80001bc6:	c119                	beqz	a0,80001bcc <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001bc8:	e89fe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001bcc:	0804bc23          	sd	zero,152(s1)
  if(p->pagetable)
    80001bd0:	68c8                	ld	a0,144(s1)
    80001bd2:	c501                	beqz	a0,80001bda <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001bd4:	64cc                	ld	a1,136(s1)
    80001bd6:	f9dff0ef          	jal	80001b72 <proc_freepagetable>
  p->pagetable = 0;
    80001bda:	0804b823          	sd	zero,144(s1)
  p->sz = 0;
    80001bde:	0804b423          	sd	zero,136(s1)
  p->pid = 0;
    80001be2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001be6:	0604bc23          	sd	zero,120(s1)
  p->name[0] = 0;
    80001bea:	18048c23          	sb	zero,408(s1)
  p->chan = 0;
    80001bee:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bf2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bf6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bfa:	0004ac23          	sw	zero,24(s1)
  p->responded = 0;
    80001bfe:	0604a823          	sw	zero,112(s1)
  p->completetime = ticks;
    80001c02:	0000a797          	auipc	a5,0xa
    80001c06:	a9e7e783          	lwu	a5,-1378(a5) # 8000b6a0 <ticks>
    80001c0a:	e8bc                	sd	a5,80(s1)
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret

0000000080001c16 <allocproc>:
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	e04a                	sd	s2,0(sp)
    80001c20:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c22:	00012497          	auipc	s1,0x12
    80001c26:	fde48493          	addi	s1,s1,-34 # 80013c00 <proc>
    80001c2a:	00019917          	auipc	s2,0x19
    80001c2e:	9d690913          	addi	s2,s2,-1578 # 8001a600 <ptable>
    acquire(&p->lock);
    80001c32:	8526                	mv	a0,s1
    80001c34:	fcffe0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001c38:	4c9c                	lw	a5,24(s1)
    80001c3a:	cb91                	beqz	a5,80001c4e <allocproc+0x38>
      release(&p->lock);
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	85cff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c42:	1a848493          	addi	s1,s1,424
    80001c46:	ff2496e3          	bne	s1,s2,80001c32 <allocproc+0x1c>
  return 0;
    80001c4a:	4481                	li	s1,0
    80001c4c:	a8a1                	j	80001ca4 <allocproc+0x8e>
  p->pid = allocpid();
    80001c4e:	e11ff0ef          	jal	80001a5e <allocpid>
    80001c52:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c54:	4785                	li	a5,1
    80001c56:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c58:	edbfe0ef          	jal	80000b32 <kalloc>
    80001c5c:	892a                	mv	s2,a0
    80001c5e:	ecc8                	sd	a0,152(s1)
    80001c60:	c929                	beqz	a0,80001cb2 <allocproc+0x9c>
  p->pagetable = proc_pagetable(p);
    80001c62:	8526                	mv	a0,s1
    80001c64:	e8bff0ef          	jal	80001aee <proc_pagetable>
    80001c68:	892a                	mv	s2,a0
    80001c6a:	e8c8                	sd	a0,144(s1)
  if(p->pagetable == 0){
    80001c6c:	c939                	beqz	a0,80001cc2 <allocproc+0xac>
  memset(&p->context, 0, sizeof(p->context));
    80001c6e:	07000613          	li	a2,112
    80001c72:	4581                	li	a1,0
    80001c74:	0a048513          	addi	a0,s1,160
    80001c78:	85eff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001c7c:	00000797          	auipc	a5,0x0
    80001c80:	da878793          	addi	a5,a5,-600 # 80001a24 <forkret>
    80001c84:	f0dc                	sd	a5,160(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c86:	60dc                	ld	a5,128(s1)
    80001c88:	6705                	lui	a4,0x1
    80001c8a:	97ba                	add	a5,a5,a4
    80001c8c:	f4dc                	sd	a5,168(s1)
  p->ctime = ticks;
    80001c8e:	0000a797          	auipc	a5,0xa
    80001c92:	a127e783          	lwu	a5,-1518(a5) # 8000b6a0 <ticks>
    80001c96:	fc9c                	sd	a5,56(s1)
  p->completetime = 0;
    80001c98:	0404b823          	sd	zero,80(s1)
  p->priority = 0;
    80001c9c:	0404ae23          	sw	zero,92(s1)
  p->rtime=0;
    80001ca0:	0404b023          	sd	zero,64(s1)
}
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6902                	ld	s2,0(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret
    freeproc(p);
    80001cb2:	8526                	mv	a0,s1
    80001cb4:	f05ff0ef          	jal	80001bb8 <freeproc>
    release(&p->lock);
    80001cb8:	8526                	mv	a0,s1
    80001cba:	fe1fe0ef          	jal	80000c9a <release>
    return 0;
    80001cbe:	84ca                	mv	s1,s2
    80001cc0:	b7d5                	j	80001ca4 <allocproc+0x8e>
    freeproc(p);
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	ef5ff0ef          	jal	80001bb8 <freeproc>
    release(&p->lock);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	fd1fe0ef          	jal	80000c9a <release>
    return 0;
    80001cce:	84ca                	mv	s1,s2
    80001cd0:	bfd1                	j	80001ca4 <allocproc+0x8e>

0000000080001cd2 <userinit>:
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	e426                	sd	s1,8(sp)
    80001cda:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cdc:	f3bff0ef          	jal	80001c16 <allocproc>
    80001ce0:	84aa                	mv	s1,a0
  initproc = p;
    80001ce2:	0000a797          	auipc	a5,0xa
    80001ce6:	98a7b723          	sd	a0,-1650(a5) # 8000b670 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cea:	03400613          	li	a2,52
    80001cee:	0000a597          	auipc	a1,0xa
    80001cf2:	8f258593          	addi	a1,a1,-1806 # 8000b5e0 <initcode>
    80001cf6:	6948                	ld	a0,144(a0)
    80001cf8:	dc4ff0ef          	jal	800012bc <uvmfirst>
  p->sz = PGSIZE;
    80001cfc:	6785                	lui	a5,0x1
    80001cfe:	e4dc                	sd	a5,136(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d00:	6cd8                	ld	a4,152(s1)
    80001d02:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d06:	6cd8                	ld	a4,152(s1)
    80001d08:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d0a:	4641                	li	a2,16
    80001d0c:	00006597          	auipc	a1,0x6
    80001d10:	51458593          	addi	a1,a1,1300 # 80008220 <etext+0x220>
    80001d14:	19848513          	addi	a0,s1,408
    80001d18:	8fcff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001d1c:	00006517          	auipc	a0,0x6
    80001d20:	51450513          	addi	a0,a0,1300 # 80008230 <etext+0x230>
    80001d24:	1dc020ef          	jal	80003f00 <namei>
    80001d28:	18a4b823          	sd	a0,400(s1)
  p->state = RUNNABLE;
    80001d2c:	478d                	li	a5,3
    80001d2e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d30:	8526                	mv	a0,s1
    80001d32:	f69fe0ef          	jal	80000c9a <release>
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6105                	addi	sp,sp,32
    80001d3e:	8082                	ret

0000000080001d40 <growproc>:
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	e04a                	sd	s2,0(sp)
    80001d4a:	1000                	addi	s0,sp,32
    80001d4c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d4e:	bb3ff0ef          	jal	80001900 <myproc>
    80001d52:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d54:	654c                	ld	a1,136(a0)
  if(n > 0){
    80001d56:	01204c63          	bgtz	s2,80001d6e <growproc+0x2e>
  } else if(n < 0){
    80001d5a:	02094463          	bltz	s2,80001d82 <growproc+0x42>
  p->sz = sz;
    80001d5e:	e4cc                	sd	a1,136(s1)
  return 0;
    80001d60:	4501                	li	a0,0
}
    80001d62:	60e2                	ld	ra,24(sp)
    80001d64:	6442                	ld	s0,16(sp)
    80001d66:	64a2                	ld	s1,8(sp)
    80001d68:	6902                	ld	s2,0(sp)
    80001d6a:	6105                	addi	sp,sp,32
    80001d6c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d6e:	4691                	li	a3,4
    80001d70:	00b90633          	add	a2,s2,a1
    80001d74:	6948                	ld	a0,144(a0)
    80001d76:	de8ff0ef          	jal	8000135e <uvmalloc>
    80001d7a:	85aa                	mv	a1,a0
    80001d7c:	f16d                	bnez	a0,80001d5e <growproc+0x1e>
      return -1;
    80001d7e:	557d                	li	a0,-1
    80001d80:	b7cd                	j	80001d62 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d82:	00b90633          	add	a2,s2,a1
    80001d86:	6948                	ld	a0,144(a0)
    80001d88:	d92ff0ef          	jal	8000131a <uvmdealloc>
    80001d8c:	85aa                	mv	a1,a0
    80001d8e:	bfc1                	j	80001d5e <growproc+0x1e>

0000000080001d90 <fork>:
{
    80001d90:	7139                	addi	sp,sp,-64
    80001d92:	fc06                	sd	ra,56(sp)
    80001d94:	f822                	sd	s0,48(sp)
    80001d96:	f04a                	sd	s2,32(sp)
    80001d98:	e456                	sd	s5,8(sp)
    80001d9a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d9c:	b65ff0ef          	jal	80001900 <myproc>
    80001da0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001da2:	e75ff0ef          	jal	80001c16 <allocproc>
    80001da6:	10050e63          	beqz	a0,80001ec2 <fork+0x132>
    80001daa:	ec4e                	sd	s3,24(sp)
    80001dac:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dae:	088ab603          	ld	a2,136(s5)
    80001db2:	694c                	ld	a1,144(a0)
    80001db4:	090ab503          	ld	a0,144(s5)
    80001db8:	edeff0ef          	jal	80001496 <uvmcopy>
    80001dbc:	04054a63          	bltz	a0,80001e10 <fork+0x80>
    80001dc0:	f426                	sd	s1,40(sp)
    80001dc2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001dc4:	088ab783          	ld	a5,136(s5)
    80001dc8:	08f9b423          	sd	a5,136(s3)
  *(np->trapframe) = *(p->trapframe);
    80001dcc:	098ab683          	ld	a3,152(s5)
    80001dd0:	87b6                	mv	a5,a3
    80001dd2:	0989b703          	ld	a4,152(s3)
    80001dd6:	12068693          	addi	a3,a3,288
    80001dda:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dde:	6788                	ld	a0,8(a5)
    80001de0:	6b8c                	ld	a1,16(a5)
    80001de2:	6f90                	ld	a2,24(a5)
    80001de4:	01073023          	sd	a6,0(a4)
    80001de8:	e708                	sd	a0,8(a4)
    80001dea:	eb0c                	sd	a1,16(a4)
    80001dec:	ef10                	sd	a2,24(a4)
    80001dee:	02078793          	addi	a5,a5,32
    80001df2:	02070713          	addi	a4,a4,32
    80001df6:	fed792e3          	bne	a5,a3,80001dda <fork+0x4a>
  np->trapframe->a0 = 0;
    80001dfa:	0989b783          	ld	a5,152(s3)
    80001dfe:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e02:	110a8493          	addi	s1,s5,272
    80001e06:	11098913          	addi	s2,s3,272
    80001e0a:	190a8a13          	addi	s4,s5,400
    80001e0e:	a831                	j	80001e2a <fork+0x9a>
    freeproc(np);
    80001e10:	854e                	mv	a0,s3
    80001e12:	da7ff0ef          	jal	80001bb8 <freeproc>
    release(&np->lock);
    80001e16:	854e                	mv	a0,s3
    80001e18:	e83fe0ef          	jal	80000c9a <release>
    return -1;
    80001e1c:	597d                	li	s2,-1
    80001e1e:	69e2                	ld	s3,24(sp)
    80001e20:	a851                	j	80001eb4 <fork+0x124>
  for(i = 0; i < NOFILE; i++)
    80001e22:	04a1                	addi	s1,s1,8
    80001e24:	0921                	addi	s2,s2,8
    80001e26:	01448963          	beq	s1,s4,80001e38 <fork+0xa8>
    if(p->ofile[i])
    80001e2a:	6088                	ld	a0,0(s1)
    80001e2c:	d97d                	beqz	a0,80001e22 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e2e:	662020ef          	jal	80004490 <filedup>
    80001e32:	00a93023          	sd	a0,0(s2)
    80001e36:	b7f5                	j	80001e22 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001e38:	190ab503          	ld	a0,400(s5)
    80001e3c:	1b5010ef          	jal	800037f0 <idup>
    80001e40:	18a9b823          	sd	a0,400(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e44:	198a8493          	addi	s1,s5,408
    80001e48:	4641                	li	a2,16
    80001e4a:	85a6                	mv	a1,s1
    80001e4c:	19898513          	addi	a0,s3,408
    80001e50:	fc5fe0ef          	jal	80000e14 <safestrcpy>
  if (strncmp(p->name, "schedbench", sizeof(p->name)) == 0) {
    80001e54:	4641                	li	a2,16
    80001e56:	00006597          	auipc	a1,0x6
    80001e5a:	3e258593          	addi	a1,a1,994 # 80008238 <etext+0x238>
    80001e5e:	8526                	mv	a0,s1
    80001e60:	f43fe0ef          	jal	80000da2 <strncmp>
    80001e64:	e919                	bnez	a0,80001e7a <fork+0xea>
    np->is_benchmark_process = 1;
    80001e66:	4785                	li	a5,1
    80001e68:	04f9ac23          	sw	a5,88(s3)
    total_benchmark_processes++;
    80001e6c:	0000a717          	auipc	a4,0xa
    80001e70:	81c70713          	addi	a4,a4,-2020 # 8000b688 <total_benchmark_processes>
    80001e74:	431c                	lw	a5,0(a4)
    80001e76:	2785                	addiw	a5,a5,1
    80001e78:	c31c                	sw	a5,0(a4)
  pid = np->pid;
    80001e7a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001e7e:	854e                	mv	a0,s3
    80001e80:	e1bfe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001e84:	00012497          	auipc	s1,0x12
    80001e88:	96448493          	addi	s1,s1,-1692 # 800137e8 <wait_lock>
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	d75fe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001e92:	0759bc23          	sd	s5,120(s3)
  release(&wait_lock);
    80001e96:	8526                	mv	a0,s1
    80001e98:	e03fe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001e9c:	854e                	mv	a0,s3
    80001e9e:	d65fe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001ea2:	478d                	li	a5,3
    80001ea4:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001ea8:	854e                	mv	a0,s3
    80001eaa:	df1fe0ef          	jal	80000c9a <release>
  return pid;
    80001eae:	74a2                	ld	s1,40(sp)
    80001eb0:	69e2                	ld	s3,24(sp)
    80001eb2:	6a42                	ld	s4,16(sp)
}
    80001eb4:	854a                	mv	a0,s2
    80001eb6:	70e2                	ld	ra,56(sp)
    80001eb8:	7442                	ld	s0,48(sp)
    80001eba:	7902                	ld	s2,32(sp)
    80001ebc:	6aa2                	ld	s5,8(sp)
    80001ebe:	6121                	addi	sp,sp,64
    80001ec0:	8082                	ret
    return -1;
    80001ec2:	597d                	li	s2,-1
    80001ec4:	bfc5                	j	80001eb4 <fork+0x124>

0000000080001ec6 <scheduler>:
void scheduler(void) {
    80001ec6:	711d                	addi	sp,sp,-96
    80001ec8:	ec86                	sd	ra,88(sp)
    80001eca:	e8a2                	sd	s0,80(sp)
    80001ecc:	e4a6                	sd	s1,72(sp)
    80001ece:	e0ca                	sd	s2,64(sp)
    80001ed0:	fc4e                	sd	s3,56(sp)
    80001ed2:	f852                	sd	s4,48(sp)
    80001ed4:	f456                	sd	s5,40(sp)
    80001ed6:	f05a                	sd	s6,32(sp)
    80001ed8:	ec5e                	sd	s7,24(sp)
    80001eda:	e862                	sd	s8,16(sp)
    80001edc:	e466                	sd	s9,8(sp)
    80001ede:	1080                	addi	s0,sp,96
    80001ee0:	8792                	mv	a5,tp
  int id = r_tp();
    80001ee2:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ee4:	00779b13          	slli	s6,a5,0x7
    80001ee8:	00012717          	auipc	a4,0x12
    80001eec:	8e870713          	addi	a4,a4,-1816 # 800137d0 <pid_lock>
    80001ef0:	975a                	add	a4,a4,s6
    80001ef2:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &chosen->context);
    80001ef6:	00012717          	auipc	a4,0x12
    80001efa:	91270713          	addi	a4,a4,-1774 # 80013808 <cpus+0x8>
    80001efe:	9b3a                	add	s6,s6,a4
    if (sched_mode == SCHED_ROUND_ROBIN) {
    80001f00:	00009a17          	auipc	s4,0x9
    80001f04:	780a0a13          	addi	s4,s4,1920 # 8000b680 <sched_mode>
      chosen->state = RUNNING;
    80001f08:	4b91                	li	s7,4
      c->proc = chosen;
    80001f0a:	079e                	slli	a5,a5,0x7
    80001f0c:	00012a97          	auipc	s5,0x12
    80001f10:	8c4a8a93          	addi	s5,s5,-1852 # 800137d0 <pid_lock>
    80001f14:	9abe                	add	s5,s5,a5
        chosen->starttime = ticks;
    80001f16:	00009c17          	auipc	s8,0x9
    80001f1a:	78ac0c13          	addi	s8,s8,1930 # 8000b6a0 <ticks>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f1e:	00018997          	auipc	s3,0x18
    80001f22:	6e298993          	addi	s3,s3,1762 # 8001a600 <ptable>
    80001f26:	a035                	j	80001f52 <scheduler+0x8c>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f28:	00012917          	auipc	s2,0x12
    80001f2c:	cd890913          	addi	s2,s2,-808 # 80013c00 <proc>
        if (p->state == RUNNABLE) {
    80001f30:	448d                	li	s1,3
        acquire(&p->lock);
    80001f32:	854a                	mv	a0,s2
    80001f34:	ccffe0ef          	jal	80000c02 <acquire>
        if (p->state == RUNNABLE) {
    80001f38:	01892783          	lw	a5,24(s2)
    80001f3c:	0c978863          	beq	a5,s1,8000200c <scheduler+0x146>
          release(&p->lock);
    80001f40:	854a                	mv	a0,s2
    80001f42:	d59fe0ef          	jal	80000c9a <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f46:	1a890913          	addi	s2,s2,424
    80001f4a:	ff3914e3          	bne	s2,s3,80001f32 <scheduler+0x6c>
      asm volatile("wfi");
    80001f4e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f5a:	10079073          	csrw	sstatus,a5
    if (sched_mode == SCHED_ROUND_ROBIN) {
    80001f5e:	000a2783          	lw	a5,0(s4)
    80001f62:	d3f9                	beqz	a5,80001f28 <scheduler+0x62>
    else if (sched_mode == SCHED_FCFS) {
    80001f64:	4705                	li	a4,1
    80001f66:	00e78c63          	beq	a5,a4,80001f7e <scheduler+0xb8>
    else if (sched_mode == SCHED_PRIORITY) {
    80001f6a:	4709                	li	a4,2
    80001f6c:	fee791e3          	bne	a5,a4,80001f4e <scheduler+0x88>
    struct proc *chosen = 0;
    80001f70:	4901                	li	s2,0
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f72:	00012497          	auipc	s1,0x12
    80001f76:	c8e48493          	addi	s1,s1,-882 # 80013c00 <proc>
        if (p->state == RUNNABLE) {
    80001f7a:	4c8d                	li	s9,3
    80001f7c:	a095                	j	80001fe0 <scheduler+0x11a>
    struct proc *chosen = 0;
    80001f7e:	4901                	li	s2,0
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f80:	00012497          	auipc	s1,0x12
    80001f84:	c8048493          	addi	s1,s1,-896 # 80013c00 <proc>
        if (p->state == RUNNABLE) {
    80001f88:	4c8d                	li	s9,3
    80001f8a:	a821                	j	80001fa2 <scheduler+0xdc>
            release(&p->lock);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	d0dfe0ef          	jal	80000c9a <release>
    80001f92:	a021                	j	80001f9a <scheduler+0xd4>
          release(&p->lock);
    80001f94:	8526                	mv	a0,s1
    80001f96:	d05fe0ef          	jal	80000c9a <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001f9a:	1a848493          	addi	s1,s1,424
    80001f9e:	07348563          	beq	s1,s3,80002008 <scheduler+0x142>
        acquire(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	c5ffe0ef          	jal	80000c02 <acquire>
        if (p->state == RUNNABLE) {
    80001fa8:	4c9c                	lw	a5,24(s1)
    80001faa:	ff9795e3          	bne	a5,s9,80001f94 <scheduler+0xce>
          if (chosen == 0 || p->ctime < chosen->ctime) {
    80001fae:	00090c63          	beqz	s2,80001fc6 <scheduler+0x100>
    80001fb2:	7c98                	ld	a4,56(s1)
    80001fb4:	03893783          	ld	a5,56(s2)
    80001fb8:	fcf77ae3          	bgeu	a4,a5,80001f8c <scheduler+0xc6>
              release(&chosen->lock);
    80001fbc:	854a                	mv	a0,s2
    80001fbe:	cddfe0ef          	jal	80000c9a <release>
            chosen = p;
    80001fc2:	8926                	mv	s2,s1
    80001fc4:	bfd9                	j	80001f9a <scheduler+0xd4>
    80001fc6:	8926                	mv	s2,s1
    80001fc8:	bfc9                	j	80001f9a <scheduler+0xd4>
            release(&p->lock);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	ccffe0ef          	jal	80000c9a <release>
    80001fd0:	a021                	j	80001fd8 <scheduler+0x112>
          release(&p->lock);
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	cc7fe0ef          	jal	80000c9a <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001fd8:	1a848493          	addi	s1,s1,424
    80001fdc:	03348663          	beq	s1,s3,80002008 <scheduler+0x142>
        acquire(&p->lock);
    80001fe0:	8526                	mv	a0,s1
    80001fe2:	c21fe0ef          	jal	80000c02 <acquire>
        if (p->state == RUNNABLE) {
    80001fe6:	4c9c                	lw	a5,24(s1)
    80001fe8:	ff9795e3          	bne	a5,s9,80001fd2 <scheduler+0x10c>
          if (chosen == 0 || p->priority > chosen->priority) {
    80001fec:	00090c63          	beqz	s2,80002004 <scheduler+0x13e>
    80001ff0:	4cf8                	lw	a4,92(s1)
    80001ff2:	05c92783          	lw	a5,92(s2)
    80001ff6:	fce7dae3          	bge	a5,a4,80001fca <scheduler+0x104>
              release(&chosen->lock);
    80001ffa:	854a                	mv	a0,s2
    80001ffc:	c9ffe0ef          	jal	80000c9a <release>
            chosen = p;
    80002000:	8926                	mv	s2,s1
    80002002:	bfd9                	j	80001fd8 <scheduler+0x112>
    80002004:	8926                	mv	s2,s1
    80002006:	bfc9                	j	80001fd8 <scheduler+0x112>
    if (chosen) {
    80002008:	f40903e3          	beqz	s2,80001f4e <scheduler+0x88>
      chosen->state = RUNNING;
    8000200c:	01792c23          	sw	s7,24(s2)
      c->proc = chosen;
    80002010:	032ab823          	sd	s2,48(s5)
      if (chosen->starttime == 0) {
    80002014:	04893783          	ld	a5,72(s2)
    80002018:	e789                	bnez	a5,80002022 <scheduler+0x15c>
        chosen->starttime = ticks;
    8000201a:	000c6783          	lwu	a5,0(s8)
    8000201e:	04f93423          	sd	a5,72(s2)
      swtch(&c->context, &chosen->context);
    80002022:	0a090593          	addi	a1,s2,160
    80002026:	855a                	mv	a0,s6
    80002028:	76e000ef          	jal	80002796 <swtch>
      release(&chosen->lock);
    8000202c:	854a                	mv	a0,s2
    8000202e:	c6dfe0ef          	jal	80000c9a <release>
      c->proc = 0;
    80002032:	020ab823          	sd	zero,48(s5)
    80002036:	bf31                	j	80001f52 <scheduler+0x8c>

0000000080002038 <sched>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002046:	8bbff0ef          	jal	80001900 <myproc>
    8000204a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000204c:	b4dfe0ef          	jal	80000b98 <holding>
    80002050:	c92d                	beqz	a0,800020c2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002052:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002054:	2781                	sext.w	a5,a5
    80002056:	079e                	slli	a5,a5,0x7
    80002058:	00011717          	auipc	a4,0x11
    8000205c:	77870713          	addi	a4,a4,1912 # 800137d0 <pid_lock>
    80002060:	97ba                	add	a5,a5,a4
    80002062:	0a87a703          	lw	a4,168(a5)
    80002066:	4785                	li	a5,1
    80002068:	06f71363          	bne	a4,a5,800020ce <sched+0x96>
  if(p->state == RUNNING)
    8000206c:	4c98                	lw	a4,24(s1)
    8000206e:	4791                	li	a5,4
    80002070:	06f70563          	beq	a4,a5,800020da <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002074:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002078:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000207a:	e7b5                	bnez	a5,800020e6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000207c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000207e:	00011917          	auipc	s2,0x11
    80002082:	75290913          	addi	s2,s2,1874 # 800137d0 <pid_lock>
    80002086:	2781                	sext.w	a5,a5
    80002088:	079e                	slli	a5,a5,0x7
    8000208a:	97ca                	add	a5,a5,s2
    8000208c:	0ac7a983          	lw	s3,172(a5)
    80002090:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002092:	2781                	sext.w	a5,a5
    80002094:	079e                	slli	a5,a5,0x7
    80002096:	00011597          	auipc	a1,0x11
    8000209a:	77258593          	addi	a1,a1,1906 # 80013808 <cpus+0x8>
    8000209e:	95be                	add	a1,a1,a5
    800020a0:	0a048513          	addi	a0,s1,160
    800020a4:	6f2000ef          	jal	80002796 <swtch>
    800020a8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020aa:	2781                	sext.w	a5,a5
    800020ac:	079e                	slli	a5,a5,0x7
    800020ae:	993e                	add	s2,s2,a5
    800020b0:	0b392623          	sw	s3,172(s2)
}
    800020b4:	70a2                	ld	ra,40(sp)
    800020b6:	7402                	ld	s0,32(sp)
    800020b8:	64e2                	ld	s1,24(sp)
    800020ba:	6942                	ld	s2,16(sp)
    800020bc:	69a2                	ld	s3,8(sp)
    800020be:	6145                	addi	sp,sp,48
    800020c0:	8082                	ret
    panic("sched p->lock");
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	18650513          	addi	a0,a0,390 # 80008248 <etext+0x248>
    800020ca:	ed8fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	18a50513          	addi	a0,a0,394 # 80008258 <etext+0x258>
    800020d6:	eccfe0ef          	jal	800007a2 <panic>
    panic("sched running");
    800020da:	00006517          	auipc	a0,0x6
    800020de:	18e50513          	addi	a0,a0,398 # 80008268 <etext+0x268>
    800020e2:	ec0fe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    800020e6:	00006517          	auipc	a0,0x6
    800020ea:	19250513          	addi	a0,a0,402 # 80008278 <etext+0x278>
    800020ee:	eb4fe0ef          	jal	800007a2 <panic>

00000000800020f2 <yield>:
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020fc:	805ff0ef          	jal	80001900 <myproc>
    80002100:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002102:	b01fe0ef          	jal	80000c02 <acquire>
  p->state = RUNNABLE;
    80002106:	478d                	li	a5,3
    80002108:	cc9c                	sw	a5,24(s1)
  sched();
    8000210a:	f2fff0ef          	jal	80002038 <sched>
  release(&p->lock);
    8000210e:	8526                	mv	a0,s1
    80002110:	b8bfe0ef          	jal	80000c9a <release>
}
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000211e:	7179                	addi	sp,sp,-48
    80002120:	f406                	sd	ra,40(sp)
    80002122:	f022                	sd	s0,32(sp)
    80002124:	ec26                	sd	s1,24(sp)
    80002126:	e84a                	sd	s2,16(sp)
    80002128:	e44e                	sd	s3,8(sp)
    8000212a:	1800                	addi	s0,sp,48
    8000212c:	89aa                	mv	s3,a0
    8000212e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002130:	fd0ff0ef          	jal	80001900 <myproc>
    80002134:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002136:	acdfe0ef          	jal	80000c02 <acquire>
  release(lk);
    8000213a:	854a                	mv	a0,s2
    8000213c:	b5ffe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80002140:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002144:	4789                	li	a5,2
    80002146:	cc9c                	sw	a5,24(s1)

  sched();
    80002148:	ef1ff0ef          	jal	80002038 <sched>

  // Tidy up.
  p->chan = 0;
    8000214c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002150:	8526                	mv	a0,s1
    80002152:	b49fe0ef          	jal	80000c9a <release>
  acquire(lk);
    80002156:	854a                	mv	a0,s2
    80002158:	aabfe0ef          	jal	80000c02 <acquire>
}
    8000215c:	70a2                	ld	ra,40(sp)
    8000215e:	7402                	ld	s0,32(sp)
    80002160:	64e2                	ld	s1,24(sp)
    80002162:	6942                	ld	s2,16(sp)
    80002164:	69a2                	ld	s3,8(sp)
    80002166:	6145                	addi	sp,sp,48
    80002168:	8082                	ret

000000008000216a <wait_stat_internal>:
{
    8000216a:	711d                	addi	sp,sp,-96
    8000216c:	ec86                	sd	ra,88(sp)
    8000216e:	e8a2                	sd	s0,80(sp)
    80002170:	e4a6                	sd	s1,72(sp)
    80002172:	e0ca                	sd	s2,64(sp)
    80002174:	fc4e                	sd	s3,56(sp)
    80002176:	f852                	sd	s4,48(sp)
    80002178:	f456                	sd	s5,40(sp)
    8000217a:	f05a                	sd	s6,32(sp)
    8000217c:	ec5e                	sd	s7,24(sp)
    8000217e:	e862                	sd	s8,16(sp)
    80002180:	e466                	sd	s9,8(sp)
    80002182:	e06a                	sd	s10,0(sp)
    80002184:	1080                	addi	s0,sp,96
    80002186:	8c2a                	mv	s8,a0
    80002188:	8b2e                	mv	s6,a1
  struct proc *pp = myproc();
    8000218a:	f76ff0ef          	jal	80001900 <myproc>
    8000218e:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002190:	00011b97          	auipc	s7,0x11
    80002194:	658b8b93          	addi	s7,s7,1624 # 800137e8 <wait_lock>
    havekids = 0;
    80002198:	4c81                	li	s9,0
        if (p->state == ZOMBIE) {
    8000219a:	4a15                	li	s4,5
        havekids = 1;
    8000219c:	4a85                	li	s5,1
    for (p = proc; p < &proc[NPROC]; p++) {
    8000219e:	00018997          	auipc	s3,0x18
    800021a2:	46298993          	addi	s3,s3,1122 # 8001a600 <ptable>
    printf("About to sleep in wait_stat_internal\n");
    800021a6:	00006d17          	auipc	s10,0x6
    800021aa:	0ead0d13          	addi	s10,s10,234 # 80008290 <etext+0x290>
    800021ae:	a869                	j	80002248 <wait_stat_internal+0xde>
          pstats->ctime = p->ctime;
    800021b0:	7c9c                	ld	a5,56(s1)
    800021b2:	00fb3023          	sd	a5,0(s6)
          pstats->completetime = p->completetime;
    800021b6:	68bc                	ld	a5,80(s1)
    800021b8:	00fb3423          	sd	a5,8(s6)
          pstats->rtime = p->rtime;
    800021bc:	60bc                	ld	a5,64(s1)
    800021be:	00fb3823          	sd	a5,16(s6)
          pstats->turnaround_time = p->turnaround_time;
    800021c2:	70bc                	ld	a5,96(s1)
    800021c4:	00fb3c23          	sd	a5,24(s6)
          pstats->waiting_time = p->waiting_time;
    800021c8:	74bc                	ld	a5,104(s1)
    800021ca:	02fb3023          	sd	a5,32(s6)
          *status = p->xstate;
    800021ce:	54dc                	lw	a5,44(s1)
    800021d0:	00fc2023          	sw	a5,0(s8)
          int pid = p->pid;
    800021d4:	0304a903          	lw	s2,48(s1)
          release(&p->lock);  // Release here
    800021d8:	8526                	mv	a0,s1
    800021da:	ac1fe0ef          	jal	80000c9a <release>
          freeproc(p);
    800021de:	8526                	mv	a0,s1
    800021e0:	9d9ff0ef          	jal	80001bb8 <freeproc>
          release(&wait_lock);
    800021e4:	00011517          	auipc	a0,0x11
    800021e8:	60450513          	addi	a0,a0,1540 # 800137e8 <wait_lock>
    800021ec:	aaffe0ef          	jal	80000c9a <release>
}
    800021f0:	854a                	mv	a0,s2
    800021f2:	60e6                	ld	ra,88(sp)
    800021f4:	6446                	ld	s0,80(sp)
    800021f6:	64a6                	ld	s1,72(sp)
    800021f8:	6906                	ld	s2,64(sp)
    800021fa:	79e2                	ld	s3,56(sp)
    800021fc:	7a42                	ld	s4,48(sp)
    800021fe:	7aa2                	ld	s5,40(sp)
    80002200:	7b02                	ld	s6,32(sp)
    80002202:	6be2                	ld	s7,24(sp)
    80002204:	6c42                	ld	s8,16(sp)
    80002206:	6ca2                	ld	s9,8(sp)
    80002208:	6d02                	ld	s10,0(sp)
    8000220a:	6125                	addi	sp,sp,96
    8000220c:	8082                	ret
    for (p = proc; p < &proc[NPROC]; p++) {
    8000220e:	1a848493          	addi	s1,s1,424
    80002212:	03348063          	beq	s1,s3,80002232 <wait_stat_internal+0xc8>
      if (p->parent == pp) {
    80002216:	7cbc                	ld	a5,120(s1)
    80002218:	ff279be3          	bne	a5,s2,8000220e <wait_stat_internal+0xa4>
        acquire(&p->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	9e5fe0ef          	jal	80000c02 <acquire>
        if (p->state == ZOMBIE) {
    80002222:	4c9c                	lw	a5,24(s1)
    80002224:	f94786e3          	beq	a5,s4,800021b0 <wait_stat_internal+0x46>
        release(&p->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	a71fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000222e:	8756                	mv	a4,s5
    80002230:	bff9                	j	8000220e <wait_stat_internal+0xa4>
    if (!havekids || pp->killed) {
    80002232:	c705                	beqz	a4,8000225a <wait_stat_internal+0xf0>
    80002234:	02892783          	lw	a5,40(s2)
    80002238:	e38d                	bnez	a5,8000225a <wait_stat_internal+0xf0>
    printf("About to sleep in wait_stat_internal\n");
    8000223a:	856a                	mv	a0,s10
    8000223c:	a94fe0ef          	jal	800004d0 <printf>
    sleep(pp, &wait_lock);  // Wait for child to exit
    80002240:	85de                	mv	a1,s7
    80002242:	854a                	mv	a0,s2
    80002244:	edbff0ef          	jal	8000211e <sleep>
    acquire(&wait_lock);
    80002248:	855e                	mv	a0,s7
    8000224a:	9b9fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    8000224e:	8766                	mv	a4,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    80002250:	00012497          	auipc	s1,0x12
    80002254:	9b048493          	addi	s1,s1,-1616 # 80013c00 <proc>
    80002258:	bf7d                	j	80002216 <wait_stat_internal+0xac>
      release(&wait_lock);
    8000225a:	00011517          	auipc	a0,0x11
    8000225e:	58e50513          	addi	a0,a0,1422 # 800137e8 <wait_lock>
    80002262:	a39fe0ef          	jal	80000c9a <release>
      return -1;
    80002266:	597d                	li	s2,-1
    80002268:	b761                	j	800021f0 <wait_stat_internal+0x86>

000000008000226a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000226a:	7139                	addi	sp,sp,-64
    8000226c:	fc06                	sd	ra,56(sp)
    8000226e:	f822                	sd	s0,48(sp)
    80002270:	f426                	sd	s1,40(sp)
    80002272:	f04a                	sd	s2,32(sp)
    80002274:	ec4e                	sd	s3,24(sp)
    80002276:	e852                	sd	s4,16(sp)
    80002278:	e456                	sd	s5,8(sp)
    8000227a:	0080                	addi	s0,sp,64
    8000227c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000227e:	00012497          	auipc	s1,0x12
    80002282:	98248493          	addi	s1,s1,-1662 # 80013c00 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002286:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002288:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000228a:	00018917          	auipc	s2,0x18
    8000228e:	37690913          	addi	s2,s2,886 # 8001a600 <ptable>
    80002292:	a801                	j	800022a2 <wakeup+0x38>
      }
      release(&p->lock);
    80002294:	8526                	mv	a0,s1
    80002296:	a05fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000229a:	1a848493          	addi	s1,s1,424
    8000229e:	03248263          	beq	s1,s2,800022c2 <wakeup+0x58>
    if(p != myproc()){
    800022a2:	e5eff0ef          	jal	80001900 <myproc>
    800022a6:	fea48ae3          	beq	s1,a0,8000229a <wakeup+0x30>
      acquire(&p->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	957fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800022b0:	4c9c                	lw	a5,24(s1)
    800022b2:	ff3791e3          	bne	a5,s3,80002294 <wakeup+0x2a>
    800022b6:	709c                	ld	a5,32(s1)
    800022b8:	fd479ee3          	bne	a5,s4,80002294 <wakeup+0x2a>
        p->state = RUNNABLE;
    800022bc:	0154ac23          	sw	s5,24(s1)
    800022c0:	bfd1                	j	80002294 <wakeup+0x2a>
    }
  }
}
    800022c2:	70e2                	ld	ra,56(sp)
    800022c4:	7442                	ld	s0,48(sp)
    800022c6:	74a2                	ld	s1,40(sp)
    800022c8:	7902                	ld	s2,32(sp)
    800022ca:	69e2                	ld	s3,24(sp)
    800022cc:	6a42                	ld	s4,16(sp)
    800022ce:	6aa2                	ld	s5,8(sp)
    800022d0:	6121                	addi	sp,sp,64
    800022d2:	8082                	ret

00000000800022d4 <reparent>:
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	e052                	sd	s4,0(sp)
    800022e2:	1800                	addi	s0,sp,48
    800022e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e6:	00012497          	auipc	s1,0x12
    800022ea:	91a48493          	addi	s1,s1,-1766 # 80013c00 <proc>
      pp->parent = initproc;
    800022ee:	00009a17          	auipc	s4,0x9
    800022f2:	382a0a13          	addi	s4,s4,898 # 8000b670 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022f6:	00018997          	auipc	s3,0x18
    800022fa:	30a98993          	addi	s3,s3,778 # 8001a600 <ptable>
    800022fe:	a029                	j	80002308 <reparent+0x34>
    80002300:	1a848493          	addi	s1,s1,424
    80002304:	01348b63          	beq	s1,s3,8000231a <reparent+0x46>
    if(pp->parent == p){
    80002308:	7cbc                	ld	a5,120(s1)
    8000230a:	ff279be3          	bne	a5,s2,80002300 <reparent+0x2c>
      pp->parent = initproc;
    8000230e:	000a3503          	ld	a0,0(s4)
    80002312:	fca8                	sd	a0,120(s1)
      wakeup(initproc);
    80002314:	f57ff0ef          	jal	8000226a <wakeup>
    80002318:	b7e5                	j	80002300 <reparent+0x2c>
}
    8000231a:	70a2                	ld	ra,40(sp)
    8000231c:	7402                	ld	s0,32(sp)
    8000231e:	64e2                	ld	s1,24(sp)
    80002320:	6942                	ld	s2,16(sp)
    80002322:	69a2                	ld	s3,8(sp)
    80002324:	6a02                	ld	s4,0(sp)
    80002326:	6145                	addi	sp,sp,48
    80002328:	8082                	ret

000000008000232a <exit>:
{
    8000232a:	7139                	addi	sp,sp,-64
    8000232c:	fc06                	sd	ra,56(sp)
    8000232e:	f822                	sd	s0,48(sp)
    80002330:	f426                	sd	s1,40(sp)
    80002332:	f04a                	sd	s2,32(sp)
    80002334:	ec4e                	sd	s3,24(sp)
    80002336:	e852                	sd	s4,16(sp)
    80002338:	0080                	addi	s0,sp,64
    8000233a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000233c:	dc4ff0ef          	jal	80001900 <myproc>
    80002340:	892a                	mv	s2,a0
  if(p == initproc)
    80002342:	00009797          	auipc	a5,0x9
    80002346:	32e7b783          	ld	a5,814(a5) # 8000b670 <initproc>
    8000234a:	11050493          	addi	s1,a0,272
    8000234e:	19050993          	addi	s3,a0,400
    80002352:	00a78463          	beq	a5,a0,8000235a <exit+0x30>
    80002356:	e456                	sd	s5,8(sp)
    80002358:	a839                	j	80002376 <exit+0x4c>
    8000235a:	e456                	sd	s5,8(sp)
    panic("init exiting");
    8000235c:	00006517          	auipc	a0,0x6
    80002360:	f5c50513          	addi	a0,a0,-164 # 800082b8 <etext+0x2b8>
    80002364:	c3efe0ef          	jal	800007a2 <panic>
      fileclose(f);
    80002368:	16e020ef          	jal	800044d6 <fileclose>
      p->ofile[fd] = 0;
    8000236c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002370:	04a1                	addi	s1,s1,8
    80002372:	01348563          	beq	s1,s3,8000237c <exit+0x52>
    if(p->ofile[fd]){
    80002376:	6088                	ld	a0,0(s1)
    80002378:	f965                	bnez	a0,80002368 <exit+0x3e>
    8000237a:	bfdd                	j	80002370 <exit+0x46>
  begin_op();
    8000237c:	541010ef          	jal	800040bc <begin_op>
  iput(p->cwd);
    80002380:	19093503          	ld	a0,400(s2)
    80002384:	624010ef          	jal	800039a8 <iput>
  end_op();
    80002388:	59f010ef          	jal	80004126 <end_op>
  p->cwd = 0;
    8000238c:	18093823          	sd	zero,400(s2)
  acquire(&wait_lock);
    80002390:	00011517          	auipc	a0,0x11
    80002394:	45850513          	addi	a0,a0,1112 # 800137e8 <wait_lock>
    80002398:	86bfe0ef          	jal	80000c02 <acquire>
  p->completetime = ticks;
    8000239c:	00009797          	auipc	a5,0x9
    800023a0:	3047e783          	lwu	a5,772(a5) # 8000b6a0 <ticks>
    800023a4:	04f93823          	sd	a5,80(s2)
  p->turnaround_time = p->completetime - p->ctime;
    800023a8:	03893703          	ld	a4,56(s2)
    800023ac:	8f99                	sub	a5,a5,a4
    800023ae:	06f93023          	sd	a5,96(s2)
  p->waiting_time = p->turnaround_time - p->rtime;
    800023b2:	04093703          	ld	a4,64(s2)
    800023b6:	40e78733          	sub	a4,a5,a4
    800023ba:	06e93423          	sd	a4,104(s2)
  if (p->is_benchmark_process) {
    800023be:	05892683          	lw	a3,88(s2)
    800023c2:	c2a9                	beqz	a3,80002404 <exit+0xda>
    global_turnaround_time += p->turnaround_time;
    800023c4:	00009697          	auipc	a3,0x9
    800023c8:	2d468693          	addi	a3,a3,724 # 8000b698 <global_turnaround_time>
    800023cc:	6290                	ld	a2,0(a3)
    800023ce:	00c784b3          	add	s1,a5,a2
    800023d2:	e284                	sd	s1,0(a3)
    global_waiting_time += p->waiting_time;
    800023d4:	00009797          	auipc	a5,0x9
    800023d8:	2bc78793          	addi	a5,a5,700 # 8000b690 <global_waiting_time>
    800023dc:	6394                	ld	a3,0(a5)
    800023de:	00d709b3          	add	s3,a4,a3
    800023e2:	0137b023          	sd	s3,0(a5)
    completed_benchmark_processes++;
    800023e6:	00009717          	auipc	a4,0x9
    800023ea:	29e70713          	addi	a4,a4,670 # 8000b684 <completed_benchmark_processes>
    800023ee:	431c                	lw	a5,0(a4)
    800023f0:	2785                	addiw	a5,a5,1
    800023f2:	0007869b          	sext.w	a3,a5
    800023f6:	c31c                	sw	a5,0(a4)
    if (completed_benchmark_processes == total_benchmark_processes) {
    800023f8:	00009a97          	auipc	s5,0x9
    800023fc:	290aaa83          	lw	s5,656(s5) # 8000b688 <total_benchmark_processes>
    80002400:	03568f63          	beq	a3,s5,8000243e <exit+0x114>
  reparent(p);
    80002404:	854a                	mv	a0,s2
    80002406:	ecfff0ef          	jal	800022d4 <reparent>
  wakeup(p->parent);  // Wake up parent if waiting
    8000240a:	07893503          	ld	a0,120(s2)
    8000240e:	e5dff0ef          	jal	8000226a <wakeup>
  acquire(&p->lock);
    80002412:	854a                	mv	a0,s2
    80002414:	feefe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    80002418:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    8000241c:	4795                	li	a5,5
    8000241e:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002422:	00011517          	auipc	a0,0x11
    80002426:	3c650513          	addi	a0,a0,966 # 800137e8 <wait_lock>
    8000242a:	871fe0ef          	jal	80000c9a <release>
  sched();  // does not return
    8000242e:	c0bff0ef          	jal	80002038 <sched>
  panic("zombie exit"); // should never reach here
    80002432:	00006517          	auipc	a0,0x6
    80002436:	f3650513          	addi	a0,a0,-202 # 80008368 <etext+0x368>
    8000243a:	b68fe0ef          	jal	800007a2 <panic>
        printf("\n[Scheduler Benchmark Results]\n");
    8000243e:	00006517          	auipc	a0,0x6
    80002442:	e8a50513          	addi	a0,a0,-374 # 800082c8 <etext+0x2c8>
    80002446:	88afe0ef          	jal	800004d0 <printf>
        printf("Scheduler Mode: %d\n", sched_mode);
    8000244a:	00009597          	auipc	a1,0x9
    8000244e:	2365a583          	lw	a1,566(a1) # 8000b680 <sched_mode>
    80002452:	00006517          	auipc	a0,0x6
    80002456:	e9650513          	addi	a0,a0,-362 # 800082e8 <etext+0x2e8>
    8000245a:	876fe0ef          	jal	800004d0 <printf>
        int avg_ta = global_turnaround_time / total_benchmark_processes;
    8000245e:	0354d5b3          	divu	a1,s1,s5
        printf("Average Turnaround Time: %d ticks\n", avg_ta);
    80002462:	2581                	sext.w	a1,a1
    80002464:	00006517          	auipc	a0,0x6
    80002468:	e9c50513          	addi	a0,a0,-356 # 80008300 <etext+0x300>
    8000246c:	864fe0ef          	jal	800004d0 <printf>
        int avg_wait = global_waiting_time / total_benchmark_processes;
    80002470:	0359d5b3          	divu	a1,s3,s5
        printf("Average Waiting Time: %d ticks\n", avg_wait);
    80002474:	2581                	sext.w	a1,a1
    80002476:	00006517          	auipc	a0,0x6
    8000247a:	eb250513          	addi	a0,a0,-334 # 80008328 <etext+0x328>
    8000247e:	852fe0ef          	jal	800004d0 <printf>
        printf("-----------------------------\n");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	ec650513          	addi	a0,a0,-314 # 80008348 <etext+0x348>
    8000248a:	846fe0ef          	jal	800004d0 <printf>
        global_turnaround_time = 0;
    8000248e:	00009797          	auipc	a5,0x9
    80002492:	2007b523          	sd	zero,522(a5) # 8000b698 <global_turnaround_time>
        global_waiting_time = 0;
    80002496:	00009797          	auipc	a5,0x9
    8000249a:	1e07bd23          	sd	zero,506(a5) # 8000b690 <global_waiting_time>
        total_benchmark_processes = 0;
    8000249e:	00009797          	auipc	a5,0x9
    800024a2:	1e07a523          	sw	zero,490(a5) # 8000b688 <total_benchmark_processes>
        completed_benchmark_processes = 0;
    800024a6:	00009797          	auipc	a5,0x9
    800024aa:	1c07af23          	sw	zero,478(a5) # 8000b684 <completed_benchmark_processes>
    800024ae:	bf99                	j	80002404 <exit+0xda>

00000000800024b0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024b0:	7179                	addi	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	1800                	addi	s0,sp,48
    800024be:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024c0:	00011497          	auipc	s1,0x11
    800024c4:	74048493          	addi	s1,s1,1856 # 80013c00 <proc>
    800024c8:	00018997          	auipc	s3,0x18
    800024cc:	13898993          	addi	s3,s3,312 # 8001a600 <ptable>
    acquire(&p->lock);
    800024d0:	8526                	mv	a0,s1
    800024d2:	f30fe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    800024d6:	589c                	lw	a5,48(s1)
    800024d8:	01278b63          	beq	a5,s2,800024ee <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024dc:	8526                	mv	a0,s1
    800024de:	fbcfe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024e2:	1a848493          	addi	s1,s1,424
    800024e6:	ff3495e3          	bne	s1,s3,800024d0 <kill+0x20>
  }
  return -1;
    800024ea:	557d                	li	a0,-1
    800024ec:	a819                	j	80002502 <kill+0x52>
      p->killed = 1;
    800024ee:	4785                	li	a5,1
    800024f0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800024f2:	4c98                	lw	a4,24(s1)
    800024f4:	4789                	li	a5,2
    800024f6:	00f70d63          	beq	a4,a5,80002510 <kill+0x60>
      release(&p->lock);
    800024fa:	8526                	mv	a0,s1
    800024fc:	f9efe0ef          	jal	80000c9a <release>
      return 0;
    80002500:	4501                	li	a0,0
}
    80002502:	70a2                	ld	ra,40(sp)
    80002504:	7402                	ld	s0,32(sp)
    80002506:	64e2                	ld	s1,24(sp)
    80002508:	6942                	ld	s2,16(sp)
    8000250a:	69a2                	ld	s3,8(sp)
    8000250c:	6145                	addi	sp,sp,48
    8000250e:	8082                	ret
        p->state = RUNNABLE;
    80002510:	478d                	li	a5,3
    80002512:	cc9c                	sw	a5,24(s1)
    80002514:	b7dd                	j	800024fa <kill+0x4a>

0000000080002516 <setkilled>:

void
setkilled(struct proc *p)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002522:	ee0fe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    80002526:	4785                	li	a5,1
    80002528:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000252a:	8526                	mv	a0,s1
    8000252c:	f6efe0ef          	jal	80000c9a <release>
}
    80002530:	60e2                	ld	ra,24(sp)
    80002532:	6442                	ld	s0,16(sp)
    80002534:	64a2                	ld	s1,8(sp)
    80002536:	6105                	addi	sp,sp,32
    80002538:	8082                	ret

000000008000253a <killed>:

int
killed(struct proc *p)
{
    8000253a:	1101                	addi	sp,sp,-32
    8000253c:	ec06                	sd	ra,24(sp)
    8000253e:	e822                	sd	s0,16(sp)
    80002540:	e426                	sd	s1,8(sp)
    80002542:	e04a                	sd	s2,0(sp)
    80002544:	1000                	addi	s0,sp,32
    80002546:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002548:	ebafe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    8000254c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002550:	8526                	mv	a0,s1
    80002552:	f48fe0ef          	jal	80000c9a <release>
  return k;
}
    80002556:	854a                	mv	a0,s2
    80002558:	60e2                	ld	ra,24(sp)
    8000255a:	6442                	ld	s0,16(sp)
    8000255c:	64a2                	ld	s1,8(sp)
    8000255e:	6902                	ld	s2,0(sp)
    80002560:	6105                	addi	sp,sp,32
    80002562:	8082                	ret

0000000080002564 <wait>:
{
    80002564:	715d                	addi	sp,sp,-80
    80002566:	e486                	sd	ra,72(sp)
    80002568:	e0a2                	sd	s0,64(sp)
    8000256a:	fc26                	sd	s1,56(sp)
    8000256c:	f84a                	sd	s2,48(sp)
    8000256e:	f44e                	sd	s3,40(sp)
    80002570:	f052                	sd	s4,32(sp)
    80002572:	ec56                	sd	s5,24(sp)
    80002574:	e85a                	sd	s6,16(sp)
    80002576:	e45e                	sd	s7,8(sp)
    80002578:	e062                	sd	s8,0(sp)
    8000257a:	0880                	addi	s0,sp,80
    8000257c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000257e:	b82ff0ef          	jal	80001900 <myproc>
    80002582:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002584:	00011517          	auipc	a0,0x11
    80002588:	26450513          	addi	a0,a0,612 # 800137e8 <wait_lock>
    8000258c:	e76fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    80002590:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002592:	4a15                	li	s4,5
        havekids = 1;
    80002594:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002596:	00018997          	auipc	s3,0x18
    8000259a:	06a98993          	addi	s3,s3,106 # 8001a600 <ptable>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000259e:	00011c17          	auipc	s8,0x11
    800025a2:	24ac0c13          	addi	s8,s8,586 # 800137e8 <wait_lock>
    800025a6:	a871                	j	80002642 <wait+0xde>
          pid = pp->pid;
    800025a8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800025ac:	000b0c63          	beqz	s6,800025c4 <wait+0x60>
    800025b0:	4691                	li	a3,4
    800025b2:	02c48613          	addi	a2,s1,44
    800025b6:	85da                	mv	a1,s6
    800025b8:	09093503          	ld	a0,144(s2)
    800025bc:	fb7fe0ef          	jal	80001572 <copyout>
    800025c0:	02054b63          	bltz	a0,800025f6 <wait+0x92>
          freeproc(pp);
    800025c4:	8526                	mv	a0,s1
    800025c6:	df2ff0ef          	jal	80001bb8 <freeproc>
          release(&pp->lock);
    800025ca:	8526                	mv	a0,s1
    800025cc:	ecefe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    800025d0:	00011517          	auipc	a0,0x11
    800025d4:	21850513          	addi	a0,a0,536 # 800137e8 <wait_lock>
    800025d8:	ec2fe0ef          	jal	80000c9a <release>
}
    800025dc:	854e                	mv	a0,s3
    800025de:	60a6                	ld	ra,72(sp)
    800025e0:	6406                	ld	s0,64(sp)
    800025e2:	74e2                	ld	s1,56(sp)
    800025e4:	7942                	ld	s2,48(sp)
    800025e6:	79a2                	ld	s3,40(sp)
    800025e8:	7a02                	ld	s4,32(sp)
    800025ea:	6ae2                	ld	s5,24(sp)
    800025ec:	6b42                	ld	s6,16(sp)
    800025ee:	6ba2                	ld	s7,8(sp)
    800025f0:	6c02                	ld	s8,0(sp)
    800025f2:	6161                	addi	sp,sp,80
    800025f4:	8082                	ret
            release(&pp->lock);
    800025f6:	8526                	mv	a0,s1
    800025f8:	ea2fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    800025fc:	00011517          	auipc	a0,0x11
    80002600:	1ec50513          	addi	a0,a0,492 # 800137e8 <wait_lock>
    80002604:	e96fe0ef          	jal	80000c9a <release>
            return -1;
    80002608:	59fd                	li	s3,-1
    8000260a:	bfc9                	j	800025dc <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000260c:	1a848493          	addi	s1,s1,424
    80002610:	03348063          	beq	s1,s3,80002630 <wait+0xcc>
      if(pp->parent == p){
    80002614:	7cbc                	ld	a5,120(s1)
    80002616:	ff279be3          	bne	a5,s2,8000260c <wait+0xa8>
        acquire(&pp->lock);
    8000261a:	8526                	mv	a0,s1
    8000261c:	de6fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    80002620:	4c9c                	lw	a5,24(s1)
    80002622:	f94783e3          	beq	a5,s4,800025a8 <wait+0x44>
        release(&pp->lock);
    80002626:	8526                	mv	a0,s1
    80002628:	e72fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000262c:	8756                	mv	a4,s5
    8000262e:	bff9                	j	8000260c <wait+0xa8>
    if(!havekids || killed(p)){
    80002630:	cf19                	beqz	a4,8000264e <wait+0xea>
    80002632:	854a                	mv	a0,s2
    80002634:	f07ff0ef          	jal	8000253a <killed>
    80002638:	e919                	bnez	a0,8000264e <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000263a:	85e2                	mv	a1,s8
    8000263c:	854a                	mv	a0,s2
    8000263e:	ae1ff0ef          	jal	8000211e <sleep>
    havekids = 0;
    80002642:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002644:	00011497          	auipc	s1,0x11
    80002648:	5bc48493          	addi	s1,s1,1468 # 80013c00 <proc>
    8000264c:	b7e1                	j	80002614 <wait+0xb0>
      release(&wait_lock);
    8000264e:	00011517          	auipc	a0,0x11
    80002652:	19a50513          	addi	a0,a0,410 # 800137e8 <wait_lock>
    80002656:	e44fe0ef          	jal	80000c9a <release>
      return -1;
    8000265a:	59fd                	li	s3,-1
    8000265c:	b741                	j	800025dc <wait+0x78>

000000008000265e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000265e:	7179                	addi	sp,sp,-48
    80002660:	f406                	sd	ra,40(sp)
    80002662:	f022                	sd	s0,32(sp)
    80002664:	ec26                	sd	s1,24(sp)
    80002666:	e84a                	sd	s2,16(sp)
    80002668:	e44e                	sd	s3,8(sp)
    8000266a:	e052                	sd	s4,0(sp)
    8000266c:	1800                	addi	s0,sp,48
    8000266e:	84aa                	mv	s1,a0
    80002670:	892e                	mv	s2,a1
    80002672:	89b2                	mv	s3,a2
    80002674:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002676:	a8aff0ef          	jal	80001900 <myproc>
  if(user_dst){
    8000267a:	cc99                	beqz	s1,80002698 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000267c:	86d2                	mv	a3,s4
    8000267e:	864e                	mv	a2,s3
    80002680:	85ca                	mv	a1,s2
    80002682:	6948                	ld	a0,144(a0)
    80002684:	eeffe0ef          	jal	80001572 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002688:	70a2                	ld	ra,40(sp)
    8000268a:	7402                	ld	s0,32(sp)
    8000268c:	64e2                	ld	s1,24(sp)
    8000268e:	6942                	ld	s2,16(sp)
    80002690:	69a2                	ld	s3,8(sp)
    80002692:	6a02                	ld	s4,0(sp)
    80002694:	6145                	addi	sp,sp,48
    80002696:	8082                	ret
    memmove((char *)dst, src, len);
    80002698:	000a061b          	sext.w	a2,s4
    8000269c:	85ce                	mv	a1,s3
    8000269e:	854a                	mv	a0,s2
    800026a0:	e92fe0ef          	jal	80000d32 <memmove>
    return 0;
    800026a4:	8526                	mv	a0,s1
    800026a6:	b7cd                	j	80002688 <either_copyout+0x2a>

00000000800026a8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800026a8:	7179                	addi	sp,sp,-48
    800026aa:	f406                	sd	ra,40(sp)
    800026ac:	f022                	sd	s0,32(sp)
    800026ae:	ec26                	sd	s1,24(sp)
    800026b0:	e84a                	sd	s2,16(sp)
    800026b2:	e44e                	sd	s3,8(sp)
    800026b4:	e052                	sd	s4,0(sp)
    800026b6:	1800                	addi	s0,sp,48
    800026b8:	892a                	mv	s2,a0
    800026ba:	84ae                	mv	s1,a1
    800026bc:	89b2                	mv	s3,a2
    800026be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026c0:	a40ff0ef          	jal	80001900 <myproc>
  if(user_src){
    800026c4:	cc99                	beqz	s1,800026e2 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800026c6:	86d2                	mv	a3,s4
    800026c8:	864e                	mv	a2,s3
    800026ca:	85ca                	mv	a1,s2
    800026cc:	6948                	ld	a0,144(a0)
    800026ce:	f7bfe0ef          	jal	80001648 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800026d2:	70a2                	ld	ra,40(sp)
    800026d4:	7402                	ld	s0,32(sp)
    800026d6:	64e2                	ld	s1,24(sp)
    800026d8:	6942                	ld	s2,16(sp)
    800026da:	69a2                	ld	s3,8(sp)
    800026dc:	6a02                	ld	s4,0(sp)
    800026de:	6145                	addi	sp,sp,48
    800026e0:	8082                	ret
    memmove(dst, (char*)src, len);
    800026e2:	000a061b          	sext.w	a2,s4
    800026e6:	85ce                	mv	a1,s3
    800026e8:	854a                	mv	a0,s2
    800026ea:	e48fe0ef          	jal	80000d32 <memmove>
    return 0;
    800026ee:	8526                	mv	a0,s1
    800026f0:	b7cd                	j	800026d2 <either_copyin+0x2a>

00000000800026f2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800026f2:	715d                	addi	sp,sp,-80
    800026f4:	e486                	sd	ra,72(sp)
    800026f6:	e0a2                	sd	s0,64(sp)
    800026f8:	fc26                	sd	s1,56(sp)
    800026fa:	f84a                	sd	s2,48(sp)
    800026fc:	f44e                	sd	s3,40(sp)
    800026fe:	f052                	sd	s4,32(sp)
    80002700:	ec56                	sd	s5,24(sp)
    80002702:	e85a                	sd	s6,16(sp)
    80002704:	e45e                	sd	s7,8(sp)
    80002706:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	97050513          	addi	a0,a0,-1680 # 80008078 <etext+0x78>
    80002710:	dc1fd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002714:	00011497          	auipc	s1,0x11
    80002718:	68448493          	addi	s1,s1,1668 # 80013d98 <proc+0x198>
    8000271c:	00018917          	auipc	s2,0x18
    80002720:	07c90913          	addi	s2,s2,124 # 8001a798 <ptable+0x198>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002724:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002726:	00006997          	auipc	s3,0x6
    8000272a:	c5298993          	addi	s3,s3,-942 # 80008378 <etext+0x378>
    printf("%d %s %s", p->pid, state, p->name);
    8000272e:	00006a97          	auipc	s5,0x6
    80002732:	c52a8a93          	addi	s5,s5,-942 # 80008380 <etext+0x380>
    printf("\n");
    80002736:	00006a17          	auipc	s4,0x6
    8000273a:	942a0a13          	addi	s4,s4,-1726 # 80008078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000273e:	00006b97          	auipc	s7,0x6
    80002742:	192b8b93          	addi	s7,s7,402 # 800088d0 <states.0>
    80002746:	a829                	j	80002760 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002748:	e986a583          	lw	a1,-360(a3)
    8000274c:	8556                	mv	a0,s5
    8000274e:	d83fd0ef          	jal	800004d0 <printf>
    printf("\n");
    80002752:	8552                	mv	a0,s4
    80002754:	d7dfd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002758:	1a848493          	addi	s1,s1,424
    8000275c:	03248263          	beq	s1,s2,80002780 <procdump+0x8e>
    if(p->state == UNUSED)
    80002760:	86a6                	mv	a3,s1
    80002762:	e804a783          	lw	a5,-384(s1)
    80002766:	dbed                	beqz	a5,80002758 <procdump+0x66>
      state = "???";
    80002768:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000276a:	fcfb6fe3          	bltu	s6,a5,80002748 <procdump+0x56>
    8000276e:	02079713          	slli	a4,a5,0x20
    80002772:	01d75793          	srli	a5,a4,0x1d
    80002776:	97de                	add	a5,a5,s7
    80002778:	6390                	ld	a2,0(a5)
    8000277a:	f679                	bnez	a2,80002748 <procdump+0x56>
      state = "???";
    8000277c:	864e                	mv	a2,s3
    8000277e:	b7e9                	j	80002748 <procdump+0x56>
  }
}
    80002780:	60a6                	ld	ra,72(sp)
    80002782:	6406                	ld	s0,64(sp)
    80002784:	74e2                	ld	s1,56(sp)
    80002786:	7942                	ld	s2,48(sp)
    80002788:	79a2                	ld	s3,40(sp)
    8000278a:	7a02                	ld	s4,32(sp)
    8000278c:	6ae2                	ld	s5,24(sp)
    8000278e:	6b42                	ld	s6,16(sp)
    80002790:	6ba2                	ld	s7,8(sp)
    80002792:	6161                	addi	sp,sp,80
    80002794:	8082                	ret

0000000080002796 <swtch>:
    80002796:	00153023          	sd	ra,0(a0)
    8000279a:	00253423          	sd	sp,8(a0)
    8000279e:	e900                	sd	s0,16(a0)
    800027a0:	ed04                	sd	s1,24(a0)
    800027a2:	03253023          	sd	s2,32(a0)
    800027a6:	03353423          	sd	s3,40(a0)
    800027aa:	03453823          	sd	s4,48(a0)
    800027ae:	03553c23          	sd	s5,56(a0)
    800027b2:	05653023          	sd	s6,64(a0)
    800027b6:	05753423          	sd	s7,72(a0)
    800027ba:	05853823          	sd	s8,80(a0)
    800027be:	05953c23          	sd	s9,88(a0)
    800027c2:	07a53023          	sd	s10,96(a0)
    800027c6:	07b53423          	sd	s11,104(a0)
    800027ca:	0005b083          	ld	ra,0(a1)
    800027ce:	0085b103          	ld	sp,8(a1)
    800027d2:	6980                	ld	s0,16(a1)
    800027d4:	6d84                	ld	s1,24(a1)
    800027d6:	0205b903          	ld	s2,32(a1)
    800027da:	0285b983          	ld	s3,40(a1)
    800027de:	0305ba03          	ld	s4,48(a1)
    800027e2:	0385ba83          	ld	s5,56(a1)
    800027e6:	0405bb03          	ld	s6,64(a1)
    800027ea:	0485bb83          	ld	s7,72(a1)
    800027ee:	0505bc03          	ld	s8,80(a1)
    800027f2:	0585bc83          	ld	s9,88(a1)
    800027f6:	0605bd03          	ld	s10,96(a1)
    800027fa:	0685bd83          	ld	s11,104(a1)
    800027fe:	8082                	ret

0000000080002800 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002800:	1141                	addi	sp,sp,-16
    80002802:	e406                	sd	ra,8(sp)
    80002804:	e022                	sd	s0,0(sp)
    80002806:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002808:	00006597          	auipc	a1,0x6
    8000280c:	bb858593          	addi	a1,a1,-1096 # 800083c0 <etext+0x3c0>
    80002810:	0001f517          	auipc	a0,0x1f
    80002814:	80850513          	addi	a0,a0,-2040 # 80021018 <tickslock>
    80002818:	b6afe0ef          	jal	80000b82 <initlock>
}
    8000281c:	60a2                	ld	ra,8(sp)
    8000281e:	6402                	ld	s0,0(sp)
    80002820:	0141                	addi	sp,sp,16
    80002822:	8082                	ret

0000000080002824 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002824:	1141                	addi	sp,sp,-16
    80002826:	e422                	sd	s0,8(sp)
    80002828:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000282a:	00003797          	auipc	a5,0x3
    8000282e:	02678793          	addi	a5,a5,38 # 80005850 <kernelvec>
    80002832:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002836:	6422                	ld	s0,8(sp)
    80002838:	0141                	addi	sp,sp,16
    8000283a:	8082                	ret

000000008000283c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000283c:	1141                	addi	sp,sp,-16
    8000283e:	e406                	sd	ra,8(sp)
    80002840:	e022                	sd	s0,0(sp)
    80002842:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002844:	8bcff0ef          	jal	80001900 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002848:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000284c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000284e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002852:	00004697          	auipc	a3,0x4
    80002856:	7ae68693          	addi	a3,a3,1966 # 80007000 <_trampoline>
    8000285a:	00004717          	auipc	a4,0x4
    8000285e:	7a670713          	addi	a4,a4,1958 # 80007000 <_trampoline>
    80002862:	8f15                	sub	a4,a4,a3
    80002864:	040007b7          	lui	a5,0x4000
    80002868:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000286a:	07b2                	slli	a5,a5,0xc
    8000286c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000286e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002872:	6d58                	ld	a4,152(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002874:	18002673          	csrr	a2,satp
    80002878:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000287a:	6d50                	ld	a2,152(a0)
    8000287c:	6158                	ld	a4,128(a0)
    8000287e:	6585                	lui	a1,0x1
    80002880:	972e                	add	a4,a4,a1
    80002882:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002884:	6d58                	ld	a4,152(a0)
    80002886:	00000617          	auipc	a2,0x0
    8000288a:	11a60613          	addi	a2,a2,282 # 800029a0 <usertrap>
    8000288e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002890:	6d58                	ld	a4,152(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002892:	8612                	mv	a2,tp
    80002894:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002896:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000289a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000289e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028a2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800028a6:	6d58                	ld	a4,152(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028a8:	6f18                	ld	a4,24(a4)
    800028aa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800028ae:	6948                	ld	a0,144(a0)
    800028b0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800028b2:	00004717          	auipc	a4,0x4
    800028b6:	7ea70713          	addi	a4,a4,2026 # 8000709c <userret>
    800028ba:	8f15                	sub	a4,a4,a3
    800028bc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800028be:	577d                	li	a4,-1
    800028c0:	177e                	slli	a4,a4,0x3f
    800028c2:	8d59                	or	a0,a0,a4
    800028c4:	9782                	jalr	a5
}
    800028c6:	60a2                	ld	ra,8(sp)
    800028c8:	6402                	ld	s0,0(sp)
    800028ca:	0141                	addi	sp,sp,16
    800028cc:	8082                	ret

00000000800028ce <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800028ce:	1101                	addi	sp,sp,-32
    800028d0:	ec06                	sd	ra,24(sp)
    800028d2:	e822                	sd	s0,16(sp)
    800028d4:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800028d6:	ffffe0ef          	jal	800018d4 <cpuid>
    800028da:	cd11                	beqz	a0,800028f6 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800028dc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800028e0:	000f4737          	lui	a4,0xf4
    800028e4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800028e8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800028ea:	14d79073          	csrw	stimecmp,a5
}
    800028ee:	60e2                	ld	ra,24(sp)
    800028f0:	6442                	ld	s0,16(sp)
    800028f2:	6105                	addi	sp,sp,32
    800028f4:	8082                	ret
    800028f6:	e426                	sd	s1,8(sp)
    800028f8:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    800028fa:	0001e917          	auipc	s2,0x1e
    800028fe:	71e90913          	addi	s2,s2,1822 # 80021018 <tickslock>
    80002902:	854a                	mv	a0,s2
    80002904:	afefe0ef          	jal	80000c02 <acquire>
    ticks++;
    80002908:	00009497          	auipc	s1,0x9
    8000290c:	d9848493          	addi	s1,s1,-616 # 8000b6a0 <ticks>
    80002910:	409c                	lw	a5,0(s1)
    80002912:	2785                	addiw	a5,a5,1
    80002914:	c09c                	sw	a5,0(s1)
    update_time();
    80002916:	986ff0ef          	jal	80001a9c <update_time>
    wakeup(&ticks);
    8000291a:	8526                	mv	a0,s1
    8000291c:	94fff0ef          	jal	8000226a <wakeup>
    release(&tickslock);
    80002920:	854a                	mv	a0,s2
    80002922:	b78fe0ef          	jal	80000c9a <release>
    80002926:	64a2                	ld	s1,8(sp)
    80002928:	6902                	ld	s2,0(sp)
    8000292a:	bf4d                	j	800028dc <clockintr+0xe>

000000008000292c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000292c:	1101                	addi	sp,sp,-32
    8000292e:	ec06                	sd	ra,24(sp)
    80002930:	e822                	sd	s0,16(sp)
    80002932:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002934:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002938:	57fd                	li	a5,-1
    8000293a:	17fe                	slli	a5,a5,0x3f
    8000293c:	07a5                	addi	a5,a5,9
    8000293e:	00f70c63          	beq	a4,a5,80002956 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002942:	57fd                	li	a5,-1
    80002944:	17fe                	slli	a5,a5,0x3f
    80002946:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002948:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000294a:	04f70763          	beq	a4,a5,80002998 <devintr+0x6c>
  }
}
    8000294e:	60e2                	ld	ra,24(sp)
    80002950:	6442                	ld	s0,16(sp)
    80002952:	6105                	addi	sp,sp,32
    80002954:	8082                	ret
    80002956:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002958:	7a5020ef          	jal	800058fc <plic_claim>
    8000295c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000295e:	47a9                	li	a5,10
    80002960:	00f50963          	beq	a0,a5,80002972 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002964:	4785                	li	a5,1
    80002966:	00f50963          	beq	a0,a5,80002978 <devintr+0x4c>
    return 1;
    8000296a:	4505                	li	a0,1
    } else if(irq){
    8000296c:	e889                	bnez	s1,8000297e <devintr+0x52>
    8000296e:	64a2                	ld	s1,8(sp)
    80002970:	bff9                	j	8000294e <devintr+0x22>
      uartintr();
    80002972:	8a2fe0ef          	jal	80000a14 <uartintr>
    if(irq)
    80002976:	a819                	j	8000298c <devintr+0x60>
      virtio_disk_intr();
    80002978:	44a030ef          	jal	80005dc2 <virtio_disk_intr>
    if(irq)
    8000297c:	a801                	j	8000298c <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000297e:	85a6                	mv	a1,s1
    80002980:	00006517          	auipc	a0,0x6
    80002984:	a4850513          	addi	a0,a0,-1464 # 800083c8 <etext+0x3c8>
    80002988:	b49fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    8000298c:	8526                	mv	a0,s1
    8000298e:	78f020ef          	jal	8000591c <plic_complete>
    return 1;
    80002992:	4505                	li	a0,1
    80002994:	64a2                	ld	s1,8(sp)
    80002996:	bf65                	j	8000294e <devintr+0x22>
    clockintr();
    80002998:	f37ff0ef          	jal	800028ce <clockintr>
    return 2;
    8000299c:	4509                	li	a0,2
    8000299e:	bf45                	j	8000294e <devintr+0x22>

00000000800029a0 <usertrap>:
{
    800029a0:	1101                	addi	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	e426                	sd	s1,8(sp)
    800029a8:	e04a                	sd	s2,0(sp)
    800029aa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ac:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800029b0:	1007f793          	andi	a5,a5,256
    800029b4:	ef85                	bnez	a5,800029ec <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029b6:	00003797          	auipc	a5,0x3
    800029ba:	e9a78793          	addi	a5,a5,-358 # 80005850 <kernelvec>
    800029be:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800029c2:	f3ffe0ef          	jal	80001900 <myproc>
    800029c6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800029c8:	6d5c                	ld	a5,152(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029ca:	14102773          	csrr	a4,sepc
    800029ce:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029d0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800029d4:	47a1                	li	a5,8
    800029d6:	02f70163          	beq	a4,a5,800029f8 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800029da:	f53ff0ef          	jal	8000292c <devintr>
    800029de:	892a                	mv	s2,a0
    800029e0:	c135                	beqz	a0,80002a44 <usertrap+0xa4>
  if(killed(p))
    800029e2:	8526                	mv	a0,s1
    800029e4:	b57ff0ef          	jal	8000253a <killed>
    800029e8:	cd1d                	beqz	a0,80002a26 <usertrap+0x86>
    800029ea:	a81d                	j	80002a20 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800029ec:	00006517          	auipc	a0,0x6
    800029f0:	9fc50513          	addi	a0,a0,-1540 # 800083e8 <etext+0x3e8>
    800029f4:	daffd0ef          	jal	800007a2 <panic>
    if(killed(p))
    800029f8:	b43ff0ef          	jal	8000253a <killed>
    800029fc:	e121                	bnez	a0,80002a3c <usertrap+0x9c>
    p->trapframe->epc += 4;
    800029fe:	6cd8                	ld	a4,152(s1)
    80002a00:	6f1c                	ld	a5,24(a4)
    80002a02:	0791                	addi	a5,a5,4
    80002a04:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a0a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a0e:	10079073          	csrw	sstatus,a5
    syscall();
    80002a12:	24c000ef          	jal	80002c5e <syscall>
  if(killed(p))
    80002a16:	8526                	mv	a0,s1
    80002a18:	b23ff0ef          	jal	8000253a <killed>
    80002a1c:	c901                	beqz	a0,80002a2c <usertrap+0x8c>
    80002a1e:	4901                	li	s2,0
    exit(-1);
    80002a20:	557d                	li	a0,-1
    80002a22:	909ff0ef          	jal	8000232a <exit>
  if(which_dev == 2)
    80002a26:	4789                	li	a5,2
    80002a28:	04f90563          	beq	s2,a5,80002a72 <usertrap+0xd2>
  usertrapret();
    80002a2c:	e11ff0ef          	jal	8000283c <usertrapret>
}
    80002a30:	60e2                	ld	ra,24(sp)
    80002a32:	6442                	ld	s0,16(sp)
    80002a34:	64a2                	ld	s1,8(sp)
    80002a36:	6902                	ld	s2,0(sp)
    80002a38:	6105                	addi	sp,sp,32
    80002a3a:	8082                	ret
      exit(-1);
    80002a3c:	557d                	li	a0,-1
    80002a3e:	8edff0ef          	jal	8000232a <exit>
    80002a42:	bf75                	j	800029fe <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a44:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002a48:	5890                	lw	a2,48(s1)
    80002a4a:	00006517          	auipc	a0,0x6
    80002a4e:	9be50513          	addi	a0,a0,-1602 # 80008408 <etext+0x408>
    80002a52:	a7ffd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a5a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a5e:	00006517          	auipc	a0,0x6
    80002a62:	9da50513          	addi	a0,a0,-1574 # 80008438 <etext+0x438>
    80002a66:	a6bfd0ef          	jal	800004d0 <printf>
    setkilled(p);
    80002a6a:	8526                	mv	a0,s1
    80002a6c:	aabff0ef          	jal	80002516 <setkilled>
    80002a70:	b75d                	j	80002a16 <usertrap+0x76>
    yield();
    80002a72:	e80ff0ef          	jal	800020f2 <yield>
    80002a76:	bf5d                	j	80002a2c <usertrap+0x8c>

0000000080002a78 <kerneltrap>:
{
    80002a78:	7179                	addi	sp,sp,-48
    80002a7a:	f406                	sd	ra,40(sp)
    80002a7c:	f022                	sd	s0,32(sp)
    80002a7e:	ec26                	sd	s1,24(sp)
    80002a80:	e84a                	sd	s2,16(sp)
    80002a82:	e44e                	sd	s3,8(sp)
    80002a84:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a86:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a8a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a8e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a92:	1004f793          	andi	a5,s1,256
    80002a96:	c795                	beqz	a5,80002ac2 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a9c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a9e:	eb85                	bnez	a5,80002ace <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002aa0:	e8dff0ef          	jal	8000292c <devintr>
    80002aa4:	c91d                	beqz	a0,80002ada <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002aa6:	4789                	li	a5,2
    80002aa8:	04f50a63          	beq	a0,a5,80002afc <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002aac:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ab0:	10049073          	csrw	sstatus,s1
}
    80002ab4:	70a2                	ld	ra,40(sp)
    80002ab6:	7402                	ld	s0,32(sp)
    80002ab8:	64e2                	ld	s1,24(sp)
    80002aba:	6942                	ld	s2,16(sp)
    80002abc:	69a2                	ld	s3,8(sp)
    80002abe:	6145                	addi	sp,sp,48
    80002ac0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ac2:	00006517          	auipc	a0,0x6
    80002ac6:	99e50513          	addi	a0,a0,-1634 # 80008460 <etext+0x460>
    80002aca:	cd9fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002ace:	00006517          	auipc	a0,0x6
    80002ad2:	9ba50513          	addi	a0,a0,-1606 # 80008488 <etext+0x488>
    80002ad6:	ccdfd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ada:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ade:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002ae2:	85ce                	mv	a1,s3
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	9c450513          	addi	a0,a0,-1596 # 800084a8 <etext+0x4a8>
    80002aec:	9e5fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002af0:	00006517          	auipc	a0,0x6
    80002af4:	9e050513          	addi	a0,a0,-1568 # 800084d0 <etext+0x4d0>
    80002af8:	cabfd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002afc:	e05fe0ef          	jal	80001900 <myproc>
    80002b00:	d555                	beqz	a0,80002aac <kerneltrap+0x34>
    yield();
    80002b02:	df0ff0ef          	jal	800020f2 <yield>
    80002b06:	b75d                	j	80002aac <kerneltrap+0x34>

0000000080002b08 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b08:	1101                	addi	sp,sp,-32
    80002b0a:	ec06                	sd	ra,24(sp)
    80002b0c:	e822                	sd	s0,16(sp)
    80002b0e:	e426                	sd	s1,8(sp)
    80002b10:	1000                	addi	s0,sp,32
    80002b12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b14:	dedfe0ef          	jal	80001900 <myproc>
  switch (n) {
    80002b18:	4795                	li	a5,5
    80002b1a:	0497e163          	bltu	a5,s1,80002b5c <argraw+0x54>
    80002b1e:	048a                	slli	s1,s1,0x2
    80002b20:	00006717          	auipc	a4,0x6
    80002b24:	de070713          	addi	a4,a4,-544 # 80008900 <states.0+0x30>
    80002b28:	94ba                	add	s1,s1,a4
    80002b2a:	409c                	lw	a5,0(s1)
    80002b2c:	97ba                	add	a5,a5,a4
    80002b2e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b30:	6d5c                	ld	a5,152(a0)
    80002b32:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	64a2                	ld	s1,8(sp)
    80002b3a:	6105                	addi	sp,sp,32
    80002b3c:	8082                	ret
    return p->trapframe->a1;
    80002b3e:	6d5c                	ld	a5,152(a0)
    80002b40:	7fa8                	ld	a0,120(a5)
    80002b42:	bfcd                	j	80002b34 <argraw+0x2c>
    return p->trapframe->a2;
    80002b44:	6d5c                	ld	a5,152(a0)
    80002b46:	63c8                	ld	a0,128(a5)
    80002b48:	b7f5                	j	80002b34 <argraw+0x2c>
    return p->trapframe->a3;
    80002b4a:	6d5c                	ld	a5,152(a0)
    80002b4c:	67c8                	ld	a0,136(a5)
    80002b4e:	b7dd                	j	80002b34 <argraw+0x2c>
    return p->trapframe->a4;
    80002b50:	6d5c                	ld	a5,152(a0)
    80002b52:	6bc8                	ld	a0,144(a5)
    80002b54:	b7c5                	j	80002b34 <argraw+0x2c>
    return p->trapframe->a5;
    80002b56:	6d5c                	ld	a5,152(a0)
    80002b58:	6fc8                	ld	a0,152(a5)
    80002b5a:	bfe9                	j	80002b34 <argraw+0x2c>
  panic("argraw");
    80002b5c:	00006517          	auipc	a0,0x6
    80002b60:	98450513          	addi	a0,a0,-1660 # 800084e0 <etext+0x4e0>
    80002b64:	c3ffd0ef          	jal	800007a2 <panic>

0000000080002b68 <fetchaddr>:
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	e426                	sd	s1,8(sp)
    80002b70:	e04a                	sd	s2,0(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
    80002b76:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b78:	d89fe0ef          	jal	80001900 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b7c:	655c                	ld	a5,136(a0)
    80002b7e:	02f4f663          	bgeu	s1,a5,80002baa <fetchaddr+0x42>
    80002b82:	00848713          	addi	a4,s1,8
    80002b86:	02e7e463          	bltu	a5,a4,80002bae <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b8a:	46a1                	li	a3,8
    80002b8c:	8626                	mv	a2,s1
    80002b8e:	85ca                	mv	a1,s2
    80002b90:	6948                	ld	a0,144(a0)
    80002b92:	ab7fe0ef          	jal	80001648 <copyin>
    80002b96:	00a03533          	snez	a0,a0
    80002b9a:	40a00533          	neg	a0,a0
}
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6902                	ld	s2,0(sp)
    80002ba6:	6105                	addi	sp,sp,32
    80002ba8:	8082                	ret
    return -1;
    80002baa:	557d                	li	a0,-1
    80002bac:	bfcd                	j	80002b9e <fetchaddr+0x36>
    80002bae:	557d                	li	a0,-1
    80002bb0:	b7fd                	j	80002b9e <fetchaddr+0x36>

0000000080002bb2 <fetchstr>:
{
    80002bb2:	7179                	addi	sp,sp,-48
    80002bb4:	f406                	sd	ra,40(sp)
    80002bb6:	f022                	sd	s0,32(sp)
    80002bb8:	ec26                	sd	s1,24(sp)
    80002bba:	e84a                	sd	s2,16(sp)
    80002bbc:	e44e                	sd	s3,8(sp)
    80002bbe:	1800                	addi	s0,sp,48
    80002bc0:	892a                	mv	s2,a0
    80002bc2:	84ae                	mv	s1,a1
    80002bc4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bc6:	d3bfe0ef          	jal	80001900 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002bca:	86ce                	mv	a3,s3
    80002bcc:	864a                	mv	a2,s2
    80002bce:	85a6                	mv	a1,s1
    80002bd0:	6948                	ld	a0,144(a0)
    80002bd2:	afdfe0ef          	jal	800016ce <copyinstr>
    80002bd6:	00054c63          	bltz	a0,80002bee <fetchstr+0x3c>
  return strlen(buf);
    80002bda:	8526                	mv	a0,s1
    80002bdc:	a6afe0ef          	jal	80000e46 <strlen>
}
    80002be0:	70a2                	ld	ra,40(sp)
    80002be2:	7402                	ld	s0,32(sp)
    80002be4:	64e2                	ld	s1,24(sp)
    80002be6:	6942                	ld	s2,16(sp)
    80002be8:	69a2                	ld	s3,8(sp)
    80002bea:	6145                	addi	sp,sp,48
    80002bec:	8082                	ret
    return -1;
    80002bee:	557d                	li	a0,-1
    80002bf0:	bfc5                	j	80002be0 <fetchstr+0x2e>

0000000080002bf2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	1000                	addi	s0,sp,32
    80002bfc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bfe:	f0bff0ef          	jal	80002b08 <argraw>
    80002c02:	c088                	sw	a0,0(s1)
  return 0;
}
    80002c04:	4501                	li	a0,0
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	64a2                	ld	s1,8(sp)
    80002c0c:	6105                	addi	sp,sp,32
    80002c0e:	8082                	ret

0000000080002c10 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c10:	1101                	addi	sp,sp,-32
    80002c12:	ec06                	sd	ra,24(sp)
    80002c14:	e822                	sd	s0,16(sp)
    80002c16:	e426                	sd	s1,8(sp)
    80002c18:	1000                	addi	s0,sp,32
    80002c1a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c1c:	eedff0ef          	jal	80002b08 <argraw>
    80002c20:	e088                	sd	a0,0(s1)
  return 0;
}
    80002c22:	4501                	li	a0,0
    80002c24:	60e2                	ld	ra,24(sp)
    80002c26:	6442                	ld	s0,16(sp)
    80002c28:	64a2                	ld	s1,8(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c2e:	7179                	addi	sp,sp,-48
    80002c30:	f406                	sd	ra,40(sp)
    80002c32:	f022                	sd	s0,32(sp)
    80002c34:	ec26                	sd	s1,24(sp)
    80002c36:	e84a                	sd	s2,16(sp)
    80002c38:	1800                	addi	s0,sp,48
    80002c3a:	84ae                	mv	s1,a1
    80002c3c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c3e:	fd840593          	addi	a1,s0,-40
    80002c42:	fcfff0ef          	jal	80002c10 <argaddr>
  return fetchstr(addr, buf, max);
    80002c46:	864a                	mv	a2,s2
    80002c48:	85a6                	mv	a1,s1
    80002c4a:	fd843503          	ld	a0,-40(s0)
    80002c4e:	f65ff0ef          	jal	80002bb2 <fetchstr>
}
    80002c52:	70a2                	ld	ra,40(sp)
    80002c54:	7402                	ld	s0,32(sp)
    80002c56:	64e2                	ld	s1,24(sp)
    80002c58:	6942                	ld	s2,16(sp)
    80002c5a:	6145                	addi	sp,sp,48
    80002c5c:	8082                	ret

0000000080002c5e <syscall>:
[SYS_setpriority] sys_setpriority, 
};

void
syscall(void)
{
    80002c5e:	1101                	addi	sp,sp,-32
    80002c60:	ec06                	sd	ra,24(sp)
    80002c62:	e822                	sd	s0,16(sp)
    80002c64:	e426                	sd	s1,8(sp)
    80002c66:	e04a                	sd	s2,0(sp)
    80002c68:	1000                	addi	s0,sp,32
  syscall_counter++;
    80002c6a:	00009717          	auipc	a4,0x9
    80002c6e:	a3a70713          	addi	a4,a4,-1478 # 8000b6a4 <syscall_counter>
    80002c72:	431c                	lw	a5,0(a4)
    80002c74:	2785                	addiw	a5,a5,1
    80002c76:	c31c                	sw	a5,0(a4)
  int num;
  struct proc *p = myproc();
    80002c78:	c89fe0ef          	jal	80001900 <myproc>
    80002c7c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c7e:	09853903          	ld	s2,152(a0)
    80002c82:	0a893783          	ld	a5,168(s2)
    80002c86:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c8a:	37fd                	addiw	a5,a5,-1
    80002c8c:	4775                	li	a4,29
    80002c8e:	00f76f63          	bltu	a4,a5,80002cac <syscall+0x4e>
    80002c92:	00369713          	slli	a4,a3,0x3
    80002c96:	00006797          	auipc	a5,0x6
    80002c9a:	c8278793          	addi	a5,a5,-894 # 80008918 <syscalls>
    80002c9e:	97ba                	add	a5,a5,a4
    80002ca0:	639c                	ld	a5,0(a5)
    80002ca2:	c789                	beqz	a5,80002cac <syscall+0x4e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002ca4:	9782                	jalr	a5
    80002ca6:	06a93823          	sd	a0,112(s2)
    80002caa:	a829                	j	80002cc4 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cac:	19848613          	addi	a2,s1,408
    80002cb0:	588c                	lw	a1,48(s1)
    80002cb2:	00006517          	auipc	a0,0x6
    80002cb6:	83650513          	addi	a0,a0,-1994 # 800084e8 <etext+0x4e8>
    80002cba:	817fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cbe:	6cdc                	ld	a5,152(s1)
    80002cc0:	577d                	li	a4,-1
    80002cc2:	fbb8                	sd	a4,112(a5)
  }
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	64a2                	ld	s1,8(sp)
    80002cca:	6902                	ld	s2,0(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret

0000000080002cd0 <sys_schedstats>:
  uint64 waiting_time;
};


uint64
sys_schedstats(void) {
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	1000                	addi	s0,sp,32
  int mode;
  if (argint(0, &mode) < 0)
    80002cd8:	fec40593          	addi	a1,s0,-20
    80002cdc:	4501                	li	a0,0
    80002cde:	f15ff0ef          	jal	80002bf2 <argint>
    80002ce2:	06054d63          	bltz	a0,80002d5c <sys_schedstats+0x8c>
      return -1;
  if (mode < 0 || mode > 2)
    80002ce6:	fec42783          	lw	a5,-20(s0)
    80002cea:	0007869b          	sext.w	a3,a5
    80002cee:	4709                	li	a4,2
      return -1;
    80002cf0:	557d                	li	a0,-1
  if (mode < 0 || mode > 2)
    80002cf2:	04d76963          	bltu	a4,a3,80002d44 <sys_schedstats+0x74>

  sched_mode = mode; 
    80002cf6:	00009717          	auipc	a4,0x9
    80002cfa:	98f72523          	sw	a5,-1654(a4) # 8000b680 <sched_mode>

global_turnaround_time = 0;
    80002cfe:	00009717          	auipc	a4,0x9
    80002d02:	98073d23          	sd	zero,-1638(a4) # 8000b698 <global_turnaround_time>
global_waiting_time = 0;
    80002d06:	00009717          	auipc	a4,0x9
    80002d0a:	98073523          	sd	zero,-1654(a4) # 8000b690 <global_waiting_time>
total_benchmark_processes = 0;
    80002d0e:	00009717          	auipc	a4,0x9
    80002d12:	96072d23          	sw	zero,-1670(a4) # 8000b688 <total_benchmark_processes>
completed_benchmark_processes = 0;
    80002d16:	00009717          	auipc	a4,0x9
    80002d1a:	96072723          	sw	zero,-1682(a4) # 8000b684 <completed_benchmark_processes>


  

  if (sched_mode == SCHED_ROUND_ROBIN)
    80002d1e:	cf81                	beqz	a5,80002d36 <sys_schedstats+0x66>
  {
    printf("Scheduler mode set to: Round Robin\n");
  }

  else if (sched_mode == SCHED_FCFS)
    80002d20:	4705                	li	a4,1
    80002d22:	02e78563          	beq	a5,a4,80002d4c <sys_schedstats+0x7c>
  {
    printf("Scheduler mode set to: FCFS\n");
  }
  else if (sched_mode == SCHED_PRIORITY)
  {
    printf("Scheduler mode set to: Priority\n");
    80002d26:	00006517          	auipc	a0,0x6
    80002d2a:	82a50513          	addi	a0,a0,-2006 # 80008550 <etext+0x550>
    80002d2e:	fa2fd0ef          	jal	800004d0 <printf>
  }
  else
  {
    printf("Unknown scheduler mode!\n");
  }
  return 0;
    80002d32:	4501                	li	a0,0
    80002d34:	a801                	j	80002d44 <sys_schedstats+0x74>
    printf("Scheduler mode set to: Round Robin\n");
    80002d36:	00005517          	auipc	a0,0x5
    80002d3a:	7d250513          	addi	a0,a0,2002 # 80008508 <etext+0x508>
    80002d3e:	f92fd0ef          	jal	800004d0 <printf>
  return 0;
    80002d42:	4501                	li	a0,0
}
    80002d44:	60e2                	ld	ra,24(sp)
    80002d46:	6442                	ld	s0,16(sp)
    80002d48:	6105                	addi	sp,sp,32
    80002d4a:	8082                	ret
    printf("Scheduler mode set to: FCFS\n");
    80002d4c:	00005517          	auipc	a0,0x5
    80002d50:	7e450513          	addi	a0,a0,2020 # 80008530 <etext+0x530>
    80002d54:	f7cfd0ef          	jal	800004d0 <printf>
  return 0;
    80002d58:	4501                	li	a0,0
    80002d5a:	b7ed                	j	80002d44 <sys_schedstats+0x74>
      return -1;
    80002d5c:	557d                	li	a0,-1
    80002d5e:	b7dd                	j	80002d44 <sys_schedstats+0x74>

0000000080002d60 <sys_wait_stat>:


uint64
sys_wait_stat(void)
{
    80002d60:	711d                	addi	sp,sp,-96
    80002d62:	ec86                	sd	ra,88(sp)
    80002d64:	e8a2                	sd	s0,80(sp)
    80002d66:	1080                	addi	s0,sp,96
  uint64 status_addr, perf_addr;
  struct perf p;

  if (argaddr(0, &status_addr) < 0 || argaddr(1, &perf_addr) < 0)
    80002d68:	fd840593          	addi	a1,s0,-40
    80002d6c:	4501                	li	a0,0
    80002d6e:	ea3ff0ef          	jal	80002c10 <argaddr>
    return -1;
    80002d72:	57fd                	li	a5,-1
  if (argaddr(0, &status_addr) < 0 || argaddr(1, &perf_addr) < 0)
    80002d74:	06054163          	bltz	a0,80002dd6 <sys_wait_stat+0x76>
    80002d78:	fd040593          	addi	a1,s0,-48
    80002d7c:	4505                	li	a0,1
    80002d7e:	e93ff0ef          	jal	80002c10 <argaddr>
    return -1;
    80002d82:	57fd                	li	a5,-1
  if (argaddr(0, &status_addr) < 0 || argaddr(1, &perf_addr) < 0)
    80002d84:	04054963          	bltz	a0,80002dd6 <sys_wait_stat+0x76>
    80002d88:	e4a6                	sd	s1,72(sp)

  int status;
  int ret = wait_stat_internal(&status, &p);  // helper below
    80002d8a:	fa840593          	addi	a1,s0,-88
    80002d8e:	fa440513          	addi	a0,s0,-92
    80002d92:	bd8ff0ef          	jal	8000216a <wait_stat_internal>
    80002d96:	84aa                	mv	s1,a0
  if (ret < 0)
    return -1;
    80002d98:	57fd                	li	a5,-1
  if (ret < 0)
    80002d9a:	04054663          	bltz	a0,80002de6 <sys_wait_stat+0x86>

  // Copy status and perf to user space
  if (copyout(myproc()->pagetable, status_addr, (char*)&status, sizeof(status)) < 0)
    80002d9e:	b63fe0ef          	jal	80001900 <myproc>
    80002da2:	4691                	li	a3,4
    80002da4:	fa440613          	addi	a2,s0,-92
    80002da8:	fd843583          	ld	a1,-40(s0)
    80002dac:	6948                	ld	a0,144(a0)
    80002dae:	fc4fe0ef          	jal	80001572 <copyout>
    return -1;
    80002db2:	57fd                	li	a5,-1
  if (copyout(myproc()->pagetable, status_addr, (char*)&status, sizeof(status)) < 0)
    80002db4:	02054b63          	bltz	a0,80002dea <sys_wait_stat+0x8a>
  if (copyout(myproc()->pagetable, perf_addr, (char*)&p, sizeof(p)) < 0)
    80002db8:	b49fe0ef          	jal	80001900 <myproc>
    80002dbc:	02800693          	li	a3,40
    80002dc0:	fa840613          	addi	a2,s0,-88
    80002dc4:	fd043583          	ld	a1,-48(s0)
    80002dc8:	6948                	ld	a0,144(a0)
    80002dca:	fa8fe0ef          	jal	80001572 <copyout>
    80002dce:	00054963          	bltz	a0,80002de0 <sys_wait_stat+0x80>
    return -1;

  return ret;
    80002dd2:	87a6                	mv	a5,s1
    80002dd4:	64a6                	ld	s1,72(sp)
}
    80002dd6:	853e                	mv	a0,a5
    80002dd8:	60e6                	ld	ra,88(sp)
    80002dda:	6446                	ld	s0,80(sp)
    80002ddc:	6125                	addi	sp,sp,96
    80002dde:	8082                	ret
    return -1;
    80002de0:	57fd                	li	a5,-1
    80002de2:	64a6                	ld	s1,72(sp)
    80002de4:	bfcd                	j	80002dd6 <sys_wait_stat+0x76>
    80002de6:	64a6                	ld	s1,72(sp)
    80002de8:	b7fd                	j	80002dd6 <sys_wait_stat+0x76>
    80002dea:	64a6                	ld	s1,72(sp)
    80002dec:	b7ed                	j	80002dd6 <sys_wait_stat+0x76>

0000000080002dee <sys_getptable>:

extern int getptable(int n, uint64 addr);

uint64
sys_getptable(void)
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	1000                	addi	s0,sp,32
  int n;
  uint64 addr;

  if(argint(0, &n) < 0 || argaddr(1, &addr) < 0)
    80002df6:	fec40593          	addi	a1,s0,-20
    80002dfa:	4501                	li	a0,0
    80002dfc:	df7ff0ef          	jal	80002bf2 <argint>
    return 0;
    80002e00:	4781                	li	a5,0
  if(argint(0, &n) < 0 || argaddr(1, &addr) < 0)
    80002e02:	02054163          	bltz	a0,80002e24 <sys_getptable+0x36>
    80002e06:	fe040593          	addi	a1,s0,-32
    80002e0a:	4505                	li	a0,1
    80002e0c:	e05ff0ef          	jal	80002c10 <argaddr>
    return 0;
    80002e10:	4781                	li	a5,0
  if(argint(0, &n) < 0 || argaddr(1, &addr) < 0)
    80002e12:	00054963          	bltz	a0,80002e24 <sys_getptable+0x36>

  return getptable(n, addr);
    80002e16:	fe043583          	ld	a1,-32(s0)
    80002e1a:	fec42503          	lw	a0,-20(s0)
    80002e1e:	b13fe0ef          	jal	80001930 <getptable>
    80002e22:	87aa                	mv	a5,a0
}
    80002e24:	853e                	mv	a0,a5
    80002e26:	60e2                	ld	ra,24(sp)
    80002e28:	6442                	ld	s0,16(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <sys_getppid>:

uint64
sys_getppid(void)
{
    80002e2e:	1141                	addi	sp,sp,-16
    80002e30:	e406                	sd	ra,8(sp)
    80002e32:	e022                	sd	s0,0(sp)
    80002e34:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002e36:	acbfe0ef          	jal	80001900 <myproc>
    80002e3a:	7d3c                	ld	a5,120(a0)
}
    80002e3c:	5b88                	lw	a0,48(a5)
    80002e3e:	60a2                	ld	ra,8(sp)
    80002e40:	6402                	ld	s0,0(sp)
    80002e42:	0141                	addi	sp,sp,16
    80002e44:	8082                	ret

0000000080002e46 <sys_setpriority>:

uint64
sys_setpriority(void)
{
    80002e46:	7179                	addi	sp,sp,-48
    80002e48:	f406                	sd	ra,40(sp)
    80002e4a:	f022                	sd	s0,32(sp)
    80002e4c:	1800                	addi	s0,sp,48
  int pid, priority;
  if (argint(0, &pid) < 0 || argint(1, &priority) < 0)
    80002e4e:	fdc40593          	addi	a1,s0,-36
    80002e52:	4501                	li	a0,0
    80002e54:	d9fff0ef          	jal	80002bf2 <argint>
    return -1;
    80002e58:	57fd                	li	a5,-1
  if (argint(0, &pid) < 0 || argint(1, &priority) < 0)
    80002e5a:	04054f63          	bltz	a0,80002eb8 <sys_setpriority+0x72>
    80002e5e:	fd840593          	addi	a1,s0,-40
    80002e62:	4505                	li	a0,1
    80002e64:	d8fff0ef          	jal	80002bf2 <argint>
    80002e68:	04054d63          	bltz	a0,80002ec2 <sys_setpriority+0x7c>
    80002e6c:	ec26                	sd	s1,24(sp)
    80002e6e:	e84a                	sd	s2,16(sp)

  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++) {
    80002e70:	00011497          	auipc	s1,0x11
    80002e74:	d9048493          	addi	s1,s1,-624 # 80013c00 <proc>
    80002e78:	00017917          	auipc	s2,0x17
    80002e7c:	78890913          	addi	s2,s2,1928 # 8001a600 <ptable>
    acquire(&p->lock);
    80002e80:	8526                	mv	a0,s1
    80002e82:	d81fd0ef          	jal	80000c02 <acquire>
    if (p->pid == pid) {
    80002e86:	5898                	lw	a4,48(s1)
    80002e88:	fdc42783          	lw	a5,-36(s0)
    80002e8c:	00f70d63          	beq	a4,a5,80002ea6 <sys_setpriority+0x60>
      p->priority = priority;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002e90:	8526                	mv	a0,s1
    80002e92:	e09fd0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002e96:	1a848493          	addi	s1,s1,424
    80002e9a:	ff2493e3          	bne	s1,s2,80002e80 <sys_setpriority+0x3a>
  }
  return -1; // PID not found
    80002e9e:	57fd                	li	a5,-1
    80002ea0:	64e2                	ld	s1,24(sp)
    80002ea2:	6942                	ld	s2,16(sp)
    80002ea4:	a811                	j	80002eb8 <sys_setpriority+0x72>
      p->priority = priority;
    80002ea6:	fd842783          	lw	a5,-40(s0)
    80002eaa:	ccfc                	sw	a5,92(s1)
      release(&p->lock);
    80002eac:	8526                	mv	a0,s1
    80002eae:	dedfd0ef          	jal	80000c9a <release>
      return 0;
    80002eb2:	4781                	li	a5,0
    80002eb4:	64e2                	ld	s1,24(sp)
    80002eb6:	6942                	ld	s2,16(sp)
}
    80002eb8:	853e                	mv	a0,a5
    80002eba:	70a2                	ld	ra,40(sp)
    80002ebc:	7402                	ld	s0,32(sp)
    80002ebe:	6145                	addi	sp,sp,48
    80002ec0:	8082                	ret
    return -1;
    80002ec2:	57fd                	li	a5,-1
    80002ec4:	bfd5                	j	80002eb8 <sys_setpriority+0x72>

0000000080002ec6 <sys_exit>:


uint64
sys_exit(void)
{
    80002ec6:	1101                	addi	sp,sp,-32
    80002ec8:	ec06                	sd	ra,24(sp)
    80002eca:	e822                	sd	s0,16(sp)
    80002ecc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002ece:	fec40593          	addi	a1,s0,-20
    80002ed2:	4501                	li	a0,0
    80002ed4:	d1fff0ef          	jal	80002bf2 <argint>
  exit(n);
    80002ed8:	fec42503          	lw	a0,-20(s0)
    80002edc:	c4eff0ef          	jal	8000232a <exit>
  return 0;  // not reached
}
    80002ee0:	4501                	li	a0,0
    80002ee2:	60e2                	ld	ra,24(sp)
    80002ee4:	6442                	ld	s0,16(sp)
    80002ee6:	6105                	addi	sp,sp,32
    80002ee8:	8082                	ret

0000000080002eea <sys_getpid>:

uint64
sys_getpid(void)
{
    80002eea:	1141                	addi	sp,sp,-16
    80002eec:	e406                	sd	ra,8(sp)
    80002eee:	e022                	sd	s0,0(sp)
    80002ef0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ef2:	a0ffe0ef          	jal	80001900 <myproc>
}
    80002ef6:	5908                	lw	a0,48(a0)
    80002ef8:	60a2                	ld	ra,8(sp)
    80002efa:	6402                	ld	s0,0(sp)
    80002efc:	0141                	addi	sp,sp,16
    80002efe:	8082                	ret

0000000080002f00 <sys_fork>:

uint64
sys_fork(void)
{
    80002f00:	1141                	addi	sp,sp,-16
    80002f02:	e406                	sd	ra,8(sp)
    80002f04:	e022                	sd	s0,0(sp)
    80002f06:	0800                	addi	s0,sp,16
  return fork();
    80002f08:	e89fe0ef          	jal	80001d90 <fork>
}
    80002f0c:	60a2                	ld	ra,8(sp)
    80002f0e:	6402                	ld	s0,0(sp)
    80002f10:	0141                	addi	sp,sp,16
    80002f12:	8082                	ret

0000000080002f14 <sys_wait>:

uint64
sys_wait(void)
{
    80002f14:	1101                	addi	sp,sp,-32
    80002f16:	ec06                	sd	ra,24(sp)
    80002f18:	e822                	sd	s0,16(sp)
    80002f1a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002f1c:	fe840593          	addi	a1,s0,-24
    80002f20:	4501                	li	a0,0
    80002f22:	cefff0ef          	jal	80002c10 <argaddr>
  return wait(p);
    80002f26:	fe843503          	ld	a0,-24(s0)
    80002f2a:	e3aff0ef          	jal	80002564 <wait>
}
    80002f2e:	60e2                	ld	ra,24(sp)
    80002f30:	6442                	ld	s0,16(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002f36:	7179                	addi	sp,sp,-48
    80002f38:	f406                	sd	ra,40(sp)
    80002f3a:	f022                	sd	s0,32(sp)
    80002f3c:	ec26                	sd	s1,24(sp)
    80002f3e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002f40:	fdc40593          	addi	a1,s0,-36
    80002f44:	4501                	li	a0,0
    80002f46:	cadff0ef          	jal	80002bf2 <argint>
  addr = myproc()->sz;
    80002f4a:	9b7fe0ef          	jal	80001900 <myproc>
    80002f4e:	6544                	ld	s1,136(a0)
  if(growproc(n) < 0)
    80002f50:	fdc42503          	lw	a0,-36(s0)
    80002f54:	dedfe0ef          	jal	80001d40 <growproc>
    80002f58:	00054863          	bltz	a0,80002f68 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002f5c:	8526                	mv	a0,s1
    80002f5e:	70a2                	ld	ra,40(sp)
    80002f60:	7402                	ld	s0,32(sp)
    80002f62:	64e2                	ld	s1,24(sp)
    80002f64:	6145                	addi	sp,sp,48
    80002f66:	8082                	ret
    return -1;
    80002f68:	54fd                	li	s1,-1
    80002f6a:	bfcd                	j	80002f5c <sys_sbrk+0x26>

0000000080002f6c <sys_sleep>:

uint64
sys_sleep(void)
{
    80002f6c:	7139                	addi	sp,sp,-64
    80002f6e:	fc06                	sd	ra,56(sp)
    80002f70:	f822                	sd	s0,48(sp)
    80002f72:	f04a                	sd	s2,32(sp)
    80002f74:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002f76:	fcc40593          	addi	a1,s0,-52
    80002f7a:	4501                	li	a0,0
    80002f7c:	c77ff0ef          	jal	80002bf2 <argint>
  if(n < 0)
    80002f80:	fcc42783          	lw	a5,-52(s0)
    80002f84:	0607c763          	bltz	a5,80002ff2 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002f88:	0001e517          	auipc	a0,0x1e
    80002f8c:	09050513          	addi	a0,a0,144 # 80021018 <tickslock>
    80002f90:	c73fd0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002f94:	00008917          	auipc	s2,0x8
    80002f98:	70c92903          	lw	s2,1804(s2) # 8000b6a0 <ticks>
  while(ticks - ticks0 < n){
    80002f9c:	fcc42783          	lw	a5,-52(s0)
    80002fa0:	cf8d                	beqz	a5,80002fda <sys_sleep+0x6e>
    80002fa2:	f426                	sd	s1,40(sp)
    80002fa4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002fa6:	0001e997          	auipc	s3,0x1e
    80002faa:	07298993          	addi	s3,s3,114 # 80021018 <tickslock>
    80002fae:	00008497          	auipc	s1,0x8
    80002fb2:	6f248493          	addi	s1,s1,1778 # 8000b6a0 <ticks>
    if(killed(myproc())){
    80002fb6:	94bfe0ef          	jal	80001900 <myproc>
    80002fba:	d80ff0ef          	jal	8000253a <killed>
    80002fbe:	ed0d                	bnez	a0,80002ff8 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002fc0:	85ce                	mv	a1,s3
    80002fc2:	8526                	mv	a0,s1
    80002fc4:	95aff0ef          	jal	8000211e <sleep>
  while(ticks - ticks0 < n){
    80002fc8:	409c                	lw	a5,0(s1)
    80002fca:	412787bb          	subw	a5,a5,s2
    80002fce:	fcc42703          	lw	a4,-52(s0)
    80002fd2:	fee7e2e3          	bltu	a5,a4,80002fb6 <sys_sleep+0x4a>
    80002fd6:	74a2                	ld	s1,40(sp)
    80002fd8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002fda:	0001e517          	auipc	a0,0x1e
    80002fde:	03e50513          	addi	a0,a0,62 # 80021018 <tickslock>
    80002fe2:	cb9fd0ef          	jal	80000c9a <release>
  return 0;
    80002fe6:	4501                	li	a0,0
}
    80002fe8:	70e2                	ld	ra,56(sp)
    80002fea:	7442                	ld	s0,48(sp)
    80002fec:	7902                	ld	s2,32(sp)
    80002fee:	6121                	addi	sp,sp,64
    80002ff0:	8082                	ret
    n = 0;
    80002ff2:	fc042623          	sw	zero,-52(s0)
    80002ff6:	bf49                	j	80002f88 <sys_sleep+0x1c>
      release(&tickslock);
    80002ff8:	0001e517          	auipc	a0,0x1e
    80002ffc:	02050513          	addi	a0,a0,32 # 80021018 <tickslock>
    80003000:	c9bfd0ef          	jal	80000c9a <release>
      return -1;
    80003004:	557d                	li	a0,-1
    80003006:	74a2                	ld	s1,40(sp)
    80003008:	69e2                	ld	s3,24(sp)
    8000300a:	bff9                	j	80002fe8 <sys_sleep+0x7c>

000000008000300c <sys_kill>:

uint64
sys_kill(void)
{
    8000300c:	1101                	addi	sp,sp,-32
    8000300e:	ec06                	sd	ra,24(sp)
    80003010:	e822                	sd	s0,16(sp)
    80003012:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003014:	fec40593          	addi	a1,s0,-20
    80003018:	4501                	li	a0,0
    8000301a:	bd9ff0ef          	jal	80002bf2 <argint>
  return kill(pid);
    8000301e:	fec42503          	lw	a0,-20(s0)
    80003022:	c8eff0ef          	jal	800024b0 <kill>
}
    80003026:	60e2                	ld	ra,24(sp)
    80003028:	6442                	ld	s0,16(sp)
    8000302a:	6105                	addi	sp,sp,32
    8000302c:	8082                	ret

000000008000302e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000302e:	1101                	addi	sp,sp,-32
    80003030:	ec06                	sd	ra,24(sp)
    80003032:	e822                	sd	s0,16(sp)
    80003034:	e426                	sd	s1,8(sp)
    80003036:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003038:	0001e517          	auipc	a0,0x1e
    8000303c:	fe050513          	addi	a0,a0,-32 # 80021018 <tickslock>
    80003040:	bc3fd0ef          	jal	80000c02 <acquire>
  xticks = ticks;
    80003044:	00008497          	auipc	s1,0x8
    80003048:	65c4a483          	lw	s1,1628(s1) # 8000b6a0 <ticks>
  release(&tickslock);
    8000304c:	0001e517          	auipc	a0,0x1e
    80003050:	fcc50513          	addi	a0,a0,-52 # 80021018 <tickslock>
    80003054:	c47fd0ef          	jal	80000c9a <release>
  return xticks;
}
    80003058:	02049513          	slli	a0,s1,0x20
    8000305c:	9101                	srli	a0,a0,0x20
    8000305e:	60e2                	ld	ra,24(sp)
    80003060:	6442                	ld	s0,16(sp)
    80003062:	64a2                	ld	s1,8(sp)
    80003064:	6105                	addi	sp,sp,32
    80003066:	8082                	ret

0000000080003068 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003068:	7179                	addi	sp,sp,-48
    8000306a:	f406                	sd	ra,40(sp)
    8000306c:	f022                	sd	s0,32(sp)
    8000306e:	ec26                	sd	s1,24(sp)
    80003070:	e84a                	sd	s2,16(sp)
    80003072:	e44e                	sd	s3,8(sp)
    80003074:	e052                	sd	s4,0(sp)
    80003076:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003078:	00005597          	auipc	a1,0x5
    8000307c:	50058593          	addi	a1,a1,1280 # 80008578 <etext+0x578>
    80003080:	0001e517          	auipc	a0,0x1e
    80003084:	fb050513          	addi	a0,a0,-80 # 80021030 <bcache>
    80003088:	afbfd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000308c:	00026797          	auipc	a5,0x26
    80003090:	fa478793          	addi	a5,a5,-92 # 80029030 <bcache+0x8000>
    80003094:	00026717          	auipc	a4,0x26
    80003098:	20470713          	addi	a4,a4,516 # 80029298 <bcache+0x8268>
    8000309c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800030a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800030a4:	0001e497          	auipc	s1,0x1e
    800030a8:	fa448493          	addi	s1,s1,-92 # 80021048 <bcache+0x18>
    b->next = bcache.head.next;
    800030ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800030ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800030b0:	00005a17          	auipc	s4,0x5
    800030b4:	4d0a0a13          	addi	s4,s4,1232 # 80008580 <etext+0x580>
    b->next = bcache.head.next;
    800030b8:	2b893783          	ld	a5,696(s2)
    800030bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800030be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800030c2:	85d2                	mv	a1,s4
    800030c4:	01048513          	addi	a0,s1,16
    800030c8:	248010ef          	jal	80004310 <initsleeplock>
    bcache.head.next->prev = b;
    800030cc:	2b893783          	ld	a5,696(s2)
    800030d0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800030d2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800030d6:	45848493          	addi	s1,s1,1112
    800030da:	fd349fe3          	bne	s1,s3,800030b8 <binit+0x50>
  }
}
    800030de:	70a2                	ld	ra,40(sp)
    800030e0:	7402                	ld	s0,32(sp)
    800030e2:	64e2                	ld	s1,24(sp)
    800030e4:	6942                	ld	s2,16(sp)
    800030e6:	69a2                	ld	s3,8(sp)
    800030e8:	6a02                	ld	s4,0(sp)
    800030ea:	6145                	addi	sp,sp,48
    800030ec:	8082                	ret

00000000800030ee <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030ee:	7179                	addi	sp,sp,-48
    800030f0:	f406                	sd	ra,40(sp)
    800030f2:	f022                	sd	s0,32(sp)
    800030f4:	ec26                	sd	s1,24(sp)
    800030f6:	e84a                	sd	s2,16(sp)
    800030f8:	e44e                	sd	s3,8(sp)
    800030fa:	1800                	addi	s0,sp,48
    800030fc:	892a                	mv	s2,a0
    800030fe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003100:	0001e517          	auipc	a0,0x1e
    80003104:	f3050513          	addi	a0,a0,-208 # 80021030 <bcache>
    80003108:	afbfd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000310c:	00026497          	auipc	s1,0x26
    80003110:	1dc4b483          	ld	s1,476(s1) # 800292e8 <bcache+0x82b8>
    80003114:	00026797          	auipc	a5,0x26
    80003118:	18478793          	addi	a5,a5,388 # 80029298 <bcache+0x8268>
    8000311c:	02f48b63          	beq	s1,a5,80003152 <bread+0x64>
    80003120:	873e                	mv	a4,a5
    80003122:	a021                	j	8000312a <bread+0x3c>
    80003124:	68a4                	ld	s1,80(s1)
    80003126:	02e48663          	beq	s1,a4,80003152 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000312a:	449c                	lw	a5,8(s1)
    8000312c:	ff279ce3          	bne	a5,s2,80003124 <bread+0x36>
    80003130:	44dc                	lw	a5,12(s1)
    80003132:	ff3799e3          	bne	a5,s3,80003124 <bread+0x36>
      b->refcnt++;
    80003136:	40bc                	lw	a5,64(s1)
    80003138:	2785                	addiw	a5,a5,1
    8000313a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000313c:	0001e517          	auipc	a0,0x1e
    80003140:	ef450513          	addi	a0,a0,-268 # 80021030 <bcache>
    80003144:	b57fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    80003148:	01048513          	addi	a0,s1,16
    8000314c:	1fa010ef          	jal	80004346 <acquiresleep>
      return b;
    80003150:	a889                	j	800031a2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003152:	00026497          	auipc	s1,0x26
    80003156:	18e4b483          	ld	s1,398(s1) # 800292e0 <bcache+0x82b0>
    8000315a:	00026797          	auipc	a5,0x26
    8000315e:	13e78793          	addi	a5,a5,318 # 80029298 <bcache+0x8268>
    80003162:	00f48863          	beq	s1,a5,80003172 <bread+0x84>
    80003166:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003168:	40bc                	lw	a5,64(s1)
    8000316a:	cb91                	beqz	a5,8000317e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000316c:	64a4                	ld	s1,72(s1)
    8000316e:	fee49de3          	bne	s1,a4,80003168 <bread+0x7a>
  panic("bget: no buffers");
    80003172:	00005517          	auipc	a0,0x5
    80003176:	41650513          	addi	a0,a0,1046 # 80008588 <etext+0x588>
    8000317a:	e28fd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    8000317e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003182:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003186:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000318a:	4785                	li	a5,1
    8000318c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000318e:	0001e517          	auipc	a0,0x1e
    80003192:	ea250513          	addi	a0,a0,-350 # 80021030 <bcache>
    80003196:	b05fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    8000319a:	01048513          	addi	a0,s1,16
    8000319e:	1a8010ef          	jal	80004346 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800031a2:	409c                	lw	a5,0(s1)
    800031a4:	cb89                	beqz	a5,800031b6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800031a6:	8526                	mv	a0,s1
    800031a8:	70a2                	ld	ra,40(sp)
    800031aa:	7402                	ld	s0,32(sp)
    800031ac:	64e2                	ld	s1,24(sp)
    800031ae:	6942                	ld	s2,16(sp)
    800031b0:	69a2                	ld	s3,8(sp)
    800031b2:	6145                	addi	sp,sp,48
    800031b4:	8082                	ret
    virtio_disk_rw(b, 0);
    800031b6:	4581                	li	a1,0
    800031b8:	8526                	mv	a0,s1
    800031ba:	1f7020ef          	jal	80005bb0 <virtio_disk_rw>
    b->valid = 1;
    800031be:	4785                	li	a5,1
    800031c0:	c09c                	sw	a5,0(s1)
  return b;
    800031c2:	b7d5                	j	800031a6 <bread+0xb8>

00000000800031c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800031c4:	1101                	addi	sp,sp,-32
    800031c6:	ec06                	sd	ra,24(sp)
    800031c8:	e822                	sd	s0,16(sp)
    800031ca:	e426                	sd	s1,8(sp)
    800031cc:	1000                	addi	s0,sp,32
    800031ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031d0:	0541                	addi	a0,a0,16
    800031d2:	1f2010ef          	jal	800043c4 <holdingsleep>
    800031d6:	c911                	beqz	a0,800031ea <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031d8:	4585                	li	a1,1
    800031da:	8526                	mv	a0,s1
    800031dc:	1d5020ef          	jal	80005bb0 <virtio_disk_rw>
}
    800031e0:	60e2                	ld	ra,24(sp)
    800031e2:	6442                	ld	s0,16(sp)
    800031e4:	64a2                	ld	s1,8(sp)
    800031e6:	6105                	addi	sp,sp,32
    800031e8:	8082                	ret
    panic("bwrite");
    800031ea:	00005517          	auipc	a0,0x5
    800031ee:	3b650513          	addi	a0,a0,950 # 800085a0 <etext+0x5a0>
    800031f2:	db0fd0ef          	jal	800007a2 <panic>

00000000800031f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031f6:	1101                	addi	sp,sp,-32
    800031f8:	ec06                	sd	ra,24(sp)
    800031fa:	e822                	sd	s0,16(sp)
    800031fc:	e426                	sd	s1,8(sp)
    800031fe:	e04a                	sd	s2,0(sp)
    80003200:	1000                	addi	s0,sp,32
    80003202:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003204:	01050913          	addi	s2,a0,16
    80003208:	854a                	mv	a0,s2
    8000320a:	1ba010ef          	jal	800043c4 <holdingsleep>
    8000320e:	c135                	beqz	a0,80003272 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80003210:	854a                	mv	a0,s2
    80003212:	17a010ef          	jal	8000438c <releasesleep>

  acquire(&bcache.lock);
    80003216:	0001e517          	auipc	a0,0x1e
    8000321a:	e1a50513          	addi	a0,a0,-486 # 80021030 <bcache>
    8000321e:	9e5fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80003222:	40bc                	lw	a5,64(s1)
    80003224:	37fd                	addiw	a5,a5,-1
    80003226:	0007871b          	sext.w	a4,a5
    8000322a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000322c:	e71d                	bnez	a4,8000325a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000322e:	68b8                	ld	a4,80(s1)
    80003230:	64bc                	ld	a5,72(s1)
    80003232:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003234:	68b8                	ld	a4,80(s1)
    80003236:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003238:	00026797          	auipc	a5,0x26
    8000323c:	df878793          	addi	a5,a5,-520 # 80029030 <bcache+0x8000>
    80003240:	2b87b703          	ld	a4,696(a5)
    80003244:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003246:	00026717          	auipc	a4,0x26
    8000324a:	05270713          	addi	a4,a4,82 # 80029298 <bcache+0x8268>
    8000324e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003250:	2b87b703          	ld	a4,696(a5)
    80003254:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003256:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000325a:	0001e517          	auipc	a0,0x1e
    8000325e:	dd650513          	addi	a0,a0,-554 # 80021030 <bcache>
    80003262:	a39fd0ef          	jal	80000c9a <release>
}
    80003266:	60e2                	ld	ra,24(sp)
    80003268:	6442                	ld	s0,16(sp)
    8000326a:	64a2                	ld	s1,8(sp)
    8000326c:	6902                	ld	s2,0(sp)
    8000326e:	6105                	addi	sp,sp,32
    80003270:	8082                	ret
    panic("brelse");
    80003272:	00005517          	auipc	a0,0x5
    80003276:	33650513          	addi	a0,a0,822 # 800085a8 <etext+0x5a8>
    8000327a:	d28fd0ef          	jal	800007a2 <panic>

000000008000327e <bpin>:

void
bpin(struct buf *b) {
    8000327e:	1101                	addi	sp,sp,-32
    80003280:	ec06                	sd	ra,24(sp)
    80003282:	e822                	sd	s0,16(sp)
    80003284:	e426                	sd	s1,8(sp)
    80003286:	1000                	addi	s0,sp,32
    80003288:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000328a:	0001e517          	auipc	a0,0x1e
    8000328e:	da650513          	addi	a0,a0,-602 # 80021030 <bcache>
    80003292:	971fd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80003296:	40bc                	lw	a5,64(s1)
    80003298:	2785                	addiw	a5,a5,1
    8000329a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000329c:	0001e517          	auipc	a0,0x1e
    800032a0:	d9450513          	addi	a0,a0,-620 # 80021030 <bcache>
    800032a4:	9f7fd0ef          	jal	80000c9a <release>
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret

00000000800032b2 <bunpin>:

void
bunpin(struct buf *b) {
    800032b2:	1101                	addi	sp,sp,-32
    800032b4:	ec06                	sd	ra,24(sp)
    800032b6:	e822                	sd	s0,16(sp)
    800032b8:	e426                	sd	s1,8(sp)
    800032ba:	1000                	addi	s0,sp,32
    800032bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032be:	0001e517          	auipc	a0,0x1e
    800032c2:	d7250513          	addi	a0,a0,-654 # 80021030 <bcache>
    800032c6:	93dfd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    800032ca:	40bc                	lw	a5,64(s1)
    800032cc:	37fd                	addiw	a5,a5,-1
    800032ce:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032d0:	0001e517          	auipc	a0,0x1e
    800032d4:	d6050513          	addi	a0,a0,-672 # 80021030 <bcache>
    800032d8:	9c3fd0ef          	jal	80000c9a <release>
}
    800032dc:	60e2                	ld	ra,24(sp)
    800032de:	6442                	ld	s0,16(sp)
    800032e0:	64a2                	ld	s1,8(sp)
    800032e2:	6105                	addi	sp,sp,32
    800032e4:	8082                	ret

00000000800032e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032e6:	1101                	addi	sp,sp,-32
    800032e8:	ec06                	sd	ra,24(sp)
    800032ea:	e822                	sd	s0,16(sp)
    800032ec:	e426                	sd	s1,8(sp)
    800032ee:	e04a                	sd	s2,0(sp)
    800032f0:	1000                	addi	s0,sp,32
    800032f2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032f4:	00d5d59b          	srliw	a1,a1,0xd
    800032f8:	00026797          	auipc	a5,0x26
    800032fc:	4147a783          	lw	a5,1044(a5) # 8002970c <sb+0x1c>
    80003300:	9dbd                	addw	a1,a1,a5
    80003302:	dedff0ef          	jal	800030ee <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003306:	0074f713          	andi	a4,s1,7
    8000330a:	4785                	li	a5,1
    8000330c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003310:	14ce                	slli	s1,s1,0x33
    80003312:	90d9                	srli	s1,s1,0x36
    80003314:	00950733          	add	a4,a0,s1
    80003318:	05874703          	lbu	a4,88(a4)
    8000331c:	00e7f6b3          	and	a3,a5,a4
    80003320:	c29d                	beqz	a3,80003346 <bfree+0x60>
    80003322:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003324:	94aa                	add	s1,s1,a0
    80003326:	fff7c793          	not	a5,a5
    8000332a:	8f7d                	and	a4,a4,a5
    8000332c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003330:	711000ef          	jal	80004240 <log_write>
  brelse(bp);
    80003334:	854a                	mv	a0,s2
    80003336:	ec1ff0ef          	jal	800031f6 <brelse>
}
    8000333a:	60e2                	ld	ra,24(sp)
    8000333c:	6442                	ld	s0,16(sp)
    8000333e:	64a2                	ld	s1,8(sp)
    80003340:	6902                	ld	s2,0(sp)
    80003342:	6105                	addi	sp,sp,32
    80003344:	8082                	ret
    panic("freeing free block");
    80003346:	00005517          	auipc	a0,0x5
    8000334a:	26a50513          	addi	a0,a0,618 # 800085b0 <etext+0x5b0>
    8000334e:	c54fd0ef          	jal	800007a2 <panic>

0000000080003352 <balloc>:
{
    80003352:	711d                	addi	sp,sp,-96
    80003354:	ec86                	sd	ra,88(sp)
    80003356:	e8a2                	sd	s0,80(sp)
    80003358:	e4a6                	sd	s1,72(sp)
    8000335a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000335c:	00026797          	auipc	a5,0x26
    80003360:	3987a783          	lw	a5,920(a5) # 800296f4 <sb+0x4>
    80003364:	0e078f63          	beqz	a5,80003462 <balloc+0x110>
    80003368:	e0ca                	sd	s2,64(sp)
    8000336a:	fc4e                	sd	s3,56(sp)
    8000336c:	f852                	sd	s4,48(sp)
    8000336e:	f456                	sd	s5,40(sp)
    80003370:	f05a                	sd	s6,32(sp)
    80003372:	ec5e                	sd	s7,24(sp)
    80003374:	e862                	sd	s8,16(sp)
    80003376:	e466                	sd	s9,8(sp)
    80003378:	8baa                	mv	s7,a0
    8000337a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000337c:	00026b17          	auipc	s6,0x26
    80003380:	374b0b13          	addi	s6,s6,884 # 800296f0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003384:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003386:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003388:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000338a:	6c89                	lui	s9,0x2
    8000338c:	a0b5                	j	800033f8 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000338e:	97ca                	add	a5,a5,s2
    80003390:	8e55                	or	a2,a2,a3
    80003392:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003396:	854a                	mv	a0,s2
    80003398:	6a9000ef          	jal	80004240 <log_write>
        brelse(bp);
    8000339c:	854a                	mv	a0,s2
    8000339e:	e59ff0ef          	jal	800031f6 <brelse>
  bp = bread(dev, bno);
    800033a2:	85a6                	mv	a1,s1
    800033a4:	855e                	mv	a0,s7
    800033a6:	d49ff0ef          	jal	800030ee <bread>
    800033aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800033ac:	40000613          	li	a2,1024
    800033b0:	4581                	li	a1,0
    800033b2:	05850513          	addi	a0,a0,88
    800033b6:	921fd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    800033ba:	854a                	mv	a0,s2
    800033bc:	685000ef          	jal	80004240 <log_write>
  brelse(bp);
    800033c0:	854a                	mv	a0,s2
    800033c2:	e35ff0ef          	jal	800031f6 <brelse>
}
    800033c6:	6906                	ld	s2,64(sp)
    800033c8:	79e2                	ld	s3,56(sp)
    800033ca:	7a42                	ld	s4,48(sp)
    800033cc:	7aa2                	ld	s5,40(sp)
    800033ce:	7b02                	ld	s6,32(sp)
    800033d0:	6be2                	ld	s7,24(sp)
    800033d2:	6c42                	ld	s8,16(sp)
    800033d4:	6ca2                	ld	s9,8(sp)
}
    800033d6:	8526                	mv	a0,s1
    800033d8:	60e6                	ld	ra,88(sp)
    800033da:	6446                	ld	s0,80(sp)
    800033dc:	64a6                	ld	s1,72(sp)
    800033de:	6125                	addi	sp,sp,96
    800033e0:	8082                	ret
    brelse(bp);
    800033e2:	854a                	mv	a0,s2
    800033e4:	e13ff0ef          	jal	800031f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800033e8:	015c87bb          	addw	a5,s9,s5
    800033ec:	00078a9b          	sext.w	s5,a5
    800033f0:	004b2703          	lw	a4,4(s6)
    800033f4:	04eaff63          	bgeu	s5,a4,80003452 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800033f8:	41fad79b          	sraiw	a5,s5,0x1f
    800033fc:	0137d79b          	srliw	a5,a5,0x13
    80003400:	015787bb          	addw	a5,a5,s5
    80003404:	40d7d79b          	sraiw	a5,a5,0xd
    80003408:	01cb2583          	lw	a1,28(s6)
    8000340c:	9dbd                	addw	a1,a1,a5
    8000340e:	855e                	mv	a0,s7
    80003410:	cdfff0ef          	jal	800030ee <bread>
    80003414:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003416:	004b2503          	lw	a0,4(s6)
    8000341a:	000a849b          	sext.w	s1,s5
    8000341e:	8762                	mv	a4,s8
    80003420:	fca4f1e3          	bgeu	s1,a0,800033e2 <balloc+0x90>
      m = 1 << (bi % 8);
    80003424:	00777693          	andi	a3,a4,7
    80003428:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000342c:	41f7579b          	sraiw	a5,a4,0x1f
    80003430:	01d7d79b          	srliw	a5,a5,0x1d
    80003434:	9fb9                	addw	a5,a5,a4
    80003436:	4037d79b          	sraiw	a5,a5,0x3
    8000343a:	00f90633          	add	a2,s2,a5
    8000343e:	05864603          	lbu	a2,88(a2)
    80003442:	00c6f5b3          	and	a1,a3,a2
    80003446:	d5a1                	beqz	a1,8000338e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003448:	2705                	addiw	a4,a4,1
    8000344a:	2485                	addiw	s1,s1,1
    8000344c:	fd471ae3          	bne	a4,s4,80003420 <balloc+0xce>
    80003450:	bf49                	j	800033e2 <balloc+0x90>
    80003452:	6906                	ld	s2,64(sp)
    80003454:	79e2                	ld	s3,56(sp)
    80003456:	7a42                	ld	s4,48(sp)
    80003458:	7aa2                	ld	s5,40(sp)
    8000345a:	7b02                	ld	s6,32(sp)
    8000345c:	6be2                	ld	s7,24(sp)
    8000345e:	6c42                	ld	s8,16(sp)
    80003460:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003462:	00005517          	auipc	a0,0x5
    80003466:	16650513          	addi	a0,a0,358 # 800085c8 <etext+0x5c8>
    8000346a:	866fd0ef          	jal	800004d0 <printf>
  return 0;
    8000346e:	4481                	li	s1,0
    80003470:	b79d                	j	800033d6 <balloc+0x84>

0000000080003472 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003472:	7179                	addi	sp,sp,-48
    80003474:	f406                	sd	ra,40(sp)
    80003476:	f022                	sd	s0,32(sp)
    80003478:	ec26                	sd	s1,24(sp)
    8000347a:	e84a                	sd	s2,16(sp)
    8000347c:	e44e                	sd	s3,8(sp)
    8000347e:	1800                	addi	s0,sp,48
    80003480:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003482:	47ad                	li	a5,11
    80003484:	02b7e663          	bltu	a5,a1,800034b0 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003488:	02059793          	slli	a5,a1,0x20
    8000348c:	01e7d593          	srli	a1,a5,0x1e
    80003490:	00b504b3          	add	s1,a0,a1
    80003494:	0504a903          	lw	s2,80(s1)
    80003498:	06091a63          	bnez	s2,8000350c <bmap+0x9a>
      addr = balloc(ip->dev);
    8000349c:	4108                	lw	a0,0(a0)
    8000349e:	eb5ff0ef          	jal	80003352 <balloc>
    800034a2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034a6:	06090363          	beqz	s2,8000350c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800034aa:	0524a823          	sw	s2,80(s1)
    800034ae:	a8b9                	j	8000350c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800034b0:	ff45849b          	addiw	s1,a1,-12
    800034b4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800034b8:	0ff00793          	li	a5,255
    800034bc:	06e7ee63          	bltu	a5,a4,80003538 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800034c0:	08052903          	lw	s2,128(a0)
    800034c4:	00091d63          	bnez	s2,800034de <bmap+0x6c>
      addr = balloc(ip->dev);
    800034c8:	4108                	lw	a0,0(a0)
    800034ca:	e89ff0ef          	jal	80003352 <balloc>
    800034ce:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034d2:	02090d63          	beqz	s2,8000350c <bmap+0x9a>
    800034d6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800034d8:	0929a023          	sw	s2,128(s3)
    800034dc:	a011                	j	800034e0 <bmap+0x6e>
    800034de:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800034e0:	85ca                	mv	a1,s2
    800034e2:	0009a503          	lw	a0,0(s3)
    800034e6:	c09ff0ef          	jal	800030ee <bread>
    800034ea:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034ec:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800034f0:	02049713          	slli	a4,s1,0x20
    800034f4:	01e75593          	srli	a1,a4,0x1e
    800034f8:	00b784b3          	add	s1,a5,a1
    800034fc:	0004a903          	lw	s2,0(s1)
    80003500:	00090e63          	beqz	s2,8000351c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003504:	8552                	mv	a0,s4
    80003506:	cf1ff0ef          	jal	800031f6 <brelse>
    return addr;
    8000350a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000350c:	854a                	mv	a0,s2
    8000350e:	70a2                	ld	ra,40(sp)
    80003510:	7402                	ld	s0,32(sp)
    80003512:	64e2                	ld	s1,24(sp)
    80003514:	6942                	ld	s2,16(sp)
    80003516:	69a2                	ld	s3,8(sp)
    80003518:	6145                	addi	sp,sp,48
    8000351a:	8082                	ret
      addr = balloc(ip->dev);
    8000351c:	0009a503          	lw	a0,0(s3)
    80003520:	e33ff0ef          	jal	80003352 <balloc>
    80003524:	0005091b          	sext.w	s2,a0
      if(addr){
    80003528:	fc090ee3          	beqz	s2,80003504 <bmap+0x92>
        a[bn] = addr;
    8000352c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003530:	8552                	mv	a0,s4
    80003532:	50f000ef          	jal	80004240 <log_write>
    80003536:	b7f9                	j	80003504 <bmap+0x92>
    80003538:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000353a:	00005517          	auipc	a0,0x5
    8000353e:	0a650513          	addi	a0,a0,166 # 800085e0 <etext+0x5e0>
    80003542:	a60fd0ef          	jal	800007a2 <panic>

0000000080003546 <iget>:
{
    80003546:	7179                	addi	sp,sp,-48
    80003548:	f406                	sd	ra,40(sp)
    8000354a:	f022                	sd	s0,32(sp)
    8000354c:	ec26                	sd	s1,24(sp)
    8000354e:	e84a                	sd	s2,16(sp)
    80003550:	e44e                	sd	s3,8(sp)
    80003552:	e052                	sd	s4,0(sp)
    80003554:	1800                	addi	s0,sp,48
    80003556:	89aa                	mv	s3,a0
    80003558:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000355a:	00026517          	auipc	a0,0x26
    8000355e:	1b650513          	addi	a0,a0,438 # 80029710 <itable>
    80003562:	ea0fd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003566:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003568:	00026497          	auipc	s1,0x26
    8000356c:	1c048493          	addi	s1,s1,448 # 80029728 <itable+0x18>
    80003570:	00028697          	auipc	a3,0x28
    80003574:	c4868693          	addi	a3,a3,-952 # 8002b1b8 <log>
    80003578:	a039                	j	80003586 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000357a:	02090963          	beqz	s2,800035ac <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000357e:	08848493          	addi	s1,s1,136
    80003582:	02d48863          	beq	s1,a3,800035b2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003586:	449c                	lw	a5,8(s1)
    80003588:	fef059e3          	blez	a5,8000357a <iget+0x34>
    8000358c:	4098                	lw	a4,0(s1)
    8000358e:	ff3716e3          	bne	a4,s3,8000357a <iget+0x34>
    80003592:	40d8                	lw	a4,4(s1)
    80003594:	ff4713e3          	bne	a4,s4,8000357a <iget+0x34>
      ip->ref++;
    80003598:	2785                	addiw	a5,a5,1
    8000359a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000359c:	00026517          	auipc	a0,0x26
    800035a0:	17450513          	addi	a0,a0,372 # 80029710 <itable>
    800035a4:	ef6fd0ef          	jal	80000c9a <release>
      return ip;
    800035a8:	8926                	mv	s2,s1
    800035aa:	a02d                	j	800035d4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035ac:	fbe9                	bnez	a5,8000357e <iget+0x38>
      empty = ip;
    800035ae:	8926                	mv	s2,s1
    800035b0:	b7f9                	j	8000357e <iget+0x38>
  if(empty == 0)
    800035b2:	02090a63          	beqz	s2,800035e6 <iget+0xa0>
  ip->dev = dev;
    800035b6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035ba:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035be:	4785                	li	a5,1
    800035c0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035c4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800035c8:	00026517          	auipc	a0,0x26
    800035cc:	14850513          	addi	a0,a0,328 # 80029710 <itable>
    800035d0:	ecafd0ef          	jal	80000c9a <release>
}
    800035d4:	854a                	mv	a0,s2
    800035d6:	70a2                	ld	ra,40(sp)
    800035d8:	7402                	ld	s0,32(sp)
    800035da:	64e2                	ld	s1,24(sp)
    800035dc:	6942                	ld	s2,16(sp)
    800035de:	69a2                	ld	s3,8(sp)
    800035e0:	6a02                	ld	s4,0(sp)
    800035e2:	6145                	addi	sp,sp,48
    800035e4:	8082                	ret
    panic("iget: no inodes");
    800035e6:	00005517          	auipc	a0,0x5
    800035ea:	01250513          	addi	a0,a0,18 # 800085f8 <etext+0x5f8>
    800035ee:	9b4fd0ef          	jal	800007a2 <panic>

00000000800035f2 <fsinit>:
fsinit(int dev) {
    800035f2:	7179                	addi	sp,sp,-48
    800035f4:	f406                	sd	ra,40(sp)
    800035f6:	f022                	sd	s0,32(sp)
    800035f8:	ec26                	sd	s1,24(sp)
    800035fa:	e84a                	sd	s2,16(sp)
    800035fc:	e44e                	sd	s3,8(sp)
    800035fe:	1800                	addi	s0,sp,48
    80003600:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003602:	4585                	li	a1,1
    80003604:	aebff0ef          	jal	800030ee <bread>
    80003608:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000360a:	00026997          	auipc	s3,0x26
    8000360e:	0e698993          	addi	s3,s3,230 # 800296f0 <sb>
    80003612:	02000613          	li	a2,32
    80003616:	05850593          	addi	a1,a0,88
    8000361a:	854e                	mv	a0,s3
    8000361c:	f16fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    80003620:	8526                	mv	a0,s1
    80003622:	bd5ff0ef          	jal	800031f6 <brelse>
  if(sb.magic != FSMAGIC)
    80003626:	0009a703          	lw	a4,0(s3)
    8000362a:	102037b7          	lui	a5,0x10203
    8000362e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003632:	02f71063          	bne	a4,a5,80003652 <fsinit+0x60>
  initlog(dev, &sb);
    80003636:	00026597          	auipc	a1,0x26
    8000363a:	0ba58593          	addi	a1,a1,186 # 800296f0 <sb>
    8000363e:	854a                	mv	a0,s2
    80003640:	1f9000ef          	jal	80004038 <initlog>
}
    80003644:	70a2                	ld	ra,40(sp)
    80003646:	7402                	ld	s0,32(sp)
    80003648:	64e2                	ld	s1,24(sp)
    8000364a:	6942                	ld	s2,16(sp)
    8000364c:	69a2                	ld	s3,8(sp)
    8000364e:	6145                	addi	sp,sp,48
    80003650:	8082                	ret
    panic("invalid file system");
    80003652:	00005517          	auipc	a0,0x5
    80003656:	fb650513          	addi	a0,a0,-74 # 80008608 <etext+0x608>
    8000365a:	948fd0ef          	jal	800007a2 <panic>

000000008000365e <iinit>:
{
    8000365e:	7179                	addi	sp,sp,-48
    80003660:	f406                	sd	ra,40(sp)
    80003662:	f022                	sd	s0,32(sp)
    80003664:	ec26                	sd	s1,24(sp)
    80003666:	e84a                	sd	s2,16(sp)
    80003668:	e44e                	sd	s3,8(sp)
    8000366a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000366c:	00005597          	auipc	a1,0x5
    80003670:	fb458593          	addi	a1,a1,-76 # 80008620 <etext+0x620>
    80003674:	00026517          	auipc	a0,0x26
    80003678:	09c50513          	addi	a0,a0,156 # 80029710 <itable>
    8000367c:	d06fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003680:	00026497          	auipc	s1,0x26
    80003684:	0b848493          	addi	s1,s1,184 # 80029738 <itable+0x28>
    80003688:	00028997          	auipc	s3,0x28
    8000368c:	b4098993          	addi	s3,s3,-1216 # 8002b1c8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003690:	00005917          	auipc	s2,0x5
    80003694:	f9890913          	addi	s2,s2,-104 # 80008628 <etext+0x628>
    80003698:	85ca                	mv	a1,s2
    8000369a:	8526                	mv	a0,s1
    8000369c:	475000ef          	jal	80004310 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036a0:	08848493          	addi	s1,s1,136
    800036a4:	ff349ae3          	bne	s1,s3,80003698 <iinit+0x3a>
}
    800036a8:	70a2                	ld	ra,40(sp)
    800036aa:	7402                	ld	s0,32(sp)
    800036ac:	64e2                	ld	s1,24(sp)
    800036ae:	6942                	ld	s2,16(sp)
    800036b0:	69a2                	ld	s3,8(sp)
    800036b2:	6145                	addi	sp,sp,48
    800036b4:	8082                	ret

00000000800036b6 <ialloc>:
{
    800036b6:	7139                	addi	sp,sp,-64
    800036b8:	fc06                	sd	ra,56(sp)
    800036ba:	f822                	sd	s0,48(sp)
    800036bc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800036be:	00026717          	auipc	a4,0x26
    800036c2:	03e72703          	lw	a4,62(a4) # 800296fc <sb+0xc>
    800036c6:	4785                	li	a5,1
    800036c8:	06e7f063          	bgeu	a5,a4,80003728 <ialloc+0x72>
    800036cc:	f426                	sd	s1,40(sp)
    800036ce:	f04a                	sd	s2,32(sp)
    800036d0:	ec4e                	sd	s3,24(sp)
    800036d2:	e852                	sd	s4,16(sp)
    800036d4:	e456                	sd	s5,8(sp)
    800036d6:	e05a                	sd	s6,0(sp)
    800036d8:	8aaa                	mv	s5,a0
    800036da:	8b2e                	mv	s6,a1
    800036dc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036de:	00026a17          	auipc	s4,0x26
    800036e2:	012a0a13          	addi	s4,s4,18 # 800296f0 <sb>
    800036e6:	00495593          	srli	a1,s2,0x4
    800036ea:	018a2783          	lw	a5,24(s4)
    800036ee:	9dbd                	addw	a1,a1,a5
    800036f0:	8556                	mv	a0,s5
    800036f2:	9fdff0ef          	jal	800030ee <bread>
    800036f6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036f8:	05850993          	addi	s3,a0,88
    800036fc:	00f97793          	andi	a5,s2,15
    80003700:	079a                	slli	a5,a5,0x6
    80003702:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003704:	00099783          	lh	a5,0(s3)
    80003708:	cb9d                	beqz	a5,8000373e <ialloc+0x88>
    brelse(bp);
    8000370a:	aedff0ef          	jal	800031f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000370e:	0905                	addi	s2,s2,1
    80003710:	00ca2703          	lw	a4,12(s4)
    80003714:	0009079b          	sext.w	a5,s2
    80003718:	fce7e7e3          	bltu	a5,a4,800036e6 <ialloc+0x30>
    8000371c:	74a2                	ld	s1,40(sp)
    8000371e:	7902                	ld	s2,32(sp)
    80003720:	69e2                	ld	s3,24(sp)
    80003722:	6a42                	ld	s4,16(sp)
    80003724:	6aa2                	ld	s5,8(sp)
    80003726:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003728:	00005517          	auipc	a0,0x5
    8000372c:	f0850513          	addi	a0,a0,-248 # 80008630 <etext+0x630>
    80003730:	da1fc0ef          	jal	800004d0 <printf>
  return 0;
    80003734:	4501                	li	a0,0
}
    80003736:	70e2                	ld	ra,56(sp)
    80003738:	7442                	ld	s0,48(sp)
    8000373a:	6121                	addi	sp,sp,64
    8000373c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000373e:	04000613          	li	a2,64
    80003742:	4581                	li	a1,0
    80003744:	854e                	mv	a0,s3
    80003746:	d90fd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    8000374a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000374e:	8526                	mv	a0,s1
    80003750:	2f1000ef          	jal	80004240 <log_write>
      brelse(bp);
    80003754:	8526                	mv	a0,s1
    80003756:	aa1ff0ef          	jal	800031f6 <brelse>
      return iget(dev, inum);
    8000375a:	0009059b          	sext.w	a1,s2
    8000375e:	8556                	mv	a0,s5
    80003760:	de7ff0ef          	jal	80003546 <iget>
    80003764:	74a2                	ld	s1,40(sp)
    80003766:	7902                	ld	s2,32(sp)
    80003768:	69e2                	ld	s3,24(sp)
    8000376a:	6a42                	ld	s4,16(sp)
    8000376c:	6aa2                	ld	s5,8(sp)
    8000376e:	6b02                	ld	s6,0(sp)
    80003770:	b7d9                	j	80003736 <ialloc+0x80>

0000000080003772 <iupdate>:
{
    80003772:	1101                	addi	sp,sp,-32
    80003774:	ec06                	sd	ra,24(sp)
    80003776:	e822                	sd	s0,16(sp)
    80003778:	e426                	sd	s1,8(sp)
    8000377a:	e04a                	sd	s2,0(sp)
    8000377c:	1000                	addi	s0,sp,32
    8000377e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003780:	415c                	lw	a5,4(a0)
    80003782:	0047d79b          	srliw	a5,a5,0x4
    80003786:	00026597          	auipc	a1,0x26
    8000378a:	f825a583          	lw	a1,-126(a1) # 80029708 <sb+0x18>
    8000378e:	9dbd                	addw	a1,a1,a5
    80003790:	4108                	lw	a0,0(a0)
    80003792:	95dff0ef          	jal	800030ee <bread>
    80003796:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003798:	05850793          	addi	a5,a0,88
    8000379c:	40d8                	lw	a4,4(s1)
    8000379e:	8b3d                	andi	a4,a4,15
    800037a0:	071a                	slli	a4,a4,0x6
    800037a2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800037a4:	04449703          	lh	a4,68(s1)
    800037a8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800037ac:	04649703          	lh	a4,70(s1)
    800037b0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800037b4:	04849703          	lh	a4,72(s1)
    800037b8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800037bc:	04a49703          	lh	a4,74(s1)
    800037c0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800037c4:	44f8                	lw	a4,76(s1)
    800037c6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037c8:	03400613          	li	a2,52
    800037cc:	05048593          	addi	a1,s1,80
    800037d0:	00c78513          	addi	a0,a5,12
    800037d4:	d5efd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    800037d8:	854a                	mv	a0,s2
    800037da:	267000ef          	jal	80004240 <log_write>
  brelse(bp);
    800037de:	854a                	mv	a0,s2
    800037e0:	a17ff0ef          	jal	800031f6 <brelse>
}
    800037e4:	60e2                	ld	ra,24(sp)
    800037e6:	6442                	ld	s0,16(sp)
    800037e8:	64a2                	ld	s1,8(sp)
    800037ea:	6902                	ld	s2,0(sp)
    800037ec:	6105                	addi	sp,sp,32
    800037ee:	8082                	ret

00000000800037f0 <idup>:
{
    800037f0:	1101                	addi	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	1000                	addi	s0,sp,32
    800037fa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037fc:	00026517          	auipc	a0,0x26
    80003800:	f1450513          	addi	a0,a0,-236 # 80029710 <itable>
    80003804:	bfefd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    80003808:	449c                	lw	a5,8(s1)
    8000380a:	2785                	addiw	a5,a5,1
    8000380c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000380e:	00026517          	auipc	a0,0x26
    80003812:	f0250513          	addi	a0,a0,-254 # 80029710 <itable>
    80003816:	c84fd0ef          	jal	80000c9a <release>
}
    8000381a:	8526                	mv	a0,s1
    8000381c:	60e2                	ld	ra,24(sp)
    8000381e:	6442                	ld	s0,16(sp)
    80003820:	64a2                	ld	s1,8(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <ilock>:
{
    80003826:	1101                	addi	sp,sp,-32
    80003828:	ec06                	sd	ra,24(sp)
    8000382a:	e822                	sd	s0,16(sp)
    8000382c:	e426                	sd	s1,8(sp)
    8000382e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003830:	cd19                	beqz	a0,8000384e <ilock+0x28>
    80003832:	84aa                	mv	s1,a0
    80003834:	451c                	lw	a5,8(a0)
    80003836:	00f05c63          	blez	a5,8000384e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000383a:	0541                	addi	a0,a0,16
    8000383c:	30b000ef          	jal	80004346 <acquiresleep>
  if(ip->valid == 0){
    80003840:	40bc                	lw	a5,64(s1)
    80003842:	cf89                	beqz	a5,8000385c <ilock+0x36>
}
    80003844:	60e2                	ld	ra,24(sp)
    80003846:	6442                	ld	s0,16(sp)
    80003848:	64a2                	ld	s1,8(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret
    8000384e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003850:	00005517          	auipc	a0,0x5
    80003854:	df850513          	addi	a0,a0,-520 # 80008648 <etext+0x648>
    80003858:	f4bfc0ef          	jal	800007a2 <panic>
    8000385c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000385e:	40dc                	lw	a5,4(s1)
    80003860:	0047d79b          	srliw	a5,a5,0x4
    80003864:	00026597          	auipc	a1,0x26
    80003868:	ea45a583          	lw	a1,-348(a1) # 80029708 <sb+0x18>
    8000386c:	9dbd                	addw	a1,a1,a5
    8000386e:	4088                	lw	a0,0(s1)
    80003870:	87fff0ef          	jal	800030ee <bread>
    80003874:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003876:	05850593          	addi	a1,a0,88
    8000387a:	40dc                	lw	a5,4(s1)
    8000387c:	8bbd                	andi	a5,a5,15
    8000387e:	079a                	slli	a5,a5,0x6
    80003880:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003882:	00059783          	lh	a5,0(a1)
    80003886:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000388a:	00259783          	lh	a5,2(a1)
    8000388e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003892:	00459783          	lh	a5,4(a1)
    80003896:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000389a:	00659783          	lh	a5,6(a1)
    8000389e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800038a2:	459c                	lw	a5,8(a1)
    800038a4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800038a6:	03400613          	li	a2,52
    800038aa:	05b1                	addi	a1,a1,12
    800038ac:	05048513          	addi	a0,s1,80
    800038b0:	c82fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800038b4:	854a                	mv	a0,s2
    800038b6:	941ff0ef          	jal	800031f6 <brelse>
    ip->valid = 1;
    800038ba:	4785                	li	a5,1
    800038bc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800038be:	04449783          	lh	a5,68(s1)
    800038c2:	c399                	beqz	a5,800038c8 <ilock+0xa2>
    800038c4:	6902                	ld	s2,0(sp)
    800038c6:	bfbd                	j	80003844 <ilock+0x1e>
      panic("ilock: no type");
    800038c8:	00005517          	auipc	a0,0x5
    800038cc:	d8850513          	addi	a0,a0,-632 # 80008650 <etext+0x650>
    800038d0:	ed3fc0ef          	jal	800007a2 <panic>

00000000800038d4 <iunlock>:
{
    800038d4:	1101                	addi	sp,sp,-32
    800038d6:	ec06                	sd	ra,24(sp)
    800038d8:	e822                	sd	s0,16(sp)
    800038da:	e426                	sd	s1,8(sp)
    800038dc:	e04a                	sd	s2,0(sp)
    800038de:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038e0:	c505                	beqz	a0,80003908 <iunlock+0x34>
    800038e2:	84aa                	mv	s1,a0
    800038e4:	01050913          	addi	s2,a0,16
    800038e8:	854a                	mv	a0,s2
    800038ea:	2db000ef          	jal	800043c4 <holdingsleep>
    800038ee:	cd09                	beqz	a0,80003908 <iunlock+0x34>
    800038f0:	449c                	lw	a5,8(s1)
    800038f2:	00f05b63          	blez	a5,80003908 <iunlock+0x34>
  releasesleep(&ip->lock);
    800038f6:	854a                	mv	a0,s2
    800038f8:	295000ef          	jal	8000438c <releasesleep>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret
    panic("iunlock");
    80003908:	00005517          	auipc	a0,0x5
    8000390c:	d5850513          	addi	a0,a0,-680 # 80008660 <etext+0x660>
    80003910:	e93fc0ef          	jal	800007a2 <panic>

0000000080003914 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003914:	7179                	addi	sp,sp,-48
    80003916:	f406                	sd	ra,40(sp)
    80003918:	f022                	sd	s0,32(sp)
    8000391a:	ec26                	sd	s1,24(sp)
    8000391c:	e84a                	sd	s2,16(sp)
    8000391e:	e44e                	sd	s3,8(sp)
    80003920:	1800                	addi	s0,sp,48
    80003922:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003924:	05050493          	addi	s1,a0,80
    80003928:	08050913          	addi	s2,a0,128
    8000392c:	a021                	j	80003934 <itrunc+0x20>
    8000392e:	0491                	addi	s1,s1,4
    80003930:	01248b63          	beq	s1,s2,80003946 <itrunc+0x32>
    if(ip->addrs[i]){
    80003934:	408c                	lw	a1,0(s1)
    80003936:	dde5                	beqz	a1,8000392e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003938:	0009a503          	lw	a0,0(s3)
    8000393c:	9abff0ef          	jal	800032e6 <bfree>
      ip->addrs[i] = 0;
    80003940:	0004a023          	sw	zero,0(s1)
    80003944:	b7ed                	j	8000392e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003946:	0809a583          	lw	a1,128(s3)
    8000394a:	ed89                	bnez	a1,80003964 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000394c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003950:	854e                	mv	a0,s3
    80003952:	e21ff0ef          	jal	80003772 <iupdate>
}
    80003956:	70a2                	ld	ra,40(sp)
    80003958:	7402                	ld	s0,32(sp)
    8000395a:	64e2                	ld	s1,24(sp)
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	69a2                	ld	s3,8(sp)
    80003960:	6145                	addi	sp,sp,48
    80003962:	8082                	ret
    80003964:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003966:	0009a503          	lw	a0,0(s3)
    8000396a:	f84ff0ef          	jal	800030ee <bread>
    8000396e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003970:	05850493          	addi	s1,a0,88
    80003974:	45850913          	addi	s2,a0,1112
    80003978:	a021                	j	80003980 <itrunc+0x6c>
    8000397a:	0491                	addi	s1,s1,4
    8000397c:	01248963          	beq	s1,s2,8000398e <itrunc+0x7a>
      if(a[j])
    80003980:	408c                	lw	a1,0(s1)
    80003982:	dde5                	beqz	a1,8000397a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003984:	0009a503          	lw	a0,0(s3)
    80003988:	95fff0ef          	jal	800032e6 <bfree>
    8000398c:	b7fd                	j	8000397a <itrunc+0x66>
    brelse(bp);
    8000398e:	8552                	mv	a0,s4
    80003990:	867ff0ef          	jal	800031f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003994:	0809a583          	lw	a1,128(s3)
    80003998:	0009a503          	lw	a0,0(s3)
    8000399c:	94bff0ef          	jal	800032e6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800039a0:	0809a023          	sw	zero,128(s3)
    800039a4:	6a02                	ld	s4,0(sp)
    800039a6:	b75d                	j	8000394c <itrunc+0x38>

00000000800039a8 <iput>:
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	1000                	addi	s0,sp,32
    800039b2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800039b4:	00026517          	auipc	a0,0x26
    800039b8:	d5c50513          	addi	a0,a0,-676 # 80029710 <itable>
    800039bc:	a46fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039c0:	4498                	lw	a4,8(s1)
    800039c2:	4785                	li	a5,1
    800039c4:	02f70063          	beq	a4,a5,800039e4 <iput+0x3c>
  ip->ref--;
    800039c8:	449c                	lw	a5,8(s1)
    800039ca:	37fd                	addiw	a5,a5,-1
    800039cc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039ce:	00026517          	auipc	a0,0x26
    800039d2:	d4250513          	addi	a0,a0,-702 # 80029710 <itable>
    800039d6:	ac4fd0ef          	jal	80000c9a <release>
}
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6105                	addi	sp,sp,32
    800039e2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039e4:	40bc                	lw	a5,64(s1)
    800039e6:	d3ed                	beqz	a5,800039c8 <iput+0x20>
    800039e8:	04a49783          	lh	a5,74(s1)
    800039ec:	fff1                	bnez	a5,800039c8 <iput+0x20>
    800039ee:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800039f0:	01048913          	addi	s2,s1,16
    800039f4:	854a                	mv	a0,s2
    800039f6:	151000ef          	jal	80004346 <acquiresleep>
    release(&itable.lock);
    800039fa:	00026517          	auipc	a0,0x26
    800039fe:	d1650513          	addi	a0,a0,-746 # 80029710 <itable>
    80003a02:	a98fd0ef          	jal	80000c9a <release>
    itrunc(ip);
    80003a06:	8526                	mv	a0,s1
    80003a08:	f0dff0ef          	jal	80003914 <itrunc>
    ip->type = 0;
    80003a0c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a10:	8526                	mv	a0,s1
    80003a12:	d61ff0ef          	jal	80003772 <iupdate>
    ip->valid = 0;
    80003a16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a1a:	854a                	mv	a0,s2
    80003a1c:	171000ef          	jal	8000438c <releasesleep>
    acquire(&itable.lock);
    80003a20:	00026517          	auipc	a0,0x26
    80003a24:	cf050513          	addi	a0,a0,-784 # 80029710 <itable>
    80003a28:	9dafd0ef          	jal	80000c02 <acquire>
    80003a2c:	6902                	ld	s2,0(sp)
    80003a2e:	bf69                	j	800039c8 <iput+0x20>

0000000080003a30 <iunlockput>:
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a3c:	e99ff0ef          	jal	800038d4 <iunlock>
  iput(ip);
    80003a40:	8526                	mv	a0,s1
    80003a42:	f67ff0ef          	jal	800039a8 <iput>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6105                	addi	sp,sp,32
    80003a4e:	8082                	ret

0000000080003a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a50:	1141                	addi	sp,sp,-16
    80003a52:	e422                	sd	s0,8(sp)
    80003a54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a56:	411c                	lw	a5,0(a0)
    80003a58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a5a:	415c                	lw	a5,4(a0)
    80003a5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a5e:	04451783          	lh	a5,68(a0)
    80003a62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a66:	04a51783          	lh	a5,74(a0)
    80003a6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a6e:	04c56783          	lwu	a5,76(a0)
    80003a72:	e99c                	sd	a5,16(a1)
}
    80003a74:	6422                	ld	s0,8(sp)
    80003a76:	0141                	addi	sp,sp,16
    80003a78:	8082                	ret

0000000080003a7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a7a:	457c                	lw	a5,76(a0)
    80003a7c:	0ed7eb63          	bltu	a5,a3,80003b72 <readi+0xf8>
{
    80003a80:	7159                	addi	sp,sp,-112
    80003a82:	f486                	sd	ra,104(sp)
    80003a84:	f0a2                	sd	s0,96(sp)
    80003a86:	eca6                	sd	s1,88(sp)
    80003a88:	e0d2                	sd	s4,64(sp)
    80003a8a:	fc56                	sd	s5,56(sp)
    80003a8c:	f85a                	sd	s6,48(sp)
    80003a8e:	f45e                	sd	s7,40(sp)
    80003a90:	1880                	addi	s0,sp,112
    80003a92:	8b2a                	mv	s6,a0
    80003a94:	8bae                	mv	s7,a1
    80003a96:	8a32                	mv	s4,a2
    80003a98:	84b6                	mv	s1,a3
    80003a9a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a9c:	9f35                	addw	a4,a4,a3
    return 0;
    80003a9e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003aa0:	0cd76063          	bltu	a4,a3,80003b60 <readi+0xe6>
    80003aa4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003aa6:	00e7f463          	bgeu	a5,a4,80003aae <readi+0x34>
    n = ip->size - off;
    80003aaa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aae:	080a8f63          	beqz	s5,80003b4c <readi+0xd2>
    80003ab2:	e8ca                	sd	s2,80(sp)
    80003ab4:	f062                	sd	s8,32(sp)
    80003ab6:	ec66                	sd	s9,24(sp)
    80003ab8:	e86a                	sd	s10,16(sp)
    80003aba:	e46e                	sd	s11,8(sp)
    80003abc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003abe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ac2:	5c7d                	li	s8,-1
    80003ac4:	a80d                	j	80003af6 <readi+0x7c>
    80003ac6:	020d1d93          	slli	s11,s10,0x20
    80003aca:	020ddd93          	srli	s11,s11,0x20
    80003ace:	05890613          	addi	a2,s2,88
    80003ad2:	86ee                	mv	a3,s11
    80003ad4:	963a                	add	a2,a2,a4
    80003ad6:	85d2                	mv	a1,s4
    80003ad8:	855e                	mv	a0,s7
    80003ada:	b85fe0ef          	jal	8000265e <either_copyout>
    80003ade:	05850763          	beq	a0,s8,80003b2c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ae2:	854a                	mv	a0,s2
    80003ae4:	f12ff0ef          	jal	800031f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae8:	013d09bb          	addw	s3,s10,s3
    80003aec:	009d04bb          	addw	s1,s10,s1
    80003af0:	9a6e                	add	s4,s4,s11
    80003af2:	0559f763          	bgeu	s3,s5,80003b40 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003af6:	00a4d59b          	srliw	a1,s1,0xa
    80003afa:	855a                	mv	a0,s6
    80003afc:	977ff0ef          	jal	80003472 <bmap>
    80003b00:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b04:	c5b1                	beqz	a1,80003b50 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003b06:	000b2503          	lw	a0,0(s6)
    80003b0a:	de4ff0ef          	jal	800030ee <bread>
    80003b0e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b10:	3ff4f713          	andi	a4,s1,1023
    80003b14:	40ec87bb          	subw	a5,s9,a4
    80003b18:	413a86bb          	subw	a3,s5,s3
    80003b1c:	8d3e                	mv	s10,a5
    80003b1e:	2781                	sext.w	a5,a5
    80003b20:	0006861b          	sext.w	a2,a3
    80003b24:	faf671e3          	bgeu	a2,a5,80003ac6 <readi+0x4c>
    80003b28:	8d36                	mv	s10,a3
    80003b2a:	bf71                	j	80003ac6 <readi+0x4c>
      brelse(bp);
    80003b2c:	854a                	mv	a0,s2
    80003b2e:	ec8ff0ef          	jal	800031f6 <brelse>
      tot = -1;
    80003b32:	59fd                	li	s3,-1
      break;
    80003b34:	6946                	ld	s2,80(sp)
    80003b36:	7c02                	ld	s8,32(sp)
    80003b38:	6ce2                	ld	s9,24(sp)
    80003b3a:	6d42                	ld	s10,16(sp)
    80003b3c:	6da2                	ld	s11,8(sp)
    80003b3e:	a831                	j	80003b5a <readi+0xe0>
    80003b40:	6946                	ld	s2,80(sp)
    80003b42:	7c02                	ld	s8,32(sp)
    80003b44:	6ce2                	ld	s9,24(sp)
    80003b46:	6d42                	ld	s10,16(sp)
    80003b48:	6da2                	ld	s11,8(sp)
    80003b4a:	a801                	j	80003b5a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b4c:	89d6                	mv	s3,s5
    80003b4e:	a031                	j	80003b5a <readi+0xe0>
    80003b50:	6946                	ld	s2,80(sp)
    80003b52:	7c02                	ld	s8,32(sp)
    80003b54:	6ce2                	ld	s9,24(sp)
    80003b56:	6d42                	ld	s10,16(sp)
    80003b58:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b5a:	0009851b          	sext.w	a0,s3
    80003b5e:	69a6                	ld	s3,72(sp)
}
    80003b60:	70a6                	ld	ra,104(sp)
    80003b62:	7406                	ld	s0,96(sp)
    80003b64:	64e6                	ld	s1,88(sp)
    80003b66:	6a06                	ld	s4,64(sp)
    80003b68:	7ae2                	ld	s5,56(sp)
    80003b6a:	7b42                	ld	s6,48(sp)
    80003b6c:	7ba2                	ld	s7,40(sp)
    80003b6e:	6165                	addi	sp,sp,112
    80003b70:	8082                	ret
    return 0;
    80003b72:	4501                	li	a0,0
}
    80003b74:	8082                	ret

0000000080003b76 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b76:	457c                	lw	a5,76(a0)
    80003b78:	10d7e063          	bltu	a5,a3,80003c78 <writei+0x102>
{
    80003b7c:	7159                	addi	sp,sp,-112
    80003b7e:	f486                	sd	ra,104(sp)
    80003b80:	f0a2                	sd	s0,96(sp)
    80003b82:	e8ca                	sd	s2,80(sp)
    80003b84:	e0d2                	sd	s4,64(sp)
    80003b86:	fc56                	sd	s5,56(sp)
    80003b88:	f85a                	sd	s6,48(sp)
    80003b8a:	f45e                	sd	s7,40(sp)
    80003b8c:	1880                	addi	s0,sp,112
    80003b8e:	8aaa                	mv	s5,a0
    80003b90:	8bae                	mv	s7,a1
    80003b92:	8a32                	mv	s4,a2
    80003b94:	8936                	mv	s2,a3
    80003b96:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b98:	00e687bb          	addw	a5,a3,a4
    80003b9c:	0ed7e063          	bltu	a5,a3,80003c7c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ba0:	00043737          	lui	a4,0x43
    80003ba4:	0cf76e63          	bltu	a4,a5,80003c80 <writei+0x10a>
    80003ba8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003baa:	0a0b0f63          	beqz	s6,80003c68 <writei+0xf2>
    80003bae:	eca6                	sd	s1,88(sp)
    80003bb0:	f062                	sd	s8,32(sp)
    80003bb2:	ec66                	sd	s9,24(sp)
    80003bb4:	e86a                	sd	s10,16(sp)
    80003bb6:	e46e                	sd	s11,8(sp)
    80003bb8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bba:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bbe:	5c7d                	li	s8,-1
    80003bc0:	a825                	j	80003bf8 <writei+0x82>
    80003bc2:	020d1d93          	slli	s11,s10,0x20
    80003bc6:	020ddd93          	srli	s11,s11,0x20
    80003bca:	05848513          	addi	a0,s1,88
    80003bce:	86ee                	mv	a3,s11
    80003bd0:	8652                	mv	a2,s4
    80003bd2:	85de                	mv	a1,s7
    80003bd4:	953a                	add	a0,a0,a4
    80003bd6:	ad3fe0ef          	jal	800026a8 <either_copyin>
    80003bda:	05850a63          	beq	a0,s8,80003c2e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bde:	8526                	mv	a0,s1
    80003be0:	660000ef          	jal	80004240 <log_write>
    brelse(bp);
    80003be4:	8526                	mv	a0,s1
    80003be6:	e10ff0ef          	jal	800031f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bea:	013d09bb          	addw	s3,s10,s3
    80003bee:	012d093b          	addw	s2,s10,s2
    80003bf2:	9a6e                	add	s4,s4,s11
    80003bf4:	0569f063          	bgeu	s3,s6,80003c34 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003bf8:	00a9559b          	srliw	a1,s2,0xa
    80003bfc:	8556                	mv	a0,s5
    80003bfe:	875ff0ef          	jal	80003472 <bmap>
    80003c02:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c06:	c59d                	beqz	a1,80003c34 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003c08:	000aa503          	lw	a0,0(s5)
    80003c0c:	ce2ff0ef          	jal	800030ee <bread>
    80003c10:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c12:	3ff97713          	andi	a4,s2,1023
    80003c16:	40ec87bb          	subw	a5,s9,a4
    80003c1a:	413b06bb          	subw	a3,s6,s3
    80003c1e:	8d3e                	mv	s10,a5
    80003c20:	2781                	sext.w	a5,a5
    80003c22:	0006861b          	sext.w	a2,a3
    80003c26:	f8f67ee3          	bgeu	a2,a5,80003bc2 <writei+0x4c>
    80003c2a:	8d36                	mv	s10,a3
    80003c2c:	bf59                	j	80003bc2 <writei+0x4c>
      brelse(bp);
    80003c2e:	8526                	mv	a0,s1
    80003c30:	dc6ff0ef          	jal	800031f6 <brelse>
  }

  if(off > ip->size)
    80003c34:	04caa783          	lw	a5,76(s5)
    80003c38:	0327fa63          	bgeu	a5,s2,80003c6c <writei+0xf6>
    ip->size = off;
    80003c3c:	052aa623          	sw	s2,76(s5)
    80003c40:	64e6                	ld	s1,88(sp)
    80003c42:	7c02                	ld	s8,32(sp)
    80003c44:	6ce2                	ld	s9,24(sp)
    80003c46:	6d42                	ld	s10,16(sp)
    80003c48:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c4a:	8556                	mv	a0,s5
    80003c4c:	b27ff0ef          	jal	80003772 <iupdate>

  return tot;
    80003c50:	0009851b          	sext.w	a0,s3
    80003c54:	69a6                	ld	s3,72(sp)
}
    80003c56:	70a6                	ld	ra,104(sp)
    80003c58:	7406                	ld	s0,96(sp)
    80003c5a:	6946                	ld	s2,80(sp)
    80003c5c:	6a06                	ld	s4,64(sp)
    80003c5e:	7ae2                	ld	s5,56(sp)
    80003c60:	7b42                	ld	s6,48(sp)
    80003c62:	7ba2                	ld	s7,40(sp)
    80003c64:	6165                	addi	sp,sp,112
    80003c66:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c68:	89da                	mv	s3,s6
    80003c6a:	b7c5                	j	80003c4a <writei+0xd4>
    80003c6c:	64e6                	ld	s1,88(sp)
    80003c6e:	7c02                	ld	s8,32(sp)
    80003c70:	6ce2                	ld	s9,24(sp)
    80003c72:	6d42                	ld	s10,16(sp)
    80003c74:	6da2                	ld	s11,8(sp)
    80003c76:	bfd1                	j	80003c4a <writei+0xd4>
    return -1;
    80003c78:	557d                	li	a0,-1
}
    80003c7a:	8082                	ret
    return -1;
    80003c7c:	557d                	li	a0,-1
    80003c7e:	bfe1                	j	80003c56 <writei+0xe0>
    return -1;
    80003c80:	557d                	li	a0,-1
    80003c82:	bfd1                	j	80003c56 <writei+0xe0>

0000000080003c84 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c84:	1141                	addi	sp,sp,-16
    80003c86:	e406                	sd	ra,8(sp)
    80003c88:	e022                	sd	s0,0(sp)
    80003c8a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c8c:	4639                	li	a2,14
    80003c8e:	914fd0ef          	jal	80000da2 <strncmp>
}
    80003c92:	60a2                	ld	ra,8(sp)
    80003c94:	6402                	ld	s0,0(sp)
    80003c96:	0141                	addi	sp,sp,16
    80003c98:	8082                	ret

0000000080003c9a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c9a:	7139                	addi	sp,sp,-64
    80003c9c:	fc06                	sd	ra,56(sp)
    80003c9e:	f822                	sd	s0,48(sp)
    80003ca0:	f426                	sd	s1,40(sp)
    80003ca2:	f04a                	sd	s2,32(sp)
    80003ca4:	ec4e                	sd	s3,24(sp)
    80003ca6:	e852                	sd	s4,16(sp)
    80003ca8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003caa:	04451703          	lh	a4,68(a0)
    80003cae:	4785                	li	a5,1
    80003cb0:	00f71a63          	bne	a4,a5,80003cc4 <dirlookup+0x2a>
    80003cb4:	892a                	mv	s2,a0
    80003cb6:	89ae                	mv	s3,a1
    80003cb8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cba:	457c                	lw	a5,76(a0)
    80003cbc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cbe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cc0:	e39d                	bnez	a5,80003ce6 <dirlookup+0x4c>
    80003cc2:	a095                	j	80003d26 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003cc4:	00005517          	auipc	a0,0x5
    80003cc8:	9a450513          	addi	a0,a0,-1628 # 80008668 <etext+0x668>
    80003ccc:	ad7fc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003cd0:	00005517          	auipc	a0,0x5
    80003cd4:	9b050513          	addi	a0,a0,-1616 # 80008680 <etext+0x680>
    80003cd8:	acbfc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cdc:	24c1                	addiw	s1,s1,16
    80003cde:	04c92783          	lw	a5,76(s2)
    80003ce2:	04f4f163          	bgeu	s1,a5,80003d24 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ce6:	4741                	li	a4,16
    80003ce8:	86a6                	mv	a3,s1
    80003cea:	fc040613          	addi	a2,s0,-64
    80003cee:	4581                	li	a1,0
    80003cf0:	854a                	mv	a0,s2
    80003cf2:	d89ff0ef          	jal	80003a7a <readi>
    80003cf6:	47c1                	li	a5,16
    80003cf8:	fcf51ce3          	bne	a0,a5,80003cd0 <dirlookup+0x36>
    if(de.inum == 0)
    80003cfc:	fc045783          	lhu	a5,-64(s0)
    80003d00:	dff1                	beqz	a5,80003cdc <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003d02:	fc240593          	addi	a1,s0,-62
    80003d06:	854e                	mv	a0,s3
    80003d08:	f7dff0ef          	jal	80003c84 <namecmp>
    80003d0c:	f961                	bnez	a0,80003cdc <dirlookup+0x42>
      if(poff)
    80003d0e:	000a0463          	beqz	s4,80003d16 <dirlookup+0x7c>
        *poff = off;
    80003d12:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d16:	fc045583          	lhu	a1,-64(s0)
    80003d1a:	00092503          	lw	a0,0(s2)
    80003d1e:	829ff0ef          	jal	80003546 <iget>
    80003d22:	a011                	j	80003d26 <dirlookup+0x8c>
  return 0;
    80003d24:	4501                	li	a0,0
}
    80003d26:	70e2                	ld	ra,56(sp)
    80003d28:	7442                	ld	s0,48(sp)
    80003d2a:	74a2                	ld	s1,40(sp)
    80003d2c:	7902                	ld	s2,32(sp)
    80003d2e:	69e2                	ld	s3,24(sp)
    80003d30:	6a42                	ld	s4,16(sp)
    80003d32:	6121                	addi	sp,sp,64
    80003d34:	8082                	ret

0000000080003d36 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d36:	711d                	addi	sp,sp,-96
    80003d38:	ec86                	sd	ra,88(sp)
    80003d3a:	e8a2                	sd	s0,80(sp)
    80003d3c:	e4a6                	sd	s1,72(sp)
    80003d3e:	e0ca                	sd	s2,64(sp)
    80003d40:	fc4e                	sd	s3,56(sp)
    80003d42:	f852                	sd	s4,48(sp)
    80003d44:	f456                	sd	s5,40(sp)
    80003d46:	f05a                	sd	s6,32(sp)
    80003d48:	ec5e                	sd	s7,24(sp)
    80003d4a:	e862                	sd	s8,16(sp)
    80003d4c:	e466                	sd	s9,8(sp)
    80003d4e:	1080                	addi	s0,sp,96
    80003d50:	84aa                	mv	s1,a0
    80003d52:	8b2e                	mv	s6,a1
    80003d54:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d56:	00054703          	lbu	a4,0(a0)
    80003d5a:	02f00793          	li	a5,47
    80003d5e:	00f70e63          	beq	a4,a5,80003d7a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d62:	b9ffd0ef          	jal	80001900 <myproc>
    80003d66:	19053503          	ld	a0,400(a0)
    80003d6a:	a87ff0ef          	jal	800037f0 <idup>
    80003d6e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d70:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d74:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d76:	4b85                	li	s7,1
    80003d78:	a871                	j	80003e14 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003d7a:	4585                	li	a1,1
    80003d7c:	4505                	li	a0,1
    80003d7e:	fc8ff0ef          	jal	80003546 <iget>
    80003d82:	8a2a                	mv	s4,a0
    80003d84:	b7f5                	j	80003d70 <namex+0x3a>
      iunlockput(ip);
    80003d86:	8552                	mv	a0,s4
    80003d88:	ca9ff0ef          	jal	80003a30 <iunlockput>
      return 0;
    80003d8c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d8e:	8552                	mv	a0,s4
    80003d90:	60e6                	ld	ra,88(sp)
    80003d92:	6446                	ld	s0,80(sp)
    80003d94:	64a6                	ld	s1,72(sp)
    80003d96:	6906                	ld	s2,64(sp)
    80003d98:	79e2                	ld	s3,56(sp)
    80003d9a:	7a42                	ld	s4,48(sp)
    80003d9c:	7aa2                	ld	s5,40(sp)
    80003d9e:	7b02                	ld	s6,32(sp)
    80003da0:	6be2                	ld	s7,24(sp)
    80003da2:	6c42                	ld	s8,16(sp)
    80003da4:	6ca2                	ld	s9,8(sp)
    80003da6:	6125                	addi	sp,sp,96
    80003da8:	8082                	ret
      iunlock(ip);
    80003daa:	8552                	mv	a0,s4
    80003dac:	b29ff0ef          	jal	800038d4 <iunlock>
      return ip;
    80003db0:	bff9                	j	80003d8e <namex+0x58>
      iunlockput(ip);
    80003db2:	8552                	mv	a0,s4
    80003db4:	c7dff0ef          	jal	80003a30 <iunlockput>
      return 0;
    80003db8:	8a4e                	mv	s4,s3
    80003dba:	bfd1                	j	80003d8e <namex+0x58>
  len = path - s;
    80003dbc:	40998633          	sub	a2,s3,s1
    80003dc0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003dc4:	099c5063          	bge	s8,s9,80003e44 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003dc8:	4639                	li	a2,14
    80003dca:	85a6                	mv	a1,s1
    80003dcc:	8556                	mv	a0,s5
    80003dce:	f65fc0ef          	jal	80000d32 <memmove>
    80003dd2:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dd4:	0004c783          	lbu	a5,0(s1)
    80003dd8:	01279763          	bne	a5,s2,80003de6 <namex+0xb0>
    path++;
    80003ddc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dde:	0004c783          	lbu	a5,0(s1)
    80003de2:	ff278de3          	beq	a5,s2,80003ddc <namex+0xa6>
    ilock(ip);
    80003de6:	8552                	mv	a0,s4
    80003de8:	a3fff0ef          	jal	80003826 <ilock>
    if(ip->type != T_DIR){
    80003dec:	044a1783          	lh	a5,68(s4)
    80003df0:	f9779be3          	bne	a5,s7,80003d86 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003df4:	000b0563          	beqz	s6,80003dfe <namex+0xc8>
    80003df8:	0004c783          	lbu	a5,0(s1)
    80003dfc:	d7dd                	beqz	a5,80003daa <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dfe:	4601                	li	a2,0
    80003e00:	85d6                	mv	a1,s5
    80003e02:	8552                	mv	a0,s4
    80003e04:	e97ff0ef          	jal	80003c9a <dirlookup>
    80003e08:	89aa                	mv	s3,a0
    80003e0a:	d545                	beqz	a0,80003db2 <namex+0x7c>
    iunlockput(ip);
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	c23ff0ef          	jal	80003a30 <iunlockput>
    ip = next;
    80003e12:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e14:	0004c783          	lbu	a5,0(s1)
    80003e18:	01279763          	bne	a5,s2,80003e26 <namex+0xf0>
    path++;
    80003e1c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e1e:	0004c783          	lbu	a5,0(s1)
    80003e22:	ff278de3          	beq	a5,s2,80003e1c <namex+0xe6>
  if(*path == 0)
    80003e26:	cb8d                	beqz	a5,80003e58 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003e28:	0004c783          	lbu	a5,0(s1)
    80003e2c:	89a6                	mv	s3,s1
  len = path - s;
    80003e2e:	4c81                	li	s9,0
    80003e30:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e32:	01278963          	beq	a5,s2,80003e44 <namex+0x10e>
    80003e36:	d3d9                	beqz	a5,80003dbc <namex+0x86>
    path++;
    80003e38:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e3a:	0009c783          	lbu	a5,0(s3)
    80003e3e:	ff279ce3          	bne	a5,s2,80003e36 <namex+0x100>
    80003e42:	bfad                	j	80003dbc <namex+0x86>
    memmove(name, s, len);
    80003e44:	2601                	sext.w	a2,a2
    80003e46:	85a6                	mv	a1,s1
    80003e48:	8556                	mv	a0,s5
    80003e4a:	ee9fc0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003e4e:	9cd6                	add	s9,s9,s5
    80003e50:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e54:	84ce                	mv	s1,s3
    80003e56:	bfbd                	j	80003dd4 <namex+0x9e>
  if(nameiparent){
    80003e58:	f20b0be3          	beqz	s6,80003d8e <namex+0x58>
    iput(ip);
    80003e5c:	8552                	mv	a0,s4
    80003e5e:	b4bff0ef          	jal	800039a8 <iput>
    return 0;
    80003e62:	4a01                	li	s4,0
    80003e64:	b72d                	j	80003d8e <namex+0x58>

0000000080003e66 <dirlink>:
{
    80003e66:	7139                	addi	sp,sp,-64
    80003e68:	fc06                	sd	ra,56(sp)
    80003e6a:	f822                	sd	s0,48(sp)
    80003e6c:	f04a                	sd	s2,32(sp)
    80003e6e:	ec4e                	sd	s3,24(sp)
    80003e70:	e852                	sd	s4,16(sp)
    80003e72:	0080                	addi	s0,sp,64
    80003e74:	892a                	mv	s2,a0
    80003e76:	8a2e                	mv	s4,a1
    80003e78:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e7a:	4601                	li	a2,0
    80003e7c:	e1fff0ef          	jal	80003c9a <dirlookup>
    80003e80:	e535                	bnez	a0,80003eec <dirlink+0x86>
    80003e82:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e84:	04c92483          	lw	s1,76(s2)
    80003e88:	c48d                	beqz	s1,80003eb2 <dirlink+0x4c>
    80003e8a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e8c:	4741                	li	a4,16
    80003e8e:	86a6                	mv	a3,s1
    80003e90:	fc040613          	addi	a2,s0,-64
    80003e94:	4581                	li	a1,0
    80003e96:	854a                	mv	a0,s2
    80003e98:	be3ff0ef          	jal	80003a7a <readi>
    80003e9c:	47c1                	li	a5,16
    80003e9e:	04f51b63          	bne	a0,a5,80003ef4 <dirlink+0x8e>
    if(de.inum == 0)
    80003ea2:	fc045783          	lhu	a5,-64(s0)
    80003ea6:	c791                	beqz	a5,80003eb2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ea8:	24c1                	addiw	s1,s1,16
    80003eaa:	04c92783          	lw	a5,76(s2)
    80003eae:	fcf4efe3          	bltu	s1,a5,80003e8c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003eb2:	4639                	li	a2,14
    80003eb4:	85d2                	mv	a1,s4
    80003eb6:	fc240513          	addi	a0,s0,-62
    80003eba:	f1ffc0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003ebe:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ec2:	4741                	li	a4,16
    80003ec4:	86a6                	mv	a3,s1
    80003ec6:	fc040613          	addi	a2,s0,-64
    80003eca:	4581                	li	a1,0
    80003ecc:	854a                	mv	a0,s2
    80003ece:	ca9ff0ef          	jal	80003b76 <writei>
    80003ed2:	1541                	addi	a0,a0,-16
    80003ed4:	00a03533          	snez	a0,a0
    80003ed8:	40a00533          	neg	a0,a0
    80003edc:	74a2                	ld	s1,40(sp)
}
    80003ede:	70e2                	ld	ra,56(sp)
    80003ee0:	7442                	ld	s0,48(sp)
    80003ee2:	7902                	ld	s2,32(sp)
    80003ee4:	69e2                	ld	s3,24(sp)
    80003ee6:	6a42                	ld	s4,16(sp)
    80003ee8:	6121                	addi	sp,sp,64
    80003eea:	8082                	ret
    iput(ip);
    80003eec:	abdff0ef          	jal	800039a8 <iput>
    return -1;
    80003ef0:	557d                	li	a0,-1
    80003ef2:	b7f5                	j	80003ede <dirlink+0x78>
      panic("dirlink read");
    80003ef4:	00004517          	auipc	a0,0x4
    80003ef8:	79c50513          	addi	a0,a0,1948 # 80008690 <etext+0x690>
    80003efc:	8a7fc0ef          	jal	800007a2 <panic>

0000000080003f00 <namei>:

struct inode*
namei(char *path)
{
    80003f00:	1101                	addi	sp,sp,-32
    80003f02:	ec06                	sd	ra,24(sp)
    80003f04:	e822                	sd	s0,16(sp)
    80003f06:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f08:	fe040613          	addi	a2,s0,-32
    80003f0c:	4581                	li	a1,0
    80003f0e:	e29ff0ef          	jal	80003d36 <namex>
}
    80003f12:	60e2                	ld	ra,24(sp)
    80003f14:	6442                	ld	s0,16(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret

0000000080003f1a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f1a:	1141                	addi	sp,sp,-16
    80003f1c:	e406                	sd	ra,8(sp)
    80003f1e:	e022                	sd	s0,0(sp)
    80003f20:	0800                	addi	s0,sp,16
    80003f22:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f24:	4585                	li	a1,1
    80003f26:	e11ff0ef          	jal	80003d36 <namex>
}
    80003f2a:	60a2                	ld	ra,8(sp)
    80003f2c:	6402                	ld	s0,0(sp)
    80003f2e:	0141                	addi	sp,sp,16
    80003f30:	8082                	ret

0000000080003f32 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f32:	1101                	addi	sp,sp,-32
    80003f34:	ec06                	sd	ra,24(sp)
    80003f36:	e822                	sd	s0,16(sp)
    80003f38:	e426                	sd	s1,8(sp)
    80003f3a:	e04a                	sd	s2,0(sp)
    80003f3c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f3e:	00027917          	auipc	s2,0x27
    80003f42:	27a90913          	addi	s2,s2,634 # 8002b1b8 <log>
    80003f46:	01892583          	lw	a1,24(s2)
    80003f4a:	02892503          	lw	a0,40(s2)
    80003f4e:	9a0ff0ef          	jal	800030ee <bread>
    80003f52:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f54:	02c92603          	lw	a2,44(s2)
    80003f58:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f5a:	00c05f63          	blez	a2,80003f78 <write_head+0x46>
    80003f5e:	00027717          	auipc	a4,0x27
    80003f62:	28a70713          	addi	a4,a4,650 # 8002b1e8 <log+0x30>
    80003f66:	87aa                	mv	a5,a0
    80003f68:	060a                	slli	a2,a2,0x2
    80003f6a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f6c:	4314                	lw	a3,0(a4)
    80003f6e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f70:	0711                	addi	a4,a4,4
    80003f72:	0791                	addi	a5,a5,4
    80003f74:	fec79ce3          	bne	a5,a2,80003f6c <write_head+0x3a>
  }
  bwrite(buf);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	a4aff0ef          	jal	800031c4 <bwrite>
  brelse(buf);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	a76ff0ef          	jal	800031f6 <brelse>
}
    80003f84:	60e2                	ld	ra,24(sp)
    80003f86:	6442                	ld	s0,16(sp)
    80003f88:	64a2                	ld	s1,8(sp)
    80003f8a:	6902                	ld	s2,0(sp)
    80003f8c:	6105                	addi	sp,sp,32
    80003f8e:	8082                	ret

0000000080003f90 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f90:	00027797          	auipc	a5,0x27
    80003f94:	2547a783          	lw	a5,596(a5) # 8002b1e4 <log+0x2c>
    80003f98:	08f05f63          	blez	a5,80004036 <install_trans+0xa6>
{
    80003f9c:	7139                	addi	sp,sp,-64
    80003f9e:	fc06                	sd	ra,56(sp)
    80003fa0:	f822                	sd	s0,48(sp)
    80003fa2:	f426                	sd	s1,40(sp)
    80003fa4:	f04a                	sd	s2,32(sp)
    80003fa6:	ec4e                	sd	s3,24(sp)
    80003fa8:	e852                	sd	s4,16(sp)
    80003faa:	e456                	sd	s5,8(sp)
    80003fac:	e05a                	sd	s6,0(sp)
    80003fae:	0080                	addi	s0,sp,64
    80003fb0:	8b2a                	mv	s6,a0
    80003fb2:	00027a97          	auipc	s5,0x27
    80003fb6:	236a8a93          	addi	s5,s5,566 # 8002b1e8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fba:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fbc:	00027997          	auipc	s3,0x27
    80003fc0:	1fc98993          	addi	s3,s3,508 # 8002b1b8 <log>
    80003fc4:	a829                	j	80003fde <install_trans+0x4e>
    brelse(lbuf);
    80003fc6:	854a                	mv	a0,s2
    80003fc8:	a2eff0ef          	jal	800031f6 <brelse>
    brelse(dbuf);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	a28ff0ef          	jal	800031f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd2:	2a05                	addiw	s4,s4,1
    80003fd4:	0a91                	addi	s5,s5,4
    80003fd6:	02c9a783          	lw	a5,44(s3)
    80003fda:	04fa5463          	bge	s4,a5,80004022 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fde:	0189a583          	lw	a1,24(s3)
    80003fe2:	014585bb          	addw	a1,a1,s4
    80003fe6:	2585                	addiw	a1,a1,1
    80003fe8:	0289a503          	lw	a0,40(s3)
    80003fec:	902ff0ef          	jal	800030ee <bread>
    80003ff0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ff2:	000aa583          	lw	a1,0(s5)
    80003ff6:	0289a503          	lw	a0,40(s3)
    80003ffa:	8f4ff0ef          	jal	800030ee <bread>
    80003ffe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004000:	40000613          	li	a2,1024
    80004004:	05890593          	addi	a1,s2,88
    80004008:	05850513          	addi	a0,a0,88
    8000400c:	d27fc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004010:	8526                	mv	a0,s1
    80004012:	9b2ff0ef          	jal	800031c4 <bwrite>
    if(recovering == 0)
    80004016:	fa0b18e3          	bnez	s6,80003fc6 <install_trans+0x36>
      bunpin(dbuf);
    8000401a:	8526                	mv	a0,s1
    8000401c:	a96ff0ef          	jal	800032b2 <bunpin>
    80004020:	b75d                	j	80003fc6 <install_trans+0x36>
}
    80004022:	70e2                	ld	ra,56(sp)
    80004024:	7442                	ld	s0,48(sp)
    80004026:	74a2                	ld	s1,40(sp)
    80004028:	7902                	ld	s2,32(sp)
    8000402a:	69e2                	ld	s3,24(sp)
    8000402c:	6a42                	ld	s4,16(sp)
    8000402e:	6aa2                	ld	s5,8(sp)
    80004030:	6b02                	ld	s6,0(sp)
    80004032:	6121                	addi	sp,sp,64
    80004034:	8082                	ret
    80004036:	8082                	ret

0000000080004038 <initlog>:
{
    80004038:	7179                	addi	sp,sp,-48
    8000403a:	f406                	sd	ra,40(sp)
    8000403c:	f022                	sd	s0,32(sp)
    8000403e:	ec26                	sd	s1,24(sp)
    80004040:	e84a                	sd	s2,16(sp)
    80004042:	e44e                	sd	s3,8(sp)
    80004044:	1800                	addi	s0,sp,48
    80004046:	892a                	mv	s2,a0
    80004048:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000404a:	00027497          	auipc	s1,0x27
    8000404e:	16e48493          	addi	s1,s1,366 # 8002b1b8 <log>
    80004052:	00004597          	auipc	a1,0x4
    80004056:	64e58593          	addi	a1,a1,1614 # 800086a0 <etext+0x6a0>
    8000405a:	8526                	mv	a0,s1
    8000405c:	b27fc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80004060:	0149a583          	lw	a1,20(s3)
    80004064:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004066:	0109a783          	lw	a5,16(s3)
    8000406a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000406c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004070:	854a                	mv	a0,s2
    80004072:	87cff0ef          	jal	800030ee <bread>
  log.lh.n = lh->n;
    80004076:	4d30                	lw	a2,88(a0)
    80004078:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000407a:	00c05f63          	blez	a2,80004098 <initlog+0x60>
    8000407e:	87aa                	mv	a5,a0
    80004080:	00027717          	auipc	a4,0x27
    80004084:	16870713          	addi	a4,a4,360 # 8002b1e8 <log+0x30>
    80004088:	060a                	slli	a2,a2,0x2
    8000408a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000408c:	4ff4                	lw	a3,92(a5)
    8000408e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004090:	0791                	addi	a5,a5,4
    80004092:	0711                	addi	a4,a4,4
    80004094:	fec79ce3          	bne	a5,a2,8000408c <initlog+0x54>
  brelse(buf);
    80004098:	95eff0ef          	jal	800031f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000409c:	4505                	li	a0,1
    8000409e:	ef3ff0ef          	jal	80003f90 <install_trans>
  log.lh.n = 0;
    800040a2:	00027797          	auipc	a5,0x27
    800040a6:	1407a123          	sw	zero,322(a5) # 8002b1e4 <log+0x2c>
  write_head(); // clear the log
    800040aa:	e89ff0ef          	jal	80003f32 <write_head>
}
    800040ae:	70a2                	ld	ra,40(sp)
    800040b0:	7402                	ld	s0,32(sp)
    800040b2:	64e2                	ld	s1,24(sp)
    800040b4:	6942                	ld	s2,16(sp)
    800040b6:	69a2                	ld	s3,8(sp)
    800040b8:	6145                	addi	sp,sp,48
    800040ba:	8082                	ret

00000000800040bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040bc:	1101                	addi	sp,sp,-32
    800040be:	ec06                	sd	ra,24(sp)
    800040c0:	e822                	sd	s0,16(sp)
    800040c2:	e426                	sd	s1,8(sp)
    800040c4:	e04a                	sd	s2,0(sp)
    800040c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040c8:	00027517          	auipc	a0,0x27
    800040cc:	0f050513          	addi	a0,a0,240 # 8002b1b8 <log>
    800040d0:	b33fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    800040d4:	00027497          	auipc	s1,0x27
    800040d8:	0e448493          	addi	s1,s1,228 # 8002b1b8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040dc:	4979                	li	s2,30
    800040de:	a029                	j	800040e8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800040e0:	85a6                	mv	a1,s1
    800040e2:	8526                	mv	a0,s1
    800040e4:	83afe0ef          	jal	8000211e <sleep>
    if(log.committing){
    800040e8:	50dc                	lw	a5,36(s1)
    800040ea:	fbfd                	bnez	a5,800040e0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040ec:	5098                	lw	a4,32(s1)
    800040ee:	2705                	addiw	a4,a4,1
    800040f0:	0027179b          	slliw	a5,a4,0x2
    800040f4:	9fb9                	addw	a5,a5,a4
    800040f6:	0017979b          	slliw	a5,a5,0x1
    800040fa:	54d4                	lw	a3,44(s1)
    800040fc:	9fb5                	addw	a5,a5,a3
    800040fe:	00f95763          	bge	s2,a5,8000410c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004102:	85a6                	mv	a1,s1
    80004104:	8526                	mv	a0,s1
    80004106:	818fe0ef          	jal	8000211e <sleep>
    8000410a:	bff9                	j	800040e8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000410c:	00027517          	auipc	a0,0x27
    80004110:	0ac50513          	addi	a0,a0,172 # 8002b1b8 <log>
    80004114:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004116:	b85fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    8000411a:	60e2                	ld	ra,24(sp)
    8000411c:	6442                	ld	s0,16(sp)
    8000411e:	64a2                	ld	s1,8(sp)
    80004120:	6902                	ld	s2,0(sp)
    80004122:	6105                	addi	sp,sp,32
    80004124:	8082                	ret

0000000080004126 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004126:	7139                	addi	sp,sp,-64
    80004128:	fc06                	sd	ra,56(sp)
    8000412a:	f822                	sd	s0,48(sp)
    8000412c:	f426                	sd	s1,40(sp)
    8000412e:	f04a                	sd	s2,32(sp)
    80004130:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004132:	00027497          	auipc	s1,0x27
    80004136:	08648493          	addi	s1,s1,134 # 8002b1b8 <log>
    8000413a:	8526                	mv	a0,s1
    8000413c:	ac7fc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80004140:	509c                	lw	a5,32(s1)
    80004142:	37fd                	addiw	a5,a5,-1
    80004144:	0007891b          	sext.w	s2,a5
    80004148:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000414a:	50dc                	lw	a5,36(s1)
    8000414c:	ef9d                	bnez	a5,8000418a <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000414e:	04091763          	bnez	s2,8000419c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80004152:	00027497          	auipc	s1,0x27
    80004156:	06648493          	addi	s1,s1,102 # 8002b1b8 <log>
    8000415a:	4785                	li	a5,1
    8000415c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000415e:	8526                	mv	a0,s1
    80004160:	b3bfc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004164:	54dc                	lw	a5,44(s1)
    80004166:	04f04b63          	bgtz	a5,800041bc <end_op+0x96>
    acquire(&log.lock);
    8000416a:	00027497          	auipc	s1,0x27
    8000416e:	04e48493          	addi	s1,s1,78 # 8002b1b8 <log>
    80004172:	8526                	mv	a0,s1
    80004174:	a8ffc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    80004178:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000417c:	8526                	mv	a0,s1
    8000417e:	8ecfe0ef          	jal	8000226a <wakeup>
    release(&log.lock);
    80004182:	8526                	mv	a0,s1
    80004184:	b17fc0ef          	jal	80000c9a <release>
}
    80004188:	a025                	j	800041b0 <end_op+0x8a>
    8000418a:	ec4e                	sd	s3,24(sp)
    8000418c:	e852                	sd	s4,16(sp)
    8000418e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004190:	00004517          	auipc	a0,0x4
    80004194:	51850513          	addi	a0,a0,1304 # 800086a8 <etext+0x6a8>
    80004198:	e0afc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    8000419c:	00027497          	auipc	s1,0x27
    800041a0:	01c48493          	addi	s1,s1,28 # 8002b1b8 <log>
    800041a4:	8526                	mv	a0,s1
    800041a6:	8c4fe0ef          	jal	8000226a <wakeup>
  release(&log.lock);
    800041aa:	8526                	mv	a0,s1
    800041ac:	aeffc0ef          	jal	80000c9a <release>
}
    800041b0:	70e2                	ld	ra,56(sp)
    800041b2:	7442                	ld	s0,48(sp)
    800041b4:	74a2                	ld	s1,40(sp)
    800041b6:	7902                	ld	s2,32(sp)
    800041b8:	6121                	addi	sp,sp,64
    800041ba:	8082                	ret
    800041bc:	ec4e                	sd	s3,24(sp)
    800041be:	e852                	sd	s4,16(sp)
    800041c0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800041c2:	00027a97          	auipc	s5,0x27
    800041c6:	026a8a93          	addi	s5,s5,38 # 8002b1e8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041ca:	00027a17          	auipc	s4,0x27
    800041ce:	feea0a13          	addi	s4,s4,-18 # 8002b1b8 <log>
    800041d2:	018a2583          	lw	a1,24(s4)
    800041d6:	012585bb          	addw	a1,a1,s2
    800041da:	2585                	addiw	a1,a1,1
    800041dc:	028a2503          	lw	a0,40(s4)
    800041e0:	f0ffe0ef          	jal	800030ee <bread>
    800041e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041e6:	000aa583          	lw	a1,0(s5)
    800041ea:	028a2503          	lw	a0,40(s4)
    800041ee:	f01fe0ef          	jal	800030ee <bread>
    800041f2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800041f4:	40000613          	li	a2,1024
    800041f8:	05850593          	addi	a1,a0,88
    800041fc:	05848513          	addi	a0,s1,88
    80004200:	b33fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80004204:	8526                	mv	a0,s1
    80004206:	fbffe0ef          	jal	800031c4 <bwrite>
    brelse(from);
    8000420a:	854e                	mv	a0,s3
    8000420c:	febfe0ef          	jal	800031f6 <brelse>
    brelse(to);
    80004210:	8526                	mv	a0,s1
    80004212:	fe5fe0ef          	jal	800031f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004216:	2905                	addiw	s2,s2,1
    80004218:	0a91                	addi	s5,s5,4
    8000421a:	02ca2783          	lw	a5,44(s4)
    8000421e:	faf94ae3          	blt	s2,a5,800041d2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004222:	d11ff0ef          	jal	80003f32 <write_head>
    install_trans(0); // Now install writes to home locations
    80004226:	4501                	li	a0,0
    80004228:	d69ff0ef          	jal	80003f90 <install_trans>
    log.lh.n = 0;
    8000422c:	00027797          	auipc	a5,0x27
    80004230:	fa07ac23          	sw	zero,-72(a5) # 8002b1e4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004234:	cffff0ef          	jal	80003f32 <write_head>
    80004238:	69e2                	ld	s3,24(sp)
    8000423a:	6a42                	ld	s4,16(sp)
    8000423c:	6aa2                	ld	s5,8(sp)
    8000423e:	b735                	j	8000416a <end_op+0x44>

0000000080004240 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004240:	1101                	addi	sp,sp,-32
    80004242:	ec06                	sd	ra,24(sp)
    80004244:	e822                	sd	s0,16(sp)
    80004246:	e426                	sd	s1,8(sp)
    80004248:	e04a                	sd	s2,0(sp)
    8000424a:	1000                	addi	s0,sp,32
    8000424c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000424e:	00027917          	auipc	s2,0x27
    80004252:	f6a90913          	addi	s2,s2,-150 # 8002b1b8 <log>
    80004256:	854a                	mv	a0,s2
    80004258:	9abfc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000425c:	02c92603          	lw	a2,44(s2)
    80004260:	47f5                	li	a5,29
    80004262:	06c7c363          	blt	a5,a2,800042c8 <log_write+0x88>
    80004266:	00027797          	auipc	a5,0x27
    8000426a:	f6e7a783          	lw	a5,-146(a5) # 8002b1d4 <log+0x1c>
    8000426e:	37fd                	addiw	a5,a5,-1
    80004270:	04f65c63          	bge	a2,a5,800042c8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004274:	00027797          	auipc	a5,0x27
    80004278:	f647a783          	lw	a5,-156(a5) # 8002b1d8 <log+0x20>
    8000427c:	04f05c63          	blez	a5,800042d4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004280:	4781                	li	a5,0
    80004282:	04c05f63          	blez	a2,800042e0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004286:	44cc                	lw	a1,12(s1)
    80004288:	00027717          	auipc	a4,0x27
    8000428c:	f6070713          	addi	a4,a4,-160 # 8002b1e8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004290:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004292:	4314                	lw	a3,0(a4)
    80004294:	04b68663          	beq	a3,a1,800042e0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004298:	2785                	addiw	a5,a5,1
    8000429a:	0711                	addi	a4,a4,4
    8000429c:	fef61be3          	bne	a2,a5,80004292 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042a0:	0621                	addi	a2,a2,8
    800042a2:	060a                	slli	a2,a2,0x2
    800042a4:	00027797          	auipc	a5,0x27
    800042a8:	f1478793          	addi	a5,a5,-236 # 8002b1b8 <log>
    800042ac:	97b2                	add	a5,a5,a2
    800042ae:	44d8                	lw	a4,12(s1)
    800042b0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042b2:	8526                	mv	a0,s1
    800042b4:	fcbfe0ef          	jal	8000327e <bpin>
    log.lh.n++;
    800042b8:	00027717          	auipc	a4,0x27
    800042bc:	f0070713          	addi	a4,a4,-256 # 8002b1b8 <log>
    800042c0:	575c                	lw	a5,44(a4)
    800042c2:	2785                	addiw	a5,a5,1
    800042c4:	d75c                	sw	a5,44(a4)
    800042c6:	a80d                	j	800042f8 <log_write+0xb8>
    panic("too big a transaction");
    800042c8:	00004517          	auipc	a0,0x4
    800042cc:	3f050513          	addi	a0,a0,1008 # 800086b8 <etext+0x6b8>
    800042d0:	cd2fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    800042d4:	00004517          	auipc	a0,0x4
    800042d8:	3fc50513          	addi	a0,a0,1020 # 800086d0 <etext+0x6d0>
    800042dc:	cc6fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    800042e0:	00878693          	addi	a3,a5,8
    800042e4:	068a                	slli	a3,a3,0x2
    800042e6:	00027717          	auipc	a4,0x27
    800042ea:	ed270713          	addi	a4,a4,-302 # 8002b1b8 <log>
    800042ee:	9736                	add	a4,a4,a3
    800042f0:	44d4                	lw	a3,12(s1)
    800042f2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800042f4:	faf60fe3          	beq	a2,a5,800042b2 <log_write+0x72>
  }
  release(&log.lock);
    800042f8:	00027517          	auipc	a0,0x27
    800042fc:	ec050513          	addi	a0,a0,-320 # 8002b1b8 <log>
    80004300:	99bfc0ef          	jal	80000c9a <release>
}
    80004304:	60e2                	ld	ra,24(sp)
    80004306:	6442                	ld	s0,16(sp)
    80004308:	64a2                	ld	s1,8(sp)
    8000430a:	6902                	ld	s2,0(sp)
    8000430c:	6105                	addi	sp,sp,32
    8000430e:	8082                	ret

0000000080004310 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004310:	1101                	addi	sp,sp,-32
    80004312:	ec06                	sd	ra,24(sp)
    80004314:	e822                	sd	s0,16(sp)
    80004316:	e426                	sd	s1,8(sp)
    80004318:	e04a                	sd	s2,0(sp)
    8000431a:	1000                	addi	s0,sp,32
    8000431c:	84aa                	mv	s1,a0
    8000431e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004320:	00004597          	auipc	a1,0x4
    80004324:	3d058593          	addi	a1,a1,976 # 800086f0 <etext+0x6f0>
    80004328:	0521                	addi	a0,a0,8
    8000432a:	859fc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    8000432e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004332:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004336:	0204a423          	sw	zero,40(s1)
}
    8000433a:	60e2                	ld	ra,24(sp)
    8000433c:	6442                	ld	s0,16(sp)
    8000433e:	64a2                	ld	s1,8(sp)
    80004340:	6902                	ld	s2,0(sp)
    80004342:	6105                	addi	sp,sp,32
    80004344:	8082                	ret

0000000080004346 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004346:	1101                	addi	sp,sp,-32
    80004348:	ec06                	sd	ra,24(sp)
    8000434a:	e822                	sd	s0,16(sp)
    8000434c:	e426                	sd	s1,8(sp)
    8000434e:	e04a                	sd	s2,0(sp)
    80004350:	1000                	addi	s0,sp,32
    80004352:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004354:	00850913          	addi	s2,a0,8
    80004358:	854a                	mv	a0,s2
    8000435a:	8a9fc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    8000435e:	409c                	lw	a5,0(s1)
    80004360:	c799                	beqz	a5,8000436e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004362:	85ca                	mv	a1,s2
    80004364:	8526                	mv	a0,s1
    80004366:	db9fd0ef          	jal	8000211e <sleep>
  while (lk->locked) {
    8000436a:	409c                	lw	a5,0(s1)
    8000436c:	fbfd                	bnez	a5,80004362 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000436e:	4785                	li	a5,1
    80004370:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004372:	d8efd0ef          	jal	80001900 <myproc>
    80004376:	591c                	lw	a5,48(a0)
    80004378:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000437a:	854a                	mv	a0,s2
    8000437c:	91ffc0ef          	jal	80000c9a <release>
}
    80004380:	60e2                	ld	ra,24(sp)
    80004382:	6442                	ld	s0,16(sp)
    80004384:	64a2                	ld	s1,8(sp)
    80004386:	6902                	ld	s2,0(sp)
    80004388:	6105                	addi	sp,sp,32
    8000438a:	8082                	ret

000000008000438c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000438c:	1101                	addi	sp,sp,-32
    8000438e:	ec06                	sd	ra,24(sp)
    80004390:	e822                	sd	s0,16(sp)
    80004392:	e426                	sd	s1,8(sp)
    80004394:	e04a                	sd	s2,0(sp)
    80004396:	1000                	addi	s0,sp,32
    80004398:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000439a:	00850913          	addi	s2,a0,8
    8000439e:	854a                	mv	a0,s2
    800043a0:	863fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    800043a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043a8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043ac:	8526                	mv	a0,s1
    800043ae:	ebdfd0ef          	jal	8000226a <wakeup>
  release(&lk->lk);
    800043b2:	854a                	mv	a0,s2
    800043b4:	8e7fc0ef          	jal	80000c9a <release>
}
    800043b8:	60e2                	ld	ra,24(sp)
    800043ba:	6442                	ld	s0,16(sp)
    800043bc:	64a2                	ld	s1,8(sp)
    800043be:	6902                	ld	s2,0(sp)
    800043c0:	6105                	addi	sp,sp,32
    800043c2:	8082                	ret

00000000800043c4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043c4:	7179                	addi	sp,sp,-48
    800043c6:	f406                	sd	ra,40(sp)
    800043c8:	f022                	sd	s0,32(sp)
    800043ca:	ec26                	sd	s1,24(sp)
    800043cc:	e84a                	sd	s2,16(sp)
    800043ce:	1800                	addi	s0,sp,48
    800043d0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043d2:	00850913          	addi	s2,a0,8
    800043d6:	854a                	mv	a0,s2
    800043d8:	82bfc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800043dc:	409c                	lw	a5,0(s1)
    800043de:	ef81                	bnez	a5,800043f6 <holdingsleep+0x32>
    800043e0:	4481                	li	s1,0
  release(&lk->lk);
    800043e2:	854a                	mv	a0,s2
    800043e4:	8b7fc0ef          	jal	80000c9a <release>
  return r;
}
    800043e8:	8526                	mv	a0,s1
    800043ea:	70a2                	ld	ra,40(sp)
    800043ec:	7402                	ld	s0,32(sp)
    800043ee:	64e2                	ld	s1,24(sp)
    800043f0:	6942                	ld	s2,16(sp)
    800043f2:	6145                	addi	sp,sp,48
    800043f4:	8082                	ret
    800043f6:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800043f8:	0284a983          	lw	s3,40(s1)
    800043fc:	d04fd0ef          	jal	80001900 <myproc>
    80004400:	5904                	lw	s1,48(a0)
    80004402:	413484b3          	sub	s1,s1,s3
    80004406:	0014b493          	seqz	s1,s1
    8000440a:	69a2                	ld	s3,8(sp)
    8000440c:	bfd9                	j	800043e2 <holdingsleep+0x1e>

000000008000440e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000440e:	1141                	addi	sp,sp,-16
    80004410:	e406                	sd	ra,8(sp)
    80004412:	e022                	sd	s0,0(sp)
    80004414:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004416:	00004597          	auipc	a1,0x4
    8000441a:	2ea58593          	addi	a1,a1,746 # 80008700 <etext+0x700>
    8000441e:	00027517          	auipc	a0,0x27
    80004422:	ee250513          	addi	a0,a0,-286 # 8002b300 <ftable>
    80004426:	f5cfc0ef          	jal	80000b82 <initlock>
}
    8000442a:	60a2                	ld	ra,8(sp)
    8000442c:	6402                	ld	s0,0(sp)
    8000442e:	0141                	addi	sp,sp,16
    80004430:	8082                	ret

0000000080004432 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004432:	1101                	addi	sp,sp,-32
    80004434:	ec06                	sd	ra,24(sp)
    80004436:	e822                	sd	s0,16(sp)
    80004438:	e426                	sd	s1,8(sp)
    8000443a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000443c:	00027517          	auipc	a0,0x27
    80004440:	ec450513          	addi	a0,a0,-316 # 8002b300 <ftable>
    80004444:	fbefc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004448:	00027497          	auipc	s1,0x27
    8000444c:	ed048493          	addi	s1,s1,-304 # 8002b318 <ftable+0x18>
    80004450:	00028717          	auipc	a4,0x28
    80004454:	e6870713          	addi	a4,a4,-408 # 8002c2b8 <disk>
    if(f->ref == 0){
    80004458:	40dc                	lw	a5,4(s1)
    8000445a:	cf89                	beqz	a5,80004474 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000445c:	02848493          	addi	s1,s1,40
    80004460:	fee49ce3          	bne	s1,a4,80004458 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004464:	00027517          	auipc	a0,0x27
    80004468:	e9c50513          	addi	a0,a0,-356 # 8002b300 <ftable>
    8000446c:	82ffc0ef          	jal	80000c9a <release>
  return 0;
    80004470:	4481                	li	s1,0
    80004472:	a809                	j	80004484 <filealloc+0x52>
      f->ref = 1;
    80004474:	4785                	li	a5,1
    80004476:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004478:	00027517          	auipc	a0,0x27
    8000447c:	e8850513          	addi	a0,a0,-376 # 8002b300 <ftable>
    80004480:	81bfc0ef          	jal	80000c9a <release>
}
    80004484:	8526                	mv	a0,s1
    80004486:	60e2                	ld	ra,24(sp)
    80004488:	6442                	ld	s0,16(sp)
    8000448a:	64a2                	ld	s1,8(sp)
    8000448c:	6105                	addi	sp,sp,32
    8000448e:	8082                	ret

0000000080004490 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	1000                	addi	s0,sp,32
    8000449a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000449c:	00027517          	auipc	a0,0x27
    800044a0:	e6450513          	addi	a0,a0,-412 # 8002b300 <ftable>
    800044a4:	f5efc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800044a8:	40dc                	lw	a5,4(s1)
    800044aa:	02f05063          	blez	a5,800044ca <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044ae:	2785                	addiw	a5,a5,1
    800044b0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044b2:	00027517          	auipc	a0,0x27
    800044b6:	e4e50513          	addi	a0,a0,-434 # 8002b300 <ftable>
    800044ba:	fe0fc0ef          	jal	80000c9a <release>
  return f;
}
    800044be:	8526                	mv	a0,s1
    800044c0:	60e2                	ld	ra,24(sp)
    800044c2:	6442                	ld	s0,16(sp)
    800044c4:	64a2                	ld	s1,8(sp)
    800044c6:	6105                	addi	sp,sp,32
    800044c8:	8082                	ret
    panic("filedup");
    800044ca:	00004517          	auipc	a0,0x4
    800044ce:	23e50513          	addi	a0,a0,574 # 80008708 <etext+0x708>
    800044d2:	ad0fc0ef          	jal	800007a2 <panic>

00000000800044d6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044d6:	7139                	addi	sp,sp,-64
    800044d8:	fc06                	sd	ra,56(sp)
    800044da:	f822                	sd	s0,48(sp)
    800044dc:	f426                	sd	s1,40(sp)
    800044de:	0080                	addi	s0,sp,64
    800044e0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044e2:	00027517          	auipc	a0,0x27
    800044e6:	e1e50513          	addi	a0,a0,-482 # 8002b300 <ftable>
    800044ea:	f18fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800044ee:	40dc                	lw	a5,4(s1)
    800044f0:	04f05a63          	blez	a5,80004544 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800044f4:	37fd                	addiw	a5,a5,-1
    800044f6:	0007871b          	sext.w	a4,a5
    800044fa:	c0dc                	sw	a5,4(s1)
    800044fc:	04e04e63          	bgtz	a4,80004558 <fileclose+0x82>
    80004500:	f04a                	sd	s2,32(sp)
    80004502:	ec4e                	sd	s3,24(sp)
    80004504:	e852                	sd	s4,16(sp)
    80004506:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004508:	0004a903          	lw	s2,0(s1)
    8000450c:	0094ca83          	lbu	s5,9(s1)
    80004510:	0104ba03          	ld	s4,16(s1)
    80004514:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004518:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000451c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004520:	00027517          	auipc	a0,0x27
    80004524:	de050513          	addi	a0,a0,-544 # 8002b300 <ftable>
    80004528:	f72fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    8000452c:	4785                	li	a5,1
    8000452e:	04f90063          	beq	s2,a5,8000456e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004532:	3979                	addiw	s2,s2,-2
    80004534:	4785                	li	a5,1
    80004536:	0527f563          	bgeu	a5,s2,80004580 <fileclose+0xaa>
    8000453a:	7902                	ld	s2,32(sp)
    8000453c:	69e2                	ld	s3,24(sp)
    8000453e:	6a42                	ld	s4,16(sp)
    80004540:	6aa2                	ld	s5,8(sp)
    80004542:	a00d                	j	80004564 <fileclose+0x8e>
    80004544:	f04a                	sd	s2,32(sp)
    80004546:	ec4e                	sd	s3,24(sp)
    80004548:	e852                	sd	s4,16(sp)
    8000454a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000454c:	00004517          	auipc	a0,0x4
    80004550:	1c450513          	addi	a0,a0,452 # 80008710 <etext+0x710>
    80004554:	a4efc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    80004558:	00027517          	auipc	a0,0x27
    8000455c:	da850513          	addi	a0,a0,-600 # 8002b300 <ftable>
    80004560:	f3afc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004564:	70e2                	ld	ra,56(sp)
    80004566:	7442                	ld	s0,48(sp)
    80004568:	74a2                	ld	s1,40(sp)
    8000456a:	6121                	addi	sp,sp,64
    8000456c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000456e:	85d6                	mv	a1,s5
    80004570:	8552                	mv	a0,s4
    80004572:	336000ef          	jal	800048a8 <pipeclose>
    80004576:	7902                	ld	s2,32(sp)
    80004578:	69e2                	ld	s3,24(sp)
    8000457a:	6a42                	ld	s4,16(sp)
    8000457c:	6aa2                	ld	s5,8(sp)
    8000457e:	b7dd                	j	80004564 <fileclose+0x8e>
    begin_op();
    80004580:	b3dff0ef          	jal	800040bc <begin_op>
    iput(ff.ip);
    80004584:	854e                	mv	a0,s3
    80004586:	c22ff0ef          	jal	800039a8 <iput>
    end_op();
    8000458a:	b9dff0ef          	jal	80004126 <end_op>
    8000458e:	7902                	ld	s2,32(sp)
    80004590:	69e2                	ld	s3,24(sp)
    80004592:	6a42                	ld	s4,16(sp)
    80004594:	6aa2                	ld	s5,8(sp)
    80004596:	b7f9                	j	80004564 <fileclose+0x8e>

0000000080004598 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004598:	715d                	addi	sp,sp,-80
    8000459a:	e486                	sd	ra,72(sp)
    8000459c:	e0a2                	sd	s0,64(sp)
    8000459e:	fc26                	sd	s1,56(sp)
    800045a0:	f44e                	sd	s3,40(sp)
    800045a2:	0880                	addi	s0,sp,80
    800045a4:	84aa                	mv	s1,a0
    800045a6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800045a8:	b58fd0ef          	jal	80001900 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800045ac:	409c                	lw	a5,0(s1)
    800045ae:	37f9                	addiw	a5,a5,-2
    800045b0:	4705                	li	a4,1
    800045b2:	04f76063          	bltu	a4,a5,800045f2 <filestat+0x5a>
    800045b6:	f84a                	sd	s2,48(sp)
    800045b8:	892a                	mv	s2,a0
    ilock(f->ip);
    800045ba:	6c88                	ld	a0,24(s1)
    800045bc:	a6aff0ef          	jal	80003826 <ilock>
    stati(f->ip, &st);
    800045c0:	fb840593          	addi	a1,s0,-72
    800045c4:	6c88                	ld	a0,24(s1)
    800045c6:	c8aff0ef          	jal	80003a50 <stati>
    iunlock(f->ip);
    800045ca:	6c88                	ld	a0,24(s1)
    800045cc:	b08ff0ef          	jal	800038d4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045d0:	46e1                	li	a3,24
    800045d2:	fb840613          	addi	a2,s0,-72
    800045d6:	85ce                	mv	a1,s3
    800045d8:	09093503          	ld	a0,144(s2)
    800045dc:	f97fc0ef          	jal	80001572 <copyout>
    800045e0:	41f5551b          	sraiw	a0,a0,0x1f
    800045e4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800045e6:	60a6                	ld	ra,72(sp)
    800045e8:	6406                	ld	s0,64(sp)
    800045ea:	74e2                	ld	s1,56(sp)
    800045ec:	79a2                	ld	s3,40(sp)
    800045ee:	6161                	addi	sp,sp,80
    800045f0:	8082                	ret
  return -1;
    800045f2:	557d                	li	a0,-1
    800045f4:	bfcd                	j	800045e6 <filestat+0x4e>

00000000800045f6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045f6:	7179                	addi	sp,sp,-48
    800045f8:	f406                	sd	ra,40(sp)
    800045fa:	f022                	sd	s0,32(sp)
    800045fc:	e84a                	sd	s2,16(sp)
    800045fe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004600:	00854783          	lbu	a5,8(a0)
    80004604:	cfd1                	beqz	a5,800046a0 <fileread+0xaa>
    80004606:	ec26                	sd	s1,24(sp)
    80004608:	e44e                	sd	s3,8(sp)
    8000460a:	84aa                	mv	s1,a0
    8000460c:	89ae                	mv	s3,a1
    8000460e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004610:	411c                	lw	a5,0(a0)
    80004612:	4705                	li	a4,1
    80004614:	04e78363          	beq	a5,a4,8000465a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004618:	470d                	li	a4,3
    8000461a:	04e78763          	beq	a5,a4,80004668 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000461e:	4709                	li	a4,2
    80004620:	06e79a63          	bne	a5,a4,80004694 <fileread+0x9e>
    ilock(f->ip);
    80004624:	6d08                	ld	a0,24(a0)
    80004626:	a00ff0ef          	jal	80003826 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000462a:	874a                	mv	a4,s2
    8000462c:	5094                	lw	a3,32(s1)
    8000462e:	864e                	mv	a2,s3
    80004630:	4585                	li	a1,1
    80004632:	6c88                	ld	a0,24(s1)
    80004634:	c46ff0ef          	jal	80003a7a <readi>
    80004638:	892a                	mv	s2,a0
    8000463a:	00a05563          	blez	a0,80004644 <fileread+0x4e>
      f->off += r;
    8000463e:	509c                	lw	a5,32(s1)
    80004640:	9fa9                	addw	a5,a5,a0
    80004642:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004644:	6c88                	ld	a0,24(s1)
    80004646:	a8eff0ef          	jal	800038d4 <iunlock>
    8000464a:	64e2                	ld	s1,24(sp)
    8000464c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000464e:	854a                	mv	a0,s2
    80004650:	70a2                	ld	ra,40(sp)
    80004652:	7402                	ld	s0,32(sp)
    80004654:	6942                	ld	s2,16(sp)
    80004656:	6145                	addi	sp,sp,48
    80004658:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000465a:	6908                	ld	a0,16(a0)
    8000465c:	388000ef          	jal	800049e4 <piperead>
    80004660:	892a                	mv	s2,a0
    80004662:	64e2                	ld	s1,24(sp)
    80004664:	69a2                	ld	s3,8(sp)
    80004666:	b7e5                	j	8000464e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004668:	02451783          	lh	a5,36(a0)
    8000466c:	03079693          	slli	a3,a5,0x30
    80004670:	92c1                	srli	a3,a3,0x30
    80004672:	4725                	li	a4,9
    80004674:	02d76863          	bltu	a4,a3,800046a4 <fileread+0xae>
    80004678:	0792                	slli	a5,a5,0x4
    8000467a:	00027717          	auipc	a4,0x27
    8000467e:	be670713          	addi	a4,a4,-1050 # 8002b260 <devsw>
    80004682:	97ba                	add	a5,a5,a4
    80004684:	639c                	ld	a5,0(a5)
    80004686:	c39d                	beqz	a5,800046ac <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004688:	4505                	li	a0,1
    8000468a:	9782                	jalr	a5
    8000468c:	892a                	mv	s2,a0
    8000468e:	64e2                	ld	s1,24(sp)
    80004690:	69a2                	ld	s3,8(sp)
    80004692:	bf75                	j	8000464e <fileread+0x58>
    panic("fileread");
    80004694:	00004517          	auipc	a0,0x4
    80004698:	08c50513          	addi	a0,a0,140 # 80008720 <etext+0x720>
    8000469c:	906fc0ef          	jal	800007a2 <panic>
    return -1;
    800046a0:	597d                	li	s2,-1
    800046a2:	b775                	j	8000464e <fileread+0x58>
      return -1;
    800046a4:	597d                	li	s2,-1
    800046a6:	64e2                	ld	s1,24(sp)
    800046a8:	69a2                	ld	s3,8(sp)
    800046aa:	b755                	j	8000464e <fileread+0x58>
    800046ac:	597d                	li	s2,-1
    800046ae:	64e2                	ld	s1,24(sp)
    800046b0:	69a2                	ld	s3,8(sp)
    800046b2:	bf71                	j	8000464e <fileread+0x58>

00000000800046b4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046b4:	00954783          	lbu	a5,9(a0)
    800046b8:	10078b63          	beqz	a5,800047ce <filewrite+0x11a>
{
    800046bc:	715d                	addi	sp,sp,-80
    800046be:	e486                	sd	ra,72(sp)
    800046c0:	e0a2                	sd	s0,64(sp)
    800046c2:	f84a                	sd	s2,48(sp)
    800046c4:	f052                	sd	s4,32(sp)
    800046c6:	e85a                	sd	s6,16(sp)
    800046c8:	0880                	addi	s0,sp,80
    800046ca:	892a                	mv	s2,a0
    800046cc:	8b2e                	mv	s6,a1
    800046ce:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046d0:	411c                	lw	a5,0(a0)
    800046d2:	4705                	li	a4,1
    800046d4:	02e78763          	beq	a5,a4,80004702 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046d8:	470d                	li	a4,3
    800046da:	02e78863          	beq	a5,a4,8000470a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046de:	4709                	li	a4,2
    800046e0:	0ce79c63          	bne	a5,a4,800047b8 <filewrite+0x104>
    800046e4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046e6:	0ac05863          	blez	a2,80004796 <filewrite+0xe2>
    800046ea:	fc26                	sd	s1,56(sp)
    800046ec:	ec56                	sd	s5,24(sp)
    800046ee:	e45e                	sd	s7,8(sp)
    800046f0:	e062                	sd	s8,0(sp)
    int i = 0;
    800046f2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800046f4:	6b85                	lui	s7,0x1
    800046f6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046fa:	6c05                	lui	s8,0x1
    800046fc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004700:	a8b5                	j	8000477c <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004702:	6908                	ld	a0,16(a0)
    80004704:	1fc000ef          	jal	80004900 <pipewrite>
    80004708:	a04d                	j	800047aa <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000470a:	02451783          	lh	a5,36(a0)
    8000470e:	03079693          	slli	a3,a5,0x30
    80004712:	92c1                	srli	a3,a3,0x30
    80004714:	4725                	li	a4,9
    80004716:	0ad76e63          	bltu	a4,a3,800047d2 <filewrite+0x11e>
    8000471a:	0792                	slli	a5,a5,0x4
    8000471c:	00027717          	auipc	a4,0x27
    80004720:	b4470713          	addi	a4,a4,-1212 # 8002b260 <devsw>
    80004724:	97ba                	add	a5,a5,a4
    80004726:	679c                	ld	a5,8(a5)
    80004728:	c7dd                	beqz	a5,800047d6 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000472a:	4505                	li	a0,1
    8000472c:	9782                	jalr	a5
    8000472e:	a8b5                	j	800047aa <filewrite+0xf6>
      if(n1 > max)
    80004730:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004734:	989ff0ef          	jal	800040bc <begin_op>
      ilock(f->ip);
    80004738:	01893503          	ld	a0,24(s2)
    8000473c:	8eaff0ef          	jal	80003826 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004740:	8756                	mv	a4,s5
    80004742:	02092683          	lw	a3,32(s2)
    80004746:	01698633          	add	a2,s3,s6
    8000474a:	4585                	li	a1,1
    8000474c:	01893503          	ld	a0,24(s2)
    80004750:	c26ff0ef          	jal	80003b76 <writei>
    80004754:	84aa                	mv	s1,a0
    80004756:	00a05763          	blez	a0,80004764 <filewrite+0xb0>
        f->off += r;
    8000475a:	02092783          	lw	a5,32(s2)
    8000475e:	9fa9                	addw	a5,a5,a0
    80004760:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004764:	01893503          	ld	a0,24(s2)
    80004768:	96cff0ef          	jal	800038d4 <iunlock>
      end_op();
    8000476c:	9bbff0ef          	jal	80004126 <end_op>

      if(r != n1){
    80004770:	029a9563          	bne	s5,s1,8000479a <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004774:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004778:	0149da63          	bge	s3,s4,8000478c <filewrite+0xd8>
      int n1 = n - i;
    8000477c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004780:	0004879b          	sext.w	a5,s1
    80004784:	fafbd6e3          	bge	s7,a5,80004730 <filewrite+0x7c>
    80004788:	84e2                	mv	s1,s8
    8000478a:	b75d                	j	80004730 <filewrite+0x7c>
    8000478c:	74e2                	ld	s1,56(sp)
    8000478e:	6ae2                	ld	s5,24(sp)
    80004790:	6ba2                	ld	s7,8(sp)
    80004792:	6c02                	ld	s8,0(sp)
    80004794:	a039                	j	800047a2 <filewrite+0xee>
    int i = 0;
    80004796:	4981                	li	s3,0
    80004798:	a029                	j	800047a2 <filewrite+0xee>
    8000479a:	74e2                	ld	s1,56(sp)
    8000479c:	6ae2                	ld	s5,24(sp)
    8000479e:	6ba2                	ld	s7,8(sp)
    800047a0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800047a2:	033a1c63          	bne	s4,s3,800047da <filewrite+0x126>
    800047a6:	8552                	mv	a0,s4
    800047a8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047aa:	60a6                	ld	ra,72(sp)
    800047ac:	6406                	ld	s0,64(sp)
    800047ae:	7942                	ld	s2,48(sp)
    800047b0:	7a02                	ld	s4,32(sp)
    800047b2:	6b42                	ld	s6,16(sp)
    800047b4:	6161                	addi	sp,sp,80
    800047b6:	8082                	ret
    800047b8:	fc26                	sd	s1,56(sp)
    800047ba:	f44e                	sd	s3,40(sp)
    800047bc:	ec56                	sd	s5,24(sp)
    800047be:	e45e                	sd	s7,8(sp)
    800047c0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800047c2:	00004517          	auipc	a0,0x4
    800047c6:	f6e50513          	addi	a0,a0,-146 # 80008730 <etext+0x730>
    800047ca:	fd9fb0ef          	jal	800007a2 <panic>
    return -1;
    800047ce:	557d                	li	a0,-1
}
    800047d0:	8082                	ret
      return -1;
    800047d2:	557d                	li	a0,-1
    800047d4:	bfd9                	j	800047aa <filewrite+0xf6>
    800047d6:	557d                	li	a0,-1
    800047d8:	bfc9                	j	800047aa <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800047da:	557d                	li	a0,-1
    800047dc:	79a2                	ld	s3,40(sp)
    800047de:	b7f1                	j	800047aa <filewrite+0xf6>

00000000800047e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	ec26                	sd	s1,24(sp)
    800047e8:	e052                	sd	s4,0(sp)
    800047ea:	1800                	addi	s0,sp,48
    800047ec:	84aa                	mv	s1,a0
    800047ee:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047f0:	0005b023          	sd	zero,0(a1)
    800047f4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047f8:	c3bff0ef          	jal	80004432 <filealloc>
    800047fc:	e088                	sd	a0,0(s1)
    800047fe:	c549                	beqz	a0,80004888 <pipealloc+0xa8>
    80004800:	c33ff0ef          	jal	80004432 <filealloc>
    80004804:	00aa3023          	sd	a0,0(s4)
    80004808:	cd25                	beqz	a0,80004880 <pipealloc+0xa0>
    8000480a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000480c:	b26fc0ef          	jal	80000b32 <kalloc>
    80004810:	892a                	mv	s2,a0
    80004812:	c12d                	beqz	a0,80004874 <pipealloc+0x94>
    80004814:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004816:	4985                	li	s3,1
    80004818:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000481c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004820:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004824:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004828:	00004597          	auipc	a1,0x4
    8000482c:	f1858593          	addi	a1,a1,-232 # 80008740 <etext+0x740>
    80004830:	b52fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004834:	609c                	ld	a5,0(s1)
    80004836:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000483a:	609c                	ld	a5,0(s1)
    8000483c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004840:	609c                	ld	a5,0(s1)
    80004842:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004846:	609c                	ld	a5,0(s1)
    80004848:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000484c:	000a3783          	ld	a5,0(s4)
    80004850:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004854:	000a3783          	ld	a5,0(s4)
    80004858:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000485c:	000a3783          	ld	a5,0(s4)
    80004860:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004864:	000a3783          	ld	a5,0(s4)
    80004868:	0127b823          	sd	s2,16(a5)
  return 0;
    8000486c:	4501                	li	a0,0
    8000486e:	6942                	ld	s2,16(sp)
    80004870:	69a2                	ld	s3,8(sp)
    80004872:	a01d                	j	80004898 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004874:	6088                	ld	a0,0(s1)
    80004876:	c119                	beqz	a0,8000487c <pipealloc+0x9c>
    80004878:	6942                	ld	s2,16(sp)
    8000487a:	a029                	j	80004884 <pipealloc+0xa4>
    8000487c:	6942                	ld	s2,16(sp)
    8000487e:	a029                	j	80004888 <pipealloc+0xa8>
    80004880:	6088                	ld	a0,0(s1)
    80004882:	c10d                	beqz	a0,800048a4 <pipealloc+0xc4>
    fileclose(*f0);
    80004884:	c53ff0ef          	jal	800044d6 <fileclose>
  if(*f1)
    80004888:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000488c:	557d                	li	a0,-1
  if(*f1)
    8000488e:	c789                	beqz	a5,80004898 <pipealloc+0xb8>
    fileclose(*f1);
    80004890:	853e                	mv	a0,a5
    80004892:	c45ff0ef          	jal	800044d6 <fileclose>
  return -1;
    80004896:	557d                	li	a0,-1
}
    80004898:	70a2                	ld	ra,40(sp)
    8000489a:	7402                	ld	s0,32(sp)
    8000489c:	64e2                	ld	s1,24(sp)
    8000489e:	6a02                	ld	s4,0(sp)
    800048a0:	6145                	addi	sp,sp,48
    800048a2:	8082                	ret
  return -1;
    800048a4:	557d                	li	a0,-1
    800048a6:	bfcd                	j	80004898 <pipealloc+0xb8>

00000000800048a8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048a8:	1101                	addi	sp,sp,-32
    800048aa:	ec06                	sd	ra,24(sp)
    800048ac:	e822                	sd	s0,16(sp)
    800048ae:	e426                	sd	s1,8(sp)
    800048b0:	e04a                	sd	s2,0(sp)
    800048b2:	1000                	addi	s0,sp,32
    800048b4:	84aa                	mv	s1,a0
    800048b6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048b8:	b4afc0ef          	jal	80000c02 <acquire>
  if(writable){
    800048bc:	02090763          	beqz	s2,800048ea <pipeclose+0x42>
    pi->writeopen = 0;
    800048c0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048c4:	21848513          	addi	a0,s1,536
    800048c8:	9a3fd0ef          	jal	8000226a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048cc:	2204b783          	ld	a5,544(s1)
    800048d0:	e785                	bnez	a5,800048f8 <pipeclose+0x50>
    release(&pi->lock);
    800048d2:	8526                	mv	a0,s1
    800048d4:	bc6fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    800048d8:	8526                	mv	a0,s1
    800048da:	976fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    800048de:	60e2                	ld	ra,24(sp)
    800048e0:	6442                	ld	s0,16(sp)
    800048e2:	64a2                	ld	s1,8(sp)
    800048e4:	6902                	ld	s2,0(sp)
    800048e6:	6105                	addi	sp,sp,32
    800048e8:	8082                	ret
    pi->readopen = 0;
    800048ea:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048ee:	21c48513          	addi	a0,s1,540
    800048f2:	979fd0ef          	jal	8000226a <wakeup>
    800048f6:	bfd9                	j	800048cc <pipeclose+0x24>
    release(&pi->lock);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ba0fc0ef          	jal	80000c9a <release>
}
    800048fe:	b7c5                	j	800048de <pipeclose+0x36>

0000000080004900 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004900:	711d                	addi	sp,sp,-96
    80004902:	ec86                	sd	ra,88(sp)
    80004904:	e8a2                	sd	s0,80(sp)
    80004906:	e4a6                	sd	s1,72(sp)
    80004908:	e0ca                	sd	s2,64(sp)
    8000490a:	fc4e                	sd	s3,56(sp)
    8000490c:	f852                	sd	s4,48(sp)
    8000490e:	f456                	sd	s5,40(sp)
    80004910:	1080                	addi	s0,sp,96
    80004912:	84aa                	mv	s1,a0
    80004914:	8aae                	mv	s5,a1
    80004916:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004918:	fe9fc0ef          	jal	80001900 <myproc>
    8000491c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000491e:	8526                	mv	a0,s1
    80004920:	ae2fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004924:	0b405a63          	blez	s4,800049d8 <pipewrite+0xd8>
    80004928:	f05a                	sd	s6,32(sp)
    8000492a:	ec5e                	sd	s7,24(sp)
    8000492c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000492e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004930:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004932:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004936:	21c48b93          	addi	s7,s1,540
    8000493a:	a81d                	j	80004970 <pipewrite+0x70>
      release(&pi->lock);
    8000493c:	8526                	mv	a0,s1
    8000493e:	b5cfc0ef          	jal	80000c9a <release>
      return -1;
    80004942:	597d                	li	s2,-1
    80004944:	7b02                	ld	s6,32(sp)
    80004946:	6be2                	ld	s7,24(sp)
    80004948:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000494a:	854a                	mv	a0,s2
    8000494c:	60e6                	ld	ra,88(sp)
    8000494e:	6446                	ld	s0,80(sp)
    80004950:	64a6                	ld	s1,72(sp)
    80004952:	6906                	ld	s2,64(sp)
    80004954:	79e2                	ld	s3,56(sp)
    80004956:	7a42                	ld	s4,48(sp)
    80004958:	7aa2                	ld	s5,40(sp)
    8000495a:	6125                	addi	sp,sp,96
    8000495c:	8082                	ret
      wakeup(&pi->nread);
    8000495e:	8562                	mv	a0,s8
    80004960:	90bfd0ef          	jal	8000226a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004964:	85a6                	mv	a1,s1
    80004966:	855e                	mv	a0,s7
    80004968:	fb6fd0ef          	jal	8000211e <sleep>
  while(i < n){
    8000496c:	05495b63          	bge	s2,s4,800049c2 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004970:	2204a783          	lw	a5,544(s1)
    80004974:	d7e1                	beqz	a5,8000493c <pipewrite+0x3c>
    80004976:	854e                	mv	a0,s3
    80004978:	bc3fd0ef          	jal	8000253a <killed>
    8000497c:	f161                	bnez	a0,8000493c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000497e:	2184a783          	lw	a5,536(s1)
    80004982:	21c4a703          	lw	a4,540(s1)
    80004986:	2007879b          	addiw	a5,a5,512
    8000498a:	fcf70ae3          	beq	a4,a5,8000495e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000498e:	4685                	li	a3,1
    80004990:	01590633          	add	a2,s2,s5
    80004994:	faf40593          	addi	a1,s0,-81
    80004998:	0909b503          	ld	a0,144(s3)
    8000499c:	cadfc0ef          	jal	80001648 <copyin>
    800049a0:	03650e63          	beq	a0,s6,800049dc <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049a4:	21c4a783          	lw	a5,540(s1)
    800049a8:	0017871b          	addiw	a4,a5,1
    800049ac:	20e4ae23          	sw	a4,540(s1)
    800049b0:	1ff7f793          	andi	a5,a5,511
    800049b4:	97a6                	add	a5,a5,s1
    800049b6:	faf44703          	lbu	a4,-81(s0)
    800049ba:	00e78c23          	sb	a4,24(a5)
      i++;
    800049be:	2905                	addiw	s2,s2,1
    800049c0:	b775                	j	8000496c <pipewrite+0x6c>
    800049c2:	7b02                	ld	s6,32(sp)
    800049c4:	6be2                	ld	s7,24(sp)
    800049c6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800049c8:	21848513          	addi	a0,s1,536
    800049cc:	89ffd0ef          	jal	8000226a <wakeup>
  release(&pi->lock);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ac8fc0ef          	jal	80000c9a <release>
  return i;
    800049d6:	bf95                	j	8000494a <pipewrite+0x4a>
  int i = 0;
    800049d8:	4901                	li	s2,0
    800049da:	b7fd                	j	800049c8 <pipewrite+0xc8>
    800049dc:	7b02                	ld	s6,32(sp)
    800049de:	6be2                	ld	s7,24(sp)
    800049e0:	6c42                	ld	s8,16(sp)
    800049e2:	b7dd                	j	800049c8 <pipewrite+0xc8>

00000000800049e4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049e4:	715d                	addi	sp,sp,-80
    800049e6:	e486                	sd	ra,72(sp)
    800049e8:	e0a2                	sd	s0,64(sp)
    800049ea:	fc26                	sd	s1,56(sp)
    800049ec:	f84a                	sd	s2,48(sp)
    800049ee:	f44e                	sd	s3,40(sp)
    800049f0:	f052                	sd	s4,32(sp)
    800049f2:	ec56                	sd	s5,24(sp)
    800049f4:	0880                	addi	s0,sp,80
    800049f6:	84aa                	mv	s1,a0
    800049f8:	892e                	mv	s2,a1
    800049fa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800049fc:	f05fc0ef          	jal	80001900 <myproc>
    80004a00:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a02:	8526                	mv	a0,s1
    80004a04:	9fefc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a08:	2184a703          	lw	a4,536(s1)
    80004a0c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a10:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a14:	02f71563          	bne	a4,a5,80004a3e <piperead+0x5a>
    80004a18:	2244a783          	lw	a5,548(s1)
    80004a1c:	cb85                	beqz	a5,80004a4c <piperead+0x68>
    if(killed(pr)){
    80004a1e:	8552                	mv	a0,s4
    80004a20:	b1bfd0ef          	jal	8000253a <killed>
    80004a24:	ed19                	bnez	a0,80004a42 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a26:	85a6                	mv	a1,s1
    80004a28:	854e                	mv	a0,s3
    80004a2a:	ef4fd0ef          	jal	8000211e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a2e:	2184a703          	lw	a4,536(s1)
    80004a32:	21c4a783          	lw	a5,540(s1)
    80004a36:	fef701e3          	beq	a4,a5,80004a18 <piperead+0x34>
    80004a3a:	e85a                	sd	s6,16(sp)
    80004a3c:	a809                	j	80004a4e <piperead+0x6a>
    80004a3e:	e85a                	sd	s6,16(sp)
    80004a40:	a039                	j	80004a4e <piperead+0x6a>
      release(&pi->lock);
    80004a42:	8526                	mv	a0,s1
    80004a44:	a56fc0ef          	jal	80000c9a <release>
      return -1;
    80004a48:	59fd                	li	s3,-1
    80004a4a:	a8b1                	j	80004aa6 <piperead+0xc2>
    80004a4c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a4e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a50:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a52:	05505263          	blez	s5,80004a96 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004a56:	2184a783          	lw	a5,536(s1)
    80004a5a:	21c4a703          	lw	a4,540(s1)
    80004a5e:	02f70c63          	beq	a4,a5,80004a96 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a62:	0017871b          	addiw	a4,a5,1
    80004a66:	20e4ac23          	sw	a4,536(s1)
    80004a6a:	1ff7f793          	andi	a5,a5,511
    80004a6e:	97a6                	add	a5,a5,s1
    80004a70:	0187c783          	lbu	a5,24(a5)
    80004a74:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a78:	4685                	li	a3,1
    80004a7a:	fbf40613          	addi	a2,s0,-65
    80004a7e:	85ca                	mv	a1,s2
    80004a80:	090a3503          	ld	a0,144(s4)
    80004a84:	aeffc0ef          	jal	80001572 <copyout>
    80004a88:	01650763          	beq	a0,s6,80004a96 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a8c:	2985                	addiw	s3,s3,1
    80004a8e:	0905                	addi	s2,s2,1
    80004a90:	fd3a93e3          	bne	s5,s3,80004a56 <piperead+0x72>
    80004a94:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a96:	21c48513          	addi	a0,s1,540
    80004a9a:	fd0fd0ef          	jal	8000226a <wakeup>
  release(&pi->lock);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	9fafc0ef          	jal	80000c9a <release>
    80004aa4:	6b42                	ld	s6,16(sp)
  return i;
}
    80004aa6:	854e                	mv	a0,s3
    80004aa8:	60a6                	ld	ra,72(sp)
    80004aaa:	6406                	ld	s0,64(sp)
    80004aac:	74e2                	ld	s1,56(sp)
    80004aae:	7942                	ld	s2,48(sp)
    80004ab0:	79a2                	ld	s3,40(sp)
    80004ab2:	7a02                	ld	s4,32(sp)
    80004ab4:	6ae2                	ld	s5,24(sp)
    80004ab6:	6161                	addi	sp,sp,80
    80004ab8:	8082                	ret

0000000080004aba <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004aba:	1141                	addi	sp,sp,-16
    80004abc:	e422                	sd	s0,8(sp)
    80004abe:	0800                	addi	s0,sp,16
    80004ac0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004ac2:	8905                	andi	a0,a0,1
    80004ac4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004ac6:	8b89                	andi	a5,a5,2
    80004ac8:	c399                	beqz	a5,80004ace <flags2perm+0x14>
      perm |= PTE_W;
    80004aca:	00456513          	ori	a0,a0,4
    return perm;
}
    80004ace:	6422                	ld	s0,8(sp)
    80004ad0:	0141                	addi	sp,sp,16
    80004ad2:	8082                	ret

0000000080004ad4 <exec>:

int
exec(char *path, char **argv)
{
    80004ad4:	df010113          	addi	sp,sp,-528
    80004ad8:	20113423          	sd	ra,520(sp)
    80004adc:	20813023          	sd	s0,512(sp)
    80004ae0:	ffa6                	sd	s1,504(sp)
    80004ae2:	fbca                	sd	s2,496(sp)
    80004ae4:	0c00                	addi	s0,sp,528
    80004ae6:	892a                	mv	s2,a0
    80004ae8:	dea43c23          	sd	a0,-520(s0)
    80004aec:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004af0:	e11fc0ef          	jal	80001900 <myproc>
    80004af4:	84aa                	mv	s1,a0

  begin_op();
    80004af6:	dc6ff0ef          	jal	800040bc <begin_op>

  if((ip = namei(path)) == 0){
    80004afa:	854a                	mv	a0,s2
    80004afc:	c04ff0ef          	jal	80003f00 <namei>
    80004b00:	c931                	beqz	a0,80004b54 <exec+0x80>
    80004b02:	f3d2                	sd	s4,480(sp)
    80004b04:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b06:	d21fe0ef          	jal	80003826 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b0a:	04000713          	li	a4,64
    80004b0e:	4681                	li	a3,0
    80004b10:	e5040613          	addi	a2,s0,-432
    80004b14:	4581                	li	a1,0
    80004b16:	8552                	mv	a0,s4
    80004b18:	f63fe0ef          	jal	80003a7a <readi>
    80004b1c:	04000793          	li	a5,64
    80004b20:	00f51a63          	bne	a0,a5,80004b34 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004b24:	e5042703          	lw	a4,-432(s0)
    80004b28:	464c47b7          	lui	a5,0x464c4
    80004b2c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b30:	02f70663          	beq	a4,a5,80004b5c <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b34:	8552                	mv	a0,s4
    80004b36:	efbfe0ef          	jal	80003a30 <iunlockput>
    end_op();
    80004b3a:	decff0ef          	jal	80004126 <end_op>
  }
  return -1;
    80004b3e:	557d                	li	a0,-1
    80004b40:	7a1e                	ld	s4,480(sp)
}
    80004b42:	20813083          	ld	ra,520(sp)
    80004b46:	20013403          	ld	s0,512(sp)
    80004b4a:	74fe                	ld	s1,504(sp)
    80004b4c:	795e                	ld	s2,496(sp)
    80004b4e:	21010113          	addi	sp,sp,528
    80004b52:	8082                	ret
    end_op();
    80004b54:	dd2ff0ef          	jal	80004126 <end_op>
    return -1;
    80004b58:	557d                	li	a0,-1
    80004b5a:	b7e5                	j	80004b42 <exec+0x6e>
    80004b5c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004b5e:	8526                	mv	a0,s1
    80004b60:	f8ffc0ef          	jal	80001aee <proc_pagetable>
    80004b64:	8b2a                	mv	s6,a0
    80004b66:	2c050b63          	beqz	a0,80004e3c <exec+0x368>
    80004b6a:	f7ce                	sd	s3,488(sp)
    80004b6c:	efd6                	sd	s5,472(sp)
    80004b6e:	e7de                	sd	s7,456(sp)
    80004b70:	e3e2                	sd	s8,448(sp)
    80004b72:	ff66                	sd	s9,440(sp)
    80004b74:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b76:	e7042d03          	lw	s10,-400(s0)
    80004b7a:	e8845783          	lhu	a5,-376(s0)
    80004b7e:	12078963          	beqz	a5,80004cb0 <exec+0x1dc>
    80004b82:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b84:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b86:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004b88:	6c85                	lui	s9,0x1
    80004b8a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b8e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004b92:	6a85                	lui	s5,0x1
    80004b94:	a085                	j	80004bf4 <exec+0x120>
      panic("loadseg: address should exist");
    80004b96:	00004517          	auipc	a0,0x4
    80004b9a:	bb250513          	addi	a0,a0,-1102 # 80008748 <etext+0x748>
    80004b9e:	c05fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    80004ba2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004ba4:	8726                	mv	a4,s1
    80004ba6:	012c06bb          	addw	a3,s8,s2
    80004baa:	4581                	li	a1,0
    80004bac:	8552                	mv	a0,s4
    80004bae:	ecdfe0ef          	jal	80003a7a <readi>
    80004bb2:	2501                	sext.w	a0,a0
    80004bb4:	24a49a63          	bne	s1,a0,80004e08 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004bb8:	012a893b          	addw	s2,s5,s2
    80004bbc:	03397363          	bgeu	s2,s3,80004be2 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004bc0:	02091593          	slli	a1,s2,0x20
    80004bc4:	9181                	srli	a1,a1,0x20
    80004bc6:	95de                	add	a1,a1,s7
    80004bc8:	855a                	mv	a0,s6
    80004bca:	c1afc0ef          	jal	80000fe4 <walkaddr>
    80004bce:	862a                	mv	a2,a0
    if(pa == 0)
    80004bd0:	d179                	beqz	a0,80004b96 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004bd2:	412984bb          	subw	s1,s3,s2
    80004bd6:	0004879b          	sext.w	a5,s1
    80004bda:	fcfcf4e3          	bgeu	s9,a5,80004ba2 <exec+0xce>
    80004bde:	84d6                	mv	s1,s5
    80004be0:	b7c9                	j	80004ba2 <exec+0xce>
    sz = sz1;
    80004be2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004be6:	2d85                	addiw	s11,s11,1
    80004be8:	038d0d1b          	addiw	s10,s10,56
    80004bec:	e8845783          	lhu	a5,-376(s0)
    80004bf0:	08fdd063          	bge	s11,a5,80004c70 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004bf4:	2d01                	sext.w	s10,s10
    80004bf6:	03800713          	li	a4,56
    80004bfa:	86ea                	mv	a3,s10
    80004bfc:	e1840613          	addi	a2,s0,-488
    80004c00:	4581                	li	a1,0
    80004c02:	8552                	mv	a0,s4
    80004c04:	e77fe0ef          	jal	80003a7a <readi>
    80004c08:	03800793          	li	a5,56
    80004c0c:	1cf51663          	bne	a0,a5,80004dd8 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004c10:	e1842783          	lw	a5,-488(s0)
    80004c14:	4705                	li	a4,1
    80004c16:	fce798e3          	bne	a5,a4,80004be6 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004c1a:	e4043483          	ld	s1,-448(s0)
    80004c1e:	e3843783          	ld	a5,-456(s0)
    80004c22:	1af4ef63          	bltu	s1,a5,80004de0 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c26:	e2843783          	ld	a5,-472(s0)
    80004c2a:	94be                	add	s1,s1,a5
    80004c2c:	1af4ee63          	bltu	s1,a5,80004de8 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004c30:	df043703          	ld	a4,-528(s0)
    80004c34:	8ff9                	and	a5,a5,a4
    80004c36:	1a079d63          	bnez	a5,80004df0 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c3a:	e1c42503          	lw	a0,-484(s0)
    80004c3e:	e7dff0ef          	jal	80004aba <flags2perm>
    80004c42:	86aa                	mv	a3,a0
    80004c44:	8626                	mv	a2,s1
    80004c46:	85ca                	mv	a1,s2
    80004c48:	855a                	mv	a0,s6
    80004c4a:	f14fc0ef          	jal	8000135e <uvmalloc>
    80004c4e:	e0a43423          	sd	a0,-504(s0)
    80004c52:	1a050363          	beqz	a0,80004df8 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c56:	e2843b83          	ld	s7,-472(s0)
    80004c5a:	e2042c03          	lw	s8,-480(s0)
    80004c5e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004c62:	00098463          	beqz	s3,80004c6a <exec+0x196>
    80004c66:	4901                	li	s2,0
    80004c68:	bfa1                	j	80004bc0 <exec+0xec>
    sz = sz1;
    80004c6a:	e0843903          	ld	s2,-504(s0)
    80004c6e:	bfa5                	j	80004be6 <exec+0x112>
    80004c70:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004c72:	8552                	mv	a0,s4
    80004c74:	dbdfe0ef          	jal	80003a30 <iunlockput>
  end_op();
    80004c78:	caeff0ef          	jal	80004126 <end_op>
  p = myproc();
    80004c7c:	c85fc0ef          	jal	80001900 <myproc>
    80004c80:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004c82:	08853c83          	ld	s9,136(a0)
  sz = PGROUNDUP(sz);
    80004c86:	6985                	lui	s3,0x1
    80004c88:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c8a:	99ca                	add	s3,s3,s2
    80004c8c:	77fd                	lui	a5,0xfffff
    80004c8e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004c92:	4691                	li	a3,4
    80004c94:	6609                	lui	a2,0x2
    80004c96:	964e                	add	a2,a2,s3
    80004c98:	85ce                	mv	a1,s3
    80004c9a:	855a                	mv	a0,s6
    80004c9c:	ec2fc0ef          	jal	8000135e <uvmalloc>
    80004ca0:	892a                	mv	s2,a0
    80004ca2:	e0a43423          	sd	a0,-504(s0)
    80004ca6:	e519                	bnez	a0,80004cb4 <exec+0x1e0>
  if(pagetable)
    80004ca8:	e1343423          	sd	s3,-504(s0)
    80004cac:	4a01                	li	s4,0
    80004cae:	aab1                	j	80004e0a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cb0:	4901                	li	s2,0
    80004cb2:	b7c1                	j	80004c72 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004cb4:	75f9                	lui	a1,0xffffe
    80004cb6:	95aa                	add	a1,a1,a0
    80004cb8:	855a                	mv	a0,s6
    80004cba:	88ffc0ef          	jal	80001548 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004cbe:	7bfd                	lui	s7,0xfffff
    80004cc0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004cc2:	e0043783          	ld	a5,-512(s0)
    80004cc6:	6388                	ld	a0,0(a5)
    80004cc8:	cd39                	beqz	a0,80004d26 <exec+0x252>
    80004cca:	e9040993          	addi	s3,s0,-368
    80004cce:	f9040c13          	addi	s8,s0,-112
    80004cd2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004cd4:	972fc0ef          	jal	80000e46 <strlen>
    80004cd8:	0015079b          	addiw	a5,a0,1
    80004cdc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ce0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004ce4:	11796e63          	bltu	s2,s7,80004e00 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ce8:	e0043d03          	ld	s10,-512(s0)
    80004cec:	000d3a03          	ld	s4,0(s10)
    80004cf0:	8552                	mv	a0,s4
    80004cf2:	954fc0ef          	jal	80000e46 <strlen>
    80004cf6:	0015069b          	addiw	a3,a0,1
    80004cfa:	8652                	mv	a2,s4
    80004cfc:	85ca                	mv	a1,s2
    80004cfe:	855a                	mv	a0,s6
    80004d00:	873fc0ef          	jal	80001572 <copyout>
    80004d04:	10054063          	bltz	a0,80004e04 <exec+0x330>
    ustack[argc] = sp;
    80004d08:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d0c:	0485                	addi	s1,s1,1
    80004d0e:	008d0793          	addi	a5,s10,8
    80004d12:	e0f43023          	sd	a5,-512(s0)
    80004d16:	008d3503          	ld	a0,8(s10)
    80004d1a:	c909                	beqz	a0,80004d2c <exec+0x258>
    if(argc >= MAXARG)
    80004d1c:	09a1                	addi	s3,s3,8
    80004d1e:	fb899be3          	bne	s3,s8,80004cd4 <exec+0x200>
  ip = 0;
    80004d22:	4a01                	li	s4,0
    80004d24:	a0dd                	j	80004e0a <exec+0x336>
  sp = sz;
    80004d26:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004d2a:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d2c:	00349793          	slli	a5,s1,0x3
    80004d30:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd2b98>
    80004d34:	97a2                	add	a5,a5,s0
    80004d36:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d3a:	00148693          	addi	a3,s1,1
    80004d3e:	068e                	slli	a3,a3,0x3
    80004d40:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d44:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004d48:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004d4c:	f5796ee3          	bltu	s2,s7,80004ca8 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d50:	e9040613          	addi	a2,s0,-368
    80004d54:	85ca                	mv	a1,s2
    80004d56:	855a                	mv	a0,s6
    80004d58:	81bfc0ef          	jal	80001572 <copyout>
    80004d5c:	0e054263          	bltz	a0,80004e40 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004d60:	098ab783          	ld	a5,152(s5) # 1098 <_entry-0x7fffef68>
    80004d64:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d68:	df843783          	ld	a5,-520(s0)
    80004d6c:	0007c703          	lbu	a4,0(a5)
    80004d70:	cf11                	beqz	a4,80004d8c <exec+0x2b8>
    80004d72:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d74:	02f00693          	li	a3,47
    80004d78:	a039                	j	80004d86 <exec+0x2b2>
      last = s+1;
    80004d7a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004d7e:	0785                	addi	a5,a5,1
    80004d80:	fff7c703          	lbu	a4,-1(a5)
    80004d84:	c701                	beqz	a4,80004d8c <exec+0x2b8>
    if(*s == '/')
    80004d86:	fed71ce3          	bne	a4,a3,80004d7e <exec+0x2aa>
    80004d8a:	bfc5                	j	80004d7a <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d8c:	4641                	li	a2,16
    80004d8e:	df843583          	ld	a1,-520(s0)
    80004d92:	198a8513          	addi	a0,s5,408
    80004d96:	87efc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    80004d9a:	090ab503          	ld	a0,144(s5)
  p->pagetable = pagetable;
    80004d9e:	096ab823          	sd	s6,144(s5)
  p->sz = sz;
    80004da2:	e0843783          	ld	a5,-504(s0)
    80004da6:	08fab423          	sd	a5,136(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004daa:	098ab783          	ld	a5,152(s5)
    80004dae:	e6843703          	ld	a4,-408(s0)
    80004db2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004db4:	098ab783          	ld	a5,152(s5)
    80004db8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004dbc:	85e6                	mv	a1,s9
    80004dbe:	db5fc0ef          	jal	80001b72 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004dc2:	0004851b          	sext.w	a0,s1
    80004dc6:	79be                	ld	s3,488(sp)
    80004dc8:	7a1e                	ld	s4,480(sp)
    80004dca:	6afe                	ld	s5,472(sp)
    80004dcc:	6b5e                	ld	s6,464(sp)
    80004dce:	6bbe                	ld	s7,456(sp)
    80004dd0:	6c1e                	ld	s8,448(sp)
    80004dd2:	7cfa                	ld	s9,440(sp)
    80004dd4:	7d5a                	ld	s10,432(sp)
    80004dd6:	b3b5                	j	80004b42 <exec+0x6e>
    80004dd8:	e1243423          	sd	s2,-504(s0)
    80004ddc:	7dba                	ld	s11,424(sp)
    80004dde:	a035                	j	80004e0a <exec+0x336>
    80004de0:	e1243423          	sd	s2,-504(s0)
    80004de4:	7dba                	ld	s11,424(sp)
    80004de6:	a015                	j	80004e0a <exec+0x336>
    80004de8:	e1243423          	sd	s2,-504(s0)
    80004dec:	7dba                	ld	s11,424(sp)
    80004dee:	a831                	j	80004e0a <exec+0x336>
    80004df0:	e1243423          	sd	s2,-504(s0)
    80004df4:	7dba                	ld	s11,424(sp)
    80004df6:	a811                	j	80004e0a <exec+0x336>
    80004df8:	e1243423          	sd	s2,-504(s0)
    80004dfc:	7dba                	ld	s11,424(sp)
    80004dfe:	a031                	j	80004e0a <exec+0x336>
  ip = 0;
    80004e00:	4a01                	li	s4,0
    80004e02:	a021                	j	80004e0a <exec+0x336>
    80004e04:	4a01                	li	s4,0
  if(pagetable)
    80004e06:	a011                	j	80004e0a <exec+0x336>
    80004e08:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004e0a:	e0843583          	ld	a1,-504(s0)
    80004e0e:	855a                	mv	a0,s6
    80004e10:	d63fc0ef          	jal	80001b72 <proc_freepagetable>
  return -1;
    80004e14:	557d                	li	a0,-1
  if(ip){
    80004e16:	000a1b63          	bnez	s4,80004e2c <exec+0x358>
    80004e1a:	79be                	ld	s3,488(sp)
    80004e1c:	7a1e                	ld	s4,480(sp)
    80004e1e:	6afe                	ld	s5,472(sp)
    80004e20:	6b5e                	ld	s6,464(sp)
    80004e22:	6bbe                	ld	s7,456(sp)
    80004e24:	6c1e                	ld	s8,448(sp)
    80004e26:	7cfa                	ld	s9,440(sp)
    80004e28:	7d5a                	ld	s10,432(sp)
    80004e2a:	bb21                	j	80004b42 <exec+0x6e>
    80004e2c:	79be                	ld	s3,488(sp)
    80004e2e:	6afe                	ld	s5,472(sp)
    80004e30:	6b5e                	ld	s6,464(sp)
    80004e32:	6bbe                	ld	s7,456(sp)
    80004e34:	6c1e                	ld	s8,448(sp)
    80004e36:	7cfa                	ld	s9,440(sp)
    80004e38:	7d5a                	ld	s10,432(sp)
    80004e3a:	b9ed                	j	80004b34 <exec+0x60>
    80004e3c:	6b5e                	ld	s6,464(sp)
    80004e3e:	b9dd                	j	80004b34 <exec+0x60>
  sz = sz1;
    80004e40:	e0843983          	ld	s3,-504(s0)
    80004e44:	b595                	j	80004ca8 <exec+0x1d4>

0000000080004e46 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e46:	7179                	addi	sp,sp,-48
    80004e48:	f406                	sd	ra,40(sp)
    80004e4a:	f022                	sd	s0,32(sp)
    80004e4c:	ec26                	sd	s1,24(sp)
    80004e4e:	e84a                	sd	s2,16(sp)
    80004e50:	1800                	addi	s0,sp,48
    80004e52:	892e                	mv	s2,a1
    80004e54:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004e56:	fdc40593          	addi	a1,s0,-36
    80004e5a:	d99fd0ef          	jal	80002bf2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e5e:	fdc42703          	lw	a4,-36(s0)
    80004e62:	47bd                	li	a5,15
    80004e64:	02e7e963          	bltu	a5,a4,80004e96 <argfd+0x50>
    80004e68:	a99fc0ef          	jal	80001900 <myproc>
    80004e6c:	fdc42703          	lw	a4,-36(s0)
    80004e70:	02270793          	addi	a5,a4,34
    80004e74:	078e                	slli	a5,a5,0x3
    80004e76:	953e                	add	a0,a0,a5
    80004e78:	611c                	ld	a5,0(a0)
    80004e7a:	c385                	beqz	a5,80004e9a <argfd+0x54>
    return -1;
  if(pfd)
    80004e7c:	00090463          	beqz	s2,80004e84 <argfd+0x3e>
    *pfd = fd;
    80004e80:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004e84:	4501                	li	a0,0
  if(pf)
    80004e86:	c091                	beqz	s1,80004e8a <argfd+0x44>
    *pf = f;
    80004e88:	e09c                	sd	a5,0(s1)
}
    80004e8a:	70a2                	ld	ra,40(sp)
    80004e8c:	7402                	ld	s0,32(sp)
    80004e8e:	64e2                	ld	s1,24(sp)
    80004e90:	6942                	ld	s2,16(sp)
    80004e92:	6145                	addi	sp,sp,48
    80004e94:	8082                	ret
    return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	bfcd                	j	80004e8a <argfd+0x44>
    80004e9a:	557d                	li	a0,-1
    80004e9c:	b7fd                	j	80004e8a <argfd+0x44>

0000000080004e9e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e9e:	1101                	addi	sp,sp,-32
    80004ea0:	ec06                	sd	ra,24(sp)
    80004ea2:	e822                	sd	s0,16(sp)
    80004ea4:	e426                	sd	s1,8(sp)
    80004ea6:	1000                	addi	s0,sp,32
    80004ea8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004eaa:	a57fc0ef          	jal	80001900 <myproc>
    80004eae:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004eb0:	11050793          	addi	a5,a0,272
    80004eb4:	4501                	li	a0,0
    80004eb6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004eb8:	6398                	ld	a4,0(a5)
    80004eba:	cb19                	beqz	a4,80004ed0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004ebc:	2505                	addiw	a0,a0,1
    80004ebe:	07a1                	addi	a5,a5,8
    80004ec0:	fed51ce3          	bne	a0,a3,80004eb8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004ec4:	557d                	li	a0,-1
}
    80004ec6:	60e2                	ld	ra,24(sp)
    80004ec8:	6442                	ld	s0,16(sp)
    80004eca:	64a2                	ld	s1,8(sp)
    80004ecc:	6105                	addi	sp,sp,32
    80004ece:	8082                	ret
      p->ofile[fd] = f;
    80004ed0:	02250793          	addi	a5,a0,34
    80004ed4:	078e                	slli	a5,a5,0x3
    80004ed6:	963e                	add	a2,a2,a5
    80004ed8:	e204                	sd	s1,0(a2)
      return fd;
    80004eda:	b7f5                	j	80004ec6 <fdalloc+0x28>

0000000080004edc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004edc:	715d                	addi	sp,sp,-80
    80004ede:	e486                	sd	ra,72(sp)
    80004ee0:	e0a2                	sd	s0,64(sp)
    80004ee2:	fc26                	sd	s1,56(sp)
    80004ee4:	f84a                	sd	s2,48(sp)
    80004ee6:	f44e                	sd	s3,40(sp)
    80004ee8:	ec56                	sd	s5,24(sp)
    80004eea:	e85a                	sd	s6,16(sp)
    80004eec:	0880                	addi	s0,sp,80
    80004eee:	8b2e                	mv	s6,a1
    80004ef0:	89b2                	mv	s3,a2
    80004ef2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ef4:	fb040593          	addi	a1,s0,-80
    80004ef8:	822ff0ef          	jal	80003f1a <nameiparent>
    80004efc:	84aa                	mv	s1,a0
    80004efe:	10050a63          	beqz	a0,80005012 <create+0x136>
    return 0;

  ilock(dp);
    80004f02:	925fe0ef          	jal	80003826 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f06:	4601                	li	a2,0
    80004f08:	fb040593          	addi	a1,s0,-80
    80004f0c:	8526                	mv	a0,s1
    80004f0e:	d8dfe0ef          	jal	80003c9a <dirlookup>
    80004f12:	8aaa                	mv	s5,a0
    80004f14:	c129                	beqz	a0,80004f56 <create+0x7a>
    iunlockput(dp);
    80004f16:	8526                	mv	a0,s1
    80004f18:	b19fe0ef          	jal	80003a30 <iunlockput>
    ilock(ip);
    80004f1c:	8556                	mv	a0,s5
    80004f1e:	909fe0ef          	jal	80003826 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f22:	4789                	li	a5,2
    80004f24:	02fb1463          	bne	s6,a5,80004f4c <create+0x70>
    80004f28:	044ad783          	lhu	a5,68(s5)
    80004f2c:	37f9                	addiw	a5,a5,-2
    80004f2e:	17c2                	slli	a5,a5,0x30
    80004f30:	93c1                	srli	a5,a5,0x30
    80004f32:	4705                	li	a4,1
    80004f34:	00f76c63          	bltu	a4,a5,80004f4c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004f38:	8556                	mv	a0,s5
    80004f3a:	60a6                	ld	ra,72(sp)
    80004f3c:	6406                	ld	s0,64(sp)
    80004f3e:	74e2                	ld	s1,56(sp)
    80004f40:	7942                	ld	s2,48(sp)
    80004f42:	79a2                	ld	s3,40(sp)
    80004f44:	6ae2                	ld	s5,24(sp)
    80004f46:	6b42                	ld	s6,16(sp)
    80004f48:	6161                	addi	sp,sp,80
    80004f4a:	8082                	ret
    iunlockput(ip);
    80004f4c:	8556                	mv	a0,s5
    80004f4e:	ae3fe0ef          	jal	80003a30 <iunlockput>
    return 0;
    80004f52:	4a81                	li	s5,0
    80004f54:	b7d5                	j	80004f38 <create+0x5c>
    80004f56:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004f58:	85da                	mv	a1,s6
    80004f5a:	4088                	lw	a0,0(s1)
    80004f5c:	f5afe0ef          	jal	800036b6 <ialloc>
    80004f60:	8a2a                	mv	s4,a0
    80004f62:	cd15                	beqz	a0,80004f9e <create+0xc2>
  ilock(ip);
    80004f64:	8c3fe0ef          	jal	80003826 <ilock>
  ip->major = major;
    80004f68:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004f6c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004f70:	4905                	li	s2,1
    80004f72:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004f76:	8552                	mv	a0,s4
    80004f78:	ffafe0ef          	jal	80003772 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004f7c:	032b0763          	beq	s6,s2,80004faa <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f80:	004a2603          	lw	a2,4(s4)
    80004f84:	fb040593          	addi	a1,s0,-80
    80004f88:	8526                	mv	a0,s1
    80004f8a:	eddfe0ef          	jal	80003e66 <dirlink>
    80004f8e:	06054563          	bltz	a0,80004ff8 <create+0x11c>
  iunlockput(dp);
    80004f92:	8526                	mv	a0,s1
    80004f94:	a9dfe0ef          	jal	80003a30 <iunlockput>
  return ip;
    80004f98:	8ad2                	mv	s5,s4
    80004f9a:	7a02                	ld	s4,32(sp)
    80004f9c:	bf71                	j	80004f38 <create+0x5c>
    iunlockput(dp);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	a91fe0ef          	jal	80003a30 <iunlockput>
    return 0;
    80004fa4:	8ad2                	mv	s5,s4
    80004fa6:	7a02                	ld	s4,32(sp)
    80004fa8:	bf41                	j	80004f38 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004faa:	004a2603          	lw	a2,4(s4)
    80004fae:	00003597          	auipc	a1,0x3
    80004fb2:	7ba58593          	addi	a1,a1,1978 # 80008768 <etext+0x768>
    80004fb6:	8552                	mv	a0,s4
    80004fb8:	eaffe0ef          	jal	80003e66 <dirlink>
    80004fbc:	02054e63          	bltz	a0,80004ff8 <create+0x11c>
    80004fc0:	40d0                	lw	a2,4(s1)
    80004fc2:	00003597          	auipc	a1,0x3
    80004fc6:	7ae58593          	addi	a1,a1,1966 # 80008770 <etext+0x770>
    80004fca:	8552                	mv	a0,s4
    80004fcc:	e9bfe0ef          	jal	80003e66 <dirlink>
    80004fd0:	02054463          	bltz	a0,80004ff8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fd4:	004a2603          	lw	a2,4(s4)
    80004fd8:	fb040593          	addi	a1,s0,-80
    80004fdc:	8526                	mv	a0,s1
    80004fde:	e89fe0ef          	jal	80003e66 <dirlink>
    80004fe2:	00054b63          	bltz	a0,80004ff8 <create+0x11c>
    dp->nlink++;  // for ".."
    80004fe6:	04a4d783          	lhu	a5,74(s1)
    80004fea:	2785                	addiw	a5,a5,1
    80004fec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	f80fe0ef          	jal	80003772 <iupdate>
    80004ff6:	bf71                	j	80004f92 <create+0xb6>
  ip->nlink = 0;
    80004ff8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ffc:	8552                	mv	a0,s4
    80004ffe:	f74fe0ef          	jal	80003772 <iupdate>
  iunlockput(ip);
    80005002:	8552                	mv	a0,s4
    80005004:	a2dfe0ef          	jal	80003a30 <iunlockput>
  iunlockput(dp);
    80005008:	8526                	mv	a0,s1
    8000500a:	a27fe0ef          	jal	80003a30 <iunlockput>
  return 0;
    8000500e:	7a02                	ld	s4,32(sp)
    80005010:	b725                	j	80004f38 <create+0x5c>
    return 0;
    80005012:	8aaa                	mv	s5,a0
    80005014:	b715                	j	80004f38 <create+0x5c>

0000000080005016 <sys_dup>:
{
    80005016:	7179                	addi	sp,sp,-48
    80005018:	f406                	sd	ra,40(sp)
    8000501a:	f022                	sd	s0,32(sp)
    8000501c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000501e:	fd840613          	addi	a2,s0,-40
    80005022:	4581                	li	a1,0
    80005024:	4501                	li	a0,0
    80005026:	e21ff0ef          	jal	80004e46 <argfd>
    return -1;
    8000502a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000502c:	02054363          	bltz	a0,80005052 <sys_dup+0x3c>
    80005030:	ec26                	sd	s1,24(sp)
    80005032:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005034:	fd843903          	ld	s2,-40(s0)
    80005038:	854a                	mv	a0,s2
    8000503a:	e65ff0ef          	jal	80004e9e <fdalloc>
    8000503e:	84aa                	mv	s1,a0
    return -1;
    80005040:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005042:	00054d63          	bltz	a0,8000505c <sys_dup+0x46>
  filedup(f);
    80005046:	854a                	mv	a0,s2
    80005048:	c48ff0ef          	jal	80004490 <filedup>
  return fd;
    8000504c:	87a6                	mv	a5,s1
    8000504e:	64e2                	ld	s1,24(sp)
    80005050:	6942                	ld	s2,16(sp)
}
    80005052:	853e                	mv	a0,a5
    80005054:	70a2                	ld	ra,40(sp)
    80005056:	7402                	ld	s0,32(sp)
    80005058:	6145                	addi	sp,sp,48
    8000505a:	8082                	ret
    8000505c:	64e2                	ld	s1,24(sp)
    8000505e:	6942                	ld	s2,16(sp)
    80005060:	bfcd                	j	80005052 <sys_dup+0x3c>

0000000080005062 <sys_read>:
{
    80005062:	7179                	addi	sp,sp,-48
    80005064:	f406                	sd	ra,40(sp)
    80005066:	f022                	sd	s0,32(sp)
    80005068:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000506a:	fd840593          	addi	a1,s0,-40
    8000506e:	4505                	li	a0,1
    80005070:	ba1fd0ef          	jal	80002c10 <argaddr>
  argint(2, &n);
    80005074:	fe440593          	addi	a1,s0,-28
    80005078:	4509                	li	a0,2
    8000507a:	b79fd0ef          	jal	80002bf2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000507e:	fe840613          	addi	a2,s0,-24
    80005082:	4581                	li	a1,0
    80005084:	4501                	li	a0,0
    80005086:	dc1ff0ef          	jal	80004e46 <argfd>
    8000508a:	87aa                	mv	a5,a0
    return -1;
    8000508c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000508e:	0007ca63          	bltz	a5,800050a2 <sys_read+0x40>
  return fileread(f, p, n);
    80005092:	fe442603          	lw	a2,-28(s0)
    80005096:	fd843583          	ld	a1,-40(s0)
    8000509a:	fe843503          	ld	a0,-24(s0)
    8000509e:	d58ff0ef          	jal	800045f6 <fileread>
}
    800050a2:	70a2                	ld	ra,40(sp)
    800050a4:	7402                	ld	s0,32(sp)
    800050a6:	6145                	addi	sp,sp,48
    800050a8:	8082                	ret

00000000800050aa <sys_write>:
{
    800050aa:	7179                	addi	sp,sp,-48
    800050ac:	f406                	sd	ra,40(sp)
    800050ae:	f022                	sd	s0,32(sp)
    800050b0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800050b2:	fd840593          	addi	a1,s0,-40
    800050b6:	4505                	li	a0,1
    800050b8:	b59fd0ef          	jal	80002c10 <argaddr>
  argint(2, &n);
    800050bc:	fe440593          	addi	a1,s0,-28
    800050c0:	4509                	li	a0,2
    800050c2:	b31fd0ef          	jal	80002bf2 <argint>
  if(argfd(0, 0, &f) < 0)
    800050c6:	fe840613          	addi	a2,s0,-24
    800050ca:	4581                	li	a1,0
    800050cc:	4501                	li	a0,0
    800050ce:	d79ff0ef          	jal	80004e46 <argfd>
    800050d2:	87aa                	mv	a5,a0
    return -1;
    800050d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800050d6:	0007ca63          	bltz	a5,800050ea <sys_write+0x40>
  return filewrite(f, p, n);
    800050da:	fe442603          	lw	a2,-28(s0)
    800050de:	fd843583          	ld	a1,-40(s0)
    800050e2:	fe843503          	ld	a0,-24(s0)
    800050e6:	dceff0ef          	jal	800046b4 <filewrite>
}
    800050ea:	70a2                	ld	ra,40(sp)
    800050ec:	7402                	ld	s0,32(sp)
    800050ee:	6145                	addi	sp,sp,48
    800050f0:	8082                	ret

00000000800050f2 <sys_close>:
{
    800050f2:	1101                	addi	sp,sp,-32
    800050f4:	ec06                	sd	ra,24(sp)
    800050f6:	e822                	sd	s0,16(sp)
    800050f8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800050fa:	fe040613          	addi	a2,s0,-32
    800050fe:	fec40593          	addi	a1,s0,-20
    80005102:	4501                	li	a0,0
    80005104:	d43ff0ef          	jal	80004e46 <argfd>
    return -1;
    80005108:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000510a:	02054163          	bltz	a0,8000512c <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000510e:	ff2fc0ef          	jal	80001900 <myproc>
    80005112:	fec42783          	lw	a5,-20(s0)
    80005116:	02278793          	addi	a5,a5,34
    8000511a:	078e                	slli	a5,a5,0x3
    8000511c:	953e                	add	a0,a0,a5
    8000511e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005122:	fe043503          	ld	a0,-32(s0)
    80005126:	bb0ff0ef          	jal	800044d6 <fileclose>
  return 0;
    8000512a:	4781                	li	a5,0
}
    8000512c:	853e                	mv	a0,a5
    8000512e:	60e2                	ld	ra,24(sp)
    80005130:	6442                	ld	s0,16(sp)
    80005132:	6105                	addi	sp,sp,32
    80005134:	8082                	ret

0000000080005136 <sys_fstat>:
{
    80005136:	1101                	addi	sp,sp,-32
    80005138:	ec06                	sd	ra,24(sp)
    8000513a:	e822                	sd	s0,16(sp)
    8000513c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000513e:	fe040593          	addi	a1,s0,-32
    80005142:	4505                	li	a0,1
    80005144:	acdfd0ef          	jal	80002c10 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005148:	fe840613          	addi	a2,s0,-24
    8000514c:	4581                	li	a1,0
    8000514e:	4501                	li	a0,0
    80005150:	cf7ff0ef          	jal	80004e46 <argfd>
    80005154:	87aa                	mv	a5,a0
    return -1;
    80005156:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005158:	0007c863          	bltz	a5,80005168 <sys_fstat+0x32>
  return filestat(f, st);
    8000515c:	fe043583          	ld	a1,-32(s0)
    80005160:	fe843503          	ld	a0,-24(s0)
    80005164:	c34ff0ef          	jal	80004598 <filestat>
}
    80005168:	60e2                	ld	ra,24(sp)
    8000516a:	6442                	ld	s0,16(sp)
    8000516c:	6105                	addi	sp,sp,32
    8000516e:	8082                	ret

0000000080005170 <sys_link>:
{
    80005170:	7169                	addi	sp,sp,-304
    80005172:	f606                	sd	ra,296(sp)
    80005174:	f222                	sd	s0,288(sp)
    80005176:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005178:	08000613          	li	a2,128
    8000517c:	ed040593          	addi	a1,s0,-304
    80005180:	4501                	li	a0,0
    80005182:	aadfd0ef          	jal	80002c2e <argstr>
    return -1;
    80005186:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005188:	0c054e63          	bltz	a0,80005264 <sys_link+0xf4>
    8000518c:	08000613          	li	a2,128
    80005190:	f5040593          	addi	a1,s0,-176
    80005194:	4505                	li	a0,1
    80005196:	a99fd0ef          	jal	80002c2e <argstr>
    return -1;
    8000519a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000519c:	0c054463          	bltz	a0,80005264 <sys_link+0xf4>
    800051a0:	ee26                	sd	s1,280(sp)
  begin_op();
    800051a2:	f1bfe0ef          	jal	800040bc <begin_op>
  if((ip = namei(old)) == 0){
    800051a6:	ed040513          	addi	a0,s0,-304
    800051aa:	d57fe0ef          	jal	80003f00 <namei>
    800051ae:	84aa                	mv	s1,a0
    800051b0:	c53d                	beqz	a0,8000521e <sys_link+0xae>
  ilock(ip);
    800051b2:	e74fe0ef          	jal	80003826 <ilock>
  if(ip->type == T_DIR){
    800051b6:	04449703          	lh	a4,68(s1)
    800051ba:	4785                	li	a5,1
    800051bc:	06f70663          	beq	a4,a5,80005228 <sys_link+0xb8>
    800051c0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800051c2:	04a4d783          	lhu	a5,74(s1)
    800051c6:	2785                	addiw	a5,a5,1
    800051c8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800051cc:	8526                	mv	a0,s1
    800051ce:	da4fe0ef          	jal	80003772 <iupdate>
  iunlock(ip);
    800051d2:	8526                	mv	a0,s1
    800051d4:	f00fe0ef          	jal	800038d4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800051d8:	fd040593          	addi	a1,s0,-48
    800051dc:	f5040513          	addi	a0,s0,-176
    800051e0:	d3bfe0ef          	jal	80003f1a <nameiparent>
    800051e4:	892a                	mv	s2,a0
    800051e6:	cd21                	beqz	a0,8000523e <sys_link+0xce>
  ilock(dp);
    800051e8:	e3efe0ef          	jal	80003826 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800051ec:	00092703          	lw	a4,0(s2)
    800051f0:	409c                	lw	a5,0(s1)
    800051f2:	04f71363          	bne	a4,a5,80005238 <sys_link+0xc8>
    800051f6:	40d0                	lw	a2,4(s1)
    800051f8:	fd040593          	addi	a1,s0,-48
    800051fc:	854a                	mv	a0,s2
    800051fe:	c69fe0ef          	jal	80003e66 <dirlink>
    80005202:	02054b63          	bltz	a0,80005238 <sys_link+0xc8>
  iunlockput(dp);
    80005206:	854a                	mv	a0,s2
    80005208:	829fe0ef          	jal	80003a30 <iunlockput>
  iput(ip);
    8000520c:	8526                	mv	a0,s1
    8000520e:	f9afe0ef          	jal	800039a8 <iput>
  end_op();
    80005212:	f15fe0ef          	jal	80004126 <end_op>
  return 0;
    80005216:	4781                	li	a5,0
    80005218:	64f2                	ld	s1,280(sp)
    8000521a:	6952                	ld	s2,272(sp)
    8000521c:	a0a1                	j	80005264 <sys_link+0xf4>
    end_op();
    8000521e:	f09fe0ef          	jal	80004126 <end_op>
    return -1;
    80005222:	57fd                	li	a5,-1
    80005224:	64f2                	ld	s1,280(sp)
    80005226:	a83d                	j	80005264 <sys_link+0xf4>
    iunlockput(ip);
    80005228:	8526                	mv	a0,s1
    8000522a:	807fe0ef          	jal	80003a30 <iunlockput>
    end_op();
    8000522e:	ef9fe0ef          	jal	80004126 <end_op>
    return -1;
    80005232:	57fd                	li	a5,-1
    80005234:	64f2                	ld	s1,280(sp)
    80005236:	a03d                	j	80005264 <sys_link+0xf4>
    iunlockput(dp);
    80005238:	854a                	mv	a0,s2
    8000523a:	ff6fe0ef          	jal	80003a30 <iunlockput>
  ilock(ip);
    8000523e:	8526                	mv	a0,s1
    80005240:	de6fe0ef          	jal	80003826 <ilock>
  ip->nlink--;
    80005244:	04a4d783          	lhu	a5,74(s1)
    80005248:	37fd                	addiw	a5,a5,-1
    8000524a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000524e:	8526                	mv	a0,s1
    80005250:	d22fe0ef          	jal	80003772 <iupdate>
  iunlockput(ip);
    80005254:	8526                	mv	a0,s1
    80005256:	fdafe0ef          	jal	80003a30 <iunlockput>
  end_op();
    8000525a:	ecdfe0ef          	jal	80004126 <end_op>
  return -1;
    8000525e:	57fd                	li	a5,-1
    80005260:	64f2                	ld	s1,280(sp)
    80005262:	6952                	ld	s2,272(sp)
}
    80005264:	853e                	mv	a0,a5
    80005266:	70b2                	ld	ra,296(sp)
    80005268:	7412                	ld	s0,288(sp)
    8000526a:	6155                	addi	sp,sp,304
    8000526c:	8082                	ret

000000008000526e <sys_unlink>:
{
    8000526e:	7151                	addi	sp,sp,-240
    80005270:	f586                	sd	ra,232(sp)
    80005272:	f1a2                	sd	s0,224(sp)
    80005274:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005276:	08000613          	li	a2,128
    8000527a:	f3040593          	addi	a1,s0,-208
    8000527e:	4501                	li	a0,0
    80005280:	9affd0ef          	jal	80002c2e <argstr>
    80005284:	16054063          	bltz	a0,800053e4 <sys_unlink+0x176>
    80005288:	eda6                	sd	s1,216(sp)
  begin_op();
    8000528a:	e33fe0ef          	jal	800040bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000528e:	fb040593          	addi	a1,s0,-80
    80005292:	f3040513          	addi	a0,s0,-208
    80005296:	c85fe0ef          	jal	80003f1a <nameiparent>
    8000529a:	84aa                	mv	s1,a0
    8000529c:	c945                	beqz	a0,8000534c <sys_unlink+0xde>
  ilock(dp);
    8000529e:	d88fe0ef          	jal	80003826 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800052a2:	00003597          	auipc	a1,0x3
    800052a6:	4c658593          	addi	a1,a1,1222 # 80008768 <etext+0x768>
    800052aa:	fb040513          	addi	a0,s0,-80
    800052ae:	9d7fe0ef          	jal	80003c84 <namecmp>
    800052b2:	10050e63          	beqz	a0,800053ce <sys_unlink+0x160>
    800052b6:	00003597          	auipc	a1,0x3
    800052ba:	4ba58593          	addi	a1,a1,1210 # 80008770 <etext+0x770>
    800052be:	fb040513          	addi	a0,s0,-80
    800052c2:	9c3fe0ef          	jal	80003c84 <namecmp>
    800052c6:	10050463          	beqz	a0,800053ce <sys_unlink+0x160>
    800052ca:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800052cc:	f2c40613          	addi	a2,s0,-212
    800052d0:	fb040593          	addi	a1,s0,-80
    800052d4:	8526                	mv	a0,s1
    800052d6:	9c5fe0ef          	jal	80003c9a <dirlookup>
    800052da:	892a                	mv	s2,a0
    800052dc:	0e050863          	beqz	a0,800053cc <sys_unlink+0x15e>
  ilock(ip);
    800052e0:	d46fe0ef          	jal	80003826 <ilock>
  if(ip->nlink < 1)
    800052e4:	04a91783          	lh	a5,74(s2)
    800052e8:	06f05763          	blez	a5,80005356 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800052ec:	04491703          	lh	a4,68(s2)
    800052f0:	4785                	li	a5,1
    800052f2:	06f70963          	beq	a4,a5,80005364 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800052f6:	4641                	li	a2,16
    800052f8:	4581                	li	a1,0
    800052fa:	fc040513          	addi	a0,s0,-64
    800052fe:	9d9fb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005302:	4741                	li	a4,16
    80005304:	f2c42683          	lw	a3,-212(s0)
    80005308:	fc040613          	addi	a2,s0,-64
    8000530c:	4581                	li	a1,0
    8000530e:	8526                	mv	a0,s1
    80005310:	867fe0ef          	jal	80003b76 <writei>
    80005314:	47c1                	li	a5,16
    80005316:	08f51b63          	bne	a0,a5,800053ac <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000531a:	04491703          	lh	a4,68(s2)
    8000531e:	4785                	li	a5,1
    80005320:	08f70d63          	beq	a4,a5,800053ba <sys_unlink+0x14c>
  iunlockput(dp);
    80005324:	8526                	mv	a0,s1
    80005326:	f0afe0ef          	jal	80003a30 <iunlockput>
  ip->nlink--;
    8000532a:	04a95783          	lhu	a5,74(s2)
    8000532e:	37fd                	addiw	a5,a5,-1
    80005330:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005334:	854a                	mv	a0,s2
    80005336:	c3cfe0ef          	jal	80003772 <iupdate>
  iunlockput(ip);
    8000533a:	854a                	mv	a0,s2
    8000533c:	ef4fe0ef          	jal	80003a30 <iunlockput>
  end_op();
    80005340:	de7fe0ef          	jal	80004126 <end_op>
  return 0;
    80005344:	4501                	li	a0,0
    80005346:	64ee                	ld	s1,216(sp)
    80005348:	694e                	ld	s2,208(sp)
    8000534a:	a849                	j	800053dc <sys_unlink+0x16e>
    end_op();
    8000534c:	ddbfe0ef          	jal	80004126 <end_op>
    return -1;
    80005350:	557d                	li	a0,-1
    80005352:	64ee                	ld	s1,216(sp)
    80005354:	a061                	j	800053dc <sys_unlink+0x16e>
    80005356:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	42050513          	addi	a0,a0,1056 # 80008778 <etext+0x778>
    80005360:	c42fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005364:	04c92703          	lw	a4,76(s2)
    80005368:	02000793          	li	a5,32
    8000536c:	f8e7f5e3          	bgeu	a5,a4,800052f6 <sys_unlink+0x88>
    80005370:	e5ce                	sd	s3,200(sp)
    80005372:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005376:	4741                	li	a4,16
    80005378:	86ce                	mv	a3,s3
    8000537a:	f1840613          	addi	a2,s0,-232
    8000537e:	4581                	li	a1,0
    80005380:	854a                	mv	a0,s2
    80005382:	ef8fe0ef          	jal	80003a7a <readi>
    80005386:	47c1                	li	a5,16
    80005388:	00f51c63          	bne	a0,a5,800053a0 <sys_unlink+0x132>
    if(de.inum != 0)
    8000538c:	f1845783          	lhu	a5,-232(s0)
    80005390:	efa1                	bnez	a5,800053e8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005392:	29c1                	addiw	s3,s3,16
    80005394:	04c92783          	lw	a5,76(s2)
    80005398:	fcf9efe3          	bltu	s3,a5,80005376 <sys_unlink+0x108>
    8000539c:	69ae                	ld	s3,200(sp)
    8000539e:	bfa1                	j	800052f6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800053a0:	00003517          	auipc	a0,0x3
    800053a4:	3f050513          	addi	a0,a0,1008 # 80008790 <etext+0x790>
    800053a8:	bfafb0ef          	jal	800007a2 <panic>
    800053ac:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800053ae:	00003517          	auipc	a0,0x3
    800053b2:	3fa50513          	addi	a0,a0,1018 # 800087a8 <etext+0x7a8>
    800053b6:	becfb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    800053ba:	04a4d783          	lhu	a5,74(s1)
    800053be:	37fd                	addiw	a5,a5,-1
    800053c0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800053c4:	8526                	mv	a0,s1
    800053c6:	bacfe0ef          	jal	80003772 <iupdate>
    800053ca:	bfa9                	j	80005324 <sys_unlink+0xb6>
    800053cc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800053ce:	8526                	mv	a0,s1
    800053d0:	e60fe0ef          	jal	80003a30 <iunlockput>
  end_op();
    800053d4:	d53fe0ef          	jal	80004126 <end_op>
  return -1;
    800053d8:	557d                	li	a0,-1
    800053da:	64ee                	ld	s1,216(sp)
}
    800053dc:	70ae                	ld	ra,232(sp)
    800053de:	740e                	ld	s0,224(sp)
    800053e0:	616d                	addi	sp,sp,240
    800053e2:	8082                	ret
    return -1;
    800053e4:	557d                	li	a0,-1
    800053e6:	bfdd                	j	800053dc <sys_unlink+0x16e>
    iunlockput(ip);
    800053e8:	854a                	mv	a0,s2
    800053ea:	e46fe0ef          	jal	80003a30 <iunlockput>
    goto bad;
    800053ee:	694e                	ld	s2,208(sp)
    800053f0:	69ae                	ld	s3,200(sp)
    800053f2:	bff1                	j	800053ce <sys_unlink+0x160>

00000000800053f4 <sys_open>:

uint64
sys_open(void)
{
    800053f4:	7131                	addi	sp,sp,-192
    800053f6:	fd06                	sd	ra,184(sp)
    800053f8:	f922                	sd	s0,176(sp)
    800053fa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800053fc:	f4c40593          	addi	a1,s0,-180
    80005400:	4505                	li	a0,1
    80005402:	ff0fd0ef          	jal	80002bf2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005406:	08000613          	li	a2,128
    8000540a:	f5040593          	addi	a1,s0,-176
    8000540e:	4501                	li	a0,0
    80005410:	81ffd0ef          	jal	80002c2e <argstr>
    80005414:	87aa                	mv	a5,a0
    return -1;
    80005416:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005418:	0a07c263          	bltz	a5,800054bc <sys_open+0xc8>
    8000541c:	f526                	sd	s1,168(sp)

  begin_op();
    8000541e:	c9ffe0ef          	jal	800040bc <begin_op>

  if(omode & O_CREATE){
    80005422:	f4c42783          	lw	a5,-180(s0)
    80005426:	2007f793          	andi	a5,a5,512
    8000542a:	c3d5                	beqz	a5,800054ce <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000542c:	4681                	li	a3,0
    8000542e:	4601                	li	a2,0
    80005430:	4589                	li	a1,2
    80005432:	f5040513          	addi	a0,s0,-176
    80005436:	aa7ff0ef          	jal	80004edc <create>
    8000543a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000543c:	c541                	beqz	a0,800054c4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000543e:	04449703          	lh	a4,68(s1)
    80005442:	478d                	li	a5,3
    80005444:	00f71763          	bne	a4,a5,80005452 <sys_open+0x5e>
    80005448:	0464d703          	lhu	a4,70(s1)
    8000544c:	47a5                	li	a5,9
    8000544e:	0ae7ed63          	bltu	a5,a4,80005508 <sys_open+0x114>
    80005452:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005454:	fdffe0ef          	jal	80004432 <filealloc>
    80005458:	892a                	mv	s2,a0
    8000545a:	c179                	beqz	a0,80005520 <sys_open+0x12c>
    8000545c:	ed4e                	sd	s3,152(sp)
    8000545e:	a41ff0ef          	jal	80004e9e <fdalloc>
    80005462:	89aa                	mv	s3,a0
    80005464:	0a054a63          	bltz	a0,80005518 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005468:	04449703          	lh	a4,68(s1)
    8000546c:	478d                	li	a5,3
    8000546e:	0cf70263          	beq	a4,a5,80005532 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005472:	4789                	li	a5,2
    80005474:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005478:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000547c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005480:	f4c42783          	lw	a5,-180(s0)
    80005484:	0017c713          	xori	a4,a5,1
    80005488:	8b05                	andi	a4,a4,1
    8000548a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000548e:	0037f713          	andi	a4,a5,3
    80005492:	00e03733          	snez	a4,a4
    80005496:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000549a:	4007f793          	andi	a5,a5,1024
    8000549e:	c791                	beqz	a5,800054aa <sys_open+0xb6>
    800054a0:	04449703          	lh	a4,68(s1)
    800054a4:	4789                	li	a5,2
    800054a6:	08f70d63          	beq	a4,a5,80005540 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800054aa:	8526                	mv	a0,s1
    800054ac:	c28fe0ef          	jal	800038d4 <iunlock>
  end_op();
    800054b0:	c77fe0ef          	jal	80004126 <end_op>

  return fd;
    800054b4:	854e                	mv	a0,s3
    800054b6:	74aa                	ld	s1,168(sp)
    800054b8:	790a                	ld	s2,160(sp)
    800054ba:	69ea                	ld	s3,152(sp)
}
    800054bc:	70ea                	ld	ra,184(sp)
    800054be:	744a                	ld	s0,176(sp)
    800054c0:	6129                	addi	sp,sp,192
    800054c2:	8082                	ret
      end_op();
    800054c4:	c63fe0ef          	jal	80004126 <end_op>
      return -1;
    800054c8:	557d                	li	a0,-1
    800054ca:	74aa                	ld	s1,168(sp)
    800054cc:	bfc5                	j	800054bc <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800054ce:	f5040513          	addi	a0,s0,-176
    800054d2:	a2ffe0ef          	jal	80003f00 <namei>
    800054d6:	84aa                	mv	s1,a0
    800054d8:	c11d                	beqz	a0,800054fe <sys_open+0x10a>
    ilock(ip);
    800054da:	b4cfe0ef          	jal	80003826 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800054de:	04449703          	lh	a4,68(s1)
    800054e2:	4785                	li	a5,1
    800054e4:	f4f71de3          	bne	a4,a5,8000543e <sys_open+0x4a>
    800054e8:	f4c42783          	lw	a5,-180(s0)
    800054ec:	d3bd                	beqz	a5,80005452 <sys_open+0x5e>
      iunlockput(ip);
    800054ee:	8526                	mv	a0,s1
    800054f0:	d40fe0ef          	jal	80003a30 <iunlockput>
      end_op();
    800054f4:	c33fe0ef          	jal	80004126 <end_op>
      return -1;
    800054f8:	557d                	li	a0,-1
    800054fa:	74aa                	ld	s1,168(sp)
    800054fc:	b7c1                	j	800054bc <sys_open+0xc8>
      end_op();
    800054fe:	c29fe0ef          	jal	80004126 <end_op>
      return -1;
    80005502:	557d                	li	a0,-1
    80005504:	74aa                	ld	s1,168(sp)
    80005506:	bf5d                	j	800054bc <sys_open+0xc8>
    iunlockput(ip);
    80005508:	8526                	mv	a0,s1
    8000550a:	d26fe0ef          	jal	80003a30 <iunlockput>
    end_op();
    8000550e:	c19fe0ef          	jal	80004126 <end_op>
    return -1;
    80005512:	557d                	li	a0,-1
    80005514:	74aa                	ld	s1,168(sp)
    80005516:	b75d                	j	800054bc <sys_open+0xc8>
      fileclose(f);
    80005518:	854a                	mv	a0,s2
    8000551a:	fbdfe0ef          	jal	800044d6 <fileclose>
    8000551e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005520:	8526                	mv	a0,s1
    80005522:	d0efe0ef          	jal	80003a30 <iunlockput>
    end_op();
    80005526:	c01fe0ef          	jal	80004126 <end_op>
    return -1;
    8000552a:	557d                	li	a0,-1
    8000552c:	74aa                	ld	s1,168(sp)
    8000552e:	790a                	ld	s2,160(sp)
    80005530:	b771                	j	800054bc <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005532:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005536:	04649783          	lh	a5,70(s1)
    8000553a:	02f91223          	sh	a5,36(s2)
    8000553e:	bf3d                	j	8000547c <sys_open+0x88>
    itrunc(ip);
    80005540:	8526                	mv	a0,s1
    80005542:	bd2fe0ef          	jal	80003914 <itrunc>
    80005546:	b795                	j	800054aa <sys_open+0xb6>

0000000080005548 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005548:	7175                	addi	sp,sp,-144
    8000554a:	e506                	sd	ra,136(sp)
    8000554c:	e122                	sd	s0,128(sp)
    8000554e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005550:	b6dfe0ef          	jal	800040bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005554:	08000613          	li	a2,128
    80005558:	f7040593          	addi	a1,s0,-144
    8000555c:	4501                	li	a0,0
    8000555e:	ed0fd0ef          	jal	80002c2e <argstr>
    80005562:	02054363          	bltz	a0,80005588 <sys_mkdir+0x40>
    80005566:	4681                	li	a3,0
    80005568:	4601                	li	a2,0
    8000556a:	4585                	li	a1,1
    8000556c:	f7040513          	addi	a0,s0,-144
    80005570:	96dff0ef          	jal	80004edc <create>
    80005574:	c911                	beqz	a0,80005588 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005576:	cbafe0ef          	jal	80003a30 <iunlockput>
  end_op();
    8000557a:	badfe0ef          	jal	80004126 <end_op>
  return 0;
    8000557e:	4501                	li	a0,0
}
    80005580:	60aa                	ld	ra,136(sp)
    80005582:	640a                	ld	s0,128(sp)
    80005584:	6149                	addi	sp,sp,144
    80005586:	8082                	ret
    end_op();
    80005588:	b9ffe0ef          	jal	80004126 <end_op>
    return -1;
    8000558c:	557d                	li	a0,-1
    8000558e:	bfcd                	j	80005580 <sys_mkdir+0x38>

0000000080005590 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005590:	7135                	addi	sp,sp,-160
    80005592:	ed06                	sd	ra,152(sp)
    80005594:	e922                	sd	s0,144(sp)
    80005596:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005598:	b25fe0ef          	jal	800040bc <begin_op>
  argint(1, &major);
    8000559c:	f6c40593          	addi	a1,s0,-148
    800055a0:	4505                	li	a0,1
    800055a2:	e50fd0ef          	jal	80002bf2 <argint>
  argint(2, &minor);
    800055a6:	f6840593          	addi	a1,s0,-152
    800055aa:	4509                	li	a0,2
    800055ac:	e46fd0ef          	jal	80002bf2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800055b0:	08000613          	li	a2,128
    800055b4:	f7040593          	addi	a1,s0,-144
    800055b8:	4501                	li	a0,0
    800055ba:	e74fd0ef          	jal	80002c2e <argstr>
    800055be:	02054563          	bltz	a0,800055e8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800055c2:	f6841683          	lh	a3,-152(s0)
    800055c6:	f6c41603          	lh	a2,-148(s0)
    800055ca:	458d                	li	a1,3
    800055cc:	f7040513          	addi	a0,s0,-144
    800055d0:	90dff0ef          	jal	80004edc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800055d4:	c911                	beqz	a0,800055e8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055d6:	c5afe0ef          	jal	80003a30 <iunlockput>
  end_op();
    800055da:	b4dfe0ef          	jal	80004126 <end_op>
  return 0;
    800055de:	4501                	li	a0,0
}
    800055e0:	60ea                	ld	ra,152(sp)
    800055e2:	644a                	ld	s0,144(sp)
    800055e4:	610d                	addi	sp,sp,160
    800055e6:	8082                	ret
    end_op();
    800055e8:	b3ffe0ef          	jal	80004126 <end_op>
    return -1;
    800055ec:	557d                	li	a0,-1
    800055ee:	bfcd                	j	800055e0 <sys_mknod+0x50>

00000000800055f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800055f0:	7135                	addi	sp,sp,-160
    800055f2:	ed06                	sd	ra,152(sp)
    800055f4:	e922                	sd	s0,144(sp)
    800055f6:	e14a                	sd	s2,128(sp)
    800055f8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800055fa:	b06fc0ef          	jal	80001900 <myproc>
    800055fe:	892a                	mv	s2,a0
  
  begin_op();
    80005600:	abdfe0ef          	jal	800040bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005604:	08000613          	li	a2,128
    80005608:	f6040593          	addi	a1,s0,-160
    8000560c:	4501                	li	a0,0
    8000560e:	e20fd0ef          	jal	80002c2e <argstr>
    80005612:	04054363          	bltz	a0,80005658 <sys_chdir+0x68>
    80005616:	e526                	sd	s1,136(sp)
    80005618:	f6040513          	addi	a0,s0,-160
    8000561c:	8e5fe0ef          	jal	80003f00 <namei>
    80005620:	84aa                	mv	s1,a0
    80005622:	c915                	beqz	a0,80005656 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005624:	a02fe0ef          	jal	80003826 <ilock>
  if(ip->type != T_DIR){
    80005628:	04449703          	lh	a4,68(s1)
    8000562c:	4785                	li	a5,1
    8000562e:	02f71963          	bne	a4,a5,80005660 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005632:	8526                	mv	a0,s1
    80005634:	aa0fe0ef          	jal	800038d4 <iunlock>
  iput(p->cwd);
    80005638:	19093503          	ld	a0,400(s2)
    8000563c:	b6cfe0ef          	jal	800039a8 <iput>
  end_op();
    80005640:	ae7fe0ef          	jal	80004126 <end_op>
  p->cwd = ip;
    80005644:	18993823          	sd	s1,400(s2)
  return 0;
    80005648:	4501                	li	a0,0
    8000564a:	64aa                	ld	s1,136(sp)
}
    8000564c:	60ea                	ld	ra,152(sp)
    8000564e:	644a                	ld	s0,144(sp)
    80005650:	690a                	ld	s2,128(sp)
    80005652:	610d                	addi	sp,sp,160
    80005654:	8082                	ret
    80005656:	64aa                	ld	s1,136(sp)
    end_op();
    80005658:	acffe0ef          	jal	80004126 <end_op>
    return -1;
    8000565c:	557d                	li	a0,-1
    8000565e:	b7fd                	j	8000564c <sys_chdir+0x5c>
    iunlockput(ip);
    80005660:	8526                	mv	a0,s1
    80005662:	bcefe0ef          	jal	80003a30 <iunlockput>
    end_op();
    80005666:	ac1fe0ef          	jal	80004126 <end_op>
    return -1;
    8000566a:	557d                	li	a0,-1
    8000566c:	64aa                	ld	s1,136(sp)
    8000566e:	bff9                	j	8000564c <sys_chdir+0x5c>

0000000080005670 <sys_exec>:

uint64
sys_exec(void)
{
    80005670:	7121                	addi	sp,sp,-448
    80005672:	ff06                	sd	ra,440(sp)
    80005674:	fb22                	sd	s0,432(sp)
    80005676:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005678:	e4840593          	addi	a1,s0,-440
    8000567c:	4505                	li	a0,1
    8000567e:	d92fd0ef          	jal	80002c10 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005682:	08000613          	li	a2,128
    80005686:	f5040593          	addi	a1,s0,-176
    8000568a:	4501                	li	a0,0
    8000568c:	da2fd0ef          	jal	80002c2e <argstr>
    80005690:	87aa                	mv	a5,a0
    return -1;
    80005692:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005694:	0c07c463          	bltz	a5,8000575c <sys_exec+0xec>
    80005698:	f726                	sd	s1,424(sp)
    8000569a:	f34a                	sd	s2,416(sp)
    8000569c:	ef4e                	sd	s3,408(sp)
    8000569e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800056a0:	10000613          	li	a2,256
    800056a4:	4581                	li	a1,0
    800056a6:	e5040513          	addi	a0,s0,-432
    800056aa:	e2cfb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800056ae:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800056b2:	89a6                	mv	s3,s1
    800056b4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800056b6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800056ba:	00391513          	slli	a0,s2,0x3
    800056be:	e4040593          	addi	a1,s0,-448
    800056c2:	e4843783          	ld	a5,-440(s0)
    800056c6:	953e                	add	a0,a0,a5
    800056c8:	ca0fd0ef          	jal	80002b68 <fetchaddr>
    800056cc:	02054663          	bltz	a0,800056f8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800056d0:	e4043783          	ld	a5,-448(s0)
    800056d4:	c3a9                	beqz	a5,80005716 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800056d6:	c5cfb0ef          	jal	80000b32 <kalloc>
    800056da:	85aa                	mv	a1,a0
    800056dc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800056e0:	cd01                	beqz	a0,800056f8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800056e2:	6605                	lui	a2,0x1
    800056e4:	e4043503          	ld	a0,-448(s0)
    800056e8:	ccafd0ef          	jal	80002bb2 <fetchstr>
    800056ec:	00054663          	bltz	a0,800056f8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800056f0:	0905                	addi	s2,s2,1
    800056f2:	09a1                	addi	s3,s3,8
    800056f4:	fd4913e3          	bne	s2,s4,800056ba <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056f8:	f5040913          	addi	s2,s0,-176
    800056fc:	6088                	ld	a0,0(s1)
    800056fe:	c931                	beqz	a0,80005752 <sys_exec+0xe2>
    kfree(argv[i]);
    80005700:	b50fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005704:	04a1                	addi	s1,s1,8
    80005706:	ff249be3          	bne	s1,s2,800056fc <sys_exec+0x8c>
  return -1;
    8000570a:	557d                	li	a0,-1
    8000570c:	74ba                	ld	s1,424(sp)
    8000570e:	791a                	ld	s2,416(sp)
    80005710:	69fa                	ld	s3,408(sp)
    80005712:	6a5a                	ld	s4,400(sp)
    80005714:	a0a1                	j	8000575c <sys_exec+0xec>
      argv[i] = 0;
    80005716:	0009079b          	sext.w	a5,s2
    8000571a:	078e                	slli	a5,a5,0x3
    8000571c:	fd078793          	addi	a5,a5,-48
    80005720:	97a2                	add	a5,a5,s0
    80005722:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005726:	e5040593          	addi	a1,s0,-432
    8000572a:	f5040513          	addi	a0,s0,-176
    8000572e:	ba6ff0ef          	jal	80004ad4 <exec>
    80005732:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005734:	f5040993          	addi	s3,s0,-176
    80005738:	6088                	ld	a0,0(s1)
    8000573a:	c511                	beqz	a0,80005746 <sys_exec+0xd6>
    kfree(argv[i]);
    8000573c:	b14fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005740:	04a1                	addi	s1,s1,8
    80005742:	ff349be3          	bne	s1,s3,80005738 <sys_exec+0xc8>
  return ret;
    80005746:	854a                	mv	a0,s2
    80005748:	74ba                	ld	s1,424(sp)
    8000574a:	791a                	ld	s2,416(sp)
    8000574c:	69fa                	ld	s3,408(sp)
    8000574e:	6a5a                	ld	s4,400(sp)
    80005750:	a031                	j	8000575c <sys_exec+0xec>
  return -1;
    80005752:	557d                	li	a0,-1
    80005754:	74ba                	ld	s1,424(sp)
    80005756:	791a                	ld	s2,416(sp)
    80005758:	69fa                	ld	s3,408(sp)
    8000575a:	6a5a                	ld	s4,400(sp)
}
    8000575c:	70fa                	ld	ra,440(sp)
    8000575e:	745a                	ld	s0,432(sp)
    80005760:	6139                	addi	sp,sp,448
    80005762:	8082                	ret

0000000080005764 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005764:	7139                	addi	sp,sp,-64
    80005766:	fc06                	sd	ra,56(sp)
    80005768:	f822                	sd	s0,48(sp)
    8000576a:	f426                	sd	s1,40(sp)
    8000576c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000576e:	992fc0ef          	jal	80001900 <myproc>
    80005772:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005774:	fd840593          	addi	a1,s0,-40
    80005778:	4501                	li	a0,0
    8000577a:	c96fd0ef          	jal	80002c10 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000577e:	fc840593          	addi	a1,s0,-56
    80005782:	fd040513          	addi	a0,s0,-48
    80005786:	85aff0ef          	jal	800047e0 <pipealloc>
    return -1;
    8000578a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000578c:	0a054763          	bltz	a0,8000583a <sys_pipe+0xd6>
  fd0 = -1;
    80005790:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005794:	fd043503          	ld	a0,-48(s0)
    80005798:	f06ff0ef          	jal	80004e9e <fdalloc>
    8000579c:	fca42223          	sw	a0,-60(s0)
    800057a0:	08054463          	bltz	a0,80005828 <sys_pipe+0xc4>
    800057a4:	fc843503          	ld	a0,-56(s0)
    800057a8:	ef6ff0ef          	jal	80004e9e <fdalloc>
    800057ac:	fca42023          	sw	a0,-64(s0)
    800057b0:	06054263          	bltz	a0,80005814 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057b4:	4691                	li	a3,4
    800057b6:	fc440613          	addi	a2,s0,-60
    800057ba:	fd843583          	ld	a1,-40(s0)
    800057be:	68c8                	ld	a0,144(s1)
    800057c0:	db3fb0ef          	jal	80001572 <copyout>
    800057c4:	00054e63          	bltz	a0,800057e0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800057c8:	4691                	li	a3,4
    800057ca:	fc040613          	addi	a2,s0,-64
    800057ce:	fd843583          	ld	a1,-40(s0)
    800057d2:	0591                	addi	a1,a1,4
    800057d4:	68c8                	ld	a0,144(s1)
    800057d6:	d9dfb0ef          	jal	80001572 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800057da:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057dc:	04055f63          	bgez	a0,8000583a <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800057e0:	fc442783          	lw	a5,-60(s0)
    800057e4:	02278793          	addi	a5,a5,34
    800057e8:	078e                	slli	a5,a5,0x3
    800057ea:	97a6                	add	a5,a5,s1
    800057ec:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800057f0:	fc042783          	lw	a5,-64(s0)
    800057f4:	02278793          	addi	a5,a5,34
    800057f8:	078e                	slli	a5,a5,0x3
    800057fa:	94be                	add	s1,s1,a5
    800057fc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005800:	fd043503          	ld	a0,-48(s0)
    80005804:	cd3fe0ef          	jal	800044d6 <fileclose>
    fileclose(wf);
    80005808:	fc843503          	ld	a0,-56(s0)
    8000580c:	ccbfe0ef          	jal	800044d6 <fileclose>
    return -1;
    80005810:	57fd                	li	a5,-1
    80005812:	a025                	j	8000583a <sys_pipe+0xd6>
    if(fd0 >= 0)
    80005814:	fc442783          	lw	a5,-60(s0)
    80005818:	0007c863          	bltz	a5,80005828 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    8000581c:	02278793          	addi	a5,a5,34
    80005820:	078e                	slli	a5,a5,0x3
    80005822:	97a6                	add	a5,a5,s1
    80005824:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005828:	fd043503          	ld	a0,-48(s0)
    8000582c:	cabfe0ef          	jal	800044d6 <fileclose>
    fileclose(wf);
    80005830:	fc843503          	ld	a0,-56(s0)
    80005834:	ca3fe0ef          	jal	800044d6 <fileclose>
    return -1;
    80005838:	57fd                	li	a5,-1
}
    8000583a:	853e                	mv	a0,a5
    8000583c:	70e2                	ld	ra,56(sp)
    8000583e:	7442                	ld	s0,48(sp)
    80005840:	74a2                	ld	s1,40(sp)
    80005842:	6121                	addi	sp,sp,64
    80005844:	8082                	ret
	...

0000000080005850 <kernelvec>:
    80005850:	7111                	addi	sp,sp,-256
    80005852:	e006                	sd	ra,0(sp)
    80005854:	e40a                	sd	sp,8(sp)
    80005856:	e80e                	sd	gp,16(sp)
    80005858:	ec12                	sd	tp,24(sp)
    8000585a:	f016                	sd	t0,32(sp)
    8000585c:	f41a                	sd	t1,40(sp)
    8000585e:	f81e                	sd	t2,48(sp)
    80005860:	e4aa                	sd	a0,72(sp)
    80005862:	e8ae                	sd	a1,80(sp)
    80005864:	ecb2                	sd	a2,88(sp)
    80005866:	f0b6                	sd	a3,96(sp)
    80005868:	f4ba                	sd	a4,104(sp)
    8000586a:	f8be                	sd	a5,112(sp)
    8000586c:	fcc2                	sd	a6,120(sp)
    8000586e:	e146                	sd	a7,128(sp)
    80005870:	edf2                	sd	t3,216(sp)
    80005872:	f1f6                	sd	t4,224(sp)
    80005874:	f5fa                	sd	t5,232(sp)
    80005876:	f9fe                	sd	t6,240(sp)
    80005878:	a00fd0ef          	jal	80002a78 <kerneltrap>
    8000587c:	6082                	ld	ra,0(sp)
    8000587e:	6122                	ld	sp,8(sp)
    80005880:	61c2                	ld	gp,16(sp)
    80005882:	7282                	ld	t0,32(sp)
    80005884:	7322                	ld	t1,40(sp)
    80005886:	73c2                	ld	t2,48(sp)
    80005888:	6526                	ld	a0,72(sp)
    8000588a:	65c6                	ld	a1,80(sp)
    8000588c:	6666                	ld	a2,88(sp)
    8000588e:	7686                	ld	a3,96(sp)
    80005890:	7726                	ld	a4,104(sp)
    80005892:	77c6                	ld	a5,112(sp)
    80005894:	7866                	ld	a6,120(sp)
    80005896:	688a                	ld	a7,128(sp)
    80005898:	6e6e                	ld	t3,216(sp)
    8000589a:	7e8e                	ld	t4,224(sp)
    8000589c:	7f2e                	ld	t5,232(sp)
    8000589e:	7fce                	ld	t6,240(sp)
    800058a0:	6111                	addi	sp,sp,256
    800058a2:	10200073          	sret
	...

00000000800058ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800058ae:	1141                	addi	sp,sp,-16
    800058b0:	e422                	sd	s0,8(sp)
    800058b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800058b4:	0c0007b7          	lui	a5,0xc000
    800058b8:	4705                	li	a4,1
    800058ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800058bc:	0c0007b7          	lui	a5,0xc000
    800058c0:	c3d8                	sw	a4,4(a5)
}
    800058c2:	6422                	ld	s0,8(sp)
    800058c4:	0141                	addi	sp,sp,16
    800058c6:	8082                	ret

00000000800058c8 <plicinithart>:

void
plicinithart(void)
{
    800058c8:	1141                	addi	sp,sp,-16
    800058ca:	e406                	sd	ra,8(sp)
    800058cc:	e022                	sd	s0,0(sp)
    800058ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800058d0:	804fc0ef          	jal	800018d4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800058d4:	0085171b          	slliw	a4,a0,0x8
    800058d8:	0c0027b7          	lui	a5,0xc002
    800058dc:	97ba                	add	a5,a5,a4
    800058de:	40200713          	li	a4,1026
    800058e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800058e6:	00d5151b          	slliw	a0,a0,0xd
    800058ea:	0c2017b7          	lui	a5,0xc201
    800058ee:	97aa                	add	a5,a5,a0
    800058f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800058f4:	60a2                	ld	ra,8(sp)
    800058f6:	6402                	ld	s0,0(sp)
    800058f8:	0141                	addi	sp,sp,16
    800058fa:	8082                	ret

00000000800058fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800058fc:	1141                	addi	sp,sp,-16
    800058fe:	e406                	sd	ra,8(sp)
    80005900:	e022                	sd	s0,0(sp)
    80005902:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005904:	fd1fb0ef          	jal	800018d4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005908:	00d5151b          	slliw	a0,a0,0xd
    8000590c:	0c2017b7          	lui	a5,0xc201
    80005910:	97aa                	add	a5,a5,a0
  return irq;
}
    80005912:	43c8                	lw	a0,4(a5)
    80005914:	60a2                	ld	ra,8(sp)
    80005916:	6402                	ld	s0,0(sp)
    80005918:	0141                	addi	sp,sp,16
    8000591a:	8082                	ret

000000008000591c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000591c:	1101                	addi	sp,sp,-32
    8000591e:	ec06                	sd	ra,24(sp)
    80005920:	e822                	sd	s0,16(sp)
    80005922:	e426                	sd	s1,8(sp)
    80005924:	1000                	addi	s0,sp,32
    80005926:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005928:	fadfb0ef          	jal	800018d4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000592c:	00d5151b          	slliw	a0,a0,0xd
    80005930:	0c2017b7          	lui	a5,0xc201
    80005934:	97aa                	add	a5,a5,a0
    80005936:	c3c4                	sw	s1,4(a5)
}
    80005938:	60e2                	ld	ra,24(sp)
    8000593a:	6442                	ld	s0,16(sp)
    8000593c:	64a2                	ld	s1,8(sp)
    8000593e:	6105                	addi	sp,sp,32
    80005940:	8082                	ret

0000000080005942 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005942:	1141                	addi	sp,sp,-16
    80005944:	e406                	sd	ra,8(sp)
    80005946:	e022                	sd	s0,0(sp)
    80005948:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000594a:	479d                	li	a5,7
    8000594c:	04a7ca63          	blt	a5,a0,800059a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005950:	00027797          	auipc	a5,0x27
    80005954:	96878793          	addi	a5,a5,-1688 # 8002c2b8 <disk>
    80005958:	97aa                	add	a5,a5,a0
    8000595a:	0187c783          	lbu	a5,24(a5)
    8000595e:	e7b9                	bnez	a5,800059ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005960:	00451693          	slli	a3,a0,0x4
    80005964:	00027797          	auipc	a5,0x27
    80005968:	95478793          	addi	a5,a5,-1708 # 8002c2b8 <disk>
    8000596c:	6398                	ld	a4,0(a5)
    8000596e:	9736                	add	a4,a4,a3
    80005970:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005974:	6398                	ld	a4,0(a5)
    80005976:	9736                	add	a4,a4,a3
    80005978:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000597c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005980:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005984:	97aa                	add	a5,a5,a0
    80005986:	4705                	li	a4,1
    80005988:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000598c:	00027517          	auipc	a0,0x27
    80005990:	94450513          	addi	a0,a0,-1724 # 8002c2d0 <disk+0x18>
    80005994:	8d7fc0ef          	jal	8000226a <wakeup>
}
    80005998:	60a2                	ld	ra,8(sp)
    8000599a:	6402                	ld	s0,0(sp)
    8000599c:	0141                	addi	sp,sp,16
    8000599e:	8082                	ret
    panic("free_desc 1");
    800059a0:	00003517          	auipc	a0,0x3
    800059a4:	e1850513          	addi	a0,a0,-488 # 800087b8 <etext+0x7b8>
    800059a8:	dfbfa0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    800059ac:	00003517          	auipc	a0,0x3
    800059b0:	e1c50513          	addi	a0,a0,-484 # 800087c8 <etext+0x7c8>
    800059b4:	deffa0ef          	jal	800007a2 <panic>

00000000800059b8 <virtio_disk_init>:
{
    800059b8:	1101                	addi	sp,sp,-32
    800059ba:	ec06                	sd	ra,24(sp)
    800059bc:	e822                	sd	s0,16(sp)
    800059be:	e426                	sd	s1,8(sp)
    800059c0:	e04a                	sd	s2,0(sp)
    800059c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800059c4:	00003597          	auipc	a1,0x3
    800059c8:	e1458593          	addi	a1,a1,-492 # 800087d8 <etext+0x7d8>
    800059cc:	00027517          	auipc	a0,0x27
    800059d0:	a1450513          	addi	a0,a0,-1516 # 8002c3e0 <disk+0x128>
    800059d4:	9aefb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059d8:	100017b7          	lui	a5,0x10001
    800059dc:	4398                	lw	a4,0(a5)
    800059de:	2701                	sext.w	a4,a4
    800059e0:	747277b7          	lui	a5,0x74727
    800059e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800059e8:	18f71063          	bne	a4,a5,80005b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800059ec:	100017b7          	lui	a5,0x10001
    800059f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800059f2:	439c                	lw	a5,0(a5)
    800059f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059f6:	4709                	li	a4,2
    800059f8:	16e79863          	bne	a5,a4,80005b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059fc:	100017b7          	lui	a5,0x10001
    80005a00:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005a02:	439c                	lw	a5,0(a5)
    80005a04:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005a06:	16e79163          	bne	a5,a4,80005b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005a0a:	100017b7          	lui	a5,0x10001
    80005a0e:	47d8                	lw	a4,12(a5)
    80005a10:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005a12:	554d47b7          	lui	a5,0x554d4
    80005a16:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005a1a:	14f71763          	bne	a4,a5,80005b68 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a1e:	100017b7          	lui	a5,0x10001
    80005a22:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a26:	4705                	li	a4,1
    80005a28:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a2a:	470d                	li	a4,3
    80005a2c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005a2e:	10001737          	lui	a4,0x10001
    80005a32:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005a34:	c7ffe737          	lui	a4,0xc7ffe
    80005a38:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd2367>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005a3c:	8ef9                	and	a3,a3,a4
    80005a3e:	10001737          	lui	a4,0x10001
    80005a42:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a44:	472d                	li	a4,11
    80005a46:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a48:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005a4c:	439c                	lw	a5,0(a5)
    80005a4e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005a52:	8ba1                	andi	a5,a5,8
    80005a54:	12078063          	beqz	a5,80005b74 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005a58:	100017b7          	lui	a5,0x10001
    80005a5c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005a60:	100017b7          	lui	a5,0x10001
    80005a64:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005a68:	439c                	lw	a5,0(a5)
    80005a6a:	2781                	sext.w	a5,a5
    80005a6c:	10079a63          	bnez	a5,80005b80 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005a70:	100017b7          	lui	a5,0x10001
    80005a74:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005a78:	439c                	lw	a5,0(a5)
    80005a7a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005a7c:	10078863          	beqz	a5,80005b8c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005a80:	471d                	li	a4,7
    80005a82:	10f77b63          	bgeu	a4,a5,80005b98 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005a86:	8acfb0ef          	jal	80000b32 <kalloc>
    80005a8a:	00027497          	auipc	s1,0x27
    80005a8e:	82e48493          	addi	s1,s1,-2002 # 8002c2b8 <disk>
    80005a92:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005a94:	89efb0ef          	jal	80000b32 <kalloc>
    80005a98:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005a9a:	898fb0ef          	jal	80000b32 <kalloc>
    80005a9e:	87aa                	mv	a5,a0
    80005aa0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005aa2:	6088                	ld	a0,0(s1)
    80005aa4:	10050063          	beqz	a0,80005ba4 <virtio_disk_init+0x1ec>
    80005aa8:	00027717          	auipc	a4,0x27
    80005aac:	81873703          	ld	a4,-2024(a4) # 8002c2c0 <disk+0x8>
    80005ab0:	0e070a63          	beqz	a4,80005ba4 <virtio_disk_init+0x1ec>
    80005ab4:	0e078863          	beqz	a5,80005ba4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005ab8:	6605                	lui	a2,0x1
    80005aba:	4581                	li	a1,0
    80005abc:	a1afb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005ac0:	00026497          	auipc	s1,0x26
    80005ac4:	7f848493          	addi	s1,s1,2040 # 8002c2b8 <disk>
    80005ac8:	6605                	lui	a2,0x1
    80005aca:	4581                	li	a1,0
    80005acc:	6488                	ld	a0,8(s1)
    80005ace:	a08fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    80005ad2:	6605                	lui	a2,0x1
    80005ad4:	4581                	li	a1,0
    80005ad6:	6888                	ld	a0,16(s1)
    80005ad8:	9fefb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005adc:	100017b7          	lui	a5,0x10001
    80005ae0:	4721                	li	a4,8
    80005ae2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ae4:	4098                	lw	a4,0(s1)
    80005ae6:	100017b7          	lui	a5,0x10001
    80005aea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005aee:	40d8                	lw	a4,4(s1)
    80005af0:	100017b7          	lui	a5,0x10001
    80005af4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005af8:	649c                	ld	a5,8(s1)
    80005afa:	0007869b          	sext.w	a3,a5
    80005afe:	10001737          	lui	a4,0x10001
    80005b02:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005b06:	9781                	srai	a5,a5,0x20
    80005b08:	10001737          	lui	a4,0x10001
    80005b0c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005b10:	689c                	ld	a5,16(s1)
    80005b12:	0007869b          	sext.w	a3,a5
    80005b16:	10001737          	lui	a4,0x10001
    80005b1a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005b1e:	9781                	srai	a5,a5,0x20
    80005b20:	10001737          	lui	a4,0x10001
    80005b24:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005b28:	10001737          	lui	a4,0x10001
    80005b2c:	4785                	li	a5,1
    80005b2e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005b30:	00f48c23          	sb	a5,24(s1)
    80005b34:	00f48ca3          	sb	a5,25(s1)
    80005b38:	00f48d23          	sb	a5,26(s1)
    80005b3c:	00f48da3          	sb	a5,27(s1)
    80005b40:	00f48e23          	sb	a5,28(s1)
    80005b44:	00f48ea3          	sb	a5,29(s1)
    80005b48:	00f48f23          	sb	a5,30(s1)
    80005b4c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005b50:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b54:	100017b7          	lui	a5,0x10001
    80005b58:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005b5c:	60e2                	ld	ra,24(sp)
    80005b5e:	6442                	ld	s0,16(sp)
    80005b60:	64a2                	ld	s1,8(sp)
    80005b62:	6902                	ld	s2,0(sp)
    80005b64:	6105                	addi	sp,sp,32
    80005b66:	8082                	ret
    panic("could not find virtio disk");
    80005b68:	00003517          	auipc	a0,0x3
    80005b6c:	c8050513          	addi	a0,a0,-896 # 800087e8 <etext+0x7e8>
    80005b70:	c33fa0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005b74:	00003517          	auipc	a0,0x3
    80005b78:	c9450513          	addi	a0,a0,-876 # 80008808 <etext+0x808>
    80005b7c:	c27fa0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005b80:	00003517          	auipc	a0,0x3
    80005b84:	ca850513          	addi	a0,a0,-856 # 80008828 <etext+0x828>
    80005b88:	c1bfa0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    80005b8c:	00003517          	auipc	a0,0x3
    80005b90:	cbc50513          	addi	a0,a0,-836 # 80008848 <etext+0x848>
    80005b94:	c0ffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    80005b98:	00003517          	auipc	a0,0x3
    80005b9c:	cd050513          	addi	a0,a0,-816 # 80008868 <etext+0x868>
    80005ba0:	c03fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    80005ba4:	00003517          	auipc	a0,0x3
    80005ba8:	ce450513          	addi	a0,a0,-796 # 80008888 <etext+0x888>
    80005bac:	bf7fa0ef          	jal	800007a2 <panic>

0000000080005bb0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005bb0:	7159                	addi	sp,sp,-112
    80005bb2:	f486                	sd	ra,104(sp)
    80005bb4:	f0a2                	sd	s0,96(sp)
    80005bb6:	eca6                	sd	s1,88(sp)
    80005bb8:	e8ca                	sd	s2,80(sp)
    80005bba:	e4ce                	sd	s3,72(sp)
    80005bbc:	e0d2                	sd	s4,64(sp)
    80005bbe:	fc56                	sd	s5,56(sp)
    80005bc0:	f85a                	sd	s6,48(sp)
    80005bc2:	f45e                	sd	s7,40(sp)
    80005bc4:	f062                	sd	s8,32(sp)
    80005bc6:	ec66                	sd	s9,24(sp)
    80005bc8:	1880                	addi	s0,sp,112
    80005bca:	8a2a                	mv	s4,a0
    80005bcc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005bce:	00c52c83          	lw	s9,12(a0)
    80005bd2:	001c9c9b          	slliw	s9,s9,0x1
    80005bd6:	1c82                	slli	s9,s9,0x20
    80005bd8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005bdc:	00027517          	auipc	a0,0x27
    80005be0:	80450513          	addi	a0,a0,-2044 # 8002c3e0 <disk+0x128>
    80005be4:	81efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005be8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005bea:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005bec:	00026b17          	auipc	s6,0x26
    80005bf0:	6ccb0b13          	addi	s6,s6,1740 # 8002c2b8 <disk>
  for(int i = 0; i < 3; i++){
    80005bf4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005bf6:	00026c17          	auipc	s8,0x26
    80005bfa:	7eac0c13          	addi	s8,s8,2026 # 8002c3e0 <disk+0x128>
    80005bfe:	a8b9                	j	80005c5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005c00:	00fb0733          	add	a4,s6,a5
    80005c04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005c08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005c0a:	0207c563          	bltz	a5,80005c34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005c0e:	2905                	addiw	s2,s2,1
    80005c10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005c12:	05590963          	beq	s2,s5,80005c64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005c16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005c18:	00026717          	auipc	a4,0x26
    80005c1c:	6a070713          	addi	a4,a4,1696 # 8002c2b8 <disk>
    80005c20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005c22:	01874683          	lbu	a3,24(a4)
    80005c26:	fee9                	bnez	a3,80005c00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005c28:	2785                	addiw	a5,a5,1
    80005c2a:	0705                	addi	a4,a4,1
    80005c2c:	fe979be3          	bne	a5,s1,80005c22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005c30:	57fd                	li	a5,-1
    80005c32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005c34:	01205d63          	blez	s2,80005c4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c38:	f9042503          	lw	a0,-112(s0)
    80005c3c:	d07ff0ef          	jal	80005942 <free_desc>
      for(int j = 0; j < i; j++)
    80005c40:	4785                	li	a5,1
    80005c42:	0127d663          	bge	a5,s2,80005c4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c46:	f9442503          	lw	a0,-108(s0)
    80005c4a:	cf9ff0ef          	jal	80005942 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005c4e:	85e2                	mv	a1,s8
    80005c50:	00026517          	auipc	a0,0x26
    80005c54:	68050513          	addi	a0,a0,1664 # 8002c2d0 <disk+0x18>
    80005c58:	cc6fc0ef          	jal	8000211e <sleep>
  for(int i = 0; i < 3; i++){
    80005c5c:	f9040613          	addi	a2,s0,-112
    80005c60:	894e                	mv	s2,s3
    80005c62:	bf55                	j	80005c16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c64:	f9042503          	lw	a0,-112(s0)
    80005c68:	00451693          	slli	a3,a0,0x4

  if(write)
    80005c6c:	00026797          	auipc	a5,0x26
    80005c70:	64c78793          	addi	a5,a5,1612 # 8002c2b8 <disk>
    80005c74:	00a50713          	addi	a4,a0,10
    80005c78:	0712                	slli	a4,a4,0x4
    80005c7a:	973e                	add	a4,a4,a5
    80005c7c:	01703633          	snez	a2,s7
    80005c80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005c82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005c86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c8a:	6398                	ld	a4,0(a5)
    80005c8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c8e:	0a868613          	addi	a2,a3,168
    80005c92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005c96:	6390                	ld	a2,0(a5)
    80005c98:	00d605b3          	add	a1,a2,a3
    80005c9c:	4741                	li	a4,16
    80005c9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ca0:	4805                	li	a6,1
    80005ca2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005ca6:	f9442703          	lw	a4,-108(s0)
    80005caa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005cae:	0712                	slli	a4,a4,0x4
    80005cb0:	963a                	add	a2,a2,a4
    80005cb2:	058a0593          	addi	a1,s4,88
    80005cb6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005cb8:	0007b883          	ld	a7,0(a5)
    80005cbc:	9746                	add	a4,a4,a7
    80005cbe:	40000613          	li	a2,1024
    80005cc2:	c710                	sw	a2,8(a4)
  if(write)
    80005cc4:	001bb613          	seqz	a2,s7
    80005cc8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005ccc:	00166613          	ori	a2,a2,1
    80005cd0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005cd4:	f9842583          	lw	a1,-104(s0)
    80005cd8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005cdc:	00250613          	addi	a2,a0,2
    80005ce0:	0612                	slli	a2,a2,0x4
    80005ce2:	963e                	add	a2,a2,a5
    80005ce4:	577d                	li	a4,-1
    80005ce6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005cea:	0592                	slli	a1,a1,0x4
    80005cec:	98ae                	add	a7,a7,a1
    80005cee:	03068713          	addi	a4,a3,48
    80005cf2:	973e                	add	a4,a4,a5
    80005cf4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005cf8:	6398                	ld	a4,0(a5)
    80005cfa:	972e                	add	a4,a4,a1
    80005cfc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005d00:	4689                	li	a3,2
    80005d02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005d06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005d0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005d0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005d12:	6794                	ld	a3,8(a5)
    80005d14:	0026d703          	lhu	a4,2(a3)
    80005d18:	8b1d                	andi	a4,a4,7
    80005d1a:	0706                	slli	a4,a4,0x1
    80005d1c:	96ba                	add	a3,a3,a4
    80005d1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005d22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005d26:	6798                	ld	a4,8(a5)
    80005d28:	00275783          	lhu	a5,2(a4)
    80005d2c:	2785                	addiw	a5,a5,1
    80005d2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005d32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d36:	100017b7          	lui	a5,0x10001
    80005d3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005d3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005d42:	00026917          	auipc	s2,0x26
    80005d46:	69e90913          	addi	s2,s2,1694 # 8002c3e0 <disk+0x128>
  while(b->disk == 1) {
    80005d4a:	4485                	li	s1,1
    80005d4c:	01079a63          	bne	a5,a6,80005d60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005d50:	85ca                	mv	a1,s2
    80005d52:	8552                	mv	a0,s4
    80005d54:	bcafc0ef          	jal	8000211e <sleep>
  while(b->disk == 1) {
    80005d58:	004a2783          	lw	a5,4(s4)
    80005d5c:	fe978ae3          	beq	a5,s1,80005d50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005d60:	f9042903          	lw	s2,-112(s0)
    80005d64:	00290713          	addi	a4,s2,2
    80005d68:	0712                	slli	a4,a4,0x4
    80005d6a:	00026797          	auipc	a5,0x26
    80005d6e:	54e78793          	addi	a5,a5,1358 # 8002c2b8 <disk>
    80005d72:	97ba                	add	a5,a5,a4
    80005d74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005d78:	00026997          	auipc	s3,0x26
    80005d7c:	54098993          	addi	s3,s3,1344 # 8002c2b8 <disk>
    80005d80:	00491713          	slli	a4,s2,0x4
    80005d84:	0009b783          	ld	a5,0(s3)
    80005d88:	97ba                	add	a5,a5,a4
    80005d8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005d8e:	854a                	mv	a0,s2
    80005d90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005d94:	bafff0ef          	jal	80005942 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005d98:	8885                	andi	s1,s1,1
    80005d9a:	f0fd                	bnez	s1,80005d80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005d9c:	00026517          	auipc	a0,0x26
    80005da0:	64450513          	addi	a0,a0,1604 # 8002c3e0 <disk+0x128>
    80005da4:	ef7fa0ef          	jal	80000c9a <release>
}
    80005da8:	70a6                	ld	ra,104(sp)
    80005daa:	7406                	ld	s0,96(sp)
    80005dac:	64e6                	ld	s1,88(sp)
    80005dae:	6946                	ld	s2,80(sp)
    80005db0:	69a6                	ld	s3,72(sp)
    80005db2:	6a06                	ld	s4,64(sp)
    80005db4:	7ae2                	ld	s5,56(sp)
    80005db6:	7b42                	ld	s6,48(sp)
    80005db8:	7ba2                	ld	s7,40(sp)
    80005dba:	7c02                	ld	s8,32(sp)
    80005dbc:	6ce2                	ld	s9,24(sp)
    80005dbe:	6165                	addi	sp,sp,112
    80005dc0:	8082                	ret

0000000080005dc2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005dc2:	1101                	addi	sp,sp,-32
    80005dc4:	ec06                	sd	ra,24(sp)
    80005dc6:	e822                	sd	s0,16(sp)
    80005dc8:	e426                	sd	s1,8(sp)
    80005dca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005dcc:	00026497          	auipc	s1,0x26
    80005dd0:	4ec48493          	addi	s1,s1,1260 # 8002c2b8 <disk>
    80005dd4:	00026517          	auipc	a0,0x26
    80005dd8:	60c50513          	addi	a0,a0,1548 # 8002c3e0 <disk+0x128>
    80005ddc:	e27fa0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005de0:	100017b7          	lui	a5,0x10001
    80005de4:	53b8                	lw	a4,96(a5)
    80005de6:	8b0d                	andi	a4,a4,3
    80005de8:	100017b7          	lui	a5,0x10001
    80005dec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005dee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005df2:	689c                	ld	a5,16(s1)
    80005df4:	0204d703          	lhu	a4,32(s1)
    80005df8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005dfc:	04f70663          	beq	a4,a5,80005e48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005e00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005e04:	6898                	ld	a4,16(s1)
    80005e06:	0204d783          	lhu	a5,32(s1)
    80005e0a:	8b9d                	andi	a5,a5,7
    80005e0c:	078e                	slli	a5,a5,0x3
    80005e0e:	97ba                	add	a5,a5,a4
    80005e10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005e12:	00278713          	addi	a4,a5,2
    80005e16:	0712                	slli	a4,a4,0x4
    80005e18:	9726                	add	a4,a4,s1
    80005e1a:	01074703          	lbu	a4,16(a4)
    80005e1e:	e321                	bnez	a4,80005e5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005e20:	0789                	addi	a5,a5,2
    80005e22:	0792                	slli	a5,a5,0x4
    80005e24:	97a6                	add	a5,a5,s1
    80005e26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005e28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005e2c:	c3efc0ef          	jal	8000226a <wakeup>

    disk.used_idx += 1;
    80005e30:	0204d783          	lhu	a5,32(s1)
    80005e34:	2785                	addiw	a5,a5,1
    80005e36:	17c2                	slli	a5,a5,0x30
    80005e38:	93c1                	srli	a5,a5,0x30
    80005e3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005e3e:	6898                	ld	a4,16(s1)
    80005e40:	00275703          	lhu	a4,2(a4)
    80005e44:	faf71ee3          	bne	a4,a5,80005e00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005e48:	00026517          	auipc	a0,0x26
    80005e4c:	59850513          	addi	a0,a0,1432 # 8002c3e0 <disk+0x128>
    80005e50:	e4bfa0ef          	jal	80000c9a <release>
}
    80005e54:	60e2                	ld	ra,24(sp)
    80005e56:	6442                	ld	s0,16(sp)
    80005e58:	64a2                	ld	s1,8(sp)
    80005e5a:	6105                	addi	sp,sp,32
    80005e5c:	8082                	ret
      panic("virtio_disk_intr status");
    80005e5e:	00003517          	auipc	a0,0x3
    80005e62:	a4250513          	addi	a0,a0,-1470 # 800088a0 <etext+0x8a0>
    80005e66:	93dfa0ef          	jal	800007a2 <panic>

0000000080005e6a <sys_kbdint>:


extern int kbd_intr_count;
uint64
sys_kbdint(void)
{
    80005e6a:	1141                	addi	sp,sp,-16
    80005e6c:	e422                	sd	s0,8(sp)
    80005e6e:	0800                	addi	s0,sp,16
  return kbd_intr_count;
}
    80005e70:	00005517          	auipc	a0,0x5
    80005e74:	7d052503          	lw	a0,2000(a0) # 8000b640 <kbd_intr_count>
    80005e78:	6422                	ld	s0,8(sp)
    80005e7a:	0141                	addi	sp,sp,16
    80005e7c:	8082                	ret

0000000080005e7e <sys_countsyscall>:

extern int syscall_counter;

uint64
sys_countsyscall(void)
{
    80005e7e:	1141                	addi	sp,sp,-16
    80005e80:	e422                	sd	s0,8(sp)
    80005e82:	0800                	addi	s0,sp,16
  return syscall_counter;
}
    80005e84:	00006517          	auipc	a0,0x6
    80005e88:	82052503          	lw	a0,-2016(a0) # 8000b6a4 <syscall_counter>
    80005e8c:	6422                	ld	s0,8(sp)
    80005e8e:	0141                	addi	sp,sp,16
    80005e90:	8082                	ret

0000000080005e92 <convert_unix_time_to_rtcdate>:
  if (copyout(myproc()->pagetable, user_dst, (char*)&r, sizeof(r)) < 0)
    return -1;

  return 0;
}
void convert_unix_time_to_rtcdate(uint64 unix_time, struct rtcdate *r) {
    80005e92:	7139                	addi	sp,sp,-64
    80005e94:	fc22                	sd	s0,56(sp)
    80005e96:	0080                	addi	s0,sp,64
  // Seconds in time units
  int days_in_month[] = {31,28,31,30,31,30,31,31,30,31,30,31};
    80005e98:	00003797          	auipc	a5,0x3
    80005e9c:	b7878793          	addi	a5,a5,-1160 # 80008a10 <syscalls+0xf8>
    80005ea0:	0007b883          	ld	a7,0(a5)
    80005ea4:	0087b803          	ld	a6,8(a5)
    80005ea8:	6b90                	ld	a2,16(a5)
    80005eaa:	6f94                	ld	a3,24(a5)
    80005eac:	7398                	ld	a4,32(a5)
    80005eae:	779c                	ld	a5,40(a5)
    80005eb0:	fd143023          	sd	a7,-64(s0)
    80005eb4:	fd043423          	sd	a6,-56(s0)
    80005eb8:	fcc43823          	sd	a2,-48(s0)
    80005ebc:	fcd43c23          	sd	a3,-40(s0)
    80005ec0:	fee43023          	sd	a4,-32(s0)
    80005ec4:	fef43423          	sd	a5,-24(s0)
  int year = 1970;
  int month, day;
  int days = unix_time / 86400;
    80005ec8:	6755                	lui	a4,0x15
    80005eca:	18070713          	addi	a4,a4,384 # 15180 <_entry-0x7ffeae80>
    80005ece:	02e557b3          	divu	a5,a0,a4
    80005ed2:	2781                	sext.w	a5,a5
  int secs_remaining = unix_time % 86400;
    80005ed4:	02e57533          	remu	a0,a0,a4
  int year = 1970;
    80005ed8:	7b200693          	li	a3,1970

  // Calculate current year
  while (1) {
    int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    80005edc:	06400893          	li	a7,100
    80005ee0:	19000313          	li	t1,400
    80005ee4:	a029                	j	80005eee <convert_unix_time_to_rtcdate+0x5c>
    int days_in_year = leap ? 366 : 365;
    if (days >= days_in_year) {
    80005ee6:	02e7c663          	blt	a5,a4,80005f12 <convert_unix_time_to_rtcdate+0x80>
      days -= days_in_year;
    80005eea:	9f99                	subw	a5,a5,a4
      year++;
    80005eec:	2685                	addiw	a3,a3,1
    int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    80005eee:	0036f613          	andi	a2,a3,3
    int days_in_year = leap ? 366 : 365;
    80005ef2:	16d00713          	li	a4,365
    int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    80005ef6:	fa65                	bnez	a2,80005ee6 <convert_unix_time_to_rtcdate+0x54>
    80005ef8:	0316e83b          	remw	a6,a3,a7
    int days_in_year = leap ? 366 : 365;
    80005efc:	16e00713          	li	a4,366
    int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    80005f00:	fe0813e3          	bnez	a6,80005ee6 <convert_unix_time_to_rtcdate+0x54>
    80005f04:	0266e73b          	remw	a4,a3,t1
    int days_in_year = leap ? 366 : 365;
    80005f08:	00173713          	seqz	a4,a4
    80005f0c:	16d70713          	addi	a4,a4,365
    80005f10:	bfd9                	j	80005ee6 <convert_unix_time_to_rtcdate+0x54>
      break;
    }
  }

  // Handle leap year for current year
  int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    80005f12:	ee11                	bnez	a2,80005f2e <convert_unix_time_to_rtcdate+0x9c>
    80005f14:	06400713          	li	a4,100
    80005f18:	02e6e73b          	remw	a4,a3,a4
    80005f1c:	e711                	bnez	a4,80005f28 <convert_unix_time_to_rtcdate+0x96>
    80005f1e:	19000713          	li	a4,400
    80005f22:	02e6e73b          	remw	a4,a3,a4
    80005f26:	e701                	bnez	a4,80005f2e <convert_unix_time_to_rtcdate+0x9c>
  if (leap)
    days_in_month[1] = 29;
    80005f28:	4775                	li	a4,29
    80005f2a:	fce42223          	sw	a4,-60(s0)

  // Calculate month and day
  month = 0;
  while (days >= days_in_month[month]) {
    80005f2e:	fc042703          	lw	a4,-64(s0)
    80005f32:	04e7c563          	blt	a5,a4,80005f7c <convert_unix_time_to_rtcdate+0xea>
    80005f36:	fc440613          	addi	a2,s0,-60
  month = 0;
    80005f3a:	4801                	li	a6,0
    days -= days_in_month[month];
    80005f3c:	9f99                	subw	a5,a5,a4
    month++;
    80005f3e:	2805                	addiw	a6,a6,1
  while (days >= days_in_month[month]) {
    80005f40:	0611                	addi	a2,a2,4
    80005f42:	ffc62703          	lw	a4,-4(a2)
    80005f46:	fee7dbe3          	bge	a5,a4,80005f3c <convert_unix_time_to_rtcdate+0xaa>
  }
  day = days + 1;

  // Calculate hour, minute, second
  int hour = secs_remaining / 3600;
  secs_remaining %= 3600;
    80005f4a:	6605                	lui	a2,0x1
    80005f4c:	e106061b          	addiw	a2,a2,-496 # e10 <_entry-0x7ffff1f0>
    80005f50:	02c5673b          	remw	a4,a0,a2
  int minute = secs_remaining / 60;
  int second = secs_remaining % 60;

  // Fill struct
  r->year = year;
    80005f54:	c194                	sw	a3,0(a1)
  r->month = month + 1; // month is 0-indexed
    80005f56:	2805                	addiw	a6,a6,1
    80005f58:	0105a223          	sw	a6,4(a1)
  day = days + 1;
    80005f5c:	2785                	addiw	a5,a5,1
  r->day = day;
    80005f5e:	c59c                	sw	a5,8(a1)
  int hour = secs_remaining / 3600;
    80005f60:	02c5453b          	divw	a0,a0,a2
  r->hour = hour;
    80005f64:	c5c8                	sw	a0,12(a1)
  int minute = secs_remaining / 60;
    80005f66:	03c00793          	li	a5,60
    80005f6a:	02f746bb          	divw	a3,a4,a5
  r->minute = minute;
    80005f6e:	c994                	sw	a3,16(a1)
  int second = secs_remaining % 60;
    80005f70:	02f7673b          	remw	a4,a4,a5
  r->second = second;
    80005f74:	c9d8                	sw	a4,20(a1)
}
    80005f76:	7462                	ld	s0,56(sp)
    80005f78:	6121                	addi	sp,sp,64
    80005f7a:	8082                	ret
  month = 0;
    80005f7c:	4801                	li	a6,0
    80005f7e:	b7f1                	j	80005f4a <convert_unix_time_to_rtcdate+0xb8>

0000000080005f80 <sys_datetime>:
{
    80005f80:	7179                	addi	sp,sp,-48
    80005f82:	f406                	sd	ra,40(sp)
    80005f84:	f022                	sd	s0,32(sp)
    80005f86:	1800                	addi	s0,sp,48
  if (argaddr(0, &user_dst) < 0)
    80005f88:	fe840593          	addi	a1,s0,-24
    80005f8c:	4501                	li	a0,0
    80005f8e:	c83fc0ef          	jal	80002c10 <argaddr>
    80005f92:	87aa                	mv	a5,a0
    return -1;
    80005f94:	557d                	li	a0,-1
  if (argaddr(0, &user_dst) < 0)
    80005f96:	0407c763          	bltz	a5,80005fe4 <sys_datetime+0x64>
  uint64 ticks = *(volatile uint64*)CLINT_MTIME;
    80005f9a:	0200c7b7          	lui	a5,0x200c
    80005f9e:	ff87b503          	ld	a0,-8(a5) # 200bff8 <_entry-0x7dff4008>
  uint64 seconds = ticks / MTIME_FREQ;
    80005fa2:	009a27b7          	lui	a5,0x9a2
    80005fa6:	d2078793          	addi	a5,a5,-736 # 9a1d20 <_entry-0x7f65e2e0>
    80005faa:	02f55533          	divu	a0,a0,a5
  uint64 now = BOOT_EPOCH + seconds + TIMEZONE_OFFSET;
    80005fae:	682a67b7          	lui	a5,0x682a6
    80005fb2:	58178793          	addi	a5,a5,1409 # 682a6581 <_entry-0x17d59a7f>
  convert_unix_time_to_rtcdate(now, &r);
    80005fb6:	fd040593          	addi	a1,s0,-48
    80005fba:	953e                	add	a0,a0,a5
    80005fbc:	ed7ff0ef          	jal	80005e92 <convert_unix_time_to_rtcdate>
  if (user_dst < USERBASE || user_dst >= USERTOP) {
    80005fc0:	fe843703          	ld	a4,-24(s0)
    80005fc4:	400007b7          	lui	a5,0x40000
    return -1;  // Invalid user address (outside of user space range)
    80005fc8:	557d                	li	a0,-1
  if (user_dst < USERBASE || user_dst >= USERTOP) {
    80005fca:	00f77d63          	bgeu	a4,a5,80005fe4 <sys_datetime+0x64>
  if (copyout(myproc()->pagetable, user_dst, (char*)&r, sizeof(r)) < 0)
    80005fce:	933fb0ef          	jal	80001900 <myproc>
    80005fd2:	46e1                	li	a3,24
    80005fd4:	fd040613          	addi	a2,s0,-48
    80005fd8:	fe843583          	ld	a1,-24(s0)
    80005fdc:	6948                	ld	a0,144(a0)
    80005fde:	d94fb0ef          	jal	80001572 <copyout>
    80005fe2:	957d                	srai	a0,a0,0x3f
}
    80005fe4:	70a2                	ld	ra,40(sp)
    80005fe6:	7402                	ld	s0,32(sp)
    80005fe8:	6145                	addi	sp,sp,48
    80005fea:	8082                	ret

0000000080005fec <sys_sysrand>:

static uint seed = 1; // default seed

uint64
sys_sysrand(void)
{
    80005fec:	1141                	addi	sp,sp,-16
    80005fee:	e422                	sd	s0,8(sp)
    80005ff0:	0800                	addi	s0,sp,16
  // Optional: reseed occasionally using ticks for variability
  seed = seed * 1664525 + 1013904223;
    80005ff2:	00005717          	auipc	a4,0x5
    80005ff6:	5e670713          	addi	a4,a4,1510 # 8000b5d8 <seed>
    80005ffa:	431c                	lw	a5,0(a4)
    80005ffc:	00196537          	lui	a0,0x196
    80006000:	60d5051b          	addiw	a0,a0,1549 # 19660d <_entry-0x7fe699f3>
    80006004:	02f5053b          	mulw	a0,a0,a5
    80006008:	3c6ef7b7          	lui	a5,0x3c6ef
    8000600c:	35f7879b          	addiw	a5,a5,863 # 3c6ef35f <_entry-0x43910ca1>
    80006010:	9d3d                	addw	a0,a0,a5
    80006012:	c308                	sw	a0,0(a4)
  return seed;
}
    80006014:	1502                	slli	a0,a0,0x20
    80006016:	9101                	srli	a0,a0,0x20
    80006018:	6422                	ld	s0,8(sp)
    8000601a:	0141                	addi	sp,sp,16
    8000601c:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
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
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
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
