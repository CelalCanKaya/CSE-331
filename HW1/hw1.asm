.data
	Space  : .space 256
	file : .asciiz "input_hw1.txt"
	sifir : .asciiz "zero"
	bir : .asciiz "one"
	iki : .asciiz "two"
	�c : .asciiz "three"
	d�rt : .asciiz "four"
	bes : .asciiz "five"
	alti : .asciiz "six"
	yedi : .asciiz "seven"
	sekiz : .asciiz "eight"
	dokuz : .asciiz "nine"
	Bsifir : .asciiz "Zero"
	Bbir : .asciiz "One"
	Biki : .asciiz "Two"
	B�c : .asciiz "Three"
	Bd�rt : .asciiz "Four"
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
	move $s7, $v0 		#Dosyay� en son da kapatmak i�in File Descriptor'u saveledim


	#Read File
	move $a0, $v0
	li $v0, 14
	la $a1, Space
	li $a2, 256
	syscall
	
		
lp:
	lb $a0, ($a1)        # a1 Register�ndan a0 register�na byte load ettim
	beqz $a0, end		# a0 Register�ndaki de�er 0'dan k���kse program� kapatmak i�in end label�na git.
	ble $a0, 57, control	# a0 Register�ndaki Ascii de�eri 57 den k���kse control label�na git (Say� Kontrol�)
lp2:
	li $v0, 11            # a0 Byte�ndaki karakteri ekrana yazd�r�yorum
	syscall
lp3:
	add $a1, $a1, 1		# Bir sonraki byte � almak i�in a1'i 1 artt�r�yorum
	jal lp
	
	
control:
	bge $a0, 48, print	# Asci de�eri 57'den k���k 48'den b�y�kse say� olaca�� i�in print labeline aktar�yorum.
	jal lp2		# Say� de�ilse lp2 labeline geri d�n
	
control2:
	add $a1, $a1, -1	#�ki �nce olan adreste nokta olup olmad���n� kontrol edece�im.
	lb $a0, ($a1)
	beq $a0, 46, printNumB 	# C�mle ba�� oldugu printNumB labeline aktar�yorum.	
	add $a1, $a1, 2
	lb $a0, ($a1)
	jal printNum	 #  C�mle ba�� olmad��� i�in printNum labeline aktar�yorum
	
digitC:
	bge $a0, 48, digitCw	# Asci de�eri 57'den k���k 48'den b�y�kse say� olaca�� i�in digitCw labeline aktar�yorum.
	jal print1	#Say� olmad��� i�in print1 Labeline d�n�yorum
	
digitCw:
	add $a1, $a1, -1
	lb $a0, ($a1)
	jal lp2		# Bir sonraki karakterde digit oldu�undan say�y� �evirmeden ekrana yazd�raca��m. lp2 Labeline atl�yorum
	
digitC2:
	bge $a0, 48, digitCw2	# Asci de�eri 57'den k���k 48'den b�y�kse say� olaca�� i�in digitCw2 labeline aktar�yorum.
	add $a1, $a1, 1
	jal print2	#Say� olmad��� i�in print2 Labeline d�n�yorum
	
digitCw2:
	add $a1, $a1, 1
	lb $a0, ($a1)
	jal lp2		# Bir �nceki karakterde digit oldu�undan say�y� �evirmeden ekrana yazd�raca��m. lp2 Labeline atl�yorum
	
afterDot:
	add $a1, $a1, 1
	lb $a0, ($a1)
	ble $a0, 57, afterDot2	#Noktadan sonra say� gelip gelmedi�ini kontrol edece�im. Asci de�eri 57 den k���kse afterDot2 labeline git.
	add $a1, $a1, -2
	jal print3
	
afterDot2:
	bge $a0, 48, afterDotw	#Noktadan sonra say� geldi�inden Ondal�k say� oldugunu anlad�m.Oldugu gibi yazmak i�in afterDotw Labeline git.
	add $a1, $a1, -2
	jal print3
	
afterDotw:
	add $a1, $a1, -2
	lb $a0, ($a1)
	jal lp2		#Say�y� �evirmeden yazmak i�in lp2 ye d�n�yorum
	
beforeDot:
	add $a1, $a1, -1
	lb $a0, ($a1)
	ble $a0, 57, beforeDot2	#�ki �nceki adresteki karakterin say� olup olmad���n� kontrol ediyorum.
	add $a1, $a1, 2
	jal print4	#Ondal�k Say� olmad��� i�in print4 labeline gidiyorum.
	
beforeDot2:
	bge $a0, 48, beforeDotw	#�ki �nceki adresteki karakter say�ysa Ondal�k olaca��ndan beforeDotw labeline d�n�yorum.
	add $a1, $a1, 2
	jal print4	#Ondal�k Say� olmad��� i�in print4 labeline gidiyorum.

