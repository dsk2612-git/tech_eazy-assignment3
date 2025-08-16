variable "stage" {
  description = "Deployment stage (dev/prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Base bucket name"
  default     = "dsk2646565"
}

variable "instance_ami" {
  default = "ami-0b83c7f5e2823d1f4" # Amazon Linux 2
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "intern"
}
