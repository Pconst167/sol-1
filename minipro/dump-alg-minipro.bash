#!/usr/bin/env bash

# This script is a part of the minipro project
# https://gitlab.com/DavidGriffith/minipro/

# This script downloads a .rar file containing the official Xgpro
# software.  This .rar file is then expanded and the algorithm files
# within are processed to create an algorithm.xml file for use with
# minipro.  This script is heavily based on and greatly expanded from a
# similar script by radiomanV <radioman_35@yahoo.com>.

# Why do this?  It's because for the T56 programmer, the bitstreams
# required by the programmer's FPGA are not contained in the programmer
# itself, but must be loaded from the controlling program.  The other
# Xgecu programmers keep their FPGA bitstreams in their own hardware.

# See
# https://hackaday.com/2021/01/29/why-blobs-are-important-and-why-you-should-care/
# for a discussion of this practice and why it's bad.

# Prerequisites:
#   bash, bsdtar, sha256sum, wget or curl, and base64.

XGPRO_RAR=xgproV1278_Setup.rar
XGPRO_RAR2=XgproV1278_Setup.exe
XGPRO_URL=https://github.com/Kreeblah/XGecu_Software/raw/refs/heads/master/Xgpro/12
XGPRO_SHA256=cf5dd2771aa3b5af46e09c2eabc05bdb56362dd2719c348e287fa91d93b8eec9

WORKDIR=`pwd`
XGPRO_ALG="algorithm"
ALG_FILENAME="algorithm.xml"

FIRMWARE_NAMES=("updateII.dat" "UpdateT48.dat" "updateT56.dat")
FIRMWARE_TYPE=("TL866II+" "T48" "T56")
FIRMWARE_VERSIONS=("04.2.105" "01.1.32" "01.1.73")
FIRMWARE_COUNT=3

ALG_OFFSET=545		# 0x221

TAR="bsdtar"

usage() {
	echo "usage: $0 [ <path> ]" && grep " .)\ #" $0;
	echo
	echo "This script downloads Xgecu software RAR file to extract firmware and T56"
	echo "algorithms.  By default, this script will process the *.alg files in"
	echo "$XGPRO_RAR and put the resulting $ALG_FILENAME file in the current"
	echo "directory along with the latest firmware images for the TL866II+, T48, and"
	echo "T56 programmers."
	echo
	echo "If a path is supplied (for example: /usr/local/share/minipro/), this script"
	echo "will attempt to install $ALG_FILENAME there.  This is intended for use by the"
	echo "minipro Makefile, package management, or manually."
	echo
	echo "Prerequisite programs: bash, bsdtar, sha256sum, base64, and wget or curl."
	echo "If you don't see \"bsdtar\" as a separate package, try \"libarchive-tools\"."
	echo "As the name suggests, on BSD systems, your regular tar program is bsdtar."
	echo
	exit 0;
}

if [ $1 ] ; then
	if [ $1 = "help" ] || [ $1 = "-h" ]  ; then
		usage
		exit
	fi
fi

echo "Starting the Xgecu downloader."
echo "** Where do I put the T56 algorithms ($ALG_FILENAME) file?"

if [ $1 ]; then
	INSTALL_DIR=$1
	echo "** I see you want me to install it to $INSTALL_DIR"
	echo "** Checking to see if I can work on this stuff right here."

	if [ -w $WORKDIR ]; then
		echo "   Success!"
	else
		echo "** Error: Unable to write to $WORKDIR."
		echo "   Where do I put the downloaded file?"
		exit
	fi

	# Do we have write access now?
	# No?  Then see if we can do it through sudo.
	if ! [ -w $INSTALL_DIR ]; then
		if [ ! -d $INSTALL_DIR ] ; then
			echo "** Error: $INSTALL_DIR doesn't exist.  Is minipro installed yet?"
			exit
		fi

		echo "** Checking to see if I can write there as \"$USER\"."
		if [ ! -w $INSTALL_DIR ] ; then
			echo "** Can't write there as \"$USER\".  Trying as the superuser."
			if ! [ -x "$(command -v sudo)" ]; then
				echo "** Error: sudo not found.  Install algorithms manually."
				exit
			fi

			sudo -u root bash -c : && RUNAS="sudo -u root"
				$RUNAS bash<<-EOF
				if [ -w $INSTALL_DIR ] ; then
					USE_ROOT=1
					echo "   Success!"
				else
					echo "** Error: Unable to write to $INSTALL_DIR."
					exit
				fi
			EOF
		fi
	fi  # We can write without needing root access
else
	# No target directory specified, so we'll just put the files into the
	# current working directory.
	INSTALL_DIR=$WORKDIR
	echo "** I'll just leave it right here."
fi


