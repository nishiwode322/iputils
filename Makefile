#
# Configuration
#

# CC
CC=gcc    #设置编译器
# Path to parent kernel include files directory
LIBC_INCLUDE=/usr/include      #保存母核包含的文件的目录
# Libraries
ADDLIB=                       #添加自己增加的库，这里为缺省状态
# Linker flags			#链接的一些选项
LDFLAG_STATIC=-Wl,-Bstatic     
LDFLAG_DYNAMIC=-Wl,-Bdynamic
#####################################################################
#加载库
#####################################################################
LDFLAG_CAP=-lcap
LDFLAG_GNUTLS=-lgnutls-openssl
LDFLAG_CRYPTO=-lcrypto
LDFLAG_IDN=-lidn
LDFLAG_RESOLV=-lresolv
LDFLAG_SYSFS=-lsysfs          #文件系统相关的
#Wl选项告诉编译器将后面的参数传递给链接器
#-Wl,-Bstatic告诉链接器使用-Bstatic选项，该选项是告诉链接器，对接下来的-l选项使用静态链接
#-Wl,-Bdynamic就是告诉链接器对接下来的-l选项使用动态链接
#
# Options
#

# Capability support (with libcap) [yes|static|no]
USE_CAP=yes					#设置开关的打开与关闭
# sysfs support (with libsysfs - deprecated) [no|yes|static]
USE_SYSFS=no
# IDN support (experimental) [no|yes|static]
USE_IDN=no

# Do not use getifaddrs [no|yes|static]
WITHOUT_IFADDRS=no
# arping default device (e.g. eth0) []  #设置缺省的设备
ARPING_DEFAULT_DEVICE=

# GNU TLS library for ping6 [yes|no|static]  #设置ping6 的gnu的库的状态
USE_GNUTLS=yes
# Crypto library for ping6 [shared|static]  #库的属性为共享
USE_CRYPTO=shared
# Resolv library for ping6 [yes|static]  #设置ping6的resolve库的状态
USE_RESOLV=yes
# ping6 source routing (deprecated by RFC5095) [no|yes|RFC3542]
ENABLE_PING6_RTHDR=no

# rdisc server (-r option) support [no|yes]
ENABLE_RDISC_SERVER=no           #不支持rdisc server

# -------------------------------------
# What a pity, all new gccs are buggy and -Werror does not work. Sigh.
# CCOPT=-fno-strict-aliasing -Wstrict-prototypes -Wall -Werror -g
##设置gcc编译的参数 ，比如-g就是为了方便gdb等调试工具调试
CCOPT=-fno-strict-aliasing -Wstrict-prototypes -Wall -g
CCOPTOPT=-O3                              #设置编译器的优化级别为3级
GLIBCFIX=-D_GNU_SOURCE                    #说明代码是符合GNU的代码规范
DEFINES=				  	
LDLIB=

FUNC_LIB = $(if $(filter static,$(1)),$(LDFLAG_STATIC) $(2) $(LDFLAG_DYNAMIC),$(2))
#如果过滤掉参数1中除了静态函数外的有其他函数，就将$(1)),$(LDFLAG_STATIC) $(2)这几个变量所代表的赋值给FUNC_LIB这个变量
#否则，只将参数2所代表的内容赋给FUNC_LIB

# USE_GNUTLS: DEF_GNUTLS, LIB_GNUTLS
# USE_CRYPTO: LIB_CRYPTO
ifneq ($(USE_GNUTLS),no)
	LIB_CRYPTO = $(call FUNC_LIB,$(USE_GNUTLS),$(LDFLAG_GNUTLS))
	DEF_CRYPTO = -DUSE_GNUTLS
else
	LIB_CRYPTO = $(call FUNC_LIB,$(USE_CRYPTO),$(LDFLAG_CRYPTO))
endif
#判断如果USE_GNUTLS变量的内容不是"no",则以变量USE_GNUTLS和LDFLAG_GNUTLS的内容为参数调用FUNC_LIB变量
#并将结果赋给LIB_CRYPTO变量。

