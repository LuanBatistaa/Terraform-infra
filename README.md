# VEXPENSES-TF

## Este repositório contém um módulo Terraform para provisionar uma infraestrutura AWS.



<span style="color: yellow;">
O modulo inicial consistia em uma configuração simples de Infraestutura com algumas praticas não recomendadas.</span>

<br>

- Cria uma chave privada RSA para autenticação segura via SSH. Essa chave é utilizada para acessar a instância EC2.

- Cria um par de chaves na AWS, associando a chave pública à chave privada gerada. Isso permite o acesso remoto à instância.

- Cria uma VPC com CIDR 10.0.0.0/16, proporcionando uma rede isolada para os recursos.

- Configura uma sub-rede (10.0.1.0/24) na zona de disponibilidade us-east-1a, segmentando o tráfego e aumentando a segurança.

- Cria um gateway que permite a comunicação entre a VPC e a internet, possibilitando o acesso externo às instâncias.

- Estabelece uma tabela de rotas com uma rota padrão (0.0.0.0/0) para o gateway de internet, permitindo o tráfego de internet para a VPC.

- Associa a tabela de rotas à sub-rede criada, garantindo que o tráfego possa ser roteado corretamente.

- Define um grupo de segurança que permite acesso SSH (porta 22) de qualquer lugar (pratica não recomendada) e permite todo o tráfego de saída, controlando o acesso à instância EC2.

- Recupera a imagem mais recente do Debian 12, que será utilizada para criar a instância EC2

- Lança uma instância do tipo t2.micro com a AMI Debian 12, executando um script de atualização durante a inicialização.

- Saídas para exibir a chave privada e o IP público da instância.

# <span style="color: green;">O modulo atual expandiu significativamente essa base, incorporando recursos distintos e várias melhorias.
</span>


<br>


### Separação dos recursos em arquivos diferentes para melhor manutenção e clareza.

<br>

---

### Criação da Sub Rede e Associação tabela de rotas secundária.

- Práticas que proporcionam uma arquitetura de rede mais robusta, segura e flexível.

<br>

---

### Criação de template que define como as instâncias EC2 serão lançadas, incluindo a AMI (Amazon Machine Image), tipo de instância, e outros parâmetros.


- Facilita a criação e a gestão de instâncias EC2 com configurações pré-definidas.


<br>

---

### Criação de um grupo de auto scaling que gerencia a quantidade de instâncias EC2 ativas, com capacidade desejada de 2 instâncias.

- Permite que a infraestrutura se ajuste automaticamente à demanda, escalando para cima ou para baixo conforme necessário.

<br>

---
### Criação um balanceador de carga que distribui o tráfego entre as instâncias EC2.



- Melhora a disponibilidade e a resiliência do seu aplicativo, garantindo que o tráfego seja distribuído eficientemente


<br>

---

### Criação de um grupo de destino para o balanceador de carga, onde as instâncias EC2 serão registradas.

- Permite que o balanceador de carga saiba para onde enviar o tráfego.

- Distribui as requisições igualmente entre as instâncias.

- COM CHECAGEM A CADA 30 SEGUNDOS

- 5 o número de respostas bem-sucedidas consecutivas necessárias para considerar a instância saudável.
- 5 o número de respostas malsucedidas consecutivas necessárias para considerar a instância não saudável

<br>

---
### Criação de um Listeners do Balanceador de Carga

- Redireciona o tráfego recebido para o grupo de destinos.

<br>

---

### Automação para instalação e inicialização do Nginx:

 - Automação garante que o Nginx seja instalado e iniciado automaticamente assim que a instância EC2 for criada, proporcionando um ambiente de servidor web pronto para uso.

<br>

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado.
  <br>

## Utilização

Para rodar os comandos na sua conta da aws, crie um usuário na sessao IAM do console, crie credenciais de acesso e use-as exportando no comando abaixo.

### **Obter Credenciais**:
   - Anote a `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` geradas para o usuário.
  

### **Configurar Variáveis de Ambiente**:
   - Dependendo do seu sistema operacional, use um dos métodos abaixo:

### No Windows (PowerShell)

 Abra seu terminal e execute:

```
$env:AWS_ACCESS_KEY_ID="SUA_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY="SUA_SECRET_KEY"
```

### No Linux ou macOS

 Abra seu terminal e execute:

```
export AWS_ACCESS_KEY_ID="SUA_ACCESS_KEY"          
export AWS_SECRET_ACCESS_KEY="SUA_SECRET_KEY"
```

<br>

## Uso Basico

**Após configurar as variáveis de ambiente, você pode executar os seguintes comandos do Terraform:**
```
terraform init
terraform plan
terraform apply
```

## Destruir a Infraestrutura:

```
terraform destroy
```

<br>


## Este projeto proporciona uma infraestrutura completa e escalável na AWS, utilizando as melhores práticas de provisionamento com Terraform. A evolução do projeto reflete um aumento significativo na complexidade e funcionalidade, tornando-o adequado para aplicações em produção.
