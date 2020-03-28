#!/bin/bash
# ##################################################
# NAME:
#   bdb
# DESCRIPTION:
#   bash directory bookmarking
# AUTHOR:
#   bytebutcher
# ##################################################

function usage() {
	echo "usage: $(basename ${0}) [-a] [-r] [-l]>"	>&2
	echo "  -a  add current dir to bookmarks" 	>&2
	echo "  -r  remove current dir from bookmarks"	>&2
	echo "  -l  list bookmarks"			>&2
	echo "  -?  display help"			>&2
	exit 1
}

function require_command() {
	local required_command="${1}"
	command -v "${required_command}" >/dev/null 2>&1 || {
		echo "Require ${required_command} but it's not installed. Aborting." >&2
		exit 1;
	}
}

function is_integer() {
	[[ ${1} =~ ^[0-9]+$ ]]
}

function resolve_dir() {
	cd "${1}" 2>/dev/null || return ${?}  
	echo "`pwd -P`" 
}

function add_bookmark() {
	if ! [ -f "${BOOKMARK_FILE}" ] || ! grep "^${1}\$" "${BOOKMARK_FILE}" ; then
		echo "${1}" >> "${BOOKMARK_FILE}"
		echo "Added ${1}"
	fi
}

function get_bookmark_by_index() {
	local index="${1}"; 
	local line_count="$(wc -l "${BOOKMARK_FILE}" | awk '{ print $1 }')"
	if ! is_integer ${index} || [ ${index} -eq 0 ] || [ ${index} -gt ${line_count} ] ; then
		echo "ERROR: Invalid index!" >&2
		exit 1
	fi
	sed "${index}q;d" "${BOOKMARK_FILE}"
}

function remove_bookmark() {
	if [ -f "${BOOKMARK_FILE}" ] ; then
		local tmp_file=$(mktemp)
		grep -v "^${1}\$" <"${BOOKMARK_FILE}" >"${tmp_file}"
		mv "${tmp_file}" "${BOOKMARK_FILE}"
		echo "Removed ${1}"
	fi
}

function list_bookmarks () {
	if [ -f "${BOOKMARK_FILE}" ] ; then
		cat -n "${BOOKMARK_FILE}"
	fi
}

CURRENT_PATH=$(resolve_dir "${CWD}")
BOOKMARK_PATH="${HOME}/.bdb/"
BOOKMARK_NAME="bookmarks"
BOOKMARK_FILE="${BOOKMARK_PATH}${BOOKMARK_NAME}"

require_command "fzf"

if ! [ -d "${BOOKMARK_PATH}" ] ; then
	mkdir "${BOOKMARK_PATH}"
fi

case ${1} in
	-a | --add)
		path="${2}"
		if [ -z "${path}" ] ; then
			path="${CURRENT_PATH}"
		fi
		add_bookmark "${path}"
		exit 0
		;;
	-r | --remove)
		index="${2}"
		path="${CURRENT_PATH}"
		if [ -n "${index}" ] ; then
			path=$(get_bookmark_by_index "${index}")
		fi
		remove_bookmark "${path}"
		exit 0
		;;
	-l | --list)
		list_bookmarks 
		exit 0
		;;
	-h | --help )
		usage
		exit 0
		;;
	* )
		if ! [ -f "${BOOKMARK_FILE}" ] ; then
			echo "No bookmarks defined yet." >&2
			exit 1
		fi
		if [ $# -eq 0 ] ; then
			result=$(cat "${BOOKMARK_FILE}" | wc -l)
			if [ ${result} -eq 1 ] ; then
				cat "${BOOKMARK_FILE}"	
			else
		       		cat "${BOOKMARK_FILE}" | fzf
			fi
		elif is_integer "${1}" ; then
			index="${1}"
			get_bookmark_by_index "${index}"
		else
			result=$(cat "${BOOKMARK_FILE}" | grep "${1}" | wc -l)
			if [ ${result} -eq 0 ] ; then
				echo "No matching bookmarks found." >&2
				exit 1
			elif [ ${result} -eq 1 ] ; then
				cat "${BOOKMARK_FILE}" | grep "${1}"
			else
				cat "${BOOKMARK_FILE}" | grep "${1}" | fzf
			fi
		fi
esac
