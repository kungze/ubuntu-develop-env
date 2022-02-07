#!/usr/bin/bash

set -x
set -e

KUBE_CLUSTER_NAME=${KUBE_CLUSTER_NAME:-""}
KUBE_CLUSTER_API_SERVER=${KUBE_CLUSTER_API_SERVER:-""}
KUBE_CLUSTER_CA_DATA=${KUBE_CLUSTER_CA_DATA:-""}

KUBE_USER_NAME=${KUBE_USER_NAME:-""}
KUBE_USER_PASSWORD=${KUBE_USER_PASSWORD:-""}
KUBE_USER_CLIENT_CA_DATA=${KUBE_USER_CLIENT_CA_DATA:-""}
KUBE_USER_CLIENT_KEY_DATA=${KUBE_USER_CLIENT_KEY_DATA:-""}

KUBE_CONTEXT_NAME=${KUBE_CONTEXT_NAME:-"$HOSTNAME"}

if [ ! -f $HOME/.kube/config ]; then
    kubectl config set preferences.colors true
    # Set cluster config
    if [ "$KUBE_CLUSTER_NAME" != "" ]; then
        kubectl config set-cluster $KUBE_CLUSTER_NAME
        if [ "$KUBE_CLUSTER_API_SERVER" != "" ]; then
            kubectl config set-cluster $KUBE_CLUSTER_NAME --server=$KUBE_CLUSTER_API_SERVER
        fi
        if [ "$KUBE_CLUSTER_CA_DATA" != "" ]; then
            echo "$KUBE_CLUSTER_CA_DATA"|base64 -d - > /tmp/cluster_ca
            kubectl config set-cluster $KUBE_CLUSTER_NAME --embed-certs --certificate-authority=/tmp/cluster_ca
            rm -f /tmp/cluster_ca
        fi
    fi
    # Set user config
    if [ "$KUBE_USER_NAME" != "" ]; then
        kubectl config set-credentials $KUBE_USER_NAME
        if [ "$KUBE_USER_PASSWORD" != "" ]; then
            kubectl config set-credentials $KUBE_USER_NAME --password=$KUBE_USER_PASSWORD
        fi
        if [ "$KUBE_USER_CLIENT_CA_DATA" != "" ]; then
            echo "$KUBE_USER_CLIENT_CA_DATA"|base64 -d - > /tmp/user_client_ca
            kubectl config set-credentials $KUBE_USER_NAME --embed-certs=true --client-certificate=/tmp/user_client_ca
            rm -f /tmp/user_client_ca
        fi
        if [ "$KUBE_USER_CLIENT_KEY_DATA" != "" ]; then
            echo "$KUBE_USER_CLIENT_KEY_DATA"|base64 -d - > /tmp/user_client_key
            kubectl config set-credentials $KUBE_USER_NAME --embed-certs=true --client-key=/tmp/user_client_key
            rm -f /tmp/user_client_key
        fi
    fi
    # Set context
    if [ "$KUBE_CLUSTER_NAME" != "" ] && [ "$KUBE_USER_NAME" != "" ]; then
        kubectl config set-context $KUBE_CONTEXT_NAME --cluster $KUBE_CLUSTER_NAME --user=$KUBE_USER_NAME
        kubectl config use-context $KUBE_CONTEXT_NAME
    fi
fi
