#!/usr/bin/env bash
# Run whisperX on a WAV file and write a matching .txt transcript next to it.

set -Euo pipefail

usage() {
  cat <<'EOF'
Usage: whisperx-transcribe.sh <input.wav>

Runs whisperX with a fixed configuration:
  --model medium
  --language cs
  --device cpu
  --compute_type int8
  --vad_method silero
  --no_align
  --output_format txt

The transcript is written alongside the input WAV using the same base name and
a .txt extension.
EOF
}

main() {
  if [[ $# -ne 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit $([[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && echo 0 || echo 1)
  fi

  local input=$1

  if [[ ! -f "$input" ]]; then
    printf 'whisperx-transcribe: input file not found: %s\n' "$input" >&2
    exit 1
  fi

  case ${input,,} in
    *.wav) ;;
    *)
      printf 'whisperx-transcribe: input must be a WAV file: %s\n' "$input" >&2
      exit 1
      ;;
  esac

  local venv_dir=${WHISPERX_VENV:-"$HOME/whisperx"}
  local whisperx_bin="$venv_dir/bin/whisperx"

  if [[ ! -x "$whisperx_bin" ]]; then
    printf 'whisperx-transcribe: whisperx not found at %s (set WHISPERX_VENV to override)\n' "$whisperx_bin" >&2
    exit 1
  fi

  local input_dir base_name output_path
  input_dir=$(cd "$(dirname "$input")" && pwd)
  base_name=$(basename "${input%.*}")
  output_path="$input_dir/${base_name}.txt"

  printf 'Transcribing %s -> %s\n' "$input" "$output_path"

  "$whisperx_bin" "$input" \
    --model medium \
    --language cs \
    --device cpu \
    --compute_type int8 \
    --vad_method silero \
    --no_align \
    --output_format txt \
    --output_dir "$input_dir"
}

main "$@"
