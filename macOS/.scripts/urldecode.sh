#!/bin/bash
#
# https://www.rosettacode.org/wiki/URL_decoding
function urldecode() { local u="${1//+/ }"; printf '%b' "${u//%/\\x}"; }