LIB_RESOLV = $(call FUNC_LIB,$(USE_RESOLV),$(LDFLAG_RESOLV))
#以变量USE_RESOLV)和LDFLAG_RESOLV的内容为参数调用FUNC_LIB变量,并将结果存放载LIB_RESOLV中。
# USE_CAP:  DEF_CAP, LIB_CAP
ifneq ($(USE_CAP),no)
	DEF_CAP = -DCAPABILITIES
	LIB_CAP = $(call FUNC_LIB,$(USE_CAP),$(LDFLAG_CAP))
endif
#判断如果USE_CAP变量的内容不是"no",则以变量USE_CAP和LDFLAG_CAP的内容为参数调用FUNC_LIB变量,
#并将结果赋给LIB_CAP变量。

# USE_SYSFS: DEF_SYSFS, LIB_SYSFS
ifneq ($(USE_SYSFS),no)
	DEF_SYSFS = -DUSE_SYSFS
	LIB_SYSFS = $(call FUNC_LIB,$(USE_SYSFS),$(LDFLAG_SYSFS))
endif
#判断如果USE_SYSFS变量的内容不是"no",则以变量USE_SYSFS和LDFLAG_SYSFS的内容为参数调用FUNC_LIB变量,
#并将结果赋给LIB_SYSFS变量。


# USE_IDN: DEF_IDN, LIB_IDN
ifneq ($(USE_IDN),no)
	DEF_IDN = -DUSE_IDN
	LIB_IDN = $(call FUNC_LIB,$(USE_IDN),$(LDFLAG_IDN))
endif
#判断如果USE_IDN)变量的内容不是"no",则以变量USE_IDN和LDFLAG_IDN的内容为参数调用FUNC_LIB变量,
#并将结果赋给LIB_IDN变量。

# WITHOUT_IFADDRS: DEF_WITHOUT_IFADDRS
ifneq ($(WITHOUT_IFADDRS),no)
	DEF_WITHOUT_IFADDRS = -DWITHOUT_IFADDRS
endif
#判断如果WITHOUT_IFADDRS变量的内容不是"no",则将DWITHOUT_IFADDRS赋值给DEF_WITHOUT_IFADDRS


# ENABLE_RDISC_SERVER: DEF_ENABLE_RDISC_SERVER
ifneq ($(ENABLE_RDISC_SERVER),no)
	DEF_ENABLE_RDISC_SERVER = -DRDISC_SERVER
endif
#判断如果ENABLE_RDISC_SERVER变量的内容不是"no",则将DRDISC_SERVER赋值给DEF_ENABLE_RDISC_SERVER

# ENABLE_PING6_RTHDR: DEF_ENABLE_PING6_RTHDR
ifneq ($(ENABLE_PING6_RTHDR),no)
	DEF_ENABLE_PING6_RTHDR = -DPING6_ENABLE_RTHDR
#判断如果ENABLE_PING6_RTHDR变量的内容不是"no",则将DPING6_ENABLE_RTHDR赋值给DEF_ENABLE_PING6_RTHDR
ifeq ($(ENABLE_PING6_RTHDR),RFC3542)
	DEF_ENABLE_PING6_RTHDR += -DPINR6_ENABLE_RTHDR_RFC3542
# 判断如果ENABLE_PING6_RTHDR变量的内容不是RFC3542,则将DPINR6_ENABLE_RTHDR_RFC3542赋值给	DEF_ENABLE_PING6_RTHDR
endif

# -------------------------------------

IPV4_TARGETS=tracepath ping clockdiff rdisc arping tftpd rarpd  
#将等号右边的变量都赋值给IPV4_TARGETS
IPV6_TARGETS=tracepath6 traceroute6 ping6
#将等号右边的变量都赋值给IPV6_TARGETS
TARGETS=$(IPV4_TARGETS) $(IPV6_TARGETS)
# 将IPV4_TARGETS和IPV6_TARGETS变量的内容都赋值给TARGETS
#以下两行注解差不多，故省略了
CFLAGS=$(CCOPTOPT) $(CCOPT) $(GLIBCFIX) $(DEFINES)
LDLIBS=$(LDLIB) $(ADDLIB) 

