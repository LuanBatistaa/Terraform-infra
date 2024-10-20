variable "projeto" {
  description = "Nome do projeto"
  type        = string
  default     = "VExpenses"
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
  default     = "LuanBatista"
}

#Instala o servidor web Nginx.
#Inicia o servidor Nginx.
variable "user_data" {
  type    = string
  default = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              sudo apt install nginx -y
              sudo nginx
              EOF
}