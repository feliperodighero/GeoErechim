# 🌍 GeoErechim

GeoErechim é um projeto acadêmico inspirado no GeoGuessr, mas focado exclusivamente na cidade de Erechim (RS, Brasil). O jogador explora lugares aleatórios da cidade via Google Street View e tenta adivinhar sua localização no mapa para acumular pontos.

🎮 Um jogo educativo, divertido e voltado para a geografia urbana local.

---
## ✨ Funcionalidades

- Exploração de pontos aleatórios de Erechim via Street View.
- Sistema de pontuação baseado na distância entre o palpite e o local real.
- Exibição de mapa interativo com marcadores e linhas de comparação.
- Ranking por estrelas ⭐ baseado na precisão.
- Suporte a Android (e iOS futuramente).
  
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

### 3. Criar arquivo .env na raiz
```bash
GOOGLE_MAPS_API_KEY=SUA_CHAVE_AQUI
```

### 4. Rodar o emulador ou conectar dispositivo físico

### 5. Executar o app
```bash
flutter run
```

## Checklist para rodar sem erros

1. Flutter configurado corretamente (flutter doctor OK)
2. .env criado com GOOGLE_MAPS_API_KEY
3. flutter pub get rodado
4. Gradle NDK configurado (27.0.12077973)
5. Android/iOS APIs habilitadas no GCP
