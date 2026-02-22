app {
  url    = "https://github.com/kubernetes-csi/csi-driver-nfs"
  author = "Kubernetes CSI Maintainers"
}

pack {
  name        = "nfs-csi-plugin"
  description = <<-EOT
    The Container Storage Interface (CSI) plugin for Network File System (NFS) enables the dynamic
    provisioning and management of NFS volumes for containerized workloads.
  EOT
  url         = "https://github.com/flaudisio/nomad-pack-registry/tree/main/packs/nfs-csi-plugin"
  version     = "0.9.0"
}
