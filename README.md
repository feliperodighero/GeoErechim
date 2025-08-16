# GeoErechim

GeoErechim é um projeto de faculdade inspirado no GeoGuessr, mas focado na cidade de Erechim (RS). O app permite que o usuário explore lugares aleatórios na cidade via Street View e tente adivinhar a localização para ganhar pontos.

---

## 📦 Requisitos do Projeto

- Flutter >= 3.10.0
- Dart >= 3.1.0
- Android Studio ou VS Code com Flutter & Dart plugin
- Emulador Android ou dispositivo físico
- Conta no Google Cloud Platform com APIs habilitadas:
  - Maps SDK for Android
  - Maps SDK for iOS
  - Street View API
- Chave de API do Google Maps

---

## 🛠 Configuração do Projeto

### 1. Clonar o repositório
```bash
git clone <URL_DO_REPOSITORIO>
cd geoerechim
```

### 2. Instalar dependências
```bash
flutter pub get
```

### 3. Configurações Android

- Versão do NDK: 27.0.12077973
- Compile SDK: versão usada pelo Flutter (flutter compileSdkVersion)
-Gradle Kotlin DSL (android/app/build.gradle.kts) configurado para ler .env:

```bash
import java.util.Properties
import java.io.File

val localProperties = Properties()
val localPropertiesFile = File(rootProject.projectDir, "local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}

android {
    defaultConfig {
        resValue(
            type = "string",
            name = "google_maps_api_key",
            value = localProperties.getProperty("GOOGLE_MAPS_API_KEY")
        )
    }
}
```

- AndroidManifest.xml:
```bash
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="@string/google_maps_api_key"/>
```

### 4. Configurações iOS

- No arquivo ios/Runner/AppDelegate.swift:


import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey(dotenv.get("GOOGLE_MAPS_API_KEY"))
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

## Estrutura do Projeto

- lib/main.dart: inicializa o app e carrega o .env
- lib/pages/home_page.dart: tela inicial com botão "Jogar"
- lib/pages/game_page.dart: tela do Street View
- lib/utils/generate_random_cordinates.dart: gera coordenadas aleatórias dentro de Erechim
- lib/widgets/custom_buttom.dart: botão customizado

## Checklist para rodar sem erros

1. Flutter configurado corretamente (flutter doctor OK)
2. .env criado com GOOGLE_MAPS_API_KEY
3. flutter pub get rodado
4. Gradle NDK configurado (27.0.12077973)
5. Android/iOS APIs habilitadas no GCP
6. Código modular estruturado conforme lib/pages, lib/widgets, lib/utils
7. Rodar flutter clean antes do primeiro run se alterar .env
