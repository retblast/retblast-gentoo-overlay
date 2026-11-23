# Retblast's overlay
This houses some packages that I use, and are not in the GURU or Gentoo's repositories.

## Ladybird

`www-client/ladybird-bin` repackages the official Ubuntu 24.04 amd64 build. On amd64, it requires the `~amd64` keyword.

### Vulkan video decoding

The `vulkan-video` USE flag is enabled by default. It rebuilds Ladybird's FFmpeg 9 libraries with Vulkan decoding for H.264, HEVC, VP9, and AV1, plus AAC decoding. The package keeps these libraries under `/opt/ladybird` so software such as OpenCV can keep using the system FFmpeg.

The launcher clears inherited library and Vulkan driver overrides. The GPU helpers enable Intel ANV's video decode extensions. On drivers without AV1 film grain synthesis, the FFmpeg patch lets clips without film grain use Vulkan and leaves clips that need film grain eligible for software fallback.

To check support, open `about:support` in Ladybird. On Intel, check the Video engine in `intel_gpu_top` during playback to confirm hardware use for a specific clip.

To opt out, add `www-client/ladybird-bin -vulkan-video` to `/etc/portage/package.use`. This keeps the upstream bundled libraries and uses system FFmpeg for H.264, HEVC, and AAC.

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
