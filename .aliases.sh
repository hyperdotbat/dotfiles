#!/bin/bash

alias v='nvim' #'vim'
alias vi='vim'
alias nv='nvim'
alias sv='sudo -E nvim' #'sudo -E vim'
alias svim='sudo -E vim'
alias inv='nvim "$(fzf -m --preview="bat --color=always {}")"'
alias sinv='sudo -E nvim "$(fzf -m --preview="bat --color=always {}")"'
alias vsc='vscodium'

alias yz='yazi'
alias f='yazi'

alias tm='tmux'
alias tmuxt='tmux new-session -A -t'
alias tmuxssh='tmuxt ssh'

alias os-age='~/scripts/check_os_age.sh'

alias mnt='sudo mount -o uid=hyper,gid=hyper'

alias ls='eza --group-directories-first --icons'
alias l="ls"
alias ll="ls -lA"
alias lsa='ls -a'

cdl() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

alias z="cdl"
alias ..="z .."
alias ...="z ../.."
alias ....="z ../../.."
alias z..="z .."
alias cd..="cd .."

alias ssh_hoshizora="~/scripts/ssh_hoshizora.sh"
alias ssh_komorebi="~/scripts/ssh_komorebi.sh"
alias ssh_homelab="~/scripts/ssh_homelab.sh"
alias ssh_cenovo="~/scripts/ssh_cenovo.sh"

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias anicli='ani-cli'
alias ytx='yt-x'

alias fetch='fastfetch' #'neofetch'
alias ff='fastfetch'

alias dots='z ~/dotfiles'

alias freeze-state='echo freeze | sudo tee /sys/power/state'

alias vidcompress='~/scripts/vidcompress.sh'
alias mp4compress='vidcompress'
mp4-replace-compress() {
    vidcompress "$1" "$2" 1
}
alias clypt-compress='mp4-replace-compress'

## ALL OF THIS SHOULD BE OUTSOURCED TO OTHER SCRIPTS
ytmp4() {
    local url="$1"
    local output_dir="${2:-$HOME/YT-DLP/$(date +%Y-%m-%d)}"
    mkdir -p "$output_dir"

    yt-dlp -f "bestvideo[ext=mp4]+bestaudio" \
	    --embed-metadata \
	    --embed-thumbnail \
	    -o "$output_dir/%(title)s.%(ext)s" \
	    "$url"
    xdg-open "$output_dir"
}
#ytmp4() {
#    local url="$1"
#    local output_dir="${2:-$HOME/YT-DLP/$(date +%Y-%m-%d)}"
#    mkdir -p "$output_dir"
#
#    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
#	    --embed-metadata \
#	    --embed-thumbnail --convert-thumbnails jpg \
#	    -o "$output_dir/%(title)s.%(ext)s" \
#	    "$url"
#    xdg-open "$output_dir"
#}
ytmp3() {
    local url="$1"
    local output_dir="${2:-$HOME/YT-DLP/$(date +%Y-%m-%d)}"
    mkdir -p "$output_dir"

    #yt-dlp -x --audio-format mp3 \
    yt-dlp -f "ba" -x --audio-format mp3 --audio-quality 0 \
	    --embed-metadata \
	    --embed-thumbnail \
	    --convert-thumbnails jpg \
	    -o "$output_dir/%(title)s.%(ext)s" \
	    "$url"
    
    # Fix metadata for all MP3s in the output directory
#    for file in "$output_dir"/*.mp3; do
#        if [[ -f "$file" ]]; then
#            ffmpeg -i "$file" -q:a 0 -map_metadata 0 -id3v2_version 3 "${file%.mp3}.tmp.mp3" && mv "${file%.mp3}.tmp.mp3" "$file"
#        fi
#    done

    xdg-open "$output_dir"
}
ytmp3clean() {
    local url="$1"
    local output_dir="${2:-$HOME/YT-DLP/$(date +%Y-%m-%d)}"
    mkdir -p "$output_dir"

    yt-dlp -x --audio-format mp3 \
	    --embed-metadata \
	    -o "$output_dir/%(title)s.%(ext)s" \
	    "$url"
    xdg-open "$output_dir"
}

