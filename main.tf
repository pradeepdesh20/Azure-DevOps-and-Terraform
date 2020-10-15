provider "azurerm"{
   version = "2.5.0"
   features {}
}

resource "azurerm_resource_group" "tf_test_rg" {
   name = "tgmainrg"
   location = "eastus"
}

terraform {
   backend "azurerm" {
      resource_group_name     = "Terraform_rg_blobstore"
      storage_account_name    = "tfstoragepradeepdesh"
      container_name          = "tfstate"
      key                     = "terraform.tfstate"
   }
}

variable "imagebuild"{
   type = string 
   description = "lastest image build"
   }
   
resource "azurerm_container_group" "tf_test_cg" {
   name                    = "weatherapi"
   location                = azurerm_resource_group.tf_test_rg.location
   resource_group_name     = azurerm_resource_group.tf_test_rg.name

   ip_address_type         = "public"
   dns_name_label          = "pradeepdeshwapi"
   os_type                 = "Linux"

   container {
      name   = "weatherapi"
      image  = "pradeepdesh/weatherapi:${var.imagebuild}"
      cpu    = "1"
      memory = "1"

      ports {
         port     = 80
         protocol = "TCP"
      }
   }

}