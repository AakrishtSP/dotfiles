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

    # Pick random lang/voice if requested
    if test $random -eq 1
        if test "$engine" = "gtts"
            set lang (printf "%s\n" $gtts_langs | shuf -n1)
        else if test "$engine" = "espeak"
            set lang (printf "%s\n" $espeak_voices | shuf -n1)
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
        return 1
    end

    if test "$engine" = "gtts"
        set tmpfile (mktemp /tmp/speak-output-XXXXXX.mp3)
        set txtfile (mktemp /tmp/speak-text-XXXXXX.txt)
        echo "$text" > $txtfile
        python3 -c "
from gtts import gTTS
with open('$txtfile', 'r', encoding='utf-8') as f:
    t = f.read()
tts = gTTS(text=t, lang='$lang')
tts.save('$tmpfile')
" && mpv --really-quiet "$tmpfile"
        rm -f $txtfile $tmpfile
    else if test "$engine" = "espeak"
        espeak -v "$lang" -p "$pitch" -s "$speed" "$text"
    else
        echo "Unknown engine: $engine. Use 'gtts' or 'espeak'."
        return 1
    end
end

