##############################################################################################################
# This part for infos to connect onto aws based on you aws config & credentials files
##############################################################################################################
provider aws {
  region = var.region
  profile = var.aws_profile
}