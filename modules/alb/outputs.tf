output "dns_name" {
  value = aws_lb.this.dns_name
}
output "alb_arn" {
  value = aws_lb.this.arn
}

output "service_a_tg_arn" {
  value = aws_lb_target_group.service_a.arn
}

output "service_b_tg_arn" {
  value = aws_lb_target_group.service_b.arn
}

output "service_c_tg_arn" {
  value = aws_lb_target_group.service_c.arn
}

output "service_d_tg_arn" {
  value = aws_lb_target_group.service_d.arn
}

output "service_e_tg_arn" {
  value = aws_lb_target_group.service_e.arn
}
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}