SKIPUNZIP=0
SKIPMOUNT=false
Manufacturer=$(getprop ro.product.vendor.manufacturer)
Codename=$(getprop ro.product.device)
Model=$(getprop ro.product.vendor.model)
Build=$(getprop ro.build.version.incremental)
Android=$(getprop ro.build.version.release)
CPU_ABI=$(getprop ro.product.cpu.abi)
MIUI=$(getprop ro.miui.ui.version.code)
MODNAME=`grep_prop name $MODPATH/module.prop`
MODVER=`grep_prop version $MODPATH/module.prop`
MINMIUI=13
MINSDK=31
MAXSDK=0

# Set what you want to display when installing your module
print_modname() {
	ui_print " "
	ui_print "==================================================="
	ui_print "  $MODNAME $MODVER"
	ui_print " "
	sleep 0.05
	ui_print "  如果你有疑问,你可以去:",
	sleep 0.05
	ui_print "  Telegram: @sti_Aniruf"
	ui_print "  Coolapk:  @sti"
	sleep 0.05
	ui_print "==================================================="
	sleep 0.5
}
      

# Install module files
install_files() {
	sleep 0.5
	if [ $API -ge 33 ]; then
		mv -f $MODPATH/system/media $MODPATH/system/product
	fi
}

# output some system spec.
print_specs() {
	ui_print "==================================================="
	sleep 0.05
	ui_print "- 哪台机子？                $Model"
	sleep 0.05
    ui_print "- 又是哪家手机刷小米模块？  $Manufacturer"
    sleep 0.05
	ui_print "- SDK 版本:                API level $API"
	sleep 0.05
	ui_print "- 你是Android几？          Android $Android"
	sleep 0.05
	ui_print "- HyperOS 版本:           HyperOS $MIUI"
	sleep 0.05
	ui_print "- 构建版本:                 $Build"
	ui_print "==================================================="
	sleep 0.3
}

# Check for min/max api version
check_sdk() {
	local error=false
	if [ $MINSDK -gt 0 -a $MINSDK -gt $API ]
	    then
		ui_print " "
		ui_print "  Your SDK version $API is less than the required ";
		ui_print "  SDK version. ";
		error=true
    fi

	if [ $MAXSDK -gt 0 -a $MAXSDK -lt $API ]
	    then
		ui_print " "
		ui_print "  Your SDK version $API is higher than the required ";
		ui_print "  SDK version. ";
		error=true
    fi

	if $error; then
		abort
	fi
}

# check minimum MIUI version 
check_miui() {
	local error=false
	if [ $MINMIUI -gt 0 -a $MIUI -lt $MINMIUI ]
	    then
		ui_print " "
		ui_print "  Your HyperOS version $MIUI is less than the required ";
		ui_print "  MIUI version. ";
		error=true
    fi

	if $error; then
		abort
	fi
	
}

# cleanup extra files after installation
cleanup() {
	rm -rf $MODPATH/addon 2>/dev/null
	rm -rf $MODPATH/common 2>/dev/null
	rm -f $MODPATH/install.sh 2>/dev/null
	rm -f $MODPATH/LICENSE 2>/dev/null

    OVERLAYS="`ls $MODPATH/system/product/overlay`"
    
    for OVERLAY in $OVERLAYS; do
        rm -f `find /data/system/package_cache -type f -name *$OVERLAY*`
        rm -f `find /data/dalvik-cache -type f -name *$OVERLAY*.apk`
    done

}

print_terms() {
	ui_print "==================================================="
	sleep 0.05
	ui_print "本项目基于HyperOS Monet Project"
	sleep 0.05
	ui_print "所作的MIUI Monet Icons 1.0.0版."
	sleep 0.05
	ui_print "去除了其中的所有图标并更改图标来源为Lawnicons."
	sleep 0.05
	ui_print "同时图标制作方案来自酷安@此用户名涉嫌违禁."
	sleep 0.05
	ui_print "原来这里的协议已经不重要了,但你仍需同意这份协议."
	sleep 0.05
	ui_print " "
	ui_print "    1.我同意了"
	ui_print "    2.我不同意"
	ui_print " "
	sleep 0.05
	ui_print "  按下音量 (+) 键来改变所选选项"
	ui_print "  按下音量 (-) 键来确认所选选项"
	ui_print "==================================================="
	sleep 0.5
	ui_print " "
	A=1
	while true; do
		case $A in
			1 ) TEXT="同意";;
			2 ) TEXT="拒绝";;
		esac
		ui_print "    $A. $TEXT"
		if $VKSEL 60; then
			A=$((A + 1))
		else
			break
		fi
		if [ $A -gt 2 ]; then
			A=1
		fi
	done
	if [ $A -gt 1 ]; then
		ui_print " "
		ui_print "你必须同意这个协议"
		ui_print "来安装使用这个模块"
		abort
	fi
}

print_credits() {
	ui_print "==================================================="
	ui_print "  Thanks for your support!"
	ui_print "  We think you’re pretty awesome 🤩"
	ui_print " "
	ui_print " "
	ui_print "  Made with ❤️sti"
	ui_print "==================================================="
	sleep 0.3
}

# main installer
run_install() {
    . $MODPATH/addon/Volume-Key-Selector/install.sh
	ui_print " "
	print_modname
	sleep 1
    ui_print " "
	ui_print "- 😋"
	ui_print " "
	sleep 1
	print_specs
	sleep 1
	check_sdk
	check_miui
	ui_print " "
	ui_print "- 让我们来检查一些东西."
	ui_print " "
	print_terms
	ui_print " "
	ui_print "- 安装图标文件中……"
	sleep 0.5
	install_files
	sleep 1
    ui_print " "
	ui_print "- 安装完成😋"
    sleep 1
	ui_print " "
	ui_print "- 正在清理残余文件……"
	ui_print " "
	cleanup
	sleep 2
	print_credits
#	ui_print " "
}

# start the installation
run_install