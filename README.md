# ☁️ Seu Clima Hoje

Aplicativo em **Flutter** para visualizar o clima atual de forma simples e rápida, direto no celular ou em outras plataformas suportadas pelo Flutter.

A ideia do projeto é ser um app de consulta de clima, onde o usuário consegue ver as principais informações de tempo (como temperatura e condições climáticas) de forma organizada.

---

## 🎯 Objetivo do projeto

O **Seu Clima Hoje** foi pensado para:

- Praticar desenvolvimento mobile com **Flutter**;
- Trabalhar consumo de **API externa de clima**;
- Organizar um projeto Flutter multi-plataforma (Android, iOS, Web e Desktop);
- Servir como base para evoluções futuras (mais detalhes de clima, previsão, temas, etc.).

---

## ✨ Funcionalidades (atuais / previstas)

> Dependendo do estado atual do repositório, algumas funcionalidades podem ainda estar em desenvolvimento.

- 🌡️ Exibir informações básicas de clima de uma cidade ou localidade;
- 🌍 Suporte a múltiplas plataformas (Android, iOS, Web, Desktop);
- 🧱 Estrutura inicial de app Flutter preparada para evoluir:
  - Organização do código em `lib/`;
  - Configurações padrão de `pubspec.yaml`;
  - Pastas de plataforma já geradas pelo Flutter.

---

## 🧰 Tecnologias utilizadas

- **Flutter**
- **Dart**

Suporte gerado pelo Flutter para:

- Android (`android/`)
- iOS (`ios/`)
- Web (`web/`)
- Linux (`linux/`)
- macOS (`macos/`)
- Windows (`windows/`)

---

## 📁 Estrutura do projeto

Estrutura básica do repositório:

    Seu-Clima-Hoje/
    ├── android/              # Projeto nativo Android gerado pelo Flutter
    ├── ios/                  # Projeto nativo iOS gerado pelo Flutter
    ├── web/                  # Entrypoint e assets para rodar no navegador
    ├── linux/                # Suporte a desktop Linux
    ├── macos/                # Suporte a desktop macOS
    ├── windows/              # Suporte a desktop Windows
    ├── lib/
    │   └── main.dart         # Ponto de entrada do aplicativo Flutter
    ├── test/                 # Testes de unidade/widget (padrão Flutter)
    ├── pubspec.yaml          # Dependências, nome do app e configurações gerais
    ├── pubspec.lock
    ├── analysis_options.yaml # Regras de análise estática (lint)
    ├── .gitignore
    └── README.md

> À medida que novas telas, widgets e lógicas forem sendo criadas, a pasta `lib/` pode ser organizada em subpastas como `pages/`, `widgets/`, `services/`, etc.

---

## 🛠 Pré-requisitos

Antes de rodar o projeto, você precisa ter:

- **Flutter SDK** instalado e configurado;
- **Dart** (já vem com o Flutter);
- Um emulador ou dispositivo físico (Android/iOS) ou ambiente para Web/Desktop.

Verifique o ambiente com:

    flutter doctor

---

## 🚀 Como rodar o projeto

No diretório do projeto, execute:

    # Atualizar dependências
    flutter pub get

    # Rodar no dispositivo/emulador padrão
    flutter run

Para rodar em plataformas específicas:

    # Android
    flutter run -d android

    # Web
    flutter run -d chrome

    # Linux / macOS / Windows (se configurado)
    flutter run -d linux
    flutter run -d macos
    flutter run -d windows

---

## 📌 Possíveis próximos passos

Algumas ideias para evoluir o **Seu Clima Hoje**:

- Buscar clima baseado na **localização atual** do usuário (geolocalização);
- Permitir buscar clima por **nome da cidade**;
- Exibir mais detalhes:
  - Umidade;
  - Velocidade do vento;
  - Sensação térmica;
- Adicionar **previsão dos próximos dias**;
- Tratar estados de **carregando**, **erro** e **sem conexão** de forma amigável;
- Aplicar um design mais elaborado com base em condições de clima (dias chuvosos, ensolarados etc.).

---

## 👨‍💻 Autor

**Diogo Arthur Gulhak**

Desenvolvedor de Software focado em **Flutter/Dart**, desenvolvimento mobile e boas práticas de arquitetura.

- GitHub: [@Kadjow](https://github.com/Kadjow)
- LinkedIn: [Diogo Arthur Gulhak](https://www.linkedin.com/in/diogo-arthur-gulhak-0bbaa0273/)
