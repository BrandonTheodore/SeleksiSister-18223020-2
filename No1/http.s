	.file	"http.c"
	.text
	.section	.rodata
.LC0:
	.string	"Gagal membuat socket"
.LC1:
	.string	"Gagal setsockopt"
.LC2:
	.string	"Gagal melakukan bind"
.LC3:
	.string	"Gagal listen"
	.align 8
.LC4:
	.string	"Server mendengarkan pada port %d...\n"
.LC5:
	.string	"Gagal accept"
.LC6:
	.string	"Koneksi diterima dari %s:%d\n"
.LC7:
	.string	"Gagal fork"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movl	$16, -68(%rbp)
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L2
	movl	$.LC0, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L2:
	movl	$1, -72(%rbp)
	leaq	-72(%rbp), %rdx
	movl	-20(%rbp), %eax
	movl	$4, %r8d
	movq	%rdx, %rcx
	movl	$2, %edx
	movl	$1, %esi
	movl	%eax, %edi
	call	setsockopt
	testl	%eax, %eax
	jns	.L3
	movl	$.LC1, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L3:
	movw	$2, -48(%rbp)
	movl	$0, -44(%rbp)
	movl	$6969, %edi
	call	htons
	movw	%ax, -46(%rbp)
	leaq	-48(%rbp), %rcx
	movl	-20(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind
	testl	%eax, %eax
	jns	.L4
	movl	$.LC2, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L4:
	movl	-20(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	listen
	testl	%eax, %eax
	jns	.L5
	movl	$.LC3, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L5:
	movl	$6969, %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
.L10:
	leaq	-68(%rbp), %rdx
	leaq	-64(%rbp), %rcx
	movl	-20(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jns	.L6
	movl	$.LC5, %edi
	call	perror
	jmp	.L7
.L6:
	movzwl	-62(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	ntohs
	movzwl	%ax, %ebx
	movl	-60(%rbp), %eax
	movl	%eax, %edi
	call	inet_ntoa
	movl	%ebx, %edx
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	call	fork
	movl	%eax, -28(%rbp)
	cmpl	$0, -28(%rbp)
	jns	.L8
	movl	$.LC7, %edi
	call	perror
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L10
.L8:
	cmpl	$0, -28(%rbp)
	jne	.L9
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	handle_client
	movl	$0, %edi
	call	exit
.L9:
	movl	-24(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edx
	movl	$0, %esi
	movl	$-1, %edi
	call	waitpid
.L7:
	jmp	.L10
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
.LC8:
	.string	" "
.LC9:
	.string	"Request: %s %s\n"
.LC10:
	.string	"GET"
.LC11:
	.string	"/"
.LC12:
	.string	"/index.html"
.LC13:
	.string	"/test"
	.align 8
.LC14:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nCuma buat test"
.LC15:
	.string	"POST"
	.align 8
.LC16:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nRequest POST diterima!"
.LC17:
	.string	"PUT"
	.align 8
.LC18:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nRequest PUT diterima!"
.LC19:
	.string	"DELETE"
	.align 8
.LC20:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nRequest DELETE diterima!"
	.align 8
.LC21:
	.string	"HTTP/1.1 501 Not Implemented\r\nContent-Type: text/plain\r\n\r\nMethod tidak didukung."
	.text
	.globl	handle_client
	.type	handle_client, @function
handle_client:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4176, %rsp
	movl	%edi, -4164(%rbp)
	leaq	-4160(%rbp), %rdx
	movl	$0, %eax
	movl	$512, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-4160(%rbp), %rcx
	movl	-4164(%rbp), %eax
	movl	$4095, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jg	.L12
	movl	-4164(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L11
.L12:
	leaq	-4160(%rbp), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -16(%rbp)
	movl	$.LC8, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -24(%rbp)
	cmpq	$0, -16(%rbp)
	je	.L14
	cmpq	$0, -24(%rbp)
	jne	.L15
.L14:
	movl	-4164(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L11
.L15:
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	movq	-16(%rbp), %rax
	movl	$.LC10, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L16
	movq	-24(%rbp), %rax
	movl	$.LC11, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L17
	movl	-4164(%rbp), %eax
	movl	$.LC12, %esi
	movl	%eax, %edi
	call	serve_file
	jmp	.L18
.L17:
	movq	-24(%rbp), %rax
	movl	$.LC13, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L19
	movq	$.LC14, -64(%rbp)
	movl	$10, %edi
	call	sleep
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-64(%rbp), %rsi
	movl	-4164(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L18
.L19:
	movq	-24(%rbp), %rdx
	movl	-4164(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	serve_file
	jmp	.L18
.L16:
	movq	-16(%rbp), %rax
	movl	$.LC15, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L20
	movq	$.LC16, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-56(%rbp), %rsi
	movl	-4164(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L18
.L20:
	movq	-16(%rbp), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L21
	movq	$.LC18, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-48(%rbp), %rsi
	movl	-4164(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L18
.L21:
	movq	-16(%rbp), %rax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L22
	movq	$.LC20, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-40(%rbp), %rsi
	movl	-4164(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L18
.L22:
	movq	$.LC21, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-32(%rbp), %rsi
	movl	-4164(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
.L18:
	movl	-4164(%rbp), %eax
	movl	%eax, %edi
	call	close
.L11:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	handle_client, .-handle_client
	.section	.rodata
.LC22:
	.string	"./public"
.LC23:
	.string	"%s%s"
.LC24:
	.string	"rb"
	.align 8
.LC25:
	.string	"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\n404 Not Found: File tidak ditemukan."
	.align 8
.LC26:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: %s\r\nContent-Length: %ld\r\n\r\n"
	.text
	.globl	serve_file
	.type	serve_file, @function
serve_file:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$9280, %rsp
	movl	%edi, -9268(%rbp)
	movq	%rsi, -9280(%rbp)
	movq	-9280(%rbp), %rdx
	leaq	-1072(%rbp), %rax
	movq	%rdx, %r8
	movl	$.LC22, %ecx
	movl	$.LC23, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-1072(%rbp), %rax
	movl	$.LC24, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L25
	movq	$.LC25, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-40(%rbp), %rsi
	movl	-9268(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L24
.L25:
	movq	-8(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	leaq	-1072(%rbp), %rax
	movq	%rax, %rdi
	call	get_mime_type
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rcx
	movq	-24(%rbp), %rdx
	leaq	-5168(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC26, %edx
	movl	$4096, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-5168(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-5168(%rbp), %rsi
	movl	-9268(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L27
.L28:
	movq	-32(%rbp), %rdx
	leaq	-9264(%rbp), %rsi
	movl	-9268(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
.L27:
	movq	-8(%rbp), %rdx
	leaq	-9264(%rbp), %rax
	movq	%rdx, %rcx
	movl	$4096, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movq	%rax, -32(%rbp)
	cmpq	$0, -32(%rbp)
	jne	.L28
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	serve_file, .-serve_file
	.section	.rodata
.LC27:
	.string	"application/octet-stream"
.LC28:
	.string	".html"
.LC29:
	.string	"text/html"
.LC30:
	.string	".css"
.LC31:
	.string	"text/css"
.LC32:
	.string	".png"
.LC33:
	.string	"image/png"
	.text
	.globl	get_mime_type
	.type	get_mime_type, @function
get_mime_type:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$46, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L30
	movq	-8(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jne	.L31
.L30:
	movl	$.LC27, %eax
	jmp	.L32
.L31:
	movq	-8(%rbp), %rax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L33
	movl	$.LC29, %eax
	jmp	.L32
.L33:
	movq	-8(%rbp), %rax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L34
	movl	$.LC31, %eax
	jmp	.L32
.L34:
	movq	-8(%rbp), %rax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L35
	movl	$.LC33, %eax
	jmp	.L32
.L35:
	movl	$.LC27, %eax
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	get_mime_type, .-get_mime_type
	.ident	"GCC: (GNU) 14.2.1 20240912 (Red Hat 14.2.1-3)"
	.section	.note.GNU-stack,"",@progbits
