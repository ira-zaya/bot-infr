# =========| VARIABLES |========
variable "http-port" {
  type = number
  default = 80
}

variable "fargate_memory" {
  default = 512
}

variable "fargate_cpu" {
  default = 256
}

variable "environment" {
  default = "dev"
}

variable "app_name" {
  default = "hello"
}

variable "aws_account" {
  default = "581835478100"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "default-cidr" {
  type = string
  default = "0.0.0.0/0"
}
variable "vpc-cidr" {
  default      = "10.0.0.0/16"
  description  = "VPC CIDR Block"
  type         = string
}

variable "server_port" {
  default     = 8080
  description = "The port the server will use for HTTP requests"
  type        = number
}

locals {
  repository_name = format("%s-%s", var.app_name, var.environment)
}

locals {
  ecr_repository_url = format("%s:%s", "581835478100.dkr.ecr.eu-west-2.amazonaws.com/hello-dev", "nginx")
}

variable "repo_url" {
  type = string
  default = "hello-dev"
}

variable "image_tag" {
  type = string
  default = "0.0.1"
}

variable "ecr_repo_url" {
  type = string
  default = "581835478100.dkr.ecr.eu-west-2.amazonaws.com"
}

variable "script" {
  description = "Build script file"
  type        = string
  default     = "build-docker.sh"
}

variable "working_dir" {
  description = "Application location"
  type        = string
  default     = "./app"
}

variable "ecs_task_role_name" {
  default = "TaskRole"
}

variable "ecs_task_execution_role_name" {
  default = "TaskExRole"
}

variable "public-subnet-cidr" {
  type         = list(string)
  default      = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "private-subnet-cidr" {
  type         = list(string)
  default      = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable "eip" {
  description = "Create EIPs with different names"
  type = list(string)
  default = ["EIP 1", "EIP 2"]
}