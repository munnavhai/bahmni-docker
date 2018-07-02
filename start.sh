#!/bin/bash -e

source ./config.sh

#function restart_openmrs_delayed() {
#  sleep 90
#  service openmrs restart
#}

# Make a file to source from cron scripts to have the bahmni specific env vars available
printenv | egrep "^BAHMNI" | sed 's/^\(.*\)$/export \1/g' | tee /cron_env.sh

ansible-playbook -i ${INVENTORY} /ansible/bahmni_start.yml

case $1 in
"active")
  case $2 in
  "true" | "True" | "yes" | "Yes" | "false" | "False" | "no" | "No")
    ;;
  *)
    echo "Accepted values for second parameter: true, True, yes, Yes, false, False, no, No. "
    exit 1
  esac

  ${BAHMNI} start
  #restart_openmrs_delayed &

  tail -F /var/log/openmrs/openmrs.log /var/log/bahmni-lab/bahmni-lab.log /var/log/bahmni-reports/bahmni-reports.log
  ;;
"passive")
  tail -F /var/log/mysqld.log
  ;;
*)
  echo 'Use "active" or "passive" as first argument.'
  exit 1

esac

