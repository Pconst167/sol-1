# dump-lgc.pl - Dump LGC files in XML format
# File format described here: https://github.com/evolutional/xgpro-logic
#
# Copytight (C) 2021 Lubomir Rintel <lkundrak@v3.sk>
#
# This file is a part of Minipro.
#
# Minipro is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Minipro is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

use strict;
use warnings;

my $data = join '', <>;
my ($AllCrc32, $UIFlag, $ItemCount, $Res, @ItemStart) = unpack 'LLLL512L', $data;

my @lvl = qw/0 1 L H C Z X G V/;
my @vlt = qw/5V 3V3 2V5 1V8/;

print <<END;
<?xml version="1.0" encoding="utf-8"?>
<logicic>
  <database device="LOGIC">
    <manufacturer name="Logic Ic">
END

for my $item (0..$ItemCount-1) {
	my ($ItemName, $VoltageLevel, $PinCount, $Res0, $Res1, $UIRes, @Vectors) =
		unpack 'x4a32CCCCLX44Lx40/(a24)', substr $data, $ItemStart[$item];
	$ItemName =~ s/\x00.*//;

        printf "      <ic name=\"%s\" type=\"5\" voltage=\"%s\" pins=\"%d\">\n",
		$ItemName, $vlt[$VoltageLevel], $PinCount;

	foreach my $id (0..$#Vectors) {
		my $vector = $Vectors[$id];
		my @pins = map { $_ & 0xf, $_ >> 4 } map { ord $_ } split '', $vector;
		printf "        <vector id=\"%02d\"> %s </vector>\n", $id,
			join ' ', map { $lvl[$pins[$_]] } (0..$PinCount-1)
	}

	printf "      </ic>\n";
}

print <<END;
    </manufacturer>
  </database>
</logicic>
END