# Check for needed programs: bsdtar, sha256sum, wget or curl, and base64.
#
if ! [ -x "$(command -v $TAR)" ]; then
        # Bsdtar not found.  Check if tar is really bsdtar
        TARVER="$(command -v "tar" --version | cut -d" " -f1 | head -n1)"
        if [ $TARVER == "tar" ]; then
                echo "** Good!  tar is really bsdtar."
		TAR="tar"
        else
                echo "** Error: bsdtar not installed." >&2
		echo "** Try libarchive-tools if you don't see a bsdtar package."
		ERROR=1
        fi
else
        echo "** Found bsdtar."
fi

if [ -x "$(command -v wget )" ]; then
	GETURL="wget -O"
	echo "** Found wget."
elif [ -x "$(command -v curl)" ]; then
	GETURL="curl -L --fail -w '%{http_code}' -o"
	echo "** Found curl."
else
	echo "Error: Neither wget nor curl are installed." >&2
	ERROR=1
fi

if ! [ -x "$(command -v sha256sum)" ]; then
	echo "Error: sha256sum is not installed.  This should not happen." >&2
	ERROR=1
else
	echo "** Found sha256sum."
fi

if ! [ -x "$(command -v base64)" ]; then
	echo "Error: base64 is not installed.  This should not happen." >&2
	ERROR=1
else
	echo "** Found base64."
fi

if [ ${ERROR} ] ; then
	echo "Install prerequsites and then try again." >&2
	exit 1
fi


# Download, check, then extract.
if [ ! -f "$WORKDIR/$XGPRO_RAR" ] ; then
	echo "** Downloading $XGPRO_RAR."
#	echo "   doing $GETURL $WORKDIR/$XGPRO_RAR $XGPRO_URL/$XGPRO_RAR"
	http_code="$($GETURL $WORKDIR/$XGPRO_RAR $XGPRO_URL/$XGPRO_RAR)"
	RETVAL="$?"

	if [ ! -s $WORKDIR/$XGPRO_RAR ] ; then
		rm -f $WORKDIR/$XGPRO_RAR
	fi
else
	echo "** $XGPRO_RAR already in $WORKDIR."
	RETVAL=0
fi

if [ $RETVAL -ne 0 ] ; then
	echo "** Error: Unable to download $XGPRO_RAR."
	exit 2
fi

echo "** Checking $XGPRO_RAR."
SHA256_CHECK=`sha256sum $XGPRO_RAR | cut -d" " -f1`
if [ $XGPRO_SHA256 != $SHA256_CHECK ] ; then
	echo "** Error: SHA256 checksum for $XGPRO_RAR is wrong."
	echo "    Should be $XGPRO_SHA256"
	echo "    But I got $SHA256_CHECK"
	exit 3
fi
echo "** SHA256 checksum is good."

echo "** Extracting."
$TAR -x --to-stdout -f $WORKDIR/$XGPRO_RAR \
	| $TAR -x -f -  ${FIRMWARE_NAMES[*]} $XGPRO_ALG/*.alg

# Rename firmware files to reflect their versions.
#
NAME_INDEX=0
while [ $NAME_INDEX -lt $FIRMWARE_COUNT ] ; do
	NEWNAME="firmware-${FIRMWARE_TYPE[$NAME_INDEX]}-${FIRMWARE_VERSIONS[$NAME_INDEX]}.dat"
	echo "    ${FIRMWARE_NAMES[$NAME_INDEX]} --> $NEWNAME"
	mv ${FIRMWARE_NAMES[$NAME_INDEX]} $NEWNAME
	NAME_INDEX=$((NAME_INDEX+1))
done
echo "    $XGPRO_ALG/"


# Extracting algorithm data and building algorithm.xml.
#
echo "** Processing T56 algorithm files to create $ALG_FILENAME."
echo '<root>' > $ALG_FILENAME
echo '<database type="ALGORITHMS">' >> $ALG_FILENAME
echo '<algorithms_T56>' >> $ALG_FILENAME
TICK_COUNT=0
TICK_MAX=75
for file in  $XGPRO_ALG/*.alg  ; do
	if [ $TICK_COUNT -le $TICK_MAX ] ; then
		TICK_COUNT=$((TICK_COUNT+1))
		echo -n "."
	else
		TICK_COUNT=0
		echo "."
	fi
	read -d "" desc < $file
	bitstream=$(tail -c +$ALG_OFFSET $file | gzip --best | base64 -w 0)
	file=$(basename -- "$file")
	echo "<algorithm name=\"${file%.*}\"" >> $ALG_FILENAME
	echo "description=\"${desc}\"" >> $ALG_FILENAME
	echo "bitstream=\"${bitstream}\"/>" >> $ALG_FILENAME
done
echo '</algorithms_T56>' >> $ALG_FILENAME
echo '</database>' >> $ALG_FILENAME
echo '</root>' >> $ALG_FILENAME

rm -rf $XGPRO_ALG/

echo

if [ $INSTALL_DIR != $WORKDIR ] ; then
	echo "** Installing $ALG_FILENAME to $INSTALL_DIR."
	if [ -n $USE_ROOT ] ; then
		sudo cp $ALG_FILENAME $INSTALL_DIR
	fi
fi
echo "** Done!"
