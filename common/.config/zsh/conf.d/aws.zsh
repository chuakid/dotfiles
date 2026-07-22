# AWS CLI helpers: profile switcher, console login, EKS import
export AWS_DEFAULT_REGION=us-west-2

if [ -f $(brew --prefix)/bin/aws_zsh_completer.sh ] ; then
  autoload -Uz compinit && compinit
  source $(brew --prefix)/bin/aws_zsh_completer.sh
fi

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
# cluster, context aliased <cluster>-<env>-<region> (env = last '-' segment of the
# profile). The kube.zsh merge loader then exposes them to `kubectx`. Args are
# profiles to sweep; with none, sweeps every ~/.aws/config profile that has a
# role_arn (the assumable custom roles — jump roles lack eks perms). Override the
# region list with EKS_REGIONS="a b c". Needs warm creds: run `aws sso login`
# first, and note a profile's role-chained session lasts only ~1h.
eks-import() {
    local -a profiles regions
    profiles=("$@")
    (( ${#profiles} )) || profiles=(${(f)"$(awk '/^\[profile /{p=$0; sub(/^\[profile /,"",p); sub(/\]$/,"",p)} /role_arn/{print p}' ~/.aws/config)"})
    regions=(${=EKS_REGIONS:-us-west-2 us-east-1 us-east-2 us-west-1 ap-southeast-1 ap-northeast-1 ap-southeast-2 eu-west-1 eu-central-1})

    local profile env region cluster dir clusters
    for profile in $profiles; do
        env=${profile##*-}
        for region in $regions; do
            clusters=$(AWS_PROFILE=$profile aws eks list-clusters --region $region --query 'clusters[]' --output text 2>/dev/null) || continue
            [[ -z $clusters ]] && continue
            for cluster in ${(z)clusters}; do
                dir=$HOME/.kube/custom-contexts/${profile}-${region}
                mkdir -p $dir
                AWS_PROFILE=$profile aws eks update-kubeconfig --region $region --name $cluster \
                    --kubeconfig $dir/${cluster}.yml --alias ${cluster}-${env}-${region} >/dev/null \
                    && print "imported ${cluster}-${env}-${region}"
            done
        done
    done
}
