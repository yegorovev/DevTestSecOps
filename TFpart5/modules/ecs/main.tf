resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_name
}

data "template_file" "container_template" {
  template = file("${path.module}/files/containers.json")
  vars = {
    name          = var.ecs_container_config.name
    image         = var.ecs_container_config.image
    cpu           = var.ecs_container_config.cpu
    memory        = var.ecs_container_config.memory
    port_mappings = jsonencode(var.ecs_container_config.port_mappings)
    command       = jsonencode(var.ecs_container_config.command)
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.ecs_task_config.name
  container_definitions    = data.template_file.container_template.rendered
  requires_compatibilities = var.ecs_task_config.requires_compatibilities
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_config.name
  cluster         = aws_ecs_cluster.cluster.id
  desired_count   = var.ecs_service_config.desired_count
  task_definition = aws_ecs_task_definition.task.arn
}
