 
 
 
#use german keyboard layout within X
cat << EOF > /usr/local/etc/X11/xorg.conf.d/13-keyboard-evdev.conf

Section "InputClass"
	Identifier "KeyboardEvdev"
	MatchIsKeyboard "on"
	Option "XkbRules" "evdev"
EndSection

EOF

cat << EOF > /usr/local/etc/X11/xorg.conf.d/94-keyboard-de.conf

Section "InputClass"
	Identifier "KeyboardLayout"
	MatchIsKeyboard "on"
	Option "XkbLayout" "de"
EndSection

EOF