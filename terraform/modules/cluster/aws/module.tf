resource "aws_vpc" "cluster" {
  cidr_block = "10.0.0.0/8"

  tags {
    Name = "cluster"
  }
}

resource "aws_subnet" "cluster" {
  vpc_id     = "${aws_vpc.cluster.id}"
  cidr_block = "10.240.0.0/24"

  # availabilit_zone = random

  tags {
    Name = "cluster"
  }
}

data "aws_ami" "coreos" {
  owners = ["595879546273"] # CoreOS

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # Consider pinning to 1632.3.0, as container linux and Ignition versions
  # are tightly coupled
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
}

resource "aws_security_group" "master" {
  name        = "masters"
  description = "Masters Security Group"

  tags {
    Name = "masters"
  }
}

resource "aws_security_group_rule" "master_all_to_world" {
  security_group_id = "${aws_security_group.master.id}"

  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master_kube_api_from_world" {
  security_group_id = "${aws_security_group.master.id}"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 6443
  to_port     = 6443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master_ssh_from_world" {
  security_group_id = "${aws_security_group.master.id}"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "worker" {
  name        = "workers"
  description = "Workers Security Group"

  tags {
    Name = "workers"
  }
}

resource "aws_security_group_rule" "worker_all_to_world" {
  security_group_id = "${aws_security_group.worker.id}"

  type        = "egress"
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_ssh_from_world" {
  security_group_id = "${aws_security_group.worker.id}"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
}

# TODO: NLB
/* resource "aws_elb" "apiserver" { */
/*   name = "apiserver" */
/*   subnets = ["${aws_subnet.cluster.id}"] */
/*   internal = false */

/*   listener { */
/*     lb_port = 6443 */
/*     lb_protocol = "tcp" # It's HTTPS, but this LB doesn't terminate the SSL */
/*     instance_port = 6443 */
/*     instance_protocol = "tcp" */
/*   } */

/*   instances = "${aws_instance.master.*.id}" */
/*   cross_zone_load_balancing = false */
/*   idle_timeout = 60 */
/*   connection_draining = true */
/*   connection_draining_timeout = 60 */

/*   tags { */
/*     Name = "apiserver" */
/*   } */
/* } */

/* resource "aws_eip" "apiserver" { */
/*   vpc = true */
/* } */

resource "aws_instance" "master" {
  count = 1
  ami   = "${data.aws_ami.coreos.id}"

  instance_type = "c5.large"

  # TODO: generate
  key_name               = "mt-test"
  subnet_id              = "${aws_subnet.cluster.id}"
  private_ip             = "10.240.0.1${count.index}"
  vpc_security_group_ids = ["${aws_security_group.master.id}"]

  # TODO: write in "Container Linux Config" and use ct to transpile (is this what the ignition provider does?)
  #user_data = "${file("${path.module}/userdata/ignition.json")}"
  user_data = "${data.ignition_config.master.rendered}"

  tags {
    Name      = "master-${count.index}"
    System    = "kubernetes"
    Component = "master"
  }
}

resource "aws_instance" "worker" {
  count = 3

  ami = "${data.aws_ami.coreos.id}"

  instance_type = "c5.large"

  # TODO: generate
  key_name               = "mt-test"
  subnet_id              = "${aws_subnet.cluster.id}"
  private_ip             = "10.240.0.2${count.index}"
  vpc_security_group_ids = ["${aws_security_group.worker.id}"]

  # TODO: write in "Container Linux Config" and use ct to transpile (is this what the ignition provider does?)
  #user_data = "${file("${path.module}/userdata/ignition.json")}"
  user_data = "${data.ignition_config.worker.rendered}"

  tags {
    Name      = "worker-${count.index}"
    System    = "kubernetes"
    Component = "worker"
  }
}
