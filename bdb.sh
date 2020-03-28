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
	if ! [ -d "${1}" ] ; then
		echo "ERROR: Invalid bookmark location!" >&2
		exit 1
	fi
	if grep "^${1}\$" "${BOOKMARK_FILE}" &> /dev/null ; then
		echo "Location '${1}' is already bookmarked." >&2
		exit 0
	fi
	echo "${1}" >> "${BOOKMARK_FILE}"
	echo "Added '${1}'" >&2
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
		if ! grep "^${1}\$" "${BOOKMARK_FILE}" &> /dev/null ; then
			echo "No matching boomark found." >&2
			exit 0
		fi
		local tmp_file=$(mktemp)
		grep -v "^${1}\$" <"${BOOKMARK_FILE}" >"${tmp_file}"
		mv "${tmp_file}" "${BOOKMARK_FILE}"
		echo "Removed '${1}'" >&2
		exit 0
	else
		echo "No bookmarks defined yet." >&2
		exit 0
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
		if [ -z "${2}" ] ; then
			path="${CURRENT_PATH}"
		else
			path="${2}"
		fi
		add_bookmark "${path}"
		exit 0
		;;
	-r | --remove)
		if [ -n "${2}" ] ; then
			index="${2}"
			path=$(get_bookmark_by_index "${index}")
		else
			path="${CURRENT_PATH}"
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
			num_bookmarks=$(cat "${BOOKMARK_FILE}" | wc -l)
			if [ ${num_bookmarks} -eq 1 ] ; then
				# Directly jump to bookmark when there is only one defined
				cat "${BOOKMARK_FILE}"	
			else
				# Let user search bookmark file using fzf when there are 
				# multiple bookmarks defined
		       		cat "${BOOKMARK_FILE}" | fzf
			fi
		elif is_integer "${1}" ; then
			index="${1}"
			get_bookmark_by_index "${index}"
		else
			num_matches=$(cat "${BOOKMARK_FILE}" | grep "${1}" | wc -l)
			if [ ${num_matches} -eq 0 ] ; then
				echo "No matching bookmarks found." >&2
				exit 1
			elif [ ${num_matches} -eq 1 ] ; then
				# Directly jump to bookmark when there is only one matching 
				# bookmark
				cat "${BOOKMARK_FILE}" | grep "${1}"
			else
				# Let user search bookmark file using fzf when there are 
				# multiple matching bookmarks
				cat "${BOOKMARK_FILE}" | grep "${1}" | fzf
			fi
		fi
esac
