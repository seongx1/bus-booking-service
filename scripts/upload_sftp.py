#!/usr/bin/env python3
"""Upload local dir to Cloudways public_html via SFTP. Usage: upload_sftp.py <host> <user> <password> <local_dir> [remote_path]"""
import os
import sys

try:
    import paramiko
except ImportError:
    print("paramiko 필요: .venv_deploy/bin/pip install paramiko 또는 pip install paramiko")
    sys.exit(1)

def main():
    if len(sys.argv) < 5:
        print(__doc__)
        sys.exit(1)
    host = sys.argv[1]
    user = sys.argv[2]
    password = sys.argv[3]
    local_dir = sys.argv[4].rstrip("/")
    remote_path = (sys.argv[5] if len(sys.argv) > 5 else "public_html").rstrip("/")

    if not os.path.isdir(local_dir):
        print(f"오류: 디렉토리가 없습니다: {local_dir}")
        sys.exit(1)

    transport = paramiko.Transport((host, 22))
    transport.connect(username=user, password=password)
    sftp = paramiko.SFTPClient.from_transport(transport)

    try:
        try:
            sftp.stat(remote_path)
        except FileNotFoundError:
            sftp.mkdir(remote_path)

        for name in os.listdir(local_dir):
            local_path = os.path.join(local_dir, name)
            remote_file = f"{remote_path}/{name}"
            if os.path.isfile(local_path):
                sftp.put(local_path, remote_file)
                print(f"  업로드: {name}")
            elif os.path.isdir(local_path):
                try:
                    sftp.mkdir(remote_file)
                except OSError:
                    pass
                for subname in os.listdir(local_path):
                    sub_local = os.path.join(local_path, subname)
                    sub_remote = f"{remote_file}/{subname}"
                    if os.path.isfile(sub_local):
                        sftp.put(sub_local, sub_remote)
                        print(f"  업로드: {name}/{subname}")
        print("업로드 완료.")
    finally:
        sftp.close()
        transport.close()

if __name__ == "__main__":
    main()
