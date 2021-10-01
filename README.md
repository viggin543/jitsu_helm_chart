# JITSU helm chart
## For google k8s service

This chart assumes a GKE cluster with workload identity enabled
And a GCP service account annotated with the name of jitsu KSA
To give jitsu access to GCS
( refer to terraform directory for all needed entities )

Dependencies:
- Redis connection string 
- This chart assumes prometheus operator is installed on the cluster
  - disable monitoring in values file if not
- External DNS is installed in the cluster
  - if not chart will still work


This chart creates a ManagedCertificate GKE resource that will provision a TLS certificate
And assigns this certificate to an Ingress
( this will open jitsu server to the world - assuming google hosted zone is connected to a public dns)
Jitsu configurator is creates a ClusterIp service and can be accessed only via private IP/port forwarding


### terraform dir contains all relevant resources needed for this deployment to operate
- GCP service account
  - workload identity mapping
- reserved static ip
- ingress dns record set ( assuming google hosted zones are connected to a public dns )
- maxmind GCS bucket
  - granting jitsu SA Object Admin role on maxmind bucket


### best install this chart using argocd

Cheers
