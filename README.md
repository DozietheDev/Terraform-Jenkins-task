# Terraform-Jenkins-task

This is a project that 
1. Create a Terraform configuration that provisions an ECS cluster, following security best practices. This setup includes:
a. Private subnets for internal resource communication
b. Public subnets for internet-facing access

2. Create a Jenkins CI/CD pipeline that deploys multiple services to an ECS cluster.
The pipeline should be capable of:
a. Handling multiple ECS tasks (i.e., services) within a single ECS cluster
b. Dynamically detecting and deploying all available services for an
organisation
c. Ensuring that each cluster can support multi-task execution without requiring separate clusters per service

Key Expectations
The focus is to design a reusable CI/CD pipeline, attention to security best practices and approach to building a clean and scalable architecture.