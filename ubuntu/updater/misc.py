#!/usr/bin/env python

import tempfile
from os import environ as env
from pathlib import Path
from subprocess import run

HOMEDIR = Path.home()
USER_LOCAL = HOMEDIR / ".local"
USER_LOCAL_BIN = USER_LOCAL / "bin"


def main() -> int:
    update_direnv()
    update_k3d()
    update_kubectl()
    update_lf()
    update_sccache()

    return 0


def update_direnv() -> None:
    print("Installing direnv...")

    env["bin_path"] = str(USER_LOCAL_BIN)
    run("curl -sfL https://direnv.net/install.sh | bash", shell=True)

    print("Done.\n")


def update_k3d() -> None:
    print("Installing k3d...")

    env["K3D_INSTALL_DIR"] = str(USER_LOCAL_BIN)
    env["USE_SUDO"] = "false"
    run(
        """
        curl -s \\
            https://raw.githubusercontent.com/rancher/k3d/main/install.sh \\
            | bash
        """,
        shell=True,
    )

    print("Done.\n")


def update_kubectl() -> None:
    print("Installing kubectl...")

    version = (
        run(
            ["curl", "-Ls", "https://dl.k8s.io/release/stable.txt"],
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    )
    kubectl_path = USER_LOCAL_BIN / "kubectl"
    run(
        [
            "curl",
            "-Lo",
            kubectl_path,
            f"https://dl.k8s.io/release/{version}/bin/linux/amd64/kubectl",
        ]
    )
    kubectl_path.chmod(0o775)

    print("Done.\n")


def update_lf() -> None:
    print("Installing lf...")

    base_url = "https://github.com/gokcehan/lf/releases/latest/download"
    url = f"{base_url}/lf-linux-amd64.tar.gz"
    run(f"curl -L {url} | tar xzC ~/.local/bin", shell=True)

    print("Done.\n")


def update_sccache() -> None:
    print("Installing sccache...")

    platform = "x86_64-unknown-linux-musl"
    repo_url = "https://github.com/mozilla/sccache"
    version = "v" + (
        run(
            " | ".join(
                [
                    f"git ls-remote --tags --refs '{repo_url}'",
                    "grep -o 'refs/tags/.*'",
                    "cut -d/ -f3-",
                    "sed 's/^v//'",
                    "tail -n1",
                ]
            ),
            shell=True,
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    )
    url = (
        f"{repo_url}/releases/download/"
        f"{version}/sccache-{version}-{platform}.tar.gz"
    )

    sccache_path = USER_LOCAL_BIN / "sccache"
    sccache_tmp_dir = Path(tempfile.mkdtemp())
    sccache_tmp_file = sccache_tmp_dir / "sccache.tar.gz"
    run(["curl", "-fsSL", "-o", sccache_tmp_file, "-C", "-", url])
    run(
        [
            "tar",
            "-xzf",
            sccache_tmp_file,
            "-C",
            sccache_tmp_dir,
            "--strip-components=1",
        ]
    )
    run(["rm", sccache_tmp_file])
    run(["mv", "-f", sccache_tmp_dir / "sccache", sccache_path])
    sccache_path.chmod(0o775)

    print("Done.\n")


if __name__ == "__main__":
    raise SystemExit(main())
