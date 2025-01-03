#!/bin/bash
# Description: Video to GIF/APNG/WEBP converter
# By: MDHEXT, Nabi KaramAliZadeh, Pathduck
# Version: 6.0
# Url: https://github.com/Pathduck/vid2ani/ forked from https://github.com/MDHEXT/video2gif
# What this script is based on: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
# License: GNU General Public License v3.0 (GPLv3)

# Enable error handling
set -euo pipefail

### Start Main ###
main() {

# Define ANSI Colors
OFF=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 12)
CYAN=$(tput setaf 14)

# Default values
fps=15
mode=1
dither=0
colormax=256
scale="-1"
filetype="gif"
loglevel="error"
bayerscale=""
start_time=""
end_time=""
trim=""
webp_lossy=""
errorswitch=""
errordiff=""
picswitch=""

# Check input
if [ $# -eq 0 ]; then print_help; exit; fi
input="$1"
output="${input%.*}"

echo "Input file: $input"
echo "Output file: $output"

# Parse Arguments
shift
while [[ $# -gt 0 ]]; do
	case "$1" in
		-r) scale="$2"; shift 2;;
		-f) fps="$2"; shift 2;;
		-m) mode="$2"; shift 2;;
		-d) dither="$2"; shift 2;;
		-b) bayerscale="$2"; shift 2;;
		-t) filetype="$2"; shift 2;;
		-o) output="${2%.*}"; shift 2;;
		-s) start_time="$2"; shift 2;;
		-e) end_time="$2"; shift 2;;
		-c) colormax="$2"; shift 2;;
		-l) webp_lossy="$2"; shift 2;;
		-v) loglevel="$2"; shift 2;;
		-k) errorswitch=1; shift;;
		-p) picswitch=1; shift;;
		-h|--help) print_help; exit;;
		*) echo ${RED}"Unknown option $1"${OFF}; exit 1;;
	esac
done

# Input validation
if [[ -z "$input" ]]; then
	echo "Input file is required."; print_help; exit 1
fi

# Fix paths for Cygwin and create working dir
if [[ "$(uname -o)" == "Cygwin" ]]; then
	# Use Windows-compatible directories for Cygwin
	input=$(cygpath -w "$input")
	output=$(cygpath -w "$output")
	WD=$(cygpath -w "$(mktemp -d -t vid2ani-XXXXXX)")
else
	# Use POSIX-compatible directories
	WD=$(mktemp -d -t vid2ani-XXXXXX)
fi

# Cleanup on exit, interrupt, termination
trap 'rm -rf "$WD"' EXIT INT TERM

# Validate output file extension
case "$filetype" in
	gif) output="$output.gif";;
	png) output="$output.png"; filetype="apng";;
	apng) output="$output.png";;
	webp) output="$output.webp";;
	*) echo ${RED}"Invalid file type: $filetype"${OFF}; exit 1;;
esac

echo "Input file: $input"
echo "Output file: $output"

# Validate Palettegen
if [[ "$mode" -lt 1 || "$mode" -gt 3 ]]; then
	echo ${RED}"Not a valid palettegen (-m) mode"${OFF}; exit 1
fi

# Validate Dithering
if [[ "$dither" -gt 8 || "$dither" -lt 0 ]]; then
	echo ${RED}"Not a valid dither (-d) algorithm"${OFF}; exit 1
fi

# Validate Bayerscale
if [[ -n "$bayerscale" ]]; then
	if [[ "$bayerscale" -gt 5 || "$bayerscale" -lt 0 ]]; then
		echo ${RED}"Not a valid bayerscale (-b) value"${OFF}; exit 1
	fi
	if [[ "$dither" -ne 1 ]]; then
		echo ${RED}"Bayerscale (-b) only works with Bayer dithering"${OFF}; exit 1
	fi
fi

# Validate Lossy WEBP
if [[ -n "$webp_lossy" ]]; then
	if [[ "$filetype" != "webp" ]]; then
		echo ${RED}"Lossy (-l) is only valid for filetype webp"${OFF}; exit 1
	fi
	if [[ "$webp_lossy" -gt 100 || "$webp_lossy" -lt 0 ]]; then
		echo ${RED}"Not a valid lossy (-l) quality value"${OFF}; exit 1
	fi
fi

