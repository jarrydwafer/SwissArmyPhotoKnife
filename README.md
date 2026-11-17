# SwissArmyPhotoKnife

A light meter and shot logbook for film photography. Choose the film ISO and
the lens, point the phone, and read aperture and shutter pairs for the area
your film lens sees. Each shot you log keeps its frame number, time, place,
lens, settings and notes.

It is one web page. It runs in a browser at
[meter.jarrydwafer.com](https://meter.jarrydwafer.com) and as an installed
Android app, which wraps the same page with [Capacitor](https://capacitorjs.com).
The app works offline. Your logbook stays on your phone.

Status: early. The readings are not yet calibrated against a reference meter.

## Layout

| Path | What it is |
|------|------------|
| `www/index.html` | The whole app: markup, styles and script in one file |
| `www/fonts/` | Jost, bundled so the app works offline |
| `android/` | The Android project (Capacitor shell) |
| `android/app/src/main/java/.../ShellPlugin.java` | Save a file, share sheet, keep the screen on |
| `tools/make-icons.sh` | Renders the launcher icons |

There is no build step for the page. Edit `www/index.html` and reload.

## Run it in a browser

```sh
npm run web        # http://localhost:8080
```

The camera needs HTTPS or `localhost`.

## Build the Android app

You need Node 22 or newer, JDK 21 and the Android SDK (platform 36). On a Mac
with Homebrew:

```sh
brew install openjdk@21
brew install --cask android-commandlinetools android-platform-tools
export JAVA_HOME=/opt/homebrew/opt/openjdk@21
export ANDROID_HOME=$HOME/Library/Android/sdk
sdkmanager --sdk_root=$ANDROID_HOME "platforms;android-36" "build-tools;36.0.0"
```

Then:

```sh
npm install
npm run apk        # builds android/app/build/outputs/apk/debug/app-debug.apk
npm run phone      # builds, installs on the phone connected by USB, and opens it
```

For `npm run phone`, turn on USB debugging on the phone (Settings, Developer
options) and accept the prompt when you plug it in.

## Privacy

The logbook, the calibration and the settings are stored on the phone and are
not uploaded. The page loads a [Plausible](https://plausible.io) script from
`stats.jarrydwafer.com` that counts visits and a few events (camera started,
shot saved, logbook exported) without cookies and without your readings,
notes or location. Offline, nothing is sent.

## Licence

Code: [GNU Affero General Public License v3.0 or later](LICENSE).
Jost typeface: SIL Open Font License 1.1, see `www/fonts/OFL.txt`.
