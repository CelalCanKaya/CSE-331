.data
	Space  : .space 256
	file : .asciiz "input_hw1.txt"
	sifir : .asciiz "zero"
	bir : .asciiz "one"
	iki : .asciiz "two"
	üc : .asciiz "three"
	dört : .asciiz "four"
	bes : .asciiz "five"
	alti : .asciiz "six"
	yedi : .asciiz "seven"
	sekiz : .asciiz "eight"
	dokuz : .asciiz "nine"
	Bsifir : .asciiz "Zero"
	Bbir : .asciiz "One"
	Biki : .asciiz "Two"
	Büc : .asciiz "Three"
	Bdört : .asciiz "Four"
	Bbes : .asciiz "Five"
	Balti : .asciiz "Six"
	Byedi : .asciiz "Seven"
	Bsekiz : .asciiz "Eight"
	Bdokuz : .asciiz "Nine"
.text
	.globl main
	
main:
	# Open File
	li $v0, 13
	la $a0, file
	li $a1, 0
	li $a2, 0 
	syscall
	move $s7, $v0 		#Dosyayý en son da kapatmak için File Descriptor'u saveledim


	#Read File
	move $a0, $v0
	li $v0, 14
	la $a1, Space
	li $a2, 256
	syscall
	
		
lp:
	lb $a0, ($a1)        # a1 Registerýndan a0 registerýna byte load ettim
	beqz $a0, end		# a0 Registerýndaki deðer 0'dan küçükse programý kapatmak için end labelýna git.
	ble $a0, 57, control	# a0 Registerýndaki Ascii deðeri 57 den küçükse control labelýna git (Sayý Kontrolü)
lp2:
	li $v0, 11            # a0 Byteýndaki karakteri ekrana yazdýrýyorum
	syscall
lp3:
	add $a1, $a1, 1		# Bir sonraki byte ý almak için a1'i 1 arttýrýyorum
	jal lp
	
	
control:
	bge $a0, 48, print	# Asci deðeri 57'den küçük 48'den büyükse sayý olacaðý için print labeline aktarýyorum.
	jal lp2		# Sayý deðilse lp2 labeline geri dön
	
control2:
	add $a1, $a1, -1	#Ýki önce olan adreste nokta olup olmadýðýný kontrol edeceðim.
	lb $a0, ($a1)
	beq $a0, 46, printNumB 	# Cümle baþý oldugu printNumB labeline aktarýyorum.	
	add $a1, $a1, 2
	lb $a0, ($a1)
	jal printNum	 #  Cümle baþý olmadýðý için printNum labeline aktarýyorum
	
digitC:
	bge $a0, 48, digitCw	# Asci deðeri 57'den küçük 48'den büyükse sayý olacaðý için digitCw labeline aktarýyorum.
	jal print1	#Sayý olmadýðý için print1 Labeline dönüyorum
	
digitCw:
	add $a1, $a1, -1
	lb $a0, ($a1)
	jal lp2		# Bir sonraki karakterde digit olduðundan sayýyý çevirmeden ekrana yazdýracaðým. lp2 Labeline atlýyorum
	
digitC2:
	bge $a0, 48, digitCw2	# Asci deðeri 57'den küçük 48'den büyükse sayý olacaðý için digitCw2 labeline aktarýyorum.
	add $a1, $a1, 1
	jal print2	#Sayý olmadýðý için print2 Labeline dönüyorum
	
digitCw2:
	add $a1, $a1, 1
	lb $a0, ($a1)
	jal lp2		# Bir önceki karakterde digit olduðundan sayýyý çevirmeden ekrana yazdýracaðým. lp2 Labeline atlýyorum
	
afterDot:
	add $a1, $a1, 1
	lb $a0, ($a1)
	ble $a0, 57, afterDot2	#Noktadan sonra sayý gelip gelmediðini kontrol edeceðim. Asci deðeri 57 den küçükse afterDot2 labeline git.
	add $a1, $a1, -2
	jal print3
	
afterDot2:
	bge $a0, 48, afterDotw	#Noktadan sonra sayý geldiðinden Ondalýk sayý oldugunu anladým.Oldugu gibi yazmak için afterDotw Labeline git.
	add $a1, $a1, -2
	jal print3
	
afterDotw:
	add $a1, $a1, -2
	lb $a0, ($a1)
	jal lp2		#Sayýyý çevirmeden yazmak için lp2 ye dönüyorum
	
beforeDot:
	add $a1, $a1, -1
	lb $a0, ($a1)
	ble $a0, 57, beforeDot2	#Ýki önceki adresteki karakterin sayý olup olmadýðýný kontrol ediyorum.
	add $a1, $a1, 2
	jal print4	#Ondalýk Sayý olmadýðý için print4 labeline gidiyorum.
	
beforeDot2:
	bge $a0, 48, beforeDotw	#Ýki önceki adresteki karakter sayýysa Ondalýk olacaðýndan beforeDotw labeline dönüyorum.
	add $a1, $a1, 2
	jal print4	#Ondalýk Sayý olmadýðý için print4 labeline gidiyorum.

beforeDotw:
	add $a1, $a1, 2		#Olduðum adrese geri dönmek için 2 ekliyorum	
	lb $a0, ($a1)
	jal lp2		#Bir önceki byte nokta ve ondan öncekide sayý oldugu için karakteri oldugu gibi ekrana bastýrmak için lp2'ye dönüyorum
	
