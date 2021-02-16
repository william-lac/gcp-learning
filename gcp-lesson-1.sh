# Intention of scripting the creation of GCE, assigning buckets, and tell it to run a script upon starting up

while getopts p:b flag
do
    case "${flag}" in
        p) project=${OPTARG};;
        b) bucket=${OPTARG};;
    esac
done

# Create new project
# challenge-vm-cli
gcloud projects create $project

# Set project ID/Name
gcloud config set project $project

# Create Bucket
# challenge-vm-cli-bucket
gsutil mb gs://$bucket -p $project -c NEARLINE -l US-WEST2

# Had issues with Trial account not letting me enable billing
# gcloud beta billing projects link challenge-vm-cli --billing-account=XXXXXX-XXXXXX-XXXXXXX
# ERROR: (gcloud.beta.billing.projects.link) FAILED_PRECONDITION: Precondition check failed.
# - '@type': type.googleapis.com/google.rpc.QuotaFailure
#  violations:
#  - description: 'Cloud billing quota exceeded: https://support.google.com/code/contact/billing_quota_increase'
#    subject: billingAccounts/XXXXXX-XXXXXX-XXXXXX

# I'll script it below to how I would create a GCE (Google Cloud Engine)
gcloud beta compute --project=challenge-1-304718 instances create challenge-vm-cli --zone=us-central1-f \
--machine-type=f1-micro --subnet=default --network-tier=PREMIUM \
--metadata=lab-logs-bucket=gs://challenge-vm-cli-bucket/,startup-script-url=https://storage.googleapis.com/challenge-vm-cli-bucket/scripts/startup-script.sh \
--no-restart-on-failure --maintenance-policy=TERMINATE --preemptible \
--service-account=845007272164-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform \
--image=debian-10-buster-v20210122 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced \
--boot-disk-device-name=challenge-vm-cli --no-shielded-secure-boot --shielded-vtpm \
--shielded-integrity-monitoring --reservation-affinity=any



# made the following script public - https://storage.googleapis.com/challenge-vm-cli-bucket/scripts/startup-script.sh