UNAME_N:=$(shell uname -n) 
#获取主机名
LASTTAG:=$(shell git describe HEAD | sed -e 's/-.*//')
TODAY=$(shell date +%Y/%m/%d)			#获取年月日的信息保存在TODAY变量中
DATE=$(shell date --date $(TODAY) +%Y%m%d)     #获取系统时间参数，保存在DATE变量里
TAG:=$(shell date --date=$(TODAY) +s%Y%m%d)   
#以字符串的形式输出日期，加了冒号是为了防止递归性的错误


# -------------------------------------
.PHONY: all ninfod clean distclean man html check-kernel modules snapshot     
#声明伪目标

all: $(TARGETS)                        
#TARGETS所有的目标

%.s: %.c
	$(COMPILE.c) $< $(DEF_$(patsubst %.o,%,$@)) -S -o $@
%.o: %.c
	$(COMPILE.c) $< $(DEF_$(patsubst %.o,%,$@)) -o $@
#将.c文件编译成.o文件
$(TARGETS): %: %.o
	$(LINK.o) $^ $(LIB_$@) $(LDLIBS) -o $@   #将各个.o文件链接生成可执行文件
# COMPILE.c=$(CC) $(CFLAGS) $(CPPFLAGS) -c
# $< 依赖目标中的第一个目标名字
# $@ 表示目标
# $^ 所有的依赖目标的集合
# 在$(patsubst %.o,%,$@ )中，patsubst把目标中的变量符合后缀是.o的全部删除, DEF_ping
# LINK.o把.o文件链接在一起的命令行,缺省值是$(CC) $(LDFLAGS) $(TARGET_ARCH)


# -------------------------------------
# arping
#设置arping相关变量的内容
DEF_arping = $(DEF_SYSFS) $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS)
LIB_arping = $(LIB_SYSFS) $(LIB_CAP) $(LIB_IDN)

ifneq ($(ARPING_DEFAULT_DEVICE),)
DEF_arping += -DDEFAULT_DEVICE=\"$(ARPING_DEFAULT_DEVICE)\"
endif

# clockdiff
#设置clockdiff相关变量的内容
DEF_clockdiff = $(DEF_CAP)
LIB_clockdiff = $(LIB_CAP)

# ping / ping6
#设置ping/ping6 相关变量的内容
DEF_ping_common = $(DEF_CAP) $(DEF_IDN)
DEF_ping  = $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS)
LIB_ping  = $(LIB_CAP) $(LIB_IDN)
DEF_ping6 = $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS) $(DEF_ENABLE_PING6_RTHDR) $(DEF_CRYPTO)
LIB_ping6 = $(LIB_CAP) $(LIB_IDN) $(LIB_RESOLV) $(LIB_CRYPTO)

# 一些目标文件产生及其依赖文件
ping: ping_common.o
ping6: ping_common.o
ping.o ping_common.o: ping_common.h
ping6.o: ping_common.h in6_flowlabel.h

# rarpd
DEF_rarpd =
LIB_rarpd =

# rdisc
#设置rdisc的内容
DEF_rdisc = $(DEF_ENABLE_RDISC_SERVER)
LIB_rdisc =

# tracepath
#设置tracepath的内容
DEF_tracepath = $(DEF_IDN)
LIB_tracepath = $(LIB_IDN)

# tracepath6
#设置tracepath6的内容
DEF_tracepath6 = $(DEF_IDN)
LIB_tracepath6 =

# traceroute6
#设置traceroute6的内容
DEF_traceroute6 = $(DEF_CAP) $(DEF_IDN)
LIB_traceroute6 = $(LIB_CAP) $(LIB_IDN)

