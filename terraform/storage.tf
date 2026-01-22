data "archive_file" "function_file" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "../suspend_instance"
}

resource "google_storage_bucket" "function_bucket" {
  name                        = "function-source-bucket-${var.project_id}"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "function_object" {
  name   = "source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_file.output_path
}