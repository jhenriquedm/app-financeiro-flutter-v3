# 💰 Money Wise - App Financeiro Flutter

Aplicativo de controle financeiro desenvolvido em **Flutter**, com foco em gerenciamento de receitas e despesas, persistência local de dados e aplicação do padrão arquitetural **MVVM (Model-View-ViewModel)**.

O projeto evoluiu de um protótipo de interface para uma aplicação funcional, utilizando **SQLite**, **Provider** e **Flutter Web**, permitindo cadastro de usuários, autenticação local e gerenciamento financeiro reativo.

---

# 🚀 Funcionalidades

### ✅ Autenticação de Usuário

* Cadastro de usuário com:

  * Nome
  * E-mail
  * Senha
* Login funcional conectado ao SQLite
* Persistência do usuário cadastrado

### ✅ Controle Financeiro

* Cadastro de transações
* Edição de transações
* Exclusão de transações
* Listagem automática

### ✅ Dashboard Financeiro

* Saldo atualizado automaticamente
* Total de receitas
* Total de despesas
* Resumo financeiro visual

### ✅ Análise Financeira

* Percentual de despesas por categoria
* Indicadores financeiros
* Resumo consolidado das despesas

### ✅ Recursos Extras

* Máscara monetária brasileira (`R$ 0,00`)
* Persistência local com SQLite
* Atualização reativa utilizando Provider
* Modal interno para adicionar/editar transações
* Scroll vertical responsivo
* Validação de formulários

---

# 🏗 Arquitetura do Projeto

O projeto foi estruturado utilizando **MVVM (Model-View-ViewModel)**:

```txt
Model → Estrutura dos dados
View → Interface do usuário
ViewModel → Lógica de negócio e gerenciamento de estado
```

Tecnologias utilizadas:

* **Flutter**
* **Dart**
* **SQLite (sqflite)**
* **Provider**
* **MVVM**
* **Flutter Web**
* **GitHub Codespaces**

---

# 🚀 Como executar o projeto (PASSO A PASSO COMPLETO)

## 🌐 Executar pelo GitHub Codespaces

> Não é necessário instalar nada localmente no computador.

---

## 🔹 Passo 1: Criar o Codespace

1. Clique no botão verde **"Code"**
2. Vá até a aba **"Codespaces"**
3. Clique em:

```txt
Create codespace on main
```

⏳ Aguarde o ambiente abrir (pode levar alguns minutos).

---

## 🔹 Passo 2: Abrir o Terminal

No Codespaces:

```txt
Terminal → New Terminal
```

---

## 🔹 Passo 3: Instalar o Flutter

No terminal execute:

```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
```

Depois:

```bash
echo 'export PATH=$HOME/flutter/bin:$PATH' >> ~/.bashrc
```

Em seguida:

```bash
source ~/.bashrc
```

---

## 🔹 Passo 4: Verificar Instalação

Execute:

```bash
flutter doctor
```

Se aparecer:

```txt
[✓] Flutter
```

A instalação está correta.

> Alguns avisos podem aparecer e podem ser ignorados no Codespaces.

---

## 🔹 Passo 5: Habilitar Flutter Web

Execute:

```bash
flutter config --enable-web
```

---

## 🔹 Passo 6: Acessar o Projeto

Entre na pasta do app:

```bash
cd app
```

---

## 🔹 Passo 7: Instalar Dependências

Execute:

```bash
flutter pub get
```

---

## 🔹 Passo 8: Executar o Projeto

### Execução padrão

```bash
flutter run -d web-server
```

### Execução recomendada (Persistência estável)

Para manter os dados persistidos corretamente no navegador, recomenda-se utilizar **porta fixa**:

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

---

## 🔹 Passo 9: Abrir o Sistema

Após executar, vá até a aba:

```txt
Ports
```

Procure a porta utilizada:

```txt
8080
```

Clique com o botão direito:

```txt
Open in Browser
```

ou:

```txt
Abrir no navegador
```

---

# 💾 Persistência dos Dados (Importante)

O aplicativo utiliza **SQLite local no navegador (Flutter Web)**.

Isso significa:

### ✅ Os dados permanecem salvos quando:

* O usuário faz logout;
* A página é recarregada;
* O app é executado novamente utilizando a **mesma URL/porta**.

### ⚠️ Os dados podem ser perdidos quando:

* O Codespace gera uma nova porta dinâmica;
* O aplicativo é executado em outra origem/URL;
* O navegador limpa armazenamento local.

Por isso, recomenda-se utilizar:

```bash
flutter run -d web-server --web-port 8080
```

para manter consistência nos testes.

---

# 📱 Fluxo esperado do aplicativo

Após rodar o projeto, o usuário poderá:

### 1. Criar conta

Cadastrar:

* Nome
* E-mail
* Senha

### 2. Realizar Login

Acessar o sistema utilizando usuário previamente cadastrado.

### 3. Gerenciar transações

* Adicionar receitas
* Adicionar despesas
* Editar transações
* Excluir transações

### 4. Visualizar Dashboard

Consultar:

* Saldo atual
* Receitas
* Despesas
* Transações recentes

### 5. Visualizar Análise Financeira

Consultar:

* Distribuição de gastos por categoria
* Percentuais financeiros
* Resumo consolidado

---

# 📂 Estrutura do Projeto

```txt
lib/
│
├── data/              → SQLite + DAO
├── models/            → Estrutura dos dados
├── utils/             → Configurações auxiliares
├── viewmodels/        → Regras de negócio + Provider
├── views/             → Interfaces do usuário
├── widgets/           → Componentes reutilizáveis
└── main.dart          → Inicialização da aplicação
```

---

# 📌 Observações

* Projeto desenvolvido para fins acadêmicos.
* Não utiliza backend externo.
* Os dados são persistidos localmente via SQLite.
* Arquitetura baseada em **MVVM**.
* Interface baseada em **Material Design**.
* Desenvolvido para execução no **GitHub Codespaces + Flutter Web**.

---

# 👨‍💻 Desenvolvido com Flutter

Projeto acadêmico de **Controle Financeiro (Money Wise)** utilizando Flutter, SQLite, Provider e MVVM.