vidcut-default() {
    if [ $# -lt 3 ]; then
        echo "Usage: vidcut-default <input_file> <start_time> <end_time> [output_file]"
        return 1
    fi

    input_file="$1"
    start_time="$2"
    end_time="$3"
    output_file="${4:-${input_file%.*}_cut.${input_file##*.}}"

    ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"
}
vidcut() {
    if [ $# -lt 3 ]; then
        echo "Usage: vidcut <input_file> <start_time> <end_time> [output_file]"
        return 1
    fi

    input_file="$1"
    start_time="$2"
    end_time="$3"
    output_file="${4:-${input_file%.*}_cut.${input_file##*.}}"

    ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" \
	-map 0 \
	-c copy \
	"$output_file"
}
vidcut-re() {
    if [ $# -lt 3 ]; then
        echo "Usage: vidcut <input_file> <start_time> <end_time> [output_file]"
        return 1
    fi

    input_file="$1"
    start_time="$2"
    end_time="$3"
    output_file="${4:-${input_file%.*}_cut.${input_file##*.}}"

    ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" \
	-c:v libx264 \
	-r 30 \
	-c:a aac \
	"$output_file"
}

mp4togif() {
    local input="$1"
    local output="${input%.mp4}.gif"
 
    ffmpeg -i "$input" -vf \
	   "fps=15,scale=500:-1:flags=lanczos" \
	   "$output"
}
mp4tomp3() {
    local input="$1"
    local output="${input%.mp4}.mp3"
    ffmpeg -i "$input" -vn -acodec copy "$output" 
}
mp4-thumbnail-extract() {
    local input="$1"
    local output="${input%.mp4}.jpg"
    ffmpeg -i "$input" -map 0:v:1 -c:v mjpeg -q:v 2 -frames:v 1 "$output"
}
mp4tomp3cover() {
    local input="$1"
    local output="${input%.mp4}.mp3"
    local cover_tmp="/tmp/cover_$$.jpg"

    ffmpeg -i "$input" -map 0:v:1 -c:v mjpeg -q:v 2 -frames:v 1 "$cover_tmp"

    if [ -f "$cover_tmp" ]; then
        # Extract MP3 and embed the thumbnail as cover art
        ffmpeg -i "$input" -i "$cover_tmp" -map a -map 1 -c:a libmp3lame -q:a 0 \
            -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" \
            "$output"
        echo "MP3 created with embedded cover art."
    else
        echo "No embedded thumbnail found in the video."
        # If no thumbnail exists, just extract the MP3 without a cover
        ffmpeg -i "$input" -vn -acodec copy "$output"
        echo "MP3 created without cover art."
    fi

    rm -f "$cover_tmp"
}

png2ico() {
    magick "$1" -resize 512x512 "${1%.*}.ico"
}

exe-ico-extract() {
    wrestool -x -t 14 "$1" > "${1%.*}.ico"
}

#alias gen-icons='magick $1 -define icon:auto-resize=16,32,48,64,128,256,512 ${1%.*}.ico'
#alias gen-icons='magick $1 -resize 16x16 -resize 32x32 -resize 48x48 -resize 64x64 -resize 128x128 -resize 256x256 -resize 512x512 ${1%.*}.ico'
#gen-icons() {
#    magick "$1" -resize 16x16 -resize 32x32 -resize 48x48 -resize 64x64 -resize 128x128 -resize 256x256 -resize 512x512 "${1%.*}.ico"
#}

flac-replace-cover(){
	metaflac --remove --block-type=PICTURE "$1" && metaflac --import-picture-from="$2" "$1"
}

pixelart_upscale(){
	magick "$1" -scale "${2:-400%}" -interpolate Nearest "${1%.*}_upscaled.${1##*.}"
}

flac-extract-cover-rockbox(){
	ffmpeg -i "$1" -an -vcodec copy cover.jpg && mogrify -resize 500x500\! -interlace none cover.jpg
}

#alias mv-from-children='find . -mindepth 2 -type f -exec mv -t . {} +'

alias restart-audio-engine='systemctl --user restart pipewire pipewire-pulse pipewire-virtual-sinks wireplumber'
alias restart-display-manager="sudo systemctl restart display-manager"

alias untar-gz='tar -xvzf'
alias untar-xz='tar -xvJf'

alias findprocess='ps aux | grep -i'

alias clock='tty-clock -c'
# Goofy ahh
alias lavat-lava='lavat -c yellow -R1 -k red'
alias lavat-candy='lavat -c green -R1 -k magenta'
alias lavat-blob='lavat -c green -R1 -k cyan -C -r 3 -b 8'
