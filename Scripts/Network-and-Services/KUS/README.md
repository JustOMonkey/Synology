# <img src="https://upload.wikimedia.org/wikipedia/commons/4/48/Synology_Logo.svg" alt="Synology Logo" width="200"/>

---

## 📖 Script: `kus.sh` (Kill User Script)

A powerful script to **kill user and ghost sessions** on a Synology NAS.  
Designed to maximize system performance and minimize disk wear without requiring frequent reboots.

This script is capable of managing users linked to an Active Directory (AD) domain. It identifies active sessions, providing administrators with detailed information on users connected via SMB.

---

### 📜 Table of Contents

1. [About](#about)
2. [How to Use](#how-to-use)
3. [Output](#output)

---

### 📖 About

`KUS` (Kill User Script) is a utility script that:
- Terminates all user and ghost sessions in Samba (SMB).
- Prevents unnecessary strain on Synology disks.
- Optimizes Synology NAS performance by avoiding stale connections.

---

### 🛠️ How to Use

1. **Open Task Scheduler:**
   - Navigate to **Control Panel** > **Task Scheduler**.

2. **Create a New Task:**
   - Click **Create** > **Scheduled Task** > **User-defined script**.

3. **Configure General Settings:**
   - **Task Name:** `KUS`
   - **User:** `root`
     > ⚠️ **Important:** The `root` user is required to ensure the script executes properly.

4. **Set the Schedule:**
   - Define when you want the task to run (e.g., daily or weekly).

5. **Configure Task Settings:**
   - **Send Details by Email:**
     > ⚠️ **Important:** Ensure that a mail server is configured in the Notification category of DSM.  
     Otherwise, the task will not send email notifications.

   - **Run Command:**  
     Use one of the following options based on your setup:

     #### 📁 **Filepath**
     Execute the script stored in a specific location:
     ```bash
     bash /volumeX/script/folder/kus.sh
     ```
     > ⚠️ **Important:** Update `/volumeX/script/folder/` with the actual script location on your Synology NAS.

     #### 📖 **Directly**
     Alternatively, you can input the script directly into the task:
     ```bash
     #!/bin/bash
     
     usertotal=0
     
     # Get the output of smbstatus -p
     output=$(smbstatus -p)
     
     # Extract all PIDs and usernames and store them in an array as key-value pairs
     declare -A pid_username_map
     while read -r line; do
        if [[ "$line" =~ ^[0-9]+ ]]; then
           pid=$(echo "$line" | awk '{print $1}')
           username=$(echo "$line" | awk '{print $2}')
           pid_username_map["$pid"]="$username"
        fi
     done <<< "$output"
     
     # Show people who have been killed
     for pid in "${!pid_username_map[@]}"; do
        username="${pid_username_map[$pid]}"
        echo "PID processing: $pid, Username: $username"
        kill -9 $pid
        ((usertotal++))
     done
     
     # Show total sessions killed
     echo "Total Kill Session(s) (SMB): $usertotal User(s)."
     ```

---

### 📝 Output

When the script runs successfully, it provides the following output:
- Lists all terminated sessions with their process IDs (PIDs) and usernames.
- Displays a summary of the total number of sessions killed, e.g.:
```txt
PID processing: 16072, Username: domain\jhon.doe
Total Kill Session(s) (SMB) : 1 User(s).
```
