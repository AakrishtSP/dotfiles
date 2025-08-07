function speak --description "Text-to-speech utility with multiple engines"
    set -l lang "en-us"
    set -l pitch 50
    set -l speed 175
    set -l engine "auto"
    set -l random 0
    set -l volume 100
    set -l list_voices 0
    set -l list_langs 0
    set -l output_file ""
    set -l help 0

    argparse --name=speak \
        'h/help' \
        'l/lang=' \
        'p/pitch=' \
        's/speed=' \
        'v/volume=' \
        'e/engine=' \
        'o/output=' \
        'r/random' \
        'list-voices' \
        'list-langs' \
        -- $argv
    or return 1

    # Handle help flag
    if set -q _flag_help
        set help 1
    end

    if set -q _flag_lang
        set lang $_flag_lang
    end

    if set -q _flag_pitch
        set pitch $_flag_pitch
    end

    if set -q _flag_speed
        set speed $_flag_speed
    end

    if set -q _flag_volume
        set volume $_flag_volume
    end

    if set -q _flag_engine
        set engine $_flag_engine
    end

    if set -q _flag_output
        set output_file $_flag_output
    end

    if set -q _flag_random
        set random 1
    end

    if set -q _flag_list_voices
        set list_voices 1
    end

    if set -q _flag_list_langs
        set list_langs 1
    end

    # Comprehensive language lists
    set -l gtts_langs en en-us en-gb en-au en-ca en-in fr fr-ca de es es-es es-mx it pt pt-br ru ja ko zh zh-cn zh-tw ar hi nl sv da no fi pl tr cs hu ro bg hr sk sl et lv lt el he th vi id ms tl fil uk be mk ka hy az kk ky uz mn ne bn gu ta te kn ml si my km lo ka
    
    set -l espeak_voices en en-us en-gb en-au en-ca en-in fr de es es-mx it pt pt-br ru ja ko zh ar hi nl sv da no fi pl tr cs hu ro bg hr sk sl et lv lt el he th vi id ms uk be mk ka hy az kk ky uz mn ne bn gu ta te kn ml si my km lo

    # Detect platform and available engines
    set -l is_termux 0
    set -l available_engines
    
    if test -d /data/data/com.termux
        set is_termux 1
    end

    # Auto-detect best available engine
    if test "$engine" = "auto"
        if test $is_termux -eq 1; and type -q termux-tts-speak
            set engine "termux"
        else if type -q python3; and python3 -c "import gtts" 2>/dev/null
            set engine "gtts"
        else if type -q espeak
            set engine "espeak"
        else if type -q say
            set engine "say"
        else
            set engine "none"
        end
    end

    # Build list of available engines
    if test $is_termux -eq 1; and type -q termux-tts-speak
        set available_engines $available_engines "termux"
    end
    if type -q python3; and python3 -c "import gtts" 2>/dev/null
        set available_engines $available_engines "gtts"
    end
    if type -q espeak
        set available_engines $available_engines "espeak"
    end
    if type -q say
        set available_engines $available_engines "say"
    end

    # Show help
    if test $help -eq 1
        echo "speak - Text-to-speech utility with multiple engines"
        echo ""
        echo "USAGE:"
        echo "    speak [OPTIONS] 'text to speak'"
        echo "    echo 'text' | speak [OPTIONS]"
        echo ""
        echo "OPTIONS:"
        echo "    -h, --help           Show this help message"
        echo "    -l, --lang LANG      Set language/voice (default: en-us)"
        echo "    -p, --pitch NUM      Set pitch 0-100 (default: 50, espeak only)"
        echo "    -s, --speed NUM      Set speed in WPM (default: 175, espeak only)"
        echo "    -v, --volume NUM     Set volume 0-100 (default: 100)"
        echo "    -e, --engine ENGINE  Use specific engine: auto|gtts|espeak|termux|say"
        echo "    -o, --output FILE    Save to audio file instead of playing"
        echo "    -r, --random         Use random voice/language"
        echo "    --list-voices        List available voices for current engine"
        echo "    --list-langs         List available languages for current engine"
        echo ""
        echo "ENGINES:"
        if contains "termux" $available_engines
            echo "    termux    - Android TTS (Termux only, best quality)"
        end
        if contains "gtts" $available_engines
            echo "    gtts      - Google Text-to-Speech (requires internet)"
        end
        if contains "espeak" $available_engines
            echo "    espeak    - eSpeak synthesizer (offline)"
        end
        if contains "say" $available_engines
            echo "    say       - macOS built-in TTS"
        end
        echo "    auto      - Auto-select best available engine (default)"
        echo ""
        echo "EXAMPLES:"
        echo "    speak 'Hello world'"
        echo "    speak -e espeak -l en-gb 'British accent'"
        echo "    speak -r 'Random voice'"
        echo "    echo 'Long text' | speak -o speech.mp3"
        echo "    speak --list-langs"
        echo ""
        echo "AVAILABLE ENGINES: "(string join ", " $available_engines)
        return 0
    end

    # List voices
    if test $list_voices -eq 1
        echo "Available voices for engine '$engine':"
        switch $engine
            case "gtts"
                printf "%s\n" $gtts_langs | column -c 80
            case "espeak"
                if type -q espeak
                    espeak --voices | head -20
                else
                    printf "%s\n" $espeak_voices | column -c 80
                end
            case "termux"
                if type -q termux-tts-speak
                    echo "Termux uses system TTS voices. Check Android TTS settings."
                else
                    echo "Termux TTS not available"
                end
            case "say"
                if type -q say
                    say -v '?'
                else
                    echo "macOS say command not available"
                end
            case '*'
                echo "Unknown engine: $engine"
        end
        return 0
    end

    # List languages
    if test $list_langs -eq 1
        echo "Available languages for engine '$engine':"
        switch $engine
            case "gtts"
                printf "%s\n" $gtts_langs | column -c 80
            case "espeak"
                printf "%s\n" $espeak_voices | column -c 80
            case "termux"
                echo "Termux supports system languages. Check Android TTS settings."
            case "say"
                echo "macOS say supports system voices. Use 'speak --list-voices' to see available voices."
            case '*'
                echo "Unknown engine: $engine"
        end
        return 0
    end

    # Detect platform and set temp directory
    set -l temp_dir
    if test $is_termux -eq 1
        # Termux environment
        set temp_dir "$TMPDIR"
        if test -z "$temp_dir"
            set temp_dir "$HOME/tmp"
            mkdir -p "$temp_dir"
        end
    else if test (uname) = "Darwin"
        # macOS
        set temp_dir (getconf DARWIN_USER_TEMP_DIR 2>/dev/null)
        if test -z "$temp_dir"
            set temp_dir "/tmp"
        end
    else
        # Regular Linux/Unix
        set temp_dir "/tmp"
    end

    # Validate engine
    if test "$engine" = "none"
        echo "Error: No TTS engine available!"
        echo "Install one of the following:"
        echo "  - Termux: pkg install termux-api"
        echo "  - gTTS: pip install gtts"
        echo "  - eSpeak: pkg install espeak (Termux) or apt install espeak (Linux)"
        return 1
    end

    if not contains "$engine" $available_engines
        echo "Error: Engine '$engine' not available."
        echo "Available engines: "(string join ", " $available_engines)
        echo "Use 'speak --help' for more information."
        return 1
    end

    # Pick random lang/voice if requested
    if test $random -eq 1
        switch $engine
            case "gtts"
                if type -q shuf
                    set lang (printf "%s\n" $gtts_langs | shuf -n1)
                else
                    set lang (printf "%s\n" $gtts_langs | sort -R | head -n1)
                end
            case "espeak"
                if type -q shuf
                    set lang (printf "%s\n" $espeak_voices | shuf -n1)
                else
                    set lang (printf "%s\n" $espeak_voices | sort -R | head -n1)
                end
            case "say"
                if type -q say
                    set lang (say -v '?' | awk '{print $1}' | shuf -n1 2>/dev/null || say -v '?' | awk '{print $1}' | head -n1)
                end
            case "termux"
                echo "🎲 Random voice selection not supported for Termux engine"
        end
        echo "🎲 Random voice/language chosen: $lang"
    end

    # Read input text robustly
    set -l text ""
    if not isatty stdin
        # Read from pipe/stdin
        set text (cat | string collect)
        set text (string trim -- $text)
    else if test (count $argv) -gt 0
        # Read from arguments
        set text (string join ' ' $argv)
    end

    # Validate text input
    if test -z "$text"
        echo "Error: No text provided to speak"
        echo "Usage: speak [OPTIONS] 'text to speak'"
        echo "       echo 'text' | speak [OPTIONS]"
        echo "Use 'speak --help' for full documentation."
        return 1
    end

    # Validate numeric parameters
    if not string match -qr '^\d+$' "$pitch"
        echo "Error: Pitch must be a number (0-100)"
        return 1
    end
    if not string match -qr '^\d+$' "$speed"
        echo "Error: Speed must be a number (words per minute)"
        return 1
    end
    if not string match -qr '^\d+$' "$volume"
        echo "Error: Volume must be a number (0-100)"
        return 1
    end

    # Clamp values to reasonable ranges
    if test $pitch -lt 0; set pitch 0; end
    if test $pitch -gt 100; set pitch 100; end
    if test $speed -lt 50; set speed 50; end
    if test $speed -gt 500; set speed 500; end
    if test $volume -lt 0; set volume 0; end
    if test $volume -gt 100; set volume 100; end

    # Engine implementations
    switch $engine
        case "termux"
            if not type -q termux-tts-speak
                echo "Error: termux-tts-speak not found. Install with: pkg install termux-api"
                return 1
            end
            echo "🔊 Speaking with Termux TTS..."
            termux-tts-speak "$text"

        case "gtts"
            if not type -q python3
                echo "Error: python3 not found. Install with: pkg install python (Termux) or your system package manager"
                return 1
            end
            
            if not python3 -c "import gtts" 2>/dev/null
                echo "Error: gTTS module not found. Install with: pip install gtts"
                return 1
            end

            echo "🔊 Generating speech with Google TTS (lang: $lang)..."

            # Create temp files with proper error checking
            set tmpfile (mktemp "$temp_dir/speak-output-XXXXXX.mp3")
            set txtfile (mktemp "$temp_dir/speak-text-XXXXXX.txt")
            
            if test -z "$tmpfile" -o -z "$txtfile"
                echo "Error: Failed to create temporary files in $temp_dir"
                return 1
            end
            
            echo "$text" > "$txtfile"
            
            # Generate speech with better error handling
            python3 -c "
