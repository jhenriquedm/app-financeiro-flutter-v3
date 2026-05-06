💰 App Financeiro Flutter (Money Wise)

Aplicativo de controle financeiro desenvolvido em **Flutter**, com foco em organização de dados, visualização de transações e aplicação do padrão arquitetural **MVVM (Model-View-ViewModel)**.

---

# 📱 Funcionalidades

O aplicativo é composto por três telas principais:

## 🔐 Tela de Login/Cadastro

* Permite entrada de usuário (interface simulada)
* Alternância entre **Login** e **Cadastro**
* Layout responsivo e centralizado

---

## 📊 Dashboard (Tela Principal)

* Exibe:

  * Saldo atual
  * Total de receitas
  * Total de despesas
* Lista de transações recentes
* Indicadores visuais por categoria
* Botão para adicionar transação (simulado)
* Navegação para tela de análise

---

## 📈 Tela de Análise

* Visão detalhada dos dados financeiros
* Exibe:

  * Saldo atual
  * Receitas e despesas
* Gráfico simples por categoria (barra de progresso)
* Lista analítica de gastos

---

# 🏗️ Arquitetura

O projeto segue o padrão **MVVM**:

```
lib/
 ├── models/        → Estrutura dos dados
 ├── viewmodels/    → Lógica e regras de negócio
 ├── views/         → Interface do usuário
 └── utils/         → Utilitários (cores, etc.)
```

---

# 🚀 Como Executar o Projeto

## 📌 Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

* Flutter SDK
* Git
* Navegador (Google Chrome recomendado)

---

## 🔽 1. Clonar o repositório

Abra o terminal e execute:

```
git clone https://github.com/jhenriquedm/app-financeiro-flutter.git
```

---

## 📁 2. Acessar a pasta do projeto

```
cd app-financeiro-flutter/app
```

---

## 📦 3. Instalar dependências

```
flutter pub get
```

---

## ▶️ 4. Executar o projeto

### Opção 1 — Web (RECOMENDADO)

```
flutter run -d chrome
```

Caso não tenha Chrome configurado:

```
flutter run -d web-server
```

E acesse o link exibido no terminal (ex: [http://localhost:xxxx](http://localhost:xxxx))

---

## 🔄 5. Comandos úteis durante execução

```
r  → Atualiza a tela (Hot Reload)
R  → Reinicia o app
q  → Encerra execução
```

---

# 📌 Observações Importantes

* O projeto utiliza dados simulados (não possui backend)
* A funcionalidade de adicionar transação está em desenvolvimento (simulada)
* O foco do projeto é a **interface e arquitetura (MVVM)**

---

# 📷 Execução Esperada

Após rodar o projeto, o usuário poderá:

1. Acessar a tela de login
2. Navegar para o dashboard
3. Visualizar dados financeiros
4. Acessar a tela de análise
