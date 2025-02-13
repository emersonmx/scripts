#!/usr/bin/env python

import tempfile
from os import environ as env
from pathlib import Path
from subprocess import run

HOMEDIR = Path.home()
HOME_LOCAL = HOMEDIR / ".local"
HOME_LOCAL_BIN = HOME_LOCAL / "bin"


def main() -> int:
    update_direnv()
    update_k3d()
    update_k6()
    update_kubectl()
    update_sccache()

    return 0


def update_direnv() -> None:
    print("Installing direnv...")

    env["bin_path"] = str(HOME_LOCAL_BIN)
    run("curl -sfL https://direnv.net/install.sh | bash", shell=True)

    print("Done.\n")


def update_k3d() -> None:
    print("Installing k3d...")

    env["K3D_INSTALL_DIR"] = str(HOME_LOCAL_BIN)
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


def update_k6() -> None:
    print("Installing k6...")

    platform = "linux-amd64"
    repo_url = "https://github.com/grafana/k6"
    cmd = " | ".join(
        [
            f"git ls-remote --tags --refs '{repo_url}'",
            "grep -o 'refs/tags/.*'",
            "sed 's#^refs/tags/v##g'",
        ]
    )
    cmd = f"npx semver `{cmd}` | tail -n1"
    version = "v" + (
        run(
            cmd,
            shell=True,
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    )

    pkg_file = f"k6-{version}-{platform}.tar.gz"
    url = f"{repo_url}/releases/download/{version}/{pkg_file}"

    bin_path = HOME_LOCAL_BIN / "k6"
    bin_tmp_dir = Path(tempfile.mkdtemp())
    bin_tmp_file = bin_tmp_dir / pkg_file
    run(["curl", "-fsSL", "-o", bin_tmp_file, "-C", "-", url])
    run(
        [
            "tar",
            "-xzf",
            bin_tmp_file,
            "-C",
            bin_tmp_dir,
            "--strip-components=1",
        ]
    )
    run(["mv", "-f", bin_tmp_dir / "k6", bin_path])
    run(["rm", "-rf", bin_tmp_dir])
    bin_path.chmod(0o755)

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
    kubectl_path = HOME_LOCAL_BIN / "kubectl"
    run(
        [
            "curl",
            "-Lo",
            kubectl_path,
            f"https://dl.k8s.io/release/{version}/bin/linux/amd64/kubectl",
        ]
    )
    kubectl_path.chmod(0o755)

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
    pkg_file = f"sccache-{version}-{platform}.tar.gz"
    url = f"{repo_url}/releases/download/{version}/{pkg_file}"

    bin_path = HOME_LOCAL_BIN / "sccache"
    bin_tmp_dir = Path(tempfile.mkdtemp())
    bin_tmp_file = bin_tmp_dir / pkg_file
    run(["curl", "-fsSL", "-o", bin_tmp_file, "-C", "-", url])
    run(
        [
            "tar",
            "-xzf",
            bin_tmp_file,
            "-C",
            bin_tmp_dir,
            "--strip-components=1",
        ]
    )
    run(["mv", "-f", bin_tmp_dir / "sccache", bin_path])
    run(["rm", "-rf", bin_tmp_dir])
    bin_path.chmod(0o755)

    print("Done.\n")


if __name__ == "__main__":
    raise SystemExit(main())
