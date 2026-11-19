@echo off
title YouTube Music Archiver (Navidrome Standard)
chcp 65001 >nul

:start
cls
echo ========================================================
echo      YouTube Music Archiver (Navidrome Standard)
echo ========================================================
echo.
set "url="
set /p "url=Paste Link YouTube / YT Music (Lagu atau Playlist): "

if "%url%"=="" goto start

echo.
echo [1] M4A  (AAC 128-256kbps - Stream Asli Tanpa Transcode)
echo [2] OPUS (Opus ~160kbps - Stream Asli Efisiensi Tinggi)
echo [3] FLAC (Lossless Container 16-bit/48kHz - Standar Arsip)
echo [4] MP3  (320kbps VBR - Kompatibel Semua Perangkat)
echo.
set "format=1"
set /p "format=Pilih format [1/2/3/4] (Default 1): "

set "base_dir=Navidrome_Downloads"
if not exist "%base_dir%" mkdir "%base_dir%"

echo.
echo Sedang mengunduh, menanamkan metadata penuh, dan membuat struktur folder...
echo.

if "%format%"=="2" (
    yt-dlp -x --audio-format opus ^
        --embed-thumbnail --embed-metadata --embed-subs --sub-langs all ^
        --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1 -vf crop=ih:ih" ^
        --parse-metadata "%%(album,playlist_title,title)s:%%(meta_album)s" ^
        --parse-metadata "%%(artist,uploader)s:%%(meta_album_artist)s" ^
        --parse-metadata "%%(playlist_index&{}|1)s/%%(playlist_count&{}|1)s:%%(meta_track)s" ^
        --parse-metadata "1/1:%%(meta_disc)s" ^
        -o "%base_dir%/[%%(release_date>%%Y.%%m.%%d,upload_date>%%Y.%%m.%%d)s] %%(artist,uploader)s - %%(album,playlist_title,title)s [WEB-%%(ext)S]/%%(playlist_index&{0:02d}|01)s - %%(title)s.%%(ext)s" ^
        "%url%"
) else if "%format%"=="3" (
    yt-dlp -x --audio-format flac ^
        --embed-thumbnail --embed-metadata --embed-subs --sub-langs all ^
        --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1 -vf crop=ih:ih" ^
        --parse-metadata "%%(album,playlist_title,title)s:%%(meta_album)s" ^
        --parse-metadata "%%(artist,uploader)s:%%(meta_album_artist)s" ^
        --parse-metadata "%%(playlist_index&{}|1)s/%%(playlist_count&{}|1)s:%%(meta_track)s" ^
        --parse-metadata "1/1:%%(meta_disc)s" ^
        -o "%base_dir%/[%%(release_date>%%Y.%%m.%%d,upload_date>%%Y.%%m.%%d)s] %%(artist,uploader)s - %%(album,playlist_title,title)s [WEB-%%(ext)S]/%%(playlist_index&{0:02d}|01)s - %%(title)s.%%(ext)s" ^
        "%url%"
) else if "%format%"=="4" (
    yt-dlp -x --audio-format mp3 --audio-quality 0 ^
        --embed-thumbnail --embed-metadata --embed-subs --sub-langs all ^
        --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1 -vf crop=ih:ih" ^
        --parse-metadata "%%(album,playlist_title,title)s:%%(meta_album)s" ^
        --parse-metadata "%%(artist,uploader)s:%%(meta_album_artist)s" ^
        --parse-metadata "%%(playlist_index&{}|1)s/%%(playlist_count&{}|1)s:%%(meta_track)s" ^
        --parse-metadata "1/1:%%(meta_disc)s" ^
        -o "%base_dir%/[%%(release_date>%%Y.%%m.%%d,upload_date>%%Y.%%m.%%d)s] %%(artist,uploader)s - %%(album,playlist_title,title)s [WEB-%%(ext)S]/%%(playlist_index&{0:02d}|01)s - %%(title)s.%%(ext)s" ^
        "%url%"
) else (
    yt-dlp -f "bestaudio[ext=m4a]" ^
        --embed-thumbnail --embed-metadata --embed-subs --sub-langs all ^
        --convert-thumbnails jpg --ppa "ThumbnailsConvertor:-q:v 1 -vf crop=ih:ih" ^
        --parse-metadata "%%(album,playlist_title,title)s:%%(meta_album)s" ^
        --parse-metadata "%%(artist,uploader)s:%%(meta_album_artist)s" ^
        --parse-metadata "%%(playlist_index&{}|1)s/%%(playlist_count&{}|1)s:%%(meta_track)s" ^
        --parse-metadata "1/1:%%(meta_disc)s" ^
        -o "%base_dir%/[%%(release_date>%%Y.%%m.%%d,upload_date>%%Y.%%m.%%d)s] %%(artist,uploader)s - %%(album,playlist_title,title)s [WEB-%%(ext)S]/%%(playlist_index&{0:02d}|01)s - %%(title)s.%%(ext)s" ^
        "%url%"
)

echo.
echo ========================================================
echo Selesai! Cek folder: %base_dir%
echo ========================================================
echo.
pause
goto start
