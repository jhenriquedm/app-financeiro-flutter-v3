# 💰 Money Wise

Aplicativo mobile de **controle financeiro pessoal**, desenvolvido em **Flutter**, utilizando **arquitetura MVVM + Riverpod**, persistência local com **SQLite**, autenticação e sincronização em nuvem com **Firebase Authentication** e **Cloud Firestore**, além de consumo de **APIs externas** para exibição de informações do mercado financeiro.

---

## 📌 Sobre o Projeto

O **Money Wise** foi desenvolvido como projeto acadêmico da disciplina de **Desenvolvimento Mobile**, com o objetivo de aplicar conceitos modernos de desenvolvimento de aplicações móveis utilizando Flutter.

O aplicativo permite ao usuário realizar o gerenciamento das suas finanças pessoais, registrando receitas e despesas, acompanhando saldo financeiro, analisando gastos por categoria e acessando informações do mercado financeiro em tempo real.

Além disso, o projeto implementa um modelo **offline-first**, permitindo o funcionamento mesmo sem conexão com a internet.

---

## 🎯 Objetivo do Projeto

Desenvolver um aplicativo mobile moderno, funcional e responsivo, aplicando boas práticas de arquitetura de software, gerenciamento de estado, persistência de dados e integração com serviços em nuvem.

---

## ✨ Funcionalidades

### 🔐 Autenticação

* Cadastro de usuários
* Login com e-mail e senha
* Logout
* Persistência de sessão (`AuthGate`)
* Recuperação automática de sessão
* Autenticação via Firebase Authentication

---

### 💵 Controle Financeiro

* Cadastro de receitas
* Cadastro de despesas
* Edição de transações
* Exclusão de transações
* Histórico de movimentações
* Saldo financeiro atualizado automaticamente
* Controle financeiro por categoria

---

### 📊 Dashboard Inteligente

* Saudação personalizada com nome do usuário
* Saldo atual
* Total de receitas
* Total de despesas
* Histórico recente de transações
* Cards financeiros modernos
* Loading visual com **Shimmer Effect**
* Snackbars personalizadas

---

### 📈 Tela de Análises Financeiras

* Visualização de gastos por categoria
* Indicadores financeiros
* Barras de progresso
* Resumo financeiro completo

---

### 🌎 Mercado Financeiro

Integração com API externa para exibição de:

* Cotação do dólar
* Informações do mercado financeiro
* Atualizações em tempo real

---

### 💡 Dicas Financeiras

Sistema de mensagens financeiras inteligentes exibidas no Dashboard, com:

* Educação financeira
* Organização financeira
* Economia e planejamento
* Reserva de emergência
* Consumo consciente

---

### ☁️ Sincronização em Nuvem

O aplicativo sincroniza automaticamente os dados do usuário utilizando **Cloud Firestore**.

Fluxo de sincronização:

```text
Login
↓
Busca transações no Firestore
↓
Sincroniza com SQLite
↓
Libera Dashboard
```

---

### 📶 Funcionamento Offline (Offline First)

Mesmo sem internet, o aplicativo continua funcionando normalmente.

Fluxo offline:

```text
Sem internet
↓
SQLite local
↓
Dados continuam disponíveis
```

Quando a internet retorna:

```text
Firestore ↔ SQLite
Sincronização automática
```

---

### 👤 Multiusuário

O sistema possui isolamento de dados por usuário.

Cada usuário possui:

* Transações independentes
* Dashboard individual
* Dados sincronizados de forma isolada

Exemplo:

```text
Usuário A
→ vê apenas seus dados

Usuário B
→ vê apenas seus dados
```

---

## 🏗️ Arquitetura Utilizada

O projeto foi desenvolvido utilizando:

### MVVM (Model-View-ViewModel)

Separação de responsabilidades:

### Model

Representação dos dados da aplicação.

### View

Responsável pela interface do usuário.

### ViewModel

Gerencia regras de negócio e estado da aplicação.

### Repository

Camada intermediária entre serviços e persistência.

### Services

Integração com Firebase e APIs externas.

---

## 🧱 Estrutura do Projeto

```text
lib/
│
├── data/
│   ├── repositories/
│   ├── database_helper.dart
│   ├── transaction_dao.dart
│   └── user_dao.dart
│
├── models/
│
├── services/
│   ├── firebase_auth_service.dart
│   ├── firestore_service.dart
│   ├── market_service.dart
│   └── news_service.dart
│
├── viewmodels/
│
├── views/
│   ├── auth/
│   ├── dashboard/
│   └── analysis/
│
├── widgets/
│
└── utils/
```

---

## 🛠️ Tecnologias Utilizadas

### Framework

* Flutter

### Linguagem

* Dart

### Arquitetura

* MVVM

### Gerenciamento de Estado

* Riverpod

### Banco Local

* SQLite

### Banco em Nuvem

* Cloud Firestore