if [[ -n "$start_time" ]]; then
	echo start er satt
fi

if [[ -z "$start_time" ]]; then
	echo start er null
fi

if [[ -n "$end_time" ]]; then
	echo end er satt
fi

if [[ -z "$end_time" ]]; then
	echo end er null
fi


# Validate Clipping
if [[ -n "$start_time" && -z "$end_time" ]]; then
	echo ${RED}"End time (-e) is required when Start time (-e) is specified."${OFF}; exit 1
elif [[ -n "$end_time" && -z "$start_time" ]]; then
	echo ${RED}"Start time (-s) is required when End time (-e) is specified."${OFF}; exit 1
elif [[ -n "$end_time" && -n "$start_time" ]]; then
	trim="-ss $start_time -to $end_time"
fi

# Validate Framerate
if [[ "$fps" -le 0 ]]; then
	echo ${RED}"Framerate (-f) must be greater than 0."${OFF}; exit 1
fi

# Validate Max Colors
if [[ "$colormax" -lt 3 || "$colormax" -gt 256 ]]; then
	echo ${RED}"Max colors (-c) must be between 3 and 256."${OFF}; exit 1
fi

# Displaying FFmpeg version string
ffmpeg_version=$(ffmpeg -version | head -n2)
echo ${YELLOW}"$ffmpeg_version"${OFF}
echo ${GREEN}Output file:${OFF} $output

## Putting together command to generate palette ##
filters="fps=$fps,scale=$scale:-1:flags=lanczos"
palette="$WD/palette_%05d.png"

# APNG muxer does not support multiple palettes so fallback to using palettegen diff mode
if [[ "$filetype" == "apng" && "$mode" -eq 2 ]]; then
	echo ${YELLOW}"APNG does not support multiple palettes - falling back to Palettegen mode 1 (diff)"${OFF}
	mode=1
fi

# Palettegen encode mode
encode=""
if [[ -n "$mode" ]]; then
	case "$mode" in
		1) encode="palettegen=stats_mode=diff";;
		2) encode="palettegen=stats_mode=single";;
		3) encode="palettegen";;
		*) echo ${RED}"Invalid palettegen (-m) mode"${OFF}; exit 1;;
	esac
fi

# Max colors
mcol=""
if [[ -n "$colormax" ]]; then
	if [[ "$mode" -le 2 ]]; then mcol=":max_colors=${colormax}"; fi
	if [[ "$mode" -eq 3 ]]; then mcol="=max_colors=${colormax}"; fi
fi

# Executing command to generate palette
echo ${GREEN}"Generating palette..."${OFF}
echo ffmpeg -v "${loglevel}" ${trim:-} -i "${input}" -vf "${filters},${encode}${mcol}" -y "${palette}"
ffmpeg -v "${loglevel}" ${trim:-} -i "${input}" -vf "${filters},${encode}${mcol}" -y "${palette}"

# Checking if the palette file is in the Working Directory, if not cleaning up
if [[ ! -f "$WD/palette_00001.png" ]]; then
	echo ${RED}"Palette generation failed: $palette not found."${OFF}; exit 1
fi

## Setting variables to put the encode command together ##

# Palettegen decode mode
if [[ -n "$mode" ]]; then
	case "$mode" in
		1) decode="paletteuse";;
		2) decode="paletteuse=new=1";;
		3) decode="paletteuse";;
		*) echo ${RED}"Invalid palettegen (-m) mode"${OFF}; exit 1;;
	esac
fi

# Error diffusion
if [[ -n "$errorswitch" ]]; then
	case "$mode" in
		1) errordiff="=diff_mode=rectangle";;
		2) errordiff=":diff_mode=rectangle";;
		3) errordiff="=diff_mode=rectangle";;
		*) echo ${RED}"Invalid palettegen (-m) mode"${OFF}; exit 1;;
	esac
fi

# Prepare dithering and encoding options
ditheralg="none"
case "$dither" in
	0) ditheralg="none";;
	1) ditheralg="bayer";;
	2) ditheralg="heckbert";;
	3) ditheralg="floyd_steinberg";;
	4) ditheralg="sierra2";;
	5) ditheralg="sierra2_4a";;
	6) ditheralg="sierra3";;
	7) ditheralg="burkes";;
	8) ditheralg="atkinson";;
	*) echo ${RED}"Invalid dither (-d )mode"${OFF}; exit 1;;
