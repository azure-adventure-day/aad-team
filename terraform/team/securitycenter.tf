# resource "null_resource" "EnableSecurityCenter" {
#   provisioner "local-exec" {
#     command = "az security pricing create -n KubernetesService --tier 'standard'"
    
#   }
# }