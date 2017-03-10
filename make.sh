#!/usr/bin/env sh

#
# Copyright (c) 2017 Erik Nordstrøm <erik@nordstroem.no>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

if [ -z "$MAKE" ] ; then
  MAKE=make
fi
if [ -z "$CC" ] ; then
  CC=cc
fi
if [ -z "$BUILDTYPE" ] ; then
  BUILDTYPE=debug
else
  BUILDTYPE="$BUILDTYPE"
fi

if [ ! "$BUILDTYPE" = "debug" ] && [ ! "$BUILDTYPE" = "release" ] ; then
  echo "Invalid build type." 1>&2
  exit 1
fi

OUT=
BUILDS=

if [ -f "$HOME/out/.allow_from_any" ] ; then
  OUT="$HOME/out"
  echo "Using out dir \`$OUT'." 1>&2
fi

if [ -f "$HOME/build/.allow_from_any" ] ; then
  BUILDS="$HOME/build"
  echo "Using build dir \`$BUILDS'." 1>&2
fi

if [ -f buildrecipe ] ; then
  ./create_makefile.py buildrecipe.new || exit 1
  cmp -s buildrecipe buildrecipe.new
  if [ "$?" -ne "0" ] ; then
    echo "buildrecipe updated" 1>&2
    mv buildrecipe.new buildrecipe
  else
    rm buildrecipe.new
  fi
else
  ./create_makefile.py buildrecipe || exit 1
  echo "buildrecipe updated" 1>&2
fi

BUILDTYPE="$BUILDTYPE" OUT="$OUT" BUILDS="$BUILDS" CC="$CC" ${MAKE} -f buildrecipe $@
