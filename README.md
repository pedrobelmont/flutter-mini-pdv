# Flutter POS

Um aplicativo de Ponto de Venda (POS) moderno e rico em recursos, construído com Flutter. Este projeto visa fornecer uma solução multiplataforma e fácil de usar para pequenas e médias empresas gerenciarem suas vendas e estoque.

## ✨ Recursos Principais

-   **Interface de Vendas Intuitiva:** Uma UI limpa e simples para checkouts rápidos e eficientes.
-   **Gerenciamento de Produtos:** Adicione, edite e categorize produtos facilmente.
-   **Leitura de Código de Barras:** Use a câmera do dispositivo para escanear códigos de barras/QR codes de produtos para vendas mais rápidas.
-   **Geração de Recibos:** Gere recibos em PDF para as transações automaticamente.
-   **Impressão e Compartilhamento:** Imprima recibos diretamente em uma impressora compatível ou compartilhe-os digitalmente.
-   **Gerenciamento de Dados:** Importe e exporte listas de produtos e relatórios de vendas usando arquivos CSV.
-   **Funciona Offline:** Todos os dados são armazenados localmente no dispositivo usando Hive, para que o aplicativo funcione perfeitamente sem conexão com a internet.
-   **Customização:** Use o seletor de cores para personalizar a aparência das categorias de produtos ou outros elementos da UI.

## 🚀 Tecnologias e Dependências

-   **Framework:** [Flutter](https://flutter.dev/)
-   **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider)
-   **Banco de Dados Local:** [Hive](https://pub.dev/packages/hive_ce)
-   **Leitura de Código de Barras:** [mobile_scanner](https://pub.dev/packages/mobile_scanner)
-   **PDF & Impressão:** [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing)
-   **Manipulação de Arquivos:** [file_picker](https://pub.dev/packages/file_picker), [csv](https://pub.dev/packages/csv), [path_provider](https://pub.dev/packages/path_provider)
-   **Compartilhamento:** [share_plus](https://pub.dev/packages/share_plus)

## 🏁 Como Começar

Siga estas instruções para obter uma cópia do projeto em execução em sua máquina local para fins de desenvolvimento e teste.

### Pré-requisitos

Você precisa ter o Flutter SDK instalado em sua máquina. Para instruções, veja a [documentação oficial do Flutter](https://flutter.dev/docs/get-started/install).

### Instalação

1.  **Clone o repositório (substitua pela URL do seu repositório):**
    ```sh
    git clone https://github.com/seu-usuario/mini_pdv.git
    cd mini_pdv
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

## 🤝 Contribuição

Contribuições, issues e solicitações de recursos são bem-vindos!

## 📄 Licença

Considere adicionar um arquivo `LICENSE` ao projeto. A Licença MIT é uma escolha popular para projetos de código aberto.
