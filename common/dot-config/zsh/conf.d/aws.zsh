# AWS CLI helpers: profile switcher, console login, EKS import
export AWS_DEFAULT_REGION=us-west-2

aws-profile() {
    if [[ "$1" == clear ]]; then
        unset AWS_PROFILE
    else
        export AWS_PROFILE="$1"
    fi
}

_aws-profile() {
    local -a profiles
    profiles=(${(f)"$(sed -n 's/^\[profile \(.*\)\]$/\1/p' ~/.aws/config 2>/dev/null)"})
    compadd -a profiles
    compadd clear
}
compdef _aws-profile aws-profile

# Switch the region the AWS CLI (and aws-login) uses for this shell, overriding the
# AWS_DEFAULT_REGION exported above. Does NOT affect kubectl/EKS — that region is
# baked into each kubeconfig context, so switch clusters with kubectx instead.
aws-region() {
    if [[ "$1" == clear ]]; then
        unset AWS_DEFAULT_REGION
    else
        export AWS_DEFAULT_REGION="$1"
    fi
}

_aws-region() {
    compadd us-west-2 us-east-1 us-east-2 us-west-1 ap-southeast-1 ap-northeast-1 ap-southeast-2 eu-west-1 eu-central-1
    compadd clear
}
compdef _aws-region aws-region

# Open the AWS console as the active (or given) profile, mimicking the internal
# `aws-login`: exchange the profile's temporary STS creds for a federation
# sign-in token, then open the console in the browser. Requires temporary creds
# (SSO / assumed role) — long-term IAM user keys are rejected by the endpoint.
aws-login() {
    [[ -n "$1" ]] && export AWS_PROFILE="$1"
    if [[ -z "$AWS_PROFILE" ]]; then
        print -u2 "aws-login: no AWS_PROFILE set (pass one: aws-login <profile>)"
        return 1
    fi

    local creds session token region destination url
    creds=$(aws configure export-credentials --format process 2>/dev/null) || {
        print -u2 "aws-login: could not resolve creds for '$AWS_PROFILE' — run: aws sso login"
        return 1
    }

    session=$(jq -c '{sessionId:.AccessKeyId, sessionKey:.SecretAccessKey, sessionToken:.SessionToken}' <<< "$creds")
    if [[ "$(jq -r '.sessionToken' <<< "$session")" == null ]]; then
        print -u2 "aws-login: '$AWS_PROFILE' has no session token — the console federation endpoint only accepts temporary (SSO/assumed-role) creds"
        return 1
    fi

    token=$(curl -s "https://signin.aws.amazon.com/federation?Action=getSigninToken&Session=$(jq -rn --arg s "$session" '$s|@uri')" | jq -r '.SigninToken')
    if [[ -z "$token" || "$token" == null ]]; then
        print -u2 "aws-login: federation endpoint did not return a sign-in token"
        return 1
    fi

    region="${AWS_DEFAULT_REGION:-us-west-2}"
    destination=$(jq -rn --arg d "https://${region}.console.aws.amazon.com/console/home?region=${region}" '$d|@uri')
    url="https://signin.aws.amazon.com/federation?Action=login&Issuer=$(jq -rn --arg i "aws-login" '$i|@uri')&Destination=${destination}&SigninToken=${token}"
    open "$url"
}
compdef _aws-profile aws-login

# Discover EKS clusters and import each into ~/.kube/custom-contexts/, one file per
# cluster, context named <cluster>-<label>-<region> where <label> is the profile
# minus its first segment (which duplicates the cluster's project name) — so two
# roles on the same cluster (e.g. kirin-sre-prod vs kirin-fullaccess-prod) get
# distinct names instead of colliding. The context, cluster, and user entries are
# all renamed to that same stem: `aws eks update-kubeconfig --alias` only renames
# the context, leaving the cluster/user keyed by a shared ARN, so two roles would
# otherwise resolve to whichever user the merge loader saw first. The kube.zsh
# merge loader then exposes them to `kubectx`. Args are profiles to sweep; with
# none, sweeps every ~/.aws/config profile that has a role_arn (the assumable
# custom roles — jump roles lack eks perms). Override the region list with
# EKS_REGIONS="a b c". Needs warm creds: run `aws sso login` first, and note a
# profile's role-chained session lasts only ~1h.
eks-import() {
    local -a profiles regions
    profiles=("$@")
    (( ${#profiles} )) || profiles=(${(f)"$(awk '/^\[profile /{p=$0; sub(/^\[profile /,"",p); sub(/\]$/,"",p)} /role_arn/{print p}' ~/.aws/config)"})
    regions=(${=EKS_REGIONS:-us-west-2 us-east-1 us-east-2 us-west-1 ap-southeast-1 ap-northeast-1 ap-southeast-2 eu-west-1 eu-central-1})

    local profile label region cluster dir file ctx clusters
    for profile in $profiles; do
        label=${profile#*-}
        for region in $regions; do
            clusters=$(AWS_PROFILE=$profile aws eks list-clusters --region $region --query 'clusters[]' --output text 2>/dev/null) || continue
            [[ -z $clusters ]] && continue
            for cluster in ${(z)clusters}; do
                dir=$HOME/.kube/custom-contexts/${profile}-${region}
                file=$dir/${cluster}.yml
                ctx=${cluster}-${label}-${region}
                mkdir -p $dir
                # Regenerate fresh so a rename never leaves stale ARN-keyed entries behind.
                rm -f $file
                AWS_PROFILE=$profile aws eks update-kubeconfig --region $region --name $cluster \
                    --kubeconfig $file --alias $ctx >/dev/null || continue
                yq -i "
                    .clusters[0].name = \"$ctx\"
                    | .contexts[0].context.cluster = \"$ctx\"
                    | .contexts[0].context.user = \"$ctx\"
                    | .users[0].name = \"$ctx\"
                    | .\"current-context\" = \"$ctx\"
                " $file \
                    && print "imported $ctx"
            done
        done
    done
}
