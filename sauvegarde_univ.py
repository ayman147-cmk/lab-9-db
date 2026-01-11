import os
import subprocess
from datetime import datetime

class BackupSystem:
    def __init__(self, target_db="universite"):
        self.db = target_db
        self.credentials = {"u": "root", "p": ""}
        self.host = "127.0.0.1"

    def execute_backup(self):
        stamp = datetime.now().strftime("%Y%m%d_%H%M")
        output_name = f"Dump_{self.db}_{stamp}.sql"
        
        args = [
            "mysqldump",
            f"-u{self.credentials['u']}",
            f"-p{self.credentials['p']}",
            "-h", self.host,
            self.db
        ]

        try:
            with open(output_name, "w") as stream:
                proc = subprocess.Popen(
                    args, 
                    stdout=stream, 
                    stderr=subprocess.PIPE,
                    text=True
                )
                _, err_msg = proc.communicate()

            if proc.returncode == 0 and os.path.getsize(output_name) > 0:
                print(f"Success: {os.path.abspath(output_name)}")
            else:
                print(f"Failure: {err_msg}")
                if os.path.exists(output_name):
                    os.remove(output_name)

        except Exception as failure:
            print(f"System Error: {failure}")

if __name__ == "__main__":
    service = BackupSystem()
    service.execute_backup()