#!/usr/bin/env bash
function usage {
    programName=$0
    echo "description: use this program to post messages to Rocket.chat channel"
    echo "usage: $programName [-b \"message body\"] [-u \"rocket.chat url\"]"
    echo "      -b    The message body"
    echo "      -u    The rocket.chat hook url to post to"
    exit 1
}
while getopts ":b:u:c:h" opt; do
  case ${opt} in
    u) rocketUrl="$OPTARG"
    ;;
    b) msgBody="$OPTARG"
    ;;
    c) idChannel="$OPTARG"
    ;;
    h) usage
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
if [[ ! "${rocketUrl}" || ! "${msgBody}" || ! "${idChannel}" ]]; then
    echo "all arguments are required"
    usage
fi
read -d '' payLoad << EOF
{"channel": "${idChannel}","text": "${msgBody}"}
EOF
echo $payLoad
statusCode=$(curl \
        --write-out %{http_code} \
        --silent \
        --output /dev/null \
        -X POST \
        -H 'Content-type: application/json' \
        --data "${payLoad}" ${rocketUrl})
echo ${statusCode}
