provider "google" {
	project = 	"terraform-2705"
	region = "us-central1"
	credentials = "${file("C:/Users/sujag/Downloads/terraform-2705-4c574421ef83.json")}"
}

provider "aws" {
	region = "ap-south-1"
	profile = "default"
}