# Merge every per-cluster kubeconfig under ~/.kube/custom-contexts/ into KUBECONFIG,
# on top of the default ~/.kube/config. Drop a cluster's config at
# ~/.kube/custom-contexts/<name>/<name>.yml (via `aws eks update-kubeconfig
# --kubeconfig ...`) and switch with `kubectx`. See Guides/aws_cli_setup.md.
export KUBECONFIG="$HOME/.kube/config"
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/custom-contexts"
mkdir -p "$CUSTOM_KUBE_CONTEXTS"
for _kubeContext in $CUSTOM_KUBE_CONTEXTS/**/*.yml(N); do
    export KUBECONFIG="$_kubeContext:$KUBECONFIG"
done
unset _kubeContext
