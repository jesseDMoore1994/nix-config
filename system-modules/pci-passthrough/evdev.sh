METHOD="by-id"
NEW_DOMAIN="<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>"

echo $NEW_DOMAIN > evdev.txt
echo "" >> evdev.txt

echo " <qemu:commandline>" >> evdev.txt

for entry in `ls -l /dev/input/$METHOD/ | grep "event*"`
do
	KBD_M=`echo "$entry" | rev | cut -c -4 | rev`
	if [ "$KBD_M" = "ouse" ]
		then
			echo "	<qemu:arg value='-object'/>" >> evdev.txt
    			echo "	<qemu:arg value='input-linux,id=mouse"$MOUSE_COUNT",evdev=/dev/input/$METHOD/$entry'/>" >> evdev.txt
			((++MOUSE_COUNT))
	elif  [ "$KBD_M" = "-kbd" ]
	then
			echo "	<qemu:arg value='-object'/>" >> evdev.txt
    			echo "	<qemu:arg value='input-linux,id=kbd"$KBD_COUNT",evdev=/dev/input/$METHOD/$entry,grab_all=on,repeat=on'/>" >> evdev.txt
			((++KBD_COUNT))
	fi
done

echo "  </qemu:commandline>" >> evdev.txt