# tftpd
DEF_tftpd =
DEF_tftpsubs =
LIB_tftpd =
#设置目标的一些依赖文件
tftpd: tftpsubs.o
tftpd.o tftpsubs.o: tftp.h
#目标产生依赖的文件
# -------------------------------------
# ninfod
ninfod:
	@set -e; \
	#（见下文）
	#如果ninfod目录下没有Makefiel文件，就创建一个makefile
		if [ ! -f ninfod/Makefile ]; then \
			cd ninfod; \
			./configure; \
			cd ..; \
		fi; \
		$(MAKE) -C ninfod
		#否则，直接指定ninfod为读取Makefile的一个路径。

# -------------------------------------
# modules / check-kernel are only for ancient kernels; obsolete
#核对内核产生的模块

check-kernel:
ifeq ($(KERNEL_INCLUDE),)
	@echo "Please, set correct KERNEL_INCLUDE"; false
#判断内核文件的路径不正确时，输出警告信息
else
	@set -e; \
	if [ ! -r $(KERNEL_INCLUDE)/linux/autoconf.h ]; then \
		echo "Please, set correct KERNEL_INCLUDE"; false; fi
endif

modules: check-kernel          
	$(MAKE) KERNEL_INCLUDE=$(KERNEL_INCLUDE) -C Modules  #查找makefile，编译内核模块

# -------------------------------------
man:
	$(MAKE) -C doc man                #产生man的帮助文档

html:
	$(MAKE) -C doc html		  #产生html形式的帮助文档

clean:
	@rm -f *.o $(TARGETS)  		#强制删除.o文件以及产生的目标文件
	@$(MAKE) -C Modules clean       #删除产生的内核编译的模块
	@$(MAKE) -C doc clean		#清除产生的doc文档
	@set -e; \
		if [ -f ninfod/Makefile ]; then \
			$(MAKE) -C ninfod clean; \
		fi

distclean: clean
	@set -e; \
	#set -e 表示如果以下返回非0时退出（以上重复时就不注解了）
		if [ -f ninfod/Makefile ]; then \
			$(MAKE) -C ninfod distclean; \
		fi

# -------------------------------------
snapshot:
	#@符号表示以下的这些命令将不会出现在终端的环境中
	@if [ x"$(UNAME_N)" != x"pleiades" ]; then echo "Not authorized to advance snapshot"; exit 1; fi
	# #如果UNAME_N和pleiades不等，显示错误信息，并退出。
	@echo "[$(TAG)]" > RELNOTES.NEW
	#将TAG变量的内容放到到RELNOTES.NEW文档中
	@echo >>RELNOTES.NEW
	#输入一个空格到RELNOTES.NEW中
	@git log --no-merges $(LASTTAG).. | git shortlog >> RELNOTES.NEW
	#将git log和git shortlog的输出的内容放到到RELOTES.NEW文档中。
	@echo >> RELNOTES.NEW
	@cat RELNOTES >> RELNOTES.NEW
	#RELNOTES的内容追加到RELNOTES.NEW的末尾
	@mv RELNOTES.NEW RELNOTES
	@sed -e "s/^%define ssdate .*/%define ssdate $(DATE)/" iputils.spec > iputils.spec.tmp
	@mv iputils.spec.tmp iputils.spec
	#将文件iputils.spec.tmp修改为iputils.spec
	@echo "static char SNAPSHOT[] = \"$(TAG)\";" > SNAPSHOT.h
	#将TAG变量中的内容以"static char SNAPSHOT[] = \"$(TAG)\"的形式放置到SNAPSHOT.h文件中
	#将
	@$(MAKE) -C doc snapshot
	#生成snapshot形式的doc帮助文档
	@$(MAKE) man
	@git commit -a -m "iputils-$(TAG)"
	#上传时添加代码的一些说明
	@git tag -s -m "iputils-$(TAG)" $(TAG)
	@git archive --format=tar --prefix=iputils-$(TAG)/ $(TAG) | bzip2 -9 > ../iputils-$(TAG).tar.bz2
	#将自己的工程打包成).tar.bz2的格式以供他人下载

