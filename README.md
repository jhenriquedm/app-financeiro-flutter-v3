💰 App Financeiro Flutter (Money Wise)

Aplicativo de controle financeiro desenvolvido em **Flutter**, com foco em organização de dados, visualização de transações e aplicação do padrão arquitetural **MVVM (Model-View-ViewModel)**.

---
🚀 Como executar o projeto (PASSO A PASSO COMPLETO)

🌐 Executar pelo GitHub Codespaces
👉 Não precisa instalar nada no computador.

🔹 Passo 1: Criar o Codespace

    Clique no botão verde "Code"

    Vá até a aba "Codespaces"

    Clique em "Create codespace on main"
    
⏳ Aguarde o ambiente abrir (Pode levar alguns monutos)

---
🔹 Passo 2: Abrir o terminal

    No Codespace, vá em: Terminal 
---
🔹 Passo 3: Instalar o Flutter

    No terminal, execute:
    
    git clone https://github.com/flutter/flutter.git -b stable ~/flutter 
    
    Depois:

    echo 'export PATH=$HOME/flutter/bin:$PATH' >> ~/.bashrc
---
🔹 Passo 4: Verificar instalação

    flutter doctor
    
    ✔ Se aparecer [✓] Flutter, está correto (Ignorar os erros que aparecerem no terminal)
---
🔹 Passo 5: Habilitar Web

    flutter config --enable-web
---
🔹 Passo 6: Acessar o projeto

    cd app
---

🔹 Passo 8: Instalar dependências

    flutter pub get
---
🔹 Passo 9: Rodar o projeto

    flutter run -d web-server
---
🔹 Passo 9: Abrir o sistema

    Vá na aba "Ports"
    Procure o link que contenha a porta indicada no terminal
    Botão direito do mouse (Clique em "Open in Browser" ou Abrir no navegador)
---
📌 Observações

* O projeto utiliza dados simulados (não possui backend)
* A funcionalidade de adicionar transação está em desenvolvimento (simulada)
* O foco do projeto é a **interface e arquitetura (MVVM)**

---
📷 Execução esperada

Após rodar o projeto, o usuário poderá:

1. Acessar a tela de login
2. Navegar para o dashboard
3. Visualizar dados financeiros
4. Acessar a tela de análise