beforeDotw:
	add $a1, $a1, 2		#Oldu�um adrese geri d�nmek i�in 2 ekliyorum	
	lb $a0, ($a1)
	jal lp2		#Bir �nceki byte nokta ve ondan �ncekide say� oldugu i�in karakteri oldugu gibi ekrana bast�rmak i�in lp2'ye d�n�yorum
	
print:		
	li $v0, 4	
	add $a1, $a1, 1		#Bir sonraki Byte'da digit olup olmad���n� kontrol edece�im
	lb $a0, ($a1)
	ble $a0, 57, digitC
print1:		
	add $a1, $a1, -2	#Bir �nceki Byte'da digit olup olmad���n� kontrol edece�im
	lb $a0, ($a1)
	ble $a0, 57, digitC2
	add $a1, $a1, 1
print2:		
	add $a1, $a1, 1		#Bir sonraki Byte'da nokta olup olmad���n� kontrol edece�im
	lb $a0, ($a1)
	beq $a0, 46, afterDot
	add $a1, $a1, -1
print3:		
	add $a1, $a1, -1	#Bir �nceki Byte'da nokta olup olmad���n� kontrol edece�im
	lb $a0, ($a1)
	beq $a0, 46, beforeDot
	add $a1, $a1, 1
	lb $a0, ($a1)
print4:		
	add $a1, $a1, -1	#Bir �nceki Byte'da bo�luk olup olmad���n� kontrol edece�im
	lb $a0, ($a1)
	beq $a0, 32, control2
	add $a1, $a1, 1
	lb $a0, ($a1)
printNum:
	beq $a0, 48, zero	#Yazd�raca��m say� 0'sa zero labeline gidiyorum
	beq $a0, 49, one	#Yazd�raca��m say� 1'se one labeline gidiyorum
	beq $a0, 50, two	#Yazd�raca��m say� 2'yse two labeline gidiyorum
	beq $a0, 51, three	#Yazd�raca��m say� 3'se three labeline gidiyorum
	beq $a0, 52, four	#Yazd�raca��m say� 4'se four labeline gidiyorum
	beq $a0, 53, five	#Yazd�raca��m say� 5'se five labeline gidiyorum
	beq $a0, 54, six	#Yazd�raca��m say� 6'ysa six labeline gidiyorum
	beq $a0, 55, seven	#Yazd�raca��m say� 7'yse seven labeline gidiyorum
	beq $a0, 56, eight	#Yazd�raca��m say� 8'se eight labeline gidiyorum
	beq $a0, 57, nine	#Yazd�raca��m say� 9'sa nine labeline gidiyorum
printNumB:
	add $a1, $a1, 2
	lb $a0, ($a1)
	beq $a0, 48, Bzero	#Yazd�raca��m say� b�y�k 0'sa zero labeline gidiyorum
	beq $a0, 49, Bone	#Yazd�raca��m say� b�y�k 1'se one labeline gidiyorum
	beq $a0, 50, Btwo	#Yazd�raca��m say� b�y�k 2'yse two labeline gidiyorum
	beq $a0, 51, Bthree	#Yazd�raca��m say� b�y�k 3'se three labeline gidiyorum
	beq $a0, 52, Bfour	#Yazd�raca��m say� b�y�k 4'se four labeline gidiyorum
	beq $a0, 53, Bfive	#Yazd�raca��m say� b�y�k 5'se five labeline gidiyorum
	beq $a0, 54, Bsix	#Yazd�raca��m say� b�y�k 6'ysa six labeline gidiyorum
	beq $a0, 55, Bseven	#Yazd�raca��m say� b�y�k 7'yse seven labeline gidiyorum
	beq $a0, 56, Beight	#Yazd�raca��m say� b�y�k 8'se eight labeline gidiyorum
	beq $a0, 57, Bnine	#Yazd�raca��m say� b�y�k 9'sa nine labeline gidiyorum
	
#Ekrana Say�y� Yazd�rmam ��in Adresi Load Etti�im Labeller
	
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
	la $a0, �c
	syscall
	jal lp3
four:
	la $a0, d�rt
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
	la $a0, B�c
	syscall
	jal lp3
Bfour:
	la $a0, Bd�rt
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

#Procedure Kullan�m�

end:
	jal closeF	#Dosyay� Kapatma Labeline Atl�yorum
	li $v0, 10
	syscall

closeF:
  	li   $v0, 16       
  	move $a0, $s7      
	syscall
	jr $ra		#End Labelinde Kald���m Yere Geri D�n�yor
	
