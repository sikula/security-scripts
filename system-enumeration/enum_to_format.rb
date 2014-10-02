require "json"

json = {
    "SYSTEM" => {
        "OS"    => {
            "type"  => "static",
            "cmd"   => %q[cat /etc/issue],
            "msg"   => "Operating System Information",
        },
        "Uname" => {
            "type"  => "static",
            "cmd"   => %q[uname -a],
            "msg"   => "System/Kernel Version Information",
        },
        "Kernel" => {
            "type"  => "static",
            "cmd"   => %q[cat /proc/version],
            "msg"   => "Kernal Information",
        },
        "Hostname"  => {
            "type"  => "static",
            "cmd"   => %q[hostname],
            "msg"   => "System Hostname",
        },
    },
    "NET_INFO" => {
        "Net"   => {
            "type"  => "static",
            "cmd"   => %q[ifconfig -a],
            "msg"   => "Available Network Interfaces",
        },
        "Route"     => {
            "type"  => "static",
            "cmd"   => %q[route],
            "msg"   => "Routing Information",
        },
        "Netstat"   => {
            "type"  => "dynamic",
            "cmd"   => %q[netstat -antup | grep -v "TIME_WAIT"],
            "msg"   => "Network Connections and Statistics",
        },
        "ARP"       => {
            "type"  => "dynamic",
            "cmd"   => %q[arp -ven],
            "msg"   => "ARP Information",
        },
        "Firewall"  => {
            "type"  => "static",
            "cmd"   => %q[firewall-cmd --list-all-zones],
            "msg"   => "Firewall Information --( Firewall-cmd )--",
        },
        "IPTables"  => {
            "type"  => "static",
            "cmd"   => %q[iptables -S],
            "msg"   => "Firewall Information --( IP Tables )--",
        },
    },
    "DRIVE_INFO" => {
        "Mount"     => {
            "type"  => "static",
            "cmd"   => %q[mount],
            "msg"   => "Currently Mounted Devices",
        },
        "FSTab"     => {
            "type"  => "static",
            "cmd"   => %q[cat /etc/fstab | tail -n +9],
            "msg"   => "Other Devices Statistics",
        },
    },
    "LOG_INFO" => {
        "Logwatch"  => {
            "type"  => "dynamic",
            "cmd"   => %q[logwatch --detail 10 --range Today --numeric --hostname --filename],
            "msg"   => "Recent Log Entries",
        },
        "LOGDIR"    => {
            "type"  => "dynamic",
            "cmd"   => %q[tail -n25 /var/log/boot.log /var/log/cron /var/log/secure /var/log/dracut.log /var/log/firewalld /var/log/messages],
            "msg"   => "Last 25 Lines From Important Log Files",
        },
        "CRON"      => {
            "type"  => "static",
            "cmd"   => %q[ls -al /etc/cron*],
            "msg"   => "Listing Known Cron Jobs",
        },
        "CRONW"     => {
            "type"  => "static",
            "cmd"   => %q[ls -alR /etc/cron* | awk "\$1 ~ /w.\$/"],
            "msg"   => "Listing Writable Cron Directories",
        },
    },
    "CONF_INFO" => {
        "OpenSSH"   => {
            "type"  => "static",
            "cmd"   => %q[sshd -T],
            "msg"   => "Testing OpenSSH Configuration",
        },
     },
    "USER_INFO" => {
        "Whoami"    => {
            "type"  => "static",
            "cmd"   => %q[whoami],
            "msg"   => "Current User Session",
        },
        "ID"        => {
            "type"  => "static",
            "cmd"   => %q[id],
            "msg"   => "Current User Session ID",
        },
        "Users"     => {
            "type"  => "static",
            "cmd"   => %q[cat /etc/passwd],
            "msg"   => "All User Accounts",
        },
        "Supusr"    => {
            "type"  => "static",
            "cmd"   => %q[grep -v -E "^#" /etc/passwd | awk -F: "$3 == 0{print $1}"],
            "msg"   => "All Super Users Found",
        },
        "History"   => {
            "type"  => "static",
            "cmd"   => %q[ls -al $HOME/.*_history],
            "msg"   => "Recent Command Line History",
        },
        "Env"       => {
            "type"  => "static",
            "cmd"   => %q[env | grep -v "LS_COLORS"],
            "msg"   => "Environment Information",
        },
        "Sudoers"   => {
            "type"  => "static",
            "cmd"   => %q[cat /etc/sudoers | grep -v "#" | sed "/^$/d"],
            "msg"   => "All Suoders On The System",
        },
        "Logged"    => {
            "type"  => "dynamic",
            "cmd"   => %q[w],
            "msg"   => "All Users Currently Logged In",
        },
    },
    "PERMS" => {
        "DIRSROOT"  => {
            "type"  => "static",
            "cmd"   => %q[find / \( -wholename \"$HOME*\" -prune \) -o \( -type d -perm -0002 \) -exec ls -ld "{}" ";" 2>/dev/null | grep root],
            "msg"   => "Searching For World Writeable Directories For User => Root",
        },
        "DIRS"      => {
            "type"  => "static",
            "cmd"   => %q[find / \( -wholename \"$HOME*\" -prune \) -o \( -type d -perm -0002 \) -exec ls -ld "{}" ";" 2>/dev/null | grep -v root],
            "msg"   => "Searching For World Writeable Files For Users Other Than => Root",
        },
        "FILES"     => {
            "type"  => "static",
            "cmd"   => %q[
                find / -xdev \( -path \"$HOME*\" -prune -o -path "proc" -prune -path "sys" -prune \) -o \( -type f -perm -0002 \) -exec ls -l "{}" ";" 2>/dev/null],
            "msg"   => "Searching For World Writeable Files",
        },
        "STICKY"    => {
            "type"  => "static",
            "cmd"   => %q[find $HOME* | xargs lsattr 2>/dev/null | grep "^....i"],
            "msg"   => "Searching For Files With Immutable Bits Set",
        },
        "SUID"      => {
            "type"  => "static",
            "cmd"   => %q[find / \( -perm -2000 -o -perm -4000 \) -exec ls -ld {} \; 2>/dev/null],
            "msg"   => "Searching for SUID/SGID Files and Directories",
        },
        "5DAYS"     => {
            "type"  => "static",
            "cmd"   => %q[find / -xdev -ctime -5 -not \( -path "proc" -o -path "sys" \)],
            "msg"   => "Listing Files That Have Been Modified In The Last 5 Days",
        },
        "ROOTHOME"  => {
            "type"  => "static",
            "cmd"   => %q[ls -ahlR /root/ 2>/dev/null],
            "msg"   => "Testing If Home Directory Is Visible for User => Root",
        },
    },
    "PASS_FILES" => {
        "LOGPWD"    => {
            "type"  => "static",
            "cmd"   => %q[find /var/log -name "*.log" 2>/dev/null | xargs -l10 egrep "pwd|password" 2>/dev/null],
            "msg"   => "Searching For Keywords [pwd|passwd] In Log Files",
        },
        "CNFPWD"    => {
            "type"  => "static",
            "cmd"   => %q[find /etc -name "*.c*" 2>/dev/null | xargs -l10 egrep "pwd|password" 2>/dev/null],
            "msg"   => "Searching For Keywords [pwd|passwd] In Configuration Files",
        },
        "PWDFILE"   => {
            "type"  => "static",
            "cmd"   => %q[find ~ -name "*pass*" 2>/dev/null],
            "msg"   => "Searching For Files With [pass] In Their Name",
        },
        "SHDW"      => {
            "type"  => "static",
            "cmd"   => %q[cat /etc/shadow 2>/dev/null],
            "msg"   => "Shadow Files",
        },
    },
    "PROCESS_INFO" => {
        "Procs"     => {
            "type"  => "dynamic",
            "cmd"   => %q[ps axfo cgroup,rgid,class,stat,args],
            "msg"   => "Process Information",
        },
    },
    "PACKAGES" => {
        "RPM"       => {
            "type"  => "dynamic",
            "cmd"   => %q[rpm -qa --qf "[%-10{=FILEMD5S} %-30{NAME}] %{INSTALLTIME:date}\n" | sort -u -k2],
            "msg"   => "Listing Installed Packages",
        }
    },
    "TOOLS_INFO" => {
        "Tools"     => {
            "type"  => "static",
            "cmd"   => %q[which awk sed perl python ruby java gcc cc vi vim nmap find ncat nc wget tftp ftp 2>/dev/null],
            "msg"   => "Available Development Tools",
        },
    },
    "HARDWARE" => {
        "LVM"       => {
            "type"  => "static",
            "cmd"   => %q[dmsetup ls --tree -o active,open,rw,uuid,ascii,notrunc],
            "msg"   => "Logival Volume Manager Information",
        },
        "Hardware"  => {
            "type"  => "static",
            "cmd"   => %q[lshw],
            "msg"   => "List Hardware",
        },
        "Blocks"    => {
            "type"  => "static",
            "cmd"   => %q[blkid],
            "msg"   => "Block Device Attributes",
        },
        "PCI"       => {
            "type"  => "static",
            "cmd"   => %q[lspci],
            "msg"   => "List of PCI Devices",
        },
        "USB"       => {
            "type"  => "static",
            "cmd"   => %q[lsusb],
            "msg"   => "List USB Devices",
        },
        "USB-DEV"   => {
            "type"  => "static",
            "cmd"   => %q[usb-devices],
            "msg"   => "USB Device Information",
        },
        "DMI Decode"=> {
            "type"  => "static",
            "cmd"   => %q[dmidecode],
            "msg"   => "Printing DMI Table in Readable Format",
        },
        "Partition" => {
            "type"  => "static",
            "cmd"   => %q[fdisk -l ; fdisk -u -l],
            "msg"   => "Listing Partition Table",
        },
        "Drives"    => {
            "type"  => "static",
            "cmd"   => %q[hdparm -I /dev/sd??],
            "msg"   => "Listing SATA/IDE Device Parameters",
        },
        "BLK Report"=> {
            "type"  => "static",
            "cmd"   => %q[blockdev --report /dev/sd?],
            "msg"   => "Printing Block Device Report",
        },
        "Devices"   => {
            "type"  => "static",
            "cmd"   => %q[head -10 /sys/devices/virtual/dmi/id/*],
            "msg"   => "Printing More DMI Device Information",
        },
        "Listing"   => {
            "type"  => "static",
            "cmd"   => %q[ls -al /dev/disk/*],
            "msg"   => "Listing files in => /dev/disk/",
        },
        "By ID"     => {
            "type"  => "static",
            "cmd"   => %q[find /dev/disk -ls],
            "msg"   => "Listing Disks by ID",
        },
        "LVM Dump"  => {
            "type"  => "static",
            "cmd"   => %q[lvmdump],
            "msg"   => "Dumping LVM Information: DUMPED INTO TARBALL in $HOME",
        },
    },
}

File.open("command_list.json", "w") {|file|
    file.write JSON.dump(json)
}
