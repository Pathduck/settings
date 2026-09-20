#!/bin/bash
# Description: Video to AVIF converter
# By: Pathduck
# Version: 1.0
# Url: https://github.com/Pathduck/vid2avif/
# License: GNU General Public License v3.0 (GPLv3)

# Enable error handling
#set -euo pipefail

### Start Main ###
main() {

# Define ANSI Colors
off=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 10)
yellow=$(tput setaf 11)
blue=$(tput setaf 12)
cyan=$(tput setaf 14)

# Check for blank input or help commands
if [[ $# -eq 0 ]]; then print_help; exit; fi
case "$1" in
	-h) print_help; exit;;
	-?) print_help; exit;;
	--help) print_help; exit;;
esac

# Check if ffmpeg exists on PATH, if not exit
if ! command -v 'ffmpeg' >/dev/null 2>&1; then
	echo ${red}"FFmpeg not found in PATH, please install it first"${off}; exit 1
fi

# Assign input and output
input="$1"
output=$(basename "${input%.*}")

# Validate input file
if [[ ! -f "$input" ]]; then
	echo ${red}"Input file not found: $input"${off}; exit 1
fi

# Set uname for later use
uname_os=$(uname)

# Clearing input vars and setting defaults
fps=15
scale="-1"
filetype="avif"
loglevel="error"
start_time=""
end_time=""
crop=""
picswitch=""
playswitch=""

# Parse Arguments, first shift input one left
shift
while [[ $# -gt 0 ]]; do
	case "$1" in
		-o) [[ ${2##*/} == *.* ]] && output="${2%.*}" || output="$2"; shift;;
		-r) scale="$2"; shift;;
		-f) fps="$2"; shift;;
		-s) start_time="$2"; shift;;
		-e) end_time="$2"; shift;;
		-v) loglevel="$2"; shift;;
		-x) crop="$2"; shift;;
		-p) picswitch=1;;
		-y) playswitch=1;;
		*) echo ${red}"Unknown option $1"${off}; exit 1;;
	esac
	shift
done

# Validate if output file is set and not starts with a -
[[ -z $output || $output == -* ]] && { echo ${red}"Missing value for -o"${off}; exit 1; }

# Validate if output is a directory; strip trailing slash and use input filename
if [[ -d "$output" ]]; then
	output="${output%/}/"$(basename "${input%.*}")
fi

# Set output file extension
output="$output.$filetype"

# Validate Clipping
if [[ -n $start_time && -z $end_time ]]; then
	echo ${red}"End time (-e) is required when Start time (-s) is specified."${off}; exit 1
elif [[ -n $end_time && -z $start_time ]]; then
	echo ${red}"Start time (-s) is required when End time (-e) is specified."${off}; exit 1
elif [[ -n $end_time && -n $start_time ]]; then
	trim="-ss $start_time -to $end_time"
fi

# Validate Framerate
if [[ "$fps" == "-" ]]; then
	fps="source_fps"
elif [[ $fps -le 1 ]]; then
	echo ${red}"Framerate (-f) must be greater than 0."${off}; exit 1
fi

# Putting together filters
filters="fps=$fps"
[[ -n $crop ]] && filters+=",crop=$crop"
filters+=",scale=$scale:-1:flags=lanczos+accurate_rnd+full_chroma_int"

# Fix paths for Cygwin before running ffmpeg/ffplay
if [[ $uname_os == *"CYGWIN"* ]]; then
	input=$(cygpath -w "$input")
	output=$(cygpath -w "$output")
fi

# FFplay preview
if [[ -n $playswitch ]]; then
	# Check if ffplay exists on PATH, if not exit
	if ! command -v 'ffplay' >/dev/null 2>&1; then
		echo ${red}"FFplay not found in PATH, please install it first"${off}; exit 1
	fi
	echo ${yellow}"$(ffplay -version | head -n2)"${off}
	ffplay -v ${loglevel} -i "${input}" -vf "${filters}" -an -loop 0 -ss ${start_time:-0} -t ${end_time:-3}
	exit 0
fi

# Displaying FFmpeg version string and output file
echo ${yellow}"$(ffmpeg -version | head -n2)"${off}
echo ${green}Output file:${off} $output

# Setting variables to put the encode command together
type_opts="-crf 30 -cpu-used 4 -row-mt 1 -tiles 2x2 -pix_fmt yuv420p"

# Executing the encoding command
echo ${green}"Encoding animation..."${off}
ffmpeg -v ${loglevel} ${trim:-} -i "${input}" \
-vf "${filters}" -an \
-f ${filetype} ${type_opts:-} -loop 0 -plays 0 -y "${output}"

# Checking if output file was created
if [[ ! -f "$output" ]]; then
	echo ${red}"Failed to generate animation: $output not found"${off}; exit 1
fi

# Open output file if picswitch is enabled
if [[ -n $picswitch ]]; then
	xdg-open "$output"
fi

echo ${green}"Done."${off}

}
### End Main ###

### Function to print the help message ###
print_help() {
cat << EOF
${green}Video to AVIF converter v1.0${off}
${blue}By Pathduck${off}

${green}Usage:${off}
$(basename "$0") [input_file] [arguments]

${green}Arguments:${off}
  -o  Output file. Default is the same as input file, sans extension
  -r  Resize output width in pixels. Default is original input size
  -f  Framerate of output, or '-' to use input framerate (default 15)
  -s  Start time of the animation (HH:MM:SS.MS)
  -e  End time of the animation (HH:MM:SS.MS)
  -x  Crop the input video (out_w:out_h:x:y)
  -y  Preview animation using FFplay (part of FFmpeg)
      Useful for testing cropping, but will not use exact start/end time
  -p  Opens the resulting animation in the default image viewer
  -v  Set FFmpeg log level (default: error)
EOF
}
### End print_help ###

# Call Main function
main "$@"; exit;
