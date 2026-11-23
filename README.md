# Retblast's overlay
This houses some packages that I use, and are not in the GURU or Gentoo's repositories.

## Ladybird

`www-client/ladybird-bin` enables `vulkan-video` by default. It builds a private FFmpeg 9 for H.264 and HEVC hardware decoding on supported Vulkan drivers. Ladybird uses its bundled FFmpeg for AV1 and VP9. The packaged launcher handles the Intel driver setting.

To use system FFmpeg, add `www-client/ladybird-bin -vulkan-video` to `/etc/portage/package.use`. On amd64, the package requires the `~amd64` keyword.

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
