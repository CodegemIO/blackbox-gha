#!/bin/bash

if [[ -z ${BLACKBOX_PUBKEY}  ]]; then
  echo "BLACKBOX_PUBKEY environment variable missing"
  exit 1
fi

if [[ -z ${BLACKBOX_PRIVKEY}  ]]; then
  echo "BLACKBOX_PRIVKEY environment variable missing"
  exit 1
fi

if [ "${INPUT_COMMAND}" != "" ]; then
  __command=${INPUT_COMMAND}
else
  echo "command missing"
  exit 1
fi

__workdir="."
if [[ -n "${INPUT_WORKDIR}" ]]; then
  __workdir=${INPUT_WORKDIR%/}
fi

echo -e "${BLACKBOX_PUBKEY}" | gpg --import --no-tty --batch --yes
echo -e "${BLACKBOX_PRIVKEY}" | gpg --import --no-tty --batch --yes

cd ${GITHUB_WORKSPACE%/}/${__workdir}

case "${__command}" in
  postdeploy)
    blackbox_postdeploy
    ;;
  shred_all_files)
    blackbox_shred_all_files
    ;;
  *)
    echo "invalid blackbox command"
    exit 1
    ;;
esac
