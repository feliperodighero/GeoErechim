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

## Checklist para rodar sem erros

1. Flutter configurado corretamente (flutter doctor OK)
2. .env criado com GOOGLE_MAPS_API_KEY
3. flutter pub get rodado
4. Gradle NDK configurado (27.0.12077973)
5. Android/iOS APIs habilitadas no GCP
