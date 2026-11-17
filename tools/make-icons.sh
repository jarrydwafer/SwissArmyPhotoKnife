#!/bin/sh
# Renders the Android launcher icons: white bold italic Jost on the app's red.
# Needs Google Chrome and sips (macOS). Run from the repo root: sh tools/make-icons.sh
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
RES="$ROOT/android/app/src/main/res"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
RED="#e3120b"
TMP=$(mktemp -d)
cp "$ROOT/www/fonts/jost-latin-italic.woff2" "$TMP/"

# render NAME BOX_CSS FONT_PX  ->  $TMP/NAME.png, 1024 px square, transparent outside the box
render() {
  cat > "$TMP/$1.html" <<HTML
<!doctype html><meta charset="utf-8"><style>
@font-face{font-family:J;font-style:italic;font-weight:100 900;src:url(jost-latin-italic.woff2)}
html,body{margin:0;width:1024px;height:1024px;background:transparent;overflow:hidden}
.b{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;$2}
.t{font:italic 800 $3px/1 J;color:#fff;letter-spacing:-.01em;transform:translateX(-1.5%)}
</style><div class="b"><span class="t">SAPK</span></div>
HTML
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1024,1024 --default-background-color=00000000 --virtual-time-budget=3000 \
    --screenshot="$TMP/$1.png" "file://$TMP/$1.html" >/dev/null 2>&1
}
render foreground "" 210                                                 # adaptive icon layer, text inside the safe zone
render legacy "background:$RED;inset:64px;border-radius:150px" 250       # Android 7 square icon
render round "background:$RED;inset:40px;border-radius:50%" 250          # Android 7 round icon

# density: launcher px (48dp), adaptive layer px (108dp)
for d in mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432; do
  name=${d%%:*}; rest=${d#*:}; icon=${rest%%:*}; layer=${rest#*:}
  dir="$RES/mipmap-$name"; mkdir -p "$dir"
  sips -z "$layer" "$layer" "$TMP/foreground.png" --out "$dir/ic_launcher_foreground.png" >/dev/null
  sips -z "$icon" "$icon" "$TMP/legacy.png" --out "$dir/ic_launcher.png" >/dev/null
  sips -z "$icon" "$icon" "$TMP/round.png" --out "$dir/ic_launcher_round.png" >/dev/null
done
rm -rf "$TMP"
echo "Icons written to $RES/mipmap-*"