print:		
	li $v0, 4	
	add $a1, $a1, 1		#Bir sonraki Byte'da digit olup olmadýðýný kontrol edeceðim
	lb $a0, ($a1)
	ble $a0, 57, digitC
print1:		
	add $a1, $a1, -2	#Bir önceki Byte'da digit olup olmadýðýný kontrol edeceðim
	lb $a0, ($a1)
	ble $a0, 57, digitC2
	add $a1, $a1, 1
print2:		
	add $a1, $a1, 1		#Bir sonraki Byte'da nokta olup olmadýðýný kontrol edeceðim
	lb $a0, ($a1)
	beq $a0, 46, afterDot
	add $a1, $a1, -1
print3:		
	add $a1, $a1, -1	#Bir önceki Byte'da nokta olup olmadýðýný kontrol edeceðim
	lb $a0, ($a1)
	beq $a0, 46, beforeDot
	add $a1, $a1, 1
	lb $a0, ($a1)
print4:		
	add $a1, $a1, -1	#Bir önceki Byte'da boþluk olup olmadýðýný kontrol edeceðim
	lb $a0, ($a1)
	beq $a0, 32, control2
	add $a1, $a1, 1
	lb $a0, ($a1)
printNum:
	beq $a0, 48, zero	#Yazdýracaðým sayý 0'sa zero labeline gidiyorum
	beq $a0, 49, one	#Yazdýracaðým sayý 1'se one labeline gidiyorum
	beq $a0, 50, two	#Yazdýracaðým sayý 2'yse two labeline gidiyorum
	beq $a0, 51, three	#Yazdýracaðým sayý 3'se three labeline gidiyorum
	beq $a0, 52, four	#Yazdýracaðým sayý 4'se four labeline gidiyorum
	beq $a0, 53, five	#Yazdýracaðým sayý 5'se five labeline gidiyorum
	beq $a0, 54, six	#Yazdýracaðým sayý 6'ysa six labeline gidiyorum
	beq $a0, 55, seven	#Yazdýracaðým sayý 7'yse seven labeline gidiyorum
	beq $a0, 56, eight	#Yazdýracaðým sayý 8'se eight labeline gidiyorum
	beq $a0, 57, nine	#Yazdýracaðým sayý 9'sa nine labeline gidiyorum
printNumB:
	add $a1, $a1, 2
	lb $a0, ($a1)
	beq $a0, 48, Bzero	#Yazdýracaðým sayý büyük 0'sa zero labeline gidiyorum
	beq $a0, 49, Bone	#Yazdýracaðým sayý büyük 1'se one labeline gidiyorum
	beq $a0, 50, Btwo	#Yazdýracaðým sayý büyük 2'yse two labeline gidiyorum
	beq $a0, 51, Bthree	#Yazdýracaðým sayý büyük 3'se three labeline gidiyorum
	beq $a0, 52, Bfour	#Yazdýracaðým sayý büyük 4'se four labeline gidiyorum
	beq $a0, 53, Bfive	#Yazdýracaðým sayý büyük 5'se five labeline gidiyorum
	beq $a0, 54, Bsix	#Yazdýracaðým sayý büyük 6'ysa six labeline gidiyorum
	beq $a0, 55, Bseven	#Yazdýracaðým sayý büyük 7'yse seven labeline gidiyorum
	beq $a0, 56, Beight	#Yazdýracaðým sayý büyük 8'se eight labeline gidiyorum
	beq $a0, 57, Bnine	#Yazdýracaðým sayý büyük 9'sa nine labeline gidiyorum
	
#Ekrana Sayýyý Yazdýrmam Ýçin Adresi Load Ettiðim Labeller
	
zero:
	la $a0, sifir
	syscall
	jal lp3	

one:
	la $a0, bir
	syscall
	jal lp3
two:
	la $a0, iki
	syscall
	jal lp3
three:
	la $a0, üc
	syscall
	jal lp3
four:
	la $a0, dört
	syscall
	jal lp3
five:
	la $a0, bes
	syscall
	jal lp3
six:
	la $a0, alti
	syscall
	jal lp3
seven:
	la $a0, yedi
	syscall
	jal lp3
eight:
	la $a0, sekiz
	syscall
	jal lp3
nine:
	la $a0, dokuz
	syscall
	jal lp3

Bzero:
	la $a0, Bsifir
	syscall
	jal lp3	

Bone:
	la $a0, Bbir
	syscall
	jal lp3
Btwo:
	la $a0, Biki
	syscall
	jal lp3
Bthree:
	la $a0, Büc
	syscall
	jal lp3
Bfour:
	la $a0, Bdört
	syscall
	jal lp3
Bfive:
	la $a0, Bbes
	syscall
	jal lp3
Bsix:
	la $a0, Balti
	syscall
	jal lp3
Bseven:
	la $a0, Byedi
	syscall
	jal lp3
Beight:
	la $a0, Bsekiz
	syscall
	jal lp3
Bnine:
	la $a0, Bdokuz
	syscall
	jal lp3

#Procedure Kullanýmý

end:
	jal closeF	#Dosyayý Kapatma Labeline Atlýyorum
	li $v0, 10
	syscall

closeF:
  	li   $v0, 16       
  	move $a0, $s7      
	syscall
	jr $ra		#End Labelinde Kaldýðým Yere Geri Dönüyor
	
