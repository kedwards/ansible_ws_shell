#!/usr/bin/zsh
#
# Ansible Service-Report
#
verbose=0
defaults="${ENBRIDGE_MRM_SR_DEFAULTS:-0}"
project="$HOME/workspace/ansible-openlink"
play_dir="plays"
config="services.cfg"
playbook="services.yml"
service_report=${project}/${play_dir}/service-report.yml

short=cpvh
long=config,playbook,verbose,help

function usage()
{
    echo ""
    echo "Ansible Service Report"
    echo "mrm.systems@enbridge.com"
    echo "© Enbridge Inc."
    echo ""
    echo "Usage: ./service-report.sh"
    echo "\t-h | --help\tprint this help menu"
    echo "\t-v | --verbose\tset verbose output"
    echo "\t-c | --config\tconfig file  - path/to/services.cfg"
    echo "\t-p | --playbook\tplaybook file  - path/to/services.yml"
    echo ""
}

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "getopt: system failure."
    exit 1
fi

# -temporarily store output to be able to check for errors
# -activate advanced mode getopt quoting e.g. via “--options”
# -pass arguments only via   -- "$@"   to separate them correctly
parsed=$(getopt --options ${short} --longoptions ${long} --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# use eval with "$PARSED" to properly handle the quoting
eval set -- "${parsed}"

# now enjoy the options in order and nicely split until we see --
while true
do
    case "$1" in
        -h|--help)
            usage
            exit 4
            ;;
        -c|--config)
            config=$2
            shift
            ;;
        -p|--playbook)
            playbook=$2
            shift
            ;;
        -v|--verbose)
            verbose=1
            shift
            ;;
        --)
            shift
            break
            ;;
       
    esac
done

# handle non-option arguments
if [ $# -ne 1 ] && [ ${defaults} -ne 1 ]
then
    usage
    exit 4
fi

if [ ${verbose} -eq 1 ]
then
    cd ${project}/
    ansible-playbook ${project}/${play_dir}/${playbook} -e @${project}/${play_dir}/${config}
    sleep 5
    ansible-playbook ${service_report}
else
    cd $project
    ansible-playbook ${project}/${play_dir}/${playbook} -e @${project}/${play_dir}/${config} &> /dev/null
    sleep 5
    ansible-playbook ${service_report} &> /dev/null
fi    