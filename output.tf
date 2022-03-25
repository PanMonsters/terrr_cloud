output "internal_ip_address_web-001" {
  value       = resource.yandex_compute_instance.vm[0].network_interface.0.ip_address
}

output "external_ip_address_web-001" {
  value       = resource.yandex_compute_instance.vm[0].network_interface.0.nat_ip_address
}

/* Расскоментировать для prod
output "internal_ip_address_web-002" {
  value       = resource.yandex_compute_instance.vm[1].network_interface.0.ip_address
}

output "external_ip_address_web-002" {
  value       = resource.yandex_compute_instance.vm[1].network_interface.0.ip_address
}

*/


output "internal_ip_address_s1" {
  value       = resource.yandex_compute_instance.vm_for_each["s1"].network_interface.0.ip_address
}

output "external_ip_address_s1" {
  value       = resource.yandex_compute_instance.vm_for_each["s1"].network_interface.0.nat_ip_address
}


