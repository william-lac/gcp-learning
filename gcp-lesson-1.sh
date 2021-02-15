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


