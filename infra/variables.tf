variable "vpc-cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "172.22.0.0/16"
}

variable "all_tags" {
  description = "tags for all resources"
  type        = map(string)
  default = {
    "Owner" = "GjovaniMirdita"
  }
}

variable "repo_github" {
  description = "GitHub repository"
  type        = string
  default     = "repo:gjovani-vega/docker-nodejs-sample*"
}