### Autenticação

* Firebase Authentication

### APIs Externas

* HTTP API

### UX/UI

* Shimmer
* Custom Snackbars
* Splash Screen
* Ícone personalizado

---

## 📱 Responsividade

O aplicativo foi desenvolvido para adaptação em diferentes tamanhos de tela:

* Smartphones
* Tablets
* Web

Com layout responsivo e adaptável.

---

## 🎨 Interface

O aplicativo possui interface moderna com:

* Gradientes
* Cards premium
* Sombras suaves
* Componentes responsivos
* Experiência visual moderna

---

## 🚀 Como Executar o Projeto

### 1. Clonar repositório

```bash
git clone URL_DO_REPOSITORIO
```

---

### 2. Entrar na pasta

```bash
cd app
```

---

### 3. Instalar dependências

```bash
flutter pub get
```

---

### 4. Rodar aplicação

### Web

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### Android

```bash
flutter run
```

---

## 📦 Gerar APK Release

```bash
flutter build apk --release --no-tree-shake-icons
```

APK gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔥 Diferenciais do Projeto

* Arquitetura organizada (MVVM)
* Persistência híbrida (SQLite + Firestore)
* Offline-first
* Sincronização automática
* Multiusuário
* Responsividade
* Integração com APIs externas
* Dashboard premium
* Loading moderno (Shimmer)
* Firebase Authentication
* Splash Screen personalizada
* APK Android funcional

---

# Melhorias futuras do Aplicativo (APP)

## Melhorias Visuais e de Experiência do Usuário (UX/UI)

* **Alterar o nome do aplicativo**, adequando a identidade visual e nomenclatura da solução.

* **Adicionar imagem/ilustração na tela de login**, visando melhorar a experiência visual do usuário e reforçar a identidade do aplicativo.

* **Implementar suporte aos modos claro e escuro (Light/Dark Mode)**, permitindo alternância dinâmica entre os temas para melhor experiência de uso e acessibilidade.

* **Implementar personalização de tema do aplicativo**, possibilitando que o usuário altere a cor principal do sistema através das configurações.
  Exemplo:

  * Tema padrão: Azul;
  * Possibilidade de escolha de outras cores pelo usuário (verde, roxo, vermelho, laranja, entre outras).

---

## Regras de Negócio e Funcionalidades

### Tela de Configurações

Adicionar uma **tela de configurações do usuário**, contendo funcionalidades para:

* Edição de dados pessoais;
* Atualização de dados cadastrais;
* Alteração de senha;
* Personalização de temas e aparência do aplicativo;
* Configurações gerais de segurança e conta.

### Encerramento Automático de Sessão

Implementar **expiração automática da sessão após 5 minutos de inatividade do usuário**, visando aumentar a segurança do aplicativo e proteger informações sensíveis.

### Login Inteligente e Persistência de Sessão

Após o encerramento da sessão:

* Armazenar credenciais de autenticação de forma segura em cache/local storage;
* Permitir login rápido com poucos cliques, sem necessidade de redigitar e-mail e senha;
* Implementar suporte à autenticação biométrica:

  * Impressão digital (Fingerprint);
  * Reconhecimento facial (Face ID), quando suportado pelo dispositivo.

### Alternância entre Contas

Adicionar funcionalidade de **troca de contas (Multiaccount)**, disponível:

**Na tela de login:**

* Seleção rápida de contas já autenticadas/salvas no dispositivo.

**Na Dashboard:**

* Opção de:

  * Encerrar sessão (Logout);
  * Retornar para a tela de login;
  * Alternar entre contas cadastradas sem necessidade de novo login manual.

### Versionamento do Aplicativo

Definir e padronizar o **controle de versionamento do aplicativo**, seguindo convenção incremental.

Exemplo:

* v1.1.2
* v1.1.3
* v1.2.0

Seguindo critérios de:

* Correções de bugs (Patch);
* Melhorias e novas funcionalidades (Minor);
* Grandes alterações estruturais (Major).

### Cadastro de Lembretes Financeiros

Adicionar funcionalidade de **cadastro e gerenciamento de lembretes financeiros**, contemplando:

#### Contas a Pagar

* Lembrete para pagamento de boletos;
* Avisos de vencimento de dívidas;
* Programação de pagamentos futuros.

#### Contas a Receber

* Lembretes para cobrança de valores pendentes;
* Alertas de recebimentos futuros;
* Controle de pagamentos aguardando confirmação.

#### Notificações

* Envio de notificações automáticas no dispositivo;
* Alertas prévios antes da data de vencimento;
* Configuração de frequência e antecedência dos lembretes.

---

## 👨‍💻 Desenvolvedor

**José Henrique Dias Moreira**

Projeto acadêmico desenvolvido para a disciplina de **Desenvolvimento Mobile**.

---

## 📄 Licença

Projeto desenvolvido exclusivamente para fins acadêmicos.
