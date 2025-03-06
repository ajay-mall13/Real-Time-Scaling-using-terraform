resource "google_compute_autoscaler" "my_autoscaler" {
  name   = "autoscaler"
  zone   = "us-central1-b"  # Fixed to match other resources
  target = google_compute_instance_group_manager.default.self_link

  autoscaling_policy {
    max_replicas    = 7
    min_replicas    = 1
    cooldown_period = 45

    metric {
      name                      = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter                    = "resource.type=\"pubsub_subscription\" AND resource.labels.subscription_id=\"our-subscription\""
      single_instance_assignment = 65535
    }
  }
}

resource "google_compute_instance_template" "default" {
  name         = "my-instance-template1"
  machine_type = "n1-standard-4"

  disk {
    boot         = true
    auto_delete  = true
    source_image = data.google_compute_image.debian_9.self_link
  }

  network_interface {
    network    = "default"  # Use default VPC or specify a custom one
    // subnetwork = "your-subnet-name"  # Uncomment and replace if using a custom VPC
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "my-igm"
  zone               = "us-central1-b"  # Fixed zone mismatch
  base_instance_name = "autoscaler-sample"

  version {
    instance_template = google_compute_instance_template.default.self_link
    name              = "primary"
  }

  # Removed target_pools (use a backend service instead if needed)
}

# Remove this if using a load balancer
resource "google_compute_target_pool" "default" {
  name = "my-target-pool"
}

data "google_compute_image" "debian_9" {
  family  = "debian-11"
  project = "debian-cloud"
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-b"
}
