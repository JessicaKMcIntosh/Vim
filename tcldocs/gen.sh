#!/bin/sh

# Reads a list of manpages from man.lst and converts them to text files.
# Does not check before overwriting files. Make sure you have backups!
#
# I collected man.lst from the Cygwin Tcl 8.5 package I am using.
# This package puts the manpages in the "n" section.
# If you system puts them in a different system change the man command.

for command in `cat man.lst`
do
    text_file="`echo $command | tr 'A-Z' 'a-z'`.txt"
    echo "$command => $text_file"
    man n $command | col -b > ${text_file}
    # Alternate command to eliminate garbage chracters.
    # This works for me on Cygwin...
#    zcat /usr/share/man/mann/${command}.n.gz | \
#        nroff -man -Tascii -c \
#        | col -b -x > ${text_file}
done
