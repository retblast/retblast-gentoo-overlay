# Retblast's overlay
This houses some packages that I use, and are not in the GURU or Gentoo's repositories.

# Workflow
After creating the ebuild, do
```
  pkgdev manifest -d $distfilesFolder $ebuild
  pkgcheck scan $ebuild 
  ebuild $ebuild clean test install
  ebuild $ebuild clean install merge
```
$distfilesFolder usually is `/var/cache/distfiles`
If stuff works fine, can be pushed to the repo.

## Updating a Manifest file
```
  rm /var/cache/distfiles/file
  rm path/to/Manifest
```
Then do the manifest generation again.

## Keywording
I only keyword stuff I want to make me manually unkeyword locally for xyz reason.
