variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "ecs_task_family" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}
