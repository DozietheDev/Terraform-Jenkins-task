variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "notify-cluster"
}

variable "ecs_task_family" {
  description = "ECS task family name"
  type        = string
  default     = "notify-task"
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
  default     = "notifyservice"
}

variable "container_image" {
  description = "Container image for ECS task"
  type        = string
  default     = "notify-image:latest"
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access services (for security group)"
  type        = string
  default     = "0.0.0.0/0"
}
