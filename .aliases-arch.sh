#!/bin/bash
alias yay='paru'

alias list_installed_packages='~/scripts/list_installed_packages.sh'
alias list_installed_packages_by_size='~/scripts/list_installed_packages_by_size.sh'
alias list_last_installed_packages="grep '\[ALPM\] installed' /var/log/pacman.log | sort | tail -n 20"

btrfs-snapshot(){
	local suffix=$1
	local snapshots_dir="/.snapshots"
	sudo mkdir -p "$snapshots_dir"
	if [ -z "$suffix" ]; then
		sudo btrfs subvolume snapshot / "$snapshots_dir/@-$(date +%Y-%m-%d)"
	else
		sudo btrfs subvolume snapshot / "$snapshots_dir/@-$(date +%Y-%m-%d)-$suffix"
	fi

	update-grub
}

alias reflector-update='sudo reflector --country Poland,Germany --latest 10 --sort rate --save /etc/pacman.d/mirrorlist'
alias update-clean='sudo pacman -Syu && date +%s > $HOME/.last_arch_update'
#alias update='btrfs-snapshot "BeforeUpdate" && reflector-update && update-clean && update-grub'
alias update='tmux new-session -A -s update bash -ic "btrfs-snapshot \"BeforeUpdate\" && reflector-update && update-clean && update-grub; exec bash"'

alias hyprconfig="cd ~/.config/hypr && code ." #ranger" #"v ~/.config/hypr/hyprland.conf"
alias hyprcfg="hyprconfig"

