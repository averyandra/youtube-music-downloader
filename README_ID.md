# YouTube Music Archiver (Navidrome Ready)

> Another Language / Bahasa lainnya
> [English](README.md)

Skrip otomatisasi berbasis Windows Batch (`.bat`) untuk mengunduh trek audio tunggal (*single track*) maupun album/playlist penuh dari YouTube dan YouTube Music, lengkap dengan injeksi metadata terstruktur, lirik tersinkronisasi (*synchronized lyrics*), dan pemotongan (*cropping*) *cover art* rasio 1:1 untuk kebutuhan server media **Navidrome**.

## Fitur Utama

* **Struktur Direktori Standar Rilis (*Release Naming Convention*):** Otomatis menyusun hierarki direktori dan berkas audio sesuai konvensi pengarsipan pustaka musik:

  ```text
  Navidrome_Downloads/
  └── [YYYY.MM.DD] Artist - Album [WEB-FORMAT]/
      ├── 01 - Track Title.m4a
      └── 02 - Track Title.m4a
  ```

* **Pemetaan Metadata Penuh (*FFmpeg / TagLib Compatible*):**

  * **Album & Album Artist Fallback:** Otomatis mengisi tag `Album` (menggunakan nama album, judul playlist, atau judul trek untuk rilis *single*) dan `AlbumArtist` agar Navidrome tidak memecah entri album atau menampilkan `[Unknown Album]`.

  * **Track & Disc Indexing:** Menanamkan tag `TrackNumber` (`1/1` untuk *single* atau `01/N` untuk playlist) dan `DiscNumber` (`1/1`).

  * **Embedded Lyrics:** Mengekstrak *Closed Captions* / subtitel yang tersedia (`--embed-subs`) ke dalam *tag* lirik berkas audio.

* **Auto-Crop Cover Art (1:1):** Mengonversi *thumbnail* YouTube ke format JPEG kualitas tinggi dan memotong bagian tengah gambar secara otomatis (`crop=ih:ih`) menjadi rasio aspek persegi (*aspect ratio* 1:1).

* **Dukungan Multi-Format & Transcoding:**

  1. **M4A (AAC):** *Stream* asli YouTube tanpa proses *re-encoding* (direkomendasikan untuk efisiensi penyimpanan dan menjaga kualitas sumber).

  2. **OPUS:** *Stream* asli YouTube berbasis kodek Opus (*bitrate* ~160 kbps).

  3. **FLAC:** Kontainer *lossless* (16-bit / 48 kHz) untuk standardisasi pustaka arsip.

  4. **MP3:** VBR (*Variable Bitrate*) kualitas tertinggi (`-q:a 0`, ~245–320 kbps) untuk kompatibilitas perangkat lawas (*legacy devices*).

* **Dukungan Karakter UTF-8 (`chcp 65001`):** Mempertahankan integritas *character encoding* non-Latin (Kanji, Kana, Hangul, Hanzi, maupun diakritik khusus) pada nama berkas (*filename*) dan *tag* metadata.

## Dependensi Sistem

Skrip ini membutuhkan tiga komponen utama yang harus terdaftar di *Environment Variable* (`PATH`) Windows:

| Komponen | Paket Winget | Peran & Fungsi Teknis |
| :--- | :--- | :--- |
| **yt-dlp** | `yt-dlp.yt-dlp` | *Extractor* utama untuk mengambil *audio stream*, informasi rilis, *playlist*, subtitel, dan memetakan variabel metadata (`--parse-metadata`). |
| **FFmpeg & FFprobe** | `yt-dlp.FFmpeg` | Melakukan *container remuxing*, *audio transcoding*, pemotongan rasio *thumbnail* (`crop=ih:ih`), serta injeksi atom/tag metadata (ID3v2, Vorbis Comment, MP4 atoms). |
| **Deno** | `DenoLand.Deno` | JavaScript *runtime* modern yang digunakan oleh `yt-dlp` untuk menyelesaikan tantangan dekripsi pemutar YouTube (*n-challenge / signature deciphering*) guna mencegah *error* HTTP 403 Forbidden. |

## Instalasi Dependensi (Windows)

Buka Command Prompt (CMD) atau PowerShell, lalu jalankan perintah berikut:

```bat
winget install yt-dlp
```

> **Catatan:** Paket `yt-dlp.yt-dlp` di repositori `winget` secara otomatis menyertakan instalasi `DenoLand.Deno` dan `yt-dlp.FFmpeg` sebagai dependensi bawaan.

### Penanganan Error Instalasi Winget (*Troubleshooting*)

Jika `winget` mengalami ketidakcocokan *hash* (*Installer hash does not match*) atau *error* ekstraksi PyInstaller pada `yt-dlp.exe`, unduh dan pasang *binary* rilis terbaru secara langsung ke direktori *root* tempat skrip `.bat` disimpan menggunakan `curl`:

```bat
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -o yt-dlp.exe
```

### Verifikasi Dependensi

Tutup dan buka kembali sesi terminal (*shell*) Anda, lalu pastikan seluruh dependensi dapat dieksekusi oleh sistem:

```bat
yt-dlp --version
ffmpeg -version
deno --version
```

## Prosedur Eksekusi (*Usage*)

1. Simpan kode skrip sebagai `download_navidrome.bat` dengan *character encoding* **UTF-8**.

2. Eksekusi `yt_music_download.bat` (klik dua kali melalui File Explorer atau panggil melalui CLI).

3. Tempel (*paste*) URL video YouTube, album YouTube Music, atau *playlist*, lalu tekan **Enter**.

4. Pilih profil format keluaran (`1`–`4`) atau langsung tekan **Enter** untuk menggunakan konfigurasi *default* (`M4A`).

5. Setelah proses selesai, pindahkan direktori hasil unduhan dari `Navidrome_Downloads/` ke direktori *music library* server Navidrome Anda (misalnya `/srv/navidrome/music/`), lalu jalankan **Full Scan** pada antarmuka web Navidrome untuk memperbarui indeks basis data.

## Maintenance & Pembaruan (*Updates*)

Untuk memperbarui `yt-dlp` dan seluruh dependensinya secara berkala agar tetap kompatibel dengan perubahan *endpoint* API YouTube, jalankan:

```bat
winget upgrade yt-dlp DenoLand.Deno yt-dlp.FFmpeg
```

*(Atau jalankan `yt-dlp -U` jika menggunakan berkas binary `yt-dlp.exe` portabel lokal).*
