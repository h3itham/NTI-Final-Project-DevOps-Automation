# SETTING UP PERMISSIONS FOR THE AWS BACKUP SERVICE TO PERFORM BACKUPS AND RESTORES WITHIN AN AWS ACCOUNT.

# ASSUME ROLE POLICY FOR BACKUPS 
data "aws_iam_policy_document" "example-aws-backup-service-assume-role-policy-doc" {
  statement {
    sid     = "AssumeServiceRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

# THE POLICIES THAT ALLOW THE BACKUP SERVICE TO TAKE BACKUPS AND RESTORES 
data "aws_iam_policy" "aws-backup-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_iam_policy" "aws-restore-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

data "aws_caller_identity" "current_account" {}

#NEEDED TO ALLOW THE BACKUP SERVICE TO RESTORE FROM A SNAPSHOT TO AN EC2 INSTANCE 
# SEE https://stackoverflow.com/questions/61802628/aws-backup-missing-permission-iampassrole 
data "aws_iam_policy_document" "example-pass-role-policy-doc" {
  statement {
    sid       = "ExamplePassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/*"]
  }
}

# ROLES FOR TAKING AWS BACKUPS 

resource "aws_iam_role" "example-aws-backup-service-role" {
  name               = "ExampleAWSBackupServiceRole"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.example-aws-backup-service-assume-role-policy-doc.json

  tags = {
    Project = "nti-project"
    Role    = "iam"
  }
}

resource "aws_iam_role_policy" "example-backup-service-aws-backup-role-policy" {
  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "backup:*",
            "tag:GetResources"
          ],
          "Resource": "*"
        }
      ]
    }
  POLICY
  role = aws_iam_role.example-aws-backup-service-role.name
}

resource "aws_iam_role_policy" "example-restore-service-aws-backup-role-policy" {
  policy = data.aws_iam_policy.aws-restore-service-policy.policy
  role   = aws_iam_role.example-aws-backup-service-role.name
}

resource "aws_iam_role_policy" "example-backup-service-pass-role-policy" {
  policy = data.aws_iam_policy_document.example-pass-role-policy-doc.json
  role   = aws_iam_role.example-aws-backup-service-role.name
}

resource "aws_backup_vault" "example-backup-vault" {
  name = "example-backup-vault"
  tags = {
    Project = "nti-project"
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "example-backup-plan" {
  name = "example-backup-plan"

  rule {
    rule_name         = "weekdays-every-2-hours-${local.backups.retention}-day-retention"
    target_vault_name = aws_backup_vault.example-backup-vault.name
    schedule          = var.backup_schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = var.backup_retention_days
    }

    recovery_point_tags = {
      Project = "nti-project"
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
     Project = "nti-project"
     Role    = "backup"
  }
}

resource "aws_backup_selection" "example-server-backup-selection" {
  iam_role_arn = aws_iam_role.example-aws-backup-service-role.arn
  name         = "example-server-resources"
  plan_id      = aws_backup_plan.example-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