esac

# Paletteuse error diffusion
ditherenc=""
if [[ "$mode" -ne 2 ]]; then
	if [[ -n "$errorswitch" ]]; then ditherenc=":dither=$ditheralg"; fi
	if [[ -z "$errorswitch" ]]; then ditherenc="=dither=$ditheralg"; fi
else
	ditherenc=":dither=$ditheralg"
fi

# Checking for Bayer Scale and adjusting command
if [[ -n "$bayerscale" ]]; then bayer=":bayer_scale=$bayerscale"; fi
if [[ -z "$bayerscale" ]]; then bayer=""; fi

# WEBP pixel format and lossy quality
if [[ "$filetype" == "webp" && -n "$webp_lossy" ]]; then
	webp_lossy="-lossless 0 -pix_fmt yuva420p -quality $webp_lossy"
fi

# Executing the encoding command
echo ${GREEN}"Encoding animation..."${OFF}
echo ffmpeg -v "${loglevel}" ${trim:-} -i "${input}" -thread_queue_size 512 -i "${palette}" -lavfi "${filters} [x]; [x][1:v] ${decode}${errordiff}${ditherenc}${bayer}" -f "${filetype}" ${webp_lossy:-} -loop 0 -plays 0 -y "${output}"
ffmpeg -v "${loglevel}" ${trim:-} -i "${input}" -thread_queue_size 512 -i "${palette}" -lavfi "${filters} [x]; [x][1:v] ${decode}${errordiff}${ditherenc}${bayer}" -f "${filetype}" ${webp_lossy:-} -loop 0 -plays 0 -y "${output}"

# Checking if output file was created
if [[ ! -f "$output" ]]; then
	echo ${RED}"Failed to generate animation."${OFF}; exit 1
fi

# Open output if picswitch is enabled
if [[ -n "$picswitch" ]]; then
	xdg-open "$output"
fi

echo ${GREEN}"Done."${OFF}

} 
### End Main ###

### Function to print the help message ###
print_help() {
cat << EOF
${GREEN}Video to GIF/APNG/WEBP converter v6.0${OFF}
${BLUE}By MDHEXT, Nabi KaramAliZadeh, Pathduck${OFF}

${GREEN}Usage:${OFF}
$(basename $0) [input_file] [arguments]

${GREEN}Arguments:${OFF}
  -t  Output file type. Valid: 'gif' (default), 'apng', 'png', 'webp'.
  -o  Output file. The default is the same name as the input video.
  -r  Scale or size. Width of the animation in pixels.
  -s  Start time of the animation (HH:MM:SS.MS).
  -e  End time of the animation (HH:MM:SS.MS).
  -f  Framerate in frames per second (default: 15).
  -d  Dithering algorithm to be used (default: 0).
  -b  Bayer Scale setting. Range 0 - 5 (default: 2).
  -m  Palettegen mode: 1 (diff), 2 (single), 3 (full) (default: 1).
  -c  Maximum colors usable per palette. Range 3 - 256 (default).
  -k  Enables paletteuse error diffusion.
  -l  Enable lossy WebP compression and quality. Range 0 - 100.
  -v  Set FFmpeg log level (default: error).
  -p  Opens the resulting animation in the default viewer.

${GREEN}Dithering Mode${OFF}
  0: None
  1: Bayer
  2: Heckbert
  3: Floyd Steinberg
  4: Sierra2
  5: Sierra2_4a
  6: Sierra3
  7: Burkes
  8: Atkinson

${GREEN}Palettegen Modes${OFF}
  1: diff - only what moves affects the palette
  2: single - one palette per frame
  3: full - one palette for the whole animation

${GREEN}About Bayerscale${OFF}
When bayer dithering is selected, the Bayer Scale option defines the
scale of the pattern (how much the crosshatch pattern is visible).
A low value means more visible pattern for less banding, a higher value
means less visible pattern at the cost of more banding.

${GREEN}People who made this project come to fruition${OFF}
ubitux, Nabi KaramAliZadeh, and the very kind and patient people in the
Batch Discord Server. Without these people's contributions, this script
would not be possible. Thank you all for your contributions and
assistance^^!
EOF
}
### End print_help ###

# Call Main function
main "$@"; exit;
