# YouTube Music Archiver (Navidrome Ready)

> Another Language / Bahasa lainnya
> [Bahasa Indonesia](README_ID.md)

A Windows Batch (`.bat`) automation script designed to download single audio tracks as well as full albums/playlists from YouTube and YouTube Music, complete with structured metadata injection, synchronized lyrics, and 1:1 aspect ratio cover art cropping tailored for **Navidrome** media servers.

## Key Features

- **Release Naming Convention Directory Structure:** Automatically organizes directory hierarchies and audio files following standard music library archiving conventions:

  ```text
  Navidrome_Downloads/
  └── [YYYY.MM.DD] Artist - Album [WEB-FORMAT]/
      ├── 01 - Track Title.m4a
      └── 02 - Track Title.m4a
  ```

- **Comprehensive Metadata Mapping (FFmpeg / TagLib Compatible):**
  - **Album & Album Artist Fallback:** Automatically populates the `Album` tag (using the album name, playlist title, or track title for single releases) and `AlbumArtist` so Navidrome does not split album entries or display `[Unknown Album]`.
  - **Track & Disc Indexing:** Embeds `TrackNumber` (`1/1` for singles or `01/N` for playlists) and `DiscNumber` (`1/1`) tags.
  - **Embedded Lyrics:** Extracts available Closed Captions / subtitles (`--embed-subs`) directly into the audio file's lyrics tag.

- **Auto-Crop Cover Art (1:1):** Converts YouTube thumbnails into high-quality JPEG format and automatically center-crops the image (`crop=ih:ih`) into a perfect 1:1 square aspect ratio.

- **Multi-Format & Transcoding Support:**
  1. **M4A (AAC):** Native YouTube audio stream without re-encoding (recommended for storage efficiency and preserving source quality).
  2. **OPUS:** Native YouTube stream utilizing the Opus codec (~160 kbps bitrate).
  3. **FLAC:** Lossless container (16-bit / 48 kHz) for standardized archival libraries.
  4. **MP3:** Highest-quality VBR (Variable Bitrate, `-q:a 0`, ~245–320 kbps) for legacy device compatibility.

- **UTF-8 Character Support (`chcp 65001`):** Preserves non-Latin character encoding integrity (Kanji, Kana, Hangul, Hanzi, as well as special diacritics) across filenames and metadata tags.

## System Dependencies

This script requires three core components to be registered in your Windows System Environment Variables (`PATH`):

| Component | Winget Package | Technical Role & Function |
| :--- | :--- | :--- |
| **yt-dlp** | `yt-dlp.yt-dlp` | Primary extractor responsible for fetching audio streams, release metadata, playlists, subtitles, and mapping metadata variables (`--parse-metadata`). |
| **FFmpeg & FFprobe** | `yt-dlp.FFmpeg` | Handles container remuxing, audio transcoding, thumbnail aspect ratio cropping (`crop=ih:ih`), and metadata atom/tag injection (ID3v2, Vorbis Comment, MP4 atoms). |
| **Deno** | `DenoLand.Deno` | Modern JavaScript runtime utilized by `yt-dlp` to solve YouTube player decryption challenges (n-challenge / signature deciphering) to prevent HTTP 403 Forbidden errors. |

## Dependency Installation (Windows)

Open Command Prompt (CMD) or PowerShell, then execute the following command:

```bat
winget install yt-dlp
```

> **Note:** The `yt-dlp.yt-dlp` package in the `winget` repository automatically bundles `DenoLand.Deno` and `yt-dlp.FFmpeg` as built-in dependencies.

### Winget Installation Troubleshooting

If `winget` encounters a hash mismatch (`Installer hash does not match`) or PyInstaller extraction errors on `yt-dlp.exe`, download and place the latest release binary directly into the root directory where your `.bat` script is located using `curl`:

```bat
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -o yt-dlp.exe
```

### Dependency Verification

Close and reopen your terminal (shell) session, then verify that all dependencies are executable by the system:

```bat
yt-dlp --version
ffmpeg -version
deno --version
```

## Execution Procedure (Usage)

1. Save the script code as `download_navidrome.bat` using **UTF-8** character encoding.
2. Execute `yt_music_download.bat` (double-click via File Explorer or invoke via CLI).
3. Paste the YouTube video, YouTube Music album, or playlist URL, then press **Enter**.
4. Select an output format profile (`1`–`4`) or simply press **Enter** to use the default configuration (`M4A`).
5. Once completed, move the downloaded folder from `Navidrome_Downloads/` to your Navidrome server's music library directory (e.g., `/srv/navidrome/music/`), then trigger a **Full Scan** in the Navidrome web interface to update the database index.

## Maintenance & Updates

To periodically update `yt-dlp` and all its dependencies to maintain compatibility with YouTube API endpoint changes, run:

```bat
winget upgrade yt-dlp DenoLand.Deno yt-dlp.FFmpeg
```

*(Alternatively, run `yt-dlp -U` if using a local portable `yt-dlp.exe` binary).*
