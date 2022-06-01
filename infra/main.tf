resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "europe-west1"

  remove_default_node_pool = true
  initial_node_count       = 1
  cluster_autoscaling {
    enabled             = true
    resource_limits {
      resource_type = "cpu"
      maximum       = 96
    }

    resource_limits {
      resource_type = "memory"
      maximum       = 256
    }
    auto_provisioning_defaults {
      image_type      = "COS_CONTAINERD"
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }  
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool-1"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name               = "primary-nodes"
  depends_on         = [google_container_cluster.primary]
  location           = "europe-west1"
  cluster            = google_container_cluster.primary.name
  initial_node_count = 1
  upgrade_settings {
    max_surge       = 20
    max_unavailable = 0
  }
  autoscaling {
    min_node_count = 1
    max_node_count = 20
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    machine_type = "e2-highcpu-32"
    image_type   = "COS_CONTAINERD"
    disk_type    = "pd-ssd"
  }
}