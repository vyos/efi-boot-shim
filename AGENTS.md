# AGENTS.md

## Project purpose

VyOS fork of [rhboot/shim](https://github.com/rhboot/shim) — a first-stage UEFI bootloader used to satisfy UEFI Secure Boot on VyOS images. shim chains to the second-stage bootloader (GRUB) after validating its signature against a built-in vendor certificate. The fork carries the VyOS vendor certificate and any build-system tweaks needed for the VyOS ISO.

## Tech stack

- C with EFI/GNU-EFI conventions; built against the vendored `gnu-efi` submodule (pinned branch `shim-16.0`).
- GNU `make` build (`Makefile` at root). Current source version `16.0`.
- `.clang-format` present.

## Build / test / run

```
git submodule update --init --recursive    # gnu-efi must be present
make VENDOR_CERT_FILE=pub.cer               # DER-encoded vendor certificate
# Optional packaging release suffix (sets DASHRELEASE in install paths):
make RELEASE=1
```

See `BUILDING` for full options. Test plan in `testplan.txt`. To produce a Debian package, use the upstream `debian/` rules (consumers wrap this in `vyos-build-packages`).

## Repository layout

- `Makefile` — top-level build (variables: `VENDOR_CERT_FILE`, `RELEASE`,...).
- C sources for the shim itself plus fallback (`fallback.c`) and MOK manager.
- `gnu-efi/` — git submodule (`https://github.com/rhboot/gnu-efi.git`, branch `shim-16.0`).
- `BUILDING`, `README.md`, `README.fallback`, `README.tpm`, `testplan.txt`.
- `.github/`, `.clang-format`.

## Cross-repo context

Native UEFI artifact. Built once and embedded into VyOS ISOs assembled by `vyos/vyos-build`. Companion repo `vyos/shim-review` carries the public shim-review submission paperwork required by Microsoft to sign each VyOS-built shim. Both belong to the build-infrastructure / packaging category. The standard VyOS package mirror twin pattern does **not** apply here (no an internal repository).

## Conventions

- Commit / PR title format: `component: T12345: description` (Phorge task ID at https://vyos.dev mandatory). Enforced where consumed via `vyos/.github` reusables.
- Upstream-tracking fork — keep the diff against `rhboot/shim` minimal; bump `gnu-efi` submodule branch in lockstep with shim version.
- Branch model: VyOS train branches (`rolling`, `sagitta`, `circinus`) overlaid on upstream tags.

## Notes for future contributors

- Fork parent: `rhboot/shim`. The vendored `gnu-efi` submodule is also a Red Hat fork (`rhboot/gnu-efi`).
- A new VyOS shim must go through Microsoft shim review (see `vyos/shim-review`) before it can be signed for Secure Boot. Rebuilds without re-review will not be Secure-Boot-trusted.
- Security contact in upstream is `secalert@redhat.com`; for VyOS-specific issues file at https://vyos.dev.
