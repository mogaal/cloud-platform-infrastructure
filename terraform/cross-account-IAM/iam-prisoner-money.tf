# generated by https://github.com/ministryofjustice/money-to-prisoners-deploy
# IAM roles and policies used by Prisoner Money team's namespaces

data "aws_iam_policy_document" "prisoner-money-kiam-trust-chain" {
  # KIAM trust chain to allow pods to assume roles defined below
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::754256621582:role/nodes.live-1.cloud-platform.service.justice.gov.uk"]
    }
    actions = ["sts:AssumeRole"]
  }
}

variable "money-to-prisoners-test-tags" {
  type = map(string)
  default = {
    business-unit          = "HMPPS"
    application            = "money-to-prisoners"
    is-production          = "false"
    environment-name       = "test"
    owner                  = "prisoner-money"
    infrastructure-support = "platforms@digital.justice.gov.uk"
  }
}

resource "aws_iam_role" "money-to-prisoners-test-api" {
  name               = "money-to-prisoners-test-iam-role-api"
  description        = "IAM role for api pods in money-to-prisoners-test"
  tags               = var.money-to-prisoners-test-tags
  assume_role_policy = data.aws_iam_policy_document.prisoner-money-kiam-trust-chain.json
}

data "aws_iam_policy_document" "money-to-prisoners-test-api" {
  # "api" policy statements for "money-to-prisoners-test" namespace

  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.money-to-prisoners-test-api.arn]
  }

  # allows direct access to a test-only S3 bucket in mojdsd AWS account
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "arn:aws:s3:::money-to-prisoners-testing/cp/*",
    ]
  }
}

resource "aws_iam_policy" "money-to-prisoners-test-api" {
  name   = "money-to-prisoners-test-iam-policy-api"
  policy = data.aws_iam_policy_document.money-to-prisoners-test-api.json
}

resource "aws_iam_role_policy_attachment" "money-to-prisoners-test-api" {
  role       = aws_iam_role.money-to-prisoners-test-api.name
  policy_arn = aws_iam_policy.money-to-prisoners-test-api.arn
}