from gtts import gTTS
import sys
try:
    with open('$txtfile', 'r', encoding='utf-8') as f:
        text = f.read().strip()
    if not text:
        print('Error: Empty text provided', file=sys.stderr)
        sys.exit(1)
    
    tts = gTTS(text=text, lang='$lang', slow=False)
    tts.save('$tmpfile')
    print('✓ Speech generated successfully')
except Exception as e:
    print(f'Error generating speech: {e}', file=sys.stderr)
    sys.exit(1)
"
            if test $status -ne 0
                echo "Error: Failed to generate speech"
                rm -f "$txtfile" "$tmpfile"
                return 1
            end

            # Handle output file or play audio
            if test -n "$output_file"
                cp "$tmpfile" "$output_file"
                echo "✓ Audio saved to: $output_file"
            else
                # Try different audio players with volume control
                set -l played 0
                if type -q mpv
                    mpv --really-quiet --volume=$volume "$tmpfile"
                    set played 1
                else if type -q play
                    play --volume (math "$volume/100") "$tmpfile"
                    set played 1
                else if type -q ffplay
                    ffplay -nodisp -autoexit -volume $volume "$tmpfile" 2>/dev/null
                    set played 1
                else if test $is_termux -eq 1; and type -q termux-media-player
                    termux-media-player play "$tmpfile"
                    set played 1
                end
                
                if test $played -eq 0
                    echo "No audio player found. Install mpv, sox, or ffmpeg"
                    echo "Audio file saved at: $tmpfile (not cleaned up for manual playback)"
                    rm -f "$txtfile"
                    return 1
                end
            end
            
            rm -f "$txtfile" "$tmpfile"

        case "espeak"
            if not type -q espeak
                echo "Error: espeak not found. Install with: pkg install espeak (Termux) or your system package manager"
                return 1
            end
            
            echo "🔊 Speaking with eSpeak (lang: $lang, pitch: $pitch, speed: $speed)..."
            
            # Build espeak command with options
            set -l espeak_cmd espeak
            set espeak_cmd $espeak_cmd -v "$lang"
            set espeak_cmd $espeak_cmd -p "$pitch"
            set espeak_cmd $espeak_cmd -s "$speed"
            
            # Handle output file
            if test -n "$output_file"
                set espeak_cmd $espeak_cmd -w "$output_file"
                $espeak_cmd "$text"
                echo "✓ Audio saved to: $output_file"
            else
                $espeak_cmd "$text"
            end

        case "say"
            if not type -q say
                echo "Error: say command not found (macOS only)"
                return 1
            end
            
            echo "🔊 Speaking with macOS say (voice: $lang)..."
            
            # Build say command
            set -l say_cmd say
            if test -n "$lang"
                set say_cmd $say_cmd -v "$lang"
            end
            
            # Handle output file
            if test -n "$output_file"
                set say_cmd $say_cmd -o "$output_file"
                $say_cmd "$text"
                echo "✓ Audio saved to: $output_file"
            else
                $say_cmd "$text"
            end

        case '*'
            echo "Error: Unknown engine '$engine'"
            echo "Available engines: "(string join ", " $available_engines)
            return 1
    end

    echo "✓ Speech completed successfully"
end

