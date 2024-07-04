variable "region" {
  description = "Region to use for all resources"
  type        = string
  default     = "ap-southeast-2"
}
variable "db_storage_size" {
  description = "Size of Disk for db"
  type        = string
  default     = "350"
}

variable "db_iops" {
  description = "Required IOPs for the DB"
  type        = string
  default     = "13000"
}

variable "backup_retention" {
  description = "Length of time to store backups in days"
  type        = string
  default     = "7"
}

variable "application_role" {
  description = "Role used to authenticate app to db"
  type        = string
  default     = "arn:aws:iam::123456789101:role/application/example-app"
}

variable "eks_subnet" {
  description = "subnet for rds instance"
  type        = string
  default     = "10.2.0.0/16"
}

variable "rds_subnet" {
  description = "subnet for rds instance"
  type        = string
  default     = "10.5.0.0/16"
}

variable "kms_key" {
  description = "KMS Key id for encryption of database metrics"
  type        = string
  default     = "example_kms_key"
}
