#!/usr/bin/env bash

# a handy script for importing EAC rips from Windows to my FLAC storage. perhaps
# it will be useful to somebody else.

set -e
set -x

cd /mnt/storage/FLAC/.new
mv -t . /mnt/windows/Rips/*

# fix permissions, since NTFS has everything set to 777 by default
find . -type d -exec chmod 755 '{}' +
find . -type f -exec chmod 644 '{}' +

# fix paths inside CUE files. can't use sed, because the cue files are encoded
# in the Windows local codepage (Windows-1250 in my case), and sed doesn't
# recognize lines which have characters in this encoding.
while IFS= read -r -d '' file; do
    tmp=$(mktemp)
    perl -npe 's/^FILE "[^\\]*\\(.*)" WAVE/FILE "\1" WAVE/' < "$file" > "$tmp"
    mv "$tmp" "$file"
    chmod 644 "$file"
done < <(find -type f -name '*.cue' -print0)

mv -t .. *

exit 0
