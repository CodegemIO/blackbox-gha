## Blackbox GitHub Actions

This GitHub actions allows for quick and easy access to StackExchange/blackbox v2.0.0. It does not try to clone the latest binaries from git in order to save some build time, rather the necessary executables are included within this repository under `/bin`.

## Usage

This action can be used in any workflow for a repository that has encrypted secrets using blackbox. The following can be configured (note that currently only `postdeploy` and `shred_all_files` are needed/supported).

| Parameter          | Type                 | Description                                            | Required? | Default |
| ------------------ | -------------------- | ------------------------------------------------------ | --------- | ------- |
| `command`          | GHA `with` parameter | The blackbox command to run.                           | Yes       | None    |
| `workdir`          | GHA `with` parameter | The directory to run blackbox commands in.             | No        | `./`    |
| `BLACKBOX_PUBKEY`  | Environment variable | The public key of a blackbox admin.                    | Yes       | None    |
| `BLACKBOX_PRIVKEY` | Environment variable | The private key of a blackbox admin encoded in base64. | Yes       | None    |

It is highly likely that you'll want to pass the public and private key environment variables through GitHub secrets. The private key is assumed to be base64 encoded. This information can be retrieved from GPG by running the following command.

```bash
gpg --export-secret-keys <key id> | base64
```

It is recommended that the secret key used here is specifically made for CI.

## Sample Workflow

This example decrypts all secrets, uses them, and then shreds them.

```yml
name: Blackbox Sample
on: push
jobs:
  tests-requiring-blackbox:
    runs-on: ubuntu-latest
    steps:
      - name: Decrypt secrets
        uses: CodegemIO/blackbox-gha@v1.0
        with:
          command: "postdeploy"
        env:
          BLACKBOX_PUBKEY: ${{ secrets.BLACKBOX_PUBKEY }}
          BLACKBOX_PRIVKEY: ${{ secrets.BLACKBOX_PRIVKEY }}
      - name: Run tests that need secrets
        run: ./test.sh
      - name: Shred decrypted secrets
        uses: CodegemIO/blackbox-gha@v1.0
        with:
          command: "shred_all_files"
        env:
          BLACKBOX_PUBKEY: ${{ secrets.BLACKBOX_PUBKEY }}
          BLACKBOX_PRIVKEY: ${{ secrets.BLACKBOX_PRIVKEY }}
```
