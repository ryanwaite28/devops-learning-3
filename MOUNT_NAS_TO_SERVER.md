# Permanently Mounting a NAS Share to Ubuntu Server

To permanently mount a NAS share to an Ubuntu Server (so it reconnects automatically on boot), **NFS is the recommended protocol** for Linux and Kubernetes environments due to lower overhead and native Linux file permissions. 

If your NAS only exposes SMB/CIFS shares, see the alternative section at the bottom.

---

## 1. Enable NFS on Your NAS
Before configuring Ubuntu, ensure NFS is enabled on your NAS (e.g., Synology, TrueNAS, UGREEN UGOS):
1. Enable the **NFS service** (NFSv3 or NFSv4) in your NAS control panel.
2. Edit your shared folder's **NFS permissions** to allow access from your Ubuntu Server's IP address (or subnet, e.g., `192.168.1.0/24`).
3. Note the exact export path shown by the NAS (e.g., `/volume1/k8s-data` or `/mnt/pool/share`).

---

## 2. Install the NFS Client on Ubuntu
SSH into your Ubuntu Server and install the NFS utility package:

```bash
sudo apt update
sudo apt install -y nfs-common
```

---

## 3. Create a Local Mount Directory
Create the folder on Ubuntu where the NAS share will appear:

```bash
sudo mkdir -p /mnt/nas
```

---

## 4. Test the Mount Manually
Verify that your Ubuntu server can reach the NAS and mount the folder before making it permanent:

```bash
sudo mount -t nfs <NAS_IP>:/volume1/k8s-data /mnt/nas
```
*(Replace `<NAS_IP>` and `/volume1/k8s-data` with your actual NAS IP and export path.)*

Check that it mounted properly:
```bash
df -h /mnt/nas
```

---

## 5. Make the Mount Persistent Across Reboots
To prevent the server from hanging at boot if the NAS is temporarily offline, add the mount to `/etc/fstab` with `nofail` and `_netdev` options:

1. Open `/etc/fstab`:
   ```bash
   sudo nano /etc/fstab
   ```
2. Add this line at the bottom:
   ```text
   <NAS_IP>:/volume1/k8s-data  /mnt/nas  nfs  defaults,_netdev,nofail,x-systemd.automount  0  0
   ```
   * **`_netdev`**: Tells Ubuntu to wait until the network is online before mounting.
   * **`nofail`**: Prevents boot failures if the NAS is powered off or rebooting.
   * **`x-systemd.automount`**: Automatically mounts/remounts the share on demand when accessed.

3. Reload systemd and test the `fstab` entry:
   ```bash
   sudo systemctl daemon-reload
   sudo umount /mnt/nas
   sudo mount -a
   ```

---

## Alternative: Using SMB/CIFS Instead of NFS
If you must use SMB instead of NFS:

1. Install CIFS utilities:
   ```bash
   sudo apt install -y cifs-utils
   ```
2. Store credentials securely in `/etc/smb-credentials` (`username=...` and `password=...`) and lock permissions:
   ```bash
   sudo chmod 600 /etc/smb-credentials
   ```
3. Add this line to `/etc/fstab`:
   ```text
   //<NAS_IP>/share  /mnt/nas  cifs  credentials=/etc/smb-credentials,_netdev,nofail,uid=1000,gid=1000  0  0
   ```

> **Tip for Kubernetes:** If you plan to use this NAS for Kubernetes Persistent Volumes rather than host-level backups, consider installing the **NFS CSI Driver** (`csi-driver-nfs`) inside your cluster so Kubernetes dynamically creates and mounts subfolders for pods automatically without needing host mounts on every worker node.
