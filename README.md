# Basic Instructions

1. Create a directory to house this project in then switch to that directory

   ``
   mkdir RDS-TF-Project; cd RDS-TF-Project
   ``

2. Create two empty .tf files named provider.tf & rds.tf. Then open text editors to begin configuration task
   
   ``
   touch provider.tf rds.tf; code provider.tf rds.tf
   ``

3.  Once files have necessary information needed to deploy infrastructure; run the following commands to initialize terraform in current directory, validate syntax of file, and build infrastructure

    ``
    terraform init; terraform validate/plan; terraform apply -auto-apply
    ``

4. Login to AWS Console -> Go to RDS Service to check and see the DB instance be created. Can also go to VPC Service and check the security group & subnet section


5. Once everything is complete, make sure to destroy resources so charges will not happen
 
   ``
   terraform destroy
   ``
 
# References
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
