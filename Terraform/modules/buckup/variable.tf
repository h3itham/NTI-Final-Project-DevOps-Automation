# CRON JOB TO DEFINE THE BACKUP SCHEDULE IN UTC TIME
variable "backup_schedule" {
  type    = string
}
# DEFINE THE RETENTION PERIOD IN DAYS 
variable "backup_retention_days" {
  type    = number
}