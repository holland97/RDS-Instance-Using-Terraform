# Create default vpc if one doesn't exist
resource "aws_default_vpc" "default-vpc" {
  tags = {
    Name = "default vpc"
  }

}

# Use data source to get all availability zones in region
data "aws_availability_zones" "available-zones" {}

#Create a default subnet in the first az if one doesn't exist
resource "aws_default_subnet" "subnet-az1" {
  availability_zone = data.aws_availability_zones.available-zones.names[0] #Select first AZ in the list that's being pulled from code above. Gets us-east-1a

}

# Creates a default subnet in the second az if one doesn't exist
resource "aws_default_subnet" "subnet-az2" {
  availability_zone = data.aws_availability_zones.available-zones.names[1]

}

# Create security group for the web server
resource "aws_security_group" "webserver-security-group" {
  name        = "webserver security group"
  description = "enable http access on port 80"
  vpc_id      = aws_default_vpc.default-vpc.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver security group"
  }

}

# Create security group for the DB
resource "aws_security_group" "db-security-group" {
  name        = "database security group"
  description = "enable postgreSQL access on port 5432" #By default postgresql listens on this port
  vpc_id      = aws_default_vpc.default-vpc.id

  ingress {
    description     = "postgresql access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-security-group.id] #Allows traffic from the webserver
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database security group"
  }

}

# Create subnet group. Specifies the subnet to reserve for rds instance
resource "aws_db_subnet_group" "db-subnet-group" {
  name        = "database-subnets"
  subnet_ids  = [aws_default_subnet.subnet-az1.id, aws_default_subnet.subnet-az2.id] #Subnets to launch the rds instance in which is first & second AZ
  description = "subnets for DB instance"

  tags = {
    Name = "database-subnets"
  }
}


# Creates my RDS DB using TF

resource "aws_db_instance" "postgresDB" {
  engine                 = "postgres"
  engine_version         = "15.4"
  db_name                = "Anime" #Name of the DB created once DB Instance is spun up
  allocated_storage      = 20
  storage_type           = "gp2"
  identifier             = "testing-db" #Name of the RDS instance
  instance_class         = "db.t3.micro"
  multi_az               = "false" #Specifies if DB is Multi-AZ but it isn't
  username               = "AdminTobi"
  password               = "**************"
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.db-security-group.id]
  availability_zone      = data.aws_availability_zones.available-zones.names[0] #AZ I want to launch DB in
  skip_final_snapshot    = "true"                                               #Enabled so I won't get charged when I delete DB

  tags = {
    Name = "Project-RDS-DB"
  }

}
