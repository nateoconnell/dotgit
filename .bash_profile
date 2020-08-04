#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# autostart sway on tty1
[[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && exec sway
