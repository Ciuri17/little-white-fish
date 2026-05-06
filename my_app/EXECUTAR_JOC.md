# Com Executar el Joc - Instruccions per Dispositiu

## Status ✅

**Compilació exitosa!** El codi de "Little White Fish" s'ha compilat sense errors.

```
✅ Domain Layer completat
✅ Data Layer completat
✅ BLoC & Game Logic completat
✅ UI Pages completat
✅ Flutter compilació exitosa
```

## Per Executar el Joc

Necessites **un dispositiu o emulador**. Tenim 3 opcions:

### Opció 1: Android Emulator (Recomanat - Més fàcil) 📱

#### Pas 1: Instal·lar Android Studio

1. Descarrega Android Studio: https://developer.android.com/studio
2. Instal·la i obri
3. Clic a "Create New Project" (no importa quin template)

#### Pas 2: Crear Virtual Device

1. Android Studio → Tools → Device Manager
2. "Create Device" → Selecciona "Pixel 6" → Clic Next
3. Selecciona "Android 13" (o la versió que ofereixi) → Download si cal
4. Finish → Clic el botó de Play (triangle) per iniciar l'emulador

#### Pas 3: Executar el Joc

Una vegada l'emulador estigui iniciat:

```powershell
cd "c:\Users\jciur\Desktop\Martí\my_app"
C:\flutter\bin\flutter.bat run
```

Flutter detectarà l'emulador i instal·larà el joc automàticament!

---

### Opció 2: iOS Simulator (Si tens Mac) 🍎

```bash
cd c:\Users\jciur\Desktop\Martí\my_app
C:\flutter\bin\flutter.bat run -d macos
```

---

### Opció 3: Dispositiu Android Físic 📲

1. Connecta el telèfon Android al PC per USB
2. Activa "Developer Mode": Settings → About → Toca "Build Number" 7 vegades
3. Settings → Developer Options → Activa "USB Debugging"
4. Aprova la connexió al telèfon
5. Corre:

```powershell
cd "c:\Users\jciur\Desktop\Martí\my_app"
C:\flutter\bin\flutter.bat devices
```

Si veu el teu dispositiu:

```powershell
C:\flutter\bin\flutter.bat run
```

---

### Opció 4: Windows Desktop (Experimental) 💻

Si vols executar directament en Windows:

```powershell
cd "c:\Users\jciur\Desktop\Martí\my_app"
C:\flutter\bin\flutter.bat create .
C:\flutter\bin\flutter.bat run -d windows
```

---

## Verificar Dispositius Disponibles

```powershell
cd "c:\Users\jciur\Desktop\Martí\my_app"
C:\flutter\bin\flutter.bat devices
```

Output exemple si hi ha un emulador:

```
Found 1 connected device:
Pixel 6 (emulator-5554) • emulator-5554 • android-arm64  • Android 13 (API 33)
```

---

## Quan s'Executi el Joc

### Pantalla 1: Menú

- 🐟 "Little White Fish"
- "Best Score: 0"
- Botó PLAY blanc
- Settings (Sound, Language)

### Pantalla 2: Joc

- Peix blanc al centre
- Fons gradient blau (bioma shallow)
- Botigues pujant (parallax)
- Score: 0, Depth: 0m

### Controls

- **Mantenir tapat** = Peix puja
- **Deixar d'apredir** = Peix cau
- **Xics** = Pausa/Reprendre

### Objectius

- Evita obstacles (coral, mines, meduses, depredadors)
- Recull les esferes grogues (+10 punts)
- Sobreviu el màxim temps possible
- Desbloqueja els biomes: Shallow → Twilight → Abyss

---

## Solucionar Problemes

### "No supported devices connected"

**Solució:** Necessites configurar un emulador (Opció 1) o connectar un dispositiu (Opció 3)

### "Flutter not found"

**Solució:**

```powershell
C:\flutter\bin\flutter.bat --version
```

Si funciona, el Flutter està correctament localitzat a `C:\flutter`

### El joc es bloqueja al iniciar

**Solució:**

```powershell
C:\flutter\bin\flutter.bat clean
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat run
```

### Android Emulator no s'inicia

**Solució:** Necessita CPU virtua habilitada (nested virtualization):

- Windows: Activa Hyper-V
  1. Dreta a This PC → Manage
  2. Local Users → Groups
  3. Assegura't que l'usuari está a "Hyper-V Administrators"
  4. Reinicia

---

## Info Tècnica

```
App: Little White Fish
Engine: Flutter 3.41.9
Architecture: Clean Architecture + BLoC
Game Loop: 60 FPS
Physics: Gravity-based underwater movement
Plataformes Suportades: Android, iOS, Windows, Web
```

---

## Properes Passes (Després de jugar)

1. **Provar la gameplay** - Com es sent el peix? Els obstacles són prou difícils?
2. **Personalitzar** - Canviar colors, física, dificultats
3. **Afegir sons** - Integrar audio manager
4. **Afegir efectes** - Particle system, screen shake
5. **Publicar** - Build APK per a Google Play

---

## Comandos Útils

```powershell
# Llançar amb debugging verbose
C:\flutter\bin\flutter.bat run -v

# Llançar en mode release (més ràpid)
C:\flutter\bin\flutter.bat run --release

# Build APK final
C:\flutter\bin\flutter.bat build apk --release

# Neteja i reconstrueix
C:\flutter\bin\flutter.bat clean
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat run

# Veure logs del dispositiu
C:\flutter\bin\flutter.bat logs
```

---

## ¿Necessites Ajuda?

Si tens problemes:

1. Executa `flutter doctor` per diagnòstic complet
2. Verifica que Java JDK estigui instal·lat (necessari per Android)
3. Comprova que Android SDK estigui configurat correctament

```powershell
C:\flutter\bin\flutter.bat doctor
```

---

**Estàs preparat per jugar!** 🎮

Primer pas: **Configura l'Android Emulator** (Opció 1 és la més senzilla)
Segon pas: **Executa `flutter run`**
Tercer pas: **Diverteix-te!** 🐠
