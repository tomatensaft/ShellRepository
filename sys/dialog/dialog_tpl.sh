#!/bin/sh
# SPDX-License-Identifier: MIT

set -u

dialog_msgbox() {
	local _msg="${1}"
	local _title="${2-"Error"}"
	local _backtitle="${3-"${DIALOG_BACKTITLE-""}"}"
	local _vsize="${4-"0"}"
	local _hsize="${5-"0"}"
	${DIALOG-dialog} --title "${_title}" --backtitle "${_backtitle}" --msgbox "${_msg}" "${_vsize}" "${_hsize}"
}

dialog_msgbox Test TitelTest backtitel 300 300