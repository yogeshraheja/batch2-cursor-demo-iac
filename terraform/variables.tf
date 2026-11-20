variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0fbc7ac82ff7690bc"
}

variable "excluded_availability_zones" {
  description = "Availability zones to exclude from EC2 placement (e.g. AZs that do not support the instance type)"
  type        = list(string)
  default     = ["us-east-1e"]
}
