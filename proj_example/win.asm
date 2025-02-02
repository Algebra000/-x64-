;这是x64汇编源文件，使用VC自带的ml64.exe进行编译

includelib user32.lib
includelib ucrt.lib
includelib Gdi32.lib

extern exit : proc
extern RegisterClassExW: proc
extern DefWindowProcW: proc
extern CreateWindowExW: proc
extern ShowWindow: proc
extern TranslateMessage: proc
extern DispatchMessageW: proc
extern GetMessageW: proc
extern GetStockObject: proc

.const ;常量区
    clsName dw 31383, 21475, 31243, 24207, 0 ;"窗口程序"

.data ;变量区
    hwnd dq 0
    wndcls dd 80 ;cbsize(4字节)和style(4字节)
        dd 0
        dq wndproc ;DefWindowProcW ; +8
        dq 0 ;cbClsExtra、cbWndExtra(两个一共8字节，取0即可) +16
        dq 0 ;hInstance,进程句柄 +24
        dq 0 ;hIcon +32
        dq 0 ;hCursor +40
        dq 0 ;hbrBackground +48
        dq 0 ;lpszMenuName
        ;db 48 dup(0) 
        dq clsName
        dq 0 ;hIconSm

.code 

wndproc proc
    SUB rsp, 38h ;这里的栈指针应该是8的奇数倍才可以（?）
    ;原因：1.栈要16字节对齐
    ;2.因为call指令会将当前执行位置入栈，这个位置占8字节
    CALL DefWindowProcW ;还有，这里的栈大小最小28h,这是因为调用的函数要用到rsp到rsp + 20h用于传参
    ADD rsp, 38h
    RET
wndproc endp

main proc
    sub rsp, 98h ;rsp 就是常说的栈指针，它永远指向一个进程的栈顶。
    ;这句话设置了栈大小0x98

    xor ecx, ecx
    call GetStockObject
    mov qword ptr [wndcls + 48], rax

    lea rcx, wndcls
    call RegisterClassExW

    mov dword ptr [rsp + 20h], 200  ;从20开始
    mov dword ptr [rsp + 28h], 100
    mov dword ptr [rsp + 38h], 1E0h ;窗口高
    mov dword ptr [rsp + 30h], 2D0h ;窗口宽
    mov r9d, 0CF0000h ;窗口样式
    lea r8, clsName ;窗口名
    mov rdx, r8 ;窗口类名
    mov rcx, 0
    call CreateWindowExW ;这里：ecx是扩展窗口样式。
    ;与形参表的对应顺序：ecx(rcx),rdx,r8,r9d,+20h,+28h,+30h,+38h,+40h,+48h,+50h,+58h

    mov qword ptr [hwnd], rax ;返回的句柄

    mov rcx, rax
    mov rdx, 5
    call ShowWindow

lop:
    xor r9d, r9d ;异或运算，用来清空寄存器
    xor r8d, r8d
    mov rdx, [hwnd]
    lea rcx, [rsp + 60h]
    call GetMessageW

    cmp eax, 0
    jle return

    lea rcx, [rsp + 60h]
    call TranslateMessage

    lea rcx, [rsp + 60h]
    call DispatchMessageW
    jmp lop

return:
    mov ecx, dword ptr [rsp + 70h]
    call exit

main endp

end










