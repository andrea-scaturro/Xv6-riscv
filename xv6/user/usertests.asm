
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	de4080e7          	jalr	-540(ra) # 5df4 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	dd2080e7          	jalr	-558(ra) # 5df4 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	28250513          	add	a0,a0,642 # 62c0 <malloc+0xec>
      46:	00006097          	auipc	ra,0x6
      4a:	0d6080e7          	jalr	214(ra) # 611c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	d54080e7          	jalr	-684(ra) # 5da4 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	add	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	add	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	26050513          	add	a0,a0,608 # 62e0 <malloc+0x10c>
      88:	00006097          	auipc	ra,0x6
      8c:	094080e7          	jalr	148(ra) # 611c <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	d12080e7          	jalr	-750(ra) # 5da4 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	25050513          	add	a0,a0,592 # 62f8 <malloc+0x124>
      b0:	00006097          	auipc	ra,0x6
      b4:	d44080e7          	jalr	-700(ra) # 5df4 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	d10080e7          	jalr	-752(ra) # 5dcc <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	25250513          	add	a0,a0,594 # 6318 <malloc+0x144>
      ce:	00006097          	auipc	ra,0x6
      d2:	d26080e7          	jalr	-730(ra) # 5df4 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	21a50513          	add	a0,a0,538 # 6300 <malloc+0x12c>
      ee:	00006097          	auipc	ra,0x6
      f2:	02e080e7          	jalr	46(ra) # 611c <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	cac080e7          	jalr	-852(ra) # 5da4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	22650513          	add	a0,a0,550 # 6328 <malloc+0x154>
     10a:	00006097          	auipc	ra,0x6
     10e:	012080e7          	jalr	18(ra) # 611c <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	c90080e7          	jalr	-880(ra) # 5da4 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	22450513          	add	a0,a0,548 # 6350 <malloc+0x17c>
     134:	00006097          	auipc	ra,0x6
     138:	cd0080e7          	jalr	-816(ra) # 5e04 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	21050513          	add	a0,a0,528 # 6350 <malloc+0x17c>
     148:	00006097          	auipc	ra,0x6
     14c:	cac080e7          	jalr	-852(ra) # 5df4 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	20c58593          	add	a1,a1,524 # 6360 <malloc+0x18c>
     15c:	00006097          	auipc	ra,0x6
     160:	c68080e7          	jalr	-920(ra) # 5dc4 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	1e850513          	add	a0,a0,488 # 6350 <malloc+0x17c>
     170:	00006097          	auipc	ra,0x6
     174:	c84080e7          	jalr	-892(ra) # 5df4 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	1ec58593          	add	a1,a1,492 # 6368 <malloc+0x194>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	c3e080e7          	jalr	-962(ra) # 5dc4 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	1bc50513          	add	a0,a0,444 # 6350 <malloc+0x17c>
     19c:	00006097          	auipc	ra,0x6
     1a0:	c68080e7          	jalr	-920(ra) # 5e04 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	c26080e7          	jalr	-986(ra) # 5dcc <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	c1c080e7          	jalr	-996(ra) # 5dcc <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	1a650513          	add	a0,a0,422 # 6370 <malloc+0x19c>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	f4a080e7          	jalr	-182(ra) # 611c <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	bc8080e7          	jalr	-1080(ra) # 5da4 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	be4080e7          	jalr	-1052(ra) # 5df4 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	bb4080e7          	jalr	-1100(ra) # 5dcc <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	bbe080e7          	jalr	-1090(ra) # 5e04 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	11c50513          	add	a0,a0,284 # 6398 <malloc+0x1c4>
     284:	00006097          	auipc	ra,0x6
     288:	b80080e7          	jalr	-1152(ra) # 5e04 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	108a8a93          	add	s5,s5,264 # 6398 <malloc+0x1c4>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	add	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <fourteen+0x193>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	b48080e7          	jalr	-1208(ra) # 5df4 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	b06080e7          	jalr	-1274(ra) # 5dc4 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	af2080e7          	jalr	-1294(ra) # 5dc4 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	aec080e7          	jalr	-1300(ra) # 5dcc <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	b1a080e7          	jalr	-1254(ra) # 5e04 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	09650513          	add	a0,a0,150 # 63a8 <malloc+0x1d4>
     31a:	00006097          	auipc	ra,0x6
     31e:	e02080e7          	jalr	-510(ra) # 611c <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	a80080e7          	jalr	-1408(ra) # 5da4 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	09450513          	add	a0,a0,148 # 63c8 <malloc+0x1f4>
     33c:	00006097          	auipc	ra,0x6
     340:	de0080e7          	jalr	-544(ra) # 611c <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	a5e080e7          	jalr	-1442(ra) # 5da4 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	add	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	08250513          	add	a0,a0,130 # 63e0 <malloc+0x20c>
     366:	00006097          	auipc	ra,0x6
     36a:	a9e080e7          	jalr	-1378(ra) # 5e04 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	06e98993          	add	s3,s3,110 # 63e0 <malloc+0x20c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	a6e080e7          	jalr	-1426(ra) # 5df4 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	a2c080e7          	jalr	-1492(ra) # 5dc4 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	a2a080e7          	jalr	-1494(ra) # 5dcc <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	a58080e7          	jalr	-1448(ra) # 5e04 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	02250513          	add	a0,a0,34 # 63e0 <malloc+0x20c>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	a2e080e7          	jalr	-1490(ra) # 5df4 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	f9258593          	add	a1,a1,-110 # 6368 <malloc+0x194>
     3de:	00006097          	auipc	ra,0x6
     3e2:	9e6080e7          	jalr	-1562(ra) # 5dc4 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	01450513          	add	a0,a0,20 # 6400 <malloc+0x22c>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	d28080e7          	jalr	-728(ra) # 611c <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	9a6080e7          	jalr	-1626(ra) # 5da4 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	fe250513          	add	a0,a0,-30 # 63e8 <malloc+0x214>
     40e:	00006097          	auipc	ra,0x6
     412:	d0e080e7          	jalr	-754(ra) # 611c <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00006097          	auipc	ra,0x6
     41c:	98c080e7          	jalr	-1652(ra) # 5da4 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	fc850513          	add	a0,a0,-56 # 63e8 <malloc+0x214>
     428:	00006097          	auipc	ra,0x6
     42c:	cf4080e7          	jalr	-780(ra) # 611c <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00006097          	auipc	ra,0x6
     436:	972080e7          	jalr	-1678(ra) # 5da4 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	990080e7          	jalr	-1648(ra) # 5dcc <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	f9c50513          	add	a0,a0,-100 # 63e0 <malloc+0x20c>
     44c:	00006097          	auipc	ra,0x6
     450:	9b8080e7          	jalr	-1608(ra) # 5e04 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00006097          	auipc	ra,0x6
     45a:	94e080e7          	jalr	-1714(ra) # 5da4 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	add	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraw	a4,s1,0x1f
     482:	01b7571b          	srlw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraw	a3,a5,0x5
     48e:	0306869b          	addw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	and	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	add	a0,s0,-80
     4aa:	00006097          	auipc	ra,0x6
     4ae:	95a080e7          	jalr	-1702(ra) # 5e04 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	add	a0,s0,-80
     4ba:	00006097          	auipc	ra,0x6
     4be:	93a080e7          	jalr	-1734(ra) # 5df4 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00006097          	auipc	ra,0x6
     4ca:	906080e7          	jalr	-1786(ra) # 5dcc <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraw	a4,s1,0x1f
     4ea:	01b7571b          	srlw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraw	a3,a5,0x5
     4f6:	0306869b          	addw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	and	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	add	a0,s0,-80
     512:	00006097          	auipc	ra,0x6
     516:	8f2080e7          	jalr	-1806(ra) # 5e04 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	add	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	add	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	sll	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	ec0a0a13          	add	s4,s4,-320 # 6410 <malloc+0x23c>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00006097          	auipc	ra,0x6
     566:	892080e7          	jalr	-1902(ra) # 5df4 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00006097          	auipc	ra,0x6
     578:	850080e7          	jalr	-1968(ra) # 5dc4 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00006097          	auipc	ra,0x6
     586:	84a080e7          	jalr	-1974(ra) # 5dcc <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00006097          	auipc	ra,0x6
     590:	878080e7          	jalr	-1928(ra) # 5e04 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00006097          	auipc	ra,0x6
     59e:	82a080e7          	jalr	-2006(ra) # 5dc4 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	add	a0,s0,-72
     5aa:	00006097          	auipc	ra,0x6
     5ae:	80a080e7          	jalr	-2038(ra) # 5db4 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00006097          	auipc	ra,0x6
     5c2:	806080e7          	jalr	-2042(ra) # 5dc4 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	7fe080e7          	jalr	2046(ra) # 5dcc <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	7f2080e7          	jalr	2034(ra) # 5dcc <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	add	s2,s2,8
     5e4:	fd040793          	add	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	add	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	e1c50513          	add	a0,a0,-484 # 6418 <malloc+0x244>
     604:	00006097          	auipc	ra,0x6
     608:	b18080e7          	jalr	-1256(ra) # 611c <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	796080e7          	jalr	1942(ra) # 5da4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	e1650513          	add	a0,a0,-490 # 6430 <malloc+0x25c>
     622:	00006097          	auipc	ra,0x6
     626:	afa080e7          	jalr	-1286(ra) # 611c <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	778080e7          	jalr	1912(ra) # 5da4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	e2850513          	add	a0,a0,-472 # 6460 <malloc+0x28c>
     640:	00006097          	auipc	ra,0x6
     644:	adc080e7          	jalr	-1316(ra) # 611c <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	75a080e7          	jalr	1882(ra) # 5da4 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	e3e50513          	add	a0,a0,-450 # 6490 <malloc+0x2bc>
     65a:	00006097          	auipc	ra,0x6
     65e:	ac2080e7          	jalr	-1342(ra) # 611c <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	740080e7          	jalr	1856(ra) # 5da4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	e3050513          	add	a0,a0,-464 # 64a0 <malloc+0x2cc>
     678:	00006097          	auipc	ra,0x6
     67c:	aa4080e7          	jalr	-1372(ra) # 611c <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	722080e7          	jalr	1826(ra) # 5da4 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	add	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	sll	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	e22a0a13          	add	s4,s4,-478 # 64d0 <malloc+0x2fc>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	cb2a8a93          	add	s5,s5,-846 # 6368 <malloc+0x194>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	72e080e7          	jalr	1838(ra) # 5df4 <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	6e4080e7          	jalr	1764(ra) # 5dbc <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	6e6080e7          	jalr	1766(ra) # 5dcc <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	add	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	6c2080e7          	jalr	1730(ra) # 5db4 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	6be080e7          	jalr	1726(ra) # 5dc4 <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	6a0080e7          	jalr	1696(ra) # 5dbc <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	6a0080e7          	jalr	1696(ra) # 5dcc <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	694080e7          	jalr	1684(ra) # 5dcc <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	add	s2,s2,8
     742:	fc040793          	add	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	add	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	d7c50513          	add	a0,a0,-644 # 64d8 <malloc+0x304>
     764:	00006097          	auipc	ra,0x6
     768:	9b8080e7          	jalr	-1608(ra) # 611c <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	636080e7          	jalr	1590(ra) # 5da4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	d7650513          	add	a0,a0,-650 # 64f0 <malloc+0x31c>
     782:	00006097          	auipc	ra,0x6
     786:	99a080e7          	jalr	-1638(ra) # 611c <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	618080e7          	jalr	1560(ra) # 5da4 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	cfc50513          	add	a0,a0,-772 # 6490 <malloc+0x2bc>
     79c:	00006097          	auipc	ra,0x6
     7a0:	980080e7          	jalr	-1664(ra) # 611c <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	5fe080e7          	jalr	1534(ra) # 5da4 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	d7250513          	add	a0,a0,-654 # 6520 <malloc+0x34c>
     7b6:	00006097          	auipc	ra,0x6
     7ba:	966080e7          	jalr	-1690(ra) # 611c <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	5e4080e7          	jalr	1508(ra) # 5da4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	d6c50513          	add	a0,a0,-660 # 6538 <malloc+0x364>
     7d4:	00006097          	auipc	ra,0x6
     7d8:	948080e7          	jalr	-1720(ra) # 611c <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	5c6080e7          	jalr	1478(ra) # 5da4 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	add	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	add	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	b5650513          	add	a0,a0,-1194 # 6350 <malloc+0x17c>
     802:	00005097          	auipc	ra,0x5
     806:	602080e7          	jalr	1538(ra) # 5e04 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	b4250513          	add	a0,a0,-1214 # 6350 <malloc+0x17c>
     816:	00005097          	auipc	ra,0x5
     81a:	5de080e7          	jalr	1502(ra) # 5df4 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	b3e58593          	add	a1,a1,-1218 # 6360 <malloc+0x18c>
     82a:	00005097          	auipc	ra,0x5
     82e:	59a080e7          	jalr	1434(ra) # 5dc4 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	598080e7          	jalr	1432(ra) # 5dcc <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	b1250513          	add	a0,a0,-1262 # 6350 <malloc+0x17c>
     846:	00005097          	auipc	ra,0x5
     84a:	5ae080e7          	jalr	1454(ra) # 5df4 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	add	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	564080e7          	jalr	1380(ra) # 5dbc <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	ae650513          	add	a0,a0,-1306 # 6350 <malloc+0x17c>
     872:	00005097          	auipc	ra,0x5
     876:	582080e7          	jalr	1410(ra) # 5df4 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	ad250513          	add	a0,a0,-1326 # 6350 <malloc+0x17c>
     886:	00005097          	auipc	ra,0x5
     88a:	56e080e7          	jalr	1390(ra) # 5df4 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	add	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	524080e7          	jalr	1316(ra) # 5dbc <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	add	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	50e080e7          	jalr	1294(ra) # 5dbc <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	d0c58593          	add	a1,a1,-756 # 65c8 <malloc+0x3f4>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	4fe080e7          	jalr	1278(ra) # 5dc4 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	add	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	4e4080e7          	jalr	1252(ra) # 5dbc <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	add	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	4cc080e7          	jalr	1228(ra) # 5dbc <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	a5250513          	add	a0,a0,-1454 # 6350 <malloc+0x17c>
     906:	00005097          	auipc	ra,0x5
     90a:	4fe080e7          	jalr	1278(ra) # 5e04 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	4bc080e7          	jalr	1212(ra) # 5dcc <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	4b2080e7          	jalr	1202(ra) # 5dcc <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	4a8080e7          	jalr	1192(ra) # 5dcc <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	add	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	c2650513          	add	a0,a0,-986 # 6568 <malloc+0x394>
     94a:	00005097          	auipc	ra,0x5
     94e:	7d2080e7          	jalr	2002(ra) # 611c <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	450080e7          	jalr	1104(ra) # 5da4 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	c2a50513          	add	a0,a0,-982 # 6588 <malloc+0x3b4>
     966:	00005097          	auipc	ra,0x5
     96a:	7b6080e7          	jalr	1974(ra) # 611c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	c2650513          	add	a0,a0,-986 # 6598 <malloc+0x3c4>
     97a:	00005097          	auipc	ra,0x5
     97e:	7a2080e7          	jalr	1954(ra) # 611c <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	420080e7          	jalr	1056(ra) # 5da4 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	c2a50513          	add	a0,a0,-982 # 65b8 <malloc+0x3e4>
     996:	00005097          	auipc	ra,0x5
     99a:	786080e7          	jalr	1926(ra) # 611c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	bf650513          	add	a0,a0,-1034 # 6598 <malloc+0x3c4>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	772080e7          	jalr	1906(ra) # 611c <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	3f0080e7          	jalr	1008(ra) # 5da4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	c1050513          	add	a0,a0,-1008 # 65d0 <malloc+0x3fc>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	754080e7          	jalr	1876(ra) # 611c <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	3d2080e7          	jalr	978(ra) # 5da4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	c1250513          	add	a0,a0,-1006 # 65f0 <malloc+0x41c>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	736080e7          	jalr	1846(ra) # 611c <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	3b4080e7          	jalr	948(ra) # 5da4 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	add	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	add	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	bfe50513          	add	a0,a0,-1026 # 6610 <malloc+0x43c>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	3da080e7          	jalr	986(ra) # 5df4 <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	c0e98993          	add	s3,s3,-1010 # 6638 <malloc+0x464>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	c3ea8a93          	add	s5,s5,-962 # 6670 <malloc+0x49c>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	380080e7          	jalr	896(ra) # 5dc4 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	36c080e7          	jalr	876(ra) # 5dc4 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	35e080e7          	jalr	862(ra) # 5dcc <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	b9850513          	add	a0,a0,-1128 # 6610 <malloc+0x43c>
     a80:	00005097          	auipc	ra,0x5
     a84:	374080e7          	jalr	884(ra) # 5df4 <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	add	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	322080e7          	jalr	802(ra) # 5dbc <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	320080e7          	jalr	800(ra) # 5dcc <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	b5c50513          	add	a0,a0,-1188 # 6610 <malloc+0x43c>
     abc:	00005097          	auipc	ra,0x5
     ac0:	348080e7          	jalr	840(ra) # 5e04 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	add	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	b3a50513          	add	a0,a0,-1222 # 6618 <malloc+0x444>
     ae6:	00005097          	auipc	ra,0x5
     aea:	636080e7          	jalr	1590(ra) # 611c <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	2b4080e7          	jalr	692(ra) # 5da4 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	b4c50513          	add	a0,a0,-1204 # 6648 <malloc+0x474>
     b04:	00005097          	auipc	ra,0x5
     b08:	618080e7          	jalr	1560(ra) # 611c <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	296080e7          	jalr	662(ra) # 5da4 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	b6650513          	add	a0,a0,-1178 # 6680 <malloc+0x4ac>
     b22:	00005097          	auipc	ra,0x5
     b26:	5fa080e7          	jalr	1530(ra) # 611c <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	278080e7          	jalr	632(ra) # 5da4 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	b7250513          	add	a0,a0,-1166 # 66a8 <malloc+0x4d4>
     b3e:	00005097          	auipc	ra,0x5
     b42:	5de080e7          	jalr	1502(ra) # 611c <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	25c080e7          	jalr	604(ra) # 5da4 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	b7650513          	add	a0,a0,-1162 # 66c8 <malloc+0x4f4>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	5c2080e7          	jalr	1474(ra) # 611c <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	240080e7          	jalr	576(ra) # 5da4 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	b7250513          	add	a0,a0,-1166 # 66e0 <malloc+0x50c>
     b76:	00005097          	auipc	ra,0x5
     b7a:	5a6080e7          	jalr	1446(ra) # 611c <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	224080e7          	jalr	548(ra) # 5da4 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	add	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	add	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	b6050513          	add	a0,a0,-1184 # 6700 <malloc+0x52c>
     ba8:	00005097          	auipc	ra,0x5
     bac:	24c080e7          	jalr	588(ra) # 5df4 <open>
  if(fd < 0){
     bb0:	0a054063          	bltz	a0,c50 <writebig+0xc8>
     bb4:	89aa                	mv	s3,a0
  printf("(MAXFILE: %d )  ", MAXFILE);
     bb6:	65c1                	lui	a1,0x10
     bb8:	10b58593          	add	a1,a1,267 # 1010b <base+0x493>
     bbc:	00006517          	auipc	a0,0x6
     bc0:	b6c50513          	add	a0,a0,-1172 # 6728 <malloc+0x554>
     bc4:	00005097          	auipc	ra,0x5
     bc8:	558080e7          	jalr	1368(ra) # 611c <printf>
  for(i = 0; i < MAXFILE; i++){
     bcc:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bce:	0000c917          	auipc	s2,0xc
     bd2:	0aa90913          	add	s2,s2,170 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bd6:	6a41                	lui	s4,0x10
     bd8:	10ba0a13          	add	s4,s4,267 # 1010b <base+0x493>
    ((int*)buf)[0] = i;
     bdc:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     be0:	40000613          	li	a2,1024
     be4:	85ca                	mv	a1,s2
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	1dc080e7          	jalr	476(ra) # 5dc4 <write>
     bf0:	40000793          	li	a5,1024
     bf4:	06f51c63          	bne	a0,a5,c6c <writebig+0xe4>
  for(i = 0; i < MAXFILE; i++){
     bf8:	2485                	addw	s1,s1,1
     bfa:	ff4491e3          	bne	s1,s4,bdc <writebig+0x54>
  close(fd);
     bfe:	854e                	mv	a0,s3
     c00:	00005097          	auipc	ra,0x5
     c04:	1cc080e7          	jalr	460(ra) # 5dcc <close>
  fd = open("big", O_RDONLY);
     c08:	4581                	li	a1,0
     c0a:	00006517          	auipc	a0,0x6
     c0e:	af650513          	add	a0,a0,-1290 # 6700 <malloc+0x52c>
     c12:	00005097          	auipc	ra,0x5
     c16:	1e2080e7          	jalr	482(ra) # 5df4 <open>
     c1a:	89aa                	mv	s3,a0
  n = 0;
     c1c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c1e:	0000c917          	auipc	s2,0xc
     c22:	05a90913          	add	s2,s2,90 # cc78 <buf>
  if(fd < 0){
     c26:	06054263          	bltz	a0,c8a <writebig+0x102>
    i = read(fd, buf, BSIZE);
     c2a:	40000613          	li	a2,1024
     c2e:	85ca                	mv	a1,s2
     c30:	854e                	mv	a0,s3
     c32:	00005097          	auipc	ra,0x5
     c36:	18a080e7          	jalr	394(ra) # 5dbc <read>
    if(i == 0){
     c3a:	c535                	beqz	a0,ca6 <writebig+0x11e>
    } else if(i != BSIZE){
     c3c:	40000793          	li	a5,1024
     c40:	0af51f63          	bne	a0,a5,cfe <writebig+0x176>
    if(((int*)buf)[0] != n){
     c44:	00092683          	lw	a3,0(s2)
     c48:	0c969a63          	bne	a3,s1,d1c <writebig+0x194>
    n++;
     c4c:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c4e:	bff1                	j	c2a <writebig+0xa2>
    printf("%s: error: creat big failed!\n", s);
     c50:	85d6                	mv	a1,s5
     c52:	00006517          	auipc	a0,0x6
     c56:	ab650513          	add	a0,a0,-1354 # 6708 <malloc+0x534>
     c5a:	00005097          	auipc	ra,0x5
     c5e:	4c2080e7          	jalr	1218(ra) # 611c <printf>
    exit(1);
     c62:	4505                	li	a0,1
     c64:	00005097          	auipc	ra,0x5
     c68:	140080e7          	jalr	320(ra) # 5da4 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c6c:	8626                	mv	a2,s1
     c6e:	85d6                	mv	a1,s5
     c70:	00006517          	auipc	a0,0x6
     c74:	ad050513          	add	a0,a0,-1328 # 6740 <malloc+0x56c>
     c78:	00005097          	auipc	ra,0x5
     c7c:	4a4080e7          	jalr	1188(ra) # 611c <printf>
      exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	122080e7          	jalr	290(ra) # 5da4 <exit>
    printf("%s: error: open big failed!\n", s);
     c8a:	85d6                	mv	a1,s5
     c8c:	00006517          	auipc	a0,0x6
     c90:	adc50513          	add	a0,a0,-1316 # 6768 <malloc+0x594>
     c94:	00005097          	auipc	ra,0x5
     c98:	488080e7          	jalr	1160(ra) # 611c <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	106080e7          	jalr	262(ra) # 5da4 <exit>
      if(n == MAXFILE - 1){
     ca6:	67c1                	lui	a5,0x10
     ca8:	10a78793          	add	a5,a5,266 # 1010a <base+0x492>
     cac:	02f48a63          	beq	s1,a5,ce0 <writebig+0x158>
  close(fd);
     cb0:	854e                	mv	a0,s3
     cb2:	00005097          	auipc	ra,0x5
     cb6:	11a080e7          	jalr	282(ra) # 5dcc <close>
  if(unlink("big") < 0){
     cba:	00006517          	auipc	a0,0x6
     cbe:	a4650513          	add	a0,a0,-1466 # 6700 <malloc+0x52c>
     cc2:	00005097          	auipc	ra,0x5
     cc6:	142080e7          	jalr	322(ra) # 5e04 <unlink>
     cca:	06054863          	bltz	a0,d3a <writebig+0x1b2>
}
     cce:	70e2                	ld	ra,56(sp)
     cd0:	7442                	ld	s0,48(sp)
     cd2:	74a2                	ld	s1,40(sp)
     cd4:	7902                	ld	s2,32(sp)
     cd6:	69e2                	ld	s3,24(sp)
     cd8:	6a42                	ld	s4,16(sp)
     cda:	6aa2                	ld	s5,8(sp)
     cdc:	6121                	add	sp,sp,64
     cde:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ce0:	863e                	mv	a2,a5
     ce2:	85d6                	mv	a1,s5
     ce4:	00006517          	auipc	a0,0x6
     ce8:	aa450513          	add	a0,a0,-1372 # 6788 <malloc+0x5b4>
     cec:	00005097          	auipc	ra,0x5
     cf0:	430080e7          	jalr	1072(ra) # 611c <printf>
        exit(1);
     cf4:	4505                	li	a0,1
     cf6:	00005097          	auipc	ra,0x5
     cfa:	0ae080e7          	jalr	174(ra) # 5da4 <exit>
      printf("%s: read failed %d\n", s, i);
     cfe:	862a                	mv	a2,a0
     d00:	85d6                	mv	a1,s5
     d02:	00006517          	auipc	a0,0x6
     d06:	aae50513          	add	a0,a0,-1362 # 67b0 <malloc+0x5dc>
     d0a:	00005097          	auipc	ra,0x5
     d0e:	412080e7          	jalr	1042(ra) # 611c <printf>
      exit(1);
     d12:	4505                	li	a0,1
     d14:	00005097          	auipc	ra,0x5
     d18:	090080e7          	jalr	144(ra) # 5da4 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d1c:	8626                	mv	a2,s1
     d1e:	85d6                	mv	a1,s5
     d20:	00006517          	auipc	a0,0x6
     d24:	aa850513          	add	a0,a0,-1368 # 67c8 <malloc+0x5f4>
     d28:	00005097          	auipc	ra,0x5
     d2c:	3f4080e7          	jalr	1012(ra) # 611c <printf>
      exit(1);
     d30:	4505                	li	a0,1
     d32:	00005097          	auipc	ra,0x5
     d36:	072080e7          	jalr	114(ra) # 5da4 <exit>
    printf("%s: unlink big failed\n", s);
     d3a:	85d6                	mv	a1,s5
     d3c:	00006517          	auipc	a0,0x6
     d40:	ab450513          	add	a0,a0,-1356 # 67f0 <malloc+0x61c>
     d44:	00005097          	auipc	ra,0x5
     d48:	3d8080e7          	jalr	984(ra) # 611c <printf>
    exit(1);
     d4c:	4505                	li	a0,1
     d4e:	00005097          	auipc	ra,0x5
     d52:	056080e7          	jalr	86(ra) # 5da4 <exit>

0000000000000d56 <unlinkread>:
{
     d56:	7179                	add	sp,sp,-48
     d58:	f406                	sd	ra,40(sp)
     d5a:	f022                	sd	s0,32(sp)
     d5c:	ec26                	sd	s1,24(sp)
     d5e:	e84a                	sd	s2,16(sp)
     d60:	e44e                	sd	s3,8(sp)
     d62:	1800                	add	s0,sp,48
     d64:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d66:	20200593          	li	a1,514
     d6a:	00006517          	auipc	a0,0x6
     d6e:	a9e50513          	add	a0,a0,-1378 # 6808 <malloc+0x634>
     d72:	00005097          	auipc	ra,0x5
     d76:	082080e7          	jalr	130(ra) # 5df4 <open>
  if(fd < 0){
     d7a:	0e054563          	bltz	a0,e64 <unlinkread+0x10e>
     d7e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d80:	4615                	li	a2,5
     d82:	00006597          	auipc	a1,0x6
     d86:	ab658593          	add	a1,a1,-1354 # 6838 <malloc+0x664>
     d8a:	00005097          	auipc	ra,0x5
     d8e:	03a080e7          	jalr	58(ra) # 5dc4 <write>
  close(fd);
     d92:	8526                	mv	a0,s1
     d94:	00005097          	auipc	ra,0x5
     d98:	038080e7          	jalr	56(ra) # 5dcc <close>
  fd = open("unlinkread", O_RDWR);
     d9c:	4589                	li	a1,2
     d9e:	00006517          	auipc	a0,0x6
     da2:	a6a50513          	add	a0,a0,-1430 # 6808 <malloc+0x634>
     da6:	00005097          	auipc	ra,0x5
     daa:	04e080e7          	jalr	78(ra) # 5df4 <open>
     dae:	84aa                	mv	s1,a0
  if(fd < 0){
     db0:	0c054863          	bltz	a0,e80 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     db4:	00006517          	auipc	a0,0x6
     db8:	a5450513          	add	a0,a0,-1452 # 6808 <malloc+0x634>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	048080e7          	jalr	72(ra) # 5e04 <unlink>
     dc4:	ed61                	bnez	a0,e9c <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dc6:	20200593          	li	a1,514
     dca:	00006517          	auipc	a0,0x6
     dce:	a3e50513          	add	a0,a0,-1474 # 6808 <malloc+0x634>
     dd2:	00005097          	auipc	ra,0x5
     dd6:	022080e7          	jalr	34(ra) # 5df4 <open>
     dda:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     ddc:	460d                	li	a2,3
     dde:	00006597          	auipc	a1,0x6
     de2:	aa258593          	add	a1,a1,-1374 # 6880 <malloc+0x6ac>
     de6:	00005097          	auipc	ra,0x5
     dea:	fde080e7          	jalr	-34(ra) # 5dc4 <write>
  close(fd1);
     dee:	854a                	mv	a0,s2
     df0:	00005097          	auipc	ra,0x5
     df4:	fdc080e7          	jalr	-36(ra) # 5dcc <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     df8:	660d                	lui	a2,0x3
     dfa:	0000c597          	auipc	a1,0xc
     dfe:	e7e58593          	add	a1,a1,-386 # cc78 <buf>
     e02:	8526                	mv	a0,s1
     e04:	00005097          	auipc	ra,0x5
     e08:	fb8080e7          	jalr	-72(ra) # 5dbc <read>
     e0c:	4795                	li	a5,5
     e0e:	0af51563          	bne	a0,a5,eb8 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e12:	0000c717          	auipc	a4,0xc
     e16:	e6674703          	lbu	a4,-410(a4) # cc78 <buf>
     e1a:	06800793          	li	a5,104
     e1e:	0af71b63          	bne	a4,a5,ed4 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e22:	4629                	li	a2,10
     e24:	0000c597          	auipc	a1,0xc
     e28:	e5458593          	add	a1,a1,-428 # cc78 <buf>
     e2c:	8526                	mv	a0,s1
     e2e:	00005097          	auipc	ra,0x5
     e32:	f96080e7          	jalr	-106(ra) # 5dc4 <write>
     e36:	47a9                	li	a5,10
     e38:	0af51c63          	bne	a0,a5,ef0 <unlinkread+0x19a>
  close(fd);
     e3c:	8526                	mv	a0,s1
     e3e:	00005097          	auipc	ra,0x5
     e42:	f8e080e7          	jalr	-114(ra) # 5dcc <close>
  unlink("unlinkread");
     e46:	00006517          	auipc	a0,0x6
     e4a:	9c250513          	add	a0,a0,-1598 # 6808 <malloc+0x634>
     e4e:	00005097          	auipc	ra,0x5
     e52:	fb6080e7          	jalr	-74(ra) # 5e04 <unlink>
}
     e56:	70a2                	ld	ra,40(sp)
     e58:	7402                	ld	s0,32(sp)
     e5a:	64e2                	ld	s1,24(sp)
     e5c:	6942                	ld	s2,16(sp)
     e5e:	69a2                	ld	s3,8(sp)
     e60:	6145                	add	sp,sp,48
     e62:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e64:	85ce                	mv	a1,s3
     e66:	00006517          	auipc	a0,0x6
     e6a:	9b250513          	add	a0,a0,-1614 # 6818 <malloc+0x644>
     e6e:	00005097          	auipc	ra,0x5
     e72:	2ae080e7          	jalr	686(ra) # 611c <printf>
    exit(1);
     e76:	4505                	li	a0,1
     e78:	00005097          	auipc	ra,0x5
     e7c:	f2c080e7          	jalr	-212(ra) # 5da4 <exit>
    printf("%s: open unlinkread failed\n", s);
     e80:	85ce                	mv	a1,s3
     e82:	00006517          	auipc	a0,0x6
     e86:	9be50513          	add	a0,a0,-1602 # 6840 <malloc+0x66c>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	292080e7          	jalr	658(ra) # 611c <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00005097          	auipc	ra,0x5
     e98:	f10080e7          	jalr	-240(ra) # 5da4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e9c:	85ce                	mv	a1,s3
     e9e:	00006517          	auipc	a0,0x6
     ea2:	9c250513          	add	a0,a0,-1598 # 6860 <malloc+0x68c>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	276080e7          	jalr	630(ra) # 611c <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00005097          	auipc	ra,0x5
     eb4:	ef4080e7          	jalr	-268(ra) # 5da4 <exit>
    printf("%s: unlinkread read failed", s);
     eb8:	85ce                	mv	a1,s3
     eba:	00006517          	auipc	a0,0x6
     ebe:	9ce50513          	add	a0,a0,-1586 # 6888 <malloc+0x6b4>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	25a080e7          	jalr	602(ra) # 611c <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00005097          	auipc	ra,0x5
     ed0:	ed8080e7          	jalr	-296(ra) # 5da4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ed4:	85ce                	mv	a1,s3
     ed6:	00006517          	auipc	a0,0x6
     eda:	9d250513          	add	a0,a0,-1582 # 68a8 <malloc+0x6d4>
     ede:	00005097          	auipc	ra,0x5
     ee2:	23e080e7          	jalr	574(ra) # 611c <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00005097          	auipc	ra,0x5
     eec:	ebc080e7          	jalr	-324(ra) # 5da4 <exit>
    printf("%s: unlinkread write failed\n", s);
     ef0:	85ce                	mv	a1,s3
     ef2:	00006517          	auipc	a0,0x6
     ef6:	9d650513          	add	a0,a0,-1578 # 68c8 <malloc+0x6f4>
     efa:	00005097          	auipc	ra,0x5
     efe:	222080e7          	jalr	546(ra) # 611c <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00005097          	auipc	ra,0x5
     f08:	ea0080e7          	jalr	-352(ra) # 5da4 <exit>

0000000000000f0c <linktest>:
{
     f0c:	1101                	add	sp,sp,-32
     f0e:	ec06                	sd	ra,24(sp)
     f10:	e822                	sd	s0,16(sp)
     f12:	e426                	sd	s1,8(sp)
     f14:	e04a                	sd	s2,0(sp)
     f16:	1000                	add	s0,sp,32
     f18:	892a                	mv	s2,a0
  unlink("lf1");
     f1a:	00006517          	auipc	a0,0x6
     f1e:	9ce50513          	add	a0,a0,-1586 # 68e8 <malloc+0x714>
     f22:	00005097          	auipc	ra,0x5
     f26:	ee2080e7          	jalr	-286(ra) # 5e04 <unlink>
  unlink("lf2");
     f2a:	00006517          	auipc	a0,0x6
     f2e:	9c650513          	add	a0,a0,-1594 # 68f0 <malloc+0x71c>
     f32:	00005097          	auipc	ra,0x5
     f36:	ed2080e7          	jalr	-302(ra) # 5e04 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f3a:	20200593          	li	a1,514
     f3e:	00006517          	auipc	a0,0x6
     f42:	9aa50513          	add	a0,a0,-1622 # 68e8 <malloc+0x714>
     f46:	00005097          	auipc	ra,0x5
     f4a:	eae080e7          	jalr	-338(ra) # 5df4 <open>
  if(fd < 0){
     f4e:	10054763          	bltz	a0,105c <linktest+0x150>
     f52:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f54:	4615                	li	a2,5
     f56:	00006597          	auipc	a1,0x6
     f5a:	8e258593          	add	a1,a1,-1822 # 6838 <malloc+0x664>
     f5e:	00005097          	auipc	ra,0x5
     f62:	e66080e7          	jalr	-410(ra) # 5dc4 <write>
     f66:	4795                	li	a5,5
     f68:	10f51863          	bne	a0,a5,1078 <linktest+0x16c>
  close(fd);
     f6c:	8526                	mv	a0,s1
     f6e:	00005097          	auipc	ra,0x5
     f72:	e5e080e7          	jalr	-418(ra) # 5dcc <close>
  if(link("lf1", "lf2") < 0){
     f76:	00006597          	auipc	a1,0x6
     f7a:	97a58593          	add	a1,a1,-1670 # 68f0 <malloc+0x71c>
     f7e:	00006517          	auipc	a0,0x6
     f82:	96a50513          	add	a0,a0,-1686 # 68e8 <malloc+0x714>
     f86:	00005097          	auipc	ra,0x5
     f8a:	e8e080e7          	jalr	-370(ra) # 5e14 <link>
     f8e:	10054363          	bltz	a0,1094 <linktest+0x188>
  unlink("lf1");
     f92:	00006517          	auipc	a0,0x6
     f96:	95650513          	add	a0,a0,-1706 # 68e8 <malloc+0x714>
     f9a:	00005097          	auipc	ra,0x5
     f9e:	e6a080e7          	jalr	-406(ra) # 5e04 <unlink>
  if(open("lf1", 0) >= 0){
     fa2:	4581                	li	a1,0
     fa4:	00006517          	auipc	a0,0x6
     fa8:	94450513          	add	a0,a0,-1724 # 68e8 <malloc+0x714>
     fac:	00005097          	auipc	ra,0x5
     fb0:	e48080e7          	jalr	-440(ra) # 5df4 <open>
     fb4:	0e055e63          	bgez	a0,10b0 <linktest+0x1a4>
  fd = open("lf2", 0);
     fb8:	4581                	li	a1,0
     fba:	00006517          	auipc	a0,0x6
     fbe:	93650513          	add	a0,a0,-1738 # 68f0 <malloc+0x71c>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	e32080e7          	jalr	-462(ra) # 5df4 <open>
     fca:	84aa                	mv	s1,a0
  if(fd < 0){
     fcc:	10054063          	bltz	a0,10cc <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fd0:	660d                	lui	a2,0x3
     fd2:	0000c597          	auipc	a1,0xc
     fd6:	ca658593          	add	a1,a1,-858 # cc78 <buf>
     fda:	00005097          	auipc	ra,0x5
     fde:	de2080e7          	jalr	-542(ra) # 5dbc <read>
     fe2:	4795                	li	a5,5
     fe4:	10f51263          	bne	a0,a5,10e8 <linktest+0x1dc>
  close(fd);
     fe8:	8526                	mv	a0,s1
     fea:	00005097          	auipc	ra,0x5
     fee:	de2080e7          	jalr	-542(ra) # 5dcc <close>
  if(link("lf2", "lf2") >= 0){
     ff2:	00006597          	auipc	a1,0x6
     ff6:	8fe58593          	add	a1,a1,-1794 # 68f0 <malloc+0x71c>
     ffa:	852e                	mv	a0,a1
     ffc:	00005097          	auipc	ra,0x5
    1000:	e18080e7          	jalr	-488(ra) # 5e14 <link>
    1004:	10055063          	bgez	a0,1104 <linktest+0x1f8>
  unlink("lf2");
    1008:	00006517          	auipc	a0,0x6
    100c:	8e850513          	add	a0,a0,-1816 # 68f0 <malloc+0x71c>
    1010:	00005097          	auipc	ra,0x5
    1014:	df4080e7          	jalr	-524(ra) # 5e04 <unlink>
  if(link("lf2", "lf1") >= 0){
    1018:	00006597          	auipc	a1,0x6
    101c:	8d058593          	add	a1,a1,-1840 # 68e8 <malloc+0x714>
    1020:	00006517          	auipc	a0,0x6
    1024:	8d050513          	add	a0,a0,-1840 # 68f0 <malloc+0x71c>
    1028:	00005097          	auipc	ra,0x5
    102c:	dec080e7          	jalr	-532(ra) # 5e14 <link>
    1030:	0e055863          	bgez	a0,1120 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1034:	00006597          	auipc	a1,0x6
    1038:	8b458593          	add	a1,a1,-1868 # 68e8 <malloc+0x714>
    103c:	00006517          	auipc	a0,0x6
    1040:	9bc50513          	add	a0,a0,-1604 # 69f8 <malloc+0x824>
    1044:	00005097          	auipc	ra,0x5
    1048:	dd0080e7          	jalr	-560(ra) # 5e14 <link>
    104c:	0e055863          	bgez	a0,113c <linktest+0x230>
}
    1050:	60e2                	ld	ra,24(sp)
    1052:	6442                	ld	s0,16(sp)
    1054:	64a2                	ld	s1,8(sp)
    1056:	6902                	ld	s2,0(sp)
    1058:	6105                	add	sp,sp,32
    105a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    105c:	85ca                	mv	a1,s2
    105e:	00006517          	auipc	a0,0x6
    1062:	89a50513          	add	a0,a0,-1894 # 68f8 <malloc+0x724>
    1066:	00005097          	auipc	ra,0x5
    106a:	0b6080e7          	jalr	182(ra) # 611c <printf>
    exit(1);
    106e:	4505                	li	a0,1
    1070:	00005097          	auipc	ra,0x5
    1074:	d34080e7          	jalr	-716(ra) # 5da4 <exit>
    printf("%s: write lf1 failed\n", s);
    1078:	85ca                	mv	a1,s2
    107a:	00006517          	auipc	a0,0x6
    107e:	89650513          	add	a0,a0,-1898 # 6910 <malloc+0x73c>
    1082:	00005097          	auipc	ra,0x5
    1086:	09a080e7          	jalr	154(ra) # 611c <printf>
    exit(1);
    108a:	4505                	li	a0,1
    108c:	00005097          	auipc	ra,0x5
    1090:	d18080e7          	jalr	-744(ra) # 5da4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1094:	85ca                	mv	a1,s2
    1096:	00006517          	auipc	a0,0x6
    109a:	89250513          	add	a0,a0,-1902 # 6928 <malloc+0x754>
    109e:	00005097          	auipc	ra,0x5
    10a2:	07e080e7          	jalr	126(ra) # 611c <printf>
    exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00005097          	auipc	ra,0x5
    10ac:	cfc080e7          	jalr	-772(ra) # 5da4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10b0:	85ca                	mv	a1,s2
    10b2:	00006517          	auipc	a0,0x6
    10b6:	89650513          	add	a0,a0,-1898 # 6948 <malloc+0x774>
    10ba:	00005097          	auipc	ra,0x5
    10be:	062080e7          	jalr	98(ra) # 611c <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00005097          	auipc	ra,0x5
    10c8:	ce0080e7          	jalr	-800(ra) # 5da4 <exit>
    printf("%s: open lf2 failed\n", s);
    10cc:	85ca                	mv	a1,s2
    10ce:	00006517          	auipc	a0,0x6
    10d2:	8aa50513          	add	a0,a0,-1878 # 6978 <malloc+0x7a4>
    10d6:	00005097          	auipc	ra,0x5
    10da:	046080e7          	jalr	70(ra) # 611c <printf>
    exit(1);
    10de:	4505                	li	a0,1
    10e0:	00005097          	auipc	ra,0x5
    10e4:	cc4080e7          	jalr	-828(ra) # 5da4 <exit>
    printf("%s: read lf2 failed\n", s);
    10e8:	85ca                	mv	a1,s2
    10ea:	00006517          	auipc	a0,0x6
    10ee:	8a650513          	add	a0,a0,-1882 # 6990 <malloc+0x7bc>
    10f2:	00005097          	auipc	ra,0x5
    10f6:	02a080e7          	jalr	42(ra) # 611c <printf>
    exit(1);
    10fa:	4505                	li	a0,1
    10fc:	00005097          	auipc	ra,0x5
    1100:	ca8080e7          	jalr	-856(ra) # 5da4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1104:	85ca                	mv	a1,s2
    1106:	00006517          	auipc	a0,0x6
    110a:	8a250513          	add	a0,a0,-1886 # 69a8 <malloc+0x7d4>
    110e:	00005097          	auipc	ra,0x5
    1112:	00e080e7          	jalr	14(ra) # 611c <printf>
    exit(1);
    1116:	4505                	li	a0,1
    1118:	00005097          	auipc	ra,0x5
    111c:	c8c080e7          	jalr	-884(ra) # 5da4 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1120:	85ca                	mv	a1,s2
    1122:	00006517          	auipc	a0,0x6
    1126:	8ae50513          	add	a0,a0,-1874 # 69d0 <malloc+0x7fc>
    112a:	00005097          	auipc	ra,0x5
    112e:	ff2080e7          	jalr	-14(ra) # 611c <printf>
    exit(1);
    1132:	4505                	li	a0,1
    1134:	00005097          	auipc	ra,0x5
    1138:	c70080e7          	jalr	-912(ra) # 5da4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    113c:	85ca                	mv	a1,s2
    113e:	00006517          	auipc	a0,0x6
    1142:	8c250513          	add	a0,a0,-1854 # 6a00 <malloc+0x82c>
    1146:	00005097          	auipc	ra,0x5
    114a:	fd6080e7          	jalr	-42(ra) # 611c <printf>
    exit(1);
    114e:	4505                	li	a0,1
    1150:	00005097          	auipc	ra,0x5
    1154:	c54080e7          	jalr	-940(ra) # 5da4 <exit>

0000000000001158 <validatetest>:
{
    1158:	7139                	add	sp,sp,-64
    115a:	fc06                	sd	ra,56(sp)
    115c:	f822                	sd	s0,48(sp)
    115e:	f426                	sd	s1,40(sp)
    1160:	f04a                	sd	s2,32(sp)
    1162:	ec4e                	sd	s3,24(sp)
    1164:	e852                	sd	s4,16(sp)
    1166:	e456                	sd	s5,8(sp)
    1168:	e05a                	sd	s6,0(sp)
    116a:	0080                	add	s0,sp,64
    116c:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    116e:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1170:	00006997          	auipc	s3,0x6
    1174:	8b098993          	add	s3,s3,-1872 # 6a20 <malloc+0x84c>
    1178:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	6a85                	lui	s5,0x1
    117c:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1180:	85a6                	mv	a1,s1
    1182:	854e                	mv	a0,s3
    1184:	00005097          	auipc	ra,0x5
    1188:	c90080e7          	jalr	-880(ra) # 5e14 <link>
    118c:	01251f63          	bne	a0,s2,11aa <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1190:	94d6                	add	s1,s1,s5
    1192:	ff4497e3          	bne	s1,s4,1180 <validatetest+0x28>
}
    1196:	70e2                	ld	ra,56(sp)
    1198:	7442                	ld	s0,48(sp)
    119a:	74a2                	ld	s1,40(sp)
    119c:	7902                	ld	s2,32(sp)
    119e:	69e2                	ld	s3,24(sp)
    11a0:	6a42                	ld	s4,16(sp)
    11a2:	6aa2                	ld	s5,8(sp)
    11a4:	6b02                	ld	s6,0(sp)
    11a6:	6121                	add	sp,sp,64
    11a8:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11aa:	85da                	mv	a1,s6
    11ac:	00006517          	auipc	a0,0x6
    11b0:	88450513          	add	a0,a0,-1916 # 6a30 <malloc+0x85c>
    11b4:	00005097          	auipc	ra,0x5
    11b8:	f68080e7          	jalr	-152(ra) # 611c <printf>
      exit(1);
    11bc:	4505                	li	a0,1
    11be:	00005097          	auipc	ra,0x5
    11c2:	be6080e7          	jalr	-1050(ra) # 5da4 <exit>

00000000000011c6 <bigdir>:
{
    11c6:	715d                	add	sp,sp,-80
    11c8:	e486                	sd	ra,72(sp)
    11ca:	e0a2                	sd	s0,64(sp)
    11cc:	fc26                	sd	s1,56(sp)
    11ce:	f84a                	sd	s2,48(sp)
    11d0:	f44e                	sd	s3,40(sp)
    11d2:	f052                	sd	s4,32(sp)
    11d4:	ec56                	sd	s5,24(sp)
    11d6:	e85a                	sd	s6,16(sp)
    11d8:	0880                	add	s0,sp,80
    11da:	89aa                	mv	s3,a0
  unlink("bd");
    11dc:	00006517          	auipc	a0,0x6
    11e0:	87450513          	add	a0,a0,-1932 # 6a50 <malloc+0x87c>
    11e4:	00005097          	auipc	ra,0x5
    11e8:	c20080e7          	jalr	-992(ra) # 5e04 <unlink>
  fd = open("bd", O_CREATE);
    11ec:	20000593          	li	a1,512
    11f0:	00006517          	auipc	a0,0x6
    11f4:	86050513          	add	a0,a0,-1952 # 6a50 <malloc+0x87c>
    11f8:	00005097          	auipc	ra,0x5
    11fc:	bfc080e7          	jalr	-1028(ra) # 5df4 <open>
  if(fd < 0){
    1200:	0c054963          	bltz	a0,12d2 <bigdir+0x10c>
  close(fd);
    1204:	00005097          	auipc	ra,0x5
    1208:	bc8080e7          	jalr	-1080(ra) # 5dcc <close>
  for(i = 0; i < N; i++){
    120c:	4901                	li	s2,0
    name[0] = 'x';
    120e:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1212:	00006a17          	auipc	s4,0x6
    1216:	83ea0a13          	add	s4,s4,-1986 # 6a50 <malloc+0x87c>
  for(i = 0; i < N; i++){
    121a:	1f400b13          	li	s6,500
    name[0] = 'x';
    121e:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1222:	41f9571b          	sraw	a4,s2,0x1f
    1226:	01a7571b          	srlw	a4,a4,0x1a
    122a:	012707bb          	addw	a5,a4,s2
    122e:	4067d69b          	sraw	a3,a5,0x6
    1232:	0306869b          	addw	a3,a3,48
    1236:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    123a:	03f7f793          	and	a5,a5,63
    123e:	9f99                	subw	a5,a5,a4
    1240:	0307879b          	addw	a5,a5,48
    1244:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1248:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    124c:	fb040593          	add	a1,s0,-80
    1250:	8552                	mv	a0,s4
    1252:	00005097          	auipc	ra,0x5
    1256:	bc2080e7          	jalr	-1086(ra) # 5e14 <link>
    125a:	84aa                	mv	s1,a0
    125c:	e949                	bnez	a0,12ee <bigdir+0x128>
  for(i = 0; i < N; i++){
    125e:	2905                	addw	s2,s2,1
    1260:	fb691fe3          	bne	s2,s6,121e <bigdir+0x58>
  unlink("bd");
    1264:	00005517          	auipc	a0,0x5
    1268:	7ec50513          	add	a0,a0,2028 # 6a50 <malloc+0x87c>
    126c:	00005097          	auipc	ra,0x5
    1270:	b98080e7          	jalr	-1128(ra) # 5e04 <unlink>
    name[0] = 'x';
    1274:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1278:	1f400a13          	li	s4,500
    name[0] = 'x';
    127c:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1280:	41f4d71b          	sraw	a4,s1,0x1f
    1284:	01a7571b          	srlw	a4,a4,0x1a
    1288:	009707bb          	addw	a5,a4,s1
    128c:	4067d69b          	sraw	a3,a5,0x6
    1290:	0306869b          	addw	a3,a3,48
    1294:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1298:	03f7f793          	and	a5,a5,63
    129c:	9f99                	subw	a5,a5,a4
    129e:	0307879b          	addw	a5,a5,48
    12a2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    12a6:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    12aa:	fb040513          	add	a0,s0,-80
    12ae:	00005097          	auipc	ra,0x5
    12b2:	b56080e7          	jalr	-1194(ra) # 5e04 <unlink>
    12b6:	ed21                	bnez	a0,130e <bigdir+0x148>
  for(i = 0; i < N; i++){
    12b8:	2485                	addw	s1,s1,1
    12ba:	fd4491e3          	bne	s1,s4,127c <bigdir+0xb6>
}
    12be:	60a6                	ld	ra,72(sp)
    12c0:	6406                	ld	s0,64(sp)
    12c2:	74e2                	ld	s1,56(sp)
    12c4:	7942                	ld	s2,48(sp)
    12c6:	79a2                	ld	s3,40(sp)
    12c8:	7a02                	ld	s4,32(sp)
    12ca:	6ae2                	ld	s5,24(sp)
    12cc:	6b42                	ld	s6,16(sp)
    12ce:	6161                	add	sp,sp,80
    12d0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12d2:	85ce                	mv	a1,s3
    12d4:	00005517          	auipc	a0,0x5
    12d8:	78450513          	add	a0,a0,1924 # 6a58 <malloc+0x884>
    12dc:	00005097          	auipc	ra,0x5
    12e0:	e40080e7          	jalr	-448(ra) # 611c <printf>
    exit(1);
    12e4:	4505                	li	a0,1
    12e6:	00005097          	auipc	ra,0x5
    12ea:	abe080e7          	jalr	-1346(ra) # 5da4 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12ee:	fb040613          	add	a2,s0,-80
    12f2:	85ce                	mv	a1,s3
    12f4:	00005517          	auipc	a0,0x5
    12f8:	78450513          	add	a0,a0,1924 # 6a78 <malloc+0x8a4>
    12fc:	00005097          	auipc	ra,0x5
    1300:	e20080e7          	jalr	-480(ra) # 611c <printf>
      exit(1);
    1304:	4505                	li	a0,1
    1306:	00005097          	auipc	ra,0x5
    130a:	a9e080e7          	jalr	-1378(ra) # 5da4 <exit>
      printf("%s: bigdir unlink failed", s);
    130e:	85ce                	mv	a1,s3
    1310:	00005517          	auipc	a0,0x5
    1314:	78850513          	add	a0,a0,1928 # 6a98 <malloc+0x8c4>
    1318:	00005097          	auipc	ra,0x5
    131c:	e04080e7          	jalr	-508(ra) # 611c <printf>
      exit(1);
    1320:	4505                	li	a0,1
    1322:	00005097          	auipc	ra,0x5
    1326:	a82080e7          	jalr	-1406(ra) # 5da4 <exit>

000000000000132a <pgbug>:
{
    132a:	7179                	add	sp,sp,-48
    132c:	f406                	sd	ra,40(sp)
    132e:	f022                	sd	s0,32(sp)
    1330:	ec26                	sd	s1,24(sp)
    1332:	1800                	add	s0,sp,48
  argv[0] = 0;
    1334:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1338:	00008497          	auipc	s1,0x8
    133c:	cc848493          	add	s1,s1,-824 # 9000 <big>
    1340:	fd840593          	add	a1,s0,-40
    1344:	6088                	ld	a0,0(s1)
    1346:	00005097          	auipc	ra,0x5
    134a:	aa6080e7          	jalr	-1370(ra) # 5dec <exec>
  pipe(big);
    134e:	6088                	ld	a0,0(s1)
    1350:	00005097          	auipc	ra,0x5
    1354:	a64080e7          	jalr	-1436(ra) # 5db4 <pipe>
  exit(0);
    1358:	4501                	li	a0,0
    135a:	00005097          	auipc	ra,0x5
    135e:	a4a080e7          	jalr	-1462(ra) # 5da4 <exit>

0000000000001362 <badarg>:
{
    1362:	7139                	add	sp,sp,-64
    1364:	fc06                	sd	ra,56(sp)
    1366:	f822                	sd	s0,48(sp)
    1368:	f426                	sd	s1,40(sp)
    136a:	f04a                	sd	s2,32(sp)
    136c:	ec4e                	sd	s3,24(sp)
    136e:	0080                	add	s0,sp,64
    1370:	64b1                	lui	s1,0xc
    1372:	35048493          	add	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1376:	597d                	li	s2,-1
    1378:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    137c:	00005997          	auipc	s3,0x5
    1380:	f7c98993          	add	s3,s3,-132 # 62f8 <malloc+0x124>
    argv[0] = (char*)0xffffffff;
    1384:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1388:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    138c:	fc040593          	add	a1,s0,-64
    1390:	854e                	mv	a0,s3
    1392:	00005097          	auipc	ra,0x5
    1396:	a5a080e7          	jalr	-1446(ra) # 5dec <exec>
  for(int i = 0; i < 50000; i++){
    139a:	34fd                	addw	s1,s1,-1
    139c:	f4e5                	bnez	s1,1384 <badarg+0x22>
  exit(0);
    139e:	4501                	li	a0,0
    13a0:	00005097          	auipc	ra,0x5
    13a4:	a04080e7          	jalr	-1532(ra) # 5da4 <exit>

00000000000013a8 <copyinstr2>:
{
    13a8:	7155                	add	sp,sp,-208
    13aa:	e586                	sd	ra,200(sp)
    13ac:	e1a2                	sd	s0,192(sp)
    13ae:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    13b0:	f6840793          	add	a5,s0,-152
    13b4:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    13b8:	07800713          	li	a4,120
    13bc:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13c0:	0785                	add	a5,a5,1
    13c2:	fed79de3          	bne	a5,a3,13bc <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13c6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13ca:	f6840513          	add	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	a36080e7          	jalr	-1482(ra) # 5e04 <unlink>
  if(ret != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51063          	bne	a0,a5,14b8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13dc:	20100593          	li	a1,513
    13e0:	f6840513          	add	a0,s0,-152
    13e4:	00005097          	auipc	ra,0x5
    13e8:	a10080e7          	jalr	-1520(ra) # 5df4 <open>
  if(fd != -1){
    13ec:	57fd                	li	a5,-1
    13ee:	0ef51563          	bne	a0,a5,14d8 <copyinstr2+0x130>
  ret = link(b, b);
    13f2:	f6840593          	add	a1,s0,-152
    13f6:	852e                	mv	a0,a1
    13f8:	00005097          	auipc	ra,0x5
    13fc:	a1c080e7          	jalr	-1508(ra) # 5e14 <link>
  if(ret != -1){
    1400:	57fd                	li	a5,-1
    1402:	0ef51b63          	bne	a0,a5,14f8 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1406:	00007797          	auipc	a5,0x7
    140a:	8ea78793          	add	a5,a5,-1814 # 7cf0 <malloc+0x1b1c>
    140e:	f4f43c23          	sd	a5,-168(s0)
    1412:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1416:	f5840593          	add	a1,s0,-168
    141a:	f6840513          	add	a0,s0,-152
    141e:	00005097          	auipc	ra,0x5
    1422:	9ce080e7          	jalr	-1586(ra) # 5dec <exec>
  if(ret != -1){
    1426:	57fd                	li	a5,-1
    1428:	0ef51963          	bne	a0,a5,151a <copyinstr2+0x172>
  int pid = fork();
    142c:	00005097          	auipc	ra,0x5
    1430:	970080e7          	jalr	-1680(ra) # 5d9c <fork>
  if(pid < 0){
    1434:	10054363          	bltz	a0,153a <copyinstr2+0x192>
  if(pid == 0){
    1438:	12051463          	bnez	a0,1560 <copyinstr2+0x1b8>
    143c:	00008797          	auipc	a5,0x8
    1440:	12478793          	add	a5,a5,292 # 9560 <big.0>
    1444:	00009697          	auipc	a3,0x9
    1448:	11c68693          	add	a3,a3,284 # a560 <big.0+0x1000>
      big[i] = 'x';
    144c:	07800713          	li	a4,120
    1450:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1454:	0785                	add	a5,a5,1
    1456:	fed79de3          	bne	a5,a3,1450 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    145a:	00009797          	auipc	a5,0x9
    145e:	10078323          	sb	zero,262(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1462:	00007797          	auipc	a5,0x7
    1466:	2fe78793          	add	a5,a5,766 # 8760 <malloc+0x258c>
    146a:	6390                	ld	a2,0(a5)
    146c:	6794                	ld	a3,8(a5)
    146e:	6b98                	ld	a4,16(a5)
    1470:	6f9c                	ld	a5,24(a5)
    1472:	f2c43823          	sd	a2,-208(s0)
    1476:	f2d43c23          	sd	a3,-200(s0)
    147a:	f4e43023          	sd	a4,-192(s0)
    147e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1482:	f3040593          	add	a1,s0,-208
    1486:	00005517          	auipc	a0,0x5
    148a:	e7250513          	add	a0,a0,-398 # 62f8 <malloc+0x124>
    148e:	00005097          	auipc	ra,0x5
    1492:	95e080e7          	jalr	-1698(ra) # 5dec <exec>
    if(ret != -1){
    1496:	57fd                	li	a5,-1
    1498:	0af50e63          	beq	a0,a5,1554 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    149c:	55fd                	li	a1,-1
    149e:	00005517          	auipc	a0,0x5
    14a2:	6a250513          	add	a0,a0,1698 # 6b40 <malloc+0x96c>
    14a6:	00005097          	auipc	ra,0x5
    14aa:	c76080e7          	jalr	-906(ra) # 611c <printf>
      exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00005097          	auipc	ra,0x5
    14b4:	8f4080e7          	jalr	-1804(ra) # 5da4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14b8:	862a                	mv	a2,a0
    14ba:	f6840593          	add	a1,s0,-152
    14be:	00005517          	auipc	a0,0x5
    14c2:	5fa50513          	add	a0,a0,1530 # 6ab8 <malloc+0x8e4>
    14c6:	00005097          	auipc	ra,0x5
    14ca:	c56080e7          	jalr	-938(ra) # 611c <printf>
    exit(1);
    14ce:	4505                	li	a0,1
    14d0:	00005097          	auipc	ra,0x5
    14d4:	8d4080e7          	jalr	-1836(ra) # 5da4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14d8:	862a                	mv	a2,a0
    14da:	f6840593          	add	a1,s0,-152
    14de:	00005517          	auipc	a0,0x5
    14e2:	5fa50513          	add	a0,a0,1530 # 6ad8 <malloc+0x904>
    14e6:	00005097          	auipc	ra,0x5
    14ea:	c36080e7          	jalr	-970(ra) # 611c <printf>
    exit(1);
    14ee:	4505                	li	a0,1
    14f0:	00005097          	auipc	ra,0x5
    14f4:	8b4080e7          	jalr	-1868(ra) # 5da4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14f8:	86aa                	mv	a3,a0
    14fa:	f6840613          	add	a2,s0,-152
    14fe:	85b2                	mv	a1,a2
    1500:	00005517          	auipc	a0,0x5
    1504:	5f850513          	add	a0,a0,1528 # 6af8 <malloc+0x924>
    1508:	00005097          	auipc	ra,0x5
    150c:	c14080e7          	jalr	-1004(ra) # 611c <printf>
    exit(1);
    1510:	4505                	li	a0,1
    1512:	00005097          	auipc	ra,0x5
    1516:	892080e7          	jalr	-1902(ra) # 5da4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    151a:	567d                	li	a2,-1
    151c:	f6840593          	add	a1,s0,-152
    1520:	00005517          	auipc	a0,0x5
    1524:	60050513          	add	a0,a0,1536 # 6b20 <malloc+0x94c>
    1528:	00005097          	auipc	ra,0x5
    152c:	bf4080e7          	jalr	-1036(ra) # 611c <printf>
    exit(1);
    1530:	4505                	li	a0,1
    1532:	00005097          	auipc	ra,0x5
    1536:	872080e7          	jalr	-1934(ra) # 5da4 <exit>
    printf("fork failed\n");
    153a:	00006517          	auipc	a0,0x6
    153e:	a6650513          	add	a0,a0,-1434 # 6fa0 <malloc+0xdcc>
    1542:	00005097          	auipc	ra,0x5
    1546:	bda080e7          	jalr	-1062(ra) # 611c <printf>
    exit(1);
    154a:	4505                	li	a0,1
    154c:	00005097          	auipc	ra,0x5
    1550:	858080e7          	jalr	-1960(ra) # 5da4 <exit>
    exit(747); // OK
    1554:	2eb00513          	li	a0,747
    1558:	00005097          	auipc	ra,0x5
    155c:	84c080e7          	jalr	-1972(ra) # 5da4 <exit>
  int st = 0;
    1560:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1564:	f5440513          	add	a0,s0,-172
    1568:	00005097          	auipc	ra,0x5
    156c:	844080e7          	jalr	-1980(ra) # 5dac <wait>
  if(st != 747){
    1570:	f5442703          	lw	a4,-172(s0)
    1574:	2eb00793          	li	a5,747
    1578:	00f71663          	bne	a4,a5,1584 <copyinstr2+0x1dc>
}
    157c:	60ae                	ld	ra,200(sp)
    157e:	640e                	ld	s0,192(sp)
    1580:	6169                	add	sp,sp,208
    1582:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1584:	00005517          	auipc	a0,0x5
    1588:	5e450513          	add	a0,a0,1508 # 6b68 <malloc+0x994>
    158c:	00005097          	auipc	ra,0x5
    1590:	b90080e7          	jalr	-1136(ra) # 611c <printf>
    exit(1);
    1594:	4505                	li	a0,1
    1596:	00005097          	auipc	ra,0x5
    159a:	80e080e7          	jalr	-2034(ra) # 5da4 <exit>

000000000000159e <truncate3>:
{
    159e:	7159                	add	sp,sp,-112
    15a0:	f486                	sd	ra,104(sp)
    15a2:	f0a2                	sd	s0,96(sp)
    15a4:	eca6                	sd	s1,88(sp)
    15a6:	e8ca                	sd	s2,80(sp)
    15a8:	e4ce                	sd	s3,72(sp)
    15aa:	e0d2                	sd	s4,64(sp)
    15ac:	fc56                	sd	s5,56(sp)
    15ae:	1880                	add	s0,sp,112
    15b0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15b2:	60100593          	li	a1,1537
    15b6:	00005517          	auipc	a0,0x5
    15ba:	d9a50513          	add	a0,a0,-614 # 6350 <malloc+0x17c>
    15be:	00005097          	auipc	ra,0x5
    15c2:	836080e7          	jalr	-1994(ra) # 5df4 <open>
    15c6:	00005097          	auipc	ra,0x5
    15ca:	806080e7          	jalr	-2042(ra) # 5dcc <close>
  pid = fork();
    15ce:	00004097          	auipc	ra,0x4
    15d2:	7ce080e7          	jalr	1998(ra) # 5d9c <fork>
  if(pid < 0){
    15d6:	08054063          	bltz	a0,1656 <truncate3+0xb8>
  if(pid == 0){
    15da:	e969                	bnez	a0,16ac <truncate3+0x10e>
    15dc:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15e0:	00005a17          	auipc	s4,0x5
    15e4:	d70a0a13          	add	s4,s4,-656 # 6350 <malloc+0x17c>
      int n = write(fd, "1234567890", 10);
    15e8:	00005a97          	auipc	s5,0x5
    15ec:	5e0a8a93          	add	s5,s5,1504 # 6bc8 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15f0:	4585                	li	a1,1
    15f2:	8552                	mv	a0,s4
    15f4:	00005097          	auipc	ra,0x5
    15f8:	800080e7          	jalr	-2048(ra) # 5df4 <open>
    15fc:	84aa                	mv	s1,a0
      if(fd < 0){
    15fe:	06054a63          	bltz	a0,1672 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1602:	4629                	li	a2,10
    1604:	85d6                	mv	a1,s5
    1606:	00004097          	auipc	ra,0x4
    160a:	7be080e7          	jalr	1982(ra) # 5dc4 <write>
      if(n != 10){
    160e:	47a9                	li	a5,10
    1610:	06f51f63          	bne	a0,a5,168e <truncate3+0xf0>
      close(fd);
    1614:	8526                	mv	a0,s1
    1616:	00004097          	auipc	ra,0x4
    161a:	7b6080e7          	jalr	1974(ra) # 5dcc <close>
      fd = open("truncfile", O_RDONLY);
    161e:	4581                	li	a1,0
    1620:	8552                	mv	a0,s4
    1622:	00004097          	auipc	ra,0x4
    1626:	7d2080e7          	jalr	2002(ra) # 5df4 <open>
    162a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    162c:	02000613          	li	a2,32
    1630:	f9840593          	add	a1,s0,-104
    1634:	00004097          	auipc	ra,0x4
    1638:	788080e7          	jalr	1928(ra) # 5dbc <read>
      close(fd);
    163c:	8526                	mv	a0,s1
    163e:	00004097          	auipc	ra,0x4
    1642:	78e080e7          	jalr	1934(ra) # 5dcc <close>
    for(int i = 0; i < 100; i++){
    1646:	39fd                	addw	s3,s3,-1
    1648:	fa0994e3          	bnez	s3,15f0 <truncate3+0x52>
    exit(0);
    164c:	4501                	li	a0,0
    164e:	00004097          	auipc	ra,0x4
    1652:	756080e7          	jalr	1878(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    1656:	85ca                	mv	a1,s2
    1658:	00005517          	auipc	a0,0x5
    165c:	54050513          	add	a0,a0,1344 # 6b98 <malloc+0x9c4>
    1660:	00005097          	auipc	ra,0x5
    1664:	abc080e7          	jalr	-1348(ra) # 611c <printf>
    exit(1);
    1668:	4505                	li	a0,1
    166a:	00004097          	auipc	ra,0x4
    166e:	73a080e7          	jalr	1850(ra) # 5da4 <exit>
        printf("%s: open failed\n", s);
    1672:	85ca                	mv	a1,s2
    1674:	00005517          	auipc	a0,0x5
    1678:	53c50513          	add	a0,a0,1340 # 6bb0 <malloc+0x9dc>
    167c:	00005097          	auipc	ra,0x5
    1680:	aa0080e7          	jalr	-1376(ra) # 611c <printf>
        exit(1);
    1684:	4505                	li	a0,1
    1686:	00004097          	auipc	ra,0x4
    168a:	71e080e7          	jalr	1822(ra) # 5da4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    168e:	862a                	mv	a2,a0
    1690:	85ca                	mv	a1,s2
    1692:	00005517          	auipc	a0,0x5
    1696:	54650513          	add	a0,a0,1350 # 6bd8 <malloc+0xa04>
    169a:	00005097          	auipc	ra,0x5
    169e:	a82080e7          	jalr	-1406(ra) # 611c <printf>
        exit(1);
    16a2:	4505                	li	a0,1
    16a4:	00004097          	auipc	ra,0x4
    16a8:	700080e7          	jalr	1792(ra) # 5da4 <exit>
    16ac:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b0:	00005a17          	auipc	s4,0x5
    16b4:	ca0a0a13          	add	s4,s4,-864 # 6350 <malloc+0x17c>
    int n = write(fd, "xxx", 3);
    16b8:	00005a97          	auipc	s5,0x5
    16bc:	540a8a93          	add	s5,s5,1344 # 6bf8 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16c0:	60100593          	li	a1,1537
    16c4:	8552                	mv	a0,s4
    16c6:	00004097          	auipc	ra,0x4
    16ca:	72e080e7          	jalr	1838(ra) # 5df4 <open>
    16ce:	84aa                	mv	s1,a0
    if(fd < 0){
    16d0:	04054763          	bltz	a0,171e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16d4:	460d                	li	a2,3
    16d6:	85d6                	mv	a1,s5
    16d8:	00004097          	auipc	ra,0x4
    16dc:	6ec080e7          	jalr	1772(ra) # 5dc4 <write>
    if(n != 3){
    16e0:	478d                	li	a5,3
    16e2:	04f51c63          	bne	a0,a5,173a <truncate3+0x19c>
    close(fd);
    16e6:	8526                	mv	a0,s1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	6e4080e7          	jalr	1764(ra) # 5dcc <close>
  for(int i = 0; i < 150; i++){
    16f0:	39fd                	addw	s3,s3,-1
    16f2:	fc0997e3          	bnez	s3,16c0 <truncate3+0x122>
  wait(&xstatus);
    16f6:	fbc40513          	add	a0,s0,-68
    16fa:	00004097          	auipc	ra,0x4
    16fe:	6b2080e7          	jalr	1714(ra) # 5dac <wait>
  unlink("truncfile");
    1702:	00005517          	auipc	a0,0x5
    1706:	c4e50513          	add	a0,a0,-946 # 6350 <malloc+0x17c>
    170a:	00004097          	auipc	ra,0x4
    170e:	6fa080e7          	jalr	1786(ra) # 5e04 <unlink>
  exit(xstatus);
    1712:	fbc42503          	lw	a0,-68(s0)
    1716:	00004097          	auipc	ra,0x4
    171a:	68e080e7          	jalr	1678(ra) # 5da4 <exit>
      printf("%s: open failed\n", s);
    171e:	85ca                	mv	a1,s2
    1720:	00005517          	auipc	a0,0x5
    1724:	49050513          	add	a0,a0,1168 # 6bb0 <malloc+0x9dc>
    1728:	00005097          	auipc	ra,0x5
    172c:	9f4080e7          	jalr	-1548(ra) # 611c <printf>
      exit(1);
    1730:	4505                	li	a0,1
    1732:	00004097          	auipc	ra,0x4
    1736:	672080e7          	jalr	1650(ra) # 5da4 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    173a:	862a                	mv	a2,a0
    173c:	85ca                	mv	a1,s2
    173e:	00005517          	auipc	a0,0x5
    1742:	4c250513          	add	a0,a0,1218 # 6c00 <malloc+0xa2c>
    1746:	00005097          	auipc	ra,0x5
    174a:	9d6080e7          	jalr	-1578(ra) # 611c <printf>
      exit(1);
    174e:	4505                	li	a0,1
    1750:	00004097          	auipc	ra,0x4
    1754:	654080e7          	jalr	1620(ra) # 5da4 <exit>

0000000000001758 <exectest>:
{
    1758:	715d                	add	sp,sp,-80
    175a:	e486                	sd	ra,72(sp)
    175c:	e0a2                	sd	s0,64(sp)
    175e:	fc26                	sd	s1,56(sp)
    1760:	f84a                	sd	s2,48(sp)
    1762:	0880                	add	s0,sp,80
    1764:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1766:	00005797          	auipc	a5,0x5
    176a:	b9278793          	add	a5,a5,-1134 # 62f8 <malloc+0x124>
    176e:	fcf43023          	sd	a5,-64(s0)
    1772:	00005797          	auipc	a5,0x5
    1776:	4ae78793          	add	a5,a5,1198 # 6c20 <malloc+0xa4c>
    177a:	fcf43423          	sd	a5,-56(s0)
    177e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1782:	00005517          	auipc	a0,0x5
    1786:	4a650513          	add	a0,a0,1190 # 6c28 <malloc+0xa54>
    178a:	00004097          	auipc	ra,0x4
    178e:	67a080e7          	jalr	1658(ra) # 5e04 <unlink>
  pid = fork();
    1792:	00004097          	auipc	ra,0x4
    1796:	60a080e7          	jalr	1546(ra) # 5d9c <fork>
  if(pid < 0) {
    179a:	04054663          	bltz	a0,17e6 <exectest+0x8e>
    179e:	84aa                	mv	s1,a0
  if(pid == 0) {
    17a0:	e959                	bnez	a0,1836 <exectest+0xde>
    close(1);
    17a2:	4505                	li	a0,1
    17a4:	00004097          	auipc	ra,0x4
    17a8:	628080e7          	jalr	1576(ra) # 5dcc <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17ac:	20100593          	li	a1,513
    17b0:	00005517          	auipc	a0,0x5
    17b4:	47850513          	add	a0,a0,1144 # 6c28 <malloc+0xa54>
    17b8:	00004097          	auipc	ra,0x4
    17bc:	63c080e7          	jalr	1596(ra) # 5df4 <open>
    if(fd < 0) {
    17c0:	04054163          	bltz	a0,1802 <exectest+0xaa>
    if(fd != 1) {
    17c4:	4785                	li	a5,1
    17c6:	04f50c63          	beq	a0,a5,181e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17ca:	85ca                	mv	a1,s2
    17cc:	00005517          	auipc	a0,0x5
    17d0:	47c50513          	add	a0,a0,1148 # 6c48 <malloc+0xa74>
    17d4:	00005097          	auipc	ra,0x5
    17d8:	948080e7          	jalr	-1720(ra) # 611c <printf>
      exit(1);
    17dc:	4505                	li	a0,1
    17de:	00004097          	auipc	ra,0x4
    17e2:	5c6080e7          	jalr	1478(ra) # 5da4 <exit>
     printf("%s: fork failed\n", s);
    17e6:	85ca                	mv	a1,s2
    17e8:	00005517          	auipc	a0,0x5
    17ec:	3b050513          	add	a0,a0,944 # 6b98 <malloc+0x9c4>
    17f0:	00005097          	auipc	ra,0x5
    17f4:	92c080e7          	jalr	-1748(ra) # 611c <printf>
     exit(1);
    17f8:	4505                	li	a0,1
    17fa:	00004097          	auipc	ra,0x4
    17fe:	5aa080e7          	jalr	1450(ra) # 5da4 <exit>
      printf("%s: create failed\n", s);
    1802:	85ca                	mv	a1,s2
    1804:	00005517          	auipc	a0,0x5
    1808:	42c50513          	add	a0,a0,1068 # 6c30 <malloc+0xa5c>
    180c:	00005097          	auipc	ra,0x5
    1810:	910080e7          	jalr	-1776(ra) # 611c <printf>
      exit(1);
    1814:	4505                	li	a0,1
    1816:	00004097          	auipc	ra,0x4
    181a:	58e080e7          	jalr	1422(ra) # 5da4 <exit>
    if(exec("echo", echoargv) < 0){
    181e:	fc040593          	add	a1,s0,-64
    1822:	00005517          	auipc	a0,0x5
    1826:	ad650513          	add	a0,a0,-1322 # 62f8 <malloc+0x124>
    182a:	00004097          	auipc	ra,0x4
    182e:	5c2080e7          	jalr	1474(ra) # 5dec <exec>
    1832:	02054163          	bltz	a0,1854 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1836:	fdc40513          	add	a0,s0,-36
    183a:	00004097          	auipc	ra,0x4
    183e:	572080e7          	jalr	1394(ra) # 5dac <wait>
    1842:	02951763          	bne	a0,s1,1870 <exectest+0x118>
  if(xstatus != 0)
    1846:	fdc42503          	lw	a0,-36(s0)
    184a:	cd0d                	beqz	a0,1884 <exectest+0x12c>
    exit(xstatus);
    184c:	00004097          	auipc	ra,0x4
    1850:	558080e7          	jalr	1368(ra) # 5da4 <exit>
      printf("%s: exec echo failed\n", s);
    1854:	85ca                	mv	a1,s2
    1856:	00005517          	auipc	a0,0x5
    185a:	40250513          	add	a0,a0,1026 # 6c58 <malloc+0xa84>
    185e:	00005097          	auipc	ra,0x5
    1862:	8be080e7          	jalr	-1858(ra) # 611c <printf>
      exit(1);
    1866:	4505                	li	a0,1
    1868:	00004097          	auipc	ra,0x4
    186c:	53c080e7          	jalr	1340(ra) # 5da4 <exit>
    printf("%s: wait failed!\n", s);
    1870:	85ca                	mv	a1,s2
    1872:	00005517          	auipc	a0,0x5
    1876:	3fe50513          	add	a0,a0,1022 # 6c70 <malloc+0xa9c>
    187a:	00005097          	auipc	ra,0x5
    187e:	8a2080e7          	jalr	-1886(ra) # 611c <printf>
    1882:	b7d1                	j	1846 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1884:	4581                	li	a1,0
    1886:	00005517          	auipc	a0,0x5
    188a:	3a250513          	add	a0,a0,930 # 6c28 <malloc+0xa54>
    188e:	00004097          	auipc	ra,0x4
    1892:	566080e7          	jalr	1382(ra) # 5df4 <open>
  if(fd < 0) {
    1896:	02054a63          	bltz	a0,18ca <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    189a:	4609                	li	a2,2
    189c:	fb840593          	add	a1,s0,-72
    18a0:	00004097          	auipc	ra,0x4
    18a4:	51c080e7          	jalr	1308(ra) # 5dbc <read>
    18a8:	4789                	li	a5,2
    18aa:	02f50e63          	beq	a0,a5,18e6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18ae:	85ca                	mv	a1,s2
    18b0:	00005517          	auipc	a0,0x5
    18b4:	e1850513          	add	a0,a0,-488 # 66c8 <malloc+0x4f4>
    18b8:	00005097          	auipc	ra,0x5
    18bc:	864080e7          	jalr	-1948(ra) # 611c <printf>
    exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	4e2080e7          	jalr	1250(ra) # 5da4 <exit>
    printf("%s: open failed\n", s);
    18ca:	85ca                	mv	a1,s2
    18cc:	00005517          	auipc	a0,0x5
    18d0:	2e450513          	add	a0,a0,740 # 6bb0 <malloc+0x9dc>
    18d4:	00005097          	auipc	ra,0x5
    18d8:	848080e7          	jalr	-1976(ra) # 611c <printf>
    exit(1);
    18dc:	4505                	li	a0,1
    18de:	00004097          	auipc	ra,0x4
    18e2:	4c6080e7          	jalr	1222(ra) # 5da4 <exit>
  unlink("echo-ok");
    18e6:	00005517          	auipc	a0,0x5
    18ea:	34250513          	add	a0,a0,834 # 6c28 <malloc+0xa54>
    18ee:	00004097          	auipc	ra,0x4
    18f2:	516080e7          	jalr	1302(ra) # 5e04 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f6:	fb844703          	lbu	a4,-72(s0)
    18fa:	04f00793          	li	a5,79
    18fe:	00f71863          	bne	a4,a5,190e <exectest+0x1b6>
    1902:	fb944703          	lbu	a4,-71(s0)
    1906:	04b00793          	li	a5,75
    190a:	02f70063          	beq	a4,a5,192a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    190e:	85ca                	mv	a1,s2
    1910:	00005517          	auipc	a0,0x5
    1914:	37850513          	add	a0,a0,888 # 6c88 <malloc+0xab4>
    1918:	00005097          	auipc	ra,0x5
    191c:	804080e7          	jalr	-2044(ra) # 611c <printf>
    exit(1);
    1920:	4505                	li	a0,1
    1922:	00004097          	auipc	ra,0x4
    1926:	482080e7          	jalr	1154(ra) # 5da4 <exit>
    exit(0);
    192a:	4501                	li	a0,0
    192c:	00004097          	auipc	ra,0x4
    1930:	478080e7          	jalr	1144(ra) # 5da4 <exit>

0000000000001934 <pipe1>:
{
    1934:	711d                	add	sp,sp,-96
    1936:	ec86                	sd	ra,88(sp)
    1938:	e8a2                	sd	s0,80(sp)
    193a:	e4a6                	sd	s1,72(sp)
    193c:	e0ca                	sd	s2,64(sp)
    193e:	fc4e                	sd	s3,56(sp)
    1940:	f852                	sd	s4,48(sp)
    1942:	f456                	sd	s5,40(sp)
    1944:	f05a                	sd	s6,32(sp)
    1946:	ec5e                	sd	s7,24(sp)
    1948:	1080                	add	s0,sp,96
    194a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    194c:	fa840513          	add	a0,s0,-88
    1950:	00004097          	auipc	ra,0x4
    1954:	464080e7          	jalr	1124(ra) # 5db4 <pipe>
    1958:	e93d                	bnez	a0,19ce <pipe1+0x9a>
    195a:	84aa                	mv	s1,a0
  pid = fork();
    195c:	00004097          	auipc	ra,0x4
    1960:	440080e7          	jalr	1088(ra) # 5d9c <fork>
    1964:	8a2a                	mv	s4,a0
  if(pid == 0){
    1966:	c151                	beqz	a0,19ea <pipe1+0xb6>
  } else if(pid > 0){
    1968:	16a05d63          	blez	a0,1ae2 <pipe1+0x1ae>
    close(fds[1]);
    196c:	fac42503          	lw	a0,-84(s0)
    1970:	00004097          	auipc	ra,0x4
    1974:	45c080e7          	jalr	1116(ra) # 5dcc <close>
    total = 0;
    1978:	8a26                	mv	s4,s1
    cc = 1;
    197a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    197c:	0000ba97          	auipc	s5,0xb
    1980:	2fca8a93          	add	s5,s5,764 # cc78 <buf>
    1984:	864e                	mv	a2,s3
    1986:	85d6                	mv	a1,s5
    1988:	fa842503          	lw	a0,-88(s0)
    198c:	00004097          	auipc	ra,0x4
    1990:	430080e7          	jalr	1072(ra) # 5dbc <read>
    1994:	10a05263          	blez	a0,1a98 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1998:	0000b717          	auipc	a4,0xb
    199c:	2e070713          	add	a4,a4,736 # cc78 <buf>
    19a0:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19a4:	00074683          	lbu	a3,0(a4)
    19a8:	0ff4f793          	zext.b	a5,s1
    19ac:	2485                	addw	s1,s1,1
    19ae:	0cf69163          	bne	a3,a5,1a70 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    19b2:	0705                	add	a4,a4,1
    19b4:	fec498e3          	bne	s1,a2,19a4 <pipe1+0x70>
      total += n;
    19b8:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19bc:	0019979b          	sllw	a5,s3,0x1
    19c0:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19c4:	670d                	lui	a4,0x3
    19c6:	fb377fe3          	bgeu	a4,s3,1984 <pipe1+0x50>
        cc = sizeof(buf);
    19ca:	698d                	lui	s3,0x3
    19cc:	bf65                	j	1984 <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    19ce:	85ca                	mv	a1,s2
    19d0:	00005517          	auipc	a0,0x5
    19d4:	2d050513          	add	a0,a0,720 # 6ca0 <malloc+0xacc>
    19d8:	00004097          	auipc	ra,0x4
    19dc:	744080e7          	jalr	1860(ra) # 611c <printf>
    exit(1);
    19e0:	4505                	li	a0,1
    19e2:	00004097          	auipc	ra,0x4
    19e6:	3c2080e7          	jalr	962(ra) # 5da4 <exit>
    close(fds[0]);
    19ea:	fa842503          	lw	a0,-88(s0)
    19ee:	00004097          	auipc	ra,0x4
    19f2:	3de080e7          	jalr	990(ra) # 5dcc <close>
    for(n = 0; n < N; n++){
    19f6:	0000bb17          	auipc	s6,0xb
    19fa:	282b0b13          	add	s6,s6,642 # cc78 <buf>
    19fe:	416004bb          	negw	s1,s6
    1a02:	0ff4f493          	zext.b	s1,s1
    1a06:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a0a:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a0c:	6a85                	lui	s5,0x1
    1a0e:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x85>
{
    1a12:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a14:	0097873b          	addw	a4,a5,s1
    1a18:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a1c:	0785                	add	a5,a5,1
    1a1e:	fef99be3          	bne	s3,a5,1a14 <pipe1+0xe0>
        buf[i] = seq++;
    1a22:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a26:	40900613          	li	a2,1033
    1a2a:	85de                	mv	a1,s7
    1a2c:	fac42503          	lw	a0,-84(s0)
    1a30:	00004097          	auipc	ra,0x4
    1a34:	394080e7          	jalr	916(ra) # 5dc4 <write>
    1a38:	40900793          	li	a5,1033
    1a3c:	00f51c63          	bne	a0,a5,1a54 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a40:	24a5                	addw	s1,s1,9
    1a42:	0ff4f493          	zext.b	s1,s1
    1a46:	fd5a16e3          	bne	s4,s5,1a12 <pipe1+0xde>
    exit(0);
    1a4a:	4501                	li	a0,0
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	358080e7          	jalr	856(ra) # 5da4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a54:	85ca                	mv	a1,s2
    1a56:	00005517          	auipc	a0,0x5
    1a5a:	26250513          	add	a0,a0,610 # 6cb8 <malloc+0xae4>
    1a5e:	00004097          	auipc	ra,0x4
    1a62:	6be080e7          	jalr	1726(ra) # 611c <printf>
        exit(1);
    1a66:	4505                	li	a0,1
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	33c080e7          	jalr	828(ra) # 5da4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a70:	85ca                	mv	a1,s2
    1a72:	00005517          	auipc	a0,0x5
    1a76:	25e50513          	add	a0,a0,606 # 6cd0 <malloc+0xafc>
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	6a2080e7          	jalr	1698(ra) # 611c <printf>
}
    1a82:	60e6                	ld	ra,88(sp)
    1a84:	6446                	ld	s0,80(sp)
    1a86:	64a6                	ld	s1,72(sp)
    1a88:	6906                	ld	s2,64(sp)
    1a8a:	79e2                	ld	s3,56(sp)
    1a8c:	7a42                	ld	s4,48(sp)
    1a8e:	7aa2                	ld	s5,40(sp)
    1a90:	7b02                	ld	s6,32(sp)
    1a92:	6be2                	ld	s7,24(sp)
    1a94:	6125                	add	sp,sp,96
    1a96:	8082                	ret
    if(total != N * SZ){
    1a98:	6785                	lui	a5,0x1
    1a9a:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x85>
    1a9e:	02fa0063          	beq	s4,a5,1abe <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aa2:	85d2                	mv	a1,s4
    1aa4:	00005517          	auipc	a0,0x5
    1aa8:	24450513          	add	a0,a0,580 # 6ce8 <malloc+0xb14>
    1aac:	00004097          	auipc	ra,0x4
    1ab0:	670080e7          	jalr	1648(ra) # 611c <printf>
      exit(1);
    1ab4:	4505                	li	a0,1
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	2ee080e7          	jalr	750(ra) # 5da4 <exit>
    close(fds[0]);
    1abe:	fa842503          	lw	a0,-88(s0)
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	30a080e7          	jalr	778(ra) # 5dcc <close>
    wait(&xstatus);
    1aca:	fa440513          	add	a0,s0,-92
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	2de080e7          	jalr	734(ra) # 5dac <wait>
    exit(xstatus);
    1ad6:	fa442503          	lw	a0,-92(s0)
    1ada:	00004097          	auipc	ra,0x4
    1ade:	2ca080e7          	jalr	714(ra) # 5da4 <exit>
    printf("%s: fork() failed\n", s);
    1ae2:	85ca                	mv	a1,s2
    1ae4:	00005517          	auipc	a0,0x5
    1ae8:	22450513          	add	a0,a0,548 # 6d08 <malloc+0xb34>
    1aec:	00004097          	auipc	ra,0x4
    1af0:	630080e7          	jalr	1584(ra) # 611c <printf>
    exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	2ae080e7          	jalr	686(ra) # 5da4 <exit>

0000000000001afe <exitwait>:
{
    1afe:	7139                	add	sp,sp,-64
    1b00:	fc06                	sd	ra,56(sp)
    1b02:	f822                	sd	s0,48(sp)
    1b04:	f426                	sd	s1,40(sp)
    1b06:	f04a                	sd	s2,32(sp)
    1b08:	ec4e                	sd	s3,24(sp)
    1b0a:	e852                	sd	s4,16(sp)
    1b0c:	0080                	add	s0,sp,64
    1b0e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b10:	4901                	li	s2,0
    1b12:	06400993          	li	s3,100
    pid = fork();
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	286080e7          	jalr	646(ra) # 5d9c <fork>
    1b1e:	84aa                	mv	s1,a0
    if(pid < 0){
    1b20:	02054a63          	bltz	a0,1b54 <exitwait+0x56>
    if(pid){
    1b24:	c151                	beqz	a0,1ba8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b26:	fcc40513          	add	a0,s0,-52
    1b2a:	00004097          	auipc	ra,0x4
    1b2e:	282080e7          	jalr	642(ra) # 5dac <wait>
    1b32:	02951f63          	bne	a0,s1,1b70 <exitwait+0x72>
      if(i != xstate) {
    1b36:	fcc42783          	lw	a5,-52(s0)
    1b3a:	05279963          	bne	a5,s2,1b8c <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b3e:	2905                	addw	s2,s2,1
    1b40:	fd391be3          	bne	s2,s3,1b16 <exitwait+0x18>
}
    1b44:	70e2                	ld	ra,56(sp)
    1b46:	7442                	ld	s0,48(sp)
    1b48:	74a2                	ld	s1,40(sp)
    1b4a:	7902                	ld	s2,32(sp)
    1b4c:	69e2                	ld	s3,24(sp)
    1b4e:	6a42                	ld	s4,16(sp)
    1b50:	6121                	add	sp,sp,64
    1b52:	8082                	ret
      printf("%s: fork failed\n", s);
    1b54:	85d2                	mv	a1,s4
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	04250513          	add	a0,a0,66 # 6b98 <malloc+0x9c4>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	5be080e7          	jalr	1470(ra) # 611c <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	23c080e7          	jalr	572(ra) # 5da4 <exit>
        printf("%s: wait wrong pid\n", s);
    1b70:	85d2                	mv	a1,s4
    1b72:	00005517          	auipc	a0,0x5
    1b76:	1ae50513          	add	a0,a0,430 # 6d20 <malloc+0xb4c>
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	5a2080e7          	jalr	1442(ra) # 611c <printf>
        exit(1);
    1b82:	4505                	li	a0,1
    1b84:	00004097          	auipc	ra,0x4
    1b88:	220080e7          	jalr	544(ra) # 5da4 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b8c:	85d2                	mv	a1,s4
    1b8e:	00005517          	auipc	a0,0x5
    1b92:	1aa50513          	add	a0,a0,426 # 6d38 <malloc+0xb64>
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	586080e7          	jalr	1414(ra) # 611c <printf>
        exit(1);
    1b9e:	4505                	li	a0,1
    1ba0:	00004097          	auipc	ra,0x4
    1ba4:	204080e7          	jalr	516(ra) # 5da4 <exit>
      exit(i);
    1ba8:	854a                	mv	a0,s2
    1baa:	00004097          	auipc	ra,0x4
    1bae:	1fa080e7          	jalr	506(ra) # 5da4 <exit>

0000000000001bb2 <twochildren>:
{
    1bb2:	1101                	add	sp,sp,-32
    1bb4:	ec06                	sd	ra,24(sp)
    1bb6:	e822                	sd	s0,16(sp)
    1bb8:	e426                	sd	s1,8(sp)
    1bba:	e04a                	sd	s2,0(sp)
    1bbc:	1000                	add	s0,sp,32
    1bbe:	892a                	mv	s2,a0
    1bc0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bc4:	00004097          	auipc	ra,0x4
    1bc8:	1d8080e7          	jalr	472(ra) # 5d9c <fork>
    if(pid1 < 0){
    1bcc:	02054c63          	bltz	a0,1c04 <twochildren+0x52>
    if(pid1 == 0){
    1bd0:	c921                	beqz	a0,1c20 <twochildren+0x6e>
      int pid2 = fork();
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	1ca080e7          	jalr	458(ra) # 5d9c <fork>
      if(pid2 < 0){
    1bda:	04054763          	bltz	a0,1c28 <twochildren+0x76>
      if(pid2 == 0){
    1bde:	c13d                	beqz	a0,1c44 <twochildren+0x92>
        wait(0);
    1be0:	4501                	li	a0,0
    1be2:	00004097          	auipc	ra,0x4
    1be6:	1ca080e7          	jalr	458(ra) # 5dac <wait>
        wait(0);
    1bea:	4501                	li	a0,0
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	1c0080e7          	jalr	448(ra) # 5dac <wait>
  for(int i = 0; i < 1000; i++){
    1bf4:	34fd                	addw	s1,s1,-1
    1bf6:	f4f9                	bnez	s1,1bc4 <twochildren+0x12>
}
    1bf8:	60e2                	ld	ra,24(sp)
    1bfa:	6442                	ld	s0,16(sp)
    1bfc:	64a2                	ld	s1,8(sp)
    1bfe:	6902                	ld	s2,0(sp)
    1c00:	6105                	add	sp,sp,32
    1c02:	8082                	ret
      printf("%s: fork failed\n", s);
    1c04:	85ca                	mv	a1,s2
    1c06:	00005517          	auipc	a0,0x5
    1c0a:	f9250513          	add	a0,a0,-110 # 6b98 <malloc+0x9c4>
    1c0e:	00004097          	auipc	ra,0x4
    1c12:	50e080e7          	jalr	1294(ra) # 611c <printf>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	00004097          	auipc	ra,0x4
    1c1c:	18c080e7          	jalr	396(ra) # 5da4 <exit>
      exit(0);
    1c20:	00004097          	auipc	ra,0x4
    1c24:	184080e7          	jalr	388(ra) # 5da4 <exit>
        printf("%s: fork failed\n", s);
    1c28:	85ca                	mv	a1,s2
    1c2a:	00005517          	auipc	a0,0x5
    1c2e:	f6e50513          	add	a0,a0,-146 # 6b98 <malloc+0x9c4>
    1c32:	00004097          	auipc	ra,0x4
    1c36:	4ea080e7          	jalr	1258(ra) # 611c <printf>
        exit(1);
    1c3a:	4505                	li	a0,1
    1c3c:	00004097          	auipc	ra,0x4
    1c40:	168080e7          	jalr	360(ra) # 5da4 <exit>
        exit(0);
    1c44:	00004097          	auipc	ra,0x4
    1c48:	160080e7          	jalr	352(ra) # 5da4 <exit>

0000000000001c4c <forkfork>:
{
    1c4c:	7179                	add	sp,sp,-48
    1c4e:	f406                	sd	ra,40(sp)
    1c50:	f022                	sd	s0,32(sp)
    1c52:	ec26                	sd	s1,24(sp)
    1c54:	1800                	add	s0,sp,48
    1c56:	84aa                	mv	s1,a0
    int pid = fork();
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	144080e7          	jalr	324(ra) # 5d9c <fork>
    if(pid < 0){
    1c60:	04054163          	bltz	a0,1ca2 <forkfork+0x56>
    if(pid == 0){
    1c64:	cd29                	beqz	a0,1cbe <forkfork+0x72>
    int pid = fork();
    1c66:	00004097          	auipc	ra,0x4
    1c6a:	136080e7          	jalr	310(ra) # 5d9c <fork>
    if(pid < 0){
    1c6e:	02054a63          	bltz	a0,1ca2 <forkfork+0x56>
    if(pid == 0){
    1c72:	c531                	beqz	a0,1cbe <forkfork+0x72>
    wait(&xstatus);
    1c74:	fdc40513          	add	a0,s0,-36
    1c78:	00004097          	auipc	ra,0x4
    1c7c:	134080e7          	jalr	308(ra) # 5dac <wait>
    if(xstatus != 0) {
    1c80:	fdc42783          	lw	a5,-36(s0)
    1c84:	ebbd                	bnez	a5,1cfa <forkfork+0xae>
    wait(&xstatus);
    1c86:	fdc40513          	add	a0,s0,-36
    1c8a:	00004097          	auipc	ra,0x4
    1c8e:	122080e7          	jalr	290(ra) # 5dac <wait>
    if(xstatus != 0) {
    1c92:	fdc42783          	lw	a5,-36(s0)
    1c96:	e3b5                	bnez	a5,1cfa <forkfork+0xae>
}
    1c98:	70a2                	ld	ra,40(sp)
    1c9a:	7402                	ld	s0,32(sp)
    1c9c:	64e2                	ld	s1,24(sp)
    1c9e:	6145                	add	sp,sp,48
    1ca0:	8082                	ret
      printf("%s: fork failed", s);
    1ca2:	85a6                	mv	a1,s1
    1ca4:	00005517          	auipc	a0,0x5
    1ca8:	0b450513          	add	a0,a0,180 # 6d58 <malloc+0xb84>
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	470080e7          	jalr	1136(ra) # 611c <printf>
      exit(1);
    1cb4:	4505                	li	a0,1
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	0ee080e7          	jalr	238(ra) # 5da4 <exit>
{
    1cbe:	0c800493          	li	s1,200
        int pid1 = fork();
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	0da080e7          	jalr	218(ra) # 5d9c <fork>
        if(pid1 < 0){
    1cca:	00054f63          	bltz	a0,1ce8 <forkfork+0x9c>
        if(pid1 == 0){
    1cce:	c115                	beqz	a0,1cf2 <forkfork+0xa6>
        wait(0);
    1cd0:	4501                	li	a0,0
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	0da080e7          	jalr	218(ra) # 5dac <wait>
      for(int j = 0; j < 200; j++){
    1cda:	34fd                	addw	s1,s1,-1
    1cdc:	f0fd                	bnez	s1,1cc2 <forkfork+0x76>
      exit(0);
    1cde:	4501                	li	a0,0
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	0c4080e7          	jalr	196(ra) # 5da4 <exit>
          exit(1);
    1ce8:	4505                	li	a0,1
    1cea:	00004097          	auipc	ra,0x4
    1cee:	0ba080e7          	jalr	186(ra) # 5da4 <exit>
          exit(0);
    1cf2:	00004097          	auipc	ra,0x4
    1cf6:	0b2080e7          	jalr	178(ra) # 5da4 <exit>
      printf("%s: fork in child failed", s);
    1cfa:	85a6                	mv	a1,s1
    1cfc:	00005517          	auipc	a0,0x5
    1d00:	06c50513          	add	a0,a0,108 # 6d68 <malloc+0xb94>
    1d04:	00004097          	auipc	ra,0x4
    1d08:	418080e7          	jalr	1048(ra) # 611c <printf>
      exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	096080e7          	jalr	150(ra) # 5da4 <exit>

0000000000001d16 <reparent2>:
{
    1d16:	1101                	add	sp,sp,-32
    1d18:	ec06                	sd	ra,24(sp)
    1d1a:	e822                	sd	s0,16(sp)
    1d1c:	e426                	sd	s1,8(sp)
    1d1e:	1000                	add	s0,sp,32
    1d20:	32000493          	li	s1,800
    int pid1 = fork();
    1d24:	00004097          	auipc	ra,0x4
    1d28:	078080e7          	jalr	120(ra) # 5d9c <fork>
    if(pid1 < 0){
    1d2c:	00054f63          	bltz	a0,1d4a <reparent2+0x34>
    if(pid1 == 0){
    1d30:	c915                	beqz	a0,1d64 <reparent2+0x4e>
    wait(0);
    1d32:	4501                	li	a0,0
    1d34:	00004097          	auipc	ra,0x4
    1d38:	078080e7          	jalr	120(ra) # 5dac <wait>
  for(int i = 0; i < 800; i++){
    1d3c:	34fd                	addw	s1,s1,-1
    1d3e:	f0fd                	bnez	s1,1d24 <reparent2+0xe>
  exit(0);
    1d40:	4501                	li	a0,0
    1d42:	00004097          	auipc	ra,0x4
    1d46:	062080e7          	jalr	98(ra) # 5da4 <exit>
      printf("fork failed\n");
    1d4a:	00005517          	auipc	a0,0x5
    1d4e:	25650513          	add	a0,a0,598 # 6fa0 <malloc+0xdcc>
    1d52:	00004097          	auipc	ra,0x4
    1d56:	3ca080e7          	jalr	970(ra) # 611c <printf>
      exit(1);
    1d5a:	4505                	li	a0,1
    1d5c:	00004097          	auipc	ra,0x4
    1d60:	048080e7          	jalr	72(ra) # 5da4 <exit>
      fork();
    1d64:	00004097          	auipc	ra,0x4
    1d68:	038080e7          	jalr	56(ra) # 5d9c <fork>
      fork();
    1d6c:	00004097          	auipc	ra,0x4
    1d70:	030080e7          	jalr	48(ra) # 5d9c <fork>
      exit(0);
    1d74:	4501                	li	a0,0
    1d76:	00004097          	auipc	ra,0x4
    1d7a:	02e080e7          	jalr	46(ra) # 5da4 <exit>

0000000000001d7e <createdelete>:
{
    1d7e:	7175                	add	sp,sp,-144
    1d80:	e506                	sd	ra,136(sp)
    1d82:	e122                	sd	s0,128(sp)
    1d84:	fca6                	sd	s1,120(sp)
    1d86:	f8ca                	sd	s2,112(sp)
    1d88:	f4ce                	sd	s3,104(sp)
    1d8a:	f0d2                	sd	s4,96(sp)
    1d8c:	ecd6                	sd	s5,88(sp)
    1d8e:	e8da                	sd	s6,80(sp)
    1d90:	e4de                	sd	s7,72(sp)
    1d92:	e0e2                	sd	s8,64(sp)
    1d94:	fc66                	sd	s9,56(sp)
    1d96:	0900                	add	s0,sp,144
    1d98:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d9a:	4901                	li	s2,0
    1d9c:	4991                	li	s3,4
    pid = fork();
    1d9e:	00004097          	auipc	ra,0x4
    1da2:	ffe080e7          	jalr	-2(ra) # 5d9c <fork>
    1da6:	84aa                	mv	s1,a0
    if(pid < 0){
    1da8:	02054f63          	bltz	a0,1de6 <createdelete+0x68>
    if(pid == 0){
    1dac:	c939                	beqz	a0,1e02 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dae:	2905                	addw	s2,s2,1
    1db0:	ff3917e3          	bne	s2,s3,1d9e <createdelete+0x20>
    1db4:	4491                	li	s1,4
    wait(&xstatus);
    1db6:	f7c40513          	add	a0,s0,-132
    1dba:	00004097          	auipc	ra,0x4
    1dbe:	ff2080e7          	jalr	-14(ra) # 5dac <wait>
    if(xstatus != 0)
    1dc2:	f7c42903          	lw	s2,-132(s0)
    1dc6:	0e091263          	bnez	s2,1eaa <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1dca:	34fd                	addw	s1,s1,-1
    1dcc:	f4ed                	bnez	s1,1db6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dce:	f8040123          	sb	zero,-126(s0)
    1dd2:	03000993          	li	s3,48
    1dd6:	5a7d                	li	s4,-1
    1dd8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ddc:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dde:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1de0:	07400a93          	li	s5,116
    1de4:	a29d                	j	1f4a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1de6:	85e6                	mv	a1,s9
    1de8:	00005517          	auipc	a0,0x5
    1dec:	1b850513          	add	a0,a0,440 # 6fa0 <malloc+0xdcc>
    1df0:	00004097          	auipc	ra,0x4
    1df4:	32c080e7          	jalr	812(ra) # 611c <printf>
      exit(1);
    1df8:	4505                	li	a0,1
    1dfa:	00004097          	auipc	ra,0x4
    1dfe:	faa080e7          	jalr	-86(ra) # 5da4 <exit>
      name[0] = 'p' + pi;
    1e02:	0709091b          	addw	s2,s2,112
    1e06:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e0a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e0e:	4951                	li	s2,20
    1e10:	a015                	j	1e34 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e12:	85e6                	mv	a1,s9
    1e14:	00005517          	auipc	a0,0x5
    1e18:	e1c50513          	add	a0,a0,-484 # 6c30 <malloc+0xa5c>
    1e1c:	00004097          	auipc	ra,0x4
    1e20:	300080e7          	jalr	768(ra) # 611c <printf>
          exit(1);
    1e24:	4505                	li	a0,1
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	f7e080e7          	jalr	-130(ra) # 5da4 <exit>
      for(i = 0; i < N; i++){
    1e2e:	2485                	addw	s1,s1,1
    1e30:	07248863          	beq	s1,s2,1ea0 <createdelete+0x122>
        name[1] = '0' + i;
    1e34:	0304879b          	addw	a5,s1,48
    1e38:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e3c:	20200593          	li	a1,514
    1e40:	f8040513          	add	a0,s0,-128
    1e44:	00004097          	auipc	ra,0x4
    1e48:	fb0080e7          	jalr	-80(ra) # 5df4 <open>
        if(fd < 0){
    1e4c:	fc0543e3          	bltz	a0,1e12 <createdelete+0x94>
        close(fd);
    1e50:	00004097          	auipc	ra,0x4
    1e54:	f7c080e7          	jalr	-132(ra) # 5dcc <close>
        if(i > 0 && (i % 2 ) == 0){
    1e58:	fc905be3          	blez	s1,1e2e <createdelete+0xb0>
    1e5c:	0014f793          	and	a5,s1,1
    1e60:	f7f9                	bnez	a5,1e2e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e62:	01f4d79b          	srlw	a5,s1,0x1f
    1e66:	9fa5                	addw	a5,a5,s1
    1e68:	4017d79b          	sraw	a5,a5,0x1
    1e6c:	0307879b          	addw	a5,a5,48
    1e70:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e74:	f8040513          	add	a0,s0,-128
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	f8c080e7          	jalr	-116(ra) # 5e04 <unlink>
    1e80:	fa0557e3          	bgez	a0,1e2e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e84:	85e6                	mv	a1,s9
    1e86:	00005517          	auipc	a0,0x5
    1e8a:	f0250513          	add	a0,a0,-254 # 6d88 <malloc+0xbb4>
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	28e080e7          	jalr	654(ra) # 611c <printf>
            exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	f0c080e7          	jalr	-244(ra) # 5da4 <exit>
      exit(0);
    1ea0:	4501                	li	a0,0
    1ea2:	00004097          	auipc	ra,0x4
    1ea6:	f02080e7          	jalr	-254(ra) # 5da4 <exit>
      exit(1);
    1eaa:	4505                	li	a0,1
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	ef8080e7          	jalr	-264(ra) # 5da4 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eb4:	f8040613          	add	a2,s0,-128
    1eb8:	85e6                	mv	a1,s9
    1eba:	00005517          	auipc	a0,0x5
    1ebe:	ee650513          	add	a0,a0,-282 # 6da0 <malloc+0xbcc>
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	25a080e7          	jalr	602(ra) # 611c <printf>
        exit(1);
    1eca:	4505                	li	a0,1
    1ecc:	00004097          	auipc	ra,0x4
    1ed0:	ed8080e7          	jalr	-296(ra) # 5da4 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ed4:	054b7163          	bgeu	s6,s4,1f16 <createdelete+0x198>
      if(fd >= 0)
    1ed8:	02055a63          	bgez	a0,1f0c <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1edc:	2485                	addw	s1,s1,1
    1ede:	0ff4f493          	zext.b	s1,s1
    1ee2:	05548c63          	beq	s1,s5,1f3a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ee6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1eea:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eee:	4581                	li	a1,0
    1ef0:	f8040513          	add	a0,s0,-128
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	f00080e7          	jalr	-256(ra) # 5df4 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1efc:	00090463          	beqz	s2,1f04 <createdelete+0x186>
    1f00:	fd2bdae3          	bge	s7,s2,1ed4 <createdelete+0x156>
    1f04:	fa0548e3          	bltz	a0,1eb4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f08:	014b7963          	bgeu	s6,s4,1f1a <createdelete+0x19c>
        close(fd);
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	ec0080e7          	jalr	-320(ra) # 5dcc <close>
    1f14:	b7e1                	j	1edc <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f16:	fc0543e3          	bltz	a0,1edc <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f1a:	f8040613          	add	a2,s0,-128
    1f1e:	85e6                	mv	a1,s9
    1f20:	00005517          	auipc	a0,0x5
    1f24:	ea850513          	add	a0,a0,-344 # 6dc8 <malloc+0xbf4>
    1f28:	00004097          	auipc	ra,0x4
    1f2c:	1f4080e7          	jalr	500(ra) # 611c <printf>
        exit(1);
    1f30:	4505                	li	a0,1
    1f32:	00004097          	auipc	ra,0x4
    1f36:	e72080e7          	jalr	-398(ra) # 5da4 <exit>
  for(i = 0; i < N; i++){
    1f3a:	2905                	addw	s2,s2,1
    1f3c:	2a05                	addw	s4,s4,1
    1f3e:	2985                	addw	s3,s3,1 # 3001 <execout+0x8f>
    1f40:	0ff9f993          	zext.b	s3,s3
    1f44:	47d1                	li	a5,20
    1f46:	02f90a63          	beq	s2,a5,1f7a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f4a:	84e2                	mv	s1,s8
    1f4c:	bf69                	j	1ee6 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f4e:	2905                	addw	s2,s2,1
    1f50:	0ff97913          	zext.b	s2,s2
    1f54:	2985                	addw	s3,s3,1
    1f56:	0ff9f993          	zext.b	s3,s3
    1f5a:	03490863          	beq	s2,s4,1f8a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f5e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f60:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f64:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f68:	f8040513          	add	a0,s0,-128
    1f6c:	00004097          	auipc	ra,0x4
    1f70:	e98080e7          	jalr	-360(ra) # 5e04 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f74:	34fd                	addw	s1,s1,-1
    1f76:	f4ed                	bnez	s1,1f60 <createdelete+0x1e2>
    1f78:	bfd9                	j	1f4e <createdelete+0x1d0>
    1f7a:	03000993          	li	s3,48
    1f7e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f82:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f84:	08400a13          	li	s4,132
    1f88:	bfd9                	j	1f5e <createdelete+0x1e0>
}
    1f8a:	60aa                	ld	ra,136(sp)
    1f8c:	640a                	ld	s0,128(sp)
    1f8e:	74e6                	ld	s1,120(sp)
    1f90:	7946                	ld	s2,112(sp)
    1f92:	79a6                	ld	s3,104(sp)
    1f94:	7a06                	ld	s4,96(sp)
    1f96:	6ae6                	ld	s5,88(sp)
    1f98:	6b46                	ld	s6,80(sp)
    1f9a:	6ba6                	ld	s7,72(sp)
    1f9c:	6c06                	ld	s8,64(sp)
    1f9e:	7ce2                	ld	s9,56(sp)
    1fa0:	6149                	add	sp,sp,144
    1fa2:	8082                	ret

0000000000001fa4 <linkunlink>:
{
    1fa4:	711d                	add	sp,sp,-96
    1fa6:	ec86                	sd	ra,88(sp)
    1fa8:	e8a2                	sd	s0,80(sp)
    1faa:	e4a6                	sd	s1,72(sp)
    1fac:	e0ca                	sd	s2,64(sp)
    1fae:	fc4e                	sd	s3,56(sp)
    1fb0:	f852                	sd	s4,48(sp)
    1fb2:	f456                	sd	s5,40(sp)
    1fb4:	f05a                	sd	s6,32(sp)
    1fb6:	ec5e                	sd	s7,24(sp)
    1fb8:	e862                	sd	s8,16(sp)
    1fba:	e466                	sd	s9,8(sp)
    1fbc:	1080                	add	s0,sp,96
    1fbe:	84aa                	mv	s1,a0
  unlink("x");
    1fc0:	00004517          	auipc	a0,0x4
    1fc4:	3a850513          	add	a0,a0,936 # 6368 <malloc+0x194>
    1fc8:	00004097          	auipc	ra,0x4
    1fcc:	e3c080e7          	jalr	-452(ra) # 5e04 <unlink>
  pid = fork();
    1fd0:	00004097          	auipc	ra,0x4
    1fd4:	dcc080e7          	jalr	-564(ra) # 5d9c <fork>
  if(pid < 0){
    1fd8:	02054b63          	bltz	a0,200e <linkunlink+0x6a>
    1fdc:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fde:	06100c93          	li	s9,97
    1fe2:	c111                	beqz	a0,1fe6 <linkunlink+0x42>
    1fe4:	4c85                	li	s9,1
    1fe6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fea:	41c659b7          	lui	s3,0x41c65
    1fee:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1ff2:	690d                	lui	s2,0x3
    1ff4:	0399091b          	addw	s2,s2,57 # 3039 <fourteen+0x3>
    if((x % 3) == 0){
    1ff8:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1ffa:	4b05                	li	s6,1
      unlink("x");
    1ffc:	00004a97          	auipc	s5,0x4
    2000:	36ca8a93          	add	s5,s5,876 # 6368 <malloc+0x194>
      link("cat", "x");
    2004:	00005b97          	auipc	s7,0x5
    2008:	decb8b93          	add	s7,s7,-532 # 6df0 <malloc+0xc1c>
    200c:	a825                	j	2044 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    200e:	85a6                	mv	a1,s1
    2010:	00005517          	auipc	a0,0x5
    2014:	b8850513          	add	a0,a0,-1144 # 6b98 <malloc+0x9c4>
    2018:	00004097          	auipc	ra,0x4
    201c:	104080e7          	jalr	260(ra) # 611c <printf>
    exit(1);
    2020:	4505                	li	a0,1
    2022:	00004097          	auipc	ra,0x4
    2026:	d82080e7          	jalr	-638(ra) # 5da4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    202a:	20200593          	li	a1,514
    202e:	8556                	mv	a0,s5
    2030:	00004097          	auipc	ra,0x4
    2034:	dc4080e7          	jalr	-572(ra) # 5df4 <open>
    2038:	00004097          	auipc	ra,0x4
    203c:	d94080e7          	jalr	-620(ra) # 5dcc <close>
  for(i = 0; i < 100; i++){
    2040:	34fd                	addw	s1,s1,-1
    2042:	c88d                	beqz	s1,2074 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2044:	033c87bb          	mulw	a5,s9,s3
    2048:	012787bb          	addw	a5,a5,s2
    204c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2050:	0347f7bb          	remuw	a5,a5,s4
    2054:	dbf9                	beqz	a5,202a <linkunlink+0x86>
    } else if((x % 3) == 1){
    2056:	01678863          	beq	a5,s6,2066 <linkunlink+0xc2>
      unlink("x");
    205a:	8556                	mv	a0,s5
    205c:	00004097          	auipc	ra,0x4
    2060:	da8080e7          	jalr	-600(ra) # 5e04 <unlink>
    2064:	bff1                	j	2040 <linkunlink+0x9c>
      link("cat", "x");
    2066:	85d6                	mv	a1,s5
    2068:	855e                	mv	a0,s7
    206a:	00004097          	auipc	ra,0x4
    206e:	daa080e7          	jalr	-598(ra) # 5e14 <link>
    2072:	b7f9                	j	2040 <linkunlink+0x9c>
  if(pid)
    2074:	020c0463          	beqz	s8,209c <linkunlink+0xf8>
    wait(0);
    2078:	4501                	li	a0,0
    207a:	00004097          	auipc	ra,0x4
    207e:	d32080e7          	jalr	-718(ra) # 5dac <wait>
}
    2082:	60e6                	ld	ra,88(sp)
    2084:	6446                	ld	s0,80(sp)
    2086:	64a6                	ld	s1,72(sp)
    2088:	6906                	ld	s2,64(sp)
    208a:	79e2                	ld	s3,56(sp)
    208c:	7a42                	ld	s4,48(sp)
    208e:	7aa2                	ld	s5,40(sp)
    2090:	7b02                	ld	s6,32(sp)
    2092:	6be2                	ld	s7,24(sp)
    2094:	6c42                	ld	s8,16(sp)
    2096:	6ca2                	ld	s9,8(sp)
    2098:	6125                	add	sp,sp,96
    209a:	8082                	ret
    exit(0);
    209c:	4501                	li	a0,0
    209e:	00004097          	auipc	ra,0x4
    20a2:	d06080e7          	jalr	-762(ra) # 5da4 <exit>

00000000000020a6 <forktest>:
{
    20a6:	7179                	add	sp,sp,-48
    20a8:	f406                	sd	ra,40(sp)
    20aa:	f022                	sd	s0,32(sp)
    20ac:	ec26                	sd	s1,24(sp)
    20ae:	e84a                	sd	s2,16(sp)
    20b0:	e44e                	sd	s3,8(sp)
    20b2:	1800                	add	s0,sp,48
    20b4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20b6:	4481                	li	s1,0
    20b8:	3e800913          	li	s2,1000
    pid = fork();
    20bc:	00004097          	auipc	ra,0x4
    20c0:	ce0080e7          	jalr	-800(ra) # 5d9c <fork>
    if(pid < 0)
    20c4:	02054863          	bltz	a0,20f4 <forktest+0x4e>
    if(pid == 0)
    20c8:	c115                	beqz	a0,20ec <forktest+0x46>
  for(n=0; n<N; n++){
    20ca:	2485                	addw	s1,s1,1
    20cc:	ff2498e3          	bne	s1,s2,20bc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20d0:	85ce                	mv	a1,s3
    20d2:	00005517          	auipc	a0,0x5
    20d6:	d3e50513          	add	a0,a0,-706 # 6e10 <malloc+0xc3c>
    20da:	00004097          	auipc	ra,0x4
    20de:	042080e7          	jalr	66(ra) # 611c <printf>
    exit(1);
    20e2:	4505                	li	a0,1
    20e4:	00004097          	auipc	ra,0x4
    20e8:	cc0080e7          	jalr	-832(ra) # 5da4 <exit>
      exit(0);
    20ec:	00004097          	auipc	ra,0x4
    20f0:	cb8080e7          	jalr	-840(ra) # 5da4 <exit>
  if (n == 0) {
    20f4:	cc9d                	beqz	s1,2132 <forktest+0x8c>
  if(n == N){
    20f6:	3e800793          	li	a5,1000
    20fa:	fcf48be3          	beq	s1,a5,20d0 <forktest+0x2a>
  for(; n > 0; n--){
    20fe:	00905b63          	blez	s1,2114 <forktest+0x6e>
    if(wait(0) < 0){
    2102:	4501                	li	a0,0
    2104:	00004097          	auipc	ra,0x4
    2108:	ca8080e7          	jalr	-856(ra) # 5dac <wait>
    210c:	04054163          	bltz	a0,214e <forktest+0xa8>
  for(; n > 0; n--){
    2110:	34fd                	addw	s1,s1,-1
    2112:	f8e5                	bnez	s1,2102 <forktest+0x5c>
  if(wait(0) != -1){
    2114:	4501                	li	a0,0
    2116:	00004097          	auipc	ra,0x4
    211a:	c96080e7          	jalr	-874(ra) # 5dac <wait>
    211e:	57fd                	li	a5,-1
    2120:	04f51563          	bne	a0,a5,216a <forktest+0xc4>
}
    2124:	70a2                	ld	ra,40(sp)
    2126:	7402                	ld	s0,32(sp)
    2128:	64e2                	ld	s1,24(sp)
    212a:	6942                	ld	s2,16(sp)
    212c:	69a2                	ld	s3,8(sp)
    212e:	6145                	add	sp,sp,48
    2130:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2132:	85ce                	mv	a1,s3
    2134:	00005517          	auipc	a0,0x5
    2138:	cc450513          	add	a0,a0,-828 # 6df8 <malloc+0xc24>
    213c:	00004097          	auipc	ra,0x4
    2140:	fe0080e7          	jalr	-32(ra) # 611c <printf>
    exit(1);
    2144:	4505                	li	a0,1
    2146:	00004097          	auipc	ra,0x4
    214a:	c5e080e7          	jalr	-930(ra) # 5da4 <exit>
      printf("%s: wait stopped early\n", s);
    214e:	85ce                	mv	a1,s3
    2150:	00005517          	auipc	a0,0x5
    2154:	ce850513          	add	a0,a0,-792 # 6e38 <malloc+0xc64>
    2158:	00004097          	auipc	ra,0x4
    215c:	fc4080e7          	jalr	-60(ra) # 611c <printf>
      exit(1);
    2160:	4505                	li	a0,1
    2162:	00004097          	auipc	ra,0x4
    2166:	c42080e7          	jalr	-958(ra) # 5da4 <exit>
    printf("%s: wait got too many\n", s);
    216a:	85ce                	mv	a1,s3
    216c:	00005517          	auipc	a0,0x5
    2170:	ce450513          	add	a0,a0,-796 # 6e50 <malloc+0xc7c>
    2174:	00004097          	auipc	ra,0x4
    2178:	fa8080e7          	jalr	-88(ra) # 611c <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	00004097          	auipc	ra,0x4
    2182:	c26080e7          	jalr	-986(ra) # 5da4 <exit>

0000000000002186 <kernmem>:
{
    2186:	715d                	add	sp,sp,-80
    2188:	e486                	sd	ra,72(sp)
    218a:	e0a2                	sd	s0,64(sp)
    218c:	fc26                	sd	s1,56(sp)
    218e:	f84a                	sd	s2,48(sp)
    2190:	f44e                	sd	s3,40(sp)
    2192:	f052                	sd	s4,32(sp)
    2194:	ec56                	sd	s5,24(sp)
    2196:	0880                	add	s0,sp,80
    2198:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    219a:	4485                	li	s1,1
    219c:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    219e:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21a0:	69b1                	lui	s3,0xc
    21a2:	35098993          	add	s3,s3,848 # c350 <uninit+0x1de8>
    21a6:	1003d937          	lui	s2,0x1003d
    21aa:	090e                	sll	s2,s2,0x3
    21ac:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21b0:	00004097          	auipc	ra,0x4
    21b4:	bec080e7          	jalr	-1044(ra) # 5d9c <fork>
    if(pid < 0){
    21b8:	02054963          	bltz	a0,21ea <kernmem+0x64>
    if(pid == 0){
    21bc:	c529                	beqz	a0,2206 <kernmem+0x80>
    wait(&xstatus);
    21be:	fbc40513          	add	a0,s0,-68
    21c2:	00004097          	auipc	ra,0x4
    21c6:	bea080e7          	jalr	-1046(ra) # 5dac <wait>
    if(xstatus != -1)  // did kernel kill child?
    21ca:	fbc42783          	lw	a5,-68(s0)
    21ce:	05579d63          	bne	a5,s5,2228 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21d2:	94ce                	add	s1,s1,s3
    21d4:	fd249ee3          	bne	s1,s2,21b0 <kernmem+0x2a>
}
    21d8:	60a6                	ld	ra,72(sp)
    21da:	6406                	ld	s0,64(sp)
    21dc:	74e2                	ld	s1,56(sp)
    21de:	7942                	ld	s2,48(sp)
    21e0:	79a2                	ld	s3,40(sp)
    21e2:	7a02                	ld	s4,32(sp)
    21e4:	6ae2                	ld	s5,24(sp)
    21e6:	6161                	add	sp,sp,80
    21e8:	8082                	ret
      printf("%s: fork failed\n", s);
    21ea:	85d2                	mv	a1,s4
    21ec:	00005517          	auipc	a0,0x5
    21f0:	9ac50513          	add	a0,a0,-1620 # 6b98 <malloc+0x9c4>
    21f4:	00004097          	auipc	ra,0x4
    21f8:	f28080e7          	jalr	-216(ra) # 611c <printf>
      exit(1);
    21fc:	4505                	li	a0,1
    21fe:	00004097          	auipc	ra,0x4
    2202:	ba6080e7          	jalr	-1114(ra) # 5da4 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2206:	0004c683          	lbu	a3,0(s1)
    220a:	8626                	mv	a2,s1
    220c:	85d2                	mv	a1,s4
    220e:	00005517          	auipc	a0,0x5
    2212:	c5a50513          	add	a0,a0,-934 # 6e68 <malloc+0xc94>
    2216:	00004097          	auipc	ra,0x4
    221a:	f06080e7          	jalr	-250(ra) # 611c <printf>
      exit(1);
    221e:	4505                	li	a0,1
    2220:	00004097          	auipc	ra,0x4
    2224:	b84080e7          	jalr	-1148(ra) # 5da4 <exit>
      exit(1);
    2228:	4505                	li	a0,1
    222a:	00004097          	auipc	ra,0x4
    222e:	b7a080e7          	jalr	-1158(ra) # 5da4 <exit>

0000000000002232 <MAXVAplus>:
{
    2232:	7179                	add	sp,sp,-48
    2234:	f406                	sd	ra,40(sp)
    2236:	f022                	sd	s0,32(sp)
    2238:	ec26                	sd	s1,24(sp)
    223a:	e84a                	sd	s2,16(sp)
    223c:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    223e:	4785                	li	a5,1
    2240:	179a                	sll	a5,a5,0x26
    2242:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2246:	fd843783          	ld	a5,-40(s0)
    224a:	cf85                	beqz	a5,2282 <MAXVAplus+0x50>
    224c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    224e:	54fd                	li	s1,-1
    pid = fork();
    2250:	00004097          	auipc	ra,0x4
    2254:	b4c080e7          	jalr	-1204(ra) # 5d9c <fork>
    if(pid < 0){
    2258:	02054b63          	bltz	a0,228e <MAXVAplus+0x5c>
    if(pid == 0){
    225c:	c539                	beqz	a0,22aa <MAXVAplus+0x78>
    wait(&xstatus);
    225e:	fd440513          	add	a0,s0,-44
    2262:	00004097          	auipc	ra,0x4
    2266:	b4a080e7          	jalr	-1206(ra) # 5dac <wait>
    if(xstatus != -1)  // did kernel kill child?
    226a:	fd442783          	lw	a5,-44(s0)
    226e:	06979463          	bne	a5,s1,22d6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2272:	fd843783          	ld	a5,-40(s0)
    2276:	0786                	sll	a5,a5,0x1
    2278:	fcf43c23          	sd	a5,-40(s0)
    227c:	fd843783          	ld	a5,-40(s0)
    2280:	fbe1                	bnez	a5,2250 <MAXVAplus+0x1e>
}
    2282:	70a2                	ld	ra,40(sp)
    2284:	7402                	ld	s0,32(sp)
    2286:	64e2                	ld	s1,24(sp)
    2288:	6942                	ld	s2,16(sp)
    228a:	6145                	add	sp,sp,48
    228c:	8082                	ret
      printf("%s: fork failed\n", s);
    228e:	85ca                	mv	a1,s2
    2290:	00005517          	auipc	a0,0x5
    2294:	90850513          	add	a0,a0,-1784 # 6b98 <malloc+0x9c4>
    2298:	00004097          	auipc	ra,0x4
    229c:	e84080e7          	jalr	-380(ra) # 611c <printf>
      exit(1);
    22a0:	4505                	li	a0,1
    22a2:	00004097          	auipc	ra,0x4
    22a6:	b02080e7          	jalr	-1278(ra) # 5da4 <exit>
      *(char*)a = 99;
    22aa:	fd843783          	ld	a5,-40(s0)
    22ae:	06300713          	li	a4,99
    22b2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22b6:	fd843603          	ld	a2,-40(s0)
    22ba:	85ca                	mv	a1,s2
    22bc:	00005517          	auipc	a0,0x5
    22c0:	bcc50513          	add	a0,a0,-1076 # 6e88 <malloc+0xcb4>
    22c4:	00004097          	auipc	ra,0x4
    22c8:	e58080e7          	jalr	-424(ra) # 611c <printf>
      exit(1);
    22cc:	4505                	li	a0,1
    22ce:	00004097          	auipc	ra,0x4
    22d2:	ad6080e7          	jalr	-1322(ra) # 5da4 <exit>
      exit(1);
    22d6:	4505                	li	a0,1
    22d8:	00004097          	auipc	ra,0x4
    22dc:	acc080e7          	jalr	-1332(ra) # 5da4 <exit>

00000000000022e0 <bigargtest>:
{
    22e0:	7179                	add	sp,sp,-48
    22e2:	f406                	sd	ra,40(sp)
    22e4:	f022                	sd	s0,32(sp)
    22e6:	ec26                	sd	s1,24(sp)
    22e8:	1800                	add	s0,sp,48
    22ea:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22ec:	00005517          	auipc	a0,0x5
    22f0:	bb450513          	add	a0,a0,-1100 # 6ea0 <malloc+0xccc>
    22f4:	00004097          	auipc	ra,0x4
    22f8:	b10080e7          	jalr	-1264(ra) # 5e04 <unlink>
  pid = fork();
    22fc:	00004097          	auipc	ra,0x4
    2300:	aa0080e7          	jalr	-1376(ra) # 5d9c <fork>
  if(pid == 0){
    2304:	c121                	beqz	a0,2344 <bigargtest+0x64>
  } else if(pid < 0){
    2306:	0a054063          	bltz	a0,23a6 <bigargtest+0xc6>
  wait(&xstatus);
    230a:	fdc40513          	add	a0,s0,-36
    230e:	00004097          	auipc	ra,0x4
    2312:	a9e080e7          	jalr	-1378(ra) # 5dac <wait>
  if(xstatus != 0)
    2316:	fdc42503          	lw	a0,-36(s0)
    231a:	e545                	bnez	a0,23c2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    231c:	4581                	li	a1,0
    231e:	00005517          	auipc	a0,0x5
    2322:	b8250513          	add	a0,a0,-1150 # 6ea0 <malloc+0xccc>
    2326:	00004097          	auipc	ra,0x4
    232a:	ace080e7          	jalr	-1330(ra) # 5df4 <open>
  if(fd < 0){
    232e:	08054e63          	bltz	a0,23ca <bigargtest+0xea>
  close(fd);
    2332:	00004097          	auipc	ra,0x4
    2336:	a9a080e7          	jalr	-1382(ra) # 5dcc <close>
}
    233a:	70a2                	ld	ra,40(sp)
    233c:	7402                	ld	s0,32(sp)
    233e:	64e2                	ld	s1,24(sp)
    2340:	6145                	add	sp,sp,48
    2342:	8082                	ret
    2344:	00007797          	auipc	a5,0x7
    2348:	11c78793          	add	a5,a5,284 # 9460 <args.1>
    234c:	00007697          	auipc	a3,0x7
    2350:	20c68693          	add	a3,a3,524 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2354:	00005717          	auipc	a4,0x5
    2358:	b5c70713          	add	a4,a4,-1188 # 6eb0 <malloc+0xcdc>
    235c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    235e:	07a1                	add	a5,a5,8
    2360:	fed79ee3          	bne	a5,a3,235c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2364:	00007597          	auipc	a1,0x7
    2368:	0fc58593          	add	a1,a1,252 # 9460 <args.1>
    236c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2370:	00004517          	auipc	a0,0x4
    2374:	f8850513          	add	a0,a0,-120 # 62f8 <malloc+0x124>
    2378:	00004097          	auipc	ra,0x4
    237c:	a74080e7          	jalr	-1420(ra) # 5dec <exec>
    fd = open("bigarg-ok", O_CREATE);
    2380:	20000593          	li	a1,512
    2384:	00005517          	auipc	a0,0x5
    2388:	b1c50513          	add	a0,a0,-1252 # 6ea0 <malloc+0xccc>
    238c:	00004097          	auipc	ra,0x4
    2390:	a68080e7          	jalr	-1432(ra) # 5df4 <open>
    close(fd);
    2394:	00004097          	auipc	ra,0x4
    2398:	a38080e7          	jalr	-1480(ra) # 5dcc <close>
    exit(0);
    239c:	4501                	li	a0,0
    239e:	00004097          	auipc	ra,0x4
    23a2:	a06080e7          	jalr	-1530(ra) # 5da4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23a6:	85a6                	mv	a1,s1
    23a8:	00005517          	auipc	a0,0x5
    23ac:	be850513          	add	a0,a0,-1048 # 6f90 <malloc+0xdbc>
    23b0:	00004097          	auipc	ra,0x4
    23b4:	d6c080e7          	jalr	-660(ra) # 611c <printf>
    exit(1);
    23b8:	4505                	li	a0,1
    23ba:	00004097          	auipc	ra,0x4
    23be:	9ea080e7          	jalr	-1558(ra) # 5da4 <exit>
    exit(xstatus);
    23c2:	00004097          	auipc	ra,0x4
    23c6:	9e2080e7          	jalr	-1566(ra) # 5da4 <exit>
    printf("%s: bigarg test failed!\n", s);
    23ca:	85a6                	mv	a1,s1
    23cc:	00005517          	auipc	a0,0x5
    23d0:	be450513          	add	a0,a0,-1052 # 6fb0 <malloc+0xddc>
    23d4:	00004097          	auipc	ra,0x4
    23d8:	d48080e7          	jalr	-696(ra) # 611c <printf>
    exit(1);
    23dc:	4505                	li	a0,1
    23de:	00004097          	auipc	ra,0x4
    23e2:	9c6080e7          	jalr	-1594(ra) # 5da4 <exit>

00000000000023e6 <stacktest>:
{
    23e6:	7179                	add	sp,sp,-48
    23e8:	f406                	sd	ra,40(sp)
    23ea:	f022                	sd	s0,32(sp)
    23ec:	ec26                	sd	s1,24(sp)
    23ee:	1800                	add	s0,sp,48
    23f0:	84aa                	mv	s1,a0
  pid = fork();
    23f2:	00004097          	auipc	ra,0x4
    23f6:	9aa080e7          	jalr	-1622(ra) # 5d9c <fork>
  if(pid == 0) {
    23fa:	c115                	beqz	a0,241e <stacktest+0x38>
  } else if(pid < 0){
    23fc:	04054463          	bltz	a0,2444 <stacktest+0x5e>
  wait(&xstatus);
    2400:	fdc40513          	add	a0,s0,-36
    2404:	00004097          	auipc	ra,0x4
    2408:	9a8080e7          	jalr	-1624(ra) # 5dac <wait>
  if(xstatus == -1)  // kernel killed child?
    240c:	fdc42503          	lw	a0,-36(s0)
    2410:	57fd                	li	a5,-1
    2412:	04f50763          	beq	a0,a5,2460 <stacktest+0x7a>
    exit(xstatus);
    2416:	00004097          	auipc	ra,0x4
    241a:	98e080e7          	jalr	-1650(ra) # 5da4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    241e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2420:	77fd                	lui	a5,0xfffff
    2422:	97ba                	add	a5,a5,a4
    2424:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2428:	85a6                	mv	a1,s1
    242a:	00005517          	auipc	a0,0x5
    242e:	ba650513          	add	a0,a0,-1114 # 6fd0 <malloc+0xdfc>
    2432:	00004097          	auipc	ra,0x4
    2436:	cea080e7          	jalr	-790(ra) # 611c <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00004097          	auipc	ra,0x4
    2440:	968080e7          	jalr	-1688(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    2444:	85a6                	mv	a1,s1
    2446:	00004517          	auipc	a0,0x4
    244a:	75250513          	add	a0,a0,1874 # 6b98 <malloc+0x9c4>
    244e:	00004097          	auipc	ra,0x4
    2452:	cce080e7          	jalr	-818(ra) # 611c <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00004097          	auipc	ra,0x4
    245c:	94c080e7          	jalr	-1716(ra) # 5da4 <exit>
    exit(0);
    2460:	4501                	li	a0,0
    2462:	00004097          	auipc	ra,0x4
    2466:	942080e7          	jalr	-1726(ra) # 5da4 <exit>

000000000000246a <textwrite>:
{
    246a:	7179                	add	sp,sp,-48
    246c:	f406                	sd	ra,40(sp)
    246e:	f022                	sd	s0,32(sp)
    2470:	ec26                	sd	s1,24(sp)
    2472:	1800                	add	s0,sp,48
    2474:	84aa                	mv	s1,a0
  pid = fork();
    2476:	00004097          	auipc	ra,0x4
    247a:	926080e7          	jalr	-1754(ra) # 5d9c <fork>
  if(pid == 0) {
    247e:	c115                	beqz	a0,24a2 <textwrite+0x38>
  } else if(pid < 0){
    2480:	02054963          	bltz	a0,24b2 <textwrite+0x48>
  wait(&xstatus);
    2484:	fdc40513          	add	a0,s0,-36
    2488:	00004097          	auipc	ra,0x4
    248c:	924080e7          	jalr	-1756(ra) # 5dac <wait>
  if(xstatus == -1)  // kernel killed child?
    2490:	fdc42503          	lw	a0,-36(s0)
    2494:	57fd                	li	a5,-1
    2496:	02f50c63          	beq	a0,a5,24ce <textwrite+0x64>
    exit(xstatus);
    249a:	00004097          	auipc	ra,0x4
    249e:	90a080e7          	jalr	-1782(ra) # 5da4 <exit>
    *addr = 10;
    24a2:	47a9                	li	a5,10
    24a4:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24a8:	4505                	li	a0,1
    24aa:	00004097          	auipc	ra,0x4
    24ae:	8fa080e7          	jalr	-1798(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    24b2:	85a6                	mv	a1,s1
    24b4:	00004517          	auipc	a0,0x4
    24b8:	6e450513          	add	a0,a0,1764 # 6b98 <malloc+0x9c4>
    24bc:	00004097          	auipc	ra,0x4
    24c0:	c60080e7          	jalr	-928(ra) # 611c <printf>
    exit(1);
    24c4:	4505                	li	a0,1
    24c6:	00004097          	auipc	ra,0x4
    24ca:	8de080e7          	jalr	-1826(ra) # 5da4 <exit>
    exit(0);
    24ce:	4501                	li	a0,0
    24d0:	00004097          	auipc	ra,0x4
    24d4:	8d4080e7          	jalr	-1836(ra) # 5da4 <exit>

00000000000024d8 <manywrites>:
{
    24d8:	711d                	add	sp,sp,-96
    24da:	ec86                	sd	ra,88(sp)
    24dc:	e8a2                	sd	s0,80(sp)
    24de:	e4a6                	sd	s1,72(sp)
    24e0:	e0ca                	sd	s2,64(sp)
    24e2:	fc4e                	sd	s3,56(sp)
    24e4:	f852                	sd	s4,48(sp)
    24e6:	f456                	sd	s5,40(sp)
    24e8:	f05a                	sd	s6,32(sp)
    24ea:	ec5e                	sd	s7,24(sp)
    24ec:	1080                	add	s0,sp,96
    24ee:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24f0:	4981                	li	s3,0
    24f2:	4911                	li	s2,4
    int pid = fork();
    24f4:	00004097          	auipc	ra,0x4
    24f8:	8a8080e7          	jalr	-1880(ra) # 5d9c <fork>
    24fc:	84aa                	mv	s1,a0
    if(pid < 0){
    24fe:	02054963          	bltz	a0,2530 <manywrites+0x58>
    if(pid == 0){
    2502:	c521                	beqz	a0,254a <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    2504:	2985                	addw	s3,s3,1
    2506:	ff2997e3          	bne	s3,s2,24f4 <manywrites+0x1c>
    250a:	4491                	li	s1,4
    int st = 0;
    250c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2510:	fa840513          	add	a0,s0,-88
    2514:	00004097          	auipc	ra,0x4
    2518:	898080e7          	jalr	-1896(ra) # 5dac <wait>
    if(st != 0)
    251c:	fa842503          	lw	a0,-88(s0)
    2520:	ed6d                	bnez	a0,261a <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2522:	34fd                	addw	s1,s1,-1
    2524:	f4e5                	bnez	s1,250c <manywrites+0x34>
  exit(0);
    2526:	4501                	li	a0,0
    2528:	00004097          	auipc	ra,0x4
    252c:	87c080e7          	jalr	-1924(ra) # 5da4 <exit>
      printf("fork failed\n");
    2530:	00005517          	auipc	a0,0x5
    2534:	a7050513          	add	a0,a0,-1424 # 6fa0 <malloc+0xdcc>
    2538:	00004097          	auipc	ra,0x4
    253c:	be4080e7          	jalr	-1052(ra) # 611c <printf>
      exit(1);
    2540:	4505                	li	a0,1
    2542:	00004097          	auipc	ra,0x4
    2546:	862080e7          	jalr	-1950(ra) # 5da4 <exit>
      name[0] = 'b';
    254a:	06200793          	li	a5,98
    254e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2552:	0619879b          	addw	a5,s3,97
    2556:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    255a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    255e:	fa840513          	add	a0,s0,-88
    2562:	00004097          	auipc	ra,0x4
    2566:	8a2080e7          	jalr	-1886(ra) # 5e04 <unlink>
    256a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    256c:	0000ab17          	auipc	s6,0xa
    2570:	70cb0b13          	add	s6,s6,1804 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2574:	8a26                	mv	s4,s1
    2576:	0209ce63          	bltz	s3,25b2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    257a:	20200593          	li	a1,514
    257e:	fa840513          	add	a0,s0,-88
    2582:	00004097          	auipc	ra,0x4
    2586:	872080e7          	jalr	-1934(ra) # 5df4 <open>
    258a:	892a                	mv	s2,a0
          if(fd < 0){
    258c:	04054763          	bltz	a0,25da <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2590:	660d                	lui	a2,0x3
    2592:	85da                	mv	a1,s6
    2594:	00004097          	auipc	ra,0x4
    2598:	830080e7          	jalr	-2000(ra) # 5dc4 <write>
          if(cc != sz){
    259c:	678d                	lui	a5,0x3
    259e:	04f51e63          	bne	a0,a5,25fa <manywrites+0x122>
          close(fd);
    25a2:	854a                	mv	a0,s2
    25a4:	00004097          	auipc	ra,0x4
    25a8:	828080e7          	jalr	-2008(ra) # 5dcc <close>
        for(int i = 0; i < ci+1; i++){
    25ac:	2a05                	addw	s4,s4,1
    25ae:	fd49d6e3          	bge	s3,s4,257a <manywrites+0xa2>
        unlink(name);
    25b2:	fa840513          	add	a0,s0,-88
    25b6:	00004097          	auipc	ra,0x4
    25ba:	84e080e7          	jalr	-1970(ra) # 5e04 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25be:	3bfd                	addw	s7,s7,-1
    25c0:	fa0b9ae3          	bnez	s7,2574 <manywrites+0x9c>
      unlink(name);
    25c4:	fa840513          	add	a0,s0,-88
    25c8:	00004097          	auipc	ra,0x4
    25cc:	83c080e7          	jalr	-1988(ra) # 5e04 <unlink>
      exit(0);
    25d0:	4501                	li	a0,0
    25d2:	00003097          	auipc	ra,0x3
    25d6:	7d2080e7          	jalr	2002(ra) # 5da4 <exit>
            printf("%s: cannot create %s\n", s, name);
    25da:	fa840613          	add	a2,s0,-88
    25de:	85d6                	mv	a1,s5
    25e0:	00005517          	auipc	a0,0x5
    25e4:	a1850513          	add	a0,a0,-1512 # 6ff8 <malloc+0xe24>
    25e8:	00004097          	auipc	ra,0x4
    25ec:	b34080e7          	jalr	-1228(ra) # 611c <printf>
            exit(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	7b2080e7          	jalr	1970(ra) # 5da4 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25fa:	86aa                	mv	a3,a0
    25fc:	660d                	lui	a2,0x3
    25fe:	85d6                	mv	a1,s5
    2600:	00004517          	auipc	a0,0x4
    2604:	dc850513          	add	a0,a0,-568 # 63c8 <malloc+0x1f4>
    2608:	00004097          	auipc	ra,0x4
    260c:	b14080e7          	jalr	-1260(ra) # 611c <printf>
            exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	792080e7          	jalr	1938(ra) # 5da4 <exit>
      exit(st);
    261a:	00003097          	auipc	ra,0x3
    261e:	78a080e7          	jalr	1930(ra) # 5da4 <exit>

0000000000002622 <copyinstr3>:
{
    2622:	7179                	add	sp,sp,-48
    2624:	f406                	sd	ra,40(sp)
    2626:	f022                	sd	s0,32(sp)
    2628:	ec26                	sd	s1,24(sp)
    262a:	1800                	add	s0,sp,48
  sbrk(8192);
    262c:	6509                	lui	a0,0x2
    262e:	00004097          	auipc	ra,0x4
    2632:	80e080e7          	jalr	-2034(ra) # 5e3c <sbrk>
  uint64 top = (uint64) sbrk(0);
    2636:	4501                	li	a0,0
    2638:	00004097          	auipc	ra,0x4
    263c:	804080e7          	jalr	-2044(ra) # 5e3c <sbrk>
  if((top % PGSIZE) != 0){
    2640:	03451793          	sll	a5,a0,0x34
    2644:	e3c9                	bnez	a5,26c6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	7f4080e7          	jalr	2036(ra) # 5e3c <sbrk>
  if(top % PGSIZE){
    2650:	03451793          	sll	a5,a0,0x34
    2654:	e3d9                	bnez	a5,26da <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2656:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x5b>
  *b = 'x';
    265a:	07800793          	li	a5,120
    265e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2662:	8526                	mv	a0,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	7a0080e7          	jalr	1952(ra) # 5e04 <unlink>
  if(ret != -1){
    266c:	57fd                	li	a5,-1
    266e:	08f51363          	bne	a0,a5,26f4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2672:	20100593          	li	a1,513
    2676:	8526                	mv	a0,s1
    2678:	00003097          	auipc	ra,0x3
    267c:	77c080e7          	jalr	1916(ra) # 5df4 <open>
  if(fd != -1){
    2680:	57fd                	li	a5,-1
    2682:	08f51863          	bne	a0,a5,2712 <copyinstr3+0xf0>
  ret = link(b, b);
    2686:	85a6                	mv	a1,s1
    2688:	8526                	mv	a0,s1
    268a:	00003097          	auipc	ra,0x3
    268e:	78a080e7          	jalr	1930(ra) # 5e14 <link>
  if(ret != -1){
    2692:	57fd                	li	a5,-1
    2694:	08f51e63          	bne	a0,a5,2730 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2698:	00005797          	auipc	a5,0x5
    269c:	65878793          	add	a5,a5,1624 # 7cf0 <malloc+0x1b1c>
    26a0:	fcf43823          	sd	a5,-48(s0)
    26a4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26a8:	fd040593          	add	a1,s0,-48
    26ac:	8526                	mv	a0,s1
    26ae:	00003097          	auipc	ra,0x3
    26b2:	73e080e7          	jalr	1854(ra) # 5dec <exec>
  if(ret != -1){
    26b6:	57fd                	li	a5,-1
    26b8:	08f51c63          	bne	a0,a5,2750 <copyinstr3+0x12e>
}
    26bc:	70a2                	ld	ra,40(sp)
    26be:	7402                	ld	s0,32(sp)
    26c0:	64e2                	ld	s1,24(sp)
    26c2:	6145                	add	sp,sp,48
    26c4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26c6:	0347d513          	srl	a0,a5,0x34
    26ca:	6785                	lui	a5,0x1
    26cc:	40a7853b          	subw	a0,a5,a0
    26d0:	00003097          	auipc	ra,0x3
    26d4:	76c080e7          	jalr	1900(ra) # 5e3c <sbrk>
    26d8:	b7bd                	j	2646 <copyinstr3+0x24>
    printf("oops\n");
    26da:	00005517          	auipc	a0,0x5
    26de:	93650513          	add	a0,a0,-1738 # 7010 <malloc+0xe3c>
    26e2:	00004097          	auipc	ra,0x4
    26e6:	a3a080e7          	jalr	-1478(ra) # 611c <printf>
    exit(1);
    26ea:	4505                	li	a0,1
    26ec:	00003097          	auipc	ra,0x3
    26f0:	6b8080e7          	jalr	1720(ra) # 5da4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26f4:	862a                	mv	a2,a0
    26f6:	85a6                	mv	a1,s1
    26f8:	00004517          	auipc	a0,0x4
    26fc:	3c050513          	add	a0,a0,960 # 6ab8 <malloc+0x8e4>
    2700:	00004097          	auipc	ra,0x4
    2704:	a1c080e7          	jalr	-1508(ra) # 611c <printf>
    exit(1);
    2708:	4505                	li	a0,1
    270a:	00003097          	auipc	ra,0x3
    270e:	69a080e7          	jalr	1690(ra) # 5da4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2712:	862a                	mv	a2,a0
    2714:	85a6                	mv	a1,s1
    2716:	00004517          	auipc	a0,0x4
    271a:	3c250513          	add	a0,a0,962 # 6ad8 <malloc+0x904>
    271e:	00004097          	auipc	ra,0x4
    2722:	9fe080e7          	jalr	-1538(ra) # 611c <printf>
    exit(1);
    2726:	4505                	li	a0,1
    2728:	00003097          	auipc	ra,0x3
    272c:	67c080e7          	jalr	1660(ra) # 5da4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2730:	86aa                	mv	a3,a0
    2732:	8626                	mv	a2,s1
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	3c250513          	add	a0,a0,962 # 6af8 <malloc+0x924>
    273e:	00004097          	auipc	ra,0x4
    2742:	9de080e7          	jalr	-1570(ra) # 611c <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	00003097          	auipc	ra,0x3
    274c:	65c080e7          	jalr	1628(ra) # 5da4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2750:	567d                	li	a2,-1
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	3cc50513          	add	a0,a0,972 # 6b20 <malloc+0x94c>
    275c:	00004097          	auipc	ra,0x4
    2760:	9c0080e7          	jalr	-1600(ra) # 611c <printf>
    exit(1);
    2764:	4505                	li	a0,1
    2766:	00003097          	auipc	ra,0x3
    276a:	63e080e7          	jalr	1598(ra) # 5da4 <exit>

000000000000276e <rwsbrk>:
{
    276e:	1101                	add	sp,sp,-32
    2770:	ec06                	sd	ra,24(sp)
    2772:	e822                	sd	s0,16(sp)
    2774:	e426                	sd	s1,8(sp)
    2776:	e04a                	sd	s2,0(sp)
    2778:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    277a:	6509                	lui	a0,0x2
    277c:	00003097          	auipc	ra,0x3
    2780:	6c0080e7          	jalr	1728(ra) # 5e3c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2784:	57fd                	li	a5,-1
    2786:	06f50263          	beq	a0,a5,27ea <rwsbrk+0x7c>
    278a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    278c:	7579                	lui	a0,0xffffe
    278e:	00003097          	auipc	ra,0x3
    2792:	6ae080e7          	jalr	1710(ra) # 5e3c <sbrk>
    2796:	57fd                	li	a5,-1
    2798:	06f50663          	beq	a0,a5,2804 <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    279c:	20100593          	li	a1,513
    27a0:	00005517          	auipc	a0,0x5
    27a4:	8b050513          	add	a0,a0,-1872 # 7050 <malloc+0xe7c>
    27a8:	00003097          	auipc	ra,0x3
    27ac:	64c080e7          	jalr	1612(ra) # 5df4 <open>
    27b0:	892a                	mv	s2,a0
  if(fd < 0){
    27b2:	06054663          	bltz	a0,281e <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    27b6:	6785                	lui	a5,0x1
    27b8:	94be                	add	s1,s1,a5
    27ba:	40000613          	li	a2,1024
    27be:	85a6                	mv	a1,s1
    27c0:	00003097          	auipc	ra,0x3
    27c4:	604080e7          	jalr	1540(ra) # 5dc4 <write>
    27c8:	862a                	mv	a2,a0
  if(n >= 0){
    27ca:	06054763          	bltz	a0,2838 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27ce:	85a6                	mv	a1,s1
    27d0:	00005517          	auipc	a0,0x5
    27d4:	8a050513          	add	a0,a0,-1888 # 7070 <malloc+0xe9c>
    27d8:	00004097          	auipc	ra,0x4
    27dc:	944080e7          	jalr	-1724(ra) # 611c <printf>
    exit(1);
    27e0:	4505                	li	a0,1
    27e2:	00003097          	auipc	ra,0x3
    27e6:	5c2080e7          	jalr	1474(ra) # 5da4 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27ea:	00005517          	auipc	a0,0x5
    27ee:	82e50513          	add	a0,a0,-2002 # 7018 <malloc+0xe44>
    27f2:	00004097          	auipc	ra,0x4
    27f6:	92a080e7          	jalr	-1750(ra) # 611c <printf>
    exit(1);
    27fa:	4505                	li	a0,1
    27fc:	00003097          	auipc	ra,0x3
    2800:	5a8080e7          	jalr	1448(ra) # 5da4 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2804:	00005517          	auipc	a0,0x5
    2808:	82c50513          	add	a0,a0,-2004 # 7030 <malloc+0xe5c>
    280c:	00004097          	auipc	ra,0x4
    2810:	910080e7          	jalr	-1776(ra) # 611c <printf>
    exit(1);
    2814:	4505                	li	a0,1
    2816:	00003097          	auipc	ra,0x3
    281a:	58e080e7          	jalr	1422(ra) # 5da4 <exit>
    printf("open(rwsbrk) failed\n");
    281e:	00005517          	auipc	a0,0x5
    2822:	83a50513          	add	a0,a0,-1990 # 7058 <malloc+0xe84>
    2826:	00004097          	auipc	ra,0x4
    282a:	8f6080e7          	jalr	-1802(ra) # 611c <printf>
    exit(1);
    282e:	4505                	li	a0,1
    2830:	00003097          	auipc	ra,0x3
    2834:	574080e7          	jalr	1396(ra) # 5da4 <exit>
  close(fd);
    2838:	854a                	mv	a0,s2
    283a:	00003097          	auipc	ra,0x3
    283e:	592080e7          	jalr	1426(ra) # 5dcc <close>
  unlink("rwsbrk");
    2842:	00005517          	auipc	a0,0x5
    2846:	80e50513          	add	a0,a0,-2034 # 7050 <malloc+0xe7c>
    284a:	00003097          	auipc	ra,0x3
    284e:	5ba080e7          	jalr	1466(ra) # 5e04 <unlink>
  fd = open("README", O_RDONLY);
    2852:	4581                	li	a1,0
    2854:	00004517          	auipc	a0,0x4
    2858:	c7c50513          	add	a0,a0,-900 # 64d0 <malloc+0x2fc>
    285c:	00003097          	auipc	ra,0x3
    2860:	598080e7          	jalr	1432(ra) # 5df4 <open>
    2864:	892a                	mv	s2,a0
  if(fd < 0){
    2866:	02054963          	bltz	a0,2898 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    286a:	4629                	li	a2,10
    286c:	85a6                	mv	a1,s1
    286e:	00003097          	auipc	ra,0x3
    2872:	54e080e7          	jalr	1358(ra) # 5dbc <read>
    2876:	862a                	mv	a2,a0
  if(n >= 0){
    2878:	02054d63          	bltz	a0,28b2 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    287c:	85a6                	mv	a1,s1
    287e:	00005517          	auipc	a0,0x5
    2882:	82250513          	add	a0,a0,-2014 # 70a0 <malloc+0xecc>
    2886:	00004097          	auipc	ra,0x4
    288a:	896080e7          	jalr	-1898(ra) # 611c <printf>
    exit(1);
    288e:	4505                	li	a0,1
    2890:	00003097          	auipc	ra,0x3
    2894:	514080e7          	jalr	1300(ra) # 5da4 <exit>
    printf("open(rwsbrk) failed\n");
    2898:	00004517          	auipc	a0,0x4
    289c:	7c050513          	add	a0,a0,1984 # 7058 <malloc+0xe84>
    28a0:	00004097          	auipc	ra,0x4
    28a4:	87c080e7          	jalr	-1924(ra) # 611c <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	00003097          	auipc	ra,0x3
    28ae:	4fa080e7          	jalr	1274(ra) # 5da4 <exit>
  close(fd);
    28b2:	854a                	mv	a0,s2
    28b4:	00003097          	auipc	ra,0x3
    28b8:	518080e7          	jalr	1304(ra) # 5dcc <close>
  exit(0);
    28bc:	4501                	li	a0,0
    28be:	00003097          	auipc	ra,0x3
    28c2:	4e6080e7          	jalr	1254(ra) # 5da4 <exit>

00000000000028c6 <sbrkbasic>:
{
    28c6:	7139                	add	sp,sp,-64
    28c8:	fc06                	sd	ra,56(sp)
    28ca:	f822                	sd	s0,48(sp)
    28cc:	f426                	sd	s1,40(sp)
    28ce:	f04a                	sd	s2,32(sp)
    28d0:	ec4e                	sd	s3,24(sp)
    28d2:	e852                	sd	s4,16(sp)
    28d4:	0080                	add	s0,sp,64
    28d6:	8a2a                	mv	s4,a0
  pid = fork();
    28d8:	00003097          	auipc	ra,0x3
    28dc:	4c4080e7          	jalr	1220(ra) # 5d9c <fork>
  if(pid < 0){
    28e0:	02054c63          	bltz	a0,2918 <sbrkbasic+0x52>
  if(pid == 0){
    28e4:	ed21                	bnez	a0,293c <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28e6:	40000537          	lui	a0,0x40000
    28ea:	00003097          	auipc	ra,0x3
    28ee:	552080e7          	jalr	1362(ra) # 5e3c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28f2:	57fd                	li	a5,-1
    28f4:	02f50f63          	beq	a0,a5,2932 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f8:	400007b7          	lui	a5,0x40000
    28fc:	97aa                	add	a5,a5,a0
      *b = 99;
    28fe:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2902:	6705                	lui	a4,0x1
      *b = 99;
    2904:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2908:	953a                	add	a0,a0,a4
    290a:	fef51de3          	bne	a0,a5,2904 <sbrkbasic+0x3e>
    exit(1);
    290e:	4505                	li	a0,1
    2910:	00003097          	auipc	ra,0x3
    2914:	494080e7          	jalr	1172(ra) # 5da4 <exit>
    printf("fork failed in sbrkbasic\n");
    2918:	00004517          	auipc	a0,0x4
    291c:	7b050513          	add	a0,a0,1968 # 70c8 <malloc+0xef4>
    2920:	00003097          	auipc	ra,0x3
    2924:	7fc080e7          	jalr	2044(ra) # 611c <printf>
    exit(1);
    2928:	4505                	li	a0,1
    292a:	00003097          	auipc	ra,0x3
    292e:	47a080e7          	jalr	1146(ra) # 5da4 <exit>
      exit(0);
    2932:	4501                	li	a0,0
    2934:	00003097          	auipc	ra,0x3
    2938:	470080e7          	jalr	1136(ra) # 5da4 <exit>
  wait(&xstatus);
    293c:	fcc40513          	add	a0,s0,-52
    2940:	00003097          	auipc	ra,0x3
    2944:	46c080e7          	jalr	1132(ra) # 5dac <wait>
  if(xstatus == 1){
    2948:	fcc42703          	lw	a4,-52(s0)
    294c:	4785                	li	a5,1
    294e:	00f70d63          	beq	a4,a5,2968 <sbrkbasic+0xa2>
  a = sbrk(0);
    2952:	4501                	li	a0,0
    2954:	00003097          	auipc	ra,0x3
    2958:	4e8080e7          	jalr	1256(ra) # 5e3c <sbrk>
    295c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    295e:	4901                	li	s2,0
    2960:	6985                	lui	s3,0x1
    2962:	38898993          	add	s3,s3,904 # 1388 <badarg+0x26>
    2966:	a005                	j	2986 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2968:	85d2                	mv	a1,s4
    296a:	00004517          	auipc	a0,0x4
    296e:	77e50513          	add	a0,a0,1918 # 70e8 <malloc+0xf14>
    2972:	00003097          	auipc	ra,0x3
    2976:	7aa080e7          	jalr	1962(ra) # 611c <printf>
    exit(1);
    297a:	4505                	li	a0,1
    297c:	00003097          	auipc	ra,0x3
    2980:	428080e7          	jalr	1064(ra) # 5da4 <exit>
    a = b + 1;
    2984:	84be                	mv	s1,a5
    b = sbrk(1);
    2986:	4505                	li	a0,1
    2988:	00003097          	auipc	ra,0x3
    298c:	4b4080e7          	jalr	1204(ra) # 5e3c <sbrk>
    if(b != a){
    2990:	04951c63          	bne	a0,s1,29e8 <sbrkbasic+0x122>
    *b = 1;
    2994:	4785                	li	a5,1
    2996:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    299a:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    299e:	2905                	addw	s2,s2,1
    29a0:	ff3912e3          	bne	s2,s3,2984 <sbrkbasic+0xbe>
  pid = fork();
    29a4:	00003097          	auipc	ra,0x3
    29a8:	3f8080e7          	jalr	1016(ra) # 5d9c <fork>
    29ac:	892a                	mv	s2,a0
  if(pid < 0){
    29ae:	04054e63          	bltz	a0,2a0a <sbrkbasic+0x144>
  c = sbrk(1);
    29b2:	4505                	li	a0,1
    29b4:	00003097          	auipc	ra,0x3
    29b8:	488080e7          	jalr	1160(ra) # 5e3c <sbrk>
  c = sbrk(1);
    29bc:	4505                	li	a0,1
    29be:	00003097          	auipc	ra,0x3
    29c2:	47e080e7          	jalr	1150(ra) # 5e3c <sbrk>
  if(c != a + 1){
    29c6:	0489                	add	s1,s1,2
    29c8:	04a48f63          	beq	s1,a0,2a26 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29cc:	85d2                	mv	a1,s4
    29ce:	00004517          	auipc	a0,0x4
    29d2:	77a50513          	add	a0,a0,1914 # 7148 <malloc+0xf74>
    29d6:	00003097          	auipc	ra,0x3
    29da:	746080e7          	jalr	1862(ra) # 611c <printf>
    exit(1);
    29de:	4505                	li	a0,1
    29e0:	00003097          	auipc	ra,0x3
    29e4:	3c4080e7          	jalr	964(ra) # 5da4 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29e8:	872a                	mv	a4,a0
    29ea:	86a6                	mv	a3,s1
    29ec:	864a                	mv	a2,s2
    29ee:	85d2                	mv	a1,s4
    29f0:	00004517          	auipc	a0,0x4
    29f4:	71850513          	add	a0,a0,1816 # 7108 <malloc+0xf34>
    29f8:	00003097          	auipc	ra,0x3
    29fc:	724080e7          	jalr	1828(ra) # 611c <printf>
      exit(1);
    2a00:	4505                	li	a0,1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	3a2080e7          	jalr	930(ra) # 5da4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a0a:	85d2                	mv	a1,s4
    2a0c:	00004517          	auipc	a0,0x4
    2a10:	71c50513          	add	a0,a0,1820 # 7128 <malloc+0xf54>
    2a14:	00003097          	auipc	ra,0x3
    2a18:	708080e7          	jalr	1800(ra) # 611c <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	386080e7          	jalr	902(ra) # 5da4 <exit>
  if(pid == 0)
    2a26:	00091763          	bnez	s2,2a34 <sbrkbasic+0x16e>
    exit(0);
    2a2a:	4501                	li	a0,0
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	378080e7          	jalr	888(ra) # 5da4 <exit>
  wait(&xstatus);
    2a34:	fcc40513          	add	a0,s0,-52
    2a38:	00003097          	auipc	ra,0x3
    2a3c:	374080e7          	jalr	884(ra) # 5dac <wait>
  exit(xstatus);
    2a40:	fcc42503          	lw	a0,-52(s0)
    2a44:	00003097          	auipc	ra,0x3
    2a48:	360080e7          	jalr	864(ra) # 5da4 <exit>

0000000000002a4c <sbrkmuch>:
{
    2a4c:	7179                	add	sp,sp,-48
    2a4e:	f406                	sd	ra,40(sp)
    2a50:	f022                	sd	s0,32(sp)
    2a52:	ec26                	sd	s1,24(sp)
    2a54:	e84a                	sd	s2,16(sp)
    2a56:	e44e                	sd	s3,8(sp)
    2a58:	e052                	sd	s4,0(sp)
    2a5a:	1800                	add	s0,sp,48
    2a5c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a5e:	4501                	li	a0,0
    2a60:	00003097          	auipc	ra,0x3
    2a64:	3dc080e7          	jalr	988(ra) # 5e3c <sbrk>
    2a68:	892a                	mv	s2,a0
  a = sbrk(0);
    2a6a:	4501                	li	a0,0
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	3d0080e7          	jalr	976(ra) # 5e3c <sbrk>
    2a74:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a76:	06400537          	lui	a0,0x6400
    2a7a:	9d05                	subw	a0,a0,s1
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	3c0080e7          	jalr	960(ra) # 5e3c <sbrk>
  if (p != a) {
    2a84:	0ca49863          	bne	s1,a0,2b54 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a88:	4501                	li	a0,0
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	3b2080e7          	jalr	946(ra) # 5e3c <sbrk>
    2a92:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a94:	00a4f963          	bgeu	s1,a0,2aa6 <sbrkmuch+0x5a>
    *pp = 1;
    2a98:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a9a:	6705                	lui	a4,0x1
    *pp = 1;
    2a9c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2aa0:	94ba                	add	s1,s1,a4
    2aa2:	fef4ede3          	bltu	s1,a5,2a9c <sbrkmuch+0x50>
  *lastaddr = 99;
    2aa6:	064007b7          	lui	a5,0x6400
    2aaa:	06300713          	li	a4,99
    2aae:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2ab2:	4501                	li	a0,0
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	388080e7          	jalr	904(ra) # 5e3c <sbrk>
    2abc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2abe:	757d                	lui	a0,0xfffff
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	37c080e7          	jalr	892(ra) # 5e3c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ac8:	57fd                	li	a5,-1
    2aca:	0af50363          	beq	a0,a5,2b70 <sbrkmuch+0x124>
  c = sbrk(0);
    2ace:	4501                	li	a0,0
    2ad0:	00003097          	auipc	ra,0x3
    2ad4:	36c080e7          	jalr	876(ra) # 5e3c <sbrk>
  if(c != a - PGSIZE){
    2ad8:	77fd                	lui	a5,0xfffff
    2ada:	97a6                	add	a5,a5,s1
    2adc:	0af51863          	bne	a0,a5,2b8c <sbrkmuch+0x140>
  a = sbrk(0);
    2ae0:	4501                	li	a0,0
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	35a080e7          	jalr	858(ra) # 5e3c <sbrk>
    2aea:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2aec:	6505                	lui	a0,0x1
    2aee:	00003097          	auipc	ra,0x3
    2af2:	34e080e7          	jalr	846(ra) # 5e3c <sbrk>
    2af6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2af8:	0aa49a63          	bne	s1,a0,2bac <sbrkmuch+0x160>
    2afc:	4501                	li	a0,0
    2afe:	00003097          	auipc	ra,0x3
    2b02:	33e080e7          	jalr	830(ra) # 5e3c <sbrk>
    2b06:	6785                	lui	a5,0x1
    2b08:	97a6                	add	a5,a5,s1
    2b0a:	0af51163          	bne	a0,a5,2bac <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b0e:	064007b7          	lui	a5,0x6400
    2b12:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b16:	06300793          	li	a5,99
    2b1a:	0af70963          	beq	a4,a5,2bcc <sbrkmuch+0x180>
  a = sbrk(0);
    2b1e:	4501                	li	a0,0
    2b20:	00003097          	auipc	ra,0x3
    2b24:	31c080e7          	jalr	796(ra) # 5e3c <sbrk>
    2b28:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b2a:	4501                	li	a0,0
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	310080e7          	jalr	784(ra) # 5e3c <sbrk>
    2b34:	40a9053b          	subw	a0,s2,a0
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	304080e7          	jalr	772(ra) # 5e3c <sbrk>
  if(c != a){
    2b40:	0aa49463          	bne	s1,a0,2be8 <sbrkmuch+0x19c>
}
    2b44:	70a2                	ld	ra,40(sp)
    2b46:	7402                	ld	s0,32(sp)
    2b48:	64e2                	ld	s1,24(sp)
    2b4a:	6942                	ld	s2,16(sp)
    2b4c:	69a2                	ld	s3,8(sp)
    2b4e:	6a02                	ld	s4,0(sp)
    2b50:	6145                	add	sp,sp,48
    2b52:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b54:	85ce                	mv	a1,s3
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	61250513          	add	a0,a0,1554 # 7168 <malloc+0xf94>
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	5be080e7          	jalr	1470(ra) # 611c <printf>
    exit(1);
    2b66:	4505                	li	a0,1
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	23c080e7          	jalr	572(ra) # 5da4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b70:	85ce                	mv	a1,s3
    2b72:	00004517          	auipc	a0,0x4
    2b76:	63e50513          	add	a0,a0,1598 # 71b0 <malloc+0xfdc>
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	5a2080e7          	jalr	1442(ra) # 611c <printf>
    exit(1);
    2b82:	4505                	li	a0,1
    2b84:	00003097          	auipc	ra,0x3
    2b88:	220080e7          	jalr	544(ra) # 5da4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b8c:	86aa                	mv	a3,a0
    2b8e:	8626                	mv	a2,s1
    2b90:	85ce                	mv	a1,s3
    2b92:	00004517          	auipc	a0,0x4
    2b96:	63e50513          	add	a0,a0,1598 # 71d0 <malloc+0xffc>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	582080e7          	jalr	1410(ra) # 611c <printf>
    exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	200080e7          	jalr	512(ra) # 5da4 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2bac:	86d2                	mv	a3,s4
    2bae:	8626                	mv	a2,s1
    2bb0:	85ce                	mv	a1,s3
    2bb2:	00004517          	auipc	a0,0x4
    2bb6:	65e50513          	add	a0,a0,1630 # 7210 <malloc+0x103c>
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	562080e7          	jalr	1378(ra) # 611c <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	1e0080e7          	jalr	480(ra) # 5da4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bcc:	85ce                	mv	a1,s3
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	67250513          	add	a0,a0,1650 # 7240 <malloc+0x106c>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	546080e7          	jalr	1350(ra) # 611c <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	1c4080e7          	jalr	452(ra) # 5da4 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2be8:	86aa                	mv	a3,a0
    2bea:	8626                	mv	a2,s1
    2bec:	85ce                	mv	a1,s3
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	68a50513          	add	a0,a0,1674 # 7278 <malloc+0x10a4>
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	526080e7          	jalr	1318(ra) # 611c <printf>
    exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	00003097          	auipc	ra,0x3
    2c04:	1a4080e7          	jalr	420(ra) # 5da4 <exit>

0000000000002c08 <sbrkarg>:
{
    2c08:	7179                	add	sp,sp,-48
    2c0a:	f406                	sd	ra,40(sp)
    2c0c:	f022                	sd	s0,32(sp)
    2c0e:	ec26                	sd	s1,24(sp)
    2c10:	e84a                	sd	s2,16(sp)
    2c12:	e44e                	sd	s3,8(sp)
    2c14:	1800                	add	s0,sp,48
    2c16:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c18:	6505                	lui	a0,0x1
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	222080e7          	jalr	546(ra) # 5e3c <sbrk>
    2c22:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c24:	20100593          	li	a1,513
    2c28:	00004517          	auipc	a0,0x4
    2c2c:	67850513          	add	a0,a0,1656 # 72a0 <malloc+0x10cc>
    2c30:	00003097          	auipc	ra,0x3
    2c34:	1c4080e7          	jalr	452(ra) # 5df4 <open>
    2c38:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	66650513          	add	a0,a0,1638 # 72a0 <malloc+0x10cc>
    2c42:	00003097          	auipc	ra,0x3
    2c46:	1c2080e7          	jalr	450(ra) # 5e04 <unlink>
  if(fd < 0)  {
    2c4a:	0404c163          	bltz	s1,2c8c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c4e:	6605                	lui	a2,0x1
    2c50:	85ca                	mv	a1,s2
    2c52:	8526                	mv	a0,s1
    2c54:	00003097          	auipc	ra,0x3
    2c58:	170080e7          	jalr	368(ra) # 5dc4 <write>
    2c5c:	04054663          	bltz	a0,2ca8 <sbrkarg+0xa0>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	00003097          	auipc	ra,0x3
    2c66:	16a080e7          	jalr	362(ra) # 5dcc <close>
  a = sbrk(PGSIZE);
    2c6a:	6505                	lui	a0,0x1
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	1d0080e7          	jalr	464(ra) # 5e3c <sbrk>
  if(pipe((int *) a) != 0){
    2c74:	00003097          	auipc	ra,0x3
    2c78:	140080e7          	jalr	320(ra) # 5db4 <pipe>
    2c7c:	e521                	bnez	a0,2cc4 <sbrkarg+0xbc>
}
    2c7e:	70a2                	ld	ra,40(sp)
    2c80:	7402                	ld	s0,32(sp)
    2c82:	64e2                	ld	s1,24(sp)
    2c84:	6942                	ld	s2,16(sp)
    2c86:	69a2                	ld	s3,8(sp)
    2c88:	6145                	add	sp,sp,48
    2c8a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c8c:	85ce                	mv	a1,s3
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	61a50513          	add	a0,a0,1562 # 72a8 <malloc+0x10d4>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	486080e7          	jalr	1158(ra) # 611c <printf>
    exit(1);
    2c9e:	4505                	li	a0,1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	104080e7          	jalr	260(ra) # 5da4 <exit>
    printf("%s: write sbrk failed\n", s);
    2ca8:	85ce                	mv	a1,s3
    2caa:	00004517          	auipc	a0,0x4
    2cae:	61650513          	add	a0,a0,1558 # 72c0 <malloc+0x10ec>
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	46a080e7          	jalr	1130(ra) # 611c <printf>
    exit(1);
    2cba:	4505                	li	a0,1
    2cbc:	00003097          	auipc	ra,0x3
    2cc0:	0e8080e7          	jalr	232(ra) # 5da4 <exit>
    printf("%s: pipe() failed\n", s);
    2cc4:	85ce                	mv	a1,s3
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	fda50513          	add	a0,a0,-38 # 6ca0 <malloc+0xacc>
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	44e080e7          	jalr	1102(ra) # 611c <printf>
    exit(1);
    2cd6:	4505                	li	a0,1
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	0cc080e7          	jalr	204(ra) # 5da4 <exit>

0000000000002ce0 <argptest>:
{
    2ce0:	1101                	add	sp,sp,-32
    2ce2:	ec06                	sd	ra,24(sp)
    2ce4:	e822                	sd	s0,16(sp)
    2ce6:	e426                	sd	s1,8(sp)
    2ce8:	e04a                	sd	s2,0(sp)
    2cea:	1000                	add	s0,sp,32
    2cec:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cee:	4581                	li	a1,0
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	5e850513          	add	a0,a0,1512 # 72d8 <malloc+0x1104>
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	0fc080e7          	jalr	252(ra) # 5df4 <open>
  if (fd < 0) {
    2d00:	02054b63          	bltz	a0,2d36 <argptest+0x56>
    2d04:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d06:	4501                	li	a0,0
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	134080e7          	jalr	308(ra) # 5e3c <sbrk>
    2d10:	567d                	li	a2,-1
    2d12:	fff50593          	add	a1,a0,-1
    2d16:	8526                	mv	a0,s1
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	0a4080e7          	jalr	164(ra) # 5dbc <read>
  close(fd);
    2d20:	8526                	mv	a0,s1
    2d22:	00003097          	auipc	ra,0x3
    2d26:	0aa080e7          	jalr	170(ra) # 5dcc <close>
}
    2d2a:	60e2                	ld	ra,24(sp)
    2d2c:	6442                	ld	s0,16(sp)
    2d2e:	64a2                	ld	s1,8(sp)
    2d30:	6902                	ld	s2,0(sp)
    2d32:	6105                	add	sp,sp,32
    2d34:	8082                	ret
    printf("%s: open failed\n", s);
    2d36:	85ca                	mv	a1,s2
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	e7850513          	add	a0,a0,-392 # 6bb0 <malloc+0x9dc>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	3dc080e7          	jalr	988(ra) # 611c <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	05a080e7          	jalr	90(ra) # 5da4 <exit>

0000000000002d52 <sbrkbugs>:
{
    2d52:	1141                	add	sp,sp,-16
    2d54:	e406                	sd	ra,8(sp)
    2d56:	e022                	sd	s0,0(sp)
    2d58:	0800                	add	s0,sp,16
  int pid = fork();
    2d5a:	00003097          	auipc	ra,0x3
    2d5e:	042080e7          	jalr	66(ra) # 5d9c <fork>
  if(pid < 0){
    2d62:	02054263          	bltz	a0,2d86 <sbrkbugs+0x34>
  if(pid == 0){
    2d66:	ed0d                	bnez	a0,2da0 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	0d4080e7          	jalr	212(ra) # 5e3c <sbrk>
    sbrk(-sz);
    2d70:	40a0053b          	negw	a0,a0
    2d74:	00003097          	auipc	ra,0x3
    2d78:	0c8080e7          	jalr	200(ra) # 5e3c <sbrk>
    exit(0);
    2d7c:	4501                	li	a0,0
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	026080e7          	jalr	38(ra) # 5da4 <exit>
    printf("fork failed\n");
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	21a50513          	add	a0,a0,538 # 6fa0 <malloc+0xdcc>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	38e080e7          	jalr	910(ra) # 611c <printf>
    exit(1);
    2d96:	4505                	li	a0,1
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	00c080e7          	jalr	12(ra) # 5da4 <exit>
  wait(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	00a080e7          	jalr	10(ra) # 5dac <wait>
  pid = fork();
    2daa:	00003097          	auipc	ra,0x3
    2dae:	ff2080e7          	jalr	-14(ra) # 5d9c <fork>
  if(pid < 0){
    2db2:	02054563          	bltz	a0,2ddc <sbrkbugs+0x8a>
  if(pid == 0){
    2db6:	e121                	bnez	a0,2df6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	084080e7          	jalr	132(ra) # 5e3c <sbrk>
    sbrk(-(sz - 3500));
    2dc0:	6785                	lui	a5,0x1
    2dc2:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x56>
    2dc6:	40a7853b          	subw	a0,a5,a0
    2dca:	00003097          	auipc	ra,0x3
    2dce:	072080e7          	jalr	114(ra) # 5e3c <sbrk>
    exit(0);
    2dd2:	4501                	li	a0,0
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	fd0080e7          	jalr	-48(ra) # 5da4 <exit>
    printf("fork failed\n");
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	1c450513          	add	a0,a0,452 # 6fa0 <malloc+0xdcc>
    2de4:	00003097          	auipc	ra,0x3
    2de8:	338080e7          	jalr	824(ra) # 611c <printf>
    exit(1);
    2dec:	4505                	li	a0,1
    2dee:	00003097          	auipc	ra,0x3
    2df2:	fb6080e7          	jalr	-74(ra) # 5da4 <exit>
  wait(0);
    2df6:	4501                	li	a0,0
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	fb4080e7          	jalr	-76(ra) # 5dac <wait>
  pid = fork();
    2e00:	00003097          	auipc	ra,0x3
    2e04:	f9c080e7          	jalr	-100(ra) # 5d9c <fork>
  if(pid < 0){
    2e08:	02054a63          	bltz	a0,2e3c <sbrkbugs+0xea>
  if(pid == 0){
    2e0c:	e529                	bnez	a0,2e56 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	02e080e7          	jalr	46(ra) # 5e3c <sbrk>
    2e16:	67ad                	lui	a5,0xb
    2e18:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x298>
    2e1c:	40a7853b          	subw	a0,a5,a0
    2e20:	00003097          	auipc	ra,0x3
    2e24:	01c080e7          	jalr	28(ra) # 5e3c <sbrk>
    sbrk(-10);
    2e28:	5559                	li	a0,-10
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	012080e7          	jalr	18(ra) # 5e3c <sbrk>
    exit(0);
    2e32:	4501                	li	a0,0
    2e34:	00003097          	auipc	ra,0x3
    2e38:	f70080e7          	jalr	-144(ra) # 5da4 <exit>
    printf("fork failed\n");
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	16450513          	add	a0,a0,356 # 6fa0 <malloc+0xdcc>
    2e44:	00003097          	auipc	ra,0x3
    2e48:	2d8080e7          	jalr	728(ra) # 611c <printf>
    exit(1);
    2e4c:	4505                	li	a0,1
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	f56080e7          	jalr	-170(ra) # 5da4 <exit>
  wait(0);
    2e56:	4501                	li	a0,0
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	f54080e7          	jalr	-172(ra) # 5dac <wait>
  exit(0);
    2e60:	4501                	li	a0,0
    2e62:	00003097          	auipc	ra,0x3
    2e66:	f42080e7          	jalr	-190(ra) # 5da4 <exit>

0000000000002e6a <sbrklast>:
{
    2e6a:	7179                	add	sp,sp,-48
    2e6c:	f406                	sd	ra,40(sp)
    2e6e:	f022                	sd	s0,32(sp)
    2e70:	ec26                	sd	s1,24(sp)
    2e72:	e84a                	sd	s2,16(sp)
    2e74:	e44e                	sd	s3,8(sp)
    2e76:	e052                	sd	s4,0(sp)
    2e78:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e7a:	4501                	li	a0,0
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	fc0080e7          	jalr	-64(ra) # 5e3c <sbrk>
  if((top % 4096) != 0)
    2e84:	03451793          	sll	a5,a0,0x34
    2e88:	ebd9                	bnez	a5,2f1e <sbrklast+0xb4>
  sbrk(4096);
    2e8a:	6505                	lui	a0,0x1
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	fb0080e7          	jalr	-80(ra) # 5e3c <sbrk>
  sbrk(10);
    2e94:	4529                	li	a0,10
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	fa6080e7          	jalr	-90(ra) # 5e3c <sbrk>
  sbrk(-20);
    2e9e:	5531                	li	a0,-20
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	f9c080e7          	jalr	-100(ra) # 5e3c <sbrk>
  top = (uint64) sbrk(0);
    2ea8:	4501                	li	a0,0
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	f92080e7          	jalr	-110(ra) # 5e3c <sbrk>
    2eb2:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2eb4:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0xb4>
  p[0] = 'x';
    2eb8:	07800a13          	li	s4,120
    2ebc:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2ec0:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2ec4:	20200593          	li	a1,514
    2ec8:	854a                	mv	a0,s2
    2eca:	00003097          	auipc	ra,0x3
    2ece:	f2a080e7          	jalr	-214(ra) # 5df4 <open>
    2ed2:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ed4:	4605                	li	a2,1
    2ed6:	85ca                	mv	a1,s2
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	eec080e7          	jalr	-276(ra) # 5dc4 <write>
  close(fd);
    2ee0:	854e                	mv	a0,s3
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	eea080e7          	jalr	-278(ra) # 5dcc <close>
  fd = open(p, O_RDWR);
    2eea:	4589                	li	a1,2
    2eec:	854a                	mv	a0,s2
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	f06080e7          	jalr	-250(ra) # 5df4 <open>
  p[0] = '\0';
    2ef6:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2efa:	4605                	li	a2,1
    2efc:	85ca                	mv	a1,s2
    2efe:	00003097          	auipc	ra,0x3
    2f02:	ebe080e7          	jalr	-322(ra) # 5dbc <read>
  if(p[0] != 'x')
    2f06:	fc04c783          	lbu	a5,-64(s1)
    2f0a:	03479463          	bne	a5,s4,2f32 <sbrklast+0xc8>
}
    2f0e:	70a2                	ld	ra,40(sp)
    2f10:	7402                	ld	s0,32(sp)
    2f12:	64e2                	ld	s1,24(sp)
    2f14:	6942                	ld	s2,16(sp)
    2f16:	69a2                	ld	s3,8(sp)
    2f18:	6a02                	ld	s4,0(sp)
    2f1a:	6145                	add	sp,sp,48
    2f1c:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f1e:	0347d513          	srl	a0,a5,0x34
    2f22:	6785                	lui	a5,0x1
    2f24:	40a7853b          	subw	a0,a5,a0
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	f14080e7          	jalr	-236(ra) # 5e3c <sbrk>
    2f30:	bfa9                	j	2e8a <sbrklast+0x20>
    exit(1);
    2f32:	4505                	li	a0,1
    2f34:	00003097          	auipc	ra,0x3
    2f38:	e70080e7          	jalr	-400(ra) # 5da4 <exit>

0000000000002f3c <sbrk8000>:
{
    2f3c:	1141                	add	sp,sp,-16
    2f3e:	e406                	sd	ra,8(sp)
    2f40:	e022                	sd	s0,0(sp)
    2f42:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2f44:	80000537          	lui	a0,0x80000
    2f48:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	ef2080e7          	jalr	-270(ra) # 5e3c <sbrk>
  volatile char *top = sbrk(0);
    2f52:	4501                	li	a0,0
    2f54:	00003097          	auipc	ra,0x3
    2f58:	ee8080e7          	jalr	-280(ra) # 5e3c <sbrk>
  *(top-1) = *(top-1) + 1;
    2f5c:	fff54783          	lbu	a5,-1(a0)
    2f60:	2785                	addw	a5,a5,1 # 1001 <linktest+0xf5>
    2f62:	0ff7f793          	zext.b	a5,a5
    2f66:	fef50fa3          	sb	a5,-1(a0)
}
    2f6a:	60a2                	ld	ra,8(sp)
    2f6c:	6402                	ld	s0,0(sp)
    2f6e:	0141                	add	sp,sp,16
    2f70:	8082                	ret

0000000000002f72 <execout>:
{
    2f72:	715d                	add	sp,sp,-80
    2f74:	e486                	sd	ra,72(sp)
    2f76:	e0a2                	sd	s0,64(sp)
    2f78:	fc26                	sd	s1,56(sp)
    2f7a:	f84a                	sd	s2,48(sp)
    2f7c:	f44e                	sd	s3,40(sp)
    2f7e:	f052                	sd	s4,32(sp)
    2f80:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f82:	4901                	li	s2,0
    2f84:	49bd                	li	s3,15
    int pid = fork();
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	e16080e7          	jalr	-490(ra) # 5d9c <fork>
    2f8e:	84aa                	mv	s1,a0
    if(pid < 0){
    2f90:	02054063          	bltz	a0,2fb0 <execout+0x3e>
    } else if(pid == 0){
    2f94:	c91d                	beqz	a0,2fca <execout+0x58>
      wait((int*)0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	e14080e7          	jalr	-492(ra) # 5dac <wait>
  for(int avail = 0; avail < 15; avail++){
    2fa0:	2905                	addw	s2,s2,1
    2fa2:	ff3912e3          	bne	s2,s3,2f86 <execout+0x14>
  exit(0);
    2fa6:	4501                	li	a0,0
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	dfc080e7          	jalr	-516(ra) # 5da4 <exit>
      printf("fork failed\n");
    2fb0:	00004517          	auipc	a0,0x4
    2fb4:	ff050513          	add	a0,a0,-16 # 6fa0 <malloc+0xdcc>
    2fb8:	00003097          	auipc	ra,0x3
    2fbc:	164080e7          	jalr	356(ra) # 611c <printf>
      exit(1);
    2fc0:	4505                	li	a0,1
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	de2080e7          	jalr	-542(ra) # 5da4 <exit>
        if(a == 0xffffffffffffffffLL)
    2fca:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fcc:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fce:	6505                	lui	a0,0x1
    2fd0:	00003097          	auipc	ra,0x3
    2fd4:	e6c080e7          	jalr	-404(ra) # 5e3c <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fd8:	01350763          	beq	a0,s3,2fe6 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fdc:	6785                	lui	a5,0x1
    2fde:	97aa                	add	a5,a5,a0
    2fe0:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0xf3>
      while(1){
    2fe4:	b7ed                	j	2fce <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fe6:	01205a63          	blez	s2,2ffa <execout+0x88>
        sbrk(-4096);
    2fea:	757d                	lui	a0,0xfffff
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	e50080e7          	jalr	-432(ra) # 5e3c <sbrk>
      for(int i = 0; i < avail; i++)
    2ff4:	2485                	addw	s1,s1,1
    2ff6:	ff249ae3          	bne	s1,s2,2fea <execout+0x78>
      close(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00003097          	auipc	ra,0x3
    3000:	dd0080e7          	jalr	-560(ra) # 5dcc <close>
      char *args[] = { "echo", "x", 0 };
    3004:	00003517          	auipc	a0,0x3
    3008:	2f450513          	add	a0,a0,756 # 62f8 <malloc+0x124>
    300c:	faa43c23          	sd	a0,-72(s0)
    3010:	00003797          	auipc	a5,0x3
    3014:	35878793          	add	a5,a5,856 # 6368 <malloc+0x194>
    3018:	fcf43023          	sd	a5,-64(s0)
    301c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3020:	fb840593          	add	a1,s0,-72
    3024:	00003097          	auipc	ra,0x3
    3028:	dc8080e7          	jalr	-568(ra) # 5dec <exec>
      exit(0);
    302c:	4501                	li	a0,0
    302e:	00003097          	auipc	ra,0x3
    3032:	d76080e7          	jalr	-650(ra) # 5da4 <exit>

0000000000003036 <fourteen>:
{
    3036:	1101                	add	sp,sp,-32
    3038:	ec06                	sd	ra,24(sp)
    303a:	e822                	sd	s0,16(sp)
    303c:	e426                	sd	s1,8(sp)
    303e:	1000                	add	s0,sp,32
    3040:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3042:	00004517          	auipc	a0,0x4
    3046:	46e50513          	add	a0,a0,1134 # 74b0 <malloc+0x12dc>
    304a:	00003097          	auipc	ra,0x3
    304e:	dd2080e7          	jalr	-558(ra) # 5e1c <mkdir>
    3052:	e165                	bnez	a0,3132 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3054:	00004517          	auipc	a0,0x4
    3058:	2b450513          	add	a0,a0,692 # 7308 <malloc+0x1134>
    305c:	00003097          	auipc	ra,0x3
    3060:	dc0080e7          	jalr	-576(ra) # 5e1c <mkdir>
    3064:	e56d                	bnez	a0,314e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3066:	20000593          	li	a1,512
    306a:	00004517          	auipc	a0,0x4
    306e:	2f650513          	add	a0,a0,758 # 7360 <malloc+0x118c>
    3072:	00003097          	auipc	ra,0x3
    3076:	d82080e7          	jalr	-638(ra) # 5df4 <open>
  if(fd < 0){
    307a:	0e054863          	bltz	a0,316a <fourteen+0x134>
  close(fd);
    307e:	00003097          	auipc	ra,0x3
    3082:	d4e080e7          	jalr	-690(ra) # 5dcc <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3086:	4581                	li	a1,0
    3088:	00004517          	auipc	a0,0x4
    308c:	35050513          	add	a0,a0,848 # 73d8 <malloc+0x1204>
    3090:	00003097          	auipc	ra,0x3
    3094:	d64080e7          	jalr	-668(ra) # 5df4 <open>
  if(fd < 0){
    3098:	0e054763          	bltz	a0,3186 <fourteen+0x150>
  close(fd);
    309c:	00003097          	auipc	ra,0x3
    30a0:	d30080e7          	jalr	-720(ra) # 5dcc <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    30a4:	00004517          	auipc	a0,0x4
    30a8:	3a450513          	add	a0,a0,932 # 7448 <malloc+0x1274>
    30ac:	00003097          	auipc	ra,0x3
    30b0:	d70080e7          	jalr	-656(ra) # 5e1c <mkdir>
    30b4:	c57d                	beqz	a0,31a2 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30b6:	00004517          	auipc	a0,0x4
    30ba:	3ea50513          	add	a0,a0,1002 # 74a0 <malloc+0x12cc>
    30be:	00003097          	auipc	ra,0x3
    30c2:	d5e080e7          	jalr	-674(ra) # 5e1c <mkdir>
    30c6:	cd65                	beqz	a0,31be <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	3d850513          	add	a0,a0,984 # 74a0 <malloc+0x12cc>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	d34080e7          	jalr	-716(ra) # 5e04 <unlink>
  unlink("12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	37050513          	add	a0,a0,880 # 7448 <malloc+0x1274>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	d24080e7          	jalr	-732(ra) # 5e04 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	2f050513          	add	a0,a0,752 # 73d8 <malloc+0x1204>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	d14080e7          	jalr	-748(ra) # 5e04 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	26850513          	add	a0,a0,616 # 7360 <malloc+0x118c>
    3100:	00003097          	auipc	ra,0x3
    3104:	d04080e7          	jalr	-764(ra) # 5e04 <unlink>
  unlink("12345678901234/123456789012345");
    3108:	00004517          	auipc	a0,0x4
    310c:	20050513          	add	a0,a0,512 # 7308 <malloc+0x1134>
    3110:	00003097          	auipc	ra,0x3
    3114:	cf4080e7          	jalr	-780(ra) # 5e04 <unlink>
  unlink("12345678901234");
    3118:	00004517          	auipc	a0,0x4
    311c:	39850513          	add	a0,a0,920 # 74b0 <malloc+0x12dc>
    3120:	00003097          	auipc	ra,0x3
    3124:	ce4080e7          	jalr	-796(ra) # 5e04 <unlink>
}
    3128:	60e2                	ld	ra,24(sp)
    312a:	6442                	ld	s0,16(sp)
    312c:	64a2                	ld	s1,8(sp)
    312e:	6105                	add	sp,sp,32
    3130:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3132:	85a6                	mv	a1,s1
    3134:	00004517          	auipc	a0,0x4
    3138:	1ac50513          	add	a0,a0,428 # 72e0 <malloc+0x110c>
    313c:	00003097          	auipc	ra,0x3
    3140:	fe0080e7          	jalr	-32(ra) # 611c <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	00003097          	auipc	ra,0x3
    314a:	c5e080e7          	jalr	-930(ra) # 5da4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    314e:	85a6                	mv	a1,s1
    3150:	00004517          	auipc	a0,0x4
    3154:	1d850513          	add	a0,a0,472 # 7328 <malloc+0x1154>
    3158:	00003097          	auipc	ra,0x3
    315c:	fc4080e7          	jalr	-60(ra) # 611c <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00003097          	auipc	ra,0x3
    3166:	c42080e7          	jalr	-958(ra) # 5da4 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    316a:	85a6                	mv	a1,s1
    316c:	00004517          	auipc	a0,0x4
    3170:	22450513          	add	a0,a0,548 # 7390 <malloc+0x11bc>
    3174:	00003097          	auipc	ra,0x3
    3178:	fa8080e7          	jalr	-88(ra) # 611c <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00003097          	auipc	ra,0x3
    3182:	c26080e7          	jalr	-986(ra) # 5da4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3186:	85a6                	mv	a1,s1
    3188:	00004517          	auipc	a0,0x4
    318c:	28050513          	add	a0,a0,640 # 7408 <malloc+0x1234>
    3190:	00003097          	auipc	ra,0x3
    3194:	f8c080e7          	jalr	-116(ra) # 611c <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00003097          	auipc	ra,0x3
    319e:	c0a080e7          	jalr	-1014(ra) # 5da4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31a2:	85a6                	mv	a1,s1
    31a4:	00004517          	auipc	a0,0x4
    31a8:	2c450513          	add	a0,a0,708 # 7468 <malloc+0x1294>
    31ac:	00003097          	auipc	ra,0x3
    31b0:	f70080e7          	jalr	-144(ra) # 611c <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00003097          	auipc	ra,0x3
    31ba:	bee080e7          	jalr	-1042(ra) # 5da4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31be:	85a6                	mv	a1,s1
    31c0:	00004517          	auipc	a0,0x4
    31c4:	30050513          	add	a0,a0,768 # 74c0 <malloc+0x12ec>
    31c8:	00003097          	auipc	ra,0x3
    31cc:	f54080e7          	jalr	-172(ra) # 611c <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00003097          	auipc	ra,0x3
    31d6:	bd2080e7          	jalr	-1070(ra) # 5da4 <exit>

00000000000031da <diskfull>:
{
    31da:	b9010113          	add	sp,sp,-1136
    31de:	46113423          	sd	ra,1128(sp)
    31e2:	46813023          	sd	s0,1120(sp)
    31e6:	44913c23          	sd	s1,1112(sp)
    31ea:	45213823          	sd	s2,1104(sp)
    31ee:	45313423          	sd	s3,1096(sp)
    31f2:	45413023          	sd	s4,1088(sp)
    31f6:	43513c23          	sd	s5,1080(sp)
    31fa:	43613823          	sd	s6,1072(sp)
    31fe:	43713423          	sd	s7,1064(sp)
    3202:	43813023          	sd	s8,1056(sp)
    3206:	47010413          	add	s0,sp,1136
    320a:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    320c:	00004517          	auipc	a0,0x4
    3210:	2ec50513          	add	a0,a0,748 # 74f8 <malloc+0x1324>
    3214:	00003097          	auipc	ra,0x3
    3218:	bf0080e7          	jalr	-1040(ra) # 5e04 <unlink>
  for(fi = 0; done == 0; fi++){
    321c:	4a01                	li	s4,0
    name[0] = 'b';
    321e:	06200b93          	li	s7,98
    name[1] = 'i';
    3222:	06900b13          	li	s6,105
    name[2] = 'g';
    3226:	06700a93          	li	s5,103
    322a:	69c1                	lui	s3,0x10
    322c:	10b98993          	add	s3,s3,267 # 1010b <base+0x493>
    3230:	aabd                	j	33ae <diskfull+0x1d4>
      printf("%s: could not create file %s\n", s, name);
    3232:	b9040613          	add	a2,s0,-1136
    3236:	85e2                	mv	a1,s8
    3238:	00004517          	auipc	a0,0x4
    323c:	2d050513          	add	a0,a0,720 # 7508 <malloc+0x1334>
    3240:	00003097          	auipc	ra,0x3
    3244:	edc080e7          	jalr	-292(ra) # 611c <printf>
      break;
    3248:	a821                	j	3260 <diskfull+0x86>
        close(fd);
    324a:	854a                	mv	a0,s2
    324c:	00003097          	auipc	ra,0x3
    3250:	b80080e7          	jalr	-1152(ra) # 5dcc <close>
    close(fd);
    3254:	854a                	mv	a0,s2
    3256:	00003097          	auipc	ra,0x3
    325a:	b76080e7          	jalr	-1162(ra) # 5dcc <close>
  for(fi = 0; done == 0; fi++){
    325e:	2a05                	addw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    3260:	4481                	li	s1,0
    name[0] = 'z';
    3262:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3266:	08000993          	li	s3,128
    name[0] = 'z';
    326a:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    326e:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3272:	41f4d71b          	sraw	a4,s1,0x1f
    3276:	01b7571b          	srlw	a4,a4,0x1b
    327a:	009707bb          	addw	a5,a4,s1
    327e:	4057d69b          	sraw	a3,a5,0x5
    3282:	0306869b          	addw	a3,a3,48
    3286:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    328a:	8bfd                	and	a5,a5,31
    328c:	9f99                	subw	a5,a5,a4
    328e:	0307879b          	addw	a5,a5,48
    3292:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3296:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    329a:	bb040513          	add	a0,s0,-1104
    329e:	00003097          	auipc	ra,0x3
    32a2:	b66080e7          	jalr	-1178(ra) # 5e04 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32a6:	60200593          	li	a1,1538
    32aa:	bb040513          	add	a0,s0,-1104
    32ae:	00003097          	auipc	ra,0x3
    32b2:	b46080e7          	jalr	-1210(ra) # 5df4 <open>
    if(fd < 0)
    32b6:	00054963          	bltz	a0,32c8 <diskfull+0xee>
    close(fd);
    32ba:	00003097          	auipc	ra,0x3
    32be:	b12080e7          	jalr	-1262(ra) # 5dcc <close>
  for(int i = 0; i < nzz; i++){
    32c2:	2485                	addw	s1,s1,1
    32c4:	fb3493e3          	bne	s1,s3,326a <diskfull+0x90>
  if(mkdir("diskfulldir") == 0)
    32c8:	00004517          	auipc	a0,0x4
    32cc:	23050513          	add	a0,a0,560 # 74f8 <malloc+0x1324>
    32d0:	00003097          	auipc	ra,0x3
    32d4:	b4c080e7          	jalr	-1204(ra) # 5e1c <mkdir>
    32d8:	12050963          	beqz	a0,340a <diskfull+0x230>
  unlink("diskfulldir");
    32dc:	00004517          	auipc	a0,0x4
    32e0:	21c50513          	add	a0,a0,540 # 74f8 <malloc+0x1324>
    32e4:	00003097          	auipc	ra,0x3
    32e8:	b20080e7          	jalr	-1248(ra) # 5e04 <unlink>
  for(int i = 0; i < nzz; i++){
    32ec:	4481                	li	s1,0
    name[0] = 'z';
    32ee:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32f2:	08000993          	li	s3,128
    name[0] = 'z';
    32f6:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32fa:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32fe:	41f4d71b          	sraw	a4,s1,0x1f
    3302:	01b7571b          	srlw	a4,a4,0x1b
    3306:	009707bb          	addw	a5,a4,s1
    330a:	4057d69b          	sraw	a3,a5,0x5
    330e:	0306869b          	addw	a3,a3,48
    3312:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3316:	8bfd                	and	a5,a5,31
    3318:	9f99                	subw	a5,a5,a4
    331a:	0307879b          	addw	a5,a5,48
    331e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3322:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3326:	bb040513          	add	a0,s0,-1104
    332a:	00003097          	auipc	ra,0x3
    332e:	ada080e7          	jalr	-1318(ra) # 5e04 <unlink>
  for(int i = 0; i < nzz; i++){
    3332:	2485                	addw	s1,s1,1
    3334:	fd3491e3          	bne	s1,s3,32f6 <diskfull+0x11c>
  for(int i = 0; i < fi; i++){
    3338:	03405e63          	blez	s4,3374 <diskfull+0x19a>
    333c:	4481                	li	s1,0
    name[0] = 'b';
    333e:	06200a93          	li	s5,98
    name[1] = 'i';
    3342:	06900993          	li	s3,105
    name[2] = 'g';
    3346:	06700913          	li	s2,103
    name[0] = 'b';
    334a:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    334e:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3352:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3356:	0304879b          	addw	a5,s1,48
    335a:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    335e:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3362:	bb040513          	add	a0,s0,-1104
    3366:	00003097          	auipc	ra,0x3
    336a:	a9e080e7          	jalr	-1378(ra) # 5e04 <unlink>
  for(int i = 0; i < fi; i++){
    336e:	2485                	addw	s1,s1,1
    3370:	fd449de3          	bne	s1,s4,334a <diskfull+0x170>
}
    3374:	46813083          	ld	ra,1128(sp)
    3378:	46013403          	ld	s0,1120(sp)
    337c:	45813483          	ld	s1,1112(sp)
    3380:	45013903          	ld	s2,1104(sp)
    3384:	44813983          	ld	s3,1096(sp)
    3388:	44013a03          	ld	s4,1088(sp)
    338c:	43813a83          	ld	s5,1080(sp)
    3390:	43013b03          	ld	s6,1072(sp)
    3394:	42813b83          	ld	s7,1064(sp)
    3398:	42013c03          	ld	s8,1056(sp)
    339c:	47010113          	add	sp,sp,1136
    33a0:	8082                	ret
    close(fd);
    33a2:	854a                	mv	a0,s2
    33a4:	00003097          	auipc	ra,0x3
    33a8:	a28080e7          	jalr	-1496(ra) # 5dcc <close>
  for(fi = 0; done == 0; fi++){
    33ac:	2a05                	addw	s4,s4,1
    name[0] = 'b';
    33ae:	b9740823          	sb	s7,-1136(s0)
    name[1] = 'i';
    33b2:	b96408a3          	sb	s6,-1135(s0)
    name[2] = 'g';
    33b6:	b9540923          	sb	s5,-1134(s0)
    name[3] = '0' + fi;
    33ba:	030a079b          	addw	a5,s4,48
    33be:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33c2:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33c6:	b9040513          	add	a0,s0,-1136
    33ca:	00003097          	auipc	ra,0x3
    33ce:	a3a080e7          	jalr	-1478(ra) # 5e04 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33d2:	60200593          	li	a1,1538
    33d6:	b9040513          	add	a0,s0,-1136
    33da:	00003097          	auipc	ra,0x3
    33de:	a1a080e7          	jalr	-1510(ra) # 5df4 <open>
    33e2:	892a                	mv	s2,a0
    if(fd < 0){
    33e4:	e40547e3          	bltz	a0,3232 <diskfull+0x58>
    33e8:	84ce                	mv	s1,s3
      if(write(fd, buf, BSIZE) != BSIZE){
    33ea:	40000613          	li	a2,1024
    33ee:	bb040593          	add	a1,s0,-1104
    33f2:	854a                	mv	a0,s2
    33f4:	00003097          	auipc	ra,0x3
    33f8:	9d0080e7          	jalr	-1584(ra) # 5dc4 <write>
    33fc:	40000793          	li	a5,1024
    3400:	e4f515e3          	bne	a0,a5,324a <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    3404:	34fd                	addw	s1,s1,-1
    3406:	f0f5                	bnez	s1,33ea <diskfull+0x210>
    3408:	bf69                	j	33a2 <diskfull+0x1c8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    340a:	00004517          	auipc	a0,0x4
    340e:	11e50513          	add	a0,a0,286 # 7528 <malloc+0x1354>
    3412:	00003097          	auipc	ra,0x3
    3416:	d0a080e7          	jalr	-758(ra) # 611c <printf>
    341a:	b5c9                	j	32dc <diskfull+0x102>

000000000000341c <iputtest>:
{
    341c:	1101                	add	sp,sp,-32
    341e:	ec06                	sd	ra,24(sp)
    3420:	e822                	sd	s0,16(sp)
    3422:	e426                	sd	s1,8(sp)
    3424:	1000                	add	s0,sp,32
    3426:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3428:	00004517          	auipc	a0,0x4
    342c:	13050513          	add	a0,a0,304 # 7558 <malloc+0x1384>
    3430:	00003097          	auipc	ra,0x3
    3434:	9ec080e7          	jalr	-1556(ra) # 5e1c <mkdir>
    3438:	04054563          	bltz	a0,3482 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    343c:	00004517          	auipc	a0,0x4
    3440:	11c50513          	add	a0,a0,284 # 7558 <malloc+0x1384>
    3444:	00003097          	auipc	ra,0x3
    3448:	9e0080e7          	jalr	-1568(ra) # 5e24 <chdir>
    344c:	04054963          	bltz	a0,349e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3450:	00004517          	auipc	a0,0x4
    3454:	14850513          	add	a0,a0,328 # 7598 <malloc+0x13c4>
    3458:	00003097          	auipc	ra,0x3
    345c:	9ac080e7          	jalr	-1620(ra) # 5e04 <unlink>
    3460:	04054d63          	bltz	a0,34ba <iputtest+0x9e>
  if(chdir("/") < 0){
    3464:	00004517          	auipc	a0,0x4
    3468:	16450513          	add	a0,a0,356 # 75c8 <malloc+0x13f4>
    346c:	00003097          	auipc	ra,0x3
    3470:	9b8080e7          	jalr	-1608(ra) # 5e24 <chdir>
    3474:	06054163          	bltz	a0,34d6 <iputtest+0xba>
}
    3478:	60e2                	ld	ra,24(sp)
    347a:	6442                	ld	s0,16(sp)
    347c:	64a2                	ld	s1,8(sp)
    347e:	6105                	add	sp,sp,32
    3480:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3482:	85a6                	mv	a1,s1
    3484:	00004517          	auipc	a0,0x4
    3488:	0dc50513          	add	a0,a0,220 # 7560 <malloc+0x138c>
    348c:	00003097          	auipc	ra,0x3
    3490:	c90080e7          	jalr	-880(ra) # 611c <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00003097          	auipc	ra,0x3
    349a:	90e080e7          	jalr	-1778(ra) # 5da4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    349e:	85a6                	mv	a1,s1
    34a0:	00004517          	auipc	a0,0x4
    34a4:	0d850513          	add	a0,a0,216 # 7578 <malloc+0x13a4>
    34a8:	00003097          	auipc	ra,0x3
    34ac:	c74080e7          	jalr	-908(ra) # 611c <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00003097          	auipc	ra,0x3
    34b6:	8f2080e7          	jalr	-1806(ra) # 5da4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34ba:	85a6                	mv	a1,s1
    34bc:	00004517          	auipc	a0,0x4
    34c0:	0ec50513          	add	a0,a0,236 # 75a8 <malloc+0x13d4>
    34c4:	00003097          	auipc	ra,0x3
    34c8:	c58080e7          	jalr	-936(ra) # 611c <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00003097          	auipc	ra,0x3
    34d2:	8d6080e7          	jalr	-1834(ra) # 5da4 <exit>
    printf("%s: chdir / failed\n", s);
    34d6:	85a6                	mv	a1,s1
    34d8:	00004517          	auipc	a0,0x4
    34dc:	0f850513          	add	a0,a0,248 # 75d0 <malloc+0x13fc>
    34e0:	00003097          	auipc	ra,0x3
    34e4:	c3c080e7          	jalr	-964(ra) # 611c <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00003097          	auipc	ra,0x3
    34ee:	8ba080e7          	jalr	-1862(ra) # 5da4 <exit>

00000000000034f2 <exitiputtest>:
{
    34f2:	7179                	add	sp,sp,-48
    34f4:	f406                	sd	ra,40(sp)
    34f6:	f022                	sd	s0,32(sp)
    34f8:	ec26                	sd	s1,24(sp)
    34fa:	1800                	add	s0,sp,48
    34fc:	84aa                	mv	s1,a0
  pid = fork();
    34fe:	00003097          	auipc	ra,0x3
    3502:	89e080e7          	jalr	-1890(ra) # 5d9c <fork>
  if(pid < 0){
    3506:	04054663          	bltz	a0,3552 <exitiputtest+0x60>
  if(pid == 0){
    350a:	ed45                	bnez	a0,35c2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    350c:	00004517          	auipc	a0,0x4
    3510:	04c50513          	add	a0,a0,76 # 7558 <malloc+0x1384>
    3514:	00003097          	auipc	ra,0x3
    3518:	908080e7          	jalr	-1784(ra) # 5e1c <mkdir>
    351c:	04054963          	bltz	a0,356e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3520:	00004517          	auipc	a0,0x4
    3524:	03850513          	add	a0,a0,56 # 7558 <malloc+0x1384>
    3528:	00003097          	auipc	ra,0x3
    352c:	8fc080e7          	jalr	-1796(ra) # 5e24 <chdir>
    3530:	04054d63          	bltz	a0,358a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3534:	00004517          	auipc	a0,0x4
    3538:	06450513          	add	a0,a0,100 # 7598 <malloc+0x13c4>
    353c:	00003097          	auipc	ra,0x3
    3540:	8c8080e7          	jalr	-1848(ra) # 5e04 <unlink>
    3544:	06054163          	bltz	a0,35a6 <exitiputtest+0xb4>
    exit(0);
    3548:	4501                	li	a0,0
    354a:	00003097          	auipc	ra,0x3
    354e:	85a080e7          	jalr	-1958(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    3552:	85a6                	mv	a1,s1
    3554:	00003517          	auipc	a0,0x3
    3558:	64450513          	add	a0,a0,1604 # 6b98 <malloc+0x9c4>
    355c:	00003097          	auipc	ra,0x3
    3560:	bc0080e7          	jalr	-1088(ra) # 611c <printf>
    exit(1);
    3564:	4505                	li	a0,1
    3566:	00003097          	auipc	ra,0x3
    356a:	83e080e7          	jalr	-1986(ra) # 5da4 <exit>
      printf("%s: mkdir failed\n", s);
    356e:	85a6                	mv	a1,s1
    3570:	00004517          	auipc	a0,0x4
    3574:	ff050513          	add	a0,a0,-16 # 7560 <malloc+0x138c>
    3578:	00003097          	auipc	ra,0x3
    357c:	ba4080e7          	jalr	-1116(ra) # 611c <printf>
      exit(1);
    3580:	4505                	li	a0,1
    3582:	00003097          	auipc	ra,0x3
    3586:	822080e7          	jalr	-2014(ra) # 5da4 <exit>
      printf("%s: child chdir failed\n", s);
    358a:	85a6                	mv	a1,s1
    358c:	00004517          	auipc	a0,0x4
    3590:	05c50513          	add	a0,a0,92 # 75e8 <malloc+0x1414>
    3594:	00003097          	auipc	ra,0x3
    3598:	b88080e7          	jalr	-1144(ra) # 611c <printf>
      exit(1);
    359c:	4505                	li	a0,1
    359e:	00003097          	auipc	ra,0x3
    35a2:	806080e7          	jalr	-2042(ra) # 5da4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35a6:	85a6                	mv	a1,s1
    35a8:	00004517          	auipc	a0,0x4
    35ac:	00050513          	mv	a0,a0
    35b0:	00003097          	auipc	ra,0x3
    35b4:	b6c080e7          	jalr	-1172(ra) # 611c <printf>
      exit(1);
    35b8:	4505                	li	a0,1
    35ba:	00002097          	auipc	ra,0x2
    35be:	7ea080e7          	jalr	2026(ra) # 5da4 <exit>
  wait(&xstatus);
    35c2:	fdc40513          	add	a0,s0,-36
    35c6:	00002097          	auipc	ra,0x2
    35ca:	7e6080e7          	jalr	2022(ra) # 5dac <wait>
  exit(xstatus);
    35ce:	fdc42503          	lw	a0,-36(s0)
    35d2:	00002097          	auipc	ra,0x2
    35d6:	7d2080e7          	jalr	2002(ra) # 5da4 <exit>

00000000000035da <dirtest>:
{
    35da:	1101                	add	sp,sp,-32
    35dc:	ec06                	sd	ra,24(sp)
    35de:	e822                	sd	s0,16(sp)
    35e0:	e426                	sd	s1,8(sp)
    35e2:	1000                	add	s0,sp,32
    35e4:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35e6:	00004517          	auipc	a0,0x4
    35ea:	01a50513          	add	a0,a0,26 # 7600 <malloc+0x142c>
    35ee:	00003097          	auipc	ra,0x3
    35f2:	82e080e7          	jalr	-2002(ra) # 5e1c <mkdir>
    35f6:	04054563          	bltz	a0,3640 <dirtest+0x66>
  if(chdir("dir0") < 0){
    35fa:	00004517          	auipc	a0,0x4
    35fe:	00650513          	add	a0,a0,6 # 7600 <malloc+0x142c>
    3602:	00003097          	auipc	ra,0x3
    3606:	822080e7          	jalr	-2014(ra) # 5e24 <chdir>
    360a:	04054963          	bltz	a0,365c <dirtest+0x82>
  if(chdir("..") < 0){
    360e:	00004517          	auipc	a0,0x4
    3612:	01250513          	add	a0,a0,18 # 7620 <malloc+0x144c>
    3616:	00003097          	auipc	ra,0x3
    361a:	80e080e7          	jalr	-2034(ra) # 5e24 <chdir>
    361e:	04054d63          	bltz	a0,3678 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3622:	00004517          	auipc	a0,0x4
    3626:	fde50513          	add	a0,a0,-34 # 7600 <malloc+0x142c>
    362a:	00002097          	auipc	ra,0x2
    362e:	7da080e7          	jalr	2010(ra) # 5e04 <unlink>
    3632:	06054163          	bltz	a0,3694 <dirtest+0xba>
}
    3636:	60e2                	ld	ra,24(sp)
    3638:	6442                	ld	s0,16(sp)
    363a:	64a2                	ld	s1,8(sp)
    363c:	6105                	add	sp,sp,32
    363e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3640:	85a6                	mv	a1,s1
    3642:	00004517          	auipc	a0,0x4
    3646:	f1e50513          	add	a0,a0,-226 # 7560 <malloc+0x138c>
    364a:	00003097          	auipc	ra,0x3
    364e:	ad2080e7          	jalr	-1326(ra) # 611c <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	750080e7          	jalr	1872(ra) # 5da4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    365c:	85a6                	mv	a1,s1
    365e:	00004517          	auipc	a0,0x4
    3662:	faa50513          	add	a0,a0,-86 # 7608 <malloc+0x1434>
    3666:	00003097          	auipc	ra,0x3
    366a:	ab6080e7          	jalr	-1354(ra) # 611c <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	734080e7          	jalr	1844(ra) # 5da4 <exit>
    printf("%s: chdir .. failed\n", s);
    3678:	85a6                	mv	a1,s1
    367a:	00004517          	auipc	a0,0x4
    367e:	fae50513          	add	a0,a0,-82 # 7628 <malloc+0x1454>
    3682:	00003097          	auipc	ra,0x3
    3686:	a9a080e7          	jalr	-1382(ra) # 611c <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	718080e7          	jalr	1816(ra) # 5da4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3694:	85a6                	mv	a1,s1
    3696:	00004517          	auipc	a0,0x4
    369a:	faa50513          	add	a0,a0,-86 # 7640 <malloc+0x146c>
    369e:	00003097          	auipc	ra,0x3
    36a2:	a7e080e7          	jalr	-1410(ra) # 611c <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	6fc080e7          	jalr	1788(ra) # 5da4 <exit>

00000000000036b0 <subdir>:
{
    36b0:	1101                	add	sp,sp,-32
    36b2:	ec06                	sd	ra,24(sp)
    36b4:	e822                	sd	s0,16(sp)
    36b6:	e426                	sd	s1,8(sp)
    36b8:	e04a                	sd	s2,0(sp)
    36ba:	1000                	add	s0,sp,32
    36bc:	892a                	mv	s2,a0
  unlink("ff");
    36be:	00004517          	auipc	a0,0x4
    36c2:	0ca50513          	add	a0,a0,202 # 7788 <malloc+0x15b4>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	73e080e7          	jalr	1854(ra) # 5e04 <unlink>
  if(mkdir("dd") != 0){
    36ce:	00004517          	auipc	a0,0x4
    36d2:	f8a50513          	add	a0,a0,-118 # 7658 <malloc+0x1484>
    36d6:	00002097          	auipc	ra,0x2
    36da:	746080e7          	jalr	1862(ra) # 5e1c <mkdir>
    36de:	38051663          	bnez	a0,3a6a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36e2:	20200593          	li	a1,514
    36e6:	00004517          	auipc	a0,0x4
    36ea:	f9250513          	add	a0,a0,-110 # 7678 <malloc+0x14a4>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	706080e7          	jalr	1798(ra) # 5df4 <open>
    36f6:	84aa                	mv	s1,a0
  if(fd < 0){
    36f8:	38054763          	bltz	a0,3a86 <subdir+0x3d6>
  write(fd, "ff", 2);
    36fc:	4609                	li	a2,2
    36fe:	00004597          	auipc	a1,0x4
    3702:	08a58593          	add	a1,a1,138 # 7788 <malloc+0x15b4>
    3706:	00002097          	auipc	ra,0x2
    370a:	6be080e7          	jalr	1726(ra) # 5dc4 <write>
  close(fd);
    370e:	8526                	mv	a0,s1
    3710:	00002097          	auipc	ra,0x2
    3714:	6bc080e7          	jalr	1724(ra) # 5dcc <close>
  if(unlink("dd") >= 0){
    3718:	00004517          	auipc	a0,0x4
    371c:	f4050513          	add	a0,a0,-192 # 7658 <malloc+0x1484>
    3720:	00002097          	auipc	ra,0x2
    3724:	6e4080e7          	jalr	1764(ra) # 5e04 <unlink>
    3728:	36055d63          	bgez	a0,3aa2 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    372c:	00004517          	auipc	a0,0x4
    3730:	fa450513          	add	a0,a0,-92 # 76d0 <malloc+0x14fc>
    3734:	00002097          	auipc	ra,0x2
    3738:	6e8080e7          	jalr	1768(ra) # 5e1c <mkdir>
    373c:	38051163          	bnez	a0,3abe <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3740:	20200593          	li	a1,514
    3744:	00004517          	auipc	a0,0x4
    3748:	fb450513          	add	a0,a0,-76 # 76f8 <malloc+0x1524>
    374c:	00002097          	auipc	ra,0x2
    3750:	6a8080e7          	jalr	1704(ra) # 5df4 <open>
    3754:	84aa                	mv	s1,a0
  if(fd < 0){
    3756:	38054263          	bltz	a0,3ada <subdir+0x42a>
  write(fd, "FF", 2);
    375a:	4609                	li	a2,2
    375c:	00004597          	auipc	a1,0x4
    3760:	fcc58593          	add	a1,a1,-52 # 7728 <malloc+0x1554>
    3764:	00002097          	auipc	ra,0x2
    3768:	660080e7          	jalr	1632(ra) # 5dc4 <write>
  close(fd);
    376c:	8526                	mv	a0,s1
    376e:	00002097          	auipc	ra,0x2
    3772:	65e080e7          	jalr	1630(ra) # 5dcc <close>
  fd = open("dd/dd/../ff", 0);
    3776:	4581                	li	a1,0
    3778:	00004517          	auipc	a0,0x4
    377c:	fb850513          	add	a0,a0,-72 # 7730 <malloc+0x155c>
    3780:	00002097          	auipc	ra,0x2
    3784:	674080e7          	jalr	1652(ra) # 5df4 <open>
    3788:	84aa                	mv	s1,a0
  if(fd < 0){
    378a:	36054663          	bltz	a0,3af6 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    378e:	660d                	lui	a2,0x3
    3790:	00009597          	auipc	a1,0x9
    3794:	4e858593          	add	a1,a1,1256 # cc78 <buf>
    3798:	00002097          	auipc	ra,0x2
    379c:	624080e7          	jalr	1572(ra) # 5dbc <read>
  if(cc != 2 || buf[0] != 'f'){
    37a0:	4789                	li	a5,2
    37a2:	36f51863          	bne	a0,a5,3b12 <subdir+0x462>
    37a6:	00009717          	auipc	a4,0x9
    37aa:	4d274703          	lbu	a4,1234(a4) # cc78 <buf>
    37ae:	06600793          	li	a5,102
    37b2:	36f71063          	bne	a4,a5,3b12 <subdir+0x462>
  close(fd);
    37b6:	8526                	mv	a0,s1
    37b8:	00002097          	auipc	ra,0x2
    37bc:	614080e7          	jalr	1556(ra) # 5dcc <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37c0:	00004597          	auipc	a1,0x4
    37c4:	fc058593          	add	a1,a1,-64 # 7780 <malloc+0x15ac>
    37c8:	00004517          	auipc	a0,0x4
    37cc:	f3050513          	add	a0,a0,-208 # 76f8 <malloc+0x1524>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	644080e7          	jalr	1604(ra) # 5e14 <link>
    37d8:	34051b63          	bnez	a0,3b2e <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37dc:	00004517          	auipc	a0,0x4
    37e0:	f1c50513          	add	a0,a0,-228 # 76f8 <malloc+0x1524>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	620080e7          	jalr	1568(ra) # 5e04 <unlink>
    37ec:	34051f63          	bnez	a0,3b4a <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37f0:	4581                	li	a1,0
    37f2:	00004517          	auipc	a0,0x4
    37f6:	f0650513          	add	a0,a0,-250 # 76f8 <malloc+0x1524>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	5fa080e7          	jalr	1530(ra) # 5df4 <open>
    3802:	36055263          	bgez	a0,3b66 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3806:	00004517          	auipc	a0,0x4
    380a:	e5250513          	add	a0,a0,-430 # 7658 <malloc+0x1484>
    380e:	00002097          	auipc	ra,0x2
    3812:	616080e7          	jalr	1558(ra) # 5e24 <chdir>
    3816:	36051663          	bnez	a0,3b82 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    381a:	00004517          	auipc	a0,0x4
    381e:	ffe50513          	add	a0,a0,-2 # 7818 <malloc+0x1644>
    3822:	00002097          	auipc	ra,0x2
    3826:	602080e7          	jalr	1538(ra) # 5e24 <chdir>
    382a:	36051a63          	bnez	a0,3b9e <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    382e:	00004517          	auipc	a0,0x4
    3832:	01a50513          	add	a0,a0,26 # 7848 <malloc+0x1674>
    3836:	00002097          	auipc	ra,0x2
    383a:	5ee080e7          	jalr	1518(ra) # 5e24 <chdir>
    383e:	36051e63          	bnez	a0,3bba <subdir+0x50a>
  if(chdir("./..") != 0){
    3842:	00004517          	auipc	a0,0x4
    3846:	03650513          	add	a0,a0,54 # 7878 <malloc+0x16a4>
    384a:	00002097          	auipc	ra,0x2
    384e:	5da080e7          	jalr	1498(ra) # 5e24 <chdir>
    3852:	38051263          	bnez	a0,3bd6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3856:	4581                	li	a1,0
    3858:	00004517          	auipc	a0,0x4
    385c:	f2850513          	add	a0,a0,-216 # 7780 <malloc+0x15ac>
    3860:	00002097          	auipc	ra,0x2
    3864:	594080e7          	jalr	1428(ra) # 5df4 <open>
    3868:	84aa                	mv	s1,a0
  if(fd < 0){
    386a:	38054463          	bltz	a0,3bf2 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    386e:	660d                	lui	a2,0x3
    3870:	00009597          	auipc	a1,0x9
    3874:	40858593          	add	a1,a1,1032 # cc78 <buf>
    3878:	00002097          	auipc	ra,0x2
    387c:	544080e7          	jalr	1348(ra) # 5dbc <read>
    3880:	4789                	li	a5,2
    3882:	38f51663          	bne	a0,a5,3c0e <subdir+0x55e>
  close(fd);
    3886:	8526                	mv	a0,s1
    3888:	00002097          	auipc	ra,0x2
    388c:	544080e7          	jalr	1348(ra) # 5dcc <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3890:	4581                	li	a1,0
    3892:	00004517          	auipc	a0,0x4
    3896:	e6650513          	add	a0,a0,-410 # 76f8 <malloc+0x1524>
    389a:	00002097          	auipc	ra,0x2
    389e:	55a080e7          	jalr	1370(ra) # 5df4 <open>
    38a2:	38055463          	bgez	a0,3c2a <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38a6:	20200593          	li	a1,514
    38aa:	00004517          	auipc	a0,0x4
    38ae:	05e50513          	add	a0,a0,94 # 7908 <malloc+0x1734>
    38b2:	00002097          	auipc	ra,0x2
    38b6:	542080e7          	jalr	1346(ra) # 5df4 <open>
    38ba:	38055663          	bgez	a0,3c46 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38be:	20200593          	li	a1,514
    38c2:	00004517          	auipc	a0,0x4
    38c6:	07650513          	add	a0,a0,118 # 7938 <malloc+0x1764>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	52a080e7          	jalr	1322(ra) # 5df4 <open>
    38d2:	38055863          	bgez	a0,3c62 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38d6:	20000593          	li	a1,512
    38da:	00004517          	auipc	a0,0x4
    38de:	d7e50513          	add	a0,a0,-642 # 7658 <malloc+0x1484>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	512080e7          	jalr	1298(ra) # 5df4 <open>
    38ea:	38055a63          	bgez	a0,3c7e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38ee:	4589                	li	a1,2
    38f0:	00004517          	auipc	a0,0x4
    38f4:	d6850513          	add	a0,a0,-664 # 7658 <malloc+0x1484>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	4fc080e7          	jalr	1276(ra) # 5df4 <open>
    3900:	38055d63          	bgez	a0,3c9a <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3904:	4585                	li	a1,1
    3906:	00004517          	auipc	a0,0x4
    390a:	d5250513          	add	a0,a0,-686 # 7658 <malloc+0x1484>
    390e:	00002097          	auipc	ra,0x2
    3912:	4e6080e7          	jalr	1254(ra) # 5df4 <open>
    3916:	3a055063          	bgez	a0,3cb6 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    391a:	00004597          	auipc	a1,0x4
    391e:	0ae58593          	add	a1,a1,174 # 79c8 <malloc+0x17f4>
    3922:	00004517          	auipc	a0,0x4
    3926:	fe650513          	add	a0,a0,-26 # 7908 <malloc+0x1734>
    392a:	00002097          	auipc	ra,0x2
    392e:	4ea080e7          	jalr	1258(ra) # 5e14 <link>
    3932:	3a050063          	beqz	a0,3cd2 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3936:	00004597          	auipc	a1,0x4
    393a:	09258593          	add	a1,a1,146 # 79c8 <malloc+0x17f4>
    393e:	00004517          	auipc	a0,0x4
    3942:	ffa50513          	add	a0,a0,-6 # 7938 <malloc+0x1764>
    3946:	00002097          	auipc	ra,0x2
    394a:	4ce080e7          	jalr	1230(ra) # 5e14 <link>
    394e:	3a050063          	beqz	a0,3cee <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3952:	00004597          	auipc	a1,0x4
    3956:	e2e58593          	add	a1,a1,-466 # 7780 <malloc+0x15ac>
    395a:	00004517          	auipc	a0,0x4
    395e:	d1e50513          	add	a0,a0,-738 # 7678 <malloc+0x14a4>
    3962:	00002097          	auipc	ra,0x2
    3966:	4b2080e7          	jalr	1202(ra) # 5e14 <link>
    396a:	3a050063          	beqz	a0,3d0a <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    396e:	00004517          	auipc	a0,0x4
    3972:	f9a50513          	add	a0,a0,-102 # 7908 <malloc+0x1734>
    3976:	00002097          	auipc	ra,0x2
    397a:	4a6080e7          	jalr	1190(ra) # 5e1c <mkdir>
    397e:	3a050463          	beqz	a0,3d26 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3982:	00004517          	auipc	a0,0x4
    3986:	fb650513          	add	a0,a0,-74 # 7938 <malloc+0x1764>
    398a:	00002097          	auipc	ra,0x2
    398e:	492080e7          	jalr	1170(ra) # 5e1c <mkdir>
    3992:	3a050863          	beqz	a0,3d42 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3996:	00004517          	auipc	a0,0x4
    399a:	dea50513          	add	a0,a0,-534 # 7780 <malloc+0x15ac>
    399e:	00002097          	auipc	ra,0x2
    39a2:	47e080e7          	jalr	1150(ra) # 5e1c <mkdir>
    39a6:	3a050c63          	beqz	a0,3d5e <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39aa:	00004517          	auipc	a0,0x4
    39ae:	f8e50513          	add	a0,a0,-114 # 7938 <malloc+0x1764>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	452080e7          	jalr	1106(ra) # 5e04 <unlink>
    39ba:	3c050063          	beqz	a0,3d7a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39be:	00004517          	auipc	a0,0x4
    39c2:	f4a50513          	add	a0,a0,-182 # 7908 <malloc+0x1734>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	43e080e7          	jalr	1086(ra) # 5e04 <unlink>
    39ce:	3c050463          	beqz	a0,3d96 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39d2:	00004517          	auipc	a0,0x4
    39d6:	ca650513          	add	a0,a0,-858 # 7678 <malloc+0x14a4>
    39da:	00002097          	auipc	ra,0x2
    39de:	44a080e7          	jalr	1098(ra) # 5e24 <chdir>
    39e2:	3c050863          	beqz	a0,3db2 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39e6:	00004517          	auipc	a0,0x4
    39ea:	13250513          	add	a0,a0,306 # 7b18 <malloc+0x1944>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	436080e7          	jalr	1078(ra) # 5e24 <chdir>
    39f6:	3c050c63          	beqz	a0,3dce <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39fa:	00004517          	auipc	a0,0x4
    39fe:	d8650513          	add	a0,a0,-634 # 7780 <malloc+0x15ac>
    3a02:	00002097          	auipc	ra,0x2
    3a06:	402080e7          	jalr	1026(ra) # 5e04 <unlink>
    3a0a:	3e051063          	bnez	a0,3dea <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a0e:	00004517          	auipc	a0,0x4
    3a12:	c6a50513          	add	a0,a0,-918 # 7678 <malloc+0x14a4>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	3ee080e7          	jalr	1006(ra) # 5e04 <unlink>
    3a1e:	3e051463          	bnez	a0,3e06 <subdir+0x756>
  if(unlink("dd") == 0){
    3a22:	00004517          	auipc	a0,0x4
    3a26:	c3650513          	add	a0,a0,-970 # 7658 <malloc+0x1484>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	3da080e7          	jalr	986(ra) # 5e04 <unlink>
    3a32:	3e050863          	beqz	a0,3e22 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a36:	00004517          	auipc	a0,0x4
    3a3a:	15250513          	add	a0,a0,338 # 7b88 <malloc+0x19b4>
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	3c6080e7          	jalr	966(ra) # 5e04 <unlink>
    3a46:	3e054c63          	bltz	a0,3e3e <subdir+0x78e>
  if(unlink("dd") < 0){
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	c0e50513          	add	a0,a0,-1010 # 7658 <malloc+0x1484>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	3b2080e7          	jalr	946(ra) # 5e04 <unlink>
    3a5a:	40054063          	bltz	a0,3e5a <subdir+0x7aa>
}
    3a5e:	60e2                	ld	ra,24(sp)
    3a60:	6442                	ld	s0,16(sp)
    3a62:	64a2                	ld	s1,8(sp)
    3a64:	6902                	ld	s2,0(sp)
    3a66:	6105                	add	sp,sp,32
    3a68:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a6a:	85ca                	mv	a1,s2
    3a6c:	00004517          	auipc	a0,0x4
    3a70:	bf450513          	add	a0,a0,-1036 # 7660 <malloc+0x148c>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	6a8080e7          	jalr	1704(ra) # 611c <printf>
    exit(1);
    3a7c:	4505                	li	a0,1
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	326080e7          	jalr	806(ra) # 5da4 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a86:	85ca                	mv	a1,s2
    3a88:	00004517          	auipc	a0,0x4
    3a8c:	bf850513          	add	a0,a0,-1032 # 7680 <malloc+0x14ac>
    3a90:	00002097          	auipc	ra,0x2
    3a94:	68c080e7          	jalr	1676(ra) # 611c <printf>
    exit(1);
    3a98:	4505                	li	a0,1
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	30a080e7          	jalr	778(ra) # 5da4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3aa2:	85ca                	mv	a1,s2
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	bfc50513          	add	a0,a0,-1028 # 76a0 <malloc+0x14cc>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	670080e7          	jalr	1648(ra) # 611c <printf>
    exit(1);
    3ab4:	4505                	li	a0,1
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	2ee080e7          	jalr	750(ra) # 5da4 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	c1850513          	add	a0,a0,-1000 # 76d8 <malloc+0x1504>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	654080e7          	jalr	1620(ra) # 611c <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	2d2080e7          	jalr	722(ra) # 5da4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	c2c50513          	add	a0,a0,-980 # 7708 <malloc+0x1534>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	638080e7          	jalr	1592(ra) # 611c <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	2b6080e7          	jalr	694(ra) # 5da4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	c4850513          	add	a0,a0,-952 # 7740 <malloc+0x156c>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	61c080e7          	jalr	1564(ra) # 611c <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	29a080e7          	jalr	666(ra) # 5da4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	c4c50513          	add	a0,a0,-948 # 7760 <malloc+0x158c>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	600080e7          	jalr	1536(ra) # 611c <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	27e080e7          	jalr	638(ra) # 5da4 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	c6050513          	add	a0,a0,-928 # 7790 <malloc+0x15bc>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	5e4080e7          	jalr	1508(ra) # 611c <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	262080e7          	jalr	610(ra) # 5da4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	c6c50513          	add	a0,a0,-916 # 77b8 <malloc+0x15e4>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	5c8080e7          	jalr	1480(ra) # 611c <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	246080e7          	jalr	582(ra) # 5da4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	c7050513          	add	a0,a0,-912 # 77d8 <malloc+0x1604>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	5ac080e7          	jalr	1452(ra) # 611c <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	22a080e7          	jalr	554(ra) # 5da4 <exit>
    printf("%s: chdir dd failed\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	c7c50513          	add	a0,a0,-900 # 7800 <malloc+0x162c>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	590080e7          	jalr	1424(ra) # 611c <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	20e080e7          	jalr	526(ra) # 5da4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	c8850513          	add	a0,a0,-888 # 7828 <malloc+0x1654>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	574080e7          	jalr	1396(ra) # 611c <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	1f2080e7          	jalr	498(ra) # 5da4 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	c9c50513          	add	a0,a0,-868 # 7858 <malloc+0x1684>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	558080e7          	jalr	1368(ra) # 611c <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	1d6080e7          	jalr	470(ra) # 5da4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bd6:	85ca                	mv	a1,s2
    3bd8:	00004517          	auipc	a0,0x4
    3bdc:	ca850513          	add	a0,a0,-856 # 7880 <malloc+0x16ac>
    3be0:	00002097          	auipc	ra,0x2
    3be4:	53c080e7          	jalr	1340(ra) # 611c <printf>
    exit(1);
    3be8:	4505                	li	a0,1
    3bea:	00002097          	auipc	ra,0x2
    3bee:	1ba080e7          	jalr	442(ra) # 5da4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	ca450513          	add	a0,a0,-860 # 7898 <malloc+0x16c4>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	520080e7          	jalr	1312(ra) # 611c <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	19e080e7          	jalr	414(ra) # 5da4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	ca850513          	add	a0,a0,-856 # 78b8 <malloc+0x16e4>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	504080e7          	jalr	1284(ra) # 611c <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	182080e7          	jalr	386(ra) # 5da4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	cac50513          	add	a0,a0,-852 # 78d8 <malloc+0x1704>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	4e8080e7          	jalr	1256(ra) # 611c <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	166080e7          	jalr	358(ra) # 5da4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	cd050513          	add	a0,a0,-816 # 7918 <malloc+0x1744>
    3c50:	00002097          	auipc	ra,0x2
    3c54:	4cc080e7          	jalr	1228(ra) # 611c <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	14a080e7          	jalr	330(ra) # 5da4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	ce450513          	add	a0,a0,-796 # 7948 <malloc+0x1774>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	4b0080e7          	jalr	1200(ra) # 611c <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	12e080e7          	jalr	302(ra) # 5da4 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	ce850513          	add	a0,a0,-792 # 7968 <malloc+0x1794>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	494080e7          	jalr	1172(ra) # 611c <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	112080e7          	jalr	274(ra) # 5da4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	cec50513          	add	a0,a0,-788 # 7988 <malloc+0x17b4>
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	478080e7          	jalr	1144(ra) # 611c <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	0f6080e7          	jalr	246(ra) # 5da4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	cf050513          	add	a0,a0,-784 # 79a8 <malloc+0x17d4>
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	45c080e7          	jalr	1116(ra) # 611c <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00002097          	auipc	ra,0x2
    3cce:	0da080e7          	jalr	218(ra) # 5da4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	d0450513          	add	a0,a0,-764 # 79d8 <malloc+0x1804>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	440080e7          	jalr	1088(ra) # 611c <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	0be080e7          	jalr	190(ra) # 5da4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	d1050513          	add	a0,a0,-752 # 7a00 <malloc+0x182c>
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	424080e7          	jalr	1060(ra) # 611c <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00002097          	auipc	ra,0x2
    3d06:	0a2080e7          	jalr	162(ra) # 5da4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	d1c50513          	add	a0,a0,-740 # 7a28 <malloc+0x1854>
    3d14:	00002097          	auipc	ra,0x2
    3d18:	408080e7          	jalr	1032(ra) # 611c <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	086080e7          	jalr	134(ra) # 5da4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	d2850513          	add	a0,a0,-728 # 7a50 <malloc+0x187c>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	3ec080e7          	jalr	1004(ra) # 611c <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	06a080e7          	jalr	106(ra) # 5da4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	d2c50513          	add	a0,a0,-724 # 7a70 <malloc+0x189c>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	3d0080e7          	jalr	976(ra) # 611c <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	04e080e7          	jalr	78(ra) # 5da4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	d3050513          	add	a0,a0,-720 # 7a90 <malloc+0x18bc>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	3b4080e7          	jalr	948(ra) # 611c <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00002097          	auipc	ra,0x2
    3d76:	032080e7          	jalr	50(ra) # 5da4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	d3c50513          	add	a0,a0,-708 # 7ab8 <malloc+0x18e4>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	398080e7          	jalr	920(ra) # 611c <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	016080e7          	jalr	22(ra) # 5da4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	d4050513          	add	a0,a0,-704 # 7ad8 <malloc+0x1904>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	37c080e7          	jalr	892(ra) # 611c <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	ffa080e7          	jalr	-6(ra) # 5da4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	d4450513          	add	a0,a0,-700 # 7af8 <malloc+0x1924>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	360080e7          	jalr	864(ra) # 611c <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	fde080e7          	jalr	-34(ra) # 5da4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	d5050513          	add	a0,a0,-688 # 7b20 <malloc+0x194c>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	344080e7          	jalr	836(ra) # 611c <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	fc2080e7          	jalr	-62(ra) # 5da4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00004517          	auipc	a0,0x4
    3df0:	9cc50513          	add	a0,a0,-1588 # 77b8 <malloc+0x15e4>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	328080e7          	jalr	808(ra) # 611c <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	fa6080e7          	jalr	-90(ra) # 5da4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e06:	85ca                	mv	a1,s2
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	d3850513          	add	a0,a0,-712 # 7b40 <malloc+0x196c>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	30c080e7          	jalr	780(ra) # 611c <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	f8a080e7          	jalr	-118(ra) # 5da4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e22:	85ca                	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	d3c50513          	add	a0,a0,-708 # 7b60 <malloc+0x198c>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	2f0080e7          	jalr	752(ra) # 611c <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	f6e080e7          	jalr	-146(ra) # 5da4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e3e:	85ca                	mv	a1,s2
    3e40:	00004517          	auipc	a0,0x4
    3e44:	d5050513          	add	a0,a0,-688 # 7b90 <malloc+0x19bc>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	2d4080e7          	jalr	724(ra) # 611c <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	f52080e7          	jalr	-174(ra) # 5da4 <exit>
    printf("%s: unlink dd failed\n", s);
    3e5a:	85ca                	mv	a1,s2
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	d5450513          	add	a0,a0,-684 # 7bb0 <malloc+0x19dc>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	2b8080e7          	jalr	696(ra) # 611c <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	f36080e7          	jalr	-202(ra) # 5da4 <exit>

0000000000003e76 <rmdot>:
{
    3e76:	1101                	add	sp,sp,-32
    3e78:	ec06                	sd	ra,24(sp)
    3e7a:	e822                	sd	s0,16(sp)
    3e7c:	e426                	sd	s1,8(sp)
    3e7e:	1000                	add	s0,sp,32
    3e80:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e82:	00004517          	auipc	a0,0x4
    3e86:	d4650513          	add	a0,a0,-698 # 7bc8 <malloc+0x19f4>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	f92080e7          	jalr	-110(ra) # 5e1c <mkdir>
    3e92:	e549                	bnez	a0,3f1c <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e94:	00004517          	auipc	a0,0x4
    3e98:	d3450513          	add	a0,a0,-716 # 7bc8 <malloc+0x19f4>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	f88080e7          	jalr	-120(ra) # 5e24 <chdir>
    3ea4:	e951                	bnez	a0,3f38 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	b5250513          	add	a0,a0,-1198 # 69f8 <malloc+0x824>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	f56080e7          	jalr	-170(ra) # 5e04 <unlink>
    3eb6:	cd59                	beqz	a0,3f54 <rmdot+0xde>
  if(unlink("..") == 0){
    3eb8:	00003517          	auipc	a0,0x3
    3ebc:	76850513          	add	a0,a0,1896 # 7620 <malloc+0x144c>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	f44080e7          	jalr	-188(ra) # 5e04 <unlink>
    3ec8:	c545                	beqz	a0,3f70 <rmdot+0xfa>
  if(chdir("/") != 0){
    3eca:	00003517          	auipc	a0,0x3
    3ece:	6fe50513          	add	a0,a0,1790 # 75c8 <malloc+0x13f4>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	f52080e7          	jalr	-174(ra) # 5e24 <chdir>
    3eda:	e94d                	bnez	a0,3f8c <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3edc:	00004517          	auipc	a0,0x4
    3ee0:	d5450513          	add	a0,a0,-684 # 7c30 <malloc+0x1a5c>
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	f20080e7          	jalr	-224(ra) # 5e04 <unlink>
    3eec:	cd55                	beqz	a0,3fa8 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	d6a50513          	add	a0,a0,-662 # 7c58 <malloc+0x1a84>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	f0e080e7          	jalr	-242(ra) # 5e04 <unlink>
    3efe:	c179                	beqz	a0,3fc4 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f00:	00004517          	auipc	a0,0x4
    3f04:	cc850513          	add	a0,a0,-824 # 7bc8 <malloc+0x19f4>
    3f08:	00002097          	auipc	ra,0x2
    3f0c:	efc080e7          	jalr	-260(ra) # 5e04 <unlink>
    3f10:	e961                	bnez	a0,3fe0 <rmdot+0x16a>
}
    3f12:	60e2                	ld	ra,24(sp)
    3f14:	6442                	ld	s0,16(sp)
    3f16:	64a2                	ld	s1,8(sp)
    3f18:	6105                	add	sp,sp,32
    3f1a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f1c:	85a6                	mv	a1,s1
    3f1e:	00004517          	auipc	a0,0x4
    3f22:	cb250513          	add	a0,a0,-846 # 7bd0 <malloc+0x19fc>
    3f26:	00002097          	auipc	ra,0x2
    3f2a:	1f6080e7          	jalr	502(ra) # 611c <printf>
    exit(1);
    3f2e:	4505                	li	a0,1
    3f30:	00002097          	auipc	ra,0x2
    3f34:	e74080e7          	jalr	-396(ra) # 5da4 <exit>
    printf("%s: chdir dots failed\n", s);
    3f38:	85a6                	mv	a1,s1
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	cae50513          	add	a0,a0,-850 # 7be8 <malloc+0x1a14>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	1da080e7          	jalr	474(ra) # 611c <printf>
    exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	e58080e7          	jalr	-424(ra) # 5da4 <exit>
    printf("%s: rm . worked!\n", s);
    3f54:	85a6                	mv	a1,s1
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	caa50513          	add	a0,a0,-854 # 7c00 <malloc+0x1a2c>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	1be080e7          	jalr	446(ra) # 611c <printf>
    exit(1);
    3f66:	4505                	li	a0,1
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	e3c080e7          	jalr	-452(ra) # 5da4 <exit>
    printf("%s: rm .. worked!\n", s);
    3f70:	85a6                	mv	a1,s1
    3f72:	00004517          	auipc	a0,0x4
    3f76:	ca650513          	add	a0,a0,-858 # 7c18 <malloc+0x1a44>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	1a2080e7          	jalr	418(ra) # 611c <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00002097          	auipc	ra,0x2
    3f88:	e20080e7          	jalr	-480(ra) # 5da4 <exit>
    printf("%s: chdir / failed\n", s);
    3f8c:	85a6                	mv	a1,s1
    3f8e:	00003517          	auipc	a0,0x3
    3f92:	64250513          	add	a0,a0,1602 # 75d0 <malloc+0x13fc>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	186080e7          	jalr	390(ra) # 611c <printf>
    exit(1);
    3f9e:	4505                	li	a0,1
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	e04080e7          	jalr	-508(ra) # 5da4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fa8:	85a6                	mv	a1,s1
    3faa:	00004517          	auipc	a0,0x4
    3fae:	c8e50513          	add	a0,a0,-882 # 7c38 <malloc+0x1a64>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	16a080e7          	jalr	362(ra) # 611c <printf>
    exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	de8080e7          	jalr	-536(ra) # 5da4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fc4:	85a6                	mv	a1,s1
    3fc6:	00004517          	auipc	a0,0x4
    3fca:	c9a50513          	add	a0,a0,-870 # 7c60 <malloc+0x1a8c>
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	14e080e7          	jalr	334(ra) # 611c <printf>
    exit(1);
    3fd6:	4505                	li	a0,1
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	dcc080e7          	jalr	-564(ra) # 5da4 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fe0:	85a6                	mv	a1,s1
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	c9e50513          	add	a0,a0,-866 # 7c80 <malloc+0x1aac>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	132080e7          	jalr	306(ra) # 611c <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	db0080e7          	jalr	-592(ra) # 5da4 <exit>

0000000000003ffc <dirfile>:
{
    3ffc:	1101                	add	sp,sp,-32
    3ffe:	ec06                	sd	ra,24(sp)
    4000:	e822                	sd	s0,16(sp)
    4002:	e426                	sd	s1,8(sp)
    4004:	e04a                	sd	s2,0(sp)
    4006:	1000                	add	s0,sp,32
    4008:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    400a:	20000593          	li	a1,512
    400e:	00004517          	auipc	a0,0x4
    4012:	c9250513          	add	a0,a0,-878 # 7ca0 <malloc+0x1acc>
    4016:	00002097          	auipc	ra,0x2
    401a:	dde080e7          	jalr	-546(ra) # 5df4 <open>
  if(fd < 0){
    401e:	0e054d63          	bltz	a0,4118 <dirfile+0x11c>
  close(fd);
    4022:	00002097          	auipc	ra,0x2
    4026:	daa080e7          	jalr	-598(ra) # 5dcc <close>
  if(chdir("dirfile") == 0){
    402a:	00004517          	auipc	a0,0x4
    402e:	c7650513          	add	a0,a0,-906 # 7ca0 <malloc+0x1acc>
    4032:	00002097          	auipc	ra,0x2
    4036:	df2080e7          	jalr	-526(ra) # 5e24 <chdir>
    403a:	cd6d                	beqz	a0,4134 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    403c:	4581                	li	a1,0
    403e:	00004517          	auipc	a0,0x4
    4042:	caa50513          	add	a0,a0,-854 # 7ce8 <malloc+0x1b14>
    4046:	00002097          	auipc	ra,0x2
    404a:	dae080e7          	jalr	-594(ra) # 5df4 <open>
  if(fd >= 0){
    404e:	10055163          	bgez	a0,4150 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4052:	20000593          	li	a1,512
    4056:	00004517          	auipc	a0,0x4
    405a:	c9250513          	add	a0,a0,-878 # 7ce8 <malloc+0x1b14>
    405e:	00002097          	auipc	ra,0x2
    4062:	d96080e7          	jalr	-618(ra) # 5df4 <open>
  if(fd >= 0){
    4066:	10055363          	bgez	a0,416c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    406a:	00004517          	auipc	a0,0x4
    406e:	c7e50513          	add	a0,a0,-898 # 7ce8 <malloc+0x1b14>
    4072:	00002097          	auipc	ra,0x2
    4076:	daa080e7          	jalr	-598(ra) # 5e1c <mkdir>
    407a:	10050763          	beqz	a0,4188 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    407e:	00004517          	auipc	a0,0x4
    4082:	c6a50513          	add	a0,a0,-918 # 7ce8 <malloc+0x1b14>
    4086:	00002097          	auipc	ra,0x2
    408a:	d7e080e7          	jalr	-642(ra) # 5e04 <unlink>
    408e:	10050b63          	beqz	a0,41a4 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4092:	00004597          	auipc	a1,0x4
    4096:	c5658593          	add	a1,a1,-938 # 7ce8 <malloc+0x1b14>
    409a:	00002517          	auipc	a0,0x2
    409e:	43650513          	add	a0,a0,1078 # 64d0 <malloc+0x2fc>
    40a2:	00002097          	auipc	ra,0x2
    40a6:	d72080e7          	jalr	-654(ra) # 5e14 <link>
    40aa:	10050b63          	beqz	a0,41c0 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40ae:	00004517          	auipc	a0,0x4
    40b2:	bf250513          	add	a0,a0,-1038 # 7ca0 <malloc+0x1acc>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	d4e080e7          	jalr	-690(ra) # 5e04 <unlink>
    40be:	10051f63          	bnez	a0,41dc <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40c2:	4589                	li	a1,2
    40c4:	00003517          	auipc	a0,0x3
    40c8:	93450513          	add	a0,a0,-1740 # 69f8 <malloc+0x824>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	d28080e7          	jalr	-728(ra) # 5df4 <open>
  if(fd >= 0){
    40d4:	12055263          	bgez	a0,41f8 <dirfile+0x1fc>
  fd = open(".", 0);
    40d8:	4581                	li	a1,0
    40da:	00003517          	auipc	a0,0x3
    40de:	91e50513          	add	a0,a0,-1762 # 69f8 <malloc+0x824>
    40e2:	00002097          	auipc	ra,0x2
    40e6:	d12080e7          	jalr	-750(ra) # 5df4 <open>
    40ea:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40ec:	4605                	li	a2,1
    40ee:	00002597          	auipc	a1,0x2
    40f2:	27a58593          	add	a1,a1,634 # 6368 <malloc+0x194>
    40f6:	00002097          	auipc	ra,0x2
    40fa:	cce080e7          	jalr	-818(ra) # 5dc4 <write>
    40fe:	10a04b63          	bgtz	a0,4214 <dirfile+0x218>
  close(fd);
    4102:	8526                	mv	a0,s1
    4104:	00002097          	auipc	ra,0x2
    4108:	cc8080e7          	jalr	-824(ra) # 5dcc <close>
}
    410c:	60e2                	ld	ra,24(sp)
    410e:	6442                	ld	s0,16(sp)
    4110:	64a2                	ld	s1,8(sp)
    4112:	6902                	ld	s2,0(sp)
    4114:	6105                	add	sp,sp,32
    4116:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4118:	85ca                	mv	a1,s2
    411a:	00004517          	auipc	a0,0x4
    411e:	b8e50513          	add	a0,a0,-1138 # 7ca8 <malloc+0x1ad4>
    4122:	00002097          	auipc	ra,0x2
    4126:	ffa080e7          	jalr	-6(ra) # 611c <printf>
    exit(1);
    412a:	4505                	li	a0,1
    412c:	00002097          	auipc	ra,0x2
    4130:	c78080e7          	jalr	-904(ra) # 5da4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4134:	85ca                	mv	a1,s2
    4136:	00004517          	auipc	a0,0x4
    413a:	b9250513          	add	a0,a0,-1134 # 7cc8 <malloc+0x1af4>
    413e:	00002097          	auipc	ra,0x2
    4142:	fde080e7          	jalr	-34(ra) # 611c <printf>
    exit(1);
    4146:	4505                	li	a0,1
    4148:	00002097          	auipc	ra,0x2
    414c:	c5c080e7          	jalr	-932(ra) # 5da4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4150:	85ca                	mv	a1,s2
    4152:	00004517          	auipc	a0,0x4
    4156:	ba650513          	add	a0,a0,-1114 # 7cf8 <malloc+0x1b24>
    415a:	00002097          	auipc	ra,0x2
    415e:	fc2080e7          	jalr	-62(ra) # 611c <printf>
    exit(1);
    4162:	4505                	li	a0,1
    4164:	00002097          	auipc	ra,0x2
    4168:	c40080e7          	jalr	-960(ra) # 5da4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    416c:	85ca                	mv	a1,s2
    416e:	00004517          	auipc	a0,0x4
    4172:	b8a50513          	add	a0,a0,-1142 # 7cf8 <malloc+0x1b24>
    4176:	00002097          	auipc	ra,0x2
    417a:	fa6080e7          	jalr	-90(ra) # 611c <printf>
    exit(1);
    417e:	4505                	li	a0,1
    4180:	00002097          	auipc	ra,0x2
    4184:	c24080e7          	jalr	-988(ra) # 5da4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4188:	85ca                	mv	a1,s2
    418a:	00004517          	auipc	a0,0x4
    418e:	b9650513          	add	a0,a0,-1130 # 7d20 <malloc+0x1b4c>
    4192:	00002097          	auipc	ra,0x2
    4196:	f8a080e7          	jalr	-118(ra) # 611c <printf>
    exit(1);
    419a:	4505                	li	a0,1
    419c:	00002097          	auipc	ra,0x2
    41a0:	c08080e7          	jalr	-1016(ra) # 5da4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41a4:	85ca                	mv	a1,s2
    41a6:	00004517          	auipc	a0,0x4
    41aa:	ba250513          	add	a0,a0,-1118 # 7d48 <malloc+0x1b74>
    41ae:	00002097          	auipc	ra,0x2
    41b2:	f6e080e7          	jalr	-146(ra) # 611c <printf>
    exit(1);
    41b6:	4505                	li	a0,1
    41b8:	00002097          	auipc	ra,0x2
    41bc:	bec080e7          	jalr	-1044(ra) # 5da4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41c0:	85ca                	mv	a1,s2
    41c2:	00004517          	auipc	a0,0x4
    41c6:	bae50513          	add	a0,a0,-1106 # 7d70 <malloc+0x1b9c>
    41ca:	00002097          	auipc	ra,0x2
    41ce:	f52080e7          	jalr	-174(ra) # 611c <printf>
    exit(1);
    41d2:	4505                	li	a0,1
    41d4:	00002097          	auipc	ra,0x2
    41d8:	bd0080e7          	jalr	-1072(ra) # 5da4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41dc:	85ca                	mv	a1,s2
    41de:	00004517          	auipc	a0,0x4
    41e2:	bba50513          	add	a0,a0,-1094 # 7d98 <malloc+0x1bc4>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	f36080e7          	jalr	-202(ra) # 611c <printf>
    exit(1);
    41ee:	4505                	li	a0,1
    41f0:	00002097          	auipc	ra,0x2
    41f4:	bb4080e7          	jalr	-1100(ra) # 5da4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41f8:	85ca                	mv	a1,s2
    41fa:	00004517          	auipc	a0,0x4
    41fe:	bbe50513          	add	a0,a0,-1090 # 7db8 <malloc+0x1be4>
    4202:	00002097          	auipc	ra,0x2
    4206:	f1a080e7          	jalr	-230(ra) # 611c <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00002097          	auipc	ra,0x2
    4210:	b98080e7          	jalr	-1128(ra) # 5da4 <exit>
    printf("%s: write . succeeded!\n", s);
    4214:	85ca                	mv	a1,s2
    4216:	00004517          	auipc	a0,0x4
    421a:	bca50513          	add	a0,a0,-1078 # 7de0 <malloc+0x1c0c>
    421e:	00002097          	auipc	ra,0x2
    4222:	efe080e7          	jalr	-258(ra) # 611c <printf>
    exit(1);
    4226:	4505                	li	a0,1
    4228:	00002097          	auipc	ra,0x2
    422c:	b7c080e7          	jalr	-1156(ra) # 5da4 <exit>

0000000000004230 <iref>:
{
    4230:	7139                	add	sp,sp,-64
    4232:	fc06                	sd	ra,56(sp)
    4234:	f822                	sd	s0,48(sp)
    4236:	f426                	sd	s1,40(sp)
    4238:	f04a                	sd	s2,32(sp)
    423a:	ec4e                	sd	s3,24(sp)
    423c:	e852                	sd	s4,16(sp)
    423e:	e456                	sd	s5,8(sp)
    4240:	e05a                	sd	s6,0(sp)
    4242:	0080                	add	s0,sp,64
    4244:	8b2a                	mv	s6,a0
    4246:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    424a:	00004a17          	auipc	s4,0x4
    424e:	baea0a13          	add	s4,s4,-1106 # 7df8 <malloc+0x1c24>
    mkdir("");
    4252:	00003497          	auipc	s1,0x3
    4256:	6ae48493          	add	s1,s1,1710 # 7900 <malloc+0x172c>
    link("README", "");
    425a:	00002a97          	auipc	s5,0x2
    425e:	276a8a93          	add	s5,s5,630 # 64d0 <malloc+0x2fc>
    fd = open("xx", O_CREATE);
    4262:	00004997          	auipc	s3,0x4
    4266:	a8e98993          	add	s3,s3,-1394 # 7cf0 <malloc+0x1b1c>
    426a:	a891                	j	42be <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    426c:	85da                	mv	a1,s6
    426e:	00004517          	auipc	a0,0x4
    4272:	b9250513          	add	a0,a0,-1134 # 7e00 <malloc+0x1c2c>
    4276:	00002097          	auipc	ra,0x2
    427a:	ea6080e7          	jalr	-346(ra) # 611c <printf>
      exit(1);
    427e:	4505                	li	a0,1
    4280:	00002097          	auipc	ra,0x2
    4284:	b24080e7          	jalr	-1244(ra) # 5da4 <exit>
      printf("%s: chdir irefd failed\n", s);
    4288:	85da                	mv	a1,s6
    428a:	00004517          	auipc	a0,0x4
    428e:	b8e50513          	add	a0,a0,-1138 # 7e18 <malloc+0x1c44>
    4292:	00002097          	auipc	ra,0x2
    4296:	e8a080e7          	jalr	-374(ra) # 611c <printf>
      exit(1);
    429a:	4505                	li	a0,1
    429c:	00002097          	auipc	ra,0x2
    42a0:	b08080e7          	jalr	-1272(ra) # 5da4 <exit>
      close(fd);
    42a4:	00002097          	auipc	ra,0x2
    42a8:	b28080e7          	jalr	-1240(ra) # 5dcc <close>
    42ac:	a889                	j	42fe <iref+0xce>
    unlink("xx");
    42ae:	854e                	mv	a0,s3
    42b0:	00002097          	auipc	ra,0x2
    42b4:	b54080e7          	jalr	-1196(ra) # 5e04 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42b8:	397d                	addw	s2,s2,-1
    42ba:	06090063          	beqz	s2,431a <iref+0xea>
    if(mkdir("irefd") != 0){
    42be:	8552                	mv	a0,s4
    42c0:	00002097          	auipc	ra,0x2
    42c4:	b5c080e7          	jalr	-1188(ra) # 5e1c <mkdir>
    42c8:	f155                	bnez	a0,426c <iref+0x3c>
    if(chdir("irefd") != 0){
    42ca:	8552                	mv	a0,s4
    42cc:	00002097          	auipc	ra,0x2
    42d0:	b58080e7          	jalr	-1192(ra) # 5e24 <chdir>
    42d4:	f955                	bnez	a0,4288 <iref+0x58>
    mkdir("");
    42d6:	8526                	mv	a0,s1
    42d8:	00002097          	auipc	ra,0x2
    42dc:	b44080e7          	jalr	-1212(ra) # 5e1c <mkdir>
    link("README", "");
    42e0:	85a6                	mv	a1,s1
    42e2:	8556                	mv	a0,s5
    42e4:	00002097          	auipc	ra,0x2
    42e8:	b30080e7          	jalr	-1232(ra) # 5e14 <link>
    fd = open("", O_CREATE);
    42ec:	20000593          	li	a1,512
    42f0:	8526                	mv	a0,s1
    42f2:	00002097          	auipc	ra,0x2
    42f6:	b02080e7          	jalr	-1278(ra) # 5df4 <open>
    if(fd >= 0)
    42fa:	fa0555e3          	bgez	a0,42a4 <iref+0x74>
    fd = open("xx", O_CREATE);
    42fe:	20000593          	li	a1,512
    4302:	854e                	mv	a0,s3
    4304:	00002097          	auipc	ra,0x2
    4308:	af0080e7          	jalr	-1296(ra) # 5df4 <open>
    if(fd >= 0)
    430c:	fa0541e3          	bltz	a0,42ae <iref+0x7e>
      close(fd);
    4310:	00002097          	auipc	ra,0x2
    4314:	abc080e7          	jalr	-1348(ra) # 5dcc <close>
    4318:	bf59                	j	42ae <iref+0x7e>
    431a:	03300493          	li	s1,51
    chdir("..");
    431e:	00003997          	auipc	s3,0x3
    4322:	30298993          	add	s3,s3,770 # 7620 <malloc+0x144c>
    unlink("irefd");
    4326:	00004917          	auipc	s2,0x4
    432a:	ad290913          	add	s2,s2,-1326 # 7df8 <malloc+0x1c24>
    chdir("..");
    432e:	854e                	mv	a0,s3
    4330:	00002097          	auipc	ra,0x2
    4334:	af4080e7          	jalr	-1292(ra) # 5e24 <chdir>
    unlink("irefd");
    4338:	854a                	mv	a0,s2
    433a:	00002097          	auipc	ra,0x2
    433e:	aca080e7          	jalr	-1334(ra) # 5e04 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4342:	34fd                	addw	s1,s1,-1
    4344:	f4ed                	bnez	s1,432e <iref+0xfe>
  chdir("/");
    4346:	00003517          	auipc	a0,0x3
    434a:	28250513          	add	a0,a0,642 # 75c8 <malloc+0x13f4>
    434e:	00002097          	auipc	ra,0x2
    4352:	ad6080e7          	jalr	-1322(ra) # 5e24 <chdir>
}
    4356:	70e2                	ld	ra,56(sp)
    4358:	7442                	ld	s0,48(sp)
    435a:	74a2                	ld	s1,40(sp)
    435c:	7902                	ld	s2,32(sp)
    435e:	69e2                	ld	s3,24(sp)
    4360:	6a42                	ld	s4,16(sp)
    4362:	6aa2                	ld	s5,8(sp)
    4364:	6b02                	ld	s6,0(sp)
    4366:	6121                	add	sp,sp,64
    4368:	8082                	ret

000000000000436a <openiputtest>:
{
    436a:	7179                	add	sp,sp,-48
    436c:	f406                	sd	ra,40(sp)
    436e:	f022                	sd	s0,32(sp)
    4370:	ec26                	sd	s1,24(sp)
    4372:	1800                	add	s0,sp,48
    4374:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4376:	00004517          	auipc	a0,0x4
    437a:	aba50513          	add	a0,a0,-1350 # 7e30 <malloc+0x1c5c>
    437e:	00002097          	auipc	ra,0x2
    4382:	a9e080e7          	jalr	-1378(ra) # 5e1c <mkdir>
    4386:	04054263          	bltz	a0,43ca <openiputtest+0x60>
  pid = fork();
    438a:	00002097          	auipc	ra,0x2
    438e:	a12080e7          	jalr	-1518(ra) # 5d9c <fork>
  if(pid < 0){
    4392:	04054a63          	bltz	a0,43e6 <openiputtest+0x7c>
  if(pid == 0){
    4396:	e93d                	bnez	a0,440c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4398:	4589                	li	a1,2
    439a:	00004517          	auipc	a0,0x4
    439e:	a9650513          	add	a0,a0,-1386 # 7e30 <malloc+0x1c5c>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	a52080e7          	jalr	-1454(ra) # 5df4 <open>
    if(fd >= 0){
    43aa:	04054c63          	bltz	a0,4402 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43ae:	85a6                	mv	a1,s1
    43b0:	00004517          	auipc	a0,0x4
    43b4:	aa050513          	add	a0,a0,-1376 # 7e50 <malloc+0x1c7c>
    43b8:	00002097          	auipc	ra,0x2
    43bc:	d64080e7          	jalr	-668(ra) # 611c <printf>
      exit(1);
    43c0:	4505                	li	a0,1
    43c2:	00002097          	auipc	ra,0x2
    43c6:	9e2080e7          	jalr	-1566(ra) # 5da4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43ca:	85a6                	mv	a1,s1
    43cc:	00004517          	auipc	a0,0x4
    43d0:	a6c50513          	add	a0,a0,-1428 # 7e38 <malloc+0x1c64>
    43d4:	00002097          	auipc	ra,0x2
    43d8:	d48080e7          	jalr	-696(ra) # 611c <printf>
    exit(1);
    43dc:	4505                	li	a0,1
    43de:	00002097          	auipc	ra,0x2
    43e2:	9c6080e7          	jalr	-1594(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    43e6:	85a6                	mv	a1,s1
    43e8:	00002517          	auipc	a0,0x2
    43ec:	7b050513          	add	a0,a0,1968 # 6b98 <malloc+0x9c4>
    43f0:	00002097          	auipc	ra,0x2
    43f4:	d2c080e7          	jalr	-724(ra) # 611c <printf>
    exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00002097          	auipc	ra,0x2
    43fe:	9aa080e7          	jalr	-1622(ra) # 5da4 <exit>
    exit(0);
    4402:	4501                	li	a0,0
    4404:	00002097          	auipc	ra,0x2
    4408:	9a0080e7          	jalr	-1632(ra) # 5da4 <exit>
  sleep(1);
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	a36080e7          	jalr	-1482(ra) # 5e44 <sleep>
  if(unlink("oidir") != 0){
    4416:	00004517          	auipc	a0,0x4
    441a:	a1a50513          	add	a0,a0,-1510 # 7e30 <malloc+0x1c5c>
    441e:	00002097          	auipc	ra,0x2
    4422:	9e6080e7          	jalr	-1562(ra) # 5e04 <unlink>
    4426:	cd19                	beqz	a0,4444 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4428:	85a6                	mv	a1,s1
    442a:	00003517          	auipc	a0,0x3
    442e:	95e50513          	add	a0,a0,-1698 # 6d88 <malloc+0xbb4>
    4432:	00002097          	auipc	ra,0x2
    4436:	cea080e7          	jalr	-790(ra) # 611c <printf>
    exit(1);
    443a:	4505                	li	a0,1
    443c:	00002097          	auipc	ra,0x2
    4440:	968080e7          	jalr	-1688(ra) # 5da4 <exit>
  wait(&xstatus);
    4444:	fdc40513          	add	a0,s0,-36
    4448:	00002097          	auipc	ra,0x2
    444c:	964080e7          	jalr	-1692(ra) # 5dac <wait>
  exit(xstatus);
    4450:	fdc42503          	lw	a0,-36(s0)
    4454:	00002097          	auipc	ra,0x2
    4458:	950080e7          	jalr	-1712(ra) # 5da4 <exit>

000000000000445c <forkforkfork>:
{
    445c:	1101                	add	sp,sp,-32
    445e:	ec06                	sd	ra,24(sp)
    4460:	e822                	sd	s0,16(sp)
    4462:	e426                	sd	s1,8(sp)
    4464:	1000                	add	s0,sp,32
    4466:	84aa                	mv	s1,a0
  unlink("stopforking");
    4468:	00004517          	auipc	a0,0x4
    446c:	a1050513          	add	a0,a0,-1520 # 7e78 <malloc+0x1ca4>
    4470:	00002097          	auipc	ra,0x2
    4474:	994080e7          	jalr	-1644(ra) # 5e04 <unlink>
  int pid = fork();
    4478:	00002097          	auipc	ra,0x2
    447c:	924080e7          	jalr	-1756(ra) # 5d9c <fork>
  if(pid < 0){
    4480:	04054563          	bltz	a0,44ca <forkforkfork+0x6e>
  if(pid == 0){
    4484:	c12d                	beqz	a0,44e6 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4486:	4551                	li	a0,20
    4488:	00002097          	auipc	ra,0x2
    448c:	9bc080e7          	jalr	-1604(ra) # 5e44 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4490:	20200593          	li	a1,514
    4494:	00004517          	auipc	a0,0x4
    4498:	9e450513          	add	a0,a0,-1564 # 7e78 <malloc+0x1ca4>
    449c:	00002097          	auipc	ra,0x2
    44a0:	958080e7          	jalr	-1704(ra) # 5df4 <open>
    44a4:	00002097          	auipc	ra,0x2
    44a8:	928080e7          	jalr	-1752(ra) # 5dcc <close>
  wait(0);
    44ac:	4501                	li	a0,0
    44ae:	00002097          	auipc	ra,0x2
    44b2:	8fe080e7          	jalr	-1794(ra) # 5dac <wait>
  sleep(10); // one second
    44b6:	4529                	li	a0,10
    44b8:	00002097          	auipc	ra,0x2
    44bc:	98c080e7          	jalr	-1652(ra) # 5e44 <sleep>
}
    44c0:	60e2                	ld	ra,24(sp)
    44c2:	6442                	ld	s0,16(sp)
    44c4:	64a2                	ld	s1,8(sp)
    44c6:	6105                	add	sp,sp,32
    44c8:	8082                	ret
    printf("%s: fork failed", s);
    44ca:	85a6                	mv	a1,s1
    44cc:	00003517          	auipc	a0,0x3
    44d0:	88c50513          	add	a0,a0,-1908 # 6d58 <malloc+0xb84>
    44d4:	00002097          	auipc	ra,0x2
    44d8:	c48080e7          	jalr	-952(ra) # 611c <printf>
    exit(1);
    44dc:	4505                	li	a0,1
    44de:	00002097          	auipc	ra,0x2
    44e2:	8c6080e7          	jalr	-1850(ra) # 5da4 <exit>
      int fd = open("stopforking", 0);
    44e6:	00004497          	auipc	s1,0x4
    44ea:	99248493          	add	s1,s1,-1646 # 7e78 <malloc+0x1ca4>
    44ee:	4581                	li	a1,0
    44f0:	8526                	mv	a0,s1
    44f2:	00002097          	auipc	ra,0x2
    44f6:	902080e7          	jalr	-1790(ra) # 5df4 <open>
      if(fd >= 0){
    44fa:	02055763          	bgez	a0,4528 <forkforkfork+0xcc>
      if(fork() < 0){
    44fe:	00002097          	auipc	ra,0x2
    4502:	89e080e7          	jalr	-1890(ra) # 5d9c <fork>
    4506:	fe0554e3          	bgez	a0,44ee <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    450a:	20200593          	li	a1,514
    450e:	00004517          	auipc	a0,0x4
    4512:	96a50513          	add	a0,a0,-1686 # 7e78 <malloc+0x1ca4>
    4516:	00002097          	auipc	ra,0x2
    451a:	8de080e7          	jalr	-1826(ra) # 5df4 <open>
    451e:	00002097          	auipc	ra,0x2
    4522:	8ae080e7          	jalr	-1874(ra) # 5dcc <close>
    4526:	b7e1                	j	44ee <forkforkfork+0x92>
        exit(0);
    4528:	4501                	li	a0,0
    452a:	00002097          	auipc	ra,0x2
    452e:	87a080e7          	jalr	-1926(ra) # 5da4 <exit>

0000000000004532 <killstatus>:
{
    4532:	7139                	add	sp,sp,-64
    4534:	fc06                	sd	ra,56(sp)
    4536:	f822                	sd	s0,48(sp)
    4538:	f426                	sd	s1,40(sp)
    453a:	f04a                	sd	s2,32(sp)
    453c:	ec4e                	sd	s3,24(sp)
    453e:	e852                	sd	s4,16(sp)
    4540:	0080                	add	s0,sp,64
    4542:	8a2a                	mv	s4,a0
    4544:	06400913          	li	s2,100
    if(xst != -1) {
    4548:	59fd                	li	s3,-1
    int pid1 = fork();
    454a:	00002097          	auipc	ra,0x2
    454e:	852080e7          	jalr	-1966(ra) # 5d9c <fork>
    4552:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4554:	02054f63          	bltz	a0,4592 <killstatus+0x60>
    if(pid1 == 0){
    4558:	c939                	beqz	a0,45ae <killstatus+0x7c>
    sleep(1);
    455a:	4505                	li	a0,1
    455c:	00002097          	auipc	ra,0x2
    4560:	8e8080e7          	jalr	-1816(ra) # 5e44 <sleep>
    kill(pid1);
    4564:	8526                	mv	a0,s1
    4566:	00002097          	auipc	ra,0x2
    456a:	86e080e7          	jalr	-1938(ra) # 5dd4 <kill>
    wait(&xst);
    456e:	fcc40513          	add	a0,s0,-52
    4572:	00002097          	auipc	ra,0x2
    4576:	83a080e7          	jalr	-1990(ra) # 5dac <wait>
    if(xst != -1) {
    457a:	fcc42783          	lw	a5,-52(s0)
    457e:	03379d63          	bne	a5,s3,45b8 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4582:	397d                	addw	s2,s2,-1
    4584:	fc0913e3          	bnez	s2,454a <killstatus+0x18>
  exit(0);
    4588:	4501                	li	a0,0
    458a:	00002097          	auipc	ra,0x2
    458e:	81a080e7          	jalr	-2022(ra) # 5da4 <exit>
      printf("%s: fork failed\n", s);
    4592:	85d2                	mv	a1,s4
    4594:	00002517          	auipc	a0,0x2
    4598:	60450513          	add	a0,a0,1540 # 6b98 <malloc+0x9c4>
    459c:	00002097          	auipc	ra,0x2
    45a0:	b80080e7          	jalr	-1152(ra) # 611c <printf>
      exit(1);
    45a4:	4505                	li	a0,1
    45a6:	00001097          	auipc	ra,0x1
    45aa:	7fe080e7          	jalr	2046(ra) # 5da4 <exit>
        getpid();
    45ae:	00002097          	auipc	ra,0x2
    45b2:	886080e7          	jalr	-1914(ra) # 5e34 <getpid>
      while(1) {
    45b6:	bfe5                	j	45ae <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45b8:	85d2                	mv	a1,s4
    45ba:	00004517          	auipc	a0,0x4
    45be:	8ce50513          	add	a0,a0,-1842 # 7e88 <malloc+0x1cb4>
    45c2:	00002097          	auipc	ra,0x2
    45c6:	b5a080e7          	jalr	-1190(ra) # 611c <printf>
       exit(1);
    45ca:	4505                	li	a0,1
    45cc:	00001097          	auipc	ra,0x1
    45d0:	7d8080e7          	jalr	2008(ra) # 5da4 <exit>

00000000000045d4 <preempt>:
{
    45d4:	7139                	add	sp,sp,-64
    45d6:	fc06                	sd	ra,56(sp)
    45d8:	f822                	sd	s0,48(sp)
    45da:	f426                	sd	s1,40(sp)
    45dc:	f04a                	sd	s2,32(sp)
    45de:	ec4e                	sd	s3,24(sp)
    45e0:	e852                	sd	s4,16(sp)
    45e2:	0080                	add	s0,sp,64
    45e4:	892a                	mv	s2,a0
  pid1 = fork();
    45e6:	00001097          	auipc	ra,0x1
    45ea:	7b6080e7          	jalr	1974(ra) # 5d9c <fork>
  if(pid1 < 0) {
    45ee:	00054563          	bltz	a0,45f8 <preempt+0x24>
    45f2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45f4:	e105                	bnez	a0,4614 <preempt+0x40>
    for(;;)
    45f6:	a001                	j	45f6 <preempt+0x22>
    printf("%s: fork failed", s);
    45f8:	85ca                	mv	a1,s2
    45fa:	00002517          	auipc	a0,0x2
    45fe:	75e50513          	add	a0,a0,1886 # 6d58 <malloc+0xb84>
    4602:	00002097          	auipc	ra,0x2
    4606:	b1a080e7          	jalr	-1254(ra) # 611c <printf>
    exit(1);
    460a:	4505                	li	a0,1
    460c:	00001097          	auipc	ra,0x1
    4610:	798080e7          	jalr	1944(ra) # 5da4 <exit>
  pid2 = fork();
    4614:	00001097          	auipc	ra,0x1
    4618:	788080e7          	jalr	1928(ra) # 5d9c <fork>
    461c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    461e:	00054463          	bltz	a0,4626 <preempt+0x52>
  if(pid2 == 0)
    4622:	e105                	bnez	a0,4642 <preempt+0x6e>
    for(;;)
    4624:	a001                	j	4624 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4626:	85ca                	mv	a1,s2
    4628:	00002517          	auipc	a0,0x2
    462c:	57050513          	add	a0,a0,1392 # 6b98 <malloc+0x9c4>
    4630:	00002097          	auipc	ra,0x2
    4634:	aec080e7          	jalr	-1300(ra) # 611c <printf>
    exit(1);
    4638:	4505                	li	a0,1
    463a:	00001097          	auipc	ra,0x1
    463e:	76a080e7          	jalr	1898(ra) # 5da4 <exit>
  pipe(pfds);
    4642:	fc840513          	add	a0,s0,-56
    4646:	00001097          	auipc	ra,0x1
    464a:	76e080e7          	jalr	1902(ra) # 5db4 <pipe>
  pid3 = fork();
    464e:	00001097          	auipc	ra,0x1
    4652:	74e080e7          	jalr	1870(ra) # 5d9c <fork>
    4656:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4658:	02054e63          	bltz	a0,4694 <preempt+0xc0>
  if(pid3 == 0){
    465c:	e525                	bnez	a0,46c4 <preempt+0xf0>
    close(pfds[0]);
    465e:	fc842503          	lw	a0,-56(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	76a080e7          	jalr	1898(ra) # 5dcc <close>
    if(write(pfds[1], "x", 1) != 1)
    466a:	4605                	li	a2,1
    466c:	00002597          	auipc	a1,0x2
    4670:	cfc58593          	add	a1,a1,-772 # 6368 <malloc+0x194>
    4674:	fcc42503          	lw	a0,-52(s0)
    4678:	00001097          	auipc	ra,0x1
    467c:	74c080e7          	jalr	1868(ra) # 5dc4 <write>
    4680:	4785                	li	a5,1
    4682:	02f51763          	bne	a0,a5,46b0 <preempt+0xdc>
    close(pfds[1]);
    4686:	fcc42503          	lw	a0,-52(s0)
    468a:	00001097          	auipc	ra,0x1
    468e:	742080e7          	jalr	1858(ra) # 5dcc <close>
    for(;;)
    4692:	a001                	j	4692 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4694:	85ca                	mv	a1,s2
    4696:	00002517          	auipc	a0,0x2
    469a:	50250513          	add	a0,a0,1282 # 6b98 <malloc+0x9c4>
    469e:	00002097          	auipc	ra,0x2
    46a2:	a7e080e7          	jalr	-1410(ra) # 611c <printf>
     exit(1);
    46a6:	4505                	li	a0,1
    46a8:	00001097          	auipc	ra,0x1
    46ac:	6fc080e7          	jalr	1788(ra) # 5da4 <exit>
      printf("%s: preempt write error", s);
    46b0:	85ca                	mv	a1,s2
    46b2:	00003517          	auipc	a0,0x3
    46b6:	7f650513          	add	a0,a0,2038 # 7ea8 <malloc+0x1cd4>
    46ba:	00002097          	auipc	ra,0x2
    46be:	a62080e7          	jalr	-1438(ra) # 611c <printf>
    46c2:	b7d1                	j	4686 <preempt+0xb2>
  close(pfds[1]);
    46c4:	fcc42503          	lw	a0,-52(s0)
    46c8:	00001097          	auipc	ra,0x1
    46cc:	704080e7          	jalr	1796(ra) # 5dcc <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46d0:	660d                	lui	a2,0x3
    46d2:	00008597          	auipc	a1,0x8
    46d6:	5a658593          	add	a1,a1,1446 # cc78 <buf>
    46da:	fc842503          	lw	a0,-56(s0)
    46de:	00001097          	auipc	ra,0x1
    46e2:	6de080e7          	jalr	1758(ra) # 5dbc <read>
    46e6:	4785                	li	a5,1
    46e8:	02f50363          	beq	a0,a5,470e <preempt+0x13a>
    printf("%s: preempt read error", s);
    46ec:	85ca                	mv	a1,s2
    46ee:	00003517          	auipc	a0,0x3
    46f2:	7d250513          	add	a0,a0,2002 # 7ec0 <malloc+0x1cec>
    46f6:	00002097          	auipc	ra,0x2
    46fa:	a26080e7          	jalr	-1498(ra) # 611c <printf>
}
    46fe:	70e2                	ld	ra,56(sp)
    4700:	7442                	ld	s0,48(sp)
    4702:	74a2                	ld	s1,40(sp)
    4704:	7902                	ld	s2,32(sp)
    4706:	69e2                	ld	s3,24(sp)
    4708:	6a42                	ld	s4,16(sp)
    470a:	6121                	add	sp,sp,64
    470c:	8082                	ret
  close(pfds[0]);
    470e:	fc842503          	lw	a0,-56(s0)
    4712:	00001097          	auipc	ra,0x1
    4716:	6ba080e7          	jalr	1722(ra) # 5dcc <close>
  printf("kill... ");
    471a:	00003517          	auipc	a0,0x3
    471e:	7be50513          	add	a0,a0,1982 # 7ed8 <malloc+0x1d04>
    4722:	00002097          	auipc	ra,0x2
    4726:	9fa080e7          	jalr	-1542(ra) # 611c <printf>
  kill(pid1);
    472a:	8526                	mv	a0,s1
    472c:	00001097          	auipc	ra,0x1
    4730:	6a8080e7          	jalr	1704(ra) # 5dd4 <kill>
  kill(pid2);
    4734:	854e                	mv	a0,s3
    4736:	00001097          	auipc	ra,0x1
    473a:	69e080e7          	jalr	1694(ra) # 5dd4 <kill>
  kill(pid3);
    473e:	8552                	mv	a0,s4
    4740:	00001097          	auipc	ra,0x1
    4744:	694080e7          	jalr	1684(ra) # 5dd4 <kill>
  printf("wait... ");
    4748:	00003517          	auipc	a0,0x3
    474c:	7a050513          	add	a0,a0,1952 # 7ee8 <malloc+0x1d14>
    4750:	00002097          	auipc	ra,0x2
    4754:	9cc080e7          	jalr	-1588(ra) # 611c <printf>
  wait(0);
    4758:	4501                	li	a0,0
    475a:	00001097          	auipc	ra,0x1
    475e:	652080e7          	jalr	1618(ra) # 5dac <wait>
  wait(0);
    4762:	4501                	li	a0,0
    4764:	00001097          	auipc	ra,0x1
    4768:	648080e7          	jalr	1608(ra) # 5dac <wait>
  wait(0);
    476c:	4501                	li	a0,0
    476e:	00001097          	auipc	ra,0x1
    4772:	63e080e7          	jalr	1598(ra) # 5dac <wait>
    4776:	b761                	j	46fe <preempt+0x12a>

0000000000004778 <reparent>:
{
    4778:	7179                	add	sp,sp,-48
    477a:	f406                	sd	ra,40(sp)
    477c:	f022                	sd	s0,32(sp)
    477e:	ec26                	sd	s1,24(sp)
    4780:	e84a                	sd	s2,16(sp)
    4782:	e44e                	sd	s3,8(sp)
    4784:	e052                	sd	s4,0(sp)
    4786:	1800                	add	s0,sp,48
    4788:	89aa                	mv	s3,a0
  int master_pid = getpid();
    478a:	00001097          	auipc	ra,0x1
    478e:	6aa080e7          	jalr	1706(ra) # 5e34 <getpid>
    4792:	8a2a                	mv	s4,a0
    4794:	0c800913          	li	s2,200
    int pid = fork();
    4798:	00001097          	auipc	ra,0x1
    479c:	604080e7          	jalr	1540(ra) # 5d9c <fork>
    47a0:	84aa                	mv	s1,a0
    if(pid < 0){
    47a2:	02054263          	bltz	a0,47c6 <reparent+0x4e>
    if(pid){
    47a6:	cd21                	beqz	a0,47fe <reparent+0x86>
      if(wait(0) != pid){
    47a8:	4501                	li	a0,0
    47aa:	00001097          	auipc	ra,0x1
    47ae:	602080e7          	jalr	1538(ra) # 5dac <wait>
    47b2:	02951863          	bne	a0,s1,47e2 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47b6:	397d                	addw	s2,s2,-1
    47b8:	fe0910e3          	bnez	s2,4798 <reparent+0x20>
  exit(0);
    47bc:	4501                	li	a0,0
    47be:	00001097          	auipc	ra,0x1
    47c2:	5e6080e7          	jalr	1510(ra) # 5da4 <exit>
      printf("%s: fork failed\n", s);
    47c6:	85ce                	mv	a1,s3
    47c8:	00002517          	auipc	a0,0x2
    47cc:	3d050513          	add	a0,a0,976 # 6b98 <malloc+0x9c4>
    47d0:	00002097          	auipc	ra,0x2
    47d4:	94c080e7          	jalr	-1716(ra) # 611c <printf>
      exit(1);
    47d8:	4505                	li	a0,1
    47da:	00001097          	auipc	ra,0x1
    47de:	5ca080e7          	jalr	1482(ra) # 5da4 <exit>
        printf("%s: wait wrong pid\n", s);
    47e2:	85ce                	mv	a1,s3
    47e4:	00002517          	auipc	a0,0x2
    47e8:	53c50513          	add	a0,a0,1340 # 6d20 <malloc+0xb4c>
    47ec:	00002097          	auipc	ra,0x2
    47f0:	930080e7          	jalr	-1744(ra) # 611c <printf>
        exit(1);
    47f4:	4505                	li	a0,1
    47f6:	00001097          	auipc	ra,0x1
    47fa:	5ae080e7          	jalr	1454(ra) # 5da4 <exit>
      int pid2 = fork();
    47fe:	00001097          	auipc	ra,0x1
    4802:	59e080e7          	jalr	1438(ra) # 5d9c <fork>
      if(pid2 < 0){
    4806:	00054763          	bltz	a0,4814 <reparent+0x9c>
      exit(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	598080e7          	jalr	1432(ra) # 5da4 <exit>
        kill(master_pid);
    4814:	8552                	mv	a0,s4
    4816:	00001097          	auipc	ra,0x1
    481a:	5be080e7          	jalr	1470(ra) # 5dd4 <kill>
        exit(1);
    481e:	4505                	li	a0,1
    4820:	00001097          	auipc	ra,0x1
    4824:	584080e7          	jalr	1412(ra) # 5da4 <exit>

0000000000004828 <sbrkfail>:
{
    4828:	7119                	add	sp,sp,-128
    482a:	fc86                	sd	ra,120(sp)
    482c:	f8a2                	sd	s0,112(sp)
    482e:	f4a6                	sd	s1,104(sp)
    4830:	f0ca                	sd	s2,96(sp)
    4832:	ecce                	sd	s3,88(sp)
    4834:	e8d2                	sd	s4,80(sp)
    4836:	e4d6                	sd	s5,72(sp)
    4838:	0100                	add	s0,sp,128
    483a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    483c:	fb040513          	add	a0,s0,-80
    4840:	00001097          	auipc	ra,0x1
    4844:	574080e7          	jalr	1396(ra) # 5db4 <pipe>
    4848:	e901                	bnez	a0,4858 <sbrkfail+0x30>
    484a:	f8040493          	add	s1,s0,-128
    484e:	fa840993          	add	s3,s0,-88
    4852:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4854:	5a7d                	li	s4,-1
    4856:	a085                	j	48b6 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4858:	85d6                	mv	a1,s5
    485a:	00002517          	auipc	a0,0x2
    485e:	44650513          	add	a0,a0,1094 # 6ca0 <malloc+0xacc>
    4862:	00002097          	auipc	ra,0x2
    4866:	8ba080e7          	jalr	-1862(ra) # 611c <printf>
    exit(1);
    486a:	4505                	li	a0,1
    486c:	00001097          	auipc	ra,0x1
    4870:	538080e7          	jalr	1336(ra) # 5da4 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4874:	00001097          	auipc	ra,0x1
    4878:	5c8080e7          	jalr	1480(ra) # 5e3c <sbrk>
    487c:	064007b7          	lui	a5,0x6400
    4880:	40a7853b          	subw	a0,a5,a0
    4884:	00001097          	auipc	ra,0x1
    4888:	5b8080e7          	jalr	1464(ra) # 5e3c <sbrk>
      write(fds[1], "x", 1);
    488c:	4605                	li	a2,1
    488e:	00002597          	auipc	a1,0x2
    4892:	ada58593          	add	a1,a1,-1318 # 6368 <malloc+0x194>
    4896:	fb442503          	lw	a0,-76(s0)
    489a:	00001097          	auipc	ra,0x1
    489e:	52a080e7          	jalr	1322(ra) # 5dc4 <write>
      for(;;) sleep(1000);
    48a2:	3e800513          	li	a0,1000
    48a6:	00001097          	auipc	ra,0x1
    48aa:	59e080e7          	jalr	1438(ra) # 5e44 <sleep>
    48ae:	bfd5                	j	48a2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b0:	0911                	add	s2,s2,4
    48b2:	03390563          	beq	s2,s3,48dc <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48b6:	00001097          	auipc	ra,0x1
    48ba:	4e6080e7          	jalr	1254(ra) # 5d9c <fork>
    48be:	00a92023          	sw	a0,0(s2)
    48c2:	d94d                	beqz	a0,4874 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48c4:	ff4506e3          	beq	a0,s4,48b0 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48c8:	4605                	li	a2,1
    48ca:	faf40593          	add	a1,s0,-81
    48ce:	fb042503          	lw	a0,-80(s0)
    48d2:	00001097          	auipc	ra,0x1
    48d6:	4ea080e7          	jalr	1258(ra) # 5dbc <read>
    48da:	bfd9                	j	48b0 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48dc:	6505                	lui	a0,0x1
    48de:	00001097          	auipc	ra,0x1
    48e2:	55e080e7          	jalr	1374(ra) # 5e3c <sbrk>
    48e6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48e8:	597d                	li	s2,-1
    48ea:	a021                	j	48f2 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48ec:	0491                	add	s1,s1,4
    48ee:	01348f63          	beq	s1,s3,490c <sbrkfail+0xe4>
    if(pids[i] == -1)
    48f2:	4088                	lw	a0,0(s1)
    48f4:	ff250ce3          	beq	a0,s2,48ec <sbrkfail+0xc4>
    kill(pids[i]);
    48f8:	00001097          	auipc	ra,0x1
    48fc:	4dc080e7          	jalr	1244(ra) # 5dd4 <kill>
    wait(0);
    4900:	4501                	li	a0,0
    4902:	00001097          	auipc	ra,0x1
    4906:	4aa080e7          	jalr	1194(ra) # 5dac <wait>
    490a:	b7cd                	j	48ec <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    490c:	57fd                	li	a5,-1
    490e:	04fa0163          	beq	s4,a5,4950 <sbrkfail+0x128>
  pid = fork();
    4912:	00001097          	auipc	ra,0x1
    4916:	48a080e7          	jalr	1162(ra) # 5d9c <fork>
    491a:	84aa                	mv	s1,a0
  if(pid < 0){
    491c:	04054863          	bltz	a0,496c <sbrkfail+0x144>
  if(pid == 0){
    4920:	c525                	beqz	a0,4988 <sbrkfail+0x160>
  wait(&xstatus);
    4922:	fbc40513          	add	a0,s0,-68
    4926:	00001097          	auipc	ra,0x1
    492a:	486080e7          	jalr	1158(ra) # 5dac <wait>
  if(xstatus != -1 && xstatus != 2)
    492e:	fbc42783          	lw	a5,-68(s0)
    4932:	577d                	li	a4,-1
    4934:	00e78563          	beq	a5,a4,493e <sbrkfail+0x116>
    4938:	4709                	li	a4,2
    493a:	08e79d63          	bne	a5,a4,49d4 <sbrkfail+0x1ac>
}
    493e:	70e6                	ld	ra,120(sp)
    4940:	7446                	ld	s0,112(sp)
    4942:	74a6                	ld	s1,104(sp)
    4944:	7906                	ld	s2,96(sp)
    4946:	69e6                	ld	s3,88(sp)
    4948:	6a46                	ld	s4,80(sp)
    494a:	6aa6                	ld	s5,72(sp)
    494c:	6109                	add	sp,sp,128
    494e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4950:	85d6                	mv	a1,s5
    4952:	00003517          	auipc	a0,0x3
    4956:	5a650513          	add	a0,a0,1446 # 7ef8 <malloc+0x1d24>
    495a:	00001097          	auipc	ra,0x1
    495e:	7c2080e7          	jalr	1986(ra) # 611c <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00001097          	auipc	ra,0x1
    4968:	440080e7          	jalr	1088(ra) # 5da4 <exit>
    printf("%s: fork failed\n", s);
    496c:	85d6                	mv	a1,s5
    496e:	00002517          	auipc	a0,0x2
    4972:	22a50513          	add	a0,a0,554 # 6b98 <malloc+0x9c4>
    4976:	00001097          	auipc	ra,0x1
    497a:	7a6080e7          	jalr	1958(ra) # 611c <printf>
    exit(1);
    497e:	4505                	li	a0,1
    4980:	00001097          	auipc	ra,0x1
    4984:	424080e7          	jalr	1060(ra) # 5da4 <exit>
    a = sbrk(0);
    4988:	4501                	li	a0,0
    498a:	00001097          	auipc	ra,0x1
    498e:	4b2080e7          	jalr	1202(ra) # 5e3c <sbrk>
    4992:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4994:	3e800537          	lui	a0,0x3e800
    4998:	00001097          	auipc	ra,0x1
    499c:	4a4080e7          	jalr	1188(ra) # 5e3c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49a0:	87ca                	mv	a5,s2
    49a2:	3e800737          	lui	a4,0x3e800
    49a6:	993a                	add	s2,s2,a4
    49a8:	6705                	lui	a4,0x1
      n += *(a+i);
    49aa:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49ae:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49b0:	97ba                	add	a5,a5,a4
    49b2:	ff279ce3          	bne	a5,s2,49aa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49b6:	8626                	mv	a2,s1
    49b8:	85d6                	mv	a1,s5
    49ba:	00003517          	auipc	a0,0x3
    49be:	55e50513          	add	a0,a0,1374 # 7f18 <malloc+0x1d44>
    49c2:	00001097          	auipc	ra,0x1
    49c6:	75a080e7          	jalr	1882(ra) # 611c <printf>
    exit(1);
    49ca:	4505                	li	a0,1
    49cc:	00001097          	auipc	ra,0x1
    49d0:	3d8080e7          	jalr	984(ra) # 5da4 <exit>
    exit(1);
    49d4:	4505                	li	a0,1
    49d6:	00001097          	auipc	ra,0x1
    49da:	3ce080e7          	jalr	974(ra) # 5da4 <exit>

00000000000049de <mem>:
{
    49de:	7139                	add	sp,sp,-64
    49e0:	fc06                	sd	ra,56(sp)
    49e2:	f822                	sd	s0,48(sp)
    49e4:	f426                	sd	s1,40(sp)
    49e6:	f04a                	sd	s2,32(sp)
    49e8:	ec4e                	sd	s3,24(sp)
    49ea:	0080                	add	s0,sp,64
    49ec:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49ee:	00001097          	auipc	ra,0x1
    49f2:	3ae080e7          	jalr	942(ra) # 5d9c <fork>
    m1 = 0;
    49f6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49f8:	6909                	lui	s2,0x2
    49fa:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0xef>
  if((pid = fork()) == 0){
    49fe:	c115                	beqz	a0,4a22 <mem+0x44>
    wait(&xstatus);
    4a00:	fcc40513          	add	a0,s0,-52
    4a04:	00001097          	auipc	ra,0x1
    4a08:	3a8080e7          	jalr	936(ra) # 5dac <wait>
    if(xstatus == -1){
    4a0c:	fcc42503          	lw	a0,-52(s0)
    4a10:	57fd                	li	a5,-1
    4a12:	06f50363          	beq	a0,a5,4a78 <mem+0x9a>
    exit(xstatus);
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	38e080e7          	jalr	910(ra) # 5da4 <exit>
      *(char**)m2 = m1;
    4a1e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a20:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a22:	854a                	mv	a0,s2
    4a24:	00001097          	auipc	ra,0x1
    4a28:	7b0080e7          	jalr	1968(ra) # 61d4 <malloc>
    4a2c:	f96d                	bnez	a0,4a1e <mem+0x40>
    while(m1){
    4a2e:	c881                	beqz	s1,4a3e <mem+0x60>
      m2 = *(char**)m1;
    4a30:	8526                	mv	a0,s1
    4a32:	6084                	ld	s1,0(s1)
      free(m1);
    4a34:	00001097          	auipc	ra,0x1
    4a38:	71e080e7          	jalr	1822(ra) # 6152 <free>
    while(m1){
    4a3c:	f8f5                	bnez	s1,4a30 <mem+0x52>
    m1 = malloc(1024*20);
    4a3e:	6515                	lui	a0,0x5
    4a40:	00001097          	auipc	ra,0x1
    4a44:	794080e7          	jalr	1940(ra) # 61d4 <malloc>
    if(m1 == 0){
    4a48:	c911                	beqz	a0,4a5c <mem+0x7e>
    free(m1);
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	708080e7          	jalr	1800(ra) # 6152 <free>
    exit(0);
    4a52:	4501                	li	a0,0
    4a54:	00001097          	auipc	ra,0x1
    4a58:	350080e7          	jalr	848(ra) # 5da4 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a5c:	85ce                	mv	a1,s3
    4a5e:	00003517          	auipc	a0,0x3
    4a62:	4ea50513          	add	a0,a0,1258 # 7f48 <malloc+0x1d74>
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	6b6080e7          	jalr	1718(ra) # 611c <printf>
      exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	00001097          	auipc	ra,0x1
    4a74:	334080e7          	jalr	820(ra) # 5da4 <exit>
      exit(0);
    4a78:	4501                	li	a0,0
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	32a080e7          	jalr	810(ra) # 5da4 <exit>

0000000000004a82 <sharedfd>:
{
    4a82:	7159                	add	sp,sp,-112
    4a84:	f486                	sd	ra,104(sp)
    4a86:	f0a2                	sd	s0,96(sp)
    4a88:	eca6                	sd	s1,88(sp)
    4a8a:	e8ca                	sd	s2,80(sp)
    4a8c:	e4ce                	sd	s3,72(sp)
    4a8e:	e0d2                	sd	s4,64(sp)
    4a90:	fc56                	sd	s5,56(sp)
    4a92:	f85a                	sd	s6,48(sp)
    4a94:	f45e                	sd	s7,40(sp)
    4a96:	1880                	add	s0,sp,112
    4a98:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	4ce50513          	add	a0,a0,1230 # 7f68 <malloc+0x1d94>
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	362080e7          	jalr	866(ra) # 5e04 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4aaa:	20200593          	li	a1,514
    4aae:	00003517          	auipc	a0,0x3
    4ab2:	4ba50513          	add	a0,a0,1210 # 7f68 <malloc+0x1d94>
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	33e080e7          	jalr	830(ra) # 5df4 <open>
  if(fd < 0){
    4abe:	04054a63          	bltz	a0,4b12 <sharedfd+0x90>
    4ac2:	892a                	mv	s2,a0
  pid = fork();
    4ac4:	00001097          	auipc	ra,0x1
    4ac8:	2d8080e7          	jalr	728(ra) # 5d9c <fork>
    4acc:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ace:	07000593          	li	a1,112
    4ad2:	e119                	bnez	a0,4ad8 <sharedfd+0x56>
    4ad4:	06300593          	li	a1,99
    4ad8:	4629                	li	a2,10
    4ada:	fa040513          	add	a0,s0,-96
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	0cc080e7          	jalr	204(ra) # 5baa <memset>
    4ae6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4aea:	4629                	li	a2,10
    4aec:	fa040593          	add	a1,s0,-96
    4af0:	854a                	mv	a0,s2
    4af2:	00001097          	auipc	ra,0x1
    4af6:	2d2080e7          	jalr	722(ra) # 5dc4 <write>
    4afa:	47a9                	li	a5,10
    4afc:	02f51963          	bne	a0,a5,4b2e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4b00:	34fd                	addw	s1,s1,-1
    4b02:	f4e5                	bnez	s1,4aea <sharedfd+0x68>
  if(pid == 0) {
    4b04:	04099363          	bnez	s3,4b4a <sharedfd+0xc8>
    exit(0);
    4b08:	4501                	li	a0,0
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	29a080e7          	jalr	666(ra) # 5da4 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b12:	85d2                	mv	a1,s4
    4b14:	00003517          	auipc	a0,0x3
    4b18:	46450513          	add	a0,a0,1124 # 7f78 <malloc+0x1da4>
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	600080e7          	jalr	1536(ra) # 611c <printf>
    exit(1);
    4b24:	4505                	li	a0,1
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	27e080e7          	jalr	638(ra) # 5da4 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b2e:	85d2                	mv	a1,s4
    4b30:	00003517          	auipc	a0,0x3
    4b34:	47050513          	add	a0,a0,1136 # 7fa0 <malloc+0x1dcc>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	5e4080e7          	jalr	1508(ra) # 611c <printf>
      exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	262080e7          	jalr	610(ra) # 5da4 <exit>
    wait(&xstatus);
    4b4a:	f9c40513          	add	a0,s0,-100
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	25e080e7          	jalr	606(ra) # 5dac <wait>
    if(xstatus != 0)
    4b56:	f9c42983          	lw	s3,-100(s0)
    4b5a:	00098763          	beqz	s3,4b68 <sharedfd+0xe6>
      exit(xstatus);
    4b5e:	854e                	mv	a0,s3
    4b60:	00001097          	auipc	ra,0x1
    4b64:	244080e7          	jalr	580(ra) # 5da4 <exit>
  close(fd);
    4b68:	854a                	mv	a0,s2
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	262080e7          	jalr	610(ra) # 5dcc <close>
  fd = open("sharedfd", 0);
    4b72:	4581                	li	a1,0
    4b74:	00003517          	auipc	a0,0x3
    4b78:	3f450513          	add	a0,a0,1012 # 7f68 <malloc+0x1d94>
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	278080e7          	jalr	632(ra) # 5df4 <open>
    4b84:	8baa                	mv	s7,a0
  nc = np = 0;
    4b86:	8ace                	mv	s5,s3
  if(fd < 0){
    4b88:	02054563          	bltz	a0,4bb2 <sharedfd+0x130>
    4b8c:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4b90:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b94:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b98:	4629                	li	a2,10
    4b9a:	fa040593          	add	a1,s0,-96
    4b9e:	855e                	mv	a0,s7
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	21c080e7          	jalr	540(ra) # 5dbc <read>
    4ba8:	02a05f63          	blez	a0,4be6 <sharedfd+0x164>
    4bac:	fa040793          	add	a5,s0,-96
    4bb0:	a01d                	j	4bd6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bb2:	85d2                	mv	a1,s4
    4bb4:	00003517          	auipc	a0,0x3
    4bb8:	40c50513          	add	a0,a0,1036 # 7fc0 <malloc+0x1dec>
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	560080e7          	jalr	1376(ra) # 611c <printf>
    exit(1);
    4bc4:	4505                	li	a0,1
    4bc6:	00001097          	auipc	ra,0x1
    4bca:	1de080e7          	jalr	478(ra) # 5da4 <exit>
        nc++;
    4bce:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bd0:	0785                	add	a5,a5,1
    4bd2:	fd2783e3          	beq	a5,s2,4b98 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bd6:	0007c703          	lbu	a4,0(a5)
    4bda:	fe970ae3          	beq	a4,s1,4bce <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bde:	ff6719e3          	bne	a4,s6,4bd0 <sharedfd+0x14e>
        np++;
    4be2:	2a85                	addw	s5,s5,1
    4be4:	b7f5                	j	4bd0 <sharedfd+0x14e>
  close(fd);
    4be6:	855e                	mv	a0,s7
    4be8:	00001097          	auipc	ra,0x1
    4bec:	1e4080e7          	jalr	484(ra) # 5dcc <close>
  unlink("sharedfd");
    4bf0:	00003517          	auipc	a0,0x3
    4bf4:	37850513          	add	a0,a0,888 # 7f68 <malloc+0x1d94>
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	20c080e7          	jalr	524(ra) # 5e04 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c00:	6789                	lui	a5,0x2
    4c02:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xee>
    4c06:	00f99763          	bne	s3,a5,4c14 <sharedfd+0x192>
    4c0a:	6789                	lui	a5,0x2
    4c0c:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xee>
    4c10:	02fa8063          	beq	s5,a5,4c30 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c14:	85d2                	mv	a1,s4
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	3d250513          	add	a0,a0,978 # 7fe8 <malloc+0x1e14>
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	4fe080e7          	jalr	1278(ra) # 611c <printf>
    exit(1);
    4c26:	4505                	li	a0,1
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	17c080e7          	jalr	380(ra) # 5da4 <exit>
    exit(0);
    4c30:	4501                	li	a0,0
    4c32:	00001097          	auipc	ra,0x1
    4c36:	172080e7          	jalr	370(ra) # 5da4 <exit>

0000000000004c3a <fourfiles>:
{
    4c3a:	7135                	add	sp,sp,-160
    4c3c:	ed06                	sd	ra,152(sp)
    4c3e:	e922                	sd	s0,144(sp)
    4c40:	e526                	sd	s1,136(sp)
    4c42:	e14a                	sd	s2,128(sp)
    4c44:	fcce                	sd	s3,120(sp)
    4c46:	f8d2                	sd	s4,112(sp)
    4c48:	f4d6                	sd	s5,104(sp)
    4c4a:	f0da                	sd	s6,96(sp)
    4c4c:	ecde                	sd	s7,88(sp)
    4c4e:	e8e2                	sd	s8,80(sp)
    4c50:	e4e6                	sd	s9,72(sp)
    4c52:	e0ea                	sd	s10,64(sp)
    4c54:	fc6e                	sd	s11,56(sp)
    4c56:	1100                	add	s0,sp,160
    4c58:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c5a:	00003797          	auipc	a5,0x3
    4c5e:	3a678793          	add	a5,a5,934 # 8000 <malloc+0x1e2c>
    4c62:	f6f43823          	sd	a5,-144(s0)
    4c66:	00003797          	auipc	a5,0x3
    4c6a:	3a278793          	add	a5,a5,930 # 8008 <malloc+0x1e34>
    4c6e:	f6f43c23          	sd	a5,-136(s0)
    4c72:	00003797          	auipc	a5,0x3
    4c76:	39e78793          	add	a5,a5,926 # 8010 <malloc+0x1e3c>
    4c7a:	f8f43023          	sd	a5,-128(s0)
    4c7e:	00003797          	auipc	a5,0x3
    4c82:	39a78793          	add	a5,a5,922 # 8018 <malloc+0x1e44>
    4c86:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c8a:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c8e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c90:	4481                	li	s1,0
    4c92:	4a11                	li	s4,4
    fname = names[pi];
    4c94:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c98:	854e                	mv	a0,s3
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	16a080e7          	jalr	362(ra) # 5e04 <unlink>
    pid = fork();
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	0fa080e7          	jalr	250(ra) # 5d9c <fork>
    if(pid < 0){
    4caa:	04054063          	bltz	a0,4cea <fourfiles+0xb0>
    if(pid == 0){
    4cae:	cd21                	beqz	a0,4d06 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4cb0:	2485                	addw	s1,s1,1
    4cb2:	0921                	add	s2,s2,8
    4cb4:	ff4490e3          	bne	s1,s4,4c94 <fourfiles+0x5a>
    4cb8:	4491                	li	s1,4
    wait(&xstatus);
    4cba:	f6c40513          	add	a0,s0,-148
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	0ee080e7          	jalr	238(ra) # 5dac <wait>
    if(xstatus != 0)
    4cc6:	f6c42a83          	lw	s5,-148(s0)
    4cca:	0c0a9863          	bnez	s5,4d9a <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4cce:	34fd                	addw	s1,s1,-1
    4cd0:	f4ed                	bnez	s1,4cba <fourfiles+0x80>
    4cd2:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cd6:	00008a17          	auipc	s4,0x8
    4cda:	fa2a0a13          	add	s4,s4,-94 # cc78 <buf>
    if(total != N*SZ){
    4cde:	6d05                	lui	s10,0x1
    4ce0:	770d0d13          	add	s10,s10,1904 # 1770 <exectest+0x18>
  for(i = 0; i < NCHILD; i++){
    4ce4:	03400d93          	li	s11,52
    4ce8:	a22d                	j	4e12 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4cea:	85e6                	mv	a1,s9
    4cec:	00002517          	auipc	a0,0x2
    4cf0:	2b450513          	add	a0,a0,692 # 6fa0 <malloc+0xdcc>
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	428080e7          	jalr	1064(ra) # 611c <printf>
      exit(1);
    4cfc:	4505                	li	a0,1
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	0a6080e7          	jalr	166(ra) # 5da4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d06:	20200593          	li	a1,514
    4d0a:	854e                	mv	a0,s3
    4d0c:	00001097          	auipc	ra,0x1
    4d10:	0e8080e7          	jalr	232(ra) # 5df4 <open>
    4d14:	892a                	mv	s2,a0
      if(fd < 0){
    4d16:	04054763          	bltz	a0,4d64 <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d1a:	1f400613          	li	a2,500
    4d1e:	0304859b          	addw	a1,s1,48
    4d22:	00008517          	auipc	a0,0x8
    4d26:	f5650513          	add	a0,a0,-170 # cc78 <buf>
    4d2a:	00001097          	auipc	ra,0x1
    4d2e:	e80080e7          	jalr	-384(ra) # 5baa <memset>
    4d32:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d34:	00008997          	auipc	s3,0x8
    4d38:	f4498993          	add	s3,s3,-188 # cc78 <buf>
    4d3c:	1f400613          	li	a2,500
    4d40:	85ce                	mv	a1,s3
    4d42:	854a                	mv	a0,s2
    4d44:	00001097          	auipc	ra,0x1
    4d48:	080080e7          	jalr	128(ra) # 5dc4 <write>
    4d4c:	85aa                	mv	a1,a0
    4d4e:	1f400793          	li	a5,500
    4d52:	02f51763          	bne	a0,a5,4d80 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d56:	34fd                	addw	s1,s1,-1
    4d58:	f0f5                	bnez	s1,4d3c <fourfiles+0x102>
      exit(0);
    4d5a:	4501                	li	a0,0
    4d5c:	00001097          	auipc	ra,0x1
    4d60:	048080e7          	jalr	72(ra) # 5da4 <exit>
        printf("create failed\n", s);
    4d64:	85e6                	mv	a1,s9
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	2ba50513          	add	a0,a0,698 # 8020 <malloc+0x1e4c>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	3ae080e7          	jalr	942(ra) # 611c <printf>
        exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	02c080e7          	jalr	44(ra) # 5da4 <exit>
          printf("write failed %d\n", n);
    4d80:	00003517          	auipc	a0,0x3
    4d84:	2b050513          	add	a0,a0,688 # 8030 <malloc+0x1e5c>
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	394080e7          	jalr	916(ra) # 611c <printf>
          exit(1);
    4d90:	4505                	li	a0,1
    4d92:	00001097          	auipc	ra,0x1
    4d96:	012080e7          	jalr	18(ra) # 5da4 <exit>
      exit(xstatus);
    4d9a:	8556                	mv	a0,s5
    4d9c:	00001097          	auipc	ra,0x1
    4da0:	008080e7          	jalr	8(ra) # 5da4 <exit>
          printf("wrong char\n", s);
    4da4:	85e6                	mv	a1,s9
    4da6:	00003517          	auipc	a0,0x3
    4daa:	2a250513          	add	a0,a0,674 # 8048 <malloc+0x1e74>
    4dae:	00001097          	auipc	ra,0x1
    4db2:	36e080e7          	jalr	878(ra) # 611c <printf>
          exit(1);
    4db6:	4505                	li	a0,1
    4db8:	00001097          	auipc	ra,0x1
    4dbc:	fec080e7          	jalr	-20(ra) # 5da4 <exit>
      total += n;
    4dc0:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dc4:	660d                	lui	a2,0x3
    4dc6:	85d2                	mv	a1,s4
    4dc8:	854e                	mv	a0,s3
    4dca:	00001097          	auipc	ra,0x1
    4dce:	ff2080e7          	jalr	-14(ra) # 5dbc <read>
    4dd2:	02a05063          	blez	a0,4df2 <fourfiles+0x1b8>
    4dd6:	00008797          	auipc	a5,0x8
    4dda:	ea278793          	add	a5,a5,-350 # cc78 <buf>
    4dde:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4de2:	0007c703          	lbu	a4,0(a5)
    4de6:	fa971fe3          	bne	a4,s1,4da4 <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4dea:	0785                	add	a5,a5,1
    4dec:	fed79be3          	bne	a5,a3,4de2 <fourfiles+0x1a8>
    4df0:	bfc1                	j	4dc0 <fourfiles+0x186>
    close(fd);
    4df2:	854e                	mv	a0,s3
    4df4:	00001097          	auipc	ra,0x1
    4df8:	fd8080e7          	jalr	-40(ra) # 5dcc <close>
    if(total != N*SZ){
    4dfc:	03a91863          	bne	s2,s10,4e2c <fourfiles+0x1f2>
    unlink(fname);
    4e00:	8562                	mv	a0,s8
    4e02:	00001097          	auipc	ra,0x1
    4e06:	002080e7          	jalr	2(ra) # 5e04 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e0a:	0ba1                	add	s7,s7,8
    4e0c:	2b05                	addw	s6,s6,1
    4e0e:	03bb0d63          	beq	s6,s11,4e48 <fourfiles+0x20e>
    fname = names[i];
    4e12:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e16:	4581                	li	a1,0
    4e18:	8562                	mv	a0,s8
    4e1a:	00001097          	auipc	ra,0x1
    4e1e:	fda080e7          	jalr	-38(ra) # 5df4 <open>
    4e22:	89aa                	mv	s3,a0
    total = 0;
    4e24:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e26:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e2a:	bf69                	j	4dc4 <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e2c:	85ca                	mv	a1,s2
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	22a50513          	add	a0,a0,554 # 8058 <malloc+0x1e84>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	2e6080e7          	jalr	742(ra) # 611c <printf>
      exit(1);
    4e3e:	4505                	li	a0,1
    4e40:	00001097          	auipc	ra,0x1
    4e44:	f64080e7          	jalr	-156(ra) # 5da4 <exit>
}
    4e48:	60ea                	ld	ra,152(sp)
    4e4a:	644a                	ld	s0,144(sp)
    4e4c:	64aa                	ld	s1,136(sp)
    4e4e:	690a                	ld	s2,128(sp)
    4e50:	79e6                	ld	s3,120(sp)
    4e52:	7a46                	ld	s4,112(sp)
    4e54:	7aa6                	ld	s5,104(sp)
    4e56:	7b06                	ld	s6,96(sp)
    4e58:	6be6                	ld	s7,88(sp)
    4e5a:	6c46                	ld	s8,80(sp)
    4e5c:	6ca6                	ld	s9,72(sp)
    4e5e:	6d06                	ld	s10,64(sp)
    4e60:	7de2                	ld	s11,56(sp)
    4e62:	610d                	add	sp,sp,160
    4e64:	8082                	ret

0000000000004e66 <concreate>:
{
    4e66:	7135                	add	sp,sp,-160
    4e68:	ed06                	sd	ra,152(sp)
    4e6a:	e922                	sd	s0,144(sp)
    4e6c:	e526                	sd	s1,136(sp)
    4e6e:	e14a                	sd	s2,128(sp)
    4e70:	fcce                	sd	s3,120(sp)
    4e72:	f8d2                	sd	s4,112(sp)
    4e74:	f4d6                	sd	s5,104(sp)
    4e76:	f0da                	sd	s6,96(sp)
    4e78:	ecde                	sd	s7,88(sp)
    4e7a:	1100                	add	s0,sp,160
    4e7c:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7e:	04300793          	li	a5,67
    4e82:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e86:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e8a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e8c:	4b0d                	li	s6,3
    4e8e:	4a85                	li	s5,1
      link("C0", file);
    4e90:	00003b97          	auipc	s7,0x3
    4e94:	1e0b8b93          	add	s7,s7,480 # 8070 <malloc+0x1e9c>
  for(i = 0; i < N; i++){
    4e98:	02800a13          	li	s4,40
    4e9c:	acc9                	j	516e <concreate+0x308>
      link("C0", file);
    4e9e:	fa840593          	add	a1,s0,-88
    4ea2:	855e                	mv	a0,s7
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	f70080e7          	jalr	-144(ra) # 5e14 <link>
    if(pid == 0) {
    4eac:	a465                	j	5154 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4eae:	4795                	li	a5,5
    4eb0:	02f9693b          	remw	s2,s2,a5
    4eb4:	4785                	li	a5,1
    4eb6:	02f90b63          	beq	s2,a5,4eec <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eba:	20200593          	li	a1,514
    4ebe:	fa840513          	add	a0,s0,-88
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	f32080e7          	jalr	-206(ra) # 5df4 <open>
      if(fd < 0){
    4eca:	26055c63          	bgez	a0,5142 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ece:	fa840593          	add	a1,s0,-88
    4ed2:	00003517          	auipc	a0,0x3
    4ed6:	1a650513          	add	a0,a0,422 # 8078 <malloc+0x1ea4>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	242080e7          	jalr	578(ra) # 611c <printf>
        exit(1);
    4ee2:	4505                	li	a0,1
    4ee4:	00001097          	auipc	ra,0x1
    4ee8:	ec0080e7          	jalr	-320(ra) # 5da4 <exit>
      link("C0", file);
    4eec:	fa840593          	add	a1,s0,-88
    4ef0:	00003517          	auipc	a0,0x3
    4ef4:	18050513          	add	a0,a0,384 # 8070 <malloc+0x1e9c>
    4ef8:	00001097          	auipc	ra,0x1
    4efc:	f1c080e7          	jalr	-228(ra) # 5e14 <link>
      exit(0);
    4f00:	4501                	li	a0,0
    4f02:	00001097          	auipc	ra,0x1
    4f06:	ea2080e7          	jalr	-350(ra) # 5da4 <exit>
        exit(1);
    4f0a:	4505                	li	a0,1
    4f0c:	00001097          	auipc	ra,0x1
    4f10:	e98080e7          	jalr	-360(ra) # 5da4 <exit>
  memset(fa, 0, sizeof(fa));
    4f14:	02800613          	li	a2,40
    4f18:	4581                	li	a1,0
    4f1a:	f8040513          	add	a0,s0,-128
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	c8c080e7          	jalr	-884(ra) # 5baa <memset>
  fd = open(".", 0);
    4f26:	4581                	li	a1,0
    4f28:	00002517          	auipc	a0,0x2
    4f2c:	ad050513          	add	a0,a0,-1328 # 69f8 <malloc+0x824>
    4f30:	00001097          	auipc	ra,0x1
    4f34:	ec4080e7          	jalr	-316(ra) # 5df4 <open>
    4f38:	892a                	mv	s2,a0
  n = 0;
    4f3a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f3c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f40:	02700b13          	li	s6,39
      fa[i] = 1;
    4f44:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f46:	4641                	li	a2,16
    4f48:	f7040593          	add	a1,s0,-144
    4f4c:	854a                	mv	a0,s2
    4f4e:	00001097          	auipc	ra,0x1
    4f52:	e6e080e7          	jalr	-402(ra) # 5dbc <read>
    4f56:	08a05263          	blez	a0,4fda <concreate+0x174>
    if(de.inum == 0)
    4f5a:	f7045783          	lhu	a5,-144(s0)
    4f5e:	d7e5                	beqz	a5,4f46 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f60:	f7244783          	lbu	a5,-142(s0)
    4f64:	ff4791e3          	bne	a5,s4,4f46 <concreate+0xe0>
    4f68:	f7444783          	lbu	a5,-140(s0)
    4f6c:	ffe9                	bnez	a5,4f46 <concreate+0xe0>
      i = de.name[1] - '0';
    4f6e:	f7344783          	lbu	a5,-141(s0)
    4f72:	fd07879b          	addw	a5,a5,-48
    4f76:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f7a:	02eb6063          	bltu	s6,a4,4f9a <concreate+0x134>
      if(fa[i]){
    4f7e:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0xa4>
    4f82:	97a2                	add	a5,a5,s0
    4f84:	fd07c783          	lbu	a5,-48(a5)
    4f88:	eb8d                	bnez	a5,4fba <concreate+0x154>
      fa[i] = 1;
    4f8a:	fb070793          	add	a5,a4,-80
    4f8e:	00878733          	add	a4,a5,s0
    4f92:	fd770823          	sb	s7,-48(a4)
      n++;
    4f96:	2a85                	addw	s5,s5,1
    4f98:	b77d                	j	4f46 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f9a:	f7240613          	add	a2,s0,-142
    4f9e:	85ce                	mv	a1,s3
    4fa0:	00003517          	auipc	a0,0x3
    4fa4:	0f850513          	add	a0,a0,248 # 8098 <malloc+0x1ec4>
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	174080e7          	jalr	372(ra) # 611c <printf>
        exit(1);
    4fb0:	4505                	li	a0,1
    4fb2:	00001097          	auipc	ra,0x1
    4fb6:	df2080e7          	jalr	-526(ra) # 5da4 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fba:	f7240613          	add	a2,s0,-142
    4fbe:	85ce                	mv	a1,s3
    4fc0:	00003517          	auipc	a0,0x3
    4fc4:	0f850513          	add	a0,a0,248 # 80b8 <malloc+0x1ee4>
    4fc8:	00001097          	auipc	ra,0x1
    4fcc:	154080e7          	jalr	340(ra) # 611c <printf>
        exit(1);
    4fd0:	4505                	li	a0,1
    4fd2:	00001097          	auipc	ra,0x1
    4fd6:	dd2080e7          	jalr	-558(ra) # 5da4 <exit>
  close(fd);
    4fda:	854a                	mv	a0,s2
    4fdc:	00001097          	auipc	ra,0x1
    4fe0:	df0080e7          	jalr	-528(ra) # 5dcc <close>
  if(n != N){
    4fe4:	02800793          	li	a5,40
    4fe8:	00fa9763          	bne	s5,a5,4ff6 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fec:	4a8d                	li	s5,3
    4fee:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4ff0:	02800a13          	li	s4,40
    4ff4:	a8c9                	j	50c6 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff6:	85ce                	mv	a1,s3
    4ff8:	00003517          	auipc	a0,0x3
    4ffc:	0e850513          	add	a0,a0,232 # 80e0 <malloc+0x1f0c>
    5000:	00001097          	auipc	ra,0x1
    5004:	11c080e7          	jalr	284(ra) # 611c <printf>
    exit(1);
    5008:	4505                	li	a0,1
    500a:	00001097          	auipc	ra,0x1
    500e:	d9a080e7          	jalr	-614(ra) # 5da4 <exit>
      printf("%s: fork failed\n", s);
    5012:	85ce                	mv	a1,s3
    5014:	00002517          	auipc	a0,0x2
    5018:	b8450513          	add	a0,a0,-1148 # 6b98 <malloc+0x9c4>
    501c:	00001097          	auipc	ra,0x1
    5020:	100080e7          	jalr	256(ra) # 611c <printf>
      exit(1);
    5024:	4505                	li	a0,1
    5026:	00001097          	auipc	ra,0x1
    502a:	d7e080e7          	jalr	-642(ra) # 5da4 <exit>
      close(open(file, 0));
    502e:	4581                	li	a1,0
    5030:	fa840513          	add	a0,s0,-88
    5034:	00001097          	auipc	ra,0x1
    5038:	dc0080e7          	jalr	-576(ra) # 5df4 <open>
    503c:	00001097          	auipc	ra,0x1
    5040:	d90080e7          	jalr	-624(ra) # 5dcc <close>
      close(open(file, 0));
    5044:	4581                	li	a1,0
    5046:	fa840513          	add	a0,s0,-88
    504a:	00001097          	auipc	ra,0x1
    504e:	daa080e7          	jalr	-598(ra) # 5df4 <open>
    5052:	00001097          	auipc	ra,0x1
    5056:	d7a080e7          	jalr	-646(ra) # 5dcc <close>
      close(open(file, 0));
    505a:	4581                	li	a1,0
    505c:	fa840513          	add	a0,s0,-88
    5060:	00001097          	auipc	ra,0x1
    5064:	d94080e7          	jalr	-620(ra) # 5df4 <open>
    5068:	00001097          	auipc	ra,0x1
    506c:	d64080e7          	jalr	-668(ra) # 5dcc <close>
      close(open(file, 0));
    5070:	4581                	li	a1,0
    5072:	fa840513          	add	a0,s0,-88
    5076:	00001097          	auipc	ra,0x1
    507a:	d7e080e7          	jalr	-642(ra) # 5df4 <open>
    507e:	00001097          	auipc	ra,0x1
    5082:	d4e080e7          	jalr	-690(ra) # 5dcc <close>
      close(open(file, 0));
    5086:	4581                	li	a1,0
    5088:	fa840513          	add	a0,s0,-88
    508c:	00001097          	auipc	ra,0x1
    5090:	d68080e7          	jalr	-664(ra) # 5df4 <open>
    5094:	00001097          	auipc	ra,0x1
    5098:	d38080e7          	jalr	-712(ra) # 5dcc <close>
      close(open(file, 0));
    509c:	4581                	li	a1,0
    509e:	fa840513          	add	a0,s0,-88
    50a2:	00001097          	auipc	ra,0x1
    50a6:	d52080e7          	jalr	-686(ra) # 5df4 <open>
    50aa:	00001097          	auipc	ra,0x1
    50ae:	d22080e7          	jalr	-734(ra) # 5dcc <close>
    if(pid == 0)
    50b2:	08090363          	beqz	s2,5138 <concreate+0x2d2>
      wait(0);
    50b6:	4501                	li	a0,0
    50b8:	00001097          	auipc	ra,0x1
    50bc:	cf4080e7          	jalr	-780(ra) # 5dac <wait>
  for(i = 0; i < N; i++){
    50c0:	2485                	addw	s1,s1,1
    50c2:	0f448563          	beq	s1,s4,51ac <concreate+0x346>
    file[1] = '0' + i;
    50c6:	0304879b          	addw	a5,s1,48
    50ca:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50ce:	00001097          	auipc	ra,0x1
    50d2:	cce080e7          	jalr	-818(ra) # 5d9c <fork>
    50d6:	892a                	mv	s2,a0
    if(pid < 0){
    50d8:	f2054de3          	bltz	a0,5012 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50dc:	0354e73b          	remw	a4,s1,s5
    50e0:	00a767b3          	or	a5,a4,a0
    50e4:	2781                	sext.w	a5,a5
    50e6:	d7a1                	beqz	a5,502e <concreate+0x1c8>
    50e8:	01671363          	bne	a4,s6,50ee <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50ec:	f129                	bnez	a0,502e <concreate+0x1c8>
      unlink(file);
    50ee:	fa840513          	add	a0,s0,-88
    50f2:	00001097          	auipc	ra,0x1
    50f6:	d12080e7          	jalr	-750(ra) # 5e04 <unlink>
      unlink(file);
    50fa:	fa840513          	add	a0,s0,-88
    50fe:	00001097          	auipc	ra,0x1
    5102:	d06080e7          	jalr	-762(ra) # 5e04 <unlink>
      unlink(file);
    5106:	fa840513          	add	a0,s0,-88
    510a:	00001097          	auipc	ra,0x1
    510e:	cfa080e7          	jalr	-774(ra) # 5e04 <unlink>
      unlink(file);
    5112:	fa840513          	add	a0,s0,-88
    5116:	00001097          	auipc	ra,0x1
    511a:	cee080e7          	jalr	-786(ra) # 5e04 <unlink>
      unlink(file);
    511e:	fa840513          	add	a0,s0,-88
    5122:	00001097          	auipc	ra,0x1
    5126:	ce2080e7          	jalr	-798(ra) # 5e04 <unlink>
      unlink(file);
    512a:	fa840513          	add	a0,s0,-88
    512e:	00001097          	auipc	ra,0x1
    5132:	cd6080e7          	jalr	-810(ra) # 5e04 <unlink>
    5136:	bfb5                	j	50b2 <concreate+0x24c>
      exit(0);
    5138:	4501                	li	a0,0
    513a:	00001097          	auipc	ra,0x1
    513e:	c6a080e7          	jalr	-918(ra) # 5da4 <exit>
      close(fd);
    5142:	00001097          	auipc	ra,0x1
    5146:	c8a080e7          	jalr	-886(ra) # 5dcc <close>
    if(pid == 0) {
    514a:	bb5d                	j	4f00 <concreate+0x9a>
      close(fd);
    514c:	00001097          	auipc	ra,0x1
    5150:	c80080e7          	jalr	-896(ra) # 5dcc <close>
      wait(&xstatus);
    5154:	f6c40513          	add	a0,s0,-148
    5158:	00001097          	auipc	ra,0x1
    515c:	c54080e7          	jalr	-940(ra) # 5dac <wait>
      if(xstatus != 0)
    5160:	f6c42483          	lw	s1,-148(s0)
    5164:	da0493e3          	bnez	s1,4f0a <concreate+0xa4>
  for(i = 0; i < N; i++){
    5168:	2905                	addw	s2,s2,1
    516a:	db4905e3          	beq	s2,s4,4f14 <concreate+0xae>
    file[1] = '0' + i;
    516e:	0309079b          	addw	a5,s2,48
    5172:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5176:	fa840513          	add	a0,s0,-88
    517a:	00001097          	auipc	ra,0x1
    517e:	c8a080e7          	jalr	-886(ra) # 5e04 <unlink>
    pid = fork();
    5182:	00001097          	auipc	ra,0x1
    5186:	c1a080e7          	jalr	-998(ra) # 5d9c <fork>
    if(pid && (i % 3) == 1){
    518a:	d20502e3          	beqz	a0,4eae <concreate+0x48>
    518e:	036967bb          	remw	a5,s2,s6
    5192:	d15786e3          	beq	a5,s5,4e9e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5196:	20200593          	li	a1,514
    519a:	fa840513          	add	a0,s0,-88
    519e:	00001097          	auipc	ra,0x1
    51a2:	c56080e7          	jalr	-938(ra) # 5df4 <open>
      if(fd < 0){
    51a6:	fa0553e3          	bgez	a0,514c <concreate+0x2e6>
    51aa:	b315                	j	4ece <concreate+0x68>
}
    51ac:	60ea                	ld	ra,152(sp)
    51ae:	644a                	ld	s0,144(sp)
    51b0:	64aa                	ld	s1,136(sp)
    51b2:	690a                	ld	s2,128(sp)
    51b4:	79e6                	ld	s3,120(sp)
    51b6:	7a46                	ld	s4,112(sp)
    51b8:	7aa6                	ld	s5,104(sp)
    51ba:	7b06                	ld	s6,96(sp)
    51bc:	6be6                	ld	s7,88(sp)
    51be:	610d                	add	sp,sp,160
    51c0:	8082                	ret

00000000000051c2 <bigfile>:
{
    51c2:	7139                	add	sp,sp,-64
    51c4:	fc06                	sd	ra,56(sp)
    51c6:	f822                	sd	s0,48(sp)
    51c8:	f426                	sd	s1,40(sp)
    51ca:	f04a                	sd	s2,32(sp)
    51cc:	ec4e                	sd	s3,24(sp)
    51ce:	e852                	sd	s4,16(sp)
    51d0:	e456                	sd	s5,8(sp)
    51d2:	0080                	add	s0,sp,64
    51d4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d6:	00003517          	auipc	a0,0x3
    51da:	f4250513          	add	a0,a0,-190 # 8118 <malloc+0x1f44>
    51de:	00001097          	auipc	ra,0x1
    51e2:	c26080e7          	jalr	-986(ra) # 5e04 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e6:	20200593          	li	a1,514
    51ea:	00003517          	auipc	a0,0x3
    51ee:	f2e50513          	add	a0,a0,-210 # 8118 <malloc+0x1f44>
    51f2:	00001097          	auipc	ra,0x1
    51f6:	c02080e7          	jalr	-1022(ra) # 5df4 <open>
    51fa:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51fc:	4481                	li	s1,0
    memset(buf, i, SZ);
    51fe:	00008917          	auipc	s2,0x8
    5202:	a7a90913          	add	s2,s2,-1414 # cc78 <buf>
  for(i = 0; i < N; i++){
    5206:	4a51                	li	s4,20
  if(fd < 0){
    5208:	0a054063          	bltz	a0,52a8 <bigfile+0xe6>
    memset(buf, i, SZ);
    520c:	25800613          	li	a2,600
    5210:	85a6                	mv	a1,s1
    5212:	854a                	mv	a0,s2
    5214:	00001097          	auipc	ra,0x1
    5218:	996080e7          	jalr	-1642(ra) # 5baa <memset>
    if(write(fd, buf, SZ) != SZ){
    521c:	25800613          	li	a2,600
    5220:	85ca                	mv	a1,s2
    5222:	854e                	mv	a0,s3
    5224:	00001097          	auipc	ra,0x1
    5228:	ba0080e7          	jalr	-1120(ra) # 5dc4 <write>
    522c:	25800793          	li	a5,600
    5230:	08f51a63          	bne	a0,a5,52c4 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5234:	2485                	addw	s1,s1,1
    5236:	fd449be3          	bne	s1,s4,520c <bigfile+0x4a>
  close(fd);
    523a:	854e                	mv	a0,s3
    523c:	00001097          	auipc	ra,0x1
    5240:	b90080e7          	jalr	-1136(ra) # 5dcc <close>
  fd = open("bigfile.dat", 0);
    5244:	4581                	li	a1,0
    5246:	00003517          	auipc	a0,0x3
    524a:	ed250513          	add	a0,a0,-302 # 8118 <malloc+0x1f44>
    524e:	00001097          	auipc	ra,0x1
    5252:	ba6080e7          	jalr	-1114(ra) # 5df4 <open>
    5256:	8a2a                	mv	s4,a0
  total = 0;
    5258:	4981                	li	s3,0
  for(i = 0; ; i++){
    525a:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    525c:	00008917          	auipc	s2,0x8
    5260:	a1c90913          	add	s2,s2,-1508 # cc78 <buf>
  if(fd < 0){
    5264:	06054e63          	bltz	a0,52e0 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5268:	12c00613          	li	a2,300
    526c:	85ca                	mv	a1,s2
    526e:	8552                	mv	a0,s4
    5270:	00001097          	auipc	ra,0x1
    5274:	b4c080e7          	jalr	-1204(ra) # 5dbc <read>
    if(cc < 0){
    5278:	08054263          	bltz	a0,52fc <bigfile+0x13a>
    if(cc == 0)
    527c:	c971                	beqz	a0,5350 <bigfile+0x18e>
    if(cc != SZ/2){
    527e:	12c00793          	li	a5,300
    5282:	08f51b63          	bne	a0,a5,5318 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5286:	01f4d79b          	srlw	a5,s1,0x1f
    528a:	9fa5                	addw	a5,a5,s1
    528c:	4017d79b          	sraw	a5,a5,0x1
    5290:	00094703          	lbu	a4,0(s2)
    5294:	0af71063          	bne	a4,a5,5334 <bigfile+0x172>
    5298:	12b94703          	lbu	a4,299(s2)
    529c:	08f71c63          	bne	a4,a5,5334 <bigfile+0x172>
    total += cc;
    52a0:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    52a4:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a6:	b7c9                	j	5268 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a8:	85d6                	mv	a1,s5
    52aa:	00003517          	auipc	a0,0x3
    52ae:	e7e50513          	add	a0,a0,-386 # 8128 <malloc+0x1f54>
    52b2:	00001097          	auipc	ra,0x1
    52b6:	e6a080e7          	jalr	-406(ra) # 611c <printf>
    exit(1);
    52ba:	4505                	li	a0,1
    52bc:	00001097          	auipc	ra,0x1
    52c0:	ae8080e7          	jalr	-1304(ra) # 5da4 <exit>
      printf("%s: write bigfile failed\n", s);
    52c4:	85d6                	mv	a1,s5
    52c6:	00003517          	auipc	a0,0x3
    52ca:	e8250513          	add	a0,a0,-382 # 8148 <malloc+0x1f74>
    52ce:	00001097          	auipc	ra,0x1
    52d2:	e4e080e7          	jalr	-434(ra) # 611c <printf>
      exit(1);
    52d6:	4505                	li	a0,1
    52d8:	00001097          	auipc	ra,0x1
    52dc:	acc080e7          	jalr	-1332(ra) # 5da4 <exit>
    printf("%s: cannot open bigfile\n", s);
    52e0:	85d6                	mv	a1,s5
    52e2:	00003517          	auipc	a0,0x3
    52e6:	e8650513          	add	a0,a0,-378 # 8168 <malloc+0x1f94>
    52ea:	00001097          	auipc	ra,0x1
    52ee:	e32080e7          	jalr	-462(ra) # 611c <printf>
    exit(1);
    52f2:	4505                	li	a0,1
    52f4:	00001097          	auipc	ra,0x1
    52f8:	ab0080e7          	jalr	-1360(ra) # 5da4 <exit>
      printf("%s: read bigfile failed\n", s);
    52fc:	85d6                	mv	a1,s5
    52fe:	00003517          	auipc	a0,0x3
    5302:	e8a50513          	add	a0,a0,-374 # 8188 <malloc+0x1fb4>
    5306:	00001097          	auipc	ra,0x1
    530a:	e16080e7          	jalr	-490(ra) # 611c <printf>
      exit(1);
    530e:	4505                	li	a0,1
    5310:	00001097          	auipc	ra,0x1
    5314:	a94080e7          	jalr	-1388(ra) # 5da4 <exit>
      printf("%s: short read bigfile\n", s);
    5318:	85d6                	mv	a1,s5
    531a:	00003517          	auipc	a0,0x3
    531e:	e8e50513          	add	a0,a0,-370 # 81a8 <malloc+0x1fd4>
    5322:	00001097          	auipc	ra,0x1
    5326:	dfa080e7          	jalr	-518(ra) # 611c <printf>
      exit(1);
    532a:	4505                	li	a0,1
    532c:	00001097          	auipc	ra,0x1
    5330:	a78080e7          	jalr	-1416(ra) # 5da4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5334:	85d6                	mv	a1,s5
    5336:	00003517          	auipc	a0,0x3
    533a:	e8a50513          	add	a0,a0,-374 # 81c0 <malloc+0x1fec>
    533e:	00001097          	auipc	ra,0x1
    5342:	dde080e7          	jalr	-546(ra) # 611c <printf>
      exit(1);
    5346:	4505                	li	a0,1
    5348:	00001097          	auipc	ra,0x1
    534c:	a5c080e7          	jalr	-1444(ra) # 5da4 <exit>
  close(fd);
    5350:	8552                	mv	a0,s4
    5352:	00001097          	auipc	ra,0x1
    5356:	a7a080e7          	jalr	-1414(ra) # 5dcc <close>
  if(total != N*SZ){
    535a:	678d                	lui	a5,0x3
    535c:	ee078793          	add	a5,a5,-288 # 2ee0 <sbrklast+0x76>
    5360:	02f99363          	bne	s3,a5,5386 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5364:	00003517          	auipc	a0,0x3
    5368:	db450513          	add	a0,a0,-588 # 8118 <malloc+0x1f44>
    536c:	00001097          	auipc	ra,0x1
    5370:	a98080e7          	jalr	-1384(ra) # 5e04 <unlink>
}
    5374:	70e2                	ld	ra,56(sp)
    5376:	7442                	ld	s0,48(sp)
    5378:	74a2                	ld	s1,40(sp)
    537a:	7902                	ld	s2,32(sp)
    537c:	69e2                	ld	s3,24(sp)
    537e:	6a42                	ld	s4,16(sp)
    5380:	6aa2                	ld	s5,8(sp)
    5382:	6121                	add	sp,sp,64
    5384:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5386:	85d6                	mv	a1,s5
    5388:	00003517          	auipc	a0,0x3
    538c:	e5850513          	add	a0,a0,-424 # 81e0 <malloc+0x200c>
    5390:	00001097          	auipc	ra,0x1
    5394:	d8c080e7          	jalr	-628(ra) # 611c <printf>
    exit(1);
    5398:	4505                	li	a0,1
    539a:	00001097          	auipc	ra,0x1
    539e:	a0a080e7          	jalr	-1526(ra) # 5da4 <exit>

00000000000053a2 <writebigFile>:
{
    53a2:	7139                	add	sp,sp,-64
    53a4:	fc06                	sd	ra,56(sp)
    53a6:	f822                	sd	s0,48(sp)
    53a8:	f426                	sd	s1,40(sp)
    53aa:	f04a                	sd	s2,32(sp)
    53ac:	ec4e                	sd	s3,24(sp)
    53ae:	e852                	sd	s4,16(sp)
    53b0:	e456                	sd	s5,8(sp)
    53b2:	0080                	add	s0,sp,64
    53b4:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    53b6:	20200593          	li	a1,514
    53ba:	00001517          	auipc	a0,0x1
    53be:	34650513          	add	a0,a0,838 # 6700 <malloc+0x52c>
    53c2:	00001097          	auipc	ra,0x1
    53c6:	a32080e7          	jalr	-1486(ra) # 5df4 <open>
  if(fd < 0){
    53ca:	08054863          	bltz	a0,545a <writebigFile+0xb8>
    53ce:	89aa                	mv	s3,a0
  printf("(MAXFILE: %d )  ", MAXFILE);
    53d0:	65c1                	lui	a1,0x10
    53d2:	10b58593          	add	a1,a1,267 # 1010b <base+0x493>
    53d6:	00001517          	auipc	a0,0x1
    53da:	35250513          	add	a0,a0,850 # 6728 <malloc+0x554>
    53de:	00001097          	auipc	ra,0x1
    53e2:	d3e080e7          	jalr	-706(ra) # 611c <printf>
  for(i = 0; i < MAXFILE; i++){
    53e6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    53e8:	00008917          	auipc	s2,0x8
    53ec:	89090913          	add	s2,s2,-1904 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
    53f0:	6a41                	lui	s4,0x10
    53f2:	10ba0a13          	add	s4,s4,267 # 1010b <base+0x493>
    ((int*)buf)[0] = i;
    53f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    53fa:	40000613          	li	a2,1024
    53fe:	85ca                	mv	a1,s2
    5400:	854e                	mv	a0,s3
    5402:	00001097          	auipc	ra,0x1
    5406:	9c2080e7          	jalr	-1598(ra) # 5dc4 <write>
    540a:	40000793          	li	a5,1024
    540e:	06f51163          	bne	a0,a5,5470 <writebigFile+0xce>
  for(i = 0; i < MAXFILE; i++){
    5412:	2485                	addw	s1,s1,1
    5414:	ff4491e3          	bne	s1,s4,53f6 <writebigFile+0x54>
  close(fd);
    5418:	854e                	mv	a0,s3
    541a:	00001097          	auipc	ra,0x1
    541e:	9b2080e7          	jalr	-1614(ra) # 5dcc <close>
  fd = open("big", O_RDONLY);
    5422:	4581                	li	a1,0
    5424:	00001517          	auipc	a0,0x1
    5428:	2dc50513          	add	a0,a0,732 # 6700 <malloc+0x52c>
    542c:	00001097          	auipc	ra,0x1
    5430:	9c8080e7          	jalr	-1592(ra) # 5df4 <open>
    5434:	8a2a                	mv	s4,a0
  n = 0;
    5436:	4901                	li	s2,0
    i = read(fd, buf, BSIZE);
    5438:	00008997          	auipc	s3,0x8
    543c:	84098993          	add	s3,s3,-1984 # cc78 <buf>
  if(fd < 0){
    5440:	0a055b63          	bgez	a0,54f6 <writebigFile+0x154>
    printf("%s: error: open big failed!\n", s);
    5444:	85d6                	mv	a1,s5
    5446:	00001517          	auipc	a0,0x1
    544a:	32250513          	add	a0,a0,802 # 6768 <malloc+0x594>
    544e:	00001097          	auipc	ra,0x1
    5452:	cce080e7          	jalr	-818(ra) # 611c <printf>
    return 0;
    5456:	4481                	li	s1,0
    5458:	a03d                	j	5486 <writebigFile+0xe4>
    printf("%s: error: creat big failed!\n", s);
    545a:	85d6                	mv	a1,s5
    545c:	00001517          	auipc	a0,0x1
    5460:	2ac50513          	add	a0,a0,684 # 6708 <malloc+0x534>
    5464:	00001097          	auipc	ra,0x1
    5468:	cb8080e7          	jalr	-840(ra) # 611c <printf>
    return 0;
    546c:	4481                	li	s1,0
    546e:	a821                	j	5486 <writebigFile+0xe4>
      printf("%s: error: write big file failed\n", s, i);
    5470:	8626                	mv	a2,s1
    5472:	85d6                	mv	a1,s5
    5474:	00001517          	auipc	a0,0x1
    5478:	2cc50513          	add	a0,a0,716 # 6740 <malloc+0x56c>
    547c:	00001097          	auipc	ra,0x1
    5480:	ca0080e7          	jalr	-864(ra) # 611c <printf>
      return 0;
    5484:	4481                	li	s1,0
}
    5486:	8526                	mv	a0,s1
    5488:	70e2                	ld	ra,56(sp)
    548a:	7442                	ld	s0,48(sp)
    548c:	74a2                	ld	s1,40(sp)
    548e:	7902                	ld	s2,32(sp)
    5490:	69e2                	ld	s3,24(sp)
    5492:	6a42                	ld	s4,16(sp)
    5494:	6aa2                	ld	s5,8(sp)
    5496:	6121                	add	sp,sp,64
    5498:	8082                	ret
      if(n == MAXFILE - 1){
    549a:	67c1                	lui	a5,0x10
    549c:	10a78793          	add	a5,a5,266 # 1010a <base+0x492>
    54a0:	02f90363          	beq	s2,a5,54c6 <writebigFile+0x124>
  close(fd);
    54a4:	8552                	mv	a0,s4
    54a6:	00001097          	auipc	ra,0x1
    54aa:	926080e7          	jalr	-1754(ra) # 5dcc <close>
  if(unlink("big") < 0){
    54ae:	00001517          	auipc	a0,0x1
    54b2:	25250513          	add	a0,a0,594 # 6700 <malloc+0x52c>
    54b6:	00001097          	auipc	ra,0x1
    54ba:	94e080e7          	jalr	-1714(ra) # 5e04 <unlink>
    54be:	06054a63          	bltz	a0,5532 <writebigFile+0x190>
  return 1;
    54c2:	4485                	li	s1,1
    54c4:	b7c9                	j	5486 <writebigFile+0xe4>
        printf("%s: read only %d blocks from big", s, n);
    54c6:	863e                	mv	a2,a5
    54c8:	85d6                	mv	a1,s5
    54ca:	00001517          	auipc	a0,0x1
    54ce:	2be50513          	add	a0,a0,702 # 6788 <malloc+0x5b4>
    54d2:	00001097          	auipc	ra,0x1
    54d6:	c4a080e7          	jalr	-950(ra) # 611c <printf>
        return 0;
    54da:	b775                	j	5486 <writebigFile+0xe4>
      printf("%s: read failed %d\n", s, i);
    54dc:	862a                	mv	a2,a0
    54de:	85d6                	mv	a1,s5
    54e0:	00001517          	auipc	a0,0x1
    54e4:	2d050513          	add	a0,a0,720 # 67b0 <malloc+0x5dc>
    54e8:	00001097          	auipc	ra,0x1
    54ec:	c34080e7          	jalr	-972(ra) # 611c <printf>
      return 0;
    54f0:	4481                	li	s1,0
    54f2:	bf51                	j	5486 <writebigFile+0xe4>
    n++;
    54f4:	2905                	addw	s2,s2,1
    i = read(fd, buf, BSIZE);
    54f6:	40000613          	li	a2,1024
    54fa:	85ce                	mv	a1,s3
    54fc:	8552                	mv	a0,s4
    54fe:	00001097          	auipc	ra,0x1
    5502:	8be080e7          	jalr	-1858(ra) # 5dbc <read>
    5506:	84aa                	mv	s1,a0
    if(i == 0){
    5508:	d949                	beqz	a0,549a <writebigFile+0xf8>
    } else if(i != BSIZE){
    550a:	40000793          	li	a5,1024
    550e:	fcf517e3          	bne	a0,a5,54dc <writebigFile+0x13a>
    if(((int*)buf)[0] != n){
    5512:	0009a683          	lw	a3,0(s3)
    5516:	fd268fe3          	beq	a3,s2,54f4 <writebigFile+0x152>
      printf("%s: read content of block %d is %d\n", s,
    551a:	864a                	mv	a2,s2
    551c:	85d6                	mv	a1,s5
    551e:	00001517          	auipc	a0,0x1
    5522:	2aa50513          	add	a0,a0,682 # 67c8 <malloc+0x5f4>
    5526:	00001097          	auipc	ra,0x1
    552a:	bf6080e7          	jalr	-1034(ra) # 611c <printf>
     return 0;
    552e:	4481                	li	s1,0
    5530:	bf99                	j	5486 <writebigFile+0xe4>
    printf("%s: unlink big failed\n", s);
    5532:	85d6                	mv	a1,s5
    5534:	00001517          	auipc	a0,0x1
    5538:	2bc50513          	add	a0,a0,700 # 67f0 <malloc+0x61c>
    553c:	00001097          	auipc	ra,0x1
    5540:	be0080e7          	jalr	-1056(ra) # 611c <printf>
    return 0;
    5544:	b789                	j	5486 <writebigFile+0xe4>

0000000000005546 <fsfull>:
{
    5546:	7135                	add	sp,sp,-160
    5548:	ed06                	sd	ra,152(sp)
    554a:	e922                	sd	s0,144(sp)
    554c:	e526                	sd	s1,136(sp)
    554e:	e14a                	sd	s2,128(sp)
    5550:	fcce                	sd	s3,120(sp)
    5552:	f8d2                	sd	s4,112(sp)
    5554:	f4d6                	sd	s5,104(sp)
    5556:	f0da                	sd	s6,96(sp)
    5558:	ecde                	sd	s7,88(sp)
    555a:	e8e2                	sd	s8,80(sp)
    555c:	e4e6                	sd	s9,72(sp)
    555e:	e0ea                	sd	s10,64(sp)
    5560:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    5562:	00003517          	auipc	a0,0x3
    5566:	c9e50513          	add	a0,a0,-866 # 8200 <malloc+0x202c>
    556a:	00001097          	auipc	ra,0x1
    556e:	bb2080e7          	jalr	-1102(ra) # 611c <printf>
  for(nfiles = 0; ; nfiles++){
    5572:	4481                	li	s1,0
    name[0] = 'f';
    5574:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5578:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    557c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5580:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5582:	00003c97          	auipc	s9,0x3
    5586:	c8ec8c93          	add	s9,s9,-882 # 8210 <malloc+0x203c>
    name[0] = 'f';
    558a:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    558e:	0384c7bb          	divw	a5,s1,s8
    5592:	0307879b          	addw	a5,a5,48
    5596:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    559a:	0384e7bb          	remw	a5,s1,s8
    559e:	0377c7bb          	divw	a5,a5,s7
    55a2:	0307879b          	addw	a5,a5,48
    55a6:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    55aa:	0374e7bb          	remw	a5,s1,s7
    55ae:	0367c7bb          	divw	a5,a5,s6
    55b2:	0307879b          	addw	a5,a5,48
    55b6:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    55ba:	0364e7bb          	remw	a5,s1,s6
    55be:	0307879b          	addw	a5,a5,48
    55c2:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    55c6:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    55ca:	f6040593          	add	a1,s0,-160
    55ce:	8566                	mv	a0,s9
    55d0:	00001097          	auipc	ra,0x1
    55d4:	b4c080e7          	jalr	-1204(ra) # 611c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    55d8:	20200593          	li	a1,514
    55dc:	f6040513          	add	a0,s0,-160
    55e0:	00001097          	auipc	ra,0x1
    55e4:	814080e7          	jalr	-2028(ra) # 5df4 <open>
    55e8:	892a                	mv	s2,a0
    if(fd < 0){
    55ea:	0a055563          	bgez	a0,5694 <fsfull+0x14e>
      printf("open %s failed\n", name);
    55ee:	f6040593          	add	a1,s0,-160
    55f2:	00003517          	auipc	a0,0x3
    55f6:	c2e50513          	add	a0,a0,-978 # 8220 <malloc+0x204c>
    55fa:	00001097          	auipc	ra,0x1
    55fe:	b22080e7          	jalr	-1246(ra) # 611c <printf>
  while(nfiles >= 0){
    5602:	0604c363          	bltz	s1,5668 <fsfull+0x122>
    name[0] = 'f';
    5606:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    560a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    560e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5612:	4929                	li	s2,10
  while(nfiles >= 0){
    5614:	5afd                	li	s5,-1
    name[0] = 'f';
    5616:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    561a:	0344c7bb          	divw	a5,s1,s4
    561e:	0307879b          	addw	a5,a5,48
    5622:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5626:	0344e7bb          	remw	a5,s1,s4
    562a:	0337c7bb          	divw	a5,a5,s3
    562e:	0307879b          	addw	a5,a5,48
    5632:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5636:	0334e7bb          	remw	a5,s1,s3
    563a:	0327c7bb          	divw	a5,a5,s2
    563e:	0307879b          	addw	a5,a5,48
    5642:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5646:	0324e7bb          	remw	a5,s1,s2
    564a:	0307879b          	addw	a5,a5,48
    564e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5652:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5656:	f6040513          	add	a0,s0,-160
    565a:	00000097          	auipc	ra,0x0
    565e:	7aa080e7          	jalr	1962(ra) # 5e04 <unlink>
    nfiles--;
    5662:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    5664:	fb5499e3          	bne	s1,s5,5616 <fsfull+0xd0>
  printf("fsfull test finished\n");
    5668:	00003517          	auipc	a0,0x3
    566c:	bd850513          	add	a0,a0,-1064 # 8240 <malloc+0x206c>
    5670:	00001097          	auipc	ra,0x1
    5674:	aac080e7          	jalr	-1364(ra) # 611c <printf>
}
    5678:	60ea                	ld	ra,152(sp)
    567a:	644a                	ld	s0,144(sp)
    567c:	64aa                	ld	s1,136(sp)
    567e:	690a                	ld	s2,128(sp)
    5680:	79e6                	ld	s3,120(sp)
    5682:	7a46                	ld	s4,112(sp)
    5684:	7aa6                	ld	s5,104(sp)
    5686:	7b06                	ld	s6,96(sp)
    5688:	6be6                	ld	s7,88(sp)
    568a:	6c46                	ld	s8,80(sp)
    568c:	6ca6                	ld	s9,72(sp)
    568e:	6d06                	ld	s10,64(sp)
    5690:	610d                	add	sp,sp,160
    5692:	8082                	ret
    int total = 0;
    5694:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5696:	00007a97          	auipc	s5,0x7
    569a:	5e2a8a93          	add	s5,s5,1506 # cc78 <buf>
      if(cc < BSIZE)
    569e:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    56a2:	40000613          	li	a2,1024
    56a6:	85d6                	mv	a1,s5
    56a8:	854a                	mv	a0,s2
    56aa:	00000097          	auipc	ra,0x0
    56ae:	71a080e7          	jalr	1818(ra) # 5dc4 <write>
      if(cc < BSIZE)
    56b2:	00aa5563          	bge	s4,a0,56bc <fsfull+0x176>
      total += cc;
    56b6:	00a989bb          	addw	s3,s3,a0
    while(1){
    56ba:	b7e5                	j	56a2 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    56bc:	85ce                	mv	a1,s3
    56be:	00003517          	auipc	a0,0x3
    56c2:	b7250513          	add	a0,a0,-1166 # 8230 <malloc+0x205c>
    56c6:	00001097          	auipc	ra,0x1
    56ca:	a56080e7          	jalr	-1450(ra) # 611c <printf>
    close(fd);
    56ce:	854a                	mv	a0,s2
    56d0:	00000097          	auipc	ra,0x0
    56d4:	6fc080e7          	jalr	1788(ra) # 5dcc <close>
    if(total == 0)
    56d8:	f20985e3          	beqz	s3,5602 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    56dc:	2485                	addw	s1,s1,1
    56de:	b575                	j	558a <fsfull+0x44>

00000000000056e0 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    56e0:	7179                	add	sp,sp,-48
    56e2:	f406                	sd	ra,40(sp)
    56e4:	f022                	sd	s0,32(sp)
    56e6:	ec26                	sd	s1,24(sp)
    56e8:	e84a                	sd	s2,16(sp)
    56ea:	1800                	add	s0,sp,48
    56ec:	84aa                	mv	s1,a0
    56ee:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    56f0:	00003517          	auipc	a0,0x3
    56f4:	b6850513          	add	a0,a0,-1176 # 8258 <malloc+0x2084>
    56f8:	00001097          	auipc	ra,0x1
    56fc:	a24080e7          	jalr	-1500(ra) # 611c <printf>
  if((pid = fork()) < 0) {
    5700:	00000097          	auipc	ra,0x0
    5704:	69c080e7          	jalr	1692(ra) # 5d9c <fork>
    5708:	02054e63          	bltz	a0,5744 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    570c:	c929                	beqz	a0,575e <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    570e:	fdc40513          	add	a0,s0,-36
    5712:	00000097          	auipc	ra,0x0
    5716:	69a080e7          	jalr	1690(ra) # 5dac <wait>
    if(xstatus != 0) 
    571a:	fdc42783          	lw	a5,-36(s0)
    571e:	c7b9                	beqz	a5,576c <run+0x8c>
      printf("FAILED\n");
    5720:	00003517          	auipc	a0,0x3
    5724:	b6050513          	add	a0,a0,-1184 # 8280 <malloc+0x20ac>
    5728:	00001097          	auipc	ra,0x1
    572c:	9f4080e7          	jalr	-1548(ra) # 611c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5730:	fdc42503          	lw	a0,-36(s0)
  }
}
    5734:	00153513          	seqz	a0,a0
    5738:	70a2                	ld	ra,40(sp)
    573a:	7402                	ld	s0,32(sp)
    573c:	64e2                	ld	s1,24(sp)
    573e:	6942                	ld	s2,16(sp)
    5740:	6145                	add	sp,sp,48
    5742:	8082                	ret
    printf("runtest: fork error\n");
    5744:	00003517          	auipc	a0,0x3
    5748:	b2450513          	add	a0,a0,-1244 # 8268 <malloc+0x2094>
    574c:	00001097          	auipc	ra,0x1
    5750:	9d0080e7          	jalr	-1584(ra) # 611c <printf>
    exit(1);
    5754:	4505                	li	a0,1
    5756:	00000097          	auipc	ra,0x0
    575a:	64e080e7          	jalr	1614(ra) # 5da4 <exit>
    f(s);
    575e:	854a                	mv	a0,s2
    5760:	9482                	jalr	s1
    exit(0);
    5762:	4501                	li	a0,0
    5764:	00000097          	auipc	ra,0x0
    5768:	640080e7          	jalr	1600(ra) # 5da4 <exit>
      printf("OK\n");
    576c:	00003517          	auipc	a0,0x3
    5770:	b1c50513          	add	a0,a0,-1252 # 8288 <malloc+0x20b4>
    5774:	00001097          	auipc	ra,0x1
    5778:	9a8080e7          	jalr	-1624(ra) # 611c <printf>
    577c:	bf55                	j	5730 <run+0x50>

000000000000577e <runtests>:

int
runtests(struct test *tests, char *justone) {
    577e:	1101                	add	sp,sp,-32
    5780:	ec06                	sd	ra,24(sp)
    5782:	e822                	sd	s0,16(sp)
    5784:	e426                	sd	s1,8(sp)
    5786:	e04a                	sd	s2,0(sp)
    5788:	1000                	add	s0,sp,32
    578a:	84aa                	mv	s1,a0
    578c:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    578e:	6508                	ld	a0,8(a0)
    5790:	ed09                	bnez	a0,57aa <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5792:	4501                	li	a0,0
    5794:	a82d                	j	57ce <runtests+0x50>
      if(!run(t->f, t->s)){
    5796:	648c                	ld	a1,8(s1)
    5798:	6088                	ld	a0,0(s1)
    579a:	00000097          	auipc	ra,0x0
    579e:	f46080e7          	jalr	-186(ra) # 56e0 <run>
    57a2:	cd09                	beqz	a0,57bc <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    57a4:	04c1                	add	s1,s1,16
    57a6:	6488                	ld	a0,8(s1)
    57a8:	c11d                	beqz	a0,57ce <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    57aa:	fe0906e3          	beqz	s2,5796 <runtests+0x18>
    57ae:	85ca                	mv	a1,s2
    57b0:	00000097          	auipc	ra,0x0
    57b4:	3a4080e7          	jalr	932(ra) # 5b54 <strcmp>
    57b8:	f575                	bnez	a0,57a4 <runtests+0x26>
    57ba:	bff1                	j	5796 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    57bc:	00003517          	auipc	a0,0x3
    57c0:	ad450513          	add	a0,a0,-1324 # 8290 <malloc+0x20bc>
    57c4:	00001097          	auipc	ra,0x1
    57c8:	958080e7          	jalr	-1704(ra) # 611c <printf>
        return 1;
    57cc:	4505                	li	a0,1
}
    57ce:	60e2                	ld	ra,24(sp)
    57d0:	6442                	ld	s0,16(sp)
    57d2:	64a2                	ld	s1,8(sp)
    57d4:	6902                	ld	s2,0(sp)
    57d6:	6105                	add	sp,sp,32
    57d8:	8082                	ret

00000000000057da <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    57da:	7139                	add	sp,sp,-64
    57dc:	fc06                	sd	ra,56(sp)
    57de:	f822                	sd	s0,48(sp)
    57e0:	f426                	sd	s1,40(sp)
    57e2:	f04a                	sd	s2,32(sp)
    57e4:	ec4e                	sd	s3,24(sp)
    57e6:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    57e8:	fc840513          	add	a0,s0,-56
    57ec:	00000097          	auipc	ra,0x0
    57f0:	5c8080e7          	jalr	1480(ra) # 5db4 <pipe>
    57f4:	06054763          	bltz	a0,5862 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    57f8:	00000097          	auipc	ra,0x0
    57fc:	5a4080e7          	jalr	1444(ra) # 5d9c <fork>

  if(pid < 0){
    5800:	06054e63          	bltz	a0,587c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5804:	ed51                	bnez	a0,58a0 <countfree+0xc6>
    close(fds[0]);
    5806:	fc842503          	lw	a0,-56(s0)
    580a:	00000097          	auipc	ra,0x0
    580e:	5c2080e7          	jalr	1474(ra) # 5dcc <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5812:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5814:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5816:	00001997          	auipc	s3,0x1
    581a:	b5298993          	add	s3,s3,-1198 # 6368 <malloc+0x194>
      uint64 a = (uint64) sbrk(4096);
    581e:	6505                	lui	a0,0x1
    5820:	00000097          	auipc	ra,0x0
    5824:	61c080e7          	jalr	1564(ra) # 5e3c <sbrk>
      if(a == 0xffffffffffffffff){
    5828:	07250763          	beq	a0,s2,5896 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    582c:	6785                	lui	a5,0x1
    582e:	97aa                	add	a5,a5,a0
    5830:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0xf3>
      if(write(fds[1], "x", 1) != 1){
    5834:	8626                	mv	a2,s1
    5836:	85ce                	mv	a1,s3
    5838:	fcc42503          	lw	a0,-52(s0)
    583c:	00000097          	auipc	ra,0x0
    5840:	588080e7          	jalr	1416(ra) # 5dc4 <write>
    5844:	fc950de3          	beq	a0,s1,581e <countfree+0x44>
        printf("write() failed in countfree()\n");
    5848:	00003517          	auipc	a0,0x3
    584c:	aa050513          	add	a0,a0,-1376 # 82e8 <malloc+0x2114>
    5850:	00001097          	auipc	ra,0x1
    5854:	8cc080e7          	jalr	-1844(ra) # 611c <printf>
        exit(1);
    5858:	4505                	li	a0,1
    585a:	00000097          	auipc	ra,0x0
    585e:	54a080e7          	jalr	1354(ra) # 5da4 <exit>
    printf("pipe() failed in countfree()\n");
    5862:	00003517          	auipc	a0,0x3
    5866:	a4650513          	add	a0,a0,-1466 # 82a8 <malloc+0x20d4>
    586a:	00001097          	auipc	ra,0x1
    586e:	8b2080e7          	jalr	-1870(ra) # 611c <printf>
    exit(1);
    5872:	4505                	li	a0,1
    5874:	00000097          	auipc	ra,0x0
    5878:	530080e7          	jalr	1328(ra) # 5da4 <exit>
    printf("fork failed in countfree()\n");
    587c:	00003517          	auipc	a0,0x3
    5880:	a4c50513          	add	a0,a0,-1460 # 82c8 <malloc+0x20f4>
    5884:	00001097          	auipc	ra,0x1
    5888:	898080e7          	jalr	-1896(ra) # 611c <printf>
    exit(1);
    588c:	4505                	li	a0,1
    588e:	00000097          	auipc	ra,0x0
    5892:	516080e7          	jalr	1302(ra) # 5da4 <exit>
      }
    }

    exit(0);
    5896:	4501                	li	a0,0
    5898:	00000097          	auipc	ra,0x0
    589c:	50c080e7          	jalr	1292(ra) # 5da4 <exit>
  }

  close(fds[1]);
    58a0:	fcc42503          	lw	a0,-52(s0)
    58a4:	00000097          	auipc	ra,0x0
    58a8:	528080e7          	jalr	1320(ra) # 5dcc <close>

  int n = 0;
    58ac:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    58ae:	4605                	li	a2,1
    58b0:	fc740593          	add	a1,s0,-57
    58b4:	fc842503          	lw	a0,-56(s0)
    58b8:	00000097          	auipc	ra,0x0
    58bc:	504080e7          	jalr	1284(ra) # 5dbc <read>
    if(cc < 0){
    58c0:	00054563          	bltz	a0,58ca <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    58c4:	c105                	beqz	a0,58e4 <countfree+0x10a>
      break;
    n += 1;
    58c6:	2485                	addw	s1,s1,1
  while(1){
    58c8:	b7dd                	j	58ae <countfree+0xd4>
      printf("read() failed in countfree()\n");
    58ca:	00003517          	auipc	a0,0x3
    58ce:	a3e50513          	add	a0,a0,-1474 # 8308 <malloc+0x2134>
    58d2:	00001097          	auipc	ra,0x1
    58d6:	84a080e7          	jalr	-1974(ra) # 611c <printf>
      exit(1);
    58da:	4505                	li	a0,1
    58dc:	00000097          	auipc	ra,0x0
    58e0:	4c8080e7          	jalr	1224(ra) # 5da4 <exit>
  }

  close(fds[0]);
    58e4:	fc842503          	lw	a0,-56(s0)
    58e8:	00000097          	auipc	ra,0x0
    58ec:	4e4080e7          	jalr	1252(ra) # 5dcc <close>
  wait((int*)0);
    58f0:	4501                	li	a0,0
    58f2:	00000097          	auipc	ra,0x0
    58f6:	4ba080e7          	jalr	1210(ra) # 5dac <wait>
  
  return n;
}
    58fa:	8526                	mv	a0,s1
    58fc:	70e2                	ld	ra,56(sp)
    58fe:	7442                	ld	s0,48(sp)
    5900:	74a2                	ld	s1,40(sp)
    5902:	7902                	ld	s2,32(sp)
    5904:	69e2                	ld	s3,24(sp)
    5906:	6121                	add	sp,sp,64
    5908:	8082                	ret

000000000000590a <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    590a:	711d                	add	sp,sp,-96
    590c:	ec86                	sd	ra,88(sp)
    590e:	e8a2                	sd	s0,80(sp)
    5910:	e4a6                	sd	s1,72(sp)
    5912:	e0ca                	sd	s2,64(sp)
    5914:	fc4e                	sd	s3,56(sp)
    5916:	f852                	sd	s4,48(sp)
    5918:	f456                	sd	s5,40(sp)
    591a:	f05a                	sd	s6,32(sp)
    591c:	ec5e                	sd	s7,24(sp)
    591e:	e862                	sd	s8,16(sp)
    5920:	e466                	sd	s9,8(sp)
    5922:	e06a                	sd	s10,0(sp)
    5924:	1080                	add	s0,sp,96
    5926:	8aaa                	mv	s5,a0
    5928:	89ae                	mv	s3,a1
    592a:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    592c:	00003b97          	auipc	s7,0x3
    5930:	9fcb8b93          	add	s7,s7,-1540 # 8328 <malloc+0x2154>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5934:	00003b17          	auipc	s6,0x3
    5938:	6dcb0b13          	add	s6,s6,1756 # 9010 <quicktests>
      if(continuous != 2) {
    593c:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    593e:	00004c17          	auipc	s8,0x4
    5942:	aa2c0c13          	add	s8,s8,-1374 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    5946:	00003d17          	auipc	s10,0x3
    594a:	9fad0d13          	add	s10,s10,-1542 # 8340 <malloc+0x216c>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    594e:	00003c97          	auipc	s9,0x3
    5952:	a12c8c93          	add	s9,s9,-1518 # 8360 <malloc+0x218c>
    5956:	a839                	j	5974 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5958:	856a                	mv	a0,s10
    595a:	00000097          	auipc	ra,0x0
    595e:	7c2080e7          	jalr	1986(ra) # 611c <printf>
    5962:	a081                	j	59a2 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    5964:	00000097          	auipc	ra,0x0
    5968:	e76080e7          	jalr	-394(ra) # 57da <countfree>
    596c:	04954663          	blt	a0,s1,59b8 <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5970:	06098163          	beqz	s3,59d2 <drivetests+0xc8>
    printf("usertests starting\n");
    5974:	855e                	mv	a0,s7
    5976:	00000097          	auipc	ra,0x0
    597a:	7a6080e7          	jalr	1958(ra) # 611c <printf>
    int free0 = countfree();
    597e:	00000097          	auipc	ra,0x0
    5982:	e5c080e7          	jalr	-420(ra) # 57da <countfree>
    5986:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5988:	85ca                	mv	a1,s2
    598a:	855a                	mv	a0,s6
    598c:	00000097          	auipc	ra,0x0
    5990:	df2080e7          	jalr	-526(ra) # 577e <runtests>
    5994:	c119                	beqz	a0,599a <drivetests+0x90>
      if(continuous != 2) {
    5996:	03499c63          	bne	s3,s4,59ce <drivetests+0xc4>
    if(!quick) {
    599a:	fc0a95e3          	bnez	s5,5964 <drivetests+0x5a>
      if (justone == 0)
    599e:	fa090de3          	beqz	s2,5958 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    59a2:	85ca                	mv	a1,s2
    59a4:	8562                	mv	a0,s8
    59a6:	00000097          	auipc	ra,0x0
    59aa:	dd8080e7          	jalr	-552(ra) # 577e <runtests>
    59ae:	d95d                	beqz	a0,5964 <drivetests+0x5a>
        if(continuous != 2) {
    59b0:	fb498ae3          	beq	s3,s4,5964 <drivetests+0x5a>
          return 1;
    59b4:	4505                	li	a0,1
    59b6:	a839                	j	59d4 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    59b8:	8626                	mv	a2,s1
    59ba:	85aa                	mv	a1,a0
    59bc:	8566                	mv	a0,s9
    59be:	00000097          	auipc	ra,0x0
    59c2:	75e080e7          	jalr	1886(ra) # 611c <printf>
      if(continuous != 2) {
    59c6:	fb4987e3          	beq	s3,s4,5974 <drivetests+0x6a>
        return 1;
    59ca:	4505                	li	a0,1
    59cc:	a021                	j	59d4 <drivetests+0xca>
        return 1;
    59ce:	4505                	li	a0,1
    59d0:	a011                	j	59d4 <drivetests+0xca>
  return 0;
    59d2:	854e                	mv	a0,s3
}
    59d4:	60e6                	ld	ra,88(sp)
    59d6:	6446                	ld	s0,80(sp)
    59d8:	64a6                	ld	s1,72(sp)
    59da:	6906                	ld	s2,64(sp)
    59dc:	79e2                	ld	s3,56(sp)
    59de:	7a42                	ld	s4,48(sp)
    59e0:	7aa2                	ld	s5,40(sp)
    59e2:	7b02                	ld	s6,32(sp)
    59e4:	6be2                	ld	s7,24(sp)
    59e6:	6c42                	ld	s8,16(sp)
    59e8:	6ca2                	ld	s9,8(sp)
    59ea:	6d02                	ld	s10,0(sp)
    59ec:	6125                	add	sp,sp,96
    59ee:	8082                	ret

00000000000059f0 <main>:

int
main(int argc, char *argv[])
{
    59f0:	1101                	add	sp,sp,-32
    59f2:	ec06                	sd	ra,24(sp)
    59f4:	e822                	sd	s0,16(sp)
    59f6:	e426                	sd	s1,8(sp)
    59f8:	e04a                	sd	s2,0(sp)
    59fa:	1000                	add	s0,sp,32
    59fc:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;
   if(argc == 2 && strcmp(argv[1], "writebig") == 0){
    59fe:	4789                	li	a5,2
    5a00:	02f50263          	beq	a0,a5,5a24 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5a04:	4785                	li	a5,1
    5a06:	0ca7cc63          	blt	a5,a0,5ade <main+0xee>
  char *justone = 0;
    5a0a:	4601                	li	a2,0
  int quick = 0;
    5a0c:	4501                	li	a0,0
  int continuous = 0;
    5a0e:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5a10:	00000097          	auipc	ra,0x0
    5a14:	efa080e7          	jalr	-262(ra) # 590a <drivetests>
    5a18:	c575                	beqz	a0,5b04 <main+0x114>
    exit(1);
    5a1a:	4505                	li	a0,1
    5a1c:	00000097          	auipc	ra,0x0
    5a20:	388080e7          	jalr	904(ra) # 5da4 <exit>
    5a24:	892e                	mv	s2,a1
   if(argc == 2 && strcmp(argv[1], "writebig") == 0){
    5a26:	00003597          	auipc	a1,0x3
    5a2a:	96a58593          	add	a1,a1,-1686 # 8390 <malloc+0x21bc>
    5a2e:	00893503          	ld	a0,8(s2)
    5a32:	00000097          	auipc	ra,0x0
    5a36:	122080e7          	jalr	290(ra) # 5b54 <strcmp>
    5a3a:	e131                	bnez	a0,5a7e <main+0x8e>
    if(writebigFile("writebig")==1) {
    5a3c:	00003517          	auipc	a0,0x3
    5a40:	95450513          	add	a0,a0,-1708 # 8390 <malloc+0x21bc>
    5a44:	00000097          	auipc	ra,0x0
    5a48:	95e080e7          	jalr	-1698(ra) # 53a2 <writebigFile>
    5a4c:	4785                	li	a5,1
    5a4e:	00f50f63          	beq	a0,a5,5a6c <main+0x7c>
    printf("test : writebig failed\n");
    5a52:	00003517          	auipc	a0,0x3
    5a56:	96650513          	add	a0,a0,-1690 # 83b8 <malloc+0x21e4>
    5a5a:	00000097          	auipc	ra,0x0
    5a5e:	6c2080e7          	jalr	1730(ra) # 611c <printf>
    exit(1);
    5a62:	4505                	li	a0,1
    5a64:	00000097          	auipc	ra,0x0
    5a68:	340080e7          	jalr	832(ra) # 5da4 <exit>
      printf("test :writebig passed\n");
    5a6c:	00003517          	auipc	a0,0x3
    5a70:	93450513          	add	a0,a0,-1740 # 83a0 <malloc+0x21cc>
    5a74:	00000097          	auipc	ra,0x0
    5a78:	6a8080e7          	jalr	1704(ra) # 611c <printf>
    5a7c:	b7dd                	j	5a62 <main+0x72>
    else if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5a7e:	00003597          	auipc	a1,0x3
    5a82:	95258593          	add	a1,a1,-1710 # 83d0 <malloc+0x21fc>
    5a86:	00893503          	ld	a0,8(s2)
    5a8a:	00000097          	auipc	ra,0x0
    5a8e:	0ca080e7          	jalr	202(ra) # 5b54 <strcmp>
    5a92:	85aa                	mv	a1,a0
    5a94:	c135                	beqz	a0,5af8 <main+0x108>
    else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5a96:	00003597          	auipc	a1,0x3
    5a9a:	99258593          	add	a1,a1,-1646 # 8428 <malloc+0x2254>
    5a9e:	00893503          	ld	a0,8(s2)
    5aa2:	00000097          	auipc	ra,0x0
    5aa6:	0b2080e7          	jalr	178(ra) # 5b54 <strcmp>
    5aaa:	e501                	bnez	a0,5ab2 <main+0xc2>
  char *justone = 0;
    5aac:	4601                	li	a2,0
    continuous = 1;
    5aae:	4585                	li	a1,1
    5ab0:	b785                	j	5a10 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5ab2:	00003597          	auipc	a1,0x3
    5ab6:	92658593          	add	a1,a1,-1754 # 83d8 <malloc+0x2204>
    5aba:	00893503          	ld	a0,8(s2)
    5abe:	00000097          	auipc	ra,0x0
    5ac2:	096080e7          	jalr	150(ra) # 5b54 <strcmp>
    5ac6:	cd05                	beqz	a0,5afe <main+0x10e>
  } else if(argc == 2 && argv[1][0] != '-'){
    5ac8:	00893603          	ld	a2,8(s2)
    5acc:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x8e>
    5ad0:	02d00793          	li	a5,45
    5ad4:	00f70563          	beq	a4,a5,5ade <main+0xee>
  int quick = 0;
    5ad8:	4501                	li	a0,0
  int continuous = 0;
    5ada:	4581                	li	a1,0
    5adc:	bf15                	j	5a10 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5ade:	00003517          	auipc	a0,0x3
    5ae2:	90250513          	add	a0,a0,-1790 # 83e0 <malloc+0x220c>
    5ae6:	00000097          	auipc	ra,0x0
    5aea:	636080e7          	jalr	1590(ra) # 611c <printf>
    exit(1);
    5aee:	4505                	li	a0,1
    5af0:	00000097          	auipc	ra,0x0
    5af4:	2b4080e7          	jalr	692(ra) # 5da4 <exit>
  char *justone = 0;
    5af8:	4601                	li	a2,0
    quick = 1;
    5afa:	4505                	li	a0,1
    5afc:	bf11                	j	5a10 <main+0x20>
    continuous = 2;
    5afe:	85a6                	mv	a1,s1
  char *justone = 0;
    5b00:	4601                	li	a2,0
    5b02:	b739                	j	5a10 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5b04:	00003517          	auipc	a0,0x3
    5b08:	90c50513          	add	a0,a0,-1780 # 8410 <malloc+0x223c>
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	610080e7          	jalr	1552(ra) # 611c <printf>
  exit(0);
    5b14:	4501                	li	a0,0
    5b16:	00000097          	auipc	ra,0x0
    5b1a:	28e080e7          	jalr	654(ra) # 5da4 <exit>

0000000000005b1e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5b1e:	1141                	add	sp,sp,-16
    5b20:	e406                	sd	ra,8(sp)
    5b22:	e022                	sd	s0,0(sp)
    5b24:	0800                	add	s0,sp,16
  extern int main();
  main();
    5b26:	00000097          	auipc	ra,0x0
    5b2a:	eca080e7          	jalr	-310(ra) # 59f0 <main>
  exit(0);
    5b2e:	4501                	li	a0,0
    5b30:	00000097          	auipc	ra,0x0
    5b34:	274080e7          	jalr	628(ra) # 5da4 <exit>

0000000000005b38 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5b38:	1141                	add	sp,sp,-16
    5b3a:	e422                	sd	s0,8(sp)
    5b3c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5b3e:	87aa                	mv	a5,a0
    5b40:	0585                	add	a1,a1,1
    5b42:	0785                	add	a5,a5,1
    5b44:	fff5c703          	lbu	a4,-1(a1)
    5b48:	fee78fa3          	sb	a4,-1(a5)
    5b4c:	fb75                	bnez	a4,5b40 <strcpy+0x8>
    ;
  return os;
}
    5b4e:	6422                	ld	s0,8(sp)
    5b50:	0141                	add	sp,sp,16
    5b52:	8082                	ret

0000000000005b54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5b54:	1141                	add	sp,sp,-16
    5b56:	e422                	sd	s0,8(sp)
    5b58:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    5b5a:	00054783          	lbu	a5,0(a0)
    5b5e:	cb91                	beqz	a5,5b72 <strcmp+0x1e>
    5b60:	0005c703          	lbu	a4,0(a1)
    5b64:	00f71763          	bne	a4,a5,5b72 <strcmp+0x1e>
    p++, q++;
    5b68:	0505                	add	a0,a0,1
    5b6a:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    5b6c:	00054783          	lbu	a5,0(a0)
    5b70:	fbe5                	bnez	a5,5b60 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5b72:	0005c503          	lbu	a0,0(a1)
}
    5b76:	40a7853b          	subw	a0,a5,a0
    5b7a:	6422                	ld	s0,8(sp)
    5b7c:	0141                	add	sp,sp,16
    5b7e:	8082                	ret

0000000000005b80 <strlen>:

uint
strlen(const char *s)
{
    5b80:	1141                	add	sp,sp,-16
    5b82:	e422                	sd	s0,8(sp)
    5b84:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5b86:	00054783          	lbu	a5,0(a0)
    5b8a:	cf91                	beqz	a5,5ba6 <strlen+0x26>
    5b8c:	0505                	add	a0,a0,1
    5b8e:	87aa                	mv	a5,a0
    5b90:	86be                	mv	a3,a5
    5b92:	0785                	add	a5,a5,1
    5b94:	fff7c703          	lbu	a4,-1(a5)
    5b98:	ff65                	bnez	a4,5b90 <strlen+0x10>
    5b9a:	40a6853b          	subw	a0,a3,a0
    5b9e:	2505                	addw	a0,a0,1
    ;
  return n;
}
    5ba0:	6422                	ld	s0,8(sp)
    5ba2:	0141                	add	sp,sp,16
    5ba4:	8082                	ret
  for(n = 0; s[n]; n++)
    5ba6:	4501                	li	a0,0
    5ba8:	bfe5                	j	5ba0 <strlen+0x20>

0000000000005baa <memset>:

void*
memset(void *dst, int c, uint n)
{
    5baa:	1141                	add	sp,sp,-16
    5bac:	e422                	sd	s0,8(sp)
    5bae:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5bb0:	ca19                	beqz	a2,5bc6 <memset+0x1c>
    5bb2:	87aa                	mv	a5,a0
    5bb4:	1602                	sll	a2,a2,0x20
    5bb6:	9201                	srl	a2,a2,0x20
    5bb8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5bbc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5bc0:	0785                	add	a5,a5,1
    5bc2:	fee79de3          	bne	a5,a4,5bbc <memset+0x12>
  }
  return dst;
}
    5bc6:	6422                	ld	s0,8(sp)
    5bc8:	0141                	add	sp,sp,16
    5bca:	8082                	ret

0000000000005bcc <strchr>:

char*
strchr(const char *s, char c)
{
    5bcc:	1141                	add	sp,sp,-16
    5bce:	e422                	sd	s0,8(sp)
    5bd0:	0800                	add	s0,sp,16
  for(; *s; s++)
    5bd2:	00054783          	lbu	a5,0(a0)
    5bd6:	cb99                	beqz	a5,5bec <strchr+0x20>
    if(*s == c)
    5bd8:	00f58763          	beq	a1,a5,5be6 <strchr+0x1a>
  for(; *s; s++)
    5bdc:	0505                	add	a0,a0,1
    5bde:	00054783          	lbu	a5,0(a0)
    5be2:	fbfd                	bnez	a5,5bd8 <strchr+0xc>
      return (char*)s;
  return 0;
    5be4:	4501                	li	a0,0
}
    5be6:	6422                	ld	s0,8(sp)
    5be8:	0141                	add	sp,sp,16
    5bea:	8082                	ret
  return 0;
    5bec:	4501                	li	a0,0
    5bee:	bfe5                	j	5be6 <strchr+0x1a>

0000000000005bf0 <gets>:

char*
gets(char *buf, int max)
{
    5bf0:	711d                	add	sp,sp,-96
    5bf2:	ec86                	sd	ra,88(sp)
    5bf4:	e8a2                	sd	s0,80(sp)
    5bf6:	e4a6                	sd	s1,72(sp)
    5bf8:	e0ca                	sd	s2,64(sp)
    5bfa:	fc4e                	sd	s3,56(sp)
    5bfc:	f852                	sd	s4,48(sp)
    5bfe:	f456                	sd	s5,40(sp)
    5c00:	f05a                	sd	s6,32(sp)
    5c02:	ec5e                	sd	s7,24(sp)
    5c04:	1080                	add	s0,sp,96
    5c06:	8baa                	mv	s7,a0
    5c08:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5c0a:	892a                	mv	s2,a0
    5c0c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5c0e:	4aa9                	li	s5,10
    5c10:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5c12:	89a6                	mv	s3,s1
    5c14:	2485                	addw	s1,s1,1
    5c16:	0344d863          	bge	s1,s4,5c46 <gets+0x56>
    cc = read(0, &c, 1);
    5c1a:	4605                	li	a2,1
    5c1c:	faf40593          	add	a1,s0,-81
    5c20:	4501                	li	a0,0
    5c22:	00000097          	auipc	ra,0x0
    5c26:	19a080e7          	jalr	410(ra) # 5dbc <read>
    if(cc < 1)
    5c2a:	00a05e63          	blez	a0,5c46 <gets+0x56>
    buf[i++] = c;
    5c2e:	faf44783          	lbu	a5,-81(s0)
    5c32:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5c36:	01578763          	beq	a5,s5,5c44 <gets+0x54>
    5c3a:	0905                	add	s2,s2,1
    5c3c:	fd679be3          	bne	a5,s6,5c12 <gets+0x22>
  for(i=0; i+1 < max; ){
    5c40:	89a6                	mv	s3,s1
    5c42:	a011                	j	5c46 <gets+0x56>
    5c44:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5c46:	99de                	add	s3,s3,s7
    5c48:	00098023          	sb	zero,0(s3)
  return buf;
}
    5c4c:	855e                	mv	a0,s7
    5c4e:	60e6                	ld	ra,88(sp)
    5c50:	6446                	ld	s0,80(sp)
    5c52:	64a6                	ld	s1,72(sp)
    5c54:	6906                	ld	s2,64(sp)
    5c56:	79e2                	ld	s3,56(sp)
    5c58:	7a42                	ld	s4,48(sp)
    5c5a:	7aa2                	ld	s5,40(sp)
    5c5c:	7b02                	ld	s6,32(sp)
    5c5e:	6be2                	ld	s7,24(sp)
    5c60:	6125                	add	sp,sp,96
    5c62:	8082                	ret

0000000000005c64 <stat>:

int
stat(const char *n, struct stat *st)
{
    5c64:	1101                	add	sp,sp,-32
    5c66:	ec06                	sd	ra,24(sp)
    5c68:	e822                	sd	s0,16(sp)
    5c6a:	e426                	sd	s1,8(sp)
    5c6c:	e04a                	sd	s2,0(sp)
    5c6e:	1000                	add	s0,sp,32
    5c70:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5c72:	4581                	li	a1,0
    5c74:	00000097          	auipc	ra,0x0
    5c78:	180080e7          	jalr	384(ra) # 5df4 <open>
  if(fd < 0)
    5c7c:	02054563          	bltz	a0,5ca6 <stat+0x42>
    5c80:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5c82:	85ca                	mv	a1,s2
    5c84:	00000097          	auipc	ra,0x0
    5c88:	188080e7          	jalr	392(ra) # 5e0c <fstat>
    5c8c:	892a                	mv	s2,a0
  close(fd);
    5c8e:	8526                	mv	a0,s1
    5c90:	00000097          	auipc	ra,0x0
    5c94:	13c080e7          	jalr	316(ra) # 5dcc <close>
  return r;
}
    5c98:	854a                	mv	a0,s2
    5c9a:	60e2                	ld	ra,24(sp)
    5c9c:	6442                	ld	s0,16(sp)
    5c9e:	64a2                	ld	s1,8(sp)
    5ca0:	6902                	ld	s2,0(sp)
    5ca2:	6105                	add	sp,sp,32
    5ca4:	8082                	ret
    return -1;
    5ca6:	597d                	li	s2,-1
    5ca8:	bfc5                	j	5c98 <stat+0x34>

0000000000005caa <atoi>:

int
atoi(const char *s)
{
    5caa:	1141                	add	sp,sp,-16
    5cac:	e422                	sd	s0,8(sp)
    5cae:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5cb0:	00054683          	lbu	a3,0(a0)
    5cb4:	fd06879b          	addw	a5,a3,-48
    5cb8:	0ff7f793          	zext.b	a5,a5
    5cbc:	4625                	li	a2,9
    5cbe:	02f66863          	bltu	a2,a5,5cee <atoi+0x44>
    5cc2:	872a                	mv	a4,a0
  n = 0;
    5cc4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5cc6:	0705                	add	a4,a4,1
    5cc8:	0025179b          	sllw	a5,a0,0x2
    5ccc:	9fa9                	addw	a5,a5,a0
    5cce:	0017979b          	sllw	a5,a5,0x1
    5cd2:	9fb5                	addw	a5,a5,a3
    5cd4:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5cd8:	00074683          	lbu	a3,0(a4)
    5cdc:	fd06879b          	addw	a5,a3,-48
    5ce0:	0ff7f793          	zext.b	a5,a5
    5ce4:	fef671e3          	bgeu	a2,a5,5cc6 <atoi+0x1c>
  return n;
}
    5ce8:	6422                	ld	s0,8(sp)
    5cea:	0141                	add	sp,sp,16
    5cec:	8082                	ret
  n = 0;
    5cee:	4501                	li	a0,0
    5cf0:	bfe5                	j	5ce8 <atoi+0x3e>

0000000000005cf2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5cf2:	1141                	add	sp,sp,-16
    5cf4:	e422                	sd	s0,8(sp)
    5cf6:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5cf8:	02b57463          	bgeu	a0,a1,5d20 <memmove+0x2e>
    while(n-- > 0)
    5cfc:	00c05f63          	blez	a2,5d1a <memmove+0x28>
    5d00:	1602                	sll	a2,a2,0x20
    5d02:	9201                	srl	a2,a2,0x20
    5d04:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5d08:	872a                	mv	a4,a0
      *dst++ = *src++;
    5d0a:	0585                	add	a1,a1,1
    5d0c:	0705                	add	a4,a4,1
    5d0e:	fff5c683          	lbu	a3,-1(a1)
    5d12:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5d16:	fee79ae3          	bne	a5,a4,5d0a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5d1a:	6422                	ld	s0,8(sp)
    5d1c:	0141                	add	sp,sp,16
    5d1e:	8082                	ret
    dst += n;
    5d20:	00c50733          	add	a4,a0,a2
    src += n;
    5d24:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5d26:	fec05ae3          	blez	a2,5d1a <memmove+0x28>
    5d2a:	fff6079b          	addw	a5,a2,-1
    5d2e:	1782                	sll	a5,a5,0x20
    5d30:	9381                	srl	a5,a5,0x20
    5d32:	fff7c793          	not	a5,a5
    5d36:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5d38:	15fd                	add	a1,a1,-1
    5d3a:	177d                	add	a4,a4,-1
    5d3c:	0005c683          	lbu	a3,0(a1)
    5d40:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5d44:	fee79ae3          	bne	a5,a4,5d38 <memmove+0x46>
    5d48:	bfc9                	j	5d1a <memmove+0x28>

0000000000005d4a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5d4a:	1141                	add	sp,sp,-16
    5d4c:	e422                	sd	s0,8(sp)
    5d4e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5d50:	ca05                	beqz	a2,5d80 <memcmp+0x36>
    5d52:	fff6069b          	addw	a3,a2,-1
    5d56:	1682                	sll	a3,a3,0x20
    5d58:	9281                	srl	a3,a3,0x20
    5d5a:	0685                	add	a3,a3,1
    5d5c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5d5e:	00054783          	lbu	a5,0(a0)
    5d62:	0005c703          	lbu	a4,0(a1)
    5d66:	00e79863          	bne	a5,a4,5d76 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5d6a:	0505                	add	a0,a0,1
    p2++;
    5d6c:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5d6e:	fed518e3          	bne	a0,a3,5d5e <memcmp+0x14>
  }
  return 0;
    5d72:	4501                	li	a0,0
    5d74:	a019                	j	5d7a <memcmp+0x30>
      return *p1 - *p2;
    5d76:	40e7853b          	subw	a0,a5,a4
}
    5d7a:	6422                	ld	s0,8(sp)
    5d7c:	0141                	add	sp,sp,16
    5d7e:	8082                	ret
  return 0;
    5d80:	4501                	li	a0,0
    5d82:	bfe5                	j	5d7a <memcmp+0x30>

0000000000005d84 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5d84:	1141                	add	sp,sp,-16
    5d86:	e406                	sd	ra,8(sp)
    5d88:	e022                	sd	s0,0(sp)
    5d8a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5d8c:	00000097          	auipc	ra,0x0
    5d90:	f66080e7          	jalr	-154(ra) # 5cf2 <memmove>
}
    5d94:	60a2                	ld	ra,8(sp)
    5d96:	6402                	ld	s0,0(sp)
    5d98:	0141                	add	sp,sp,16
    5d9a:	8082                	ret

0000000000005d9c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5d9c:	4885                	li	a7,1
 ecall
    5d9e:	00000073          	ecall
 ret
    5da2:	8082                	ret

0000000000005da4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5da4:	4889                	li	a7,2
 ecall
    5da6:	00000073          	ecall
 ret
    5daa:	8082                	ret

0000000000005dac <wait>:
.global wait
wait:
 li a7, SYS_wait
    5dac:	488d                	li	a7,3
 ecall
    5dae:	00000073          	ecall
 ret
    5db2:	8082                	ret

0000000000005db4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5db4:	4891                	li	a7,4
 ecall
    5db6:	00000073          	ecall
 ret
    5dba:	8082                	ret

0000000000005dbc <read>:
.global read
read:
 li a7, SYS_read
    5dbc:	4895                	li	a7,5
 ecall
    5dbe:	00000073          	ecall
 ret
    5dc2:	8082                	ret

0000000000005dc4 <write>:
.global write
write:
 li a7, SYS_write
    5dc4:	48c1                	li	a7,16
 ecall
    5dc6:	00000073          	ecall
 ret
    5dca:	8082                	ret

0000000000005dcc <close>:
.global close
close:
 li a7, SYS_close
    5dcc:	48d5                	li	a7,21
 ecall
    5dce:	00000073          	ecall
 ret
    5dd2:	8082                	ret

0000000000005dd4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5dd4:	4899                	li	a7,6
 ecall
    5dd6:	00000073          	ecall
 ret
    5dda:	8082                	ret

0000000000005ddc <procs>:
.global procs
procs:
 li a7, SYS_procs
    5ddc:	48d9                	li	a7,22
 ecall
    5dde:	00000073          	ecall
 ret
    5de2:	8082                	ret

0000000000005de4 <writebigfile>:
.global writebigfile
writebigfile:
 li a7, SYS_writebigfile
    5de4:	48dd                	li	a7,23
 ecall
    5de6:	00000073          	ecall
 ret
    5dea:	8082                	ret

0000000000005dec <exec>:
.global exec
exec:
 li a7, SYS_exec
    5dec:	489d                	li	a7,7
 ecall
    5dee:	00000073          	ecall
 ret
    5df2:	8082                	ret

0000000000005df4 <open>:
.global open
open:
 li a7, SYS_open
    5df4:	48bd                	li	a7,15
 ecall
    5df6:	00000073          	ecall
 ret
    5dfa:	8082                	ret

0000000000005dfc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5dfc:	48c5                	li	a7,17
 ecall
    5dfe:	00000073          	ecall
 ret
    5e02:	8082                	ret

0000000000005e04 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5e04:	48c9                	li	a7,18
 ecall
    5e06:	00000073          	ecall
 ret
    5e0a:	8082                	ret

0000000000005e0c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5e0c:	48a1                	li	a7,8
 ecall
    5e0e:	00000073          	ecall
 ret
    5e12:	8082                	ret

0000000000005e14 <link>:
.global link
link:
 li a7, SYS_link
    5e14:	48cd                	li	a7,19
 ecall
    5e16:	00000073          	ecall
 ret
    5e1a:	8082                	ret

0000000000005e1c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5e1c:	48d1                	li	a7,20
 ecall
    5e1e:	00000073          	ecall
 ret
    5e22:	8082                	ret

0000000000005e24 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5e24:	48a5                	li	a7,9
 ecall
    5e26:	00000073          	ecall
 ret
    5e2a:	8082                	ret

0000000000005e2c <dup>:
.global dup
dup:
 li a7, SYS_dup
    5e2c:	48a9                	li	a7,10
 ecall
    5e2e:	00000073          	ecall
 ret
    5e32:	8082                	ret

0000000000005e34 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5e34:	48ad                	li	a7,11
 ecall
    5e36:	00000073          	ecall
 ret
    5e3a:	8082                	ret

0000000000005e3c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5e3c:	48b1                	li	a7,12
 ecall
    5e3e:	00000073          	ecall
 ret
    5e42:	8082                	ret

0000000000005e44 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5e44:	48b5                	li	a7,13
 ecall
    5e46:	00000073          	ecall
 ret
    5e4a:	8082                	ret

0000000000005e4c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5e4c:	48b9                	li	a7,14
 ecall
    5e4e:	00000073          	ecall
 ret
    5e52:	8082                	ret

0000000000005e54 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5e54:	1101                	add	sp,sp,-32
    5e56:	ec06                	sd	ra,24(sp)
    5e58:	e822                	sd	s0,16(sp)
    5e5a:	1000                	add	s0,sp,32
    5e5c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5e60:	4605                	li	a2,1
    5e62:	fef40593          	add	a1,s0,-17
    5e66:	00000097          	auipc	ra,0x0
    5e6a:	f5e080e7          	jalr	-162(ra) # 5dc4 <write>
}
    5e6e:	60e2                	ld	ra,24(sp)
    5e70:	6442                	ld	s0,16(sp)
    5e72:	6105                	add	sp,sp,32
    5e74:	8082                	ret

0000000000005e76 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5e76:	7139                	add	sp,sp,-64
    5e78:	fc06                	sd	ra,56(sp)
    5e7a:	f822                	sd	s0,48(sp)
    5e7c:	f426                	sd	s1,40(sp)
    5e7e:	f04a                	sd	s2,32(sp)
    5e80:	ec4e                	sd	s3,24(sp)
    5e82:	0080                	add	s0,sp,64
    5e84:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5e86:	c299                	beqz	a3,5e8c <printint+0x16>
    5e88:	0805c963          	bltz	a1,5f1a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5e8c:	2581                	sext.w	a1,a1
  neg = 0;
    5e8e:	4881                	li	a7,0
    5e90:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5e94:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5e96:	2601                	sext.w	a2,a2
    5e98:	00003517          	auipc	a0,0x3
    5e9c:	94850513          	add	a0,a0,-1720 # 87e0 <digits>
    5ea0:	883a                	mv	a6,a4
    5ea2:	2705                	addw	a4,a4,1
    5ea4:	02c5f7bb          	remuw	a5,a1,a2
    5ea8:	1782                	sll	a5,a5,0x20
    5eaa:	9381                	srl	a5,a5,0x20
    5eac:	97aa                	add	a5,a5,a0
    5eae:	0007c783          	lbu	a5,0(a5)
    5eb2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5eb6:	0005879b          	sext.w	a5,a1
    5eba:	02c5d5bb          	divuw	a1,a1,a2
    5ebe:	0685                	add	a3,a3,1
    5ec0:	fec7f0e3          	bgeu	a5,a2,5ea0 <printint+0x2a>
  if(neg)
    5ec4:	00088c63          	beqz	a7,5edc <printint+0x66>
    buf[i++] = '-';
    5ec8:	fd070793          	add	a5,a4,-48
    5ecc:	00878733          	add	a4,a5,s0
    5ed0:	02d00793          	li	a5,45
    5ed4:	fef70823          	sb	a5,-16(a4)
    5ed8:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5edc:	02e05863          	blez	a4,5f0c <printint+0x96>
    5ee0:	fc040793          	add	a5,s0,-64
    5ee4:	00e78933          	add	s2,a5,a4
    5ee8:	fff78993          	add	s3,a5,-1
    5eec:	99ba                	add	s3,s3,a4
    5eee:	377d                	addw	a4,a4,-1
    5ef0:	1702                	sll	a4,a4,0x20
    5ef2:	9301                	srl	a4,a4,0x20
    5ef4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5ef8:	fff94583          	lbu	a1,-1(s2)
    5efc:	8526                	mv	a0,s1
    5efe:	00000097          	auipc	ra,0x0
    5f02:	f56080e7          	jalr	-170(ra) # 5e54 <putc>
  while(--i >= 0)
    5f06:	197d                	add	s2,s2,-1
    5f08:	ff3918e3          	bne	s2,s3,5ef8 <printint+0x82>
}
    5f0c:	70e2                	ld	ra,56(sp)
    5f0e:	7442                	ld	s0,48(sp)
    5f10:	74a2                	ld	s1,40(sp)
    5f12:	7902                	ld	s2,32(sp)
    5f14:	69e2                	ld	s3,24(sp)
    5f16:	6121                	add	sp,sp,64
    5f18:	8082                	ret
    x = -xx;
    5f1a:	40b005bb          	negw	a1,a1
    neg = 1;
    5f1e:	4885                	li	a7,1
    x = -xx;
    5f20:	bf85                	j	5e90 <printint+0x1a>

0000000000005f22 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5f22:	715d                	add	sp,sp,-80
    5f24:	e486                	sd	ra,72(sp)
    5f26:	e0a2                	sd	s0,64(sp)
    5f28:	fc26                	sd	s1,56(sp)
    5f2a:	f84a                	sd	s2,48(sp)
    5f2c:	f44e                	sd	s3,40(sp)
    5f2e:	f052                	sd	s4,32(sp)
    5f30:	ec56                	sd	s5,24(sp)
    5f32:	e85a                	sd	s6,16(sp)
    5f34:	e45e                	sd	s7,8(sp)
    5f36:	e062                	sd	s8,0(sp)
    5f38:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5f3a:	0005c903          	lbu	s2,0(a1)
    5f3e:	18090c63          	beqz	s2,60d6 <vprintf+0x1b4>
    5f42:	8aaa                	mv	s5,a0
    5f44:	8bb2                	mv	s7,a2
    5f46:	00158493          	add	s1,a1,1
  state = 0;
    5f4a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5f4c:	02500a13          	li	s4,37
    5f50:	4b55                	li	s6,21
    5f52:	a839                	j	5f70 <vprintf+0x4e>
        putc(fd, c);
    5f54:	85ca                	mv	a1,s2
    5f56:	8556                	mv	a0,s5
    5f58:	00000097          	auipc	ra,0x0
    5f5c:	efc080e7          	jalr	-260(ra) # 5e54 <putc>
    5f60:	a019                	j	5f66 <vprintf+0x44>
    } else if(state == '%'){
    5f62:	01498d63          	beq	s3,s4,5f7c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5f66:	0485                	add	s1,s1,1
    5f68:	fff4c903          	lbu	s2,-1(s1)
    5f6c:	16090563          	beqz	s2,60d6 <vprintf+0x1b4>
    if(state == 0){
    5f70:	fe0999e3          	bnez	s3,5f62 <vprintf+0x40>
      if(c == '%'){
    5f74:	ff4910e3          	bne	s2,s4,5f54 <vprintf+0x32>
        state = '%';
    5f78:	89d2                	mv	s3,s4
    5f7a:	b7f5                	j	5f66 <vprintf+0x44>
      if(c == 'd'){
    5f7c:	13490263          	beq	s2,s4,60a0 <vprintf+0x17e>
    5f80:	f9d9079b          	addw	a5,s2,-99
    5f84:	0ff7f793          	zext.b	a5,a5
    5f88:	12fb6563          	bltu	s6,a5,60b2 <vprintf+0x190>
    5f8c:	f9d9079b          	addw	a5,s2,-99
    5f90:	0ff7f713          	zext.b	a4,a5
    5f94:	10eb6f63          	bltu	s6,a4,60b2 <vprintf+0x190>
    5f98:	00271793          	sll	a5,a4,0x2
    5f9c:	00002717          	auipc	a4,0x2
    5fa0:	7ec70713          	add	a4,a4,2028 # 8788 <malloc+0x25b4>
    5fa4:	97ba                	add	a5,a5,a4
    5fa6:	439c                	lw	a5,0(a5)
    5fa8:	97ba                	add	a5,a5,a4
    5faa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5fac:	008b8913          	add	s2,s7,8
    5fb0:	4685                	li	a3,1
    5fb2:	4629                	li	a2,10
    5fb4:	000ba583          	lw	a1,0(s7)
    5fb8:	8556                	mv	a0,s5
    5fba:	00000097          	auipc	ra,0x0
    5fbe:	ebc080e7          	jalr	-324(ra) # 5e76 <printint>
    5fc2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5fc4:	4981                	li	s3,0
    5fc6:	b745                	j	5f66 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5fc8:	008b8913          	add	s2,s7,8
    5fcc:	4681                	li	a3,0
    5fce:	4629                	li	a2,10
    5fd0:	000ba583          	lw	a1,0(s7)
    5fd4:	8556                	mv	a0,s5
    5fd6:	00000097          	auipc	ra,0x0
    5fda:	ea0080e7          	jalr	-352(ra) # 5e76 <printint>
    5fde:	8bca                	mv	s7,s2
      state = 0;
    5fe0:	4981                	li	s3,0
    5fe2:	b751                	j	5f66 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5fe4:	008b8913          	add	s2,s7,8
    5fe8:	4681                	li	a3,0
    5fea:	4641                	li	a2,16
    5fec:	000ba583          	lw	a1,0(s7)
    5ff0:	8556                	mv	a0,s5
    5ff2:	00000097          	auipc	ra,0x0
    5ff6:	e84080e7          	jalr	-380(ra) # 5e76 <printint>
    5ffa:	8bca                	mv	s7,s2
      state = 0;
    5ffc:	4981                	li	s3,0
    5ffe:	b7a5                	j	5f66 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    6000:	008b8c13          	add	s8,s7,8
    6004:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    6008:	03000593          	li	a1,48
    600c:	8556                	mv	a0,s5
    600e:	00000097          	auipc	ra,0x0
    6012:	e46080e7          	jalr	-442(ra) # 5e54 <putc>
  putc(fd, 'x');
    6016:	07800593          	li	a1,120
    601a:	8556                	mv	a0,s5
    601c:	00000097          	auipc	ra,0x0
    6020:	e38080e7          	jalr	-456(ra) # 5e54 <putc>
    6024:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6026:	00002b97          	auipc	s7,0x2
    602a:	7bab8b93          	add	s7,s7,1978 # 87e0 <digits>
    602e:	03c9d793          	srl	a5,s3,0x3c
    6032:	97de                	add	a5,a5,s7
    6034:	0007c583          	lbu	a1,0(a5)
    6038:	8556                	mv	a0,s5
    603a:	00000097          	auipc	ra,0x0
    603e:	e1a080e7          	jalr	-486(ra) # 5e54 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    6042:	0992                	sll	s3,s3,0x4
    6044:	397d                	addw	s2,s2,-1
    6046:	fe0914e3          	bnez	s2,602e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    604a:	8be2                	mv	s7,s8
      state = 0;
    604c:	4981                	li	s3,0
    604e:	bf21                	j	5f66 <vprintf+0x44>
        s = va_arg(ap, char*);
    6050:	008b8993          	add	s3,s7,8
    6054:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    6058:	02090163          	beqz	s2,607a <vprintf+0x158>
        while(*s != 0){
    605c:	00094583          	lbu	a1,0(s2)
    6060:	c9a5                	beqz	a1,60d0 <vprintf+0x1ae>
          putc(fd, *s);
    6062:	8556                	mv	a0,s5
    6064:	00000097          	auipc	ra,0x0
    6068:	df0080e7          	jalr	-528(ra) # 5e54 <putc>
          s++;
    606c:	0905                	add	s2,s2,1
        while(*s != 0){
    606e:	00094583          	lbu	a1,0(s2)
    6072:	f9e5                	bnez	a1,6062 <vprintf+0x140>
        s = va_arg(ap, char*);
    6074:	8bce                	mv	s7,s3
      state = 0;
    6076:	4981                	li	s3,0
    6078:	b5fd                	j	5f66 <vprintf+0x44>
          s = "(null)";
    607a:	00002917          	auipc	s2,0x2
    607e:	70690913          	add	s2,s2,1798 # 8780 <malloc+0x25ac>
        while(*s != 0){
    6082:	02800593          	li	a1,40
    6086:	bff1                	j	6062 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    6088:	008b8913          	add	s2,s7,8
    608c:	000bc583          	lbu	a1,0(s7)
    6090:	8556                	mv	a0,s5
    6092:	00000097          	auipc	ra,0x0
    6096:	dc2080e7          	jalr	-574(ra) # 5e54 <putc>
    609a:	8bca                	mv	s7,s2
      state = 0;
    609c:	4981                	li	s3,0
    609e:	b5e1                	j	5f66 <vprintf+0x44>
        putc(fd, c);
    60a0:	02500593          	li	a1,37
    60a4:	8556                	mv	a0,s5
    60a6:	00000097          	auipc	ra,0x0
    60aa:	dae080e7          	jalr	-594(ra) # 5e54 <putc>
      state = 0;
    60ae:	4981                	li	s3,0
    60b0:	bd5d                	j	5f66 <vprintf+0x44>
        putc(fd, '%');
    60b2:	02500593          	li	a1,37
    60b6:	8556                	mv	a0,s5
    60b8:	00000097          	auipc	ra,0x0
    60bc:	d9c080e7          	jalr	-612(ra) # 5e54 <putc>
        putc(fd, c);
    60c0:	85ca                	mv	a1,s2
    60c2:	8556                	mv	a0,s5
    60c4:	00000097          	auipc	ra,0x0
    60c8:	d90080e7          	jalr	-624(ra) # 5e54 <putc>
      state = 0;
    60cc:	4981                	li	s3,0
    60ce:	bd61                	j	5f66 <vprintf+0x44>
        s = va_arg(ap, char*);
    60d0:	8bce                	mv	s7,s3
      state = 0;
    60d2:	4981                	li	s3,0
    60d4:	bd49                	j	5f66 <vprintf+0x44>
    }
  }
}
    60d6:	60a6                	ld	ra,72(sp)
    60d8:	6406                	ld	s0,64(sp)
    60da:	74e2                	ld	s1,56(sp)
    60dc:	7942                	ld	s2,48(sp)
    60de:	79a2                	ld	s3,40(sp)
    60e0:	7a02                	ld	s4,32(sp)
    60e2:	6ae2                	ld	s5,24(sp)
    60e4:	6b42                	ld	s6,16(sp)
    60e6:	6ba2                	ld	s7,8(sp)
    60e8:	6c02                	ld	s8,0(sp)
    60ea:	6161                	add	sp,sp,80
    60ec:	8082                	ret

00000000000060ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    60ee:	715d                	add	sp,sp,-80
    60f0:	ec06                	sd	ra,24(sp)
    60f2:	e822                	sd	s0,16(sp)
    60f4:	1000                	add	s0,sp,32
    60f6:	e010                	sd	a2,0(s0)
    60f8:	e414                	sd	a3,8(s0)
    60fa:	e818                	sd	a4,16(s0)
    60fc:	ec1c                	sd	a5,24(s0)
    60fe:	03043023          	sd	a6,32(s0)
    6102:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    6106:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    610a:	8622                	mv	a2,s0
    610c:	00000097          	auipc	ra,0x0
    6110:	e16080e7          	jalr	-490(ra) # 5f22 <vprintf>
}
    6114:	60e2                	ld	ra,24(sp)
    6116:	6442                	ld	s0,16(sp)
    6118:	6161                	add	sp,sp,80
    611a:	8082                	ret

000000000000611c <printf>:

void
printf(const char *fmt, ...)
{
    611c:	711d                	add	sp,sp,-96
    611e:	ec06                	sd	ra,24(sp)
    6120:	e822                	sd	s0,16(sp)
    6122:	1000                	add	s0,sp,32
    6124:	e40c                	sd	a1,8(s0)
    6126:	e810                	sd	a2,16(s0)
    6128:	ec14                	sd	a3,24(s0)
    612a:	f018                	sd	a4,32(s0)
    612c:	f41c                	sd	a5,40(s0)
    612e:	03043823          	sd	a6,48(s0)
    6132:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    6136:	00840613          	add	a2,s0,8
    613a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    613e:	85aa                	mv	a1,a0
    6140:	4505                	li	a0,1
    6142:	00000097          	auipc	ra,0x0
    6146:	de0080e7          	jalr	-544(ra) # 5f22 <vprintf>
}
    614a:	60e2                	ld	ra,24(sp)
    614c:	6442                	ld	s0,16(sp)
    614e:	6125                	add	sp,sp,96
    6150:	8082                	ret

0000000000006152 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6152:	1141                	add	sp,sp,-16
    6154:	e422                	sd	s0,8(sp)
    6156:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6158:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    615c:	00003797          	auipc	a5,0x3
    6160:	2f47b783          	ld	a5,756(a5) # 9450 <freep>
    6164:	a02d                	j	618e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6166:	4618                	lw	a4,8(a2)
    6168:	9f2d                	addw	a4,a4,a1
    616a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    616e:	6398                	ld	a4,0(a5)
    6170:	6310                	ld	a2,0(a4)
    6172:	a83d                	j	61b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6174:	ff852703          	lw	a4,-8(a0)
    6178:	9f31                	addw	a4,a4,a2
    617a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    617c:	ff053683          	ld	a3,-16(a0)
    6180:	a091                	j	61c4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6182:	6398                	ld	a4,0(a5)
    6184:	00e7e463          	bltu	a5,a4,618c <free+0x3a>
    6188:	00e6ea63          	bltu	a3,a4,619c <free+0x4a>
{
    618c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    618e:	fed7fae3          	bgeu	a5,a3,6182 <free+0x30>
    6192:	6398                	ld	a4,0(a5)
    6194:	00e6e463          	bltu	a3,a4,619c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6198:	fee7eae3          	bltu	a5,a4,618c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    619c:	ff852583          	lw	a1,-8(a0)
    61a0:	6390                	ld	a2,0(a5)
    61a2:	02059813          	sll	a6,a1,0x20
    61a6:	01c85713          	srl	a4,a6,0x1c
    61aa:	9736                	add	a4,a4,a3
    61ac:	fae60de3          	beq	a2,a4,6166 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    61b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    61b4:	4790                	lw	a2,8(a5)
    61b6:	02061593          	sll	a1,a2,0x20
    61ba:	01c5d713          	srl	a4,a1,0x1c
    61be:	973e                	add	a4,a4,a5
    61c0:	fae68ae3          	beq	a3,a4,6174 <free+0x22>
    p->s.ptr = bp->s.ptr;
    61c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    61c6:	00003717          	auipc	a4,0x3
    61ca:	28f73523          	sd	a5,650(a4) # 9450 <freep>
}
    61ce:	6422                	ld	s0,8(sp)
    61d0:	0141                	add	sp,sp,16
    61d2:	8082                	ret

00000000000061d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    61d4:	7139                	add	sp,sp,-64
    61d6:	fc06                	sd	ra,56(sp)
    61d8:	f822                	sd	s0,48(sp)
    61da:	f426                	sd	s1,40(sp)
    61dc:	f04a                	sd	s2,32(sp)
    61de:	ec4e                	sd	s3,24(sp)
    61e0:	e852                	sd	s4,16(sp)
    61e2:	e456                	sd	s5,8(sp)
    61e4:	e05a                	sd	s6,0(sp)
    61e6:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    61e8:	02051493          	sll	s1,a0,0x20
    61ec:	9081                	srl	s1,s1,0x20
    61ee:	04bd                	add	s1,s1,15
    61f0:	8091                	srl	s1,s1,0x4
    61f2:	0014899b          	addw	s3,s1,1
    61f6:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    61f8:	00003517          	auipc	a0,0x3
    61fc:	25853503          	ld	a0,600(a0) # 9450 <freep>
    6200:	c515                	beqz	a0,622c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6202:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6204:	4798                	lw	a4,8(a5)
    6206:	02977f63          	bgeu	a4,s1,6244 <malloc+0x70>
  if(nu < 4096)
    620a:	8a4e                	mv	s4,s3
    620c:	0009871b          	sext.w	a4,s3
    6210:	6685                	lui	a3,0x1
    6212:	00d77363          	bgeu	a4,a3,6218 <malloc+0x44>
    6216:	6a05                	lui	s4,0x1
    6218:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    621c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6220:	00003917          	auipc	s2,0x3
    6224:	23090913          	add	s2,s2,560 # 9450 <freep>
  if(p == (char*)-1)
    6228:	5afd                	li	s5,-1
    622a:	a895                	j	629e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    622c:	0000a797          	auipc	a5,0xa
    6230:	a4c78793          	add	a5,a5,-1460 # fc78 <base>
    6234:	00003717          	auipc	a4,0x3
    6238:	20f73e23          	sd	a5,540(a4) # 9450 <freep>
    623c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    623e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6242:	b7e1                	j	620a <malloc+0x36>
      if(p->s.size == nunits)
    6244:	02e48c63          	beq	s1,a4,627c <malloc+0xa8>
        p->s.size -= nunits;
    6248:	4137073b          	subw	a4,a4,s3
    624c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    624e:	02071693          	sll	a3,a4,0x20
    6252:	01c6d713          	srl	a4,a3,0x1c
    6256:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6258:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    625c:	00003717          	auipc	a4,0x3
    6260:	1ea73a23          	sd	a0,500(a4) # 9450 <freep>
      return (void*)(p + 1);
    6264:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6268:	70e2                	ld	ra,56(sp)
    626a:	7442                	ld	s0,48(sp)
    626c:	74a2                	ld	s1,40(sp)
    626e:	7902                	ld	s2,32(sp)
    6270:	69e2                	ld	s3,24(sp)
    6272:	6a42                	ld	s4,16(sp)
    6274:	6aa2                	ld	s5,8(sp)
    6276:	6b02                	ld	s6,0(sp)
    6278:	6121                	add	sp,sp,64
    627a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    627c:	6398                	ld	a4,0(a5)
    627e:	e118                	sd	a4,0(a0)
    6280:	bff1                	j	625c <malloc+0x88>
  hp->s.size = nu;
    6282:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6286:	0541                	add	a0,a0,16
    6288:	00000097          	auipc	ra,0x0
    628c:	eca080e7          	jalr	-310(ra) # 6152 <free>
  return freep;
    6290:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6294:	d971                	beqz	a0,6268 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6296:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6298:	4798                	lw	a4,8(a5)
    629a:	fa9775e3          	bgeu	a4,s1,6244 <malloc+0x70>
    if(p == freep)
    629e:	00093703          	ld	a4,0(s2)
    62a2:	853e                	mv	a0,a5
    62a4:	fef719e3          	bne	a4,a5,6296 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    62a8:	8552                	mv	a0,s4
    62aa:	00000097          	auipc	ra,0x0
    62ae:	b92080e7          	jalr	-1134(ra) # 5e3c <sbrk>
  if(p == (char*)-1)
    62b2:	fd5518e3          	bne	a0,s5,6282 <malloc+0xae>
        return 0;
    62b6:	4501                	li	a0,0
    62b8:	bf45                	j	6268 <malloc+0x94>
