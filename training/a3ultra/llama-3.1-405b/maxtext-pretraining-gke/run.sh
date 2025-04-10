export REPO_ROOT=`git rev-parse --show-toplevel`
export RECIPE_ROOT=$REPO_ROOT/training/a3ultra/llama-3.1-405b/maxtext-pretraining-gke

export PROJECT_ID=supercomputer-testing
gcloud config set project $PROJECT_ID


export REGION=europe-west1
export CLUSTER_REGION=europe-west1
export CLUSTER_NAME=gke-a3ultra-bm-map-3

gcloud container clusters get-credentials $CLUSTER_NAME --region $CLUSTER_REGION


export GCS_BUCKET=qinwen-mlperf-gpu
export ARTIFACT_REGISTRY=gcr.io/supercomputer-testing/us-west1-docker.pkg.dev/supercomputer-testing/qinwen/qinwen_gpu_runner-0320
export KUEUE_NAME=a3-ultra

helm install -f values.yaml \
    --set-file maxtext_config=$REPO_ROOT/src/frameworks/a3ultra/maxtext-configs/llama-3.1-405b-256gpus-a3u-bf16_mlperf.yaml \
    --set workload.image=${ARTIFACT_REGISTRY} \
    --set workload.run_name=$USER-llama-3-1-405b-maxtext-mlperf_bf16 \
    --set workload.gpus=512 \
    --set queue=$KUEUE_NAME \
    --set volumes.gcsMounts[0].bucketName=${GCS_BUCKET} \
    $USER-llama-3-1-405b-maxtext-bf16-0320-32-fp16 \
    $REPO_ROOT/src/helm-charts/a3ultra/maxtext-training