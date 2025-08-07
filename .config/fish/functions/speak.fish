function speak
    set -l lang "en-us"
    set -l pitch 50
    set -l speed 175
    set -l engine "gtts"
    set -l random 0

    argparse --name=speak 'l/lang=' 'p/pitch=' 's/speed=' 'e/engine=' 'r/random' -- $argv
    or return 1

    if set -q _flag_lang
        set lang $_flag_lang
    end

    if set -q _flag_pitch
        set pitch $_flag_pitch
    end

    if set -q _flag_speed
        set speed $_flag_speed
    end

    if set -q _flag_engine
        set engine $_flag_engine
    end

    if set -q _flag_random
        set random 1
    end

    # Supported languages for gTTS (partial list)
    set -l gtts_langs en us en-us en-gb fr de es it ru ja ko zh

    # Supported espeak voices (partial)
    set -l espeak_voices en en-us en-gb fr de es it ru ja

    # Detect platform and set temp directory
    set -l temp_dir
    if test -d /data/data/com.termux
        # Termux environment
        set temp_dir "$TMPDIR"
        if test -z "$temp_dir"
            set temp_dir "$HOME/tmp"
            mkdir -p "$temp_dir"
        end
    else
        # Regular Linux/Unix
        set temp_dir "/tmp"
    end

    # Pick random lang/voice if requested
    if test $random -eq 1
        if test "$engine" = "gtts"
            if type -q shuf
                set lang (printf "%s\n" $gtts_langs | shuf -n1)
            else
                # Fallback for systems without shuf
                set lang (printf "%s\n" $gtts_langs | sort -R | head -n1)
            end
        else if test "$engine" = "espeak"
            if type -q shuf
                set lang (printf "%s\n" $espeak_voices | shuf -n1)
            else
                set lang (printf "%s\n" $espeak_voices | sort -R | head -n1)
            end
        end
        echo "🎲 Random voice/language chosen: $lang"
    end

    # Read input text robustly
    set -l text ""
    if not isatty stdin
        while read -l line
            set text "$text
$line"
        end
        set text (string trim -- $text | string join ' ')
    else if test (count $argv) -gt 0
        set text (string join ' ' $argv)
    end

    if test -z "$text"
        echo "Usage: speak [-l lang] [-p pitch] [-s speed] [-e gtts|espeak] [-r] 'text to speak'"
        echo "       echo 'hello' | speak"
        echo ""
        echo "Available engines:"
        if type -q python3
            echo "  - gtts (requires: pip install gtts)"
        end
        if type -q espeak
            echo "  - espeak"
        end
        return 1
    end

    if test "$engine" = "gtts"
        # Check if required tools are available
        if not type -q python3
            echo "Error: python3 not found. Install with: pkg install python (Termux) or your system package manager"
            return 1
        end
        
        if not python3 -c "import gtts" 2>/dev/null
            echo "Error: gTTS module not found. Install with: pip install gtts"
            return 1
        end

        # Create temp files with proper error checking
        set tmpfile (mktemp "$temp_dir/speak-output-XXXXXX.mp3")
        set txtfile (mktemp "$temp_dir/speak-text-XXXXXX.txt")
        
        if test -z "$tmpfile" -o -z "$txtfile"
            echo "Error: Failed to create temporary files in $temp_dir"
            return 1
        end
        
        echo "$text" > "$txtfile"
        
        python3 -c "
from gtts import gTTS
import sys
try:
    with open('$txtfile', 'r', encoding='utf-8') as f:
        t = f.read()
    tts = gTTS(text=t, lang='$lang')
    tts.save('$tmpfile')
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
"
        if test $status -eq 0
            # Try different audio players based on availability
            if type -q mpv
                mpv --really-quiet "$tmpfile"
            else if type -q play
                play "$tmpfile"
            else
                echo "No audio player found. Install mpv or sox"
                echo "Audio file saved at: $tmpfile (not cleaned up for manual playback)"
                rm -f "$txtfile"
                return 1
            end
        else
            echo "Error: Failed to generate speech"
            rm -f "$txtfile" "$tmpfile"
            return 1
        end
        
        rm -f "$txtfile" "$tmpfile"
    else if test "$engine" = "espeak"
        if not type -q espeak
            echo "Error: espeak not found. Install with: pkg install espeak (Termux) or your system package manager"
            return 1
        end
        espeak -v "$lang" -p "$pitch" -s "$speed" "$text"
    else
        echo "Error: Unknown engine '$engine'. Available engines: gtts, espeak"
        return 1
    end
end

